from dolfin import *
import numpy as np
from os import path

from problems import *
from modules import *


def set_problem_parameters(default_variables, **namespace):
    # Overwrite or add new variables to 'default_variables'
    default_variables.update(dict(
        # Temporal variables
        T=5,                         # End time [s]
        dt=0.05,                      # Time step [s]
        theta=0.55,                    # Temporal scheme

        # Physical constants ('FSI 3')
        Um=-10,                       # Max. velocity inlet, CDF3: 2.0 [cm/s] or Max. pressure [dynes/cm2]
        rho_f=1.0,                  # Fluid density [g/cm3]
        mu_f=0.04,                     # Fluid dynamic viscosity [cm2/s]
        rho_s=1.1,                  # Solid density[g/cm3]
        nu_s=0.49,                     # Solid Poisson ratio [-]
        mu_s=0.75e6/2/(1+0.49),                   # Shear modulus, CSM3: 0.5E6 [dynes/cm2]
        lambda_s=(0.75e6*0.49)/(1+0.49)/(1-2*0.49),                 # Solid Young's modulus [dynes/cm2]
        s0=1e-7,
        dalpha=1e-2, #tend toward one for porous materials where grain compressibilities are insignificant, such as unconsolidated sediments, but tend towards much lower values for consolidated rocks with more rigid skeletons where pore compression is inhibited.
        kappa=2e-5,

        # Problem specific
        folder="TF_fsi_results2",      # Name of the results folder
        extrapolation="laplace",#biharmonic",#laplace",   # No displacement to extrapolate
        extrapolation_sub_type="constant",#bc2",#constant",  # Biharmonic type
        bc_ids=[8,12,3,6],          # BC Ids 

        # Solver settings
        recompute=1,

        # Geometric variables
        L=0,
        R=2.0,
        H=1,                       # Total height
        B=0,
        f_L=0.5,                    
        f_H=0.6))                     
      
    

    #from IPython import embed; embed()
    default_variables["compiler_parameters"].update({"quadrature_degree": 5})
    return default_variables


def get_mesh_domain_and_boundaries(L,R,H,B,f_L,f_H, **namespace):
    # Read mesh
    mesh = Mesh()
    hdf = HDF5File(mesh.mpi_comm(),"./mesh/pancreas.h5","r")
    hdf.read(mesh,"/mesh", False)

    boundaries=MeshFunction("size_t",mesh,2)
    hdf.read(boundaries,"/fd")
    domains=MeshFunction("size_t",mesh,3)
    hdf.read(domains,"/cd")
 
    return mesh, domains, boundaries


def initiate(dvp_, mesh, folder, f_H, f_L, **namespace):
    # Files for storing results
    u_file = XDMFFile(MPI.comm_world, path.join(folder, "velocity.xdmf"))
    d_file = XDMFFile(MPI.comm_world, path.join(folder, "d.xdmf"))
    p_file = XDMFFile(MPI.comm_world, path.join(folder, "pressure.xdmf"))
    q_file = XDMFFile(MPI.comm_world, path.join(folder, "darcyvelocity.xdmf"))
    pp_file = XDMFFile(MPI.comm_world, path.join(folder, "darcypressure.xdmf"))
    
    timeseries_u = TimeSeries(MPI.comm_world, path.join(folder, "velocity_series"))
    timeseries_q = TimeSeries(MPI.comm_world, path.join(folder, "darcyvelocity_series"))

    for tmp_t in [u_file, d_file, p_file, q_file, pp_file]:
        tmp_t.parameters["flush_output"] = True
        tmp_t.parameters["rewrite_function_mesh"] = False

    # Store initial condition
    d = dvp_["n"].sub(0, deepcopy=True)
    v = dvp_["n"].sub(1, deepcopy=True)
    p = dvp_["n"].sub(2, deepcopy=True)
    q = dvp_["n"].sub(3, deepcopy=True)
    pp = dvp_["n"].sub(4, deepcopy=True)
    d_file.write(d)
    u_file.write(v)
    p_file.write(p)
    q_file.write(q)
    pp_file.write(pp)
    
    timeseries_u.store(v.vector(), 0)
    timeseries_q.store(q.vector(), 0)

    # Coord to sample
    for coord in mesh.coordinates():
        if coord[0] == 0.5*(f_H + f_L) and coord[1] ==0.5:
            break

    # Lists to hold results
    dis_x = []
    dis_y = []
    Drag_list = []
    Lift_list = []
    Time_list = []

    return dict(u_file=u_file, d_file=d_file, p_file=p_file, q_file=q_file, pp_file=pp_file, timeseries_u=timeseries_u, timeseries_q=timeseries_q, dis_x=dis_x,
                dis_y=dis_y, Drag_list=Drag_list, Lift_list=Lift_list,
                Time_list=Time_list, coord=coord)


class Inlet(UserExpression):
    def __init__(self, Um, H, B, **kwargs):
        self.Um = 1.5 * Um
        self.factor = 0
        super().__init__(**kwargs)

    def update(self, t):
        if t < 2:
            self.factor = 0.5 * (1 - np.cos(t * np.pi / 2)) * self.Um
        else:
            self.factor = self.Um
        print(str(t)+"self.factor===="+str(self.factor))

    def eval(self, value, x):
        value[0] = self.factor
 
    #def value_shape(self):
     #   return (1,1)


def create_bcs(DVP, v_deg, Um, H, B, boundaries, extrapolation_sub_type, **namespace):
    inlet = Inlet(Um, H, B, degree=v_deg)

    # Fluid velocity conditions
    u_inlet = DirichletBC(DVP.sub(1), ((0.0,-3.5,0.0)), boundaries, 3)
    
    u_wall = DirichletBC(DVP.sub(1), ((0.0, 0.0, 0.0)), boundaries, 8)

    # Pressure Conditions
    p_out = DirichletBC(DVP.sub(2), 0.1, boundaries, 12)
    
    #p_ultrafiltrateout = DirichletBC(DVP.sub(2), 0.1, boundaries, 4)

    # Poroelastic
    q_wall = DirichletBC(DVP.sub(3), ((0.0, 0.0, 0.0)), boundaries, 6)
    pp_wall = DirichletBC(DVP.sub(4),0.1, boundaries, 6) #External boundary of poroelastic structure, pressure=0

    # Assemble boundary conditions
    bcs = [u_wall, u_inlet, p_out, q_wall, pp_wall] # p_ultrafiltrateout


    # Boundary conditions on the displacement / extrapolation
    if extrapolation_sub_type != "bc2":
        d_wall = DirichletBC(DVP.sub(0), ((0.0, 0.0, 0.0)), boundaries, 8)
        d_inlet = DirichletBC(DVP.sub(0), ((0.0, 0.0, 0.0)), boundaries, 12)
        d_outlet = DirichletBC(DVP.sub(0), ((0.0, 0.0, 0.0)), boundaries, 3)
        d_ultrafiltrateoutlet = DirichletBC(DVP.sub(0), ((0.0, 0.0, 0.0)), boundaries, 4)
        d_barwall = DirichletBC(DVP.sub(0), ((0.0, 0.0, 0.0)), boundaries, 6)
        for i in [d_wall, d_inlet, d_outlet, d_ultrafiltrateoutlet, d_barwall]:
            bcs.append(i)

    else:
        w_wall = DirichletBC(DVP.sub(0).sub(1), (0.0), boundaries, 8)
        w_inlet = DirichletBC(DVP.sub(0).sub(0), (0.0), boundaries, 12)
        w_outlet = DirichletBC(DVP.sub(0).sub(0), (0.0), boundaries, 3)
        #w_barwall = DirichletBC(DVP.sub(0), ((0.0, 0.0)), boundaries, 6)

        d_wall = DirichletBC(DVP.sub(0).sub(1), (0.0), boundaries, 8)
        d_inlet = DirichletBC(DVP.sub(0).sub(0), (0.0), boundaries, 12)
        d_outlet = DirichletBC(DVP.sub(0).sub(0), (0.0), boundaries, 3)
        d_barwall = DirichletBC(DVP.sub(0), ((0.0, 0.0)), boundaries, 6)
        for i in [w_wall, w_inlet, w_outlet, #w_barwall,
                d_wall, d_inlet, d_outlet, d_barwall]:
            bcs.append(i)

    return dict(bcs=bcs, inlet=inlet)


def pre_solve(t, inlet, **namespace):
    """Update boundary conditions"""
    inlet.update(t)


def after_solve(t, DVP, dvp_, coord, dis_x, dis_y, Drag_list, Lift_list, mu_f, n,
                counter, u_file, p_file, d_file, q_file, pp_file, timeseries_u, timeseries_q, verbose, save_step, Time_list, ds, dS,
                **namespace):
    d = dvp_["n"].sub(0, deepcopy=True)
    v = dvp_["n"].sub(1, deepcopy=True)
    p = dvp_["n"].sub(2, deepcopy=True)
    q = dvp_["n"].sub(3, deepcopy=True)
    pp = dvp_["n"].sub(4, deepcopy=True)

    if counter % save_step == 0:
        d_file.write(d, t)
        p_file.write(p, t)
        u_file.write(v, t)
        q_file.write(q, t)
        pp_file.write(pp, t)

        timeseries_u.store(v.vector(),t)
        timeseries_q.store(q.vector(),t)

def post_process(folder, dis_x, dis_y, Drag_list, Lift_list, Time_list,
                 **namespace):
    if MPI.rank(MPI.comm_world) == 0:
        np.savetxt(path.join(folder, 'Time.txt'), Time_list, delimiter=',')
     
       

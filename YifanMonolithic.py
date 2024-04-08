from dolfin import *
from utils import *
import os
import sys
#import matplotlib.pyplot as plt
#sys.path.append('../')
# Get user input
args = parse()
print(args)

# Import the problem
parameters["ghost_mode"] = "shared_facet"
if os.path.isfile(os.path.abspath(args.problem+'.py')):
    exec("from {} import *".format(args.problem))
else:
    try:
        exec("from problems.{} import *".format(args.problem))
    except:
        raise ImportError("""Can not find the problem file. """)
print(os.path.abspath(args.problem+'.py'))

# Get problem specific parameters
vars().update(set_problem_parameters(**vars()))

# Get mesh information
mesh, domains, boundaries = get_mesh_domain_and_boundaries(**vars())
#plot(mesh)
#plt.show()
# Control FEniCS output
set_log_level(20)

# Finite Elements
de = VectorElement('CG', mesh.ufl_cell(), d_deg) #structure displacement
ve = VectorElement('CG', mesh.ufl_cell(), v_deg) #fluid Velocity
pe = FiniteElement('CG', mesh.ufl_cell(), p_deg) #fluid Pres
qe = VectorElement('CG', mesh.ufl_cell(), v_deg) #Darcy Velocity
ppe = FiniteElement('CG', mesh.ufl_cell(), p_deg) #Darcy Pres

# Define coefficients
k = Constant(dt)
n = FacetNormal(mesh)

# Define function space
if extrapolation == "biharmonic":
    Elem = MixedElement([de, ve, pe, qe, ppe, de])
else:
    Elem = MixedElement([de, ve, pe, qe, ppe])

DVP = FunctionSpace(mesh, Elem)

# Create functions
dvp_ = {} # Total variables
d_ = {} #disp
v_ = {} #Fluid V
p_ = {} #Fluid P
q_ = {} #Darcy V
pp_ = {} #Darcy P
w_ = {} #Domain deformation


for time in ["n", "n-1", "n-2", "n-3"]:
    dvp = Function(DVP)
    dvp_[time] = dvp
    dvp_list = split(dvp)

    d_[time] = dvp_list[0]
    v_[time] = dvp_list[1]
    p_[time] = dvp_list[2]
    q_[time] = dvp_list[3]
    pp_[time] = dvp_list[4]
    if extrapolation == "biharmonic":
        w_[time] = dvp_list[5]

if extrapolation == "biharmonic":
    phi, psi, gamma, psi2, gamma2, beta = TestFunctions(DVP)
else:
    phi, psi, gamma, psi2, gamma2 = TestFunctions(DVP)

# Differentials
ds = Measure("ds", domain=mesh, subdomain_data=boundaries)
dx = Measure("dx", domain=mesh, subdomain_data=domains)

# Domains
dx_f = dx(dx_f_id, subdomain_data=domains)
dx_s = dx(dx_s_id, subdomain_data=domains)

dS = Measure("dS", domain=mesh, subdomain_data=boundaries, subdomain_id=5)

# Define solver
# Adding the Matrix() argument is a FEniCS 2018.1.0 hack
up_sol = LUSolver(Matrix(), linear_solver)

# Get variation formulations
exec("from modules.{} import fluid_setup".format(fluid))
vars().update(fluid_setup(**vars()))
exec("from modules.{} import solid_setup".format(solid))
vars().update(solid_setup(**vars()))
exec("from modules.{} import extrapolate_setup".format(extrapolation))
vars().update(extrapolate_setup(**vars()))


# Set up Newton solver
exec("from modules.{} import solver_setup, newtonsolver".format(solver))
vars().update(solver_setup(**vars()))

# Any pre-processing before the simulation
vars().update(initiate(**vars()))

# Create boundary conditions
vars().update(create_bcs(**vars()))

# Functions for residuals
dvp_res = Function(DVP)
chi = TrialFunction(DVP)

t = 0
counter = 0
timer = Timer("Total simulation time")
timer.start()
while t <= T + dt / 10:
    counter += 1
    t += dt
    print(default_variables["mu_s"])
    if MPI.rank(MPI.comm_world) == 0:
        txt = "Solving for timestep {:d}, time {:2.04f}".format(counter, t)
        if verbose:
            print(txt)
        else:
            print(txt, end="\r")

    # Pre solve hook
    pre_solve(**vars())

    # Solve
    newtonsolver(**vars())

    # Update vectors
    times = ["n-2", "n-1", "n"]
    for i, t_tmp in enumerate(times[:-1]):
        dvp_[t_tmp].vector().zero()
        dvp_[t_tmp].vector().axpy(1, dvp_[times[i+1]].vector())

    # After solve hook
    after_solve(**vars())

timer.stop()
if MPI.rank(MPI.comm_world) == 0:
    print("Total simulation time {0:f}".format(timer.elapsed()[0]))

# Post-processing of simulation
post_process(**vars())

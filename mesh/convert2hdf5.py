from dolfin import *
mesh = Mesh("pancreas.xml");
cd=MeshFunction('size_t',mesh,"pancreas_physical_region.xml");
fd=MeshFunction('size_t',mesh,"pancreas_facet_region.xml");
hdf = HDF5File(mesh.mpi_comm(), "pancreas.h5", "w")
hdf.write(mesh, "/mesh")
hdf.write(cd, "/cd")
hdf.write(fd, "/fd")

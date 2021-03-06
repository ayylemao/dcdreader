# dcdreader
Fortran program that reads out a CHARMM dcd trajectory file and saves the coordinates in the NumPy .npy binary format

Compilation:
gfortran npy.f90 read_dcd.f90 -o read_dcd.x

Usage:

./read_dcd.x \<path to dcd file\> \<output name .npy\> \<first n atoms to consider\>
  
Example:
./read_dcd.x traj_aaa.dcd pos.npy 34
  
The atom ordering is identical to the one in the .psf file used for simulation. In the example above, the first 34 atoms present in the .psf file are considered.
                                                          
The program works with trajectories containing crystal lattice data and those who had fixed atoms present in the simulation. It can also be used to read CHARMM velocity trajectory files.

Credit for the npy.f90 module goes to Matthias Redies (https://github.com/MRedies/NPY-for-Fortran).

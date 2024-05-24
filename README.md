# NTCL examples for the NUCLIE 2024 annual meeting Berkeley

NTCL is a Fortran based tensor contraction library targeting manybody-methods
for nuclear physics. Its primary aim is to simplify porting of research code 
from one DOE super-computer to an other. This is achieved by providing a 
hardware independent frontend while the backend varies depending on hardware.
Currently tensor-contractions using openblas, CUDA and ROCm is supported.

## Installing NTCL

Start by creating a NTCL-root directory
```
  > mkdir ntcl-root
  > cd ntcl-root
```
cloning the gitlab repository
```bash
  > git clone git@gitlab.com:ntcl/ntcl-build.git
```
You need to set the following environmental variables to build and use ntcl
```bash
export NTCL_ROOT=/path/to/ntcl-root
export PYTHONPATH=$NTCL_ROOT/ntcl-build
export PATH=$PATH:$PYTHONPATH/bin
```
There are a few optional variables that might have to be set as well,
```bash
export HDF5_DIR=/path/to/HDF5  
export OPENBLAS_ROOT=/path/to/OPENBLAS
# For running NTCL with CUDA 
export CUDADIR=/path/to/cuda
# For running NTCL with HIP
export HIP_PATH=/path/to/hip
export ROCM_PATH=/path/to/rocm
export HIP_AMDGPU_TARGET=gpuname # On Frontier this is gfx90a however we have a specific setup for Frontier
```

The build system for NTCL is written in python and requires `GitPython` to be installed
```bash
pip install GitPython
```
You also need `make` and `gcc` to be installed

Once all these variables are set it is possible to compile NTCL by running
```bash
ntcl-build.py -c -s default.openblas
```
for the openblas backend. If you instead wish to use CUDA
```bash
ntcl-build.py -c -s default.cuda
```
Once the build script is done, NTCL is compiled and ready to be used.

## Linking with NTCL

To use ntcl in your own projects you need to include the following statically linkable libraries
in to your linking command
```bash
  gfortran ... ${NTCL_ROOT}/ntcl-algorithms/lib/libntcl-algorithms.a ${NTCL_ROOT}/ntcl-tensor/lib/libntcl-tensor.a \
  ${NTCL_ROOT}/ntcl-data/lib/libntcl-data.a ${NTCL_ROOT}/ntcl-util/lib/libntcl-util.a 
```
The order matters, algorithms must come before tensor since it uses tensors, tensors need to come before data and so on.
If you have build NTCL with openBLAS you have to add linking flags for openBLAS, same goes for CUDA and HIP.
In your compilation flags you also need to add
```bash
  gfortran -c ... -I${NTCL_ROOT}/ntcl-algorithms/include -I${NTCL_ROOT}/ntcl-tensor/include -I${NTCL_ROOT}/ntcl-data/include -I${NTCL_ROOT}/ntcl-util/include 
```

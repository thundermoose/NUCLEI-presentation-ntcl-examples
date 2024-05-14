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
  > git clone ... # Need to have the correct repo here that is accessable by anybody
```
You need to set

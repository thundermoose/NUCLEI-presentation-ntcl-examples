FC=gfortran
CUDA_COMPILER=nvcc -c -ccbin /usr/local/bin/gcc -std=c++11 

ifdef CUDADIR
CUDA_COMPILER_FLAGS=-I${CUDADIR}/include $(shell pkg-config -cflags cuda)
CUDA_LINKER_FLAGS=$(shell pkg-config -libs cuda) -lstdc++
else
CUDA_COMPILER_FLAGS=
CUDA_LINKER_FLAGS=
endif

COMPILER_FLAGS=-I${NTCL_ROOT}/ntcl-algorithms/include -I${NTCL_ROOT}/ntcl-tensor/include -I${NTCL_ROOT}/ntcl-data/include $(CUDA_COMPILER_FLAGS) -ggdb
LINKER_FLAGS=${NTCL_ROOT}/ntcl-algorithms/lib/libntcl-algorithms.a ${NTCL_ROOT}/ntcl-tensor/lib/libntcl-tensor.a ${NTCL_ROOT}/ntcl-data/lib/libntcl-data.a ${NTCL_ROOT}/ntcl-util/lib/libntcl-util.a -L/home/tdl/.local/openblas/lib -lopenblas $(CUDA_LINKER_FLAGS)

SOURCES=$(shell find src -regex .*\.f90)
CUDA_SOURCES=$(shell find src -regex .*\.cu)
CUDA_OBJECTS=$(CUDA_SOURCES:src/%.cu=.obj/%.o)
BINARIES=$(SOURCES:src/%.f90=bin/%)

all: $(BINARIES)

clean:
	rm -rf bin
	rm -rf .obj

bin/%: src/%.f90 $(CUDA_OBJECTS)
	mkdir -p $(@D)
	$(FC) -o $@ $< $(CUDA_OBJECTS) $(COMPILER_FLAGS) $(LINKER_FLAGS)

.obj/%.o: src/%.cu
	mkdir -p $(@D)
	$(CUDA_COMPILER) -o $@ $< -g
	

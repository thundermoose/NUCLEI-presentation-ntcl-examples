FC=gfortran

ifdef CUDADIR
CUDA_COMPILER_FLAGS=-I${CUDADIR}/include $(shell pkg-config -cflags cuda)
CUDA_LINKER_FLAGS=$(shell pkg-config -libs cuda) -lstdc++
else
CUDA_COMPILER_FLAGS=
CUDA_LINKER_FLAGS=
endif

COMPILER_FLAGS=-I${NTCL_ROOT}/ntcl-algorithms/include $(CUDA_COMPILER_FLAGS)
LINKER_FLAGS=${NTCL_ROOT}/ntcl-algorithms/lib/libntcl-algorithms.a ${NTCL_ROOT}/ntcl-tensor/lib/libntcl-tensor.a ${NTCL_ROOT}/ntcl-data/lib/libntcl-data.a ${NTCL_ROOT}/ntcl-util/lib/libntcl-util.a -L/home/tdl/.local/openblas/lib -lopenblas $(CUDA_LINKER_FLAGS)

SOURCES=$(shell find src -regex .*\.f90)
BINARIES=$(SOURCES:src/%.f90=bin/%)

all: $(BINARIES)

clean:
	rm -rf bin

bin/%: src/%.f90
	mkdir -p $(@D)
	$(FC) -o $@ $< $(COMPILER_FLAGS) $(LINKER_FLAGS)

	

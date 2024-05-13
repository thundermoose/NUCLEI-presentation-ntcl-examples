FC=gfortran

COMPILER_FLAGS=-I${NTCL_ROOT}/ntcl-algorithms/include -I${NTCL_ROOT}/ntcl-tensor/include
LINKER_FLAGS=${NTCL_ROOT}/ntcl-algorithms/lib/libntcl-algorithms.a ${NTCL_ROOT}/ntcl-tensor/lib/libntcl-tensor.a ${NTCL_ROOT}/ntcl-data/lib/libntcl-data.a ${NTCL_ROOT}/ntcl-util/lib/libntcl-util.a -L/home/tdl/.local/openblas/lib -lopenblas

SOURCES=$(shell find src -regex .*\.f90)
BINARIES=$(SOURCES:src/%.f90=bin/%)

all: $(BINARIES)

clean:
	rm -rf bin

bin/%: src/%.f90
	mkdir -p $(@D)
	$(FC) -o $@ $< $(COMPILER_FLAGS) $(LINKER_FLAGS)

	

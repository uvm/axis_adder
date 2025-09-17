CC              = gcc
CFLAGS		= -Wall -O3 -fPIC
SEED            = 1
DUMPFST         = 1
VEROPTS         = -O3 --euvm --no-timing --x-assign fast --x-initial fast --threads 1

ifeq ($(DUMPFST),1)
	VEROPTS += --trace-fst
endif

DFLAGS = -relocation-model=pic -w -O3 

ifeq ($(DUMPFST),1)
    DFLAGS += --d-version=DUMPFST
endif

LDC2BINDIR = $(dir $(shell which ldc2))
VLBINDIR = $(dir $(shell which verilator))
VERBOSITY = NONE

TBSRC = ../testbench/axis_tests.d \
	../testbench/axis_item.d \
	../testbench/axis_snooper.d \
	../testbench/axis_adder.d \

DUTLIB = obj_dir/DVaxis_adder.a

.PHONY: all clean

all: axis_adder

$(DUTLIB): link_verilator
	(cd obj_dir; make -f DVaxis_adder.mk DVaxis_adder.a)

clean:
	rm -rf axis_adder* euvm_dir obj_dir link_verilator

link_verilator: ../rtl/axis_adder.v
	verilator $(VEROPTS) $^
	touch link_verilator

axis_adder: link_verilator $(DUTLIB) $(TBSRC)
	ldc2 $(DFLAGS) -Ieuvm_dir $(TBSRC) $(DUTLIB) -of$@ -L-luvm-ldc-shared -L-lesdl-ldc-shared \
		-L-lphobos2-ldc-shared -L-ldruntime-ldc-shared -L-ldl -L-lstdc++

run: axis_adder
	./axis_adder +UVM_TESTNAME=axis_tests.directed_test +UVM_VERBOSITY=$(VERBOSITY) # +UVM_OBJECTION_TRACE

CC              = gcc
CFLAGS		= -Wall -O3 -fPIC
SEED            = 1
DUMPVCD         = 1
VEROPTS         = -O3 --euvm --no-timing --x-assign fast --x-initial fast --threads 1

ifeq ($(DUMPVCD),1)
	VEROPTS += --trace
endif

DFLAGS = -relocation-model=pic -w -O3 

ifeq ($(DUMPVCD),1)
    DFLAGS += --d-version=DUMPVCD
endif

LDC2BINDIR = $(dir $(shell which ldc2))
VLBINDIR = $(dir $(shell which verilator))
VERBOSITY = NONE

TBSRC = ../testbench/axis_tests.d \
	../testbench/axis_item.d \
	../testbench/axis_seq.d \
	../testbench/axis_random_seq.d \
	../testbench/axis_env.d \
	../testbench/axis_scoreboard.d \
	../testbench/axis_agent.d \
	../testbench/axis_snooper.d \
	../testbench/axis_monitor.d \
	../testbench/axis_driver.d \
	../testbench/axis_sequencer.d \
	../testbench/axis_adder.d \
	euvm_dir/Vaxis_adder_euvm.d \
        $(LDC2BINDIR)/../import/esdl/intf/verilator/trace.d

DUTOBJ = euvm_dir/verilated_d.o \
	 euvm_dir/Vaxis_adder_euvm_funcs.o  \
	 obj_dir/Vaxis_adder__ALL.a \
	 obj_dir/verilated.o \
	 obj_dir/verilated_threads.o \
	 obj_dir/verilated_vcd_c.o \
	 euvm_dir/verilated_vcd_d.o

VLATOR_SRC = euvm_dir/Vaxis_adder_euvm.d euvm_dir/Vaxis_adder_euvm_funcs.cpp obj_dir/Vaxis_adder.cpp obj_dir/Vaxis_adder.h

.PHONY: all clean

all: axis_adder

clean:
	rm -rf axis_adder* euvm_dir obj_dir link_verilator

link_verilator: ../rtl/axis_adder.v
	verilator $(VEROPTS) $^
	(cd obj_dir; make -f Vaxis_adder.mk Vaxis_adder__ALL.a verilated.o verilated_threads.o)
	(cd obj_dir; make -f Vaxis_adder.mk verilated_vcd_c.o;)
	(cd euvm_dir; g++ -c -I ../obj_dir/ -I $(VLBINDIR)/../share/verilator/include $(LDC2BINDIR)/../import/esdl/intf/verilator/cpp/verilated_vcd_d.cpp -o verilated_vcd_d.o)
	(cd euvm_dir; g++ -c -I ../obj_dir/ -I $(VLBINDIR)/../share/verilator/include Vaxis_adder_euvm_funcs.cpp)
	(cd euvm_dir; g++ -c -I ../obj_dir/ -I $(VLBINDIR)/../share/verilator/include $(LDC2BINDIR)/../import/esdl/intf/verilator/cpp/verilated_d.cpp -o verilated_d.o)
	touch link_verilator

axis_adder: link_verilator $(DUTOBJ) $(TBSRC)
	ldc2 $(DFLAGS) -Ieuvm_dir $(TBSRC) $(DUTOBJ) -of$@ -L-luvm-ldc-shared -L-lesdl-ldc-shared \
		-L-lphobos2-ldc-shared -L-ldruntime-ldc-shared -L-ldl -L-lstdc++

run_directed_test: axis_adder
	./axis_adder +UVM_TESTNAME=axis_tests.directed_test +UVM_VERBOSITY=$(VERBOSITY) # +UVM_OBJECTION_TRACE

run_random_test: axis_adder
	./axis_adder +UVM_TESTNAME=axis_tests.random_test +UVM_VERBOSITY=$(VERBOSITY) +random_seed=$(SEED) # +UVM_OBJECTION_TRACE

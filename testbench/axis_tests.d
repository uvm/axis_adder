import esdl;
import uvm;

import axis_adder: axis_intf;
import axis_seq: axis_seq;
import axis_random_seq: axis_random_seq;
import axis_env: axis_env;

class directed_test: uvm_test
{
  mixin uvm_component_utils;

  @UVM_BUILD axis_env env;

  this(string name, uvm_component parent) {
    super(name, parent);
  }

  override void run_phase(uvm_phase phase) {
    phase.get_objection().set_drain_time(this, 100.nsec);
    phase.raise_objection(this);
    axis_seq directed_seq;

    directed_seq = axis_seq.type_id.create("axis_seq");

    directed_seq.set_seq(cast(ubyte[]) [0x42, 0x23, 0x12, 0x02]);
    directed_seq.start(env.agent.sequencer, null);

    phase.drop_objection(this);
  }
}

class random_test: uvm_test
{
  mixin uvm_component_utils;

  this(string name, uvm_component parent) {
    super(name, parent);
  }

  @UVM_BUILD {
    axis_env env;
  }
  
  override void run_phase(uvm_phase phase) {
    phase.get_objection().set_drain_time(this, 100.nsec);
    phase.raise_objection(this);

    for (size_t i=0; i!=1000; ++i) {
      axis_random_seq rand_sequence = axis_random_seq.type_id.create("axis_seq");
      rand_sequence.randomize();
      rand_sequence.start(env.agent.sequencer, null);
    }
    phase.drop_objection(this);
  }
}

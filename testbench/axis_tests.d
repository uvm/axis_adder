import esdl;
import uvm;

import axis_adder: axis_intf;

class directed_test: uvm_test
{
  mixin uvm_component_utils;

  axis_intf axis_in;
  
  this(string name, uvm_component parent) {
    super(name, parent);
  }

  override void connect_phase(uvm_phase phase) {
    super.connect_phase(phase);

    uvm_config_db!axis_intf.get(this, "", "axis_in", axis_in);
    assert (axis_in !is null);
  }
    
  override void run_phase(uvm_phase phase) {
    super.run_phase(phase);
    phase.raise_objection(this);
    ubyte[] data = [0x42, 0x23, 0x12, 0x02];
    for (int i = 0; i != data.length; ++i) {
      while (axis_in.ready == 0 || axis_in.areset == 1) {
        wait (axis_in.aclk.negedge());
        axis_in.last = false;
        axis_in.valid = false;
      }

      wait (axis_in.aclk.negedge());

      axis_in.data = cast (ubyte) data[i];
      if (i == data.length-1) axis_in.last = true;
      else axis_in.last = false;
      axis_in.valid = true;
    }

    wait (axis_in.aclk.negedge());
    axis_in.last = false;
    axis_in.valid = false;

    wait(100.nsec);
    phase.drop_objection(this);
  }

}

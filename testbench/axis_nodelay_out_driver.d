module axis_nodelay_out_driver;

import uvm;
import esdl;
import axis_adder: axis_intf;
import axis_out_driver: axis_out_driver;

class axis_nodelay_out_driver: axis_out_driver
{
  mixin uvm_component_utils;
  
  this(string name, uvm_component parent = null) {
    super(name, parent);
  }

  override void run_phase(uvm_phase phase) {
    // super.run_phase(phase);
    axis_out.ready = true;
    wait (axis_out.aclk.negedge());
  }
}

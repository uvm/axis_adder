import esdl;
import uvm;
import axis_adder: axis_intf;

class axis_out_driver: uvm_component
{
  mixin uvm_component_utils;
  
  axis_intf axis_out;

  this(string name, uvm_component parent = null) {
    super(name, parent);
  }

  
  override void connect_phase(uvm_phase phase) {
    super.connect_phase(phase);

    uvm_config_db!axis_intf.get(this, "", "axis_out", axis_out);
    assert (axis_out !is null);
  }
  

  override void run_phase(uvm_phase phase) {
    super.run_phase(phase);

    while (true) {
      uint delay;
      uint flag;
      delay = urandom(0, 10);
      flag = urandom(0, 10);
      if (flag == 0) {
        for (size_t i=0; i!=delay; ++i) {
          axis_out.ready = false;
          wait (axis_out.aclk.negedge());
        }
      }
      else {
        axis_out.ready = true;
        wait (axis_out.aclk.negedge());
      }
    }
  }

}


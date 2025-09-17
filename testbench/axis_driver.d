import esdl;
import uvm;
import axis_item: axis_item;
import axis_adder: axis_intf;

class axis_driver: uvm_driver!(axis_item)
{
  mixin uvm_component_utils;
  
  axis_intf axis_in;

  this(string name, uvm_component parent = null) {
    super(name, parent);
  }

  override void connect_phase(uvm_phase phase) {
    super.connect_phase(phase);

    uvm_config_db!axis_intf.get(this, "", "axis_in", axis_in);
    assert (axis_in !is null);
  }
    
  override void run_phase(uvm_phase phase) {
    super.run_phase(phase);
    while (true) {
      seq_item_port.try_next_item(req);

      if (req !is null) {
        for (int i = 0; i != req.delay; ++i) {
          wait (axis_in.aclk.negedge());

          axis_in.last = false;
          axis_in.valid = false;
        }
        
        while (axis_in.ready == 0 || axis_in.areset == 1) {
          wait (axis_in.aclk.negedge());

          axis_in.last = false;
          axis_in.valid = false;
        }

        wait (axis_in.aclk.negedge());

        axis_in.data = req.data;
        axis_in.last = req.last;
        axis_in.valid = true;

        seq_item_port.item_done();
      }
      else {
        wait (axis_in.aclk.negedge());

        axis_in.last = false;
        axis_in.valid = false;
      }
    }
  }
}

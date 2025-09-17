import esdl;
import uvm;
import axis_item: axis_item;
import axis_adder: axis_intf;

class axis_snooper: uvm_monitor
{
  mixin uvm_component_utils;

  axis_intf axis;

  this (string name, uvm_component parent = null) {
    super(name,parent);
  }

  @UVM_BUILD uvm_analysis_port!axis_item egress;

  override void connect_phase(uvm_phase phase) {
    super.connect_phase(phase);
    
    uvm_config_db!axis_intf.get(this, "", "axis", axis);
    assert (axis !is null);
  }

  override void run_phase(uvm_phase phase) {
    import std.format: format;
    
    super.run_phase(phase);

    while (true) {
      wait (axis.aclk.posedge());
      if (axis.areset == 1 ||
          axis.ready == 0 || axis.valid == 0)
        continue;
      else {
        axis_item item = axis_item.type_id.create(get_full_name() ~ ".axis_item");
        item.data = axis.data;
        item.last = cast(bool) axis.last;
        uvm_info("AXIS: ITEM", format("\n%s", item.sprint()),
                 UVM_DEBUG);
        egress.write(item);
      }
    }
  }

}

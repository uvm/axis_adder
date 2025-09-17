import esdl;
import uvm;
import axis_item: axis_item;
import axis_seq: axis_seq;

class axis_monitor: uvm_monitor
{
  mixin uvm_component_utils;
  
  @UVM_BUILD {
    uvm_analysis_imp!(axis_monitor, write) ingress;
  }

  this(string name, uvm_component parent = null) {
    super(name, parent);
  }

  axis_seq seq;

  void write(axis_item item) {
    if (seq is null) {
      seq = new axis_seq("axis_seq");
    }
    seq ~= item;
    if (seq.is_final()) {
      uvm_info("AXIS: SEQ", "\n" ~ seq.sprint(), UVM_NONE);
      seq = null;
    }
  }
  
}


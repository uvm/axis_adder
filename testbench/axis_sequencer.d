import esdl;
import uvm;
import axis_item: axis_item;

class axis_sequencer: uvm_sequencer!axis_item
{
  mixin uvm_component_utils;

  this(string name, uvm_component parent=null) {
    super(name, parent);
  }
}


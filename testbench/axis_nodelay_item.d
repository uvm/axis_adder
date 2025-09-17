import uvm;
import esdl;
import axis_adder;
import axis_item: axis_item;

class axis_nodelay_item: axis_item
{
  mixin uvm_object_utils;

  this(string name = "axis_ext_item") {
    super(name);
  }

  @constraint_override
  constraint! q{
    delay == 0;
  } cst_delay;
}

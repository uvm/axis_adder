import esdl;
import uvm;

class axis_item: uvm_object
{
  mixin uvm_object_utils;

  @UVM_DEFAULT {
    ubyte data;
    ubvec!1 last;
  }
   
  this(string name = "axis_item") {
    super(name);
  }

}

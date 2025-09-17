import esdl;
import uvm;

class axis_item: uvm_sequence_item
{
  mixin uvm_object_utils;

  @UVM_DEFAULT {
    @rand ubyte data;
    ubvec!1 last;
    @rand ubyte delay;
  }
   
  this(string name = "axis_item") {
    super(name);
  }

  constraint! q{
    data >= 0x30;
    data <= 0x7a;
  } cst_ascii;

  constraint! q{
    delay dist [0 := 9, 1:9 := 1];
    // delay dist [0 := 9, 1:9 :/ 1];
  } cst_delay;

}

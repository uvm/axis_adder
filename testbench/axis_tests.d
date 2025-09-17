import esdl;
import uvm;

import axis_adder: axis_intf;
import axis_env: axis_env;

class directed_test: uvm_test
{
  mixin uvm_component_utils;

  @UVM_BUILD axis_env env;

  this(string name, uvm_component parent) {
    super(name, parent);
  }

}

import uvm, esdl;

import axis_agent: axis_agent;

class axis_env: uvm_env
{
  mixin uvm_component_utils;

  @UVM_BUILD axis_agent agent;

  this(string name, uvm_component parent) {
    super(name, parent);
  }

}


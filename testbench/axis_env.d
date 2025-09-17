import uvm, esdl;

import axis_agent: axis_agent;
import axis_scoreboard: axis_scoreboard;

class axis_env: uvm_env
{
  mixin uvm_component_utils;

  @UVM_BUILD axis_agent agent;
  @UVM_BUILD axis_scoreboard scoreboard;

  this(string name, uvm_component parent) {
    super(name, parent);
  }

  override void connect_phase(uvm_phase phase) {
    agent.req_monitor.egress.connect(scoreboard.req_analysis);
    agent.rsp_monitor.egress.connect(scoreboard.rsp_analysis);
  }
}


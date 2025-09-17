import esdl;
import uvm;

import axis_monitor: axis_monitor;
import axis_snooper: axis_snooper;
import axis_sequencer: axis_sequencer;
import axis_driver: axis_driver;
import axis_out_driver: axis_out_driver;

class axis_agent: uvm_agent
{

  @UVM_BUILD {
    axis_sequencer sequencer;
    axis_driver     driver;
    axis_out_driver driver_out;

    axis_monitor    req_monitor;
    axis_monitor    rsp_monitor;

    axis_snooper    req_snooper;
    axis_snooper    rsp_snooper;
  }
  
  mixin uvm_component_utils;
   
  this(string name, uvm_component parent = null) {
    super(name, parent);
  }

  override void connect_phase(uvm_phase phase) {
    driver.seq_item_port.connect(sequencer.seq_item_export);
    req_snooper.egress.connect(req_monitor.ingress);
    rsp_snooper.egress.connect(rsp_monitor.ingress);
  }

}

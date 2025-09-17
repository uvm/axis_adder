import esdl;
import uvm;
import axis_seq: axis_seq;

import std.string: format;

class axis_scoreboard: uvm_scoreboard
{
  this(string name, uvm_component parent = null) {
    super(name, parent);
  }

  mixin uvm_component_utils;

  uvm_phase phase_run;

  uint _count;

  axis_seq[] req_queue;
  axis_seq[] rsp_queue;

  @UVM_BUILD {
    uvm_analysis_imp!(axis_scoreboard, write_req) req_analysis;
    uvm_analysis_imp!(axis_scoreboard, write_rsp) rsp_analysis;
  }

  override void run_phase(uvm_phase phase) {
    phase_run = phase;
    auto imp = phase.get_imp();
    assert(imp !is null);
    uvm_wait_for_ever();
  }

  void write_req(axis_seq seq) {
      uvm_info("Monitor", "Got req item", UVM_DEBUG);
      req_queue ~= seq;
      assert(phase_run !is null);
      phase_run.raise_objection(this);
  }

  void write_rsp(axis_seq seq) {
      uvm_info("Monitor", "Got rsp item", UVM_DEBUG);
      rsp_queue ~= seq;
      assert(phase_run !is null);
      check_matched();
      phase_run.drop_objection(this);
  }

  void check_matched() {
    if (req_queue.length <= _count)
      uvm_fatal("EXCEPTION", "Received a response when no request has been made");
    else {
      auto expected = add(req_queue[_count].get_values());
      if (expected == rsp_queue[_count].get_values) {
        uvm_info("MATCHED",
                 format("Scoreboard received expected response #%d", _count),
                 UVM_LOW);
        uvm_info("REQUEST", format("%s", req_queue[$-1].get_values), UVM_LOW);
        uvm_info("RESPONSE", format("%s", rsp_queue[$-1].get_values), UVM_LOW);
      }
      else {
        uvm_error("MISMATCHED", "Scoreboard received unmatched response");
        uvm_info("MISMATCHED", format("%s (tb) != %s",
                                      expected, rsp_queue[_count].get_values), uvm_verbosity.UVM_NONE);
      }
      _count += 1;
    }
  }

  ubyte[] add(ubyte[] values) {
    ubyte[] retval;
    uint sum;
    foreach (c; values) {
      sum += c;
    }
    for (int i=4; i!=0; --i) {
      retval ~= cast (ubyte) (sum >> (i-1)*8);
    }
    return retval;
  }
}


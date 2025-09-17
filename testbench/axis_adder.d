import esdl;
import uvm;

class axis_intf: VlInterface
{
  Port!(Signal!(ubvec!1)) aclk;
  Port!(Signal!(ubvec!1)) areset;
  
  VlPort!8 data;
  VlPort!1 last;
  VlPort!1 valid;
  VlPort!1 ready;
}

class Top: Entity
{
  import Vaxis_adder_euvm;

  version (DUMPFST)
    VerilatedFstD _trace;

  Signal!(ubvec!1) areset;
  Signal!(ubvec!1) aclk;

  DVaxis_adder dut;

  axis_intf axis_in;
  axis_intf axis_out;

  void opentrace(string name) {
    version (DUMPFST) {
      traceEverOn(true);
      if (_trace is null) {
        _trace = new VerilatedFstD();
        dut.trace(_trace, 99);
        _trace.open(name);
      }
    }
  }

  void closetrace() {
    version (DUMPFST) {
      if (_trace !is null) {
	_trace.flush();
	_trace.close();
	_trace = null;
      }
    }
  }

  override void doConnect() {
    import std.stdio;

    // Interface connections for Driver Side
    axis_in.aclk(aclk);
    axis_in.areset(areset);

    axis_in.data(dut.TDATA_in);
    axis_in.last(dut.TLAST_in);
    axis_in.valid(dut.TVALID_in);
    axis_in.ready(dut.TREADY_out);

    // Interface connections for Monitor Side
    axis_out.aclk(aclk);
    axis_out.areset(areset);

    axis_out.data(dut.TDATA_out);
    axis_out.last(dut.TLAST_out);
    axis_out.valid(dut.TVALID_out);
    axis_out.ready(dut.TREADY_in);
  }

  override void doBuild() {
    dut = new DVaxis_adder();
    version (DUMPFST) opentrace("axis_adder.fst");
  }
  
  override void doFinish() {
    closetrace();
  }
  
  Task!stimulateClock stimulateClockTask;
  Task!stimulateReset stimulateResetTask;
  Task!stimulateReadyIn stimulateReadyInTask;
  
  void stimulateClock() {
    while (true) {
      aclk = false;
      dut.ACLK = false;
      wait (1.nsec);
      dut.eval();
      version (DUMPFST) if (_trace !is null)
			  _trace.dump(getSimTime().getVal());
      wait (4.nsec);
      aclk = true;
      dut.ACLK = true;
      wait (1.nsec);
      dut.eval();
      version (DUMPFST) if (_trace !is null)
			  _trace.dump(getSimTime().getVal());
      wait (4.nsec);
    }
  }

  void stimulateReset() {
    areset = true;
    dut.ARESETn = false;
    wait (100.nsec);
    areset = false;
    dut.ARESETn = true;
  }

  void stimulateReadyIn() {
    dut.TREADY_in = true;
  }
  
}

class uvm_adder_tb: uvm_context
{
  Top top;
  override void initial() {
    uvm_config_db!(axis_intf).set(null, "uvm_test_top", "axis_in", top.axis_in);
  }
}

void main(string[] args) {
  auto tb = new uvm_adder_tb;
  tb.elaborate("tb", args);
  tb.start();
}

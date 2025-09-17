import esdl;
import uvm;
import axis_item: axis_item;

class axis_seq: uvm_object
{
  mixin uvm_object_utils;

  @UVM_DEFAULT ubyte[] _values;

  this(string name="") {
    super(name);
  }

  ubyte[] get_values() {
    return _values;
  }

  void set_seq(ubyte[] values) {
    this._values = values;
  }

  void set_seq(string values) {
    this._values = cast(ubyte[]) values;
  }

  bool _is_final;

  bool is_final() {
    return _is_final;
  }

  void opOpAssign(string op)(axis_item item) if(op == "~") {
    assert(item !is null);
    _values ~= item.data;
    if (item.last) _is_final = true;
  }

}

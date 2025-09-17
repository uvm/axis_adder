import esdl;
import uvm;
import axis_item: axis_item;

class axis_seq: uvm_sequence!axis_item
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

  // task
  override void body() {
    import std.format: format;
      
    for (size_t i=0; i!=_values.length; ++i) {
      req = axis_item.type_id.create(format("%s[%s]",
                                            get_name() ~ ".req", i));
      wait_for_grant();
      req.data = cast(ubyte) _values[i];
      if (i == _values.length - 1) req.last = true;
      else req.last = false;
      send_request(req);
    }
  } // body

}

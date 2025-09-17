import esdl;
import uvm;
import axis_item: axis_item;

class axis_random_seq: uvm_sequence!axis_item
{
  @UVM_DEFAULT {
    @rand uint seq_size;
  }

  mixin uvm_object_utils;


  this(string name="") {
    super(name);
    req = axis_item.type_id.create(name ~ ".req");
  }

  constraint!q{
    seq_size < 10;
    seq_size >= 6;
  } seq_size_cst;

  // task
  override void body() {
      for (size_t i=0; i!=seq_size; ++i) {
        wait_for_grant();
        req.randomize();
        if (i == seq_size - 1) req.last = true;
        else req.last = false;
        axis_item cloned = cast(axis_item) req.clone;
        // uvm_info("axis_item", cloned.sprint, UVM_DEBUG);
        send_request(cloned);
      }
      // uvm_info("axis_item", "Finishing sequence", UVM_DEBUG);
    }

}

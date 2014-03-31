require "narray"
require "ffi"
require "narray_ffi_c.so"

class NArray
  def to_ptr
    return FFI::Pointer::new( address() )
  end
end

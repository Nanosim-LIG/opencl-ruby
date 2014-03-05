module OpenCL

  def OpenCL.create_buffer( context, size, flags=OpenCL::Mem::READ_WRITE, data=nil)
    fs = 0
    if flags.kind_of?(Array) then
      flags.each { |f| fs = fs | f }
    else
      fs = flags
    end
    d = data
    if d and d.respond_to?(:to_ptr) then
      d = d.to_ptr
    end
    ptr1 = FFI::MemoryPointer.new( :cl_int )
    buff = OpenCL.clCreateBuffer(context, flags, size, d, ptr1)
    OpenCL.error_check(ptr1.read_cl_int)
    return Buffer::new( buff )
  end

  class Buffer < OpenCL::Mem
    layout :dummy, :pointer
  end

end

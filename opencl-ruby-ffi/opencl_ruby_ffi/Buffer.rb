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
    error = FFI::MemoryPointer.new( :cl_int )
    buff = OpenCL.clCreateBuffer(context, flags, size, d, error)
    OpenCL.error_check(error.read_cl_int)
    return Buffer::new( buff )
  end

  def OpenCL.create_sub_buffer( buffer, region, type = OpenCL::BUFFER_CREATE_TYPE_REGION, options = {} )
    OpenCL.error_check(OpenCL::INVALID_OPERATION) if buffer.platform.version_number < 1.1
    flags = 0
    if options[:flags] then
      if options[:flags].kind_of?(Array) then
        options[:flags].each { |f| flags = flags | f }
      else
        flags = options[:flags]
      end
    end
    error = FFI::MemoryPointer.new( :cl_int )
    buff = OpenCL.clCreateSubBuffer( buffer, flags, type, region, error)
    OpenCL.error_check(error.read_cl_int)
    return Buffer::new( buff )
  end

  def OpenCL.create_from_GL_buffer( context, bufobj, flags=OpenCL::Mem::READ_WRITE )
    fs = 0
    if flags.kind_of?(Array) then
      flags.each { |f| fs = fs | f }
    else
      fs = flags
    end
    error = FFI::MemoryPointer.new( :cl_int )
    buff = OpenCL.clCreateFromGLBuffer( context, fs, bufobj, error )
    OpenCL.error_check(error.read_cl_int)
    return Buffer::new( buff )
  end

  class Buffer < OpenCL::Mem
    layout :dummy, :pointer

    def create_sub_buffer( region, type = OpenCL::BUFFER_CREATE_TYPE_REGION, options = {} )
      OpenCL.create_sub_buffer( self, region, type, options )
    end
  end

end

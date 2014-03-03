module OpenCL

  def OpenCL.create_program_with_source(context, strings)
    strs = nil
    if strings == nil then
      raise OpenCL::Error::new(OpenCL::Error.getErrorString(OpenCL::Error::INVALID_VALUE))
    elsif strings.kind_of?(String) then
     strs = [strings]
    elsif strings.kind_of?(Array) then
     strs = strings
    end
    n_strs = strs.size
    strs_lengths = FFI::MemoryPointer.new( :size_t, n_strs )
    c_strs = FFI::MemoryPointer.new( :pointer, n_strs )

    c_strs_p = []
    strs.each { |str|
      if str then
        c_strs_p.push (FFI::MemoryPointer.from_string(str))
      end
    }
    raise OpenCL::Error::new(OpenCL::Error.getErrorString(OpenCL::Error::INVALID_VALUE)) if c_strs_p.size == 0

    c_strs = FFI::MemoryPointer.new( :pointer, c_strs_p.size )
    c_strs_length = FFI::MemoryPointer.new( :size_t, c_strs_p.size )
    c_strs_p.each_with_index { |p, i|
      c_strs[i].write_pointer(p)
      c_strs_length[i].write_size_t(p.size)
    }
    pointer_err = FFI::MemoryPointer.new( :cl_int )
    program_ptr = OpenCL.clCreateProgramWithSource(context, c_strs_p.size, c_strs, c_strs_length, pointer_err)
    OpenCL.error_check(pointer_err.read_cl_int)
    return OpenCL::Program::new( program_ptr )
  end

  class Program
    def self.release(ptr)
      OpenCL.clReleaseProgram(self)
    end
  end

end

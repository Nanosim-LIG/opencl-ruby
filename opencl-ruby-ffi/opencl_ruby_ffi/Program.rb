module OpenCL

  def OpenCL.build_program(program, options = "", &block)
    @@callbacks.push( block ) if block
    options_p = FFI::MemoryPointer.from_string(options)
    err = OpenCL.clBuildProgram(program, 0, nil, options_p, block, nil)
    OpenCL.error_check(err)
  end

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

    eval OpenCL.get_info_array("Program", :size_t, "BINARY_SIZES")

    eval OpenCL.get_info("Program", :size_t, "NUM_KERNELS")

    %w( KERNEL_NAMES SOURCE ).each { |prop|
      eval OpenCL.get_info("Program", :string, prop)
    }

    def binaries
      sizes = self.binary_sizes
      bin_array = FFI::MemoryPointer.new( :pointer, sizes.length )
      sizes.length
      total_size = 0
      sizes.each_with_index { |s, i|
        total_size += s
        bin_array[i].write_pointer(FFI::MemoryPointer.new(s))
      }
      error = OpenCL.clGetProgramInfo(self, Program::BINARIES, total_size, bin_array, nil)
      OpenCL.error_check(error)
      bins = []
      sizes.each_with_index { |s, i|
        bins.push bin_array[i].read_pointer.read_bytes(s)
      }
      return bins
    end

    def build(options = "", &block)
      OpenCL.build_program(self, options, &block)
    end

    def context
      ptr = FFI::MemoryPointer.new( Context )
      error = OpenCL.clGetProgramInfo(self, Program::CONTEXT, Context.size, ptr, nil)
      OpenCL.error_check(error)
      return OpenCL::Context::new( ptr.read_pointer )
    end

    %w( NUM_DEVICES REFERENCE_COUNT ).each { |prop|
      eval OpenCL.get_info("Program", :cl_uint, prop)
    }

    def devices
      n = self.num_devices
      ptr2 = FFI::MemoryPointer.new( Device, n )
      error = OpenCL.clGetProgramInfo(self, Program::DEVICES, Device.size*n, ptr2, nil)
      OpenCL.error_check(error)
      return ptr2.get_array_of_pointer(0, n).collect { |device_ptr|
        OpenCL::Device.new(device_ptr)
      }
    end

    def self.release(ptr)
      OpenCL.clReleaseProgram(self)
    end
  end

end

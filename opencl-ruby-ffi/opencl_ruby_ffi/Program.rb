module OpenCL

  def self.build_program(program, options = {:options => ""}, &block)
    @@callbacks.push( block ) if block
    options_p = FFI::MemoryPointer.from_string(options[:options])
    devices = options[:device_list]
    devices_p = nil
    num_devices = 0
    if devices and devices.size > 0 then
      num_devices = devices.size
      devices_p = FFI::MemoryPointer.new( Device, num_devices)
      num_devices.times { |indx|
        devices_p.put_pointer(indx, devices[indx])
      }
    end
    err = OpenCL.clBuildProgram(program, num_devices, devices_p, options_p, block, options[:user_data] )
    OpenCL.error_check(err)
  end

  # Creates a Program from sources
  #
  # ==== Attributes
  #
  # * +context+ - Context the created Program will be associated to
  # * +strings+ - a single or an Array of String repesenting the program source code
  def self.create_program_with_source(context, strings)
    strs = nil
    if strings == nil then
      raise OpenCL::Error::new(OpenCL::Error.getErrorString(OpenCL::Error::INVALID_VALUE))
    else
      strs = [strings].flatten
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

    def build_status(devs = nil)
      devs = self.devices if not devs
      devs = [devs].flatten
      ptr = FFI::MemoryPointer.new( :cl_build_status )
      return devs.collect { |dev|
        error = OpenCL.clGetProgramBuildInfo(self, dev, OpenCL::Program::BUILD_STATUS, ptr.size, ptr, nil)
        OpenCL.error_check(error)
        ptr.read_cl_build_status
      }
    end

    def build_status_name(devs = nil)
      stat = self.build_status(devs)
      return stat.collect { |st|
        ss = nil
        %w( BUILD_NONE BUILD_ERROR BUILD_SUCCESS BUILD_IN_PROGRESS ).each { |s|
          ss = s if OpenCL.const_get(s) == st
        }
        ss
      }
    end

    def binary_type(devs = nil)
      devs = self.devices if not devs
      devs = [devs].flatten
      ptr = FFI::MemoryPointer.new( :cl_program_binary_type )
      return devs.collect { |dev|
        error = OpenCL.clGetProgramBuildInfo(self, dev, OpenCL::Program::BINARY_TYPE, ptr.size, ptr, nil)
        OpenCL.error_check(error)
        OpenCL::Program::BinaryType::new(ptr.read_cl_program_binary_type)
      }
    end

    def build_options(devs = nil)
      devs = self.devices if not devs
      devs = [devs].flatten
      return devs.collect { |dev|
        ptr1 = FFI::MemoryPointer.new( :size_t, 1)
        error = OpenCL.clGetProgramBuildInfo(self, dev, OpenCL::Program::BUILD_OPTIONS, 0, nil, ptr1)
        OpenCL.error_check(error)
        ptr2 = FFI::MemoryPointer.new( ptr1.read_size_t )
        error = OpenCL.clGetProgramBuildInfo(self, dev, OpenCL::Program::BUILD_OPTIONS, ptr1.read_size_t, ptr2, nil)
        OpenCL.error_check(error)
        ptr2.read_string
      }
    end

    def build_log(devs = nil)
      devs = self.devices if not devs
      devs = [devs].flatten
      return devs.collect { |dev|
        ptr1 = FFI::MemoryPointer.new( :size_t, 1)
        error = OpenCL.clGetProgramBuildInfo(self, dev, OpenCL::Program::BUILD_LOG, 0, nil, ptr1)
        OpenCL.error_check(error)
        ptr2 = FFI::MemoryPointer.new( ptr1.read_size_t )
        error = OpenCL.clGetProgramBuildInfo(self, dev, OpenCL::Program::BUILD_LOG, ptr1.read_size_t, ptr2, nil)
        OpenCL.error_check(error)
        ptr2.read_string
      }
    end

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

    def build(options = { :options => "" }, &block)
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

    def create_kernel( name )
      return OpenCL.create_kernel( self, name )
    end

    def kernels
      return OpenCL.create_kernels_in_program( self )
    end

  end

end

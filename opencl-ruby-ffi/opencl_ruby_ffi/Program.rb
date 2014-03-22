module OpenCL

  # Builds (compile and link) a Program created from sources or binary
  #
  # ==== Attributes
  #
  # * +program+ - the program to build
  # * +options+ - a hash containing named options
  # * +block+ - if provided, a callback invoked when the Program is built. Signature of the callback is { |Program, FFI::Pointer to user_data| ... }
  #
  # ==== Options
  #
  # * +:device_list+ - an Array of Device to build the program for
  # * +:user_data+ - a Pointer (or convertible to Pointer using to_ptr) to the memory area to pass to the callback
  # * +:options+ - a String containing the options to use for the build
  def self.build_program(program, options = {}, &block)
    @@callbacks.push( block ) if block
    opt = ""
    opt = options[:options] if options[:options]
    options_p = FFI::MemoryPointer.from_string(opt)
    devices = options[:device_list]
    devices = [devices].flatten if devices
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
    return program
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
    return OpenCL::Program::new( program_ptr, false )
  end

  # Maps the cl_program object of OpenCL
  class Program
    alias_method :orig_method_missing, :method_missing

    # Intercepts a call to a missing method and tries to see if it is defined as a Kernel inside
    # the Program. It then calls the Kernel enqueue_with_args method. Thanks pyopencl (Andreas Klöeckner) for the idea
    def method_missing(m, *a, &b)
      m_string = m.to_s
      k = nil
      begin
        k = self.create_kernel(m_string)
      rescue OpenCL::Error
        k = nil
      end
      if k then
        k.enqueue_with_args(*a, &b)
      else
        orig_method_missing(m, *args, &b)
      end
    end
    # Returns an Array containing the sizes of the binary inside the Program for each device
    eval OpenCL.get_info_array("Program", :size_t, "BINARY_SIZES")

    # Returns the number of Kernels defined in the Program
    eval OpenCL.get_info("Program", :size_t, "NUM_KERNELS")

    # Returns an Array of String representing the Kernel names inside the Program
    def kernel_names
      kernel_names_size = FFI::MemoryPointer.new( :size_t )
      error = OpenCL.clGetProgramInfo( self, OpenCL::Program::KERNEL_NAMES, 0, nil, kernel_names_size)
      OpenCL.error_check(error)
      k_names = FFI::MemoryPointer.new( kernel_names_size.read_size_t )
      error = OpenCL.clGetProgramInfo( self, OpenCL::Program::KERNEL_NAMES, kernel_names_size.read_size_t, k_names, nil)
      OpenCL.error_check(error)
      k_names_string = k_names.read_string
      returns k_names_string.split(";")
    end

    # Returns the concatenated Program sources
    eval OpenCL.get_info("Program", :string, "SOURCE")

    # Returns the BuildStatus of the  Program
    def build_status(devs = nil)
      devs = self.devices if not devs
      devs = [devs].flatten
      ptr = FFI::MemoryPointer.new( :cl_build_status )
      return devs.collect { |dev|
        error = OpenCL.clGetProgramBuildInfo(self, dev, OpenCL::Program::BUILD_STATUS, ptr.size, ptr, nil)
        OpenCL.error_check(error)
        OpenCL::BuildStatus::new(ptr.read_cl_build_status)
      }
    end

    # Returns the BinaryType for each Device associated to the Program or the Device specified
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

    # Returns the build options for each Device associated to the Program or the Device specified
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

    # Returns the build log for each Device associated to the Program or the Device specified
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

    # Returns the binaries associated to the Program for each Device
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

    # Builds (compile and link) the Program created from sources or binary
    #
    # ==== Attributes
    #
    # * +options+ - a hash containing named options
    # * +block+ - if provided, a callback invoked when error arise in the context. Signature of the callback is { |Program, FFI::Pointer to user_data| ... }
    #
    # ==== Options
    # * +:device_list+ - an Array of Device to build the program for
    # * +:user_data+ - a Pointer (or convertible to Pointer using to_ptr) to the memory area to pass to the callback
    # * +:options+ - a String containing the options to use for the build
    def build(options = { }, &block)
      OpenCL.build_program(self, options, &block)
    end

    # Returns the Context the Program is associated to
    def context
      ptr = FFI::MemoryPointer.new( Context )
      error = OpenCL.clGetProgramInfo(self, Program::CONTEXT, Context.size, ptr, nil)
      OpenCL.error_check(error)
      return OpenCL::Context::new( ptr.read_pointer )
    end

    ##
    # :method: num_devices()
    # Returns the number of device this Program is associated with

    ##
    # :method: reference_count()
    # Returns the reference counter for this Program
    %w( NUM_DEVICES REFERENCE_COUNT ).each { |prop|
      eval OpenCL.get_info("Program", :cl_uint, prop)
    }

    # Returns the Array of Device the Program is associated with
    def devices
      n = self.num_devices
      ptr2 = FFI::MemoryPointer.new( Device, n )
      error = OpenCL.clGetProgramInfo(self, Program::DEVICES, Device.size*n, ptr2, nil)
      OpenCL.error_check(error)
      return ptr2.get_array_of_pointer(0, n).collect { |device_ptr|
        OpenCL::Device.new(device_ptr)
      }
    end

    # Returns the Kernel corresponding the the specified name in the Program
    def create_kernel( name )
      return OpenCL.create_kernel( self, name )
    end

    # Returns an Array of Kernel corresponding to the kernels defined inside the Program
    def kernels
      return OpenCL.create_kernels_in_program( self )
    end

  end

end

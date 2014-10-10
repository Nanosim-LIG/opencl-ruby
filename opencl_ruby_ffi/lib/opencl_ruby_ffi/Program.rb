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
  # * +:options+ - a String containing the options to use for the build
  # * +:user_data+ - a Pointer (or convertible to Pointer using to_ptr) to the memory area to pass to the callback
  def self.build_program(program, options = {}, &block)
    @@callbacks.push( block ) if block
    num_devices, devices_p = get_device_list( options )
    opt = ""
    opt = options[:options] if options[:options]
    options_p = FFI::MemoryPointer.from_string(opt)
    error = clBuildProgram(program, num_devices, devices_p, options_p, block, options[:user_data] )
    error_check(error)
    return program
  end

  # Links a set of compiled programs for all device in a Context, or a subset of devices
  #
  # ==== Attributes
  #
  # * +context+ - Context the created Program will be associated with
  # * +input_programs+ - a single or an Array of Program
  # * +options+ - a Hash containing named options
  # * +block+ - if provided, a callback invoked when the Program is built. Signature of the callback is { |Program, FFI::Pointer to user_data| ... }
  #
  # ==== Options
  #
  # * +:device_list+ - an Array of Device to build the program for
  # * +:options+ - a String containing the options to use for the build
  # * +:user_data+ - a Pointer (or convertible to Pointer using to_ptr) to the memory area to pass to the callback
  def self.link_program(context, input_programs, options = {}, &block)
    @@callbacks.push( block ) if block
    num_devices, devices_p = get_device_list( options )
    opt = ""
    opt = options[:options] if options[:options]
    options_p = FFI::MemoryPointer.from_string(opt)
    programs = [input_programs].flatten
    num_programs = programs.length
    programs_p = FFI::MemoryPointer::new( Program, num_programs )
    programs_p.write_array_of_pointer(programs)
    error = FFI::MemoryPointer::new( :cl_int )
    prog = clLinkProgram( context, num_devices, devices_p, options_p, num_programs, programs_p, block, options[:user_data], error)
    error_check(error.read_cl_int)
    return Program::new( prog, false )
  end

  # Compiles a Program created from sources
  #
  # ==== Attributes
  #
  # * +program+ - the program to build
  # * +options+ - a Hash containing named options
  # * +block+ - if provided, a callback invoked when the Program is compiled. Signature of the callback is { |Program, FFI::Pointer to user_data| ... }
  #
  # ==== Options
  #
  # * +:device_list+ - an Array of Device to build the program for
  # * +:user_data+ - a Pointer (or convertible to Pointer using to_ptr) to the memory area to pass to the callback
  # * +:options+ - a String containing the options to use for the compilation
  # * +:input_headers+ - a Hash containing pairs of : String: header_include_name => Program: header
  def self.compile_program(program, options = {}, &block)
    @@callbacks.push( block ) if block
    num_devices, devices_p = get_device_list( options )
    opt = ""
    opt = options[:options] if options[:options]
    options_p = FFI::MemoryPointer.from_string(opt)
    headers = options[:input_headers]
    headers_p = nil
    header_include_names = nil
    num_headers = 0
    num_headers = headers.length if headers
    if num_headers then
      headers_p = FFI::MemoryPointer::new( Program, num_headers )
      header_include_names = FFI::MemoryPointer::new( :pointer, num_headers )
      indx = 0
      headers.each { |key, value|
        headers_p[indx].write_pointer(value)
        header_include_names[indx] = FFI::MemoryPointer.from_string(key)
        indx = indx + 1
      }
    end
    error = clCompileProgram(program, num_devices, devices_p, options_p, num_headers, headers_p, header_include_names, block, options[:user_data] )
    error_check(error)
    return program
  end

  # Creates a Program from a list of built in kernel names
  #
  # ==== Attributes
  #
  # * +context+ - Context the created Program will be associated to
  # * +device_list+ - an Array of Device to create the program for
  # * +kernel_names+ - a single or an Array of String representing the kernel names
  def self.create_program_with_built_in_kernels(context, device_list, kernel_names)
    devices = [device_list].flatten
    num_devices = devices.length
    devices_p = FFI::MemoryPointer::new( Device, num_devices )
    num_devices.times { |indx|
      devices_p[indx].write_pointer(devices[indx])
    }
    names = [kernel_names].flatten.join(",")
    names_p = FFI::MemoryPointer.from_string(names)
    error = FFI::MemoryPointer::new( :cl_int )
    prog = clCreateProgramWithBuiltInKernels( context, num_devices, devices_p, names_p, error )
    error_check(error.read_cl_int)
    return Program::new(prog, false)
  end

  # Creates a Program from binary
  #
  # ==== Attributes
  #
  # * +context+ - Context the created Program will be associated to
  # * +device_list+ - an Array of Device to create the program for. Can throw an Error::INVALID_VALUE if the number of supplied devices is different from the number of supplied binaries.
  # * +binaries+ - Array of binaries 
  def self.create_program_with_binary(context, device_list, binaries)
    bins = [binaries].flatten
    num_devices = bins.length
    devices = [device_list].flatten
    error_check(INVALID_VALUE) if devices.length != bins.length
    devices_p = FFI::MemoryPointer::new( Device, num_devices )
    lengths = FFI::MemoryPointer::new( :size_t, num_devices )
    binaries_p = FFI::MemoryPointer::new( :pointer, num_devices )
    num_devices.times { |indx|
      devices_p[indx].write_pointer(devices[indx])
      lengths[indx].write_size_t(binaries[indx].size)
      p = FFI::MemoryPointer::new(binaries[indx].size)
      p.write_bytes(binaries[indx])
      binaries_p[indx].write_pointer(p)
    }
    binary_status = FFI::MemoryPointer::new( :cl_int, num_devices )
    error = FFI::MemoryPointer::new( :cl_int )
    prog = clCreateProgramWithBinary(context, num_devices, devices_p, lengths, binaries_p, binary_status, error)
    error_check(error.read_cl_int)
    d_s = []
    num_devices.times { |indx|
      d_s.push [ devices[indx], binary_status[indx].read_cl_int ]
    }
    return [ Program::new(prog, false), d_s ]
  end

  # Creates a Program from sources
  #
  # ==== Attributes
  #
  # * +context+ - Context the created Program will be associated to
  # * +strings+ - a single or an Array of String repesenting the program source code
  def self.create_program_with_source(context, strings)
    strs = nil
    if not strings then
      error_check(INVALID_VALUE)
    else
      strs = [strings].flatten
    end
    n_strs = strs.size
    strs_lengths = FFI::MemoryPointer::new( :size_t, n_strs )
    c_strs = FFI::MemoryPointer::new( :pointer, n_strs )

    c_strs_p = []
    strs.each { |str|
      if str then
        c_strs_p.push (FFI::MemoryPointer.from_string(str))
      end
    }
    error_check(INVALID_VALUE) if c_strs_p.size == 0

    c_strs = FFI::MemoryPointer::new( :pointer, c_strs_p.size )
    c_strs_length = FFI::MemoryPointer::new( :size_t, c_strs_p.size )
    c_strs_p.each_with_index { |p, i|
      c_strs[i].write_pointer(p)
      c_strs_length[i].write_size_t(p.size)
    }
    error = FFI::MemoryPointer::new( :cl_int )
    program_ptr = clCreateProgramWithSource(context, c_strs_p.size, c_strs, c_strs_length, error)
    error_check(error.read_cl_int)
    return Program::new( program_ptr, false )
  end

  # Maps the cl_program object of OpenCL
  class Program
    include InnerInterface

    class << self
      include InnerGenerator
    end
    alias_method :orig_method_missing, :method_missing

    # Intercepts a call to a missing method and tries to see if it is defined as a Kernel inside
    # the Program. It then calls the Kernel enqueue_with_args method. Thanks pyopencl (Andreas Klöeckner) for the idea
    def method_missing(m, *a, &b)
      m_string = m.to_s
      k = nil
      begin
        k = self.create_kernel(m_string)
      rescue Error
        k = nil
      end
      if k then
        k.enqueue_with_args(*a, &b)
      else
        orig_method_missing(m, *a, &b)
      end
    end

    # Returns an Array containing the sizes of the binary inside the Program for each device
    eval get_info_array("Program", :size_t, "BINARY_SIZES")

    # Returns the number of Kernels defined in the Program
    eval get_info("Program", :size_t, "NUM_KERNELS")

    # Returns an Array of String representing the Kernel names inside the Program
    def kernel_names
      kernel_names_size = FFI::MemoryPointer::new( :size_t )
      error = OpenCL.clGetProgramInfo( self, KERNEL_NAMES, 0, nil, kernel_names_size)
      error_check(error)
      k_names = FFI::MemoryPointer::new( kernel_names_size.read_size_t )
      error = OpenCL.clGetProgramInfo( self, KERNEL_NAMES, kernel_names_size.read_size_t, k_names, nil)
      error_check(error)
      k_names_string = k_names.read_string
      returns k_names_string.split(";")
    end

    # Returns the concatenated Program sources
    eval get_info("Program", :string, "SOURCE")

    # Returns the total amount in byte used by the Program variables in the global address space for the Device(s) specified. Returns an Array of tuple [ Device, size ] (2.0 only)
    def build_global_variable_total_size(devs = nil)
      devs = self.devices if not devs
      devs = [devs].flatten
      ptr = FFI::MemoryPointer::new( :size_t )
      return devs.collect { |dev|
        error = OpenCL.clGetProgramBuildInfo(self, dev, BUILD_GLOBAL_VARIABLE_TOTAL_SIZE, ptr.size, ptr, nil)
        error_check(error)
        [dev, ptr.read_size_t]
      }
    end

    # Returns the BuildStatus of the Program for each device associated to the Program or the Device(s) specified. Returns an Array of tuple [ Device, BuildStatus ]
    def build_status(devs = nil)
      devs = self.devices if not devs
      devs = [devs].flatten
      ptr = FFI::MemoryPointer::new( :cl_build_status )
      return devs.collect { |dev|
        error = OpenCL.clGetProgramBuildInfo(self, dev, BUILD_STATUS, ptr.size, ptr, nil)
        error_check(error)
        [dev, BuildStatus::new(ptr.read_cl_build_status)]
      }
    end

    # Returns the BinaryType for each Device associated to the Program or the Device(s) specified. Returns an Array of tuple [ Device, BinaryType ]
    def binary_type(devs = nil)
      devs = self.devices if not devs
      devs = [devs].flatten
      ptr = FFI::MemoryPointer::new( :cl_program_binary_type )
      return devs.collect { |dev|
        error = OpenCL.clGetProgramBuildInfo(self, dev, BINARY_TYPE, ptr.size, ptr, nil)
        error_check(error)
        [dev, BinaryType::new(ptr.read_cl_program_binary_type)]
      }
    end

    # Returns the build options for each Device associated to the Program or the Device(s) specified. Returns an Array of tuple [ Device, String ]
    def build_options(devs = nil)
      devs = self.devices if not devs
      devs = [devs].flatten
      return devs.collect { |dev|
        ptr1 = FFI::MemoryPointer::new( :size_t, 1)
        error = OpenCL.clGetProgramBuildInfo(self, dev, BUILD_OPTIONS, 0, nil, ptr1)
        error_check(error)
        ptr2 = FFI::MemoryPointer::new( ptr1.read_size_t )
        error = OpenCL.clGetProgramBuildInfo(self, dev, BUILD_OPTIONS, ptr1.read_size_t, ptr2, nil)
        error_check(error)
        [dev, ptr2.read_string]
      }
    end

    # Returns the build log for each Device associated to the Program or the Device(s) specified. Returns an Array of tuple [ Device, String ]
    def build_log(devs = nil)
      devs = self.devices if not devs
      devs = [devs].flatten
      return devs.collect { |dev|
        ptr1 = FFI::MemoryPointer::new( :size_t, 1)
        error = OpenCL.clGetProgramBuildInfo(self, dev, BUILD_LOG, 0, nil, ptr1)
        error_check(error)
        ptr2 = FFI::MemoryPointer::new( ptr1.read_size_t )
        error = OpenCL.clGetProgramBuildInfo(self, dev, BUILD_LOG, ptr1.read_size_t, ptr2, nil)
        error_check(error)
        [dev, ptr2.read_string]
      }
    end

    # Returns the binaries associated to the Program for each Device. Returns an Array of tuple [ Device, String ]
    def binaries
      sizes = self.binary_sizes
      bin_array = FFI::MemoryPointer::new( :pointer, sizes.length )
      sizes.length
      total_size = 0
      sizes.each_with_index { |s, i|
        total_size += s
        bin_array[i].write_pointer(FFI::MemoryPointer::new(s))
      }
      error = OpenCL.clGetProgramInfo(self, BINARIES, total_size, bin_array, nil)
      error_check(error)
      bins = []
      devs = self.devices
      sizes.each_with_index { |s, i|
        bins.push [devs, bin_array[i].read_pointer.read_bytes(s)]
      }
      return bins
    end

    # Builds (compile and link) the Program created from sources or binary
    #
    # ==== Attributes
    #
    # * +options+ - a hash containing named options
    # * +block+ - if provided, a callback invoked when the Program is built. Signature of the callback is { |Program, FFI::Pointer to user_data| ... }
    #
    # ==== Options
    # * +:device_list+ - an Array of Device to build the program for
    # * +:user_data+ - a Pointer (or convertible to Pointer using to_ptr) to the memory area to pass to the callback
    # * +:options+ - a String containing the options to use for the build
    def build(options = { }, &block)
      OpenCL.build_program(self, options, &block)
    end

    # Compiles the Program' sources
    #
    # ==== Attributes
    #
    # * +options+ - a Hash containing named options
    # * +block+ - if provided, a callback invoked when the Program is compiled. Signature of the callback is { |Program, FFI::Pointer to user_data| ... }
    #
    # ==== Options
    #
    # * +:device_list+ - an Array of Device to build the program for
    # * +:user_data+ - a Pointer (or convertible to Pointer using to_ptr) to the memory area to pass to the callback
    # * +:options+ - a String containing the options to use for the compilation
    # * +:input_headers+ - a Hash containing pairs of : String: header_include_name => Program: header
    def compile(options = {}, &block)
      return OpenCL.compile_program(self, options, &block)
    end

    # Returns the Context the Program is associated to
    def context
      ptr = FFI::MemoryPointer::new( Context )
      error = OpenCL.clGetProgramInfo(self, CONTEXT, Context.size, ptr, nil)
      error_check(error)
      return Context::new( ptr.read_pointer )
    end

    ##
    # :method: num_devices()
    # Returns the number of device this Program is associated with

    ##
    # :method: reference_count()
    # Returns the reference counter for this Program
    %w( NUM_DEVICES REFERENCE_COUNT ).each { |prop|
      eval get_info("Program", :cl_uint, prop)
    }

    # Returns the Array of Device the Program is associated with
    def devices
      n = self.num_devices
      ptr2 = FFI::MemoryPointer::new( Device, n )
      error = OpenCL.clGetProgramInfo(self, DEVICES, Device.size*n, ptr2, nil)
      error_check(error)
      return ptr2.get_array_of_pointer(0, n).collect { |device_ptr|
        Device::new(device_ptr)
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

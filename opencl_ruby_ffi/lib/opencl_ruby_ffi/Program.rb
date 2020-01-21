using OpenCLRefinements if RUBY_VERSION.scan(/\d+/).collect(&:to_i).first >= 2
module OpenCL

  # Builds (compile and link) a Program created from sources or binary
  #
  # ==== Attributes
  #
  # * +program+ - the program to build
  # * +options+ - a hash containing named options
  # * +block+ - if provided, a callback invoked when the Program is built. Signature of the callback is { |Program, Pointer to user_data| ... }
  #
  # ==== Options
  #
  # * +:device_list+ - an Array of Device to build the program for
  # * +:options+ - a String containing the options to use for the build
  # * +:user_data+ - a Pointer (or convertible to Pointer using to_ptr) to the memory area to pass to the callback
  def self.build_program(program, options = {}, &block)
    if block
      wrapper_block = lambda { |p, u|
        block.call(p, u)
        @@callbacks.delete(wrapper_block)
      }
      @@callbacks[wrapper_block] = options[:user_data]
    else
      wrapper_block = nil
    end
    num_devices, devices_p = get_device_list( options )
    opt = ""
    opt = options[:options] if options[:options]
    options_p = MemoryPointer.from_string(opt)
    error = clBuildProgram(program, num_devices, devices_p, options_p, wrapper_block, options[:user_data] )
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
  # * +block+ - if provided, a callback invoked when the Program is built. Signature of the callback is { |Program, Pointer to user_data| ... }
  #
  # ==== Options
  #
  # * +:device_list+ - an Array of Device to build the program for
  # * +:options+ - a String containing the options to use for the build
  # * +:user_data+ - a Pointer (or convertible to Pointer using to_ptr) to the memory area to pass to the callback
  def self.link_program(context, input_programs, options = {}, &block)
    if block
      wrapper_block = lambda { |p, u|
        block.call(p, u)
        @@callbacks.delete(wrapper_block)
      }
      @@callbacks[wrapper_block] = options[:user_data]
    else
      wrapper_block = nil
    end
    num_devices, devices_p = get_device_list( options )
    opt = ""
    opt = options[:options] if options[:options]
    options_p = MemoryPointer.from_string(opt)
    programs = [input_programs].flatten
    num_programs = programs.length
    programs_p = MemoryPointer::new( Program, num_programs )
    programs_p.write_array_of_pointer(programs)
    error = MemoryPointer::new( :cl_int )
    prog = clLinkProgram( context, num_devices, devices_p, options_p, num_programs, programs_p, wrapper_block, options[:user_data], error)
    error_check(error.read_cl_int)
    return Program::new( prog, false )
  end

  # Compiles a Program created from sources
  #
  # ==== Attributes
  #
  # * +program+ - the program to build
  # * +options+ - a Hash containing named options
  # * +block+ - if provided, a callback invoked when the Program is compiled. Signature of the callback is { |Program, Pointer to user_data| ... }
  #
  # ==== Options
  #
  # * +:device_list+ - an Array of Device to build the program for
  # * +:user_data+ - a Pointer (or convertible to Pointer using to_ptr) to the memory area to pass to the callback
  # * +:options+ - a String containing the options to use for the compilation
  # * +:input_headers+ - a Hash containing pairs of : String: header_include_name => Program: header
  def self.compile_program(program, options = {}, &block)
    if block
      wrapper_block = lambda { |p, u|
        block.call(p, u)
        @@callbacks.delete(wrapper_block)
      }
      @@callbacks[wrapper_block] = options[:user_data]
    else
      wrapper_block = nil
    end
    num_devices, devices_p = get_device_list( options )
    opt = ""
    opt = options[:options] if options[:options]
    options_p = MemoryPointer.from_string(opt)
    headers = options[:input_headers]
    headers_p = nil
    header_include_names = nil
    num_headers = 0
    num_headers = headers.length if headers
    if num_headers then
      headers_p = MemoryPointer::new( Program, num_headers )
      header_include_names = MemoryPointer::new( :pointer, num_headers )
      indx = 0
      headers.each { |key, value|
        headers_p[indx].write_pointer(value)
        header_include_names[indx] = MemoryPointer.from_string(key)
        indx = indx + 1
      }
    end
    error = clCompileProgram(program, num_devices, devices_p, options_p, num_headers, headers_p, header_include_names, wrapper_block, options[:user_data] )
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
    devices_p = MemoryPointer::new( Device, num_devices )
    num_devices.times { |indx|
      devices_p[indx].write_pointer(devices[indx])
    }
    names = [kernel_names].flatten.join(",")
    names_p = MemoryPointer.from_string(names)
    error = MemoryPointer::new( :cl_int )
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
    devices_p = MemoryPointer::new( Device, num_devices )
    lengths = MemoryPointer::new( :size_t, num_devices )
    binaries_p = MemoryPointer::new( :pointer, num_devices )
    num_devices.times { |indx|
      devices_p[indx].write_pointer(devices[indx])
      lengths[indx].write_size_t(binaries[indx].bytesize)
      p = MemoryPointer::new(binaries[indx].bytesize)
      p.write_bytes(binaries[indx])
      binaries_p[indx].write_pointer(p)
    }
    binary_status = MemoryPointer::new( :cl_int, num_devices )
    error = MemoryPointer::new( :cl_int )
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
    c_strs = MemoryPointer::new( :pointer, n_strs )

    c_strs_p = []
    strs.each { |str|
      if str then
        c_strs_p.push (MemoryPointer.from_string(str))
      end
    }
    error_check(INVALID_VALUE) if c_strs_p.size == 0

    c_strs = MemoryPointer::new( :pointer, c_strs_p.size )
    c_strs_length = MemoryPointer::new( :size_t, c_strs_p.size )
    c_strs_p.each_with_index { |p, i|
      c_strs[i].write_pointer(p)
      c_strs_length[i].write_size_t(p.size == 0 ? 0 : p.size - 1) # minus the null character
    }
    error = MemoryPointer::new( :cl_int )
    program_ptr = clCreateProgramWithSource(context, c_strs_p.size, c_strs, c_strs_length, error)
    error_check(error.read_cl_int)
    return Program::new( program_ptr, false )
  end

  # Create a Program from an intermediate level representation
  #
  # ==== Attributes
  #
  # * +context+ - Context the created Program will be associated to
  # * +il+ - a binary string containing the intermediate level representation of the program
  def self.create_program_with_il(context, il)
    error_check(INVALID_OPERATION) if context.platform.version_number < 2.1
    length = il.bytesize
    il_p = MemoryPointer::new( length )
    error = MemoryPointer::new( :cl_int )
    il_p.write_bytes(il)
    program_ptr = clCreateProgramWithIL(context, il_p, length, error)
    error_check(error.read_cl_int)
    return Program::new( program_ptr, false )
  end

  # Attaches a callback to program that will be called on program release
  #
  # ==== Attributes
  #
  # * +program+ - the Program to attach the callback to
  # * +options+ - a hash containing named options
  # * +block+ - if provided, a callback invoked when program is released. Signature of the callback is { |Pointer to the program, Pointer to user_data| ... }
  #
  # ==== Options
  #
  # * +:user_data+ - a Pointer (or convertible to Pointer using to_ptr) to the memory area to pass to the callback
  def self.set_program_release_callback( program, options = {}, &block )
    if block
      wrapper_block = lambda { |p, u|
        block.call(p, u)
        @@callbacks.delete(wrapper_block)
      }
      @@callbacks[wrapper_block] = options[:user_data]
    else
      wrapper_block = nil
    end
    error = clSetProgramReleaseCallback( program, wrapper_block, options[:user_data] )
    error_check(error)
    return program
  end


  # Sets a specialization constant in a program
  #
  # ==== Attributes
  #
  # * +program+ - the Program to which constant needs to be set
  # * +spec_id+ - the id of the specialization constant
  # * +spec_value+ - value the constant must be set to
  # * +spec_size+ - optional spec_value size
  def self.set_program_specialization_constant( program, spec_id, spec_value, spec_size = nil)
    sz = spec_size
    sz = spec_value.class.size if sz == nil
    error = clSetProgramSpecializationConstant( program, spec_id, sz, spec_value )
    error_check(error)
    return program
  end

  # Maps the cl_program object of OpenCL
  class Program
    include InnerInterface
    extend InnerGenerator

    def inspect
      success = false
      build_status.each { |d,s|
        success |= true if s.to_i == BuildStatus::SUCCESS
      }
      return "#<#{self.class.name}: #{success ? kernel_names : ""}>"
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

    # Returns the Context the Program is associated to
    def context
      return @_context if @_context
      ptr = MemoryPointer::new( Context )
      error = OpenCL.clGetProgramInfo(self, CONTEXT, Context.size, ptr, nil)
      error_check(error)
      @_context = Context::new( ptr.read_pointer )
    end

    get_info("Program", :cl_uint, "num_devices", true)
    get_info("Program", :cl_uint, "reference_count")

    # Returns the Array of Device the Program is associated with
    def devices
      return @_devices if @_devices
      n = self.num_devices
      ptr2 = MemoryPointer::new( Device, n )
      error = OpenCL.clGetProgramInfo(self, DEVICES, Device.size*n, ptr2, nil)
      error_check(error)
      @_devices = ptr2.get_array_of_pointer(0, n).collect { |device_ptr|
        Device::new(device_ptr)
      }
      return @_devices
    end

    get_info("Program", :string, "source")
    get_info_array("Program", :size_t, "binary_sizes")

    # Returns the binaries associated to the Program for each Device. Returns an Array of tuple [ Device, String ]
    def binaries
      sizes = self.binary_sizes
      bin_array = MemoryPointer::new( :pointer, sizes.length )
      total_size = 0
      pointers = []
      sizes.each_with_index { |s, i|
        total_size += s
        pointers[i] = MemoryPointer::new(s)
        bin_array[i].write_pointer(pointers[i])
      }
      error = OpenCL.clGetProgramInfo(self, BINARIES, total_size, bin_array, nil)
      error_check(error)
      bins = []
      devs = self.devices
      sizes.each_with_index { |s, i|
        bins.push [devs[i], pointers[i].read_bytes(s)]
      }
      return bins
    end

    # Returns the BuildStatus of the Program for each device associated to the Program or the Device(s) specified. Returns an Array of tuple [ Device, BuildStatus ]
    def build_status(devs = nil)
      devs = self.devices if not devs
      devs = [devs].flatten
      ptr = MemoryPointer::new( :cl_build_status )
      return devs.collect { |dev|
        error = OpenCL.clGetProgramBuildInfo(self, dev, BUILD_STATUS, ptr.size, ptr, nil)
        error_check(error)
        [dev, BuildStatus::new(ptr.read_cl_build_status)]
      }
    end

    # Returns the build options for each Device associated to the Program or the Device(s) specified. Returns an Array of tuple [ Device, String ]
    def build_options(devs = nil)
      devs = self.devices if not devs
      devs = [devs].flatten
      return devs.collect { |dev|
        ptr1 = MemoryPointer::new( :size_t, 1)
        error = OpenCL.clGetProgramBuildInfo(self, dev, BUILD_OPTIONS, 0, nil, ptr1)
        error_check(error)
        ptr2 = MemoryPointer::new( ptr1.read_size_t )
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
        ptr1 = MemoryPointer::new( :size_t, 1)
        error = OpenCL.clGetProgramBuildInfo(self, dev, BUILD_LOG, 0, nil, ptr1)
        error_check(error)
        ptr2 = MemoryPointer::new( ptr1.read_size_t )
        error = OpenCL.clGetProgramBuildInfo(self, dev, BUILD_LOG, ptr1.read_size_t, ptr2, nil)
        error_check(error)
        [dev, ptr2.read_string]
      }
    end

    # Builds (compile and link) the Program created from sources or binary
    #
    # ==== Attributes
    #
    # * +options+ - a hash containing named options
    # * +block+ - if provided, a callback invoked when the Program is built. Signature of the callback is { |Program, Pointer to user_data| ... }
    #
    # ==== Options
    # * +:device_list+ - an Array of Device to build the program for
    # * +:user_data+ - a Pointer (or convertible to Pointer using to_ptr) to the memory area to pass to the callback
    # * +:options+ - a String containing the options to use for the build
    def build(options = { }, &block)
      OpenCL.build_program(self, options, &block)
    end

    # Returns the Kernel corresponding the the specified name in the Program
    def create_kernel( name )
      return OpenCL.create_kernel( self, name )
    end

    # Returns an Array of Kernel corresponding to the kernels defined inside the Program
    def kernels
      return OpenCL.create_kernels_in_program( self )
    end

    def kernel_names
      return kernels.collect(&:name)
    end

    module OpenCL12
      extend InnerGenerator

      get_info("Program", :size_t, "num_kernels")

      # Returns an Array of String representing the Kernel names inside the Program
      def kernel_names
        if context.platform.version_number < 1.2 then
          return kernels.collect(&:name)
        else
          kernel_names_size = MemoryPointer::new( :size_t )
          error = OpenCL.clGetProgramInfo( self, KERNEL_NAMES, 0, nil, kernel_names_size)
          error_check(error)
          k_names = MemoryPointer::new( kernel_names_size.read_size_t )
          error = OpenCL.clGetProgramInfo( self, KERNEL_NAMES, kernel_names_size.read_size_t, k_names, nil)
          error_check(error)
          k_names_string = k_names.read_string
          return k_names_string.split(";")
        end
      end

      # Returns the BinaryType for each Device associated to the Program or the Device(s) specified. Returns an Array of tuple [ Device, BinaryType ]
      def binary_type(devs = nil)
        devs = self.devices if not devs
        devs = [devs].flatten
        ptr = MemoryPointer::new( :cl_program_binary_type )
        return devs.collect { |dev|
          error = OpenCL.clGetProgramBuildInfo(self, dev, BINARY_TYPE, ptr.size, ptr, nil)
          error_check(error)
          [dev, BinaryType::new(ptr.read_cl_program_binary_type)]
        }
      end

      # Compiles the Program' sources
      #
      # ==== Attributes
      #
      # * +options+ - a Hash containing named options
      # * +block+ - if provided, a callback invoked when the Program is compiled. Signature of the callback is { |Program, Pointer to user_data| ... }
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

    end

    module OpenCL20

      # Returns the total amount in byte used by the Program variables in the global address space for the Device(s) specified. Returns an Array of tuple [ Device, size ] (2.0 only)
      def build_global_variable_total_size(devs = nil)
        devs = self.devices if not devs
        devs = [devs].flatten
        ptr = MemoryPointer::new( :size_t )
        return devs.collect { |dev|
          error = OpenCL.clGetProgramBuildInfo(self, dev, BUILD_GLOBAL_VARIABLE_TOTAL_SIZE, ptr.size, ptr, nil)
          error_check(error)
          [dev, ptr.read_size_t]
        }
      end

    end

    module OpenCL21

      # Return the intermediate level representation of the program if any, nil otherwise
      def il
        il_size = MemoryPointer::new( :size_t )
        error = OpenCL.clGetProgramInfo(self, IL, 0, nil, il_size)
        error_check(error)
        return nil if il_size == 0
        length = il_size.read_size_t
        il_p = MemoryPointer::new( length )
        error = OpenCL.clGetProgramInfo(self, IL, length, il_p, nil)
        error_check(error)
        return il_p.read_bytes(length)
      end

    end

    module OpenCL22
      extend InnerGenerator

      get_info("Program", :cl_bool, "scope_global_ctors_present")
      get_info("Program", :cl_bool, "scope_global_dtors_present")

      # Attaches a callback to the Program that will be called on program release
      #
      # ==== Attributes
      #
      # * +options+ - a hash containing named options
      # * +block+ - if provided, a callback invoked when Program is released. Signature of the callback is { |Pointer to the Program, Pointer to user_data| ... }
      #
      # ==== Options
      #
      # * +:user_data+ - a Pointer (or convertible to Pointer using to_ptr) to the memory area to pass to the callback
      def set_release_callback( options = {}, &block )
        OpenCL.set_program_release_callback( self, options, &block )
        return self
      end

      # Sets a specialization constant in a program
      #
      # ==== Attributes
      #
      # * +program+ - the Program to which constant needs to be set
      # * +spec_id+ - the id of the specialization constant
      # * +spec_value+ - value the constant must be set to
      # * +spec_size+ - optional spec_value size
      def set_specialization_constant( spec_id, spec_value, spec_size = nil)
        OpenCL.set_program_specialization_constant( self, spec_id, spec_value, spec_size)
        return self
      end

    end

    register_extension( :v12, OpenCL12, "context.platform.version_number >= 1.2" )
    register_extension( :v20, OpenCL20, "context.platform.version_number >= 2.0" )
    register_extension( :v21, OpenCL21, "context.platform.version_number >= 2.1" )
    register_extension( :v22, OpenCL22, "context.platform.version_number >= 2.2" )

  end

end

using OpenCLRefinements if RUBY_VERSION.scan(/\d+/).collect(&:to_i).first >= 2
module OpenCL

  # Unloads a Platform compiler
  #
  # ==== Attributes
  #
  # * +platform+ - the Platform to have it's compiler unloaded
  def self.unload_platform_compiler(platform)
    error_check(INVALID_OPERATION) if self.version_number < 1.2
    error = clUnloadPlatformCompiler( platform )
    error_check(error)
    return platform
  end

  # Unloads the compiler
  def self.unload_compiler
    error = clUnloadCompiler()
    error_check(error)
    return nil
  end

  # Returns a Function corresponding to an extension function
  #
  # ==== Attributes
  #
  # * +name+ - a String representing the name of the function
  # * +return_type+ - the type of data returned by the function
  # * +param_types+ - an Array of types, corresponding to the parameters type
  # * +options+ - if given, a hash of named options that will be given to Function::new. See FFI doc for details.
  def self.get_extension_function( name, return_type, param_types, options = {} )
    name_p = MemoryPointer.from_string(name)
    ptr = clGetExtensionFunctionAddress( name_p )
    return nil if ptr.null?
    return Function::new(return_type, param_types, ptr, options)
  end

  def self.attach_extension_function( name, return_type, param_types, options = {} )
    f = get_extension_function( name, return_type, param_types, options )
    if not f then
      warn "Warning: could not find extension function #{name}!"
      return nil
    end
    f.attach(OpenCL, name)
  end

  # Returns a Function corresponding to an extension function for the Platform
  #
  # ==== Attributes
  #
  # * +platform+ - the Platform to be queried
  # * +name+ - a String representing the name of the function
  # * +return_type+ - the type of data returned by the function
  # * +param_types+ - an Array of types, corresponding to the parameters type
  # * +options+ - if given, a hash of named options that will be given to Function::new. See FFI doc for details.
  def self.get_extension_function_for_platform( platform, name, return_type, param_types, options = {} )
    error_check(INVALID_OPERATION) if platform.version_number < 1.2
    name_p = MemoryPointer.from_string(name)
    ptr = clGetExtensionFunctionAddressForPlatform( platform, name_p )
    return nil if ptr.null?
    return Function::new(return_type, param_types, ptr, options)
  end

  # Returns an Array of Platform containing the available OpenCL platforms
  def self.get_platforms
    ptr1 = MemoryPointer::new(:cl_uint , 1)
    
    error = clGetPlatformIDs(0, nil, ptr1)
    error_check(error)
    ptr2 = MemoryPointer::new(:pointer, ptr1.read_uint)
    error = clGetPlatformIDs(ptr1.read_uint(), ptr2, nil)
    error_check(error)
    return ptr2.get_array_of_pointer(0,ptr1.read_uint()).collect { |platform_ptr|
      Platform::new(platform_ptr, false)
    }
  end

  class << self
    alias platforms get_platforms
  end

  # Maps the cl_platform_id object of OpenCL
  class Platform
    include InnerInterface

    class << self
      include InnerGenerator
    end

    def inspect
      return "#<#{self.class.name}: #{self.name}>"
    end

    ##
    # :method: icd_suffix_khr()
    # Returns a String containing the function name suffix used to identify extension functions to be directed to this platform by the ICD Loader

    ##
    # :method: profile()
    # Returns a String containing the profile name supported by the Platform

    ##
    # :method: version()
    # Returns a String containing the version number

    ##
    # :method: name()
    # Returns a String containing the Platform name

    ##
    # :method: vendor()
    # Returns a String identifying the Platform vendor
    %w(PROFILE VERSION NAME VENDOR).each { |prop|
      eval get_info("Platform", :string, prop)
    }

    # Returns an Array of string corresponding to the Platform extensions
    def extensions
      extensions_size = MemoryPointer::new( :size_t )
      error = OpenCL.clGetPlatformInfo( self, EXTENSIONS, 0, nil, extensions_size)
      error_check(error)
      ext = MemoryPointer::new( extensions_size.read_size_t )
      error = OpenCL.clGetPlatformInfo( self, EXTENSIONS, extensions_size.read_size_t, ext, nil)
      error_check(error)
      ext_string = ext.read_string
      return ext_string.split(" ")
    end

    # Returns an Array of Device corresponding to the available devices on the Platform
    # The type of the desired devices can be specified
    def devices(type = Device::Type::ALL)
      ptr1 = MemoryPointer::new(:cl_uint , 1)
      error = OpenCL.clGetDeviceIDs(self, type, 0, nil, ptr1)
      error_check(error)
      ptr2 = MemoryPointer::new(:pointer, ptr1.read_uint)
      error = OpenCL.clGetDeviceIDs(self, type, ptr1.read_uint(), ptr2, nil)
      error_check(error)
      return ptr2.get_array_of_pointer(0, ptr1.read_uint()).collect { |device_ptr|
        Device::new(device_ptr, false)
      }
    end

    # returs a floating point number corresponding to the OpenCL version of the Platform
    def version_number
      ver = self.version
      n = ver.scan(/OpenCL (\d+\.\d+)/)
      return n.first.first.to_f
    end

    # Creates a Context gathering devices of a certain type and belonging to this Platform
    #
    # ==== Attributes
    #
    # * +type+ - type of device to be used
    # * +options+ - if given, a hash of named options
    # * +block+ - if provided, a callback invoked when error arise in the context. Signature of the callback is { |Pointer to null terminated c string, Pointer to binary data, :size_t number of bytes of binary data, Pointer to user_data| ... }
    #
    # ==== Options
    # 
    # * +:properties+ - a list of :cl_context_properties, the Platform will be prepended
    # * +:user_data+ - an Pointer or an object that can be converted into one using to_ptr. The pointer is passed to the callback.
    def create_context_from_type(type, options = {}, &block)
      props = [ Context::PLATFORM, self ]
      if options[:properties] then
        props = props +  options[:properties]
      else
        props.push( 0 )
      end
      opts = options.clone
      opts[:properties] = props
      OpenCL.create_context_from_type(type, opts, &block)
    end

    module OpenCL12

      # Returns a Function corresponding to an extension function for a Platform
      #
      # ==== Attributes
      #
      # * +name+ - a String representing the name of the function
      # * +return_type+ - the type of data returned by the function
      # * +param_types+ - an Array of types, corresponding to the parameters type
      # * +options+ - if given, a hash of named options that will be given to Function::new. See FFI doc for details.
      def get_extension_function( name, return_type, param_types, options = {} )
        return OpenCL.get_extension_function_for_platform( self, name, return_type, param_types, options )
      end

      # Unloads the Platform compiler
      def unload_compiler
        return OpenCL.unload_platform_compiler(self)
      end

    end

    module OpenCL21
      class << self
        include InnerGenerator
      end

      ##
      # :method: host_timer_resolution()
      # returns the host timer resulution in nanoseconds
      eval get_info("Platform", :cl_ulong, "HOST_TIMER_RESOLUTION")

    end

    Extensions[:v12] = [OpenCL12, "version_number >= 1.2"]
    Extensions[:v21] = [OpenCL21, "version_number >= 2.1"]

  end

end

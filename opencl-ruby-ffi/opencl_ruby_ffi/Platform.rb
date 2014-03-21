module OpenCL

  # Returns an FFI::Function corresponding to an extension function
  #
  # ==== Attributes
  #
  # * +name+ - a String representing the name of the function
  # * +return_type+ - the type of data returned by the function
  # * +param_types+ - an Array of types, corresponding to the parameters type
  # * +options+ - if given, a hash of named options that will be given to FFI::Function::new. See FFI doc for details.
  def self.get_extension_function( name, return_type, param_types, options = {} )
    name_p = FFI::MemoryPointer.from_string(name)
    ptr = OpenCL.clGetExtensionFunctionAddress( name_p )
    return nil if ptr.null?
    return FFI::Function::new(return_type, param_types, ptr, options)
  end

  # Returns an Array of Platforms containing the available OpenCL platforms
  def self.get_platforms
    ptr1 = FFI::MemoryPointer.new(:cl_uint , 1)
    
    error = OpenCL::clGetPlatformIDs(0, nil, ptr1)
    OpenCL.error_check(error)
    ptr2 = FFI::MemoryPointer.new(:pointer, ptr1.read_uint)
    error = OpenCL::clGetPlatformIDs(ptr1.read_uint(), ptr2, nil)
    OpenCL.error_check(error)
    return ptr2.get_array_of_pointer(0,ptr1.read_uint()).collect { |platform_ptr|
      OpenCL::Platform.new(platform_ptr)
    }
  end

  # Returns an FFI::Function corresponding to an extension function for the Platform
  #
  # ==== Attributes
  #
  # * +platform+ - the Platform to be queried
  # * +name+ - a String representing the name of the function
  # * +return_type+ - the type of data returned by the function
  # * +param_types+ - an Array of types, corresponding to the parameters type
  # * +options+ - if given, a hash of named options that will be given to FFI::Function::new. See FFI doc for details.
  def get_extension_function_for_platform( platform, name, return_type, param_types, options = {} )
    OpenCL.error_check(OpenCL::INVALID_OPERATION) if self.version_number < 1.2
    name_p = FFI::MemoryPointer.from_string(name)
    ptr = OpenCL.clGetExtensionFunctionAddressForPlatform( platform, name_p )
    return nil if ptr.null?
    return FFI::Function::new(return_type, param_types, ptr, options)
  end


  # Maps the cl_platform_id object of OpenCL
  class Platform
    %w(PROFILE VERSION NAME VENDOR EXTENSIONS).each { |prop|
      eval OpenCL.get_info("Platform", :string, prop)
    }

    # Returns an Array of Device corresponding to the available devices on the Platform
    # The type of the desired devices can be specified
    def devices(type = OpenCL::Device::Type::ALL)
      ptr1 = FFI::MemoryPointer.new(:cl_uint , 1)
      error = OpenCL::clGetDeviceIDs(self, type, 0, nil, ptr1)
      OpenCL.error_check(error)
      ptr2 = FFI::MemoryPointer.new(:pointer, ptr1.read_uint)
      error = OpenCL::clGetDeviceIDs(self, type, ptr1.read_uint(), ptr2, nil)
      OpenCL.error_check(error)
      return ptr2.get_array_of_pointer(0, ptr1.read_uint()).collect { |device_ptr|
        OpenCL::Device.new(device_ptr)
      }
    end

    # returs a floating point number corresponding to the OpenCL version of the Platform
    def version_number
      ver = self.version
      n = ver.scan(/OpenCL (\d+\.\d+)/)
      return n.first.first.to_f
    end

    # Returns an FFI::Function corresponding to an extension function for a Platform
    #
    # ==== Attributes
    #
    # * +name+ - a String representing the name of the function
    # * +return_type+ - the type of data returned by the function
    # * +param_types+ - an Array of types, corresponding to the parameters type
    # * +options+ - if given, a hash of named options that will be given to FFI::Function::new. See FFI doc for details.
    def get_extension_function( name, return_type, param_types, options = {} )
      OpenCL.error_check(OpenCL::INVALID_OPERATION) if self.version_number < 1.2
      name_p = FFI::MemoryPointer.from_string(name)
      ptr = OpenCL.clGetExtensionFunctionAddressForPlatform( self, name_p )
      return nil if ptr.null?
      return FFI::Function::new(return_type, param_types, ptr, options)
    end

    # Creates a Context gathering devices of a certain type and belonging to this Platform
    #
    # ==== Attributes
    #
    # * +type+ - type of device to be used
    # * +options+ - if given, a hash of named options
    # * +block+ - if provided, a callback invoked when error arise in the context. Signature of the callback is { |FFI::Pointer to null terminated c string, FFI::Pointer to binary data, :size_t number of bytes of binary data, FFI::Pointer to user_data| ... }
    #
    # ==== Options
    # 
    # * +:properties+ - a list of :cl_context_properties, the Platform will be prepended
    # * +:user_data+ - an FFI::Pointer or an object that can be converted into one using to_ptr. The pointer is passed to the callback.
    def create_context_from_type(type, options = {}, &block)
      props = [ OpenCL::Context::PLATFORM, self ]
      if options[:properties] then
        props = props +  options[:properties]
      else
        props.push( 0 )
      end
      opts = options.clone
      opts[:properties] = props
      OpenCL.create_context_from_type(type, opts, &block)
    end

  end

end

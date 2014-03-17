module OpenCL

  def get_extension_function( name, *function_options )
    name_p = FFI::MemoryPointer.from_string(name)
    ptr = OpenCL.clGetExtensionFunctionAddress( name_p )
    return nil if ptr.null?
    return FFI::Function::new(function_options[0], function_options[1], ptr, function_options[2])
  end

  def OpenCL.get_platforms
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

  class Platform
    %w(PROFILE VERSION NAME VENDOR EXTENSIONS).each { |prop|
      eval OpenCL.get_info("Platform", :string, prop)
    }

    def devices(type = OpenCL::Device::TYPE_ALL)
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

    def version_number
      ver = self.version
      n = ver.scan(/OpenCL (\d+\.\d+)/)
      return n.first.first.to_f
    end

    def get_extension_function( name, *function_options )
      OpenCL.error_check(OpenCL::INVALID_OPERATION) if command_queue.context.platform.version_number < 1.2
      name_p = FFI::MemoryPointer.from_string(name)
      ptr = OpenCL.clGetExtensionFunctionAddressForPlatform( self, name_p )
      return nil if ptr.null?
      return FFI::Function::new(function_options[0], function_options[1], ptr, function_options[2])
    end

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

module OpenCL

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
  end

end

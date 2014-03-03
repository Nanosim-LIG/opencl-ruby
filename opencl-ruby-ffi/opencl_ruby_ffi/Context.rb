module OpenCL

  def OpenCL.create_context(devices, properties=nil, &block)
    @@callbacks.push( block ) if block
    pointer = FFI::MemoryPointer.new( Device, devices.size)
    pointer_err = FFI::MemoryPointer.new( :cl_int )
    devices.size.times { |indx|
      pointer.put_pointer(indx, devices[indx])
    }
    ptr = OpenCL.clCreateContext(nil, devices.size, pointer, block, nil, pointer_err)
    OpenCL.error_check(pointer_err.read_cl_int)
    return OpenCL::Context::new(ptr)
  end

  class Context

    %w( REFERENCE_COUNT NUM_DEVICES ).each { |prop|
      eval OpenCL.get_info("Context", :cl_uint, prop)
    }
    eval OpenCL.get_info_array("Context", :cl_context_properties, "PROPERTIES")

    def platform
      ptr2 = FFI::MemoryPointer.new( Platform.size )
      error = OpenCL.clGetContextInfo(self, Context::PLATFORM, ptr1.read_size_t, ptr2, nil)
      OpenCL.error_check(error)
      return OpenCL::Platform.new(ptr2.read_pointer)
    end

    def devices
      n = self.num_devices
      ptr2 = FFI::MemoryPointer.new( Device, n )
      error = OpenCL.clGetContextInfo(self, Context::DEVICES, Device.size*n, ptr2, nil)
      OpenCL.error_check(error)
      return ptr2.get_array_of_pointer(0, n).collect { |device_ptr|
        OpenCL::Device.new(device_ptr)
      }
    end

    def create_command_queue(device, properties=[])
      return OpenCL.create_command_queue(self, device, properties)
    end

    def create_buffer(size, flags=OpenCL::Mem::READ_WRITE, data=nil)
      return OpenCL.create_buffer(self, size, flags, data)
    end

    def create_program_with_source( strings )
      return OpenCL.create_program_with_source(self, strings)
    end

    def self.release(ptr)
      OpenCL.clReleaseContext(self)
    end
  end
end


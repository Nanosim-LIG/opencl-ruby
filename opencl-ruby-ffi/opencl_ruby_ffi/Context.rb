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

#  def OpenCL.create_context_from_type(type, properties = {}, &block)
#    @@callbacks.push( block ) if block
#    OpenCL.clCreateContextFromType(
#  end

  class Context

    %w( REFERENCE_COUNT ).each { |prop|
      eval OpenCL.get_info("Context", :cl_uint, prop)
    }
    eval OpenCL.get_info_array("Context", :cl_context_properties, "PROPERTIES")

    def platform
      self.devices.first.platform
    end

    def num_devices
      d_n = 0
      ptr = FFI::MemoryPointer.new( :size_t )
      error = OpenCL.clGetContextInfo(self, Context::DEVICES, 0, nil, ptr)
      OpenCL.error_check(error)
      d_n = ptr.read_size_t / Platform.size
#      else
#        ptr = FFI::MemoryPointer.new( :cl_uint )
#        error = OpenCL.clGetContextInfo(self, Context::NUM_DEVICES, ptr.size, ptr, nil)
#        OpenCL.error_check(error)
#        d_n = ptr.read_cl_uint
#      end
      return d_n
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

    def create_from_GL_buffer( bufobj, flags=OpenCL::Mem::READ_WRITE )
      return OpenCL.create_from_GL_buffer( self, bufobj, flags )
    end

    def create_from_GL_render_buffer( renderbuffer, flags=OpenCL::Mem::READ_WRITE )
      return OpenCL.create_from_GL_render_buffer( self, renderbuffer, flags )
    end

    def create_from_GL_texture( context, texture_target, miplevel, texture, flags=OpenCL::Mem::READ_WRITE )
      return OpenCL.create_from_GL_texture( self, texture_target, miplevel, texture, flags )
    end

    def create_from_GL_texture_2D( context, texture_target, miplevel, texture, flags=OpenCL::Mem::READ_WRITE )
      return OpenCL.create_from_GL_texture_2D( self, texture_target, miplevel, texture, flags )
    end

    def create_from_GL_texture_3D( context, texture_target, miplevel, texture, flags=OpenCL::Mem::READ_WRITE )
      return OpenCL.create_from_GL_texture_3D( self, texture_target, miplevel, texture, flags )
    end

    def create_image( format, desc, flags=OpenCL::Mem::READ_WRITE, data=nil )
      return OpenCL.create_image(self, format, desc, flags, data)
    end

    def create_image_1D( format, width, flags=OpenCL::Mem::READ_WRITE, data=nil )
      return OpenCL.create_image_1D( self, format, width, flags, data )
    end

    def create_image_2D( format, width, height, row_pitch, flags=OpenCL::Mem::READ_WRITE, data=nil )
      return OpenCL.create_image_2D( self, format, width, height, row_pitch, flags, data )
    end

    def create_image_3D( format, width, height, depth, row_pitch, slice_pitch, flags=OpenCL::Mem::READ_WRITE, data=nil )
      return OpenCL.create_image_3D( self, format, width, height, depth, row_pitch, slice_pitch, flags, data )
    end

    def create_event_from_GL_sync_KHR( sync )
      return OpenCL.create_event_from_GL_sync_KHR( self, sync )
    end

    def create_user_event
      return OpenCL.create_user_event(self)
    end

    def create_program_with_source( strings )
      return OpenCL.create_program_with_source(self, strings)
    end

    def create_sampler( normalized_coords, addressing_mode, filter_mode )
      return OpenCL.create_sampler( self, normalized_coords, addressing_mode, filter_mode )
    end
  end

end


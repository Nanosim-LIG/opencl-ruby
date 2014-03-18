module OpenCL

  # Creates an Context using the specified devices
  #
  # ==== Attributes
  #
  # * +devices+ - array of Device or a single Device
  # * +options+ - a hash containing named options
  # * +block+ - if provided, a callback invoked when error arise in the context. Signature of the callback is { |FFI::Pointer to null terminated c string, FFI::Pointer to binary data, :size_t number of bytes of binary data, FFI::Pointer to user_data| ... }
  # ==== Options
  # 
  # * +:properties+ - a null terminated list of :cl_context_properties
  # * +:user_data+ - an FFI::Pointer or an object that can be converted into one using to_ptr. The pointer is passed to the callback.
  def self.create_context(devices, options = {}, &block)
    @@callbacks.push( block ) if block
    pointer = FFI::MemoryPointer.new( Device, devices.size)
    devices.size.times { |indx|
      pointer.put_pointer(indx, devices[indx])
    }
    properties = nil
    if options[:properties] then
      properties = FFI::MemoryPointer.new( :cl_context_properties, options[:properties].length )
      options[:properties].each_with_index { |e,i|
        properties[i].write_cl_context_properties(e)
      }
    end
    user_data = options[:user_data]
    error = FFI::MemoryPointer.new( :cl_int )
    ptr = OpenCL.clCreateContext(properties, devices.size, pointer, block, user_data, error)
    OpenCL.error_check(error.read_cl_int)
    return OpenCL::Context::new(ptr)
  end

  # Creates an Context using devices of the selected type
  #
  # ==== Attributes
  #
  # * +type+ - array of Device or a single Device
  # * +options+ - a hash containing named options
  # * +block+ - if provided, a callback invoked when error arise in the context. Signature of the callback is { |FFI::Pointer to null terminated c string, FFI::Pointer to binary data, :size_t number of bytes of binary data, FFI::Pointer to user_data| ... }
  # ==== Options
  # 
  # * +:properties+ - a null terminated list of :cl_context_properties
  # * +:user_data+ - an FFI::Pointer or an object that can be converted into one using to_ptr. The pointer is passed to the callback.
  def self.create_context_from_type(type, options = {}, &block)
    @@callbacks.push( block ) if block
    error = FFI::MemoryPointer.new( :cl_int )
    properties = nil
    if options[:properties] then
      properties = FFI::MemoryPointer.new( :cl_context_properties, options[:properties].length )
      options[:properties].each_with_index { |e,i|
        properties[i].write_cl_context_properties(e)
      }
    end
    user_data = options[:user_data]
    ptr = OpenCL.clCreateContextFromType(properties, type, block, user_data, error)
    OpenCL.error_check(error.read_cl_int)
    return OpenCL::Context::new(ptr)
  end

  class Context

    ##
    # :method: reference_count
    # Returns the reference count of the Context
    %w( REFERENCE_COUNT ).each { |prop|
      eval OpenCL.get_info("Context", :cl_uint, prop)
    }

    ##
    # :method: properties
    # the Array of :cl_context_properties used to create the Context
    eval OpenCL.get_info_array("Context", :cl_context_properties, "PROPERTIES")

    # Returns the platform associated to the Context
    def platform
      self.devices.first.platform
    end

    # Returns the number of devices associated to the Context
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

    # Returns an Array of Device associated to the Context
    def devices
      n = self.num_devices
      ptr2 = FFI::MemoryPointer.new( Device, n )
      error = OpenCL.clGetContextInfo(self, Context::DEVICES, Device.size*n, ptr2, nil)
      OpenCL.error_check(error)
      return ptr2.get_array_of_pointer(0, n).collect { |device_ptr|
        OpenCL::Device.new(device_ptr)
      }
    end

    # Returns an Array of ImageFormat that are supported for a given image type in the Context
    #
    # ==== Attributes
    # * +image_type+ - a :cl_mem_object_type specifying the type of Image being queried
    # * +flags+ - a single or an Array of :cl_mem_flags specifying the flags to be used when creating the Image
    def supported_image_formats( image_type, flags=OpenCL::Mem::READ_WRITE )
      fs = 0
      if flags.kind_of?(Array) then
        flags.each { |f| fs = fs | f }
      else
        fs = flags
      end
      num_image_formats = FFI::MemoryPointer.new( :cl_uint )
      error = OpenCL.clGetSupportedImageFormats( self, fs, image_type, 0, nil, num_image_formats )
      OpenCL.error_check(error)
      num_entries = num_image_formats.read_cl_uint
      image_formats = FFI::MemoryPointer.new( ImageFormat, num_entries )
      error = OpenCL.clGetSupportedImageFormats( self, fs, image_type, num_entries, image_formats, nil )
      OpenCL.error_check(error)
      return num_entries.times.collect { |i|
        OpenCL::ImageFormat::from_pointer( image_formats + i * ImageFormat.size )
      }
    end

    # Creates a CommandQueue in Context targeting the specified Device
    #
    # ==== Attributes
    #
    # * +device+ - the Device targetted by the CommandQueue being created
    # * +properties+ - a single or an Array of :cl_command_queue_properties
    def create_command_queue(device, properties=[])
      return OpenCL.create_command_queue(self, device, properties)
    end

    # Creates a Buffer in the Context
    #
    # ==== Attributes
    #
    # * +size+ - Size in of the Buffer to be created
    # * +flags+ - a single or an Array of :cl_mem_flags specifying the flags to be used when creating the Buffer
    # * +data+ - if provided, the Pointer (or convertible to Pointer using to_ptr) to the memory area to use
    def create_buffer(size, flags=OpenCL::Mem::READ_WRITE, host_ptr=nil)
      return OpenCL.create_buffer(self, size, flags, host_ptr)
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


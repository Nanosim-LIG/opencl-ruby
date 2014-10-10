module OpenCL

  # Creates an Context using the specified devices
  #
  # ==== Attributes
  #
  # * +devices+ - array of Device or a single Device
  # * +options+ - a hash containing named options
  # * +block+ - if provided, a callback invoked when error arise in the context. Signature of the callback is { |FFI::Pointer to null terminated c string, FFI::Pointer to binary data, :size_t number of bytes of binary data, FFI::Pointer to user_data| ... }
  #
  # ==== Options
  # 
  # * +:properties+ - a list of :cl_context_properties
  # * +:user_data+ - an FFI::Pointer or an object that can be converted into one using to_ptr. The pointer is passed to the callback.
  def self.create_context(devices, options = {}, &block)
    @@callbacks.push( block ) if block
    devs = [devices].flatten
    pointer = FFI::MemoryPointer::new( Device, devs.size)
    pointer.write_array_of_pointer(devs)
    properties = get_context_properties( options )
    user_data = options[:user_data]
    error = FFI::MemoryPointer::new( :cl_int )
    ptr = clCreateContext(properties, devs.size, pointer, block, user_data, error)
    error_check(error.read_cl_int)
    return Context::new(ptr, false)
  end

  # Creates an Context using devices of the selected type
  #
  # ==== Attributes
  #
  # * +type+ - a Device::Type
  # * +options+ - a hash containing named options
  # * +block+ - if provided, a callback invoked when error arise in the context. Signature of the callback is { |FFI::Pointer to null terminated c string, FFI::Pointer to binary data, :size_t number of bytes of binary data, FFI::Pointer to user_data| ... }
  #
  # ==== Options
  # 
  # * +:properties+ - a list of :cl_context_properties
  # * +:user_data+ - an FFI::Pointer or an object that can be converted into one using to_ptr. The pointer is passed to the callback.
  def self.create_context_from_type(type, options = {}, &block)
    @@callbacks.push( block ) if block
    properties = get_context_properties( options )
    user_data = options[:user_data]
    error = FFI::MemoryPointer::new( :cl_int )
    ptr = clCreateContextFromType(properties, type, block, user_data, error)
    error_check(error.read_cl_int)
    return Context::new(ptr, false)
  end

  #Maps the cl_context object of OpenCL
  class Context
    include InnerInterface

    class << self
      include InnerGenerator
    end

    ##
    # :method: reference_count
    # Returns the reference count of the Context
    %w( REFERENCE_COUNT ).each { |prop|
      eval get_info("Context", :cl_uint, prop)
    }

    ##
    # :method: properties
    # the Array of :cl_context_properties used to create the Context
    eval get_info_array("Context", :cl_context_properties, "PROPERTIES")

    # Returns the platform associated to the Context
    def platform
      self.devices.first.platform
    end

    # Returns the number of devices associated to the Context
    def num_devices
      d_n = 0
      ptr = FFI::MemoryPointer::new( :size_t )
      error = OpenCL.clGetContextInfo(self, DEVICES, 0, nil, ptr)
      error_check(error)
      d_n = ptr.read_size_t / Platform.size
#      else
#        ptr = FFI::MemoryPointer::new( :cl_uint )
#        error = OpenCL.clGetContextInfo(self, OpenCL::Context::NUM_DEVICES, ptr.size, ptr, nil)
#        OpenCL.error_check(error)
#        d_n = ptr.read_cl_uint
#      end
      return d_n
    end

    # Returns an Array of Device associated to the Context
    def devices
      n = self.num_devices
      ptr2 = FFI::MemoryPointer::new( Device, n )
      error = OpenCL.clGetContextInfo(self, DEVICES, Device.size*n, ptr2, nil)
      error_check(error)
      return ptr2.get_array_of_pointer(0, n).collect { |device_ptr|
        Device::new(device_ptr)
      }
    end

    # Returns an Array of ImageFormat that are supported for a given image type in the Context
    #
    # ==== Attributes
    # * +image_type+ - a :cl_mem_object_type specifying the type of Image being queried
    # * +options+ - a hash containing named options
    #
    # ==== Options
    # 
    # * +:flags+ - a single or an Array of :cl_mem_flags specifying the flags to be used when creating the Buffer
    def supported_image_formats( image_type, options = {} )
      flags = get_flags( options )
      num_image_formats = FFI::MemoryPointer::new( :cl_uint )
      error = OpenCL.clGetSupportedImageFormats( self, flags, image_type, 0, nil, num_image_formats )
      error_check(error)
      num_entries = num_image_formats.read_cl_uint
      image_formats = FFI::MemoryPointer::new( ImageFormat, num_entries )
      error = OpenCL.clGetSupportedImageFormats( self, flags, image_type, num_entries, image_formats, nil )
      error_check(error)
      return num_entries.times.collect { |i|
        ImageFormat::from_pointer( image_formats + i * ImageFormat.size )
      }
    end

    # Creates a CommandQueue in Context targeting the specified Device
    #
    # ==== Attributes
    #
    # * +device+ - the Device targetted by the CommandQueue being created
    # * +options+ - a hash containing named options
    #
    # ==== Options
    # 
    # * +:properties+ - a single or an Array of :cl_command_queue_properties
    # * +:size+ - the size of the command queue ( if ON_DEVICE is specified in the properties ) 2.0+ only
    def create_command_queue( device, options = {} )
      return OpenCL.create_command_queue( self, device, options )
    end

    # Creates a Buffer in the Context
    #
    # ==== Attributes
    #
    # * +size+ - size of the Buffer to be created
    # * +options+ - a hash containing named options
    #
    # ==== Options
    # 
    # * +:flags+ - a single or an Array of :cl_mem_flags specifying the flags to be used when creating the Buffer
    # * +:host_ptr+ - if provided, the Pointer (or convertible to Pointer using to_ptr) to the memory area to use
    def create_buffer( size, options = {} )
      return OpenCL.create_buffer( self, size, options )
    end

    # Creates a Buffer in the Context from an opengl buffer
    #
    # ==== Attributes
    #
    # * +bufobj+ - opengl buffer object
    # * +options+ - a hash containing named options
    #
    # ==== Options
    #
    # * +:flags+ - a single or an Array of :cl_mem_flags specifying the flags to be used when creating the Image
    def create_from_GL_buffer( bufobj, options = {} )
      return OpenCL.create_from_GL_buffer( self, bufobj, options )
    end

    # Creates an Image in the Context from an OpenGL render buffer
    #
    # ==== Attributes
    #
    # * +renderbuf+ - opengl render buffer
    # * +options+ - a hash containing named options
    #
    # ==== Options
    #
    # * +:flags+ - a single or an Array of :cl_mem_flags specifying the flags to be used when creating the Image
    def create_from_GL_render_buffer( renderbuffer, options = {} )
      return OpenCL.create_from_GL_render_buffer( self, renderbuffer, options )
    end

    # Creates an Image in the Context from an OpenGL texture
    #
    # ==== Attributes
    #
    # * +texture_target+ - a :GLenum defining the image type of texture
    # * +texture+ - a :GLuint specifying the name of the texture
    # * +options+ - a hash containing named options
    #
    # ==== Options
    #
    # * +:miplevel+ - a :GLint specifying the mipmap level to be used (default 0)
    # * +:flags+ - a single or an Array of :cl_mem_flags specifying the flags to be used when creating the Image
    def create_from_GL_texture( texture_target, texture, options = {} )
      return OpenCL.create_from_GL_texture( self, texture_target, texture, options )
    end

    # Creates an Image in the Context from an OpenGL 2D texture
    #
    # ==== Attributes
    #
    # * +texture_target+ - a :GLenum defining the image type of texture
    # * +texture+ - a :GLuint specifying the name of the texture
    # * +options+ - a hash containing named options
    #
    # ==== Options
    #
    # * +:miplevel+ - a :GLint specifying the mipmap level to be used (default 0)
    # * +:flags+ - a single or an Array of :cl_mem_flags specifying the flags to be used when creating the Image
    def create_from_GL_texture_2D( texture_target, texture, options = {} )
      return OpenCL.create_from_GL_texture_2D( self, texture_target, texture, options )
    end

    # Creates an Image in the Context from an OpenGL 3D texture
    #
    # ==== Attributes
    #
    # * +texture_target+ - a :GLenum defining the image type of texture
    # * +texture+ - a :GLuint specifying the name of the texture
    # * +options+ - a hash containing named options
    #
    # ==== Options
    #
    # * +:miplevel+ - a :GLint specifying the mipmap level to be used (default 0)
    # * +:flags+ - a single or an Array of :cl_mem_flags specifying the flags to be used when creating the Image
    def create_from_GL_texture_3D( texture_target, texture, options = {} )
      return OpenCL.create_from_GL_texture_3D( self, texture_target, texture, options )
    end

    # Creates an Image in the Context
    #
    # ==== Attributes
    #
    # * +format+ - an ImageFormat
    # * +options+ - an ImageDesc
    #
    # ==== Options
    # 
    # * +:flags+ - a single or an Array of :cl_mem_flags specifying the flags to be used when creating the Buffer
    # * +:host_ptr+ - if provided, the Pointer (or convertible to Pointer using to_ptr) to the memory area to use
    def create_image( format, desc, options = {} )
      return OpenCL.create_image( self, format, desc, options )
    end

    # Creates a 1D Image in the Context
    #
    # ==== Attributes
    #
    # * +format+ - an ImageFormat
    # * +width+ - width of the image
    #
    # ==== Options
    # 
    # * +:flags+ - a single or an Array of :cl_mem_flags specifying the flags to be used when creating the Buffer
    # * +:host_ptr+ - if provided, the Pointer (or convertible to Pointer using to_ptr) to the memory area to use
    def create_image_1D( format, width, options = {} )
      return OpenCL.create_image_1D( self, format, width, options )
    end

    # Creates a 2D Image in the Context
    #
    # ==== Attributes
    #
    # * +format+ - an ImageFormat
    # * +width+ - width of the image
    #
    # ==== Options
    # 
    # * +:flags+ - a single or an Array of :cl_mem_flags specifying the flags to be used when creating the Buffer
    # * +:host_ptr+ - if provided, the Pointer (or convertible to Pointer using to_ptr) to the memory area to use
    # * +:row_pitch+ - if provided the row_pitch of data in host_ptr
    def create_image_2D( format, width, height, options = {} )
      return OpenCL.create_image_2D( self, format, width, height, options )
    end

    # Creates a 3D Image in the Context
    #
    # ==== Attributes
    #
    # * +format+ - an ImageFormat
    # * +width+ - width of the image
    #
    # ==== Options
    # 
    # * +:flags+ - a single or an Array of :cl_mem_flags specifying the flags to be used when creating the Buffer
    # * +:host_ptr+ - if provided, the Pointer (or convertible to Pointer using to_ptr) to the memory area to use
    # * +:row_pitch+ - if provided the row_pitch of data in host_ptr
    # * +:slice_pitch+ - if provided the slice_pitch of data in host_ptr
    def create_image_3D( format, width, height, depth, options = {} )
      return OpenCL.create_image_3D( self, format, width, height, depth, options )
    end

#    # Creates an Event in the Context from a GL sync
#    #
#    # ==== Attributes
#    #
#    # * +sync+ - a :GLsync representing the name of the sync object
#    def create_event_from_GL_sync_KHR( sync )
#      return OpenCL.create_event_from_GL_sync_KHR( self, sync )
#    end


    # Creates a user Event in the Context
    def create_user_event
      return OpenCL.create_user_event(self)
    end

    # Links a set of compiled programs for all device in the Context, or a subset of devices
    #
    # ==== Attributes
    #
    # * +input_programs+ - a single or an Array of Program
    # * +options+ - a Hash containing named options
    # * +block+ - if provided, a callback invoked when the Program is built. Signature of the callback is { |Program, FFI::Pointer to user_data| ... }
    #
    # ==== Options
    #
    # * +:device_list+ - an Array of Device to build the program for
    # * +:options+ - a String containing the options to use for the build
    # * +:user_data+ - a Pointer (or convertible to Pointer using to_ptr) to the memory area to pass to the callback
    def link_program( input_programs, options = {}, &block)
      return OpenCL.link_program(self, input_programs, options, &block)
    end

    # Creates a Program from binary
    #
    # ==== Attributes
    #
    # * +device_list+ - an Array of Device to create the program for. Can throw an OpenCL::Invalid value if the number of supplied devices is different from the number of supplied binaries.
    # * +binaries+ - Array of binaries 
    def create_program_with_binary( device_list, binaries)
       return OpenCL.create_program_with_binary(self, device_list, binaries)
    end

    # Creates a Program from a list of built in kernel names
    #
    # ==== Attributes
    #
    # * +device_list+ - an Array of Device to create the program for
    # * +kernel_names+ - a single or an Array of String representing the kernel names
    def create_program_with_built_in_kernels( device_list, kernel_names )
      return OpenCL.create_program_with_built_in_kernels(self, device_list, kernel_names )
    end

    # Creates a Program from sources in the Context
    #
    # ==== Attributes
    #
    # * +strings+ - a single or an Array of String repesenting the program source code
    def create_program_with_source( strings )
      return OpenCL.create_program_with_source(self, strings)
    end

    # Creates a Sampler in the Context
    #
    # ==== Options
    #
    # * +:normalized_coords+ - a :cl_bool specifying if the image coordinates are normalized
    # * +:addressing_mode+ - a :cl_addressing_mode specifying how out-of-range image coordinates are handled when reading from an image
    # * +:filter_mode+ - a :cl_filter_mode specifying the type of filter that must be applied when reading an image
    # * +:mip_filter_mode+ - the filtering mode to use if using mimaps (default CL_FILTER_NONE, requires cl_khr_mipmap_image)
    # * +:lod_min+ - floating point value representing the minimal LOD (default 0.0f, requires cl_khr_mipmap_image)
    # * +:lod_max+ - floating point value representing the maximal LOD (default MAXFLOAT, requires cl_khr_mipmap_image)
    def create_sampler( options = {} )
      return OpenCL.create_sampler( self, options )
    end

    # Creates a Pipe in the Context
    #
    # ==== Attributes
    #
    # * +pipe_packet_size+ - size of a packet in the Pipe
    # * +pipe_max_packets+ - size of the Pipe in packet
    #
    # ==== Options
    # 
    # * +:flags+ - a single or an Array of :cl_mem_flags specifying the flags to be used when creating the Buffer
    def create_pipe( pipe_packet_size, pipe_max_packets, opts = {} )
      return OpenCL.create_pipe( self, pipe_packet_size, pipe_max_packets, opts )
    end

    # Creates an SVMPointer pointing to an SVM area of memory in the Context
    #
    # ==== Attributes
    #
    # * +size+ - the size of the mmemory area to allocate
    # * +options+ - a hash containing named options
    #
    # ==== Options
    #
    # * +:alignment+ - imposes the minimum alignment in byte
    def svm_alloc(size, options = {})
      return OpenCL.svm_alloc( self, size, options)
    end

    # Frees an SVMPointer
    #
    # ==== Attributes
    #
    # * +svm_pointer+ - the SVMPointer to deallocate
    def svm_free(svm_pointer)
      return OpenCL.svm_free(self, svm_pointer)
    end

  end

end


using OpenCLRefinements if RUBY_VERSION.scan(/\d+/).collect(&:to_i).first >= 2
module OpenCL

  # Creates an Context using the specified devices
  #
  # ==== Attributes
  #
  # * +devices+ - array of Device or a single Device
  # * +options+ - a hash containing named options
  # * +block+ - if provided, a callback invoked when error arise in the context. Signature of the callback is { |Pointer to null terminated c string, Pointer to binary data, :size_t number of bytes of binary data, Pointer to user_data| ... }
  #
  # ==== Options
  # 
  # * +:properties+ - a list of :cl_context_properties
  # * +:user_data+ - an Pointer or an object that can be converted into one using to_ptr. The pointer is passed to the callback.
  def self.create_context(devices, options = {}, &block)
    if block
      @@callbacks[block] = options[:user_data]
    end
    devs = [devices].flatten
    pointer = MemoryPointer::new( Device, devs.size)
    pointer.write_array_of_pointer(devs)
    properties = get_context_properties( options )
    user_data = options[:user_data]
    error = MemoryPointer::new( :cl_int )
    ptr = clCreateContext(properties, devs.size, pointer, block, user_data, error)
    error_check(error.read_cl_int)
    context = Context::new(ptr, false)
    if block && context.platform.version_number >= 3.0
      callback_destructor_callback = lambda { |c, u|
        @@callbacks.delete(block)
        @@callbacks.delete(callback_destructor_callback)
      }
      @@callbacks[callback_destructor_callback] = nil
      context.set_destructor_callback(&callback_destructor_callback)
    end
    return context
  end

  # Creates an Context using devices of the selected type
  #
  # ==== Attributes
  #
  # * +type+ - a Device::Type
  # * +options+ - a hash containing named options
  # * +block+ - if provided, a callback invoked when error arise in the context. Signature of the callback is { |Pointer to null terminated c string, Pointer to binary data, :size_t number of bytes of binary data, Pointer to user_data| ... }
  #
  # ==== Options
  # 
  # * +:properties+ - a list of :cl_context_properties
  # * +:user_data+ - an Pointer or an object that can be converted into one using to_ptr. The pointer is passed to the callback.
  def self.create_context_from_type(type, options = {}, &block)
    if block
      @@callbacks[block] = options[:user_data]
    end
    properties = get_context_properties( options )
    user_data = options[:user_data]
    error = MemoryPointer::new( :cl_int )
    ptr = clCreateContextFromType(properties, type, block, user_data, error)
    error_check(error.read_cl_int)
    context = Context::new(ptr, false)
    if block && context.platform.version_number >= 3.0
      callback_destructor_callback = lambda { |c, u|
        @@callbacks.delete(block)
        @@callbacks.delete(callback_destructor_callback)
      }
      @@callbacks[callback_destructor_callback] = nil
      context.set_destructor_callback(&callback_destructor_callback)
    end
    return context
  end

  def self.set_default_device_command_queue( context, device, command_queue )
    error_check(INVALID_OPERATION) if context.platform.version_number < 2.1
    error = clSetDefaultDeviceCommandQueue( context, device, command_queue )
    error_check(error)
    return context
  end

  # Attaches a callback to context that will be called on context destruction
  #
  # ==== Attributes
  #
  # * +context+ - the Program to attach the callback to
  # * +options+ - a hash containing named options
  # * +block+ - if provided, a callback invoked when program is released. Signature of the callback is { |Pointer to the context, Pointer to user_data| ... }
  #
  # ==== Options
  #
  # * +:user_data+ - a Pointer (or convertible to Pointer using to_ptr) to the memory area to pass to the callback
  def self.set_context_destructor_callback( context, options = {}, &block )
    if block
      wrapper_block = lambda { |p, u|
        block.call(p, u)
        @@callbacks.delete(wrapper_block)
      }
      @@callbacks[wrapper_block] = options[:user_data]
    else
      wrapper_block = nil
    end
    error = clSetContextDestructorCallback( context, wrapper_block, options[:user_data] )
    error_check(error)
    return context
  end

  #Maps the cl_context object of OpenCL
  class Context
    include InnerInterface
    extend InnerGenerator

    def inspect
      return "#<#{self.class.name}: #{self.devices}>"
    end

    get_info("Context", :cl_uint, "reference_count")

    # Returns the number of devices associated to the Context
    def num_devices
      return @_num_devices if @_num_devices
      d_n = 0
      ptr = MemoryPointer::new( :size_t )
      error = OpenCL.clGetContextInfo(self, DEVICES, 0, nil, ptr)
      error_check(error)
      d_n = ptr.read_size_t / Platform.size
      @_num_devices = d_n
    end

    # Returns an Array of Device associated to the Context
    def devices
      return @_devices if @_devices
      n = self.num_devices
      ptr2 = MemoryPointer::new( Device, n )
      error = OpenCL.clGetContextInfo(self, DEVICES, Device.size*n, ptr2, nil)
      error_check(error)
      @_devices = ptr2.get_array_of_pointer(0, n).collect { |device_ptr|
        Device::new(device_ptr)
      }
      return @_devices
    end

    ##
    # @!method properties
    # the Array of :cl_context_properties used to create the Context
    def properties
      ptr1 = MemoryPointer::new( :size_t, 1)
      error = OpenCL.clGetContextInfo(self, PROPERTIES, 0, nil, ptr1)
      error_check(error)
      return [] if ptr1.read_size_t == 0
      ptr2 = MemoryPointer::new( ptr1.read_size_t )
      error = OpenCL.clGetContextInfo(self, PROPERTIES, ptr1.read_size_t, ptr2, nil)
      error_check(error)
      arr = ptr2.get_array_of_cl_context_properties(0, ptr1.read_size_t/ OpenCL.find_type(:cl_context_properties).size)
      return arr if arr.length == 1 and arr[0].to_i == 0
      arr_2 = []
      while arr.length > 2 do
        prop = arr.shift.to_i
        arr_2.push Properties::new(prop)
        return arr_2 if arr.length <= 0
        if prop == Properties::PLATFORM then
          arr_2.push Platform::new(arr.shift)
        else
          arr_2.push arr.shift.to_i
        end
        return arr_2 if arr.length <= 0
      end
      arr_2.push arr.shift.to_i if arr.length > 0
      return arr_2
    end

    # Returns the platform associated to the Context
    def platform
      return @_platform if @_platform
      @_platform = self.devices.first.platform
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
      flags = Mem::Flags::READ_WRITE if flags.to_i == 0 #ensure default READ_WRITE, Intel bug.
      num_image_formats = MemoryPointer::new( :cl_uint )
      error = OpenCL.clGetSupportedImageFormats( self, flags, image_type, 0, nil, num_image_formats )
      error_check(error)
      num_entries = num_image_formats.read_cl_uint
      image_formats = MemoryPointer::new( ImageFormat, num_entries )
      error = OpenCL.clGetSupportedImageFormats( self, flags, image_type, num_entries, image_formats, nil )
      error_check(error)
      return num_entries.times.collect { |i|
        ImageFormat::new( image_formats + i * ImageFormat.size )
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
    def create_from_gl_buffer( bufobj, options = {} )
      return OpenCL.create_from_gl_buffer( self, bufobj, options )
    end
    alias :create_from_GL_buffer :create_from_gl_buffer

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
    def create_from_gl_renderbuffer( renderbuffer, options = {} )
      return OpenCL.create_from_gl_renderbuffer( self, renderbuffer, options )
    end
    alias :create_from_GL_renderbuffer :create_from_gl_renderbuffer

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
    def create_from_gl_texture_2d( texture_target, texture, options = {} )
      return OpenCL.create_from_gl_texture_2d( self, texture_target, texture, options )
    end
    alias :create_from_GL_texture_2D :create_from_gl_texture_2d

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
    def create_from_gl_texture_3d( texture_target, texture, options = {} )
      return OpenCL.create_from_gl_texture_3d( self, texture_target, texture, options )
    end
    alias :create_from_GL_texture_3D :create_from_gl_texture_3d

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
    def create_image_1d( format, width, options = {} )
      return OpenCL.create_image_1d( self, format, width, options )
    end
    alias :create_image_1D :create_image_1d

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
    def create_image_2d( format, width, height, options = {} )
      return OpenCL.create_image_2d( self, format, width, height, options )
    end
    alias :create_image_2D :create_image_2d

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
    def create_image_3d( format, width, height, depth, options = {} )
      return OpenCL.create_image_3d( self, format, width, height, depth, options )
    end
    alias :create_image_3D :create_image_3d

    # Creates a Program from binary
    #
    # ==== Attributes
    #
    # * +device_list+ - an Array of Device to create the program for. Can throw an OpenCL::Invalid value if the number of supplied devices is different from the number of supplied binaries.
    # * +binaries+ - Array of binaries 
    def create_program_with_binary( device_list, binaries)
       return OpenCL.create_program_with_binary(self, device_list, binaries)
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

    module OpenCL11
      extend InnerGenerator

      get_info("Context", :cl_uint, "num_devices")

      # Creates a user Event in the Context
      def create_user_event
        return OpenCL.create_user_event(self)
      end

    end


    module OpenCL12

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
      def create_from_gl_texture( texture_target, texture, options = {} )
        return OpenCL.create_from_gl_texture( self, texture_target, texture, options )
      end
      alias :create_from_GL_texture :create_from_gl_texture

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

      # Links a set of compiled programs for all device in the Context, or a subset of devices
      #
      # ==== Attributes
      #
      # * +input_programs+ - a single or an Array of Program
      # * +options+ - a Hash containing named options
      # * +block+ - if provided, a callback invoked when the Program is built. Signature of the callback is { |Program, Pointer to user_data| ... }
      #
      # ==== Options
      #
      # * +:device_list+ - an Array of Device to build the program for
      # * +:options+ - a String containing the options to use for the build
      # * +:user_data+ - a Pointer (or convertible to Pointer using to_ptr) to the memory area to pass to the callback
      def link_program( input_programs, options = {}, &block)
        return OpenCL.link_program(self, input_programs, options, &block)
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

    end

    module OpenCL20

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

    module OpenCL21

      # Create a Program from an intermediate level representation in the Context
      #
      # ==== Attributes
      #
      # * +il+ - a binary string containing the intermediate level representation of the program
      def create_program_with_il(il)
        return OpenCL.create_program_with_il(self, il)
      end

      # 
      def set_default_device_command_queue( device, command_queue )
        return OpenCL.set_default_device_command_queue( self, device, command_queue )
      end

    end

    module OpenCL30
      
      # Attaches a callback to context that will be called on context destruction
      #
      # ==== Attributes
      #
      # * +options+ - a hash containing named options
      # * +block+ - if provided, a callback invoked when program is released. Signature of the callback is { |Pointer to the context, Pointer to user_data| ... }
      #
      # ==== Options
      #
      # * +:user_data+ - a Pointer (or convertible to Pointer using to_ptr) to the memory area to pass to the callback
      def set_destructor_callback( options = {}, &block )
        OpenCL.set_context_destructor_callback( self, option, &block )
        return self
      end
    end

    register_extension( :v11, OpenCL11, "platform.version_number >= 1.1" )
    register_extension( :v12, OpenCL12, "platform.version_number >= 1.2" )
    register_extension( :v20, OpenCL20, "platform.version_number >= 2.0" )
    register_extension( :v21, OpenCL21, "platform.version_number >= 2.1" )
    register_extension( :v30, OpenCL30, "platform.version_number >= 3.0" )

  end

end


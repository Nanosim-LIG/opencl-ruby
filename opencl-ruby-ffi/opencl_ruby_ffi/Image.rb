module OpenCL

  # Creates an Image
  #
  # ==== Attributes
  #
  # * +context+ - Context the created Image will be associated to
  # * +format+ - an ImageFormat
  # * +options+ - an ImageDesc
  #
  # ==== Options
  # 
  # * +:flags+ - a single or an Array of :cl_mem_flags specifying the flags to be used when creating the Buffer
  # * +:host_ptr+ - if provided, the Pointer (or convertible to Pointer using to_ptr) to the memory area to use
  def self.create_image( context, format, desc, options = {} )
    flags = OpenCL.get_flags( options )
    host_ptr = options[:host_ptr]
    error = FFI::MemoryPointer.new( :cl_int )
    img_ptr = OpenCL.clCreateImage( context, flags, format, desc, host_ptr, error )
    OpenCL.error_check(error.read_cl_int)
    return Image::new(img_ptr, false)
  end

  # Creates a 1D Image
  #
  # ==== Attributes
  #
  # * +context+ - Context the created Image will be associated to
  # * +format+ - an ImageFormat
  # * +width+ - width of the image
  #
  # ==== Options
  # 
  # * +:flags+ - a single or an Array of :cl_mem_flags specifying the flags to be used when creating the Buffer
  # * +:host_ptr+ - if provided, the Pointer (or convertible to Pointer using to_ptr) to the memory area to use
  def self.create_image_1D( context, format, width, options )
    if context.platform.version_number > 1.1 then
      desc = OpenCL::ImageDesc::new(OpenCL::Mem::IMAGE1D, width, 0, 0, 0, 0, 0, 0, 0, nil)
      return OpenCL.create_image( context, format, desc, options )
    else
      OpenCL.error_check(OpenCL::Error::INVALID_OPERATION)
    end
  end

  # Creates a 2D Image
  #
  # ==== Attributes
  #
  # * +context+ - Context the created Image will be associated to
  # * +format+ - an ImageFormat
  # * +width+ - width of the image
  #
  # ==== Options
  # 
  # * +:flags+ - a single or an Array of :cl_mem_flags specifying the flags to be used when creating the Buffer
  # * +:host_ptr+ - if provided, the Pointer (or convertible to Pointer using to_ptr) to the memory area to use
  # * +:row_pitch+ - if provided the row_pitch of data in host_ptr
  def self.create_image_2D( context, format, width, height, options = {} )
    row_pitch = 0
    row_pitch = options[:row_pitch] if options[:row_pitch]
    if context.platform.version_number > 1.1 then
      desc = OpenCL::ImageDesc::new(OpenCL::Mem::IMAGE2D, width, height, 0, 0, row_pitch, 0, 0, 0, nil)
      return OpenCL.create_image( context, format, desc, options )
    end
    flags = OpenCL.get_flags( options )
    host_ptr = options[:host_ptr]
    error = FFI::MemoryPointer.new( :cl_int )
    img_ptr = OpenCL.clCreateImage2D( context, flags, format, width, heigh, row_pitch, host_ptr, error )
    OpenCL.error_check(error.read_cl_int)
    return Image::new(img_ptr, false)
  end

  # Creates a 3D Image
  #
  # ==== Attributes
  #
  # * +context+ - Context the created Image will be associated to
  # * +format+ - an ImageFormat
  # * +width+ - width of the image
  #
  # ==== Options
  # 
  # * +:flags+ - a single or an Array of :cl_mem_flags specifying the flags to be used when creating the Buffer
  # * +:host_ptr+ - if provided, the Pointer (or convertible to Pointer using to_ptr) to the memory area to use
  # * +:row_pitch+ - if provided the row_pitch of data in host_ptr
  # * +:slice_pitch+ - if provided the slice_pitch of data in host_ptr
  def self.create_image_3D( context, format, width, height, depth, options = {} )
    row_pitch = 0
    row_pitch = options[:row_pitch] if options[:row_pitch]
    slice_pitch = 0
    slice_pitch = options[:slice_pitch] if options[:slice_pitch]
    if context.platform.version_number > 1.1 then
      desc = OpenCL::ImageDesc::new(OpenCL::Mem::IMAGE3D, width, height, depth, 0, row_pitch, slice_pitch, 0, 0, nil)
      return OpenCL.create_image( context, format, desc, flags, data )
    end
    flags = OpenCL.get_flags( options )
    host_ptr = options[:host_ptr]
    error = FFI::MemoryPointer.new( :cl_int )
    img_ptr = OpenCL.clCreateImage3D( context, fs, format, width, heigh, depth, row_pitch, slice_pitch, d, error )
    OpenCL.error_check(error.read_cl_int)
    return Image::new(img_ptr, false)
  end

  # Creates an Image from an OpenGL render buffer
  #
  # ==== Attributes
  #
  # * +context+ - Context the created Image will be associated to
  # * +renderbuf+ - opengl render buffer
  # * +options+ - a hash containing named options
  #
  # ==== Options
  #
  # * +:flags+ - a single or an Array of :cl_mem_flags specifying the flags to be used when creating the Image (default OpenCL::Mem::READ_WRITE)
  def self.create_from_GL_render_buffer( context, renderbuffer, options = {} )
    flags = OpenCL.get_flags( options )
    error = FFI::MemoryPointer.new( :cl_int )
    img = OpenCL.clCreateFromGLRenderBuffer( context, flags, renderbuffer, error )
    OpenCL.error_check(error.read_cl_int)
    return Image::new( img, false )
  end

  # Creates an Image from an OpenGL texture
  #
  # ==== Attributes
  #
  # * +context+ - Context the created Image will be associated to
  # * +texture_target+ - a :GLenum defining the image type of texture
  # * +texture+ - a :GLuint specifying the name of the texture
  # * +options+ - a hash containing named options
  #
  # ==== Options
  #
  # * +:miplevel+ - a :GLint specifying the mipmap level to be used (default 0)
  # * +:flags+ - a single or an Array of :cl_mem_flags specifying the flags to be used when creating the Image (default OpenCL::Mem::READ_WRITE)
  def self.create_from_GL_texture( context, texture_target, texture, options = {} )
    if context.platform.version_number < 1.2 then
      OpenCL.error_check(OpenCL::INVALID_OPERATION)
    end
    flags = OpenCL.get_flags( options )
    miplevel = 0
    miplevel =  options[:miplevel] if options[:miplevel]
    error = FFI::MemoryPointer.new( :cl_int )
    img = OpenCL.clCreateFromGLTexture( context, flags, texture_target, miplevel, texture, error )
    OpenCL.error_check(error.read_cl_int)
    return Image::new( img, false )
  end

  # Creates an Image from an OpenGL 2D texture
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
  def self.create_from_GL_texture_2D( context, texture_target, texture, options = {} )
    if context.platform.version_number > 1.1 then
      return OpenCL.create_from_GL_texture( context, texture_target, texture, options )
    end
    flags = OpenCL.get_flags( options )
    miplevel = 0
    miplevel =  options[:miplevel] if options[:miplevel]
    error = FFI::MemoryPointer.new( :cl_int )
    img = OpenCL.clCreateFromGLTexture2D( context, flags, texture_target, miplevel, texture, error )
    OpenCL.error_check(error.read_cl_int)
    return Image::new( img, false )
  end

  # Creates an Image from an OpenGL 3D texture
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
  def self.create_from_GL_texture_3D( context, texture_target, texture, options = {} )
    if context.platform.version_number > 1.1 then
      return OpenCL.create_from_GL_texture( context, texture_target, texture, options )
    end
    flags = OpenCL.get_flags( options )
    miplevel = 0
    miplevel =  options[:miplevel] if options[:miplevel]
    error = FFI::MemoryPointer.new( :cl_int )
    img = OpenCL.clCreateFromGLTexture3D( context, flags, texture_target, miplevel, texture, error )
    OpenCL.error_check(error.read_cl_int)
    return Image::new( img, false )
  end

  # Maps the cl_mem OpenCL objects of type CL_MEM_OBJECT_IMAGE*
  class Image


    ##
    # :method: element_size
    # Returns the element_size of the Image

    ##
    # :method: row_pitch
    # Returns the row_pitch of the Image

    ##
    # :method: slice_pitch
    # Returns the slice_pitch of the Image

    ##
    # :method: width
    # Returns the width of the Image

    ##
    # :method: height
    # Returns the height of the Image

    ##
    # :method: depth
    # Returns the depth of the Image

    ##
    # :method: array_size
    # Returns the array_size of the Image
    %w( ELEMENT_SIZE ROW_PITCH SLICE_PITCH WIDTH HEIGHT DEPTH ARRAY_SIZE ).each { |prop|
      eval OpenCL.get_info("Image", :size_t, prop)
    }

    ##
    # :method: num_mip_levels
    # Returns the num_mip_levels of the Image

    ##
    # :method: num_samples
    # Returns the num_samples of the Image
    %w( NUM_MIP_LEVELS NUM_SAMPLES ).each { |prop|
      eval OpenCL.get_info("Image", :cl_uint, prop)
    }

    # Returns the ImageDesc corresponding to the Image
    def desc
      return ImageDesc::new( self.type, self.width, self.height, self.depth, self.array_size, self.row_pitch, self.slice_pitch, self.num_mip_levels, self.num_samples, self.buffer )
    end

    # Returns the ImageFormat corresponding to the image
    def format
      image_format = FFI::MemoryPointer.new( ImageFormat )
      error = OpenCL.clGetImageInfo( self, OpenCL::Image::FORMAT, image_format.size, image_format, nil)
      OpenCL.error_check(error)
      return OpenCL::ImageFormat::from_pointer( image_format )
    end

    # Returns the associated Buffer if any, nil otherwise
    def buffer
      ptr = FFI::MemoryPointer.new( OpenCL::Buffer )
      error = OpenCL.clGetImageInfo(self,  OpenCL::Image::BUFFER, OpenCL::Buffer.size, ptr, nil)
      OpenCL.error_check(error)
      return nil if ptr.null?
      return OpenCL::Buffer::new(ptr.read_pointer)
    end

  end

end


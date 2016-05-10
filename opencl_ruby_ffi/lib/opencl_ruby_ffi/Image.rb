using OpenCLRefinements if RUBY_VERSION.scan(/\d+/).collect(&:to_i).first >= 2
module OpenCL

  # Creates an Image
  #
  # ==== Attributes
  #
  # * +context+ - Context the created Image will be associated to
  # * +format+ - an ImageFormat
  # * +desc+ - an ImageDesc
  #
  # ==== Options
  # 
  # * +:flags+ - a single or an Array of :cl_mem_flags specifying the flags to be used when creating the Image
  # * +:host_ptr+ - if provided, the Pointer (or convertible to Pointer using to_ptr) to the memory area to use
  def self.create_image( context, format, desc, options = {} )
    flags = get_flags( options )
    host_ptr = options[:host_ptr]
    error = MemoryPointer::new( :cl_int )
    img_ptr = clCreateImage( context, flags, format, desc, host_ptr, error )
    error_check(error.read_cl_int)
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
  # * +:flags+ - a single or an Array of :cl_mem_flags specifying the flags to be used when creating the Image
  # * +:host_ptr+ - if provided, the Pointer (or convertible to Pointer using to_ptr) to the memory area to use
  def self.create_image_1d( context, format, width, options = {} )
    if context.platform.version_number > 1.1 then
      desc = ImageDesc::new(Mem::IMAGE1D, width, 0, 0, 0, 0, 0, 0, 0, nil)
      return create_image( context, format, desc, options )
    else
      error_check(INVALID_OPERATION)
    end
  end
  class << self
    alias :create_image_1D :create_image_1d
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
  # * +:flags+ - a single or an Array of :cl_mem_flags specifying the flags to be used when creating the Image
  # * +:host_ptr+ - if provided, the Pointer (or convertible to Pointer using to_ptr) to the memory area to use
  # * +:row_pitch+ - if provided the row_pitch of data in host_ptr
  def self.create_image_2d( context, format, width, height, options = {} )
    row_pitch = 0
    row_pitch = options[:row_pitch] if options[:row_pitch]
    if context.platform.version_number > 1.1 then
      desc = ImageDesc::new(Mem::IMAGE2D, width, height, 0, 0, row_pitch, 0, 0, 0, nil)
      return create_image( context, format, desc, options )
    end
    flags = get_flags( options )
    host_ptr = options[:host_ptr]
    error = MemoryPointer::new( :cl_int )
    img_ptr = clCreateImage2D( context, flags, format, width, height, row_pitch, host_ptr, error )
    error_check(error.read_cl_int)
    return Image::new(img_ptr, false)
  end
  class << self
    alias :create_image_2D :create_image_2d
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
  # * +:flags+ - a single or an Array of :cl_mem_flags specifying the flags to be used when creating the Image
  # * +:host_ptr+ - if provided, the Pointer (or convertible to Pointer using to_ptr) to the memory area to use
  # * +:row_pitch+ - if provided the row_pitch of data in host_ptr
  # * +:slice_pitch+ - if provided the slice_pitch of data in host_ptr
  def self.create_image_3d( context, format, width, height, depth, options = {} )
    row_pitch = 0
    row_pitch = options[:row_pitch] if options[:row_pitch]
    slice_pitch = 0
    slice_pitch = options[:slice_pitch] if options[:slice_pitch]
    if context.platform.version_number > 1.1 then
      desc = ImageDesc::new(Mem::IMAGE3D, width, height, depth, 0, row_pitch, slice_pitch, 0, 0, nil)
      return create_image( context, format, desc, flags, data )
    end
    flags = get_flags( options )
    host_ptr = options[:host_ptr]
    error = MemoryPointer::new( :cl_int )
    img_ptr = clCreateImage3D( context, fs, format, width, height, depth, row_pitch, slice_pitch, d, error )
    error_check(error.read_cl_int)
    return Image::new(img_ptr, false)
  end
  class << self
    alias :create_image_3D :create_image_3d
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
  # * +:flags+ - a single or an Array of :cl_mem_flags specifying the flags to be used when creating the Image
  def self.create_from_gl_renderbuffer( context, renderbuffer, options = {} )
    flags = get_flags( options )
    error = MemoryPointer::new( :cl_int )
    img = clCreateFromGLRenderbuffer( context, flags, renderbuffer, error )
    error_check(error.read_cl_int)
    return Image::new( img, false )
  end
  class << self
    alias :create_from_GL_renderbuffer :create_from_gl_renderbuffer
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
  # * +:flags+ - a single or an Array of :cl_mem_flags specifying the flags to be used when creating the Image
  def self.create_from_gl_texture( context, texture_target, texture, options = {} )
    if context.platform.version_number < 1.2 then
      error_check(INVALID_OPERATION)
    end
    flags = get_flags( options )
    miplevel = 0
    miplevel =  options[:miplevel] if options[:miplevel]
    error = MemoryPointer::new( :cl_int )
    img = clCreateFromGLTexture( context, flags, texture_target, miplevel, texture, error )
    error_check(error.read_cl_int)
    return Image::new( img, false )
  end
  class << self
    alias :create_from_GL_texture :create_from_gl_texture
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
  def self.create_from_gl_texture_2d( context, texture_target, texture, options = {} )
    if context.platform.version_number > 1.1 then
      return create_from_gl_texture( context, texture_target, texture, options )
    end
    flags = get_flags( options )
    miplevel = 0
    miplevel =  options[:miplevel] if options[:miplevel]
    error = MemoryPointer::new( :cl_int )
    img = clCreateFromGLTexture2D( context, flags, texture_target, miplevel, texture, error )
    error_check(error.read_cl_int)
    return Image::new( img, false )
  end
  class << self
    alias :create_from_GL_texture_2D :create_from_gl_texture_2d
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
  def self.create_from_gl_texture_3d( context, texture_target, texture, options = {} )
    if context.platform.version_number > 1.1 then
      return create_from_gl_texture( context, texture_target, texture, options )
    end
    flags = get_flags( options )
    miplevel = 0
    miplevel =  options[:miplevel] if options[:miplevel]
    error = MemoryPointer::new( :cl_int )
    img = clCreateFromGLTexture3D( context, flags, texture_target, miplevel, texture, error )
    error_check(error.read_cl_int)
    return Image::new( img, false )
  end
  class << self
    alias :create_from_GL_texture_3D :create_from_gl_texture_3d
  end

  # Maps the cl_mem OpenCL objects of type CL_MEM_OBJECT_IMAGE*
  class Image #< Mem

    def inspect
      h = height
      d = depth
      f = flags
      return "#<#{self.class.name}: #{format.channel_order}, #{format.channel_data_type}, #{width}#{h != 0 ? "x#{h}" : ""}#{d != 0 ? "x#{d}" : ""} (#{size})#{f.to_i != 0 ? " (#{f})" : "" }>"
    end

    # Returns the ImageFormat corresponding to the image
    def format
      image_format = MemoryPointer::new( ImageFormat )
      error = OpenCL.clGetImageInfo( self, FORMAT, image_format.size, image_format, nil)
      error_check(error)
      return ImageFormat::new( image_format )
    end

    get_info("Image", :size_t, "element_size")
    get_info("Image", :size_t, "row_pitch")
    get_info("Image", :size_t, "slice_pitch")
    get_info("Image", :size_t, "width")
    get_info("Image", :size_t, "height")
    get_info("Image", :size_t, "depth")

    module OpenCL12
      extend InnerGenerator

      get_info("Image", :size_t, "array_size")

      # Returns the associated Buffer if any, nil otherwise
      def buffer
        ptr = MemoryPointer::new( Buffer )
        error = OpenCL.clGetImageInfo(self,  BUFFER, Buffer.size, ptr, nil)
        error_check(error)
        return nil if ptr.null?
        return Buffer::new(ptr.read_pointer)
      end

      get_info("Image", :cl_uint, "num_mip_levels")
      get_info("Image", :cl_uint, "num_samples")

      # Returns the ImageDesc corresponding to the Image
      def desc
        return ImageDesc::new( self.type, self.width, self.height, self.depth, self.array_size, self.row_pitch, self.slice_pitch, self.num_mip_levels, self.num_samples, self.buffer )
      end

    end

    register_extension( :v12, OpenCL12, "platform.version_number >= 1.2" )

  end

end


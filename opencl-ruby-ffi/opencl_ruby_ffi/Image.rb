module OpenCL

  def self.create_image( context, format, desc, flags=OpenCL::Mem::READ_WRITE, data=nil )
    fs = 0
    if flags.kind_of?(Array) then
      flags.each { |f| fs = fs | f }
    else
      fs = flags
    end
    d = data
    if d and d.respond_to?(:to_ptr) then
      d = d.to_ptr
    end
    err_ptr = FFI::MemoryPointer.new( :cl_int )
    img_ptr = OpenCL.clCreateImage( context, fs, format, desc, d, err_ptr )
    OpenCL.error_check(err_ptr.read_cl_int)
    return Image::new(img_ptr)
  end

  def self.create_image_1D( context, format, width, flags=OpenCL::Mem::READ_WRITE, data=nil )
    if context.platform.version_number > 1.1 then
      desc = OpenCL::ImageDesc::new(OpenCL::Mem::IMAGE1D, width, 0, 0, 0, 0, 0, 0, 0, nil)
      return OpenCL.create_image( context, format, desc, flags, data )
    else
      OpenCL.error_check(OpenCL::Error::INVALID_OPERATION)
    end
  end

  def self.create_image_2D( context, format, width, height, row_pitch, flags=OpenCL::Mem::READ_WRITE, data=nil )
    if context.platform.version_number > 1.1 then
      desc = OpenCL::ImageDesc::new(OpenCL::Mem::IMAGE2D, width, height, 0, 0, row_pitch, 0, 0, 0, nil)
      return OpenCL.create_image( context, format, desc, flags, data )
    end
    fs = 0
    if flags.kind_of?(Array) then
      flags.each { |f| fs = fs | f }
    else
      fs = flags
    end
    d = data
    if d and d.respond_to?(:to_ptr) then
      d = d.to_ptr
    end
    err_ptr = FFI::MemoryPointer.new( :cl_int )
    img_ptr = OpenCL.clCreateImage2D( context, fs, format, width, heigh, row_pitch, d, err_ptr )
    OpenCL.error_check(err_ptr.read_cl_int)
    return Image::new(img_ptr)
  end

  def self.create_image_3D( context, format, width, height, depth, row_pitch, slice_pitch, flags=OpenCL::Mem::READ_WRITE, data=nil )
    if context.platform.version_number > 1.1 then
      desc = OpenCL::ImageDesc::new(OpenCL::Mem::IMAGE3D, width, height, depth, 0, row_pitch, slice_pitch, 0, 0, FFI::Pointer(nil))
      return OpenCL.create_image( context, format, desc, flags, data )
    end
    fs = 0
    if flags.kind_of?(Array) then
      flags.each { |f| fs = fs | f }
    else
      fs = flags
    end
    d = data
    if d and d.respond_to?(:to_ptr) then
      d = d.to_ptr
    end
    err_ptr = FFI::MemoryPointer.new( :cl_int )
    img_ptr = OpenCL.clCreateImage3D( context, fs, format, width, heigh, depth, row_pitch, slice_pitch, d, err_ptr )
    OpenCL.error_check(err_ptr.read_cl_int)
    return Image::new(img_ptr)
  end

  def self.create_from_GL_render_buffer( context, renderbuffer, flags=OpenCL::Mem::READ_WRITE )
    fs = 0
    if flags.kind_of?(Array) then
      flags.each { |f| fs = fs | f }
    else
      fs = flags
    end
    error = FFI::MemoryPointer.new( :cl_int )
    img = OpenCL.clCreateFromGLRenderBuffer( context, fs, renderbuffer, error )
    OpenCL.error_check(error.read_cl_int)
    return Image::new( img )
  end

  def self.create_from_GL_texture( context, texture_target, miplevel, texture, flags=OpenCL::Mem::READ_WRITE )
    if context.platform.version_number < 1.2 then
      OpenCL.error_check(OpenCL::INVALID_OPERATION)
    end
    fs = 0
    if flags.kind_of?(Array) then
      flags.each { |f| fs = fs | f }
    else
      fs = flags
    end
    error = FFI::MemoryPointer.new( :cl_int )
    img = OpenCL.clCreateFromGLTexture( context, fs, texture_target, miplevel, texture, error )
    OpenCL.error_check(error.read_cl_int)
    return Image::new( img )
  end

  def self.create_from_GL_texture_2D( context, texture_target, miplevel, texture, flags=OpenCL::Mem::READ_WRITE )
    if context.platform.version_number > 1.1 then
      return OpenCL.create_from_GL_texture( context, texture_target, miplevel, texture, flags )
    end
    fs = 0
    if flags.kind_of?(Array) then
      flags.each { |f| fs = fs | f }
    else
      fs = flags
    end
    error = FFI::MemoryPointer.new( :cl_int )
    img = OpenCL.clCreateFromGLTexture2D( context, fs, texture_target, miplevel, texture, error )
    OpenCL.error_check(error.read_cl_int)
    return Image::new( img )
  end

  def self.create_from_GL_texture_3D( context, texture_target, miplevel, texture, flags=OpenCL::Mem::READ_WRITE )
    if context.platform.version_number > 1.1 then
      return OpenCL.create_from_GL_texture( context, texture_target, miplevel, texture, flags )
    end
    fs = 0
    if flags.kind_of?(Array) then
      flags.each { |f| fs = fs | f }
    else
      fs = flags
    end
    error = FFI::MemoryPointer.new( :cl_int )
    img = OpenCL.clCreateFromGLTexture3D( context, fs, texture_target, miplevel, texture, error )
    OpenCL.error_check(error.read_cl_int)
    return Image::new( img )
  end

  class Image

    %w( ELEMENT_SIZE ROW_PITCH SLICE_PITCH WIDTH HEIGHT DEPTH ARRAY_SIZE ).each { |prop|
      eval OpenCL.get_info("Image", :size_t, prop)
    }

    %w( NUM_MIP_LEVELS NUM_SAMPLES ).each { |prop|
      eval OpenCL.get_info("Image", :cl_uint, prop)
    }

    def buffer
      ptr = FFI::MemoryPointer.new( OpenCL::Buffer )
      error = OpenCL.clGetImageInfo(self,  OpenCL::Image::BUFFER, OpenCL::Buffer.size, ptr, nil)
      OpenCL.error_check(error)
      return nil if ptr.null?
      return OpenCL::Buffer::new(ptr.read_pointer)
    end

  end

end


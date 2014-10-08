module OpenCL

  # Creates a Buffer
  #
  # ==== Attributes
  #
  # * +context+ - Context the created Buffer will be associated to
  # * +size+ - size of the Buffer to be created
  # * +options+ - a hash containing named options
  #
  # ==== Options
  # 
  # * +:flags+ - a single or an Array of :cl_mem_flags specifying the flags to be used when creating the Buffer
  # * +:host_ptr+ - if provided, the Pointer (or convertible to Pointer using to_ptr) to the memory area to use
  def self.create_buffer( context, size, options = {} )
    flags = get_flags( options )
    host_ptr = options[:host_ptr]
    error = FFI::MemoryPointer::new( :cl_int )
    buff = clCreateBuffer(context, flags, size, host_ptr, error)
    error_check(error.read_cl_int)
    return Buffer::new( buff, false )
  end

  # Creates a Buffer from a sub part of an existing Buffer
  #
  # ==== Attributes
  #
  # * +buffer+ - source Buffer
  # * +type+ - type of sub-buffer to create. Only OpenCL::BUFFER_CREATE_TYPE_REGION is supported for now
  # * +info+ - inf reguarding the type of sub-buffer created. if type == OpenCL::BUFFER_CREATE_TYPE_REGION, info is a BufferRegion
  # * +options+ - a hash containing named options
  #
  # ==== Options
  # 
  # * +:flags+ - a single or an Array of :cl_mem_flags specifying the flags to be used when creating the Buffer
  def self.create_sub_buffer( buffer, type, info, options = {} )
    error_check(INVALID_OPERATION) if buffer.platform.version_number < 1.1
    flags = get_flags( options )
    error = FFI::MemoryPointer::new( :cl_int )
    buff = clCreateSubBuffer( buffer, flags, type, info, error)
    error_check(error.read_cl_int)
    return Buffer::new( buff, false )
  end

  # Creates Buffer from an opengl buffer
  #
  # ==== Attributes
  #
  # * +context+ - Context the created Buffer will be associated to
  # * +bufobj+ - opengl buffer object
  # * +options+ - a hash containing named options
  #
  # ==== Options
  #
  # * +:flags+ - a single or an Array of :cl_mem_flags specifying the flags to be used when creating the Image
  def self.create_from_GL_buffer( context, bufobj, options = {} )
    flags = get_flags( options )
    error = FFI::MemoryPointer::new( :cl_int )
    buff = clCreateFromGLBuffer( context, flags, bufobj, error )
    error_check(error.read_cl_int)
    return Buffer::new( buff, false )
  end

  # Maps the cl_mem OpenCL object of type CL_MEM_OBJECT_BUFFER
  class Buffer < Mem
    layout :dummy, :pointer

    # Creates a Buffer from a sub part of the Buffer
    #
    # ==== Attributes
    #
    # * +info+ - inf reguarding the type of sub-buffer created. if type == OpenCL::BUFFER_CREATE_TYPE_REGION, info is a BufferRegion
    # * +tyep+ - type of sub-buffer to create. Only OpenCL::BUFFER_CREATE_TYPE_REGION is supported for now
    # * +options+ - a hash containing named options
    #
    # ==== Options
    # 
    # * :flags - a single or an Array of :cl_mem_flags specifying the flags to be used when creating the Buffer
    def create_sub_buffer( type, region, options = {} )
      OpenCL.create_sub_buffer( self, type, region, options )
    end
  end

end

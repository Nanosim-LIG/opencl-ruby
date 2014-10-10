module OpenCL

  # Attaches a callback to memobj the will be called on memobj destruction
  #
  # ==== Attributes
  #
  # * +memobj+ - the Mem to attach the callback to
  # * +options+ - a hash containing named options
  # * +block+ - if provided, a callback invoked when memobj is released. Signature of the callback is { |FFI::Poniter to the deleted Mem, FFI::Pointer to user_data| ... }
  #
  # ==== Options
  #
  # * +:user_data+ - a Pointer (or convertible to Pointer using to_ptr) to the memory area to pass to the callback
  def self.set_mem_object_destructor_callback( memobj, options = {}, &block )
    @@callbacks.push( block ) if block
    error = clSetMemObjectDestructorCallback( memobj, block, options[:user_data] )
    error_check(error)
    return self
  end

  # Maps the cl_mem object of OpenCL
  class Mem
    include InnerInterface

    class << self
      include InnerGenerator
    end

    # Returns the Context associated to the Mem
    def context
      ptr = FFI::MemoryPointer::new( Context )
      error = OpenCL.clGetMemObjectInfo(self, CONTEXT, Context.size, ptr, nil)
      error_check(error)
      return Context::new( ptr.read_pointer )
    end

    # Returns the Platform associated to the Mem
    def platform
      return self.context.platform
    end

    # Returns the Buffer this Buffer was created from using create_sub_buffer
    def associated_memobject
      ptr = FFI::MemoryPointer::new( Mem )
      error = OpenCL.clGetMemObjectInfo(self, ASSOCIATED_MEMOBJECT, Mem.size, ptr, nil)
      error_check(error)
      return nil if ptr.read_pointer.null?
      return Mem::new( ptr.read_pointer )
    end

    ##
    # :method: offset()
    # Returns the offset used to create this Buffer using create_sub_buffer

    ##
    # :method: size()
    # Returns the size of the Buffer
    %w( OFFSET SIZE ).each { |prop|
      eval get_info("Mem", :size_t, prop)
    }

    ##
    # :method: map_count()
    # Returns the number of times this Mem is mapped

    ##
    # :method: reference_count()
    # Returns the Mem reference counter
    %w( MAP_COUNT REFERENCE_COUNT ).each { |prop|
      eval get_info("Mem", :cl_uint, prop)
    }

    ##
    # :method: uses_svn_pointer()
    # Returns true if Mem uses an SVM pointer
    eval get_info("Mem", :cl_bool, "USES_SVM_POINTER")

    ##
    # :method: type()
    # Returns a Mem::Type corresponding to the Mem
    eval get_info("Mem", :cl_mem_object_type, "TYPE")

    ##
    # :method: flags()
    # Returns a Mem::Flags corresponding to the flags used at Mem creation
    eval get_info("Mem", :cl_mem_flags, "FLAGS")

    ##
    # :method: host_ptr()
    # Returns the host Pointer specified at Mem creation or the pointer + the ofsset if it is a sub-buffer. A null Pointer is returned otherwise.
    eval get_info("Mem", :pointer, "HOST_PTR")

    # Attaches a callback to memobj that will be called on the memobj destruction
    #
    # ==== Attributes
    #
    # * +options+ - a hash containing named options
    # * +block+ - if provided, a callback invoked when memobj is released. Signature of the callback is { |Mem, FFI::Pointer to user_data| ... }
    #
    # ==== Options
    #
    # * +:user_data+ - a Pointer (or convertible to Pointer using to_ptr) to the memory area to pass to the callback
    def set_destructor_callback( options = {}, &proc )
      OpenCL.set_mem_object_destructor_callback( self, options, &proc )
      return self
    end

    # Returns the texture_target argument specified in create_from_GL_texture for Mem
    def GL_texture_target
      param_value = FFI::MemoryPointer::new( :cl_GLenum )
      error = OpenCL.clGetGLTextureInfo( self, GL_TEXTURE_TARGET, param_value.size, param_value, nil )
      error_check(error)
      return param_value.read_cl_GLenum
    end

    # Returns the miplevel argument specified in create_from_GL_texture for Mem
    def GL_mimap_level
      param_value = FFI::MemoryPointer::new( :cl_GLint )
      error = OpenCL.clGetGLTextureInfo( self, GL_MIPMAP_LEVEL, param_value.size, param_value, nil )
      error_check(error)
      return param_value.read_cl_GLint
    end

    # Returns the type of the GL object associated with Mem
    def GL_object_type
      param_value = FFI::MemoryPointer::new( :cl_gl_object_type )
      error = OpenCL.clGetGLObjectInfo( self, param_value, nil )
      error_check(error)
      return GLObjectType::new(param_value.read_cl_gl_object_type)
    end

    # Returns the name of the GL object associated with Mem
    def GL_object_name
      param_value = FFI::MemoryPointer::new( :cl_GLuint )
      error = OpenCL.clGetGLObjectInfo( self, nil, param_value )
      error_check(error)
      return param_value.read_cl_GLuint
    end

  end

end

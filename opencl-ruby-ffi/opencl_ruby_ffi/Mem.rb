module OpenCL

  # Attach a callback the will be called on Mem destruction
  #
  # ==== Attributes
  #
  # * +memobj+ - the program to build
  # * +options+ - a hash containing named options
  # * +block+ - if provided, a callback invoked when error arise in the context. Signature of the callback is { |Program, FFI::Pointer to user_data| ... }
  #
  # ==== Options
  #
  # * +:user_data: - a Pointer (or convertible to Pointer using to_ptr) to the memory area to pass to the callback
  def self.set_mem_object_destructor_callback( memobj, options = {}, &proc )
    @@callbacks.push( block ) if block
    error = OpenCL.clSetMemObjectDestructorCallback( memobj, block, options[:user_data] )
    OpenCL.error_check(error)
    return self
  end

  # Maps the cl_mem object of OpenCL
  class Mem

    # Returns the Context associated to the Mem
    def context
      ptr = FFI::MemoryPointer.new( Context )
      error = OpenCL.clGetMemObjectInfo(self, Mem::CONTEXT, Context.size, ptr, nil)
      OpenCL.error_check(error)
      return OpenCL::Context::new( ptr.read_pointer )
    end

    # Returns the Platform associated to the Mem
    def platform
      return self.context.platform
    end

    # Returns the Buffer this Buffer was created from using create_sub_buffer
    def associated_memobject
      ptr = FFI::MemoryPointer.new( Mem )
      error = OpenCL.clGetMemObjectInfo(self, Mem::ASSOCIATED_MEMOBJECT, Mem.size, ptr, nil)
      OpenCL.error_check(error)
      return nil if ptr.read_pointer.null?
      return OpenCL::Mem::new( ptr.read_pointer )
    end

    ##
    # :method: offset()
    # Returns the offsetused to create this Buffer using create_sub_buffer

    ##
    # :method: size()
    # Returns the size of the Buffer
    %w( OFFSET SIZE ).each { |prop|
      eval OpenCL.get_info("Mem", :size_t, prop)
    }

    ##
    # :method: map_count()
    # Returns the number of times this Mem is mapped

    ##
    # :method: reference_count()
    # Returns the Mem reference counter
    %w( MAP_COUNT REFERENCE_COUNT ).each { |prop|
      eval OpenCL.get_info("Mem", :cl_uint, prop)
    }

    ##
    # :method: type()
    # Returns an OpenCL::Mem::Type corresponding to the Mem
    eval OpenCL.get_info("Mem", :cl_mem_object_type, "TYPE")

    ##
    # :method: flags()
    # Returns an OpenCL::Mem::Flags corresponding to the flags used at Mem creation
    eval OpenCL.get_info("Mem", :cl_mem_flags, "FLAGS")

    ##
    # :method: host_ptr()
    # Returns the host Pointer specified at Mem creation or the pointer + the ofsset if it is a sub-buffer. A null Pointer is returned otherwise.
    eval OpenCL.get_info("Mem", :pointer, "HOST_PTR")

    # Attach a callback the will be called on the Mem destruction
    #
    # ==== Attributes
    #
    # * +options+ - a hash containing named options
    # * +block+ - if provided, a callback invoked when error arise in the context. Signature of the callback is { |Program, FFI::Pointer to user_data| ... }
    #
    # ==== Options
    #
    # * +:user_data: - a Pointer (or convertible to Pointer using to_ptr) to the memory area to pass to the callback
    def set_destructor_callback( options = {}, &proc )
      return OpenCL.set_mem_object_destructor_callback( self, options, &proc )
    end

    def GL_texture_target
      param_value = MemoryPointer.new( :cl_GLenum )
      error = OpenCL.clGetGLTextureInfo( self, OpenCL::GL_TEXTURE_TARGET, param_value.size, param_value, nil )
      OpenCL.error_check(error)
      return param_value.read_cl_GLenum
    end

    def GL_mimap_level
      param_value = MemoryPointer.new( :cl_GLint )
      error = OpenCL.clGetGLTextureInfo( self, OpenCL::GL_MIPMAP_LEVEL, param_value.size, param_value, nil )
      OpenCL.error_check(error)
      return param_value.read_cl_GLint
    end

    def GL_object_type
      param_value = MemoryPointer.new( :cl_gl_object_type )
      error = OpenCL.clGetGLObjectInfo( self, param_value, nil )
      OpenCL.error_check(error)
      return OpenCL::GLObjectType(param_value.read_cl_gl_object_type)
    end

    def GL_object_name
      param_value = MemoryPointer.new( :cl_GLuint )
      error = OpenCL.clGetGLObjectInfo( self, nil, param_value )
      OpenCL.error_check(error)
      return param_value.read_cl_GLuint
    end

  end

end

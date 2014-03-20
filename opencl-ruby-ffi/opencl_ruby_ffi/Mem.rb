module OpenCL

  def self.set_mem_object_destructor_callback( memobj, user_data = nil, &proc )
    @@callbacks.push( block ) if block
    error = OpenCL.clSetMemObjectDestructorCallback( memobj, block, user_data )
    OpenCL.error_check(error)
    return self
  end

  class Mem

    def context
      ptr = FFI::MemoryPointer.new( Context )
      error = OpenCL.clGetMemObjectInfo(self, Mem::CONTEXT, Context.size, ptr, nil)
      OpenCL.error_check(error)
      return OpenCL::Context::new( ptr.read_pointer )
    end

    def platform
      return self.context.platform
    end

    def associated_memobject
      ptr = FFI::MemoryPointer.new( Mem )
      error = OpenCL.clGetMemObjectInfo(self, Mem::ASSOCIATED_MEMOBJECT, Mem.size, ptr, nil)
      OpenCL.error_check(error)
      return OpenCL::Context::new( ptr.read_pointer )
    end

    %w( OFFSET SIZE ).each { |prop|
      eval OpenCL.get_info("Mem", :size_t, prop)
    }

    %w( MAP_COUNT REFERENCE_COUNT ).each { |prop|
      eval OpenCL.get_info("Mem", :cl_uint, prop)
    }

    eval OpenCL.get_info("Mem", :cl_mem_object_type, "TYPE")

    eval OpenCL.get_info("Mem", :cl_mem_flags, "FLAGS")

    eval OpenCL.get_info("Mem", :pointer, "HOST_PTR")

    def set_destructor_callback( user_data = nil, &proc )
      return OpenCL.set_mem_object_destructor_callback( self, user_data, &proc )
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

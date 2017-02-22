using OpenCLRefinements if RUBY_VERSION.scan(/\d+/).collect(&:to_i).first >= 2
module OpenCL

  # Attaches a callback to memobj the will be called on memobj destruction
  #
  # ==== Attributes
  #
  # * +memobj+ - the Mem to attach the callback to
  # * +options+ - a hash containing named options
  # * +block+ - if provided, a callback invoked when memobj is released. Signature of the callback is { |Poniter to the deleted Mem, Pointer to user_data| ... }
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
    extend InnerGenerator

    def inspect
      f = flags
      return "#<#{self.class.name}: #{size}#{ 0 != f.to_i ? " (#{f})" : ""}>"
    end

    get_info("Mem", :cl_mem_object_type, "type")
    get_info("Mem", :cl_mem_flags, "flags")
    get_info("Mem", :size_t, "size")
    get_info("Mem", :pointer, "host_ptr")
    get_info("Mem", :cl_uint, "map_count")
    get_info("Mem", :cl_uint, "reference_count")

    # Returns the Context associated to the Mem
    def context
      ptr = MemoryPointer::new( Context )
      error = OpenCL.clGetMemObjectInfo(self, CONTEXT, Context.size, ptr, nil)
      error_check(error)
      return Context::new( ptr.read_pointer )
    end

    # Returns the Platform associated to the Mem
    def platform
      return self.context.platform
    end

    # Returns the texture_target argument specified in create_from_GL_texture for Mem
    def gl_texture_target
      param_value = MemoryPointer::new( :cl_GLenum )
      error = OpenCL.clGetGLTextureInfo( self, GL_TEXTURE_TARGET, param_value.size, param_value, nil )
      error_check(error)
      return param_value.read_cl_GLenum
    end
    alias :GL_texture_target :gl_texture_target

    # Returns the miplevel argument specified in create_from_GL_texture for Mem
    def gl_mimap_level
      param_value = MemoryPointer::new( :cl_GLint )
      error = OpenCL.clGetGLTextureInfo( self, GL_MIPMAP_LEVEL, param_value.size, param_value, nil )
      error_check(error)
      return param_value.read_cl_GLint
    end
    alias :GL_mimap_level :gl_mimap_level

    # Returns the type of the GL object associated with Mem
    def gl_object_type
      param_value = MemoryPointer::new( :cl_gl_object_type )
      error = OpenCL.clGetGLObjectInfo( self, param_value, nil )
      error_check(error)
      return GLObjectType::new(param_value.read_cl_gl_object_type)
    end
    alias :GL_object_type :gl_object_type

    # Returns the name of the GL object associated with Mem
    def gl_object_name
      param_value = MemoryPointer::new( :cl_GLuint )
      error = OpenCL.clGetGLObjectInfo( self, nil, param_value )
      error_check(error)
      return param_value.read_cl_GLuint
    end
    alias :GL_object_name :gl_object_name

    module OpenCL11
      extend InnerGenerator

      get_info("Mem", :size_t, "offset")

      # Returns the Buffer this Buffer was created from using create_sub_buffer
      def associated_memobject
        ptr = MemoryPointer::new( Mem )
        error = OpenCL.clGetMemObjectInfo(self, ASSOCIATED_MEMOBJECT, Mem.size, ptr, nil)
        error_check(error)
        return nil if ptr.read_pointer.null?
        return Mem::new( ptr.read_pointer )
      end

      # Attaches a callback to memobj that will be called on the memobj destruction
      #
      # ==== Attributes
      #
      # * +options+ - a hash containing named options
      # * +block+ - if provided, a callback invoked when memobj is released. Signature of the callback is { |Mem, Pointer to user_data| ... }
      #
      # ==== Options
      #
      # * +:user_data+ - a Pointer (or convertible to Pointer using to_ptr) to the memory area to pass to the callback
      def set_destructor_callback( options = {}, &proc )
        OpenCL.set_mem_object_destructor_callback( self, options, &proc )
        return self
      end

    end

    module OpenCL20
      extend InnerGenerator

      get_info("Mem", :cl_bool, "uses_svm_pointer")

    end

    register_extension( :v11,  OpenCL11, "platform.version_number >= 1.1" )
    register_extension( :v20,  OpenCL20, "platform.version_number >= 2.0" )

  end

end

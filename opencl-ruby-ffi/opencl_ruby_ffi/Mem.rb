module OpenCL

  class Mem

    def context
      ptr = FFI::MemoryPointer.new( Context )
      error = OpenCL.clGetMemObjectInfo(self, Mem::CONTEXT, Context.size, ptr, nil)
      OpenCL.error_check(error)
      return OpenCL::Context::new( ptr.read_pointer )
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

    def type_name
      t = self.type
      %w( BUFFER IMAGE2D IMAGE3D IMAGE2D_ARRAY IMAGE1D IMAGE1D_ARRAY IMAGE1D_BUFFER ).each { |l_m_t|
        return l_m_t if OpenCL::Mem.const_get(l_m_t) == t
      }
    end

    eval OpenCL.get_info("Mem", :cl_mem_flags, "FLAGS")

    def flags_names
      fs = self.flags
      flag_names = []
      %w( READ_WRITE WRITE_ONLY READ_ONLY USE_HOST_PTR ALLOC_HOST_PTR COPY_HOST_PTR ).each { |f|
        flag_names.push(f) unless ( OpenCL::Mem.const_get(f) & fs ) == 0
      }
      return flag_names
    end

    eval OpenCL.get_info("Mem", :pointer, "HOST_PTR")

    def self.release(ptr)
      OpenCL.clRealeaseMemObject(self)
    end
  end

end

module OpenCL

  def OpenCL.create_kernel(program, name)
    pointer_err = FFI::MemoryPointer.new( :cl_int )
    kernel_ptr = OpenCL.clCreateKernel(program, name, pointer_err)
    OpenCL.error_check(pointer_err.read_cl_int)
    return OpenCL::Kernel::new( kernel_ptr )
  end

#  def OpenCL.kernel_set_arg( kernel, index, value, size = nil )
#    sz = size
#    
#    error = OpenCL.clSetKernelArg( kernel, index, 
#  end

  class Kernel
    class Arg
      attr_reader :index
      attr_reader :kernel
      def initialize( kernel, index )
        @index = index
        @kernel = kernel
      end

      def address_qualifier
        ptr = FFI::MemoryPointer.new( :cl_kernel_arg_address_qualifier )
        error = OpenCL.clGetKernelArgInfo(@kernel, @index, OpenCL::Kernel::Arg::Address::QUALIFIER, ptr.size, ptr, nil)
        OpenCL.error_check(error)
        return ptr.read_cl_kernel_arg_address_qualifier
      end

      def address_qualifier_name
        qualifier = self.address_qualifier
        %w( GLOBAL LOCAL CONSTANT PRIVATE ).each { |addr_q|
          return addr_q if OpenCL::Kernel::Arg::Address.const_get(addr_q) == qualifier
        }
      end

      def access_qualifier
        ptr = FFI::MemoryPointer.new( :cl_kernel_arg_access_qualifier )
        error = OpenCL.clGetKernelArgInfo(@kernel, @index, OpenCL::Kernel::Arg::Access::QUALIFIER, ptr.size, ptr, nil)
        OpenCL.error_check(error)
        return ptr.read_cl_kernel_arg_access_qualifier
      end

      def access_qualifier_name
        qualifier = self.access_qualifier
        %w( READ_ONLY WRITE_ONLY READ_WRITE NONE ).each { |acc_q|
          return acc_q if OpenCL::Kernel::Arg::Access.const_get(acc_q) == qualifier
        }
      end

      def type_qualifier
        ptr = FFI::MemoryPointer.new( :cl_kernel_arg_type_qualifier )
        error = OpenCL.clGetKernelArgInfo(@kernel, @index, OpenCL::Kernel::Arg::Type::QUALIFIER, ptr.size, ptr, nil)
        OpenCL.error_check(error)
        return ptr.read_cl_kernel_arg_type_qualifier
      end

      def type_qualifier_name
        qualifier = self.type_qualifier
        qualifier_names = []
        %w( RESTRICT VOLATILE CONST NONE ).each { |qual|
          qualifier_names.push(qual) unless ( OpenCL::Kernel::Arg::Type.const_get(qual) & qualifier ) == 0
        }
        return qualifier_names
      end

      def type_name
        ptr1 = FFI::MemoryPointer.new( :size_t, 1)
        error = OpenCL.clGetKernelArgInfo(@kernel, @index, OpenCL::Kernel::Arg::Type::NAME, 0, nil, ptr1)
        OpenCL.error_check(error)
        ptr2 = FFI::MemoryPointer.new( ptr1.read_size_t )
        error = OpenCL.clGetKernelArgInfo(@kernel, @index, OpenCL::Kernel::Arg::Type::NAME, ptr1.read_size_t, ptr2, nil)
        OpenCL.error_check(error)
        return ptr2.read_string
      end

      def name
        ptr1 = FFI::MemoryPointer.new( :size_t, 1)
        error = OpenCL.clGetKernelArgInfo(@kernel, @index, OpenCL::Kernel::Arg::NAME, 0, nil, ptr1)
        OpenCL.error_check(error)
        ptr2 = FFI::MemoryPointer.new( ptr1.read_size_t )
        error = OpenCL.clGetKernelArgInfo(@kernel, @index, OpenCL::Kernel::Arg::NAME, ptr1.read_size_t, ptr2, nil)
        OpenCL.error_check(error)
        return ptr2.read_string
      end

    end

    def args
      n = self.num_args
      a = []
      n.times { |i|
        a.push OpenCL::Kernel::Arg::new(self, i)
      }
      return a
    end

    %w( FUNCTION_NAME ATTRIBUTES ).each { |prop|
      eval OpenCL.get_info("Kernel", :string, prop)
    }

    %w( NUM_ARGS REFERENCE_COUNT ).each { |prop|
      eval OpenCL.get_info("Kernel", :cl_uint, prop)
    }

    def context
      ptr = FFI::MemoryPointer.new( Context )
      error = OpenCL.clGetKernelInfo(self, Kernel::CONTEXT, Context.size, ptr, nil)
      OpenCL.error_check(error)
      return OpenCL::Context::new( ptr.read_pointer )
    end

    def program
      ptr = FFI::MemoryPointer.new( Program )
      error = OpenCL.clGetKernelInfo(self, Kernel::PROGRAM, Program.size, ptr, nil)
      OpenCL.error_check(error)
      return OpenCL::Program.new(ptr.read_pointer)
    end

    %w( NUM_DEVICES REFERENCE_COUNT ).each { |prop|
      eval OpenCL.get_info("Program", :cl_uint, prop)
    }
    def self.release(ptr)
      OpenCL.clReleaseKernel(self)
    end
  end

end

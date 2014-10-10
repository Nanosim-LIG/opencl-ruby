module OpenCL

  # Creates an Array of Kernel corresponding to the kernels defined inside the Program
  def self.create_kernels_in_program( program )
    num_ptr = FFI::MemoryPointer::new( :cl_uint )
    error = clCreateKernelsInProgram( program, 0, nil, num_ptr )
    error_check(error)
    num_kernels = num_ptr.read_cl_uint
    kernels_ptr = FFI::MemoryPointer::new( Kernel, num_kernels )
    error =  clCreateKernelsInProgram( program, num_kernels, kernels_ptr, 0 )
    error_check(error)
    return kernels_ptr.get_array_of_pointer(0, num_kernels).collect { |kernel_ptr|
      Kernel::new(kernel_ptr, false)
    }
  end

  # Returns the Kernel corresponding the the specified name in the given Program
  def self.create_kernel(program, name)
    error = FFI::MemoryPointer::new( :cl_int )
    kernel_ptr = clCreateKernel(program, name, error)
    error_check(error.read_cl_int)
    return Kernel::new( kernel_ptr, false )
  end

  # Set the index th argument of Kernel to value. size of value can be specified
  def self.set_kernel_arg( kernel, index, value, size = nil )
    sz = size
    sz = value.class.size if sz == nil
    val = value
    if value.kind_of?(Mem) then
      val = FFI::MemoryPointer::new( Mem )
      val.write_pointer(value.to_ptr)
    end
    error = clSetKernelArg( kernel, index, sz, val )
    error_check(error)
  end

  # Maps the cl_kernel object
  class Kernel
    include InnerInterface

    class << self
      include InnerGenerator
    end

    # Maps the logical cl arg object
    class Arg
      include InnerInterface
 
      class << self
        include InnerGenerator
      end
      # Returns the index of the Arg in the list
      attr_reader :index
      # Returns the Kernel this Arg belongs to
      attr_reader :kernel

      # Creates a new arg for a Kernel at index
      def initialize( kernel, index )
        @index = index
        @kernel = kernel
      end

      # Returns an AddressQualifier corresponding to the Arg
      def address_qualifier
        error_check(INVALID_OPERATION) if @kernel.context.platform.version_number < 1.2
        ptr = FFI::MemoryPointer::new( :cl_kernel_arg_address_qualifier )
        error = OpenCL.clGetKernelArgInfo(@kernel, @index, ADDRESS_QUALIFIER, ptr.size, ptr, nil)
        error_check(error)
        return AddressQualifier::new( ptr.read_cl_kernel_arg_address_qualifier )
      end

      # Returns an AccessQualifier corresponding to the Arg
      def access_qualifier
        error_check(INVALID_OPERATION) if @kernel.context.platform.version_number < 1.2
        ptr = FFI::MemoryPointer::new( :cl_kernel_arg_access_qualifier )
        error = OpenCL.clGetKernelArgInfo(@kernel, @index, ACCESS_QUALIFIER, ptr.size, ptr, nil)
        error_check(error)
        return AccessQualifier::new( ptr.read_cl_kernel_arg_access_qualifier )
      end

      # Returns a TypeQualifier corresponding to the Arg
      def type_qualifier
        error_check(INVALID_OPERATION) if @kernel.context.platform.version_number < 1.2
        ptr = FFI::MemoryPointer::new( :cl_kernel_arg_type_qualifier )
        error = OpenCL.clGetKernelArgInfo(@kernel, @index, TYPE_QUALIFIER, ptr.size, ptr, nil)
        error_check(error)
        return TypeQualifier::new( ptr.read_cl_kernel_arg_type_qualifier )
      end

      # Returns a String corresponding to the Arg type name
      def type_name
        error_check(INVALID_OPERATION) if @kernel.context.platform.version_number < 1.2
        ptr1 = FFI::MemoryPointer::new( :size_t, 1)
        error = OpenCL.clGetKernelArgInfo(@kernel, @index, TYPE_NAME, 0, nil, ptr1)
        error_check(error)
        ptr2 = FFI::MemoryPointer::new( ptr1.read_size_t )
        error = OpenCL.clGetKernelArgInfo(@kernel, @index, TYPE_NAME, ptr1.read_size_t, ptr2, nil)
        error_check(error)
        return ptr2.read_string
      end

      # Returns a String corresponding to the Arg name
      def name
        error_check(INVALID_OPERATION) if @kernel.context.platform.version_number < 1.2
        ptr1 = FFI::MemoryPointer::new( :size_t, 1)
        error = OpenCL.clGetKernelArgInfo(@kernel, @index, NAME, 0, nil, ptr1)
        error_check(error)
        ptr2 = FFI::MemoryPointer::new( ptr1.read_size_t )
        error = OpenCL.clGetKernelArgInfo(@kernel, @index, NAME, ptr1.read_size_t, ptr2, nil)
        error_check(error)
        return ptr2.read_string
      end

      # Sets this Arg to value. The size of value can be specified.
      def set(value, size = nil)
        if value.class == SVMPointer and @kernel.context.platform.version_number >= 2.0 then
          OpenCL.set_kernel_arg_svm_pointer( @kernel, @index, value )
        else
          OpenCL.set_kernel_arg(@kernel, @index, value, size)
        end
      end

    end

    # Returns an Array of Arg corresponding to the arguments of the Kernel
    def args
      n = self.num_args
      a = []
      n.times { |i|
        a.push Arg::new(self, i)
      }
      return a
    end

    # Specifies the list of SVM pointers the kernel will be using
    def set_svm_ptrs( ptrs )
      error_check(INVALID_OPERATION) if self.context.platform.version_number < 2.0
      pointers = [ptrs].flatten
      pt = FFI::MemoryPointer::new( :pointer, pointers.length )
      pointers.each_with_index { |p, i|
        pt[i].write_pointer(p)
      }
      error = OpenCL.clSetKernelExecInfo( self, EXEC_INFO_SVM_PTRS, pt.size, pt)
      error_check(error)
      return self
    end

    # Specifies the granularity of the SVM system.
    def set_svm_fine_grain_system( flag )
      error_check(INVALID_OPERATION) if self.context.platform.version_number < 2.0
      pt = FFI::MemoryPointer::new(  :cl_bool )
      pt.write_cl_bool( flag )
      error = OpenCL.clSetKernelExecInfo( self, EXEC_INFO_SVM_FINE_GRAIN_SYSTEL, pt.size, pt)
      error_check(error)
      return self
    end

    ##
    # :method: function_name()
    # returns a String correspondig to the Kernel function name

    ##
    # :method: attributes()
    # returns a String containing the attributes qualifier used at kernel definition
    %w( FUNCTION_NAME ATTRIBUTES ).each { |prop|
      eval get_info("Kernel", :string, prop)
    }

    alias name function_name

    ##
    # :method: num_args()
    # Returns the number of arguments for the Kernel

    ##
    # :method: reference_count
    # Returns the reference counter for the Kernel
    %w( NUM_ARGS REFERENCE_COUNT ).each { |prop|
      eval get_info("Kernel", :cl_uint, prop)
    }

    # Returns the Context the Kernel is associated with
    def context
      ptr = FFI::MemoryPointer::new( Context )
      error = OpenCL.clGetKernelInfo(self, CONTEXT, Context.size, ptr, nil)
      error_check(error)
      return Context::new( ptr.read_pointer )
    end

    # Returns the Program the Kernel was created from
    def program
      ptr = FFI::MemoryPointer::new( Program )
      error = OpenCL.clGetKernelInfo(self, PROGRAM, Program.size, ptr, nil)
      error_check(error)
      return Program::new(ptr.read_pointer)
    end

    # Set the index th argument of the Kernel to value. The size of value can be specified.
    def set_arg(index, value, size = nil)
      OpenCL.set_kernel_arg(self, index, value, size)
    end

    # Set the index th argument of the Kernel to an svm pointer value.
    def set_arg_svm_pointer(index, svm_pointer)
      OpenCL.set_kernel_arg_svm_pointer(self, index, svm_pointer)
    end

    # Enqueues the Kernel in the given queue, specifying the global_work_size. Arguments for the kernel are specified afterwards. Last, a hash containing options for enqueuNDrange kernel can be specified
    def enqueue_with_args(command_queue, global_work_size, *args)
      n = self.num_args
      error_check(INVALID_KERNEL_ARGS) if args.length < n
      error_check(INVALID_KERNEL_ARGS) if args.length > n + 1
      if args.length == n + 1
        options = args.last
      else
        options = {}
      end
      n.times { |i|
        if args[i].class == SVMPointer and self.context.platform.version_number >= 2.0 then
          self.set_arg_svm_pointer(i, args[i])
        else
          self.set_arg(i, args[i])
        end
      }
      command_queue.enqueue_NDrange_kernel(self, global_work_size, options)
    end

  end

end

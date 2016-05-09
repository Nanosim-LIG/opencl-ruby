using OpenCLRefinements if RUBY_VERSION.scan(/\d+/).collect(&:to_i).first >= 2
module OpenCL

  # Creates an Array of Kernel corresponding to the kernels defined inside the Program
  def self.create_kernels_in_program( program )
    num_ptr = MemoryPointer::new( :cl_uint )
    error = clCreateKernelsInProgram( program, 0, nil, num_ptr )
    error_check(error)
    num_kernels = num_ptr.read_cl_uint
    kernels_ptr = MemoryPointer::new( Kernel, num_kernels )
    error =  clCreateKernelsInProgram( program, num_kernels, kernels_ptr, nil )
    error_check(error)
    return kernels_ptr.get_array_of_pointer(0, num_kernels).collect { |kernel_ptr|
      Kernel::new(kernel_ptr, false)
    }
  end

  # Returns the Kernel corresponding the the specified name in the given Program
  def self.create_kernel(program, name)
    error = MemoryPointer::new( :cl_int )
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
      val = MemoryPointer::new( Mem )
      val.write_pointer(value.to_ptr)
    end
    error = clSetKernelArg( kernel, index, sz, val )
    error_check(error)
  end

  def self.clone_kernel( kernel )
    error_check(INVALID_OPERATION) if kernel.context.platform.version_number < 2.1
    error = MemoryPointer::new( :cl_int )
    kernel_ptr = clCloneKernel( kernel, error )
    error_check(error.read_cl_int)
    return Kernel::new( kernel_ptr, false )
  end

  # Maps the cl_kernel object
  class Kernel
    include InnerInterface

    class << self
      include InnerGenerator
    end

    def inspect
      return "#<#{self.class.name}: #{name}>"
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

      if ExtendedStruct::FORCE_EXTENSIONS_LOADING then

        def self.register_extension(name, mod, cond)
          include mod
        end

        # Creates a new arg for a Kernel at index
        def initialize( kernel, index )
          @index = index
          @kernel = kernel
        end

      else

        Extensions = {}

        def self.register_extension(name, mod, cond)
          Extensions[name] = [mod, cond]
        end

        # Creates a new arg for a Kernel at index
        def initialize( kernel, index )
          @index = index
          @kernel = kernel
          Extensions.each { |name, ext|
            extend ext[0] if eval(ext[1])
          }
        end

      end
      # Sets this Arg to value. The size of value can be specified.
      def set(value, size = nil)
        if value.class == SVMPointer and @kernel.context.platform.version_number >= 2.0 then
          OpenCL.set_kernel_arg_svm_pointer( @kernel, @index, value )
        else
          OpenCL.set_kernel_arg(@kernel, @index, value, size)
        end
      end

      module OpenCL12

        # Returns an AddressQualifier corresponding to the Arg
        def address_qualifier
          error_check(INVALID_OPERATION) if @kernel.context.platform.version_number < 1.2
          ptr = MemoryPointer::new( :cl_kernel_arg_address_qualifier )
          error = OpenCL.clGetKernelArgInfo(@kernel, @index, ADDRESS_QUALIFIER, ptr.size, ptr, nil)
          error_check(error)
          return AddressQualifier::new( ptr.read_cl_kernel_arg_address_qualifier )
        end

        # Returns an AccessQualifier corresponding to the Arg
        def access_qualifier
          error_check(INVALID_OPERATION) if @kernel.context.platform.version_number < 1.2
          ptr = MemoryPointer::new( :cl_kernel_arg_access_qualifier )
          error = OpenCL.clGetKernelArgInfo(@kernel, @index, ACCESS_QUALIFIER, ptr.size, ptr, nil)
          error_check(error)
          return AccessQualifier::new( ptr.read_cl_kernel_arg_access_qualifier )
        end

        # Returns a String corresponding to the Arg type name
        def type_name
          error_check(INVALID_OPERATION) if @kernel.context.platform.version_number < 1.2
          ptr1 = MemoryPointer::new( :size_t, 1)
          error = OpenCL.clGetKernelArgInfo(@kernel, @index, TYPE_NAME, 0, nil, ptr1)
          error_check(error)
          ptr2 = MemoryPointer::new( ptr1.read_size_t )
          error = OpenCL.clGetKernelArgInfo(@kernel, @index, TYPE_NAME, ptr1.read_size_t, ptr2, nil)
          error_check(error)
          return ptr2.read_string
        end

        # Returns a TypeQualifier corresponding to the Arg
        def type_qualifier
          error_check(INVALID_OPERATION) if @kernel.context.platform.version_number < 1.2
          ptr = MemoryPointer::new( :cl_kernel_arg_type_qualifier )
          error = OpenCL.clGetKernelArgInfo(@kernel, @index, TYPE_QUALIFIER, ptr.size, ptr, nil)
          error_check(error)
          return TypeQualifier::new( ptr.read_cl_kernel_arg_type_qualifier )
        end

        # Returns a String corresponding to the Arg name
        def name
          error_check(INVALID_OPERATION) if @kernel.context.platform.version_number < 1.2
          ptr1 = MemoryPointer::new( :size_t, 1)
          error = OpenCL.clGetKernelArgInfo(@kernel, @index, NAME, 0, nil, ptr1)
          error_check(error)
          ptr2 = MemoryPointer::new( ptr1.read_size_t )
          error = OpenCL.clGetKernelArgInfo(@kernel, @index, NAME, ptr1.read_size_t, ptr2, nil)
          error_check(error)
          return ptr2.read_string
        end

      end

      register_extension( :v12, OpenCL12, "kernel.context.platform.version_number >= 1.2" )

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

    ##
    # :method: function_name()
    # returns a String correspondig to the Kernel function name

    eval get_info("Kernel", :string, "FUNCTION_NAME")

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
      ptr = MemoryPointer::new( Context )
      error = OpenCL.clGetKernelInfo(self, CONTEXT, Context.size, ptr, nil)
      error_check(error)
      return Context::new( ptr.read_pointer )
    end

    # Returns the Program the Kernel was created from
    def program
      ptr = MemoryPointer::new( Program )
      error = OpenCL.clGetKernelInfo(self, PROGRAM, Program.size, ptr, nil)
      error_check(error)
      return Program::new(ptr.read_pointer)
    end

    def work_group_size(device = program.devices.first)
      ptr = MemoryPointer::new( :size_t )
      error = OpenCL.clGetKernelWorkGroupInfo(self, device, WORK_GROUP_SIZE, ptr.size, ptr, nil)
      error_check(error)
      return ptr.read_size_t
    end

    def compile_work_group_size(device = program.devices.first)
      ptr = MemoryPointer::new( :size_t, 3 )
      error = OpenCL.clGetKernelWorkGroupInfo(self, device, COMPILE_WORK_GROUP_SIZE, ptr.size, ptr, nil)
      error_check(error)
      return ptr.get_array_of_size_t(0,3)
    end

    def local_mem_size(device = program.devices.first)
      ptr = MemoryPointer::new( :cl_ulong )
      error = OpenCL.clGetKernelWorkGroupInfo(self, device, LOCAL_MEM_SIZE, ptr.size, ptr, nil)
      error_check(error)
      return ptr.read_cl_ulong
    end

    # Set the index th argument of the Kernel to value. The size of value can be specified.
    def set_arg(index, value, size = nil)
      OpenCL.set_kernel_arg(self, index, value, size)
    end

    # Enqueues the Kernel in the given queue, specifying the global_work_size. Arguments for the kernel are specified afterwards. Last, a hash containing options for enqueu_ndrange kernel can be specified
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
        self.set_arg(i, args[i])
      }
      command_queue.enqueue_ndrange_kernel(self, global_work_size, options)
    end

    module OpenCL11

      def preferred_work_group_size_multiple(device = program.devices.first)
        ptr = MemoryPointer::new( :size_t )
        error = OpenCL.clGetKernelWorkGroupInfo(self, device, PREFERRED_WORK_GROUP_SIZE_MULTIPLE, ptr.size, ptr, nil)
        error_check(error)
        return ptr.read_size_t
      end

      def private_mem_size(device = program.devices.first)
        ptr = MemoryPointer::new( :cl_ulong )
        error = OpenCL.clGetKernelWorkGroupInfo(self, device, PRIVATE_MEM_SIZE, ptr.size, ptr, nil)
        error_check(error)
        return ptr.read_cl_ulong
      end

    end

    module OpenCL12

      ##
      # returns a String containing the attributes qualifier used at kernel definition
      def attributes
        attributes_size = MemoryPointer::new( :size_t )
        error = OpenCL.clGetKernelInfo( self, ATTRIBUTES, 0, nil, attributes_size)
        error_check(error)
        attr = MemoryPointer::new( attributes_size.read_size_t )
        error = OpenCL.clGetKernelInfo( self, ATTRIBUTES, attributes_size.read_size_t, attr, nil)
        error_check(error)
        attr_string = attr.read_string
        return attr_string.split(" ")
      end

      def global_work_size(device = program.devices.first)
        ptr = MemoryPointer::new( :size_t, 3 )
        error = OpenCL.clGetKernelWorkGroupInfo(self, device, GLOBAL_WORK_SIZE, ptr.size, ptr, nil)
        error_check(error)
        return ptr.get_array_of_size_t(0,3)
      end

    end

    module OpenCL20

      # Specifies the list of SVM pointers the kernel will be using
      def set_svm_ptrs( ptrs )
        error_check(INVALID_OPERATION) if self.context.platform.version_number < 2.0
        pointers = [ptrs].flatten
        pt = MemoryPointer::new( :pointer, pointers.length )
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
        pt = MemoryPointer::new(  :cl_bool )
        pt.write_cl_bool( flag )
        error = OpenCL.clSetKernelExecInfo( self, EXEC_INFO_SVM_FINE_GRAIN_SYSTEM, pt.size, pt)
        error_check(error)
        return self
      end

      # Set the index th argument of the Kernel to an svm pointer value.
      def set_arg_svm_pointer(index, svm_pointer)
        OpenCL.set_kernel_arg_svm_pointer(self, index, svm_pointer)
      end

      # Enqueues the Kernel in the given queue, specifying the global_work_size. Arguments for the kernel are specified afterwards. Last, a hash containing options for enqueu_ndrange kernel can be specified
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
        command_queue.enqueue_ndrange_kernel(self, global_work_size, options)
      end

    end

    module OpenCL21

      def max_num_sub_groups(device = program.devices.first)
        error_check(INVALID_OPERATION) if self.context.platform.version_number < 2.1
        ptr = MemoryPointer::new( :size_t )
        error = OpenCL.clGetKernelSubGroupInfo(self, device, MAX_NUM_SUB_GROUPS, 0, nil, ptr.size, ptr, nil)
        error_check(error)
        return ptr.read_size_t
      end

      def compile_num_sub_groups(device = program.devices.first)
        error_check(INVALID_OPERATION) if self.context.platform.version_number < 2.1
        ptr = MemoryPointer::new( :size_t )
        error = OpenCL.clGetKernelSubGroupInfo(self, device, COMPILE_NUM_SUB_GROUPS, 0, nil, ptr.size, ptr, nil)
        error_check(error)
        return ptr.read_size_t
      end

      def max_sub_group_size_for_ndrange(local_work_size, device = program.devices.first)
        error_check(INVALID_OPERATION) if self.context.platform.version_number < 2.1
        local_work_size = [local_work_size].flatten
        lws_p = MemoryPointer::new( :size_t, local_work_size.length )
        local_work_size.each_with_index { |e,i|
          lws_p[i].write_size_t( e )
        }
        ptr = MemoryPointer::new( :size_t )
        error = OpenCL.clGetKernelSubGroupInfo(self, device, MAX_SUB_GROUP_SIZE_FOR_NDRANGE, lws_p.size, lws_p, ptr.size, ptr, nil)
        error_check(error)
        return ptr.read_size_t
      end

      def sub_groups_count_for_ndrange(local_work_size, device = program.devices.first)
        error_check(INVALID_OPERATION) if self.context.platform.version_number < 2.1
        local_work_size = [local_work_size].flatten
        lws_p = MemoryPointer::new( :size_t, local_work_size.length )
        local_work_size.each_with_index { |e,i|
          lws_p[i].write_size_t( e )
        }
        ptr = MemoryPointer::new( :size_t )
        error = OpenCL.clGetKernelSubGroupInfo(self, device, SUB_GROUP_COUNT_FOR_NDRANGE, lws_p.size, lws_p, ptr.size, ptr, nil)
        error_check(error)
        return ptr.read_size_t
      end

      def local_size_for_sub_group_count(sub_group_number, device = program.devices.first)
        error_check(INVALID_OPERATION) if self.context.platform.version_number < 2.1
        sgp_p = MemoryPointer::new( :size_t )
        sgp_p.write_size_t(sub_group_number)
        size_ptr = MemoryPointer::new( :size_t )
        error = OpenCL.clGetKernelSubGroupInfo(self, device, LOCAL_SIZE_FOR_SUB_GROUP_COUNT, sgp_p.size, sgp_p, 0, nil, size_ptr)
        error_check(error)
        lws_p = MemoryPointer::new( size_ptr.read_size_t )
        error = OpenCL.clGetKernelSubGroupInfo(self, device, LOCAL_SIZE_FOR_SUB_GROUP_COUNT, sgp_p.size, sgp_p, lws_p.size, lws_p, nil)
        error_check(error)
        return lws_p.get_array_of_size_t(0, lws_p.size/size_ptr.size)
      end

      def clone
        return OpenCL.clone_kernel( self )
      end

    end

    register_extension( :v11, OpenCL11, "context.platform.version_number >= 1.1" )
    register_extension( :v12, OpenCL12, "context.platform.version_number >= 1.2" )
    register_extension( :v20, OpenCL20, "context.platform.version_number >= 2.0" )
    register_extension( :v21, OpenCL21, "context.platform.version_number >= 2.1" )

  end

end

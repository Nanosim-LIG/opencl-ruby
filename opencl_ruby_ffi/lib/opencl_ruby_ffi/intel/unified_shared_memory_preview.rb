module OpenCL
  DEVICE_HOST_MEM_CAPABILITIES_INTEL = 0x4190
  DEVICE_DEVICE_MEM_CAPABILITIES_INTEL = 0x4191
  DEVICE_SINGLE_DEVICE_SHARED_MEM_CAPABILITIES_INTEL = 0x4192
  DEVICE_CROSS_DEVICE_SHARED_MEM_CAPABILITIES_INTEL = 0x4193
  DEVICE_SHARED_SYSTEM_MEM_CAPABILITIES_INTEL = 0x4194

  UNIFIED_SHARED_MEMORY_ACCESS_INTEL = (1 << 0)
  UNIFIED_SHARED_MEMORY_ATOMIC_ACCESS_INTEL = (1 << 1)
  UNIFIED_SHARED_MEMORY_CONCURRENT_ACCESS_INTEL = (1 << 2)
  UNIFIED_SHARED_MEMORY_CONCURRENT_ATOMIC_ACCESS_INTEL = (1 << 3)

  MEM_ALLOC_FLAGS_INTEL = 0x4195

  MEM_ALLOC_DEFAULT_INTEL = 0
  MEM_ALLOC_WRITE_COMBINED_INTEL = (1 << 0)

  MEM_TYPE_UNKNOWN_INTEL = 0x4196
  MEM_TYPE_HOST_INTEL = 0x4197
  MEM_TYPE_DEVICE_INTEL = 0x4198
  MEM_TYPE_SHARED_INTEL = 0x4199

  MEM_ALLOC_TYPE_INTEL = 0x419A
  MEM_ALLOC_BASE_PTR_INTEL = 0x419B
  MEM_ALLOC_SIZE_INTEL = 0x419C
  MEM_ALLOC_INFO_TBD0_INTEL = 0x419D
  MEM_ALLOC_INFO_TBD1_INTEL = 0x419E
  MEM_ALLOC_INFO_TBD2_INTEL = 0x419F

  KERNEL_EXEC_INFO_INDIRECT_HOST_ACCESS_INTEL = 0x4200
  KERNEL_EXEC_INFO_INDIRECT_DEVICE_ACCESS_INTEL = 0x4201
  KERNEL_EXEC_INFO_INDIRECT_SHARED_ACCESS_INTEL = 0x4202
  KERNEL_EXEC_INFO_USM_PTRS_INTEL = 0x4203

  COMMAND_MEMSET_INTEL = 0x4204
  COMMAND_MEMCPY_INTEL = 0x4205
  COMMAND_MIGRATEMEM_INTEL = 0x4206
  COMMAND_MEMADVISE_INTEL = 0x4207

  MEM_ADVICE_TBD0_INTEL = 0x4208
  MEM_ADVICE_TBD1_INTEL = 0x4209
  MEM_ADVICE_TBD2_INTEL = 0x420A
  MEM_ADVICE_TBD3_INTEL = 0x420B
  MEM_ADVICE_TBD4_INTEL = 0x420C
  MEM_ADVICE_TBD5_INTEL = 0x420D
  MEM_ADVICE_TBD6_INTEL = 0x420E
  MEM_ADVICE_TBD7_INTEL = 0x420F

  [[:cl_bitfield, :cl_mem_properties_intel],
   [:cl_bitfield, :cl_mem_alloc_flags_intel],
   [:cl_uint, :cl_mem_info_intel],
   [:cl_uint, :cl_mem_advice_intel],
   [:cl_bitfield, :cl_unified_shared_memory_capabilities_intel],
   [:cl_uint, :cl_unified_shared_memory_type_intel]
  ].each { |o_t, t|
    typedef o_t, t
  }
end

if RUBY_VERSION.scan(/\d+/).collect(&:to_i).first >= 2
  module OpenCLRefinements
    refine FFI::Pointer do
      methods_prefix = [:put, :get, :write, :read, :put_array_of, :get_array_of]
      [[:cl_bitfield, :cl_mem_properties_intel],
       [:cl_bitfield, :cl_mem_alloc_flags_intel],
       [:cl_uint, :cl_mem_info_intel],
       [:cl_uint, :cl_mem_advice_intel],
       [:cl_bitfield, :cl_unified_shared_memory_capabilities_intel],
       [:cl_uint, :cl_unified_shared_memory_type_intel]
      ].each { |orig, add|
        methods_prefix.each { |meth|
          alias_method "#{meth}_#{add}".to_sym, "#{meth}_#{orig}".to_sym
        }
      }
    end
  end
  using OpenCLRefinements
else
  class FFI::Pointer
    methods_prefix = [:put, :get, :write, :read, :put_array_of, :get_array_of]
    [[:cl_bitfield, :cl_mem_properties_intel],
     [:cl_bitfield, :cl_mem_alloc_flags_intel],
     [:cl_uint, :cl_mem_info_intel],
     [:cl_uint, :cl_mem_advice_intel],
     [:cl_bitfield, :cl_unified_shared_memory_capabilities_intel],
     [:cl_uint, :cl_unified_shared_memory_type_intel]
    ].each { |orig, add|
      methods_prefix.each { |meth|
        alias_method "#{meth}_#{add}".to_sym, "#{meth}_#{orig}".to_sym
      }
    }
  end
end

module OpenCL

  class UnifiedSharedMemoryCapabilitiesINTEL < Bitfield
    UNIFIED_SHARED_MEMORY_ACCESS_INTEL = (1 << 0)
    UNIFIED_SHARED_MEMORY_ATOMIC_ACCESS_INTEL = (1 << 1)
    UNIFIED_SHARED_MEMORY_CONCURRENT_ACCESS_INTEL = (1 << 2)
    UNIFIED_SHARED_MEMORY_CONCURRENT_ATOMIC_ACCESS_INTEL = (1 << 3)

    def names
      fs = []
      %w( UNIFIED_SHARED_MEMORY_ACCESS_INTEL UNIFIED_SHARED_MEMORY_ATOMIC_ACCESS_INTEL UNIFIED_SHARED_MEMORY_CONCURRENT_ACCESS_INTEL UNIFIED_SHARED_MEMORY_CONCURRENT_ATOMIC_ACCESS_INTEL )..each { |f|
        fs.push(f) if self.include?( self.class.const_get(f) )
      }
      return fs
    end
  end

  module InnerInterface
    TYPE_CONVERTER[:cl_unified_shared_memory_capabilities_intel] = UnifiedSharedMemoryCapabilitiesINTEL
  end

  class Mem
    ALLOC_FLAGS_INTEL = 0x4195

    TYPE_UNKNOWN_INTEL = 0x4196
    TYPE_HOST_INTEL = 0x4197
    TYPE_DEVICE_INTEL = 0x4198
    TYPE_SHARED_INTEL = 0x4199

    ALLOC_DEFAULT_INTEL = 0
    ALLOC_WRITE_COMBINED_INTEL = (1 << 0)

    ALLOC_TYPE_INTEL = 0x419A
    ALLOC_BASE_PTR_INTEL = 0x419B
    ALLOC_SIZE_INTEL = 0x419C
    ALLOC_INFO_TBD0_INTEL = 0x419D
    ALLOC_INFO_TBD1_INTEL = 0x419E
    ALLOC_INFO_TBD2_INTEL = 0x419F

    class UnifiedSharedMemoryTypeINTEL < EnumInt
      UNKNOWN_INTEL = 0x4196
      HOST_INTEL = 0x4197
      DEVICE_INTEL = 0x4198
      SHARED_INTEL = 0x4199
      @codes = {}
      @codes[0x4196] = 'UNKNOWN_INTEL'
      @codes[0x4197] = 'HOST_INTEL'
      @codes[0x4198] = 'DEVICE_INTEL'
      @codes[0x4199] = 'SHARED_INTEL'
    end

    class AllocFlagsINTEL < Bitfield
      DEFAULT_INTEL = 0
      WRITE_COMBINED_INTEL = (1 << 0)
      def names
        fs = []
        %w( WRITE_COMBINED_INTEL ).each { |f|
          fs.push(f) if self.include?( self.class.const_get(f) )
        }
        return fs
      end
    end

    class AdviceINTEL < EnumInt
      TBD0_INTEL = 0x4208
      TBD1_INTEL = 0x4209
      TBD2_INTEL = 0x420A
      TBD3_INTEL = 0x420B
      TBD4_INTEL = 0x420C
      TBD5_INTEL = 0x420D
      TBD6_INTEL = 0x420E
      TBD7_INTEL = 0x420F
      @codes = {}
      @codes[0x4208] = 'TBD0_INTEL'
      @codes[0x4209] = 'TBD1_INTEL'
      @codes[0x420A] = 'TBD2_INTEL'
      @codes[0x420B] = 'TBD3_INTEL'
      @codes[0x420C] = 'TBD4_INTEL'
      @codes[0x420D] = 'TBD5_INTEL'
      @codes[0x420E] = 'TBD6_INTEL'
      @codes[0x420F] = 'TBD7_INTEL'
    end

  end

  module InnerInterface
    TYPE_CONVERTER[:cl_unified_shared_memory_type_intel] = Mem::UnifiedSharedMemoryTypeINTEL
    TYPE_CONVERTER[:cl_mem_alloc_flags_intel] = Mem::AllocFlagsINTEL
    TYPE_CONVERTER[:cl_mem_advice_intel] = Mem::AdviceINTEL
  end

  class Device
    HOST_MEM_CAPABILITIES_INTEL = 0x4190
    DEVICE_MEM_CAPABILITIES_INTEL = 0x4191
    SINGLE_DEVICE_SHARED_MEM_CAPABILITIES_INTEL = 0x4192
    CROSS_DEVICE_SHARED_MEM_CAPABILITIES_INTEL = 0x4193
    SHARED_SYSTEM_MEM_CAPABILITIES_INTEL = 0x4194

    module UnifiedSharedMemoryPreviewINTEL
      extend InnerGenerator

      get_info("Device", :cl_unified_shared_memory_capabilities_intel, "host_mem_capabilities_intel")
      get_info("Device", :cl_unified_shared_memory_capabilities_intel, "device_mem_capabilities_intel")
      get_info("Device", :cl_unified_shared_memory_capabilities_intel, "device_shared_mem_capabilities_intel")
      get_info("Device", :cl_unified_shared_memory_capabilities_intel, "cross_device_mem_capabilities_intel")
      get_info("Device", :cl_unified_shared_memory_capabilities_intel, "shared_system_mem_capabilities_intel")
    end
    register_extension( :cl_intel_unified_shared_memory_preview, UnifiedSharedMemoryPreviewINTEL, "extensions.include?(\"cl_intel_unified_shared_memory_preview\")" )
  end

  class USMPointer < Pointer
    def initialize( address, context, size)
      super(address)
      @context = context
      @size = size
    end

    def inspect
      return "#<#{self.class.name}: #{@size}>"
    end

    def +( offset )
      return USMPointer::new(address + offset, @context, @size - offset )
    end

    def free
      @context.mem_free_intel(alloc_base_ptr_intel)
    end

    def alloc_type_intel
      @context.mem_alloc_type_intel(self)
    end

    def alloc_flags_intel
      @context.mem_alloc_flags_intel(self)
    end

    def alloc_base_ptr_intel
      @context.mem_alloc_base_ptr_intel(self)
    end

    def alloc_size_intel
      @context.mem_alloc_size_intel(self)
    end
  end

  class Context
    module UnifiedSharedMemoryPreviewINTEL
      extend InnerGenerator

      def clGetMemAllocInfoINTEL
        return @_clGetMemAllocInfoINTEL if @_clGetMemAllocInfoINTEL
        @_clGetMemAllocInfoINTEL = platform.get_extension_function("clGetMemAllocInfoINTEL", :cl_int, [Context, :pointer, :cl_mem_info_intel, :size_t, :pointer, :pointer])
        error_check(OpenCL::INVALID_OPERATION) unless @_clGetMemAllocInfoINTEL
        return @_clGetMemAllocInfoINTEL
      end

      def clHostMemAllocINTEL
        return @_clHostMemAllocINTEL if @_clHostMemAllocINTEL
        @_clHostMemAllocINTEL = platform.get_extension_function("clHostMemAllocINTEL", :pointer, [Context, :pointer, :size_t, :cl_uint, :pointer])
        error_check(OpenCL::INVALID_OPERATION) unless @_clHostMemAllocINTEL
        return @_clHostMemAllocINTEL
      end

      def clDeviceMemAllocINTEL
        return @_clDeviceMemAllocINTEL if @_clDeviceMemAllocINTEL
        @_clDeviceMemAllocINTEL = platform.get_extension_function("clDeviceMemAllocINTEL", :pointer, [Context, Device, :pointer, :size_t, :cl_uint, :pointer])
        error_check(OpenCL::INVALID_OPERATION) unless @_clDeviceMemAllocINTEL
        return @_clDeviceMemAllocINTEL
      end

      def clSharedMemAllocINTEL
        return @_clSharedMemAllocINTEL if @_clSharedMemAllocINTEL
        @_clSharedMemAllocINTEL = platform.get_extension_function("clSharedMemAllocINTEL", :pointer, [Context, Device, :pointer, :size_t, :cl_uint, :pointer])
        error_check(OpenCL::INVALID_OPERATION) unless @_clSharedMemAllocINTEL
        return @_clSharedMemAllocINTEL
      end

      def clMemFreeINTEL
        return @_clMemFreeINTEL if @_clMemFreeINTEL
        @_clMemFreeINTEL = platform.get_extension_function("clMemFreeINTEL", :cl_int, [Context, :pointer])
        error_check(OpenCL::INVALID_OPERATION) unless @_clMemFreeINTEL
        return @_clMemFreeINTEL
      end

      def get_mem_properties_intel(properties)
        return nil unless properties
        properties = [properties].flatten
        props = MemoryPointer::new(:cl_mem_properties_intel, properties.length + 1)
        properties.each_with_index { |e, i|
          props[i].write_cl_mem_properties_intel(e)
        }
        props[properties.length].write_cl_mem_properties_intel(0)
        return props
      end

      private :get_mem_properties_intel

      def host_mem_alloc_intel(size, options = {})
        properties = get_mem_properties_intel(options[:properties])
        alignment = 0
        alignment = options[:alignment] if options[:alignment]
        error = MemoryPointer::new( :cl_int )
        ptr = clHostMemAllocINTEL.call(self, properties, size, alignment, error)
        error_check(error.read_cl_int)
        return USMPointer::new(ptr, self, size)
      end

      def device_mem_alloc_intel(device, size, options = {})
        properties = get_mem_properties_intel(options[:properties])
        alignment = 0
        alignment = options[:alignment] if options[:alignment]
        error = MemoryPointer::new( :cl_int )
        ptr = clDeviceMemAllocINTEL.call(self, device, properties, size, alignment, error)
        error_check(error.read_cl_int)
        return USMPointer::new(ptr, self, size)
      end

      def shared_mem_alloc_intel(device, size, options = {})
        properties = get_mem_properties_intel(options[:properties])
        alignment = 0
        alignment = options[:alignment] if options[:alignment]
        error = MemoryPointer::new( :cl_int )
        ptr = clSharedMemAllocINTEL.call(self, device, properties, size, alignment, error)
        error_check(error.read_cl_int)
        return USMPointer::new(ptr, self, size)
      end

      def mem_free_intel(ptr)
        error = clMemFreeINTEL.call(self, ptr)
        error_check(error)
        return self
      end

      def mem_alloc_type_intel(ptr)
        ptr_res = MemoryPointer::new(:cl_unified_shared_memory_type_intel)
        error = clGetMemAllocInfoINTEL.call(self, ptr, OpenCL::Mem::ALLOC_TYPE_INTEL, ptr_res.size, ptr_res, nil)
        error_check(error)
        return OpenCL::Mem::UnifiedSharedMemoryTypeINTEL::new(ptr_res.read_cl_unified_shared_memory_type_intel)
      end

      def mem_alloc_flags_intel(ptr)
        ptr_res = MemoryPointer::new(:cl_mem_alloc_flags_intel)
        error = clGetMemAllocInfoINTEL.call(self, ptr, OpenCL::Mem::ALLOC_FLAGS_INTEL, ptr_res.size, ptr_res, nil)
        error_check(error)
        return OpenCL::Mem::AllocFlagsINTEL::new(ptr_res.read_cl_mem_alloc_flags_intel)
      end

      def mem_alloc_base_ptr_intel(ptr)
        ptr_res = MemoryPointer::new(:pointer)
        error = clGetMemAllocInfoINTEL.call(self, ptr, OpenCL::Mem::ALLOC_BASE_PTR_INTEL, ptr_res.size, ptr_res, nil)
        error_check(error)
        return ptr_res.read_pointer
      end

      def mem_alloc_size_intel(ptr)
        ptr_res = MemoryPointer::new(:size_t)
        error = clGetMemAllocInfoINTEL.call(self, ptr, OpenCL::Mem::ALLOC_SIZE_INTEL, ptr_res.size, ptr_res, nil)
        error_check(error)
        return ptr_res.read_size_t
      end

    end
    register_extension( :cl_intel_unified_shared_memory_preview, UnifiedSharedMemoryPreviewINTEL, "platform.extensions.include?(\"cl_intel_unified_shared_memory_preview\")" )
  end

  class Kernel
    EXEC_INFO_INDIRECT_HOST_ACCESS_INTEL = 0x4200
    EXEC_INFO_INDIRECT_DEVICE_ACCESS_INTEL = 0x4201
    EXEC_INFO_INDIRECT_SHARED_ACCESS_INTEL = 0x4202
    EXEC_INFO_USM_PTRS_INTEL = 0x4203

    module UnifiedSharedMemoryPreviewINTEL
      extend InnerGenerator

      def clSetKernelArgMemPointerINTEL
        return @_clSetKernelArgMemPointerINTEL if @_clSetKernelArgMemPointerINTEL
        @_clSetKernelArgMemPointerINTEL = context.platform.get_extension_function("@_clSetKernelArgMemPointerINTEL", :cl_int, Kernel, :cl_uint, :pointer)
        error_check(OpenCL::INVALID_OPERATION) unless @_clSetKernelArgMemPointerINTEL
        return @_clSetKernelArgMemPointerINTEL
      end

      def set_arg_mem_pointer_intel(index, usm_pointer)
        error = clSetKernelArgMemPointerINTEL.call(self, index, usm_pointer)
        error_check(error)
        return self 
      end

      def set_usm_ptrs_intel( ptrs )
        pointers = [ptrs].flatten
        pt = MemoryPointer::new( :pointer, pointers.length )
        pointers.each_with_index { |p, i|
          pt[i].write_pointer(p)
        }
        error = OpenCL.clSetKernelExecInfo( self, EXEC_INFO_USM_PTRS_INTEL, pt.size, pt)
        error_check(error)
        self
      end

      def set_indirect_host_access_intel( flag )
        pt = MemoryPointer::new(  :cl_bool )
        pt.write_cl_bool( flag )
        error = OpenCL.clSetKernelExecInfo( self, EXEC_INFO_INDIRECT_HOST_ACCESS_INTEL, pt.size, pt)
        error_check(error)
        self
      end

      def set_indirect_device_access_intel( flag )
        pt = MemoryPointer::new(  :cl_bool )
        pt.write_cl_bool( flag )
        error = OpenCL.clSetKernelExecInfo( self, EXEC_INFO_INDIRECT_DEVICE_ACCESS_INTEL, pt.size, pt)
        error_check(error)
        self
      end

      def set_shared_device_access_intel( flag )
        pt = MemoryPointer::new(  :cl_bool )
        pt.write_cl_bool( flag )
        error = OpenCL.clSetKernelExecInfo( self, EXEC_INFO_SHARED_DEVICE_ACCESS_INTEL, pt.size, pt)
        error_check(error)
        self
      end

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
          elsif args[i].class == USMPointer then
            self.set_arg_mem_pointer_intel(i, args[i])
          else
            self.set_arg(i, args[i])
          end
        }
        command_queue.enqueue_ndrange_kernel(self, global_work_size, options)
      end

    end
    register_extension( :cl_intel_unified_shared_memory_preview, UnifiedSharedMemoryPreviewINTEL, "context.platform.extensions.include?(\"cl_intel_unified_shared_memory_preview\")" )
  end

  class Kernel
    class Arg
      module UnifiedSharedMemoryPreviewINTEL
        def set(value, size = nil)
          if value.class == SVMPointer and @kernel.context.platform.version_number >= 2.0 then
            OpenCL.set_kernel_arg_svm_pointer(@kernel, @index, value)
          elsif args[i].class == USMPointer then
            @kernel.set_arg_mem_pointer_intel(@index, value)
          else
            OpenCL.set_kernel_arg(@kernel, @index, value, size)
          end
        end
      end
      register_extension( :cl_intel_unified_shared_memory_preview, UnifiedSharedMemoryPreviewINTEL, "kernel.context.platform.extensions.include?(\"cl_intel_unified_shared_memory_preview\")" )
    end
  end
end

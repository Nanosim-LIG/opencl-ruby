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

  MEM_ALLOC_WRITE_COMBINED_INTEL = (1 << 0)

  MEM_TYPE_UNKNOWN_INTEL = 0x4196
  MEM_TYPE_HOST_INTEL = 0x4197
  MEM_TYPE_DEVICE_INTEL = 0x4198
  MEM_TYPE_SHARED_INTEL = 0x4199

  MEM_ALLOC_TYPE_INTEL = 0x419A
  MEM_ALLOC_BASE_PTR_INTEL = 0x419B
  MEM_ALLOC_SIZE_INTEL = 0x419C
  MEM_ALLOC_DEVICE_INTEL = 0x419D
  MEM_ALLOC_INFO_TBD1_INTEL = 0x419E
  MEM_ALLOC_INFO_TBD2_INTEL = 0x419F

  KERNEL_EXEC_INFO_INDIRECT_HOST_ACCESS_INTEL = 0x4200
  KERNEL_EXEC_INFO_INDIRECT_DEVICE_ACCESS_INTEL = 0x4201
  KERNEL_EXEC_INFO_INDIRECT_SHARED_ACCESS_INTEL = 0x4202
  KERNEL_EXEC_INFO_USM_PTRS_INTEL = 0x4203

  MIGRATE_MEM_OBJECT_HOST_INTEL = (1 << 0)
  MIGRATE_MEM_OBJECT_CONTENT_UNDEFINED_INTEL = (1 << 1)

  COMMAND_MEMFILL_INTEL = 0x4204
  COMMAND_MEMCPY_INTEL = 0x4205
  COMMAND_MIGRATEMEM_INTEL = 0x4206
  COMMAND_MEMADVISE_INTEL = 0x4207

  class CommandType
    MEMFILL_INTEL = 0x4204
    MEMCPY_INTEL = 0x4205
    MIGRATEMEM_INTEL = 0x4206
    MEMADVISE_INTEL = 0x4207

    @codes[0x4204] = 'MEMFILL_INTEL'
    @codes[0x4205] = 'MEMCPY_INTEL'
    @codes[0x4206] = 'MIGRATEMEM_INTEL'
    @codes[0x4207] = 'MEMADVISE_INTEL'
  end

  MEM_ADVICE_TBD0_INTEL = 0x4208
  MEM_ADVICE_TBD1_INTEL = 0x4209
  MEM_ADVICE_TBD2_INTEL = 0x420A
  MEM_ADVICE_TBD3_INTEL = 0x420B
  MEM_ADVICE_TBD4_INTEL = 0x420C
  MEM_ADVICE_TBD5_INTEL = 0x420D
  MEM_ADVICE_TBD6_INTEL = 0x420E
  MEM_ADVICE_TBD7_INTEL = 0x420F

  [[:cl_bitfield, :cl_mem_properties_intel],
   [:cl_bitfield, :cl_mem_migration_flags_intel],
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
       [:cl_bitfield, :cl_mem_migration_flags_intel],
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
     [:cl_bitfield, :cl_mem_migration_flags_intel],
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

    ALLOC_WRITE_COMBINED_INTEL = (1 << 0)

    ALLOC_TYPE_INTEL = 0x419A
    ALLOC_BASE_PTR_INTEL = 0x419B
    ALLOC_SIZE_INTEL = 0x419C
    ALLOC_DEVICE_INTEL = 0x419D
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

    class MigrationFlagsINTEL < Bitfield
      HOST_INTEL = (1 << 0)
      CONTENT_UNDEFINED_INTEL = (1 << 1)
      # Returns an Array of String representing the different flags set
      def names
        fs = []
        %w( HOST CONTENT_UNDEFINED ).each { |f|
          fs.push(f) if self.include?( self.class.const_get(f) )
        }
        return fs
      end
    end

  end

  module InnerInterface
    TYPE_CONVERTER[:cl_unified_shared_memory_type_intel] = Mem::UnifiedSharedMemoryTypeINTEL
    TYPE_CONVERTER[:cl_mem_alloc_flags_intel] = Mem::AllocFlagsINTEL
    TYPE_CONVERTER[:cl_mem_advice_intel] = Mem::AdviceINTEL
    TYPE_CONVERTER[:cl_mem_migration_flags_intel] = Mem::MigrationFlagsINTEL
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

      def clGetDeviceGlobalVariablePointerINTEL
        @_clGetDeviceGlobalVariablePointerINTEL ||= begin
          p = platform.get_extension_function("clGetDeviceGlobalVariablePointerINTEL", :cl_int, [Device, Program, :string, :pointer, :pointer])
          error_check(OpenCL::INVALID_OPERATION) unless p
          p
        end
      end

      def get_global_variable_pointer_intel(program, name)
        pSize = MemoryPointer::new(:size_t)
        pAddr = MemoryPointer::new(:pointer)
        error = clGetDeviceGlobalVariablePointerINTEL.call(self, program, name, pAddr, pSize)
        error_check(error)
        return USMPointer::new(pAddr.read_pointer.slice(0, pSize.read_size_t), self)
      end

    end
    register_extension( :cl_intel_unified_shared_memory_preview, UnifiedSharedMemoryPreviewINTEL, "extensions.include?(\"cl_intel_unified_shared_memory_preview\")" )
  end

  class USMPointer < Pointer

    def initialize(address, context)
      super(address)
      @context = context
    end

    def inspect
      return "#<#{self.class.name}: 0x#{address.to_s(16)} (#{size})>"
    end

    def slice(offset, size)
      res = super(offset, size)
      self.class.new(res, context)
    end

    def +( offset )
      self.slice(offset, self.size - offset)
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

    def alloc_device_intel
      context.mem_alloc_device_intel(self)
    end
  end

  class Context
    module UnifiedSharedMemoryPreviewINTEL
      extend InnerGenerator

      def clGetMemAllocInfoINTEL
        @_clGetMemAllocInfoINTEL ||= begin
          p = platform.get_extension_function("clGetMemAllocInfoINTEL", :cl_int, [Context, :pointer, :cl_mem_info_intel, :size_t, :pointer, :pointer])
          error_check(OpenCL::INVALID_OPERATION) unless p
          p
        end
      end

      def clHostMemAllocINTEL
        @_clHostMemAllocINTEL ||= begin
          p = platform.get_extension_function("clHostMemAllocINTEL", :pointer, [Context, :pointer, :size_t, :cl_uint, :pointer])
          error_check(OpenCL::INVALID_OPERATION) unless p
          p
        end
      end

      def clDeviceMemAllocINTEL
        @_clDeviceMemAllocINTEL ||= begin
          p = platform.get_extension_function("clDeviceMemAllocINTEL", :pointer, [Context, Device, :pointer, :size_t, :cl_uint, :pointer])
          error_check(OpenCL::INVALID_OPERATION) unless p
          p
        end
      end

      def clSharedMemAllocINTEL
        @_clSharedMemAllocINTEL ||= begin
          p = platform.get_extension_function("clSharedMemAllocINTEL", :pointer, [Context, Device, :pointer, :size_t, :cl_uint, :pointer])
          error_check(OpenCL::INVALID_OPERATION) unless p
          p
        end
      end

      def clMemFreeINTEL
        return @_clMemFreeINTEL ||= begin
          p = platform.get_extension_function("clMemFreeINTEL", :cl_int, [Context, :pointer])
          error_check(OpenCL::INVALID_OPERATION) unless p
          p
        end
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
        return USMPointer::new(ptr.slice(0, size), self)
      end

      def device_mem_alloc_intel(device, size, options = {})
        properties = get_mem_properties_intel(options[:properties])
        alignment = 0
        alignment = options[:alignment] if options[:alignment]
        error = MemoryPointer::new( :cl_int )
        ptr = clDeviceMemAllocINTEL.call(self, device, properties, size, alignment, error)
        error_check(error.read_cl_int)
        return USMPointer::new(ptr.slice(0, size), self)
      end

      def shared_mem_alloc_intel(device, size, options = {})
        properties = get_mem_properties_intel(options[:properties])
        alignment = 0
        alignment = options[:alignment] if options[:alignment]
        error = MemoryPointer::new( :cl_int )
        ptr = clSharedMemAllocINTEL.call(self, device, properties, size, alignment, error)
        error_check(error.read_cl_int)
        return USMPointer::new(ptr.slice(0, size), self)
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

      def mem_alloc_device_intel(ptr)
        ptr_res = MemoryPointer::new( Device )
        error = OpenCL.clGetMemAllocInfoINTEL.call(self, ptr, OpenCL::Mem::ALLOC_DEVICE_INTEL, Device.size, ptr_res, nil)
        error_check(error)
        return Device::new(ptr_res.read_pointer)
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
        @_clSetKernelArgMemPointerINTEL ||= begin
          p = context.platform.get_extension_function("clSetKernelArgMemPointerINTEL", :cl_int, Kernel, :cl_uint, :pointer)
          error_check(OpenCL::INVALID_OPERATION) unless p
          p
        end
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
    register_extension( :cl_intel_unified_shared_memory_preview, UnifiedSharedMemoryPreviewINTEL, "platform.extensions.include?(\"cl_intel_unified_shared_memory_preview\")" )
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
      register_extension( :cl_intel_unified_shared_memory_preview, UnifiedSharedMemoryPreviewINTEL, "platform.extensions.include?(\"cl_intel_unified_shared_memory_preview\")" )
    end
  end

  class CommandQueue
    module UnifiedSharedMemoryPreviewINTEL
      extend InnerGenerator

      def clEnqueueMemFillINTEL
        @_clEnqueueMemFillINTEL ||= begin
          p = platform.get_extension_function("clEnqueueMemFillINTEL", :cl_int, [CommandQueue, :pointer, :pointer, :size_t, :size_t, :cl_uint, :pointer, :pointer])
          error_check(OpenCL::INVALID_OPERATION) unless p
          p
        end
      end

      def clEnqueueMemcpyINTEL
        @_clEnqueueMemcpyINTEL ||= begin
          p = platform.get_extension_function("clEnqueueMemcpyINTEL", :cl_int, [CommandQueue, :cl_bool, :pointer, :pointer, :size_t, :cl_uint, :pointer, :pointer])
          error_check(OpenCL::INVALID_OPERATION) unless p
          p
        end
      end

      def clEnqueueMigrateMemINTEL
        @_clEnqueueMigrateMemINTEL ||= begin
          p = platform.get_extension_function("clEnqueueMigrateMemINTEL", :cl_int, [CommandQueue, :pointer, :size_t, :cl_mem_migration_flags_intel, :cl_uint, :pointer, :pointer])
          error_check(OpenCL::INVALID_OPERATION) unless p
          p
        end
      end

      def clEnqueueMemAdviseINTEL
        @_clEnqueueMemAdviseINTEL ||= begin
          p = platform.get_extension_function("clEnqueueMemAdviseINTEL", :cl_int, [CommandQueue, :pointer, :size_t, :cl_mem_advice_intel, :cl_uint, :pointer, :pointer])
          error_check(OpenCL::INVALID_OPERATION) unless p
          p
        end
      end

      def enqueue_mem_fill_intel(usm_ptr, pattern, options = {})
        num_events, events = get_event_wait_list( options )
        pattern_size = pattern.size
        pattern_size = options[:pattern_size] if options[:pattern_size]
        size = usm_ptr.size
        size = options[:size] if options[:size]
        event = MemoryPointer::new( Event )
        error = clEnqueueMemFillINTEL.call(self, usm_ptr, pattern, pattern_size, size, num_events, events, event)
        error_check(error)
        return Event::new(event.read_pointer, false)
      end

      def enqueue_memcpy_intel(dst_ptr, src_ptr, options = {})
        num_events, events = get_event_wait_list( options )
        blocking = FALSE
        blocking = TRUE if options[:blocking] or options[:blocking_copy]
        size = [dst_ptr.size, src_ptr.size].min
        size = options[:size] if options[:size]
        event = MemoryPointer::new( Event )
        error = clEnqueueMemcpyINTEL.call(self, blocking, dst_ptr, src_ptr, size, num_events, events, event)
        error_check(error)
        return Event::new(event.read_pointer, false)
      end

      def enqueue_migrate_mem_intel(usm_ptr, options = {})
        num_events, events = get_event_wait_list( options )
        flags = get_flags( options )
        size = usm_ptr.size
        size = options[:size] if options[:size]
        event = MemoryPointer::new( Event )
        error = clEnqueueMigrateMemINTEL.call(self, usm_ptr, size, flags, num_events, events, event)
        error_check(error)
        return Event::new(event.read_pointer, false)
      end

      def enqueue_mem_advise_intel(usm_ptr, advice, options = {})
        num_events, events = get_event_wait_list( options )
        size = usm_ptr.size
        size = options[:size] if options[:size]
        event = MemoryPointer::new( Event )
        error = clEnqueueMemAdviseINTEL(self, usm_ptr, size, advice, num_events, events, event)
        error_check(error)
        return Event::new(event.read_pointer, false)
      end

    end
    register_extension( :cl_intel_unified_shared_memory_preview, UnifiedSharedMemoryPreviewINTEL, "device.extensions.include?(\"cl_intel_unified_shared_memory_preview\")" )
  end
end

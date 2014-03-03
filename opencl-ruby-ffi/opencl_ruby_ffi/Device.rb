module OpenCL

  class Device
    DRIVER_VERSION = 0x102D
    %w( BUILT_IN_KERNELS DRIVER_VERSION VERSION VENDOR PROFILE OPENCL_C_VERSION NAME EXTENSIONS ).each { |prop|
      eval OpenCL.get_info("Device", :string, prop)
    }

    %w( MAX_MEM_ALLOC_SIZE MAX_CONSTANT_BUFFER_SIZE LOCAL_MEM_SIZE GLOBAL_MEM_CACHE_SIZE GLOBAL_MEM_SIZE ).each { |prop|
      eval OpenCL.get_info("Device", :cl_ulong, prop)
    }

    %w( IMAGE_PITCH_ALIGNMENT IMAGE_BASE_ADDRESS_ALIGNMENT REFERENCE_COUNT PARTITION_MAX_SUB_DEVICES VENDOR_ID PREFERRED_VECTOR_WIDTH_HALF PREFERRED_VECTOR_WIDTH_CHAR PREFERRED_VECTOR_WIDTH_SHORT PREFERRED_VECTOR_WIDTH_INT PREFERRED_VECTOR_WIDTH_LONG PREFERRED_VECTOR_WIDTH_FLOAT PREFERRED_VECTOR_WIDTH_DOUBLE NATIVE_VECTOR_WIDTH_CHAR NATIVE_VECTOR_WIDTH_SHORT NATIVE_VECTOR_WIDTH_INT NATIVE_VECTOR_WIDTH_LONG NATIVE_VECTOR_WIDTH_FLOAT NATIVE_VECTOR_WIDTH_DOUBLE NATIVE_VECTOR_WIDTH_HALF MIN_DATA_TYPE_ALIGN_SIZE MEM_BASE_ADDR_ALIGN MAX_WRITE_IMAGE_ARGS MAX_WORK_ITEM_DIMENSIONS MAX_SAMPLERS MAX_READ_IMAGE_ARGS MAX_CONSTANT_ARGS MAX_COMPUTE_UNITS MAX_CLOCK_FREQUENCY ADDRESS_BITS GLOBAL_MEM_CACHELINE_SIZE ).each { |prop|
      eval OpenCL.get_info("Device", :cl_uint, prop)
    }

    %w( PRINTF_BUFFER_SIZE IMAGE_MAX_BUFFER_SIZE IMAGE_MAX_ARRAY_SIZE PROFILING_TIMER_RESOLUTION MAX_WORK_GROUP_SIZE MAX_PARAMETER_SIZE IMAGE2D_MAX_WIDTH IMAGE2D_MAX_HEIGHT IMAGE3D_MAX_WIDTH IMAGE3D_MAX_HEIGHT IMAGE3D_MAX_DEPTH ).each { |prop|
      eval OpenCL.get_info("Device", :size_t, prop)
    }

    %w( PREFERRED_INTEROP_USER_SYNC LINKER_AVAILABLE IMAGE_SUPPORT HOST_UNIFIED_MEMORY COMPILER_AVAILABLE AVAILABLE ENDIAN_LITTLE ERROR_CORRECTION_SUPPORT ).each { |prop|
      eval OpenCL.get_info("Device", :cl_bool, prop)
    }

    %w( SINGLE_FP_CONFIG HALF_FP_CONFIG DOUBLE_FP_CONFIG ).each { |prop|
      eval OpenCL.get_info("Device", :cl_device_fp_config, prop)
    }
    eval OpenCL.get_info("Device", :cl_device_exec_capabilities, "EXECUTION_CAPABILITIES")

    def execution_capabilities_names
      caps = self.execution_capabilities
      caps_name = []
      %w( EXEC_KERNEL EXEC_NATIVE_KERNEL ).each { |cap|
        caps_name.push(cap) unless ( OpenCL.const_get(cap) & caps ) == 0
      }
      return caps_name
    end

    eval OpenCL.get_info("Device", :cl_device_mem_cache_type, "GLOBAL_MEM_CACHE_TYPE")

    def global_mem_cache_type_name
      t = self.global_mem_cache_type
      %w( NONE READ_ONLY_CACHE READ_WRITE_CACHE ).each { |cache_type|
        return cache_type if OpenCL.const_get(cache_type) == t
      }
    end

    eval OpenCL.get_info("Device", :cl_device_local_mem_type, "LOCAL_MEM_TYPE")

    def local_mem_type_name
      t = self.local_mem_type
      %w( NONE LOCAL GLOBAL ).each { |l_m_t|
        return l_m_t if OpenCL.const_get(l_m_t) == t
      }
    end

    eval OpenCL.get_info("Device", :cl_command_queue_properties, "QUEUE_PROPERTIES")

    def queue_properties_names
      caps = self.queue_properties
      cap_names = []
      %w( OUT_OF_ORDER_EXEC_MODE_ENABLE PROFILING_ENABLE ).each { |cap|
        cap_names.push(cap) unless ( OpenCL::CommandQueue.const_get(cap) & caps ) == 0
      }
      return cap_names
    end

    eval OpenCL.get_info("Device", :cl_device_type, "TYPE")

    def type_names
      t = self.type
      t_names = []
      %w( TYPE_CPU TYPE_GPU TYPE_ACCELERATOR TYPE_DEFAULT TYPE_CUSTOM ).each { |d_t|
        t_names.push(d_t) unless ( OpenCL::Device::const_get(d_t) & t ) == 0
      }
      return t_names
    end

    eval OpenCL.get_info("Device", :cl_device_affinity_domain, "PARTITION_AFFINITY_DOMAIN")

    def partition_affinity_domain_names
      aff_names = []
      affs = self.partition_affinity_domain
      %w( CL_DEVICE_AFFINITY_DOMAIN_NUMA CL_DEVICE_AFFINITY_DOMAIN_L4_CACHE CL_DEVICE_AFFINITY_DOMAIN_L3_CACHE CL_DEVICE_AFFINITY_DOMAIN_L2_CACHE CL_DEVICE_AFFINITY_DOMAIN_L1_CACHE CL_DEVICE_AFFINITY_DOMAIN_NEXT_PARTITIONABLE).each { |aff|
        aff_names.push(aff) unless (OpenCL::Device.const_get(aff) & affs ) == 0
      }
      return aff_names
    end

    eval OpenCL.get_info_array("Device", :size_t, "MAX_WORK_ITEM_SIZES")

    eval OpenCL.get_info_array("Device", :cl_device_partition_property, "PARTITION_PROPERTIES")

    eval OpenCL.get_info_array("Device", :cl_device_partition_property, "PARTITION_TYPE")

    def platform
      ptr1 = FFI::MemoryPointer.new( :size_t, 1)
      error = OpenCL.clGetDeviceInfo(self, Device::PLATFORM, 0, nil, ptr1)
      OpenCL.error_check(error)
      ptr2 = FFI::MemoryPointer.new( ptr1.read_size_t )
      error = OpenCL.clGetDeviceInfo(self, Device::PLATFORM, ptr1.read_size_t, ptr2, nil)
      OpenCL.error_check(error)
      return OpenCL::Platform.new(ptr2.read_pointer)
    end

    def parent_device
      ptr1 = FFI::MemoryPointer.new( :size_t, 1)
      error = OpenCL.clGetDeviceInfo(self, Device::PARENT_DEVICE, 0, nil, ptr1)
      OpenCL.error_check(error)
      ptr2 = FFI::MemoryPointer.new( ptr1.read_size_t )
      error = OpenCL.clGetDeviceInfo(self, Device::PARENT_DEVICE, ptr1.read_size_t, ptr2, nil)
      OpenCL.error_check(error)
      return OpenCL::Device.new(ptr2.read_pointer)
    end

    def self.release(ptr)
      OpenCL.clReleaseDevice(self)
    end
  end

end

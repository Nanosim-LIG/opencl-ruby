module OpenCL

  # Splits a Device in serveral sub-devices
  #
  # ==== Attributes
  # 
  # * +in_device+ - the Device to be partitioned
  # * +properties+ - an Array of cl_device_partition_property
  #
  # ==== Returns
  #
  # an Array of Device
  def self.create_sub_devices( in_device, properties = [OpenCL::Device::PARTITION_BY_AFFINITY_DOMAIN, OpenCL::Device::AFFINITY_DOMAIN_NEXT_PARTITIONABLE] )
    OpenCL.error_check(OpenCL::INVALID_OPERATION) if in_device.platform.version_number < 1.2
    props = FFI::MemoryPointer::new( :cl_device_partition_property, properties.length + 1 )
    properties.each_with_index { |e,i|
      props[i].write_cl_device_partition_property(e)
    }
    props[properties.length].write_cl_device_partition_property(0)
    device_number_ptr = FFI::MemoryPointer::new( :cl_uint )
    error = OpenCL.clCreateSubDevice( in_device, props, 0, nil, device_number_ptr )
    OpenCL.error_check(error)
    device_number = device_number_ptr.read_cl_uint
    devices_ptr = FFI::MemoryPointer::new( OpenCL::Device, device_number )
    error = OpenCL.clCreateSubDevice( in_device, props, device_number, devices_ptr, nil )
    OpenCL.error_check(error)
    devices_ptr.get_array_of_pointer(0, device_number).collect { |device_ptr|
        OpenCL::Device::new(device_ptr, false)
    }
  end

  # Maps the cl_device_id object of OpenCL
  class Device

    # :stopdoc:
    DRIVER_VERSION = 0x102D
    # :startdoc:

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

    ##
    # :method: execution_capabilities()
    # Returns an ExecCpabilities representing the execution capabilities corresponding to the Device
    eval OpenCL.get_info("Device", :cl_device_exec_capabilities, "EXECUTION_CAPABILITIES")

    ##
    # :method: global_mem_cache_type()
    # Returns a MemCacheType representing the type of the global cache memory on the Device
    eval OpenCL.get_info("Device", :cl_device_mem_cache_type, "GLOBAL_MEM_CACHE_TYPE")

    ##
    # :method: local_mem_type()
    # Returns a LocalMemType rpresenting the type of the local memory on the Device
    eval OpenCL.get_info("Device", :cl_device_local_mem_type, "LOCAL_MEM_TYPE")

    ##
    # :method: queue_properties()
    # Returns a CommandQueue::Properties representing the properties supported by a CommandQueue targetting the Device
    eval OpenCL.get_info("Device", :cl_command_queue_properties, "QUEUE_PROPERTIES")

    ##
    # :method: type()
    # Returns a Device::Type representing the type of the Device
    eval OpenCL.get_info("Device", :cl_device_type, "TYPE")

    ##
    # :method: partition_affinity_domain()
    # Returns an AffinityDomain representing the list of supported affinity domains for partitioning the Device using OpenCL::Device::PARTITION_BY_AFFINITY_DOMAIN
    eval OpenCL.get_info("Device", :cl_device_affinity_domain, "PARTITION_AFFINITY_DOMAIN")

    ##
    # :method: max_work_item_sizes()
    # Maximum number of work-items that can be specified in each dimension of the work-group to clEnqueueNDRangeKernel for the Device
    eval OpenCL.get_info_array("Device", :size_t, "MAX_WORK_ITEM_SIZES")

    ##
    # :method: partition_properties()
    # Returns the list of partition types supported by the Device
    eval OpenCL.get_info_array("Device", :cl_device_partition_property, "PARTITION_PROPERTIES")

    # Return an Array of partition properties names representing the partition type supported by the device
    def partition_properties_names
      prop_names = []
      props = self.partition_properties
      %w( PARTITION_EQUALLY PARTITION_BY_COUNTS PARTITION_BY_AFFINITY_DOMAIN ).each { |prop|
        prop_names.push(prop) if props.include?(OpenCL::Device.const_get(prop))
      }
    end

    ##
    # :method: partition_type()
    # Returns a list of :cl_device_partition_property used to create the Device
    eval OpenCL.get_info_array("Device", :cl_device_partition_property, "PARTITION_TYPE")

    # Returns the platform the Device belongs to
    def platform
      ptr = FFI::MemoryPointer::new( OpenCL::Platform )
      error = OpenCL.clGetDeviceInfo(self, Device::PLATFORM, OpenCL::Platform.size, ptr, nil)
      OpenCL.error_check(error)
      return OpenCL::Platform::new(ptr.read_pointer)
    end

    # Returns the parent Device if it exists
    def parent_device
      ptr = FFI::MemoryPointer::new( OpenCL::Device )
      error = OpenCL.clGetDeviceInfo(self, Device::PARENT_DEVICE, OpenCL::Device.size, ptr, nil)
      OpenCL.error_check(error)
      return nil if ptr.null?
      return OpenCL::Device::new(ptr.read_pointer)
    end

    # Partitions the Device in serveral sub-devices
    #
    # ==== Attributes
    # 
    # * +properties+ - an Array of :cl_device_partition_property
    #
    # ==== Returns
    #
    # an Array of Device
    def create_sub_devices( properties )
      return OpenCL.create_sub_devices( self, properties )
    end

    # Partitions the Device in serveral sub-devices by affinity domain
    #
    # ==== Attributes
    # 
    # * +affinity_domain+ - the :cl_device_partition_property specifying the target affinity domain
    #
    # ==== Returns
    #
    # an Array of Device
    def partition_by_affinity_domain( affinity_domain = OpenCL::Device::AFFINITY_DOMAIN_NEXT_PARTITIONABLE )
      return OpenCL.create_sub_devices( self,  [ OpenCL::Device::PARTITION_BY_AFFINITY_DOMAIN, affinity_domain ] )
    end

    # Partitions the Device in serveral sub-devices containing compute_unit_number compute units
    #
    # ==== Attributes
    # 
    # * +compute_unit_number+ - the number of compute units in each sub-device
    #
    # ==== Returns
    #
    # an Array of Device
    def partition_equally( compute_unit_number = 1 )
      return OpenCL.create_sub_devices( self,  [ OpenCL::Device::PARTITION_EQUALLY, compute_unit_number ] )
    end

    # Partitions the Device in serveral sub-devices each containing a specific number of compute units
    #
    # ==== Attributes
    # 
    # * +compute_unit_number_list+ - an Array of compute unit number
    #
    # ==== Returns
    #
    # an Array of Device
    def partition_by_count( compute_unit_number_list = [1] )
      return OpenCL.create_sub_devices( self,  [ OpenCL::Device::PARTITION_BY_COUNTS] + compute_unit_number_list + [ OpenCL::Device::PARTITION_BY_COUNTS_LIST_END ] )
    end

  end

end

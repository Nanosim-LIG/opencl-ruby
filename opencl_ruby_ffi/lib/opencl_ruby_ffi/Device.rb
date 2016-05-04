using OpenCLRefinements if RUBY_VERSION.scan(/\d+/).collect(&:to_i).first >= 2
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
  def self.create_sub_devices( in_device, properties )
    error_check(INVALID_OPERATION) if in_device.platform.version_number < 1.2
    props = MemoryPointer::new( :cl_device_partition_property, properties.length + 1 )
    properties.each_with_index { |e,i|
      props[i].write_cl_device_partition_property(e)
    }
    props[properties.length].write_cl_device_partition_property(0)
    device_number_ptr = MemoryPointer::new( :cl_uint )
    error = clCreateSubDevices( in_device, props, 0, nil, device_number_ptr )
    error_check(error)
    device_number = device_number_ptr.read_cl_uint
    devices_ptr = MemoryPointer::new( Device, device_number )
    error = clCreateSubDevices( in_device, props, device_number, devices_ptr, nil )
    error_check(error)
    devices_ptr.get_array_of_pointer(0, device_number).collect { |device_ptr|
      Device::new(device_ptr, false)
    }
  end

  def self.get_device_and_host_timer( device )
    error_check(INVALID_OPERATION) if device.platform.version_number < 2.1
    device_timestamp_p = MemoryPointer::new( :cl_ulong )
    host_timestamp_p = MemoryPointer::new( :cl_ulong )
    error = clGetDeviceAndHostTimer( device, device_timestamp_p, host_timestamp_p)
    error_check(error)
    return [ device_timestamp_p.read_cl_ulong, host_timestamp_p.read_cl_ulong ]
  end

  def self.get_host_timer( device )
    error_check(INVALID_OPERATION) if device.platform.version_number < 2.1
    host_timestamp_p = MemoryPointer::new( :cl_ulong )
    error = clGetHostTimer( device, host_timestamp_p)
    error_check(error)
    return host_timestamp_p.read_cl_ulong
  end

  # Maps the cl_device_id object of OpenCL
  class Device
    include InnerInterface

    class << self
      include InnerGenerator
    end

    def inspect
      return "#<#{self.class.name}: #{name} (#{pointer.to_i})>"
    end

    eval get_info("Device", :cl_uint, "ADDRESS_BITS")
    eval get_info("Device", :cl_bool, "AVAILABLE")
    eval get_info("Device", :cl_bool, "COMPILER_AVAILABLE")
    eval get_info("Device", :cl_bool, "ENDIAN_LITTLE")
    eval get_info("Device", :cl_bool, "ERROR_CORRECTION_SUPPORT")
    ##
    # :method: execution_capabilities()
    # Returns an ExecCpabilities representing the execution capabilities corresponding to the Device
    eval get_info("Device", :cl_device_exec_capabilities, "EXECUTION_CAPABILITIES")

    # Returns an Array of String corresponding to the Device extensions
    def extensions
      extensions_size = MemoryPointer::new( :size_t )
      error = OpenCL.clGetDeviceInfo( self, EXTENSIONS, 0, nil, extensions_size)
      error_check(error)
      ext = MemoryPointer::new( extensions_size.read_size_t )
      error = OpenCL.clGetDeviceInfo( self, EXTENSIONS, extensions_size.read_size_t, ext, nil)
      error_check(error)
      ext_string = ext.read_string
      return ext_string.split(" ")
    end

    eval get_info("Device", :cl_ulong, "GLOBAL_MEM_CACHE_SIZE")
    ##
    # :method: global_mem_cache_type()
    # Returns a MemCacheType representing the type of the global cache memory on the Device
    eval get_info("Device", :cl_device_mem_cache_type, "GLOBAL_MEM_CACHE_TYPE")
    eval get_info("Device", :cl_uint,  "GLOBAL_MEM_CACHELINE_SIZE")
    eval get_info("Device", :cl_ulong, "GLOBAL_MEM_SIZE")
    eval get_info("Device", :cl_bool,  "IMAGE_SUPPORT")
    eval get_info("Device", :size_t,   "IMAGE2D_MAX_HEIGHT")
    eval get_info("Device", :size_t,   "IMAGE2D_MAX_WIDTH")
    eval get_info("Device", :size_t,   "IMAGE3D_MAX_DEPTH")
    eval get_info("Device", :size_t,   "IMAGE3D_MAX_HEIGHT")
    eval get_info("Device", :size_t,   "IMAGE3D_MAX_WIDTH")
    eval get_info("Device", :cl_ulong, "LOCAL_MEM_SIZE")
    ##
    # :method: local_mem_type()
    # Returns a LocalMemType rpresenting the type of the local memory on the Device
    eval get_info("Device", :cl_device_local_mem_type, "LOCAL_MEM_TYPE")
    eval get_info("Device", :cl_uint,  "MAX_CLOCK_FREQUENCY")
    eval get_info("Device", :cl_uint,  "MAX_COMPUTE_UNITS")
    eval get_info("Device", :cl_uint,  "MAX_CONSTANT_ARGS")
    eval get_info("Device", :cl_ulong, "MAX_CONSTANT_BUFFER_SIZE")
    eval get_info("Device", :cl_ulong, "MAX_MEM_ALLOC_SIZE")
    eval get_info("Device", :size_t,   "MAX_PARAMETER_SIZE")
    eval get_info("Device", :cl_uint,  "MAX_READ_IMAGE_ARGS")
    eval get_info("Device", :cl_uint,  "MAX_SAMPLERS")
    eval get_info("Device", :size_t,   "MAX_WORK_GROUP_SIZE")
    eval get_info("Device", :cl_uint,  "MAX_WORK_ITEM_DIMENSIONS")
    ##
    # :method: max_work_item_sizes()
    # Maximum number of work-items that can be specified in each dimension of the work-group to clEnqueueNDRangeKernel for the Device
    eval get_info_array("Device", :size_t, "MAX_WORK_ITEM_SIZES")
    eval get_info("Device", :cl_uint, "MAX_WRITE_IMAGE_ARGS")
    eval get_info("Device", :cl_uint, "MEM_BASE_ADDR_ALIGN")
    eval get_info("Device", :cl_uint, "MIN_DATA_TYPE_ALIGN_SIZE")
    eval get_info("Device", :string,  "NAME")

    # Returns the Platform the Device belongs to
    def platform
      ptr = MemoryPointer::new( OpenCL::Platform )
      error = OpenCL.clGetDeviceInfo(self, PLATFORM, OpenCL::Platform.size, ptr, nil)
      error_check(error)
      return OpenCL::Platform::new(ptr.read_pointer)
    end

    eval get_info("Device", :cl_uint, "PREFERRED_VECTOR_WIDTH_CHAR")
    eval get_info("Device", :cl_uint, "PREFERRED_VECTOR_WIDTH_SHORT")
    eval get_info("Device", :cl_uint, "PREFERRED_VECTOR_WIDTH_INT")
    eval get_info("Device", :cl_uint, "PREFERRED_VECTOR_WIDTH_LONG")
    eval get_info("Device", :cl_uint, "PREFERRED_VECTOR_WIDTH_FLOAT")
    eval get_info("Device", :cl_uint, "PREFERRED_VECTOR_WIDTH_DOUBLE")
    eval get_info("Device", :string,  "PROFILE")
    eval get_info("Device", :size_t,  "PROFILING_TIMER_RESOLUTION")
    ##
    # :method: queue_properties()
    # Returns a CommandQueue::Properties representing the properties supported by a CommandQueue targetting the Device
    eval get_info("Device", :cl_command_queue_properties, "QUEUE_PROPERTIES")
    eval get_info("Device", :cl_device_fp_config,         "SINGLE_FP_CONFIG")
    ##
    # :method: type()
    # Returns a Device::Type representing the type of the Device
    eval get_info("Device", :cl_device_type, "TYPE")
    eval get_info("Device", :string,         "VENDOR")
    eval get_info("Device", :cl_uint,        "VENDOR_ID")
    eval get_info("Device", :string,         "VERSION")

    # returs a floating point number corresponding to the OpenCL version of the Device
    def version_number
      ver = self.version
      n = ver.scan(/OpenCL (\d+\.\d+)/)
      return n.first.first.to_f
    end

    eval get_info("Device", :string, "DRIVER_VERSION")

    module OpenCL11
      class << self
        include InnerGenerator
      end

      eval get_info("Device", :cl_bool, "HOST_UNIFIED_MEMORY")
      eval get_info("Device", :cl_uint, "NATIVE_VECTOR_WIDTH_CHAR")
      eval get_info("Device", :cl_uint, "NATIVE_VECTOR_WIDTH_SHORT")
      eval get_info("Device", :cl_uint, "NATIVE_VECTOR_WIDTH_INT")
      eval get_info("Device", :cl_uint, "NATIVE_VECTOR_WIDTH_LONG")
      eval get_info("Device", :cl_uint, "NATIVE_VECTOR_WIDTH_FLOAT")
      eval get_info("Device", :cl_uint, "NATIVE_VECTOR_WIDTH_DOUBLE")
      eval get_info("Device", :cl_uint, "NATIVE_VECTOR_WIDTH_HALF")
      eval get_info("Device", :string,  "OPENCL_C_VERSION")

      # returs a floating point number corresponding to the OpenCL C version of the Device
      def opencl_c_version_number
        ver = self.opencl_c_version
        n = ver.scan(/OpenCL C (\d+\.\d+)/)
        return n.first.first.to_f
      end

      eval get_info("Device", :cl_uint, "PREFERRED_VECTOR_WIDTH_HALF")
 
    end

    module OpenCL12
      class << self
        include InnerGenerator
      end

      # Returns an Array of String corresponding to the Device built in kernel names
      def built_in_kernels
        built_in_kernels_size = MemoryPointer::new( :size_t )
        error = OpenCL.clGetDeviceInfo( self, BUILT_IN_KERNELS, 0, nil, built_in_kernels_size)
        error_check(error)
        ker = MemoryPointer::new( built_in_kernels_size.read_size_t )
        error = OpenCL.clGetDeviceInfo( self, BUILT_IN_KERNELS, built_in_kernels_size.read_size_t, ker, nil)
        error_check(error)
        ker_string = ker.read_string
        return ker_string.split(";")
      end

      eval get_info("Device", :size_t,  "IMAGE_MAX_BUFFER_SIZE")
      eval get_info("Device", :size_t,  "IMAGE_MAX_ARRAY_SIZE")
      eval get_info("Device", :cl_bool, "LINKER_AVAILABLE")

      # Returns the parent Device if it exists
      def parent_device
        ptr = MemoryPointer::new( Device )
        error = OpenCL.clGetDeviceInfo(self, PARENT_DEVICE, Device.size, ptr, nil)
        error_check(error)
        return nil if ptr.null?
        return Device::new(ptr.read_pointer)
      end

      eval get_info("Device", :cl_uint, "PARTITION_MAX_SUB_DEVICES")

      ##
      # :method: partition_properties()
      # Returns the list of partition types supported by the Device
      def partition_properties
        ptr1 = MemoryPointer::new( :size_t, 1)
        error = OpenCL.clGetDeviceInfo(self, PARTITION_PROPERTIES, 0, nil, ptr1)
        error_check(error)
        ptr2 = MemoryPointer::new( ptr1.read_size_t )
        error = OpenCL.clGetDeviceInfo(self, PARTITION_PROPERTIES, ptr1.read_size_t, ptr2, nil)
        error_check(error)
        arr = ptr2.get_array_of_cl_device_partition_property(0, ptr1.read_size_t/ OpenCL.find_type(:cl_device_partition_property).size)
        arr.reject! { |e| e.null? }
        return arr.collect { |e| Partition::new(e.to_i) }
      end

      ##
      # :method: partition_affinity_domain()
      # Returns an AffinityDomain representing the list of supported affinity domains for partitioning the Device using OpenCL::Device::Partition::BY_AFFINITY_DOMAIN
      eval get_info("Device", :cl_device_affinity_domain, "PARTITION_AFFINITY_DOMAIN")

      ##
      # :method: partition_type()
      # Returns a list of :cl_device_partition_property used to create the Device
      def partition_type
        ptr1 = MemoryPointer::new( :size_t, 1)
        error = OpenCL.clGetDeviceInfo(self, PARTITION_TYPE, 0, nil, ptr1)
        error_check(error)
        ptr2 = MemoryPointer::new( ptr1.read_size_t )
        error = OpenCL.clGetDeviceInfo(self, PARTITION_TYPE, ptr1.read_size_t, ptr2, nil)
        error_check(error)
        arr = ptr2.get_array_of_cl_device_partition_property(0, ptr1.read_size_t/ OpenCL.find_type(:cl_device_partition_property).size)
        return [] if arr.length == 0
        ptype = arr.first.to_i
        arr_2 = []
        arr_2.push( Partition::new(ptype) )
        return arr_2 if arr.length == 1
        case ptype
        when Partition::BY_NAMES_EXT
          i = 1
          while arr[i].to_i - (0x1 << Pointer.size * 8) != Partition::BY_NAMES_LIST_END_EXT do
            arr_2.push( arr[i].to_i )
            i += 1
            return arr_2 if arr.length <= i
          end
          arr_2.push( Partition::new(Partition::BY_NAMES_LIST_END_EXT) )
          arr_2.push( 0 )
        when Partition::EQUALLY
          arr_2.push(arr[1].to_i)
          arr_2.push( 0 )
        when Partition::BY_COUNTS
          i = 1
          while arr[i].to_i != Partition::BY_COUNTS_LIST_END do
            arr_2.push( arr[i].to_i )
            i += 1
            return arr_2 if arr.length <= i
          end
          arr_2.push( Partition::new(Partition::BY_COUNTS_LIST_END) )
          arr_2.push( 0 )
        end
        return arr_2
      end

      eval get_info("Device", :size_t,  "PRINTF_BUFFER_SIZE")
      eval get_info("Device", :cl_bool, "PREFERRED_INTEROP_USER_SYNC")
      eval get_info("Device", :cl_uint, "REFERENCE_COUNT")
      #undef_method :min_data_type_align_size

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
      def partition_by_affinity_domain( affinity_domain = AFFINITY_DOMAIN_NEXT_PARTITIONABLE )
        return OpenCL.create_sub_devices( self,  [ PARTITION_BY_AFFINITY_DOMAIN, affinity_domain ] )
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
        return OpenCL.create_sub_devices( self,  [ PARTITION_EQUALLY, compute_unit_number ] )
      end

      # Partitions the Device in serveral sub-devices each containing a specific number of compute units
      #
      # ==== Attributes
      # 
      # * +compute_unit_count_list+ - an Array of compute unit counts
      #
      # ==== Returns
      #
      # an Array of Device
      def partition_by_counts( *compute_unit_count_list )
        compute_unit_count_list = [1] if compute_unit_count_list == []
        compute_unit_count_list.flatten!
        return OpenCL.create_sub_devices( self,  [ PARTITION_BY_COUNTS] + compute_unit_count_list + [ PARTITION_BY_COUNTS_LIST_END ] )
      end

      def partition_by_names_ext( *compute_unit_name_list )
        compute_unit_name_list = [0] if compute_unit_name_list == []
        compute_unit_name_list.flatten!
        return OpenCL.create_sub_devices( self,  [ Partition::BY_NAMES_EXT ] + compute_unit_name_list + [ Partition::BY_NAMES_LIST_END_EXT ] )
      end

    end


    module OpenCL20
      class << self
        include InnerGenerator
      end

      eval get_info("Device", :size_t,  "GLOBAL_VARIABLE_PREFERRED_TOTAL_SIZE")
      eval get_info("Device", :cl_uint, "IMAGE_BASE_ADDRESS_ALIGNMENT")
      eval get_info("Device", :cl_uint, "IMAGE_PITCH_ALIGNMENT")
      eval get_info("Device", :cl_uint, "MAX_ON_DEVICE_EVENTS")
      eval get_info("Device", :cl_uint, "MAX_ON_DEVICE_QUEUES")
      eval get_info("Device", :cl_uint, "MAX_PIPE_ARGS")
      eval get_info("Device", :cl_uint, "MAX_READ_IMAGE_ARGS")
      eval get_info("Device", :cl_uint, "MAX_READ_WRITE_IMAGE_ARGS")
      eval get_info("Device", :cl_uint, "PIPE_MAX_ACTIVE_RESERVATIONS")
      eval get_info("Device", :cl_uint, "PIPE_MAX_PACKET_SIZE")
      eval get_info("Device", :cl_uint, "PREFERRED_GLOBAL_ATOMIC_ALIGNMENT")
      eval get_info("Device", :cl_uint, "PREFERRED_LOCAL_ATOMIC_ALIGNMENT")
      eval get_info("Device", :cl_uint, "PREFERRED_PLATFORM_ATOMIC_ALIGNMENT")
      eval get_info("Device", :cl_uint, "QUEUE_ON_DEVICE_MAX_SIZE")
      eval get_info("Device", :cl_uint, "QUEUE_ON_DEVICE_PREFERRED_SIZE")
      ##
      # :method: queue_on_device_properties()
      # Returns a CommandQueue::Properties representing the properties supported by a CommandQueue on the Device
      eval get_info("Device", :cl_command_queue_properties, "QUEUE_ON_DEVICE_PROPERTIES")
      ##
      # :method: queue_on_host_properties()
      # Returns a CommandQueue::Properties representing the properties supported by a CommandQueue targetting the Device
      eval get_info("Device", :cl_command_queue_properties, "QUEUE_ON_HOST_PROPERTIES")

      ##
      # :method: svm_capabilities()
      # Returns an SVMCapabilities representing the the SVM capabilities corresponding to the device
      eval get_info_array("Device", :cl_device_svm_capabilities, "SVM_CAPABILITIES")

    end

    module OpenCL21
      class << self
        include InnerGenerator
      end

      eval get_info("Device", :string, "IL_VERSION")

      def il_version_number
        return il_version.scan(/(\d+\.\d+)/).first.first.to_f
      end

      eval get_info_array("Device", :cl_uint, "MAX_NUM_SUB_GROUPS")
      eval get_info_array("Device", :cl_bool, "SUBGROUP_INDEPENDENT_FORWARD_PROGRESS")

      def get_device_and_host_timer
        return OpenCL.get_device_and_host_timer( self )
      end

      def get_host_timer
        return OpenCL.get_host_timer( self )
      end

    end

    Extensions[:v11] = [ OpenCL11, "platform.version_number >= 1.1" ]
    Extensions[:v12] = [ OpenCL12, "platform.version_number >= 1.2" ]
    Extensions[:v20] = [ OpenCL20, "platform.version_number >= 2.0" ]
    Extensions[:v21] = [ OpenCL21, "platform.version_number >= 2.1" ]

  end

end

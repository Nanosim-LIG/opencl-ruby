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
    extend InnerGenerator

    def inspect
      return "#<#{self.class.name}: #{name} (#{pointer.to_i})>"
    end

    get_info("Device", :cl_uint, "address_bits", true)
    get_info("Device", :cl_bool, "available")
    get_info("Device", :cl_bool, "compiler_available")
    get_info("Device", :cl_bool, "endian_little")
    get_info("Device", :cl_bool, "error_correction_support")
    get_info("Device", :cl_device_exec_capabilities, "execution_capabilities")

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

    get_info("Device", :cl_ulong, "global_mem_cache_size")
    get_info("Device", :cl_device_mem_cache_type, "global_mem_cache_type")
    get_info("Device", :cl_uint,  "global_mem_cacheline_size")
    get_info("Device", :cl_ulong, "global_mem_size")
    get_info("Device", :cl_bool,  "image_support")
    get_info("Device", :size_t,   "image2d_max_height")
    get_info("Device", :size_t,   "image2d_max_width")
    get_info("Device", :size_t,   "image3d_max_depth")
    get_info("Device", :size_t,   "image3d_max_height")
    get_info("Device", :size_t,   "image3d_max_width")
    get_info("Device", :cl_ulong, "local_mem_size")
    get_info("Device", :cl_device_local_mem_type, "local_mem_type")
    get_info("Device", :cl_uint,  "max_clock_frequency")
    get_info("Device", :cl_uint,  "max_compute_units")
    get_info("Device", :cl_uint,  "max_constant_args")
    get_info("Device", :cl_ulong, "max_constant_buffer_size")
    get_info("Device", :cl_ulong, "max_mem_alloc_size")
    get_info("Device", :size_t,   "max_parameter_size")
    get_info("Device", :cl_uint,  "max_read_image_args")
    get_info("Device", :cl_uint,  "max_samplers")
    get_info("Device", :size_t,   "max_work_group_size")
    get_info("Device", :cl_uint,  "max_work_item_dimensions")
    get_info_array("Device", :size_t, "max_work_item_sizes")
    get_info("Device", :cl_uint, "max_write_image_args")
    get_info("Device", :cl_uint, "mem_base_addr_align")
    get_info("Device", :cl_uint, "min_data_type_align_size")
    get_info("Device", :string,  "name", true)

    alias to_s name

    # Returns the Platform the Device belongs to
    def platform
      return @_platform if @_platform
      ptr = MemoryPointer::new( OpenCL::Platform )
      error = OpenCL.clGetDeviceInfo(self, PLATFORM, OpenCL::Platform.size, ptr, nil)
      error_check(error)
      @_platform = OpenCL::Platform::new(ptr.read_pointer)
    end

    get_info("Device", :cl_uint, "preferred_vector_width_char")
    get_info("Device", :cl_uint, "preferred_vector_width_short")
    get_info("Device", :cl_uint, "preferred_vector_width_int")
    get_info("Device", :cl_uint, "preferred_vector_width_long")
    get_info("Device", :cl_uint, "preferred_vector_width_float")
    get_info("Device", :cl_uint, "preferred_vector_width_double")
    get_info("Device", :string,  "profile", true)
    get_info("Device", :size_t,  "profiling_timer_resolution")
    get_info("Device", :cl_command_queue_properties, "queue_properties")
    get_info("Device", :cl_device_fp_config,         "single_fp_config")
    get_info("Device", :cl_device_type, "type", true)
    get_info("Device", :string,         "vendor", true)
    get_info("Device", :cl_uint,        "vendor_id", true)
    get_info("Device", :string,         "version", true)

    # returs a floating point number corresponding to the OpenCL version of the Device
    def version_number
      ver = self.version
      n = ver.scan(/OpenCL (\d+\.\d+)/)
      return n.first.first.to_f
    end

    get_info("Device", :string, "driver_version")

    module OpenCL11
      extend InnerGenerator

      get_info("Device", :cl_bool, "host_unified_memory")
      get_info("Device", :cl_uint, "native_vector_width_char")
      get_info("Device", :cl_uint, "native_vector_width_short")
      get_info("Device", :cl_uint, "native_vector_width_int")
      get_info("Device", :cl_uint, "native_vector_width_long")
      get_info("Device", :cl_uint, "native_vector_width_float")
      get_info("Device", :cl_uint, "native_vector_width_double")
      get_info("Device", :cl_uint, "native_vector_width_half")
      get_info("Device", :string,  "opencl_c_version")

      # returs a floating point number corresponding to the OpenCL C version of the Device
      def opencl_c_version_number
        ver = self.opencl_c_version
        n = ver.scan(/OpenCL C (\d+\.\d+)/)
        return n.first.first.to_f
      end

      get_info("Device", :cl_uint, "preferred_vector_width_half")
 
    end

    module OpenCL12
      extend InnerGenerator

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

      get_info("Device", :size_t,  "image_max_buffer_size")
      get_info("Device", :size_t,  "image_max_array_size")
      get_info("Device", :cl_bool, "linker_available")

      # Returns the parent Device if it exists
      def parent_device
        ptr = MemoryPointer::new( Device )
        error = OpenCL.clGetDeviceInfo(self, PARENT_DEVICE, Device.size, ptr, nil)
        error_check(error)
        return nil if ptr.null?
        return Device::new(ptr.read_pointer)
      end

      get_info("Device", :cl_uint, "partition_max_sub_devices")

      ##
      # @!method partition_properties()
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

      get_info("Device", :cl_device_affinity_domain, "partition_affinity_domain")

      ##
      # @!method partition_type()
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

      get_info("Device", :size_t,  "printf_buffer_size")
      get_info("Device", :cl_bool, "preferred_interop_user_sync")
      get_info("Device", :cl_uint, "reference_count")
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

      def partition_by_names_intel( *compute_unit_name_list )
        compute_unit_name_list = [0] if compute_unit_name_list == []
        compute_unit_name_list.flatten!
        return OpenCL.create_sub_devices( self,  [ Partition::BY_NAMES_INTEL ] + compute_unit_name_list + [ Partition::BY_NAMES_LIST_END_INTEL ] )
      end

    end


    module OpenCL20
      extend InnerGenerator

      get_info("Device", :size_t,  "global_variable_preferred_total_size")
      get_info("Device", :cl_uint, "image_base_address_alignment")
      get_info("Device", :cl_uint, "image_pitch_alignment")
      get_info("Device", :cl_uint, "max_on_device_events")
      get_info("Device", :cl_uint, "max_on_device_queues")
      get_info("Device", :cl_uint, "max_pipe_args")
      get_info("Device", :cl_uint, "max_read_image_args")
      get_info("Device", :cl_uint, "max_read_write_image_args")
      get_info("Device", :cl_uint, "pipe_max_active_reservations")
      get_info("Device", :cl_uint, "pipe_max_packet_size")
      get_info("Device", :cl_uint, "preferred_global_atomic_alignment")
      get_info("Device", :cl_uint, "preferred_local_atomic_alignment")
      get_info("Device", :cl_uint, "preferred_platform_atomic_alignment")
      get_info("Device", :cl_uint, "queue_on_device_max_size")
      get_info("Device", :cl_uint, "queue_on_device_preferred_size")
      get_info("Device", :cl_command_queue_properties, "queue_on_device_properties")
      get_info("Device", :cl_command_queue_properties, "queue_on_host_properties")
      get_info_array("Device", :cl_device_svm_capabilities, "svm_capabilities")

    end

    module OpenCL21
      extend InnerGenerator

      get_info("Device", :string, "il_version")

      def il_version_number
        return il_version.scan(/(\d+\.\d+)/).first.first.to_f
      end

      get_info_array("Device", :cl_uint, "max_num_sub_groups")
      get_info_array("Device", :cl_bool, "subgroup_independent_forward_progress")

      def get_device_and_host_timer
        return OpenCL.get_device_and_host_timer( self )
      end

      def get_host_timer
        return OpenCL.get_host_timer( self )
      end

    end

    register_extension( :v11,  OpenCL11, "platform.version_number >= 1.1" )
    register_extension( :v12,  OpenCL12, "platform.version_number >= 1.2" )
    register_extension( :v20,  OpenCL20, "platform.version_number >= 2.0" )
    register_extension( :v21,  OpenCL21, "platform.version_number >= 2.1" )

  end

end

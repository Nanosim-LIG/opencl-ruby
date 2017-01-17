using OpenCLRefinements if RUBY_VERSION.scan(/\d+/).collect(&:to_i).first >= 2

module OpenCL

  DEVICE_TOPOLOGY_TYPE_PCIE_AMD = 1
  DEVICE_PROFILING_TIMER_OFFSET_AMD = 0x4036
  DEVICE_TOPOLOGY_AMD = 0x4037
  DEVICE_BOARD_NAME_AMD = 0x4038
  DEVICE_GLOBAL_FREE_MEMORY_AMD = 0x4039
  DEVICE_SIMD_PER_COMPUTE_UNIT_AMD = 0x4040
  DEVICE_SIMD_WIDTH_AMD = 0x4041
  DEVICE_SIMD_INSTRUCTION_WIDTH_AMD = 0x4042
  DEVICE_WAVEFRONT_WIDTH_AMD = 0x4043
  DEVICE_GLOBAL_MEM_CHANNELS_AMD = 0x4044
  DEVICE_GLOBAL_MEM_CHANNEL_BANKS_AMD = 0x4045
  DEVICE_GLOBAL_MEM_CHANNEL_BANK_WIDTH_AMD = 0x4046
  DEVICE_LOCAL_MEM_SIZE_PER_COMPUTE_UNIT_AMD = 0x4047
  DEVICE_LOCAL_MEM_BANKS_AMD = 0x4048
  DEVICE_THREAD_TRACE_SUPPORTED_AMD = 0x4049
  DEVICE_GFXIP_MAJOR_AMD = 0x404A
  DEVICE_GFXIP_MINOR_AMD = 0x404B
  DEVICE_AVAILABLE_ASYNC_QUEUES_AMD = 0x404C

  class Device

    TOPOLOGY_TYPE_PCIE_AMD = 1
    PROFILING_TIMER_OFFSET_AMD = 0x4036
    TOPOLOGY_AMD = 0x4037
    BOARD_NAME_AMD = 0x4038
    GLOBAL_FREE_MEMORY_AMD = 0x4039
    SIMD_PER_COMPUTE_UNIT_AMD = 0x4040
    SIMD_WIDTH_AMD = 0x4041
    SIMD_INSTRUCTION_WIDTH_AMD = 0x4042
    WAVEFRONT_WIDTH_AMD = 0x4043
    GLOBAL_MEM_CHANNELS_AMD = 0x4044
    GLOBAL_MEM_CHANNEL_BANKS_AMD = 0x4045
    GLOBAL_MEM_CHANNEL_BANK_WIDTH_AMD = 0x4046
    LOCAL_MEM_SIZE_PER_COMPUTE_UNIT_AMD = 0x4047
    LOCAL_MEM_BANKS_AMD = 0x4048
    THREAD_TRACE_SUPPORTED_AMD = 0x4049
    GFXIP_MAJOR_AMD = 0x404A
    GFXIP_MINOR_AMD = 0x404B
    AVAILABLE_ASYNC_QUEUES_AMD = 0x404C

    module AMDDeviceAttributeQuery
      extend InnerGenerator

      class AMDTopology < Union
        class Raw < Struct
          layout :type,  UInt,
                 :data, [UInt, 5]
        end
        class PCIE < Struct
          layout :type,     UInt,
                 :unused,  [Char, 17],
                 :bus,      Char,
                 :device,   Char,
                 :function, Char
        end
        layout :raw, Raw,
               :pcie, PCIE
      end

      get_info("Device", :string, "board_name_amd")

      get_info("Device", :cl_ulong, "profiling_timer_offset_amd")

      get_info("Device", :cl_uint, "simd_per_compute_unit_amd")
      get_info("Device", :cl_uint, "simd_width_amd")
      get_info("Device", :cl_uint, "simd_instruction_width_amd")
      get_info("Device", :cl_uint, "wavefront_width_amd")
      get_info("Device", :cl_uint, "global_mem_channels_amd")
      get_info("Device", :cl_uint, "global_mem_channel_banks_amd")
      get_info("Device", :cl_uint, "global_mem_channel_bank_width_amd")
      get_info("Device", :cl_uint, "local_mem_banks_amd")
      get_info("Device", :cl_uint, "gfxip_major_amd")
      get_info("Device", :cl_uint, "gfxip_minor_amd")
      get_info("Device", :cl_uint, "available_async_queues_amd")

      get_info("Device", :cl_bool, "thread_trace_supported_amd")

      get_info("Device", :size_t, "local_mem_size_per_compute_unit_amd")

      get_info_array("Device", :size_t, "global_free_memory_amd")

      def topology_amd
        ptr1 = MemoryPointer::new( AMDTopology )
        error = OpenCL.clGetDeviceInfo(self, TOPOLOGY_AMD, ptr1.size, ptr1, nil)
        error_check(error)
        return AMDTopology::new(ptr1)
      end

    end

    register_extension( :cl_amd_device_attribute_query,  AMDDeviceAttributeQuery, "extensions.include?(\"cl_amd_device_attribute_query\")" )

  end

end

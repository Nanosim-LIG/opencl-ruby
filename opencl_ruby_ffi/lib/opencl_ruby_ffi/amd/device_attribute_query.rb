require 'opencl_ruby_ffi'
using OpenCLRefinements if RUBY_VERSION.scan(/\d+/).collect(&:to_i).first >= 2

module OpenCL

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

  module AMDDeviceAttributeQueryDevice
    class << self
      include InnerGenerator
    end

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

    eval get_info("Device", :string, "BOARD_NAME_AMD")

    eval get_info("Device", :cl_ulong, "PROFILING_TIMER_OFFSET_AMD")

    %w( SIMD_PER_COMPUTE_UNIT_AMD SIMD_WIDTH_AMD SIMD_INSTRUCTION_WIDTH_AMD WAVEFRONT_WIDTH_AMD GLOBAL_MEM_CHANNELS_AMD GLOBAL_MEM_CHANNEL_BANKS_AMD GLOBAL_MEM_CHANNEL_BANK_WIDTH_AMD LOCAL_MEM_BANKS_AMD GFXIP_MAJOR_AMD GFXIP_MINOR_AMD AVAILABLE_ASYNC_QUEUES_AMD ).each { |prop|
      eval get_info("Device", :cl_uint, prop)
    }

    eval get_info("Device", :cl_bool, "THREAD_TRACE_SUPPORTED_AMD")

    eval get_info("Device", :size_t, "LOCAL_MEM_SIZE_PER_COMPUTE_UNIT_AMD")

    eval get_info_array("Device", :size_t, "GLOBAL_FREE_MEMORY_AMD")

    def topology_amd
      ptr1 = MemoryPointer::new( AMDTopology )
      error = OpenCL.clGetDeviceInfo(self, TOPOLOGY_AMD, ptr1.size, ptr1, nil)
      error_check(error)
      return AMDTopology::new(ptr1)
    end

  end

  Device::Extensions[:cl_amd_device_attribute_query] = [ AMDDeviceAttributeQueryDevice, "extensions.include?(\"cl_amd_device_attribute_query\")" ]

end

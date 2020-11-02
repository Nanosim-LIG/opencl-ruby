using OpenCLRefinements if RUBY_VERSION.scan(/\d+/).collect(&:to_i).first >= 2

module OpenCL

  DEVICE_COMPUTE_CAPABILITY_MAJOR_NV = 0x4000
  DEVICE_COMPUTE_CAPABILITY_MINOR_NV = 0x4001
  DEVICE_REGISTERS_PER_BLOCK_NV = 0x4002
  DEVICE_WARP_SIZE_NV = 0x4003
  DEVICE_GPU_OVERLAP_NV = 0x4004
  DEVICE_KERNEL_EXEC_TIMEOUT_NV = 0x4005
  DEVICE_INTEGRATED_MEMORY_NV = 0x4006
  DEVICE_ATTRIBUTE_ASYNC_ENGINE_COUNT_NV = 0x4007
  DEVICE_PCI_BUS_ID_NV = 0x4008
  DEVICE_PCI_SLOT_ID_NV = 0x4009

  class Device

    COMPUTE_CAPABILITY_MAJOR_NV = 0x4000
    COMPUTE_CAPABILITY_MINOR_NV = 0x4001
    REGISTERS_PER_BLOCK_NV = 0x4002
    WARP_SIZE_NV = 0x4003
    GPU_OVERLAP_NV = 0x4004
    KERNEL_EXEC_TIMEOUT_NV = 0x4005
    INTEGRATED_MEMORY_NV = 0x4006
    ATTRIBUTE_ASYNC_ENGINE_COUNT_NV = 0x4007
    PCI_BUS_ID_NV = 0x4008
    PCI_SLOT_ID_NV = 0x4009

    module NVDeviceAttributeQuery
      extend InnerGenerator

      get_info("Device", :cl_uint, "compute_capability_major_nv")
      get_info("Device", :cl_uint, "compute_capability_minor_nv")
      get_info("Device", :cl_uint, "registers_per_block_nv")
      get_info("Device", :cl_uint, "warp_size_nv")
      get_info("Device", :cl_uint, "attribute_async_engine_count_nv")
      get_info("Device", :cl_uint, "pci_bus_id_nv")
      get_info("Device", :cl_uint, "pci_slot_id_nv")
      get_info("Device", :cl_bool, "gpu_overlap_nv")
      get_info("Device", :cl_bool, "kernel_exec_timeout_nv")
      get_info("Device", :cl_bool, "integrated_memory_nv")

    end

    register_extension( :cl_nv_device_attribute_query, NVDeviceAttributeQuery, "extensions.include?(\"cl_nv_device_attribute_query\")" )

  end

end

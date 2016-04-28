require 'opencl_ruby_ffi'
using OpenCLRefinements if RUBY_VERSION.scan(/\d+/).collect(&:to_i).first >= 2

module OpenCL

  DEVICE_COMPUTE_CAPABILITY_MAJOR_NV = 0x4000
  DEVICE_COMPUTE_CAPABILITY_MINOR_NV = 0x4001
  DEVICE_REGISTERS_PER_BLOCK_NV = 0x4002
  DEVICE_WARP_SIZE_NV = 0x4003
  DEVICE_GPU_OVERLAP_NV = 0x4004
  DEVICE_KERNEL_EXEC_TIMEOUT_NV = 0x4005
  DEVICE_INTEGRATED_MEMORY_NV = 0x4006

  module NVDeviceAttributeQueryDevice
    class << self
      include InnerGenerator
    end

    COMPUTE_CAPABILITY_MAJOR_NV = 0x4000
    COMPUTE_CAPABILITY_MINOR_NV = 0x4001
    REGISTERS_PER_BLOCK_NV = 0x4002
    WARP_SIZE_NV = 0x4003
    GPU_OVERLAP_NV = 0x4004
    KERNEL_EXEC_TIMEOUT_NV = 0x4005
    INTEGRATED_MEMORY_NV = 0x4006

    %w( COMPUTE_CAPABILITY_MAJOR_NV COMPUTE_CAPABILITY_MINOR_NV REGISTERS_PER_BLOCK_NV WARP_SIZE_NV ).each { |prop|
      eval get_info("Device", :cl_uint, prop)
    }

    %w( GPU_OVERLAP_NV KERNEL_EXEC_TIMEOUT_NV INTEGRATED_MEMORY_NV ).each { |prop|
      eval get_info("Device", :cl_bool, prop)
    }

  end

  Device::Extensions[:cl_nv_device_attribute_query] = [ NVDeviceAttributeQueryDevice, "extensions.include?(\"cl_nv_device_attribute_query\")" ]

end

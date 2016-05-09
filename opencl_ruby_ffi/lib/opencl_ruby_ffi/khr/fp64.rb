require 'opencl_ruby_ffi'
using OpenCLRefinements if RUBY_VERSION.scan(/\d+/).collect(&:to_i).first >= 2

module OpenCL

  DEVICE_DOUBLE_FP_CONFIG = 0x1032

  class Device

    DOUBLE_FP_CONFIG = 0x1032

    module KHRFP64
      class << self
        include InnerGenerator
      end

      eval get_info("Device", :cl_device_fp_config,  "DOUBLE_FP_CONFIG")

    end

    register_extension( :cl_khr_fp64,  KHRFP64, "platform.version_number >= 1.2 or extensions.include?(\"cl_khr_fp64\")" )

  end

end

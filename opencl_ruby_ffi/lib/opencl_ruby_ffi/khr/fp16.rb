require 'opencl_ruby_ffi'
using OpenCLRefinements if RUBY_VERSION.scan(/\d+/).collect(&:to_i).first >= 2

module OpenCL

  DEVICE_HALF_FP_CONFIG = 0x1033

  class Device

    HALF_FP_CONFIG = 0x1033

    module KHRFP16
      extend InnerGenerator

      get_info("Device", :cl_device_fp_config,  "half_fp_config")

    end

    register_extension( :cl_khr_fp16,  KHRFP16, "extensions.include?(\"cl_khr_fp16\")" )

  end

end

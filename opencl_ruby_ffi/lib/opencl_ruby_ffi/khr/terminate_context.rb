require 'opencl_ruby_ffi'
using OpenCLRefinements if RUBY_VERSION.scan(/\d+/).collect(&:to_i).first >= 2

module OpenCL

  DEVICE_TERMINATE_CAPABILITY_KHR = 0x2031
  CONTEXT_TERMINATE_KHR = 0x2032

  attach_extension_function("clTerminateContextKHR", :cl_int, [Context])

  def self.terminate_context_khr( context )
    error_check(INVALID_OPERATION) unless context.platform.extensions.include? "cl_khr_terminate_context"
    error = clTerminateContextKHR( context )
    error_check(error)
  end

  class Device

    TERMINATE_CAPABILITY_KHR = 0x2031

    get_info("Device", :cl_bitfield, "terminate_capability_khr")

  end

  class Context

    TERMINATE_KHR = 0x2032

    class Properties
      TERMINATE_KHR = 0x2032
      @codes[0x2032] = 'TERMINATE_KHR'
    end

    module KHRTerminateContext

      def terminate_context_khr
        return OpenCL.terminate_context_khr(self)
      end

    end

    register_extension( :cl_khr_terminate_context, KHRTerminateContext, "platform.extensions.include?(\"cl_khr_terminate_context\")" )

  end

end

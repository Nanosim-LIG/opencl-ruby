require 'opencl_ruby_ffi'
using OpenCLRefinements if RUBY_VERSION.scan(/\d+/).collect(&:to_i).first >= 2

module OpenCL

  DEVICE_TERMINATE_CAPABILITY_KHR = 0x200F
  CONTEXT_TERMINATE_KHR = 0x2010

  name_p = MemoryPointer.from_string("clTerminateContextKHR")
  p = clGetExtensionFunctionAddress(name_p)
  if p then
    func = Function::new( :cl_int, [Context], p )
    func.attach(OpenCL, "clTerminateContextKHR")
  end

  def self.terminate_context_khr( context )
    error_check(INVALID_OPERATION) unless context.platform.extensions.include? "cl_khr_terminate_context"
    error = clTerminateContextKHR( context )
    error_check(error)
  end

  class Device

    TERMINATE_CAPABILITY_KHR = 0x200F

    eval get_info("Device", :cl_bitfield, "TERMINATE_CAPABILITY_KHR")

  end

  class Context

    TERMINATE_KHR = 0x2010

    class Properties
      TERMINATE_KHR = 0x2032
      @codes[0x2032] = 'TERMINATE_KHR'
    end

    def terminate_context_khr
      return OpenCL.terminate_context_khr(self)
    end

  end

end

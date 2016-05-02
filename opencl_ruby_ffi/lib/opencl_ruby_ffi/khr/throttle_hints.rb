require 'opencl_ruby_ffi'
using OpenCLRefinements if RUBY_VERSION.scan(/\d+/).collect(&:to_i).first >= 2

module OpenCL

  QUEUE_THROTTLE_KHR = 0x1097
  QUEUE_THROTTLE_HIGH_KHR = (1<<0)
  QUEUE_THROTTLE_MED_KHR = (1<<1)
  QUEUE_THROTTLE_LOW_KHR = (1<<2)

  class CommandQueue

    THROTTLE_KHR = 0x1097
    THROTTLE_HIGH_KHR = (1 << 0)
    THROTTLE_MED_KHR = (1 << 1)
    THROTTLE_LOW_KHR = (1 << 2)

    class ThrottleKHR < Enum
      HIGH_KHR = (1 << 0)
      MED_KHR = (1 << 1)
      LOW_KHR = (1 << 2)
      @codes = {}
      @codes[(1 << 0)] = 'HIGH_KHR'
      @codes[(1 << 1)] = 'MED_KHR'
      @codes[(1 << 2)] = 'LOW_KHR'
    end

  end

  module InnerInterface
    TYPE_CONVERTER[:cl_queue_throttle_khr] = CommandQueue::ThrottleKHR
  end

  module KHRThrottleHintsCommandQueue

    class << self
      include InnerGenerator
    end

    ##
    # :method: throttle_khr
    # Returns the :cl_queue_throttle_khr used to create the CommandQueue (2.1 and cl_khr_throttle_hints required)
    eval get_info("CommandQueue", :cl_queue_throttle_khr, "THROTTLE_KHR", "CommandQueue::")

  end

  CommandQueue::Extensions[:cl_khr_throttle_hints] = [KHRThrottleHintsCommandQueue, "device.platform.extensions.include?(\"cl_khr_throttle_hints\")"]

end

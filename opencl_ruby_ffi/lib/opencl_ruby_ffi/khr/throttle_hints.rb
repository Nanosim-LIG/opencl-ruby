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
      THROTTLE_HIGH_KHR = (1 << 0)
      THROTTLE_MED_KHR = (1 << 1)
      THROTTLE_LOW_KHR = (1 << 2)
      @codes = {}
      @codes[(1 << 0)] = 'THROTTLE_HIGH_KHR'
      @codes[(1 << 1)] = 'THROTTLE_MED_KHR'
      @codes[(1 << 2)] = 'THROTTLE_LOW_KHR'
    end

  end

  module InnerInterface
    TYPE_CONVERTER[:cl_queue_throttle_khr] = CommandQueue::ThrottleKHR
  end

end

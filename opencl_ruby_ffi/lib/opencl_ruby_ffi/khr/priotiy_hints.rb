require 'opencl_ruby_ffi'
using OpenCLRefinements if RUBY_VERSION.scan(/\d+/).collect(&:to_i).first >= 2

module OpenCL

  QUEUE_PRIORITY_KHR = 0x1096
  QUEUE_PRIORITY_HIGH_KHR = (1<<0)
  QUEUE_PRIORITY_MED_KHR = (1<<1)
  QUEUE_PRIORITY_LOW_KHR = (1<<2)

  class CommandQueue

    PRIORITY_KHR = 0x1096
    PRIORITY_HIGH_KHR = (1 << 0)
    PRIORITY_MED_KHR = (1 << 1)
    PRIORITY_LOW_KHR = (1 << 2)

    class PriorityKHR < Enum
      PRIORITY_HIGH_KHR = (1 << 0)
      PRIORITY_MED_KHR = (1 << 1)
      PRIORITY_LOW_KHR = (1 << 2)
      @codes = {}
      @codes[(1 << 0)] = 'PRIORITY_HIGH_KHR'
      @codes[(1 << 1)] = 'PRIORITY_MED_KHR'
      @codes[(1 << 2)] = 'PRIORITY_LOW_KHR'
    end

  end

  InnerInterface::TYPE_CONVERTER[:cl_queue_priority_khr] = CommandQueue::PriorityKHR

end

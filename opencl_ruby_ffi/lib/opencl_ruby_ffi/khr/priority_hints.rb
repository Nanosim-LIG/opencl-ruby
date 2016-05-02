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

  module InnerInterface
    TYPE_CONVERTER[:cl_queue_priority_khr] = CommandQueue::PriorityKHR
  end

  module KHRPriorityHintsCommandQueue

    class << self
      include InnerGenerator
    end

    ##
    # :method: priority_khr
    # Returns the :cl_queue_priority_khr used to create the CommandQueue
    eval get_info("CommandQueue", :cl_queue_priority_khr, "PRIORITY_KHR", "CommandQueue::")

  end

  CommandQueue::Extensions[:cl_khr_priority_hints] = [KHRPriorityHintsCommandQueue, "device.platform.extensions.include?(\"cl_khr_priority_hints\")"]

end

require 'opencl_ruby_ffi'
using OpenCLRefinements if RUBY_VERSION.scan(/\d+/).collect(&:to_i).first >= 2

module OpenCL

  PLATFORM_NOT_FOUND_KHR = -1001

  PLATFORM_ICD_SUFFIX_KHR = 0x0920

  class Error

    # Represents the OpenCL CL_PLATFORM_NOT_FOUND_KHR error
    class PLATFORM_NOT_FOUND_KHR < Error

      # Initilizes code to -1001
      def initialize
        super(-1001)
      end

      # Returns a string representing the name corresponding to the error classe
      def self.name
        return "PLATFORM_NOT_FOUND_KHR"
      end

      # Returns a string representing the name corresponding to the error
      def name
        return "PLATFORM_NOT_FOUND_KHR"
      end

      # Returns the code corresponding to this error class
      def self.code
        return -1001
      end

    end

    CLASSES[-1001] = PLATFORM_NOT_FOUND_KHR
    PlatformNotFoundKHR = PLATFORM_NOT_FOUND_KHR

  end

end

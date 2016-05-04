require 'opencl_ruby_ffi'
using OpenCLRefinements if RUBY_VERSION.scan(/\d+/).collect(&:to_i).first >= 2

module OpenCL

  DEVICE_SPIR_VERSIONS = 0x40E0
  PROGRAM_BINARY_TYPE_INTERMEDIATE = 0x40E1

  class Device
    SPIR_VERSIONS = 0x40E0

    module KHRSPIR

      # Return an Array of String corresponding to the SPIR versions supported by the device
      def spir_versions
        spir_versions_size = MemoryPointer::new( :size_t )
        error = OpenCL.clGetDeviceInfo( self, SPIR_VERSIONS, 0, nil, spir_versions_size)
        error_check(error)
        vers = MemoryPointer::new( spir_versions_size.read_size_t )
        error = OpenCL.clGetDeviceInfo( self, SPIR_VERSIONS, spir_versions_size.read_size_t, vers, nil)
        error_check(error)
        vers_string = vers.read_string
        return vers_string.split(" ")
      end

      def spir_versions_number
        vers_strings = spir_versions
        return vers_strings.collect { |s| s.scan(/(\d+\.\d+)/).first.first.to_f }
      end

    end

    Extensions[:cl_khr_spir] = [ KHRSPIR, "platform.extensions.include?(\"cl_khr_spir\") or extensions.include?(\"cl_khr_spir\")" ]

  end

  class Program
    BINARY_TYPE_INTERMEDIATE = 0x40E1
    class BinaryType
      INTERMEDIATE = 0x40E1
      @codes[0x40E1] = 'INTERMEDIATE'
    end
  end

end

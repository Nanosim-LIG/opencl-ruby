using OpenCLRefinements if RUBY_VERSION.scan(/\d+/).collect(&:to_i).first >= 2
module OpenCL

  CONTEXT_KERNEL_PROFILING_MODES_COUNT_INTEL = 0x407A
  CONTEXT_KERNEL_PROFILING_MODE_INFO_INTEL = 0x407B
  KERNEL_IL_SYMBOLS_INTEL = 0x407C
  KERNEL_BINARY_PROGRAM_INTEL = 0x407D

  class Kernel
    IL_SYMBOLS_INTEL = 0x407C
    BINARY_PROGRAM_INTEL = 0x407D
    module KernelProfilingINTEL
      def binary_program_intel(device = program.devices.first)
        ptr_bin = nil
        begin
        ptr = MemoryPointer::new( :size_t )
        error = OpenCL.clGetKernelWorkGroupInfo(self, device, BINARY_PROGRAM_INTEL, 0, nil, ptr)
        error_check(error)
        bin_size = ptr.read_size_t
        ptr_bin = MemoryPointer::new(bin_size)
        error = OpenCL.clGetKernelWorkGroupInfo(self, device, BINARY_PROGRAM_INTEL, bin_size, ptr_bin, nil)
        error_check(error)
        rescue OpenCL::Error::INVALID_VALUE
          ptr = MemoryPointer::new( :size_t )
          error = OpenCL.clGetKernelInfo(self, BINARY_PROGRAM_INTEL, 0, nil, ptr)
          error_check(error)
          bin_size = ptr.read_size_t
          ptr_bin = MemoryPointer::new(bin_size)
          error = OpenCL.clGetKernelInfo(self, BINARY_PROGRAM_INTEL, bin_size, ptr_bin, nil)
          error_check(error)
        end
        return ptr_bin.read_bytes(bin_size)
      end
    end
    register_extension(:cl_intel_kernel_profiling, KernelProfilingINTEL, "true")
  end

end

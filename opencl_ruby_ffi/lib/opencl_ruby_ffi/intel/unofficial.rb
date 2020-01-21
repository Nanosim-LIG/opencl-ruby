if RUBY_VERSION.scan(/\d+/).collect(&:to_i).first >= 2
  using OpenCLRefinements
end

module OpenCL

  # Unofficial kernel profiling extension
  CONTEXT_KERNEL_PROFILING_MODES_COUNT_INTEL = 0x407A
  CONTEXT_KERNEL_PROFILING_MODE_INFO_INTEL   = 0x407B
  KERNEL_IL_SYMBOLS_INTEL                    = 0x407C
  KERNEL_BINARY_PROGRAM_INTEL                = 0x407D
  # Unofficial VTune Debug Info extension
  PROGRAM_DEBUG_INFO_INTEL                   = 0x4100
  PROGRAM_DEBUG_INFO_SIZES_INTEL             = 0x4101
  KERNEL_BINARIES_INTEL                      = 0x4102
  KERNEL_BINARY_SIZES_INTEL                  = 0x4103

  class Kernel
    IL_SYMBOLS_INTEL                    = 0x407C
    BINARY_PROGRAM_INTEL                = 0x407D
    BINARIES_INTEL                      = 0x4102
    BINARY_SIZES_INTEL                  = 0x4103
 
    def binary_program_intel(device = program.devices.first)
      sz = MemoryPointer::new( :size_t )
      begin
        error = OpenCL.clGetKernelWorkGroupInfo(self, device, BINARY_PROGRAM_INTEL, 0, nil, sz)
        error_check(error)
        sz = sz.read_size_t
        bin = MemoryPointer::new(sz)
        error = OpenCL.clGetKernelWorkGroupInfo(self, device, BINARY_PROGRAM_INTEL, sz, bin, nil)
        error_check(error)
        return bin.read_bytes(sz)
      rescue
        error = OpenCL.clGetKernelInfo(self, BINARY_PROGRAM_INTEL, 0, nil, sz)
        error_check(error)
        sz = sz.read_size_t
        bin = MemoryPointer::new(sz)
        error = OpenCL.clGetKernelInfo(self, BINARY_PROGRAM_INTEL, sz, bin, nil)
        error_check(error)
        return bin.read_bytes(sz)
      end
    end

    get_info_array("Kernel", :size_t, "binary_sizes_intel")

    def binaries_intel
      sizes = self.binary_sizes_intel
      bin_array = MemoryPointer::new( :pointer, sizes.length )
      total_size = 0
      pointers = []
      sizes.each_with_index { |s, i|
        total_size += s
        pointers[i] = MemoryPointer::new(s)
        bin_array[i].write_pointer(pointers[i])
      }
      error = OpenCL.clGetKernelInfo(self, BINARIES_INTEL, total_size, bin_array, nil)
      error_check(error)
      bins = []
      devs = self.program.devices
      sizes.each_with_index { |s, i|
        bins.push [devs[i], pointers[i].read_bytes(s)]
      }
      return bins
    end

  end

  class Program
    DEBUG_INFO_INTEL                   = 0x4100
    DEBUG_INFO_SIZES_INTEL             = 0x4101

    get_info_array("Program", :size_t, "debug_info_sizes_intel")

    def debug_info_intel
      sizes = self.debug_info_sizes_intel
      bin_array = MemoryPointer::new( :pointer, sizes.length )
      total_size = 0
      sizes.each_with_index { |s, i|
        total_size += s
        pointers[i] = MemoryPointer::new(s)
        bin_array[i].write_pointer(pointers[i])
      }
      error = OpenCL.clGetProgramInfo(self, DEBUG_INFO_INTEL, total_size, bin_array, nil)
      error_check(error)
      bins = []
      devs = self.devices
      sizes.each_with_index { |s, i|
        bins.push [devs[i], pointers[i].read_bytes(s)]
      }
      return bins
    end
  end

end

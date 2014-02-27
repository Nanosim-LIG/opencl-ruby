require 'ffi'
module FFI
  class Pointer
    type = FFI.find_type(:size_t)
    type, _ = FFI::TypeDefs.find do |(name, t)|
      method_defined? "read_#{name}" if t == type
    end

    alias_method :read_size_t, "read_#{type}" if type
  end
end

module OpenCL
  extend FFI::Library
  SUCCESS = 0
  ffi_lib "libOpenCL.so"
  FFI::typedef :pointer, :cl_platform_id
  FFI::typedef :uint, :cl_uint
  FFI::typedef :int, :cl_int
  FFI::typedef :cl_uint, :cl_platform_info
  attach_function :clGetPlatformIDs, [:cl_uint, :pointer, :pointer], :cl_int

  class Platform < FFI::ManagedStruct
    layout :dummy, :pointer
    NAME = 0x902
    def self.release(ptr)
    end
    
    def name
      ptr = FFI::MemoryPointer.new(:size_t, 1)
      error = OpenCL.clGetPlatformInfo(self, NAME, 0, nil, ptr)
      raise "Error: #{error}" if error != SUCCESS
      ptr2 = FFI::MemoryPointer.new( ptr.read_size_t )
      error = OpenCL.clGetPlatformInfo(self, NAME, ptr.read_size_t, ptr2, nil)
      raise "Error: #{error}" if error != SUCCESS
      return ptr2.read_string
    end
  end
  attach_function :clGetPlatformInfo, [Platform, :cl_platform_info, :size_t, :pointer, :pointer], :cl_int

  def OpenCL::getPlatformsIDs
    ptr = FFI::MemoryPointer.new(:cl_uint , 1)
    
    error = OpenCL::clGetPlatformIDs(0, nil, ptr)
    raise "Error: #{error}" if error != SUCCESS
    ptr2 = FFI::MemoryPointer.new(:cl_platform_id, ptr.read_uint)
    platforms = []
    error = OpenCL::clGetPlatformIDs(ptr.read_uint(), ptr2, nil)
    raise "Error: #{error}" if error != SUCCESS
    return ptr2.get_array_of_pointer(0,ptr.read_uint()).compact.collect { |platform_ptr|
      OpenCL::Platform.new(platform_ptr)
    }
  end
end
platforms = OpenCL::getPlatformsIDs
platforms.each { |platform|
  puts platform.name
}

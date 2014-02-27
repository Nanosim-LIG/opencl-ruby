require "./gen.rb"

module FFI
  class Pointer
    alias_method :orig_method_missing, :method_missing
    def method_missing(m, *a, &b)
      if m.to_s.match("read_")
        type = m.to_s.sub("read_","")
        type = FFI.find_type(type.to_sym)
        type, _ = FFI::TypeDefs.find do |(name, t)|
          Pointer.method_defined?("read_#{name}") if t == type
        end
        return eval "read_#{type}( *a, &b)" if type
      elsif m.to_s.match ("write_")
        type = m.to_s.sub("write_","")
        type = FFI.find_type(type.to_sym)
        type, _ = FFI::TypeDefs.find do |(name, t)|
          Pointer.method_defined?("write_#{name}") if t == type
        end
        return eval "write_#{type}( *a, &b)" if type
      elsif m.to_s.match ("get_array_of_")
        type = m.to_s.sub("get_array_of_","")
        type = FFI.find_type(type.to_sym)
        type, _ = FFI::TypeDefs.find do |(name, t)|
          Pointer.method_defined?("get_array_of_#{name}") if t == type
        end
        return eval "get_array_of_#{type}( *a, &b)" if type
      end
      orig_method_missing m, *a, &b

    end  
  end
end


module OpenCL
  class ImageFormat < FFI::Struct
    layout :image_channel_order, :cl_channel_order,
           :image_channel_data_type, :cl_channel_type
  end

  class ImageDesc < FFI::Struct
    layout :image_type,           :cl_mem_object_type,
           :image_width,          :size_t,
           :image_height,         :size_t,
           :image_depth,          :size_t,
           :image_array_size,     :size_t,
           :image_row_pitch,      :size_t,
           :image_slice_pitch,    :size_t,
           :num_mip_levels,       :cl_uint, 
           :num_samples,          :cl_uint,  
           :buffer,               Mem
  end

  class BufferRegion < FFI::Struct
    layout :origin, :size_t,
           :size,   :size_t
  end

  def OpenCL.get_info_array(klass, type, name)
    return <<EOF
      def #{name.downcase}
        ptr1 = FFI::MemoryPointer.new( :size_t, 1)
        error = OpenCL.clGet#{klass}Info(self, #{klass}::#{name}, 0, nil, ptr1)
        raise "Error: \#{error}" if error != SUCCESS
        ptr2 = FFI::MemoryPointer.new( ptr1.read_size_t )
        error = OpenCL.clGet#{klass}Info(self, #{klass}::#{name}, ptr1.read_size_t, ptr2, nil)
        raise "Error: \#{error}" if error != SUCCESS
        return ptr2.get_array_of_#{type}(0, ptr1.read_size_t/ FFI.find_type(:#{type}).size)
      end
EOF
  end

  def OpenCL.get_info(klass, type, name)
    return <<EOF
      def #{name.downcase}
        ptr1 = FFI::MemoryPointer.new( :size_t, 1)
        error = OpenCL.clGet#{klass}Info(self, #{klass}::#{name}, 0, nil, ptr1)
        raise "Error: \#{error}" if error != SUCCESS
        ptr2 = FFI::MemoryPointer.new( ptr1.read_size_t )
        error = OpenCL.clGet#{klass}Info(self, #{klass}::#{name}, ptr1.read_size_t, ptr2, nil)
        raise "Error: \#{error}" if error != SUCCESS
        return ptr2.read_#{type}
      end
EOF
  end

  def OpenCL.get_platforms
    ptr1 = FFI::MemoryPointer.new(:cl_uint , 1)
    
    error = OpenCL::clGetPlatformIDs(0, nil, ptr1)
    raise "Error: #{error}" if error != SUCCESS
    ptr2 = FFI::MemoryPointer.new(:pointer, ptr1.read_uint)
    error = OpenCL::clGetPlatformIDs(ptr1.read_uint(), ptr2, nil)
    raise "Error: #{error}" if error != SUCCESS
    return ptr2.get_array_of_pointer(0,ptr1.read_uint()).collect { |platform_ptr|
      OpenCL::Platform.new(platform_ptr)
    }
  end

  class Device
    DRIVER_VERSION = 0x102D
    %w( BUILT_IN_KERNELS DRIVER_VERSION VERSION VENDOR PROFILE OPENCL_C_VERSION NAME EXTENSIONS ).each { |prop|
      eval OpenCL.get_info("Device", :string, prop)
    }
    %w( MAX_MEM_ALLOC_SIZE MAX_CONSTANT_BUFFER_SIZE LOCAL_MEM_SIZE GLOBAL_MEM_CACHE_SIZE GLOBAL_MEM_SIZE ).each { |prop|
      eval OpenCL.get_info("Device", :cl_ulong, prop)
    }
    %w( IMAGE_PITCH_ALIGNMENT IMAGE_BASE_ADDRESS_ALIGNMENT REFERENCE_COUNT PARTITION_MAX_SUB_DEVICES VENDOR_ID PREFERRED_VECTOR_WIDTH_HALF PREFERRED_VECTOR_WIDTH_CHAR PREFERRED_VECTOR_WIDTH_SHORT PREFERRED_VECTOR_WIDTH_INT PREFERRED_VECTOR_WIDTH_LONG PREFERRED_VECTOR_WIDTH_FLOAT PREFERRED_VECTOR_WIDTH_DOUBLE NATIVE_VECTOR_WIDTH_CHAR NATIVE_VECTOR_WIDTH_SHORT NATIVE_VECTOR_WIDTH_INT NATIVE_VECTOR_WIDTH_LONG NATIVE_VECTOR_WIDTH_FLOAT NATIVE_VECTOR_WIDTH_DOUBLE NATIVE_VECTOR_WIDTH_HALF MIN_DATA_TYPE_ALIGN_SIZE MEM_BASE_ADDR_ALIGN MAX_WRITE_IMAGE_ARGS MAX_WORK_ITEM_DIMENSIONS MAX_SAMPLERS MAX_READ_IMAGE_ARGS MAX_CONSTANT_ARGS MAX_COMPUTE_UNITS MAX_CLOCK_FREQUENCY ADDRESS_BITS GLOBAL_MEM_CACHELINE_SIZE ).each { |prop|
      eval OpenCL.get_info("Device", :cl_uint, prop)
    }
    %w( PRINTF_BUFFER_SIZE IMAGE_MAX_BUFFER_SIZE IMAGE_MAX_ARRAY_SIZE PROFILING_TIMER_RESOLUTION MAX_WORK_GROUP_SIZE MAX_PARAMETER_SIZE IMAGE2D_MAX_WIDTH IMAGE2D_MAX_HEIGHT IMAGE3D_MAX_WIDTH IMAGE3D_MAX_HEIGHT IMAGE3D_MAX_DEPTH ).each { |prop|
      eval OpenCL.get_info("Device", :size_t, prop)
    }
    %w( PREFERRED_INTEROP_USER_SYNC LINKER_AVAILABLE IMAGE_SUPPORT HOST_UNIFIED_MEMORY COMPILER_AVAILABLE AVAILABLE ENDIAN_LITTLE ERROR_CORRECTION_SUPPORT ).each { |prop|
      eval OpenCL.get_info("Device", :cl_bool, prop)
    }
    %w( SINGLE_FP_CONFIG HALF_FP_CONFIG DOUBLE_FP_CONFIG ).each { |prop|
      eval OpenCL.get_info("Device", :cl_device_fp_config, prop)
    }
    eval OpenCL.get_info("Device", :cl_device_exec_capabilities, "EXECUTION_CAPABILITIES")
    eval OpenCL.get_info("Device", :cl_device_mem_cache_type, "GLOBAL_MEM_CACHE_TYPE")
    eval OpenCL.get_info("Device", :cl_device_local_mem_type, "LOCAL_MEM_TYPE")
    eval OpenCL.get_info("Device", :cl_command_queue_properties, "QUEUE_PROPERTIES")
    eval OpenCL.get_info("Device", :cl_device_type, "TYPE")
    eval OpenCL.get_info("Device", :cl_device_affinity_domain, "PARTITION_AFFINITY_DOMAIN")
    eval OpenCL.get_info_array("Device", :size_t, "MAX_WORK_ITEM_SIZES")
    eval OpenCL.get_info_array("Device", :cl_device_partition_property, "PARTITION_PROPERTIES")
    eval OpenCL.get_info_array("Device", :cl_device_partition_property, "PARTITION_TYPE")
    def platform
        ptr1 = FFI::MemoryPointer.new( :size_t, 1)
        error = OpenCL.clGetDeviceInfo(self, Device::PLATFORM, 0, nil, ptr1)
        raise "Error: \#{error}" if error != SUCCESS
        ptr2 = FFI::MemoryPointer.new( ptr1.read_size_t )
        error = OpenCL.clGetDeviceInfo(self, Device::PLATFORM, ptr1.read_size_t, ptr2, nil)
        raise "Error: \#{error}" if error != SUCCESS
        return OpenCL::Platform.new(ptr2)
    end
    def parent_device
        ptr1 = FFI::MemoryPointer.new( :size_t, 1)
        error = OpenCL.clGetDeviceInfo(self, Device::PARENT_DEVICE, 0, nil, ptr1)
        raise "Error: \#{error}" if error != SUCCESS
        ptr2 = FFI::MemoryPointer.new( ptr1.read_size_t )
        error = OpenCL.clGetDeviceInfo(self, Device::PARENT_DEVICE, ptr1.read_size_t, ptr2, nil)
        raise "Error: \#{error}" if error != SUCCESS
        return OpenCL::Device.new(ptr2)
    end
    def self.release(ptr)
      OpenCL.clReleaseDevice(self)
    end
  end

  class Platform
    %w(PROFILE VERSION NAME VENDOR EXTENSIONS).each { |prop|
      eval OpenCL.get_info("Platform", :string, prop)
    }
    def self.release(ptr)
    end

    def devices(type = OpenCL::Device::TYPE_ALL)
      ptr1 = FFI::MemoryPointer.new(:cl_uint , 1)
      error = OpenCL::clGetDeviceIDs(self, type, 0, nil, ptr1)
      raise "Error: #{error}" if error != SUCCESS
      ptr2 = FFI::MemoryPointer.new(:pointer, ptr1.read_uint)
      error = OpenCL::clGetDeviceIDs(self, type, ptr1.read_uint(), ptr2, nil)
      raise "Error: #{error}" if error != SUCCESS
      return ptr2.get_array_of_pointer(0, ptr1.read_uint()).compact.collect { |device_ptr|
        OpenCL::Device.new(device_ptr)
      }
    end
  end
end

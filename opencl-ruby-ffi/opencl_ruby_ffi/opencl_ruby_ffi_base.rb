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
  @@callbacks = []
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

  def OpenCL.error_check(errcode)
    raise OpenCL::Error::new(OpenCL::Error.get_error_string(errcode)) if errcode != SUCCESS
  end

  def OpenCL.get_info_array(klass, type, name)
    klass_name = klass
    klass_name = "MemObject" if klass == "Mem"
    return <<EOF
      def #{name.downcase}
        ptr1 = FFI::MemoryPointer.new( :size_t, 1)
        error = OpenCL.clGet#{klass_name}Info(self, #{klass}::#{name}, 0, nil, ptr1)
        OpenCL.error_check(error)
        ptr2 = FFI::MemoryPointer.new( ptr1.read_size_t )
        error = OpenCL.clGet#{klass_name}Info(self, #{klass}::#{name}, ptr1.read_size_t, ptr2, nil)
        OpenCL.error_check(error)
        return ptr2.get_array_of_#{type}(0, ptr1.read_size_t/ FFI.find_type(:#{type}).size)
      end
EOF
  end

  def OpenCL.get_info(klass, type, name)
    klass_name = klass
    klass_name = "MemObject" if klass == "Mem"
    return <<EOF
      def #{name.downcase}
        ptr1 = FFI::MemoryPointer.new( :size_t, 1)
        error = OpenCL.clGet#{klass_name}Info(self, #{klass}::#{name}, 0, nil, ptr1)
        OpenCL.error_check(error)
        ptr2 = FFI::MemoryPointer.new( ptr1.read_size_t )
        error = OpenCL.clGet#{klass_name}Info(self, #{klass}::#{name}, ptr1.read_size_t, ptr2, nil)
        OpenCL.error_check(error)
        return ptr2.read_#{type}
      end
EOF
  end

end

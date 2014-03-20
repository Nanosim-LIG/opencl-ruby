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
  class FFI::Struct
    alias_method :parent_initialize, :initialize
  end

  class ImageFormat < FFI::Struct
    layout :image_channel_order, :cl_channel_order,
           :image_channel_data_type, :cl_channel_type

    def initialize( image_channel_order, image_channel_data_type )
      super()
      self[:image_channel_order] = image_channel_order
      self[:image_channel_data_type] = image_channel_data_type
    end

    def channel_order
      return self[:image_channel_order]
    end

    def channel_order=(order)
      return self[:image_channel_order] = order
    end

    def channel_data_type
      return self[:image_channel_data_type]
    end

    def channel_data_type=(data_type)
      return self[:image_channel_data_type] = data_type
    end

    def channel_order_name
      co = self[:image_channel_order]
      %w( R A RG RA RGB RGBA BGRA ARGB INTENSITY LUMINANCE Rx RGx RGBx ).each { |c_o_n|
        return c_o_n if OpenCL::const_get(c_o_n) == co
      }    
    end

    def channel_data_type_name
      ct = self[:image_channel_data_type]
      %w( SNORM_INT8 SNORM_INT16 UNORM_INT8 UNORM_INT16 UNORM_SHORT_565 UNORM_SHORT_555 UNORM_INT_101010 SIGNED_INT8 SIGNED_INT16 UNSIGNED_INT8 UNSIGNED_INT16 UNSIGNED_INT32 HALF_FLOAT FLOAT ).each { |c_d_t_n|
        return c_d_t_n if OpenCL::const_get(c_d_t_n) == ct
      }
    end

    def to_s
      return "{ #{channel_order_name}, #{channel_data_type_name} }"
    end

    def parent_initialize(ptr)
      super(ptr)
    end

    def self.from_pointer( ptr )
      object = allocate
      object.parent_initialize( ptr )
      object
    end
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

     def initialize( image_type, image_width, image_height, image_depth, image_array_size, image_row_pitch, image_slice_pitch, num_mip_levels, num_samples, buffer )
       super()
       self[:image_type] = image_type
       self[:image_width] = image_width
       self[:image_height] = image_height
       self[:image_depth] = image_depth
       self[:image_array_size] = image_array_size
       self[:image_row_pitch] = image_row_pitch
       self[:image_slice_pitch] = image_slice_pitch
       self[:num_mip_levels] = num_mip_levels
       self[:num_samples] = num_samples
       self[:buffer] = buffer
     end
  end

  class BufferRegion < FFI::Struct
    layout :origin, :size_t,
           :size,   :size_t

    def initialize( origin, sz )
      super()
      self[:origin] = origin
      self[:size]   = sz
    end
  end

  def self.get_flags( options )
    flags = 0
    if options[:flags] then
      if options[:flags].respond_to?(:each) then
        options[:flags].each { |f| flags = flags | f }
      else
        flags = options[:flags]
      end
    end
    return flags
  end

  def self.get_event_wait_list( options )
    num_events = 0
    events = nil
    if options[:event_wait_list] then
      num_events = options[:event_wait_list].length
      if num_events > 0 then
        events = FFI::MemoryPointer.new( Event, num_events )
        options[:event_wait_list].each_with_index { |e, i|
          events[i].write_pointer(e)
        }
      end
    end
    return [ num_events, events ]
  end

  def self.get_command_queue_properties( options )
    properties = nil
    if options[:properties] then
      if options[:properties].respond_to?(:each) then
        options[:properties].each { |f| properties = properties | f }
      else
        properties = options[:properties]
      end
    end
    return properties
  end

  def self.get_origin_region( image, options, origin_symbol, region_symbol )
    origin = FFI::MemoryPointer.new( :size_t, 3 )
    (0..2).each { |i| origin[i].write_size_t(0) }
    if options[origin_symbol] then
      options[origin_symbol].each_with_index { |e, i|
        origin[i].write_size_t(e)
      }
    end
    region = FFI::MemoryPointer.new( :size_t, 3 )
    (0..2).each { |i| region[i].write_size_t(1) }
    if options[region_symbol] then
      options[region_symbol].each_with_index { |e, i|
        region[i].write_size_t(e)
      }
    else
       region[0].write_size_t( image.width - origin[0].read_size_t )
       if image.type == OpenCL::Mem::IMAGE1D_ARRAY then
         region[1].write_size_t( image.array_size - origin[1].read_size_t )
       else
         region[1].write_size_t( image.height ? image.height - origin[1].read_size_t : 1 )
       end
       if image.type == OpenCL::Mem::IMAGE2D_ARRAY then
         region[2].write_size_t( image.array_size - origin[2].read_size_t )
       else 
         region[2].write_size_t( image.depth ? image.depth - origin[2].read_size_t : 1 )
       end
    end
    return [origin, region]
  end

  def self.get_context_properties( options )
    properties = nil
    if options[:properties] then
      properties = FFI::MemoryPointer.new( :cl_context_properties, options[:properties].length + 1 )
      options[:properties].each_with_index { |e,i|
        properties[i].write_cl_context_properties(e)
      }
      properties[options[:properties].length].write_cl_context_properties(0)
    end
    return properties
  end

  def self.error_check(errcode)
    raise OpenCL::Error::new(OpenCL::Error.get_error_string(errcode)) if errcode != SUCCESS
  end

  def self.get_info_array(klass, type, name)
    klass_name = klass
    klass_name = "MemObject" if klass == "Mem"
    s = <<EOF
      def #{name.downcase}
        ptr1 = FFI::MemoryPointer.new( :size_t, 1)
        error = OpenCL.clGet#{klass_name}Info(self, #{klass}::#{name}, 0, nil, ptr1)
        OpenCL.error_check(error)
EOF
    if ( klass == "Device" and name == "PARTITION_TYPE" ) or ( klass == "Context" and name == "PROPERTIES" ) then
      s+= <<EOF
        return [] if ptr1.read_size_t == 0
EOF
    end
    s += <<EOF
        ptr2 = FFI::MemoryPointer.new( ptr1.read_size_t )
        error = OpenCL.clGet#{klass_name}Info(self, #{klass}::#{name}, ptr1.read_size_t, ptr2, nil)
        OpenCL.error_check(error)
        arr = ptr2.get_array_of_#{type}(0, ptr1.read_size_t/ FFI.find_type(:#{type}).size)
EOF
    if ( klass == "Device" and ( name == "PARTITION_TYPE" or name == "PARTITION_PROPERTIES" ) ) or ( klass == "Context" and name == "PROPERTIES" ) then
      s+= <<EOF
        return arr.reject! { |e| e == 0 }
      end
EOF
    else
      s+= <<EOF
        return arr
      end
EOF
    end
    return s
  end

  def self.get_info(klass, type, name)
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

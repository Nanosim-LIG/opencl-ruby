module FFI

  class Pointer
    alias_method :orig_method_missing, :method_missing
    # if a missing write_type, read_type, get_array_of_type can transitively get a replacement, an alias is created and the method is called
    def method_missing(m, *a, &b)
      if m.to_s.match("read_")
        type = m.to_s.sub("read_","")
        type = FFI.find_type(type.to_sym)
        type, _ = FFI::TypeDefs.find do |(name, t)|
          Pointer.method_defined?("read_#{name}") if t == type
        end
        eval "alias :#{m} :read_#{type}" if type
        return eval "read_#{type}( *a, &b)" if type
      elsif m.to_s.match ("write_")
        type = m.to_s.sub("write_","")
        type = FFI.find_type(type.to_sym)
        type, _ = FFI::TypeDefs.find do |(name, t)|
          Pointer.method_defined?("write_#{name}") if t == type
        end
        eval "alias :#{m} :write_#{type}" if type
        return eval "write_#{type}( *a, &b)" if type
      elsif m.to_s.match ("get_array_of_")
        type = m.to_s.sub("get_array_of_","")
        type = FFI.find_type(type.to_sym)
        type, _ = FFI::TypeDefs.find do |(name, t)|
          Pointer.method_defined?("get_array_of_#{name}") if t == type
        end
        eval "alias :#{m} :get_array_of_#{type}" if type
        return eval "get_array_of_#{type}( *a, &b)" if type
      end
      orig_method_missing m, *a, &b

    end  
  end

  class Struct

    # alias initialize in order to call it from another function from a child class
    alias_method :parent_initialize, :initialize
  end

end

module OpenCL

  @@callbacks = []

  # Maps the :cl_image_fomat type of OpenCL
  class ImageFormat < FFI::Struct
    layout :image_channel_order, :cl_channel_order,
           :image_channel_data_type, :cl_channel_type

    # Creates a new ImageFormat from an image channel order and data type
    def initialize( image_channel_order, image_channel_data_type )
      super()
      self[:image_channel_order] = image_channel_order
      self[:image_channel_data_type] = image_channel_data_type
    end

    # Returns a new ChannelOrder corresponding to the ImageFormat internal value
    def channel_order
      return ChannelOrder::new(self[:image_channel_order])
    end

    # Sets the ImageFormat internal value for the image channel order
    def channel_order=(order)
      return self[:image_channel_order] = order
    end

    # Returns a new ChannelType corresponding to the ImageFormat internal value
    def channel_data_type
      return ChannelType::new(self[:image_channel_data_type])
    end

    # Sets the ImageFormat internal value for the image channel data type
    def channel_data_type=(data_type)
      return self[:image_channel_data_type] = data_type
    end

    # Returns a String containing a user friendly representation of the ImageFormat
    def to_s
      return "{ #{self.channel_order}, #{self.channel_data_type} }"
    end

    # A workaroud to call the parent initialize from another function (from_pointer)
    def parent_initialize(ptr)
      super(ptr)
    end

    # Creates a new ImageFormat using an FFI::Pointer, fonctionality was lost when initialize was defined
    def self.from_pointer( ptr )
      object = allocate
      object.parent_initialize( ptr )
      object
    end
  end

  # Map the :cl_image_desc type of OpenCL
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
           :buffer,               Mem.ptr

     # Creates anew ImageDesc using the values provided by the user
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

  # Maps the :cl_buffer_region type of OpenCL
  class BufferRegion < FFI::Struct
    layout :origin, :size_t,
           :size,   :size_t

    # Creates a new BufferRegion using the value provided by the user
    def initialize( origin, sz )
      super()
      self[:origin] = origin
      self[:size]   = sz
    end
  end

  #:stopdoc:
  module InnerInterface

    private

    # Extracts the :flags named option from the hash given and returns the flags value
    def get_flags( options )
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
  
    # Extracts the :event_wait_list named option from the hash given and returns a tuple containing the number of events and a pointer to those events
    def get_event_wait_list( options )
      events = options[:event_wait_list]
      events = [events].flatten if events
      events_p = nil
      num_events = 0
      if events and events.size > 0 then
        num_events = events.size
        events_p = FFI::MemoryPointer::new( Event, num_events )
        events_p.write_array_of_pointer(events)
      end
      return [num_events, events_p]
    end
  
    # Extracts the :properties named option (for a CommandQueue) from the hash given and returns the properties values
    def get_command_queue_properties( options )
      properties = CommandQueue::Properties::new(0)
      if options[:properties] then
        if options[:properties].respond_to?(:each) then
          options[:properties].each { |f| properties = properties | f }
        else
          properties = properties | options[:properties]
        end
      end
      return properties
    end
  
    # Extracts the origin_symbol and region_symbol named options for image from the given hash. Returns the read (or detemined suitable) origin and region in a tuple
    def get_origin_region( image, options, origin_symbol, region_symbol )
      origin = FFI::MemoryPointer::new( :size_t, 3 )
      (0..2).each { |i| origin[i].write_size_t(0) }
      if options[origin_symbol] then
        options[origin_symbol].each_with_index { |e, i|
          origin[i].write_size_t(e)
        }
      end
      region = FFI::MemoryPointer::new( :size_t, 3 )
      (0..2).each { |i| region[i].write_size_t(1) }
      if options[region_symbol] then
        options[region_symbol].each_with_index { |e, i|
          region[i].write_size_t(e)
        }
      else
         region[0].write_size_t( image.width - origin[0].read_size_t )
         if image.type == Mem::IMAGE1D_ARRAY then
           region[1].write_size_t( image.array_size - origin[1].read_size_t )
         else
           region[1].write_size_t( image.height != 0 ? image.height - origin[1].read_size_t : 1 )
         end
         if image.type == Mem::IMAGE2D_ARRAY then
           region[2].write_size_t( image.array_size - origin[2].read_size_t )
         else 
           region[2].write_size_t( image.depth != 0 ? image.depth - origin[2].read_size_t : 1 )
         end
      end
      return [origin, region]
    end
  
    # Extracts the :properties named option (for a Context) from the hash given and returns an FFI:Pointer to a 0 terminated list of properties 
    def get_context_properties( options )
      properties = nil
      if options[:properties] then
        properties = FFI::MemoryPointer::new( :cl_context_properties, options[:properties].length + 1 )
        options[:properties].each_with_index { |e,i|
          properties[i].write_cl_context_properties(e)
        }
        properties[options[:properties].length].write_cl_context_properties(0)
      end
      return properties
    end
  
    # Extracts the :device_list named option from the hash given and returns [ number of devices, an FFI:Pointer to the list of Device or nil ]
    def get_device_list( options )
      devices = options[:device_list]
      devices = [devices].flatten if devices
      devices_p = nil
      num_devices = 0
      if devices and devices.size > 0 then
        num_devices = devices.size
        devices_p = FFI::MemoryPointer::new( Device, num_devices)
        devices_p.write_array_of_pointer(devices)
      end
      return [num_devices, devices_p]
    end
  
    # checks if a :cl_int corresponds to an error code and raises the apropriate Error
    def error_check(errcode)
      return nil if errcode == SUCCESS
      klass = Error::error_class(errcode)
      if klass then
        raise klass::new
      else
        raise Error::new("#{errcode}")
      end
    end

    TYPE_CONVERTER = {
      :cl_device_type => Device::Type,
      :cl_device_fp_config => Device::FPConfig,
      :cl_device_mem_cache_type => Device::MemCacheType,
      :cl_device_local_mem_type => Device::LocalMemType,
      :cl_device_exec_capabilities => Device::ExecCapabilities,
      :cl_command_queue_properties => CommandQueue::Properties,
      :cl_device_affinity_domain => Device::AffinityDomain,
      :cl_device_svm_capabilities => Device::SVMCapabilities,
      :cl_channel_order => ChannelOrder,
      :cl_channel_type => ChannelType,
      :cl_mem_flags => Mem::Flags,
      :cl_mem_object_type => Mem::Type,
      :cl_mem_migration_flags => Mem::MigrationFlags,
      :cl_addressing_mode => AddressingMode,
      :cl_filter_mode => FilterMode,
      :cl_map_flags => MapFlags,
      :cl_program_binary_type => Program::BinaryType,
      :cl_kernel_arg_address_qualifier => Kernel::Arg::AddressQualifier,
      :cl_kernel_arg_access_qualifier => Kernel::Arg::AccessQualifier,
      :cl_kernel_arg_type_qualifier => Kernel::Arg::TypeQualifier,
      :cl_command_type => CommandType,
      :cl_build_status => BuildStatus
    }
    
    private_constant :TYPE_CONVERTER
  
    # Converts a type from a symbol to an OpenCL class if a convertion is found
    def convert_type(type)
      return TYPE_CONVERTER[type]
    end

  end

  private_constant :InnerInterface
  extend InnerInterface

  module InnerGenerator

    private

    #  Generates a new method for klass that use the apropriate clGetKlassInfo, to read an element of the given type. The info queried is specified by name.
    def get_info(klass, type, name)
      klass_name = klass
      klass_name = "MemObject" if klass == "Mem"
      s = <<EOF
      def #{name.downcase}
        ptr1 = FFI::MemoryPointer::new( :size_t, 1)
        error = OpenCL.clGet#{klass_name}Info(self, #{klass}::#{name}, 0, nil, ptr1)
        error_check(error)
        ptr2 = FFI::MemoryPointer::new( ptr1.read_size_t )
        error = OpenCL.clGet#{klass_name}Info(self, #{klass}::#{name}, ptr1.read_size_t, ptr2, nil)
        error_check(error)
        if(convert_type(:#{type})) then
          return convert_type(:#{type})::new(ptr2.read_#{type})
        else
          return ptr2.read_#{type}
        end
      end
EOF
      return s
    end

    #  Generates a new method for klass that use the apropriate clGetKlassInfo, to read an Array of element of the given type. The info queried is specified by name.
    def get_info_array(klass, type, name)
      klass_name = klass
      klass_name = "MemObject" if klass == "Mem"
      s = <<EOF
      def #{name.downcase}
        ptr1 = FFI::MemoryPointer::new( :size_t, 1)
        error = OpenCL.clGet#{klass_name}Info(self, #{klass}::#{name}, 0, nil, ptr1)
        error_check(error)
EOF
      if ( klass == "Device" and name == "PARTITION_TYPE" ) or ( klass == "Context" and name == "PROPERTIES" ) then
        s+= <<EOF
        return [] if ptr1.read_size_t == 0
EOF
      end
      s += <<EOF
        ptr2 = FFI::MemoryPointer::new( ptr1.read_size_t )
        error = OpenCL.clGet#{klass_name}Info(self, #{klass}::#{name}, ptr1.read_size_t, ptr2, nil)
        error_check(error)
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

  end
  private_constant :InnerGenerator
  #:startdoc:

end

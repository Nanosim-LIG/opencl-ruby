using OpenCLRefinements if RUBY_VERSION.scan(/\d+/).collect(&:to_i).first >= 2

module OpenCL

  class Pointer < FFI::Pointer
    def initialize(*args)
      if args.length == 2 then
        super(OpenCL::find_type(args[0]), args[1])
      else
        super(*args)
      end
    end
  end

  class Function < FFI::Function
    def initialize(ret, args, *opts, &block)
      super(OpenCL::find_type(ret), args.collect { |a| OpenCL::find_type(a) }, *opts, &block)
    end
  end

  class MemoryPointer < FFI::MemoryPointer

    def initialize(size, count = 1, clear = true)
      if size.is_a?(Symbol)
        size = OpenCL::find_type(size)
      end
      super(size, count, clear)
    end

  end

  class Struct < FFI::Struct
  end

  class Union < FFI::Union
  end

  @@callbacks = {}

  # Maps the :cl_image_fomat type of OpenCL
  class ImageFormat < Struct
    layout :image_channel_order, :cl_channel_order,
           :image_channel_data_type, :cl_channel_type

    def inspect
      return "#<#{self.class.name}: #{channel_order} #{channel_data_type}>"
    end

    # Creates a new ImageFormat from an image channel order and data type
    def initialize( image_channel_order, image_channel_data_type = nil )
      if image_channel_order.is_a?(FFI::Pointer) and image_channel_data_type.nil? then
        super(image_channel_order)
      else
        super()
        self[:image_channel_order] = image_channel_order
        self[:image_channel_data_type] = image_channel_data_type
      end
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

  end

  # Map the :cl_image_desc type of OpenCL
  class ImageDesc < Struct
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
  class BufferRegion < Struct
    layout :origin, :size_t,
           :size,   :size_t

    # Creates a new BufferRegion using the value provided by the user
    def initialize( origin, sz )
      super()
      self[:origin] = origin
      self[:size]   = sz
    end
  end

  class Version
    include Comparable
    MAJOR_BITS = 10
    MINOR_BITS = 10
    PATCH_BITS = 12
    MAJOR_MASK = (1 << MAJOR_BITS) - 1
    MINOR_MASK = (1 << MINOR_BITS) - 1
    PATCH_MASK = (1 << PATCH_BITS) - 1

    attr_reader :major, :minor, :patch
    def initialize(major, minor = 0, patch = 0)
      @major = major
      @minor = minor
      @patch = patch
    end

    def to_int
      Version.make(@major, @minor, @patch)
    end
    alias to_i to_int

    def <=>(other)
      res = (@major <=> other.major)
      res = (@minor <=> other.minor) if res == 0
      res = (@patch <=> other.patch) if res == 0
      res
    end

    def to_s
      "#{@major}.#{@minor}.#{@patch}"
    end

    def self.major(v)
      v >> (MINOR_BITS + PATCH_BITS)
    end

    def self.minor(v)
      (v >> (PATCH_BITS)) & MINOR_MASK
    end

    def self.patch(v)
      v & PATCH_MASK
    end

    def self.make(major, minor = 0, patch = 0)
      ((major & MAJOR_MASK) << (MINOR_BITS + PATCH_BITS)) +
      ((minor & MINOR_MASK) << PATCH_BITS) +
       (patch & PATCH_MASK)
    end

    def self.from_int(v)
      self.new(major(v), minor(v), patch(v))
    end
  end

  # Maps the :cl_name_version type of OpenCL
  class NameVersion < Struct
    MAX_NAME_SIZE = 64
    layout :version, :cl_version,
           :name, [:char, MAX_NAME_SIZE]

    def version
      Version.from_int(self[:version])
    end

    def name
      self[:name].to_s
    end
  end

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
        events_p = MemoryPointer::new( Event, num_events )
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
      origin = MemoryPointer::new( :size_t, 3 )
      (0..2).each { |i| origin[i].write_size_t(0) }
      if options[origin_symbol] then
        options[origin_symbol].each_with_index { |e, i|
          origin[i].write_size_t(e)
        }
      end
      region = MemoryPointer::new( :size_t, 3 )
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
  
    # Extracts the :properties named option (for a Context) from the hash given and returns an Pointer to a 0 terminated list of properties 
    def get_context_properties( options )
      properties = nil
      if options[:properties] then
        properties = MemoryPointer::new( :cl_context_properties, options[:properties].length + 1 )
        options[:properties].each_with_index { |e,i|
          properties[i].write_cl_context_properties(e.respond_to?(:to_ptr) ? e : e.to_i)
        }
        properties[options[:properties].length].write_cl_context_properties(0)
      end
      return properties
    end
  
    # EXtracts the :properties named option (for a Mem) from the hash given and returns the properties values
    def get_mem_properties( options )
      properties = nil
      if options[:properties] then
        properties = MemoryPointer::new( :cl_mem_properties, options[:properties].length + 1 )
        options[:properties].each_with_index { |e,i|
          properties[i].write_cl_mem_properties(e.respond_to?(:to_ptr) ? e : e.to_i)
        }
        properties[options[:properties].length].write_cl_mem_properties(0)
      end
      return properties
    end
  
    # Extracts the :device_list named option from the hash given and returns [ number of devices, an Pointer to the list of Device or nil ]
    def get_device_list( options )
      devices = options[:device_list]
      devices = [devices].flatten if devices
      devices_p = nil
      num_devices = 0
      if devices and devices.size > 0 then
        num_devices = devices.size
        devices_p = MemoryPointer::new( Device, num_devices)
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
      :cl_device_atomic_capabilities => Device::AtomicCapabilities,
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

  class Enum
    include InnerInterface
  end

  class Bitfield
    include InnerInterface
  end

  module ExtensionInnerGenerator

    private

    # @!macro [attach] get_info_ext
    #   @!method $3
    #   Returns the OpenCL::$1::$3 info
    #   @return $2
    def get_info_ext(klass, type, name, function, memoizable = false)
      if memoizable
      s = <<EOF
      def #{name.downcase}
        return @_#{name.downcase} if @_#{name.downcase}
        f = platform.get_extension_function("#{function}", :cl_int, [#{klass}, :cl_uint, :size_t, :pointer, :pointer])
        error_check(OpenCL::INVALID_OPERATION) unless f

        ptr1 = MemoryPointer::new(:size_t, 1)
        error = f.call(self, #{klass}::#{name.upcase}, 0, nil, ptr1)
        error_check(error)
        ptr2 = MemoryPointer::new(ptr1.read_size_t)
        error = f.call(self, #{klass}::#{name.upcase}, ptr1.read_size_t, ptr2, nil)
        error_check(error)
        if(convert_type(:#{type})) then
          @_#{name.downcase} = convert_type(:#{type})::new(ptr2.read_#{type})
        else
          @_#{name.downcase} = ptr2.read_#{type}
        end
        return @_#{name.downcase}
      end
EOF
      else
      s = <<EOF
      def #{name.downcase}
        f = platform.get_extension_function("#{function}", :cl_int, [#{klass}, :cl_uint, :size_t, :pointer, :pointer])
        error_check(OpenCL::INVALID_OPERATION) unless f

        ptr1 = MemoryPointer::new(:size_t, 1)
        error = f.call(self, #{klass}::#{name.upcase}, 0, nil, ptr1)
        error_check(error)
        ptr2 = MemoryPointer::new(ptr1.read_size_t)
        error = f.call(self, #{klass}::#{name.upcase}, ptr1.read_size_t, ptr2, nil)
        error_check(error)
        if(convert_type(:#{type})) then
          return convert_type(:#{type})::new(ptr2.read_#{type})
        else
          return ptr2.read_#{type}
        end
      end
EOF
      end
      if type == :cl_bool then
        s += <<EOF
      def #{name.downcase}?
        #{name.downcase} == 0 ? false : true
      end
EOF
      end
      module_eval s
    end

    # @!macro [attach] get_info_array_ext
    #   @!method $3
    #   Returns the OpenCL::$1::$3 info
    #   @return an Array of $2
    def get_info_array_ext(klass, type, name, function, memoizable = false)
      if memoizable
      s = <<EOF
      def #{name.downcase}
        return @_#{name.downcase} if @_#{name.downcase}
        f = platform.get_extension_function("#{function}", :cl_int, [#{klass}, :cl_uint, :size_t, :pointer, :pointer])
        error_check(OpenCL::INVALID_OPERATION) unless f

        ptr1 = MemoryPointer::new(:size_t, 1)
        error = f.call(self, #{klass}::#{name.upcase}, 0, nil, ptr1)
        error_check(error)
        ptr2 = MemoryPointer::new(ptr1.read_size_t)
        error = f.call(self, #{klass}::#{name.upcase}, ptr1.read_size_t, ptr2, nil)
        error_check(error)
        arr = ptr2.get_array_of_#{type}(0, ptr1.read_size_t / OpenCL.find_type(:#{type}).size)
        if(convert_type(:#{type})) then
          @_#{name.downcase} = arr.collect { |e| convert_type(:#{type})::new(e) }
        else
          @_#{name.downcase} = arr
        end
        return @_#{name.downcase}
      end
EOF
      else
      s = <<EOF
      def #{name.downcase}
        f = platform.get_extension_function("#{function}", :cl_int, [#{klass}, :cl_uint, :size_t, :pointer, :pointer])
        error_check(OpenCL::INVALID_OPERATION) unless f

        ptr1 = MemoryPointer::new(:size_t, 1)
        error = f.call(self, #{klass}::#{name.upcase}, 0, nil, ptr1)
        error_check(error)
        ptr2 = MemoryPointer::new(ptr1.read_size_t)
        error = f.call(self, #{klass}::#{name.upcase}, ptr1.read_size_t, ptr2, nil)
        error_check(error)
        arr = ptr2.get_array_of_#{type}(0, ptr1.read_size_t / OpenCL.find_type(:#{type}).size)
        if(convert_type(:#{type})) then
          return arr.collect { |e| convert_type(:#{type})::new(e) }
        else
          return arr
        end
      end
EOF
      end
      module_eval s
    end

  end
  private_constant :ExtensionInnerGenerator

  module InnerGenerator

    private

    # @!macro [attach] get_info
    #   @!method $3
    #   Returns the OpenCL::$1::$3 info
    #   @return $2
    def get_info(klass, type, name, memoizable = false)
      klass_name = klass
      klass_name = "MemObject" if klass == "Mem"
      if memoizable
      s = <<EOF
      def #{name.downcase}
        return @_#{name.downcase} if @_#{name.downcase}
        ptr1 = MemoryPointer::new(:size_t, 1)
        error = OpenCL.clGet#{klass_name}Info(self, #{klass}::#{name.upcase}, 0, nil, ptr1)
        error_check(error)
        ptr2 = MemoryPointer::new(ptr1.read_size_t)
        error = OpenCL.clGet#{klass_name}Info(self, #{klass}::#{name.upcase}, ptr1.read_size_t, ptr2, nil)
        error_check(error)
        if(convert_type(:#{type})) then
          @_#{name.downcase} = convert_type(:#{type})::new(ptr2.read_#{type})
        else
          @_#{name.downcase} = ptr2.read_#{type}
        end
        return @_#{name.downcase}
      end
EOF
      else
      s = <<EOF
      def #{name.downcase}
        ptr1 = MemoryPointer::new(:size_t, 1)
        error = OpenCL.clGet#{klass_name}Info(self, #{klass}::#{name.upcase}, 0, nil, ptr1)
        error_check(error)
        ptr2 = MemoryPointer::new(ptr1.read_size_t)
        error = OpenCL.clGet#{klass_name}Info(self, #{klass}::#{name.upcase}, ptr1.read_size_t, ptr2, nil)
        error_check(error)
        if(convert_type(:#{type})) then
          return convert_type(:#{type})::new(ptr2.read_#{type})
        else
          return ptr2.read_#{type}
        end
      end
EOF
      end
      if type == :cl_bool then
        s += <<EOF
      def #{name.downcase}?
        #{name.downcase} == 0 ? false : true
      end
EOF
      end
      module_eval s
    end

    # @!macro [attach] get_info_array
    #   @!method $3
    #   Returns the OpenCL::$1::$3 info
    #   @return an Array of $2
    def get_info_array(klass, type, name, memoizable = false)
      klass_name = klass
      klass_name = "MemObject" if klass == "Mem"
      if memoizable
        s = <<EOF
      def #{name.downcase}
        return @_#{name.downcase} if @_#{name.downcase}
        ptr1 = MemoryPointer::new(:size_t, 1)
        error = OpenCL.clGet#{klass_name}Info(self, #{klass}::#{name.upcase}, 0, nil, ptr1)
        error_check(error)
        ptr2 = MemoryPointer::new(ptr1.read_size_t)
        error = OpenCL.clGet#{klass_name}Info(self, #{klass}::#{name.upcase}, ptr1.read_size_t, ptr2, nil)
        error_check(error)
        arr = ptr2.get_array_of_#{type}(0, ptr1.read_size_t / OpenCL.find_type(:#{type}).size)
        if(convert_type(:#{type})) then
          @_#{name.downcase} = arr.collect { |e| convert_type(:#{type})::new(e) }
        else
          @_#{name.downcase} = arr
        end
        return @_#{name.downcase}
      end
EOF
      else
        s = <<EOF
      def #{name.downcase}
        ptr1 = MemoryPointer::new(:size_t, 1)
        error = OpenCL.clGet#{klass_name}Info(self, #{klass}::#{name.upcase}, 0, nil, ptr1)
        error_check(error)
        ptr2 = MemoryPointer::new(ptr1.read_size_t)
        error = OpenCL.clGet#{klass_name}Info(self, #{klass}::#{name.upcase}, ptr1.read_size_t, ptr2, nil)
        error_check(error)
        arr = ptr2.get_array_of_#{type}(0, ptr1.read_size_t / OpenCL.find_type(:#{type}).size)
        if(convert_type(:#{type})) then
          return arr.collect { |e| convert_type(:#{type})::new(e) }
        else
          return arr
        end
      end
EOF
      end
      module_eval s
    end

  end
  private_constant :InnerGenerator

end

require 'opencl_ruby_ffi'
using OpenCLRefinements if RUBY_VERSION.scan(/\d+/).collect(&:to_i).first >= 2

module OpenCL

  DEVICE_PARTITION_FAILED_EXT = -1057
  INVALID_PARTITION_COUNT_EXT = -1058

  DEVICE_PARTITION_EQUALLY_EXT = 0x4050
  DEVICE_PARTITION_BY_COUNTS_EXT = 0x4051
  DEVICE_PARTITION_BY_NAMES_EXT = 0x4052
  DEVICE_PARTITION_BY_AFFINITY_DOMAIN_EXT = 0x4053

  DEVICE_PARENT_DEVICE_EXT = 0x4054
  DEVICE_PARTITION_TYPES_EXT = 0x4055
  DEVICE_AFFINITY_DOMAINS_EXT = 0x4056
  DEVICE_REFERENCE_COUNT_EXT = 0x4057
  DEVICE_PARTITION_STYLE_EXT = 0x4058

  AFFINITY_DOMAIN_L1_CACHE_EXT = 0x1
  AFFINITY_DOMAIN_L2_CACHE_EXT = 0x2
  AFFINITY_DOMAIN_L3_CACHE_EXT = 0x3
  AFFINITY_DOMAIN_L4_CACHE_EXT = 0x4
  AFFINITY_DOMAIN_NUMA_EXT = 0x10
  AFFINITY_DOMAIN_NEXT_FISSIONABLE_EXT = 0x100

  PROPERTIES_LIST_END_EXT = 0
  PARTITION_BY_COUNTS_LIST_END_EXT = 0
  PARTITION_BY_NAMES_LIST_END_EXT = -1

  [
    [ "clReleaseDeviceEXT",
      :cl_int,
      [ Device ]
    ], [
      "clRetainDeviceEXT",
      :cl_int,
      [ Device ]
    ], [
      "clCreateSubDevicesEXT",
      :cl_int,
      [ Device,
        :pointer,
        :cl_uint,
        :pointer,
        :pointer ]
    ]
  ].each { |name, return_type, args|
    attach_extension_function(name, return_type, args)
  }

  def self.create_sub_devices_ext( in_device, properties )
    error_check(INVALID_OPERATION) if in_device.platform.version_number < 1.1 and not in_device.platform.extensions.include? "cl_ext_device_fission"
    props = MemoryPointer::new( :cl_device_partition_property_ext, properties.length + 1 )
    properties.each_with_index { |e,i|
      props[i].write_cl_device_partition_property_ext(e)
    }
    props[properties.length].write_cl_device_partition_property_ext(0)
    device_number_ptr = MemoryPointer::new( :cl_uint )
    error = clCreateSubDevicesEXT( in_device, props, 0, nil, device_number_ptr )
    error_check(error)
    device_number = device_number_ptr.read_cl_uint
    devices_ptr = MemoryPointer::new( Device, device_number )
    error = clCreateSubDevicesEXT( in_device, props, device_number, devices_ptr, nil )
    error_check(error)
    devices_ptr.get_array_of_pointer(0, device_number).collect { |device_ptr|
      Device::new(device_ptr, false)
    }
  end

  class Error

    eval error_class_constructor( :INVALID_PARTITION_COUNT_EXT, :InvalidPartitionCountEXT )
    eval error_class_constructor( :DEVICE_PARTITION_FAILED_EXT, :DevicePartitionFailedEXT )

  end

  class Device

    PARTITION_EQUALLY_EXT = 0x4050
    PARTITION_BY_COUNTS_EXT = 0x4051
    PARTITION_BY_NAMES_EXT = 0x4052
    PARTITION_BY_AFFINITY_DOMAIN_EXT = 0x4053

    PARENT_DEVICE_EXT = 0x4054
    PARTITION_TYPES_EXT = 0x4055
    AFFINITY_DOMAINS_EXT = 0x4056
    REFERENCE_COUNT_EXT = 0x4057
    PARTITION_STYLE_EXT = 0x4058

    # Enum that maps the :cl_device_partition_property_ext type
    class PartitionEXT < EnumInt
      EQUALLY_EXT = 0x4050
      BY_COUNTS_EXT = 0x4051
      BY_COUNTS_LIST_END_EXT = 0x0
      BY_NAMES_EXT = 0x4052
      BY_AFFINITY_DOMAIN_EXT = 0x4053
      BY_NAMES_LIST_END_EXT = -1
      @codes = {}
      @codes[0x4050] = 'EQUALLY_EXT'
      @codes[0x4051] = 'BY_COUNTS_EXT'
      @codes[0x0] = 'BY_COUNTS_LIST_END_EXT'
      @codes[0x4052] = 'BY_NAMES_EXT'
      @codes[0x4053] = 'BY_AFFINITY_DOMAIN_EXT'
      @codes[-1] = 'BY_NAMES_LIST_END_EXT'
    end

    # Bitfield that maps the :cl_device_affinity_domain_ext type
    class AffinityDomainEXT < Enum
      L1_CACHE_EXT = 0x1
      L2_CACHE_EXT = 0x2
      L3_CACHE_EXT = 0x3
      L4_CACHE_EXT = 0x4
      NUMA_EXT = 0x10
      NEXT_FISSIONABLE_EXT = 0x100
      @codes = {}
      @codes[0x1] = 'L1_CACHE_EXT'
      @codes[0x2] = 'L2_CACHE_EXT'
      @codes[0x3] = 'L3_CACHE_EXT'
      @codes[0x4] = 'L4_CACHE_EXT'
      @codes[0x10] = 'NUMA_EXT'
      @codes[0x100] = 'NEXT_FISSIONABLE_EXT'
    end

  end

  module InnerInterface
    TYPE_CONVERTER[:cl_device_affinity_domain_ext] = Device::AffinityDomainEXT
  end

  class Device

    # Creates a new Device and retains it if specified and aplicable
    def initialize(ptr, retain = true)
      super(ptr)
      p = platform
      if p.version_number >= 1.2 and retain then
        error = OpenCL.clRetainDevice(ptr)
        error_check( error )
      elsif p.version_number >= 1.1 and retain and extensions.include? "cl_ext_device_fission" then
        error = OpenCL.clRetainDeviceEXT(ptr)
        error_check( error )
      end
      #STDERR.puts "Allocating Device: #{ptr}"
    end

    # method called at Device deletion, releases the object if aplicable
    # @private
    def self.release(ptr)
      plat = FFI::MemoryPointer::new( Platform )
      error = OpenCL.clGetDeviceInfo( ptr, OpenCL::Device::PLATFORM, plat.size, plat, nil)
      error_check( error )
      platform = OpenCL::Platform::new(plat.read_pointer)
      if platform.version_number >= 1.2 then
        error = OpenCL.clReleaseDevice(ptr)
        error_check( error )
      elsif platform.version_number >= 1.1
        ext_size = FFI::MemoryPointer::new( :size_t )
        error = OpenCL.clGetDeviceInfo( ptr, OpenCL::Device::EXTENSIONS, 0, nil, ext_size)
        error_check( error )
        ext = FFI::MemoryPointer::new( ext.read_size_t )
        error = OpenCL.clGetDeviceInfo( ptr, OpenCL::Device::EXTENSIONS, ext.size, ext, nil)
        error_check( error )
        extensions = ext.read_string.split(" ")
        if extensions.include? "cl_ext_device_fission" then
          error = OpenCL.clReleaseDeviceEXT(ptr)
          error_check( error )
        end
      end
    end

    module EXTDeviceFission
      extend InnerGenerator

      # Returns the list of partition types supported by the Device
      def partition_types_ext
        ptr1 = MemoryPointer::new( :size_t, 1)
        error = OpenCL.clGetDeviceInfo(self, PARTITION_TYPES_EXT, 0, nil, ptr1)
        error_check(error)
        ptr2 = MemoryPointer::new( ptr1.read_size_t )
        error = OpenCL.clGetDeviceInfo(self, PARTITION_TYPES_EXT, ptr1.read_size_t, ptr2, nil)
        error_check(error)
        arr = ptr2.get_array_of_cl_device_partition_property_ext(0, ptr1.read_size_t/ OpenCL.find_type(:cl_device_partition_property_ext).size)
        arr.reject! { |e| e == 0 }
        return arr.collect { |e| PartitionEXT::new(e.to_i) }
      end

      get_info_array("Device", :cl_device_affinity_domain_ext, "affinity_domains_ext")

      # Returns the parent Device if it exists
      def parent_device_ext
        ptr = MemoryPointer::new( Device )
        error = OpenCL.clGetDeviceInfo(self, PARENT_DEVICE_EXT, Device.size, ptr, nil)
        error_check(error)
        return nil if ptr.null?
        return Device::new(ptr.read_pointer)
      end

      get_info("Device", :cl_uint, "reference_count_ext")

      def partition_style_ext
        ptr1 = MemoryPointer::new( :size_t, 1)
        error = OpenCL.clGetDeviceInfo(self, PARTITION_STYLE_EXT, 0, nil, ptr1)
        error_check(error)
        ptr2 = MemoryPointer::new( ptr1.read_size_t )
        error = OpenCL.clGetDeviceInfo(self, PARTITION_STYLE_EXT, ptr1.read_size_t, ptr2, nil)
        error_check(error)
        arr = ptr2.get_array_of_cl_device_partition_property_ext(0, ptr1.read_size_t/ OpenCL.find_type(:cl_device_partition_property).size)
        return [] if arr.length == 0
        ptype = arr.first.to_i
        arr_2 = []
        arr_2.push( PartitionEXT::new(ptype) )
        return arr_2 if arr.length == 1
        case ptype
        when PartitionEXT::BY_NAMES_EXT
          i = 1
          while arr[i].to_i - (0x1 << Pointer.size * 8) != PartitionEXT::BY_NAMES_LIST_END_EXT do
            arr_2.push( arr[i].to_i )
            i += 1
            return arr_2 if arr.length <= i
          end
          arr_2.push( PartitionEXT::new(PartitionEXT::BY_NAMES_LIST_END_EXT) )
          arr_2.push( 0 )
        when PartitionEXT::EQUALLY_EXT
          arr_2.push(arr[1].to_i)
          arr_2.push( 0 )
        when PartitionEXT::BY_COUNTS_EXT
          i = 1
          while arr[i].to_i != PartitionEXT::BY_COUNTS_LIST_END_EXT do
            arr_2.push( arr[i].to_i )
            i += 1
            return arr_2 if arr.length <= i
          end
          arr_2.push( PartitionEXT::new(PartitionEXT::BY_COUNTS_LIST_END_EXT) )
          arr_2.push( 0 )
        end
        return arr_2
      end

      def create_sub_devices_ext( properties )
        OpenCL.create_sub_devices_ext( self, properties )
      end

      def partition_by_affinity_domain_ext( affinity_domain = AffinityDomainEXT::NEXT_FISSIONABLE_EXT )
        return OpenCL.create_sub_devices_ext( self,  [ PartitionEXT::BY_AFFINITY_DOMAIN_EXT, affinity_domain ] )
      end

      def partition_equally_ext( compute_unit_number = 1 )
        return OpenCL.create_sub_devices_ext( self,  [ PartitionEXT::EQUALLY_EXT, compute_unit_number ] )
      end

      def partition_by_counts_ext( *compute_unit_count_list )
        compute_unit_count_list = [1] if compute_unit_count_list == []
        compute_unit_count_list.flatten!
        return OpenCL.create_sub_devices_ext( self,  [ PartitionEXT::BY_COUNTS_EXT] + compute_unit_count_list + [ PartitionEXT::BY_COUNTS_LIST_END_EXT ] )
      end

      def partition_by_names_ext( *compute_unit_name_list )
        compute_unit_name_list = [0] if compute_unit_name_list == []
        compute_unit_name_list.flatten!
        return OpenCL.create_sub_devices_ext( self,  [ PartitionEXT::BY_NAMES_EXT ] + compute_unit_name_list + [ PartitionEXT::BY_NAMES_LIST_END_EXT ] )
      end

    end

     register_extension( :cl_ext_device_fission,  EXTDeviceFission, "extensions.include?(\"cl_ext_device_fission\")" )

  end

end

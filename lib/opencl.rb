begin
  require "narray"
rescue LoadError
  begin
    require "rubygems"
    gem "narray"
    require "narray"
  rescue LoadError
  end
end

require "opencl.so"

module OpenCL

  module_function
  def get_info_method(klass, name, type, ext=nil)
    klass = "OpenCL" + (klass ? "::#{klass}" : "")
    return <<EOF, nil, __FILE__, __LINE__+1
    def #{name}
      self.get#{ext}_info(#{klass}::#{name.upcase}).unpack("#{type}")[0]
    end
EOF
  end
  def get_info_uint(klass, name, ext=nil)
    get_info_method(klass, name, "L", ext)
  end
  def get_info_int(klass, name, ext=nil)
    get_info_method(klass, name, "l", ext)
  end
  def get_info_ulong(klass, name, ext=nil)
    get_info_method(klass, name, "Q", ext)
  end
  def get_info_bool(klass, name, ext=nil)
    return <<EOF, nil, __FILE__, __LINE__+1
    def #{name}
      self.get#{ext}_info(OpenCL::#{klass}::#{name.upcase}).unpack("L")[0] == 1 ? true : false
    end
EOF
  end
  def get_info_string(klass, name, ext=nil)
    return <<EOF, nil, __FILE__, __LINE__+1
    def #{name}
      self.get#{ext}_info(OpenCL::#{klass}::#{name.upcase}).chop!
    end
EOF
  end
  def get_info_size_t(klass, name, ext=nil)
    return <<EOF, nil, __FILE__, __LINE__+1
    def #{name}
      OpenCL.get_size_t(self.get#{ext}_info(OpenCL::#{klass}::#{name.upcase}))
    end
EOF
  end
  
  def get_size_t(str, n=1)
    case str.length/n
    when 4
      ary = str.unpack("L#{n}")
    when 8
      ary = str.unpack("Q#{n}")
    else
      raise "unsupported size"
    end
    return n==1 ? ary[0] : ary
  end




  class Vector
    def inspect
      "#<#{self.class}: #{self.to_a.join(", ")}>"
    end
  end

  class VArray
    def inspect
      data = Array.new
      [self.length,4].min.times do |i|
        data.push self.type_code%100==1 ? self[i] : self[i].to_a.inspect
      end
      "#<#{self.class}: length=#{self.length}, type_code=#{self.type_code},\n  data=[#{data.join(", ")}#{self.length>4 ? ", ..." : ""}]>"
    end
    alias :size :length
  end

  class Platform
    %w(profile version name vendor extensions).each do |name|
      eval *OpenCL.get_info_string("Platform", name)
    end
    def devices(dtype)
      OpenCL::Device.get_devices(self, dtype)
    end
  end

  class Device
    def type_names
      t = self.type
      ary = Array.new
      %w(CPU GPU ACCELERATOR DEFAULT).each do |tname|
        unless (OpenCL::Device.const_get("TYPE_#{tname}") & t)==0
          ary.push tname
        end
      end
      return ary
    end
    def single_fp_config_names
      t = self.single_fp_config
      ary = Array.new
      %w(DENORM INF_NAN ROUND_TO_NEAREST ROUND_TO_ZERO FMA).each do |tname|
        unless (OpenCL::Device.const_get("FP_#{tname}") & t)==0
          ary.push tname
        end
      end
      return ary
    end
    def execution_capability_names
      t = self.execution_capabilities
      ary = Array.new
      %w(KERNEL NATIVE_KERNEL).each do |tname|
        unless (OpenCL::Device.const_get("EXEC_#{tname}") & t)==0
          ary.push tname
        end
      end
      return ary
    end
    def queue_property_names
      t = self.queue_properties
      ary = Array.new
      %w(OUT_OF_ORDER_EXEC_MODE_ENABLE PROFILING_ENABLE).each do |tname|
        unless (OpenCL::CommandQueue.const_get(tname) & t)==0
          ary.push tname
        end
      end
      return ary
    end
    def global_mem_cache_type_name
      case self.global_mem_cache_type
      when OpenCL::Device::NONE
        "none"
      when OpenCL::Device::READ_ONLY_CACHE
        "read only cache"
      when OpenCL::Device::READ_WRITE_CACHE
        "read write cache"
      else
        raise "[BUG] unexpected value"
      end
    end
    def local_mem_type_name
      case self.local_mem_type
      when OpenCL::Device::LOCAL
        "local"
      when OpenCL::Device::GLOBAL
        "global"
      else
        raise "[BUG] unexpected value"
      end
    end
    def max_work_item_sizes
      OpenCL.get_size_t(self.get_info(OpenCL::Device::MAX_WORK_ITEM_SIZES), self.max_work_item_dimensions)
    end
    %w(vendor_id max_compute_units max_work_item_dimensions preferred_vector_width_char preferred_vector_width_short preferred_vector_width_long preferred_vector_width_float preferred_vector_width_double max_clock_frequency address_bits max_read_image_args max_write_image_args max_samplers mem_base_addr_align min_data_type_align_size global_mem_cache_type global_mem_cacheline_size max_constant_args local_mem_type).each do |name|
      eval *OpenCL.get_info_uint("Device", name)
    end
    %w(type max_mem_alloc_size single_fp_config global_mem_cache_size global_mem_size max_constant_buffer_size local_mem_size execution_capabilities queue_properties).each do |name|
      eval *OpenCL.get_info_ulong("Device", name)
    end
    %w(image_support error_correction_support endian_little available compiler_available).each do |name|
      eval *OpenCL.get_info_bool("Device", name)
    end
    %w(name vendor profile version extensions).each do |name|
      eval *OpenCL.get_info_string("Device", name)
    end
    %w(max_work_group_size image2D_max_width image2D_max_height image3D_max_width image3D_max_height image3D_max_depth max_parameter_size profiling_timer_resolution).each do |name|
      eval *OpenCL.get_info_size_t("Device", name)
    end
  end

  class Context
    %w(reference_count).each do |name|
      eval *OpenCL.get_info_uint("Context", name)
    end
    def create_command_queue(device, properties)
      OpenCL::CommandQueue.new(self, device, properties)
    end
    def create_buffer(flag, opts={})
      OpenCL::Buffer.new(self, flag, opts)
    end
    def create_image2D(flag, format, opts={})
      OpenCL::Image2D.new(self, flag, format, opts)
    end
    def create_image3D(flag, format, opts={})
      OpenCL::Image3D.new(self, flag, format, opts)
    end
    def create_sampler(coords, addressing_mode, filter_mode)
      OpenCL::Sampler.new(self, coords, addressing_mode, filter_mode)
    end
    def create_program_with_source(strings)
      OpenCL::Program.create_with_source(self, strings)
    end
  end

  class CommandQueue
    def properity_names
      t = self.properties
      ary = Array.new
      %w(OUT_OF_ORDER_EXEC_MODE_ENABLE PROFILING_ENABLE).each do |tname|
        unless (OpenCL::CommandQueue.const_get("QUEUE_#{tname}") & t)==0
          ary.push tname
        end
      end
      return ary
    end
    %w(reference_count).each do |name|
      eval *OpenCL.get_info_uint("CommandQueue", name)
    end
    %w(properties).each do |name|
      eval *OpenCL.get_info_ulong("CommandQueue", name)
    end
  end

  class Mem
    def type_name
      case self.mem_object_type
      when OpenCL::Mem::BUBBER
        "buffer"
      when OPENCL::Mem::IMAGE2D
        "image2D"
      when OPENCL::Mem::IMAGE3D
        "image3D"
      else
        raise "[BUG] unexpected value"
      end
    end
    def flag_names
      t = self.flags
      ary = Array.new
      %w(READ_WRITE WRITE_ONLY READ_ONLY USE_HOST_PTR ALLOC_HOST_PTR COPY_HOST_PTR).each do |tname|
        unless (OpenCL::Mem.const_get(tname) & t)==0
          ary.push tname
        end
      end
      return ary
    end
    %w(type map_count reference_count).each do |name|
      eval *OpenCL.get_info_uint("Mem", name)
    end
    %w(flags).each do |name|
      eval *OpenCL.get_info_ulong("Mem", name)
    end
    %w(size).each do |name|
      eval *OpenCL.get_info_size_t("Mem", name)
    end
  end

  class Image
    %w(element_size row_pitch slice_pitch width height depth).each do |name|
      eval *OpenCL.get_info_size_t("Image", name)
    end
  end

  class Sampler
    def addressing_mode_name
      case self.addressing_mode
      when OpenCL::ADDRESS_NONE
        "none"
      when OpenCL::ADDRESS_CLAMP_TO_EDGE
        "clamp to edge"
      when OpenCL::ADDRESS_CLAMP
        "clamp"
      when OpenCL::ADDRESS_REPEAT
        "repeat"
      else
        raise "[BUG] unexpected value"
      end
    end
    def filter_mode_name
      case self.filter_mode
      when OpenCL::FILTER_NEAREST
        "nearest"
      when OpenCL::FILTER_LINEAR
        "linear"
      else
        raise "[BUG] unexpected value"
      end
    end
    %w(reference_count addressing_mode filter_mode).each do |name|
      eval *OpenCL.get_info_uint("Sampler", name)
    end
    %w(normalized_coord).each do |name|
      eval *OpenCL.get_info_bool("Sampler", name)
    end
  end

  class Program
    alias :_build :build
    def build(*args)
      begin
        _build(*args)
      rescue
        build_log.each do |device, log|
          print device.name, ":\n  "
          print log.gsub(/\n/, "\n  ")
          print "\n"
        end
        raise $!
      end
    end

    def build_status_name
      case self.build_status
      when OpenCL::BUILD_SUCCESS
        "success"
      when OpenCL::BUILD_NONE
        "none"
      when OpenCL::BUILD_ERROR
        "error"
      when OpenCL::BUILD_IN_PROGRESS
        "in progress"
      else
        raise "[BUG] unexpected value"
      end
    end
    def binary_sizes
      OpenCL.get_size_t(self.get_info(OpenCL::Program::BINARY_SIZES), self.num_devices)
    end
    %w(reference_count num_devices).each do |name|
      eval *OpenCL.get_info_uint("Program", name)
    end
    %w(build_status).each do |name|
      eval <<EOF, nil, __FILE__, __LINE__+1
      def #{name}
        ary = Array.new
        devices.each do |device|
          ary.push [device, self.get_build_info(device, OpenCL::Program::#{name.upcase}).unpack("l")[0]]
        end
	ary
      end
EOF
    end
    %w(source build_options build_log).each do |name|
      eval <<EOF, nil, __FILE__, __LINE__+1
      def #{name}
        ary = Array.new
        devices.each do |device|
          ary.push [device, get_build_info(device, OpenCL::Program::#{name.upcase}).chop!]
        end
	ary
      end
EOF
    end

    def ceate_kernel(name)
      OpenCL::Kernel.new(self, name)
    end
  end

  class Kernel
    def compile_work_group_size
      OpenCL.get_size_t(self.get_work_group_info(OpenCL::Kernel::COMPILE_WORK_GROUP_SIZE), 3)
    end
    %w(num_args reference_ount).each do |name|
      eval *OpenCL.get_info_uint("Kernel", name)
    end
    %w(function_name).each do |name|
      eval *OpenCL.get_info_string("Kernel", name)
    end
    %w(work_group_size).each do |name|
      eval *OpenCL.get_info_size_t("Kernel", name, "_work_group")
    end
    def set_args(args)
      args.each_with_index do |arg,i|
        self.set_arg(i, arg)
      end
    end
  end

  class Event
    def wait
      Event.wait([self])
    end
    def command_type_name
      case self.command_type
      when OpenCL::COMMAND_NDRANGE_KERNEL
        "ndrange kernel"
      when OpenCL::COMMAND_TASK
        "task"
      when OpenCL::COMMAND_NATIVE_KERNEL
        "native kernel"
      when OpenCL::COMMAND_READ_BUFFER
        "read buffer"
      when OpenCL::COMMAND_WRITE_BUFFER
        "write buffer"
      when OpenCL::COMMAND_COPY_BUFFER
        "copy buffer"
      when OpenCL::COMMAND_READ_IMAGE
        "read image"
      when OpenCL::COMMAND_WRITE_IMAGE
        "write image"
      when OpenCL::COMMAND_COPY_IMAGE
        "copy image"
      when OpenCL::COMMAND_COPY_IMAGE_TO_BUFFER
        "copy image to buffer"
      when OpenCL::COMMAND_COPY_BUFFER_TO_IMAGE
        "copy buffer to image"
      when OpenCL::COMMAND_MAP_BUFFER
        "map buffer"
      when OpenCL::COMMAND_MAP_IMAGE
        "map image"
      when OpenCL::COMMAND_UNMAP_MEM_OBJECT
        "unmap mem object"
      when OpenCL::COMMAND_MARKER
        "marker"
      when OpenCL::COMMAND_WAIT_FOR_EVENTS
        "wait for events"
      when OpenCL::COMMAND_BARRIER
        "barrier"
      when OpenCL::COMMAND_ACQUIRE_GL_OBJECTS
        "acquire gl objects"
      when OpenCL::COMMAND_RELEASE_GL_OBJECTS
        "release gl objects"
      else
        raise "[BUG] unexpected value"
      end
    end
    def command_execution_status_name
      case i = self.command_execution_status
      when OpenCL::QUEUED
        "queued"
      when OpenCL::SUBMITTED
        "submitted"
      when OpenCL::RUNNING
        "running"
      when OpenCL::COMPLETE
        "complete"
      else
        "error code: #{i}"
      end
    end
    %w(command_type reference_count).each do |name|
      eval *OpenCL.get_info_uint("Event", name)
    end
    %w(command_execution_status).each do |name|
      eval *OpenCL.get_info_int("Event", name)
    end
    %w(profiling_command_queued profiling_command_submit profiling_command_start profiling_command_end).each do |name|
      eval *OpenCL.get_info_ulong(nil, name, "_profiling")
#      eval *OpenCL.get_info_ulong("Event", name, "_profiling")
    end
  end

end

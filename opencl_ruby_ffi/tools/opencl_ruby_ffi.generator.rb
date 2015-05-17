# :stopdoc:

CL_PLATFORM_H = "/usr/include/CL/cl_platform.h"
CL_H = "/usr/include/CL/cl.h"
CL_GL_H = "/usr/include/CL/cl_gl.h"
CL_EXT_H = "/usr/include/CL/cl_ext.h"
$header_files = [CL_H, CL_GL_H, CL_EXT_H, "/usr/include/CL/cl_gl_ext.h"]
$windows_header_files = ["/usr/include/CL/cl_dx9_media_sharing.h", "/usr/include/CL/cl_d3d11.h", "/usr/include/CL/cl_d3d10.h"]
$api_entries = {}

cl_h = nil
File::open(CL_H, "r") { |f|
  cl_h = f.read
}

cl_gl_h = nil
File::open(CL_GL_H, "r") { |f|
  cl_gl_h = f.read
}

cl_ext_h = nil
File::open(CL_EXT_H, "r") { |f|
  cl_ext_h = f.read
}

cl_platform_h = nil
File::open(CL_PLATFORM_H, "r") { |f|
  cl_platform_h = f.read
}
base_directory = "../lib/opencl_ruby_ffi"
output = File::new(base_directory+"/"+"opencl_ruby_ffi_base_gen.rb","w+")
output.puts <<EOF
require 'ffi'

# Maps the OpenCL API using FFI
module OpenCL
  extend FFI::Library
  begin
    ffi_lib "OpenCL"
  rescue LoadError => e
    begin
      ffi_lib "libOpenCL.so.1"
    rescue LoadError => e
      begin
        ffi_lib '/System/Library/Frameworks/OpenCL.framework/OpenCL'
      rescue LoadError => e
        raise "OpenCL implementation not found!"
      end
    end
  end
EOF

constants = cl_h.scan(/#define\s+(\w+)\s+(.*)?$/)
constants += cl_gl_h.scan(/#define\s+(\w+)\s+(.*)?$/)
constants += cl_ext_h.gsub(/\/\/.*$/,"").scan(/^#define\s+(\w+)\s+(\S*)?$/)
constants.uniq!
constants.collect! { |name,value|
  [name, value.sub(/\s*\/\*.*?\*\//,"")]
}
constants.reject! { |name,value|
  name == "__OPENCL_CL_H" || name == "__OPENCL_CL_GL_H" || name == "__CL_EXT_H"
}
output.puts"  #:stopdoc:"
constants.each { |name,value|
  output.puts "  #{name.sub("CL_","")} = #{value.sub("CL_","")}"
}
output.puts"  #:startdoc:"

output.puts <<EOF
  # Parent claas to map OpenCL errors, and is used to raise unknown errors
  class Error < StandardError
    attr_reader :code

    def initialize(code)
      @code = code
      super("\#{code}")
    end

    #:stopdoc:
    CLASSES = {}
    #:startdoc:

    private_constant :CLASSES

    # Returns the class corresponding to the error code (if any)
    def self.error_class(errcode)
      return CLASSES[errcode]
    end

    # Returns a string representing the name corresponding to the error code
    def self.name(code)
      if CLASSES[code] then
        return CLASSES[code].name
      else
        return "\#{code}"
      end
    end

    # Returns a string representing the name corresponding to the error
    def name
      return "\#{@code}"
    end
EOF
errors = {}
constants.reverse.each { |name,value| errors[value.to_i] = name.sub("CL_","") if value.to_i<0 }
errors.each { |k,v|
  name = v.split("_").collect{ |e|
    if e.match("KHR") or e.match("GL") then
      e
    else
      e.capitalize
    end
  }.join
  output.puts <<EOF

    # Represents the OpenCL CL_#{v} error
    class #{v} < Error

      # Initilizes code to #{k}
      def initialize
        super(#{k})
      end

      # Returns a string representing the name corresponding to the error classe
      def self.name
        return "#{v}"
      end

      # Returns a string representing the name corresponding to the error
      def name
        return "#{v}"
      end

      # Returns the code corresponding to this error class
      def self.code
        return #{k}
      end

    end

    CLASSES[#{k}] = #{v}
    #{name} = #{v}
EOF
}
output.puts <<EOF
  end
EOF
    
  

res = cl_platform_h.scan(/typedef (.*)?$/)
base_types = ((res.flatten.select { |item| item.match("_t") }).collect { |item| item.scan(/(\w+)?_t\s+(\w+)/).first })
base_types += [["float","cl_float"],["double","cl_double"],["uint32","cl_GLuint"],["int32","cl_GLint"],["uint32","cl_GLenum"]]
#puts base_types.inspect
  

res = cl_h.scan(/typedef (.*)?$/).flatten.reject { |e| e.match("struct") }
cl_types = res.collect! { |e| e.scan(/(\w+)\s+(\w+)/).first }
res = cl_gl_h.scan(/typedef (.*)?$/).flatten.reject { |e| e.match("struct") || e.match("CL_API_ENTRY") }
gl_types = res.collect! { |e| e.scan(/(\w+)\s+(\w+)/).first }

(base_types+cl_types+gl_types).each { |native,target|
  output.puts "  FFI.typedef :#{native.sub("intptr_t","pointer")}, :#{target}"
}

output.puts <<EOF
  # A parent class to represent OpenCL enums that use :cl_uint
  class Enum
#    extend FFI::DataConverter
#    native_type :cl_uint
    @@codes = {}

    # Initializes an enum with the given val
    def initialize( val )
      OpenCL::check_error( OpenCL::INVALID_VALUE ) if not @@codes[val]
      super()
      @val = val
    end

    # Sets the internal value of the enum
    def val=(v)
      OpenCL::check_error( OpenCL::INVALID_VALUE ) if not @@codes[val]
      @val = v
    end

    # Returns true if val corresponds to the enum value
    def is?(val)
      return true if @val == val
    end

    # Return true if val corresponds to the enum value
    def ==(val)
      return true if @val == val
    end

    # Returns a String corresponfing to the Enum value
    def to_s
      return "\#{self.name}"
    end

    # Returns the integer representing the Enum value
    def to_i
      return @val
    end

    # Returns the integer representing the Enum value
    def to_int
      return @val
    end

#    #:stopdoc:
#    def self.to_native(value, context)
#      if value then
#        return value.flags
#      else
#        return 0
#      end
#    end
#
#    def self.from_native(value, context)
#      new(value)
#    end
#
#    def self.size
#      FFI::find_type(:cl_uint).size
#    end
#
#    def self.reference_required?
#      return false
#    end
#    #:startdoc:

  end

  # A parent class to represent enums that use cl_int
  class EnumInt < Enum
#    extend FFI::DataConverter
#    native_type :cl_int
  end

  # A parent class to represent OpenCL bitfields that use :cl_bitfield
  class Bitfield
#    extend FFI::DataConverter
#    native_type :cl_bitfield

    # Initializes a new Bitfield to val
    def initialize( val = 0 )
      super()
      @val = val
    end

    # Returns true if flag is bitwise included in the Bitfield
    def include?(flag)
      return true if ( @val & flag ) == flag
      return false
    end

    # Returns a String corresponfing to the Bitfield value
    def to_s
      return "\#{self.names}"
    end

    # Returns the integer representing the Bitfield value
    def to_i
      return @val
    end

    # Returns the integer representing the Bitfield value
    def to_int
      return @val
    end

    # Returns the bitwise & operation between f and the internal Bitfield representation
    def &(f)
      return self.class::new( @val & f )
    end

    # Returns the bitwise ^ operation between f and the internal Bitfield representation
    def ^(f)
      return self.class::new( @val ^ f )
    end

    # Returns the bitwise | operation between f and the internal Bitfield representation
    def |(f)
      return self.class::new( @val | f )
    end

    # Returns the internal representation of the Bitfield
    def flags
      return @val
    end

    # Setss the internal representation of the Bitfield to val
    def flags=(val)
      @val = val
    end

#    #:stopdoc:
#    def self.to_native(value, context)
#      if value then
#        return value.flags
#      else
#        return 0
#      end
#    end
#
#    def self.from_native(value, context)
#      new(value)
#    end
#
#    def self.size
#      FFI::find_type(:cl_bitfield).size
#    end
#
#    def self.reference_required?
#      return false
#    end
#    #:startdoc:

  end
EOF

def get_class_constants(constants, constants_prefix, reject_list = [], match_list = nil, positive = true)
  if match_list then
    consts = match_list.collect { |e|
      if positive then
        (constants.to_a.select { |const,value| const == constants_prefix+e and eval(value) >= 0 }).first
      else
        (constants.to_a.select { |const,value| const == constants_prefix+e }).first
      end
    }
  else
    if positive then
      consts = constants.to_a.select { |const,value| const.match(constants_prefix) and eval(value) >= 0 }
    else
      consts = constants.to_a.select { |const,value| const.match(constants_prefix) }
    end
    consts.reject! { |const,value| 
      ( reject_list.collect { |e| const.match(e) } ).compact.length != 0
    }
  end
  consts.collect! { |const,value| ["#{const.sub("CL_MEM_OBJECT","CL_MEM").sub(constants_prefix.sub("CL_MEM_OBJECT","CL_MEM"),"")}", "#{value}"] }
  return consts
end

def create_enum_class(constants, klass_name, constants_prefix, indent=4, reject_list=[], match_list = nil, unsigned = true)
  consts = get_class_constants(constants, constants_prefix, reject_list, match_list, unsigned)
  enum_name = "Enum" + (unsigned == true ? "" : "Int")
  s = <<EOF
class #{klass_name} < #{enum_name}
  #{(consts.collect { |name, value| "#{name} = #{value}"}).join("\n  ")}
  #{(consts.collect { |name, value| "@@codes[#{value}] = '#{name}'"}).join("\n  ")}
  # Returns a String representing the Enum value name
  def name
    return @@codes[@val]
  end
end
EOF
  return (s.each_line.collect { |l| " "*indent  + l }).join("")
end

def create_bitfield_class(constants, klass_name, constants_prefix, indent=4, reject_list=[], match_list = nil)
  consts = get_class_constants(constants, constants_prefix, reject_list, match_list)
  s = <<EOF
class #{klass_name} < Bitfield
  #{(consts.collect { |name, value| "#{name} = #{value}"}).join("\n  ")}
  # Returns an Array of String representing the different flags set
  def names
    fs = []
    %w( #{(consts.collect{ |name, value| name }).join(" ")} ).each { |f|
      fs.push(f) if self.include?( self.class.const_get(f) )
    }
    return fs
  end
end
EOF
  return (s.each_line.collect { |l| " "*indent  + l }).join("")
end

def create_sub_class(constants, klass_name, constants_prefix, indent=4)
  consts = get_class_constants(constants, constants_prefix)
  s = <<EOF
class #{klass_name}
  #{(consts.collect { |name, value| "#{name} = #{value}"}).join("\n  ")}
end
EOF
  return (s.each_line.collect { |l| " "*indent  + l }).join("")
end


def create_base_class(constants, klass_name, constants_prefix, indent=2)
  consts = get_class_constants(constants, constants_prefix)
  s = <<EOF
class #{klass_name} < FFI::ManagedStruct
  layout :dummy, :pointer
  #:stopdoc:
  #{(consts.collect { |name, value| "#{name} = #{value}"}).join("\n  ")}

  # Creates a new #{klass_name} and retains it if specified and aplicable
  def initialize(ptr, retain = true)
    super(ptr)
EOF
  if klass_name != "Platform" and klass_name != "GLsync" and klass_name != "Device" then
    s += <<EOF
    OpenCL.clRetain#{klass_name.sub("Mem","MemObject")}(ptr) if retain
EOF
  elsif klass_name  == "Device" then
    s += <<EOF
    platform = FFI::MemoryPointer::new( Platform )
    OpenCL.clGetDeviceInfo( ptr, OpenCL::Device::PLATFORM, platform.size, platform, nil)
    p = OpenCL::Platform::new(platform.read_pointer)
    if p.version_number >= 1.2 and retain then
      error = OpenCL.clRetainDevice(ptr)
      error_check( error )
    end
EOF
  end
  s += <<EOF
    #STDERR.puts "Allocating #{klass_name}: \#{ptr}"
  end

  # method called at #{klass_name} deletion, releases the object if aplicable
  def self.release(ptr)
EOF
  if klass_name != "Platform" and klass_name != "GLsync" and klass_name != "Device" then
    s += <<EOF
    #STDERR.puts "Releasing #{klass_name}: \#{ptr}"
    #ref_count = FFI::MemoryPointer::new( :cl_uint ) 
    #OpenCL.clGet#{klass_name.sub("Mem","MemObject")}Info(ptr, OpenCL::#{klass_name}::REFERENCE_COUNT, ref_count.size, ref_count, nil)
    #STDERR.puts "reference counter: \#{ref_count.read_cl_uint}"
EOF
  end
  if klass_name != "Platform" and klass_name != "GLsync" and klass_name != "Device" then
    s += <<EOF
    error = OpenCL.clRelease#{klass_name.sub("Mem","MemObject")}(ptr)
    #STDERR.puts "Object released! \#{error}"
    error_check( error )
EOF
  elsif klass_name  == "Device" then
    s += <<EOF
    platform = FFI::MemoryPointer::new( Platform )
    OpenCL.clGetDeviceInfo( ptr, OpenCL::Device::PLATFORM, platform.size, platform, nil)
    p = OpenCL::Platform::new(platform.read_pointer)
    if p.version_number >= 1.2 then
      error = OpenCL.clReleaseDevice(ptr)
      error_check( error )
    end
EOF
  end
  s += <<EOF
  end
  #:startdoc:

  def to_s
    if self.respond_to?(:name) then
      return self.name
    else
      return super
    end
  end

end
EOF
  return (s.each_line.collect { |l| " "*indent  + l }).join("")
end

cl_classes = cl_h.scan(/typedef struct _\w+\s*\*\s*(\w+)/).flatten
cl_classes += cl_gl_h.scan(/typedef struct _\w+\s*\*\s*(\w+)/).flatten
$cl_classes_map = {}
cl_classes.collect! { |c|
  klass_name = c.sub("cl_","").sub("_id","").split("_").map(&:capitalize).join("").sub("Gl","GL")
  $cl_classes_map[c] = klass_name
  constants_prefix = c.sub("_id","").upcase.sub("CL_COMMAND_QUEUE","CL_QUEUE") + "_"

  output.puts <<EOF
#{create_base_class(constants, klass_name, constants_prefix)}
EOF

  if klass_name == "Program" then
  output.puts <<EOF
  class #{klass_name}
    # Enum that maps the :cl_program_binary_type type
#{create_enum_class(constants, "BinaryType","CL_PROGRAM_BINARY_TYPE_")}
  end
EOF
  end

  if klass_name == "Device" then
  output.puts <<EOF
  class #{klass_name}
    # Bitfield that maps the :cl_device_type type
#{create_bitfield_class(constants, "Type", "CL_DEVICE_TYPE_")}
    # Bitfield that maps the :cl_device_fp_config type
#{create_bitfield_class(constants, "FPConfig", "CL_FP_")}
    # Bitfield that maps the :cl_device_exec_capabilities type
#{create_bitfield_class(constants, "ExecCapabilities", "CL_EXEC_")}
    # Enum that maps the :cl_device_mem_cache_type type
#{create_enum_class(constants, "MemCacheType","CL_", 4, nil,["NONE", "READ_ONLY_CACHE", "READ_WRITE_CACHE"])}
    # Enum that maps the :cl_device_local_mem_type type
#{create_enum_class(constants, "LocalMemType","CL_", 4, nil,["LOCAL", "GLOBAL"])}
    # Bitfield that maps the :cl_device_affinity_domain type
#{create_bitfield_class(constants, "AffinityDomain", "CL_DEVICE_AFFINITY_DOMAIN_")}
    # Bitfield that maps the :cl_device_svm_capabilities
#{create_bitfield_class(constants, "SVMCapabilities", "CL_DEVICE_SVM_",4,["CAPABILITIES"])}
  end
EOF
  end

  if klass_name == "Kernel" then
    output.puts <<EOF
  class #{klass_name}
    # Maps the arg logical OpenCL objects
#{create_sub_class(constants, "Arg", "CL_KERNEL_ARG_")}
    class Arg
      # Enum that maps the :cl_kernel_arg_address_qualifier type
#{create_enum_class(constants, "AddressQualifier","CL_KERNEL_ARG_ADDRESS_", 6,["QUALIFIER"])}
      # Enum that maps the :cl_kernel_arg_access_qualifier type
#{create_enum_class(constants, "AccessQualifier","CL_KERNEL_ARG_ACCESS_", 6,["QUALIFIER"])}
      # Bitfield that maps the :cl_kernel_arg_type_qualifier type
#{create_bitfield_class(constants, "TypeQualifier", "CL_KERNEL_ARG_TYPE_", 6, ["QUALIFIER", "NAME"])}
    end
  end
EOF
  end

  if klass_name == "CommandQueue" then
    output.puts <<EOF
  class #{klass_name}
#{create_bitfield_class(constants, "Properties", "CL_QUEUE_", 4, nil, ["OUT_OF_ORDER_EXEC_MODE_ENABLE", "PROFILING_ENABLE", "ON_DEVICE", "ON_DEVICE_DEFAULT"])}
  end
EOF
  end

  if klass_name == "Mem" then
    output.puts <<EOF
  class #{klass_name}
    # Bitfield that maps the :cl_mem_flags type
#{create_bitfield_class(constants, "Flags", "CL_MEM_", 4, nil, %w(READ_WRITE WRITE_ONLY READ_ONLY USE_HOST_PTR ALLOC_HOST_PTR COPY_HOST_PTR HOST_WRITE_ONLY HOST_READ_ONLY HOST_NO_ACCESS) )}
    # Bitfield that maps the :cl_mem_migration_flags type
#{create_bitfield_class(constants, "MigrationFlags", "CL_MIGRATE_MEM_OBJECT_")}
    # Enum that maps the :cl_mem_object_type
#{create_enum_class(constants, "Type","CL_MEM_OBJECT_")}
    # Bitfield that maps the :cl_svm_mem_flags type
#{create_bitfield_class(constants, "SVMFlags", "CL_MEM_", 4, nil, %w(READ_WRITE WRITE_ONLY READ_ONLY SVM_FINE_GRAIN_BUFFER SVM_ATOMICS) )}
  end
EOF
  end

  if klass_name == "Sampler" then
    output.puts <<EOF
  class #{klass_name}
    # Enum that maps the :cl_sampler_properties
#{create_enum_class(constants, "Type","CL_SAMPLER_", 4, nil, %w(NORMALIZED_COORDS ADDRESSING_MODE FILTER_MODE MIP_FILTER_MODE LOD_MIN LOD_MAX) )}
  end
EOF
  end

  $cl_classes_map[c]
}
output.puts <<EOF
  # Enum that maps the :cl_channel_order type
#{create_enum_class(constants, "ChannelOrder","CL_", 2, nil, %w(R A RG RA RGB RGBA BGRA ARGB INTENSITY LUMINANCE Rx RGx RGBx DEPTH DEPTH_STENCIL sRGB sRGBx sRGBA sBGRA ABGR) )}
  # Enum that maps the :cl_channel_type type
#{create_enum_class(constants, "ChannelType","CL_", 2, nil, %w(SNORM_INT8 SNORM_INT16 UNORM_INT8 UNORM_INT16 UNORM_SHORT_565 UNORM_SHORT_555 UNORM_INT_101010 SIGNED_INT8 SIGNED_INT16 SIGNED_INT32 UNSIGNED_INT8 UNSIGNED_INT16 UNSIGNED_INT32 HALF_FLOAT FLOAT UNORM_INT24) )}
  # Enum that maps the :cl_addressing_mode type
#{create_enum_class(constants, "AddressingMode","CL_ADDRESS_", 2)}
  # Enum that maps the :cl_filter_mode type
#{create_enum_class(constants, "FilterMode","CL_FILTER_", 2)}
  # Bitfield that maps the :cl_map_flags type
#{create_bitfield_class(constants, "MapFlags","CL_MAP_", 2)}
  # Enum that maps the :cl_command_type type
#{create_enum_class(constants, "CommandType","CL_COMMAND_", 2)}
  # Enum that maps the :cl_gl_object_type type
#{create_enum_class(constants, "GLObjectType","CL_GL_OBJECT_", 2)}
  # Enum that maps the :cl_build_status type
#{create_enum_class(constants, "BuildStatus","CL_BUILD_", 2, ["PROGRAM_FAILURE"], nil, false)}
  # Enum that maps the command execution status logical type
#{create_enum_class(constants, "CommandExecutionStatus","CL_", 2, nil, %w( COMPLETE RUNNING SUBMITTED QUEUED ), false)}
EOF

consts = constants.to_a.select { |const,value| const.match("CL_IMAGE_") }
consts.collect! { |const,value| "#{const.sub("CL_IMAGE_","")} = #{value}" }
output.puts <<EOF
  class Image < Mem
    layout :dummy, :pointer
    #:stopdoc:
    #{consts.join("\n    ")}
    #:startdoc:
  end
EOF

consts = constants.to_a.select { |const,value| const.match("CL_PIPE_") }
consts.collect! { |const,value| "#{const.sub("CL_PIPE_","")} = #{value}" }
output.puts <<EOF
  class Pipe < Mem
    layout :dummy, :pointer
    #:stopdoc:
    #{consts.join("\n    ")}
    #:startdoc:
  end
EOF

def parse_header
    api_entries = []
    $header_files.each{ |fname|
      f = File::open(fname)
      doc = f.read
      api_entries += doc.scan(/CL_API_ENTRY.*?;/m)
      f.close
    }
    api_entries.each{ |entry|
#      puts entry
      begin 
        entry_name = entry.match(/CL_API_CALL(.*?)\(/m)[1].strip
      rescue
        entry_name = entry.match(/(\S*?)\(/m)[1].strip
      end
      next if entry_name.match('\*')
      next if entry_name.match("INTEL")
      next if entry_name.match("APPLE")
      next if entry_name.match("QCOM")
      res = entry.gsub("\r","").gsub("\n","").gsub("\t","")
      version = res.scan(/CL_API_SUFFIX__VERSION_(\d)_(\d)/).first
#      puts entry_name
#      puts version.inspect
      return_val = res.scan(/(.+)?#{entry_name}/).first[0]
      return_val = return_val.gsub("CL_API_ENTRY","").gsub("CL_API_CALL","").gsub(/CL_EXT_PREFIX__VERSION_\d_\d_DEPRECATED/,"").gsub(/\s/,"")
      return_val = return_val.match(/\*/) ? "pointer" : return_val
      return_val = $cl_classes_map[return_val] ? $cl_classes_map[return_val] : ":"+return_val
      res = res.gsub(/.+?#{entry_name}/m,"").gsub(/\/\*.+?\*\//m,"").gsub(/\s+/m," ").scan(/\((.*)\)/m).first
      callback = res.first.scan(/void \(CL_CALLBACK \* \)\(.*\)/).first
      if callback then
        return_callback = callback.scan(/^.*?\(/).first.gsub(/\W/,"")
        return_callback = ":"+return_callback
        callback_name = entry_name+"_notify"
        callback_params = callback.scan(/void \(CL_CALLBACK \* \)\((.*)\)/).first.first.gsub(/\s/,"").split(",")
        callback_params.collect! { |e| e = e.match(/\*/) ? "pointer" : e }
        callback_params.collect! { |e| e = $cl_classes_map[e] ? $cl_classes_map[e]+".by_ref" : ":"+e }
      end
      res = res.first.gsub(/void \(CL_CALLBACK \* \)\(.*\)/,"CL_CALLBACK").gsub(/\s/,"").split(",")
      res.collect! { |e| e = e.match(/CL_CALLBACK/) ? callback_name : e }
      res.collect! { |e| e = e.match(/\*/) ? "pointer" : e }
      res.collect! { |e| e = $cl_classes_map[e] ? $cl_classes_map[e] : ":"+e }
      if callback then
        callback_params[0] = ":pointer" if callback_name == "clSetMemObjectDestructorCallback_notify"
        $api_entries[entry_name] = { :return_val => return_val, :params => res, :callback => { :name => callback_name, :return_val => return_callback, :params => callback_params }, :version => version}
      else
        $api_entries[entry_name] = { :return_val => return_val, :params => res, :version => version}
      end
    }
end

parse_header

$api_entries.each { |name, data|
  next if name.match("KHR") or name.match("EXT") or ( data[:version] and ( data[:version] == ["1","2"] or data[:version] == ["2","0"] ) )
  if data[:callback] then
    output.puts "  callback :#{data[:callback][:name]}, [#{data[:callback][:params].join(",")}], #{data[:callback][:return_val]}"
  end
  output.puts "  attach_function :#{name}, [#{data[:params].join(",")}], #{data[:return_val]}"
}
  output.puts "  begin"
$api_entries.each { |name, data|
  next if name.match("KHR") or name.match("EXT")
  next if not data[:version] or data[:version] != ["1","2"]
  if data[:callback] then
    output.puts "    callback :#{data[:callback][:name]}, [#{data[:callback][:params].join(",")}], #{data[:callback][:return_val]}"
  end
  output.puts "    attach_function :#{name}, [#{data[:params].join(",")}], #{data[:return_val]}"
}
  output.puts "    begin"
$api_entries.each { |name, data|
  next if name.match("KHR") or name.match("EXT")
  next if not data[:version] or data[:version] != ["2","0"]
  if data[:callback] then
    output.puts "      callback :#{data[:callback][:name]}, [#{data[:callback][:params].join(",")}], #{data[:callback][:return_val]}"
  end
  output.puts "      attach_function :#{name}, [#{data[:params].join(",")}], #{data[:return_val]}"
}
  output.puts "    rescue FFI::NotFoundError => e"
  output.puts "      warn \"Warning OpenCL 1.2 loader detected!\""
  output.puts "    end"
  output.puts "  rescue FFI::NotFoundError => e"
  output.puts "    warn \"Warning OpenCL 1.1 loader detected!\""
  output.puts "  end"


output.puts "end"

output.rewind
#puts output.read
output.close


$types = { :cl_char   => 0,
           :cl_uchar  => 0,
           :cl_short  => 0,
           :cl_ushort => 0,
           :cl_int    => 0,
           :cl_uint   => 0,
           :cl_long   => 0,
           :cl_ulong  => 0,
           :cl_float  => 0.0,
           :cl_double => 0.0,
           :cl_half   => 0.0 }

def generate_arithmetic_type( output, type, vector_length = 1 )

  klass_name = "#{type}".sub("cl_","").capitalize
  klass_name += "#{vector_length}" if vector_length > 1
  klass_name[1] = klass_name[1].upcase if klass_name[0] == "U"
  member_corresp = { }
  i = 0
  (0..9).each { |c|
    member_corresp[i] = c
    i += 1
  }
  ('a'..'f').each { |c|
    member_corresp[i] = c
    i += 1
  }

  members = []
  members_decl = []
  members_init = []
  members_reader = []
  members_seter = []
  members_printer = []
  vector_length.times { |i|
    members.push( "FFI::StructLayout::Field::new( \"s#{member_corresp[i]}\", FFI.find_type(:#{type}).size * #{i}, FFI.find_type(:#{type}) )" )
    members_decl.push( "s#{member_corresp[i]} = #{$types[type]}" )
    members_init.push( "self[:s#{member_corresp[i]}] = s#{member_corresp[i]}" )
    members_reader.push( "# Reads the s#{member_corresp[i]} member\n    def s#{member_corresp[i]}\n     return self[:s#{member_corresp[i]}]\n    end" )
    members_seter.push( "# Sets the s#{member_corresp[i]} member to value\n    def s#{member_corresp[i]}=(value)\n     self[:s#{member_corresp[i]}] = value\n    end" )
    members_printer.push( "\#{self[:s#{member_corresp[i]}]}" )
  }
  output.puts <<EOF
  # Maps the #{type}#{vector_length > 1 ? vector_length : nil} type of OpenCL
  class #{klass_name} < FFI::Struct
    @size = FFI.find_type(:#{type}).size * #{vector_length}
    @layout = FFI::StructLayout::new([ #{members.join(", ")} ], FFI.find_type(:#{type}).size * #{vector_length}, FFI.find_type(:#{type}).size * #{vector_length} )
    # Creates a new #{klass_name} with members set to 0 or to the user specified values
    def initialize( #{members_decl.join(', ')} )
      super()
      #{members_init.join("\n      ")}
    end
    #{members_reader.join("\n    ")}
    #{members_seter.join("\n    ")}
    def to_s
      return "#{klass_name}{ #{members_printer.join(", ")} }"
    end
  end
EOF
end

sizes = [ 1, 2, 4, 8, 16]

output = File::new(base_directory+"/"+"Arithmetic_gen.rb","w+")
output.puts "module OpenCL"
sizes.each { |s|
  $types.each_key { |t|
    generate_arithmetic_type(output, t, s)
  }
}
output.puts "end"
output.close

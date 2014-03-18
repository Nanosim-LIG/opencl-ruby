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

output = File::new("opencl_ruby_ffi_base_gen.rb","w+")
output.puts <<EOF
require 'ffi'

module OpenCL
  extend FFI::Library
  ffi_lib "libOpenCL.so"
EOF

constants = cl_h.scan(/#define\s+(\w+)\s+(.*)?$/)
constants += cl_gl_h.scan(/#define\s+(\w+)\s+(.*)?$/)
constants += cl_ext_h.gsub(/\/\/.*$/,"").scan(/^#define\s+(\w+)\s+(.*)?$/)
constants.uniq!.reject! { |name,value|
  name == "__OPENCL_CL_H" || name == "__OPENCL_CL_GL_H" || name == "__CL_EXT_H"
}
constants.each { |name,value|
  output.puts "  #{name.sub("CL_","")} = #{value.sub("CL_","")}"
}

output.puts <<EOF
  class Error < StandardError
    @@codes = {}
EOF
errors = {}
constants.reverse.each { |name,value| errors[value.to_i] = name.sub("CL_","") if value.to_i<0 }
errors.each { |k,v|
   output.puts "    @@codes[#{k}] = '#{v}'"
}
output.puts <<EOF
    def self.get_error_string(errcode)
      return "CL Error: \#{@@codes[errcode]} (\#{errcode})"
    end
    def self.get_name(errcode)
      return @@codes[errcode]
    end
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
  output.puts "  FFI::typedef :#{native.sub("intptr_t","pointer")}, :#{target}"
}

cl_classes = cl_h.scan(/typedef struct _\w+\s*\*\s*(\w+)/).flatten
cl_classes += cl_gl_h.scan(/typedef struct _\w+\s*\*\s*(\w+)/).flatten
$cl_classes_map = {}
cl_classes.collect! { |c|
  $cl_classes_map[c] = c.sub("cl_","").sub("_id","").split("_").map(&:capitalize).join("").sub("Gl","GL")
  consts = constants.to_a.select { |const,value| const.match(c.sub("_id","").upcase.sub("CL_COMMAND_QUEUE","CL_QUEUE")) }
  consts.collect! { |const,value| "#{const.sub("CL_MEM_OBJECT","CL_MEM").sub(c.sub("_id","").upcase.sub("CL_COMMAND_QUEUE","CL_QUEUE")+"_","")} = #{value}" }
  output.puts <<EOF
  class #{$cl_classes_map[c]} < FFI::ManagedStruct 
    layout :dummy, :pointer
    #{consts.join("\n    ")}
    def self.release(ptr)
EOF
  if $cl_classes_map[c] != "Platform" and $cl_classes_map[c] != "GLsync" then
    if $cl_classes_map[c] == "Device" then
output.puts <<EOF
      return if self.platform.version_number < 1.2
EOF
    end
    output.puts <<EOF
      error = OpenCL.clRelease#{$cl_classes_map[c].sub("Mem","MemObject")}(ptr.read_ptr)
      OpenCL.error_check( error )
EOF
  end
  output.puts <<EOF
    end
  end
EOF
  if c.sub("cl_","").sub("_id","").upcase == "KERNEL" then
    consts = constants.to_a.select { |const,value| const.match("CL_KERNEL_ARG_") }
    consts.collect! { |const,value| "#{const.sub("CL_KERNEL_ARG_","")} = #{value}" }
    output.puts <<EOF
  class #{$cl_classes_map[c]}
    class Arg
      #{consts.join("\n      ")}
    end
  end
EOF
    consts = constants.to_a.select { |const,value| const.match("CL_KERNEL_ARG_ADDRESS_") }
    consts.collect! { |const,value| "#{const.sub("CL_KERNEL_ARG_ADDRESS_","")} = #{value}" }
    output.puts <<EOF
  class #{$cl_classes_map[c]}
    class Arg
      class Address
        #{consts.join("\n        ")}
      end
    end
  end
EOF
    consts = constants.to_a.select { |const,value| const.match("CL_KERNEL_ARG_ACCESS_") }
    consts.collect! { |const,value| "#{const.sub("CL_KERNEL_ARG_ACCESS_","")} = #{value}" }
    output.puts <<EOF
  class #{$cl_classes_map[c]}
    class Arg
      class Access
        #{consts.join("\n        ")}
      end
    end
  end
EOF
    consts = constants.to_a.select { |const,value| const.match("CL_KERNEL_ARG_TYPE_") }
    consts.collect! { |const,value| "#{const.sub("CL_KERNEL_ARG_TYPE_","")} = #{value}" }
    output.puts <<EOF
  class #{$cl_classes_map[c]}
    class Arg
      class Type
        #{consts.join("\n        ")}
      end
    end
  end
EOF
  end
  $cl_classes_map[c]
}
consts = constants.to_a.select { |const,value| const.match("CL_IMAGE_") }
consts.collect! { |const,value| "#{const.sub("CL_IMAGE_","")} = #{value}" }
output.puts <<EOF
  class Image < Mem
    layout :dummy, :pointer
    #{consts.join("\n    ")}
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
        $api_entries[entry_name] = { :return_val => return_val, :params => res, :callback => { :name => callback_name, :return_val => return_callback, :params => callback_params } }
      else
        $api_entries[entry_name] = { :return_val => return_val, :params => res }
      end
    }
end

parse_header

$api_entries.each { |name, data|
  if data[:callback] then
    output.puts "  callback :#{data[:callback][:name]}, [#{data[:callback][:params].join(",")}], #{data[:callback][:return_val]}"
  end
  next if ["clIcdGetPlatformIDsKHR" , "clTerminateContextKHR"].include?(name)
  output.puts "  attach_function :#{name}, [#{data[:params].join(",")}], #{data[:return_val]}"
}

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
  vector_length.times { |i|
    members.push( "FFI::StructLayout::Field::new( \"s#{member_corresp[i]}\", FFI.find_type(:#{type}).size * #{i}, FFI.find_type(:#{type}) )" )
    members_decl.push( "s#{member_corresp[i]} = #{$types[type]}" )
    members_init.push( "self[:s#{member_corresp[i]}] = s#{member_corresp[i]}" )
    members_reader.push( "def s#{member_corresp[i]}\n     return self[:s#{member_corresp[i]}]\n    end" )
    members_seter.push( "def s#{member_corresp[i]}=(value)\n     self[:s#{member_corresp[i]}] = value\n    end" )
  }
  output.puts <<EOF
  class #{klass_name} < FFI::Struct
    @size = FFI.find_type(:#{type}).size * #{vector_length}
    @layout = FFI::StructLayout::new([ #{members.join(", ")} ], FFI.find_type(:#{type}).size * #{vector_length}, FFI.find_type(:#{type}).size * #{vector_length} )
    def initialize( #{members_decl.join(', ')} )
      super()
      #{members_init.join("\n      ")}
    end
    #{members_reader.join("\n    ")}
    #{members_seter.join("\n    ")}
  end
EOF
end

sizes = [ 1, 2, 4, 8, 16]

output = File::new("Arithmetic_gen.rb","w+")
output.puts "module OpenCL"
sizes.each { |s|
  $types.each_key { |t|
    generate_arithmetic_type(output, t, s)
  }
}
output.puts "end"
output.close

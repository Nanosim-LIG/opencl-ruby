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

output = File::new("gen.rb","w+")
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
  $cl_classes_map[c] = c.sub("cl_","").sub("_id","").split("_").map(&:capitalize).join("")
  consts = constants.to_a.select { |const,value| const.match(c.sub("_id","").upcase.sub("CL_COMMAND_QUEUE","CL_QUEUE")) }
  consts.collect! { |const,value| "#{const.sub(c.sub("_id","").upcase.sub("CL_COMMAND_QUEUE","CL_QUEUE")+"_","")} = #{value}" }
  output.puts <<EOF
  class #{$cl_classes_map[c]} < FFI::ManagedStruct 
    layout :dummy, :pointer
    #{consts.join("\n    ")}
  end
EOF
  $cl_classes_map[c]
}

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
        callback_params.collect! { |e| e = $cl_classes_map[e] ? $cl_classes_map[e] : ":"+e }
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

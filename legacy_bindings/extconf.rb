require "mkmf"

dir_config("OpenCL", ".")

if RUBY_VERSION < "1.9" then
  conf = Config::CONFIG
else
  conf = RbConfig::CONFIG
end

if /darwin/ =~ conf["target_os"]
  path = "OpenCL"
else
  path = "CL"
end
unless have_header("#{path}/opencl.h")
  raise "cannot find #{path}/opencl.h"
end
if /darwin/ =~ conf["target_os"]
  $LDFLAGS = "-framework OpenCL"
else
  unless have_library("OpenCL")
    raise "cannot find libOpenCL.so"
  end
end

dir_config("narray", conf["archdir"])
unless have_header("narray.h")
  begin
    require "rubygems"
    if spec = Gem::Specification.find_all_by_name("narray").last
      $CPPFLAGS = "-I" << spec.full_gem_path << " " << $CPPFLAGS
    end
  rescue LoadError
  end
  unless have_header("narray.h")
    warn "cannot find narray.h"
    warn "ruby opencl will be compiled without narray"
  end
end

case "\000\001".unpack("s")[0]
when 1
  $defs.push("-DCL_BIG_ENDIAN")
when 256
  $defs.push("-DCL_LITTLE_ENDIAN")
else
  raise "cannot judge endian"
end

create_makefile("opencl")

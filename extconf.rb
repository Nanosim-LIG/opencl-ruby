require "mkmf"

dir_config("OpenCL", ".")
unless have_header("CL/cl.h")
  raise "cannot find CL/cl.h"
end
unless have_library("OpenCL")
  raise "cannot find libOpenCL.so"
end

dir_config("narray", Config::CONFIG["archdir"])
unless have_header("narray.h")
  warn "cannot find narray.h"
  warn "ruby opencl will be compiled without narray"
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

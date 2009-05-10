require "mkmf"

dir_config("cl", ".")
unless have_header("cl.h")
  raise "cannot find cl.h"
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

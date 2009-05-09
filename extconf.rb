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

create_makefile("opencl")

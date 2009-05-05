require "mkmf"

dir_config("cl",".")
unless have_header("cl.h")
  raise "cannot find cl.h"
end
create_makefile("opencl")

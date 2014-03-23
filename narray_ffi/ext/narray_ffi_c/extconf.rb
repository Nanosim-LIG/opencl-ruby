require 'mkmf'
require 'rbconfig'

if RUBY_VERSION < "1.9" then
  conf = Config::CONFIG
else
  conf = RbConfig::CONFIG
end

dir_config("narray", conf["archdir"])
unless have_header("narray.h")
  begin
    require "rubygems"
    if spec = Gem::Specification.find_all_by_name("narray").last
      spec.require_paths.each { |path|
        $CPPFLAGS = "-I" << spec.full_gem_path << "/" << path << "/ " << $CPPFLAGS
      }
    end
  rescue LoadError
  end
  unless have_header("narray.h")
    abort "missing narray.h" unless have_header("narray.h")
  end
end

dir_config("ffi", conf["archdir"])
unless have_header("Pointer.h")
  begin
    require "rubygems"
    if spec = Gem::Specification.find_all_by_name("ffi").last
      spec.require_paths.each { |path|
        $CPPFLAGS = "-I" << spec.full_gem_path << "/" << path << "/ " << $CPPFLAGS
        $CPPFLAGS = "-I" << spec.full_gem_path << "/" << path << "/" << "libffi-x86_64-linux/include/ " << $CPPFLAGS
      }
    end
  rescue LoadError
  end
  puts $CPPFLAGS
  unless have_header("Pointer.h")
    abort "missing ffi Pointer.h" unless have_header("Pointer.h")
  end
end


create_makefile("narray_ffi_c")

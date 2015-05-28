require 'opencl_ruby_ffi'
require 'tempfile'

$clang_path="clang"
$clang_path = ENV["CLANG"] if ENV["CLANG"]
$opencl_spir = "opencl_spir.h"
$opencl_spir = ENV["OPENCL_SPIR_H"] if ENV["OPENCL_SPIR_H"]

module OpenCL

  class Program
    alias :source_orig :source

    def source=(s)
      @source = s
    end

    def source
      return @source
    end
  end

  class << self
    alias :create_program_with_source_orig :create_program_with_source
  end

  def self.create_program_with_source(context, strings)
    strs = nil
    if not strings then
      error_check(INVALID_VALUE)
    else
      strs = [strings].flatten
    end
    source_file = Tempfile::new(["openl_ruby_ffi_spir",".cl"])
    path = source_file.path
    strs.each { |s| source_file.puts s }
    source_file.close
    target = path.chomp(File::extname(path))+".spir"
    devices = context.devices
    `#{$clang_path} -cc1 -emit-llvm-bc -triple spir64-unknown-unknown -cl-std=CL1.2 -cl-spir-compile-options "-cl-std=CL1.2" -include #{$opencl_spir} -o #{target} #{source_file.path}`
    binary = File::binread(target)
    File::unlink(target)
    binaries = []
    devices.each { |d|
      binaries.push binary
    }
    prog = create_program_with_binary(context, devices, binaries).first
    prog.source = File::read(source_file.path)
    return prog
  end

  class << self
    alias :build_program_orig :build_program
  end

  def self.build_program(program, options = {}, &block)
    opt = ""
    opt = options[:options] if options[:options]
    opt += "-x spir"
    new_options = options.dup
    new_options[:options] = opt
    return build_program_orig(program, new_options, &block)
  end

end

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

  class Kernel
    alias :enqueue_with_args_orig :enqueue_with_args

    def enqueue_with_args(command_queue, global_work_size, *args)
      n = self.num_args
      new_args = nil
      sizes = []
      global_count = 0
      self.args.each_index { |i|
        if self.args[i].address_qualifier == Arg::AddressQualifier::GLOBAL then
          global_count += 1
          sizes.push args[i].size
        end
      }
      n_tot = args.length
      #n_tot += global_count
      error_check(INVALID_KERNEL_ARGS) if n_tot < n
      error_check(INVALID_KERNEL_ARGS) if n_tot > n + 1
      if n_tot == n + 1
        new_args = args[0..-2]
        options = args.last
      else
        new_args = args[0..-1]
        options = {}
      end
      #new_args += sizes
      return enqueue_with_args_orig(command_queue, global_work_size, *new_args, options)
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
    opt += " -x spir"
    new_options = options.dup
    new_options[:options] = opt
    return build_program_orig(program, new_options, &block)
  end

end

Gem::Specification.new do |s|
  s.name = 'opencl_ruby_ffi'
  s.version = "0.998"
  s.author = "Brice Videau"
  s.email = "brice.videau@imag.fr"
  s.homepage = "https://github.com/Nanosim-LIG/opencl-ruby"
  s.summary = "Ruby OpenCL FFI bindings"
  s.description = "Ruby OpenCL FFI bindings. OpenCL 2.0 ready"
  s.files = %w( opencl_ruby_ffi.gemspec LICENSE lib/opencl_ruby_ffi.rb lib/opencl_ruby_ffi/ lib/opencl_ruby_ffi/Arithmetic_gen.rb lib/opencl_ruby_ffi/Buffer.rb lib/opencl_ruby_ffi/CommandQueue.rb lib/opencl_ruby_ffi/Context.rb lib/opencl_ruby_ffi/Device.rb lib/opencl_ruby_ffi/Event.rb lib/opencl_ruby_ffi/Image.rb lib/opencl_ruby_ffi/Kernel.rb lib/opencl_ruby_ffi/Mem.rb lib/opencl_ruby_ffi/opencl_ruby_ffi_base_gen.rb lib/opencl_ruby_ffi/opencl_ruby_ffi_base.rb lib/opencl_ruby_ffi/Platform.rb lib/opencl_ruby_ffi/Program.rb lib/opencl_ruby_ffi/Sampler.rb lib/opencl_ruby_ffi/Pipe.rb lib/opencl_ruby_ffi/SVM.rb )
  s.has_rdoc = true
  s.license = 'BSD'
  s.required_ruby_version = '>= 1.8.7'
  s.add_dependency 'narray', '>=0.6.0.8'
  s.add_dependency 'ffi', '>=1.9.3'
  s.add_dependency 'narray_ffi', '>=0.2'
end

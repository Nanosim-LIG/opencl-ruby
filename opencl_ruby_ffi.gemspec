Gem::Specification.new do |s|
  s.name = 'opencl_ruby_ffi'
  s.version = "1.3.12"
  s.author = "Brice Videau"
  s.email = "bvideau@anl.gov"
  s.homepage = "https://github.com/Nanosim-LIG/opencl-ruby"
  s.summary = "Ruby OpenCL FFI bindings"
  s.description = "Ruby OpenCL FFI bindings. OpenCL 3.0 ready"
  s.files =  Dir[ 'opencl_ruby_ffi.gemspec', 'LICENSE', 'lib/**/**/*.rb', '.yardopts', 'templates_custom/default/module/setup.rb' ]
  s.license = 'BSD-2-Clause'
  s.required_ruby_version = '>= 1.8.7'
  s.add_dependency 'narray', '~> 0.6', '>=0.6.0.8'
  s.add_dependency 'ffi', '~> 1.9', '>=1.9.3'
  s.add_dependency 'narray_ffi', '~> 1.0', '>=1.0.0'
end

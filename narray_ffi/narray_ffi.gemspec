Gem::Specification.new do |s|
  s.name = 'narray_ffi'
  s.version = "0.1"
  s.author = "Brice Videau"
  s.email = "brice.videau@imag.fr"
  s.homepage = "https://forge.imag.fr/projects/opencl-ruby/"
  s.summary = "Ruby narray_ffi"
  s.description = "Ruby narray_ffi interface"
  s.files = %w( narray_ffi.gemspec LICENSE lib/narray_ffi.rb ext/narray_ffi_c/narray_ffi.c ext/narray_ffi_c/extconf.rb) + Dir.glob("{ext,lib}/**/*").reject { |f| f =~ /(lib\/[12]\.[089]|\.so$|\.bundle$)/ }
  s.extensions << 'ext/narray_ffi_c/extconf.rb'
  s.has_rdoc = false
  s.license = 'BSD'
  s.required_ruby_version = '>= 1.8.7'
  s.add_development_dependency 'rake'
  s.add_development_dependency 'rake-compiler', '>=0.6.0'
  s.add_development_dependency 'narray', '>=0.6.0.8'
  s.add_development_dependency 'ffi', '>=1.9.3'
end

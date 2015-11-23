require 'opencl_ruby_ffi'

module OpenCL

  name_p = FFI::MemoryPointer.from_string("clGetGLContextInfoKHR")
  p = clGetExtensionFunctionAddress(name_p)
  if p then
    func = FFI::Function::new(:cl_int, [:pointer, :cl_gl_context_info, :size_t, :pointer, :pointer], p)
    func.attach(OpenCL, "clGetGLContextInfoKHR")

    def self.get_gl_context_info_khr( properties, param_name )
      props = FFI::MemoryPointer::new( :cl_context_properties, properties.length + 1 )
      properties.each_with_index { |e,i|
        props[i].write_cl_context_properties(e)
      }
      props[properties.length].write_cl_context_properties(0)
      size_p = FFI::MemoryPointer::new( :size_t )
      error = clGetGLContextInfoKHR( props, param_name, 0, nil, size_p )
      error_check(error)
      size = size_p.read_size_t
      nb_devices = size/Device.size
      values = FFI::MemoryPointer::new( Device, nb_devices )
      error = clGetGLContextInfoKHR( props, param_name, size, values, nil )
      error_check(error)
      return values.get_array_of_pointer(0, nb_devices).collect { |device_ptr|
        Device::new(device_ptr, false)
      }
    end
  end

  name_p = FFI::MemoryPointer.from_string("clCreateEventFromGLsyncKHR")
  p = clGetExtensionFunctionAddress(name_p)
  if p then
    func = FFI::Function::new(OpenCL::find_type(Event), [OpenCL::find_type(Context), :pointer, :pointer], p)
    func.attach(OpenCL, "clCreateEventFromGLsyncKHR")

    def self.create_event_from_glsync_khr( context, sync)
      error_check(INVALID_OPERATION) if context.platform.version_number < 1.1
      error_p = FFI::MemoryPointer::new( :cl_int )
      event = clCreateEventFromGLsyncKHR( context, sync, error_p )
      error_check(error_p.read_cl_int)
      return Event::new( event, false )
    end
  end

  class Context
    def get_gl_info_khr( param_name )
      error_check(INVALID_OPERATION) unless self.platform.extensions.include?( "cl_khr_gl_sharing" )
      return OpenCL.get_gl_context_info_khr( self.properties, param_name )
    end

    def create_event_from_glsync_khr( sync )
      error_check(INVALID_OPERATION) unless self.platform.extensions.include?( "cl_khr_gl_sharing" )
      return OpenCL.create_event_from_glsync_khr( self, sync )
    end
  end
end

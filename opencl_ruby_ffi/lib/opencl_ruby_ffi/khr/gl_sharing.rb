require 'opencl_ruby_ffi'
using OpenCLRefinements if RUBY_VERSION.scan(/\d+/).collect(&:to_i).first >= 2

module OpenCL

  INVALID_GL_SHAREGROUP_REFERENCE_KHR = -1000

  CURRENT_DEVICE_FOR_GL_CONTEXT_KHR = 0x2006
  DEVICES_FOR_GL_CONTEXT_KHR = 0x2007

  GL_CONTEXT_KHR = 0x2008
  EGL_DISPLAY_KHR = 0x2009
  GLX_DISPLAY_KHR = 0x200A
  WGL_HDC_KHR = 0x200B
  CGL_SHAREGROUP_KHR = 0x200C

  class Error

    eval error_class_constructor( :INVALID_GL_SHAREGROUP_REFERENCE_KHR, :InvalidGLSharegroupReferenceKHR )

  end

  f = attach_extension_function( "clGetGLContextInfoKHR", :cl_int, [:pointer, :cl_gl_context_info, :size_t, :pointer, :pointer] )

  def self.get_gl_context_info_khr( properties, param_name )
    props = MemoryPointer::new( :cl_context_properties, properties.length + 1 )
    properties.each_with_index { |e,i|
      props[i].write_cl_context_properties(e)
    }
    props[properties.length].write_cl_context_properties(0)
    size_p = MemoryPointer::new( :size_t )
    error = clGetGLContextInfoKHR( props, param_name, 0, nil, size_p )
    error_check(error)
    size = size_p.read_size_t
    nb_devices = size/Device.size
    values = MemoryPointer::new( Device, nb_devices )
    error = clGetGLContextInfoKHR( props, param_name, size, values, nil )
    error_check(error)
    return values.get_array_of_pointer(0, nb_devices).collect { |device_ptr|
      Device::new(device_ptr, false)
    }
  end

  class GLContextInfo < Enum
    CURRENT_DEVICE_FOR_GL_CONTEXT_KHR = 0x2006
    DEVICES_FOR_GL_CONTEXT_KHR = 0x2007
    @codes = {}
    @codes[0x2006] = CURRENT_DEVICE_FOR_GL_CONTEXT_KHR
    @codes[0x2007] = DEVICES_FOR_GL_CONTEXT_KHR
  end

  class Context

    class Properties
      GL_CONTEXT_KHR = 0x2008
      CGL_SHAREGROUP_KHR = 0x200C
      EGL_DISPLAY_KHR = 0x2009
      GLX_DISPLAY_KHR = 0x200A
      WGL_HDC_KHR = 0x200B
      @codes[0x2008] = 'GL_CONTEXT_KHR'
      @codes[0x200C] = 'CGL_SHAREGROUP_KHR'
      @codes[0x2009] = 'EGL_DISPLAY_KHR'
      @codes[0x200A] = 'GLX_DISPLAY_KHR'
      @codes[0x200B] = 'WGL_HDC_KHR'
    end

    module KHRGLSharing

      def get_gl_info_khr( param_name )
        return OpenCL.get_gl_context_info_khr( self.properties, param_name )
      end

    end

    Extensions[:cl_khr_gl_sharing] = [KHRGLSharing, "platform.extensions.include?(\"cl_khr_gl_sharing\") or devices.first.extensions.include?(\"cl_khr_gl_sharing\")"]

  end

end

require 'opencl_ruby_ffi'
using OpenCLRefinements if RUBY_VERSION.scan(/\d+/).collect(&:to_i).first >= 2

module OpenCL

  COMMAND_GL_FENCE_SYNC_OBJECT_KHR = 0x200D

  name_p = MemoryPointer.from_string("clCreateEventFromGLsyncKHR")
  p = clGetExtensionFunctionAddress(name_p)
  if p then
    func = Function::new( Event, [Context, :pointer, :pointer], p)
    func.attach(OpenCL, "clCreateEventFromGLsyncKHR")

    def self.create_event_from_glsync_khr( context, sync)
      error_check(INVALID_OPERATION) if context.platform.version_number < 1.1 and not context.platform.extensions.include?( "cl_khr_gl_sharing" )
      error_p = MemoryPointer::new( :cl_int )
      event = clCreateEventFromGLsyncKHR( context, sync, error_p )
      error_check(error_p.read_cl_int)
      return Event::new( event, false )
    end
  end

  class CommandType
    GL_FENCE_SYNC_OBJECT_KHR = 0x200D
    @codes[0x200D] = 'GL_FENCE_SYNC_OBJECT_KHR'
  end

  class Context

    def create_event_from_glsync_khr( sync )
      return OpenCL.create_event_from_glsync_khr( self, sync )
    end

  end

end

using OpenCLRefinements if RUBY_VERSION.scan(/\d+/).collect(&:to_i).first >= 2

module OpenCL

  COMMAND_GL_FENCE_SYNC_OBJECT_KHR = 0x200D

  attach_extension_function( "clCreateEventFromGLsyncKHR", Event, [Context, :pointer, :pointer] )

  def self.create_event_from_glsync_khr( context, sync)
    error_check(INVALID_OPERATION) unless context.platform.extensions.include?( "cl_khr_gl_event" ) or devices.first.extensions.include?("cl_khr_gl_event")
    error_p = MemoryPointer::new( :cl_int )
    event = clCreateEventFromGLsyncKHR( context, sync, error_p )
    error_check(error_p.read_cl_int)
    return Event::new( event, false )
  end

  class CommandType
    GL_FENCE_SYNC_OBJECT_KHR = 0x200D
    @codes[0x200D] = 'GL_FENCE_SYNC_OBJECT_KHR'
  end

  class Context

    module KHRGLEvent

      def create_event_from_glsync_khr( sync )
        return OpenCL.create_event_from_glsync_khr( self, sync )
      end
      alias create_event_from_GLsync_KHR create_event_from_glsync_khr

    end

    register_extension( :cl_khr_gl_event, KHRGLEvent, "platform.extensions.include?(\"cl_khr_gl_event\") or devices.first.extensions.include?(\"cl_khr_gl_event\")" )

  end

end

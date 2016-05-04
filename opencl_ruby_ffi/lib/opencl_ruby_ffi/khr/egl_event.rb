require 'opencl_ruby_ffi'
using OpenCLRefinements if RUBY_VERSION.scan(/\d+/).collect(&:to_i).first >= 2

module OpenCL

  COMMAND_EGL_FENCE_SYNC_OBJECT_KHR = 0x202F

  class CommandType
    EGL_FENCE_SYNC_OBJECT_KHR = 0x202F
    @codes[0x202F] = 'EGL_FENCE_SYNC_OBJECT_KHR'
  end

  attach_extension_function( "clCreateEventFromEGLSyncKHR"), Event, [Context, :cl_egl_sync_khr, :cl_egl_display_khr, :pointer] )
 
end

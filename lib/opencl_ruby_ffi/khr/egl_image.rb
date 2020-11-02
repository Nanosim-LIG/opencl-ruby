using OpenCLRefinements if RUBY_VERSION.scan(/\d+/).collect(&:to_i).first >= 2

module OpenCL

  INVALID_EGL_OBJECT_KHR = -1093
  EGL_RESOURCE_NOT_ACQUIRED_KHR = -1092

  COMMAND_ACQUIRE_EGL_OBJECTS_KHR = 0x202D
  COMMAND_RELEASE_EGL_OBJECTS_KHR = 0x202E

  class Error

    eval error_class_constructor( :INVALID_EGL_OBJECT_KHR,        :InvalidEGLObjectKHR )
    eval error_class_constructor( :EGL_RESOURCE_NOT_ACQUIRED_KHR, :EGLResourceNotAcquiredKHR )

  end

  class CommandType
    ACQUIRE_EGL_OBJECTS_KHR = 0x202D
    RELEASE_EGL_OBJECTS_KHR = 0x202E
    @codes[0x202D] = 'ACQUIRE_EGL_OBJECTS_KHR'
    @codes[0x202E] = 'RELEASE_EGL_OBJECTS_KHR'
  end

  [
    [ "clCreateFromEGLImageKHR",
      Mem,
      [ Context,
        :cl_egl_display_khr,
        :cl_egl_image_khr,
        :cl_mem_flags,
        :pointer,
        :pointer ]
    ], [
      "clEnqueueAcquireEGLObjectsKHR",
      :cl_int,
      [ CommandQueue,
        :cl_uint,
        :pointer,
        :cl_uint,
        :pointer,
        :pointer]
    ], [
      "clEnqueueReleaseEGLObjectsKHR",
      :cl_int,
      [ CommandQueue,
        :cl_uint,
        :pointer,
        :cl_uint,
        :pointer,
        :pointer]
    ]
  ].each { |name, return_type, args|
    f = attach_extension_function(name, return_type, args)
  }

end

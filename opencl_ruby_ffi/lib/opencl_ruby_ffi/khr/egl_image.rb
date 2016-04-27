require 'opencl_ruby_ffi'
using OpenCLRefinements if RUBY_VERSION.scan(/\d+/).collect(&:to_i).first >= 2

module OpenCL

  INVALID_EGL_OBJECT_KHR = -1093
  EGL_RESOURCE_NOT_ACQUIRED_KHR = -1092

  COMMAND_ACQUIRE_EGL_OBJECTS_KHR = 0x202D
  COMMAND_RELEASE_EGL_OBJECTS_KHR = 0x202E

  class Error

    # Represents the OpenCL CL_INVALID_EGL_OBJECT_KHR error
    class INVALID_EGL_OBJECT_KHR < Error

      # Initilizes code to -1093
      def initialize
        super(-1093)
      end

      # Returns a string representing the name corresponding to the error classe
      def self.name
        return "INVALID_EGL_OBJECT_KHR"
      end

      # Returns a string representing the name corresponding to the error
      def name
        return "INVALID_EGL_OBJECT_KHR"
      end

      # Returns the code corresponding to this error class
      def self.code
        return -1093
      end

    end

    CLASSES[-1093] = INVALID_EGL_OBJECT_KHR
    InvalidEGLObjectKHR = INVALID_EGL_OBJECT_KHR

    # Represents the OpenCL CL_EGL_RESOURCE_NOT_ACQUIRED_KHR error
    class EGL_RESOURCE_NOT_ACQUIRED_KHR < Error

      # Initilizes code to -1092
      def initialize
        super(-1092)
      end

      # Returns a string representing the name corresponding to the error classe
      def self.name
        return "EGL_RESOURCE_NOT_ACQUIRED_KHR"
      end

      # Returns a string representing the name corresponding to the error
      def name
        return "EGL_RESOURCE_NOT_ACQUIRED_KHR"
      end

      # Returns the code corresponding to this error class
      def self.code
        return -1092
      end

    end

    CLASSES[-1092] = EGL_RESOURCE_NOT_ACQUIRED_KHR
    InvalidEGLObjectKHR = EGL_RESOURCE_NOT_ACQUIRED_KHR

  end

  class CommandType
    ACQUIRE_EGL_OBJECTS_KHR = 0x202D
    RELEASE_EGL_OBJECTS_KHR = 0x202E
    @codes[0x202D] = 'ACQUIRE_EGL_OBJECTS_KHR'
    @codes[0x202E] = 'RELEASE_EGL_OBJECTS_KHR'
  end

  name_p = MemoryPointer.from_string("clCreateFromEGLImageKHR")
  p = clGetExtensionFunctionAddress(name_p)
  if p then
    func = Function::new( Mem, [Context, :cl_egl_display_khr, :cl_egl_image_khr, :cl_mem_flags, :pointer, :pointer], p )
    func.attach(OpenCL, "clCreateFromEGLImageKHR")
  end

  name_p = MemoryPointer.from_string("clEnqueueAcquireEGLObjectsKHR")
  p = clGetExtensionFunctionAddress(name_p)
  if p then
    func = Function::new( :cl_int, [CommandQueue, :cl_uint, :pointer, :cl_uint, :pointer, :pointer], p )
    func.attach(OpenCL, "clEnqueueAcquireEGLObjectsKHR")
  end

  name_p = MemoryPointer.from_string("clEnqueueReleaseEGLObjectsKHR")
  p = clGetExtensionFunctionAddress(name_p)
  if p then
    func = Function::new( :cl_int, [CommandQueue, :cl_uint, :pointer, :cl_uint, :pointer, :pointer], p )
    func.attach(OpenCL, "clEnqueueReleaseEGLObjectsKHR")
  end
 
end

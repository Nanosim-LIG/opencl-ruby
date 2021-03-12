using OpenCLRefinements if RUBY_VERSION.scan(/\d+/).collect(&:to_i).first >= 2
module OpenCL
  begin
    if ENV["LIBOPENCL_SO"]
      ffi_lib ENV["LIBOPENCL_SO"]
    else
      raise LoadError
    end
  rescue LoadError => e
    begin
      ffi_lib "OpenCL"
    rescue LoadError => e
      begin
        ffi_lib "libOpenCL.so.1"
      rescue LoadError => e
        begin
          ffi_lib '/System/Library/Frameworks/OpenCL.framework/OpenCL'
        rescue LoadError => e
          raise "OpenCL implementation not found!"
        end
      end
    end
  end
  attach_function :clGetPlatformIDs, [:cl_uint,:pointer,:pointer], :cl_int
  attach_function :clGetPlatformInfo, [Platform,:cl_platform_info,:size_t,:pointer,:pointer], :cl_int
  attach_function :clGetDeviceIDs, [Platform,:cl_device_type,:cl_uint,:pointer,:pointer], :cl_int
  attach_function :clGetDeviceInfo, [Device,:cl_device_info,:size_t,:pointer,:pointer], :cl_int
  callback :clCreateContext_notify, [:string,:pointer,:size_t,:pointer], :void
  attach_function :clCreateContext, [:pointer,:cl_uint,:pointer,:clCreateContext_notify,:pointer,:pointer], Context
  callback :clCreateContextFromType_notify, [:string,:pointer,:size_t,:pointer], :void
  attach_function :clCreateContextFromType, [:pointer,:cl_device_type,:clCreateContextFromType_notify,:pointer,:pointer], Context
  attach_function :clRetainContext, [Context], :cl_int
  attach_function :clReleaseContext, [Context], :cl_int
  attach_function :clGetContextInfo, [Context,:cl_context_info,:size_t,:pointer,:pointer], :cl_int
  attach_function :clRetainCommandQueue, [CommandQueue], :cl_int
  attach_function :clReleaseCommandQueue, [CommandQueue], :cl_int
  attach_function :clGetCommandQueueInfo, [CommandQueue,:cl_command_queue_info,:size_t,:pointer,:pointer], :cl_int
  attach_function :clCreateBuffer, [Context,:cl_mem_flags,:size_t,:pointer,:pointer], Mem
  attach_function :clRetainMemObject, [Mem], :cl_int
  attach_function :clReleaseMemObject, [Mem], :cl_int
  attach_function :clGetSupportedImageFormats, [Context,:cl_mem_flags,:cl_mem_object_type,:cl_uint,:pointer,:pointer], :cl_int
  attach_function :clGetMemObjectInfo, [Mem,:cl_mem_info,:size_t,:pointer,:pointer], :cl_int
  attach_function :clGetImageInfo, [Mem,:cl_image_info,:size_t,:pointer,:pointer], :cl_int
  attach_function :clRetainSampler, [Sampler], :cl_int
  attach_function :clReleaseSampler, [Sampler], :cl_int
  attach_function :clGetSamplerInfo, [Sampler,:cl_sampler_info,:size_t,:pointer,:pointer], :cl_int
  attach_function :clCreateProgramWithSource, [Context,:cl_uint,:pointer,:pointer,:pointer], Program
  attach_function :clCreateProgramWithBinary, [Context,:cl_uint,:pointer,:pointer,:pointer,:pointer,:pointer], Program
  attach_function :clRetainProgram, [Program], :cl_int
  attach_function :clReleaseProgram, [Program], :cl_int
  callback :clBuildProgram_notify, [Program.by_ref,:pointer], :void
  attach_function :clBuildProgram, [Program,:cl_uint,:pointer,:pointer,:clBuildProgram_notify,:pointer], :cl_int
  attach_function :clGetProgramInfo, [Program,:cl_program_info,:size_t,:pointer,:pointer], :cl_int
  attach_function :clGetProgramBuildInfo, [Program,Device,:cl_program_build_info,:size_t,:pointer,:pointer], :cl_int
  attach_function :clCreateKernel, [Program,:pointer,:pointer], Kernel
  attach_function :clCreateKernelsInProgram, [Program,:cl_uint,:pointer,:pointer], :cl_int
  attach_function :clRetainKernel, [Kernel], :cl_int
  attach_function :clReleaseKernel, [Kernel], :cl_int
  attach_function :clSetKernelArg, [Kernel,:cl_uint,:size_t,:pointer], :cl_int
  attach_function :clGetKernelInfo, [Kernel,:cl_kernel_info,:size_t,:pointer,:pointer], :cl_int
  attach_function :clGetKernelWorkGroupInfo, [Kernel,Device,:cl_kernel_work_group_info,:size_t,:pointer,:pointer], :cl_int
  attach_function :clWaitForEvents, [:cl_uint,:pointer], :cl_int
  attach_function :clGetEventInfo, [Event,:cl_event_info,:size_t,:pointer,:pointer], :cl_int
  attach_function :clRetainEvent, [Event], :cl_int
  attach_function :clReleaseEvent, [Event], :cl_int
  attach_function :clGetEventProfilingInfo, [Event,:cl_profiling_info,:size_t,:pointer,:pointer], :cl_int
  attach_function :clFlush, [CommandQueue], :cl_int
  attach_function :clFinish, [CommandQueue], :cl_int
  attach_function :clEnqueueReadBuffer, [CommandQueue,Mem,:cl_bool,:size_t,:size_t,:pointer,:cl_uint,:pointer,:pointer], :cl_int
  attach_function :clEnqueueWriteBuffer, [CommandQueue,Mem,:cl_bool,:size_t,:size_t,:pointer,:cl_uint,:pointer,:pointer], :cl_int
  attach_function :clEnqueueCopyBuffer, [CommandQueue,Mem,Mem,:size_t,:size_t,:size_t,:cl_uint,:pointer,:pointer], :cl_int
  attach_function :clEnqueueReadImage, [CommandQueue,Mem,:cl_bool,:pointer,:pointer,:size_t,:size_t,:pointer,:cl_uint,:pointer,:pointer], :cl_int
  attach_function :clEnqueueWriteImage, [CommandQueue,Mem,:cl_bool,:pointer,:pointer,:size_t,:size_t,:pointer,:cl_uint,:pointer,:pointer], :cl_int
  attach_function :clEnqueueCopyImage, [CommandQueue,Mem,Mem,:pointer,:pointer,:pointer,:cl_uint,:pointer,:pointer], :cl_int
  attach_function :clEnqueueCopyImageToBuffer, [CommandQueue,Mem,Mem,:pointer,:pointer,:size_t,:cl_uint,:pointer,:pointer], :cl_int
  attach_function :clEnqueueCopyBufferToImage, [CommandQueue,Mem,Mem,:size_t,:pointer,:pointer,:cl_uint,:pointer,:pointer], :cl_int
  attach_function :clEnqueueMapBuffer, [CommandQueue,Mem,:cl_bool,:cl_map_flags,:size_t,:size_t,:cl_uint,:pointer,:pointer,:pointer], :pointer
  attach_function :clEnqueueMapImage, [CommandQueue,Mem,:cl_bool,:cl_map_flags,:pointer,:pointer,:pointer,:pointer,:cl_uint,:pointer,:pointer,:pointer], :pointer
  attach_function :clEnqueueUnmapMemObject, [CommandQueue,Mem,:pointer,:cl_uint,:pointer,:pointer], :cl_int
  attach_function :clEnqueueNDRangeKernel, [CommandQueue,Kernel,:cl_uint,:pointer,:pointer,:pointer,:cl_uint,:pointer,:pointer], :cl_int
  callback :clEnqueueNativeKernel_notify, [:pointer], :void
  attach_function :clEnqueueNativeKernel, [CommandQueue,:clEnqueueNativeKernel_notify,:pointer,:size_t,:cl_uint,:pointer,:pointer,:cl_uint,:pointer,:pointer], :cl_int
  attach_function :clCreateImage2D, [Context,:cl_mem_flags,:pointer,:size_t,:size_t,:size_t,:pointer,:pointer], Mem
  attach_function :clCreateImage3D, [Context,:cl_mem_flags,:pointer,:size_t,:size_t,:size_t,:size_t,:size_t,:pointer,:pointer], Mem
  attach_function :clEnqueueMarker, [CommandQueue,:pointer], :cl_int
  attach_function :clEnqueueWaitForEvents, [CommandQueue,:cl_uint,:pointer], :cl_int
  attach_function :clEnqueueBarrier, [CommandQueue], :cl_int
  attach_function :clUnloadCompiler, [:void], :cl_int
  attach_function :clGetExtensionFunctionAddress, [:pointer], :pointer
  attach_function :clCreateCommandQueue, [Context,Device,:cl_command_queue_properties,:pointer], CommandQueue
  attach_function :clCreateSampler, [Context,:cl_bool,:cl_addressing_mode,:cl_filter_mode,:pointer], Sampler
  attach_function :clEnqueueTask, [CommandQueue,Kernel,:cl_uint,:pointer,:pointer], :cl_int
  attach_function :clCreateFromGLBuffer, [Context,:cl_mem_flags,:cl_GLuint,:pointer], Mem
  attach_function :clCreateFromGLRenderbuffer, [Context,:cl_mem_flags,:cl_GLuint,:pointer], Mem
  attach_function :clGetGLObjectInfo, [Mem,:pointer,:pointer], :cl_int
  attach_function :clGetGLTextureInfo, [Mem,:cl_gl_texture_info,:size_t,:pointer,:pointer], :cl_int
  attach_function :clEnqueueAcquireGLObjects, [CommandQueue,:cl_uint,:pointer,:cl_uint,:pointer,:pointer], :cl_int
  attach_function :clEnqueueReleaseGLObjects, [CommandQueue,:cl_uint,:pointer,:cl_uint,:pointer,:pointer], :cl_int
  attach_function :clCreateFromGLTexture2D, [Context,:cl_mem_flags,:cl_GLenum,:cl_GLint,:cl_GLuint,:pointer], Mem
  attach_function :clCreateFromGLTexture3D, [Context,:cl_mem_flags,:cl_GLenum,:cl_GLint,:cl_GLuint,:pointer], Mem
  begin # OpenCL 1.1
    attach_function :clCreateSubBuffer, [Mem,:cl_mem_flags,:cl_buffer_create_type,:pointer,:pointer], Mem
    attach_function :clEnqueueReadBufferRect, [CommandQueue,Mem,:cl_bool,:pointer,:pointer,:pointer,:size_t,:size_t,:size_t,:size_t,:pointer,:cl_uint,:pointer,:pointer], :cl_int
    attach_function :clEnqueueWriteBufferRect, [CommandQueue,Mem,:cl_bool,:pointer,:pointer,:pointer,:size_t,:size_t,:size_t,:size_t,:pointer,:cl_uint,:pointer,:pointer], :cl_int
    attach_function :clEnqueueCopyBufferRect, [CommandQueue,Mem,Mem,:pointer,:pointer,:pointer,:size_t,:size_t,:size_t,:size_t,:cl_uint,:pointer,:pointer], :cl_int
    callback :clSetMemObjectDestructorCallback_notify, [:pointer,:pointer], :void
    attach_function :clSetMemObjectDestructorCallback, [Mem,:clSetMemObjectDestructorCallback_notify,:pointer], :cl_int
    attach_function :clCreateUserEvent, [Context,:pointer], Event
    attach_function :clSetUserEventStatus, [Event,:cl_int], :cl_int
    callback :clSetEventCallback_notify, [Event.by_ref,:cl_int,:pointer], :void
    attach_function :clSetEventCallback, [Event,:cl_int,:clSetEventCallback_notify,:pointer], :cl_int
    begin # OpenCL 1.2
      attach_function :clCreateSubDevices, [Device,:pointer,:cl_uint,:pointer,:pointer], :cl_int
      attach_function :clRetainDevice, [Device], :cl_int
      attach_function :clReleaseDevice, [Device], :cl_int
      attach_function :clCreateImage, [Context,:cl_mem_flags,:pointer,:pointer,:pointer,:pointer], Mem
      attach_function :clCreateProgramWithBuiltInKernels, [Context,:cl_uint,:pointer,:pointer,:pointer], Program
      callback :clCompileProgram_notify, [Program.by_ref,:pointer], :void
      attach_function :clCompileProgram, [Program,:cl_uint,:pointer,:pointer,:cl_uint,:pointer,:pointer,:clCompileProgram_notify,:pointer], :cl_int
      callback :clLinkProgram_notify, [Program.by_ref,:pointer], :void
      attach_function :clLinkProgram, [Context,:cl_uint,:pointer,:pointer,:cl_uint,:pointer,:clLinkProgram_notify,:pointer,:pointer], Program
      attach_function :clUnloadPlatformCompiler, [Platform], :cl_int
      attach_function :clGetKernelArgInfo, [Kernel,:cl_uint,:cl_kernel_arg_info,:size_t,:pointer,:pointer], :cl_int
      attach_function :clEnqueueFillBuffer, [CommandQueue,Mem,:pointer,:size_t,:size_t,:size_t,:cl_uint,:pointer,:pointer], :cl_int
      attach_function :clEnqueueFillImage, [CommandQueue,Mem,:pointer,:pointer,:pointer,:cl_uint,:pointer,:pointer], :cl_int
      attach_function :clEnqueueMigrateMemObjects, [CommandQueue,:cl_uint,:pointer,:cl_mem_migration_flags,:cl_uint,:pointer,:pointer], :cl_int
      attach_function :clEnqueueMarkerWithWaitList, [CommandQueue,:cl_uint,:pointer,:pointer], :cl_int
      attach_function :clEnqueueBarrierWithWaitList, [CommandQueue,:cl_uint,:pointer,:pointer], :cl_int
      attach_function :clGetExtensionFunctionAddressForPlatform, [Platform,:pointer], :pointer
      attach_function :clCreateFromGLTexture, [Context,:cl_mem_flags,:cl_GLenum,:cl_GLint,:cl_GLuint,:pointer], Mem
      begin # OpenCL 2.0
        attach_function :clCreateCommandQueueWithProperties, [Context,Device,:pointer,:pointer], CommandQueue
        attach_function :clCreatePipe, [Context,:cl_mem_flags,:cl_uint,:cl_uint,:pointer,:pointer], Mem
        attach_function :clGetPipeInfo, [Mem,:cl_pipe_info,:size_t,:pointer,:pointer], :cl_int
        attach_function :clSVMAlloc, [Context,:cl_svm_mem_flags,:size_t,:cl_uint], :pointer
        attach_function :clSVMFree, [Context,:pointer], :void
        attach_function :clCreateSamplerWithProperties, [Context,:pointer,:pointer], Sampler
        attach_function :clSetKernelArgSVMPointer, [Kernel,:cl_uint,:pointer], :cl_int
        attach_function :clSetKernelExecInfo, [Kernel,:cl_kernel_exec_info,:size_t,:pointer], :cl_int
        callback :clEnqueueSVMFree_notify, [CommandQueue.by_ref,:cl_uint,:pointer,:pointer], :void
        attach_function :clEnqueueSVMFree, [CommandQueue,:cl_uint,:pointer,:clEnqueueSVMFree_notify,:pointer,:cl_uint,:pointer,:pointer], :cl_int
        attach_function :clEnqueueSVMMemcpy, [CommandQueue,:cl_bool,:pointer,:pointer,:size_t,:cl_uint,:pointer,:pointer], :cl_int
        attach_function :clEnqueueSVMMemFill, [CommandQueue,:pointer,:pointer,:size_t,:size_t,:cl_uint,:pointer,:pointer], :cl_int
        attach_function :clEnqueueSVMMap, [CommandQueue,:cl_bool,:cl_map_flags,:pointer,:size_t,:cl_uint,:pointer,:pointer], :cl_int
        attach_function :clEnqueueSVMUnmap, [CommandQueue,:pointer,:cl_uint,:pointer,:pointer], :cl_int
        begin # OpenCL 2.1
          attach_function :clSetDefaultDeviceCommandQueue, [Context,Device,CommandQueue], :cl_int
          attach_function :clGetDeviceAndHostTimer, [Device,:pointer,:pointer], :cl_int
          attach_function :clGetHostTimer, [Device,:pointer], :cl_int
          attach_function :clCreateProgramWithIL, [Context,:pointer,:size_t,:pointer], Program
          attach_function :clCloneKernel, [Kernel,:pointer], Kernel
          attach_function :clGetKernelSubGroupInfo, [Kernel,Device,:cl_kernel_sub_group_info,:size_t,:pointer,:size_t,:pointer,:pointer], :cl_int
          attach_function :clEnqueueSVMMigrateMem, [CommandQueue,:cl_uint,:pointer,:pointer,:cl_mem_migration_flags,:cl_uint,:pointer,:pointer], :cl_int
          begin # OpenCL 2.2
            callback :clSetProgramReleaseCallback_notify, [Program.by_ref,:pointer], :void
            attach_function :clSetProgramReleaseCallback, [Program,:clSetProgramReleaseCallback_notify,:pointer], :cl_int
            attach_function :clSetProgramSpecializationConstant, [Program,:cl_uint,:size_t,:pointer], :cl_int
            begin # OpenCL 3.0
              attach_function :clCreateBufferWithProperties, [Context,:pointer,:cl_mem_flags,:size_t,:pointer,:pointer], Mem
              attach_function :clCreateImageWithProperties, [Context,:pointer,:cl_mem_flags,:pointer,:pointer,:pointer,:pointer], Mem
              callback :clSetContextDestructorCallback_notify, [Context.by_ref,:pointer], :void
              attach_function :clSetContextDestructorCallback, [Context,:clSetContextDestructorCallback_notify,:pointer], :cl_int
            rescue NotFoundError => e
              warn "Warning OpenCL 2.2 loader detected!"
            end
          rescue NotFoundError => e
            warn "Warning OpenCL 2.1 loader detected!"
          end
        rescue NotFoundError => e
          warn "Warning OpenCL 2.0 loader detected!"
        end
      rescue NotFoundError => e
        warn "Warning OpenCL 1.2 loader detected!"
      end
    rescue NotFoundError => e
      warn "Warning OpenCL 1.1 loader detected!"
    end
  rescue NotFoundError => e
      warn "Warning OpenCL 1.0 loader detected!"
  end
end

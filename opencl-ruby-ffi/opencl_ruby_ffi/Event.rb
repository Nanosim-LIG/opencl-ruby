module OpenCL

  def create_user_event(context)
    ptr = FFI::MemoryPointer::new(:cl_int)
    ev = OpenCL.clCreateUserEvent(context, ptr)
    OpenCL.error_check(ptr.read_cl_int)
    return Event::new(ev)
  end

  class Event

    def command_queue
      ptr = FFI::MemoryPointer.new( CommandQueue )
      error = OpenCL.clGetEventInfo(self, Event::COMMAND_QUEUE, CommandQueue.size, ptr, nil)
      OpenCL.error_check(error)
      pt = ptr.read_pointer
      if pt.null? then
        return nil
      else
        return OpenCL::CommandQueue::new( pt )
      end
    end

    def context
      ptr = FFI::MemoryPointer.new( Context )
      error = OpenCL.clGetEventInfo(self, Event::CONTEXT, Context.size, ptr, nil)
      OpenCL.error_check(error)
      return OpenCL::Context::new( ptr.read_pointer )
    end

    eval OpenCL.get_info("Event", :cl_command_type, "COMMAND_TYPE")

    def command_type_name
      type = self.command_type
      %w( NDRANGE_KERNEL TASK NATIVE_KERNEL READ_BUFFER WRITE_BUFFER COPY_BUFFER READ_IMAGE WRITE_IMAGE COPY_IMAGE COPY_BUFFER_TO_IMAGE COPY_IMAGE_TO_BUFFER MAP_BUFFER MAP_IMAGE UNMAP_MEM_OBJECT MARKER ACQUIRE_GL_OBJECTS RELEASE_GL_OBJECTS READ_BUFFER_RECT WRITE_BUFFER_RECT COPY_BUFFER_RECT USER BARRIER MIGRATE_MEM_OBJECTS FILL_BUFFER FILL_IMAGE GL_FENCE_SYNC_OBJECT_KHR ).each { |t_n|
        return t_n if OpenCL::Command.const_get(t_n) == type
      }
    end

    eval OpenCL.get_info("Event", :cl_int, "COMMAND_EXECUTION_STATUS")

    def command_execution_status_name
      status = self.command_execution_status
      if status < 0 then
        return OpenCL::Error.get_name(status)
      else
        %w( QUEUED SUBMITTED RUNNING COMPLETE ).each { |s_n|
          return s_n if OpenCL::const_get(s_n) == status
        }
      end     
    end

    eval OpenCL.get_info("Event", :cl_uint, "REFERENCE_COUNT")

  end
end

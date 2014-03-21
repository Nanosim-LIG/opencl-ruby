module OpenCL

  def self.set_event_callback( event, command_exec_callback_type = OpenCL::COMPLETE, user_data = nil, &proc )
    error = OpenCL.clSetEventCallback( event, command_exec_callback_type, proc, user_data )
    OpenCL.error_check(error)
    return self
  end

  # Creates a user Event
  #
  # ==== Attributes
  #
  # * +context+ - Context the created Event will be associated to
  def self.create_user_event(context)
    OpenCL.error_check(OpenCL::INVALID_OPERATION) if command_queue.context.platform.version_number < 1.1
    error = FFI::MemoryPointer::new(:cl_int)
    event = OpenCL.clCreateUserEvent(context, error)
    OpenCL.error_check(error.read_cl_int)
    return Event::new(event)
  end

  def self.set_user_event_status( event, execution_status = OpenCL::COMPLETE )
    OpenCL.error_check(OpenCL::INVALID_OPERATION) if command_queue.context.platform.version_number < 1.1
    error = OpenCL.clSetUserEventStatus( event, execution_status )
    OpenCL.error_check(error)
    return self
  end

  # Creates an event from a GL sync object
  #
  # ==== Attributes
  #
  # * +context+ - Context the created Event will be associated to
  # * +sync+ - a :GLsync representing the name of the sync object
  def self.create_event_from_GL_sync_KHR( context, sync )
    error = FFI::MemoryPointer::new(:cl_int)
    event = OpenCL.clCreateEventFromGLsyncKHR(context, sync, error)
    OpenCL.error_check(error.read_cl_int)
    return Event::new(event)
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

    eval OpenCL.get_info("Event", :cl_int, "COMMAND_EXECUTION_STATUS")

    def command_execution_status
      ptr = FFI::MemoryPointer.new( :cl_int )
      error = OpenCL.clGetEventInfo(self, OpenCL::Event::COMMAND_EXECUTION_STATUS, ptr.size, ptr, nil )
      OpenCL.error_check(error)
      return OpenCL::CommandExecutionStatus::new( ptr.read_cl_int )
    end

    eval OpenCL.get_info("Event", :cl_uint, "REFERENCE_COUNT")

    def profiling_command_queued
       ptr = FFI::MemoryPointer.new( :cl_ulong )
       error = OpenCL.clGetEventProfilingInfo(self, OpenCL::PROFILING_COMMAND_QUEUED, ptr.size, ptr, nil )
       OpenCL.error_check(error)
       return ptr.read_cl_ulong
    end

    def profiling_command_submit
       ptr = FFI::MemoryPointer.new( :cl_ulong )
       error = OpenCL.clGetEventProfilingInfo(self, OpenCL::PROFILING_COMMAND_SUBMIT, ptr.size, ptr, nil )
       OpenCL.error_check(error)
       return ptr.read_cl_ulong
    end

    def profiling_command_start
       ptr = FFI::MemoryPointer.new( :cl_ulong )
       error = OpenCL.clGetEventProfilingInfo(self, OpenCL::PROFILING_COMMAND_START, ptr.size, ptr, nil )
       OpenCL.error_check(error)
       return ptr.read_cl_ulong
    end

    def profiling_command_end
       ptr = FFI::MemoryPointer.new( :cl_ulong )
       error = OpenCL.clGetEventProfilingInfo(self, OpenCL::PROFILING_COMMAND_END, ptr.size, ptr, nil )
       OpenCL.error_check(error)
       return ptr.read_cl_ulong
    end

    def set_user_event_status( event, execution_status = OpenCL::COMPLETE )
      return OpenCL.set_user_event_status( self, execution_status )
    end

    alias :set_status :set_user_event_status

    def set_event_callback( command_exec_callback_type = OpenCL::COMPLETE, user_data = nil, &proc )
      return OpenCL.set_event_callback( self, command_exec_callback_type, user_data, &proc )
    end

    alias :set_callback :set_event_callback

  end
end

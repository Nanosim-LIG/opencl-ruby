module OpenCL

  # Waits for the command identified by Event objects to complete
  #
  # ==== Attributes
  #
  # * +event_list+ - a single or an Array of Event to wait upon before returning
  def self.wait_for_events(event_list)
    num_events, events = get_event_wait_list( {:event_wait_list => event_list } )
    error = clWaitForEvents(num_events, events)
    error_check(error)
    return nil
  end
  
  # Attaches a callback to event that will be called on the given transition
  #
  # ==== Attributes
  #
  # * +event+ - the Event to attach the callback to
  # * +command_exec_callback_type+ - a CommandExecutionStatus
  # * +options+ - a hash containing named options
  # * +block+ - a callback invoked when the given event occurs. Signature of the callback is { |Event, :cl_int event_command_exec_status, FFI::Pointer to user_data| ... }
  #
  # ==== Options
  #
  # * +:user_data+ - a Pointer (or convertible to Pointer using to_ptr) to the memory area to pass to the callback
  def self.set_event_callback( event, command_exec_callback_type, options = {}, &proc )
    error_check(INVALID_OPERATION) if event.context.platform.version_number < 1.1
    error = clSetEventCallback( event, command_exec_callback_type, proc, options[:user_data] )
    error_check(error)
    return self
  end

  # Creates a user Event
  #
  # ==== Attributes
  #
  # * +context+ - Context the created Event will be associated to
  def self.create_user_event(context)
    error_check(INVALID_OPERATION) if context.platform.version_number < 1.1
    error = FFI::MemoryPointer::new(:cl_int)
    event = clCreateUserEvent(context, error)
    error_check(error.read_cl_int)
    return Event::new(event, false)
  end

  # Sets the satus of user Event to the given execution status
  def self.set_user_event_status( event, execution_status )
    error_check(INVALID_OPERATION) if event.context.platform.version_number < 1.1
    error = clSetUserEventStatus( event, execution_status )
    error_check(error)
    return self
  end

#  # Creates an event from a GL sync object
#  #
#  # ==== Attributes
#  #
#  # * +context+ - Context the created Event will be associated to
#  # * +sync+ - a :GLsync representing the name of the sync object
#  def self.create_event_from_GL_sync_KHR( context, sync )
#    error = FFI::MemoryPointer::new(:cl_int)
#    event = clCreateEventFromGLsyncKHR(context, sync, error)
#    error_check(error.read_cl_int)
#    return Event::new(event, false)
#  end

  # Maps the cl_event object
  class Event
    include InnerInterface

    class << self
      include InnerGenerator
    end

    # Returns the CommandQueue associated with the Event, if it exists
    def command_queue
      ptr = FFI::MemoryPointer::new( CommandQueue )
      error = OpenCL.clGetEventInfo(self, COMMAND_QUEUE, CommandQueue.size, ptr, nil)
      error_check(error)
      pt = ptr.read_pointer
      if pt.null? then
        return nil
      else
        return CommandQueue::new( pt )
      end
    end

    # Returns the Context associated with the Event
    def context
      ptr = FFI::MemoryPointer::new( Context )
      error = OpenCL.clGetEventInfo(self, CONTEXT, Context.size, ptr, nil)
      error_check(error)
      return Context::new( ptr.read_pointer )
    end

    # Returns a CommandType corresponding to the type of the command associated with the Event
    eval get_info("Event", :cl_command_type, "COMMAND_TYPE")

    # Returns a CommandExecutionStatus corresponding to the status of the command associtated with the Event
    def command_execution_status
      ptr = FFI::MemoryPointer::new( :cl_int )
      error = OpenCL.clGetEventInfo(self, COMMAND_EXECUTION_STATUS, ptr.size, ptr, nil )
      error_check(error)
      return CommandExecutionStatus::new( ptr.read_cl_int )
    end

    ##
    # :method: reference_count()
    # Returns the reference counter of th Event
    eval get_info("Event", :cl_uint, "REFERENCE_COUNT")

    # Returns the date the command corresponding to Event was queued
    def profiling_command_queued
       ptr = FFI::MemoryPointer::new( :cl_ulong )
       error = OpenCL.clGetEventProfilingInfo(self, PROFILING_COMMAND_QUEUED, ptr.size, ptr, nil )
       error_check(error)
       return ptr.read_cl_ulong
    end

    # Returns the date the command corresponding to Event was submited
    def profiling_command_submit
       ptr = FFI::MemoryPointer::new( :cl_ulong )
       error = OpenCL.clGetEventProfilingInfo(self, PROFILING_COMMAND_SUBMIT, ptr.size, ptr, nil )
       error_check(error)
       return ptr.read_cl_ulong
    end

    # Returns the date the command corresponding to Event started
    def profiling_command_start
       ptr = FFI::MemoryPointer::new( :cl_ulong )
       error = OpenCL.clGetEventProfilingInfo(self, PROFILING_COMMAND_START, ptr.size, ptr, nil )
       error_check(error)
       return ptr.read_cl_ulong
    end

    # Returns the date the command corresponding to Event ended
    def profiling_command_end
       ptr = FFI::MemoryPointer::new( :cl_ulong )
       error = OpenCL.clGetEventProfilingInfo(self, PROFILING_COMMAND_END, ptr.size, ptr, nil )
       error_check(error)
       return ptr.read_cl_ulong
    end

    # Sets the satus of Event (a user event) to the given execution status
    def set_user_event_status( execution_status )
      return OpenCL.set_user_event_status( self, execution_status )
    end

    alias :set_status :set_user_event_status

    # Attaches a callback to the Event that will be called on the given transition
    #
    # ==== Attributes
    #
    # * +command_exec_callback_type+ - a CommandExecutionStatus
    # * +options+ - a hash containing named options
    # * +block+ - a callback invoked when the given Event occurs. Signature of the callback is { |Event, :cl_int event_command_exec_status, FFI::Pointer to user_data| ... }
    #
    # ==== Options
    #
    # * +:user_data+ - a Pointer (or convertible to Pointer using to_ptr) to the memory area to pass to the callback
    def set_event_callback( command_exec_callback_type, options={}, &proc )
      return OpenCL.set_event_callback( self, command_exec_callback_type, options, &proc )
    end

    alias :set_callback :set_event_callback

  end
end

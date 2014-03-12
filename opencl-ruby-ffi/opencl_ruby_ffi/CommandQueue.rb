module OpenCL

  def OpenCL.finish(command_queue)
    error = OpenCL.clFinish(command_queue)
    OpenCL.error_check(error)
    command_queue
  end

  def OpenCL.create_command_queue(context, device, properties=[])
    ptr1 = FFI::MemoryPointer.new( :cl_int )
    prop = 0
    if properties.kind_of?(Array) then
      properties.each { |p| prop = prop | p }
    else
      prop = properties
    end
    cmd = OpenCL.clCreateCommandQueue( context, device, prop, ptr1 )
    error = ptr1.read_cl_int
    OpenCL.error_check(error)
    return CommandQueue::new(cmd)
  end

  def OpenCL.enqueue_copy_buffer(command_queue, src, dst, options = {})
    blocking = options[:blocking]
    if not blocking then
      blocking = 0
    end
    sz = options[:size]
    if not sz then
      sz = src.size
    end
    src_offset = options[:src_offset]
    if not src_offset then
      src_offset = 0
    end
    dst_offset = options[:dst_offset]
    if not dst_offset then
      dst_offset = 0
    end
    num_events = 0
    events = nil
    if options[:event_wait_list] then
      num_events = options[:event_wait_list].length
      if num_events > 0 then
        events = FFI::MemoryPointer.new( Event, num_events )
        options[:event_wait_list].each_with_index { |e, i|
          events[i].write_pointer(e)
        }
      end
    end
    event = FFI::MemoryPointer.new( Event )
    error = OpenCL.clEnqueueCopyBuffer(command_queue, src, dst, src_offset, dst_offset, sz, num_events, events, event)
    OpenCL.error_check(error)
    return OpenCL::Event::new(event.read_pointer)
  end

  def OpenCL.enqueue_write_buffer(command_queue, buffer, source, options = {})
    blocking = options[:blocking]
    if not blocking then
      blocking = 0
    end
    sz = options[:size]
    if not sz then
      sz = buffer.size
    end
    offset = options[:offset]
    if not offset then
      offset = 0
    end
    num_events = 0
    events = nil
    if options[:event_wait_list] then
      num_events = options[:event_wait_list].length
      if num_events > 0 then
        events = FFI::MemoryPointer.new( Event, num_events )
        options[:event_wait_list].each_with_index { |e, i|
          events[i].write_pointer(e)
        }
      end
    end
    s = source
    if s and s.respond_to?(:to_ptr) then
      s = s.to_ptr
    end
    event = FFI::MemoryPointer.new( Event )
    error = OpenCL.clEnqueueWriteBuffer(command_queue, buffer, blocking, offset, sz, s, num_events, events, event)
    OpenCL.error_check(error)
    return OpenCL::Event::new(event.read_pointer)
  end

  def OpenCL.enqueue_read_buffer(command_queue, buffer, dest, options = {})
    blocking = options[:blocking]
    if not blocking then
      blocking = 0
    end
    sz = options[:size]
    if not sz then
      sz = buffer.size
    end
    offset = options[:offset]
    if not offset then
      offset = 0
    end
    num_events = 0
    events = nil
    if options[:event_wait_list] then
      num_events = options[:event_wait_list].length
      if num_events > 0 then
        events = FFI::MemoryPointer.new( Event, num_events )
        options[:event_wait_list].each_with_index { |e, i|
          events[i].write_pointer(e)
        }
      end
    end
    d = dest
    if d and d.respond_to?(:to_ptr) then
      d = d.to_ptr
    end
    event = FFI::MemoryPointer.new( Event )
    error = OpenCL.clEnqueueReadBuffer(command_queue, buffer, blocking, offset, sz, d, num_events, events, event)
    OpenCL.error_check(error)
    return OpenCL::Event::new(event.read_pointer)
  end

  def OpenCL.enqueue_NDrange_kernel(command_queue, kernel, global_work_size, local_work_size = nil, options={})
    gws = FFI::MemoryPointer.new( :size_t, global_work_size.length )
    global_work_size.each_with_index { |g, i|
      gws[i].write_size_t(g)
    }
    lws = nil
    if local_work_size then
      lws = FFI::MemoryPointer.new( :size_t, global_work_size.length )
      global_work_size.each_index { |i|
        lws[i].write_size_t(local_work_size[i])
      }
    end
    gwo = nil
    if options[:global_work_offset] then
      gwo = FFI::MemoryPointer.new( :size_t, global_work_size.length )
      global_work_size.each_index { |i|
        gwo[i].write_size_t(global_work_offset[i])
      }
    end
    num_events = 0
    events = nil
    if options[:event_wait_list] then
      num_events = options[:event_wait_list].length
      if num_events > 0 then
        events = FFI::MemoryPointer.new( Event, num_events )
        options[:event_wait_list].each_with_index { |e, i|
          events[i].write_pointer(e)
        }
      end
    end
    event = FFI::MemoryPointer.new( Event )
    error = OpenCL.clEnqueueNDRangeKernel(command_queue, kernel, global_work_size.length, gwo, gws, lws, num_events, events, event)
    OpenCL.error_check(error)
    return OpenCL::Event::new(event.read_pointer)
  end

  def OpenCL.enqueue_wait_for_events( command_queue, events = [] )
    return OpenCL.enqueue_barrier( command_queue, events )
  end

  def OpenCL.enqueue_barrier( command_queue, events = [] )
    if command_queue.context.platform.version_number < 1.2 then
      num_events = events.length
      if events.length > 0 then
        evts = nil
        if num_events > 0 then
          evts = FFI::MemoryPointer.new( Event, num_events )
          events.each_with_index { |e, i|
            evts[i].write_pointer(e)
          }
        end
        error = OpenCL.clnqueueWaitForEvents( command_queue, num_events, evts )
      else
        error = OpenCL.clEnqueueBarrier( command_queue )
      end
      OpenCL.error_check(error)
      return nil
    else
      num_events = events.length
      evts = nil
      if num_events > 0 then
        evts = FFI::MemoryPointer.new( Event, num_events )
        events.each_with_index { |e, i|
          evts[i].write_pointer(e)
        }
      end
      event = FFI::MemoryPointer.new( Event )
      error = OpenCL.clEnqueueBarrierWithWaitList( command_queue, num_events, evts, event )
      OpenCL.error_check(error)
      return OpenCL::Event::new(event.read_pointer)
    end
  end

  def OpenCL.enqueue_marker( command_queue, events = [] )
    event = FFI::MemoryPointer.new( Event )
    if command_queue.context.platform.version_number < 1.2 then
      error = OpenCL.clEnqueueMarker( command_queue, event )
    else
      num_events = events.length
      evts = nil
      if num_events > 0 then
        evts = FFI::MemoryPointer.new( Event, num_events )
        events.each_with_index { |e, i|
          evts[i].write_pointer(e)
        }
      end
      error = OpenCL.clEnqueueMarkerWithWaitList( command_queue, num_events, evts, event )
    end
    OpenCL.error_check(error)
    return OpenCL::Event::new(event.read_pointer)
  end

  class CommandQueue

    def context
      ptr = FFI::MemoryPointer.new( Context )
      error = OpenCL.clGetCommandQueueInfo(self, CommandQueue::CONTEXT, Context.size, ptr, nil)
      OpenCL.error_check(error)
      return OpenCL::Context::new( ptr.read_pointer )
    end

    def device
      ptr = FFI::MemoryPointer.new( Device )
      error = OpenCL.clGetCommandQueueInfo(self, CommandQueue::DEVICE, Device.size, ptr, nil)
      OpenCL.error_check(error)
      return OpenCL::Device::new( ptr.read_pointer )
    end

    eval OpenCL.get_info("CommandQueue", :cl_uint, "REFERENCE_COUNT")

    eval OpenCL.get_info("CommandQueue", :cl_command_queue_properties, "PROPERTIES")

    def properties_names
      p = self.properties
      p_names = []
      %w( OUT_OF_ORDER_EXEC_MODE_ENABLE  PROFILING_ENABLE ).each { |d_p|
        p_names.push(d_p) unless ( OpenCL::CommandQueue::const_get(d_p) & p ) == 0
      }
      return p_names
    end

    def enqueue_NDrange_kernel(kernel, global_work_size, local_work_size = nil, options={})
      OpenCL.enqueue_NDrange_kernel(self, kernel, global_work_size, local_work_size, options)
    end

    def enqueue_write_buffer( buffer, source, options = {})
      OpenCL.enqueue_write_buffer(self, buffer, source, options)
    end

    def enqueue_read_buffer( buffer, dst, options = {})
      OpenCL.enqueue_read_buffer(self, buffer, dst, options)
    end

    def enqueue_copy_buffer( src_buffer, dst_buffer, options = {})
      OpenCL.enqueue_copy_buffer( self, src_buffer, dst_buffer, options )
    end

    def enqueue_barrier( events = [] )
      OpenCL.enqueue_barrier( self, events )
    end

    def enqueue_marker( events = [] )
      OpenCL.enqueue_marker( self, events )
    end

    def enqueue_wait_for_events( events = [] )
      OpenCL.enqueue_wait_for_events( self, events )
    end

    def finish
      OpenCL.finish(self)
    end
  end

end

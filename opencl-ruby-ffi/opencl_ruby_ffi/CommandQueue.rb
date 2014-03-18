module OpenCL

  def self.finish( command_queue )
    error = OpenCL.clFinish( command_queue )
    OpenCL.error_check( error )
    command_queue
  end

  # Creates a CommandQueue targeting the specified Device
  #
  # ==== Attributes
  #
  # * +context+ - the Context the CommandQueue will be associated with
  # * +device+ - the Device targetted by the CommandQueue being created
  # * +properties+ - a single or an Array of :cl_command_queue_properties
  def self.create_command_queue( context, device, properties=[] )
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

  def self.enqueue_migrate_mem_objects( command_queue, mem_objects, options = {} )
    OpenCL.error_check(OpenCL::INVALID_OPERATION) if command_queue.context.platform.version_number < 1.2
    num_mem_objects = 0
    mem_list = nil
    if mem_objects then
      num_mem_objects = [mem_objects].flatten.length
      if num_mem_objects > 0 then
        mem_list = FFI::MemoryPointer.new( OpenCL::Mem, num_mem_objects )
        [mem_objects].flatten.each_with_index { |e, i|
          mem_list[i].write_pointer(e)
        }
      end
    end
    fs = 0
    if options[:flags] then
      if options[:flags].kind_of?(Array) then
        options[:flags].each { |f| fs = fs | f }
      else
        fs = options[:flags]
      end
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
    error = OpenCL.clEnqueueMigrateMemObjects( command_queue, num_mem_objects, mem_list, fs, num_events, events, event )
    OpenCL.error_check( error )
    return OpenCL::Event::new( event.read_ptr )
  end

  def self.enqueue_map_image( command_queue, image, map_flags, options = {} )
    if options[:blocking] then
      blocking = OpenCL::TRUE
    else
      blocking = OpenCL::FALSE
    end
    origin = FFI::MemoryPointer.new( :size_t, 3 )
    (0..2).each { |i| origin[i].write_size_t(0) }
    if options[:origin] then
      options[:origin].each_with_index { |e, i|
        origin[i].write_size_t(e)
      }
    end
    region = FFI::MemoryPointer.new( :size_t, 3 )
    (0..2).each { |i| region[i].write_size_t(1) }
    if options[:region] then
      options[:region].each_with_index { |e, i|
        region[i].write_size_t(e)
      }
    else
       region[0].write_size_t( image.width )
       if image.type == OpenCL::Mem::IMAGE1D_ARRAY then
         region[1].write_size_t( image.array_size )
       else
         region[1].write_size_t( image.height ? image.height : 1 )
       end
       if image.type == OpenCL::Mem::IMAGE2D_ARRAY then
         region[2].write_size_t( image.array_size )
       else 
         region[2].write_size_t( image.depth ? image.depth : 1 )
       end
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
    image_row_pitch = FFI::MemoryPointer.new( :size_t )
    image_slice_pitch = FFI::MemoryPointer.new( :size_t )
    event = FFI::MemoryPointer.new( Event )
    error = FFI::MemoryPointer.new( :cl_int )
    OpenCL.clEnqueueMapImage( command_queue, image, blocking, map_flags, origin, region, image_row_pitch, image_slice_pitch, num_events, events, event, error )
    OpenCL.error_check( error.read_cl_int )
    ev = OpenCL::Event::new( event.read_ptr )
    return [ev, ptr, image_row_pitch.read_size_t, image_slice_pitch.read_size_t]
  end

  def self.enqueue_map_buffer( command_queue, buffer, map_flags, options = {} )
    if options[:blocking] then
      blocking = OpenCL::TRUE
    else
      blocking = OpenCL::FALSE
    end
    offset = options[:offset]
    if not offset then
      offset = 0
    end
    size = options[:size]
    if not size then
      size = buffer.size
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
    error = FFI::MemoryPointer.new( :cl_int )
    ptr = OpenCL.clEnqueueMapBuffer( command_queue, buffer, blocking, map_flags, offset, size, num_events, events, error )
    OpenCL.error_check( error.read_cl_int )
    ev = OpenCL::Event::new( event.read_ptr )
    return [ev, ptr]
  end

  def self.enqueue_unmap_mem_object( command_queue, mem_obj, mapped_ptr, options = {} )
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
    error = OpenCL.clEnqueueUnmapMemObject( command_queue, mem_obj, mapped_ptr, num_events, events, event )
    OpenCL.error_check( error )
    return OpenCL::Event::new( event.read_ptr )
  end

  def self.enqueue_read_buffer_rect( command_queue, buffer, dst, region, options = {} )
    OpenCL.error_check(OpenCL::INVALID_OPERATION) if command_queue.context.platform.version_number < 1.1
    if options[:blocking] then
      blocking = OpenCL::TRUE
    else
      blocking = OpenCL::FALSE
    end
    buffer_origin = FFI::MemoryPointer.new( :size_t, 3 )
    bo = options[:src_origin] ? options[:src_origin] : options[:buffer_origin]
    if bo then
      bo.each_with_index { |e, i|
        buffer_origin[i].write_size_t(e)
      }
    end
    host_origin = FFI::MemoryPointer.new( :size_t, 3 )
    ho = options[:dst_origin] ? options[:dst_origin] : options[:host_origin]
    if ho then
      ho.each_with_index { |e, i|
        host_origin[i].write_size_t(e)
      }
    end
    r = FFI::MemoryPointer.new( :size_t, 3 )
    (0..2).each { |i| r[i].write_size_t(0) }
    region[0..3].each_with_index { |e, i|
      r[i].write_size_t(e)
    }
    buffer_row_pitch = options[:src_row_pitch] ? options[:src_row_pitch] : options[:buffer_row_pitch]
    if not buffer_row_pitch then
      buffer_row_pitch = 0
    end
    buffer_slice_pitch = options[:src_slice_pitch] ? options[:src_slice_pitch] : options[:buffer_slice_pitch]
    if not buffer_slice_pitch then
      buffer_slice_pitch = 0
    end  
    host_row_pitch = options[:dst_row_pitch] ? options[:dst_row_pitch] : options[:host_row_pitch]
    if not host_row_pitch then
      host_row_pitch = 0
    end
    host_slice_pitch = options[:dst_slice_pitch] ? options[:dst_slice_pitch] : options[:host_slice_pitch]
    if not host_slice_pitch then
      host_slice_pitch = 0
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
    d = dst
    if d and d.respond_to?(:to_ptr) then
      d = d.to_ptr
    end
    event = FFI::MemoryPointer.new( Event )
    error = OpenCL.clEnqueueReadBufferRect(command_queue, buffer, blocking, buffer_origin, host_origin, r, buffer_row_pitch, buffer_slice_pitch, host_row_pitch, host_slice_pitch, d, num_events, events, event)
    OpenCL.error_check(error)
    return OpenCL::Event::new(event.read_pointer)
  end

  def self.enqueue_write_buffer_rect(command_queue, buffer, src, region, options = {})
    OpenCL.error_check(OpenCL::INVALID_OPERATION) if command_queue.context.platform.version_number < 1.1
    if options[:blocking] then
      blocking = OpenCL::TRUE
    else
      blocking = OpenCL::FALSE
    end
    buffer_origin = FFI::MemoryPointer.new( :size_t, 3 )
    bo = options[:dst_origin] ? options[:dst_origin] : options[:buffer_origin]
    if bo then
      bo.each_with_index { |e, i|
        buffer_origin[i].write_size_t(e)
      }
    end
    host_origin = FFI::MemoryPointer.new( :size_t, 3 )
    ho = options[:src_origin] ? options[:src_origin] : options[:host_origin]
    if ho then
      ho.each_with_index { |e, i|
        host_origin[i].write_size_t(e)
      }
    end
    r = FFI::MemoryPointer.new( :size_t, 3 )
    (0..2).each { |i| r[i].write_size_t(0) }
    region[0..3].each_with_index { |e, i|
      r[i].write_size_t(e)
    }
    buffer_row_pitch = options[:dst_row_pitch] ? options[:dst_row_pitch] : options[:buffer_row_pitch]
    if not buffer_row_pitch then
      buffer_row_pitch = 0
    end
    buffer_slice_pitch = options[:dst_slice_pitch] ? options[:dst_slice_pitch] : options[:buffer_slice_pitch]
    if not buffer_slice_pitch then
      buffer_slice_pitch = 0
    end  
    host_row_pitch = options[:src_row_pitch] ? options[:src_row_pitch] : options[:host_row_pitch]
    if not host_row_pitch then
      host_row_pitch = 0
    end
    host_slice_pitch = options[:src_slice_pitch] ? options[:src_slice_pitch] : options[:host_slice_pitch]
    if not host_slice_pitch then
      host_slice_pitch = 0
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
    s = src
    if s and s.respond_to?(:to_ptr) then
      s = s.to_ptr
    end
    event = FFI::MemoryPointer.new( Event )
    error = OpenCL.clEnqueueWriteBufferRect(command_queue, buffer, blocking, buffer_origin, host_origin, r, buffer_row_pitch, buffer_slice_pitch, host_row_pitch, host_slice_pitch, s, num_events, events, event)
    OpenCL.error_check(error)
    return OpenCL::Event::new(event.read_pointer)
  end

  def self.enqueue_copy_buffer_rect(command_queue, src_buffer, dst_buffer, region, options = {})
    OpenCL.error_check(OpenCL::INVALID_OPERATION) if command_queue.context.platform.version_number < 1.1
    src_origin = FFI::MemoryPointer.new( :size_t, 3 )
    (0..2).each { |i| src_origin[i].write_size_t(0) }
    if options[:src_origin] then
      options[:src_origin].each_with_index { |e, i|
        src_origin[i].write_size_t(e)
      }
    end
    dst_origin = FFI::MemoryPointer.new( :size_t, 3 )
    (0..2).each { |i| dst_origin[i].write_size_t(0) }
    if options[:dst_origin] then
      options[:dst_origin].each_with_index { |e, i|
        dst_origin[i].write_size_t(e)
      }
    end
    r = FFI::MemoryPointer.new( :size_t, 3 )
    (0..2).each { |i| r[i].write_size_t(0) }
    region[0..3].each_with_index { |e, i|
      r[i].write_size_t(e)
    }
    src_row_pitch = options[:src_row_pitch]
    if not src_row_pitch then
      src_row_pitch = 0
    end
    src_slice_pitch = options[:src_slice_pitch]
    if not src_slice_pitch then
      src_slice_pitch = 0
    end
    dst_row_pitch = options[:dst_row_pitch]
    if not dst_row_pitch then
      dst_row_pitch = 0
    end
    dst_slice_pitch = options[:dst_slice_pitch]
    if not dst_slice_pitch then
      dst_slice_pitch = 0
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
    error = OpenCL.clEnqueueCopyBufferRect(command_queue, src_buffer, dst_buffer, src_origin, dst_origin, r, src_row_pitch, src_slice_pitch, dst_row_pitch, dst_slice_pitch, num_events, events, event)
    OpenCL.error_check(error)
    return OpenCL::Event::new(event.read_pointer)
  end

  def self.enqueue_copy_buffer(command_queue, src_buffer, dst_buffer, options = {})
    if options[:blocking] then
      blocking = OpenCL::TRUE
    else
      blocking = OpenCL::FALSE
    end
    size = options[:size]
    if not size then
      size = [ src_buffer.size, dst_buffer.size ].min
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
    error = OpenCL.clEnqueueCopyBuffer(command_queue, src_buffer, dst_buffer, src_offset, dst_offset, size, num_events, events, event)
    OpenCL.error_check(error)
    return OpenCL::Event::new(event.read_pointer)
  end

  def self.enqueue_write_buffer( command_queue, buffer, src, options = {} )
    if options[:blocking] then
      blocking = OpenCL::TRUE
    else
      blocking = OpenCL::FALSE
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
    s = src
    if s and s.respond_to?(:to_ptr) then
      s = s.to_ptr
    end
    event = FFI::MemoryPointer.new( Event )
    error = OpenCL.clEnqueueWriteBuffer(command_queue, buffer, blocking, offset, sz, s, num_events, events, event)
    OpenCL.error_check(error)
    return OpenCL::Event::new(event.read_pointer)
  end

  def self.enqueue_acquire_GL_object( command_queue, mem_objects, options = {} )
    num_objs = [mem_objects].flatten.length
    objs = nil
    if num_objs > 0 then
      objs = FFI::MemoryPointer.new(  Mem, num_objs )
      [mem_objects].flatten.each_with_index { |o, i|
        objs[i].write_pointer(e)
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
    error = OpenCL.clEnqueueAcquireGLObject( command_queue, num_objs, objs, num_events, events, event )
    OpenCL.error_check(error)
    return OpenCL::Event::new(event.read_pointer)
  end

  def self.enqueue_release_GL_object( command_queue, mem_objects, options = {} )
    num_objs = [mem_objects].flatten.length
    objs = nil
    if num_objs > 0 then
      objs = FFI::MemoryPointer.new(  Mem, num_objs )
      [mem_objects].flatten.each_with_index { |o, i|
        objs[i].write_pointer(e)
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
    error = OpenCL.clEnqueueReleaseGLObject( command_queue, num_objs, objs, num_events, events, event )
    OpenCL.error_check(error)
    return OpenCL::Event::new(event.read_pointer)
  end

  def self.enqueue_fill_buffer( command_queue, buffer, pattern, options = {} )
    OpenCL.error_check(OpenCL::INVALID_OPERATION) if command_queue.context.platform.version_number < 1.1
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
    offset = options[:offset]
    if not offset then
      offset = 0
    end
    size = options[:size]
    if not size then
      size = buffer.size
    end
    pattern_size = options[:pattern_size]
    if not pattern_size then
      pattern_size = pattern.size
    end
    p = pattern
    if p and p.respond_to?(:to_ptr) then
      p = p.to_ptr
    end
    event = FFI::MemoryPointer.new( Event )
    error = OpenCL.clEnqueueFillBuffer( command_queue, buffer, p, pattern_size, offset, size, num_events, events, event )
    OpenCL.error_check(error)
    return OpenCL::Event::new(event.read_pointer)
  end

  def self.enqueue_fill_image( command_queue, image, fill_color, options = {} )
    OpenCL.error_check(OpenCL::INVALID_OPERATION) if command_queue.context.platform.version_number < 1.1
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
    origin = FFI::MemoryPointer.new( :size_t, 3 )
    (0..2).each { |i| origin[i].write_size_t(0) }
    if options[:origin] then
      options[:origin].each_with_index { |e, i|
        origin[i].write_size_t(e)
      }
    end
    region = FFI::MemoryPointer.new( :size_t, 3 )
    (0..2).each { |i| region[i].write_size_t(1) }
    if options[:region] then
      options[:region].each_with_index { |e, i|
        region[i].write_size_t(e)
      }
    else
       region[0].write_size_t( image.width )
       if image.type == OpenCL::Mem::IMAGE1D_ARRAY then
         region[1].write_size_t( image.array_size )
       else
         region[1].write_size_t( image.height ? image.height : 1 )
       end
       if image.type == OpenCL::Mem::IMAGE2D_ARRAY then
         region[2].write_size_t( image.array_size )
       else 
         region[2].write_size_t( image.depth ? image.depth : 1 )
       end
    end
    c = color
    if c and c.respond_to?(:to_ptr) then
      c = c.to_ptr
    end
    event = FFI::MemoryPointer.new( Event )
    error = OpenCL.clEnqueueFillImage( command_queue, image, c, origin, region, num_events, events, event )
    OpenCL.error_check(error)
    return OpenCL::Event::new(event.read_pointer)
  end

  def self.enqueue_copy_image_to_buffer( command_queue, src_image, dst_buffer, options = {} )
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
    src_origin = FFI::MemoryPointer.new( :size_t, 3 )
    (0..2).each { |i| src_origin[i].write_size_t(0) }
    if options[:src_origin] then
      options[:src_origin].each_with_index { |e, i|
        src_origin[i].write_size_t(e)
      }
    end
    region = FFI::MemoryPointer.new( :size_t, 3 )
    (0..2).each { |i| region[i].write_size_t(1) }
    if options[:region] then
      options[:region].each_with_index { |e, i|
        region[i].write_size_t(e)
      }
    else
       region[0].write_size_t( src_image.width )
       if src_image.type == OpenCL::Mem::IMAGE1D_ARRAY then
         region[1].write_size_t( src_image.array_size )
       else
         region[1].write_size_t( src_image.height ? src_image.height : 1 )
       end
       if image.type == OpenCL::Mem::IMAGE2D_ARRAY then
         region[2].write_size_t( src_image.array_size )
       else
         region[2].write_size_t( src_image.depth ? src_image.depth : 1 )
       end
    end
    dst_offset = options[:dst_offset]
    if not dst_offset then
      dst_offset = 0
    end
    event = FFI::MemoryPointer.new( Event )
    error = OpenCL.clEnqueueCopyImageToBuffer( command_queue, src_image, dst_buffer, src_origin, region, dst_offset, num_events, events, event )
    OpenCL.error_check(error)
    return OpenCL::Event::new(event.read_pointer)
  end

  def self.enqueue_copy_buffer_to_image(command_queue, src_buffer, dst_image, options = {})
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
    dst_origin = FFI::MemoryPointer.new( :size_t, 3 )
    (0..2).each { |i| dst_origin[i].write_size_t(0) }
    if options[:dst_origin] then
      options[:dst_origin].each_with_index { |e, i|
        dst_origin[i].write_size_t(e)
      }
    end
    region = FFI::MemoryPointer.new( :size_t, 3 )
    (0..2).each { |i| region[i].write_size_t(1) }
    if options[:region] then
      options[:region].each_with_index { |e, i|
        region[i].write_size_t(e)
      }
    else
       region[0].write_size_t( dst_image.width )
       if dst_image.type == OpenCL::Mem::IMAGE1D_ARRAY then
         region[1].write_size_t( dst_image.array_size )
       else
         region[1].write_size_t( dst_image.height ? dst_image.height : 1 )
       end
       if image.type == OpenCL::Mem::IMAGE2D_ARRAY then
         region[2].write_size_t( dst_image.array_size )
       else
         region[2].write_size_t( dst_image.depth ? dst_image.depth : 1 )
       end
    end
    src_offset = options[:src_offset]
    if not src_offset then
      src_offset = 0
    end
    event = FFI::MemoryPointer.new( Event )
    error = OpenCL.clEnqueueCopyBufferToImage( command_queue, src_buffer, dst_image, src_offset, dst_origin, region, num_events, events, event )
    OpenCL.error_check(error)
    return OpenCL::Event::new(event.read_pointer)
  end

  def self.enqueue_write_image(command_queue, image, src, options = {})
    if options[:blocking] then
      blocking = OpenCL::TRUE
    else
      blocking = OpenCL::FALSE
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
    origin = FFI::MemoryPointer.new( :size_t, 3 )
    (0..2).each { |i| origin[i].write_size_t(0) }
    if options[:origin] then
      options[:origin].each_with_index { |e, i|
        origin[i].write_size_t(e)
      }
    end
    region = FFI::MemoryPointer.new( :size_t, 3 )
    (0..2).each { |i| region[i].write_size_t(1) }
    if options[:region] then
      options[:region].each_with_index { |e, i|
        region[i].write_size_t(e)
      }
    else
       region[0].write_size_t( image.width )
       if image.type == OpenCL::Mem::IMAGE1D_ARRAY then
         region[1].write_size_t( image.array_size )
       else
         region[1].write_size_t( image.height ? image.height : 1 )
       end
       if image.type == OpenCL::Mem::IMAGE2D_ARRAY then
         region[2].write_size_t( image.array_size )
       else 
         region[2].write_size_t( image.depth ? image.depth : 1 )
       end
    end
    input_row_pitch = 0
    if options[:input_row_pitch] then
      input_row_pitch = options[:input_row_pitch]
    end
    input_slice_pitch = 0
    if options[:input_slice_pitch] then
      input_slice_pitch = options[:input_slice_pitch]
    end
    s = src
    if s and s.respond_to?(:to_ptr) then
      s = s.to_ptr
    end
    event = FFI::MemoryPointer.new( Event )
    error = OpenCL.clEnqueueWriteImage( command_queue, image, blocking, origin, region, input_row_pitch, input_slice_pitch, s, num_events, events, event )
    OpenCL.error_check(error)
    return OpenCL::Event::new(event.read_pointer)
  end

  def self.enqueue_copy_image( command_queue, src_image, dst_image, options = {} )
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
    src_origin FFI::MemoryPointer.new( :size_t, 3 )
    (0..2).each { |i| src_origin[i].write_size_t(0) }
    if options[:src_origin] then
      options[:src_origin].each_with_index { |e, i|
        src_origin[i].write_size_t(e)
      }
    end
    dst_origin FFI::MemoryPointer.new( :size_t, 3 )
    (0..2).each { |i| dst_origin[i].write_size_t(0) }
    if options[:dst_origin] then
      options[:dst_origin].each_with_index { |e, i|
        dst_origin[i].write_size_t(e)
      }
    end
    region = FFI::MemoryPointer.new( :size_t, 3 )
    (0..2).each { |i| region[i].write_size_t(1) }
    if options[:region] then
      options[:region].each_with_index { |e, i|
        region[i].write_size_t(e)
      }
    else
       region[0].write_size_t( [src_image.width, dst_image.width].min )
       if src_image.type == OpenCL::Mem::IMAGE1D_ARRAY and ( dst_image.type == OpenCL::Mem::IMAGE1D_ARRAY or dst_image.type == OpenCL::Mem::IMAGE2D ) then
         region[1].write_size_t( [src_image.array_size, dst_image.type == OpenCL::Mem::IMAGE1D_ARRAY ? dst_image.array_size : dst_image.height].min )
       elsif src_image.type == OpenCL::Mem::IMAGE1D or dst_image.type == OpenCL::Mem::IMAGE1D then
         region[1].write_size_t( 1 )
       else
         region[1].write_size_t( [src_image.height, dst_image.height].min )
       end
       if src_image.type == OpenCL::Mem::IMAGE2D_ARRAY and ( dst_image.type == OpenCL::Mem::IMAGE2D_ARRAY or dst_image.type == OpenCL::Mem::IMAGE3D ) then
         region[2].write_size_t( [src_image.array_size, dst_image.type == OpenCL::Mem::IMAGE2D_ARRAY ? dst_image.array_size : dst_image.depth].min )
       elsif src_image.type == OpenCL::Mem::IMAGE2D or dst_image.type == OpenCL::Mem::IMAGE2D then
         region[2].write_size_t( 1 )
       else 
         region[2].write_size_t( [src_image.depth, dst_image.depth].min )
       end
    end
    event = FFI::MemoryPointer.new( Event )
    error = OpenCL.clEnqueueCopyImage( command_queue, src_image, dst_image, src_origin, dst_origin, region, num_events, events, event )
    OpenCL.error_check(error)
    return OpenCL::Event::new(event.read_pointer)
  end

  def self.enqueue_read_image( command_queue, image, dest, options = {} )
    if options[:blocking] then
      blocking = OpenCL::TRUE
    else
      blocking = OpenCL::FALSE
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
    origin = FFI::MemoryPointer.new( :size_t, 3 )
    (0..2).each { |i| origin[i].write_size_t(0) }
    if options[:origin] then
      options[:origin].each_with_index { |e, i|
        origin[i].write_size_t(e)
      }
    end
    region = FFI::MemoryPointer.new( :size_t, 3 )
    (0..2).each { |i| region[i].write_size_t(1) }
    if options[:region] then
      options[:region].each_with_index { |e, i|
        region[i].write_size_t(e)
      }
    else
       region[0].write_size_t( image.width )
       if image.type == OpenCL::Mem::IMAGE1D_ARRAY then
         region[1].write_size_t( image.array_size )
       else
         region[1].write_size_t( image.height ? image.height : 1 )
       end
       if image.type == OpenCL::Mem::IMAGE2D_ARRAY then
         region[2].write_size_t( image.array_size )
       else 
         region[2].write_size_t( image.depth ? image.depth : 1 )
       end
    end
    row_pitch = 0
    if options[:row_pitch] then
      row_pitch = options[:row_pitch]
    end
    slice_pitch = 0
    if options[:slice_pitch] then
      slice_pitch = options[:slice_pitch]
    end
    d = dest
    if d and d.respond_to?(:to_ptr) then
      d = d.to_ptr
    end
    event = FFI::MemoryPointer.new( Event )
    error = OpenCL.clEnqueueReadImage( command_queue, image, blocking, origin, region, row_pitch, slice_pitch, d, num_events, events, event )
    OpenCL.error_check(error)
    return OpenCL::Event::new(event.read_pointer)
  end

  def self.enqueue_read_buffer( command_queue, buffer, dest, options = {} )
    if options[:blocking] then
      blocking = OpenCL::TRUE
    else
      blocking = OpenCL::FALSE
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

  def self.enqueue_native_kernel( command_queue, options = {}, &func )
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
#    num_mem_objects = 0
#    mem_list = nil
#    if options[:mem_list] then
#      num_mem_objects = options[:mem_list].length
#      if num_mem_objects > 0 then
#        mem_list = FFI::MemoryPointer.new( OpenCL::Mem, num_mem_objects )
#        options[:mem_list].each_with_index { |e, i|
#          mem_list[i].write_pointer(e)
#        }
#      end
#    end
    event = FFI::MemoryPointer.new( Event )
    error = OpenCL.clEnqueueNativeKernel( command_queue, func, nil, 0, 0, nil, nil, num_events, events, event )
    OpenCL.error_check(error)
    return OpenCL::Event::new(event.read_pointer)
  end

  def self.enqueue_task( command_queue, kernel, options = {} )
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
    error = OpenCL.clEnqueueTask( command_queue, kernel, num_events, events, event )
    OpenCL.error_check(error)
    return OpenCL::Event::new(event.read_pointer)
  end

  def self.enqueue_NDrange_kernel( command_queue, kernel, global_work_size, local_work_size = nil, options={} )
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

  def self.enqueue_wait_for_events( command_queue, events = [] )
    return OpenCL.enqueue_barrier( command_queue, events )
  end

  def self.enqueue_barrier( command_queue, events = [] )
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

  def self.enqueue_marker( command_queue, events = [] )
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

    def enqueue_native_kernel( options = {}, &func )
      return OpenCL.enqueue_native_kernel( self, options, &func )
    end

    def enqueue_task( kernel, options = {} )
      return OpenCL.enqueue_task( self, kernel, options )
    end

    def enqueue_NDrange_kernel( kernel, global_work_size, local_work_size = nil, options = {} )
      return OpenCL.enqueue_NDrange_kernel( self, kernel, global_work_size, local_work_size, options )
    end

    def enqueue_write_buffer( buffer, src, options = {} )
      return OpenCL.enqueue_write_buffer( self, buffer, src, options )
    end

    def enqueue_write_buffer_rect( buffer, src, region, options = {} )
      return OpenCL.enqueue_write_buffer_rect( self, buffer, src, region, options )
    end

    def enqueue_read_buffer( buffer, dst, options = {} )
      return OpenCL.enqueue_read_buffer( self, buffer, dst, options)
    end

    def enqueue_read_buffer_rect( buffer, dst, region, options = {} )
      return OpenCL.enqueue_read_buffer_rect( self, buffer, dst, region, options )
    end

    def enqueue_copy_buffer( src_buffer, dst_buffer, options = {} )
      return OpenCL.enqueue_copy_buffer( self, src_buffer, dst_buffer, options )
    end

    def enqueue_copy_buffer_rect( src_buffer, dst_buffer, region, options = {} )
      return OpenCL.enqueue_copy_buffer_rect( self, src_buffer, dst_buffer, region, options )
    end

    def enqueue_barrier( events = [] )
      return OpenCL.enqueue_barrier( self, events )
    end

    def enqueue_marker( events = [] )
      return OpenCL.enqueue_marker( self, events )
    end

    def enqueue_wait_for_events( events = [] )
      return OpenCL.enqueue_wait_for_events( self, events )
    end

    def enqueue_write_image( image, src, options = {} )
      return OpenCL.enqueue_write_image( self, image, src, options )
    end

    def enqueue_read_image( image, dest, options = {} )
      return OpenCL.enqueue_read_image( self, image, dest, options )
    end

    def enqueue_copy_image( src_image, dst_image, options = {} )
      return OpenCL.enqueue_copy_image( self, src_image, dst_image, options )
    end

    def enqueue_copy_buffer_to_image( src_buffer, dst_image, options = {} )
      return OpenCL.enqueue_copy_buffer_to_image( self, src_buffer, dst_image, options )
    end

    def enqueue_copy_image_to_buffer( src_image, dst_buffer, options = {} )
      return OpenCL.enqueue_copy_buffer_to_image( self, src_image, dst_buffer, options )
    end

    def enqueue_fill_image( image, fill_color, options = {} )
      return OpenCL.enqueue_fill_image( self, image, fill_color, options )
    end

    def enqueue_fill_buffer( buffer, pattern, options = {} )
      return OpenCL.enqueue_fill_image( self, image, fill_color, options )
    end

    def enqueue_acquire_GL_object( mem_objects, options = {} )
      return OpenCL.enqueue_acquire_GL_object( self, mem_objects, options )
    end

    def enqueue_release_GL_object( mem_objects, options = {} )
      return OpenCL.enqueue_release_GL_object( self, mem_objects, options )
    end

    def enqueue_map_buffer( buffer, flags, options = {} )
      return OpenCL.enqueue_map_buffer( self, buffer, flags, options )
    end

    def enqueue_map_image( image, map_flags, options = {} )
      return OpenCL.enqueue_map_image( self, image, map_flags, options )
    end

    def enqueue_migrate_mem_objects( mem_objects, options = {} )
      return OpenCL.enqueue_migrate_mem_objects( self, mem_objects, options )
    end

    def finish
      return OpenCL.finish(self)
    end

  end

end

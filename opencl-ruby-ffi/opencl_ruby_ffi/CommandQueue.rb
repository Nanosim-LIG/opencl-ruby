module OpenCL

  # Blocks until all the commands in the queue have completed
  #
  # ==== Attributes
  #
  # * +command_queue+ - the CommandQueue to finish
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
  # * +options+ - a hash containing named options
  #
  # ==== Options
  # 
  # * +:properties+ - a single or an Array of :cl_command_queue_properties
  def self.create_command_queue( context, device, options = {} )
    properties = OpenCL.get_command_queue_properties( options )
    error = FFI::MemoryPointer.new( :cl_int )
    cmd = OpenCL.clCreateCommandQueue( context, device, properties, error )
    OpenCL.error_check(error.read_cl_int)
    return CommandQueue::new(cmd)
  end

  # Enqueues a command to indicate which device a set of memory objects should be migrated to
  #
  # ==== Attributes
  # 
  # * +command_queue+ - objects will be migrated to the device associated with this CommandQueue
  # * +mem_objects+ - the Mem objects to migrate
  # * +options+ - a hash containing named options
  #
  # ==== Options
  #
  # * +:flags+ - a single or an Array of :cl_mem_migration flags
  # * +:event_wait_list+ - if provided, a list of Event to wait upon before executing the command
  #
  # ==== Returns
  #
  # the Event associated with the command
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
    flags = OpenCL.get_flags( options )
    num_events, events = OpenCL.get_event_wait_list( options )
    event = FFI::MemoryPointer.new( Event )
    error = OpenCL.clEnqueueMigrateMemObjects( command_queue, num_mem_objects, mem_list, flags, num_events, events, event )
    OpenCL.error_check( error )
    return OpenCL::Event::new( event.read_ptr )
  end

  # Enqueues a command to map an Image into host memory
  #
  # ==== Attributes
  # 
  # * +command_queue+ - CommandQueue used to execute the map command
  # * +image+ - the Image object to map
  # * +map_flags+ - a single or an Array of :cl_map_flags flags
  # * +options+ - a hash containing named options
  #
  # ==== Options
  #
  # * +:event_wait_list+ - if provided, a list of Event to wait upon before executing the command
  # * +:blocking_map+ - if provided indicates if the command blocks until the region is mapped
  # * +:blocking+ - if provided indicates if the command blocks until the region is mapped
  # * +:origin+ - if provided the origin in the Image of the region to map, else [0, 0, 0]
  # * +:region+ - if provided the region in the image to map, else the largest possible area is used
  #
  # ==== Returns
  #
  # an Array composed of [event, pointer, image_row_pitch, image_slice_pitch] where:
  # * +event+ - the Event associated with the command
  # * +pointer+ - a Pointer to the mapped memory region
  # * +image_row_pitch+ - the row pitch of the mapped region
  # * +image_slice_pitch+ - the slice pitch of the mapped region
  def self.enqueue_map_image( command_queue, image, map_flags, options = {} )
    blocking = OpenCL::FALSE
    blocking = OpenCL::TRUE if options[:blocking] or options[:blocking_map]

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
       region[0].write_size_t( image.width - origin[0] )
       if image.type == OpenCL::Mem::IMAGE1D_ARRAY then
         region[1].write_size_t( image.array_size - origin[1] )
       else
         region[1].write_size_t( ( image.height ? image.height : 1 ) - origin[1] )
       end
       if image.type == OpenCL::Mem::IMAGE2D_ARRAY then
         region[2].write_size_t( image.array_size origin[2] )
       else 
         region[2].write_size_t( ( image.depth ? image.depth : 1 ) - origin[2] )
       end
    end

    num_events, events = OpenCL.get_event_wait_list( options )
    image_row_pitch = FFI::MemoryPointer.new( :size_t )
    image_slice_pitch = FFI::MemoryPointer.new( :size_t )
    event = FFI::MemoryPointer.new( Event )
    error = FFI::MemoryPointer.new( :cl_int )
    OpenCL.clEnqueueMapImage( command_queue, image, blocking, map_flags, origin, region, image_row_pitch, image_slice_pitch, num_events, events, event, error )
    OpenCL.error_check( error.read_cl_int )
    ev = OpenCL::Event::new( event.read_ptr )
    return [ev, ptr, image_row_pitch.read_size_t, image_slice_pitch.read_size_t]
  end

  # Enqueues a command to map an Image into host memory
  #
  # ==== Attributes
  # 
  # * +command_queue+ - CommandQueue used to execute the map command
  # * +buffer+ - the Buffer object to map
  # * +map_flags+ - a single or an Array of :cl_map_flags flags
  # * +options+ - a hash containing named options
  #
  # ==== Options
  #
  # * +:event_wait_list+ - if provided, a list of Event to wait upon before executing the command
  # * +:blocking_map+ - if provided indicates if the command blocks until the region is mapped
  # * +:blocking+ - if provided indicates if the command blocks until the region is mapped
  # * +:offset+ - if provided the offset inside the Buffer region to map, else 0
  # * +:size+ - if provided the size of the region in the Buffer to map, else the largest possible size is used
  #
  # ==== Returns
  #
  # an Array composed of [event, pointer] where:
  # * +event+ - the Event associated with the command
  # * +pointer+ - a Pointer to the mapped memory region
  def self.enqueue_map_buffer( command_queue, buffer, map_flags, options = {} )
    blocking = OpenCL::FALSE
    blocking = OpenCL::TRUE if options[:blocking] or options[:blocking_map]
    offset = 0
    offset = options[:offset] if options[:offset]
    size = buffer.size - offset
    size = options[:size] - offset if options[:size]
    num_events, events = OpenCL.get_event_wait_list( options )
    event = FFI::MemoryPointer.new( Event )
    error = FFI::MemoryPointer.new( :cl_int )
    ptr = OpenCL.clEnqueueMapBuffer( command_queue, buffer, blocking, map_flags, offset, size, num_events, events, error )
    OpenCL.error_check( error.read_cl_int )
    ev = OpenCL::Event::new( event.read_ptr )
    return [ev, ptr]
  end

  # Enqueues a command to unmap a previously mapped region of a memory object
  #
  # ==== Attributes
  # 
  # * +command_queue+ - CommandQueue used to execute the unmap command
  # * +mem_obj+ - the Mem object that was previously mapped
  # * +mapped_ptr+ - the Pointer previously returned by a map command
  # * +options+ - a hash containing named options
  #
  # ==== Options
  #
  # * +:event_wait_list+ - if provided, a list of Event to wait upon before executing the command
  #
  # ==== Returns
  #
  # the Event associated with the command
  def self.enqueue_unmap_mem_object( command_queue, mem_obj, mapped_ptr, options = {} )
    num_events, events = OpenCL.get_event_wait_list( options )
    event = FFI::MemoryPointer.new( Event )
    error = OpenCL.clEnqueueUnmapMemObject( command_queue, mem_obj, mapped_ptr, num_events, events, event )
    OpenCL.error_check( error )
    return OpenCL::Event::new( event.read_ptr )
  end

  # Enqueues a command to read from a rectangular region from a Buffer object to host memory
  #
  # ==== Attributes
  # 
  # * +command_queue+ - CommandQueue used to execute the read command
  # * +buffer+ - the Buffer to be read from
  # * +ptr+ - the Pointer (or convertible to Pointer using to_ptr) to the memory area to use
  # * +region+ - the region in the Buffer to copy
  # * +options+ - a hash containing named options
  #
  # ==== Options
  #
  # * +:event_wait_list+ - if provided, a list of Event to wait upon before executing the command
  # * +:blocking_read+ - if provided indicates if the command blocks until the region is read
  # * +:blocking+ - if provided indicates if the command blocks until the region is read
  # * +:buffer_origin+ - if provided indicates the origin inside the buffer of the area to copy, else [0, 0, 0]
  # * +:host_origin+ - if provided indicates the origin inside the target host area, else [0, 0, 0]
  # * +:buffer_row_pitch+ - if provided indicates the row pitch inside the buffer, else 0
  # * +:buffer_slice_pitch+ - if provided indicates the slice pitch inside the buffer, else 0
  # * +:host_row_pitch+ - if provided indicates the row pitch inside the host area, else 0
  # * +:host_slice_pitch+ - if provided indicates the slice pitch inside the host area, else 0
  #
  # ==== Returns
  #
  # the Event associated with the command
  def self.enqueue_read_buffer_rect( command_queue, buffer, ptr, region, options = {} )
    OpenCL.error_check(OpenCL::INVALID_OPERATION) if command_queue.context.platform.version_number < 1.1
    blocking = OpenCL::FALSE
    blocking = OpenCL::TRUE if options[:blocking] or options[:blocking_read]

    buffer_origin = FFI::MemoryPointer.new( :size_t, 3 )
    (0..2).each { |i| buffer_origin[i].write_size_t(0) }
    bo = options[:src_origin] ? options[:src_origin] : options[:buffer_origin]
    if bo then
      bo.each_with_index { |e, i|
        buffer_origin[i].write_size_t(e)
      }
    end

    host_origin = FFI::MemoryPointer.new( :size_t, 3 )
    (0..2).each { |i| host_origin[i].write_size_t(0) }
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
    num_events, events = OpenCL.get_event_wait_list( options )
    event = FFI::MemoryPointer.new( Event )
    error = OpenCL.clEnqueueReadBufferRect(command_queue, buffer, blocking, buffer_origin, host_origin, r, buffer_row_pitch, buffer_slice_pitch, host_row_pitch, host_slice_pitch, ptr, num_events, events, event)
    OpenCL.error_check(error)
    return OpenCL::Event::new(event.read_pointer)
  end

  # Enqueues a command to write to a rectangular region in a Buffer object from host memory
  #
  # ==== Attributes
  # 
  # * +command_queue+ - CommandQueue used to execute the write command
  # * +buffer+ - the Buffer to be written to
  # * +ptr+ - the Pointer (or convertible to Pointer using to_ptr) to the memory area to use
  # * +region+ - the region to write in the Buffer
  # * +options+ - a hash containing named options
  #
  # ==== Options
  #
  # * +:event_wait_list+ - if provided, a list of Event to wait upon before executing the command
  # * +:blocking_write+ - if provided indicates if the command blocks until the region is written
  # * +:blocking+ - if provided indicates if the command blocks until the region is written
  # * +:buffer_origin+ - if provided indicates the origin inside the buffer of the area to copy, else [0, 0, 0]
  # * +:host_origin+ - if provided indicates the origin inside the target host area, else [0, 0, 0]
  # * +:buffer_row_pitch+ - if provided indicates the row pitch inside the buffer, else 0
  # * +:buffer_slice_pitch+ - if provided indicates the slice pitch inside the buffer, else 0
  # * +:host_row_pitch+ - if provided indicates the row pitch inside the host area, else 0
  # * +:host_slice_pitch+ - if provided indicates the slice pitch inside the host area, else 0
  #
  # ==== Returns
  #
  # the Event associated with the command
  def self.enqueue_write_buffer_rect(command_queue, buffer, ptr, region, options = {})
    OpenCL.error_check(OpenCL::INVALID_OPERATION) if command_queue.context.platform.version_number < 1.1
    blocking = OpenCL::FALSE
    blocking = OpenCL::TRUE if options[:blocking] or options[:blocking_write]

    buffer_origin = FFI::MemoryPointer.new( :size_t, 3 )
    (0..2).each { |i| buffer_origin[i].write_size_t(0) }
    bo = options[:dst_origin] ? options[:dst_origin] : options[:buffer_origin]
    if bo then
      bo.each_with_index { |e, i|
        buffer_origin[i].write_size_t(e)
      }
    end

    host_origin = FFI::MemoryPointer.new( :size_t, 3 )
    (0..2).each { |i| host_origin[i].write_size_t(0) }
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
    num_events, events = OpenCL.get_event_wait_list( options )
    event = FFI::MemoryPointer.new( Event )
    error = OpenCL.clEnqueueWriteBufferRect(command_queue, buffer, blocking, buffer_origin, host_origin, r, buffer_row_pitch, buffer_slice_pitch, host_row_pitch, host_slice_pitch, ptr, num_events, events, event)
    OpenCL.error_check(error)
    return OpenCL::Event::new(event.read_pointer)
  end

  # Enqueues a command to copy a rectangular region into a Buffer object from another Buffer object
  #
  # ==== Attributes
  # 
  # * +command_queue+ - CommandQueue used to execute the write command
  # * +src_buffer+ - the Buffer to be read from
  # * +dst_buffer+ - the Buffer to be written to
  # * +region+ - the region to write in the Buffer
  # * +options+ - a hash containing named options
  #
  # ==== Options
  #
  # * +:event_wait_list+ - if provided, a list of Event to wait upon before executing the command
  # * +:src_origin+ - if provided indicates the origin inside the src Buffer of the area to copy, else [0, 0, 0]
  # * +:dst_origin+ - if provided indicates the origin inside the dst Buffer of the area to write to, else [0, 0, 0]
  # * +:src_row_pitch+ - if provided indicates the row pitch inside the src Buffer, else 0
  # * +:src_slice_pitch+ - if provided indicates the slice pitch inside the src Buffer, else 0
  # * +:dst_row_pitch+ - if provided indicates the row pitch inside the dst Buffer, else 0
  # * +:dst_slice_pitch+ - if provided indicates the slice pitch inside the dst Buffer area, else 0
  #
  # ==== Returns
  #
  # the Event associated with the command
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
    num_events, events = OpenCL.get_event_wait_list( options )
    event = FFI::MemoryPointer.new( Event )
    error = OpenCL.clEnqueueCopyBufferRect(command_queue, src_buffer, dst_buffer, src_origin, dst_origin, r, src_row_pitch, src_slice_pitch, dst_row_pitch, dst_slice_pitch, num_events, events, event)
    OpenCL.error_check(error)
    return OpenCL::Event::new(event.read_pointer)
  end

  # Enqueues a command to copy data from a Buffer object into another Buffer object
  #
  # ==== Attributes
  # 
  # * +command_queue+ - CommandQueue used to execute the write command
  # * +src_buffer+ - the Buffer to be read from
  # * +dst_buffer+ - the Buffer to be written to
  # * +options+ - a hash containing named options
  #
  # ==== Options
  #
  # * +:event_wait_list+ - if provided, a list of Event to wait upon before executing the command
  # * +:src_offset+ - if provided indicates the offset inside the src Buffer of the area to copy, else 0
  # * +:dst_offset+ - if provided indicates the offset inside the dst Buffer of the area to write to, else 0
  # * +:size+ - if provided indicates the size of data to copy, else the maximum possible is copied
  #
  # ==== Returns
  #
  # the Event associated with the command
  def self.enqueue_copy_buffer(command_queue, src_buffer, dst_buffer, options = {})
    src_offset = 0
    src_offset = options[:src_offset] if options[:src_offset]
    dst_offset = 0
    dst_offset = options[:dst_offset] if options[:dst_offset]
    size = [ src_buffer.size - src_offset, dst_buffer.size - dst_offset ].min
    size = options[:size] if options[:size]
    num_events, events = OpenCL.get_event_wait_list( options )
    event = FFI::MemoryPointer.new( Event )
    error = OpenCL.clEnqueueCopyBuffer(command_queue, src_buffer, dst_buffer, src_offset, dst_offset, size, num_events, events, event)
    OpenCL.error_check(error)
    return OpenCL::Event::new(event.read_pointer)
  end


  # Enqueues a command to write to a Buffer object from host memory
  #
  # ==== Attributes
  # 
  # * +command_queue+ - CommandQueue used to execute the write command
  # * +buffer+ - the Buffer to be written to
  # * +ptr+ - the Pointer (or convertible to Pointer using to_ptr) to the memory area to use
  # * +options+ - a hash containing named options
  #
  # ==== Options
  #
  # * +:event_wait_list+ - if provided, a list of Event to wait upon before executing the command
  # * +:blocking_write+ - if provided indicates if the command blocks until the region is written.
  # * +:blocking+ - if provided indicates if the command blocks until the region is written
  # * +:offset+ - if provided indicates the offset inside the Buffer of the area to read from, else 0
  # * +:size+ - if provided indicates the size of data to copy, else the maximum data is copied
  #
  # ==== Returns
  #
  # the Event associated with the command
  def self.enqueue_write_buffer( command_queue, buffer, ptr, options = {} )
    blocking = OpenCL::FALSE
    blocking = OpenCL::TRUE if options[:blocking] or options[:blocking_write]
    offset = 0
    offset = options[:offset] if options[:offset]
    size = buffer.size - offset
    size = options[:size] if options[:size]
    num_events, events = OpenCL.get_event_wait_list( options )
    event = FFI::MemoryPointer.new( Event )
    error = OpenCL.clEnqueueWriteBuffer(command_queue, buffer, blocking, offset, size, ptr, num_events, events, event)
    OpenCL.error_check(error)
    return OpenCL::Event::new(event.read_pointer)
  end

  # Enqueues a command to read from a Buffer object to host memory
  #
  # ==== Attributes
  # 
  # * +command_queue+ - CommandQueue used to execute the read command
  # * +buffer+ - the Buffer to be read from
  # * +ptr+ - the Pointer (or convertible to Pointer using to_ptr) to the memory area to use
  # * +options+ - a hash containing named options
  #
  # ==== Options
  #
  # * +:event_wait_list+ - if provided, a list of Event to wait upon before executing the command
  # * +:blocking_read+ - if provided indicates if the command blocks until the region is read
  # * +:blocking+ - if provided indicates if the command blocks until the region is read
  # * +:offset+ - if provided indicates the offset inside the Buffer of the area to read from, else 0
  # * +:size+ - if provided indicates the size of data to copy, else the maximum data is copied
  #
  # ==== Returns
  #
  # the Event associated with the command
  def self.enqueue_read_buffer( command_queue, buffer, ptr, options = {} )
    blocking = OpenCL::FALSE
    blocking = OpenCL::TRUE if options[:blocking] or options[:blocking_read]
    offset = 0
    offset = options[:offset] if options[:offset]
    size = buffer.size - offset
    size = options[:size] if options[:size]
    num_events, events = OpenCL.get_event_wait_list( options )
    event = FFI::MemoryPointer.new( Event )
    error = OpenCL.clEnqueueReadBuffer(command_queue, buffer, blocking, offset, size, ptr, num_events, events, event)
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

    # Blocks until all the commands in the CommandQueue have completed
    def finish
      return OpenCL.finish(self)
    end

  end

end

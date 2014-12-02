module OpenCL

  # Blocks until all the commands in the queue have completed
  #
  # ==== Attributes
  #
  # * +command_queue+ - the CommandQueue to finish
  def self.finish( command_queue )
    error = clFinish( command_queue )
    error_check( error )
    return command_queue
  end

  # Issues all the commands in a CommandQueue to the Device
  #
  # ==== Attributes
  #
  # * +command_queue+ - the CommandQueue to flush
  def self.flush( command_queue )
    error = clFlush( command_queue )
    error_check( error )
    return command_queue
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
  # * +:size+ - the size of the command queue ( if ON_DEVICE is specified in the properties ) 2.0+ only
  def self.create_command_queue( context, device, options = {} )
    properties = get_command_queue_properties( options )
    size = options[:size]
    error = FFI::MemoryPointer::new( :cl_int )
    if context.platform.version_number < 2.0 then
      cmd = clCreateCommandQueue( context, device, properties, error )
    else
      props = nil
      if properties.to_i != 0 or size then
        props_size = 0
        props_size += 2 if properties.to_i != 0
        props_size += 2 if size
        props_size += 1 if props_size > 0
        props = FFI::MemoryPointer::new( :cl_queue_properties, props_size )
        i=0
        if properties.to_i != 0 then
          props[i].write_cl_queue_properties( Queue::PROPERTIES )
          props[i+1].write_cl_queue_properties( properties.to_i )
          i += 2
        end
        if size then
          props[i].write_cl_queue_properties( Queue::SIZE )
          props[i+1].write_cl_queue_properties( size )
          i += 2
        end
        props[i].write_cl_queue_properties( 0 )
      end
      cmd = clCreateCommandQueueWithProperties( context, device, props, error )
    end
    error_check(error.read_cl_int)
    return CommandQueue::new(cmd, false)
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
    error_check(INVALID_OPERATION) if command_queue.context.platform.version_number < 1.2
    num_mem_objects = [mem_objects].flatten.length
    mem_list = nil
    if num_mem_objects > 0 then
      mem_list = FFI::MemoryPointer::new( Mem, num_mem_objects )
      [mem_objects].flatten.each_with_index { |e, i|
        mem_list[i].write_pointer(e)
      }
    end
    flags = get_flags( options )
    num_events, events = get_event_wait_list( options )
    event = FFI::MemoryPointer::new( Event )
    error = clEnqueueMigrateMemObjects( command_queue, num_mem_objects, mem_list, flags, num_events, events, event )
    error_check( error )
    return Event::new( event.read_ptr, false )
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
    blocking = FALSE
    blocking = TRUE if options[:blocking] or options[:blocking_map]
    flags = get_flags( {:flags => map_flags} )

    origin, region = get_origin_region( image, options, :origin, :region )

    num_events, events = get_event_wait_list( options )
    image_row_pitch = FFI::MemoryPointer::new( :size_t )
    image_slice_pitch = FFI::MemoryPointer::new( :size_t )
    event = FFI::MemoryPointer::new( Event )
    error = FFI::MemoryPointer::new( :cl_int )
    ptr = clEnqueueMapImage( command_queue, image, blocking, flags, origin, region, image_row_pitch, image_slice_pitch, num_events, events, event, error )
    error_check( error.read_cl_int )
    ev = Event::new( event.read_ptr, false )
    return [ev, ptr, image_row_pitch.read_size_t, image_slice_pitch.read_size_t]
  end

  # Enqueues a command to map aa Buffer into host memory
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
    blocking = FALSE
    blocking = TRUE if options[:blocking] or options[:blocking_map]
    flags = get_flags( {:flags => map_flags} )

    offset = 0
    offset = options[:offset] if options[:offset]
    size = buffer.size - offset
    size = options[:size] - offset if options[:size]
    num_events, events = get_event_wait_list( options )
    event = FFI::MemoryPointer::new( Event )
    error = FFI::MemoryPointer::new( :cl_int )
    ptr = clEnqueueMapBuffer( command_queue, buffer, blocking, flags, offset, size, num_events, events, event, error )
    error_check( error.read_cl_int )
    ev = Event::new( event.read_ptr, false )
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
    num_events, events = get_event_wait_list( options )
    event = FFI::MemoryPointer::new( Event )
    error = clEnqueueUnmapMemObject( command_queue, mem_obj, mapped_ptr, num_events, events, event )
    error_check( error )
    return Event::new( event.read_ptr, false )
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
    error_check(INVALID_OPERATION) if command_queue.context.platform.version_number < 1.1
    blocking = FALSE
    blocking = TRUE if options[:blocking] or options[:blocking_read]

    buffer_origin = FFI::MemoryPointer::new( :size_t, 3 )
    (0..2).each { |i| buffer_origin[i].write_size_t(0) }
    bo = options[:src_origin] ? options[:src_origin] : options[:buffer_origin]
    if bo then
      bo.each_with_index { |e, i|
        buffer_origin[i].write_size_t(e)
      }
    end

    host_origin = FFI::MemoryPointer::new( :size_t, 3 )
    (0..2).each { |i| host_origin[i].write_size_t(0) }
    ho = options[:dst_origin] ? options[:dst_origin] : options[:host_origin]
    if ho then
      ho.each_with_index { |e, i|
        host_origin[i].write_size_t(e)
      }
    end

    r = FFI::MemoryPointer::new( :size_t, 3 )
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
    num_events, events = get_event_wait_list( options )
    event = FFI::MemoryPointer::new( Event )
    error = clEnqueueReadBufferRect(command_queue, buffer, blocking, buffer_origin, host_origin, r, buffer_row_pitch, buffer_slice_pitch, host_row_pitch, host_slice_pitch, ptr, num_events, events, event)
    error_check(error)
    return Event::new(event.read_pointer, false)
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
    error_check(INVALID_OPERATION) if command_queue.context.platform.version_number < 1.1
    blocking = FALSE
    blocking = TRUE if options[:blocking] or options[:blocking_write]

    buffer_origin = FFI::MemoryPointer::new( :size_t, 3 )
    (0..2).each { |i| buffer_origin[i].write_size_t(0) }
    bo = options[:dst_origin] ? options[:dst_origin] : options[:buffer_origin]
    if bo then
      bo.each_with_index { |e, i|
        buffer_origin[i].write_size_t(e)
      }
    end

    host_origin = FFI::MemoryPointer::new( :size_t, 3 )
    (0..2).each { |i| host_origin[i].write_size_t(0) }
    ho = options[:src_origin] ? options[:src_origin] : options[:host_origin]
    if ho then
      ho.each_with_index { |e, i|
        host_origin[i].write_size_t(e)
      }
    end

    r = FFI::MemoryPointer::new( :size_t, 3 )
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
    num_events, events = get_event_wait_list( options )
    event = FFI::MemoryPointer::new( Event )
    error = clEnqueueWriteBufferRect(command_queue, buffer, blocking, buffer_origin, host_origin, r, buffer_row_pitch, buffer_slice_pitch, host_row_pitch, host_slice_pitch, ptr, num_events, events, event)
    error_check(error)
    return Event::new(event.read_pointer, false)
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
    error_check(INVALID_OPERATION) if command_queue.context.platform.version_number < 1.1

    src_origin = FFI::MemoryPointer::new( :size_t, 3 )
    (0..2).each { |i| src_origin[i].write_size_t(0) }
    if options[:src_origin] then
      options[:src_origin].each_with_index { |e, i|
        src_origin[i].write_size_t(e)
      }
    end

    dst_origin = FFI::MemoryPointer::new( :size_t, 3 )
    (0..2).each { |i| dst_origin[i].write_size_t(0) }
    if options[:dst_origin] then
      options[:dst_origin].each_with_index { |e, i|
        dst_origin[i].write_size_t(e)
      }
    end

    r = FFI::MemoryPointer::new( :size_t, 3 )
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
    num_events, events = get_event_wait_list( options )
    event = FFI::MemoryPointer::new( Event )
    error = clEnqueueCopyBufferRect(command_queue, src_buffer, dst_buffer, src_origin, dst_origin, r, src_row_pitch, src_slice_pitch, dst_row_pitch, dst_slice_pitch, num_events, events, event)
    error_check(error)
    return Event::new(event.read_pointer, false)
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
    num_events, events = get_event_wait_list( options )
    event = FFI::MemoryPointer::new( Event )
    error = clEnqueueCopyBuffer(command_queue, src_buffer, dst_buffer, src_offset, dst_offset, size, num_events, events, event)
    error_check(error)
    return Event::new(event.read_pointer, false)
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
    blocking = FALSE
    blocking = TRUE if options[:blocking] or options[:blocking_write]
    offset = 0
    offset = options[:offset] if options[:offset]
    size = buffer.size - offset
    size = options[:size] if options[:size]
    num_events, events = get_event_wait_list( options )
    event = FFI::MemoryPointer::new( Event )
    error = clEnqueueWriteBuffer(command_queue, buffer, blocking, offset, size, ptr, num_events, events, event)
    error_check(error)
    return Event::new(event.read_pointer, false)
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
    blocking = FALSE
    blocking = TRUE if options[:blocking] or options[:blocking_read]
    offset = 0
    offset = options[:offset] if options[:offset]
    size = buffer.size - offset
    size = options[:size] if options[:size]
    num_events, events = get_event_wait_list( options )
    event = FFI::MemoryPointer::new( Event )
    error = clEnqueueReadBuffer(command_queue, buffer, blocking, offset, size, ptr, num_events, events, event)
    error_check(error)
    return Event::new(event.read_pointer, false)
  end

  # Acquire OpenCL Mem objects that have been created from OpenGL objects
  #
  # ==== Attributes
  # 
  # * +command_queue+ - CommandQueue used to execute the acquire command
  # * +mem_objects+ - a single or an Array of Mem objects
  # * +options+ - a hash containing named options
  #
  # ==== Options
  #
  # * +:event_wait_list+ - if provided, a list of Event to wait upon before executing the command
  #
  # ==== Returns
  #
  # the Event associated with the command
  def self.enqueue_acquire_GL_objects( command_queue, mem_objects, options = {} )
    num_objs = [mem_objects].flatten.length
    objs = nil
    if num_objs > 0 then
      objs = FFI::MemoryPointer::new(  Mem, num_objs )
      [mem_objects].flatten.each_with_index { |o, i|
        objs[i].write_pointer(e)
      }
    end
    num_events, events = get_event_wait_list( options )
    event = FFI::MemoryPointer::new( Event )
    error = clEnqueueAcquireGLObjects( command_queue, num_objs, objs, num_events, events, event )
    error_check(error)
    return Event::new(event.read_pointer, false)
  end
  class << self
    alias :enqueue_acquire_gl_objects :enqueue_acquire_GL_objects
  end

  # Release OpenCL Mem objects that have been created from OpenGL objects and previously acquired
  #
  # ==== Attributes
  # 
  # * +command_queue+ - CommandQueue used to execute the release command
  # * +mem_objects+ - a single or an Array of Mem objects
  # * +options+ - a hash containing named options
  #
  # ==== Options
  #
  # * +:event_wait_list+ - if provided, a list of Event to wait upon before executing the command
  #
  # ==== Returns
  #
  # the Event associated with the command
  def self.enqueue_release_GL_objects( command_queue, mem_objects, options = {} )
    num_objs = [mem_objects].flatten.length
    objs = nil
    if num_objs > 0 then
      objs = FFI::MemoryPointer::new( Mem, num_objs )
      [mem_objects].flatten.each_with_index { |o, i|
        objs[i].write_pointer(e)
      }
    end
    num_events, events = get_event_wait_list( options )
    event = FFI::MemoryPointer::new( Event )
    error = clEnqueueReleaseGLObjects( command_queue, num_objs, objs, num_events, events, event )
    error_check(error)
    return Event::new(event.read_pointer, false)
  end
  class << self
    alias :enqueue_release_gl_objects :enqueue_release_GL_objects
  end

  # Enqueues a command to fill a Buffer with the given pattern
  #
  # ==== Attributes
  # 
  # * +command_queue+ - CommandQueue used to execute the fill command
  # * +buffer+ - a Buffer object to be filled
  # * +pattern+ - the Pointer (or convertible to Pointer using to_ptr) to the memory area where the pattern is stored
  # * +options+ - a hash containing named options
  #
  # ==== Options
  #
  # * +:event_wait_list+ - if provided, a list of Event to wait upon before executing the command
  # * +:offset+ - if provided indicates the offset inside the Buffer of the area to be filled, else 0
  # * +:size+ - if provided indicates the size of data to fill, else the maximum size is filled
  # * +:pattern_size+ - if provided indicates the size of the pattern, else the maximum pattern data is used
  #
  # ==== Returns
  #
  # the Event associated with the command
  def self.enqueue_fill_buffer( command_queue, buffer, pattern, options = {} )
    error_check(INVALID_OPERATION) if command_queue.context.platform.version_number < 1.1
    offset = 0
    offset = options[:offset] if options[:offset]
    pattern_size = pattern.size
    pattern_size = options[:pattern_size] if options[:pattern_size]
    size = (buffer.size - offset) % pattern_size
    size = options[:size] if options[:size]
    num_events, events = get_event_wait_list( options )
    event = FFI::MemoryPointer::new( Event )
    error = clEnqueueFillBuffer( command_queue, buffer, pattern, pattern_size, offset, size, num_events, events, event )
    error_check(error)
    return Event::new(event.read_pointer, false)
  end

  # Enqueues a command to fill an Image with the given color
  #
  # ==== Attributes
  # 
  # * +command_queue+ - CommandQueue used to execute the fill command
  # * +image+ - an Image object to be filled
  # * +fill_color+ - the Pointer (or convertible to Pointer using to_ptr) to the memory area where the color is stored
  # * +options+ - a hash containing named options
  #
  # ==== Options
  #
  # * +:event_wait_list+ - if provided, a list of Event to wait upon before executing the command
  # * +:origin+ - if provided indicates the origin of the region to fill inside the Image, else [0, 0, 0]
  # * +:region+ - if provided indicates the dimension of the region to fill, else the maximum region is filled
  #
  # ==== Returns
  #
  # the Event associated with the command
  def self.enqueue_fill_image( command_queue, image, fill_color, options = {} )
    error_check(INVALID_OPERATION) if command_queue.context.platform.version_number < 1.1
    origin, region = get_origin_region( image, options, :origin, :region )
    num_events, events = get_event_wait_list( options )
    event = FFI::MemoryPointer::new( Event )
    error = clEnqueueFillImage( command_queue, image, fill_color, origin, region, num_events, events, event )
    error_check(error)
    return Event::new(event.read_pointer, false)
  end

  # Enqueues a command to copy an Image into a Buffer
  #
  # ==== Attributes
  # 
  # * +command_queue+ - CommandQueue used to execute the copy command
  # * +src_image+ - the Image to be read from
  # * +dst_buffer+ - the Buffer to be written to
  # * +options+ - a hash containing named options
  #
  # ==== Options
  #
  # * +:event_wait_list+ - if provided, a list of Event to wait upon before executing the command
  # * +:src_origin+ - if provided indicates the origin of the region to copy from the Image, else [0, 0, 0]
  # * +:region+ - if provided indicates the dimension of the region to copy, else the maximum region is copied
  # * +:dst_offset+ - if provided indicates the offset inside the Buffer, else 0
  #
  # ==== Returns
  #
  # the Event associated with the command
  def self.enqueue_copy_image_to_buffer( command_queue, src_image, dst_buffer, options = {} )
    src_origin, region = get_origin_region( src_image, options, :src_origin, :region )
    dst_offset = 0
    dst_offset = options[:dst_offset] if options[:dst_offset]
    num_events, events = get_event_wait_list( options )
    event = FFI::MemoryPointer::new( Event )
    error = clEnqueueCopyImageToBuffer( command_queue, src_image, dst_buffer, src_origin, region, dst_offset, num_events, events, event )
    error_check(error)
    return Event::new(event.read_pointer, false)
  end

  # Enqueues a command to copy a Buffer into an Image
  #
  # ==== Attributes
  # 
  # * +command_queue+ - CommandQueue used to execute the copy command
  # * +src_buffer+ - the Buffer to be read from
  # * +dst_image+ - the Image to be written to
  # * +options+ - a hash containing named options
  #
  # ==== Options
  #
  # * +:event_wait_list+ - if provided, a list of Event to wait upon before executing the command
  # * +:dst_origin+ - if provided indicates the origin of the region to write into the Image, else [0, 0, 0]
  # * +:region+ - if provided indicates the dimension of the region to copy, else the maximum region is copied
  # * +:src_offset+ - if provided indicates the offset inside the Buffer, else 0
  #
  # ==== Returns
  #
  # the Event associated with the command
  def self.enqueue_copy_buffer_to_image(command_queue, src_buffer, dst_image, options = {})
    dst_origin, region = get_origin_region( dst_image, options, :dst_origin, :region )
    src_offset = 0
    src_offset = options[:src_offset] if options[:src_offset]
    num_events, events = get_event_wait_list( options )
    event = FFI::MemoryPointer::new( Event )
    error = clEnqueueCopyBufferToImage( command_queue, src_buffer, dst_image, src_offset, dst_origin, region, num_events, events, event )
    error_check(error)
    return Event::new(event.read_pointer, false)
  end

  # Enqueues a command to copy from host memory into an Image
  #
  # ==== Attributes
  # 
  # * +command_queue+ - CommandQueue used to execute the write command
  # * +image+ - the Image to be written to
  # * +ptr+ - the Pointer (or convertible to Pointer using to_ptr) to the memory area to use
  # * +options+ - a hash containing named options
  #
  # ==== Options
  #
  # * +:event_wait_list+ - if provided, a list of Event to wait upon before executing the command
  # * +:blocking_write+ - if provided indicates if the command blocks until the region is written.
  # * +:blocking+ - if provided indicates if the command blocks until the region is written
  # * +:origin+ - if provided indicates the origin of the region to write into the Image, else [0, 0, 0]
  # * +:region+ - if provided indicates the dimension of the region to copy, else the maximum region is copied
  # * +:input_row_pitch+ - if provided indicates the row pitch inside the host area, else 0
  # * +:input_slice_pitch+ - if provided indicates the slice pitch inside the host area, else 0
  #
  # ==== Returns
  #
  # the Event associated with the command
  def self.enqueue_write_image(command_queue, image, ptr, options = {})
    blocking = FALSE
    blocking = TRUE if options[:blocking] or options[:blocking_write]

    origin, region = get_origin_region( image, options, :origin, :region )

    input_row_pitch = 0
    input_row_pitch = options[:input_row_pitch] if options[:input_row_pitch]
    input_slice_pitch = 0
    input_slice_pitch = options[:input_slice_pitch] if options[:input_slice_pitch]
    num_events, events = get_event_wait_list( options )
    event = FFI::MemoryPointer::new( Event )
    error = clEnqueueWriteImage( command_queue, image, blocking, origin, region, input_row_pitch, input_slice_pitch, ptr, num_events, events, event )
    error_check(error)
    return Event::new(event.read_pointer, false)
  end

  # Enqueues a command to copy from an Image into an Image
  #
  # ==== Attributes
  # 
  # * +command_queue+ - CommandQueue used to execute the copy command
  # * +src_image+ - the Image to be written to
  # * +dst_image+ - the Image to be written to
  # * +options+ - a hash containing named options
  #
  # ==== Options
  #
  # * +:event_wait_list+ - if provided, a list of Event to wait upon before executing the command
  # * +:src_origin+ - if provided indicates the origin of the region to read into the src Image, else [0, 0, 0]
  # * +:dst_origin+ - if provided indicates the origin of the region to write into the dst Image, else [0, 0, 0]
  # * +:region+ - if provided indicates the dimension of the region to copy, else the maximum region is copied
  #
  # ==== Returns
  #
  # the Event associated with the command
  def self.enqueue_copy_image( command_queue, src_image, dst_image, options = {} )
    src_origin, src_region = get_origin_region( src_image, options, :src_origin, :region )
    dst_origin, dst_region = get_origin_region( dst_image, options, :dst_origin, :region )
    region = FFI::MemoryPointer::new( :size_t, 3 )
    (0..2).each { |i|
      region[i].write_size_t( [src_region[i].read_size_t, dst_region[i].read_size_t].min )
    }
    num_events, events = get_event_wait_list( options )
    event = FFI::MemoryPointer::new( Event )
    error = clEnqueueCopyImage( command_queue, src_image, dst_image, src_origin, dst_origin, region, num_events, events, event )
    error_check(error)
    return Event::new(event.read_pointer, false)
  end

  # Enqueues a command to copy from an Image into host memory
  #
  # ==== Attributes
  # 
  # * +command_queue+ - CommandQueue used to execute the read command
  # * +image+ - the Image to be written to
  # * +ptr+ - the Pointer (or convertible to Pointer using to_ptr) to the memory area to use
  # * +options+ - a hash containing named options
  #
  # ==== Options
  #
  # * +:event_wait_list+ - if provided, a list of Event to wait upon before executing the command
  # * +:blocking_read+ - if provided indicates if the command blocks until the region is read.
  # * +:blocking+ - if provided indicates if the command blocks until the region is read
  # * +:origin+ - if provided indicates the origin of the region to read from the Image, else [0, 0, 0]
  # * +:region+ - if provided indicates the dimension of the region to copy, else the maximum region is copied
  # * +:row_pitch+ - if provided indicates the row pitch inside the host area, else 0
  # * +:slice_pitch+ - if provided indicates the slice pitch inside the host area, else 0
  #
  # ==== Returns
  #
  # the Event associated with the command
  def self.enqueue_read_image( command_queue, image, ptr, options = {} )
    blocking = FALSE
    blocking = TRUE if options[:blocking] or options[:blocking_read]

    origin, region = get_origin_region( image, options, :origin, :region )
    row_pitch = 0
    row_pitch = options[:row_pitch] if options[:row_pitch]
    slice_pitch = 0
    slice_pitch = options[:slice_pitch] if options[:slice_pitch]
    num_events, events = get_event_wait_list( options )
    event = FFI::MemoryPointer::new( Event )
    error = clEnqueueReadImage( command_queue, image, blocking, origin, region, row_pitch, slice_pitch, ptr, num_events, events, event )
    error_check(error)
    return Event::new(event.read_pointer, false)
  end

  # Enqueues a native kernel
  #
  # ==== Attributes
  # 
  # * +command_queue+ - CommandQueue used to execute the command
  # * +options+ - a hash containing named options
  # * +func+ - a Proc object to execute
  #
  # ==== Options
  #
  # * +:args+ - if provided, a list of arguments to pass to the kernel. Arguments should have a size method and be convertible to Pointer with to_ptr
  # * +:mem_list+ - if provided, a hash containing Buffer objects and their index inside the argument list.
  # * +:event_wait_list+ - if provided, a list of Event to wait upon before executing the command
  #
  # ==== Returns
  #
  # the Event associated with the command
  def self.enqueue_native_kernel( command_queue, options = {}, &func )
    arguments = options[:args]
    arg_offset = []
    args = nil
    args_size = 0
    if arguments then
      [arguments].flatten.each { |e|
        arg_offset.push(arg_size)
        args_size += e.size
      }
      args = FFI::MemoryPointer::new(args_size)
      [arguments].flatten.each_with_index { |e, i|
        args.put_bytes(arg_offset[i], e.to_ptr.read_bytes(e.size))
      }
    end
    num_mem_objects = 0
    mem_list = nil
    if options[:mem_list] then
      num_mem_objects = options[:mem_list].length
      if num_mem_objects > 0 then
        mem_list = FFI::MemoryPointer::new( Mem, num_mem_objects )
        mem_loc = FFI::MemoryPointer::new( :pointer, num_mem_objects )
        i = 0
        options[:mem_list].each { |key, value|
          mem_list[i].write_pointer(key)
          mem_loc[i].write_pointer(args+arg_offset[value])
          i = i + 1
        }
      end
    end
    num_events, events = get_event_wait_list( options )
    event = FFI::MemoryPointer::new( Event )
    error = clEnqueueNativeKernel( command_queue, func, args, args_size, num_mem_objects, mem_list, mem_loc, num_events, events, event )
    error_check(error)
    return Event::new(event.read_pointer, false)
  end

  # Enqueues a kernel as a task
  #
  # ==== Attributes
  # 
  # * +command_queue+ - CommandQueue used to execute the command
  # * +kernel+ - a Kernel object to execute
  # * +options+ - a hash containing named options
  #
  # ==== Options
  #
  # * +:event_wait_list+ - if provided, a list of Event to wait upon before executing the command
  #
  # ==== Returns
  #
  # the Event associated with the command
  def self.enqueue_task( command_queue, kernel, options = {} )
    if queue.context.platform.version_number < 2.0 then
      num_events, events = get_event_wait_list( options )
      event = FFI::MemoryPointer::new( Event )
      error = clEnqueueTask( command_queue, kernel, num_events, events, event )
      error_check(error)
      return Event::new(event.read_pointer, false)
    else
      opts = options.dup
      opts[:local_work_size] = [1]
      return enqueue_NDrange_kernel( command_queue, kernel, [1], opts )
    end
  end

  # Enqueues a kernel as a NDrange
  #
  # ==== Attributes
  # 
  # * +command_queue+ - CommandQueue used to execute the command
  # * +kernel+ - a Kernel object to execute
  # * +global_work_size+ - dimensions of the work
  # * +options+ - a hash containing named options
  #
  # ==== Options
  #
  # * +:event_wait_list+ - if provided, a list of Event to wait upon before executing the command
  # * +:local_work_size+ - if provided, dimensions of the local work group size
  # * +:global_work_offset+ - if provided, offset inside the global work size
  #
  # ==== Returns
  #
  # the Event associated with the command
  def self.enqueue_NDrange_kernel( command_queue, kernel, global_work_size, options={} )
    gws = FFI::MemoryPointer::new( :size_t, global_work_size.length )
    global_work_size.each_with_index { |g, i|
      gws[i].write_size_t(g)
    }
    lws = nil
    if options[:local_work_size] then
      lws = FFI::MemoryPointer::new( :size_t, global_work_size.length )
      global_work_size.each_index { |i|
        lws[i].write_size_t(options[:local_work_size][i])
      }
    end
    gwo = nil
    if options[:global_work_offset] then
      gwo = FFI::MemoryPointer::new( :size_t, global_work_size.length )
      global_work_size.each_index { |i|
        gwo[i].write_size_t(options[:global_work_offset][i])
      }
    end
    num_events, events = get_event_wait_list( options )
    event = FFI::MemoryPointer::new( Event )
    error = clEnqueueNDRangeKernel(command_queue, kernel, global_work_size.length, gwo, gws, lws, num_events, events, event)
    error_check(error)
    return Event::new(event.read_pointer, false)
  end
  class << self
    alias :enqueue_nd_range_kernel :enqueue_NDrange_kernel
  end

  # Enqueues a barrier on a list of envents
  #
  # ==== Attributes
  # 
  # * +command_queue+ - CommandQueue used to execute the command
  # * +events+ - a single or an Array of Event to wait upon before the barrier is considered finished
  #
  # ==== Returns
  #
  # an Event if implementation version is >= 1.2, nil otherwise
  def self.enqueue_wait_for_events( command_queue, events )
    return enqueue_barrier( command_queue, events )
  end

  # Enqueues a barrier that prevents subsequent execution to take place in the command queue, until the barrier is considered finished
  #
  # ==== Attributes
  # 
  # * +command_queue+ - CommandQueue used to execute the command
  # * +events+ - an optional single or Array of Event to wait upon before the barrier is considered finished
  #
  # ==== Returns
  #
  # an Event if implementation version is >= 1.2, nil otherwise
  def self.enqueue_barrier( command_queue, events = [] )
    if command_queue.context.platform.version_number < 1.2 then
      num_events = [events].flatten.length
      if num_events > 0 then
        evts = FFI::MemoryPointer::new( Event, num_events )
        [events].flatten.each_with_index { |e, i|
          evts[i].write_pointer(e)
        }
        error = clnqueueWaitForEvents( command_queue, num_events, evts )
      else
        error = clEnqueueBarrier( command_queue )
      end
      error_check(error)
      return nil
    else
      num_events = [events].flatten.length
      evts = nil
      if num_events > 0 then
        evts = FFI::MemoryPointer::new( Event, num_events )
        [events].flatten.each_with_index { |e, i|
          evts[i].write_pointer(e)
        }
      end
      event = FFI::MemoryPointer::new( Event )
      error = clEnqueueBarrierWithWaitList( command_queue, num_events, evts, event )
      error_check(error)
      return Event::new(event.read_pointer, false)
    end
  end

  # Enqueues a marker
  #
  # ==== Attributes
  # 
  # * +command_queue+ - CommandQueue used to execute the command
  # * +events+ - an optional single or Array of Event to wait upon before the marker is considered finished, if not provided all previous command are waited for before the marker is considered finished (unavailable if implementation version < 1.2 )
  #
  # ==== Returns
  #
  # an Event
  def self.enqueue_marker( command_queue, events = [] )
    event = FFI::MemoryPointer::new( Event )
    if command_queue.context.platform.version_number < 1.2 then
      error = clEnqueueMarker( command_queue, event )
    else
      num_events = [events].flatten.length
      evts = nil
      if num_events > 0 then
        evts = FFI::MemoryPointer::new( Event, num_events )
        [events].flatten.each_with_index { |e, i|
          evts[i].write_pointer(e)
        }
      end
      error = clEnqueueMarkerWithWaitList( command_queue, num_events, evts, event )
    end
    error_check(error)
    return Event::new(event.read_pointer, false)
  end

  # Maps the cl_command_queue object of OpenCL
  class CommandQueue
    include InnerInterface
 
    class << self
      include InnerGenerator
    end

    # Returns the Context associated to the CommandQueue
    def context
      ptr = FFI::MemoryPointer::new( Context )
      error = OpenCL.clGetCommandQueueInfo(self, CONTEXT, Context.size, ptr, nil)
      error_check(error)
      return Context::new( ptr.read_pointer )
    end

    # Returns the Device associated to the CommandQueue
    def device
      ptr = FFI::MemoryPointer::new( Device )
      error = OpenCL.clGetCommandQueueInfo(self, DEVICE, Device.size, ptr, nil)
      error_check(error)
      return Device::new( ptr.read_pointer )
    end

    ##
    # :method: reference_count
    # Returns the reference count of the CommandQueue
    eval get_info("CommandQueue", :cl_uint, "REFERENCE_COUNT")

    ##
    # :method: size
    # Returns the currently specified size for the command queue (2.0 and for device queue only)
    eval get_info("CommandQueue", :cl_uint, "SIZE")

    ##
    # :method: properties
    # Returns the :cl_command_queue_properties used to create the CommandQueue
    eval get_info("CommandQueue", :cl_command_queue_properties, "PROPERTIES")

    # Enqueues a kernel as a task using the CommandQueue
    #
    # ==== Attributes
    # 
    # * +kernel+ - a Kernel object to execute
    # * +options+ - a hash containing named options
    #
    # ==== Options
    #
    # * +:event_wait_list+ - if provided, a list of Event to wait upon before executing the command
    #
    # ==== Returns
    #
    # the Event associated with the command
    def enqueue_task( kernel, options = {} )
      return OpenCL.enqueue_task( self, kernel, options )
    end

    # Enqueues a kernel as a NDrange using the CommandQueue
    #
    # ==== Attributes
    # 
    # * +kernel+ - a Kernel object to execute
    # * +global_work_size+ - dimensions of the work
    # * +options+ - a hash containing named options
    #
    # ==== Options
    #
    # * +:event_wait_list+ - if provided, a list of Event to wait upon before executing the command
    # * +:local_work_size+ - if provided, dimensions of the local work group size
    # * +:global_work_offset+ - if provided, offset inside the global work size
    #
    # ==== Returns
    #
    # the Event associated with the command
    def enqueue_NDrange_kernel( kernel, global_work_size, options = {} )
      return OpenCL.enqueue_NDrange_kernel( self, kernel, global_work_size, options )
    end
    alias :enqueue_nd_range_kernel :enqueue_NDrange_kernel

    # Enqueues a command to write to a Buffer object from host memory using the CommandQueue
    #
    # ==== Attributes
    # 
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
    def enqueue_write_buffer( buffer, ptr, options = {} )
      return OpenCL.enqueue_write_buffer( self, buffer, ptr, options )
    end

    # Enqueues a command to write to a rectangular region in a Buffer object from host memory using the CommandQueue
    #
    # ==== Attributes
    # 
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
    def enqueue_write_buffer_rect( buffer, ptr, region, options = {} )
      return OpenCL.enqueue_write_buffer_rect( self, buffer, ptr, region, options )
    end

    # Enqueues a command to read from a Buffer object to host memory using the CommandQueue
    #
    # ==== Attributes
    # 
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
    def enqueue_read_buffer( buffer, ptr, options = {} )
      return OpenCL.enqueue_read_buffer( self, buffer, ptr, options)
    end

    # Enqueues a command to read from a rectangular region from a Buffer object to host memory using the CommandQueue
    #
    # ==== Attributes
    # 
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
    def enqueue_read_buffer_rect( buffer, ptr, region, options = {} )
      return OpenCL.enqueue_read_buffer_rect( self, buffer, ptr, region, options )
    end

    # Enqueues a command to copy data from a Buffer object into another Buffer object using the CommandQueue
    #
    # ==== Attributes
    # 
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
    def enqueue_copy_buffer( src_buffer, dst_buffer, options = {} )
      return OpenCL.enqueue_copy_buffer( self, src_buffer, dst_buffer, options )
    end

    # Enqueues a command to copy a rectangular region into a Buffer object from another Buffer object using the CommandQueue
    #
    # ==== Attributes
    # 
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
    def enqueue_copy_buffer_rect( src_buffer, dst_buffer, region, options = {} )
      return OpenCL.enqueue_copy_buffer_rect( self, src_buffer, dst_buffer, region, options )
    end

    # Enqueues a barrier on a list of envents using the CommandQueue
    #
    # ==== Attributes
    # 
    # * +events+ - a single or an Array of Event to wait upon before the barrier is considered finished
    #
    # ==== Returns
    #
    # an Event if implementation version is >= 1.2, nil otherwise
    def enqueue_barrier( events )
      return OpenCL.enqueue_barrier( self, events )
    end

    # Enqueues a marker using the CommandQueue
    #
    # ==== Attributes
    # 
    # * +events+ - an optional single or Array of Event to wait upon before the marker is considered finished, if not provided all previous command are waited for before the marker is considered finished (unavailable if implementation version < 1.2 )
    #
    # ==== Returns
    #
    # an Event
    def enqueue_marker( events = [] )
      return OpenCL.enqueue_marker( self, events )
    end

    # Enqueues a barrier on a list of envents using the CommandQueue
    #
    # ==== Attributes
    # 
    # * +events+ - a single or an Array of Event to wait upon before the barrier is considered finished
    #
    # ==== Returns
    #
    # an Event if implementation version is >= 1.2, nil otherwise
    def enqueue_wait_for_events( events = [] )
      return OpenCL.enqueue_wait_for_events( self, events )
    end

    # Enqueues a command to copy from host memory into an Image using the CommandQueue
    #
    # ==== Attributes
    # 
    # * +image+ - the Image to be written to
    # * +ptr+ - the Pointer (or convertible to Pointer using to_ptr) to the memory area to use
    # * +options+ - a hash containing named options
    #
    # ==== Options
    #
    # * +:event_wait_list+ - if provided, a list of Event to wait upon before executing the command
    # * +:blocking_write+ - if provided indicates if the command blocks until the region is written.
    # * +:blocking+ - if provided indicates if the command blocks until the region is written
    # * +:origin+ - if provided indicates the origin of the region to write into the Image, else [0, 0, 0]
    # * +:region+ - if provided indicates the dimension of the region to copy, else the maximum region is copied
    # * +:input_row_pitch+ - if provided indicates the row pitch inside the host area, else 0
    # * +:input_slice_pitch+ - if provided indicates the slice pitch inside the host area, else 0
    #
    # ==== Returns
    #
    # the Event associated with the command
    def enqueue_write_image( image, ptr, options = {} )
      return OpenCL.enqueue_write_image( self, image, ptr, options )
    end

    # Enqueues a command to copy from an Image into host memory using the CommandQueue
    #
    # ==== Attributes
    # 
    # * +image+ - the Image to be written to
    # * +ptr+ - the Pointer (or convertible to Pointer using to_ptr) to the memory area to use
    # * +options+ - a hash containing named options
    #
    # ==== Options
    #
    # * +:event_wait_list+ - if provided, a list of Event to wait upon before executing the command
    # * +:blocking_read+ - if provided indicates if the command blocks until the region is read.
    # * +:blocking+ - if provided indicates if the command blocks until the region is read
    # * +:origin+ - if provided indicates the origin of the region to read from the Image, else [0, 0, 0]
    # * +:region+ - if provided indicates the dimension of the region to copy, else the maximum region is copied
    # * +:row_pitch+ - if provided indicates the row pitch inside the host area, else 0
    # * +:slice_pitch+ - if provided indicates the slice pitch inside the host area, else 0
    #
    # ==== Returns
    #
    # the Event associated with the command
    def enqueue_read_image( image, ptr, options = {} )
      return OpenCL.enqueue_read_image( self, image, ptr, options )
    end

    # Enqueues a command to copy from an Image into an Image using the CommandQueue
    #
    # ==== Attributes
    # 
    # * +src_image+ - the Image to be written to
    # * +dst_image+ - the Image to be written to
    # * +options+ - a hash containing named options
    #
    # ==== Options
    #
    # * +:event_wait_list+ - if provided, a list of Event to wait upon before executing the command
    # * +:src_origin+ - if provided indicates the origin of the region to read into the src Image, else [0, 0, 0]
    # * +:dst_origin+ - if provided indicates the origin of the region to write into the dst Image, else [0, 0, 0]
    # * +:region+ - if provided indicates the dimension of the region to copy, else the maximum region is copied
    #
    # ==== Returns
    #
    # the Event associated with the command
    def enqueue_copy_image( src_image, dst_image, options = {} )
      return OpenCL.enqueue_copy_image( self, src_image, dst_image, options )
    end

    # Enqueues a command to copy a Buffer into an Image using the CommandQueue
    #
    # ==== Attributes
    # 
    # * +src_buffer+ - the Buffer to be read from
    # * +dst_image+ - the Image to be written to
    # * +options+ - a hash containing named options
    #
    # ==== Options
    #
    # * +:event_wait_list+ - if provided, a list of Event to wait upon before executing the command
    # * +:dst_origin+ - if provided indicates the origin of the region to write into the Image, else [0, 0, 0]
    # * +:region+ - if provided indicates the dimension of the region to copy, else the maximum region is copied
    # * +:src_offset+ - if provided indicates the offset inside the Buffer, else 0
    #
    # ==== Returns
    #
    # the Event associated with the command
    def enqueue_copy_buffer_to_image( src_buffer, dst_image, options = {} )
      return OpenCL.enqueue_copy_buffer_to_image( self, src_buffer, dst_image, options )
    end

    # Enqueues a command to copy an Image into a Buffer using the CommandQueue
    #
    # ==== Attributes
    # 
    # * +src_image+ - the Image to be read from
    # * +dst_buffer+ - the Buffer to be written to
    # * +options+ - a hash containing named options
    #
    # ==== Options
    #
    # * +:event_wait_list+ - if provided, a list of Event to wait upon before executing the command
    # * +:src_origin+ - if provided indicates the origin of the region to copy from the Image, else [0, 0, 0]
    # * +:region+ - if provided indicates the dimension of the region to copy, else the maximum region is copied
    # * +:dst_offset+ - if provided indicates the offset inside the Buffer, else 0
    #
    # ==== Returns
    #
    # the Event associated with the command
    def enqueue_copy_image_to_buffer( src_image, dst_buffer, options = {} )
      return OpenCL.enqueue_copy_image_to_buffer( self, src_image, dst_buffer, options )
    end

    # Enqueues a command to fill an Image with the given color using the CommandQueue
    #
    # ==== Attributes
    # 
    # * +image+ - an Image object to be filled
    # * +fill_color+ - the Pointer (or convertible to Pointer using to_ptr) to the memory area where the color is stored
    # * +options+ - a hash containing named options
    #
    # ==== Options
    #
    # * +:event_wait_list+ - if provided, a list of Event to wait upon before executing the command
    # * +:origin+ - if provided indicates the origin of the region to fill inside the Image, else [0, 0, 0]
    # * +:region+ - if provided indicates the dimension of the region to fill, else the maximum region is filled
    #
    # ==== Returns
    #
    # the Event associated with the command
    def enqueue_fill_image( image, fill_color, options = {} )
      return OpenCL.enqueue_fill_image( self, image, fill_color, options )
    end

    # Enqueues a command to fill a Buffer with the given pattern using the CommandQueue
    #
    # ==== Attributes
    # 
    # * +buffer+ - a Buffer object to be filled
    # * +pattern+ - the Pointer (or convertible to Pointer using to_ptr) to the memory area where the pattern is stored
    # * +options+ - a hash containing named options
    #
    # ==== Options
    #
    # * +:event_wait_list+ - if provided, a list of Event to wait upon before executing the command
    # * +:offset+ - if provided indicates the offset inside the Buffer of the area to be filled, else 0
    # * +:size+ - if provided indicates the size of data to fill, else the maximum size is filled
    # * +:pattern_size+ - if provided indicates the size of the pattern, else the maximum pattern data is used
    #
    # ==== Returns
    #
    # the Event associated with the command
    def enqueue_fill_buffer( buffer, pattern, options = {} )
      return OpenCL.enqueue_fill_buffer( self, buffer, pattern, options )
    end

    # Acquire OpenCL Mem objects that have been created from OpenGL objects using the CommandQueue
    #
    # ==== Attributes
    # 
    # * +mem_objects+ - a single or an Array of Mem objects
    # * +options+ - a hash containing named options
    #
    # ==== Options
    #
    # * +:event_wait_list+ - if provided, a list of Event to wait upon before executing the command
    #
    # ==== Returns
    #
    # the Event associated with the command
    def enqueue_acquire_GL_objects( mem_objects, options = {} )
      return OpenCL.enqueue_acquire_GL_objects( self, mem_objects, options )
    end
    alias :enqueue_acquire_gl_objects :enqueue_acquire_GL_objects

    # Release OpenCL Mem objects that have been created from OpenGL objects and previously acquired using the CommandQueue
    #
    # ==== Attributes
    # 
    # * +mem_objects+ - a single or an Array of Mem objects
    # * +options+ - a hash containing named options
    #
    # ==== Options
    #
    # * +:event_wait_list+ - if provided, a list of Event to wait upon before executing the command
    #
    # ==== Returns
    #
    # the Event associated with the command
    def enqueue_release_GL_objects( mem_objects, options = {} )
      return OpenCL.enqueue_release_GL_objects( self, mem_objects, options )
    end
    alias :enqueue_release_gl_objects :enqueue_release_GL_objects

    # Enqueues a command to map a Buffer into host memory using the CommandQueue
    #
    # ==== Attributes
    # 
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
    def enqueue_map_buffer( buffer, map_flags, options = {} )
      return OpenCL.enqueue_map_buffer( self, buffer, map_flags, options )
    end

    # Enqueues a command to map an Image into host memory using the CommandQueue
    #
    # ==== Attributes
    # 
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
    def enqueue_map_image( image, map_flags, options = {} )
      return OpenCL.enqueue_map_image( self, image, map_flags, options )
    end

    # Enqueues a command to unmap a previously mapped region of a memory object using the CommandQueue
    #
    # ==== Attributes
    # 
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
    def enqueue_unmap_mem_object( command_queue, mem_obj, mapped_ptr, options = {} )
      return OpenCL.enqueue_unmap_mem_object( self, mem_obj, mapped_ptr, options )
    end

    # Enqueues a command to indicate which device a set of memory objects should be migrated to using the CommandQueue
    #
    # ==== Attributes
    # 
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
    def enqueue_migrate_mem_objects( mem_objects, options = {} )
      return OpenCL.enqueue_migrate_mem_objects( self, mem_objects, options )
    end

    # Enqueues a native kernel in the CommandQueue
    #
    # ==== Attributes
    # 
    # * +options+ - a hash containing named options
    # * +func+ - a Proc object to execute
    #
    # ==== Options
    #
    # * +:args+ - if provided, a list of arguments to pass to the kernel. Arguments should have a size method and be convertible to Pointer with to_ptr
    # * +:mem_list+ - if provided, a hash containing Buffer objects and their index inside the argument list.
    # * +:event_wait_list+ - if provided, a list of Event to wait upon before executing the command
    #
    # ==== Returns
    #
    # the Event associated with the command
    def enqueue_native_kernel( options = {}, &func )
      return OpenCL.enqueue_native_kernel( self, options, &func )
    end

    # Blocks until all the commands in the CommandQueue have completed
    def finish
      return OpenCL.finish(self)
    end

    # Issues all the commands in a CommandQueue to the Device
    def flush
      return OpenCL.flush( self )
    end

    # Enqueues a command to copy from or to an SVMPointer using the CommandQueue
    #
    # ==== Attributes
    # 
    # * +dst_ptr+ - the Pointer (or convertible to Pointer using to_ptr) or SVMPointer to be written to
    # * +src_ptr+ - the Pointer (or convertible to Pointer using to_ptr) or SVMPointer to be read from
    # * +size+ - the size of data to copy
    # * +options+ - a hash containing named options
    #
    # ==== Options
    #
    # * +:event_wait_list+ - if provided, a list of Event to wait upon before executing the command
    # * +:blocking_copy+ - if provided indicates if the command blocks until the copy finishes
    # * +:blocking+ - if provided indicates if the command blocks until the copy finishes
    #
    # ==== Returns
    #
    # the Event associated with the command
    def enqueue_svm_memcpy( dst_ptr, src_ptr, size, options = {})
      return OpenCL.enqueue_svm_memcpy(self, dst_ptr, src_ptr, size, options)
    end

    # Enqueues a command that frees SVMPointers (or Pointers using a callback) using the CommandQueue
    #
    # ==== Attributes
    # 
    # * +svm_pointer+ - a single or an Array of SVMPointer (or Pointer)
    # * +options+ - a hash containing named options
    # * +block+ - if provided, a callback invoked to free the pointers. Signature of the callback is { |CommandQueue, num_pointers, FFI::Pointer to an array of num_pointers Pointers, FFI::Pointer to user_data| ... }
    #
    # ==== Options
    #
    # * +:event_wait_list+ - if provided, a list of Event to wait upon before executing the command
    # * +:user_data+ - if provided, a Pointer (or convertible to using to_ptr) that will be passed to the callback
    #
    # ==== Returns
    #
    # the Event associated with the command
    def enqueue_svm_free(svm_pointers, options = {}, &block)
      return OpenCL.enqueue_svm_free(self, svm_pointers, options, &block)
    end

    # Enqueues a command to fill a an SVM memory area using the CommandQueue
    #
    # ==== Attributes
    #
    # * +svm_ptr+ - the SVMPointer to the area to fill
    # * +pattern+ - the Pointer (or convertible to Pointer using to_ptr) to the memory area where the pattern is stored
    # * +size+ - the size of the area to fill
    #
    # ==== Options
    #
    # * +:event_wait_list+ - if provided, a list of Event to wait upon before executing the command
    # * +:pattern_size+ - if provided indicates the size of the pattern, else the maximum pattern data is used
    #
    # ==== Returns
    #
    # the Event associated with the command
    def enqueue_svm_mem_fill(command_queue, svm_ptr, pattern, size, options = {})
      return OpenCL.enqueue_svm_mem_fill(self, svm_ptr, pattern, size, options)
    end

    # Enqueues a command to map an Image into host memory using the CommandQueue
    #
    # ==== Attributes
    # 
    # * +svm_ptr+ - the SVMPointer to the area to map
    # * +size+ - the size of the region to map
    # * +map_flags+ - a single or an Array of :cl_map_flags flags
    # * +options+ - a hash containing named options
    #
    # ==== Options
    #
    # * +:event_wait_list+ - if provided, a list of Event to wait upon before executing the command
    # * +:blocking_map+ - if provided indicates if the command blocks until the region is mapped
    # * +:blocking+ - if provided indicates if the command blocks until the region is mapped
    #
    # ==== Returns
    #
    # the Event associated with the command
    def enqueue_svm_map( svm_ptr, size, map_flags, options = {} )
      return OpenCL.enqueue_svm_map( self, svm_ptr, size, map_flags, options )
    end
  
    # Enqueues a command to unmap a previously mapped SVM memory area using the CommandQueue
    #
    # ==== Attributes
    # 
    # * +svm_ptr+ - the SVMPointer of the area to be unmapped
    # * +options+ - a hash containing named options
    #
    # ==== Options
    #
    # * +:event_wait_list+ - if provided, a list of Event to wait upon before executing the command
    #
    # ==== Returns
    #
    # the Event associated with the command
    def enqueue_svm_unmap( svm_ptr, options = {} )
      return OpenCL.enqueue_svm_unmap( self, svm_ptr, options )
    end

  end

end

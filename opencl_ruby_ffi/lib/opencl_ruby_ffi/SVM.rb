module OpenCL

  # maps the SVM pointer type
  class SVMPointer < FFI::Pointer

    # create a new SVMPointer from its address and the context it pertains to
    def initialize( address, context, size, base = nil )
      super( address )
      @context = context
      if base then
        @base = base
      else
        @base = address
      end
      @size = size
    end

    # creates a new SVMPointer relative to an existing one from an offset
    def +( offset )
      return SVMPointer::new(  self.address + offset, @context, @size, @base )
    end

    # frees the parent memory region associated to this SVMPointer
    def free
      return OpenCL::svm_free( @context, @base )
    end

  end


  # Creates an SVMPointer pointing to an SVM area of memory
  #
  # ==== Attributes
  #
  # * +context+ - the Context in which to allocate the memory
  # * +size+ - the size of the mmemory area to allocate
  # * +options+ - a hash containing named options
  #
  # ==== Options
  #
  # * +:alignment+ - imposes the minimum alignment in byte
  def self.svm_alloc(context, size, options = {})
    error_check(INVALID_OPERATION) if context.platform.version_number < 2.0
    flags = get_flags(options)
    alignment = 0
    alignment = options[:alignment] if options[:alignment]
    ptr = clSVMAlloc( context, flags, size, alignment )
    error_check(MEM_OBJECT_ALLOCATION_FAILURE) if ptr.null?
    return SVMPointer::new( ptr, context, size )
  end

  # Frees an SVMPointer
  #
  # ==== Attributes
  #
  # * +context+ - the Context in which to deallocate the memory
  # * +svm_pointer+ - the SVMPointer to deallocate
  def self.svm_free(context, svm_pointer)
    error_check(INVALID_OPERATION) if context.platform.version_number < 2.0
    return clSVMFree( context, svm_pointer )
  end

  # Set the index th argument of Kernel to value. Value must be within a SVM memory area
  def self.set_kernel_arg_svm_pointer( kernel, index, value )
    error_check(INVALID_OPERATION) if kernel.context.platform.version_number < 2.0
    error = clSetKernelArgSVMPointer( kernel, index, val )
    error_check(error)
    return kernel
  end

  # Enqueues a command that frees SVMPointers (or Pointers using a callback)
  #
  # ==== Attributes
  # 
  # * +command_queue+ - CommandQueue used to execute the write command
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
  def self.enqueue_svm_free(command_queue, svm_pointers, options = {}, &block)
    pointers = [svm_pointers].flatten
    num_pointers = pointers.length
    ptr = FFI::MemoryPointer::new( :pointer, num_pointers)
    pointers.each_with_index { |p, indx|
      ptr[indx].write_pointer(p)
    }
    num_events, events = get_event_wait_list( options )
    event = FFI::MemoryPointer::new( Event )
    error = clEnqueueSVMFree(command_queue, num_pointers, ptr, block, options[:user_data], num_events, events, event)
    error_check(error)
    return Event::new(event.read_pointer, false)
  end

  # Enqueues a command to copy from or to an SVMPointer
  #
  # ==== Attributes
  # 
  # * +command_queue+ - CommandQueue used to execute the write command
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
  def self.enqueue_svm_memcpy(command_queue, dst_ptr, src_ptr, size, options = {})
    error_check(INVALID_OPERATION) if command_queue.context.platform.version_number < 2.0
    blocking = FALSE
    blocking = TRUE if options[:blocking] or options[:blocking_copy]
    num_events, events = get_event_wait_list( options )
    event = FFI::MemoryPointer::new( Event )
    error = clEnqueueSVMMemcpy(command_queue, blocking, dst_ptr, src_ptr, size, num_events, events, event)
    error_check(error)
    return Event::new(event.read_pointer, false)
  end

  # Enqueues a command to fill a an SVM memory area
  #
  # ==== Attributes
  #
  # * +command_queue+ - CommandQueue used to execute the write command
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
  def self.enqueue_svm_mem_fill(command_queue, svm_ptr, pattern, size, options = {})
    num_events, events = get_event_wait_list( options )
    pattern_size = pattern.size
    pattern_size = options[:pattern_size] if options[:pattern_size]
    event = FFI::MemoryPointer::new( Event )
    error = clEnqueueSVMMemFill(command_queue, svm_ptr, pattern, pattern_size, size, num_events, events, event)
    error_check(error)
    return Event::new(event.read_pointer, false)
  end

  # Enqueues a command to map an Image into host memory
  #
  # ==== Attributes
  # 
  # * +command_queue+ - CommandQueue used to execute the map command
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
  def self.enqueue_svm_map( command_queue, svm_ptr, size, map_flags, options = {} )
    blocking = FALSE
    blocking = TRUE if options[:blocking] or options[:blocking_map]
    flags = get_flags( {:flags => map_flags} )
    num_events, events = get_event_wait_list( options )
    event = FFI::MemoryPointer::new( Event )
    error = clEnqueueSVMMap( command_queue, blocking, flags, svm_ptr, size, num_events, events, event )
    error_check( error.read_cl_int )
    return Event::new( event.read_ptr, false )
  end

  # Enqueues a command to unmap a previously mapped SVM memory area
  #
  # ==== Attributes
  # 
  # * +command_queue+ - CommandQueue used to execute the unmap command
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
  def self.enqueue_svm_unmap( command_queue, svm_ptr, options = {} )
    num_events, events = get_event_wait_list( options )
    event = FFI::MemoryPointer::new( Event )
    error = clEnqueueSVMUnmap( command_queue, svm_ptr, num_events, events, event )
    error_check( error )
    return Event::new( event.read_ptr, false )
  end

end

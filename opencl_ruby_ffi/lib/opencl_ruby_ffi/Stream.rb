module OpenCL

  module StreamDSL

    class Stream

      def initialize(queue)
        @queue = queue
        @tail_events = nil
      end

      def <<(commands)
        events = []
        [commands].flatten.each { |c|
          events.push ( c.enqueue( queue, @tail_events ) )
        }
        @tail_events = events
        return self
      end

    end

    class Command

      def initialize(type, options = {})
        @_type = type
        @_options = options
        @_event = nil
        @_func = nil
        @_params = []
      end

      def enqueue(queue, event_wait_list = nil)
        if options and options[:event_wait_list] then
          @_event_wait_list = [options[:event_wait_list]].flatten
        else
          @_event_wait_list = nil
        end
        if event_wait_list then
          if @_event_wait_list then
            @_event_wait_list = @_event_wait_list + [event_wait_list].flatten
          else
            @_event_wait_list = [event_wait_list].flatten
          end
        end
        opts = @_options.dup
        opts[:event_wait_list] = @_event_wait_list
        @_event, @_result = @_enqueue_proc.call( queue, *@_param, opts, &@f_unc )
      end

      def result
        return @_result
      end

    end

    def self.command_constructor( name, const, function, params)
      params_array = params + ["options = {}"]
      params_array += ["&func"]
      p_variables = params.collect { |p| "@_params.push(@#{p})" }
      return <<EOF
    class #{name} < Command

      def initialize( #{params_array.join(", ")}, &func )
        super(CommandType::#{const}, options)
        #{i_variables.join("\n        ")}
        @_func = func
        @_enqueue_proc = OpenCL.method(:enqueue_#{function})
      end

    end
EOF
    end

    eval command_constructor( :NDRangeKernel, :NDRANGE_KERNEL, :ndrange_kernel, [ :buffer, :global_work_size ] )
    eval command_constructor( :Task, :TASK, :task, [ :kernel ] )
    eval command_constructor( :NativeKernel, :NATIVE_KERNEL, :native_kernel, [] )
    eval command_constructor( :ReadBuffer, :READ_BUFFER, :read_buffer, [ :buffer, :ptr ] )
    eval command_constructor( :WriteBuffer, :WRITE_BUFFER, :write_buffer, [ :buffer, :ptr ] )
    eval command_constructor( :CopyBuffer, :COPY_BUFFER, :copy_buffer, [ :src_buffer, :dst_buffer ] )
    eval command_constructor( :ReadImage, :READ_IMAGE, :read_image, [ :image, :ptr ] )
    eval command_constructor( :WriteImage, :WRITE_IMAGE, :write_image, [ :image, :ptr ] )
    eval command_constructor( :CopyImage, :COPY_IMAGE, :copy_image, [ :src_image, :dst_image ] )
    eval command_constructor( :CopyImageToBuffer, :COPY_IMAGE_TO_BUFFER, :copy_image_to_buffer, [ :src_image, :dst_buffer ] )
    eval command_constructor( :CopyBufferToImage, :COPY_BUFFER_TO_IMAGE, :copy_buffer_to_image, [ :src_buffer, :dst_image ] )
    eval command_constructor( :MapBuffer, :MAP_BUFFER, :map_buffer, [ :buffer, :map_flags ] )
    eval command_constructor( :MapImage, :MAP_IMAGE, :map_image, [ :image, :map_flags ] )
    eval command_constructor( :UnmapMemObject, :UNMAP_MEM_OBJECT, :unmap_mem_object, [ :mem_obj, :mapped_ptr ] )

    class Marker < Command

      def initialize( events = [] )
        super(CommandType::MARKER, nil)
        @events = events
        @_enqueue_proc = OpenCL.method(:enqueue_marker)
      end

    end

    eval command_constructor( :AcquireGLObjects, :ACQUIRE_GL_OBJECTS, :acquire_GL_objects, [ :mem_objects ] )
    eval command_constructor( :ReleaseGLObjects, :RELEASE_GL_OBJECTS, :release_GL_objects, [ :mem_objects ] )
    eval command_constructor( :ReadBufferRect, :READ_BUFFER_RECT, :read_buffer_rect, [ :buffer, :ptr, :region ] )
    eval command_constructor( :WriteBufferRect, :WRITE_BUFFER_RECT, :write_buffer_rect, [ :buffer, :ptr, :region ] )
    eval command_constructor( :CopyBufferRect, :COPY_BUFFER_RECT, :copy_buffer_rect, [ :src_buffer, :dst_buffer, :region ] )

    class Barrier < Command

      def initialize( events = [] )
        super(CommandType::BARRIER, nil)
        @events = events
        @_enqueue_proc = OpenCL.method(:enqueue_barrier)
      end

    end

    eval command_constructor( :FillBuffer, :FILL_BUFFER, :fill_buffer, [ :buffer, :pattern ] )
    eval command_constructor( :FillImage, :FILL_IMAGE, :fill_image, [ :image, :fill_color ] )
    eval command_constructor( :SVMFree, :SVM_FREE, :svm_free, [ :svm_pointers ] )
    eval command_constructor( :SVMMemcpy, :SVM_MEMCPY, :svm_memcpy, [ :dst_ptr, :src_ptr, :size ] )
    eval command_constructor( :SVMMemFill, :SVM_MEMFILL, :svm_memfill, [ :svm_ptr, :pattern, :size ] )
    eval command_constructor( :SVMMap, :SVM_MAP, :svm_map, [ :svm_ptr, :size, :map_flags ] )
    eval command_constructor( :SVMUnmap, :SVM_UNMAP, :svm_unmap, [ :svm_ptr ] )

  end
  
end

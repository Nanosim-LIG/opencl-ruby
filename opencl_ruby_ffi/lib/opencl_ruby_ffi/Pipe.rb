module OpenCL

  # Creates a Pipe
  #
  # ==== Attributes
  #
  # * +context+ - Context the created Pipe will be associated to
  # * +pipe_packet_size+ - size of a packet in the Pipe
  # * +pipe_max_packets+ - size of the Pipe in packet
  #
  # ==== Options
  # 
  # * +:flags+ - a single or an Array of :cl_mem_flags specifying the flags to be used when creating the Pipe
  def self.create_pipe( context, pipe_packet_size, pipe_max_packets, options = {} )
    error_check(INVALID_OPERATION) if self.context.platform.version_number < 2.0
    flags = get_flags( options )
    error = FFI::MemoryPointer::new( :cl_int )
    pipe_ptr = clCreatePipe( context, flags, pipe_packet_size, pipe_max_packets, nil, error)
    error_check(error.read_cl_int)
    return Pipe::new(pipe_ptr, false)
  end

  # Maps the cl_mem OpenCL objects of type CL_MEM_OBJECT_PIPE
  class Pipe #< Mem
    include InnerInterface

    class << self
      include InnerGenerator
    end
    
    ##
    # :method: packet_size
    # Returns the packet_size of the Pipe

    ##
    # :method: max_packets
    # Returns the max_packets of the Pipe
    %w( PACKET_SIZE MAX_PACKETS ).each { |prop|
      eval get_info("Pipe", :cl_uint, prop)
    }

  end

end

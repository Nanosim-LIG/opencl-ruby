using OpenCLRefinements if RUBY_VERSION.scan(/\d+/).collect(&:to_i).first >= 2
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
    error = MemoryPointer::new( :cl_int )
    pipe_ptr = clCreatePipe( context, flags, pipe_packet_size, pipe_max_packets, nil, error)
    error_check(error.read_cl_int)
    return Pipe::new(pipe_ptr, false)
  end

  # Maps the cl_mem OpenCL objects of type CL_MEM_OBJECT_PIPE
  class Pipe #< Mem
    include InnerInterface
    extend InnerGenerator

    def inspect
      f = flags
      return "#<#{self.class.inspect}: #{packet_size}x#{max_packets}#{ 0 != f.to_i ? " (#{f})" : ""}>"
    end

    get_info("Pipe", :cl_uint, "packet_size")
    get_info("Pipe", :cl_uint, "max_packets")

  end

end

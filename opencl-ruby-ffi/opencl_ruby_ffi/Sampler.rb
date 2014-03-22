module OpenCL

  # Creates a Sampler
  #
  # ==== Attributes
  #
  # * +context+ - Context the created Sampler will be associated to
  # * +normalized_coords+ - a :cl_bool specifying if the image coordinates are normalized
  # * +addressing_mode+ - a :cl_addressing_mode specifying how out-of-range image coordinates are handled when reading from an image
  # * +filter_mode+ - a :cl_filter_mode specifying the type of filter that must be applied when reading an image
  def self.create_sampler( context, normalized_coords, addressing_mode, filter_mode )
    error = FFI::MemoryPointer::new( :cl_int )
    sampler_ptr = OpenCL.clCreateSampler( context, normalized_coords, addressing_mode, filter_mode, error )
    OpenCL.error_check(error.read_cl_int)
    OpenCL::Sampler::new(sampler_ptr, false)
  end

  class Sampler

    def context
      ptr = FFI::MemoryPointer.new( Context )
      error = OpenCL.clGetSamplerInfo(self, Sampler::CONTEXT, Context.size, ptr, nil)
      OpenCL.error_check(error)
      return OpenCL::Context::new( ptr.read_pointer )
    end

    eval OpenCL.get_info("Sampler", :cl_uint, "REFERENCE_COUNT")

    eval OpenCL.get_info("Sampler", :cl_bool, "NORMALIZED_COORDS")

    eval OpenCL.get_info("Sampler", :cl_addressing_mode, "ADDRESSING_MODE")

    eval OpenCL.get_info("Sampler", :cl_filter_mode, "FILTER_MODE")

  end

end

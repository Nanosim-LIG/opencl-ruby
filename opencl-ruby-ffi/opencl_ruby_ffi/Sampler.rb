module OpenCL
  def OpenCL.create_sampler( context, normalized_coords, addressing_mode, filter_mode )
    error = FFI::MemoryPointer::new( :cl_int )
    sampler_ptr = OpenCL.clCreateSampler( context, normalized_coords, addressing_mode, filter_mode, error )
    OpenCL.error_check(error.read_cl_int)
    OpenCL::Sampler::new(sampler_ptr)
  end
end

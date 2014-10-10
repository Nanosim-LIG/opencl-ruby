module OpenCL

  # Creates a Sampler
  #
  # ==== Attributes
  #
  # * +context+ - Context the created Sampler will be associated to
  #
  # ==== Options
  #
  # * +:normalized_coords+ - a :cl_bool specifying if the image coordinates are normalized
  # * +:addressing_mode+ - a :cl_addressing_mode specifying how out-of-range image coordinates are handled when reading from an image
  # * +:filter_mode+ - a :cl_filter_mode specifying the type of filter that must be applied when reading an image
  # * +:mip_filter_mode+ - the filtering mode to use if using mimaps (default CL_FILTER_NONE, requires cl_khr_mipmap_image)
  # * +:lod_min+ - floating point value representing the minimal LOD (default 0.0f, requires cl_khr_mipmap_image)
  # * +:lod_max+ - floating point value representing the maximal LOD (default MAXFLOAT, requires cl_khr_mipmap_image)
  def self.create_sampler( context, options = {} )
    normalized_coords = TRUE
    normalized_coords = options[:normalized_coords] if options[:normalized_coords]
    addressing_mode = AddressingMode::CLAMP
    addressing_mode = options[:addressing_mode] if options[:addressing_mode]
    filter_mode = FilterMode::NEAREST
    filter_mode = options[:filter_mode] if options[:filter_mode]
    error = FFI::MemoryPointer::new( :cl_int )
    if context.platform.version_number < 2.0 then
      sampler_ptr = clCreateSampler( context, normalized_coords, addressing_mode, filter_mode, error )
    else
      prop_size = 7
      prop_size += 2 if options[:mip_filter_mode]
      prop_size += 2 if options[:lod_min]
      prop_size += 2 if options[:lod_max]
      properties = FFI::MemoryPointer::new( :cl_sampler_properties)
      properties[0].write_cl_sampler_properties( Sampler::NORMALIZED_COORDS )
      properties[1].write_cl_sampler_properties( normalized_coords )
      properties[2].write_cl_sampler_properties( Sampler::ADDRESSING_MODE )
      properties[3].write_cl_sampler_properties( addressing_mode )
      properties[4].write_cl_sampler_properties( Sampler::FILTER_MODE )
      properties[5].write_cl_sampler_properties( filter_mode )
      prop_indx = 6
      if options[:mip_filter_mode] then
        properties[prop_indx].write_cl_sampler_properties( Sampler::MIP_FILTER_MODE )
        properties[prop_indx+1].write_cl_sampler_properties( options[:mip_filter_mode] )
        prop_indx += 2
      end
      if options[:lod_min] then
        properties[prop_indx].write_cl_sampler_properties( Sampler::LOD_MIN )
        properties[prop_indx+1].write_float( options[:lod_min] )
        prop_indx += 2
      end
      if options[:lod_max] then
        properties[prop_indx].write_cl_sampler_properties( Sampler::LOD_MAX )
        properties[prop_indx+1].write_float( options[:lod_max] )
        prop_indx += 2
      end
      properties[prop_indx].write_cl_sampler_properties( 0 )
      sampler_ptr = clCreateSamplerWithProperties( context, properties, error )
    end
    error_check(error.read_cl_int)
    Sampler::new(sampler_ptr, false)
  end

  # Maps the cl_smapler object of OpenCL
  class Sampler
    include InnerInterface

    class << self
      include InnerGenerator
    end

    # Returns the context associated with the Sampler
    def context
      ptr = FFI::MemoryPointer::new( Context )
      error = OpenCL.clGetSamplerInfo(self, CONTEXT, Context.size, ptr, nil)
      error_check(error)
      return Context::new( ptr.read_pointer )
    end

    ##
    # :method: reference_count()
    # returns the reference counter of the Sampler
    eval get_info("Sampler", :cl_uint, "REFERENCE_COUNT")

    ##
    # :method: normalized_coords()
    # returns if the Sampler uses normalized coords
    eval get_info("Sampler", :cl_bool, "NORMALIZED_COORDS")

    ##
    # :method: addressing_mode()
    # returns an AddressingMode representing the addressing mode used by the Sampler
    eval get_info("Sampler", :cl_addressing_mode, "ADDRESSING_MODE")

    ##
    # :method: filter_mode()
    # returns a FilterMode representing the filtering mode used by the Sampler
    eval get_info("Sampler", :cl_filter_mode, "FILTER_MODE")

  end

end

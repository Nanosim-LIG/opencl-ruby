require "opencl"

platforms = OpenCL::Platform.get_platforms
platforms.each_with_index do |platform,j|
  print "Platform#{j}\n"
  %w(profile version name vendor extensions).each do |qn|
    print "  #{qn}: #{platform.send(qn).inspect}\n"
  end
  devices = OpenCL::Device.get_devices(platform, OpenCL::Device::TYPE_ALL)
  devices.each_with_index do |device,i|
    print "  Device#{i}\n"
    %w(type_names single_fp_config_names execution_capability_names queue_property_names global_mem_cache_type_name local_mem_type_name max_work_item_sizes vendor_id max_compute_units max_work_item_dimensions preferred_vector_width_char preferred_vector_width_short preferred_vector_width_long preferred_vector_width_float preferred_vector_width_double max_clock_frequency address_bits max_read_image_args max_write_image_args max_samplers mem_base_addr_align min_data_type_align_size global_mem_cacheline_size max_constant_args max_mem_alloc_size global_mem_cache_size global_mem_size max_constant_buffer_size local_mem_size image_support error_correction_support endian_little available compiler_available name vendor profile version extensions max_work_group_size image2D_max_width image2D_max_height image3D_max_width image3D_max_height image3D_max_depth max_parameter_size profiling_timer_resolution).each do |qn|
      print "    #{qn}: #{device.send(qn).inspect}\n"
    end
  end
end

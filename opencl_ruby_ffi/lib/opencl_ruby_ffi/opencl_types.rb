require 'ffi'

module OpenCL
  include FFI
  extend Library

  TYPES = [
    [ :int8, :cl_char ],
    [ :uint8, :cl_uchar ],
    [ :int16, :cl_short ],
    [ :uint16, :cl_ushort ],
    [ :int32, :cl_int ],
    [ :uint32, :cl_uint ],
    [ :int64, :cl_long ],
    [ :uint64, :cl_ulong ],
    [ :uint16, :cl_half ],
    [ :float, :cl_float ],
    [ :double, :cl_double ],
    [ :uint32, :cl_GLuint ],
    [ :int32, :cl_GLint ],
    [ :uint32, :cl_GLenum ],
    [ :cl_uint, :cl_bool ],
    [ :cl_ulong, :cl_bitfield ],
    [ :cl_bitfield, :cl_device_type ],
    [ :cl_uint, :cl_platform_info ],
    [ :cl_uint, :cl_device_info ],
    [ :cl_bitfield, :cl_device_fp_config ],
    [ :cl_uint, :cl_device_mem_cache_type ],
    [ :cl_uint, :cl_device_local_mem_type ],
    [ :cl_bitfield, :cl_device_exec_capabilities ],
    [ :cl_bitfield, :cl_device_svm_capabilities ],
    [ :cl_bitfield, :cl_command_queue_properties ],
    [ :pointer, :cl_device_partition_property ],
    [ :cl_bitfield, :cl_device_affinity_domain ],
    [ :pointer, :cl_context_properties ],
    [ :cl_uint, :cl_context_info ],
    [ :cl_bitfield, :cl_queue_properties ],
    [ :cl_uint, :cl_command_queue_info ],
    [ :cl_uint, :cl_channel_order ],
    [ :cl_uint, :cl_channel_type ],
    [ :cl_bitfield, :cl_mem_flags ],
    [ :cl_bitfield, :cl_svm_mem_flags ],
    [ :cl_uint, :cl_mem_object_type ],
    [ :cl_uint, :cl_mem_info ],
    [ :cl_bitfield, :cl_mem_migration_flags ],
    [ :cl_uint, :cl_image_info ],
    [ :cl_uint, :cl_buffer_create_type ],
    [ :cl_uint, :cl_addressing_mode ],
    [ :cl_uint, :cl_filter_mode ],
    [ :cl_uint, :cl_sampler_info ],
    [ :cl_bitfield, :cl_map_flags ],
    [ :pointer, :cl_pipe_properties ],
    [ :cl_uint, :cl_pipe_info ],
    [ :cl_uint, :cl_program_info ],
    [ :cl_uint, :cl_program_build_info ],
    [ :cl_uint, :cl_program_binary_type ],
    [ :cl_int, :cl_build_status ],
    [ :cl_uint, :cl_kernel_info ],
    [ :cl_uint, :cl_kernel_arg_info ],
    [ :cl_uint, :cl_kernel_arg_address_qualifier ],
    [ :cl_uint, :cl_kernel_arg_access_qualifier ],
    [ :cl_bitfield, :cl_kernel_arg_type_qualifier ],
    [ :cl_uint, :cl_kernel_work_group_info ],
    [ :cl_uint, :cl_kernel_sub_group_info ],
    [ :cl_uint, :cl_event_info ],
    [ :cl_uint, :cl_command_type ],
    [ :cl_uint, :cl_profiling_info ],
    [ :cl_bitfield, :cl_sampler_properties ],
    [ :cl_uint, :cl_kernel_exec_info ],
    [ :cl_uint, :cl_gl_object_type ],
    [ :cl_uint, :cl_gl_texture_info ],
    [ :cl_uint, :cl_gl_platform_info ],
    [ :cl_uint, :cl_gl_context_info ],
    [ :cl_uint, :cl_queue_priority_khr ],
    [ :cl_uint, :cl_queue_throttle_khr ],
    [ :cl_bitfield, :cl_device_partition_property_ext ],
    [ :cl_device_partition_property_ext, :cl_device_affinity_domain_ext ],
    [ :pointer, :cl_egl_display_khr ],
    [ :pointer, :cl_egl_image_khr ],
    [ :pointer, :cl_egl_sync_khr ],
    [ :cl_uint, :cl_d3d10_device_source_khr ],
    [ :cl_uint, :cl_d3d10_device_set_khr ],
    [ :cl_uint, :cl_d3d11_device_source_khr ],
    [ :cl_uint, :cl_d3d11_device_set_khr ],
    [ :cl_uint, :cl_dx9_media_adapter_type_khr ],
    [ :cl_uint, :cl_dx9_media_adapter_set_khr ]
  ]
  
  TYPES.each { |orig, add|
    typedef orig, add
  }
  TYPES.push [ FFI::TypeDefs.find { |name,t| t == FFI.find_type(:size_t) }.first, :size_t]
end

if RUBY_VERSION.scan(/\d+/).collect(&:to_i).first >= 2

  module OpenCLRefinements

    refine FFI::Pointer do
      methods_prefix = [:put, :get, :write, :read, :put_array_of, :get_array_of]
      OpenCL::TYPES.each { |orig, add|
        methods_prefix.each { |meth|
          alias_method "#{meth}_#{add}".to_sym, "#{meth}_#{orig}".to_sym
        }
      }
    end

  end
  using OpenCLRefinements
else

  class FFI::Pointer
    methods_prefix = [:put, :get, :write, :read, :put_array_of, :get_array_of]
    OpenCL::TYPES.each { |orig, add|
      methods_prefix.each { |meth|
        alias_method "#{meth}_#{add}".to_sym, "#{meth}_#{orig}".to_sym
      }
    }
  end

end

module OpenCL
  remove_const(:TYPES)
end

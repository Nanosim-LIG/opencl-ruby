require 'opencl_ruby_ffi'
using OpenCLRefinements if RUBY_VERSION.scan(/\d+/).collect(&:to_i).first >= 2

module OpenCL

  KERNEL_MAX_SUB_GROUP_SIZE_FOR_NDRANGE_KHR = 0x2033
  KERNEL_SUB_GROUP_COUNT_FOR_NDRANGE_KHR = 0x2034

  attach_extension_function( "clGetKernelSubGroupInfoKHR", :cl_int, [Kernel, Device, :size_t, :pointer, :size_t, :pointer, :pointer] )

  class Kernel
    MAX_SUB_GROUP_SIZE_FOR_NDRANGE_KHR = 0x2033
    SUB_GROUP_COUNT_FOR_NDRANGE_KHR = 0x2034

    module KHRSubGroups

      def max_sub_group_size_for_ndrange_khr(local_work_size, device = program.devices.first)
        error_check(INVALID_OPERATION) unless device.extensions.include?( "cl_khr_sub_groups" )
        local_work_size = [local_work_size].flatten
        lws_p = MemoryPointer::new( :size_t, local_work_size.length )
        local_work_size.each_with_index { |e,i|
          lws_p[i].write_size_t( e )
        }
        ptr = MemoryPointer::new( :size_t )
        error = OpenCL.clGetKernelSubGroupInfoKHR(self, device, MAX_SUB_GROUP_SIZE_FOR_NDRANGE_KHR, lws_p.size, lws_p, ptr.size, ptr, nil)
        error_check(error)
        return ptr.read_size_t
      end

      def sub_groups_count_for_ndrange_khr(local_work_size, device = program.devices.first)
        error_check(INVALID_OPERATION) unless device.extensions.include?( "cl_khr_sub_groups" )
        local_work_size = [local_work_size].flatten
        lws_p = MemoryPointer::new( :size_t, local_work_size.length )
        local_work_size.each_with_index { |e,i|
          lws_p[i].write_size_t( e )
        }
        ptr = MemoryPointer::new( :size_t )
        error = OpenCL.clGetKernelSubGroupInfoKHR(self, device, SUB_GROUP_COUNT_FOR_NDRANGE_KHR, lws_p.size, lws_p, ptr.size, ptr, nil)
        error_check(error)
        return ptr.read_size_t
      end

    end

    register_extension( :cl_khr_sub_groups, KHRSubGroups, "program.devices.collect(&:extensions).flatten.include?(\"cl_khr_sub_groups\")" )

  end

end

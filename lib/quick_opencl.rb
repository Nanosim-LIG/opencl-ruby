require "opencl"

module OpenCL
  module Quick
    module_function
    def init(type, n=0)
      case type
      when :cpu, "cpu", "CPU"
        type = OpenCL::Device::TYPE_CPU
      when :gpu, "gpu", "GPU"
        type = OpenCL::Device::TYPE_GPU
      end
      @context = OpenCL::Context.create_from_type(type)
      @device = @context.devices[n]
      @cmd_queue = OpenCL::CommandQueue.new(@context, @device, 0)
    end

    def sources=(ary)
      case ary
      when String
        ary = [ary]
      end
      @program = OpenCL::Program.create_with_source(@context, ary)
      @program.build
    end

    @kernels = Hash.new
    def execute_NDRange(kernel_name, args, global_work_size, local_work_size, opts = {})
      wait = opts[:wait] || opts["wait"] || true
      kernel = @kernels[kernel_name] ||= OpenCL::Kernel.new(@program, kernel_name)
      kernel.set_args(args)
      event = @cmd_queue.enqueue_NDrange_kernel(kernel, global_work_size, local_work_size)
      if wait
        event.wait
        return nil
      else
        event
      end
    end

    def execute_task(kernel_name, args, opts = {})
      wait = opts[:wait] || opts["wait"] || true
      kernel = @kernels[kernel_name] ||= OpenCL::Kernel.new(@program, kernel_name)
      kernel.set_args(args)
      event = @cmd_queue.enqueue_task(kernel)
      if wait
        event.wait
        return nil
      else
        event
      end
    end

    def create_buffer(size_or_varray, rw = "rw")
      case rw
      when "r"
        rw = OpenCL::Mem::READ_ONLY
      when "w"
        rw = OpenCL::Mem::WRITE_ONLY
      when "rw"
        rw = OpenCL::Mem::READ_WRITE
      end
      case size_or_varray
      when Numeric
        OpenCL::Buffer.new(@context, rw, :size => size_or_varray)
      when OpenCL::VArray
        OpenCL::Buffer.new(@context, rw | OpenCL::Mem::COPY_HOST_PTR, :host_ptr => size_or_varray)
      else
        raise "invalid argument"
      end
    end

    def read_buffer(buffer, type)
      str, event = @cmd_queue.enqueue_read_buffer(buffer, OpenCL::TRUE)
      OpenCL::VArray.to_va(type, str)
    end

  end
end

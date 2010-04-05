require "opencl"

module OpenCL
  module Quick

    class VArray

      def initialize(type, len, rw="rw")
        @varray = OpenCL::VArray.new(type, len)
        @memobj = OpenCL::Quick.create_buffer(self, rw)
        @change_host = true
        @change_device = false
      end

      def []=(*args)
        @varray.send("[]=", *args)
        @change_host = true
      end

      %w([] + - * / to_na to_s to_a copy).each do |op|
        eval <<-EOF, binding
        def #{op}(*args)
          sync(:device)
          args.each_with_index do |arg,i|
            if OpenCL::Quick::VArray === arg
              args[i] = arg.ary
            end
          end
          @varray.send("#{op}", *args)
        end
        EOF
      end

      def memobj
        @memobj
      end

      def ary
        @varray
      end

      def sync(src=:both)
        if @change_host && @change_device
          raise "BUG: conflict occured"
        end
        if @change_host && (src==:both || src==:host)
          OpenCL::Quick.write_buffer(memobj, self)
          @change_host = false
        end
        if @change_device && (src==:both || src==:device)
          @varray = OpenCL::Quick.read_buffer(memobj, @varray.type_code, @varray.data_size*@varray.length)
          @change_device = false
        end
        self
      end

      def given_to_kernel
        @change_device = true
      end

      def inspect
        sync(:device)
        @varray.inspect.sub(/OpenCL::VArray/, "OpenCL::Quick::VArray")
      end

    end # class VArray


    module_function
    def init(type=nil, n=0)
      case type
      when :cpu, "cpu", "CPU"
        dtype = OpenCL::Device::TYPE_CPU
      when :gpu, "gpu", "GPU"
        dtype = OpenCL::Device::TYPE_GPU
      when :all, "all", "ALL", nil
        dtype = OpenCL::Device::TYPE_ALL
      else
        raise "invalid type was specified"
      end
      platform = OpenCL::Platform.get_platforms[0]
      devices = OpenCL::Device.get_devices(platform, dtype)
      @context = OpenCL::Context.new(nil, devices)
      @device = devices[n]
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
      when OpenCL::Quick::VArray
        OpenCL::Buffer.new(@context, rw | OpenCL::Mem::COPY_HOST_PTR, :host_ptr => size_or_varray.ary)
      else
        raise "invalid argument"
      end
    end

    def read_buffer(buffer, type, cb=nil)
      opts = {}
      opts[:cb] = cb if cb
      str, event = @cmd_queue.enqueue_read_buffer(buffer, OpenCL::TRUE, opts)
      OpenCL::VArray.to_va(type, str)
    end
    def write_buffer(buffer, varray)
      unless OpenCL::Mem === buffer
        raise "the first argument must be OpenCL::Mem"
      end
      if OpenCL::Quick::VArray === varray
        varray = varray.ary
      end
      unless OpenCL::VArray === varray
        raise "the second argument must be OpenCL::VArray"
      end
      @cmd_queue.enqueue_write_buffer(buffer, OpenCL::TRUE, varray)
    end

  end # module Quick

  class Kernel
    def set_args(args)
      args.each_with_index do |arg, i|
        if OpenCL::Quick::VArray === arg
          arg.sync(:host)
          arg.given_to_kernel
          arg = arg.memobj
        end
        self.set_arg(i, arg)
      end
    end
  end # class Kernel

end # module OpenCL

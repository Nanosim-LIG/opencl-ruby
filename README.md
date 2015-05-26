opencl-ruby
===========

Written by Brice Videau, 2013-2014

OpenCL bindings for Ruby

Up to date OpenCL bindings for Ruby. Written using FFI but heavily inspired by Seiya Nishizawa's work on the C bindings.

Two ruby gems can be built from this repository:

- narray_ffi which add the necessary mechanism to NArrays so that they can be used as data buffers with FFI.
- opencl_ruby_ffi which provides the actual bindings.

Documentation can be found here:

http://opencl-ruby.forge.imag.fr/index.html

EXAMPLE:
--------

    require 'opencl_ruby_ffi'

    source = <<EOF
    __kernel void addition( float2 alpha, __global const float *x, __global float *y) {
      size_t ig = get_global_id(0);
      y[ig] = (alpha.s0 + alpha.s1 + x[ig])*0.3333333333333333333f;
    }
    EOF

    platform = OpenCL::platforms.first
    device = platform.devices.first
    context = OpenCL::create_context(device)
    queue = context.create_command_queue(device, :properties => OpenCL::CommandQueue::PROFILING_ENABLE)
    prog = context.create_program_with_source( source )
    prog.build
    a_in = NArray.sfloat(65536).random(1.0)
    a_out = NArray.sfloat(65536)
    f = OpenCL::Float2::new(3.0,2.0)
    b_in = context.create_buffer(a_in.size * a_in.element_size, :flags => OpenCL::Mem::COPY_HOST_PTR, :host_ptr => a_in)
    b_out = context.create_buffer(a_out.size * a_out.element_size)
    event = prog.addition(queue, [65536], f, b_in, b_out, :local_work_size => [128])
    # #Or if you want to be more OpenCL like:
    # k = prog.create_kernel("addition")
    # k.set_arg(0, f)
    # k.set_arg(1, b_in)
    # k.set_arg(2, b_out)
    # event = queue.enqueue_ndrange_kernel(k, [65536],:local_work_size => [128])
    queue.enqueue_read_buffer(b_out, a_out, :event_wait_list => [event])
    queue.finish
    diff = (a_in - a_out*3.0)
    65536.times { |i|
      raise "Computation error #{i} : #{diff[i]+f.s0+f.s1}" if (diff[i]+f.s0+f.s1).abs > 0.00001
    }
    puts "Success!"


require 'opencl_ruby_ffi'
platforms = OpenCL::platforms
source = <<EOF
__kernel void addition(  float2 alpha, __global const float *x, __global float *y) {
  size_t ig = get_global_id(0);
  y[ig] = (alpha.s0 + alpha.s1 + x[ig])*0.3333333333333333333f;
}
__kernel void sub(  float2 alpha, __global const float *x, __global float *y) {
  size_t ig = get_global_id(0);
  y[ig] = (alpha.s0 - alpha.s1 + x[ig])*0.3333333333333333333f;
}
EOF

platforms.each { |platform|
  puts platform.name + ": " + platform.version 
  puts "version number #{platform.version_number.inspect}"
  puts platform.extensions.inspect
  devices = platform.devices
  devices.each { |device|
    puts "  " + device.name
    puts "  #{device.execution_capabilities}"
    puts "  #{device.global_mem_cache_type}"
    puts "  #{device.queue_properties}"
    puts "  #{device.type}"
    puts "  #{device.extensions}"
  }
#  puts platform.create_context_from_type( OpenCL::Device::Type::GPU ).devices.first.name
  context = OpenCL::create_context(devices)
  puts context.num_devices
  puts context.devices.first.name
  puts context.platform.name
  puts OpenCL::Device::FPConfig::new(context.devices.first.double_fp_config).names.inspect
  puts OpenCL::Device::Type::new(context.devices.first.type).names.inspect
  queue = context.create_command_queue(context.devices.first, :properties => OpenCL::CommandQueue::PROFILING_ENABLE)
  puts queue.properties
  a_in = NArray.sfloat(65536).random(1.0)
  a_out = NArray.sfloat(65536)
  puts a_in.size, a_in.element_size
  a_out[0] = 3.0
  a_out[1] = 2.0
  b_in = context.create_buffer(a_in.size * a_in.element_size, :flags => OpenCL::Mem::COPY_HOST_PTR, :host_ptr => a_in)
#  b_in = context.create_buffer(a_out.size * a_out.element_size)
  b_out = context.create_buffer(a_out.size * a_out.element_size)
  b_sub = b_in.create_sub_buffer( OpenCL::BUFFER_CREATE_TYPE_REGION, OpenCL::BufferRegion::new(0, b_in.size / 2 ) )
#  puts context.supported_image_formats( OpenCL::Mem::IMAGE2D ).inspect
  puts b_in.size
  puts b_in.flags
  puts b_in.type
  puts b_sub.size
  puts b_sub.flags
  puts b_sub.type
  prog = context.create_program_with_source( source )
  puts prog.source
  puts prog.binary_sizes
  prog.build( :user_data => a_in.to_ptr ) { |prog, data|
    puts "Finished building #{prog}! (data: #{data.inspect})"
  }
  sleep 1
  puts prog.binary_sizes
  puts prog.binaries
  puts prog.build_status
  puts prog.build_log.inspect
  if prog.context.platform.version_number >= 1.2 then
    puts prog.kernel_names
    prog.kernels.each { |k| puts k.function_name }
  end
  p2, st = OpenCL.create_program_with_binary(context, prog.devices, prog.binaries.collect { |d, b| b } )
  puts st.inspect
#  puts prog.binary_type.inspect
  k = prog.create_kernel("addition")
  puts k.function_name
  f = OpenCL::Float4::new(1,2,3,4)
  puts f.inspect
  puts f[:s2]
  puts f[:s3]
  puts f.alignment
  f = OpenCL::Float2::new(3.0,2.0)
  queue.enqueue_write_buffer(b_in, a_in)
  #k.set_arg(0, a_out, 2*a_out.element_size)
  k.set_arg(0, f)
  k.set_arg(1, b_in)
  k.set_arg(2, b_out)
  e = queue.enqueue_NDrange_kernel(k, [65536],:local_work_size => [128])

  e = prog.addition(queue, [65536], f, b_in, b_out, :local_work_size => [128])
  puts a_out.inspect
  ek = queue.enqueue_read_buffer(b_out, a_out, :event_wait_list => [e])
  #ek.set_callback(OpenCL::CommandExecutionStatus::COMPLETE, :user_data => a_in.to_ptr) { |ev, status, data| puts "Transfer finished! #{ev.to_ptr.inspect}, #{status}, #{data.inspect}" }
  queue.finish
  puts ek.command_execution_status
  puts ek.profiling_command_start
  puts ek.profiling_command_end
  puts a_in.inspect
  puts a_out.inspect
  diff = (a_in - a_out*3.0)
  65536.times { |i|
    raise "Computation error #{i} : #{diff[i]+f.s0+f.s1}" if (diff[i]+f.s0+f.s1).abs > 0.00001
  }
  queue.enqueue_copy_buffer(b_out, b_in)
  ek = queue.enqueue_read_buffer(b_in, a_in)
  queue.finish
  diff = (a_in - a_out)
  65536.times { |i|
    raise "Computation error #{i} : #{diff[i]}" if (diff[i]).abs > 0.00001
  }
}

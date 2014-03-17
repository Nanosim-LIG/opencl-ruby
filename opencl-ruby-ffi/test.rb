require './opencl_ruby_ffi.rb'
platforms = OpenCL::get_platforms
source = <<EOF
__kernel void addition(  float alpha, __global const float *x, __global float *y) {\n\
  size_t ig = get_global_id(0);\n\
  y[ig] = alpha + x[ig];\n\
}
EOF

platforms.each { |platform|
  puts platform.name + ": " + platform.version 
  puts "version number #{platform.version_number.inspect}"
  devices = platform.devices
  devices.each { |device|
    puts "  " + device.name
    puts "  " + device.execution_capabilities_names.inspect
    puts "  " + device.global_mem_cache_type_name.inspect
    puts "  " + device.queue_properties_names.inspect
    puts "  " + device.type_names.inspect
  }
  puts platform.create_context_from_type( OpenCL::Device::TYPE_GPU ).devices.first.name
  context = OpenCL::create_context(devices)
  puts context.num_devices
  puts context.devices.first.name
  puts context.platform.name
  queue = context.create_command_queue(context.devices.first, OpenCL::CommandQueue::PROFILING_ENABLE)
  puts queue.properties_names.inspect
  a_in = NArray.sfloat(65536).random(1.0)
  a_out = NArray.sfloat(65536)
  puts a_in.size, a_in.element_size
  a_out[0] = 3.0
#  b_in = context.create_buffer(a_in.size * a_in.element_size, OpenCL::Mem::COPY_HOST_PTR, a_in)
  b_in = context.create_buffer(a_out.size * a_out.element_size)
  b_out = context.create_buffer(a_out.size * a_out.element_size)
  b_sub = b_in.create_sub_buffer(OpenCL::BufferRegion::new(0, b_in.size / 2 ) )
  puts context.supported_image_formats( OpenCL::Mem::IMAGE2D ).inspect
  puts b_in.size
  puts b_in.flags_names
  puts b_in.type_name
  puts b_sub.size
  puts b_sub.flags_names
  puts b_sub.type_name
  prog = context.create_program_with_source( source )
  puts prog.source
  puts prog.binary_sizes
  prog.build { |prog, data|
    puts "Finished building #{prog}!"
  }
  sleep 1
  puts prog.binary_sizes
  puts prog.binaries
  puts prog.build_status_name.inspect
  puts prog.build_log.inspect
#  puts prog.binary_type.inspect
  k = prog.create_kernel("addition")
  puts k.function_name
  f = OpenCL::Float4::new(1,2,3,4)
  puts f.inspect
  puts f[:s2]
  puts f[:s3]
  puts f.alignment
  f = OpenCL::Float::new(3.0)
  queue.enqueue_write_buffer(b_in, a_in)
  k.set_arg(0, f)
  k.set_arg(1, b_in)
  k.set_arg(2, b_out)
  e = queue.enqueue_NDrange_kernel(k, [65536],[128])
  puts a_out.inspect
  ek = queue.enqueue_read_buffer(b_out, a_out, :event_wait_list => [e])
  queue.finish
  puts ek.command_execution_status_name
  puts ek.profiling_command_start
  puts ek.profiling_command_end
  puts a_in.inspect
  puts a_out.inspect
  diff = (a_in - a_out)
  65536.times { |i|
    raise "Computation error #{i} : #{diff[i]+3.0}" if (diff[i]+3.0).abs > 0.00001
  }
  queue.enqueue_copy_buffer(b_out, b_in)
  ek = queue.enqueue_read_buffer(b_in, a_in)
  queue.finish
  diff = (a_in - a_out)
  65536.times { |i|
    raise "Computation error #{i} : #{diff[i]}" if (diff[i]).abs > 0.00001
  }
}

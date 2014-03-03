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
  devices = platform.devices
  devices.each { |device|
    puts "  " + device.name
    puts "  " + device.execution_capabilities_names.inspect
    puts "  " + device.global_mem_cache_type_name.inspect
    puts "  " + device.queue_properties_names.inspect
    puts "  " + device.type_names.inspect
  }
  context = OpenCL::create_context(devices)
  puts context.num_devices
  puts context.devices.first.name
  queue = context.create_command_queue(context.devices.first, OpenCL::CommandQueue::PROFILING_ENABLE)
  puts queue.properties_names.inspect
  a_in = NArray.float(65536).random(1.0)
  a_out = NArray.float(65536)
  b_in = context.create_buffer(a_in.size * a_in.element_size, OpenCL::Mem::COPY_HOST_PTR, a_in)
  b_out = context.create_buffer(a_out.size * a_out.element_size)
  puts b_in.size
  puts b_in.flags_names
  puts b_in.type_name
  prog = context.create_program_with_source( source )
  puts prog.source
  puts prog.binary_sizes
  prog.build
  puts prog.binary_sizes
  puts prog.binaries

}

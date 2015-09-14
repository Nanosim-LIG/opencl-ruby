[ '../lib', 'lib' ].each { |d| $:.unshift(d) if File::directory?(d) }
require 'opencl_ruby_ffi'
platform = OpenCL::platforms.first
device = platform.devices.first

source = <<EOF
struct ev {
  int start_date;
  int2 data;
  float starting_value;
  float delta;
};
__kernel void addition(  float2 alpha, __global const struct ev *x, __global struct ev *y) {
  size_t ig = get_global_id(0);
  y[ig].starting_value = x[ig].starting_value*0.3333333333333333333f + 1.0f;
}
EOF

context = OpenCL::create_context(device)
queue = context.create_command_queue(device, :properties => OpenCL::CommandQueue::PROFILING_ENABLE)
prog = context.create_program_with_source( source )
prog.build

class EV < FFI::Struct
  layout :start_date, :cl_int,
         :data, OpenCL::Int2,
         :starting_value, :cl_float,
         :delta, :cl_float
end

a_in = FFI::MemoryPointer.new(EV, 65536)
a_out = FFI::MemoryPointer.new(EV, 65536)
f = OpenCL::Float2::new(3.0,2.0)
a_ins = 65536.times.collect { |i|
  EV.new(a_in[i])
}
a_ins.each_with_index { |e,i|
  e[:starting_value] = i.to_f
}

b_in = context.create_buffer(a_in.total, :flags => OpenCL::Mem::COPY_HOST_PTR, :host_ptr => a_in)
b_out = context.create_buffer(a_out.total)
event = prog.addition(queue, [65536], f, b_in, b_out, :local_work_size => [128])
queue.enqueue_read_buffer(b_out, a_out, :event_wait_list => [event])
queue.finish
a_outs = 65536.times.collect { |i|
  EV.new(a_out[i])
}
65536.times { |i|
  raise "Computation error #{i} : #{a_ins[i][:starting_value]} #{a_outs[i][:starting_value]}}" if ((a_outs[i][:starting_value]-1.0)*3.0 - a_ins[i][:starting_value]).abs > 0.01
}
puts "Success!"

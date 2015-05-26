[ '../lib', 'lib' ].each { |d| $:.unshift(d) if File::directory?(d) }
require 'opencl_ruby_ffi'

puts p = OpenCL::get_platforms.first
puts p.version
puts d = p.devices.first
context = OpenCL::create_context( d )
queue = context.create_command_queue(context.devices.first)

source = <<EOF
inline void atomicAdd(volatile __global float *source, const float val) {
  union {
    unsigned int iVal;
    float fVal;
  } res, orig;
  do {
    orig.fVal = *source;
    res.fVal = orig.fVal + val;
  } while (atomic_cmpxchg((volatile __global unsigned int *)source, orig.iVal, res.iVal) != orig.iVal);
}

__kernel void addition(__global float * res) {
  
  atomicAdd(res, 1.0);
}
EOF
prog = context.create_program_with_source( source )
begin
  prog.build
rescue OpenCL::Error => e
  puts prog.build_log
end
a_in = NArray.sfloat(1)
a_in[0] = 0.0
b_in = context.create_buffer(a_in.size * a_in.element_size, :flags => OpenCL::Mem::COPY_HOST_PTR, :host_ptr => a_in)
prog.addition(queue, [1024*1024*1], b_in, :local_work_size => [256])
queue.enqueue_read_buffer(b_in, a_in)
queue.finish
puts a_in[0]

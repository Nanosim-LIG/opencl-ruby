[ '../lib', 'lib' ].each { |d| $:.unshift(d) if File::directory?(d) }
require 'opencl_ruby_ffi'
require 'narray_ffi'
require 'opencl_ruby_ffi/intel/unified_shared_memory_preview'

NUM = 256
SIZE = NUM * OpenCL::Int.size

program = <<CLC
#define NUM #{NUM}
int glob[NUM];

kernel void read(global int *out) {
  int tid = get_global_id(0);
  out[tid] = glob[tid];
}
CLC


dev = OpenCL.platforms.first.devices.first
c = OpenCL.create_context(dev)
q = c.create_command_queue(dev)
p = c.create_program_with_source(program)
begin
  p.compile(options: "-cl-std=CL2.0")
rescue
  p p.build_log
end

p2 = c.link_program(p, options: "-cl-std=CL2.0 -cl-take-global-address")

ptr = dev.get_global_variable_pointer_intel(p2, "glob")

h_b = ANArray.int(32, NUM).random!
h_out = ANArray.int(32, NUM)

b = c.create_buffer(SIZE)

q.enqueue_svm_memcpy(ptr, h_b.to_ptr)
p2.read(q, [NUM], b);
q.enqueue_read_buffer(b, h_out)
q.finish

raise "error" unless (h_b-h_out).abs.max == 0


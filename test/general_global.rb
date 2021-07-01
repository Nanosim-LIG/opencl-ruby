[ '../lib', 'lib' ].each { |d| $:.unshift(d) if File::directory?(d) }
require 'opencl_ruby_ffi'
require 'narray_ffi'
require 'opencl_ruby_ffi/intel/unified_shared_memory_preview'

NUM = 256
SIZE = NUM * OpenCL::Int.size

program = <<CLC
#define NUM #{NUM}
int glob[NUM];

kernel void get_address(global intptr_t *out, global size_t *sout) {
  *out = &(glob[0]);
  *sout = sizeof(glob);
}

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
  p.build(options: "-cl-std=CL2.0")
rescue
  p p.build_log
end

h_addr = FFI::MemoryPointer.new(:pointer)
h_size = FFI::MemoryPointer.new(:size_t)

h_b = ANArray.int(32, NUM).random!
h_out = ANArray.int(32, NUM)

addr = c.create_buffer(8)
size = c.create_buffer(8)

b = c.create_buffer(SIZE)

p.get_address(q, [1], addr, size)
q.enqueue_read_buffer(addr, h_addr)
q.enqueue_read_buffer(size, h_size)
q.finish
p glob = FFI::Pointer.new(h_addr.read_pointer).slice(0, h_size.read_uint64)

q.enqueue_svm_memcpy(glob, h_b.to_ptr)
p.read(q, [NUM], b);
q.enqueue_read_buffer(b, h_out)
q.finish

raise "error" unless (h_b-h_out).abs.max == 0
$stderr.puts "SUCCESS"

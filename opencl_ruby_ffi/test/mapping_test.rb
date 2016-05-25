require 'opencl_ruby_ffi'
pattern = "tototututatatiti"

c = OpenCL::create_context(OpenCL::platforms.first.devices.first)
q = c.create_command_queue(c.devices.first)
b = c.create_buffer(1024*1024, :flags => [OpenCL::Mem::ALLOC_HOST_PTR, OpenCL::Mem::READ_ONLY])
b_out = c.create_buffer(1024*1024, :flags => [OpenCL::Mem::ALLOC_HOST_PTR, OpenCL::Mem::WRITE_ONLY])
src = "kernel void toto(global const char * input, global char * output) { int ind = get_global_id(0); output[ind] = input[ind]; }"
p = c.create_program_with_source(src)
p.build

ev, ptr = q.enqueue_map_buffer(b, OpenCL::MAP_WRITE_INVALIDATE_REGION, :blocking => OpenCL::TRUE)
ptr.write_bytes(pattern)
ev = q.enqueue_unmap_mem_object(b, ptr)

ev = p.toto(q, [1024*1024], b, b_out, :event_wait_list => [ev])

ev, ptr = q.enqueue_map_buffer(b_out, OpenCL::MAP_READ, :blocking => OpenCL::TRUE)
str = ptr.read_bytes(16)
q.enqueue_unmap_mem_object(b_out, ptr)

puts "Success!" unless str != pattern

require 'opencl_ruby_ffi'
pattern = "tototututatatiti"
size = 1024*1024

c = OpenCL::create_context(OpenCL::platforms.first.devices.first)
q = c.create_command_queue(c.devices.first, :properties => OpenCL::CommandQueue::OUT_OF_ORDER_EXEC_MODE_ENABLE)
b = c.create_buffer(size, :flags => [OpenCL::Mem::ALLOC_HOST_PTR, OpenCL::Mem::READ_ONLY])
b_out = c.create_buffer(size, :flags => [OpenCL::Mem::ALLOC_HOST_PTR, OpenCL::Mem::WRITE_ONLY])
src = "kernel void toto(global const char * input, global char * output) { int ind = get_global_id(0); output[ind] = input[ind]; }"
p = c.create_program_with_source(src)
p.build

ev, ptr = q.enqueue_map_buffer(b, OpenCL::MAP_WRITE_INVALIDATE_REGION, :blocking => OpenCL::TRUE)
ptr.write_bytes(pattern*(size/pattern.size))
ev = q.enqueue_unmap_mem_object(b, ptr)

ev = p.toto(q, [size], b, b_out, :event_wait_list => [ev])

ev, ptr = q.enqueue_map_buffer(b_out, OpenCL::MAP_READ, :blocking => OpenCL::TRUE, :event_wait_list => [ev])
str = ptr.read_bytes(pattern.size*(size/pattern.size))
q.enqueue_unmap_mem_object(b_out, ptr)

puts "Success!" unless str != pattern*(size/pattern.size)

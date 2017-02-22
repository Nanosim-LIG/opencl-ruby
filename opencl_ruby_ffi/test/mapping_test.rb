require 'opencl_ruby_ffi'
require 'narray_ffi'
require 'benchmark'
size = 1024*1024

c = OpenCL::create_context(OpenCL::platforms.first.devices.first)
q = c.create_command_queue(c.devices.first, :properties => OpenCL::CommandQueue::OUT_OF_ORDER_EXEC_MODE_ENABLE)
src = "kernel void toto(global const char * input, global char * output) { int ind = get_global_id(0); output[ind] = input[ind]; }"
p = c.create_program_with_source(src)
p.build

repeat = 50

Benchmark.bm do |x|

  a = nil
  a_out = nil

  x.report { repeat.times {
    b = c.create_buffer(size, :flags => [OpenCL::Mem::ALLOC_HOST_PTR, OpenCL::Mem::READ_ONLY])
    b_out = c.create_buffer(size, :flags => [OpenCL::Mem::ALLOC_HOST_PTR, OpenCL::Mem::WRITE_ONLY])

    ev, ptr = q.enqueue_map_buffer(b, OpenCL::MAP_WRITE_INVALIDATE_REGION, :blocking => OpenCL::TRUE)
    a = NArray.to_na(ptr, NArray::BYTE, size).random!(256)
    ev = q.enqueue_unmap_mem_object(b, ptr)

    ev = p.toto(q, [size], b, b_out, :event_wait_list => [ev])

    ev, ptr = q.enqueue_map_buffer(b_out, OpenCL::MAP_READ, :blocking => OpenCL::TRUE, :event_wait_list => [ev])
    a_out = NArray.to_na(ptr, NArray::BYTE, size)
    q.enqueue_unmap_mem_object(b_out, ptr)
    GC.start
  } }

  puts "Success!" if a == a_out

  alignement = OpenCL::platforms.first.devices.first.mem_base_addr_align

  x.report { repeat.times {
    a = ANArray.new(NArray::BYTE, alignement, size).random!(256)
    a_out = ANArray.new(NArray::BYTE, alignement, size)
    b = c.create_buffer(size, :host_ptr => a, :flags => [OpenCL::Mem::USE_HOST_PTR, OpenCL::Mem::READ_ONLY])
    b_out = c.create_buffer(size, :host_ptr => a_out, :flags => [OpenCL::Mem::USE_HOST_PTR, OpenCL::Mem::WRITE_ONLY])

    ev, ptr = q.enqueue_map_buffer(b, OpenCL::MAP_WRITE, :blocking => OpenCL::TRUE)
    ev = q.enqueue_unmap_mem_object(b, ptr)

    ev = p.toto(q, [size], b, b_out, :event_wait_list => [ev])

    ev, ptr = q.enqueue_map_buffer(b_out, OpenCL::MAP_READ, :blocking => OpenCL::TRUE, :event_wait_list => [ev])
    q.enqueue_unmap_mem_object(b_out, ptr)
    GC.start
  } }

  puts "Success!" if a == a_out

end


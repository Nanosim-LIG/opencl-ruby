require "opencl"

kernel_source = <<EOF
__kernel void
dot_product (__global const float4 *a,
             __global const float4 *b,
             __global float *c)
{
  int gid = get_global_id(0);

  c[gid] = dot(a[gid], b[gid]);
}
EOF


n = 256

srcA = OpenCL::VArray.new(OpenCL::VArray::FLOAT4, n)
srcB = OpenCL::VArray.new(OpenCL::VArray::FLOAT4, n)
for i in 0...n
  srcA[i] = OpenCL::Float4.new(i,i,i,i)
  srcB[i] = OpenCL::Float4.new(i,i,i,i)
end
p srcA
p srcB


context = OpenCL::Context.create_from_type(OpenCL::Device::TYPE_GPU)

devices = context.devices

cmd_queue = OpenCL::CommandQueue.new(context, devices[0], 0)

memobjs = Array.new(3)
memobjs[0] = OpenCL::Buffer.new(context,
                                OpenCL::Mem::READ_ONLY | OpenCL::Mem::COPY_HOST_PTR,
                                :host_ptr => srcA)
memobjs[1] = OpenCL::Buffer.new(context,
                                OpenCL::Mem::READ_ONLY | OpenCL::Mem::COPY_HOST_PTR,
                                :host_ptr => srcB)
memobjs[2] = OpenCL::Buffer.new(context,
                                OpenCL::Mem::READ_WRITE,
                                :size => memobjs[0].size/4)
program = OpenCL::Program.create_with_source(context, [kernel_source])

program.build

kernel = OpenCL::Kernel.new(program, "dot_product")

memobjs.each_with_index do |memobj, i|
  kernel.set_arg(i, memobj)
end

global_work_size = [n]
local_work_size = [1]

cmd_queue.enqueue_NDrange_kernel(kernel, global_work_size, local_work_size)

str, event = cmd_queue.enqueue_read_buffer(memobjs[2],
                                           OpenCL::TRUE)
dst = OpenCL::VArray.to_va(OpenCL::VArray::FLOAT, str)
OpenCL::Event.wait([event])
p dst
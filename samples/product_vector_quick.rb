require "quick_opencl"

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

case ARGV[0]
when "gpu"
  dtype = :gpu
when "cpu"
  dtype = :cpu
else
  dtype = :all
end
OpenCL::Quick.init(dtype)

memobjs = Array.new(3)
memobjs[0] = OpenCL::Quick.create_buffer(srcA, "r")
memobjs[1] = OpenCL::Quick.create_buffer(srcB, "r")
memobjs[2] = OpenCL::Quick.create_buffer(memobjs[0].size/4, "w")

OpenCL::Quick.sources = [kernel_source]

OpenCL::Quick.execute_NDRange("dot_product", memobjs, [n], [1])

dst = OpenCL::Quick.read_buffer(memobjs[2], OpenCL::VArray::FLOAT)

p dst

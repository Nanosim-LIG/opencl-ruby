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


OpenCL::Quick.init

n = 256
srcA = OpenCL::Quick::VArray.new(OpenCL::VArray::FLOAT4, n)
srcB = OpenCL::Quick::VArray.new(OpenCL::VArray::FLOAT4, n)
dst = OpenCL::Quick::VArray.new(OpenCL::VArray::FLOAT, n)

for i in 0...n
  srcA[i] = OpenCL::Float4.new(i,i,i,i)
  srcB[i] = OpenCL::Float4.new(i,i,i,i)
end

OpenCL::Quick.sources = [kernel_source]

OpenCL::Quick.execute_NDRange("dot_product", [srcA, srcB, dst], [n], [1])

p dst

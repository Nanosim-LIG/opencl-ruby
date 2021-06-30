[ '../lib', 'lib' ].each { |d| $:.unshift(d) if File::directory?(d) }
require 'opencl_ruby_ffi'
require 'narray_ffi'

DIM = 32
SIZE = DIM * DIM * OpenCL::Float.size

program = <<CLC
#define DIM #{DIM}

typedef struct {
  intptr_t  image;
  intptr_t  sampler;
} hipTextureObject_st, *hipTextureObject_t;

inline float tex2D_f(hipTextureObject_t textureObject, float x, float y) {
   return read_imagef(__builtin_astype(textureObject->image, read_only image2d_t),
                      __builtin_astype(textureObject->sampler, sampler_t),
                      (float2)(x, y)).x;
}

void reading_impl(hipTextureObject_t textureObject, global float *out) {
  unsigned int i = get_global_id(0);
  unsigned int j = get_global_id(1);
  out[j*DIM+i] = tex2D_f(textureObject, i, j);
}

kernel void readimg(read_only image2d_t image, sampler_t sampler, global float *out) {
  hipTextureObject_st textureObject =
    { __builtin_astype(image, intptr_t),
      __builtin_astype(sampler, intptr_t) };
  reading_impl(&textureObject, out);
}
CLC


dev = OpenCL.platforms.first.devices.first
c = OpenCL.create_context(dev)
q = c.create_command_queue(dev)
p = c.create_program_with_source(program)
begin
  p.build(options: "-cl-std=CL2.0")
rescue
  p.build_log.each { |d, l|
    puts "#{d}:"
    puts l
  }
end
puts program

hin = ANArray.sfloat(256, DIM*DIM).random!
hout = ANArray.sfloat(256, DIM*DIM).random!

format = OpenCL::ImageFormat.new(OpenCL::ChannelOrder::R, OpenCL::ChannelType::FLOAT)
i = c.create_image_2d(format, DIM, DIM, host_ptr: hin, flags: OpenCL::Mem::USE_HOST_PTR)

s = c.create_sampler(normalized_coords: OpenCL::FALSE,
                     addressing_mode: OpenCL::AddressingMode::NONE,
                     filter_mode: OpenCL::FilterMode::NEAREST)
b = c.create_buffer(SIZE)
p.readimg(q, [DIM, DIM], i, s, b)
q.enqueue_read_buffer(b, hout)
q.finish

raise "error" unless (hin-hout).abs.max == 0
$stderr.puts "SUCCESS"


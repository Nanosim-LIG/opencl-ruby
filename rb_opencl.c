#include "ruby.h"
#include "cl.h"

void init_opencl_host(VALUE);
void init_opencl_vect(VALUE);

void
Init_opencl(void)
{
  VALUE rb_mOpenCL;

  rb_require("narray");

  rb_mOpenCL = rb_define_module("OpenCL");

  init_opencl_host(rb_mOpenCL);
  init_opencl_vect(rb_mOpenCL);
}

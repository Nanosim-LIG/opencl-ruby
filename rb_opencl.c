#include "ruby.h"
#include "cl.h"

VALUE init_opencl_vect(VALUE);
void init_opencl_host(VALUE, VALUE);

void
Init_opencl(void)
{
  VALUE rb_mOpenCL;
  VALUE rb_cVArray;

  rb_require("narray");

  rb_mOpenCL = rb_define_module("OpenCL");

  rb_cVArray = init_opencl_vect(rb_mOpenCL);
  init_opencl_host(rb_mOpenCL, rb_cVArray);
}

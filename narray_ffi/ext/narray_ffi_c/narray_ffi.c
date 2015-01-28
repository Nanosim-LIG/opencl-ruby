#include "ruby.h"
#include "narray.h"

VALUE na_address(VALUE self) {
  struct NARRAY *ary;
  void * ptr;
  VALUE ret;

  GetNArray(self,ary);
  ptr = ary->ptr;
  ret = ULL2NUM( sizeof(ptr) == 4 ? (unsigned long long int) (unsigned long int) ptr : (unsigned long long int) ptr );
  return ret;
}

void Init_narray_ffi_c() {
  ID id;
  VALUE klass;
  id = rb_intern("NArray");
  klass = rb_const_get(rb_cObject, id);
  rb_define_private_method(klass, "address", na_address, 0);
}


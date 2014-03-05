#include "ruby.h"
#include "narray.h"
#include "Pointer.h"

VALUE na_to_pointer(VALUE self) {
  struct NARRAY *ary;
  void * ptr;

  GetNArray(self,ary);
  ptr = ary->ptr;
  return rbffi_Pointer_NewInstance(ptr);
}

void Init_narray_ffi_c() {
  ID id;
  VALUE klass;
  id = rb_intern("NArray");
  klass = rb_const_get(rb_cObject, id);
  rb_define_method(klass, "to_ptr", na_to_pointer, 0);
}


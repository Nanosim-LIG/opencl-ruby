#include <string.h>
#include "ruby.h"
#include "cl.h"
#ifdef HAVE_NARRAY_H
#include "narray.h"
#endif

static VALUE rb_mOpenCL;
static VALUE rb_cVector;
static VALUE rb_cVArray;
static VALUE rb_cChar2;
static VALUE rb_cChar4;
static VALUE rb_cChar8;
static VALUE rb_cChar16;
static VALUE rb_cUchar2;
static VALUE rb_cUchar4;
static VALUE rb_cUchar8;
static VALUE rb_cUchar16;
static VALUE rb_cShort2;
static VALUE rb_cShort4;
static VALUE rb_cShort8;
static VALUE rb_cShort16;
static VALUE rb_cUshort2;
static VALUE rb_cUshort4;
static VALUE rb_cUshort8;
static VALUE rb_cUshort16;
static VALUE rb_cInt2;
static VALUE rb_cInt4;
static VALUE rb_cInt8;
static VALUE rb_cInt16;
static VALUE rb_cUint2;
static VALUE rb_cUint4;
static VALUE rb_cUint8;
static VALUE rb_cUint16;
static VALUE rb_cLong2;
static VALUE rb_cLong4;
static VALUE rb_cLong8;
static VALUE rb_cLong16;
static VALUE rb_cUlong2;
static VALUE rb_cUlong4;
static VALUE rb_cUlong8;
static VALUE rb_cUlong16;
static VALUE rb_cFloat2;
static VALUE rb_cFloat4;
static VALUE rb_cFloat8;
static VALUE rb_cFloat16;

enum vector_type {
  VA_NONE,
  VA_CHAR,
  VA_UCHAR,
  VA_SHORT,
  VA_USHORT,
  VA_INT,
  VA_UINT,
  VA_LONG,
  VA_ULONG,
  VA_FLOAT,
  VA_ERROR
};

typedef struct _struct_array {
  void* ptr;
  enum vector_type type;
  unsigned int n;
  size_t length;
  size_t size;
  VALUE obj;
} struct_array;


static void
vector_free(void* ptr)
{
  xfree(ptr);
}
VALUE
rb_CreateChar2(int argc, VALUE *argv, VALUE self)
{
  cl_char2 *vector;
  int n;

  vector = (cl_char2*)xmalloc(sizeof(cl_char2));
  if (argc == 1) {
    Check_Type(argv[0], T_ARRAY);
    if (RARRAY_LEN(argv[0])==2) {
      VALUE *ptr = (VALUE*)RARRAY_PTR(argv[0]);
      for (n=0; n<2; n++)
        vector[0][n] = NUM2CHR(ptr[n]);
    }
  } else if (argc == 2) {
      for (n=0; n<2; n++)
        vector[0][n] = NUM2CHR(argv[n]);
  } else {
    rb_raise(rb_eArgError, "wrong number of arguments (%d for 2)", argc);
  }
  return Data_Wrap_Struct(rb_cChar2, 0, vector_free, (void*)vector);
}
VALUE
rb_Char2_toA(int argc, VALUE *argv, VALUE self)
{
  cl_char2 *vector;

  if (argc > 0)
    rb_raise(rb_eArgError, "wrong number of arguments (%d for 0)", argc);
  Data_Get_Struct(self, cl_char2, vector);
  return rb_ary_new3(2, CHR2FIX((vector[0][0])), CHR2FIX((vector[0][1])));
}
VALUE
rb_CreateChar4(int argc, VALUE *argv, VALUE self)
{
  cl_char4 *vector;
  int n;

  vector = (cl_char4*)xmalloc(sizeof(cl_char4));
  if (argc == 1) {
    Check_Type(argv[0], T_ARRAY);
    if (RARRAY_LEN(argv[0])==4) {
      VALUE *ptr = (VALUE*)RARRAY_PTR(argv[0]);
      for (n=0; n<4; n++)
        vector[0][n] = NUM2CHR(ptr[n]);
    }
  } else if (argc == 4) {
      for (n=0; n<4; n++)
        vector[0][n] = NUM2CHR(argv[n]);
  } else {
    rb_raise(rb_eArgError, "wrong number of arguments (%d for 4)", argc);
  }
  return Data_Wrap_Struct(rb_cChar4, 0, vector_free, (void*)vector);
}
VALUE
rb_Char4_toA(int argc, VALUE *argv, VALUE self)
{
  cl_char4 *vector;

  if (argc > 0)
    rb_raise(rb_eArgError, "wrong number of arguments (%d for 0)", argc);
  Data_Get_Struct(self, cl_char4, vector);
  return rb_ary_new3(4, CHR2FIX((vector[0][0])), CHR2FIX((vector[0][1])), CHR2FIX((vector[0][2])), CHR2FIX((vector[0][3])));
}
VALUE
rb_CreateChar8(int argc, VALUE *argv, VALUE self)
{
  cl_char8 *vector;
  int n;

  vector = (cl_char8*)xmalloc(sizeof(cl_char8));
  if (argc == 1) {
    Check_Type(argv[0], T_ARRAY);
    if (RARRAY_LEN(argv[0])==8) {
      VALUE *ptr = (VALUE*)RARRAY_PTR(argv[0]);
      for (n=0; n<8; n++)
        vector[0][n] = NUM2CHR(ptr[n]);
    }
  } else if (argc == 8) {
      for (n=0; n<8; n++)
        vector[0][n] = NUM2CHR(argv[n]);
  } else {
    rb_raise(rb_eArgError, "wrong number of arguments (%d for 8)", argc);
  }
  return Data_Wrap_Struct(rb_cChar8, 0, vector_free, (void*)vector);
}
VALUE
rb_Char8_toA(int argc, VALUE *argv, VALUE self)
{
  cl_char8 *vector;

  if (argc > 0)
    rb_raise(rb_eArgError, "wrong number of arguments (%d for 0)", argc);
  Data_Get_Struct(self, cl_char8, vector);
  return rb_ary_new3(8, CHR2FIX((vector[0][0])), CHR2FIX((vector[0][1])), CHR2FIX((vector[0][2])), CHR2FIX((vector[0][3])), CHR2FIX((vector[0][4])), CHR2FIX((vector[0][5])), CHR2FIX((vector[0][6])), CHR2FIX((vector[0][7])));
}
VALUE
rb_CreateChar16(int argc, VALUE *argv, VALUE self)
{
  cl_char16 *vector;
  int n;

  vector = (cl_char16*)xmalloc(sizeof(cl_char16));
  if (argc == 1) {
    Check_Type(argv[0], T_ARRAY);
    if (RARRAY_LEN(argv[0])==16) {
      VALUE *ptr = (VALUE*)RARRAY_PTR(argv[0]);
      for (n=0; n<16; n++)
        vector[0][n] = NUM2CHR(ptr[n]);
    }
  } else if (argc == 16) {
      for (n=0; n<16; n++)
        vector[0][n] = NUM2CHR(argv[n]);
  } else {
    rb_raise(rb_eArgError, "wrong number of arguments (%d for 16)", argc);
  }
  return Data_Wrap_Struct(rb_cChar16, 0, vector_free, (void*)vector);
}
VALUE
rb_Char16_toA(int argc, VALUE *argv, VALUE self)
{
  cl_char16 *vector;

  if (argc > 0)
    rb_raise(rb_eArgError, "wrong number of arguments (%d for 0)", argc);
  Data_Get_Struct(self, cl_char16, vector);
  return rb_ary_new3(16, CHR2FIX((vector[0][0])), CHR2FIX((vector[0][1])), CHR2FIX((vector[0][2])), CHR2FIX((vector[0][3])), CHR2FIX((vector[0][4])), CHR2FIX((vector[0][5])), CHR2FIX((vector[0][6])), CHR2FIX((vector[0][7])), CHR2FIX((vector[0][8])), CHR2FIX((vector[0][9])), CHR2FIX((vector[0][10])), CHR2FIX((vector[0][11])), CHR2FIX((vector[0][12])), CHR2FIX((vector[0][13])), CHR2FIX((vector[0][14])), CHR2FIX((vector[0][15])));
}
VALUE
rb_CreateUchar2(int argc, VALUE *argv, VALUE self)
{
  cl_uchar2 *vector;
  int n;

  vector = (cl_uchar2*)xmalloc(sizeof(cl_uchar2));
  if (argc == 1) {
    Check_Type(argv[0], T_ARRAY);
    if (RARRAY_LEN(argv[0])==2) {
      VALUE *ptr = (VALUE*)RARRAY_PTR(argv[0]);
      for (n=0; n<2; n++)
        vector[0][n] = (uint8_t)NUM2UINT(ptr[n]);
    }
  } else if (argc == 2) {
      for (n=0; n<2; n++)
        vector[0][n] = (uint8_t)NUM2UINT(argv[n]);
  } else {
    rb_raise(rb_eArgError, "wrong number of arguments (%d for 2)", argc);
  }
  return Data_Wrap_Struct(rb_cUchar2, 0, vector_free, (void*)vector);
}
VALUE
rb_Uchar2_toA(int argc, VALUE *argv, VALUE self)
{
  cl_uchar2 *vector;

  if (argc > 0)
    rb_raise(rb_eArgError, "wrong number of arguments (%d for 0)", argc);
  Data_Get_Struct(self, cl_uchar2, vector);
  return rb_ary_new3(2, UINT2NUM((uint8_t)(vector[0][0])), UINT2NUM((uint8_t)(vector[0][1])));
}
VALUE
rb_CreateUchar4(int argc, VALUE *argv, VALUE self)
{
  cl_uchar4 *vector;
  int n;

  vector = (cl_uchar4*)xmalloc(sizeof(cl_uchar4));
  if (argc == 1) {
    Check_Type(argv[0], T_ARRAY);
    if (RARRAY_LEN(argv[0])==4) {
      VALUE *ptr = (VALUE*)RARRAY_PTR(argv[0]);
      for (n=0; n<4; n++)
        vector[0][n] = (uint8_t)NUM2UINT(ptr[n]);
    }
  } else if (argc == 4) {
      for (n=0; n<4; n++)
        vector[0][n] = (uint8_t)NUM2UINT(argv[n]);
  } else {
    rb_raise(rb_eArgError, "wrong number of arguments (%d for 4)", argc);
  }
  return Data_Wrap_Struct(rb_cUchar4, 0, vector_free, (void*)vector);
}
VALUE
rb_Uchar4_toA(int argc, VALUE *argv, VALUE self)
{
  cl_uchar4 *vector;

  if (argc > 0)
    rb_raise(rb_eArgError, "wrong number of arguments (%d for 0)", argc);
  Data_Get_Struct(self, cl_uchar4, vector);
  return rb_ary_new3(4, UINT2NUM((uint8_t)(vector[0][0])), UINT2NUM((uint8_t)(vector[0][1])), UINT2NUM((uint8_t)(vector[0][2])), UINT2NUM((uint8_t)(vector[0][3])));
}
VALUE
rb_CreateUchar8(int argc, VALUE *argv, VALUE self)
{
  cl_uchar8 *vector;
  int n;

  vector = (cl_uchar8*)xmalloc(sizeof(cl_uchar8));
  if (argc == 1) {
    Check_Type(argv[0], T_ARRAY);
    if (RARRAY_LEN(argv[0])==8) {
      VALUE *ptr = (VALUE*)RARRAY_PTR(argv[0]);
      for (n=0; n<8; n++)
        vector[0][n] = (uint8_t)NUM2UINT(ptr[n]);
    }
  } else if (argc == 8) {
      for (n=0; n<8; n++)
        vector[0][n] = (uint8_t)NUM2UINT(argv[n]);
  } else {
    rb_raise(rb_eArgError, "wrong number of arguments (%d for 8)", argc);
  }
  return Data_Wrap_Struct(rb_cUchar8, 0, vector_free, (void*)vector);
}
VALUE
rb_Uchar8_toA(int argc, VALUE *argv, VALUE self)
{
  cl_uchar8 *vector;

  if (argc > 0)
    rb_raise(rb_eArgError, "wrong number of arguments (%d for 0)", argc);
  Data_Get_Struct(self, cl_uchar8, vector);
  return rb_ary_new3(8, UINT2NUM((uint8_t)(vector[0][0])), UINT2NUM((uint8_t)(vector[0][1])), UINT2NUM((uint8_t)(vector[0][2])), UINT2NUM((uint8_t)(vector[0][3])), UINT2NUM((uint8_t)(vector[0][4])), UINT2NUM((uint8_t)(vector[0][5])), UINT2NUM((uint8_t)(vector[0][6])), UINT2NUM((uint8_t)(vector[0][7])));
}
VALUE
rb_CreateUchar16(int argc, VALUE *argv, VALUE self)
{
  cl_uchar16 *vector;
  int n;

  vector = (cl_uchar16*)xmalloc(sizeof(cl_uchar16));
  if (argc == 1) {
    Check_Type(argv[0], T_ARRAY);
    if (RARRAY_LEN(argv[0])==16) {
      VALUE *ptr = (VALUE*)RARRAY_PTR(argv[0]);
      for (n=0; n<16; n++)
        vector[0][n] = (uint8_t)NUM2UINT(ptr[n]);
    }
  } else if (argc == 16) {
      for (n=0; n<16; n++)
        vector[0][n] = (uint8_t)NUM2UINT(argv[n]);
  } else {
    rb_raise(rb_eArgError, "wrong number of arguments (%d for 16)", argc);
  }
  return Data_Wrap_Struct(rb_cUchar16, 0, vector_free, (void*)vector);
}
VALUE
rb_Uchar16_toA(int argc, VALUE *argv, VALUE self)
{
  cl_uchar16 *vector;

  if (argc > 0)
    rb_raise(rb_eArgError, "wrong number of arguments (%d for 0)", argc);
  Data_Get_Struct(self, cl_uchar16, vector);
  return rb_ary_new3(16, UINT2NUM((uint8_t)(vector[0][0])), UINT2NUM((uint8_t)(vector[0][1])), UINT2NUM((uint8_t)(vector[0][2])), UINT2NUM((uint8_t)(vector[0][3])), UINT2NUM((uint8_t)(vector[0][4])), UINT2NUM((uint8_t)(vector[0][5])), UINT2NUM((uint8_t)(vector[0][6])), UINT2NUM((uint8_t)(vector[0][7])), UINT2NUM((uint8_t)(vector[0][8])), UINT2NUM((uint8_t)(vector[0][9])), UINT2NUM((uint8_t)(vector[0][10])), UINT2NUM((uint8_t)(vector[0][11])), UINT2NUM((uint8_t)(vector[0][12])), UINT2NUM((uint8_t)(vector[0][13])), UINT2NUM((uint8_t)(vector[0][14])), UINT2NUM((uint8_t)(vector[0][15])));
}
VALUE
rb_CreateShort2(int argc, VALUE *argv, VALUE self)
{
  cl_short2 *vector;
  int n;

  vector = (cl_short2*)xmalloc(sizeof(cl_short2));
  if (argc == 1) {
    Check_Type(argv[0], T_ARRAY);
    if (RARRAY_LEN(argv[0])==2) {
      VALUE *ptr = (VALUE*)RARRAY_PTR(argv[0]);
      for (n=0; n<2; n++)
        vector[0][n] = (int16_t)NUM2INT(ptr[n]);
    }
  } else if (argc == 2) {
      for (n=0; n<2; n++)
        vector[0][n] = (int16_t)NUM2INT(argv[n]);
  } else {
    rb_raise(rb_eArgError, "wrong number of arguments (%d for 2)", argc);
  }
  return Data_Wrap_Struct(rb_cShort2, 0, vector_free, (void*)vector);
}
VALUE
rb_Short2_toA(int argc, VALUE *argv, VALUE self)
{
  cl_short2 *vector;

  if (argc > 0)
    rb_raise(rb_eArgError, "wrong number of arguments (%d for 0)", argc);
  Data_Get_Struct(self, cl_short2, vector);
  return rb_ary_new3(2, INT2NUM((int16_t)(vector[0][0])), INT2NUM((int16_t)(vector[0][1])));
}
VALUE
rb_CreateShort4(int argc, VALUE *argv, VALUE self)
{
  cl_short4 *vector;
  int n;

  vector = (cl_short4*)xmalloc(sizeof(cl_short4));
  if (argc == 1) {
    Check_Type(argv[0], T_ARRAY);
    if (RARRAY_LEN(argv[0])==4) {
      VALUE *ptr = (VALUE*)RARRAY_PTR(argv[0]);
      for (n=0; n<4; n++)
        vector[0][n] = (int16_t)NUM2INT(ptr[n]);
    }
  } else if (argc == 4) {
      for (n=0; n<4; n++)
        vector[0][n] = (int16_t)NUM2INT(argv[n]);
  } else {
    rb_raise(rb_eArgError, "wrong number of arguments (%d for 4)", argc);
  }
  return Data_Wrap_Struct(rb_cShort4, 0, vector_free, (void*)vector);
}
VALUE
rb_Short4_toA(int argc, VALUE *argv, VALUE self)
{
  cl_short4 *vector;

  if (argc > 0)
    rb_raise(rb_eArgError, "wrong number of arguments (%d for 0)", argc);
  Data_Get_Struct(self, cl_short4, vector);
  return rb_ary_new3(4, INT2NUM((int16_t)(vector[0][0])), INT2NUM((int16_t)(vector[0][1])), INT2NUM((int16_t)(vector[0][2])), INT2NUM((int16_t)(vector[0][3])));
}
VALUE
rb_CreateShort8(int argc, VALUE *argv, VALUE self)
{
  cl_short8 *vector;
  int n;

  vector = (cl_short8*)xmalloc(sizeof(cl_short8));
  if (argc == 1) {
    Check_Type(argv[0], T_ARRAY);
    if (RARRAY_LEN(argv[0])==8) {
      VALUE *ptr = (VALUE*)RARRAY_PTR(argv[0]);
      for (n=0; n<8; n++)
        vector[0][n] = (int16_t)NUM2INT(ptr[n]);
    }
  } else if (argc == 8) {
      for (n=0; n<8; n++)
        vector[0][n] = (int16_t)NUM2INT(argv[n]);
  } else {
    rb_raise(rb_eArgError, "wrong number of arguments (%d for 8)", argc);
  }
  return Data_Wrap_Struct(rb_cShort8, 0, vector_free, (void*)vector);
}
VALUE
rb_Short8_toA(int argc, VALUE *argv, VALUE self)
{
  cl_short8 *vector;

  if (argc > 0)
    rb_raise(rb_eArgError, "wrong number of arguments (%d for 0)", argc);
  Data_Get_Struct(self, cl_short8, vector);
  return rb_ary_new3(8, INT2NUM((int16_t)(vector[0][0])), INT2NUM((int16_t)(vector[0][1])), INT2NUM((int16_t)(vector[0][2])), INT2NUM((int16_t)(vector[0][3])), INT2NUM((int16_t)(vector[0][4])), INT2NUM((int16_t)(vector[0][5])), INT2NUM((int16_t)(vector[0][6])), INT2NUM((int16_t)(vector[0][7])));
}
VALUE
rb_CreateShort16(int argc, VALUE *argv, VALUE self)
{
  cl_short16 *vector;
  int n;

  vector = (cl_short16*)xmalloc(sizeof(cl_short16));
  if (argc == 1) {
    Check_Type(argv[0], T_ARRAY);
    if (RARRAY_LEN(argv[0])==16) {
      VALUE *ptr = (VALUE*)RARRAY_PTR(argv[0]);
      for (n=0; n<16; n++)
        vector[0][n] = (int16_t)NUM2INT(ptr[n]);
    }
  } else if (argc == 16) {
      for (n=0; n<16; n++)
        vector[0][n] = (int16_t)NUM2INT(argv[n]);
  } else {
    rb_raise(rb_eArgError, "wrong number of arguments (%d for 16)", argc);
  }
  return Data_Wrap_Struct(rb_cShort16, 0, vector_free, (void*)vector);
}
VALUE
rb_Short16_toA(int argc, VALUE *argv, VALUE self)
{
  cl_short16 *vector;

  if (argc > 0)
    rb_raise(rb_eArgError, "wrong number of arguments (%d for 0)", argc);
  Data_Get_Struct(self, cl_short16, vector);
  return rb_ary_new3(16, INT2NUM((int16_t)(vector[0][0])), INT2NUM((int16_t)(vector[0][1])), INT2NUM((int16_t)(vector[0][2])), INT2NUM((int16_t)(vector[0][3])), INT2NUM((int16_t)(vector[0][4])), INT2NUM((int16_t)(vector[0][5])), INT2NUM((int16_t)(vector[0][6])), INT2NUM((int16_t)(vector[0][7])), INT2NUM((int16_t)(vector[0][8])), INT2NUM((int16_t)(vector[0][9])), INT2NUM((int16_t)(vector[0][10])), INT2NUM((int16_t)(vector[0][11])), INT2NUM((int16_t)(vector[0][12])), INT2NUM((int16_t)(vector[0][13])), INT2NUM((int16_t)(vector[0][14])), INT2NUM((int16_t)(vector[0][15])));
}
VALUE
rb_CreateUshort2(int argc, VALUE *argv, VALUE self)
{
  cl_ushort2 *vector;
  int n;

  vector = (cl_ushort2*)xmalloc(sizeof(cl_ushort2));
  if (argc == 1) {
    Check_Type(argv[0], T_ARRAY);
    if (RARRAY_LEN(argv[0])==2) {
      VALUE *ptr = (VALUE*)RARRAY_PTR(argv[0]);
      for (n=0; n<2; n++)
        vector[0][n] = (uint16_t)NUM2UINT(ptr[n]);
    }
  } else if (argc == 2) {
      for (n=0; n<2; n++)
        vector[0][n] = (uint16_t)NUM2UINT(argv[n]);
  } else {
    rb_raise(rb_eArgError, "wrong number of arguments (%d for 2)", argc);
  }
  return Data_Wrap_Struct(rb_cUshort2, 0, vector_free, (void*)vector);
}
VALUE
rb_Ushort2_toA(int argc, VALUE *argv, VALUE self)
{
  cl_ushort2 *vector;

  if (argc > 0)
    rb_raise(rb_eArgError, "wrong number of arguments (%d for 0)", argc);
  Data_Get_Struct(self, cl_ushort2, vector);
  return rb_ary_new3(2, UINT2NUM((uint16_t)(vector[0][0])), UINT2NUM((uint16_t)(vector[0][1])));
}
VALUE
rb_CreateUshort4(int argc, VALUE *argv, VALUE self)
{
  cl_ushort4 *vector;
  int n;

  vector = (cl_ushort4*)xmalloc(sizeof(cl_ushort4));
  if (argc == 1) {
    Check_Type(argv[0], T_ARRAY);
    if (RARRAY_LEN(argv[0])==4) {
      VALUE *ptr = (VALUE*)RARRAY_PTR(argv[0]);
      for (n=0; n<4; n++)
        vector[0][n] = (uint16_t)NUM2UINT(ptr[n]);
    }
  } else if (argc == 4) {
      for (n=0; n<4; n++)
        vector[0][n] = (uint16_t)NUM2UINT(argv[n]);
  } else {
    rb_raise(rb_eArgError, "wrong number of arguments (%d for 4)", argc);
  }
  return Data_Wrap_Struct(rb_cUshort4, 0, vector_free, (void*)vector);
}
VALUE
rb_Ushort4_toA(int argc, VALUE *argv, VALUE self)
{
  cl_ushort4 *vector;

  if (argc > 0)
    rb_raise(rb_eArgError, "wrong number of arguments (%d for 0)", argc);
  Data_Get_Struct(self, cl_ushort4, vector);
  return rb_ary_new3(4, UINT2NUM((uint16_t)(vector[0][0])), UINT2NUM((uint16_t)(vector[0][1])), UINT2NUM((uint16_t)(vector[0][2])), UINT2NUM((uint16_t)(vector[0][3])));
}
VALUE
rb_CreateUshort8(int argc, VALUE *argv, VALUE self)
{
  cl_ushort8 *vector;
  int n;

  vector = (cl_ushort8*)xmalloc(sizeof(cl_ushort8));
  if (argc == 1) {
    Check_Type(argv[0], T_ARRAY);
    if (RARRAY_LEN(argv[0])==8) {
      VALUE *ptr = (VALUE*)RARRAY_PTR(argv[0]);
      for (n=0; n<8; n++)
        vector[0][n] = (uint16_t)NUM2UINT(ptr[n]);
    }
  } else if (argc == 8) {
      for (n=0; n<8; n++)
        vector[0][n] = (uint16_t)NUM2UINT(argv[n]);
  } else {
    rb_raise(rb_eArgError, "wrong number of arguments (%d for 8)", argc);
  }
  return Data_Wrap_Struct(rb_cUshort8, 0, vector_free, (void*)vector);
}
VALUE
rb_Ushort8_toA(int argc, VALUE *argv, VALUE self)
{
  cl_ushort8 *vector;

  if (argc > 0)
    rb_raise(rb_eArgError, "wrong number of arguments (%d for 0)", argc);
  Data_Get_Struct(self, cl_ushort8, vector);
  return rb_ary_new3(8, UINT2NUM((uint16_t)(vector[0][0])), UINT2NUM((uint16_t)(vector[0][1])), UINT2NUM((uint16_t)(vector[0][2])), UINT2NUM((uint16_t)(vector[0][3])), UINT2NUM((uint16_t)(vector[0][4])), UINT2NUM((uint16_t)(vector[0][5])), UINT2NUM((uint16_t)(vector[0][6])), UINT2NUM((uint16_t)(vector[0][7])));
}
VALUE
rb_CreateUshort16(int argc, VALUE *argv, VALUE self)
{
  cl_ushort16 *vector;
  int n;

  vector = (cl_ushort16*)xmalloc(sizeof(cl_ushort16));
  if (argc == 1) {
    Check_Type(argv[0], T_ARRAY);
    if (RARRAY_LEN(argv[0])==16) {
      VALUE *ptr = (VALUE*)RARRAY_PTR(argv[0]);
      for (n=0; n<16; n++)
        vector[0][n] = (uint16_t)NUM2UINT(ptr[n]);
    }
  } else if (argc == 16) {
      for (n=0; n<16; n++)
        vector[0][n] = (uint16_t)NUM2UINT(argv[n]);
  } else {
    rb_raise(rb_eArgError, "wrong number of arguments (%d for 16)", argc);
  }
  return Data_Wrap_Struct(rb_cUshort16, 0, vector_free, (void*)vector);
}
VALUE
rb_Ushort16_toA(int argc, VALUE *argv, VALUE self)
{
  cl_ushort16 *vector;

  if (argc > 0)
    rb_raise(rb_eArgError, "wrong number of arguments (%d for 0)", argc);
  Data_Get_Struct(self, cl_ushort16, vector);
  return rb_ary_new3(16, UINT2NUM((uint16_t)(vector[0][0])), UINT2NUM((uint16_t)(vector[0][1])), UINT2NUM((uint16_t)(vector[0][2])), UINT2NUM((uint16_t)(vector[0][3])), UINT2NUM((uint16_t)(vector[0][4])), UINT2NUM((uint16_t)(vector[0][5])), UINT2NUM((uint16_t)(vector[0][6])), UINT2NUM((uint16_t)(vector[0][7])), UINT2NUM((uint16_t)(vector[0][8])), UINT2NUM((uint16_t)(vector[0][9])), UINT2NUM((uint16_t)(vector[0][10])), UINT2NUM((uint16_t)(vector[0][11])), UINT2NUM((uint16_t)(vector[0][12])), UINT2NUM((uint16_t)(vector[0][13])), UINT2NUM((uint16_t)(vector[0][14])), UINT2NUM((uint16_t)(vector[0][15])));
}
VALUE
rb_CreateInt2(int argc, VALUE *argv, VALUE self)
{
  cl_int2 *vector;
  int n;

  vector = (cl_int2*)xmalloc(sizeof(cl_int2));
  if (argc == 1) {
    Check_Type(argv[0], T_ARRAY);
    if (RARRAY_LEN(argv[0])==2) {
      VALUE *ptr = (VALUE*)RARRAY_PTR(argv[0]);
      for (n=0; n<2; n++)
        vector[0][n] = (int32_t)NUM2INT(ptr[n]);
    }
  } else if (argc == 2) {
      for (n=0; n<2; n++)
        vector[0][n] = (int32_t)NUM2INT(argv[n]);
  } else {
    rb_raise(rb_eArgError, "wrong number of arguments (%d for 2)", argc);
  }
  return Data_Wrap_Struct(rb_cInt2, 0, vector_free, (void*)vector);
}
VALUE
rb_Int2_toA(int argc, VALUE *argv, VALUE self)
{
  cl_int2 *vector;

  if (argc > 0)
    rb_raise(rb_eArgError, "wrong number of arguments (%d for 0)", argc);
  Data_Get_Struct(self, cl_int2, vector);
  return rb_ary_new3(2, INT2NUM((int32_t)(vector[0][0])), INT2NUM((int32_t)(vector[0][1])));
}
VALUE
rb_CreateInt4(int argc, VALUE *argv, VALUE self)
{
  cl_int4 *vector;
  int n;

  vector = (cl_int4*)xmalloc(sizeof(cl_int4));
  if (argc == 1) {
    Check_Type(argv[0], T_ARRAY);
    if (RARRAY_LEN(argv[0])==4) {
      VALUE *ptr = (VALUE*)RARRAY_PTR(argv[0]);
      for (n=0; n<4; n++)
        vector[0][n] = (int32_t)NUM2INT(ptr[n]);
    }
  } else if (argc == 4) {
      for (n=0; n<4; n++)
        vector[0][n] = (int32_t)NUM2INT(argv[n]);
  } else {
    rb_raise(rb_eArgError, "wrong number of arguments (%d for 4)", argc);
  }
  return Data_Wrap_Struct(rb_cInt4, 0, vector_free, (void*)vector);
}
VALUE
rb_Int4_toA(int argc, VALUE *argv, VALUE self)
{
  cl_int4 *vector;

  if (argc > 0)
    rb_raise(rb_eArgError, "wrong number of arguments (%d for 0)", argc);
  Data_Get_Struct(self, cl_int4, vector);
  return rb_ary_new3(4, INT2NUM((int32_t)(vector[0][0])), INT2NUM((int32_t)(vector[0][1])), INT2NUM((int32_t)(vector[0][2])), INT2NUM((int32_t)(vector[0][3])));
}
VALUE
rb_CreateInt8(int argc, VALUE *argv, VALUE self)
{
  cl_int8 *vector;
  int n;

  vector = (cl_int8*)xmalloc(sizeof(cl_int8));
  if (argc == 1) {
    Check_Type(argv[0], T_ARRAY);
    if (RARRAY_LEN(argv[0])==8) {
      VALUE *ptr = (VALUE*)RARRAY_PTR(argv[0]);
      for (n=0; n<8; n++)
        vector[0][n] = (int32_t)NUM2INT(ptr[n]);
    }
  } else if (argc == 8) {
      for (n=0; n<8; n++)
        vector[0][n] = (int32_t)NUM2INT(argv[n]);
  } else {
    rb_raise(rb_eArgError, "wrong number of arguments (%d for 8)", argc);
  }
  return Data_Wrap_Struct(rb_cInt8, 0, vector_free, (void*)vector);
}
VALUE
rb_Int8_toA(int argc, VALUE *argv, VALUE self)
{
  cl_int8 *vector;

  if (argc > 0)
    rb_raise(rb_eArgError, "wrong number of arguments (%d for 0)", argc);
  Data_Get_Struct(self, cl_int8, vector);
  return rb_ary_new3(8, INT2NUM((int32_t)(vector[0][0])), INT2NUM((int32_t)(vector[0][1])), INT2NUM((int32_t)(vector[0][2])), INT2NUM((int32_t)(vector[0][3])), INT2NUM((int32_t)(vector[0][4])), INT2NUM((int32_t)(vector[0][5])), INT2NUM((int32_t)(vector[0][6])), INT2NUM((int32_t)(vector[0][7])));
}
VALUE
rb_CreateInt16(int argc, VALUE *argv, VALUE self)
{
  cl_int16 *vector;
  int n;

  vector = (cl_int16*)xmalloc(sizeof(cl_int16));
  if (argc == 1) {
    Check_Type(argv[0], T_ARRAY);
    if (RARRAY_LEN(argv[0])==16) {
      VALUE *ptr = (VALUE*)RARRAY_PTR(argv[0]);
      for (n=0; n<16; n++)
        vector[0][n] = (int32_t)NUM2INT(ptr[n]);
    }
  } else if (argc == 16) {
      for (n=0; n<16; n++)
        vector[0][n] = (int32_t)NUM2INT(argv[n]);
  } else {
    rb_raise(rb_eArgError, "wrong number of arguments (%d for 16)", argc);
  }
  return Data_Wrap_Struct(rb_cInt16, 0, vector_free, (void*)vector);
}
VALUE
rb_Int16_toA(int argc, VALUE *argv, VALUE self)
{
  cl_int16 *vector;

  if (argc > 0)
    rb_raise(rb_eArgError, "wrong number of arguments (%d for 0)", argc);
  Data_Get_Struct(self, cl_int16, vector);
  return rb_ary_new3(16, INT2NUM((int32_t)(vector[0][0])), INT2NUM((int32_t)(vector[0][1])), INT2NUM((int32_t)(vector[0][2])), INT2NUM((int32_t)(vector[0][3])), INT2NUM((int32_t)(vector[0][4])), INT2NUM((int32_t)(vector[0][5])), INT2NUM((int32_t)(vector[0][6])), INT2NUM((int32_t)(vector[0][7])), INT2NUM((int32_t)(vector[0][8])), INT2NUM((int32_t)(vector[0][9])), INT2NUM((int32_t)(vector[0][10])), INT2NUM((int32_t)(vector[0][11])), INT2NUM((int32_t)(vector[0][12])), INT2NUM((int32_t)(vector[0][13])), INT2NUM((int32_t)(vector[0][14])), INT2NUM((int32_t)(vector[0][15])));
}
VALUE
rb_CreateUint2(int argc, VALUE *argv, VALUE self)
{
  cl_uint2 *vector;
  int n;

  vector = (cl_uint2*)xmalloc(sizeof(cl_uint2));
  if (argc == 1) {
    Check_Type(argv[0], T_ARRAY);
    if (RARRAY_LEN(argv[0])==2) {
      VALUE *ptr = (VALUE*)RARRAY_PTR(argv[0]);
      for (n=0; n<2; n++)
        vector[0][n] = (uint32_t)NUM2UINT(ptr[n]);
    }
  } else if (argc == 2) {
      for (n=0; n<2; n++)
        vector[0][n] = (uint32_t)NUM2UINT(argv[n]);
  } else {
    rb_raise(rb_eArgError, "wrong number of arguments (%d for 2)", argc);
  }
  return Data_Wrap_Struct(rb_cUint2, 0, vector_free, (void*)vector);
}
VALUE
rb_Uint2_toA(int argc, VALUE *argv, VALUE self)
{
  cl_uint2 *vector;

  if (argc > 0)
    rb_raise(rb_eArgError, "wrong number of arguments (%d for 0)", argc);
  Data_Get_Struct(self, cl_uint2, vector);
  return rb_ary_new3(2, UINT2NUM((uint32_t)(vector[0][0])), UINT2NUM((uint32_t)(vector[0][1])));
}
VALUE
rb_CreateUint4(int argc, VALUE *argv, VALUE self)
{
  cl_uint4 *vector;
  int n;

  vector = (cl_uint4*)xmalloc(sizeof(cl_uint4));
  if (argc == 1) {
    Check_Type(argv[0], T_ARRAY);
    if (RARRAY_LEN(argv[0])==4) {
      VALUE *ptr = (VALUE*)RARRAY_PTR(argv[0]);
      for (n=0; n<4; n++)
        vector[0][n] = (uint32_t)NUM2UINT(ptr[n]);
    }
  } else if (argc == 4) {
      for (n=0; n<4; n++)
        vector[0][n] = (uint32_t)NUM2UINT(argv[n]);
  } else {
    rb_raise(rb_eArgError, "wrong number of arguments (%d for 4)", argc);
  }
  return Data_Wrap_Struct(rb_cUint4, 0, vector_free, (void*)vector);
}
VALUE
rb_Uint4_toA(int argc, VALUE *argv, VALUE self)
{
  cl_uint4 *vector;

  if (argc > 0)
    rb_raise(rb_eArgError, "wrong number of arguments (%d for 0)", argc);
  Data_Get_Struct(self, cl_uint4, vector);
  return rb_ary_new3(4, UINT2NUM((uint32_t)(vector[0][0])), UINT2NUM((uint32_t)(vector[0][1])), UINT2NUM((uint32_t)(vector[0][2])), UINT2NUM((uint32_t)(vector[0][3])));
}
VALUE
rb_CreateUint8(int argc, VALUE *argv, VALUE self)
{
  cl_uint8 *vector;
  int n;

  vector = (cl_uint8*)xmalloc(sizeof(cl_uint8));
  if (argc == 1) {
    Check_Type(argv[0], T_ARRAY);
    if (RARRAY_LEN(argv[0])==8) {
      VALUE *ptr = (VALUE*)RARRAY_PTR(argv[0]);
      for (n=0; n<8; n++)
        vector[0][n] = (uint32_t)NUM2UINT(ptr[n]);
    }
  } else if (argc == 8) {
      for (n=0; n<8; n++)
        vector[0][n] = (uint32_t)NUM2UINT(argv[n]);
  } else {
    rb_raise(rb_eArgError, "wrong number of arguments (%d for 8)", argc);
  }
  return Data_Wrap_Struct(rb_cUint8, 0, vector_free, (void*)vector);
}
VALUE
rb_Uint8_toA(int argc, VALUE *argv, VALUE self)
{
  cl_uint8 *vector;

  if (argc > 0)
    rb_raise(rb_eArgError, "wrong number of arguments (%d for 0)", argc);
  Data_Get_Struct(self, cl_uint8, vector);
  return rb_ary_new3(8, UINT2NUM((uint32_t)(vector[0][0])), UINT2NUM((uint32_t)(vector[0][1])), UINT2NUM((uint32_t)(vector[0][2])), UINT2NUM((uint32_t)(vector[0][3])), UINT2NUM((uint32_t)(vector[0][4])), UINT2NUM((uint32_t)(vector[0][5])), UINT2NUM((uint32_t)(vector[0][6])), UINT2NUM((uint32_t)(vector[0][7])));
}
VALUE
rb_CreateUint16(int argc, VALUE *argv, VALUE self)
{
  cl_uint16 *vector;
  int n;

  vector = (cl_uint16*)xmalloc(sizeof(cl_uint16));
  if (argc == 1) {
    Check_Type(argv[0], T_ARRAY);
    if (RARRAY_LEN(argv[0])==16) {
      VALUE *ptr = (VALUE*)RARRAY_PTR(argv[0]);
      for (n=0; n<16; n++)
        vector[0][n] = (uint32_t)NUM2UINT(ptr[n]);
    }
  } else if (argc == 16) {
      for (n=0; n<16; n++)
        vector[0][n] = (uint32_t)NUM2UINT(argv[n]);
  } else {
    rb_raise(rb_eArgError, "wrong number of arguments (%d for 16)", argc);
  }
  return Data_Wrap_Struct(rb_cUint16, 0, vector_free, (void*)vector);
}
VALUE
rb_Uint16_toA(int argc, VALUE *argv, VALUE self)
{
  cl_uint16 *vector;

  if (argc > 0)
    rb_raise(rb_eArgError, "wrong number of arguments (%d for 0)", argc);
  Data_Get_Struct(self, cl_uint16, vector);
  return rb_ary_new3(16, UINT2NUM((uint32_t)(vector[0][0])), UINT2NUM((uint32_t)(vector[0][1])), UINT2NUM((uint32_t)(vector[0][2])), UINT2NUM((uint32_t)(vector[0][3])), UINT2NUM((uint32_t)(vector[0][4])), UINT2NUM((uint32_t)(vector[0][5])), UINT2NUM((uint32_t)(vector[0][6])), UINT2NUM((uint32_t)(vector[0][7])), UINT2NUM((uint32_t)(vector[0][8])), UINT2NUM((uint32_t)(vector[0][9])), UINT2NUM((uint32_t)(vector[0][10])), UINT2NUM((uint32_t)(vector[0][11])), UINT2NUM((uint32_t)(vector[0][12])), UINT2NUM((uint32_t)(vector[0][13])), UINT2NUM((uint32_t)(vector[0][14])), UINT2NUM((uint32_t)(vector[0][15])));
}
VALUE
rb_CreateLong2(int argc, VALUE *argv, VALUE self)
{
  cl_long2 *vector;
  int n;

  vector = (cl_long2*)xmalloc(sizeof(cl_long2));
  if (argc == 1) {
    Check_Type(argv[0], T_ARRAY);
    if (RARRAY_LEN(argv[0])==2) {
      VALUE *ptr = (VALUE*)RARRAY_PTR(argv[0]);
      for (n=0; n<2; n++)
        vector[0][n] = NUM2LONG(ptr[n]);
    }
  } else if (argc == 2) {
      for (n=0; n<2; n++)
        vector[0][n] = NUM2LONG(argv[n]);
  } else {
    rb_raise(rb_eArgError, "wrong number of arguments (%d for 2)", argc);
  }
  return Data_Wrap_Struct(rb_cLong2, 0, vector_free, (void*)vector);
}
VALUE
rb_Long2_toA(int argc, VALUE *argv, VALUE self)
{
  cl_long2 *vector;

  if (argc > 0)
    rb_raise(rb_eArgError, "wrong number of arguments (%d for 0)", argc);
  Data_Get_Struct(self, cl_long2, vector);
  return rb_ary_new3(2, LONG2NUM((int64_t)(vector[0][0])), LONG2NUM((int64_t)(vector[0][1])));
}
VALUE
rb_CreateLong4(int argc, VALUE *argv, VALUE self)
{
  cl_long4 *vector;
  int n;

  vector = (cl_long4*)xmalloc(sizeof(cl_long4));
  if (argc == 1) {
    Check_Type(argv[0], T_ARRAY);
    if (RARRAY_LEN(argv[0])==4) {
      VALUE *ptr = (VALUE*)RARRAY_PTR(argv[0]);
      for (n=0; n<4; n++)
        vector[0][n] = NUM2LONG(ptr[n]);
    }
  } else if (argc == 4) {
      for (n=0; n<4; n++)
        vector[0][n] = NUM2LONG(argv[n]);
  } else {
    rb_raise(rb_eArgError, "wrong number of arguments (%d for 4)", argc);
  }
  return Data_Wrap_Struct(rb_cLong4, 0, vector_free, (void*)vector);
}
VALUE
rb_Long4_toA(int argc, VALUE *argv, VALUE self)
{
  cl_long4 *vector;

  if (argc > 0)
    rb_raise(rb_eArgError, "wrong number of arguments (%d for 0)", argc);
  Data_Get_Struct(self, cl_long4, vector);
  return rb_ary_new3(4, LONG2NUM((int64_t)(vector[0][0])), LONG2NUM((int64_t)(vector[0][1])), LONG2NUM((int64_t)(vector[0][2])), LONG2NUM((int64_t)(vector[0][3])));
}
VALUE
rb_CreateLong8(int argc, VALUE *argv, VALUE self)
{
  cl_long8 *vector;
  int n;

  vector = (cl_long8*)xmalloc(sizeof(cl_long8));
  if (argc == 1) {
    Check_Type(argv[0], T_ARRAY);
    if (RARRAY_LEN(argv[0])==8) {
      VALUE *ptr = (VALUE*)RARRAY_PTR(argv[0]);
      for (n=0; n<8; n++)
        vector[0][n] = NUM2LONG(ptr[n]);
    }
  } else if (argc == 8) {
      for (n=0; n<8; n++)
        vector[0][n] = NUM2LONG(argv[n]);
  } else {
    rb_raise(rb_eArgError, "wrong number of arguments (%d for 8)", argc);
  }
  return Data_Wrap_Struct(rb_cLong8, 0, vector_free, (void*)vector);
}
VALUE
rb_Long8_toA(int argc, VALUE *argv, VALUE self)
{
  cl_long8 *vector;

  if (argc > 0)
    rb_raise(rb_eArgError, "wrong number of arguments (%d for 0)", argc);
  Data_Get_Struct(self, cl_long8, vector);
  return rb_ary_new3(8, LONG2NUM((int64_t)(vector[0][0])), LONG2NUM((int64_t)(vector[0][1])), LONG2NUM((int64_t)(vector[0][2])), LONG2NUM((int64_t)(vector[0][3])), LONG2NUM((int64_t)(vector[0][4])), LONG2NUM((int64_t)(vector[0][5])), LONG2NUM((int64_t)(vector[0][6])), LONG2NUM((int64_t)(vector[0][7])));
}
VALUE
rb_CreateLong16(int argc, VALUE *argv, VALUE self)
{
  cl_long16 *vector;
  int n;

  vector = (cl_long16*)xmalloc(sizeof(cl_long16));
  if (argc == 1) {
    Check_Type(argv[0], T_ARRAY);
    if (RARRAY_LEN(argv[0])==16) {
      VALUE *ptr = (VALUE*)RARRAY_PTR(argv[0]);
      for (n=0; n<16; n++)
        vector[0][n] = NUM2LONG(ptr[n]);
    }
  } else if (argc == 16) {
      for (n=0; n<16; n++)
        vector[0][n] = NUM2LONG(argv[n]);
  } else {
    rb_raise(rb_eArgError, "wrong number of arguments (%d for 16)", argc);
  }
  return Data_Wrap_Struct(rb_cLong16, 0, vector_free, (void*)vector);
}
VALUE
rb_Long16_toA(int argc, VALUE *argv, VALUE self)
{
  cl_long16 *vector;

  if (argc > 0)
    rb_raise(rb_eArgError, "wrong number of arguments (%d for 0)", argc);
  Data_Get_Struct(self, cl_long16, vector);
  return rb_ary_new3(16, LONG2NUM((int64_t)(vector[0][0])), LONG2NUM((int64_t)(vector[0][1])), LONG2NUM((int64_t)(vector[0][2])), LONG2NUM((int64_t)(vector[0][3])), LONG2NUM((int64_t)(vector[0][4])), LONG2NUM((int64_t)(vector[0][5])), LONG2NUM((int64_t)(vector[0][6])), LONG2NUM((int64_t)(vector[0][7])), LONG2NUM((int64_t)(vector[0][8])), LONG2NUM((int64_t)(vector[0][9])), LONG2NUM((int64_t)(vector[0][10])), LONG2NUM((int64_t)(vector[0][11])), LONG2NUM((int64_t)(vector[0][12])), LONG2NUM((int64_t)(vector[0][13])), LONG2NUM((int64_t)(vector[0][14])), LONG2NUM((int64_t)(vector[0][15])));
}
VALUE
rb_CreateUlong2(int argc, VALUE *argv, VALUE self)
{
  cl_ulong2 *vector;
  int n;

  vector = (cl_ulong2*)xmalloc(sizeof(cl_ulong2));
  if (argc == 1) {
    Check_Type(argv[0], T_ARRAY);
    if (RARRAY_LEN(argv[0])==2) {
      VALUE *ptr = (VALUE*)RARRAY_PTR(argv[0]);
      for (n=0; n<2; n++)
        vector[0][n] = (uint64_t)NUM2ULONG(ptr[n]);
    }
  } else if (argc == 2) {
      for (n=0; n<2; n++)
        vector[0][n] = (uint64_t)NUM2ULONG(argv[n]);
  } else {
    rb_raise(rb_eArgError, "wrong number of arguments (%d for 2)", argc);
  }
  return Data_Wrap_Struct(rb_cUlong2, 0, vector_free, (void*)vector);
}
VALUE
rb_Ulong2_toA(int argc, VALUE *argv, VALUE self)
{
  cl_ulong2 *vector;

  if (argc > 0)
    rb_raise(rb_eArgError, "wrong number of arguments (%d for 0)", argc);
  Data_Get_Struct(self, cl_ulong2, vector);
  return rb_ary_new3(2, ULONG2NUM((uint64_t)(vector[0][0])), ULONG2NUM((uint64_t)(vector[0][1])));
}
VALUE
rb_CreateUlong4(int argc, VALUE *argv, VALUE self)
{
  cl_ulong4 *vector;
  int n;

  vector = (cl_ulong4*)xmalloc(sizeof(cl_ulong4));
  if (argc == 1) {
    Check_Type(argv[0], T_ARRAY);
    if (RARRAY_LEN(argv[0])==4) {
      VALUE *ptr = (VALUE*)RARRAY_PTR(argv[0]);
      for (n=0; n<4; n++)
        vector[0][n] = (uint64_t)NUM2ULONG(ptr[n]);
    }
  } else if (argc == 4) {
      for (n=0; n<4; n++)
        vector[0][n] = (uint64_t)NUM2ULONG(argv[n]);
  } else {
    rb_raise(rb_eArgError, "wrong number of arguments (%d for 4)", argc);
  }
  return Data_Wrap_Struct(rb_cUlong4, 0, vector_free, (void*)vector);
}
VALUE
rb_Ulong4_toA(int argc, VALUE *argv, VALUE self)
{
  cl_ulong4 *vector;

  if (argc > 0)
    rb_raise(rb_eArgError, "wrong number of arguments (%d for 0)", argc);
  Data_Get_Struct(self, cl_ulong4, vector);
  return rb_ary_new3(4, ULONG2NUM((uint64_t)(vector[0][0])), ULONG2NUM((uint64_t)(vector[0][1])), ULONG2NUM((uint64_t)(vector[0][2])), ULONG2NUM((uint64_t)(vector[0][3])));
}
VALUE
rb_CreateUlong8(int argc, VALUE *argv, VALUE self)
{
  cl_ulong8 *vector;
  int n;

  vector = (cl_ulong8*)xmalloc(sizeof(cl_ulong8));
  if (argc == 1) {
    Check_Type(argv[0], T_ARRAY);
    if (RARRAY_LEN(argv[0])==8) {
      VALUE *ptr = (VALUE*)RARRAY_PTR(argv[0]);
      for (n=0; n<8; n++)
        vector[0][n] = (uint64_t)NUM2ULONG(ptr[n]);
    }
  } else if (argc == 8) {
      for (n=0; n<8; n++)
        vector[0][n] = (uint64_t)NUM2ULONG(argv[n]);
  } else {
    rb_raise(rb_eArgError, "wrong number of arguments (%d for 8)", argc);
  }
  return Data_Wrap_Struct(rb_cUlong8, 0, vector_free, (void*)vector);
}
VALUE
rb_Ulong8_toA(int argc, VALUE *argv, VALUE self)
{
  cl_ulong8 *vector;

  if (argc > 0)
    rb_raise(rb_eArgError, "wrong number of arguments (%d for 0)", argc);
  Data_Get_Struct(self, cl_ulong8, vector);
  return rb_ary_new3(8, ULONG2NUM((uint64_t)(vector[0][0])), ULONG2NUM((uint64_t)(vector[0][1])), ULONG2NUM((uint64_t)(vector[0][2])), ULONG2NUM((uint64_t)(vector[0][3])), ULONG2NUM((uint64_t)(vector[0][4])), ULONG2NUM((uint64_t)(vector[0][5])), ULONG2NUM((uint64_t)(vector[0][6])), ULONG2NUM((uint64_t)(vector[0][7])));
}
VALUE
rb_CreateUlong16(int argc, VALUE *argv, VALUE self)
{
  cl_ulong16 *vector;
  int n;

  vector = (cl_ulong16*)xmalloc(sizeof(cl_ulong16));
  if (argc == 1) {
    Check_Type(argv[0], T_ARRAY);
    if (RARRAY_LEN(argv[0])==16) {
      VALUE *ptr = (VALUE*)RARRAY_PTR(argv[0]);
      for (n=0; n<16; n++)
        vector[0][n] = (uint64_t)NUM2ULONG(ptr[n]);
    }
  } else if (argc == 16) {
      for (n=0; n<16; n++)
        vector[0][n] = (uint64_t)NUM2ULONG(argv[n]);
  } else {
    rb_raise(rb_eArgError, "wrong number of arguments (%d for 16)", argc);
  }
  return Data_Wrap_Struct(rb_cUlong16, 0, vector_free, (void*)vector);
}
VALUE
rb_Ulong16_toA(int argc, VALUE *argv, VALUE self)
{
  cl_ulong16 *vector;

  if (argc > 0)
    rb_raise(rb_eArgError, "wrong number of arguments (%d for 0)", argc);
  Data_Get_Struct(self, cl_ulong16, vector);
  return rb_ary_new3(16, ULONG2NUM((uint64_t)(vector[0][0])), ULONG2NUM((uint64_t)(vector[0][1])), ULONG2NUM((uint64_t)(vector[0][2])), ULONG2NUM((uint64_t)(vector[0][3])), ULONG2NUM((uint64_t)(vector[0][4])), ULONG2NUM((uint64_t)(vector[0][5])), ULONG2NUM((uint64_t)(vector[0][6])), ULONG2NUM((uint64_t)(vector[0][7])), ULONG2NUM((uint64_t)(vector[0][8])), ULONG2NUM((uint64_t)(vector[0][9])), ULONG2NUM((uint64_t)(vector[0][10])), ULONG2NUM((uint64_t)(vector[0][11])), ULONG2NUM((uint64_t)(vector[0][12])), ULONG2NUM((uint64_t)(vector[0][13])), ULONG2NUM((uint64_t)(vector[0][14])), ULONG2NUM((uint64_t)(vector[0][15])));
}
VALUE
rb_CreateFloat2(int argc, VALUE *argv, VALUE self)
{
  cl_float2 *vector;
  int n;

  vector = (cl_float2*)xmalloc(sizeof(cl_float2));
  if (argc == 1) {
    Check_Type(argv[0], T_ARRAY);
    if (RARRAY_LEN(argv[0])==2) {
      VALUE *ptr = (VALUE*)RARRAY_PTR(argv[0]);
      for (n=0; n<2; n++)
        vector[0][n] = (float)NUM2DBL(ptr[n]);
    }
  } else if (argc == 2) {
      for (n=0; n<2; n++)
        vector[0][n] = (float)NUM2DBL(argv[n]);
  } else {
    rb_raise(rb_eArgError, "wrong number of arguments (%d for 2)", argc);
  }
  return Data_Wrap_Struct(rb_cFloat2, 0, vector_free, (void*)vector);
}
VALUE
rb_Float2_toA(int argc, VALUE *argv, VALUE self)
{
  cl_float2 *vector;

  if (argc > 0)
    rb_raise(rb_eArgError, "wrong number of arguments (%d for 0)", argc);
  Data_Get_Struct(self, cl_float2, vector);
  return rb_ary_new3(2, rb_float_new((double)(vector[0][0])), rb_float_new((double)(vector[0][1])));
}
VALUE
rb_CreateFloat4(int argc, VALUE *argv, VALUE self)
{
  cl_float4 *vector;
  int n;

  vector = (cl_float4*)xmalloc(sizeof(cl_float4));
  if (argc == 1) {
    Check_Type(argv[0], T_ARRAY);
    if (RARRAY_LEN(argv[0])==4) {
      VALUE *ptr = (VALUE*)RARRAY_PTR(argv[0]);
      for (n=0; n<4; n++)
        vector[0][n] = (float)NUM2DBL(ptr[n]);
    }
  } else if (argc == 4) {
      for (n=0; n<4; n++)
        vector[0][n] = (float)NUM2DBL(argv[n]);
  } else {
    rb_raise(rb_eArgError, "wrong number of arguments (%d for 4)", argc);
  }
  return Data_Wrap_Struct(rb_cFloat4, 0, vector_free, (void*)vector);
}
VALUE
rb_Float4_toA(int argc, VALUE *argv, VALUE self)
{
  cl_float4 *vector;

  if (argc > 0)
    rb_raise(rb_eArgError, "wrong number of arguments (%d for 0)", argc);
  Data_Get_Struct(self, cl_float4, vector);
  return rb_ary_new3(4, rb_float_new((double)(vector[0][0])), rb_float_new((double)(vector[0][1])), rb_float_new((double)(vector[0][2])), rb_float_new((double)(vector[0][3])));
}
VALUE
rb_CreateFloat8(int argc, VALUE *argv, VALUE self)
{
  cl_float8 *vector;
  int n;

  vector = (cl_float8*)xmalloc(sizeof(cl_float8));
  if (argc == 1) {
    Check_Type(argv[0], T_ARRAY);
    if (RARRAY_LEN(argv[0])==8) {
      VALUE *ptr = (VALUE*)RARRAY_PTR(argv[0]);
      for (n=0; n<8; n++)
        vector[0][n] = (float)NUM2DBL(ptr[n]);
    }
  } else if (argc == 8) {
      for (n=0; n<8; n++)
        vector[0][n] = (float)NUM2DBL(argv[n]);
  } else {
    rb_raise(rb_eArgError, "wrong number of arguments (%d for 8)", argc);
  }
  return Data_Wrap_Struct(rb_cFloat8, 0, vector_free, (void*)vector);
}
VALUE
rb_Float8_toA(int argc, VALUE *argv, VALUE self)
{
  cl_float8 *vector;

  if (argc > 0)
    rb_raise(rb_eArgError, "wrong number of arguments (%d for 0)", argc);
  Data_Get_Struct(self, cl_float8, vector);
  return rb_ary_new3(8, rb_float_new((double)(vector[0][0])), rb_float_new((double)(vector[0][1])), rb_float_new((double)(vector[0][2])), rb_float_new((double)(vector[0][3])), rb_float_new((double)(vector[0][4])), rb_float_new((double)(vector[0][5])), rb_float_new((double)(vector[0][6])), rb_float_new((double)(vector[0][7])));
}
VALUE
rb_CreateFloat16(int argc, VALUE *argv, VALUE self)
{
  cl_float16 *vector;
  int n;

  vector = (cl_float16*)xmalloc(sizeof(cl_float16));
  if (argc == 1) {
    Check_Type(argv[0], T_ARRAY);
    if (RARRAY_LEN(argv[0])==16) {
      VALUE *ptr = (VALUE*)RARRAY_PTR(argv[0]);
      for (n=0; n<16; n++)
        vector[0][n] = (float)NUM2DBL(ptr[n]);
    }
  } else if (argc == 16) {
      for (n=0; n<16; n++)
        vector[0][n] = (float)NUM2DBL(argv[n]);
  } else {
    rb_raise(rb_eArgError, "wrong number of arguments (%d for 16)", argc);
  }
  return Data_Wrap_Struct(rb_cFloat16, 0, vector_free, (void*)vector);
}
VALUE
rb_Float16_toA(int argc, VALUE *argv, VALUE self)
{
  cl_float16 *vector;

  if (argc > 0)
    rb_raise(rb_eArgError, "wrong number of arguments (%d for 0)", argc);
  Data_Get_Struct(self, cl_float16, vector);
  return rb_ary_new3(16, rb_float_new((double)(vector[0][0])), rb_float_new((double)(vector[0][1])), rb_float_new((double)(vector[0][2])), rb_float_new((double)(vector[0][3])), rb_float_new((double)(vector[0][4])), rb_float_new((double)(vector[0][5])), rb_float_new((double)(vector[0][6])), rb_float_new((double)(vector[0][7])), rb_float_new((double)(vector[0][8])), rb_float_new((double)(vector[0][9])), rb_float_new((double)(vector[0][10])), rb_float_new((double)(vector[0][11])), rb_float_new((double)(vector[0][12])), rb_float_new((double)(vector[0][13])), rb_float_new((double)(vector[0][14])), rb_float_new((double)(vector[0][15])));
}
static VALUE
create_vector(void *ptr, enum vector_type type, unsigned int n)
{

  switch (type) {
  case VA_CHAR:
    switch (n) {
    case 1:
      return CHR2FIX(((cl_char*)ptr)[0]);
      break;
    case 2:
      return Data_Wrap_Struct(rb_cChar2, 0, vector_free, ptr);
      break;
    case 4:
      return Data_Wrap_Struct(rb_cChar4, 0, vector_free, ptr);
      break;
    case 8:
      return Data_Wrap_Struct(rb_cChar8, 0, vector_free, ptr);
      break;
    case 16:
      return Data_Wrap_Struct(rb_cChar16, 0, vector_free, ptr);
      break;
    default:
      rb_raise(rb_eRuntimeError, "vector type is invalid");
    }
  case VA_UCHAR:
    switch (n) {
    case 1:
      return UINT2NUM((uint8_t)((cl_uchar*)ptr)[0]);
      break;
    case 2:
      return Data_Wrap_Struct(rb_cUchar2, 0, vector_free, ptr);
      break;
    case 4:
      return Data_Wrap_Struct(rb_cUchar4, 0, vector_free, ptr);
      break;
    case 8:
      return Data_Wrap_Struct(rb_cUchar8, 0, vector_free, ptr);
      break;
    case 16:
      return Data_Wrap_Struct(rb_cUchar16, 0, vector_free, ptr);
      break;
    default:
      rb_raise(rb_eRuntimeError, "vector type is invalid");
    }
  case VA_SHORT:
    switch (n) {
    case 1:
      return INT2NUM((int16_t)((cl_short*)ptr)[0]);
      break;
    case 2:
      return Data_Wrap_Struct(rb_cShort2, 0, vector_free, ptr);
      break;
    case 4:
      return Data_Wrap_Struct(rb_cShort4, 0, vector_free, ptr);
      break;
    case 8:
      return Data_Wrap_Struct(rb_cShort8, 0, vector_free, ptr);
      break;
    case 16:
      return Data_Wrap_Struct(rb_cShort16, 0, vector_free, ptr);
      break;
    default:
      rb_raise(rb_eRuntimeError, "vector type is invalid");
    }
  case VA_USHORT:
    switch (n) {
    case 1:
      return UINT2NUM((uint16_t)((cl_ushort*)ptr)[0]);
      break;
    case 2:
      return Data_Wrap_Struct(rb_cUshort2, 0, vector_free, ptr);
      break;
    case 4:
      return Data_Wrap_Struct(rb_cUshort4, 0, vector_free, ptr);
      break;
    case 8:
      return Data_Wrap_Struct(rb_cUshort8, 0, vector_free, ptr);
      break;
    case 16:
      return Data_Wrap_Struct(rb_cUshort16, 0, vector_free, ptr);
      break;
    default:
      rb_raise(rb_eRuntimeError, "vector type is invalid");
    }
  case VA_INT:
    switch (n) {
    case 1:
      return INT2NUM((int32_t)((cl_int*)ptr)[0]);
      break;
    case 2:
      return Data_Wrap_Struct(rb_cInt2, 0, vector_free, ptr);
      break;
    case 4:
      return Data_Wrap_Struct(rb_cInt4, 0, vector_free, ptr);
      break;
    case 8:
      return Data_Wrap_Struct(rb_cInt8, 0, vector_free, ptr);
      break;
    case 16:
      return Data_Wrap_Struct(rb_cInt16, 0, vector_free, ptr);
      break;
    default:
      rb_raise(rb_eRuntimeError, "vector type is invalid");
    }
  case VA_UINT:
    switch (n) {
    case 1:
      return UINT2NUM((uint32_t)((cl_uint*)ptr)[0]);
      break;
    case 2:
      return Data_Wrap_Struct(rb_cUint2, 0, vector_free, ptr);
      break;
    case 4:
      return Data_Wrap_Struct(rb_cUint4, 0, vector_free, ptr);
      break;
    case 8:
      return Data_Wrap_Struct(rb_cUint8, 0, vector_free, ptr);
      break;
    case 16:
      return Data_Wrap_Struct(rb_cUint16, 0, vector_free, ptr);
      break;
    default:
      rb_raise(rb_eRuntimeError, "vector type is invalid");
    }
  case VA_LONG:
    switch (n) {
    case 1:
      return LONG2NUM((int64_t)((cl_long*)ptr)[0]);
      break;
    case 2:
      return Data_Wrap_Struct(rb_cLong2, 0, vector_free, ptr);
      break;
    case 4:
      return Data_Wrap_Struct(rb_cLong4, 0, vector_free, ptr);
      break;
    case 8:
      return Data_Wrap_Struct(rb_cLong8, 0, vector_free, ptr);
      break;
    case 16:
      return Data_Wrap_Struct(rb_cLong16, 0, vector_free, ptr);
      break;
    default:
      rb_raise(rb_eRuntimeError, "vector type is invalid");
    }
  case VA_ULONG:
    switch (n) {
    case 1:
      return ULONG2NUM((uint64_t)((cl_ulong*)ptr)[0]);
      break;
    case 2:
      return Data_Wrap_Struct(rb_cUlong2, 0, vector_free, ptr);
      break;
    case 4:
      return Data_Wrap_Struct(rb_cUlong4, 0, vector_free, ptr);
      break;
    case 8:
      return Data_Wrap_Struct(rb_cUlong8, 0, vector_free, ptr);
      break;
    case 16:
      return Data_Wrap_Struct(rb_cUlong16, 0, vector_free, ptr);
      break;
    default:
      rb_raise(rb_eRuntimeError, "vector type is invalid");
    }
  case VA_FLOAT:
    switch (n) {
    case 1:
      return rb_float_new((double)((cl_float*)ptr)[0]);
      break;
    case 2:
      return Data_Wrap_Struct(rb_cFloat2, 0, vector_free, ptr);
      break;
    case 4:
      return Data_Wrap_Struct(rb_cFloat4, 0, vector_free, ptr);
      break;
    case 8:
      return Data_Wrap_Struct(rb_cFloat8, 0, vector_free, ptr);
      break;
    case 16:
      return Data_Wrap_Struct(rb_cFloat16, 0, vector_free, ptr);
      break;
    default:
      rb_raise(rb_eRuntimeError, "vector type is invalid");
    }
  default:
    rb_raise(rb_eRuntimeError, "vector type is invalid");
  }
  return Qnil;
}

static void
varray_free(struct_array *s_array)
{
  if (s_array->obj == Qnil)
    xfree(s_array->ptr);
  xfree(s_array);
}
static void
varray_mark(struct_array *s_array)
{
  if (s_array->obj != Qnil)
    rb_gc_mark(s_array->obj);
}
static size_t
data_size(enum vector_type type, unsigned int n)
{
  switch (type) {
  case VA_CHAR:
    switch (n) {
    case 1:
      return sizeof(cl_char);
      break;
    case 2:
      return sizeof(cl_char2);
      break;
    case 4:
      return sizeof(cl_char4);
      break;
    case 8:
      return sizeof(cl_char8);
      break;
    case 16:
      return sizeof(cl_char16);
      break;
    default:
      rb_raise(rb_eRuntimeError, "vector type is invalid: type_code=%d, n=%d", type, n);
    }
  case VA_UCHAR:
    switch (n) {
    case 1:
      return sizeof(cl_uchar);
      break;
    case 2:
      return sizeof(cl_uchar2);
      break;
    case 4:
      return sizeof(cl_uchar4);
      break;
    case 8:
      return sizeof(cl_uchar8);
      break;
    case 16:
      return sizeof(cl_uchar16);
      break;
    default:
      rb_raise(rb_eRuntimeError, "vector type is invalid: type_code=%d, n=%d", type, n);
    }
  case VA_SHORT:
    switch (n) {
    case 1:
      return sizeof(cl_short);
      break;
    case 2:
      return sizeof(cl_short2);
      break;
    case 4:
      return sizeof(cl_short4);
      break;
    case 8:
      return sizeof(cl_short8);
      break;
    case 16:
      return sizeof(cl_short16);
      break;
    default:
      rb_raise(rb_eRuntimeError, "vector type is invalid: type_code=%d, n=%d", type, n);
    }
  case VA_USHORT:
    switch (n) {
    case 1:
      return sizeof(cl_ushort);
      break;
    case 2:
      return sizeof(cl_ushort2);
      break;
    case 4:
      return sizeof(cl_ushort4);
      break;
    case 8:
      return sizeof(cl_ushort8);
      break;
    case 16:
      return sizeof(cl_ushort16);
      break;
    default:
      rb_raise(rb_eRuntimeError, "vector type is invalid: type_code=%d, n=%d", type, n);
    }
  case VA_INT:
    switch (n) {
    case 1:
      return sizeof(cl_int);
      break;
    case 2:
      return sizeof(cl_int2);
      break;
    case 4:
      return sizeof(cl_int4);
      break;
    case 8:
      return sizeof(cl_int8);
      break;
    case 16:
      return sizeof(cl_int16);
      break;
    default:
      rb_raise(rb_eRuntimeError, "vector type is invalid: type_code=%d, n=%d", type, n);
    }
  case VA_UINT:
    switch (n) {
    case 1:
      return sizeof(cl_uint);
      break;
    case 2:
      return sizeof(cl_uint2);
      break;
    case 4:
      return sizeof(cl_uint4);
      break;
    case 8:
      return sizeof(cl_uint8);
      break;
    case 16:
      return sizeof(cl_uint16);
      break;
    default:
      rb_raise(rb_eRuntimeError, "vector type is invalid: type_code=%d, n=%d", type, n);
    }
  case VA_LONG:
    switch (n) {
    case 1:
      return sizeof(cl_long);
      break;
    case 2:
      return sizeof(cl_long2);
      break;
    case 4:
      return sizeof(cl_long4);
      break;
    case 8:
      return sizeof(cl_long8);
      break;
    case 16:
      return sizeof(cl_long16);
      break;
    default:
      rb_raise(rb_eRuntimeError, "vector type is invalid: type_code=%d, n=%d", type, n);
    }
  case VA_ULONG:
    switch (n) {
    case 1:
      return sizeof(cl_ulong);
      break;
    case 2:
      return sizeof(cl_ulong2);
      break;
    case 4:
      return sizeof(cl_ulong4);
      break;
    case 8:
      return sizeof(cl_ulong8);
      break;
    case 16:
      return sizeof(cl_ulong16);
      break;
    default:
      rb_raise(rb_eRuntimeError, "vector type is invalid: type_code=%d, n=%d", type, n);
    }
  case VA_FLOAT:
    switch (n) {
    case 1:
      return sizeof(cl_float);
      break;
    case 2:
      return sizeof(cl_float2);
      break;
    case 4:
      return sizeof(cl_float4);
      break;
    case 8:
      return sizeof(cl_float8);
      break;
    case 16:
      return sizeof(cl_float16);
      break;
    default:
      rb_raise(rb_eRuntimeError, "vector type is invalid: type_code=%d, n=%d", type, n);
    }
  default:
    rb_raise(rb_eRuntimeError, "vector type is invalid: type_code=%d, n=%d", type, n);
  }
  return -1;
}
static unsigned int
vector_type_code(enum vector_type type, unsigned int n)
{
  return type*100+n;
}
static void
vector_type_n(unsigned int type_code, enum vector_type *type, unsigned int *n)
{
  *type = type_code/100;
  *n = type_code%100;
}
static VALUE
create_varray(void* ptr, size_t len, enum vector_type type, unsigned int n, size_t size, VALUE obj)
{
  struct_array *s_array;

  s_array = (struct_array*)xmalloc(sizeof(struct_array));
  s_array->ptr = ptr;
  s_array->length = len;
  s_array->type = type;
  s_array->n = n;
  s_array->size = size;
  s_array->obj = obj;
  return Data_Wrap_Struct(rb_cVArray, varray_mark, varray_free, (void*)s_array);
}
VALUE
rb_CreateVArray(int argc, VALUE *argv, VALUE self)
{
  enum vector_type vtype;
  unsigned int n;
  unsigned int len;
  void* ptr;
  size_t size;

  if (argc != 2)
    rb_raise(rb_eArgError, "wrong number of arguments (%d for 2)", argc);
  vector_type_n(NUM2UINT(argv[0]), &vtype, &n);
  len = NUM2UINT(argv[1]);
  size = data_size(vtype, n);
  ptr = (void*)xmalloc(len*size);
  return create_varray(ptr, len, vtype, n, size, Qnil);
}
VALUE
rb_CreateVArrayFromObject(int argc, VALUE *argv, VALUE self)
{
  enum vector_type vtype;
  unsigned int n;
  VALUE obj;
  unsigned int len;
  void* ptr;
  size_t size;

  obj = argv[1];
  if (argc==2 && TYPE(argv[1]) == T_STRING) {
    n = NUM2UINT(argv[0]);
    vector_type_n(n, &vtype, &n);
    obj = argv[1];
    len = RSTRING_LEN(obj);
    size = data_size(vtype, n);
    if (len%size != 0)
      rb_raise(rb_eArgError, "size of the string (%d) is not multiple of size of the type (%d)", len, size);
    len = len/size;
    ptr = (void*) RSTRING_PTR(obj);
#ifdef HAVE_NARRAY_H
  } else if (argc==1 && NA_IsNArray(argv[0])) {
    struct NARRAY* nary;
    int ntype;
    obj = argv[0];
    nary = NA_STRUCT(obj);
    switch (nary->rank) {
    case 1:
      n = 1;
      len = nary->shape[0];
      break;
    case 2:
      n = nary->shape[0];
      len = nary->shape[1];
      if (n!=2 && n!=4 && n!=8 && n!=16)
        rb_raise(rb_eArgError, "shape[0] of narray is invalid");
      break;
    default:
      rb_raise(rb_eArgError, "rank of narray must be 1 or 2");
    }
    ntype = nary->type;
    switch (ntype) {
    case NA_BYTE:
      vtype = VA_CHAR;
      break;
    case NA_SINT:
      vtype = VA_SHORT;
      break;
    case NA_LINT:
      vtype = VA_INT;
      break;
    case NA_SFLOAT:
      vtype = VA_FLOAT;
      break;
//    case NA_DFLOAT;
//      vtype = VA_DOUBLE;
//      break;
    default:
      rb_raise(rb_eArgError, "this type is not supported");
    }
    size = data_size(vtype, n);
    ptr = (void*) nary->ptr;
#endif
  } else {
    rb_raise(rb_eArgError, "wrong number of arguments");
  }

  return create_varray(ptr, len, vtype, n, size, obj);
}
VALUE
rb_VArray_length(int argc, VALUE *argv, VALUE self)
{
  struct_array *s_array;

  if (argc != 0)
    rb_raise(rb_eArgError, "wrong number of arguments (%d for 0)", argc);
  Data_Get_Struct(self, struct_array, s_array);
  return UINT2NUM(s_array->length);
}
VALUE
rb_VArray_toS(int argc, VALUE *argv, VALUE self)
{
  struct_array *s_array;

  if (argc != 0)
    rb_raise(rb_eArgError, "wrong number of arguments (%d for 0)", argc);
  Data_Get_Struct(self, struct_array, s_array);
  return rb_str_new(s_array->ptr, s_array->length*s_array->size);
}
VALUE
rb_VArray_typeCode(int argc, VALUE *argv, VALUE self)
{
  struct_array *s_array;

  if (argc != 0)
    rb_raise(rb_eArgError, "wrong number of arguments (%d for 0)", argc);
  Data_Get_Struct(self, struct_array, s_array);
  return UINT2NUM(vector_type_code(s_array->type,s_array->n));
}
VALUE
rb_VArray_aref(int argc, VALUE *argv, VALUE self)
{
  struct_array *s_array;
  void *ptr;
  size_t size;

  if (argc!=1)
    rb_raise(rb_eArgError, "wrong number of arguments (%d for 1)", argc);
  Data_Get_Struct(self, struct_array, s_array);
  size = s_array->size;
  if (FIXNUM_P(argv[0])) {
    int i = FIX2INT(argv[0]);
    if (i < 0)
      i += (int)s_array->length;
    if (i >= (int)s_array->length)
      rb_raise(rb_eArgError, "index %ld out of array (%ld)", i, s_array->length);
    ptr = (void*)xmalloc(size);
    return create_vector(memcpy(ptr, (s_array->ptr)+size*i, size), s_array->type, s_array->n);
  } else if (rb_class_of(argv[0]) == rb_cRange) {
     long beg, len;
     rb_range_beg_len(argv[0], &beg, &len, s_array->length, 1);
     ptr = (void*)xmalloc(size*len);
     memcpy(ptr, (s_array->ptr)+size*beg, size*len);
     return create_varray(ptr, len, s_array->type, s_array->n, s_array->size, Qnil);
  } else
    rb_raise(rb_eArgError, "wrong type of the 1st argument");

  return Qnil;
}
VALUE
rb_VArray_aset(int argc, VALUE *argv, VALUE self)
{
  struct_array *s_array;
  size_t size;
  long beg, len;
  int i, j;

  if (argc!=2)
    rb_raise(rb_eArgError, "wrong number of arguments (%d for 2)", argc);
  Data_Get_Struct(self, struct_array, s_array);
  if (FIXNUM_P(argv[0])) {
    i = FIX2INT(argv[0]);
    if (i < 0)
      i += (int)s_array->length;
    if (i >= (int)s_array->length)
      rb_raise(rb_eArgError, "index %ld out of array (%ld)", i, s_array->length);
    beg = i;
    len = 1;
  } else if (rb_class_of(argv[0]) == rb_cRange) {
     rb_range_beg_len(argv[0], &beg, &len, s_array->length, 1);
  } else
    rb_raise(rb_eArgError, "wrong type of the 1st argument");
  size = s_array->size;
  if (rb_class_of(argv[1]) == rb_cVArray) {
    struct_array *s_array1;
    Data_Get_Struct(argv[1], struct_array, s_array1);
    if (s_array1->type == s_array->type && s_array1->n == s_array->n && s_array1->length == len) {
      memcpy(s_array->ptr+beg*size, s_array1->ptr, size*len);
      return argv[1];
    } else {
      rb_raise(rb_eArgError, "type_code or length is invalid");
    }
  }
  switch (s_array->type) {
  case VA_CHAR:
    if (rb_obj_is_kind_of(argv[1], rb_cNumeric)==Qtrue) {
      cl_char val = NUM2CHR(argv[1]);
      for (i=beg;i<beg+len;i++)
        for (j=0;j<s_array->n;j++)
          ((cl_char*)s_array->ptr+size*i)[j] = val;
      return argv[1];
    }
    switch (s_array->n) {
    case 2:
      if (rb_class_of(argv[1]) == rb_cChar2) {
        cl_char2 *val;
        Data_Get_Struct(argv[1], cl_char2, val);
        for (i=beg;i<beg+len;i++)
          memcpy(s_array->ptr+size*i, val, size);
        return argv[1];
      } else {
        rb_raise(rb_eArgError, "wrong type of the 2nd argument");
      }
      break;
    case 4:
      if (rb_class_of(argv[1]) == rb_cChar4) {
        cl_char4 *val;
        Data_Get_Struct(argv[1], cl_char4, val);
        for (i=beg;i<beg+len;i++)
          memcpy(s_array->ptr+size*i, val, size);
        return argv[1];
      } else {
        rb_raise(rb_eArgError, "wrong type of the 2nd argument");
      }
      break;
    case 8:
      if (rb_class_of(argv[1]) == rb_cChar8) {
        cl_char8 *val;
        Data_Get_Struct(argv[1], cl_char8, val);
        for (i=beg;i<beg+len;i++)
          memcpy(s_array->ptr+size*i, val, size);
        return argv[1];
      } else {
        rb_raise(rb_eArgError, "wrong type of the 2nd argument");
      }
      break;
    case 16:
      if (rb_class_of(argv[1]) == rb_cChar16) {
        cl_char16 *val;
        Data_Get_Struct(argv[1], cl_char16, val);
        for (i=beg;i<beg+len;i++)
          memcpy(s_array->ptr+size*i, val, size);
        return argv[1];
      } else {
        rb_raise(rb_eArgError, "wrong type of the 2nd argument");
      }
      break;
    default:
      rb_raise(rb_eArgError, "wrong type of the 2nd argument");
    }
    break;
  case VA_UCHAR:
    if (rb_obj_is_kind_of(argv[1], rb_cNumeric)==Qtrue) {
      cl_uchar val = (uint8_t)NUM2UINT(argv[1]);
      for (i=beg;i<beg+len;i++)
        for (j=0;j<s_array->n;j++)
          ((cl_uchar*)s_array->ptr+size*i)[j] = val;
      return argv[1];
    }
    switch (s_array->n) {
    case 2:
      if (rb_class_of(argv[1]) == rb_cUchar2) {
        cl_uchar2 *val;
        Data_Get_Struct(argv[1], cl_uchar2, val);
        for (i=beg;i<beg+len;i++)
          memcpy(s_array->ptr+size*i, val, size);
        return argv[1];
      } else {
        rb_raise(rb_eArgError, "wrong type of the 2nd argument");
      }
      break;
    case 4:
      if (rb_class_of(argv[1]) == rb_cUchar4) {
        cl_uchar4 *val;
        Data_Get_Struct(argv[1], cl_uchar4, val);
        for (i=beg;i<beg+len;i++)
          memcpy(s_array->ptr+size*i, val, size);
        return argv[1];
      } else {
        rb_raise(rb_eArgError, "wrong type of the 2nd argument");
      }
      break;
    case 8:
      if (rb_class_of(argv[1]) == rb_cUchar8) {
        cl_uchar8 *val;
        Data_Get_Struct(argv[1], cl_uchar8, val);
        for (i=beg;i<beg+len;i++)
          memcpy(s_array->ptr+size*i, val, size);
        return argv[1];
      } else {
        rb_raise(rb_eArgError, "wrong type of the 2nd argument");
      }
      break;
    case 16:
      if (rb_class_of(argv[1]) == rb_cUchar16) {
        cl_uchar16 *val;
        Data_Get_Struct(argv[1], cl_uchar16, val);
        for (i=beg;i<beg+len;i++)
          memcpy(s_array->ptr+size*i, val, size);
        return argv[1];
      } else {
        rb_raise(rb_eArgError, "wrong type of the 2nd argument");
      }
      break;
    default:
      rb_raise(rb_eArgError, "wrong type of the 2nd argument");
    }
    break;
  case VA_SHORT:
    if (rb_obj_is_kind_of(argv[1], rb_cNumeric)==Qtrue) {
      cl_short val = (int16_t)NUM2INT(argv[1]);
      for (i=beg;i<beg+len;i++)
        for (j=0;j<s_array->n;j++)
          ((cl_short*)s_array->ptr+size*i)[j] = val;
      return argv[1];
    }
    switch (s_array->n) {
    case 2:
      if (rb_class_of(argv[1]) == rb_cShort2) {
        cl_short2 *val;
        Data_Get_Struct(argv[1], cl_short2, val);
        for (i=beg;i<beg+len;i++)
          memcpy(s_array->ptr+size*i, val, size);
        return argv[1];
      } else {
        rb_raise(rb_eArgError, "wrong type of the 2nd argument");
      }
      break;
    case 4:
      if (rb_class_of(argv[1]) == rb_cShort4) {
        cl_short4 *val;
        Data_Get_Struct(argv[1], cl_short4, val);
        for (i=beg;i<beg+len;i++)
          memcpy(s_array->ptr+size*i, val, size);
        return argv[1];
      } else {
        rb_raise(rb_eArgError, "wrong type of the 2nd argument");
      }
      break;
    case 8:
      if (rb_class_of(argv[1]) == rb_cShort8) {
        cl_short8 *val;
        Data_Get_Struct(argv[1], cl_short8, val);
        for (i=beg;i<beg+len;i++)
          memcpy(s_array->ptr+size*i, val, size);
        return argv[1];
      } else {
        rb_raise(rb_eArgError, "wrong type of the 2nd argument");
      }
      break;
    case 16:
      if (rb_class_of(argv[1]) == rb_cShort16) {
        cl_short16 *val;
        Data_Get_Struct(argv[1], cl_short16, val);
        for (i=beg;i<beg+len;i++)
          memcpy(s_array->ptr+size*i, val, size);
        return argv[1];
      } else {
        rb_raise(rb_eArgError, "wrong type of the 2nd argument");
      }
      break;
    default:
      rb_raise(rb_eArgError, "wrong type of the 2nd argument");
    }
    break;
  case VA_USHORT:
    if (rb_obj_is_kind_of(argv[1], rb_cNumeric)==Qtrue) {
      cl_ushort val = (uint16_t)NUM2UINT(argv[1]);
      for (i=beg;i<beg+len;i++)
        for (j=0;j<s_array->n;j++)
          ((cl_ushort*)s_array->ptr+size*i)[j] = val;
      return argv[1];
    }
    switch (s_array->n) {
    case 2:
      if (rb_class_of(argv[1]) == rb_cUshort2) {
        cl_ushort2 *val;
        Data_Get_Struct(argv[1], cl_ushort2, val);
        for (i=beg;i<beg+len;i++)
          memcpy(s_array->ptr+size*i, val, size);
        return argv[1];
      } else {
        rb_raise(rb_eArgError, "wrong type of the 2nd argument");
      }
      break;
    case 4:
      if (rb_class_of(argv[1]) == rb_cUshort4) {
        cl_ushort4 *val;
        Data_Get_Struct(argv[1], cl_ushort4, val);
        for (i=beg;i<beg+len;i++)
          memcpy(s_array->ptr+size*i, val, size);
        return argv[1];
      } else {
        rb_raise(rb_eArgError, "wrong type of the 2nd argument");
      }
      break;
    case 8:
      if (rb_class_of(argv[1]) == rb_cUshort8) {
        cl_ushort8 *val;
        Data_Get_Struct(argv[1], cl_ushort8, val);
        for (i=beg;i<beg+len;i++)
          memcpy(s_array->ptr+size*i, val, size);
        return argv[1];
      } else {
        rb_raise(rb_eArgError, "wrong type of the 2nd argument");
      }
      break;
    case 16:
      if (rb_class_of(argv[1]) == rb_cUshort16) {
        cl_ushort16 *val;
        Data_Get_Struct(argv[1], cl_ushort16, val);
        for (i=beg;i<beg+len;i++)
          memcpy(s_array->ptr+size*i, val, size);
        return argv[1];
      } else {
        rb_raise(rb_eArgError, "wrong type of the 2nd argument");
      }
      break;
    default:
      rb_raise(rb_eArgError, "wrong type of the 2nd argument");
    }
    break;
  case VA_INT:
    if (rb_obj_is_kind_of(argv[1], rb_cNumeric)==Qtrue) {
      cl_int val = (int32_t)NUM2INT(argv[1]);
      for (i=beg;i<beg+len;i++)
        for (j=0;j<s_array->n;j++)
          ((cl_int*)s_array->ptr+size*i)[j] = val;
      return argv[1];
    }
    switch (s_array->n) {
    case 2:
      if (rb_class_of(argv[1]) == rb_cInt2) {
        cl_int2 *val;
        Data_Get_Struct(argv[1], cl_int2, val);
        for (i=beg;i<beg+len;i++)
          memcpy(s_array->ptr+size*i, val, size);
        return argv[1];
      } else {
        rb_raise(rb_eArgError, "wrong type of the 2nd argument");
      }
      break;
    case 4:
      if (rb_class_of(argv[1]) == rb_cInt4) {
        cl_int4 *val;
        Data_Get_Struct(argv[1], cl_int4, val);
        for (i=beg;i<beg+len;i++)
          memcpy(s_array->ptr+size*i, val, size);
        return argv[1];
      } else {
        rb_raise(rb_eArgError, "wrong type of the 2nd argument");
      }
      break;
    case 8:
      if (rb_class_of(argv[1]) == rb_cInt8) {
        cl_int8 *val;
        Data_Get_Struct(argv[1], cl_int8, val);
        for (i=beg;i<beg+len;i++)
          memcpy(s_array->ptr+size*i, val, size);
        return argv[1];
      } else {
        rb_raise(rb_eArgError, "wrong type of the 2nd argument");
      }
      break;
    case 16:
      if (rb_class_of(argv[1]) == rb_cInt16) {
        cl_int16 *val;
        Data_Get_Struct(argv[1], cl_int16, val);
        for (i=beg;i<beg+len;i++)
          memcpy(s_array->ptr+size*i, val, size);
        return argv[1];
      } else {
        rb_raise(rb_eArgError, "wrong type of the 2nd argument");
      }
      break;
    default:
      rb_raise(rb_eArgError, "wrong type of the 2nd argument");
    }
    break;
  case VA_UINT:
    if (rb_obj_is_kind_of(argv[1], rb_cNumeric)==Qtrue) {
      cl_uint val = (uint32_t)NUM2UINT(argv[1]);
      for (i=beg;i<beg+len;i++)
        for (j=0;j<s_array->n;j++)
          ((cl_uint*)s_array->ptr+size*i)[j] = val;
      return argv[1];
    }
    switch (s_array->n) {
    case 2:
      if (rb_class_of(argv[1]) == rb_cUint2) {
        cl_uint2 *val;
        Data_Get_Struct(argv[1], cl_uint2, val);
        for (i=beg;i<beg+len;i++)
          memcpy(s_array->ptr+size*i, val, size);
        return argv[1];
      } else {
        rb_raise(rb_eArgError, "wrong type of the 2nd argument");
      }
      break;
    case 4:
      if (rb_class_of(argv[1]) == rb_cUint4) {
        cl_uint4 *val;
        Data_Get_Struct(argv[1], cl_uint4, val);
        for (i=beg;i<beg+len;i++)
          memcpy(s_array->ptr+size*i, val, size);
        return argv[1];
      } else {
        rb_raise(rb_eArgError, "wrong type of the 2nd argument");
      }
      break;
    case 8:
      if (rb_class_of(argv[1]) == rb_cUint8) {
        cl_uint8 *val;
        Data_Get_Struct(argv[1], cl_uint8, val);
        for (i=beg;i<beg+len;i++)
          memcpy(s_array->ptr+size*i, val, size);
        return argv[1];
      } else {
        rb_raise(rb_eArgError, "wrong type of the 2nd argument");
      }
      break;
    case 16:
      if (rb_class_of(argv[1]) == rb_cUint16) {
        cl_uint16 *val;
        Data_Get_Struct(argv[1], cl_uint16, val);
        for (i=beg;i<beg+len;i++)
          memcpy(s_array->ptr+size*i, val, size);
        return argv[1];
      } else {
        rb_raise(rb_eArgError, "wrong type of the 2nd argument");
      }
      break;
    default:
      rb_raise(rb_eArgError, "wrong type of the 2nd argument");
    }
    break;
  case VA_LONG:
    if (rb_obj_is_kind_of(argv[1], rb_cNumeric)==Qtrue) {
      cl_long val = NUM2LONG(argv[1]);
      for (i=beg;i<beg+len;i++)
        for (j=0;j<s_array->n;j++)
          ((cl_long*)s_array->ptr+size*i)[j] = val;
      return argv[1];
    }
    switch (s_array->n) {
    case 2:
      if (rb_class_of(argv[1]) == rb_cLong2) {
        cl_long2 *val;
        Data_Get_Struct(argv[1], cl_long2, val);
        for (i=beg;i<beg+len;i++)
          memcpy(s_array->ptr+size*i, val, size);
        return argv[1];
      } else {
        rb_raise(rb_eArgError, "wrong type of the 2nd argument");
      }
      break;
    case 4:
      if (rb_class_of(argv[1]) == rb_cLong4) {
        cl_long4 *val;
        Data_Get_Struct(argv[1], cl_long4, val);
        for (i=beg;i<beg+len;i++)
          memcpy(s_array->ptr+size*i, val, size);
        return argv[1];
      } else {
        rb_raise(rb_eArgError, "wrong type of the 2nd argument");
      }
      break;
    case 8:
      if (rb_class_of(argv[1]) == rb_cLong8) {
        cl_long8 *val;
        Data_Get_Struct(argv[1], cl_long8, val);
        for (i=beg;i<beg+len;i++)
          memcpy(s_array->ptr+size*i, val, size);
        return argv[1];
      } else {
        rb_raise(rb_eArgError, "wrong type of the 2nd argument");
      }
      break;
    case 16:
      if (rb_class_of(argv[1]) == rb_cLong16) {
        cl_long16 *val;
        Data_Get_Struct(argv[1], cl_long16, val);
        for (i=beg;i<beg+len;i++)
          memcpy(s_array->ptr+size*i, val, size);
        return argv[1];
      } else {
        rb_raise(rb_eArgError, "wrong type of the 2nd argument");
      }
      break;
    default:
      rb_raise(rb_eArgError, "wrong type of the 2nd argument");
    }
    break;
  case VA_ULONG:
    if (rb_obj_is_kind_of(argv[1], rb_cNumeric)==Qtrue) {
      cl_ulong val = (uint64_t)NUM2ULONG(argv[1]);
      for (i=beg;i<beg+len;i++)
        for (j=0;j<s_array->n;j++)
          ((cl_ulong*)s_array->ptr+size*i)[j] = val;
      return argv[1];
    }
    switch (s_array->n) {
    case 2:
      if (rb_class_of(argv[1]) == rb_cUlong2) {
        cl_ulong2 *val;
        Data_Get_Struct(argv[1], cl_ulong2, val);
        for (i=beg;i<beg+len;i++)
          memcpy(s_array->ptr+size*i, val, size);
        return argv[1];
      } else {
        rb_raise(rb_eArgError, "wrong type of the 2nd argument");
      }
      break;
    case 4:
      if (rb_class_of(argv[1]) == rb_cUlong4) {
        cl_ulong4 *val;
        Data_Get_Struct(argv[1], cl_ulong4, val);
        for (i=beg;i<beg+len;i++)
          memcpy(s_array->ptr+size*i, val, size);
        return argv[1];
      } else {
        rb_raise(rb_eArgError, "wrong type of the 2nd argument");
      }
      break;
    case 8:
      if (rb_class_of(argv[1]) == rb_cUlong8) {
        cl_ulong8 *val;
        Data_Get_Struct(argv[1], cl_ulong8, val);
        for (i=beg;i<beg+len;i++)
          memcpy(s_array->ptr+size*i, val, size);
        return argv[1];
      } else {
        rb_raise(rb_eArgError, "wrong type of the 2nd argument");
      }
      break;
    case 16:
      if (rb_class_of(argv[1]) == rb_cUlong16) {
        cl_ulong16 *val;
        Data_Get_Struct(argv[1], cl_ulong16, val);
        for (i=beg;i<beg+len;i++)
          memcpy(s_array->ptr+size*i, val, size);
        return argv[1];
      } else {
        rb_raise(rb_eArgError, "wrong type of the 2nd argument");
      }
      break;
    default:
      rb_raise(rb_eArgError, "wrong type of the 2nd argument");
    }
    break;
  case VA_FLOAT:
    if (rb_obj_is_kind_of(argv[1], rb_cNumeric)==Qtrue) {
      cl_float val = (float)NUM2DBL(argv[1]);
      for (i=beg;i<beg+len;i++)
        for (j=0;j<s_array->n;j++)
          ((cl_float*)s_array->ptr+size*i)[j] = val;
      return argv[1];
    }
    switch (s_array->n) {
    case 2:
      if (rb_class_of(argv[1]) == rb_cFloat2) {
        cl_float2 *val;
        Data_Get_Struct(argv[1], cl_float2, val);
        for (i=beg;i<beg+len;i++)
          memcpy(s_array->ptr+size*i, val, size);
        return argv[1];
      } else {
        rb_raise(rb_eArgError, "wrong type of the 2nd argument");
      }
      break;
    case 4:
      if (rb_class_of(argv[1]) == rb_cFloat4) {
        cl_float4 *val;
        Data_Get_Struct(argv[1], cl_float4, val);
        for (i=beg;i<beg+len;i++)
          memcpy(s_array->ptr+size*i, val, size);
        return argv[1];
      } else {
        rb_raise(rb_eArgError, "wrong type of the 2nd argument");
      }
      break;
    case 8:
      if (rb_class_of(argv[1]) == rb_cFloat8) {
        cl_float8 *val;
        Data_Get_Struct(argv[1], cl_float8, val);
        for (i=beg;i<beg+len;i++)
          memcpy(s_array->ptr+size*i, val, size);
        return argv[1];
      } else {
        rb_raise(rb_eArgError, "wrong type of the 2nd argument");
      }
      break;
    case 16:
      if (rb_class_of(argv[1]) == rb_cFloat16) {
        cl_float16 *val;
        Data_Get_Struct(argv[1], cl_float16, val);
        for (i=beg;i<beg+len;i++)
          memcpy(s_array->ptr+size*i, val, size);
        return argv[1];
      } else {
        rb_raise(rb_eArgError, "wrong type of the 2nd argument");
      }
      break;
    default:
      rb_raise(rb_eArgError, "wrong type of the 2nd argument");
    }
    break;
  default:
    rb_raise(rb_eRuntimeError, "[BUG] invalid type");
  }

  return Qnil;
}

#ifdef HAVE_NARRAY_H
static void
na_mark_ref(struct NARRAY *nary)
{
  rb_gc_mark(nary->ref);
}
static void
na_free(struct NARRAY *nary)
{
  xfree(nary->shape);
  xfree(nary);
}
VALUE
rb_VArray_toNa(int argc, VALUE *argv, VALUE self)
{
  struct_array *s_array;
  struct NARRAY *nary;
  int ntype;

  if (argc != 0)
    rb_raise(rb_eArgError, "wrong number of arguments (%d for 0)", argc);
  Data_Get_Struct(self, struct_array, s_array);
  switch (s_array->type) {
  case VA_CHAR:
    ntype = NA_BYTE;
    break;
  case VA_SHORT:
    ntype = NA_SINT;
    break;
  case VA_INT:
    ntype = NA_LINT;
    break;
  case VA_FLOAT:
    ntype = NA_SFLOAT;
    break;
//  case VA_DOUBLE:
//    ntype = NA_DFLOAT;
//    break;
  default:
    rb_raise(rb_eRuntimeError, "this type is not supported");
  }
  nary = ALLOC(struct NARRAY);
  nary->rank = s_array->n == 1 ? 1 : 2;
  nary->total = s_array->n*s_array->length;
  nary->shape = ALLOC_N(int, nary->rank);
  nary->ptr = s_array->ptr;
  nary->type = ntype;
  nary->ref = self;
  if (s_array->n == 1)
    nary->shape[0] = s_array->length;
  else {
    nary->shape[0] = s_array->n;
    nary->shape[1] = s_array->length;
  }

  return Data_Wrap_Struct(cNArray, na_mark_ref, na_free, nary);
}
#endif


void init_opencl_vect(VALUE rb_module)
{
  rb_mOpenCL = rb_module;

  rb_cVector = rb_define_class_under(rb_mOpenCL, "Vector", rb_cObject);
  rb_cVArray = rb_define_class_under(rb_mOpenCL, "VArray", rb_cObject);
  rb_cChar2 = rb_define_class_under(rb_mOpenCL, "Char2", rb_cVector);
  rb_cChar4 = rb_define_class_under(rb_mOpenCL, "Char4", rb_cVector);
  rb_cChar8 = rb_define_class_under(rb_mOpenCL, "Char8", rb_cVector);
  rb_cChar16 = rb_define_class_under(rb_mOpenCL, "Char16", rb_cVector);
  rb_cUchar2 = rb_define_class_under(rb_mOpenCL, "Uchar2", rb_cVector);
  rb_cUchar4 = rb_define_class_under(rb_mOpenCL, "Uchar4", rb_cVector);
  rb_cUchar8 = rb_define_class_under(rb_mOpenCL, "Uchar8", rb_cVector);
  rb_cUchar16 = rb_define_class_under(rb_mOpenCL, "Uchar16", rb_cVector);
  rb_cShort2 = rb_define_class_under(rb_mOpenCL, "Short2", rb_cVector);
  rb_cShort4 = rb_define_class_under(rb_mOpenCL, "Short4", rb_cVector);
  rb_cShort8 = rb_define_class_under(rb_mOpenCL, "Short8", rb_cVector);
  rb_cShort16 = rb_define_class_under(rb_mOpenCL, "Short16", rb_cVector);
  rb_cUshort2 = rb_define_class_under(rb_mOpenCL, "Ushort2", rb_cVector);
  rb_cUshort4 = rb_define_class_under(rb_mOpenCL, "Ushort4", rb_cVector);
  rb_cUshort8 = rb_define_class_under(rb_mOpenCL, "Ushort8", rb_cVector);
  rb_cUshort16 = rb_define_class_under(rb_mOpenCL, "Ushort16", rb_cVector);
  rb_cInt2 = rb_define_class_under(rb_mOpenCL, "Int2", rb_cVector);
  rb_cInt4 = rb_define_class_under(rb_mOpenCL, "Int4", rb_cVector);
  rb_cInt8 = rb_define_class_under(rb_mOpenCL, "Int8", rb_cVector);
  rb_cInt16 = rb_define_class_under(rb_mOpenCL, "Int16", rb_cVector);
  rb_cUint2 = rb_define_class_under(rb_mOpenCL, "Uint2", rb_cVector);
  rb_cUint4 = rb_define_class_under(rb_mOpenCL, "Uint4", rb_cVector);
  rb_cUint8 = rb_define_class_under(rb_mOpenCL, "Uint8", rb_cVector);
  rb_cUint16 = rb_define_class_under(rb_mOpenCL, "Uint16", rb_cVector);
  rb_cLong2 = rb_define_class_under(rb_mOpenCL, "Long2", rb_cVector);
  rb_cLong4 = rb_define_class_under(rb_mOpenCL, "Long4", rb_cVector);
  rb_cLong8 = rb_define_class_under(rb_mOpenCL, "Long8", rb_cVector);
  rb_cLong16 = rb_define_class_under(rb_mOpenCL, "Long16", rb_cVector);
  rb_cUlong2 = rb_define_class_under(rb_mOpenCL, "Ulong2", rb_cVector);
  rb_cUlong4 = rb_define_class_under(rb_mOpenCL, "Ulong4", rb_cVector);
  rb_cUlong8 = rb_define_class_under(rb_mOpenCL, "Ulong8", rb_cVector);
  rb_cUlong16 = rb_define_class_under(rb_mOpenCL, "Ulong16", rb_cVector);
  rb_cFloat2 = rb_define_class_under(rb_mOpenCL, "Float2", rb_cVector);
  rb_cFloat4 = rb_define_class_under(rb_mOpenCL, "Float4", rb_cVector);
  rb_cFloat8 = rb_define_class_under(rb_mOpenCL, "Float8", rb_cVector);
  rb_cFloat16 = rb_define_class_under(rb_mOpenCL, "Float16", rb_cVector);

  // rb_cVArray
  rb_define_const(rb_cVArray, "CHAR", UINT2NUM(vector_type_code(VA_CHAR,1)));
  rb_define_const(rb_cVArray, "CHAR2", UINT2NUM(vector_type_code(VA_CHAR,2)));
  rb_define_const(rb_cVArray, "CHAR4", UINT2NUM(vector_type_code(VA_CHAR,4)));
  rb_define_const(rb_cVArray, "CHAR8", UINT2NUM(vector_type_code(VA_CHAR,8)));
  rb_define_const(rb_cVArray, "CHAR16", UINT2NUM(vector_type_code(VA_CHAR,16)));
  rb_define_const(rb_cVArray, "UCHAR", UINT2NUM(vector_type_code(VA_UCHAR,1)));
  rb_define_const(rb_cVArray, "UCHAR2", UINT2NUM(vector_type_code(VA_UCHAR,2)));
  rb_define_const(rb_cVArray, "UCHAR4", UINT2NUM(vector_type_code(VA_UCHAR,4)));
  rb_define_const(rb_cVArray, "UCHAR8", UINT2NUM(vector_type_code(VA_UCHAR,8)));
  rb_define_const(rb_cVArray, "UCHAR16", UINT2NUM(vector_type_code(VA_UCHAR,16)));
  rb_define_const(rb_cVArray, "SHORT", UINT2NUM(vector_type_code(VA_SHORT,1)));
  rb_define_const(rb_cVArray, "SHORT2", UINT2NUM(vector_type_code(VA_SHORT,2)));
  rb_define_const(rb_cVArray, "SHORT4", UINT2NUM(vector_type_code(VA_SHORT,4)));
  rb_define_const(rb_cVArray, "SHORT8", UINT2NUM(vector_type_code(VA_SHORT,8)));
  rb_define_const(rb_cVArray, "SHORT16", UINT2NUM(vector_type_code(VA_SHORT,16)));
  rb_define_const(rb_cVArray, "USHORT", UINT2NUM(vector_type_code(VA_USHORT,1)));
  rb_define_const(rb_cVArray, "USHORT2", UINT2NUM(vector_type_code(VA_USHORT,2)));
  rb_define_const(rb_cVArray, "USHORT4", UINT2NUM(vector_type_code(VA_USHORT,4)));
  rb_define_const(rb_cVArray, "USHORT8", UINT2NUM(vector_type_code(VA_USHORT,8)));
  rb_define_const(rb_cVArray, "USHORT16", UINT2NUM(vector_type_code(VA_USHORT,16)));
  rb_define_const(rb_cVArray, "INT", UINT2NUM(vector_type_code(VA_INT,1)));
  rb_define_const(rb_cVArray, "INT2", UINT2NUM(vector_type_code(VA_INT,2)));
  rb_define_const(rb_cVArray, "INT4", UINT2NUM(vector_type_code(VA_INT,4)));
  rb_define_const(rb_cVArray, "INT8", UINT2NUM(vector_type_code(VA_INT,8)));
  rb_define_const(rb_cVArray, "INT16", UINT2NUM(vector_type_code(VA_INT,16)));
  rb_define_const(rb_cVArray, "UINT", UINT2NUM(vector_type_code(VA_UINT,1)));
  rb_define_const(rb_cVArray, "UINT2", UINT2NUM(vector_type_code(VA_UINT,2)));
  rb_define_const(rb_cVArray, "UINT4", UINT2NUM(vector_type_code(VA_UINT,4)));
  rb_define_const(rb_cVArray, "UINT8", UINT2NUM(vector_type_code(VA_UINT,8)));
  rb_define_const(rb_cVArray, "UINT16", UINT2NUM(vector_type_code(VA_UINT,16)));
  rb_define_const(rb_cVArray, "LONG", UINT2NUM(vector_type_code(VA_LONG,1)));
  rb_define_const(rb_cVArray, "LONG2", UINT2NUM(vector_type_code(VA_LONG,2)));
  rb_define_const(rb_cVArray, "LONG4", UINT2NUM(vector_type_code(VA_LONG,4)));
  rb_define_const(rb_cVArray, "LONG8", UINT2NUM(vector_type_code(VA_LONG,8)));
  rb_define_const(rb_cVArray, "LONG16", UINT2NUM(vector_type_code(VA_LONG,16)));
  rb_define_const(rb_cVArray, "ULONG", UINT2NUM(vector_type_code(VA_ULONG,1)));
  rb_define_const(rb_cVArray, "ULONG2", UINT2NUM(vector_type_code(VA_ULONG,2)));
  rb_define_const(rb_cVArray, "ULONG4", UINT2NUM(vector_type_code(VA_ULONG,4)));
  rb_define_const(rb_cVArray, "ULONG8", UINT2NUM(vector_type_code(VA_ULONG,8)));
  rb_define_const(rb_cVArray, "ULONG16", UINT2NUM(vector_type_code(VA_ULONG,16)));
  rb_define_const(rb_cVArray, "FLOAT", UINT2NUM(vector_type_code(VA_FLOAT,1)));
  rb_define_const(rb_cVArray, "FLOAT2", UINT2NUM(vector_type_code(VA_FLOAT,2)));
  rb_define_const(rb_cVArray, "FLOAT4", UINT2NUM(vector_type_code(VA_FLOAT,4)));
  rb_define_const(rb_cVArray, "FLOAT8", UINT2NUM(vector_type_code(VA_FLOAT,8)));
  rb_define_const(rb_cVArray, "FLOAT16", UINT2NUM(vector_type_code(VA_FLOAT,16)));

  rb_define_singleton_method(rb_cChar2, "new", rb_CreateChar2, -1);
  rb_define_method(rb_cChar2, "to_a", rb_Char2_toA, -1);
  rb_define_singleton_method(rb_cChar4, "new", rb_CreateChar4, -1);
  rb_define_method(rb_cChar4, "to_a", rb_Char4_toA, -1);
  rb_define_singleton_method(rb_cChar8, "new", rb_CreateChar8, -1);
  rb_define_method(rb_cChar8, "to_a", rb_Char8_toA, -1);
  rb_define_singleton_method(rb_cChar16, "new", rb_CreateChar16, -1);
  rb_define_method(rb_cChar16, "to_a", rb_Char16_toA, -1);
  rb_define_singleton_method(rb_cUchar2, "new", rb_CreateUchar2, -1);
  rb_define_method(rb_cUchar2, "to_a", rb_Uchar2_toA, -1);
  rb_define_singleton_method(rb_cUchar4, "new", rb_CreateUchar4, -1);
  rb_define_method(rb_cUchar4, "to_a", rb_Uchar4_toA, -1);
  rb_define_singleton_method(rb_cUchar8, "new", rb_CreateUchar8, -1);
  rb_define_method(rb_cUchar8, "to_a", rb_Uchar8_toA, -1);
  rb_define_singleton_method(rb_cUchar16, "new", rb_CreateUchar16, -1);
  rb_define_method(rb_cUchar16, "to_a", rb_Uchar16_toA, -1);
  rb_define_singleton_method(rb_cShort2, "new", rb_CreateShort2, -1);
  rb_define_method(rb_cShort2, "to_a", rb_Short2_toA, -1);
  rb_define_singleton_method(rb_cShort4, "new", rb_CreateShort4, -1);
  rb_define_method(rb_cShort4, "to_a", rb_Short4_toA, -1);
  rb_define_singleton_method(rb_cShort8, "new", rb_CreateShort8, -1);
  rb_define_method(rb_cShort8, "to_a", rb_Short8_toA, -1);
  rb_define_singleton_method(rb_cShort16, "new", rb_CreateShort16, -1);
  rb_define_method(rb_cShort16, "to_a", rb_Short16_toA, -1);
  rb_define_singleton_method(rb_cUshort2, "new", rb_CreateUshort2, -1);
  rb_define_method(rb_cUshort2, "to_a", rb_Ushort2_toA, -1);
  rb_define_singleton_method(rb_cUshort4, "new", rb_CreateUshort4, -1);
  rb_define_method(rb_cUshort4, "to_a", rb_Ushort4_toA, -1);
  rb_define_singleton_method(rb_cUshort8, "new", rb_CreateUshort8, -1);
  rb_define_method(rb_cUshort8, "to_a", rb_Ushort8_toA, -1);
  rb_define_singleton_method(rb_cUshort16, "new", rb_CreateUshort16, -1);
  rb_define_method(rb_cUshort16, "to_a", rb_Ushort16_toA, -1);
  rb_define_singleton_method(rb_cInt2, "new", rb_CreateInt2, -1);
  rb_define_method(rb_cInt2, "to_a", rb_Int2_toA, -1);
  rb_define_singleton_method(rb_cInt4, "new", rb_CreateInt4, -1);
  rb_define_method(rb_cInt4, "to_a", rb_Int4_toA, -1);
  rb_define_singleton_method(rb_cInt8, "new", rb_CreateInt8, -1);
  rb_define_method(rb_cInt8, "to_a", rb_Int8_toA, -1);
  rb_define_singleton_method(rb_cInt16, "new", rb_CreateInt16, -1);
  rb_define_method(rb_cInt16, "to_a", rb_Int16_toA, -1);
  rb_define_singleton_method(rb_cUint2, "new", rb_CreateUint2, -1);
  rb_define_method(rb_cUint2, "to_a", rb_Uint2_toA, -1);
  rb_define_singleton_method(rb_cUint4, "new", rb_CreateUint4, -1);
  rb_define_method(rb_cUint4, "to_a", rb_Uint4_toA, -1);
  rb_define_singleton_method(rb_cUint8, "new", rb_CreateUint8, -1);
  rb_define_method(rb_cUint8, "to_a", rb_Uint8_toA, -1);
  rb_define_singleton_method(rb_cUint16, "new", rb_CreateUint16, -1);
  rb_define_method(rb_cUint16, "to_a", rb_Uint16_toA, -1);
  rb_define_singleton_method(rb_cLong2, "new", rb_CreateLong2, -1);
  rb_define_method(rb_cLong2, "to_a", rb_Long2_toA, -1);
  rb_define_singleton_method(rb_cLong4, "new", rb_CreateLong4, -1);
  rb_define_method(rb_cLong4, "to_a", rb_Long4_toA, -1);
  rb_define_singleton_method(rb_cLong8, "new", rb_CreateLong8, -1);
  rb_define_method(rb_cLong8, "to_a", rb_Long8_toA, -1);
  rb_define_singleton_method(rb_cLong16, "new", rb_CreateLong16, -1);
  rb_define_method(rb_cLong16, "to_a", rb_Long16_toA, -1);
  rb_define_singleton_method(rb_cUlong2, "new", rb_CreateUlong2, -1);
  rb_define_method(rb_cUlong2, "to_a", rb_Ulong2_toA, -1);
  rb_define_singleton_method(rb_cUlong4, "new", rb_CreateUlong4, -1);
  rb_define_method(rb_cUlong4, "to_a", rb_Ulong4_toA, -1);
  rb_define_singleton_method(rb_cUlong8, "new", rb_CreateUlong8, -1);
  rb_define_method(rb_cUlong8, "to_a", rb_Ulong8_toA, -1);
  rb_define_singleton_method(rb_cUlong16, "new", rb_CreateUlong16, -1);
  rb_define_method(rb_cUlong16, "to_a", rb_Ulong16_toA, -1);
  rb_define_singleton_method(rb_cFloat2, "new", rb_CreateFloat2, -1);
  rb_define_method(rb_cFloat2, "to_a", rb_Float2_toA, -1);
  rb_define_singleton_method(rb_cFloat4, "new", rb_CreateFloat4, -1);
  rb_define_method(rb_cFloat4, "to_a", rb_Float4_toA, -1);
  rb_define_singleton_method(rb_cFloat8, "new", rb_CreateFloat8, -1);
  rb_define_method(rb_cFloat8, "to_a", rb_Float8_toA, -1);
  rb_define_singleton_method(rb_cFloat16, "new", rb_CreateFloat16, -1);
  rb_define_method(rb_cFloat16, "to_a", rb_Float16_toA, -1);
  rb_define_singleton_method(rb_cVArray, "new", rb_CreateVArray, -1);
  rb_define_singleton_method(rb_cVArray, "to_va", rb_CreateVArrayFromObject, -1);
  rb_define_method(rb_cVArray, "length", rb_VArray_length, -1);
  rb_define_method(rb_cVArray, "to_s", rb_VArray_toS, -1);
  rb_define_method(rb_cVArray, "type_code", rb_VArray_typeCode, -1);
  rb_define_method(rb_cVArray, "[]", rb_VArray_aref, -1);
  rb_define_method(rb_cVArray, "[]=", rb_VArray_aset, -1);
#ifdef HAVE_NARRAY_H
  rb_define_method(rb_cVArray, "to_na", rb_VArray_toNa, -1);
#endif
}

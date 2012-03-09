#include <string.h>
#include "ruby.h"
#ifdef __APPLE__
#include "OpenCL/opencl.h"
#define ulong u_long
#else
#include "CL/opencl.h"
#endif
#ifdef HAVE_NARRAY_H
#include "narray.h"
#endif

VALUE rb_mOpenCL;

static VALUE rb_cPlatform;
static VALUE rb_cDevice;
static VALUE rb_cContext;
static VALUE rb_cCommandQueue;
static VALUE rb_cMem;
static VALUE rb_cBuffer;
static VALUE rb_cImage;
static VALUE rb_cImage2D;
static VALUE rb_cImage3D;
static VALUE rb_cImageFormat;
static VALUE rb_cSampler;
static VALUE rb_cProgram;
static VALUE rb_cKernel;
static VALUE rb_cEvent;

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
static VALUE rb_cDouble2;
static VALUE rb_cDouble4;
static VALUE rb_cDouble8;
static VALUE rb_cDouble16;

struct  _struct_mem {
  cl_mem mem;
  VALUE host_ptr;
};
typedef struct _struct_mem *struct_mem;


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
  VA_DOUBLE,
  VA_ERROR
};

typedef struct _struct_varray {
  void* ptr;
  enum vector_type type;
  unsigned int n;
  size_t length;
  size_t size;
  VALUE obj;
} struct_varray;

static VALUE rb_cCLChar;
static VALUE rb_cCLUChar;
static VALUE rb_cCLShort;
static VALUE rb_cCLUShort;
static VALUE rb_cCLInt;
static VALUE rb_cCLUInt;
static VALUE rb_cCLLong;
static VALUE rb_cCLULong;

static VALUE rb_cCLFloat;
struct RCLFloat {
  struct RBasic basic;
  double value;
};

static VALUE rb_cCLDouble;
struct RCLDouble {
  struct RBasic basic;
  double value;
};

static VALUE rb_cCLHalf;
struct RCLHalf {
  struct RBasic basic;
  double value;
};

/********************************************************************
 *
 * Document-class: CLFloat
 *
 *  <code>CLFloat</code> objects represent real numbers using the native
 *  architecture's single-precision floating point representation.
 */
static VALUE
rb_clfloat_new(VALUE self, VALUE d)
{
  NEWOBJ(flt, struct RCLFloat);
  OBJSETUP(flt, rb_cCLFloat, T_FLOAT);
  flt->value = NUM2DBL(d);

  return (VALUE)flt;
}

static VALUE
rb_cldouble_new(VALUE self, VALUE d)
{
  NEWOBJ(flt, struct RCLDouble);
  OBJSETUP(flt, rb_cCLDouble, T_FLOAT);
  flt->value = NUM2DBL(d);

  return (VALUE)flt;
}

static VALUE
rb_clhalf_new(VALUE self, VALUE d)
{
  NEWOBJ(flt, struct RCLHalf);
  OBJSETUP(flt, rb_cCLHalf, T_FLOAT);
  flt->value = NUM2DBL(d);

  return (VALUE)flt;
}

static void
check_error(cl_int errcode)
{
  switch (errcode) {
  case CL_SUCCESS:
    break;
  case CL_DEVICE_NOT_FOUND:
    rb_raise(rb_eRuntimeError, "DEVICE NOT FOUND: error code is %d", errcode);
    break;
  case CL_DEVICE_NOT_AVAILABLE:
    rb_raise(rb_eRuntimeError, "DEVICE NOT AVAILABLE: error code is %d", errcode);
    break;
  case CL_COMPILER_NOT_AVAILABLE:
    rb_raise(rb_eRuntimeError, "COMPILER NOT AVAILABLE: error code is %d", errcode);
    break;
  case CL_MEM_OBJECT_ALLOCATION_FAILURE:
    rb_raise(rb_eRuntimeError, "MEM OBJECT ALLOCATION FAILURE: error code is %d", errcode);
    break;
  case CL_OUT_OF_RESOURCES:
    rb_raise(rb_eRuntimeError, "OUT OF RESOURCES: error code is %d", errcode);
    break;
  case CL_OUT_OF_HOST_MEMORY:
    rb_raise(rb_eRuntimeError, "OUT OF HOST MEMORY: error code is %d", errcode);
    break;
  case CL_PROFILING_INFO_NOT_AVAILABLE:
    rb_raise(rb_eRuntimeError, "PROFILING INFO NOT AVAILABLE: error code is %d", errcode);
    break;
  case CL_MEM_COPY_OVERLAP:
    rb_raise(rb_eRuntimeError, "MEM COPY OVERLAP: error code is %d", errcode);
    break;
  case CL_IMAGE_FORMAT_MISMATCH:
    rb_raise(rb_eRuntimeError, "IMAGE FORMAT MISMATCH: error code is %d", errcode);
    break;
  case CL_IMAGE_FORMAT_NOT_SUPPORTED:
    rb_raise(rb_eRuntimeError, "IMAGE FORMAT NOT SUPPORTED: error code is %d", errcode);
    break;
  case CL_BUILD_PROGRAM_FAILURE:
    rb_raise(rb_eRuntimeError, "BUILD PROGRAM FAILURE: error code is %d", errcode);
    break;
  case CL_MAP_FAILURE:
    rb_raise(rb_eRuntimeError, "MAP FAILURE: error code is %d", errcode);
    break;
  case CL_INVALID_DEVICE_TYPE:
    rb_raise(rb_eRuntimeError, "INVALID DEVICE TYPE: error code is %d", errcode);
    break;
  case CL_INVALID_PLATFORM:
    rb_raise(rb_eRuntimeError, "INVALID PLATFORM: error code is %d", errcode);
    break;
  case CL_INVALID_DEVICE:
    rb_raise(rb_eRuntimeError, "INVALID DEVICE: error code is %d", errcode);
    break;
  case CL_INVALID_CONTEXT:
    rb_raise(rb_eRuntimeError, "INVALID CONTEXT: error code is %d", errcode);
    break;
  case CL_INVALID_HOST_PTR:
    rb_raise(rb_eRuntimeError, "INVALID HOST PTR: error code is %d", errcode);
    break;
  case CL_INVALID_MEM_OBJECT:
    rb_raise(rb_eRuntimeError, "INVALID MEM OBJECT: error code is %d", errcode);
    break;
  case CL_INVALID_IMAGE_FORMAT_DESCRIPTOR:
    rb_raise(rb_eRuntimeError, "INVALID IMAGE FORMAT DESCRIPTOR: error code is %d", errcode);
    break;
  case CL_INVALID_IMAGE_SIZE:
    rb_raise(rb_eRuntimeError, "INVALID IMAGE SIZE: error code is %d", errcode);
    break;
  case CL_INVALID_SAMPLER:
    rb_raise(rb_eRuntimeError, "INVALID SAMPLER: error code is %d", errcode);
    break;
  case CL_INVALID_BINARY:
    rb_raise(rb_eRuntimeError, "INVALID BINARY: error code is %d", errcode);
    break;
  case CL_INVALID_BUILD_OPTIONS:
    rb_raise(rb_eRuntimeError, "INVALID BUILD OPTIONS: error code is %d", errcode);
    break;
  case CL_INVALID_PROGRAM:
    rb_raise(rb_eRuntimeError, "INVALID PROGRAM: error code is %d", errcode);
    break;
  case CL_INVALID_PROGRAM_EXECUTABLE:
    rb_raise(rb_eRuntimeError, "INVALID PROGRAM EXECUTABLE: error code is %d", errcode);
    break;
  case CL_INVALID_KERNEL_NAME:
    rb_raise(rb_eRuntimeError, "INVALID KERNEL NAME: error code is %d", errcode);
    break;
  case CL_INVALID_KERNEL_DEFINITION:
    rb_raise(rb_eRuntimeError, "INVALID KERNEL DEFINITION: error code is %d", errcode);
    break;
  case CL_INVALID_KERNEL:
    rb_raise(rb_eRuntimeError, "INVALID KERNEL: error code is %d", errcode);
    break;
  case CL_INVALID_ARG_INDEX:
    rb_raise(rb_eRuntimeError, "INVALID ARG INDEX: error code is %d", errcode);
    break;
  case CL_INVALID_ARG_VALUE:
    rb_raise(rb_eRuntimeError, "INVALID ARG VALUE: error code is %d", errcode);
    break;
  case CL_INVALID_ARG_SIZE:
    rb_raise(rb_eRuntimeError, "INVALID ARG SIZE: error code is %d", errcode);
    break;
  case CL_INVALID_KERNEL_ARGS:
    rb_raise(rb_eRuntimeError, "INVALID KERNEL ARGS: error code is %d", errcode);
    break;
  case CL_INVALID_WORK_DIMENSION:
    rb_raise(rb_eRuntimeError, "INVALID WORK DIMENSION: error code is %d", errcode);
    break;
  case CL_INVALID_WORK_GROUP_SIZE:
    rb_raise(rb_eRuntimeError, "INVALID WORK GROUP SIZE: error code is %d", errcode);
    break;
  case CL_INVALID_GLOBAL_OFFSET:
    rb_raise(rb_eRuntimeError, "INVALID GLOBAL OFFSET: error code is %d", errcode);
    break;
  case CL_INVALID_EVENT_WAIT_LIST:
    rb_raise(rb_eRuntimeError, "INVALID EVENT WAIT LIST: error code is %d", errcode);
    break;
  case CL_INVALID_EVENT:
    rb_raise(rb_eRuntimeError, "INVALID EVENT: error code is %d", errcode);
    break;
  case CL_INVALID_OPERATION:
    rb_raise(rb_eRuntimeError, "INVALID OPERATION: error code is %d", errcode);
    break;
  case CL_INVALID_GL_OBJECT:
    rb_raise(rb_eRuntimeError, "INVALID GL OBJECT: error code is %d", errcode);
    break;
  case CL_INVALID_BUFFER_SIZE:
    rb_raise(rb_eRuntimeError, "INVALID BUFFER SIZE: error code is %d", errcode);
    break;
  case CL_INVALID_MIP_LEVEL:
    rb_raise(rb_eRuntimeError, "INVALID MIP LEVEL: error code is %d", errcode);
    break;
  case CL_INVALID_VALUE:
    rb_raise(rb_eRuntimeError, "the values specified in properties are not valid: error code is %d", errcode);
    break;
  case CL_INVALID_QUEUE_PROPERTIES:
    rb_raise(rb_eRuntimeError, "values specified in properties are not supported by the device: error code is %d", errcode);
    break;
  case CL_INVALID_COMMAND_QUEUE:
    rb_raise(rb_eRuntimeError, "command_queue is not a valid comand-queue: error code is %d", errcode);
    break;
  default:
    rb_raise(rb_eRuntimeError, "unexpected error was occured: error code is %d", errcode);
  }
}

static VALUE
create_platform(cl_platform_id platform)
{
  return Data_Wrap_Struct(rb_cPlatform, 0, 0, (void*)platform);
}

static VALUE
create_device(cl_device_id device)
{
  return Data_Wrap_Struct(rb_cDevice, 0, 0, (void*)device);
}

static void
context_free(cl_context context)
{
  clReleaseContext(context);
}
static VALUE
create_context(cl_context context)
{
  return Data_Wrap_Struct(rb_cContext, 0, context_free, (void*)context);
}

static void
command_queue_free(cl_command_queue command_queue)
{
  clReleaseCommandQueue(command_queue);
}
static VALUE
create_command_queue(cl_command_queue command_queue)
{
  return Data_Wrap_Struct(rb_cCommandQueue, 0, command_queue_free, (void*)command_queue);
}

static void
mem_free(struct_mem mem)
{
  clReleaseMemObject(mem->mem);
  xfree(mem);
}
static void
mem_mark(struct_mem mem)
{
  if (mem->host_ptr)
    rb_gc_mark(mem->host_ptr);
}
static VALUE
create_mem(struct_mem mem)
{
  return Data_Wrap_Struct(rb_cMem, mem_mark, mem_free, (void*)mem);
}

static void
image_format_free(cl_image_format *image_format)
{
  xfree(image_format);
}
static VALUE
create_image_format(cl_image_format *image_format)
{
  return Data_Wrap_Struct(rb_cImageFormat, 0, image_format_free, (void*)image_format);
}

static void
sampler_free(cl_sampler sampler)
{
  clReleaseSampler(sampler);
}
static VALUE
create_sampler(cl_sampler sampler)
{
  return Data_Wrap_Struct(rb_cSampler, 0, sampler_free, (void*)sampler);
}

static void
program_free(cl_program program)
{
  clReleaseProgram(program);
}
static VALUE
create_program(cl_program program)
{
  return Data_Wrap_Struct(rb_cProgram, 0, program_free, (void*)program);
}

static void
kernel_free(cl_kernel kernel)
{
  clReleaseKernel(kernel);
}
static VALUE
create_kernel(cl_kernel kernel)
{
  return Data_Wrap_Struct(rb_cKernel, 0, kernel_free, (void*)kernel);
}

static void
event_free(cl_event event)
{
  clReleaseEvent(event);
}
static VALUE
create_event(cl_event event)
{
  return Data_Wrap_Struct(rb_cEvent, 0, event_free, (void*)event);
}
#ifdef CL_VERSION_1_0
void
clBuildProgram_pfn_notify (cl_program program, void * user_data)
{
  VALUE passthrough = (VALUE)user_data;
  VALUE cb = rb_ary_entry(passthrough, 0);
  VALUE cbdata = rb_ary_entry(passthrough, 1);
  rb_funcall(cb, rb_intern("call"), 2, create_program(program), cbdata);
}
/*
 *  call-seq:
 *     program.build([, opts]){ } -> nil
 *
 *  opts: device_list, options, user_data
 */
VALUE
rb_clBuildProgram(int argc, VALUE *argv, VALUE self)
{
  cl_program program;
  cl_uint num_devices;
  cl_device_id *device_list;
  char *options;
  VALUE passthrough;
  VALUE rb_p;
  cl_int ret;
  VALUE rb_program;
  VALUE rb_device_list = Qnil;
  VALUE rb_options = Qnil;
  VALUE rb_user_data = Qnil;

  VALUE result;

  if (argc > 2 || argc < 0)
    rb_raise(rb_eArgError, "wrong number of arguments (%d for 0)", argc);

  {
    VALUE _opt_hash = Qnil;

    if (argc > 0) {
      _opt_hash = argv[0];
      Check_Type(_opt_hash, T_HASH);
    }
    if (_opt_hash != Qnil) {
      rb_device_list = rb_hash_aref(_opt_hash, ID2SYM(rb_intern("device_list")));
    }
    if (_opt_hash != Qnil && rb_device_list != Qnil) {
      Check_Type(rb_device_list, T_ARRAY);
      {
        int n;
        num_devices = RARRAY_LEN(rb_device_list);
        device_list = ALLOC_N(cl_device_id, num_devices);
        for (n=0; n<(int)num_devices; n++) {
          Check_Type(RARRAY_PTR(rb_device_list)[n], T_DATA);
          if (CLASS_OF(RARRAY_PTR(rb_device_list)[n]) != rb_cDevice)
            rb_raise(rb_eRuntimeError, "type of device_list[n] is invalid: Device is expected");
          device_list[n] = (cl_device_id)DATA_PTR(RARRAY_PTR(rb_device_list)[n]);
        }
      }

    } else {
      device_list = NULL;
      num_devices = 0;
    }
    if (_opt_hash != Qnil) {
      rb_options = rb_hash_aref(_opt_hash, ID2SYM(rb_intern("options")));
    }
    if (_opt_hash != Qnil && rb_options != Qnil) {
      options = (char*) RSTRING_PTR(rb_options);

    } else {
      options = NULL;
    }
    if (_opt_hash != Qnil) {
      rb_user_data = rb_hash_aref(_opt_hash, ID2SYM(rb_intern("user_data")));
    }
  }

  rb_program = self;
  Check_Type(rb_program, T_DATA);
  if (CLASS_OF(rb_program) != rb_cProgram)
    rb_raise(rb_eRuntimeError, "type of program is invalid: Program is expected");
  program = (cl_program)DATA_PTR(rb_program);



  if(rb_block_given_p()) {
    rb_p = rb_block_proc();
    passthrough = rb_ary_new();
    rb_ary_store(passthrough, 0, rb_p);
    rb_ary_store(passthrough, 1, rb_user_data);
    ret = clBuildProgram(program, num_devices, (const cl_device_id*)device_list, (const char*)options, clBuildProgram_pfn_notify , (void *)passthrough);
  } else
    ret = clBuildProgram(program, num_devices, (const cl_device_id*)device_list, (const char*)options, NULL, NULL);
  check_error(ret);

  {
    result = Qnil;
  }

  if (device_list) xfree(device_list);

  return result;
}
#endif

#ifdef CL_VERSION_1_0
/*
 *  call-seq:
 *     Buffer.new(context, flags[, opts]) -> mem
 *
 *  opts: size, host_ptr
 */
VALUE
rb_clCreateBuffer(int argc, VALUE *argv, VALUE self)
{
  cl_context context;
  cl_mem_flags flags;
  size_t size;
  void *host_ptr;
  cl_int errcode_ret;
  cl_mem ret;
  VALUE rb_context = Qnil;
  VALUE rb_flags = Qnil;
  VALUE rb_size = Qnil;
  VALUE rb_host_ptr = Qnil;

  VALUE result;

  if (argc > 3 || argc < 2)
    rb_raise(rb_eArgError, "wrong number of arguments (%d for 2)", argc);

  {
    VALUE _opt_hash = Qnil;

    if (argc > 2) {
      _opt_hash = argv[2];
      Check_Type(_opt_hash, T_HASH);
    }
    if (_opt_hash != Qnil) {
      rb_size = rb_hash_aref(_opt_hash, ID2SYM(rb_intern("size")));
    }
    if (_opt_hash != Qnil && rb_size != Qnil) {
      size = (size_t)NUM2ULONG(rb_size);

    } else {
      size = 0;
    }
    if (_opt_hash != Qnil) {
      rb_host_ptr = rb_hash_aref(_opt_hash, ID2SYM(rb_intern("host_ptr")));
    }
    if (_opt_hash != Qnil && rb_host_ptr != Qnil) {
      if (TYPE(rb_host_ptr) == T_STRING) {
        host_ptr = RSTRING_PTR(rb_host_ptr);
        size = RSTRING_LEN(rb_host_ptr);
      } else if (CLASS_OF(rb_host_ptr) == rb_cVArray) {
        struct_varray *s_vary;
        Data_Get_Struct(rb_host_ptr, struct_varray, s_vary);
        host_ptr = s_vary->ptr;
        size = s_vary->size*s_vary->length;
      } else
        rb_raise(rb_eArgError, "wrong type of the argument");

    } else {
      host_ptr = NULL;
    }
  }

  rb_context = argv[0];
  Check_Type(rb_context, T_DATA);
  if (CLASS_OF(rb_context) != rb_cContext)
    rb_raise(rb_eRuntimeError, "type of context is invalid: Context is expected");
  context = (cl_context)DATA_PTR(rb_context);

  rb_flags = argv[1];
  flags = (uint64_t)NUM2ULONG(rb_flags);




  ret = clCreateBuffer(context, flags, size, host_ptr, &errcode_ret);
  check_error(errcode_ret);

  {
    VALUE rb_ret;
    {
      struct_mem s_ret;
      s_ret = (struct_mem)xmalloc(sizeof(struct _struct_mem));
      s_ret->mem = ret;
      s_ret->host_ptr = rb_host_ptr;
      rb_ret = create_mem(s_ret);
    }

    result = rb_ret;
  }


  return result;
}
#endif

#ifdef CL_VERSION_1_0
/*
 *  call-seq:
 *     CommandQueue.new(context, device, properties) -> command_queue
 *
 */
VALUE
rb_clCreateCommandQueue(int argc, VALUE *argv, VALUE self)
{
  cl_context context;
  cl_device_id device;
  cl_command_queue_properties properties;
  cl_int errcode_ret;
  cl_command_queue ret;
  VALUE rb_context = Qnil;
  VALUE rb_device = Qnil;
  VALUE rb_properties = Qnil;

  VALUE result;

  if (argc > 3 || argc < 3)
    rb_raise(rb_eArgError, "wrong number of arguments (%d for 3)", argc);


  rb_context = argv[0];
  Check_Type(rb_context, T_DATA);
  if (CLASS_OF(rb_context) != rb_cContext)
    rb_raise(rb_eRuntimeError, "type of context is invalid: Context is expected");
  context = (cl_context)DATA_PTR(rb_context);

  rb_device = argv[1];
  Check_Type(rb_device, T_DATA);
  if (CLASS_OF(rb_device) != rb_cDevice)
    rb_raise(rb_eRuntimeError, "type of device is invalid: Device is expected");
  device = (cl_device_id)DATA_PTR(rb_device);

  rb_properties = argv[2];
  properties = (uint64_t)NUM2ULONG(rb_properties);




  ret = clCreateCommandQueue(context, device, properties, &errcode_ret);
  check_error(errcode_ret);

  {
    VALUE rb_ret;
    rb_ret = create_command_queue(ret);

    result = rb_ret;
  }


  return result;
}
#endif

#ifdef CL_VERSION_1_0
void
clCreateContext_pfn_notify (const char * errinfo, const void * private_info, size_t cb, void * user_data)
{
  VALUE passthrough = (VALUE)user_data;
  VALUE callback = rb_ary_entry(passthrough, 0);
  VALUE cbdata = rb_ary_entry(passthrough, 1);
  rb_funcall(callback, rb_intern("call"), 3, rb_str_new2(errinfo), rb_str_new(private_info, cb), cbdata);
}
/*
 *  call-seq:
 *     Context.new(properties, devices[, opts]){ } -> context
 *
 *  opts: user_data
 */
VALUE
rb_clCreateContext(int argc, VALUE *argv, VALUE self)
{
  cl_context_properties *properties;
  cl_uint num_devices;
  cl_device_id *devices;
  cl_int errcode_ret;
  cl_context ret;
  VALUE passthrough;
  VALUE rb_properties = Qnil;
  VALUE rb_devices = Qnil;
  VALUE rb_user_data = Qnil;
  VALUE rb_p;

  VALUE result;

  if (argc > 4 || argc < 2)
    rb_raise(rb_eArgError, "wrong number of arguments (%d for 2)", argc);

  {
    VALUE _opt_hash = Qnil;

    if (argc > 2) {
      _opt_hash = argv[2];
      Check_Type(_opt_hash, T_HASH);
    }
    if (_opt_hash != Qnil) {
      rb_user_data = rb_hash_aref(_opt_hash, ID2SYM(rb_intern("user_data")));
    }
  }

  rb_properties = argv[0];
  if (rb_properties == Qnil) {
    properties = NULL;
  } else {
    Check_Type(rb_properties, T_ARRAY);
    int len_prop = RARRAY_LEN(rb_properties);
    int n;
    properties = ALLOC_N(cl_context_properties, len_prop+1);
    for (n=0; n<len_prop; n++) {
      properties[n] = (int)NUM2INT(RARRAY_PTR(rb_properties)[n]);
    }
    properties[len_prop] = 0;
  }

  rb_devices = argv[1];
  Check_Type(rb_devices, T_ARRAY);
  {
    int n;
    num_devices = RARRAY_LEN(rb_devices);
    devices = ALLOC_N(cl_device_id, num_devices);
    for (n=0; n<(int)num_devices; n++) {
      Check_Type(RARRAY_PTR(rb_devices)[n], T_DATA);
      if (CLASS_OF(RARRAY_PTR(rb_devices)[n]) != rb_cDevice)
        rb_raise(rb_eRuntimeError, "type of devices[n] is invalid: Device is expected");
      devices[n] = (cl_device_id)DATA_PTR(RARRAY_PTR(rb_devices)[n]);
    }
  }



  if(rb_block_given_p()){
    rb_p = rb_block_proc();
    passthrough = rb_ary_new();
    rb_ary_store(passthrough, 0, rb_p);
    rb_ary_store(passthrough, 1, rb_user_data);
    ret = clCreateContext((const cl_context_properties*)properties, num_devices, (const cl_device_id*)devices, clCreateContext_pfn_notify , (void *)passthrough, &errcode_ret);
  } else {
    ret = clCreateContext((const cl_context_properties*)properties, num_devices, (const cl_device_id*)devices, NULL, NULL, &errcode_ret);
  }
  check_error(errcode_ret);

  {
    VALUE rb_ret;
    rb_ret = create_context(ret);

    result = rb_ret;
  }

  if (properties) xfree(properties);
  if (devices) xfree(devices);

  return result;
}
#endif

#ifdef CL_VERSION_1_0
void
clCreateContextFromType_pfn_notify(const char * errinfo, const void * private_info, size_t cb, void * user_data)
{
  if (rb_block_given_p())
    rb_yield(rb_ary_new3(3, rb_str_new2(errinfo), rb_str_new(private_info, cb), user_data ? (VALUE) user_data : Qnil));
}
/*
 *  call-seq:
 *     Context.create_from_type(properties, device_type[, opts]){ } -> context
 *
 *  opts: user_data
 */
VALUE
rb_clCreateContextFromType(int argc, VALUE *argv, VALUE self)
{
  cl_context_properties *properties;
  cl_device_type device_type;
  void *user_data;
  cl_int errcode_ret;
  cl_context ret;
  VALUE rb_properties = Qnil;
  VALUE rb_device_type = Qnil;
  VALUE rb_user_data = Qnil;

  VALUE result;

  if (argc > 4 || argc < 2)
    rb_raise(rb_eArgError, "wrong number of arguments (%d for 2)", argc);

  {
    VALUE _opt_hash = Qnil;

    if (argc > 2) {
      _opt_hash = argv[2];
      Check_Type(_opt_hash, T_HASH);
    }
    if (_opt_hash != Qnil) {
      rb_user_data = rb_hash_aref(_opt_hash, ID2SYM(rb_intern("user_data")));
    }
    if (_opt_hash != Qnil && rb_user_data != Qnil) {
      user_data = (void*) rb_user_data;

    } else {
      user_data = NULL;
    }
  }

  rb_properties = argv[0];
  if (rb_properties == Qnil) {
    properties = NULL;
  } else {
    Check_Type(rb_properties, T_ARRAY);
    int len_prop = RARRAY_LEN(rb_properties);
    int n;
    properties = ALLOC_N(cl_context_properties, len_prop+1);
    for (n=0; n<len_prop; n++) {
      properties[n] = (int)NUM2INT(RARRAY_PTR(rb_properties)[n]);
    }
    properties[len_prop] = 0;
  }

  rb_device_type = argv[1];
  device_type = (uint64_t)NUM2ULONG(rb_device_type);




  ret = clCreateContextFromType((const cl_context_properties*)properties, device_type, clCreateContextFromType_pfn_notify, user_data, &errcode_ret);
  check_error(errcode_ret);

  {
    VALUE rb_ret;
    rb_ret = create_context(ret);

    result = rb_ret;
  }

  if (properties) xfree(properties);

  return result;
}
#endif

#ifdef CL_VERSION_1_0
/*
 *  call-seq:
 *     Image2D.new(context, flags, image_format[, opts]) -> mem
 *
 *  opts: image_width, image_height, image_row_pitch, host_ptr
 */
VALUE
rb_clCreateImage2D(int argc, VALUE *argv, VALUE self)
{
  cl_context context;
  cl_mem_flags flags;
  cl_image_format *image_format;
  size_t image_width;
  size_t image_height;
  size_t image_row_pitch;
  void *host_ptr;
  cl_int errcode_ret;
  cl_mem ret;
  VALUE rb_context = Qnil;
  VALUE rb_flags = Qnil;
  VALUE rb_image_format = Qnil;
  VALUE rb_image_width = Qnil;
  VALUE rb_image_height = Qnil;
  VALUE rb_image_row_pitch = Qnil;
  VALUE rb_host_ptr = Qnil;

  VALUE result;

  if (argc > 4 || argc < 3)
    rb_raise(rb_eArgError, "wrong number of arguments (%d for 3)", argc);

  {
    VALUE _opt_hash = Qnil;

    if (argc > 3) {
      _opt_hash = argv[3];
      Check_Type(_opt_hash, T_HASH);
    }
    if (_opt_hash != Qnil) {
      rb_image_width = rb_hash_aref(_opt_hash, ID2SYM(rb_intern("image_width")));
    }
    if (_opt_hash != Qnil && rb_image_width != Qnil) {
      image_width = (size_t)NUM2ULONG(rb_image_width);

    } else {
      image_width = 0;
    }
    if (_opt_hash != Qnil) {
      rb_image_height = rb_hash_aref(_opt_hash, ID2SYM(rb_intern("image_height")));
    }
    if (_opt_hash != Qnil && rb_image_height != Qnil) {
      image_height = (size_t)NUM2ULONG(rb_image_height);

    } else {
      image_height = 0;
    }
    if (_opt_hash != Qnil) {
      rb_image_row_pitch = rb_hash_aref(_opt_hash, ID2SYM(rb_intern("image_row_pitch")));
    }
    if (_opt_hash != Qnil && rb_image_row_pitch != Qnil) {
      image_row_pitch = (size_t)NUM2ULONG(rb_image_row_pitch);

    } else {
      image_row_pitch = 0;
    }
    if (_opt_hash != Qnil) {
      rb_host_ptr = rb_hash_aref(_opt_hash, ID2SYM(rb_intern("host_ptr")));
    }
    if (_opt_hash != Qnil && rb_host_ptr != Qnil) {
      if (TYPE(rb_host_ptr) == T_STRING) {
        host_ptr = RSTRING_PTR(rb_host_ptr);
      } else if (CLASS_OF(rb_host_ptr) == rb_cVArray) {
        struct_varray *s_vary;
        Data_Get_Struct(rb_host_ptr, struct_varray, s_vary);
        host_ptr = s_vary->ptr;
      } else
        rb_raise(rb_eArgError, "wrong type of the argument");

    } else {
      host_ptr = NULL;
    }
  }

  rb_context = argv[0];
  Check_Type(rb_context, T_DATA);
  if (CLASS_OF(rb_context) != rb_cContext)
    rb_raise(rb_eRuntimeError, "type of context is invalid: Context is expected");
  context = (cl_context)DATA_PTR(rb_context);

  rb_flags = argv[1];
  flags = (uint64_t)NUM2ULONG(rb_flags);

  rb_image_format = argv[2];
  Check_Type(rb_image_format, T_DATA);
  if (CLASS_OF(rb_image_format) != rb_cImageFormat)
    rb_raise(rb_eRuntimeError, "type of image_format is invalid: ImageFormat is expected");
  image_format = (cl_image_format*)DATA_PTR(rb_image_format);




  ret = clCreateImage2D(context, flags, (const cl_image_format*)image_format, image_width, image_height, image_row_pitch, host_ptr, &errcode_ret);
  check_error(errcode_ret);

  {
    VALUE rb_ret;
    {
      struct_mem s_ret;
      s_ret = (struct_mem)xmalloc(sizeof(struct _struct_mem));
      s_ret->mem = ret;
      s_ret->host_ptr = rb_host_ptr;
      rb_ret = create_mem(s_ret);
    }

    result = rb_ret;
  }


  return result;
}
#endif

#ifdef CL_VERSION_1_0
/*
 *  call-seq:
 *     Image3D.new(context, flags, image_format[, opts]) -> mem
 *
 *  opts: image_width, image_height, image_depth, image_row_pitch, image_slice_pitch, host_ptr
 */
VALUE
rb_clCreateImage3D(int argc, VALUE *argv, VALUE self)
{
  cl_context context;
  cl_mem_flags flags;
  cl_image_format *image_format;
  size_t image_width;
  size_t image_height;
  size_t image_depth;
  size_t image_row_pitch;
  size_t image_slice_pitch;
  void *host_ptr;
  cl_int errcode_ret;
  cl_mem ret;
  VALUE rb_context = Qnil;
  VALUE rb_flags = Qnil;
  VALUE rb_image_format = Qnil;
  VALUE rb_image_width = Qnil;
  VALUE rb_image_height = Qnil;
  VALUE rb_image_depth = Qnil;
  VALUE rb_image_row_pitch = Qnil;
  VALUE rb_image_slice_pitch = Qnil;
  VALUE rb_host_ptr = Qnil;

  VALUE result;

  if (argc > 4 || argc < 3)
    rb_raise(rb_eArgError, "wrong number of arguments (%d for 3)", argc);

  {
    VALUE _opt_hash = Qnil;

    if (argc > 3) {
      _opt_hash = argv[3];
      Check_Type(_opt_hash, T_HASH);
    }
    if (_opt_hash != Qnil) {
      rb_image_width = rb_hash_aref(_opt_hash, ID2SYM(rb_intern("image_width")));
    }
    if (_opt_hash != Qnil && rb_image_width != Qnil) {
      image_width = (size_t)NUM2ULONG(rb_image_width);

    } else {
      image_width = 0;
    }
    if (_opt_hash != Qnil) {
      rb_image_height = rb_hash_aref(_opt_hash, ID2SYM(rb_intern("image_height")));
    }
    if (_opt_hash != Qnil && rb_image_height != Qnil) {
      image_height = (size_t)NUM2ULONG(rb_image_height);

    } else {
      image_height = 0;
    }
    if (_opt_hash != Qnil) {
      rb_image_depth = rb_hash_aref(_opt_hash, ID2SYM(rb_intern("image_depth")));
    }
    if (_opt_hash != Qnil && rb_image_depth != Qnil) {
      image_depth = (size_t)NUM2ULONG(rb_image_depth);

    } else {
      image_depth = 0;
    }
    if (_opt_hash != Qnil) {
      rb_image_row_pitch = rb_hash_aref(_opt_hash, ID2SYM(rb_intern("image_row_pitch")));
    }
    if (_opt_hash != Qnil && rb_image_row_pitch != Qnil) {
      image_row_pitch = (size_t)NUM2ULONG(rb_image_row_pitch);

    } else {
      image_row_pitch = 0;
    }
    if (_opt_hash != Qnil) {
      rb_image_slice_pitch = rb_hash_aref(_opt_hash, ID2SYM(rb_intern("image_slice_pitch")));
    }
    if (_opt_hash != Qnil && rb_image_slice_pitch != Qnil) {
      image_slice_pitch = (size_t)NUM2ULONG(rb_image_slice_pitch);

    } else {
      image_slice_pitch = 0;
    }
    if (_opt_hash != Qnil) {
      rb_host_ptr = rb_hash_aref(_opt_hash, ID2SYM(rb_intern("host_ptr")));
    }
    if (_opt_hash != Qnil && rb_host_ptr != Qnil) {
      if (TYPE(rb_host_ptr) == T_STRING) {
        host_ptr = RSTRING_PTR(rb_host_ptr);
      } else if (CLASS_OF(rb_host_ptr) == rb_cVArray) {
        struct_varray *s_vary;
        Data_Get_Struct(rb_host_ptr, struct_varray, s_vary);
        host_ptr = s_vary->ptr;
      } else
        rb_raise(rb_eArgError, "wrong type of the argument");

    } else {
      host_ptr = NULL;
    }
  }

  rb_context = argv[0];
  Check_Type(rb_context, T_DATA);
  if (CLASS_OF(rb_context) != rb_cContext)
    rb_raise(rb_eRuntimeError, "type of context is invalid: Context is expected");
  context = (cl_context)DATA_PTR(rb_context);

  rb_flags = argv[1];
  flags = (uint64_t)NUM2ULONG(rb_flags);

  rb_image_format = argv[2];
  Check_Type(rb_image_format, T_DATA);
  if (CLASS_OF(rb_image_format) != rb_cImageFormat)
    rb_raise(rb_eRuntimeError, "type of image_format is invalid: ImageFormat is expected");
  image_format = (cl_image_format*)DATA_PTR(rb_image_format);




  ret = clCreateImage3D(context, flags, (const cl_image_format*)image_format, image_width, image_height, image_depth, image_row_pitch, image_slice_pitch, host_ptr, &errcode_ret);
  check_error(errcode_ret);

  {
    VALUE rb_ret;
    {
      struct_mem s_ret;
      s_ret = (struct_mem)xmalloc(sizeof(struct _struct_mem));
      s_ret->mem = ret;
      s_ret->host_ptr = rb_host_ptr;
      rb_ret = create_mem(s_ret);
    }

    result = rb_ret;
  }


  return result;
}
#endif

#ifdef CL_VERSION_1_0
/*
 *  call-seq:
 *     Kernel.new(program, kernel_name) -> kernel
 *
 */
VALUE
rb_clCreateKernel(int argc, VALUE *argv, VALUE self)
{
  cl_program program;
  char *kernel_name;
  cl_int errcode_ret;
  cl_kernel ret;
  VALUE rb_program = Qnil;
  VALUE rb_kernel_name = Qnil;

  VALUE result;

  if (argc > 2 || argc < 2)
    rb_raise(rb_eArgError, "wrong number of arguments (%d for 2)", argc);


  rb_program = argv[0];
  Check_Type(rb_program, T_DATA);
  if (CLASS_OF(rb_program) != rb_cProgram)
    rb_raise(rb_eRuntimeError, "type of program is invalid: Program is expected");
  program = (cl_program)DATA_PTR(rb_program);

  rb_kernel_name = argv[1];
  kernel_name = (char*) RSTRING_PTR(rb_kernel_name);




  ret = clCreateKernel(program, (const char*)kernel_name, &errcode_ret);
  check_error(errcode_ret);

  {
    VALUE rb_ret;
    rb_ret = create_kernel(ret);

    result = rb_ret;
  }


  return result;
}
#endif

#ifdef CL_VERSION_1_0
/*
 *  call-seq:
 *     program.create_kernels() -> kernels
 *
 */
VALUE
rb_clCreateKernelsInProgram(int argc, VALUE *argv, VALUE self)
{
  cl_program program;
  cl_uint num_kernels;
  cl_kernel *kernels;
  cl_uint num_kernels_ret;
  cl_int ret;
  VALUE rb_program;
  VALUE rb_kernels = Qnil;

  VALUE result;

  if (argc > 0 || argc < 0)
    rb_raise(rb_eArgError, "wrong number of arguments (%d for 0)", argc);


  rb_program = self;
  Check_Type(rb_program, T_DATA);
  if (CLASS_OF(rb_program) != rb_cProgram)
    rb_raise(rb_eRuntimeError, "type of program is invalid: Program is expected");
  program = (cl_program)DATA_PTR(rb_program);



  ret = clCreateKernelsInProgram(program, 0, NULL, &num_kernels_ret);
  num_kernels = num_kernels_ret;
  check_error(ret);
  kernels = ALLOC_N(cl_kernel, num_kernels);

  ret = clCreateKernelsInProgram(program, num_kernels, kernels, NULL);
  check_error(ret);

  {
    {
      VALUE ary[num_kernels];
      int ii;
      for (ii=0; ii<(int)num_kernels; ii++)
        ary[ii] = create_kernel(kernels[ii]);
      rb_kernels = rb_ary_new4(num_kernels, ary);
    }

    result = rb_kernels;
  }


  return result;
}
#endif

#ifdef CL_VERSION_1_0
/*
 *  call-seq:
 *     context.create_program_with_binary(device_list, binaries) -> program, binary_status
 *
 */
VALUE
rb_clCreateProgramWithBinary(int argc, VALUE *argv, VALUE self)
{
  cl_context context;
  cl_uint num_devices;
  cl_device_id *device_list;
  size_t *lengths;
  unsigned char **binaries;
  cl_int binary_status;
  cl_int errcode_ret;
  cl_program ret;
  VALUE rb_context;
  VALUE rb_device_list = Qnil;
  VALUE rb_binaries = Qnil;
  VALUE rb_binary_status = Qnil;

  VALUE result;

  if (argc > 2 || argc < 2)
    rb_raise(rb_eArgError, "wrong number of arguments (%d for 2)", argc);


  rb_context = self;
  Check_Type(rb_context, T_DATA);
  if (CLASS_OF(rb_context) != rb_cContext)
    rb_raise(rb_eRuntimeError, "type of context is invalid: Context is expected");
  context = (cl_context)DATA_PTR(rb_context);

  rb_device_list = argv[0];
  Check_Type(rb_device_list, T_ARRAY);
  {
    int n;
    num_devices = RARRAY_LEN(rb_device_list);
    device_list = ALLOC_N(cl_device_id, num_devices);
    for (n=0; n<(int)num_devices; n++) {
      Check_Type(RARRAY_PTR(rb_device_list)[n], T_DATA);
      if (CLASS_OF(RARRAY_PTR(rb_device_list)[n]) != rb_cDevice)
        rb_raise(rb_eRuntimeError, "type of device_list[n] is invalid: Device is expected");
      device_list[n] = (cl_device_id)DATA_PTR(RARRAY_PTR(rb_device_list)[n]);
    }
  }

  rb_binaries = argv[1];
  Check_Type(rb_binaries, T_ARRAY);
  {
    int n;
    if (RARRAY_LEN(rb_binaries) != num_devices)
      rb_raise(rb_eArgError, "length of rb_#{name} is invalid");
    binaries = ALLOC_N(unsigned char*, num_devices);
    lengths = ALLOC_N(size_t, num_devices);
    for (n=0; n<(int)num_devices; n++) {
      binaries[n] = (unsigned char*) RSTRING_PTR(RARRAY_PTR(rb_binaries)[n]);
      lengths[n] = RSTRING_LEN(RARRAY_PTR(rb_binaries)[n]);
    }
  }




  ret = clCreateProgramWithBinary(context, num_devices, (const cl_device_id*)device_list, (const size_t*)lengths, (const unsigned char**)binaries, &binary_status, &errcode_ret);
  check_error(errcode_ret);

  {
    VALUE rb_ret;
    rb_ret = create_program(ret);

    rb_binary_status = INT2NUM((int32_t)binary_status);

    result = rb_ary_new3(2, rb_ret, rb_binary_status);
  }

  if (device_list) xfree(device_list);
  if (binaries) xfree(binaries);
  if (lengths) xfree(lengths);

  return result;
}
#endif

#ifdef CL_VERSION_1_0
/*
 *  call-seq:
 *     Program.create_with_source(context, strings) -> program
 *
 */
VALUE
rb_clCreateProgramWithSource(int argc, VALUE *argv, VALUE self)
{
  cl_context context;
  cl_uint count;
  char **strings;
  size_t *lengths;
  cl_int errcode_ret;
  cl_program ret;
  VALUE rb_context = Qnil;
  VALUE rb_strings = Qnil;

  VALUE result;

  if (argc > 2 || argc < 2)
    rb_raise(rb_eArgError, "wrong number of arguments (%d for 2)", argc);


  rb_context = argv[0];
  Check_Type(rb_context, T_DATA);
  if (CLASS_OF(rb_context) != rb_cContext)
    rb_raise(rb_eRuntimeError, "type of context is invalid: Context is expected");
  context = (cl_context)DATA_PTR(rb_context);

  rb_strings = argv[1];
  Check_Type(rb_strings, T_ARRAY);
  count = RARRAY_LEN(rb_strings);
  {
    int n;
    if (RARRAY_LEN(rb_strings) != count)
      rb_raise(rb_eArgError, "length of rb_#{name} is invalid");
    strings = ALLOC_N(char*, count);
    lengths = ALLOC_N(size_t, count);
    for (n=0; n<(int)count; n++) {
      strings[n] = (char*) RSTRING_PTR(RARRAY_PTR(rb_strings)[n]);
      lengths[n] = 0;
    }
  }




  ret = clCreateProgramWithSource(context, count, (const char**)strings, (const size_t*)lengths, &errcode_ret);
  check_error(errcode_ret);

  {
    VALUE rb_ret;
    rb_ret = create_program(ret);

    result = rb_ret;
  }

  if (strings) xfree(strings);
  if (lengths) xfree(lengths);

  return result;
}
#endif

#ifdef CL_VERSION_1_0
/*
 *  call-seq:
 *     Sampler.new(context, normalized_coords, addressing_mode, filter_mode) -> sampler
 *
 */
VALUE
rb_clCreateSampler(int argc, VALUE *argv, VALUE self)
{
  cl_context context;
  cl_bool normalized_coords;
  cl_addressing_mode addressing_mode;
  cl_filter_mode filter_mode;
  cl_int errcode_ret;
  cl_sampler ret;
  VALUE rb_context = Qnil;
  VALUE rb_normalized_coords = Qnil;
  VALUE rb_addressing_mode = Qnil;
  VALUE rb_filter_mode = Qnil;

  VALUE result;

  if (argc > 4 || argc < 4)
    rb_raise(rb_eArgError, "wrong number of arguments (%d for 4)", argc);


  rb_context = argv[0];
  Check_Type(rb_context, T_DATA);
  if (CLASS_OF(rb_context) != rb_cContext)
    rb_raise(rb_eRuntimeError, "type of context is invalid: Context is expected");
  context = (cl_context)DATA_PTR(rb_context);

  rb_normalized_coords = argv[1];
  normalized_coords = (uint32_t)NUM2UINT(rb_normalized_coords);

  rb_addressing_mode = argv[2];
  addressing_mode = (uint32_t)NUM2UINT(rb_addressing_mode);

  rb_filter_mode = argv[3];
  filter_mode = (uint32_t)NUM2UINT(rb_filter_mode);




  ret = clCreateSampler(context, normalized_coords, addressing_mode, filter_mode, &errcode_ret);
  check_error(errcode_ret);

  {
    VALUE rb_ret;
    rb_ret = create_sampler(ret);

    result = rb_ret;
  }


  return result;
}
#endif

#ifdef CL_VERSION_1_1
/*
 *  call-seq:
 *     mem.create_sub_buffer(flags, buffer_create_type, buffer_create_info) -> mem
 *
 */
VALUE
rb_clCreateSubBuffer(int argc, VALUE *argv, VALUE self)
{
  cl_mem buffer;
  cl_mem_flags flags;
  cl_buffer_create_type buffer_create_type;
  void *buffer_create_info;
  cl_int errcode_ret;
  cl_mem ret;
  VALUE rb_buffer;
  VALUE rb_flags = Qnil;
  VALUE rb_buffer_create_type = Qnil;
  VALUE rb_buffer_create_info = Qnil;

  VALUE result;

  if (argc > 3 || argc < 3)
    rb_raise(rb_eArgError, "wrong number of arguments (%d for 3)", argc);


  rb_buffer = self;
  Check_Type(rb_buffer, T_DATA);
  if (CLASS_OF(rb_buffer) != rb_cMem)
    rb_raise(rb_eRuntimeError, "type of buffer is invalid: Mem is expected");
  buffer = ((struct_mem)DATA_PTR(rb_buffer))->mem;

  rb_flags = argv[0];
  flags = (uint64_t)NUM2ULONG(rb_flags);

  rb_buffer_create_type = argv[1];
  buffer_create_type = (uint32_t)NUM2UINT(rb_buffer_create_type);

  rb_buffer_create_info = argv[2];
  buffer_create_info = (void*) RSTRING_PTR(rb_buffer_create_info);




  ret = clCreateSubBuffer(buffer, flags, buffer_create_type, (const void*)buffer_create_info, &errcode_ret);
  check_error(errcode_ret);

  VALUE rb_host_ptr = Qnil;
  {
    VALUE rb_ret;
    {
      struct_mem s_ret;
      s_ret = (struct_mem)xmalloc(sizeof(struct _struct_mem));
      s_ret->mem = ret;
      s_ret->host_ptr = rb_host_ptr;
      rb_ret = create_mem(s_ret);
    }

    result = rb_ret;
  }


  return result;
}
#endif

#ifdef CL_VERSION_1_0
/*
 *  call-seq:
 *     commandqueue.enqueue_barrier() -> nil
 *
 */
VALUE
rb_clEnqueueBarrier(int argc, VALUE *argv, VALUE self)
{
  cl_command_queue command_queue;
  cl_int ret;
  VALUE rb_command_queue;

  VALUE result;

  if (argc > 0 || argc < 0)
    rb_raise(rb_eArgError, "wrong number of arguments (%d for 0)", argc);


  rb_command_queue = self;
  Check_Type(rb_command_queue, T_DATA);
  if (CLASS_OF(rb_command_queue) != rb_cCommandQueue)
    rb_raise(rb_eRuntimeError, "type of command_queue is invalid: CommandQueue is expected");
  command_queue = (cl_command_queue)DATA_PTR(rb_command_queue);




  ret = clEnqueueBarrier(command_queue);
  check_error(ret);

  {
    result = Qnil;
  }


  return result;
}
#endif

#ifdef CL_VERSION_1_0
/*
 *  call-seq:
 *     commandqueue.enqueue_copy_buffer(src_buffer, dst_buffer[, opts]) -> event
 *
 *  opts: src_offset, dst_offset, cb, event_wait_list
 */
VALUE
rb_clEnqueueCopyBuffer(int argc, VALUE *argv, VALUE self)
{
  cl_command_queue command_queue;
  cl_mem src_buffer;
  cl_mem dst_buffer;
  size_t src_offset;
  size_t dst_offset;
  size_t cb;
  cl_uint num_events_in_wait_list;
  cl_event *event_wait_list;
  cl_event event;
  cl_int ret;
  VALUE rb_command_queue;
  VALUE rb_src_buffer = Qnil;
  VALUE rb_dst_buffer = Qnil;
  VALUE rb_src_offset = Qnil;
  VALUE rb_dst_offset = Qnil;
  VALUE rb_cb = Qnil;
  VALUE rb_event_wait_list = Qnil;
  VALUE rb_event = Qnil;

  VALUE result;

  if (argc > 3 || argc < 2)
    rb_raise(rb_eArgError, "wrong number of arguments (%d for 2)", argc);

  {
    VALUE _opt_hash = Qnil;

    if (argc > 2) {
      _opt_hash = argv[2];
      Check_Type(_opt_hash, T_HASH);
    }
    if (_opt_hash != Qnil) {
      rb_src_offset = rb_hash_aref(_opt_hash, ID2SYM(rb_intern("src_offset")));
    }
    if (_opt_hash != Qnil && rb_src_offset != Qnil) {
      src_offset = (size_t)NUM2ULONG(rb_src_offset);

    } else {
      src_offset = 0;
    }
    if (_opt_hash != Qnil) {
      rb_dst_offset = rb_hash_aref(_opt_hash, ID2SYM(rb_intern("dst_offset")));
    }
    if (_opt_hash != Qnil && rb_dst_offset != Qnil) {
      dst_offset = (size_t)NUM2ULONG(rb_dst_offset);

    } else {
      dst_offset = 0;
    }
    if (_opt_hash != Qnil) {
      rb_cb = rb_hash_aref(_opt_hash, ID2SYM(rb_intern("cb")));
    }
    if (_opt_hash != Qnil && rb_cb != Qnil) {
      cb = (size_t)NUM2ULONG(rb_cb);

    } else {
      cb = 0;
    }
    if (_opt_hash != Qnil) {
      rb_event_wait_list = rb_hash_aref(_opt_hash, ID2SYM(rb_intern("event_wait_list")));
    }
    if (_opt_hash != Qnil && rb_event_wait_list != Qnil) {
      Check_Type(rb_event_wait_list, T_ARRAY);
      {
        int n;
        num_events_in_wait_list = RARRAY_LEN(rb_event_wait_list);
        event_wait_list = ALLOC_N(cl_event, num_events_in_wait_list);
        for (n=0; n<(int)num_events_in_wait_list; n++) {
          Check_Type(RARRAY_PTR(rb_event_wait_list)[n], T_DATA);
          if (CLASS_OF(RARRAY_PTR(rb_event_wait_list)[n]) != rb_cEvent)
            rb_raise(rb_eRuntimeError, "type of event_wait_list[n] is invalid: Event is expected");
          event_wait_list[n] = (cl_event)DATA_PTR(RARRAY_PTR(rb_event_wait_list)[n]);
        }
      }

    } else {
      event_wait_list = NULL;
      num_events_in_wait_list = 0;
    }
  }

  rb_command_queue = self;
  Check_Type(rb_command_queue, T_DATA);
  if (CLASS_OF(rb_command_queue) != rb_cCommandQueue)
    rb_raise(rb_eRuntimeError, "type of command_queue is invalid: CommandQueue is expected");
  command_queue = (cl_command_queue)DATA_PTR(rb_command_queue);

  rb_src_buffer = argv[0];
  Check_Type(rb_src_buffer, T_DATA);
  if (CLASS_OF(rb_src_buffer) != rb_cMem)
    rb_raise(rb_eRuntimeError, "type of src_buffer is invalid: Mem is expected");
  src_buffer = ((struct_mem)DATA_PTR(rb_src_buffer))->mem;

  rb_dst_buffer = argv[1];
  Check_Type(rb_dst_buffer, T_DATA);
  if (CLASS_OF(rb_dst_buffer) != rb_cMem)
    rb_raise(rb_eRuntimeError, "type of dst_buffer is invalid: Mem is expected");
  dst_buffer = ((struct_mem)DATA_PTR(rb_dst_buffer))->mem;




  ret = clEnqueueCopyBuffer(command_queue, src_buffer, dst_buffer, src_offset, dst_offset, cb, num_events_in_wait_list, (const cl_event*)event_wait_list, &event);
  check_error(ret);

  {
    rb_event = create_event(event);

    result = rb_event;
  }

  if (event_wait_list) xfree(event_wait_list);

  return result;
}
#endif

#ifdef CL_VERSION_1_1
/*
 *  call-seq:
 *     commandqueue.enqueue_copy_buffer_rect(src_buffer, dst_buffer[, opts]) -> event
 *
 *  opts: src_origin, dst_origin, region, src_row_pitch, src_slice_pitch, dst_row_pitch, dst_slice_pitch, event_wait_list
 */
VALUE
rb_clEnqueueCopyBufferRect(int argc, VALUE *argv, VALUE self)
{
  cl_command_queue command_queue;
  cl_mem src_buffer;
  cl_mem dst_buffer;
  size_t *src_origin;
  size_t *dst_origin;
  size_t *region;
  size_t src_row_pitch;
  size_t src_slice_pitch;
  size_t dst_row_pitch;
  size_t dst_slice_pitch;
  cl_uint num_events_in_wait_list;
  cl_event *event_wait_list;
  cl_event event;
  cl_int ret;
  VALUE rb_command_queue;
  VALUE rb_src_buffer = Qnil;
  VALUE rb_dst_buffer = Qnil;
  VALUE rb_src_origin = Qnil;
  VALUE rb_dst_origin = Qnil;
  VALUE rb_region = Qnil;
  VALUE rb_src_row_pitch = Qnil;
  VALUE rb_src_slice_pitch = Qnil;
  VALUE rb_dst_row_pitch = Qnil;
  VALUE rb_dst_slice_pitch = Qnil;
  VALUE rb_event_wait_list = Qnil;
  VALUE rb_event = Qnil;

  VALUE result;

  if (argc > 3 || argc < 2)
    rb_raise(rb_eArgError, "wrong number of arguments (%d for 2)", argc);

  {
    VALUE _opt_hash = Qnil;

    if (argc > 2) {
      _opt_hash = argv[2];
      Check_Type(_opt_hash, T_HASH);
    }
    if (_opt_hash != Qnil) {
      rb_src_origin = rb_hash_aref(_opt_hash, ID2SYM(rb_intern("src_origin")));
    }
    if (_opt_hash != Qnil && rb_src_origin != Qnil) {
      Check_Type(rb_src_origin, T_ARRAY);
      {
        int n;
        if (RARRAY_LEN(rb_src_origin) != 3)
          rb_raise(rb_eArgError, "length of rb_#{name} is invalid");
        src_origin = ALLOC_N(size_t, 3);
        for (n=0; n<(int)3; n++) {
          src_origin[n] = (size_t)NUM2ULONG(RARRAY_PTR(rb_src_origin)[n]);
        }
  }

    } else {
      src_origin = NULL;
    }
    if (_opt_hash != Qnil) {
      rb_dst_origin = rb_hash_aref(_opt_hash, ID2SYM(rb_intern("dst_origin")));
    }
    if (_opt_hash != Qnil && rb_dst_origin != Qnil) {
      Check_Type(rb_dst_origin, T_ARRAY);
      {
        int n;
        if (RARRAY_LEN(rb_dst_origin) != 3)
          rb_raise(rb_eArgError, "length of rb_#{name} is invalid");
        dst_origin = ALLOC_N(size_t, 3);
        for (n=0; n<(int)3; n++) {
          dst_origin[n] = (size_t)NUM2ULONG(RARRAY_PTR(rb_dst_origin)[n]);
        }
  }

    } else {
      dst_origin = NULL;
    }
    if (_opt_hash != Qnil) {
      rb_region = rb_hash_aref(_opt_hash, ID2SYM(rb_intern("region")));
    }
    if (_opt_hash != Qnil && rb_region != Qnil) {
      Check_Type(rb_region, T_ARRAY);
      {
        int n;
        if (RARRAY_LEN(rb_region) != 3)
          rb_raise(rb_eArgError, "length of rb_#{name} is invalid");
        region = ALLOC_N(size_t, 3);
        for (n=0; n<(int)3; n++) {
          region[n] = (size_t)NUM2ULONG(RARRAY_PTR(rb_region)[n]);
        }
  }

    } else {
      region = NULL;
    }
    if (_opt_hash != Qnil) {
      rb_src_row_pitch = rb_hash_aref(_opt_hash, ID2SYM(rb_intern("src_row_pitch")));
    }
    if (_opt_hash != Qnil && rb_src_row_pitch != Qnil) {
      src_row_pitch = (size_t)NUM2ULONG(rb_src_row_pitch);

    } else {
      src_row_pitch = 0;
    }
    if (_opt_hash != Qnil) {
      rb_src_slice_pitch = rb_hash_aref(_opt_hash, ID2SYM(rb_intern("src_slice_pitch")));
    }
    if (_opt_hash != Qnil && rb_src_slice_pitch != Qnil) {
      src_slice_pitch = (size_t)NUM2ULONG(rb_src_slice_pitch);

    } else {
      src_slice_pitch = 0;
    }
    if (_opt_hash != Qnil) {
      rb_dst_row_pitch = rb_hash_aref(_opt_hash, ID2SYM(rb_intern("dst_row_pitch")));
    }
    if (_opt_hash != Qnil && rb_dst_row_pitch != Qnil) {
      dst_row_pitch = (size_t)NUM2ULONG(rb_dst_row_pitch);

    } else {
      dst_row_pitch = 0;
    }
    if (_opt_hash != Qnil) {
      rb_dst_slice_pitch = rb_hash_aref(_opt_hash, ID2SYM(rb_intern("dst_slice_pitch")));
    }
    if (_opt_hash != Qnil && rb_dst_slice_pitch != Qnil) {
      dst_slice_pitch = (size_t)NUM2ULONG(rb_dst_slice_pitch);

    } else {
      dst_slice_pitch = 0;
    }
    if (_opt_hash != Qnil) {
      rb_event_wait_list = rb_hash_aref(_opt_hash, ID2SYM(rb_intern("event_wait_list")));
    }
    if (_opt_hash != Qnil && rb_event_wait_list != Qnil) {
      Check_Type(rb_event_wait_list, T_ARRAY);
      {
        int n;
        num_events_in_wait_list = RARRAY_LEN(rb_event_wait_list);
        event_wait_list = ALLOC_N(cl_event, num_events_in_wait_list);
        for (n=0; n<(int)num_events_in_wait_list; n++) {
          Check_Type(RARRAY_PTR(rb_event_wait_list)[n], T_DATA);
          if (CLASS_OF(RARRAY_PTR(rb_event_wait_list)[n]) != rb_cEvent)
            rb_raise(rb_eRuntimeError, "type of event_wait_list[n] is invalid: Event is expected");
          event_wait_list[n] = (cl_event)DATA_PTR(RARRAY_PTR(rb_event_wait_list)[n]);
        }
      }

    } else {
      event_wait_list = NULL;
      num_events_in_wait_list = 0;
    }
  }

  rb_command_queue = self;
  Check_Type(rb_command_queue, T_DATA);
  if (CLASS_OF(rb_command_queue) != rb_cCommandQueue)
    rb_raise(rb_eRuntimeError, "type of command_queue is invalid: CommandQueue is expected");
  command_queue = (cl_command_queue)DATA_PTR(rb_command_queue);

  rb_src_buffer = argv[0];
  Check_Type(rb_src_buffer, T_DATA);
  if (CLASS_OF(rb_src_buffer) != rb_cMem)
    rb_raise(rb_eRuntimeError, "type of src_buffer is invalid: Mem is expected");
  src_buffer = ((struct_mem)DATA_PTR(rb_src_buffer))->mem;

  rb_dst_buffer = argv[1];
  Check_Type(rb_dst_buffer, T_DATA);
  if (CLASS_OF(rb_dst_buffer) != rb_cMem)
    rb_raise(rb_eRuntimeError, "type of dst_buffer is invalid: Mem is expected");
  dst_buffer = ((struct_mem)DATA_PTR(rb_dst_buffer))->mem;




  ret = clEnqueueCopyBufferRect(command_queue, src_buffer, dst_buffer, (const size_t*)src_origin, (const size_t*)dst_origin, (const size_t*)region, src_row_pitch, src_slice_pitch, dst_row_pitch, dst_slice_pitch, num_events_in_wait_list, (const cl_event*)event_wait_list, &event);
  check_error(ret);

  {
    rb_event = create_event(event);

    result = rb_event;
  }

  if (src_origin) xfree(src_origin);
  if (dst_origin) xfree(dst_origin);
  if (region) xfree(region);
  if (event_wait_list) xfree(event_wait_list);

  return result;
}
#endif

#ifdef CL_VERSION_1_0
/*
 *  call-seq:
 *     commandqueue.enqueue_copy_buffer_to_image(src_buffer, dst_image[, opts]) -> event
 *
 *  opts: src_offset, dst_origin, region, event_wait_list
 */
VALUE
rb_clEnqueueCopyBufferToImage(int argc, VALUE *argv, VALUE self)
{
  cl_command_queue command_queue;
  cl_mem src_buffer;
  cl_mem dst_image;
  size_t src_offset;
  size_t *dst_origin;
  size_t *region;
  cl_uint num_events_in_wait_list;
  cl_event *event_wait_list;
  cl_event event;
  cl_int ret;
  VALUE rb_command_queue;
  VALUE rb_src_buffer = Qnil;
  VALUE rb_dst_image = Qnil;
  VALUE rb_src_offset = Qnil;
  VALUE rb_dst_origin = Qnil;
  VALUE rb_region = Qnil;
  VALUE rb_event_wait_list = Qnil;
  VALUE rb_event = Qnil;

  VALUE result;

  if (argc > 3 || argc < 2)
    rb_raise(rb_eArgError, "wrong number of arguments (%d for 2)", argc);

  {
    VALUE _opt_hash = Qnil;

    if (argc > 2) {
      _opt_hash = argv[2];
      Check_Type(_opt_hash, T_HASH);
    }
    if (_opt_hash != Qnil) {
      rb_src_offset = rb_hash_aref(_opt_hash, ID2SYM(rb_intern("src_offset")));
    }
    if (_opt_hash != Qnil && rb_src_offset != Qnil) {
      src_offset = (size_t)NUM2ULONG(rb_src_offset);

    } else {
      src_offset = 0;
    }
    if (_opt_hash != Qnil) {
      rb_dst_origin = rb_hash_aref(_opt_hash, ID2SYM(rb_intern("dst_origin")));
    }
    if (_opt_hash != Qnil && rb_dst_origin != Qnil) {
      Check_Type(rb_dst_origin, T_ARRAY);
      {
        int n;
        if (RARRAY_LEN(rb_dst_origin) != 3)
          rb_raise(rb_eArgError, "length of rb_#{name} is invalid");
        dst_origin = ALLOC_N(size_t, 3);
        for (n=0; n<(int)3; n++) {
          dst_origin[n] = (size_t)NUM2ULONG(RARRAY_PTR(rb_dst_origin)[n]);
        }
  }

    } else {
      dst_origin = NULL;
    }
    if (_opt_hash != Qnil) {
      rb_region = rb_hash_aref(_opt_hash, ID2SYM(rb_intern("region")));
    }
    if (_opt_hash != Qnil && rb_region != Qnil) {
      Check_Type(rb_region, T_ARRAY);
      {
        int n;
        if (RARRAY_LEN(rb_region) != 3)
          rb_raise(rb_eArgError, "length of rb_#{name} is invalid");
        region = ALLOC_N(size_t, 3);
        for (n=0; n<(int)3; n++) {
          region[n] = (size_t)NUM2ULONG(RARRAY_PTR(rb_region)[n]);
        }
  }

    } else {
      region = NULL;
    }
    if (_opt_hash != Qnil) {
      rb_event_wait_list = rb_hash_aref(_opt_hash, ID2SYM(rb_intern("event_wait_list")));
    }
    if (_opt_hash != Qnil && rb_event_wait_list != Qnil) {
      Check_Type(rb_event_wait_list, T_ARRAY);
      {
        int n;
        num_events_in_wait_list = RARRAY_LEN(rb_event_wait_list);
        event_wait_list = ALLOC_N(cl_event, num_events_in_wait_list);
        for (n=0; n<(int)num_events_in_wait_list; n++) {
          Check_Type(RARRAY_PTR(rb_event_wait_list)[n], T_DATA);
          if (CLASS_OF(RARRAY_PTR(rb_event_wait_list)[n]) != rb_cEvent)
            rb_raise(rb_eRuntimeError, "type of event_wait_list[n] is invalid: Event is expected");
          event_wait_list[n] = (cl_event)DATA_PTR(RARRAY_PTR(rb_event_wait_list)[n]);
        }
      }

    } else {
      event_wait_list = NULL;
      num_events_in_wait_list = 0;
    }
  }

  rb_command_queue = self;
  Check_Type(rb_command_queue, T_DATA);
  if (CLASS_OF(rb_command_queue) != rb_cCommandQueue)
    rb_raise(rb_eRuntimeError, "type of command_queue is invalid: CommandQueue is expected");
  command_queue = (cl_command_queue)DATA_PTR(rb_command_queue);

  rb_src_buffer = argv[0];
  Check_Type(rb_src_buffer, T_DATA);
  if (CLASS_OF(rb_src_buffer) != rb_cMem)
    rb_raise(rb_eRuntimeError, "type of src_buffer is invalid: Mem is expected");
  src_buffer = ((struct_mem)DATA_PTR(rb_src_buffer))->mem;

  rb_dst_image = argv[1];
  Check_Type(rb_dst_image, T_DATA);
  if (CLASS_OF(rb_dst_image) != rb_cMem)
    rb_raise(rb_eRuntimeError, "type of dst_image is invalid: Mem is expected");
  dst_image = ((struct_mem)DATA_PTR(rb_dst_image))->mem;




  ret = clEnqueueCopyBufferToImage(command_queue, src_buffer, dst_image, src_offset, (const size_t*)dst_origin, (const size_t*)region, num_events_in_wait_list, (const cl_event*)event_wait_list, &event);
  check_error(ret);

  {
    rb_event = create_event(event);

    result = rb_event;
  }

  if (dst_origin) xfree(dst_origin);
  if (region) xfree(region);
  if (event_wait_list) xfree(event_wait_list);

  return result;
}
#endif

#ifdef CL_VERSION_1_0
/*
 *  call-seq:
 *     commandqueue.enqueue_copy_image(src_image, dst_image[, opts]) -> event
 *
 *  opts: src_origin, dst_origin, region, event_wait_list
 */
VALUE
rb_clEnqueueCopyImage(int argc, VALUE *argv, VALUE self)
{
  cl_command_queue command_queue;
  cl_mem src_image;
  cl_mem dst_image;
  size_t *src_origin;
  size_t *dst_origin;
  size_t *region;
  cl_uint num_events_in_wait_list;
  cl_event *event_wait_list;
  cl_event event;
  cl_int ret;
  VALUE rb_command_queue;
  VALUE rb_src_image = Qnil;
  VALUE rb_dst_image = Qnil;
  VALUE rb_src_origin = Qnil;
  VALUE rb_dst_origin = Qnil;
  VALUE rb_region = Qnil;
  VALUE rb_event_wait_list = Qnil;
  VALUE rb_event = Qnil;

  VALUE result;

  if (argc > 3 || argc < 2)
    rb_raise(rb_eArgError, "wrong number of arguments (%d for 2)", argc);

  {
    VALUE _opt_hash = Qnil;

    if (argc > 2) {
      _opt_hash = argv[2];
      Check_Type(_opt_hash, T_HASH);
    }
    if (_opt_hash != Qnil) {
      rb_src_origin = rb_hash_aref(_opt_hash, ID2SYM(rb_intern("src_origin")));
    }
    if (_opt_hash != Qnil && rb_src_origin != Qnil) {
      Check_Type(rb_src_origin, T_ARRAY);
      {
        int n;
        if (RARRAY_LEN(rb_src_origin) != 3)
          rb_raise(rb_eArgError, "length of rb_#{name} is invalid");
        src_origin = ALLOC_N(size_t, 3);
        for (n=0; n<(int)3; n++) {
          src_origin[n] = (size_t)NUM2ULONG(RARRAY_PTR(rb_src_origin)[n]);
        }
  }

    } else {
      src_origin = NULL;
    }
    if (_opt_hash != Qnil) {
      rb_dst_origin = rb_hash_aref(_opt_hash, ID2SYM(rb_intern("dst_origin")));
    }
    if (_opt_hash != Qnil && rb_dst_origin != Qnil) {
      Check_Type(rb_dst_origin, T_ARRAY);
      {
        int n;
        if (RARRAY_LEN(rb_dst_origin) != 3)
          rb_raise(rb_eArgError, "length of rb_#{name} is invalid");
        dst_origin = ALLOC_N(size_t, 3);
        for (n=0; n<(int)3; n++) {
          dst_origin[n] = (size_t)NUM2ULONG(RARRAY_PTR(rb_dst_origin)[n]);
        }
  }

    } else {
      dst_origin = NULL;
    }
    if (_opt_hash != Qnil) {
      rb_region = rb_hash_aref(_opt_hash, ID2SYM(rb_intern("region")));
    }
    if (_opt_hash != Qnil && rb_region != Qnil) {
      Check_Type(rb_region, T_ARRAY);
      {
        int n;
        if (RARRAY_LEN(rb_region) != 3)
          rb_raise(rb_eArgError, "length of rb_#{name} is invalid");
        region = ALLOC_N(size_t, 3);
        for (n=0; n<(int)3; n++) {
          region[n] = (size_t)NUM2ULONG(RARRAY_PTR(rb_region)[n]);
        }
  }

    } else {
      region = NULL;
    }
    if (_opt_hash != Qnil) {
      rb_event_wait_list = rb_hash_aref(_opt_hash, ID2SYM(rb_intern("event_wait_list")));
    }
    if (_opt_hash != Qnil && rb_event_wait_list != Qnil) {
      Check_Type(rb_event_wait_list, T_ARRAY);
      {
        int n;
        num_events_in_wait_list = RARRAY_LEN(rb_event_wait_list);
        event_wait_list = ALLOC_N(cl_event, num_events_in_wait_list);
        for (n=0; n<(int)num_events_in_wait_list; n++) {
          Check_Type(RARRAY_PTR(rb_event_wait_list)[n], T_DATA);
          if (CLASS_OF(RARRAY_PTR(rb_event_wait_list)[n]) != rb_cEvent)
            rb_raise(rb_eRuntimeError, "type of event_wait_list[n] is invalid: Event is expected");
          event_wait_list[n] = (cl_event)DATA_PTR(RARRAY_PTR(rb_event_wait_list)[n]);
        }
      }

    } else {
      event_wait_list = NULL;
      num_events_in_wait_list = 0;
    }
  }

  rb_command_queue = self;
  Check_Type(rb_command_queue, T_DATA);
  if (CLASS_OF(rb_command_queue) != rb_cCommandQueue)
    rb_raise(rb_eRuntimeError, "type of command_queue is invalid: CommandQueue is expected");
  command_queue = (cl_command_queue)DATA_PTR(rb_command_queue);

  rb_src_image = argv[0];
  Check_Type(rb_src_image, T_DATA);
  if (CLASS_OF(rb_src_image) != rb_cMem)
    rb_raise(rb_eRuntimeError, "type of src_image is invalid: Mem is expected");
  src_image = ((struct_mem)DATA_PTR(rb_src_image))->mem;

  rb_dst_image = argv[1];
  Check_Type(rb_dst_image, T_DATA);
  if (CLASS_OF(rb_dst_image) != rb_cMem)
    rb_raise(rb_eRuntimeError, "type of dst_image is invalid: Mem is expected");
  dst_image = ((struct_mem)DATA_PTR(rb_dst_image))->mem;




  ret = clEnqueueCopyImage(command_queue, src_image, dst_image, (const size_t*)src_origin, (const size_t*)dst_origin, (const size_t*)region, num_events_in_wait_list, (const cl_event*)event_wait_list, &event);
  check_error(ret);

  {
    rb_event = create_event(event);

    result = rb_event;
  }

  if (src_origin) xfree(src_origin);
  if (dst_origin) xfree(dst_origin);
  if (region) xfree(region);
  if (event_wait_list) xfree(event_wait_list);

  return result;
}
#endif

#ifdef CL_VERSION_1_0
/*
 *  call-seq:
 *     commandqueue.enqueue_copy_image_to_buffer(src_image, dst_buffer[, opts]) -> event
 *
 *  opts: src_origin, region, dst_offset, event_wait_list
 */
VALUE
rb_clEnqueueCopyImageToBuffer(int argc, VALUE *argv, VALUE self)
{
  cl_command_queue command_queue;
  cl_mem src_image;
  cl_mem dst_buffer;
  size_t *src_origin;
  size_t *region;
  size_t dst_offset;
  cl_uint num_events_in_wait_list;
  cl_event *event_wait_list;
  cl_event event;
  cl_int ret;
  VALUE rb_command_queue;
  VALUE rb_src_image = Qnil;
  VALUE rb_dst_buffer = Qnil;
  VALUE rb_src_origin = Qnil;
  VALUE rb_region = Qnil;
  VALUE rb_dst_offset = Qnil;
  VALUE rb_event_wait_list = Qnil;
  VALUE rb_event = Qnil;

  VALUE result;

  if (argc > 3 || argc < 2)
    rb_raise(rb_eArgError, "wrong number of arguments (%d for 2)", argc);

  {
    VALUE _opt_hash = Qnil;

    if (argc > 2) {
      _opt_hash = argv[2];
      Check_Type(_opt_hash, T_HASH);
    }
    if (_opt_hash != Qnil) {
      rb_src_origin = rb_hash_aref(_opt_hash, ID2SYM(rb_intern("src_origin")));
    }
    if (_opt_hash != Qnil && rb_src_origin != Qnil) {
      Check_Type(rb_src_origin, T_ARRAY);
      {
        int n;
        if (RARRAY_LEN(rb_src_origin) != 3)
          rb_raise(rb_eArgError, "length of rb_#{name} is invalid");
        src_origin = ALLOC_N(size_t, 3);
        for (n=0; n<(int)3; n++) {
          src_origin[n] = (size_t)NUM2ULONG(RARRAY_PTR(rb_src_origin)[n]);
        }
  }

    } else {
      src_origin = NULL;
    }
    if (_opt_hash != Qnil) {
      rb_region = rb_hash_aref(_opt_hash, ID2SYM(rb_intern("region")));
    }
    if (_opt_hash != Qnil && rb_region != Qnil) {
      Check_Type(rb_region, T_ARRAY);
      {
        int n;
        if (RARRAY_LEN(rb_region) != 3)
          rb_raise(rb_eArgError, "length of rb_#{name} is invalid");
        region = ALLOC_N(size_t, 3);
        for (n=0; n<(int)3; n++) {
          region[n] = (size_t)NUM2ULONG(RARRAY_PTR(rb_region)[n]);
        }
  }

    } else {
      region = NULL;
    }
    if (_opt_hash != Qnil) {
      rb_dst_offset = rb_hash_aref(_opt_hash, ID2SYM(rb_intern("dst_offset")));
    }
    if (_opt_hash != Qnil && rb_dst_offset != Qnil) {
      dst_offset = (size_t)NUM2ULONG(rb_dst_offset);

    } else {
      dst_offset = 0;
    }
    if (_opt_hash != Qnil) {
      rb_event_wait_list = rb_hash_aref(_opt_hash, ID2SYM(rb_intern("event_wait_list")));
    }
    if (_opt_hash != Qnil && rb_event_wait_list != Qnil) {
      Check_Type(rb_event_wait_list, T_ARRAY);
      {
        int n;
        num_events_in_wait_list = RARRAY_LEN(rb_event_wait_list);
        event_wait_list = ALLOC_N(cl_event, num_events_in_wait_list);
        for (n=0; n<(int)num_events_in_wait_list; n++) {
          Check_Type(RARRAY_PTR(rb_event_wait_list)[n], T_DATA);
          if (CLASS_OF(RARRAY_PTR(rb_event_wait_list)[n]) != rb_cEvent)
            rb_raise(rb_eRuntimeError, "type of event_wait_list[n] is invalid: Event is expected");
          event_wait_list[n] = (cl_event)DATA_PTR(RARRAY_PTR(rb_event_wait_list)[n]);
        }
      }

    } else {
      event_wait_list = NULL;
      num_events_in_wait_list = 0;
    }
  }

  rb_command_queue = self;
  Check_Type(rb_command_queue, T_DATA);
  if (CLASS_OF(rb_command_queue) != rb_cCommandQueue)
    rb_raise(rb_eRuntimeError, "type of command_queue is invalid: CommandQueue is expected");
  command_queue = (cl_command_queue)DATA_PTR(rb_command_queue);

  rb_src_image = argv[0];
  Check_Type(rb_src_image, T_DATA);
  if (CLASS_OF(rb_src_image) != rb_cMem)
    rb_raise(rb_eRuntimeError, "type of src_image is invalid: Mem is expected");
  src_image = ((struct_mem)DATA_PTR(rb_src_image))->mem;

  rb_dst_buffer = argv[1];
  Check_Type(rb_dst_buffer, T_DATA);
  if (CLASS_OF(rb_dst_buffer) != rb_cMem)
    rb_raise(rb_eRuntimeError, "type of dst_buffer is invalid: Mem is expected");
  dst_buffer = ((struct_mem)DATA_PTR(rb_dst_buffer))->mem;




  ret = clEnqueueCopyImageToBuffer(command_queue, src_image, dst_buffer, (const size_t*)src_origin, (const size_t*)region, dst_offset, num_events_in_wait_list, (const cl_event*)event_wait_list, &event);
  check_error(ret);

  {
    rb_event = create_event(event);

    result = rb_event;
  }

  if (src_origin) xfree(src_origin);
  if (region) xfree(region);
  if (event_wait_list) xfree(event_wait_list);

  return result;
}
#endif

#ifdef CL_VERSION_1_0
/*
 *  call-seq:
 *     commandqueue.enqueue_map_buffer(buffer, blocking_map, map_flags[, opts]) -> void, event
 *
 *  opts: offset, cb, event_wait_list
 */
VALUE
rb_clEnqueueMapBuffer(int argc, VALUE *argv, VALUE self)
{
  cl_command_queue command_queue;
  cl_mem buffer;
  cl_bool blocking_map;
  cl_map_flags map_flags;
  size_t offset;
  size_t cb;
  cl_uint num_events_in_wait_list;
  cl_event *event_wait_list;
  cl_event event;
  cl_int errcode_ret;
  void *ret;
  VALUE rb_command_queue;
  VALUE rb_buffer = Qnil;
  VALUE rb_blocking_map = Qnil;
  VALUE rb_map_flags = Qnil;
  VALUE rb_offset = Qnil;
  VALUE rb_cb = Qnil;
  VALUE rb_event_wait_list = Qnil;
  VALUE rb_event = Qnil;

  VALUE result;

  if (argc > 4 || argc < 3)
    rb_raise(rb_eArgError, "wrong number of arguments (%d for 3)", argc);

  {
    VALUE _opt_hash = Qnil;

    if (argc > 3) {
      _opt_hash = argv[3];
      Check_Type(_opt_hash, T_HASH);
    }
    if (_opt_hash != Qnil) {
      rb_offset = rb_hash_aref(_opt_hash, ID2SYM(rb_intern("offset")));
    }
    if (_opt_hash != Qnil && rb_offset != Qnil) {
      offset = (size_t)NUM2ULONG(rb_offset);

    } else {
      offset = 0;
    }
    if (_opt_hash != Qnil) {
      rb_cb = rb_hash_aref(_opt_hash, ID2SYM(rb_intern("cb")));
    }
    if (_opt_hash != Qnil && rb_cb != Qnil) {
      cb = (size_t)NUM2ULONG(rb_cb);

    } else {
      cb = 0;
    }
    if (_opt_hash != Qnil) {
      rb_event_wait_list = rb_hash_aref(_opt_hash, ID2SYM(rb_intern("event_wait_list")));
    }
    if (_opt_hash != Qnil && rb_event_wait_list != Qnil) {
      Check_Type(rb_event_wait_list, T_ARRAY);
      {
        int n;
        num_events_in_wait_list = RARRAY_LEN(rb_event_wait_list);
        event_wait_list = ALLOC_N(cl_event, num_events_in_wait_list);
        for (n=0; n<(int)num_events_in_wait_list; n++) {
          Check_Type(RARRAY_PTR(rb_event_wait_list)[n], T_DATA);
          if (CLASS_OF(RARRAY_PTR(rb_event_wait_list)[n]) != rb_cEvent)
            rb_raise(rb_eRuntimeError, "type of event_wait_list[n] is invalid: Event is expected");
          event_wait_list[n] = (cl_event)DATA_PTR(RARRAY_PTR(rb_event_wait_list)[n]);
        }
      }

    } else {
      event_wait_list = NULL;
      num_events_in_wait_list = 0;
    }
  }

  rb_command_queue = self;
  Check_Type(rb_command_queue, T_DATA);
  if (CLASS_OF(rb_command_queue) != rb_cCommandQueue)
    rb_raise(rb_eRuntimeError, "type of command_queue is invalid: CommandQueue is expected");
  command_queue = (cl_command_queue)DATA_PTR(rb_command_queue);

  rb_buffer = argv[0];
  Check_Type(rb_buffer, T_DATA);
  if (CLASS_OF(rb_buffer) != rb_cMem)
    rb_raise(rb_eRuntimeError, "type of buffer is invalid: Mem is expected");
  buffer = ((struct_mem)DATA_PTR(rb_buffer))->mem;

  rb_blocking_map = argv[1];
  blocking_map = (uint32_t)NUM2UINT(rb_blocking_map);

  rb_map_flags = argv[2];
  map_flags = (uint64_t)NUM2ULONG(rb_map_flags);




  ret = clEnqueueMapBuffer(command_queue, buffer, blocking_map, map_flags, offset, cb, num_events_in_wait_list, (const cl_event*)event_wait_list, &event, &errcode_ret);
  check_error(errcode_ret);

  {
    VALUE rb_ret;
    rb_ret = rb_str_new2(ret);

    rb_event = create_event(event);

    result = rb_ary_new3(2, rb_ret, rb_event);
  }

  if (event_wait_list) xfree(event_wait_list);

  return result;
}
#endif

#ifdef CL_VERSION_1_0
/*
 *  call-seq:
 *     commandqueue.enqueue_map_image(image, blocking_map, map_flags[, opts]) -> void, image_row_pitch, image_slice_pitch, event
 *
 *  opts: origin, region, event_wait_list
 */
VALUE
rb_clEnqueueMapImage(int argc, VALUE *argv, VALUE self)
{
  cl_command_queue command_queue;
  cl_mem image;
  cl_bool blocking_map;
  cl_map_flags map_flags;
  size_t *origin;
  size_t *region;
  size_t image_row_pitch;
  size_t image_slice_pitch;
  cl_uint num_events_in_wait_list;
  cl_event *event_wait_list;
  cl_event event;
  cl_int errcode_ret;
  void *ret;
  VALUE rb_command_queue;
  VALUE rb_image = Qnil;
  VALUE rb_blocking_map = Qnil;
  VALUE rb_map_flags = Qnil;
  VALUE rb_origin = Qnil;
  VALUE rb_region = Qnil;
  VALUE rb_event_wait_list = Qnil;
  VALUE rb_image_row_pitch = Qnil;
  VALUE rb_image_slice_pitch = Qnil;
  VALUE rb_event = Qnil;

  VALUE result;

  if (argc > 4 || argc < 3)
    rb_raise(rb_eArgError, "wrong number of arguments (%d for 3)", argc);

  {
    VALUE _opt_hash = Qnil;

    if (argc > 3) {
      _opt_hash = argv[3];
      Check_Type(_opt_hash, T_HASH);
    }
    if (_opt_hash != Qnil) {
      rb_origin = rb_hash_aref(_opt_hash, ID2SYM(rb_intern("origin")));
    }
    if (_opt_hash != Qnil && rb_origin != Qnil) {
      Check_Type(rb_origin, T_ARRAY);
      {
        int n;
        if (RARRAY_LEN(rb_origin) != 3)
          rb_raise(rb_eArgError, "length of rb_#{name} is invalid");
        origin = ALLOC_N(size_t, 3);
        for (n=0; n<(int)3; n++) {
          origin[n] = (size_t)NUM2ULONG(RARRAY_PTR(rb_origin)[n]);
        }
  }

    } else {
      origin = NULL;
    }
    if (_opt_hash != Qnil) {
      rb_region = rb_hash_aref(_opt_hash, ID2SYM(rb_intern("region")));
    }
    if (_opt_hash != Qnil && rb_region != Qnil) {
      Check_Type(rb_region, T_ARRAY);
      {
        int n;
        if (RARRAY_LEN(rb_region) != 3)
          rb_raise(rb_eArgError, "length of rb_#{name} is invalid");
        region = ALLOC_N(size_t, 3);
        for (n=0; n<(int)3; n++) {
          region[n] = (size_t)NUM2ULONG(RARRAY_PTR(rb_region)[n]);
        }
  }

    } else {
      region = NULL;
    }
    if (_opt_hash != Qnil) {
      rb_event_wait_list = rb_hash_aref(_opt_hash, ID2SYM(rb_intern("event_wait_list")));
    }
    if (_opt_hash != Qnil && rb_event_wait_list != Qnil) {
      Check_Type(rb_event_wait_list, T_ARRAY);
      {
        int n;
        num_events_in_wait_list = RARRAY_LEN(rb_event_wait_list);
        event_wait_list = ALLOC_N(cl_event, num_events_in_wait_list);
        for (n=0; n<(int)num_events_in_wait_list; n++) {
          Check_Type(RARRAY_PTR(rb_event_wait_list)[n], T_DATA);
          if (CLASS_OF(RARRAY_PTR(rb_event_wait_list)[n]) != rb_cEvent)
            rb_raise(rb_eRuntimeError, "type of event_wait_list[n] is invalid: Event is expected");
          event_wait_list[n] = (cl_event)DATA_PTR(RARRAY_PTR(rb_event_wait_list)[n]);
        }
      }

    } else {
      event_wait_list = NULL;
      num_events_in_wait_list = 0;
    }
  }

  rb_command_queue = self;
  Check_Type(rb_command_queue, T_DATA);
  if (CLASS_OF(rb_command_queue) != rb_cCommandQueue)
    rb_raise(rb_eRuntimeError, "type of command_queue is invalid: CommandQueue is expected");
  command_queue = (cl_command_queue)DATA_PTR(rb_command_queue);

  rb_image = argv[0];
  Check_Type(rb_image, T_DATA);
  if (CLASS_OF(rb_image) != rb_cMem)
    rb_raise(rb_eRuntimeError, "type of image is invalid: Mem is expected");
  image = ((struct_mem)DATA_PTR(rb_image))->mem;

  rb_blocking_map = argv[1];
  blocking_map = (uint32_t)NUM2UINT(rb_blocking_map);

  rb_map_flags = argv[2];
  map_flags = (uint64_t)NUM2ULONG(rb_map_flags);




  ret = clEnqueueMapImage(command_queue, image, blocking_map, map_flags, (const size_t*)origin, (const size_t*)region, &image_row_pitch, &image_slice_pitch, num_events_in_wait_list, (const cl_event*)event_wait_list, &event, &errcode_ret);
  check_error(errcode_ret);

  {
    VALUE rb_ret;
    rb_ret = rb_str_new2(ret);

    rb_image_row_pitch = ULONG2NUM(image_row_pitch);

    rb_image_slice_pitch = ULONG2NUM(image_slice_pitch);

    rb_event = create_event(event);

    result = rb_ary_new3(4, rb_ret, rb_image_row_pitch, rb_image_slice_pitch, rb_event);
  }

  if (origin) xfree(origin);
  if (region) xfree(region);
  if (event_wait_list) xfree(event_wait_list);

  return result;
}
#endif

#ifdef CL_VERSION_1_0
/*
 *  call-seq:
 *     commandqueue.enqueue_marker() -> event
 *
 */
VALUE
rb_clEnqueueMarker(int argc, VALUE *argv, VALUE self)
{
  cl_command_queue command_queue;
  cl_event event;
  cl_int ret;
  VALUE rb_command_queue;
  VALUE rb_event = Qnil;

  VALUE result;

  if (argc > 0 || argc < 0)
    rb_raise(rb_eArgError, "wrong number of arguments (%d for 0)", argc);


  rb_command_queue = self;
  Check_Type(rb_command_queue, T_DATA);
  if (CLASS_OF(rb_command_queue) != rb_cCommandQueue)
    rb_raise(rb_eRuntimeError, "type of command_queue is invalid: CommandQueue is expected");
  command_queue = (cl_command_queue)DATA_PTR(rb_command_queue);




  ret = clEnqueueMarker(command_queue, &event);
  check_error(ret);

  {
    rb_event = create_event(event);

    result = rb_event;
  }


  return result;
}
#endif

#ifdef CL_VERSION_1_0
/*
 *  call-seq:
 *     commandqueue.enqueue_NDrange_kernel(kernel, global_work_size, local_work_size[, opts]) -> event
 *
 *  opts: event_wait_list
 */
VALUE
rb_clEnqueueNDRangeKernel(int argc, VALUE *argv, VALUE self)
{
  cl_command_queue command_queue;
  cl_kernel kernel;
  cl_uint work_dim;
  size_t *global_work_offset;
  size_t *global_work_size;
  size_t *local_work_size;
  cl_uint num_events_in_wait_list;
  cl_event *event_wait_list;
  cl_event event;
  cl_int ret;
  VALUE rb_command_queue;
  VALUE rb_kernel = Qnil;
  VALUE rb_global_work_size = Qnil;
  VALUE rb_local_work_size = Qnil;
  VALUE rb_event_wait_list = Qnil;
  VALUE rb_event = Qnil;

  VALUE result;

  if (argc > 4 || argc < 3)
    rb_raise(rb_eArgError, "wrong number of arguments (%d for 3)", argc);

  global_work_offset = NULL;
  {
    VALUE _opt_hash = Qnil;

    if (argc > 3) {
      _opt_hash = argv[3];
      Check_Type(_opt_hash, T_HASH);
    }
    if (_opt_hash != Qnil) {
      rb_event_wait_list = rb_hash_aref(_opt_hash, ID2SYM(rb_intern("event_wait_list")));
    }
    if (_opt_hash != Qnil && rb_event_wait_list != Qnil) {
      Check_Type(rb_event_wait_list, T_ARRAY);
      {
        int n;
        num_events_in_wait_list = RARRAY_LEN(rb_event_wait_list);
        event_wait_list = ALLOC_N(cl_event, num_events_in_wait_list);
        for (n=0; n<(int)num_events_in_wait_list; n++) {
          Check_Type(RARRAY_PTR(rb_event_wait_list)[n], T_DATA);
          if (CLASS_OF(RARRAY_PTR(rb_event_wait_list)[n]) != rb_cEvent)
            rb_raise(rb_eRuntimeError, "type of event_wait_list[n] is invalid: Event is expected");
          event_wait_list[n] = (cl_event)DATA_PTR(RARRAY_PTR(rb_event_wait_list)[n]);
        }
      }

    } else {
      event_wait_list = NULL;
      num_events_in_wait_list = 0;
    }
  }

  rb_command_queue = self;
  Check_Type(rb_command_queue, T_DATA);
  if (CLASS_OF(rb_command_queue) != rb_cCommandQueue)
    rb_raise(rb_eRuntimeError, "type of command_queue is invalid: CommandQueue is expected");
  command_queue = (cl_command_queue)DATA_PTR(rb_command_queue);

  rb_kernel = argv[0];
  Check_Type(rb_kernel, T_DATA);
  if (CLASS_OF(rb_kernel) != rb_cKernel)
    rb_raise(rb_eRuntimeError, "type of kernel is invalid: Kernel is expected");
  kernel = (cl_kernel)DATA_PTR(rb_kernel);

  rb_global_work_size = argv[1];
  Check_Type(rb_global_work_size, T_ARRAY);
  work_dim = RARRAY_LEN(rb_global_work_size);
  {
    int n;
    if (RARRAY_LEN(rb_global_work_size) != work_dim)
      rb_raise(rb_eArgError, "length of rb_#{name} is invalid");
    global_work_size = ALLOC_N(size_t, work_dim);
    for (n=0; n<(int)work_dim; n++) {
      global_work_size[n] = (size_t)NUM2ULONG(RARRAY_PTR(rb_global_work_size)[n]);
    }
  }

  rb_local_work_size = argv[2];
  Check_Type(rb_local_work_size, T_ARRAY);
  {
    int n;
    if (RARRAY_LEN(rb_local_work_size) != work_dim)
      rb_raise(rb_eArgError, "length of rb_#{name} is invalid");
    local_work_size = ALLOC_N(size_t, work_dim);
    for (n=0; n<(int)work_dim; n++) {
      local_work_size[n] = (size_t)NUM2ULONG(RARRAY_PTR(rb_local_work_size)[n]);
    }
  }




  ret = clEnqueueNDRangeKernel(command_queue, kernel, work_dim, (const size_t*)global_work_offset, (const size_t*)global_work_size, (const size_t*)local_work_size, num_events_in_wait_list, (const cl_event*)event_wait_list, &event);
  check_error(ret);

  {
    rb_event = create_event(event);

    result = rb_event;
  }

  if (event_wait_list) xfree(event_wait_list);
  if (global_work_size) xfree(global_work_size);
  if (local_work_size) xfree(local_work_size);

  return result;
}
#endif

#ifdef CL_VERSION_1_0
void
clEnqueueNativeKernel_user_func(void * args)
{
  if (rb_block_given_p())
    rb_yield(rb_ary_new3(1, rb_str_new2(args)));
}
/*
 *  call-seq:
 *     commandqueue.enqueue_native_kernel(args, mem_list, args_mem_loc[, opts]){ } -> event
 *
 *  opts: cb_args, event_wait_list
 */
VALUE
rb_clEnqueueNativeKernel(int argc, VALUE *argv, VALUE self)
{
  cl_command_queue command_queue;
  void *args;
  size_t cb_args;
  cl_uint num_mem_objects;
  cl_mem *mem_list;
  void **args_mem_loc;
  cl_uint num_events_in_wait_list;
  cl_event *event_wait_list;
  cl_event event;
  cl_int ret;
  VALUE rb_command_queue;
  VALUE rb_args = Qnil;
  VALUE rb_mem_list = Qnil;
  VALUE rb_args_mem_loc = Qnil;
  VALUE rb_cb_args = Qnil;
  VALUE rb_event_wait_list = Qnil;
  VALUE rb_event = Qnil;

  VALUE result;

  if (argc > 5 || argc < 3)
    rb_raise(rb_eArgError, "wrong number of arguments (%d for 3)", argc);

  {
    VALUE _opt_hash = Qnil;

    if (argc > 3) {
      _opt_hash = argv[3];
      Check_Type(_opt_hash, T_HASH);
    }
    if (_opt_hash != Qnil) {
      rb_cb_args = rb_hash_aref(_opt_hash, ID2SYM(rb_intern("cb_args")));
    }
    if (_opt_hash != Qnil && rb_cb_args != Qnil) {
      cb_args = (size_t)NUM2ULONG(rb_cb_args);

    } else {
      cb_args = 0;
    }
    if (_opt_hash != Qnil) {
      rb_event_wait_list = rb_hash_aref(_opt_hash, ID2SYM(rb_intern("event_wait_list")));
    }
    if (_opt_hash != Qnil && rb_event_wait_list != Qnil) {
      Check_Type(rb_event_wait_list, T_ARRAY);
      {
        int n;
        num_events_in_wait_list = RARRAY_LEN(rb_event_wait_list);
        event_wait_list = ALLOC_N(cl_event, num_events_in_wait_list);
        for (n=0; n<(int)num_events_in_wait_list; n++) {
          Check_Type(RARRAY_PTR(rb_event_wait_list)[n], T_DATA);
          if (CLASS_OF(RARRAY_PTR(rb_event_wait_list)[n]) != rb_cEvent)
            rb_raise(rb_eRuntimeError, "type of event_wait_list[n] is invalid: Event is expected");
          event_wait_list[n] = (cl_event)DATA_PTR(RARRAY_PTR(rb_event_wait_list)[n]);
        }
      }

    } else {
      event_wait_list = NULL;
      num_events_in_wait_list = 0;
    }
  }

  rb_command_queue = self;
  Check_Type(rb_command_queue, T_DATA);
  if (CLASS_OF(rb_command_queue) != rb_cCommandQueue)
    rb_raise(rb_eRuntimeError, "type of command_queue is invalid: CommandQueue is expected");
  command_queue = (cl_command_queue)DATA_PTR(rb_command_queue);

  rb_args = argv[0];
  args = (void*) RSTRING_PTR(rb_args);

  rb_mem_list = argv[1];
  Check_Type(rb_mem_list, T_ARRAY);
  {
    int n;
    num_mem_objects = RARRAY_LEN(rb_mem_list);
    mem_list = ALLOC_N(cl_mem, num_mem_objects);
    for (n=0; n<(int)num_mem_objects; n++) {
      Check_Type(RARRAY_PTR(rb_mem_list)[n], T_DATA);
      if (CLASS_OF(RARRAY_PTR(rb_mem_list)[n]) != rb_cMem)
        rb_raise(rb_eRuntimeError, "type of mem_list[n] is invalid: Mem is expected");
      mem_list[n] = ((struct_mem)DATA_PTR(RARRAY_PTR(rb_mem_list)[n]))->mem;
    }
  }

  rb_args_mem_loc = argv[2];
  Check_Type(rb_args_mem_loc, T_ARRAY);
  {
    int n;
    if (RARRAY_LEN(rb_args_mem_loc) != num_mem_objects)
      rb_raise(rb_eArgError, "length of rb_#{name} is invalid");
    args_mem_loc = ALLOC_N(void*, num_mem_objects);
    for (n=0; n<(int)num_mem_objects; n++) {
      args_mem_loc[n] = (void*) RSTRING_PTR(RARRAY_PTR(rb_args_mem_loc)[n]);
    }
  }




  ret = clEnqueueNativeKernel(command_queue, clEnqueueNativeKernel_user_func, args, cb_args, num_mem_objects, (const cl_mem*)mem_list, (const void**)args_mem_loc, num_events_in_wait_list, (const cl_event*)event_wait_list, &event);
  check_error(ret);

  {
    rb_event = create_event(event);

    result = rb_event;
  }

  if (event_wait_list) xfree(event_wait_list);
  if (mem_list) xfree(mem_list);
  if (args_mem_loc) xfree(args_mem_loc);

  return result;
}
#endif

#ifdef CL_VERSION_1_0
/*
 *  call-seq:
 *     commandqueue.enqueue_read_buffer(buffer, blocking_read[, opts]) -> ptr, event
 *
 *  opts: offset, cb, event_wait_list
 */
VALUE
rb_clEnqueueReadBuffer(int argc, VALUE *argv, VALUE self)
{
  cl_command_queue command_queue;
  cl_mem buffer;
  cl_bool blocking_read;
  size_t offset;
  size_t cb;
  void *ptr;
  cl_uint num_events_in_wait_list;
  cl_event *event_wait_list;
  cl_event event;
  cl_int ret;
  VALUE rb_command_queue;
  VALUE rb_buffer = Qnil;
  VALUE rb_blocking_read = Qnil;
  VALUE rb_offset = Qnil;
  VALUE rb_cb = Qnil;
  VALUE rb_event_wait_list = Qnil;
  VALUE rb_ptr = Qnil;
  VALUE rb_event = Qnil;

  VALUE result;

  if (argc > 3 || argc < 2)
    rb_raise(rb_eArgError, "wrong number of arguments (%d for 2)", argc);

  {
    VALUE _opt_hash = Qnil;

    if (argc > 2) {
      _opt_hash = argv[2];
      Check_Type(_opt_hash, T_HASH);
    }
    if (_opt_hash != Qnil) {
      rb_offset = rb_hash_aref(_opt_hash, ID2SYM(rb_intern("offset")));
    }
    if (_opt_hash != Qnil && rb_offset != Qnil) {
      offset = (size_t)NUM2ULONG(rb_offset);

    } else {
      offset = 0;
    }
    if (_opt_hash != Qnil) {
      rb_cb = rb_hash_aref(_opt_hash, ID2SYM(rb_intern("cb")));
    }
    if (_opt_hash != Qnil && rb_cb != Qnil) {
      cb = (size_t)NUM2ULONG(rb_cb);

    } else {
      cb = 0;
    }
    if (_opt_hash != Qnil) {
      rb_event_wait_list = rb_hash_aref(_opt_hash, ID2SYM(rb_intern("event_wait_list")));
    }
    if (_opt_hash != Qnil && rb_event_wait_list != Qnil) {
      Check_Type(rb_event_wait_list, T_ARRAY);
      {
        int n;
        num_events_in_wait_list = RARRAY_LEN(rb_event_wait_list);
        event_wait_list = ALLOC_N(cl_event, num_events_in_wait_list);
        for (n=0; n<(int)num_events_in_wait_list; n++) {
          Check_Type(RARRAY_PTR(rb_event_wait_list)[n], T_DATA);
          if (CLASS_OF(RARRAY_PTR(rb_event_wait_list)[n]) != rb_cEvent)
            rb_raise(rb_eRuntimeError, "type of event_wait_list[n] is invalid: Event is expected");
          event_wait_list[n] = (cl_event)DATA_PTR(RARRAY_PTR(rb_event_wait_list)[n]);
        }
      }

    } else {
      event_wait_list = NULL;
      num_events_in_wait_list = 0;
    }
  }

  rb_command_queue = self;
  Check_Type(rb_command_queue, T_DATA);
  if (CLASS_OF(rb_command_queue) != rb_cCommandQueue)
    rb_raise(rb_eRuntimeError, "type of command_queue is invalid: CommandQueue is expected");
  command_queue = (cl_command_queue)DATA_PTR(rb_command_queue);

  rb_buffer = argv[0];
  Check_Type(rb_buffer, T_DATA);
  if (CLASS_OF(rb_buffer) != rb_cMem)
    rb_raise(rb_eRuntimeError, "type of buffer is invalid: Mem is expected");
  buffer = ((struct_mem)DATA_PTR(rb_buffer))->mem;

  rb_blocking_read = argv[1];
  blocking_read = (uint32_t)NUM2UINT(rb_blocking_read);



  if (cb==0)
    check_error(clGetMemObjectInfo(buffer, CL_MEM_SIZE, sizeof(size_t), &cb, NULL));
  rb_ptr = rb_str_new(NULL, cb);
  ptr = RSTRING_PTR(rb_ptr);

  ret = clEnqueueReadBuffer(command_queue, buffer, blocking_read, offset, cb, ptr, num_events_in_wait_list, (const cl_event*)event_wait_list, &event);
  check_error(ret);

  {
    
    rb_event = create_event(event);

    result = rb_ary_new3(2, rb_ptr, rb_event);
  }

  if (event_wait_list) xfree(event_wait_list);

  return result;
}
#endif

#ifdef CL_VERSION_1_1
/*
 *  call-seq:
 *     commandqueue.enqueue_read_buffer_rect(buffer, blocking_read[, opts]) -> ptr, event
 *
 *  opts: buffer_origin, host_origin, region, buffer_row_pitch, buffer_slice_pitch, host_row_pitch, host_slice_pitch, event_wait_list
 */
VALUE
rb_clEnqueueReadBufferRect(int argc, VALUE *argv, VALUE self)
{
  cl_command_queue command_queue;
  cl_mem buffer;
  cl_bool blocking_read;
  size_t *buffer_origin;
  size_t *host_origin;
  size_t *region;
  size_t buffer_row_pitch;
  size_t buffer_slice_pitch;
  size_t host_row_pitch;
  size_t host_slice_pitch;
  void *ptr;
  cl_uint num_events_in_wait_list;
  cl_event *event_wait_list;
  cl_event event;
  cl_int ret;
  VALUE rb_command_queue;
  VALUE rb_buffer = Qnil;
  VALUE rb_blocking_read = Qnil;
  VALUE rb_buffer_origin = Qnil;
  VALUE rb_host_origin = Qnil;
  VALUE rb_region = Qnil;
  VALUE rb_buffer_row_pitch = Qnil;
  VALUE rb_buffer_slice_pitch = Qnil;
  VALUE rb_host_row_pitch = Qnil;
  VALUE rb_host_slice_pitch = Qnil;
  VALUE rb_event_wait_list = Qnil;
  VALUE rb_ptr = Qnil;
  VALUE rb_event = Qnil;

  VALUE result;

  if (argc > 3 || argc < 2)
    rb_raise(rb_eArgError, "wrong number of arguments (%d for 2)", argc);

  {
    VALUE _opt_hash = Qnil;

    if (argc > 2) {
      _opt_hash = argv[2];
      Check_Type(_opt_hash, T_HASH);
    }
    if (_opt_hash != Qnil) {
      rb_buffer_origin = rb_hash_aref(_opt_hash, ID2SYM(rb_intern("buffer_origin")));
    }
    if (_opt_hash != Qnil && rb_buffer_origin != Qnil) {
      Check_Type(rb_buffer_origin, T_ARRAY);
      {
        int n;
        if (RARRAY_LEN(rb_buffer_origin) != 3)
          rb_raise(rb_eArgError, "length of rb_#{name} is invalid");
        buffer_origin = ALLOC_N(size_t, 3);
        for (n=0; n<(int)3; n++) {
          buffer_origin[n] = (size_t)NUM2ULONG(RARRAY_PTR(rb_buffer_origin)[n]);
        }
  }

    } else {
      buffer_origin = NULL;
    }
    if (_opt_hash != Qnil) {
      rb_host_origin = rb_hash_aref(_opt_hash, ID2SYM(rb_intern("host_origin")));
    }
    if (_opt_hash != Qnil && rb_host_origin != Qnil) {
      Check_Type(rb_host_origin, T_ARRAY);
      {
        int n;
        if (RARRAY_LEN(rb_host_origin) != 3)
          rb_raise(rb_eArgError, "length of rb_#{name} is invalid");
        host_origin = ALLOC_N(size_t, 3);
        for (n=0; n<(int)3; n++) {
          host_origin[n] = (size_t)NUM2ULONG(RARRAY_PTR(rb_host_origin)[n]);
        }
  }

    } else {
      host_origin = NULL;
    }
    if (_opt_hash != Qnil) {
      rb_region = rb_hash_aref(_opt_hash, ID2SYM(rb_intern("region")));
    }
    if (_opt_hash != Qnil && rb_region != Qnil) {
      Check_Type(rb_region, T_ARRAY);
      {
        int n;
        if (RARRAY_LEN(rb_region) != 3)
          rb_raise(rb_eArgError, "length of rb_#{name} is invalid");
        region = ALLOC_N(size_t, 3);
        for (n=0; n<(int)3; n++) {
          region[n] = (size_t)NUM2ULONG(RARRAY_PTR(rb_region)[n]);
        }
  }

    } else {
      region = NULL;
    }
    if (_opt_hash != Qnil) {
      rb_buffer_row_pitch = rb_hash_aref(_opt_hash, ID2SYM(rb_intern("buffer_row_pitch")));
    }
    if (_opt_hash != Qnil && rb_buffer_row_pitch != Qnil) {
      buffer_row_pitch = (size_t)NUM2ULONG(rb_buffer_row_pitch);

    } else {
      buffer_row_pitch = 0;
    }
    if (_opt_hash != Qnil) {
      rb_buffer_slice_pitch = rb_hash_aref(_opt_hash, ID2SYM(rb_intern("buffer_slice_pitch")));
    }
    if (_opt_hash != Qnil && rb_buffer_slice_pitch != Qnil) {
      buffer_slice_pitch = (size_t)NUM2ULONG(rb_buffer_slice_pitch);

    } else {
      buffer_slice_pitch = 0;
    }
    if (_opt_hash != Qnil) {
      rb_host_row_pitch = rb_hash_aref(_opt_hash, ID2SYM(rb_intern("host_row_pitch")));
    }
    if (_opt_hash != Qnil && rb_host_row_pitch != Qnil) {
      host_row_pitch = (size_t)NUM2ULONG(rb_host_row_pitch);

    } else {
      host_row_pitch = 0;
    }
    if (_opt_hash != Qnil) {
      rb_host_slice_pitch = rb_hash_aref(_opt_hash, ID2SYM(rb_intern("host_slice_pitch")));
    }
    if (_opt_hash != Qnil && rb_host_slice_pitch != Qnil) {
      host_slice_pitch = (size_t)NUM2ULONG(rb_host_slice_pitch);

    } else {
      host_slice_pitch = 0;
    }
    if (_opt_hash != Qnil) {
      rb_event_wait_list = rb_hash_aref(_opt_hash, ID2SYM(rb_intern("event_wait_list")));
    }
    if (_opt_hash != Qnil && rb_event_wait_list != Qnil) {
      Check_Type(rb_event_wait_list, T_ARRAY);
      {
        int n;
        num_events_in_wait_list = RARRAY_LEN(rb_event_wait_list);
        event_wait_list = ALLOC_N(cl_event, num_events_in_wait_list);
        for (n=0; n<(int)num_events_in_wait_list; n++) {
          Check_Type(RARRAY_PTR(rb_event_wait_list)[n], T_DATA);
          if (CLASS_OF(RARRAY_PTR(rb_event_wait_list)[n]) != rb_cEvent)
            rb_raise(rb_eRuntimeError, "type of event_wait_list[n] is invalid: Event is expected");
          event_wait_list[n] = (cl_event)DATA_PTR(RARRAY_PTR(rb_event_wait_list)[n]);
        }
      }

    } else {
      event_wait_list = NULL;
      num_events_in_wait_list = 0;
    }
  }

  rb_command_queue = self;
  Check_Type(rb_command_queue, T_DATA);
  if (CLASS_OF(rb_command_queue) != rb_cCommandQueue)
    rb_raise(rb_eRuntimeError, "type of command_queue is invalid: CommandQueue is expected");
  command_queue = (cl_command_queue)DATA_PTR(rb_command_queue);

  rb_buffer = argv[0];
  Check_Type(rb_buffer, T_DATA);
  if (CLASS_OF(rb_buffer) != rb_cMem)
    rb_raise(rb_eRuntimeError, "type of buffer is invalid: Mem is expected");
  buffer = ((struct_mem)DATA_PTR(rb_buffer))->mem;

  rb_blocking_read = argv[1];
  blocking_read = (uint32_t)NUM2UINT(rb_blocking_read);



  int cb;
  check_error(clGetMemObjectInfo(buffer, CL_MEM_SIZE, sizeof(size_t), &cb, NULL));
  rb_ptr = rb_str_new(NULL, cb);
  ptr = RSTRING_PTR(rb_ptr);

  ret = clEnqueueReadBufferRect(command_queue, buffer, blocking_read, (const size_t*)buffer_origin, (const size_t*)host_origin, (const size_t*)region, buffer_row_pitch, buffer_slice_pitch, host_row_pitch, host_slice_pitch, ptr, num_events_in_wait_list, (const cl_event*)event_wait_list, &event);
  check_error(ret);

  {
    
    rb_event = create_event(event);

    result = rb_ary_new3(2, rb_ptr, rb_event);
  }

  if (buffer_origin) xfree(buffer_origin);
  if (host_origin) xfree(host_origin);
  if (region) xfree(region);
  if (event_wait_list) xfree(event_wait_list);

  return result;
}
#endif

#ifdef CL_VERSION_1_0
/*
 *  call-seq:
 *     commandqueue.enqueue_read_image(image, blocking_read[, opts]) -> ptr, event
 *
 *  opts: origin, region, row_pitch, slice_pitch, event_wait_list
 */
VALUE
rb_clEnqueueReadImage(int argc, VALUE *argv, VALUE self)
{
  cl_command_queue command_queue;
  cl_mem image;
  cl_bool blocking_read;
  size_t *origin;
  size_t *region;
  size_t row_pitch;
  size_t slice_pitch;
  void *ptr;
  cl_uint num_events_in_wait_list;
  cl_event *event_wait_list;
  cl_event event;
  cl_int ret;
  VALUE rb_command_queue;
  VALUE rb_image = Qnil;
  VALUE rb_blocking_read = Qnil;
  VALUE rb_origin = Qnil;
  VALUE rb_region = Qnil;
  VALUE rb_row_pitch = Qnil;
  VALUE rb_slice_pitch = Qnil;
  VALUE rb_event_wait_list = Qnil;
  VALUE rb_ptr = Qnil;
  VALUE rb_event = Qnil;

  VALUE result;

  if (argc > 3 || argc < 2)
    rb_raise(rb_eArgError, "wrong number of arguments (%d for 2)", argc);

  {
    VALUE _opt_hash = Qnil;

    if (argc > 2) {
      _opt_hash = argv[2];
      Check_Type(_opt_hash, T_HASH);
    }
    if (_opt_hash != Qnil) {
      rb_origin = rb_hash_aref(_opt_hash, ID2SYM(rb_intern("origin")));
    }
    if (_opt_hash != Qnil && rb_origin != Qnil) {
      Check_Type(rb_origin, T_ARRAY);
      {
        int n;
        if (RARRAY_LEN(rb_origin) != 3)
          rb_raise(rb_eArgError, "length of rb_#{name} is invalid");
        origin = ALLOC_N(size_t, 3);
        for (n=0; n<(int)3; n++) {
          origin[n] = (size_t)NUM2ULONG(RARRAY_PTR(rb_origin)[n]);
        }
  }

    } else {
      origin = NULL;
    }
    if (_opt_hash != Qnil) {
      rb_region = rb_hash_aref(_opt_hash, ID2SYM(rb_intern("region")));
    }
    if (_opt_hash != Qnil && rb_region != Qnil) {
      Check_Type(rb_region, T_ARRAY);
      {
        int n;
        if (RARRAY_LEN(rb_region) != 3)
          rb_raise(rb_eArgError, "length of rb_#{name} is invalid");
        region = ALLOC_N(size_t, 3);
        for (n=0; n<(int)3; n++) {
          region[n] = (size_t)NUM2ULONG(RARRAY_PTR(rb_region)[n]);
        }
  }

    } else {
      region = NULL;
    }
    if (_opt_hash != Qnil) {
      rb_row_pitch = rb_hash_aref(_opt_hash, ID2SYM(rb_intern("row_pitch")));
    }
    if (_opt_hash != Qnil && rb_row_pitch != Qnil) {
      row_pitch = (size_t)NUM2ULONG(rb_row_pitch);

    } else {
      row_pitch = 0;
    }
    if (_opt_hash != Qnil) {
      rb_slice_pitch = rb_hash_aref(_opt_hash, ID2SYM(rb_intern("slice_pitch")));
    }
    if (_opt_hash != Qnil && rb_slice_pitch != Qnil) {
      slice_pitch = (size_t)NUM2ULONG(rb_slice_pitch);

    } else {
      slice_pitch = 0;
    }
    if (_opt_hash != Qnil) {
      rb_event_wait_list = rb_hash_aref(_opt_hash, ID2SYM(rb_intern("event_wait_list")));
    }
    if (_opt_hash != Qnil && rb_event_wait_list != Qnil) {
      Check_Type(rb_event_wait_list, T_ARRAY);
      {
        int n;
        num_events_in_wait_list = RARRAY_LEN(rb_event_wait_list);
        event_wait_list = ALLOC_N(cl_event, num_events_in_wait_list);
        for (n=0; n<(int)num_events_in_wait_list; n++) {
          Check_Type(RARRAY_PTR(rb_event_wait_list)[n], T_DATA);
          if (CLASS_OF(RARRAY_PTR(rb_event_wait_list)[n]) != rb_cEvent)
            rb_raise(rb_eRuntimeError, "type of event_wait_list[n] is invalid: Event is expected");
          event_wait_list[n] = (cl_event)DATA_PTR(RARRAY_PTR(rb_event_wait_list)[n]);
        }
      }

    } else {
      event_wait_list = NULL;
      num_events_in_wait_list = 0;
    }
  }

  rb_command_queue = self;
  Check_Type(rb_command_queue, T_DATA);
  if (CLASS_OF(rb_command_queue) != rb_cCommandQueue)
    rb_raise(rb_eRuntimeError, "type of command_queue is invalid: CommandQueue is expected");
  command_queue = (cl_command_queue)DATA_PTR(rb_command_queue);

  rb_image = argv[0];
  Check_Type(rb_image, T_DATA);
  if (CLASS_OF(rb_image) != rb_cMem)
    rb_raise(rb_eRuntimeError, "type of image is invalid: Mem is expected");
  image = ((struct_mem)DATA_PTR(rb_image))->mem;

  rb_blocking_read = argv[1];
  blocking_read = (uint32_t)NUM2UINT(rb_blocking_read);



  {
    size_t size;
    if (region)
      size = region[0]*region[1]*region[2];
    else {
      size_t r;
      check_error(clGetImageInfo(image, CL_IMAGE_WIDTH, sizeof(size_t), &r, NULL));
      size = r;
      check_error(clGetImageInfo(image, CL_IMAGE_HEIGHT, sizeof(size_t), &r, NULL));
      size = size*r;
      check_error(clGetImageInfo(image, CL_IMAGE_DEPTH, sizeof(size_t), &r, NULL));
      if (r)
        size = size*r;
    }
    ptr = (void*)xmalloc(size);
  }

  ret = clEnqueueReadImage(command_queue, image, blocking_read, (const size_t*)origin, (const size_t*)region, row_pitch, slice_pitch, ptr, num_events_in_wait_list, (const cl_event*)event_wait_list, &event);
  check_error(ret);

  {
    
    rb_event = create_event(event);

    result = rb_ary_new3(2, rb_ptr, rb_event);
  }

  if (origin) xfree(origin);
  if (region) xfree(region);
  if (event_wait_list) xfree(event_wait_list);

  return result;
}
#endif

#ifdef CL_VERSION_1_0
/*
 *  call-seq:
 *     commandqueue.enqueue_task(kernel[, opts]) -> event
 *
 *  opts: event_wait_list
 */
VALUE
rb_clEnqueueTask(int argc, VALUE *argv, VALUE self)
{
  cl_command_queue command_queue;
  cl_kernel kernel;
  cl_uint num_events_in_wait_list;
  cl_event *event_wait_list;
  cl_event event;
  cl_int ret;
  VALUE rb_command_queue;
  VALUE rb_kernel = Qnil;
  VALUE rb_event_wait_list = Qnil;
  VALUE rb_event = Qnil;

  VALUE result;

  if (argc > 2 || argc < 1)
    rb_raise(rb_eArgError, "wrong number of arguments (%d for 1)", argc);

  {
    VALUE _opt_hash = Qnil;

    if (argc > 1) {
      _opt_hash = argv[1];
      Check_Type(_opt_hash, T_HASH);
    }
    if (_opt_hash != Qnil) {
      rb_event_wait_list = rb_hash_aref(_opt_hash, ID2SYM(rb_intern("event_wait_list")));
    }
    if (_opt_hash != Qnil && rb_event_wait_list != Qnil) {
      Check_Type(rb_event_wait_list, T_ARRAY);
      {
        int n;
        num_events_in_wait_list = RARRAY_LEN(rb_event_wait_list);
        event_wait_list = ALLOC_N(cl_event, num_events_in_wait_list);
        for (n=0; n<(int)num_events_in_wait_list; n++) {
          Check_Type(RARRAY_PTR(rb_event_wait_list)[n], T_DATA);
          if (CLASS_OF(RARRAY_PTR(rb_event_wait_list)[n]) != rb_cEvent)
            rb_raise(rb_eRuntimeError, "type of event_wait_list[n] is invalid: Event is expected");
          event_wait_list[n] = (cl_event)DATA_PTR(RARRAY_PTR(rb_event_wait_list)[n]);
        }
      }

    } else {
      event_wait_list = NULL;
      num_events_in_wait_list = 0;
    }
  }

  rb_command_queue = self;
  Check_Type(rb_command_queue, T_DATA);
  if (CLASS_OF(rb_command_queue) != rb_cCommandQueue)
    rb_raise(rb_eRuntimeError, "type of command_queue is invalid: CommandQueue is expected");
  command_queue = (cl_command_queue)DATA_PTR(rb_command_queue);

  rb_kernel = argv[0];
  Check_Type(rb_kernel, T_DATA);
  if (CLASS_OF(rb_kernel) != rb_cKernel)
    rb_raise(rb_eRuntimeError, "type of kernel is invalid: Kernel is expected");
  kernel = (cl_kernel)DATA_PTR(rb_kernel);




  ret = clEnqueueTask(command_queue, kernel, num_events_in_wait_list, (const cl_event*)event_wait_list, &event);
  check_error(ret);

  {
    rb_event = create_event(event);

    result = rb_event;
  }

  if (event_wait_list) xfree(event_wait_list);

  return result;
}
#endif

#ifdef CL_VERSION_1_0
/*
 *  call-seq:
 *     commandqueue.enqueue_unmap_mem_object(memobj[, opts]) -> event
 *
 *  opts: event_wait_list
 */
VALUE
rb_clEnqueueUnmapMemObject(int argc, VALUE *argv, VALUE self)
{
  cl_command_queue command_queue;
  cl_mem memobj;
  void *mapped_ptr;
  cl_uint num_events_in_wait_list;
  cl_event *event_wait_list;
  cl_event event;
  cl_int ret;
  VALUE rb_command_queue;
  VALUE rb_memobj = Qnil;
  VALUE rb_event_wait_list = Qnil;
  VALUE rb_event = Qnil;

  VALUE result;

  if (argc > 2 || argc < 1)
    rb_raise(rb_eArgError, "wrong number of arguments (%d for 1)", argc);

  mapped_ptr = NULL;
  {
    VALUE _opt_hash = Qnil;

    if (argc > 1) {
      _opt_hash = argv[1];
      Check_Type(_opt_hash, T_HASH);
    }
    if (_opt_hash != Qnil) {
      rb_event_wait_list = rb_hash_aref(_opt_hash, ID2SYM(rb_intern("event_wait_list")));
    }
    if (_opt_hash != Qnil && rb_event_wait_list != Qnil) {
      Check_Type(rb_event_wait_list, T_ARRAY);
      {
        int n;
        num_events_in_wait_list = RARRAY_LEN(rb_event_wait_list);
        event_wait_list = ALLOC_N(cl_event, num_events_in_wait_list);
        for (n=0; n<(int)num_events_in_wait_list; n++) {
          Check_Type(RARRAY_PTR(rb_event_wait_list)[n], T_DATA);
          if (CLASS_OF(RARRAY_PTR(rb_event_wait_list)[n]) != rb_cEvent)
            rb_raise(rb_eRuntimeError, "type of event_wait_list[n] is invalid: Event is expected");
          event_wait_list[n] = (cl_event)DATA_PTR(RARRAY_PTR(rb_event_wait_list)[n]);
        }
      }

    } else {
      event_wait_list = NULL;
      num_events_in_wait_list = 0;
    }
  }

  rb_command_queue = self;
  Check_Type(rb_command_queue, T_DATA);
  if (CLASS_OF(rb_command_queue) != rb_cCommandQueue)
    rb_raise(rb_eRuntimeError, "type of command_queue is invalid: CommandQueue is expected");
  command_queue = (cl_command_queue)DATA_PTR(rb_command_queue);

  rb_memobj = argv[0];
  Check_Type(rb_memobj, T_DATA);
  if (CLASS_OF(rb_memobj) != rb_cMem)
    rb_raise(rb_eRuntimeError, "type of memobj is invalid: Mem is expected");
  memobj = ((struct_mem)DATA_PTR(rb_memobj))->mem;




  ret = clEnqueueUnmapMemObject(command_queue, memobj, mapped_ptr, num_events_in_wait_list, (const cl_event*)event_wait_list, &event);
  check_error(ret);

  {
    rb_event = create_event(event);

    result = rb_event;
  }

  if (event_wait_list) xfree(event_wait_list);

  return result;
}
#endif

#ifdef CL_VERSION_1_0
/*
 *  call-seq:
 *     commandqueue.enqueue_wait_for_events(event_list) -> nil
 *
 */
VALUE
rb_clEnqueueWaitForEvents(int argc, VALUE *argv, VALUE self)
{
  cl_command_queue command_queue;
  cl_uint num_events;
  cl_event *event_list;
  cl_int ret;
  VALUE rb_command_queue;
  VALUE rb_event_list = Qnil;

  VALUE result;

  if (argc > 1 || argc < 1)
    rb_raise(rb_eArgError, "wrong number of arguments (%d for 1)", argc);


  rb_command_queue = self;
  Check_Type(rb_command_queue, T_DATA);
  if (CLASS_OF(rb_command_queue) != rb_cCommandQueue)
    rb_raise(rb_eRuntimeError, "type of command_queue is invalid: CommandQueue is expected");
  command_queue = (cl_command_queue)DATA_PTR(rb_command_queue);

  rb_event_list = argv[0];
  Check_Type(rb_event_list, T_ARRAY);
  {
    int n;
    num_events = RARRAY_LEN(rb_event_list);
    event_list = ALLOC_N(cl_event, num_events);
    for (n=0; n<(int)num_events; n++) {
      Check_Type(RARRAY_PTR(rb_event_list)[n], T_DATA);
      if (CLASS_OF(RARRAY_PTR(rb_event_list)[n]) != rb_cEvent)
        rb_raise(rb_eRuntimeError, "type of event_list[n] is invalid: Event is expected");
      event_list[n] = (cl_event)DATA_PTR(RARRAY_PTR(rb_event_list)[n]);
    }
  }




  ret = clEnqueueWaitForEvents(command_queue, num_events, (const cl_event*)event_list);
  check_error(ret);

  {
    result = Qnil;
  }

  if (event_list) xfree(event_list);

  return result;
}
#endif

#ifdef CL_VERSION_1_0
/*
 *  call-seq:
 *     commandqueue.enqueue_write_buffer(buffer, blocking_write, ptr[, opts]) -> event
 *
 *  opts: offset, cb, event_wait_list
 */
VALUE
rb_clEnqueueWriteBuffer(int argc, VALUE *argv, VALUE self)
{
  cl_command_queue command_queue;
  cl_mem buffer;
  cl_bool blocking_write;
  size_t offset;
  size_t cb;
  void *ptr;
  cl_uint num_events_in_wait_list;
  cl_event *event_wait_list;
  cl_event event;
  cl_int ret;
  VALUE rb_command_queue;
  VALUE rb_buffer = Qnil;
  VALUE rb_blocking_write = Qnil;
  VALUE rb_ptr = Qnil;
  VALUE rb_offset = Qnil;
  VALUE rb_cb = Qnil;
  VALUE rb_event_wait_list = Qnil;
  VALUE rb_event = Qnil;

  VALUE result;

  if (argc > 4 || argc < 3)
    rb_raise(rb_eArgError, "wrong number of arguments (%d for 3)", argc);

  {
    VALUE _opt_hash = Qnil;

    if (argc > 3) {
      _opt_hash = argv[3];
      Check_Type(_opt_hash, T_HASH);
    }
    if (_opt_hash != Qnil) {
      rb_offset = rb_hash_aref(_opt_hash, ID2SYM(rb_intern("offset")));
    }
    if (_opt_hash != Qnil && rb_offset != Qnil) {
      offset = (size_t)NUM2ULONG(rb_offset);

    } else {
      offset = 0;
    }
    if (_opt_hash != Qnil) {
      rb_cb = rb_hash_aref(_opt_hash, ID2SYM(rb_intern("cb")));
    }
    if (_opt_hash != Qnil && rb_cb != Qnil) {
      cb = (size_t)NUM2ULONG(rb_cb);

    } else {
      cb = 0;
    }
    if (_opt_hash != Qnil) {
      rb_event_wait_list = rb_hash_aref(_opt_hash, ID2SYM(rb_intern("event_wait_list")));
    }
    if (_opt_hash != Qnil && rb_event_wait_list != Qnil) {
      Check_Type(rb_event_wait_list, T_ARRAY);
      {
        int n;
        num_events_in_wait_list = RARRAY_LEN(rb_event_wait_list);
        event_wait_list = ALLOC_N(cl_event, num_events_in_wait_list);
        for (n=0; n<(int)num_events_in_wait_list; n++) {
          Check_Type(RARRAY_PTR(rb_event_wait_list)[n], T_DATA);
          if (CLASS_OF(RARRAY_PTR(rb_event_wait_list)[n]) != rb_cEvent)
            rb_raise(rb_eRuntimeError, "type of event_wait_list[n] is invalid: Event is expected");
          event_wait_list[n] = (cl_event)DATA_PTR(RARRAY_PTR(rb_event_wait_list)[n]);
        }
      }

    } else {
      event_wait_list = NULL;
      num_events_in_wait_list = 0;
    }
  }

  rb_command_queue = self;
  Check_Type(rb_command_queue, T_DATA);
  if (CLASS_OF(rb_command_queue) != rb_cCommandQueue)
    rb_raise(rb_eRuntimeError, "type of command_queue is invalid: CommandQueue is expected");
  command_queue = (cl_command_queue)DATA_PTR(rb_command_queue);

  rb_buffer = argv[0];
  Check_Type(rb_buffer, T_DATA);
  if (CLASS_OF(rb_buffer) != rb_cMem)
    rb_raise(rb_eRuntimeError, "type of buffer is invalid: Mem is expected");
  buffer = ((struct_mem)DATA_PTR(rb_buffer))->mem;

  rb_blocking_write = argv[1];
  blocking_write = (uint32_t)NUM2UINT(rb_blocking_write);

  rb_ptr = argv[2];
  if (TYPE(rb_ptr) == T_STRING) {
    char *c = RSTRING_PTR(rb_ptr);
    ptr = (void*)&c;
    cb = RSTRING_LEN(rb_ptr);
  } else if (CLASS_OF(rb_ptr) == rb_cVArray) {
    struct_varray *s_vary;
    Data_Get_Struct(rb_ptr, struct_varray, s_vary);
    char *c = s_vary->ptr;
    ptr = (void*)c;
    cb = s_vary->size*s_vary->length;
  } else
    rb_raise(rb_eArgError, "wrong type of the argument");




  ret = clEnqueueWriteBuffer(command_queue, buffer, blocking_write, offset, cb, (const void*)ptr, num_events_in_wait_list, (const cl_event*)event_wait_list, &event);
  check_error(ret);

  {
    rb_event = create_event(event);

    result = rb_event;
  }

  if (event_wait_list) xfree(event_wait_list);

  return result;
}
#endif

#ifdef CL_VERSION_1_1
/*
 *  call-seq:
 *     commandqueue.enqueue_write_buffer_rect(buffer, blocking_write, ptr[, opts]) -> event
 *
 *  opts: buffer_origin, host_origin, region, buffer_row_pitch, buffer_slice_pitch, host_row_pitch, host_slice_pitch, event_wait_list
 */
VALUE
rb_clEnqueueWriteBufferRect(int argc, VALUE *argv, VALUE self)
{
  cl_command_queue command_queue;
  cl_mem buffer;
  cl_bool blocking_write;
  size_t *buffer_origin;
  size_t *host_origin;
  size_t *region;
  size_t buffer_row_pitch;
  size_t buffer_slice_pitch;
  size_t host_row_pitch;
  size_t host_slice_pitch;
  void *ptr;
  cl_uint num_events_in_wait_list;
  cl_event *event_wait_list;
  cl_event event;
  cl_int ret;
  VALUE rb_command_queue;
  VALUE rb_buffer = Qnil;
  VALUE rb_blocking_write = Qnil;
  VALUE rb_ptr = Qnil;
  VALUE rb_buffer_origin = Qnil;
  VALUE rb_host_origin = Qnil;
  VALUE rb_region = Qnil;
  VALUE rb_buffer_row_pitch = Qnil;
  VALUE rb_buffer_slice_pitch = Qnil;
  VALUE rb_host_row_pitch = Qnil;
  VALUE rb_host_slice_pitch = Qnil;
  VALUE rb_event_wait_list = Qnil;
  VALUE rb_event = Qnil;

  VALUE result;

  if (argc > 4 || argc < 3)
    rb_raise(rb_eArgError, "wrong number of arguments (%d for 3)", argc);

  {
    VALUE _opt_hash = Qnil;

    if (argc > 3) {
      _opt_hash = argv[3];
      Check_Type(_opt_hash, T_HASH);
    }
    if (_opt_hash != Qnil) {
      rb_buffer_origin = rb_hash_aref(_opt_hash, ID2SYM(rb_intern("buffer_origin")));
    }
    if (_opt_hash != Qnil && rb_buffer_origin != Qnil) {
      Check_Type(rb_buffer_origin, T_ARRAY);
      {
        int n;
        if (RARRAY_LEN(rb_buffer_origin) != 3)
          rb_raise(rb_eArgError, "length of rb_#{name} is invalid");
        buffer_origin = ALLOC_N(size_t, 3);
        for (n=0; n<(int)3; n++) {
          buffer_origin[n] = (size_t)NUM2ULONG(RARRAY_PTR(rb_buffer_origin)[n]);
        }
  }

    } else {
      buffer_origin = NULL;
    }
    if (_opt_hash != Qnil) {
      rb_host_origin = rb_hash_aref(_opt_hash, ID2SYM(rb_intern("host_origin")));
    }
    if (_opt_hash != Qnil && rb_host_origin != Qnil) {
      Check_Type(rb_host_origin, T_ARRAY);
      {
        int n;
        if (RARRAY_LEN(rb_host_origin) != 3)
          rb_raise(rb_eArgError, "length of rb_#{name} is invalid");
        host_origin = ALLOC_N(size_t, 3);
        for (n=0; n<(int)3; n++) {
          host_origin[n] = (size_t)NUM2ULONG(RARRAY_PTR(rb_host_origin)[n]);
        }
  }

    } else {
      host_origin = NULL;
    }
    if (_opt_hash != Qnil) {
      rb_region = rb_hash_aref(_opt_hash, ID2SYM(rb_intern("region")));
    }
    if (_opt_hash != Qnil && rb_region != Qnil) {
      Check_Type(rb_region, T_ARRAY);
      {
        int n;
        if (RARRAY_LEN(rb_region) != 3)
          rb_raise(rb_eArgError, "length of rb_#{name} is invalid");
        region = ALLOC_N(size_t, 3);
        for (n=0; n<(int)3; n++) {
          region[n] = (size_t)NUM2ULONG(RARRAY_PTR(rb_region)[n]);
        }
  }

    } else {
      region = NULL;
    }
    if (_opt_hash != Qnil) {
      rb_buffer_row_pitch = rb_hash_aref(_opt_hash, ID2SYM(rb_intern("buffer_row_pitch")));
    }
    if (_opt_hash != Qnil && rb_buffer_row_pitch != Qnil) {
      buffer_row_pitch = (size_t)NUM2ULONG(rb_buffer_row_pitch);

    } else {
      buffer_row_pitch = 0;
    }
    if (_opt_hash != Qnil) {
      rb_buffer_slice_pitch = rb_hash_aref(_opt_hash, ID2SYM(rb_intern("buffer_slice_pitch")));
    }
    if (_opt_hash != Qnil && rb_buffer_slice_pitch != Qnil) {
      buffer_slice_pitch = (size_t)NUM2ULONG(rb_buffer_slice_pitch);

    } else {
      buffer_slice_pitch = 0;
    }
    if (_opt_hash != Qnil) {
      rb_host_row_pitch = rb_hash_aref(_opt_hash, ID2SYM(rb_intern("host_row_pitch")));
    }
    if (_opt_hash != Qnil && rb_host_row_pitch != Qnil) {
      host_row_pitch = (size_t)NUM2ULONG(rb_host_row_pitch);

    } else {
      host_row_pitch = 0;
    }
    if (_opt_hash != Qnil) {
      rb_host_slice_pitch = rb_hash_aref(_opt_hash, ID2SYM(rb_intern("host_slice_pitch")));
    }
    if (_opt_hash != Qnil && rb_host_slice_pitch != Qnil) {
      host_slice_pitch = (size_t)NUM2ULONG(rb_host_slice_pitch);

    } else {
      host_slice_pitch = 0;
    }
    if (_opt_hash != Qnil) {
      rb_event_wait_list = rb_hash_aref(_opt_hash, ID2SYM(rb_intern("event_wait_list")));
    }
    if (_opt_hash != Qnil && rb_event_wait_list != Qnil) {
      Check_Type(rb_event_wait_list, T_ARRAY);
      {
        int n;
        num_events_in_wait_list = RARRAY_LEN(rb_event_wait_list);
        event_wait_list = ALLOC_N(cl_event, num_events_in_wait_list);
        for (n=0; n<(int)num_events_in_wait_list; n++) {
          Check_Type(RARRAY_PTR(rb_event_wait_list)[n], T_DATA);
          if (CLASS_OF(RARRAY_PTR(rb_event_wait_list)[n]) != rb_cEvent)
            rb_raise(rb_eRuntimeError, "type of event_wait_list[n] is invalid: Event is expected");
          event_wait_list[n] = (cl_event)DATA_PTR(RARRAY_PTR(rb_event_wait_list)[n]);
        }
      }

    } else {
      event_wait_list = NULL;
      num_events_in_wait_list = 0;
    }
  }

  rb_command_queue = self;
  Check_Type(rb_command_queue, T_DATA);
  if (CLASS_OF(rb_command_queue) != rb_cCommandQueue)
    rb_raise(rb_eRuntimeError, "type of command_queue is invalid: CommandQueue is expected");
  command_queue = (cl_command_queue)DATA_PTR(rb_command_queue);

  rb_buffer = argv[0];
  Check_Type(rb_buffer, T_DATA);
  if (CLASS_OF(rb_buffer) != rb_cMem)
    rb_raise(rb_eRuntimeError, "type of buffer is invalid: Mem is expected");
  buffer = ((struct_mem)DATA_PTR(rb_buffer))->mem;

  rb_blocking_write = argv[1];
  blocking_write = (uint32_t)NUM2UINT(rb_blocking_write);

  rb_ptr = argv[2];
  if (TYPE(rb_ptr) == T_STRING) {
    char *c = RSTRING_PTR(rb_ptr);
    ptr = (void*)&c;
  } else if (CLASS_OF(rb_ptr) == rb_cVArray) {
    struct_varray *s_vary;
    Data_Get_Struct(rb_ptr, struct_varray, s_vary);
    char *c = s_vary->ptr;
    ptr = (void*)c;
  } else
    rb_raise(rb_eArgError, "wrong type of the argument");




  ret = clEnqueueWriteBufferRect(command_queue, buffer, blocking_write, (const size_t*)buffer_origin, (const size_t*)host_origin, (const size_t*)region, buffer_row_pitch, buffer_slice_pitch, host_row_pitch, host_slice_pitch, (const void*)ptr, num_events_in_wait_list, (const cl_event*)event_wait_list, &event);
  check_error(ret);

  {
    rb_event = create_event(event);

    result = rb_event;
  }

  if (buffer_origin) xfree(buffer_origin);
  if (host_origin) xfree(host_origin);
  if (region) xfree(region);
  if (event_wait_list) xfree(event_wait_list);

  return result;
}
#endif

#ifdef CL_VERSION_1_0
/*
 *  call-seq:
 *     commandqueue.enqueue_write_image(image, blocking_write, ptr[, opts]) -> event
 *
 *  opts: origin, region, input_row_pitch, input_slice_pitch, event_wait_list
 */
VALUE
rb_clEnqueueWriteImage(int argc, VALUE *argv, VALUE self)
{
  cl_command_queue command_queue;
  cl_mem image;
  cl_bool blocking_write;
  size_t *origin;
  size_t *region;
  size_t input_row_pitch;
  size_t input_slice_pitch;
  void *ptr;
  cl_uint num_events_in_wait_list;
  cl_event *event_wait_list;
  cl_event event;
  cl_int ret;
  VALUE rb_command_queue;
  VALUE rb_image = Qnil;
  VALUE rb_blocking_write = Qnil;
  VALUE rb_ptr = Qnil;
  VALUE rb_origin = Qnil;
  VALUE rb_region = Qnil;
  VALUE rb_input_row_pitch = Qnil;
  VALUE rb_input_slice_pitch = Qnil;
  VALUE rb_event_wait_list = Qnil;
  VALUE rb_event = Qnil;

  VALUE result;

  if (argc > 4 || argc < 3)
    rb_raise(rb_eArgError, "wrong number of arguments (%d for 3)", argc);

  {
    VALUE _opt_hash = Qnil;

    if (argc > 3) {
      _opt_hash = argv[3];
      Check_Type(_opt_hash, T_HASH);
    }
    if (_opt_hash != Qnil) {
      rb_origin = rb_hash_aref(_opt_hash, ID2SYM(rb_intern("origin")));
    }
    if (_opt_hash != Qnil && rb_origin != Qnil) {
      Check_Type(rb_origin, T_ARRAY);
      {
        int n;
        if (RARRAY_LEN(rb_origin) != 3)
          rb_raise(rb_eArgError, "length of rb_#{name} is invalid");
        origin = ALLOC_N(size_t, 3);
        for (n=0; n<(int)3; n++) {
          origin[n] = (size_t)NUM2ULONG(RARRAY_PTR(rb_origin)[n]);
        }
  }

    } else {
      origin = NULL;
    }
    if (_opt_hash != Qnil) {
      rb_region = rb_hash_aref(_opt_hash, ID2SYM(rb_intern("region")));
    }
    if (_opt_hash != Qnil && rb_region != Qnil) {
      Check_Type(rb_region, T_ARRAY);
      {
        int n;
        if (RARRAY_LEN(rb_region) != 3)
          rb_raise(rb_eArgError, "length of rb_#{name} is invalid");
        region = ALLOC_N(size_t, 3);
        for (n=0; n<(int)3; n++) {
          region[n] = (size_t)NUM2ULONG(RARRAY_PTR(rb_region)[n]);
        }
  }

    } else {
      region = NULL;
    }
    if (_opt_hash != Qnil) {
      rb_input_row_pitch = rb_hash_aref(_opt_hash, ID2SYM(rb_intern("input_row_pitch")));
    }
    if (_opt_hash != Qnil && rb_input_row_pitch != Qnil) {
      input_row_pitch = (size_t)NUM2ULONG(rb_input_row_pitch);

    } else {
      input_row_pitch = 0;
    }
    if (_opt_hash != Qnil) {
      rb_input_slice_pitch = rb_hash_aref(_opt_hash, ID2SYM(rb_intern("input_slice_pitch")));
    }
    if (_opt_hash != Qnil && rb_input_slice_pitch != Qnil) {
      input_slice_pitch = (size_t)NUM2ULONG(rb_input_slice_pitch);

    } else {
      input_slice_pitch = 0;
    }
    if (_opt_hash != Qnil) {
      rb_event_wait_list = rb_hash_aref(_opt_hash, ID2SYM(rb_intern("event_wait_list")));
    }
    if (_opt_hash != Qnil && rb_event_wait_list != Qnil) {
      Check_Type(rb_event_wait_list, T_ARRAY);
      {
        int n;
        num_events_in_wait_list = RARRAY_LEN(rb_event_wait_list);
        event_wait_list = ALLOC_N(cl_event, num_events_in_wait_list);
        for (n=0; n<(int)num_events_in_wait_list; n++) {
          Check_Type(RARRAY_PTR(rb_event_wait_list)[n], T_DATA);
          if (CLASS_OF(RARRAY_PTR(rb_event_wait_list)[n]) != rb_cEvent)
            rb_raise(rb_eRuntimeError, "type of event_wait_list[n] is invalid: Event is expected");
          event_wait_list[n] = (cl_event)DATA_PTR(RARRAY_PTR(rb_event_wait_list)[n]);
        }
      }

    } else {
      event_wait_list = NULL;
      num_events_in_wait_list = 0;
    }
  }

  rb_command_queue = self;
  Check_Type(rb_command_queue, T_DATA);
  if (CLASS_OF(rb_command_queue) != rb_cCommandQueue)
    rb_raise(rb_eRuntimeError, "type of command_queue is invalid: CommandQueue is expected");
  command_queue = (cl_command_queue)DATA_PTR(rb_command_queue);

  rb_image = argv[0];
  Check_Type(rb_image, T_DATA);
  if (CLASS_OF(rb_image) != rb_cMem)
    rb_raise(rb_eRuntimeError, "type of image is invalid: Mem is expected");
  image = ((struct_mem)DATA_PTR(rb_image))->mem;

  rb_blocking_write = argv[1];
  blocking_write = (uint32_t)NUM2UINT(rb_blocking_write);

  rb_ptr = argv[2];
  if (TYPE(rb_ptr) == T_STRING) {
    char *c = RSTRING_PTR(rb_ptr);
    ptr = (void*)&c;
  } else if (CLASS_OF(rb_ptr) == rb_cVArray) {
    struct_varray *s_vary;
    Data_Get_Struct(rb_ptr, struct_varray, s_vary);
    char *c = s_vary->ptr;
    ptr = (void*)c;
  } else
    rb_raise(rb_eArgError, "wrong type of the argument");




  ret = clEnqueueWriteImage(command_queue, image, blocking_write, (const size_t*)origin, (const size_t*)region, input_row_pitch, input_slice_pitch, (const void*)ptr, num_events_in_wait_list, (const cl_event*)event_wait_list, &event);
  check_error(ret);

  {
    rb_event = create_event(event);

    result = rb_event;
  }

  if (origin) xfree(origin);
  if (region) xfree(region);
  if (event_wait_list) xfree(event_wait_list);

  return result;
}
#endif

#ifdef CL_VERSION_1_0
/*
 *  call-seq:
 *     commandqueue.finish() -> nil
 *
 */
VALUE
rb_clFinish(int argc, VALUE *argv, VALUE self)
{
  cl_command_queue command_queue;
  cl_int ret;
  VALUE rb_command_queue;

  VALUE result;

  if (argc > 0 || argc < 0)
    rb_raise(rb_eArgError, "wrong number of arguments (%d for 0)", argc);


  rb_command_queue = self;
  Check_Type(rb_command_queue, T_DATA);
  if (CLASS_OF(rb_command_queue) != rb_cCommandQueue)
    rb_raise(rb_eRuntimeError, "type of command_queue is invalid: CommandQueue is expected");
  command_queue = (cl_command_queue)DATA_PTR(rb_command_queue);




  ret = clFinish(command_queue);
  check_error(ret);

  {
    result = Qnil;
  }


  return result;
}
#endif

#ifdef CL_VERSION_1_0
/*
 *  call-seq:
 *     commandqueue.flush() -> nil
 *
 */
VALUE
rb_clFlush(int argc, VALUE *argv, VALUE self)
{
  cl_command_queue command_queue;
  cl_int ret;
  VALUE rb_command_queue;

  VALUE result;

  if (argc > 0 || argc < 0)
    rb_raise(rb_eArgError, "wrong number of arguments (%d for 0)", argc);


  rb_command_queue = self;
  Check_Type(rb_command_queue, T_DATA);
  if (CLASS_OF(rb_command_queue) != rb_cCommandQueue)
    rb_raise(rb_eRuntimeError, "type of command_queue is invalid: CommandQueue is expected");
  command_queue = (cl_command_queue)DATA_PTR(rb_command_queue);




  ret = clFlush(command_queue);
  check_error(ret);

  {
    result = Qnil;
  }


  return result;
}
#endif

#ifdef CL_VERSION_1_0
/*
 *  call-seq:
 *     commandqueue.get_info(param_name) -> param_value
 *
 */
VALUE
rb_clGetCommandQueueInfo(int argc, VALUE *argv, VALUE self)
{
  cl_command_queue command_queue;
  cl_command_queue_info param_name;
  size_t param_value_size;
  void *param_value;
  size_t param_value_size_ret;
  cl_int ret;
  VALUE rb_command_queue;
  VALUE rb_param_name = Qnil;
  VALUE rb_param_value = Qnil;

  VALUE result;

  if (argc > 1 || argc < 1)
    rb_raise(rb_eArgError, "wrong number of arguments (%d for 1)", argc);


  rb_command_queue = self;
  Check_Type(rb_command_queue, T_DATA);
  if (CLASS_OF(rb_command_queue) != rb_cCommandQueue)
    rb_raise(rb_eRuntimeError, "type of command_queue is invalid: CommandQueue is expected");
  command_queue = (cl_command_queue)DATA_PTR(rb_command_queue);

  rb_param_name = argv[0];
  param_name = (uint32_t)NUM2UINT(rb_param_name);



  ret = clGetCommandQueueInfo(command_queue, param_name, 0, NULL, &param_value_size_ret);
  param_value_size = param_value_size_ret;
  check_error(ret);
  param_value = (void*) xmalloc(param_value_size);

  ret = clGetCommandQueueInfo(command_queue, param_name, param_value_size, param_value, NULL);
  check_error(ret);

  {
    rb_param_value = rb_str_new(param_value, param_value_size);

    result = rb_param_value;
  }


  return result;
}
#endif

#ifdef CL_VERSION_1_0
/*
 *  call-seq:
 *     context.get_info(param_name) -> param_value
 *
 */
VALUE
rb_clGetContextInfo(int argc, VALUE *argv, VALUE self)
{
  cl_context context;
  cl_context_info param_name;
  size_t param_value_size;
  void *param_value;
  size_t param_value_size_ret;
  cl_int ret;
  VALUE rb_context;
  VALUE rb_param_name = Qnil;
  VALUE rb_param_value = Qnil;

  VALUE result;

  if (argc > 1 || argc < 1)
    rb_raise(rb_eArgError, "wrong number of arguments (%d for 1)", argc);


  rb_context = self;
  Check_Type(rb_context, T_DATA);
  if (CLASS_OF(rb_context) != rb_cContext)
    rb_raise(rb_eRuntimeError, "type of context is invalid: Context is expected");
  context = (cl_context)DATA_PTR(rb_context);

  rb_param_name = argv[0];
  param_name = (uint32_t)NUM2UINT(rb_param_name);



  ret = clGetContextInfo(context, param_name, 0, NULL, &param_value_size_ret);
  param_value_size = param_value_size_ret;
  check_error(ret);
  param_value = (void*) xmalloc(param_value_size);

  ret = clGetContextInfo(context, param_name, param_value_size, param_value, NULL);
  check_error(ret);

  {
    rb_param_value = rb_str_new(param_value, param_value_size);

    result = rb_param_value;
  }


  return result;
}
#endif

#ifdef CL_VERSION_1_0
/*
 *  call-seq:
 *     Device.get_devices(platform, device_type) -> devices
 *
 */
VALUE
rb_clGetDeviceIDs(int argc, VALUE *argv, VALUE self)
{
  cl_platform_id platform;
  cl_device_type device_type;
  cl_uint num_entries;
  cl_device_id *devices;
  cl_uint num_devices;
  cl_int ret;
  VALUE rb_platform = Qnil;
  VALUE rb_device_type = Qnil;
  VALUE rb_devices = Qnil;

  VALUE result;

  if (argc > 2 || argc < 2)
    rb_raise(rb_eArgError, "wrong number of arguments (%d for 2)", argc);


  rb_platform = argv[0];
  Check_Type(rb_platform, T_DATA);
  if (CLASS_OF(rb_platform) != rb_cPlatform)
    rb_raise(rb_eRuntimeError, "type of platform is invalid: Platform is expected");
  platform = (cl_platform_id)DATA_PTR(rb_platform);

  rb_device_type = argv[1];
  device_type = (uint64_t)NUM2ULONG(rb_device_type);



  ret = clGetDeviceIDs(platform, device_type, 0, NULL, &num_devices);
  num_entries = num_devices;
  check_error(ret);
  devices = ALLOC_N(cl_device_id, num_entries);

  ret = clGetDeviceIDs(platform, device_type, num_entries, devices, NULL);
  check_error(ret);

  {
    {
      VALUE ary[num_entries];
      int ii;
      for (ii=0; ii<(int)num_entries; ii++)
        ary[ii] = create_device(devices[ii]);
      rb_devices = rb_ary_new4(num_entries, ary);
    }

    result = rb_devices;
  }


  return result;
}
#endif

#ifdef CL_VERSION_1_0
/*
 *  call-seq:
 *     device.get_info(param_name) -> param_value
 *
 */
VALUE
rb_clGetDeviceInfo(int argc, VALUE *argv, VALUE self)
{
  cl_device_id device;
  cl_device_info param_name;
  size_t param_value_size;
  void *param_value;
  size_t param_value_size_ret;
  cl_int ret;
  VALUE rb_device;
  VALUE rb_param_name = Qnil;
  VALUE rb_param_value = Qnil;

  VALUE result;

  if (argc > 1 || argc < 1)
    rb_raise(rb_eArgError, "wrong number of arguments (%d for 1)", argc);


  rb_device = self;
  Check_Type(rb_device, T_DATA);
  if (CLASS_OF(rb_device) != rb_cDevice)
    rb_raise(rb_eRuntimeError, "type of device is invalid: Device is expected");
  device = (cl_device_id)DATA_PTR(rb_device);

  rb_param_name = argv[0];
  param_name = (uint32_t)NUM2UINT(rb_param_name);



  ret = clGetDeviceInfo(device, param_name, 0, NULL, &param_value_size_ret);
  param_value_size = param_value_size_ret;
  check_error(ret);
  param_value = (void*) xmalloc(param_value_size);

  ret = clGetDeviceInfo(device, param_name, param_value_size, param_value, NULL);
  check_error(ret);

  {
    rb_param_value = rb_str_new(param_value, param_value_size);

    result = rb_param_value;
  }


  return result;
}
#endif

#ifdef CL_VERSION_1_0
/*
 *  call-seq:
 *     event.get_info(param_name) -> param_value
 *
 */
VALUE
rb_clGetEventInfo(int argc, VALUE *argv, VALUE self)
{
  cl_event event;
  cl_event_info param_name;
  size_t param_value_size;
  void *param_value;
  size_t param_value_size_ret;
  cl_int ret;
  VALUE rb_event;
  VALUE rb_param_name = Qnil;
  VALUE rb_param_value = Qnil;

  VALUE result;

  if (argc > 1 || argc < 1)
    rb_raise(rb_eArgError, "wrong number of arguments (%d for 1)", argc);


  rb_event = self;
  Check_Type(rb_event, T_DATA);
  if (CLASS_OF(rb_event) != rb_cEvent)
    rb_raise(rb_eRuntimeError, "type of event is invalid: Event is expected");
  event = (cl_event)DATA_PTR(rb_event);

  rb_param_name = argv[0];
  param_name = (uint32_t)NUM2UINT(rb_param_name);



  ret = clGetEventInfo(event, param_name, 0, NULL, &param_value_size_ret);
  param_value_size = param_value_size_ret;
  check_error(ret);
  param_value = (void*) xmalloc(param_value_size);

  ret = clGetEventInfo(event, param_name, param_value_size, param_value, NULL);
  check_error(ret);

  {
    rb_param_value = rb_str_new(param_value, param_value_size);

    result = rb_param_value;
  }


  return result;
}
#endif

#ifdef CL_VERSION_1_0
/*
 *  call-seq:
 *     event.get_profiling_info(param_name) -> param_value
 *
 */
VALUE
rb_clGetEventProfilingInfo(int argc, VALUE *argv, VALUE self)
{
  cl_event event;
  cl_profiling_info param_name;
  size_t param_value_size;
  void *param_value;
  size_t param_value_size_ret;
  cl_int ret;
  VALUE rb_event;
  VALUE rb_param_name = Qnil;
  VALUE rb_param_value = Qnil;

  VALUE result;

  if (argc > 1 || argc < 1)
    rb_raise(rb_eArgError, "wrong number of arguments (%d for 1)", argc);


  rb_event = self;
  Check_Type(rb_event, T_DATA);
  if (CLASS_OF(rb_event) != rb_cEvent)
    rb_raise(rb_eRuntimeError, "type of event is invalid: Event is expected");
  event = (cl_event)DATA_PTR(rb_event);

  rb_param_name = argv[0];
  param_name = (uint32_t)NUM2UINT(rb_param_name);



  ret = clGetEventProfilingInfo(event, param_name, 0, NULL, &param_value_size_ret);
  param_value_size = param_value_size_ret;
  check_error(ret);
  param_value = (void*) xmalloc(param_value_size);

  ret = clGetEventProfilingInfo(event, param_name, param_value_size, param_value, NULL);
  check_error(ret);

  {
    rb_param_value = rb_str_new(param_value, param_value_size);

    result = rb_param_value;
  }


  return result;
}
#endif

#ifdef CL_VERSION_1_0
/*
 *  call-seq:
 *     image.get_info(param_name) -> param_value
 *
 */
VALUE
rb_clGetImageInfo(int argc, VALUE *argv, VALUE self)
{
  cl_mem image;
  cl_image_info param_name;
  size_t param_value_size;
  void *param_value;
  size_t param_value_size_ret;
  cl_int ret;
  VALUE rb_image;
  VALUE rb_param_name = Qnil;
  VALUE rb_param_value = Qnil;

  VALUE result;

  if (argc > 1 || argc < 1)
    rb_raise(rb_eArgError, "wrong number of arguments (%d for 1)", argc);


  rb_image = self;
  Check_Type(rb_image, T_DATA);
  if (CLASS_OF(rb_image) != rb_cMem)
    rb_raise(rb_eRuntimeError, "type of image is invalid: Mem is expected");
  image = ((struct_mem)DATA_PTR(rb_image))->mem;

  rb_param_name = argv[0];
  param_name = (uint32_t)NUM2UINT(rb_param_name);



  ret = clGetImageInfo(image, param_name, 0, NULL, &param_value_size_ret);
  param_value_size = param_value_size_ret;
  check_error(ret);
  param_value = (void*) xmalloc(param_value_size);

  ret = clGetImageInfo(image, param_name, param_value_size, param_value, NULL);
  check_error(ret);

  {
    rb_param_value = rb_str_new(param_value, param_value_size);

    result = rb_param_value;
  }


  return result;
}
#endif

#ifdef CL_VERSION_1_0
/*
 *  call-seq:
 *     kernel.get_info(param_name) -> param_value
 *
 */
VALUE
rb_clGetKernelInfo(int argc, VALUE *argv, VALUE self)
{
  cl_kernel kernel;
  cl_kernel_info param_name;
  size_t param_value_size;
  void *param_value;
  size_t param_value_size_ret;
  cl_int ret;
  VALUE rb_kernel;
  VALUE rb_param_name = Qnil;
  VALUE rb_param_value = Qnil;

  VALUE result;

  if (argc > 1 || argc < 1)
    rb_raise(rb_eArgError, "wrong number of arguments (%d for 1)", argc);


  rb_kernel = self;
  Check_Type(rb_kernel, T_DATA);
  if (CLASS_OF(rb_kernel) != rb_cKernel)
    rb_raise(rb_eRuntimeError, "type of kernel is invalid: Kernel is expected");
  kernel = (cl_kernel)DATA_PTR(rb_kernel);

  rb_param_name = argv[0];
  param_name = (uint32_t)NUM2UINT(rb_param_name);



  ret = clGetKernelInfo(kernel, param_name, 0, NULL, &param_value_size_ret);
  param_value_size = param_value_size_ret;
  check_error(ret);
  param_value = (void*) xmalloc(param_value_size);

  ret = clGetKernelInfo(kernel, param_name, param_value_size, param_value, NULL);
  check_error(ret);

  {
    rb_param_value = rb_str_new(param_value, param_value_size);

    result = rb_param_value;
  }


  return result;
}
#endif

#ifdef CL_VERSION_1_0
/*
 *  call-seq:
 *     kernel.get_work_group_info(device, param_name) -> param_value
 *
 */
VALUE
rb_clGetKernelWorkGroupInfo(int argc, VALUE *argv, VALUE self)
{
  cl_kernel kernel;
  cl_device_id device;
  cl_kernel_work_group_info param_name;
  size_t param_value_size;
  void *param_value;
  size_t param_value_size_ret;
  cl_int ret;
  VALUE rb_kernel;
  VALUE rb_device = Qnil;
  VALUE rb_param_name = Qnil;
  VALUE rb_param_value = Qnil;

  VALUE result;

  if (argc > 2 || argc < 2)
    rb_raise(rb_eArgError, "wrong number of arguments (%d for 2)", argc);


  rb_kernel = self;
  Check_Type(rb_kernel, T_DATA);
  if (CLASS_OF(rb_kernel) != rb_cKernel)
    rb_raise(rb_eRuntimeError, "type of kernel is invalid: Kernel is expected");
  kernel = (cl_kernel)DATA_PTR(rb_kernel);

  rb_device = argv[0];
  Check_Type(rb_device, T_DATA);
  if (CLASS_OF(rb_device) != rb_cDevice)
    rb_raise(rb_eRuntimeError, "type of device is invalid: Device is expected");
  device = (cl_device_id)DATA_PTR(rb_device);

  rb_param_name = argv[1];
  param_name = (uint32_t)NUM2UINT(rb_param_name);



  ret = clGetKernelWorkGroupInfo(kernel, device, param_name, 0, NULL, &param_value_size_ret);
  param_value_size = param_value_size_ret;
  check_error(ret);
  param_value = (void*) xmalloc(param_value_size);

  ret = clGetKernelWorkGroupInfo(kernel, device, param_name, param_value_size, param_value, NULL);
  check_error(ret);

  {
    rb_param_value = rb_str_new(param_value, param_value_size);

    result = rb_param_value;
  }


  return result;
}
#endif

#ifdef CL_VERSION_1_0
/*
 *  call-seq:
 *     mem.get_info(param_name) -> param_value
 *
 */
VALUE
rb_clGetMemObjectInfo(int argc, VALUE *argv, VALUE self)
{
  cl_mem memobj;
  cl_mem_info param_name;
  size_t param_value_size;
  void *param_value;
  size_t param_value_size_ret;
  cl_int ret;
  VALUE rb_memobj;
  VALUE rb_param_name = Qnil;
  VALUE rb_param_value = Qnil;

  VALUE result;

  if (argc > 1 || argc < 1)
    rb_raise(rb_eArgError, "wrong number of arguments (%d for 1)", argc);


  rb_memobj = self;
  Check_Type(rb_memobj, T_DATA);
  if (CLASS_OF(rb_memobj) != rb_cMem)
    rb_raise(rb_eRuntimeError, "type of memobj is invalid: Mem is expected");
  memobj = ((struct_mem)DATA_PTR(rb_memobj))->mem;

  rb_param_name = argv[0];
  param_name = (uint32_t)NUM2UINT(rb_param_name);



  ret = clGetMemObjectInfo(memobj, param_name, 0, NULL, &param_value_size_ret);
  param_value_size = param_value_size_ret;
  check_error(ret);
  param_value = (void*) xmalloc(param_value_size);

  ret = clGetMemObjectInfo(memobj, param_name, param_value_size, param_value, NULL);
  check_error(ret);

  {
    rb_param_value = rb_str_new(param_value, param_value_size);

    result = rb_param_value;
  }


  return result;
}
#endif

#ifdef CL_VERSION_1_0
/*
 *  call-seq:
 *     Platform.get_platforms() -> platforms
 *
 */
VALUE
rb_clGetPlatformIDs(int argc, VALUE *argv, VALUE self)
{
  cl_uint num_entries;
  cl_platform_id *platforms;
  cl_uint num_platforms;
  cl_int ret;
  VALUE rb_platforms = Qnil;

  VALUE result;

  if (argc > 0 || argc < 0)
    rb_raise(rb_eArgError, "wrong number of arguments (%d for 0)", argc);




  ret = clGetPlatformIDs(0, NULL, &num_platforms);
  num_entries = num_platforms;
  check_error(ret);
  platforms = ALLOC_N(cl_platform_id, num_entries);

  ret = clGetPlatformIDs(num_entries, platforms, NULL);
  check_error(ret);

  {
    {
      VALUE ary[num_entries];
      int ii;
      for (ii=0; ii<(int)num_entries; ii++)
        ary[ii] = create_platform(platforms[ii]);
      rb_platforms = rb_ary_new4(num_entries, ary);
    }

    result = rb_platforms;
  }


  return result;
}
#endif

#ifdef CL_VERSION_1_0
/*
 *  call-seq:
 *     platform.get_info(param_name) -> param_value
 *
 */
VALUE
rb_clGetPlatformInfo(int argc, VALUE *argv, VALUE self)
{
  cl_platform_id platform;
  cl_platform_info param_name;
  size_t param_value_size;
  void *param_value;
  size_t param_value_size_ret;
  cl_int ret;
  VALUE rb_platform;
  VALUE rb_param_name = Qnil;
  VALUE rb_param_value = Qnil;

  VALUE result;

  if (argc > 1 || argc < 1)
    rb_raise(rb_eArgError, "wrong number of arguments (%d for 1)", argc);


  rb_platform = self;
  Check_Type(rb_platform, T_DATA);
  if (CLASS_OF(rb_platform) != rb_cPlatform)
    rb_raise(rb_eRuntimeError, "type of platform is invalid: Platform is expected");
  platform = (cl_platform_id)DATA_PTR(rb_platform);

  rb_param_name = argv[0];
  param_name = (uint32_t)NUM2UINT(rb_param_name);



  ret = clGetPlatformInfo(platform, param_name, 0, NULL, &param_value_size_ret);
  param_value_size = param_value_size_ret;
  check_error(ret);
  param_value = (void*) xmalloc(param_value_size);

  ret = clGetPlatformInfo(platform, param_name, param_value_size, param_value, NULL);
  check_error(ret);

  {
    rb_param_value = rb_str_new(param_value, param_value_size);

    result = rb_param_value;
  }


  return result;
}
#endif

#ifdef CL_VERSION_1_0
/*
 *  call-seq:
 *     program.get_build_info(device, param_name) -> param_value
 *
 */
VALUE
rb_clGetProgramBuildInfo(int argc, VALUE *argv, VALUE self)
{
  cl_program program;
  cl_device_id device;
  cl_program_build_info param_name;
  size_t param_value_size;
  void *param_value;
  size_t param_value_size_ret;
  cl_int ret;
  VALUE rb_program;
  VALUE rb_device = Qnil;
  VALUE rb_param_name = Qnil;
  VALUE rb_param_value = Qnil;

  VALUE result;

  if (argc > 2 || argc < 2)
    rb_raise(rb_eArgError, "wrong number of arguments (%d for 2)", argc);


  rb_program = self;
  Check_Type(rb_program, T_DATA);
  if (CLASS_OF(rb_program) != rb_cProgram)
    rb_raise(rb_eRuntimeError, "type of program is invalid: Program is expected");
  program = (cl_program)DATA_PTR(rb_program);

  rb_device = argv[0];
  Check_Type(rb_device, T_DATA);
  if (CLASS_OF(rb_device) != rb_cDevice)
    rb_raise(rb_eRuntimeError, "type of device is invalid: Device is expected");
  device = (cl_device_id)DATA_PTR(rb_device);

  rb_param_name = argv[1];
  param_name = (uint32_t)NUM2UINT(rb_param_name);



  ret = clGetProgramBuildInfo(program, device, param_name, 0, NULL, &param_value_size_ret);
  param_value_size = param_value_size_ret;
  check_error(ret);
  param_value = (void*) xmalloc(param_value_size);

  ret = clGetProgramBuildInfo(program, device, param_name, param_value_size, param_value, NULL);
  check_error(ret);

  {
    rb_param_value = rb_str_new(param_value, param_value_size);

    result = rb_param_value;
  }


  return result;
}
#endif

#ifdef CL_VERSION_1_0
/*
 *  call-seq:
 *     program.get_info(param_name) -> param_value
 *
 */
VALUE
rb_clGetProgramInfo(int argc, VALUE *argv, VALUE self)
{
  cl_program program;
  cl_program_info param_name;
  size_t param_value_size;
  void *param_value;
  size_t param_value_size_ret;
  cl_int ret;
  VALUE rb_program;
  VALUE rb_param_name = Qnil;
  VALUE rb_param_value = Qnil;

  VALUE result;

  if (argc > 1 || argc < 1)
    rb_raise(rb_eArgError, "wrong number of arguments (%d for 1)", argc);


  rb_program = self;
  Check_Type(rb_program, T_DATA);
  if (CLASS_OF(rb_program) != rb_cProgram)
    rb_raise(rb_eRuntimeError, "type of program is invalid: Program is expected");
  program = (cl_program)DATA_PTR(rb_program);

  rb_param_name = argv[0];
  param_name = (uint32_t)NUM2UINT(rb_param_name);



  ret = clGetProgramInfo(program, param_name, 0, NULL, &param_value_size_ret);
  param_value_size = param_value_size_ret;
  check_error(ret);
  param_value = (void*) xmalloc(param_value_size);

  ret = clGetProgramInfo(program, param_name, param_value_size, param_value, NULL);
  check_error(ret);

  {
    rb_param_value = rb_str_new(param_value, param_value_size);

    result = rb_param_value;
  }


  return result;
}
#endif

#ifdef CL_VERSION_1_0
/*
 *  call-seq:
 *     sampler.get_info(param_name) -> param_value
 *
 */
VALUE
rb_clGetSamplerInfo(int argc, VALUE *argv, VALUE self)
{
  cl_sampler sampler;
  cl_sampler_info param_name;
  size_t param_value_size;
  void *param_value;
  size_t param_value_size_ret;
  cl_int ret;
  VALUE rb_sampler;
  VALUE rb_param_name = Qnil;
  VALUE rb_param_value = Qnil;

  VALUE result;

  if (argc > 1 || argc < 1)
    rb_raise(rb_eArgError, "wrong number of arguments (%d for 1)", argc);


  rb_sampler = self;
  Check_Type(rb_sampler, T_DATA);
  if (CLASS_OF(rb_sampler) != rb_cSampler)
    rb_raise(rb_eRuntimeError, "type of sampler is invalid: Sampler is expected");
  sampler = (cl_sampler)DATA_PTR(rb_sampler);

  rb_param_name = argv[0];
  param_name = (uint32_t)NUM2UINT(rb_param_name);



  ret = clGetSamplerInfo(sampler, param_name, 0, NULL, &param_value_size_ret);
  param_value_size = param_value_size_ret;
  check_error(ret);
  param_value = (void*) xmalloc(param_value_size);

  ret = clGetSamplerInfo(sampler, param_name, param_value_size, param_value, NULL);
  check_error(ret);

  {
    rb_param_value = rb_str_new(param_value, param_value_size);

    result = rb_param_value;
  }


  return result;
}
#endif

#ifdef CL_VERSION_1_0
/*
 *  call-seq:
 *     context.get_supported_image_formats(flags, image_type) -> image_formats
 *
 */
VALUE
rb_clGetSupportedImageFormats(int argc, VALUE *argv, VALUE self)
{
  cl_context context;
  cl_mem_flags flags;
  cl_mem_object_type image_type;
  cl_uint num_entries;
  cl_image_format *image_formats;
  cl_uint num_image_formats;
  cl_int ret;
  VALUE rb_context;
  VALUE rb_flags = Qnil;
  VALUE rb_image_type = Qnil;
  VALUE rb_image_formats = Qnil;

  VALUE result;

  if (argc > 2 || argc < 2)
    rb_raise(rb_eArgError, "wrong number of arguments (%d for 2)", argc);


  rb_context = self;
  Check_Type(rb_context, T_DATA);
  if (CLASS_OF(rb_context) != rb_cContext)
    rb_raise(rb_eRuntimeError, "type of context is invalid: Context is expected");
  context = (cl_context)DATA_PTR(rb_context);

  rb_flags = argv[0];
  flags = (uint64_t)NUM2ULONG(rb_flags);

  rb_image_type = argv[1];
  image_type = (uint32_t)NUM2UINT(rb_image_type);



  ret = clGetSupportedImageFormats(context, flags, image_type, 0, NULL, &num_image_formats);
  num_entries = num_image_formats;
  check_error(ret);
  image_formats = ALLOC_N(cl_image_format, num_entries);

  ret = clGetSupportedImageFormats(context, flags, image_type, num_entries, image_formats, NULL);
  check_error(ret);

  {
    {
      VALUE ary[num_entries];
      int ii;
      for (ii=0; ii<(int)num_entries; ii++)
        ary[ii] = create_image_format(&image_formats[ii]);
      rb_image_formats = rb_ary_new4(num_entries, ary);
    }

    result = rb_image_formats;
  }


  return result;
}
#endif

#ifdef CL_VERSION_1_1
void
clSetEventCallback_pfn_notify (cl_event event, cl_int event_command_exec_status, void * user_data)
{
  if (rb_block_given_p())
    rb_yield(rb_ary_new3(3, create_event(event), INT2NUM(event_command_exec_status), user_data ? (VALUE) user_data : Qnil));
}
/*
 *  call-seq:
 *     event.set_callback(command_exec_callback_type[, opts]){ } -> nil
 *
 *  opts: user_data
 */
VALUE
rb_clSetEventCallback(int argc, VALUE *argv, VALUE self)
{
  cl_event event;
  cl_int command_exec_callback_type;
  void *user_data;
  cl_int ret;
  VALUE rb_event;
  VALUE rb_command_exec_callback_type = Qnil;
  VALUE rb_user_data = Qnil;

  VALUE result;

  if (argc > 3 || argc < 1)
    rb_raise(rb_eArgError, "wrong number of arguments (%d for 1)", argc);

  {
    VALUE _opt_hash = Qnil;

    if (argc > 1) {
      _opt_hash = argv[1];
      Check_Type(_opt_hash, T_HASH);
    }
    if (_opt_hash != Qnil) {
      rb_user_data = rb_hash_aref(_opt_hash, ID2SYM(rb_intern("user_data")));
    }
    if (_opt_hash != Qnil && rb_user_data != Qnil) {
      user_data = (void*) rb_user_data;

    } else {
      user_data = NULL;
    }
  }

  rb_event = self;
  Check_Type(rb_event, T_DATA);
  if (CLASS_OF(rb_event) != rb_cEvent)
    rb_raise(rb_eRuntimeError, "type of event is invalid: Event is expected");
  event = (cl_event)DATA_PTR(rb_event);

  rb_command_exec_callback_type = argv[0];
  command_exec_callback_type = (int32_t)NUM2INT(rb_command_exec_callback_type);




  ret = clSetEventCallback(event, command_exec_callback_type, clSetEventCallback_pfn_notify , user_data);
  check_error(ret);

  {
    result = Qnil;
  }


  return result;
}
#endif

#ifdef CL_VERSION_1_0
/*
 *  call-seq:
 *     kernel.set_arg(arg_index, arg_value[, opts]) -> nil
 *
 *  opts: arg_size
 */
VALUE
rb_clSetKernelArg(int argc, VALUE *argv, VALUE self)
{
  cl_kernel kernel;
  cl_uint arg_index;
  size_t arg_size;
  void *arg_value;
  cl_int ret;
  VALUE rb_kernel;
  VALUE rb_arg_index = Qnil;
  VALUE rb_arg_value = Qnil;
  VALUE rb_arg_size = Qnil;

  VALUE result;

  if (argc > 3 || argc < 2)
    rb_raise(rb_eArgError, "wrong number of arguments (%d for 2)", argc);

  {
    VALUE _opt_hash = Qnil;

    if (argc > 2) {
      _opt_hash = argv[2];
      Check_Type(_opt_hash, T_HASH);
    }
    if (_opt_hash != Qnil) {
      rb_arg_size = rb_hash_aref(_opt_hash, ID2SYM(rb_intern("arg_size")));
    }
    if (_opt_hash != Qnil && rb_arg_size != Qnil) {
      arg_size = (size_t)NUM2ULONG(rb_arg_size);

    } else {
      arg_size = 0;
    }
  }

  rb_kernel = self;
  Check_Type(rb_kernel, T_DATA);
  if (CLASS_OF(rb_kernel) != rb_cKernel)
    rb_raise(rb_eRuntimeError, "type of kernel is invalid: Kernel is expected");
  kernel = (cl_kernel)DATA_PTR(rb_kernel);

  rb_arg_index = argv[0];
  arg_index = (uint32_t)NUM2UINT(rb_arg_index);

  rb_arg_value = argv[1];
  if (TYPE(rb_arg_value)==T_FIXNUM) {
    long l = FIX2LONG(rb_arg_value);
    arg_value = (void*)&l;
    arg_size = sizeof(long);
  } else if (CLASS_OF(rb_arg_value)==rb_cCLFloat) {
    cl_float f = (cl_float)NUM2DBL(rb_arg_value);
    arg_value = (void*)&f;
    arg_size = sizeof(cl_float);
  } else if (CLASS_OF(rb_arg_value)==rb_cCLDouble) {
    cl_double d = (cl_double)NUM2DBL(rb_arg_value);
    arg_value = (void*)&d;
    arg_size = sizeof(cl_double);
  } else if (CLASS_OF(rb_arg_value)==rb_cCLHalf) {
    cl_half h = (cl_half)NUM2DBL(rb_arg_value);
    arg_value = (void*)&h;
    arg_size = sizeof(cl_half);
  } else if (CLASS_OF(rb_arg_value)==rb_cCLChar) {
    cl_char c = (cl_char)NUM2CHR(rb_arg_value);
    arg_value = (void*)&c;
    arg_size = sizeof(cl_char);
  } else if (CLASS_OF(rb_arg_value)==rb_cCLUChar) {
    cl_uchar c = (cl_char)NUM2CHR(rb_arg_value);
    arg_value = (void*)&c;
    arg_size = sizeof(cl_uchar);
  } else if (CLASS_OF(rb_arg_value)==rb_cCLShort) {
    cl_short s = (cl_short)NUM2INT(rb_arg_value);
    arg_value = (void*)&s;
    arg_size = sizeof(cl_short);
  } else if (CLASS_OF(rb_arg_value)==rb_cCLUShort) {
    cl_ushort s = (cl_ushort)NUM2INT(rb_arg_value);
    arg_value = (void*)&s;
    arg_size = sizeof(cl_ushort);
  } else if (CLASS_OF(rb_arg_value)==rb_cCLInt) {
    cl_int i = (cl_int)NUM2INT(rb_arg_value);
    arg_value = (void*)&i;
    arg_size = sizeof(cl_int);
  } else if (CLASS_OF(rb_arg_value)==rb_cCLUInt) {
    cl_uint i = (cl_uint)NUM2INT(rb_arg_value);
    arg_value = (void*)&i;
    arg_size = sizeof(cl_uint);
  } else if (CLASS_OF(rb_arg_value)==rb_cCLLong) {
    cl_long l = (cl_long)NUM2LONG(rb_arg_value);
    arg_value = (void*)&l;
    arg_size = sizeof(cl_long);
  } else if (CLASS_OF(rb_arg_value)==rb_cCLULong) {
    cl_ulong l = (cl_ulong)NUM2LONG(rb_arg_value);
    arg_value = (void*)&l;
    arg_size = sizeof(cl_ulong);
  } else if (TYPE(rb_arg_value)==T_FLOAT) {
    double d = NUM2DBL(rb_arg_value);
    arg_value = (void*)&d;
    arg_size = sizeof(double);
  } else if (TYPE(rb_arg_value)==T_STRING) {
    char *c = (char*)RSTRING_PTR(rb_arg_value);
    arg_value = (void*)c;
    arg_size = RSTRING_LEN(rb_arg_value);
  } else if (rb_arg_value==Qnil) {
    char *c = 0;
    arg_value = (void*)c;
  } else if (CLASS_OF(rb_arg_value)==rb_cSampler) {
    cl_sampler sampler;
    Check_Type(rb_arg_value, T_DATA);
    if (CLASS_OF(rb_arg_value) != rb_cSampler)
      rb_raise(rb_eRuntimeError, "type of sampler is invalid: Sampler is expected");
    sampler = (cl_sampler)DATA_PTR(rb_arg_value);

    arg_value = (void*)&sampler;
    arg_size = sizeof(cl_sampler);
  } else if (rb_obj_is_kind_of(rb_arg_value,rb_cMem)==Qtrue) {
    cl_mem mem;
    Check_Type(rb_arg_value, T_DATA);
    if (CLASS_OF(rb_arg_value) != rb_cMem)
      rb_raise(rb_eRuntimeError, "type of mem is invalid: Mem is expected");
    mem = ((struct_mem)DATA_PTR(rb_arg_value))->mem;

    arg_value = (void*)&mem;
    arg_size = sizeof(cl_mem);
  } else
    rb_raise(rb_eArgError, "wrong type of the 2th argument");



  ret = clSetKernelArg(kernel, arg_index, arg_size, (const void*)arg_value);
  check_error(ret);

  {
    result = Qnil;
  }


  return result;
}
#endif

#ifdef CL_VERSION_1_1
/*
 *  call-seq:
 *     event.set_user_event_status(execution_status) -> nil
 *
 */
VALUE
rb_clSetUserEventStatus(int argc, VALUE *argv, VALUE self)
{
  cl_event event;
  cl_int execution_status;
  cl_int ret;
  VALUE rb_event;
  VALUE rb_execution_status = Qnil;

  VALUE result;

  if (argc > 1 || argc < 1)
    rb_raise(rb_eArgError, "wrong number of arguments (%d for 1)", argc);


  rb_event = self;
  Check_Type(rb_event, T_DATA);
  if (CLASS_OF(rb_event) != rb_cEvent)
    rb_raise(rb_eRuntimeError, "type of event is invalid: Event is expected");
  event = (cl_event)DATA_PTR(rb_event);

  rb_execution_status = argv[0];
  execution_status = (int32_t)NUM2INT(rb_execution_status);




  ret = clSetUserEventStatus(event, execution_status);
  check_error(ret);

  {
    result = Qnil;
  }


  return result;
}
#endif

#ifdef CL_VERSION_1_0
/*
 *  call-seq:
 *     unload_compiler() -> nil
 *
 */
VALUE
rb_clUnloadCompiler(int argc, VALUE *argv, VALUE self)
{
  cl_int ret;

  VALUE result;

  if (argc > 0 || argc < 0)
    rb_raise(rb_eArgError, "wrong number of arguments (%d for 0)", argc);





  ret = clUnloadCompiler();
  check_error(ret);

  {
    result = Qnil;
  }


  return result;
}
#endif

#ifdef CL_VERSION_1_0
/*
 *  call-seq:
 *     Event.wait(event_list) -> nil
 *
 */
VALUE
rb_clWaitForEvents(int argc, VALUE *argv, VALUE self)
{
  cl_uint num_events;
  cl_event *event_list;
  cl_int ret;
  VALUE rb_event_list = Qnil;

  VALUE result;

  if (argc > 1 || argc < 1)
    rb_raise(rb_eArgError, "wrong number of arguments (%d for 1)", argc);


  rb_event_list = argv[0];
  Check_Type(rb_event_list, T_ARRAY);
  {
    int n;
    num_events = RARRAY_LEN(rb_event_list);
    event_list = ALLOC_N(cl_event, num_events);
    for (n=0; n<(int)num_events; n++) {
      Check_Type(RARRAY_PTR(rb_event_list)[n], T_DATA);
      if (CLASS_OF(RARRAY_PTR(rb_event_list)[n]) != rb_cEvent)
        rb_raise(rb_eRuntimeError, "type of event_list[n] is invalid: Event is expected");
      event_list[n] = (cl_event)DATA_PTR(RARRAY_PTR(rb_event_list)[n]);
    }
  }




  ret = clWaitForEvents(num_events, (const cl_event*)event_list);
  check_error(ret);

  {
    result = Qnil;
  }

  if (event_list) xfree(event_list);

  return result;
}
#endif

VALUE
rb_GetContextDevices(int argc, VALUE *argv, VALUE self)
{
  VALUE str;
  VALUE param;
  cl_device_id *devs;
  size_t len;
  VALUE *ary;
  VALUE ret;
  int i;

  if (argc!=0)
    rb_raise(rb_eArgError, "wrong number of arguments (%d for 0)", argc);
  param = UINT2NUM(CL_CONTEXT_DEVICES);
  str = rb_clGetContextInfo(1, &param, self);
  devs = (cl_device_id*)RSTRING_PTR(str);
  len = RSTRING_LEN(str)/sizeof(cl_device_id*);
  ary = ALLOC_N(VALUE, len);
  for (i=0; i<(int)len; i++)
    ary[i] = create_device(devs[i]);
  ret = rb_ary_new4(len, ary);
  xfree(ary);
  return ret;
}
VALUE
rb_GetProgramDevices(int argc, VALUE *argv, VALUE self)
{
  VALUE str;
  VALUE param;
  cl_device_id *devs;
  size_t len;
  VALUE *ary;
  VALUE ret;
  int i;

  if (argc!=0)
    rb_raise(rb_eArgError, "wrong number of arguments (%d for 0)", argc);
  param = UINT2NUM(CL_PROGRAM_DEVICES);
  str = rb_clGetProgramInfo(1, &param, self);
  devs = (cl_device_id*)RSTRING_PTR(str);
  len = RSTRING_LEN(str)/sizeof(cl_device_id*);
  ary = ALLOC_N(VALUE, len);
  for (i=0; i<(int)len; i++)
    ary[i] = create_device(devs[i]);
  ret = rb_ary_new4(len, ary);
  xfree(ary);
  return ret;
}
VALUE
rb_GetCommandQueueDevice(int argc, VALUE *argv, VALUE self)
{
  VALUE param;
  VALUE str;
  cl_device_id *target;

  if (argc!=0)
    rb_raise(rb_eArgError, "wrong number of arguments (%d for 0)", argc);
  param = UINT2NUM(CL_QUEUE_DEVICE);
  str = rb_clGetCommandQueueInfo(1, &param, self);
  target = (cl_device_id*) RSTRING_PTR(str);
  return create_device(*target);
}
VALUE
rb_GetCommandQueueContext(int argc, VALUE *argv, VALUE self)
{
  VALUE param;
  VALUE str;
  cl_context *target;

  if (argc!=0)
    rb_raise(rb_eArgError, "wrong number of arguments (%d for 0)", argc);
  param = UINT2NUM(CL_QUEUE_CONTEXT);
  str = rb_clGetCommandQueueInfo(1, &param, self);
  target = (cl_context*) RSTRING_PTR(str);
  clRetainContext(*target);
  return create_context(*target);
}
VALUE
rb_GetMemObjectContext(int argc, VALUE *argv, VALUE self)
{
  VALUE param;
  VALUE str;
  cl_context *target;

  if (argc!=0)
    rb_raise(rb_eArgError, "wrong number of arguments (%d for 0)", argc);
  param = UINT2NUM(CL_MEM_CONTEXT);
  str = rb_clGetMemObjectInfo(1, &param, self);
  target = (cl_context*) RSTRING_PTR(str);
  clRetainContext(*target);
  return create_context(*target);
}
VALUE
rb_GetSamplerContext(int argc, VALUE *argv, VALUE self)
{
  VALUE param;
  VALUE str;
  cl_context *target;

  if (argc!=0)
    rb_raise(rb_eArgError, "wrong number of arguments (%d for 0)", argc);
  param = UINT2NUM(CL_SAMPLER_CONTEXT);
  str = rb_clGetSamplerInfo(1, &param, self);
  target = (cl_context*) RSTRING_PTR(str);
  clRetainContext(*target);
  return create_context(*target);
}
VALUE
rb_GetProgramContext(int argc, VALUE *argv, VALUE self)
{
  VALUE param;
  VALUE str;
  cl_context *target;

  if (argc!=0)
    rb_raise(rb_eArgError, "wrong number of arguments (%d for 0)", argc);
  param = UINT2NUM(CL_PROGRAM_CONTEXT);
  str = rb_clGetProgramInfo(1, &param, self);
  target = (cl_context*) RSTRING_PTR(str);
  clRetainContext(*target);
  return create_context(*target);
}
VALUE
rb_GetKernelContext(int argc, VALUE *argv, VALUE self)
{
  VALUE param;
  VALUE str;
  cl_context *target;

  if (argc!=0)
    rb_raise(rb_eArgError, "wrong number of arguments (%d for 0)", argc);
  param = UINT2NUM(CL_KERNEL_CONTEXT);
  str = rb_clGetKernelInfo(1, &param, self);
  target = (cl_context*) RSTRING_PTR(str);
  clRetainContext(*target);
  return create_context(*target);
}
VALUE
rb_GetKernelProgram(int argc, VALUE *argv, VALUE self)
{
  VALUE param;
  VALUE str;
  cl_program *target;

  if (argc!=0)
    rb_raise(rb_eArgError, "wrong number of arguments (%d for 0)", argc);
  param = UINT2NUM(CL_KERNEL_PROGRAM);
  str = rb_clGetKernelInfo(1, &param, self);
  target = (cl_program*) RSTRING_PTR(str);
  clRetainProgram(*target);
  return create_program(*target);
}
VALUE
rb_GetEventCommandQueue(int argc, VALUE *argv, VALUE self)
{
  VALUE param;
  VALUE str;
  cl_command_queue *target;

  if (argc!=0)
    rb_raise(rb_eArgError, "wrong number of arguments (%d for 0)", argc);
  param = UINT2NUM(CL_EVENT_COMMAND_QUEUE);
  str = rb_clGetEventInfo(1, &param, self);
  target = (cl_command_queue*) RSTRING_PTR(str);
  clRetainCommandQueue(*target);
  return create_command_queue(*target);
}
VALUE
rb_CreateImageFormat(int argc, VALUE *argv, VALUE self)
{
  cl_channel_order image_channel_order;
  cl_channel_type image_channel_data_type;
  cl_image_format *s_image_format;

  VALUE rb_image_channel_order;
  VALUE rb_image_channel_data_type;

  if (argc != 2)
    rb_raise(rb_eArgError, "wrong number of arguments (%d for 2)", argc);
  
  rb_image_channel_order = argv[0];
  image_channel_order = (uint32_t)NUM2UINT(rb_image_channel_order);
  rb_image_channel_data_type = argv[1];
  image_channel_data_type = (uint32_t)NUM2UINT(rb_image_channel_data_type);

  s_image_format = (cl_image_format*) xmalloc(sizeof(cl_image_format));
  s_image_format->image_channel_order = image_channel_order;
  s_image_format->image_channel_data_type = image_channel_data_type;

  return create_image_format(s_image_format);
}
VALUE
rb_GetImageFormatImageChannelOrder(int argc, VALUE *argv, VALUE self)
{
  cl_image_format *image_format;

  if (argc != 0)
    rb_raise(rb_eArgError, "wrong number of arguments (%d for 2)", argc);

  Check_Type(self, T_DATA);
  if (CLASS_OF(self) != rb_cImageFormat)
    rb_raise(rb_eRuntimeError, "type of image_format is invalid: ImageFormat is expected");
  image_format = (cl_image_format*)DATA_PTR(self);

  return UINT2NUM((uint32_t)image_format->image_channel_order);
}
VALUE
rb_GetImageFormatImageChannelDataType(int argc, VALUE *argv, VALUE self)
{
  cl_image_format *image_format;

  if (argc != 0)
    rb_raise(rb_eArgError, "wrong number of arguments (%d for 2)", argc);

  Check_Type(self, T_DATA);
  if (CLASS_OF(self) != rb_cImageFormat)
    rb_raise(rb_eRuntimeError, "type of image_format is invalid: ImageFormat is expected");
  image_format = (cl_image_format*)DATA_PTR(self);

  return UINT2NUM((uint32_t)image_format->image_channel_data_type);
}
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
      for (n=0; n<(int)2; n++)
#ifdef CL_BIG_ENDIAN
        ((cl_char*)vector)[n] = NUM2CHR(ptr[n]);
#else
        ((cl_char*)vector)[n] = NUM2CHR(ptr[1-n]);
#endif
    }
  } else if (argc == 2) {
      for (n=0; n<(int)2; n++)
#ifdef CL_BIG_ENDIAN
        ((cl_char*)vector)[n] = NUM2CHR(argv[n]);
#else
        ((cl_char*)vector)[n] = NUM2CHR(argv[1-n]);
#endif
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
#ifdef CL_BIG_ENDIAN
  return rb_ary_new3(2, CHR2FIX((((cl_char*)vector)[0])), CHR2FIX((((cl_char*)vector)[1])));
#else
  return rb_ary_new3(2, CHR2FIX((((cl_char*)vector)[1])), CHR2FIX((((cl_char*)vector)[0])));
#endif
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
      for (n=0; n<(int)4; n++)
#ifdef CL_BIG_ENDIAN
        ((cl_char*)vector)[n] = NUM2CHR(ptr[n]);
#else
        ((cl_char*)vector)[n] = NUM2CHR(ptr[3-n]);
#endif
    }
  } else if (argc == 4) {
      for (n=0; n<(int)4; n++)
#ifdef CL_BIG_ENDIAN
        ((cl_char*)vector)[n] = NUM2CHR(argv[n]);
#else
        ((cl_char*)vector)[n] = NUM2CHR(argv[3-n]);
#endif
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
#ifdef CL_BIG_ENDIAN
  return rb_ary_new3(4, CHR2FIX((((cl_char*)vector)[0])), CHR2FIX((((cl_char*)vector)[1])), CHR2FIX((((cl_char*)vector)[2])), CHR2FIX((((cl_char*)vector)[3])));
#else
  return rb_ary_new3(4, CHR2FIX((((cl_char*)vector)[3])), CHR2FIX((((cl_char*)vector)[2])), CHR2FIX((((cl_char*)vector)[1])), CHR2FIX((((cl_char*)vector)[0])));
#endif
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
      for (n=0; n<(int)8; n++)
#ifdef CL_BIG_ENDIAN
        ((cl_char*)vector)[n] = NUM2CHR(ptr[n]);
#else
        ((cl_char*)vector)[n] = NUM2CHR(ptr[7-n]);
#endif
    }
  } else if (argc == 8) {
      for (n=0; n<(int)8; n++)
#ifdef CL_BIG_ENDIAN
        ((cl_char*)vector)[n] = NUM2CHR(argv[n]);
#else
        ((cl_char*)vector)[n] = NUM2CHR(argv[7-n]);
#endif
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
#ifdef CL_BIG_ENDIAN
  return rb_ary_new3(8, CHR2FIX((((cl_char*)vector)[0])), CHR2FIX((((cl_char*)vector)[1])), CHR2FIX((((cl_char*)vector)[2])), CHR2FIX((((cl_char*)vector)[3])), CHR2FIX((((cl_char*)vector)[4])), CHR2FIX((((cl_char*)vector)[5])), CHR2FIX((((cl_char*)vector)[6])), CHR2FIX((((cl_char*)vector)[7])));
#else
  return rb_ary_new3(8, CHR2FIX((((cl_char*)vector)[7])), CHR2FIX((((cl_char*)vector)[6])), CHR2FIX((((cl_char*)vector)[5])), CHR2FIX((((cl_char*)vector)[4])), CHR2FIX((((cl_char*)vector)[3])), CHR2FIX((((cl_char*)vector)[2])), CHR2FIX((((cl_char*)vector)[1])), CHR2FIX((((cl_char*)vector)[0])));
#endif
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
      for (n=0; n<(int)16; n++)
#ifdef CL_BIG_ENDIAN
        ((cl_char*)vector)[n] = NUM2CHR(ptr[n]);
#else
        ((cl_char*)vector)[n] = NUM2CHR(ptr[15-n]);
#endif
    }
  } else if (argc == 16) {
      for (n=0; n<(int)16; n++)
#ifdef CL_BIG_ENDIAN
        ((cl_char*)vector)[n] = NUM2CHR(argv[n]);
#else
        ((cl_char*)vector)[n] = NUM2CHR(argv[15-n]);
#endif
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
#ifdef CL_BIG_ENDIAN
  return rb_ary_new3(16, CHR2FIX((((cl_char*)vector)[0])), CHR2FIX((((cl_char*)vector)[1])), CHR2FIX((((cl_char*)vector)[2])), CHR2FIX((((cl_char*)vector)[3])), CHR2FIX((((cl_char*)vector)[4])), CHR2FIX((((cl_char*)vector)[5])), CHR2FIX((((cl_char*)vector)[6])), CHR2FIX((((cl_char*)vector)[7])), CHR2FIX((((cl_char*)vector)[8])), CHR2FIX((((cl_char*)vector)[9])), CHR2FIX((((cl_char*)vector)[10])), CHR2FIX((((cl_char*)vector)[11])), CHR2FIX((((cl_char*)vector)[12])), CHR2FIX((((cl_char*)vector)[13])), CHR2FIX((((cl_char*)vector)[14])), CHR2FIX((((cl_char*)vector)[15])));
#else
  return rb_ary_new3(16, CHR2FIX((((cl_char*)vector)[15])), CHR2FIX((((cl_char*)vector)[14])), CHR2FIX((((cl_char*)vector)[13])), CHR2FIX((((cl_char*)vector)[12])), CHR2FIX((((cl_char*)vector)[11])), CHR2FIX((((cl_char*)vector)[10])), CHR2FIX((((cl_char*)vector)[9])), CHR2FIX((((cl_char*)vector)[8])), CHR2FIX((((cl_char*)vector)[7])), CHR2FIX((((cl_char*)vector)[6])), CHR2FIX((((cl_char*)vector)[5])), CHR2FIX((((cl_char*)vector)[4])), CHR2FIX((((cl_char*)vector)[3])), CHR2FIX((((cl_char*)vector)[2])), CHR2FIX((((cl_char*)vector)[1])), CHR2FIX((((cl_char*)vector)[0])));
#endif
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
      for (n=0; n<(int)2; n++)
#ifdef CL_BIG_ENDIAN
        ((cl_uchar*)vector)[n] = (uint8_t)NUM2UINT(ptr[n]);
#else
        ((cl_uchar*)vector)[n] = (uint8_t)NUM2UINT(ptr[1-n]);
#endif
    }
  } else if (argc == 2) {
      for (n=0; n<(int)2; n++)
#ifdef CL_BIG_ENDIAN
        ((cl_uchar*)vector)[n] = (uint8_t)NUM2UINT(argv[n]);
#else
        ((cl_uchar*)vector)[n] = (uint8_t)NUM2UINT(argv[1-n]);
#endif
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
#ifdef CL_BIG_ENDIAN
  return rb_ary_new3(2, UINT2NUM((uint8_t)(((cl_uchar*)vector)[0])), UINT2NUM((uint8_t)(((cl_uchar*)vector)[1])));
#else
  return rb_ary_new3(2, UINT2NUM((uint8_t)(((cl_uchar*)vector)[1])), UINT2NUM((uint8_t)(((cl_uchar*)vector)[0])));
#endif
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
      for (n=0; n<(int)4; n++)
#ifdef CL_BIG_ENDIAN
        ((cl_uchar*)vector)[n] = (uint8_t)NUM2UINT(ptr[n]);
#else
        ((cl_uchar*)vector)[n] = (uint8_t)NUM2UINT(ptr[3-n]);
#endif
    }
  } else if (argc == 4) {
      for (n=0; n<(int)4; n++)
#ifdef CL_BIG_ENDIAN
        ((cl_uchar*)vector)[n] = (uint8_t)NUM2UINT(argv[n]);
#else
        ((cl_uchar*)vector)[n] = (uint8_t)NUM2UINT(argv[3-n]);
#endif
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
#ifdef CL_BIG_ENDIAN
  return rb_ary_new3(4, UINT2NUM((uint8_t)(((cl_uchar*)vector)[0])), UINT2NUM((uint8_t)(((cl_uchar*)vector)[1])), UINT2NUM((uint8_t)(((cl_uchar*)vector)[2])), UINT2NUM((uint8_t)(((cl_uchar*)vector)[3])));
#else
  return rb_ary_new3(4, UINT2NUM((uint8_t)(((cl_uchar*)vector)[3])), UINT2NUM((uint8_t)(((cl_uchar*)vector)[2])), UINT2NUM((uint8_t)(((cl_uchar*)vector)[1])), UINT2NUM((uint8_t)(((cl_uchar*)vector)[0])));
#endif
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
      for (n=0; n<(int)8; n++)
#ifdef CL_BIG_ENDIAN
        ((cl_uchar*)vector)[n] = (uint8_t)NUM2UINT(ptr[n]);
#else
        ((cl_uchar*)vector)[n] = (uint8_t)NUM2UINT(ptr[7-n]);
#endif
    }
  } else if (argc == 8) {
      for (n=0; n<(int)8; n++)
#ifdef CL_BIG_ENDIAN
        ((cl_uchar*)vector)[n] = (uint8_t)NUM2UINT(argv[n]);
#else
        ((cl_uchar*)vector)[n] = (uint8_t)NUM2UINT(argv[7-n]);
#endif
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
#ifdef CL_BIG_ENDIAN
  return rb_ary_new3(8, UINT2NUM((uint8_t)(((cl_uchar*)vector)[0])), UINT2NUM((uint8_t)(((cl_uchar*)vector)[1])), UINT2NUM((uint8_t)(((cl_uchar*)vector)[2])), UINT2NUM((uint8_t)(((cl_uchar*)vector)[3])), UINT2NUM((uint8_t)(((cl_uchar*)vector)[4])), UINT2NUM((uint8_t)(((cl_uchar*)vector)[5])), UINT2NUM((uint8_t)(((cl_uchar*)vector)[6])), UINT2NUM((uint8_t)(((cl_uchar*)vector)[7])));
#else
  return rb_ary_new3(8, UINT2NUM((uint8_t)(((cl_uchar*)vector)[7])), UINT2NUM((uint8_t)(((cl_uchar*)vector)[6])), UINT2NUM((uint8_t)(((cl_uchar*)vector)[5])), UINT2NUM((uint8_t)(((cl_uchar*)vector)[4])), UINT2NUM((uint8_t)(((cl_uchar*)vector)[3])), UINT2NUM((uint8_t)(((cl_uchar*)vector)[2])), UINT2NUM((uint8_t)(((cl_uchar*)vector)[1])), UINT2NUM((uint8_t)(((cl_uchar*)vector)[0])));
#endif
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
      for (n=0; n<(int)16; n++)
#ifdef CL_BIG_ENDIAN
        ((cl_uchar*)vector)[n] = (uint8_t)NUM2UINT(ptr[n]);
#else
        ((cl_uchar*)vector)[n] = (uint8_t)NUM2UINT(ptr[15-n]);
#endif
    }
  } else if (argc == 16) {
      for (n=0; n<(int)16; n++)
#ifdef CL_BIG_ENDIAN
        ((cl_uchar*)vector)[n] = (uint8_t)NUM2UINT(argv[n]);
#else
        ((cl_uchar*)vector)[n] = (uint8_t)NUM2UINT(argv[15-n]);
#endif
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
#ifdef CL_BIG_ENDIAN
  return rb_ary_new3(16, UINT2NUM((uint8_t)(((cl_uchar*)vector)[0])), UINT2NUM((uint8_t)(((cl_uchar*)vector)[1])), UINT2NUM((uint8_t)(((cl_uchar*)vector)[2])), UINT2NUM((uint8_t)(((cl_uchar*)vector)[3])), UINT2NUM((uint8_t)(((cl_uchar*)vector)[4])), UINT2NUM((uint8_t)(((cl_uchar*)vector)[5])), UINT2NUM((uint8_t)(((cl_uchar*)vector)[6])), UINT2NUM((uint8_t)(((cl_uchar*)vector)[7])), UINT2NUM((uint8_t)(((cl_uchar*)vector)[8])), UINT2NUM((uint8_t)(((cl_uchar*)vector)[9])), UINT2NUM((uint8_t)(((cl_uchar*)vector)[10])), UINT2NUM((uint8_t)(((cl_uchar*)vector)[11])), UINT2NUM((uint8_t)(((cl_uchar*)vector)[12])), UINT2NUM((uint8_t)(((cl_uchar*)vector)[13])), UINT2NUM((uint8_t)(((cl_uchar*)vector)[14])), UINT2NUM((uint8_t)(((cl_uchar*)vector)[15])));
#else
  return rb_ary_new3(16, UINT2NUM((uint8_t)(((cl_uchar*)vector)[15])), UINT2NUM((uint8_t)(((cl_uchar*)vector)[14])), UINT2NUM((uint8_t)(((cl_uchar*)vector)[13])), UINT2NUM((uint8_t)(((cl_uchar*)vector)[12])), UINT2NUM((uint8_t)(((cl_uchar*)vector)[11])), UINT2NUM((uint8_t)(((cl_uchar*)vector)[10])), UINT2NUM((uint8_t)(((cl_uchar*)vector)[9])), UINT2NUM((uint8_t)(((cl_uchar*)vector)[8])), UINT2NUM((uint8_t)(((cl_uchar*)vector)[7])), UINT2NUM((uint8_t)(((cl_uchar*)vector)[6])), UINT2NUM((uint8_t)(((cl_uchar*)vector)[5])), UINT2NUM((uint8_t)(((cl_uchar*)vector)[4])), UINT2NUM((uint8_t)(((cl_uchar*)vector)[3])), UINT2NUM((uint8_t)(((cl_uchar*)vector)[2])), UINT2NUM((uint8_t)(((cl_uchar*)vector)[1])), UINT2NUM((uint8_t)(((cl_uchar*)vector)[0])));
#endif
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
      for (n=0; n<(int)2; n++)
#ifdef CL_BIG_ENDIAN
        ((cl_short*)vector)[n] = (int16_t)NUM2INT(ptr[n]);
#else
        ((cl_short*)vector)[n] = (int16_t)NUM2INT(ptr[1-n]);
#endif
    }
  } else if (argc == 2) {
      for (n=0; n<(int)2; n++)
#ifdef CL_BIG_ENDIAN
        ((cl_short*)vector)[n] = (int16_t)NUM2INT(argv[n]);
#else
        ((cl_short*)vector)[n] = (int16_t)NUM2INT(argv[1-n]);
#endif
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
#ifdef CL_BIG_ENDIAN
  return rb_ary_new3(2, INT2NUM((int16_t)(((cl_short*)vector)[0])), INT2NUM((int16_t)(((cl_short*)vector)[1])));
#else
  return rb_ary_new3(2, INT2NUM((int16_t)(((cl_short*)vector)[1])), INT2NUM((int16_t)(((cl_short*)vector)[0])));
#endif
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
      for (n=0; n<(int)4; n++)
#ifdef CL_BIG_ENDIAN
        ((cl_short*)vector)[n] = (int16_t)NUM2INT(ptr[n]);
#else
        ((cl_short*)vector)[n] = (int16_t)NUM2INT(ptr[3-n]);
#endif
    }
  } else if (argc == 4) {
      for (n=0; n<(int)4; n++)
#ifdef CL_BIG_ENDIAN
        ((cl_short*)vector)[n] = (int16_t)NUM2INT(argv[n]);
#else
        ((cl_short*)vector)[n] = (int16_t)NUM2INT(argv[3-n]);
#endif
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
#ifdef CL_BIG_ENDIAN
  return rb_ary_new3(4, INT2NUM((int16_t)(((cl_short*)vector)[0])), INT2NUM((int16_t)(((cl_short*)vector)[1])), INT2NUM((int16_t)(((cl_short*)vector)[2])), INT2NUM((int16_t)(((cl_short*)vector)[3])));
#else
  return rb_ary_new3(4, INT2NUM((int16_t)(((cl_short*)vector)[3])), INT2NUM((int16_t)(((cl_short*)vector)[2])), INT2NUM((int16_t)(((cl_short*)vector)[1])), INT2NUM((int16_t)(((cl_short*)vector)[0])));
#endif
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
      for (n=0; n<(int)8; n++)
#ifdef CL_BIG_ENDIAN
        ((cl_short*)vector)[n] = (int16_t)NUM2INT(ptr[n]);
#else
        ((cl_short*)vector)[n] = (int16_t)NUM2INT(ptr[7-n]);
#endif
    }
  } else if (argc == 8) {
      for (n=0; n<(int)8; n++)
#ifdef CL_BIG_ENDIAN
        ((cl_short*)vector)[n] = (int16_t)NUM2INT(argv[n]);
#else
        ((cl_short*)vector)[n] = (int16_t)NUM2INT(argv[7-n]);
#endif
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
#ifdef CL_BIG_ENDIAN
  return rb_ary_new3(8, INT2NUM((int16_t)(((cl_short*)vector)[0])), INT2NUM((int16_t)(((cl_short*)vector)[1])), INT2NUM((int16_t)(((cl_short*)vector)[2])), INT2NUM((int16_t)(((cl_short*)vector)[3])), INT2NUM((int16_t)(((cl_short*)vector)[4])), INT2NUM((int16_t)(((cl_short*)vector)[5])), INT2NUM((int16_t)(((cl_short*)vector)[6])), INT2NUM((int16_t)(((cl_short*)vector)[7])));
#else
  return rb_ary_new3(8, INT2NUM((int16_t)(((cl_short*)vector)[7])), INT2NUM((int16_t)(((cl_short*)vector)[6])), INT2NUM((int16_t)(((cl_short*)vector)[5])), INT2NUM((int16_t)(((cl_short*)vector)[4])), INT2NUM((int16_t)(((cl_short*)vector)[3])), INT2NUM((int16_t)(((cl_short*)vector)[2])), INT2NUM((int16_t)(((cl_short*)vector)[1])), INT2NUM((int16_t)(((cl_short*)vector)[0])));
#endif
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
      for (n=0; n<(int)16; n++)
#ifdef CL_BIG_ENDIAN
        ((cl_short*)vector)[n] = (int16_t)NUM2INT(ptr[n]);
#else
        ((cl_short*)vector)[n] = (int16_t)NUM2INT(ptr[15-n]);
#endif
    }
  } else if (argc == 16) {
      for (n=0; n<(int)16; n++)
#ifdef CL_BIG_ENDIAN
        ((cl_short*)vector)[n] = (int16_t)NUM2INT(argv[n]);
#else
        ((cl_short*)vector)[n] = (int16_t)NUM2INT(argv[15-n]);
#endif
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
#ifdef CL_BIG_ENDIAN
  return rb_ary_new3(16, INT2NUM((int16_t)(((cl_short*)vector)[0])), INT2NUM((int16_t)(((cl_short*)vector)[1])), INT2NUM((int16_t)(((cl_short*)vector)[2])), INT2NUM((int16_t)(((cl_short*)vector)[3])), INT2NUM((int16_t)(((cl_short*)vector)[4])), INT2NUM((int16_t)(((cl_short*)vector)[5])), INT2NUM((int16_t)(((cl_short*)vector)[6])), INT2NUM((int16_t)(((cl_short*)vector)[7])), INT2NUM((int16_t)(((cl_short*)vector)[8])), INT2NUM((int16_t)(((cl_short*)vector)[9])), INT2NUM((int16_t)(((cl_short*)vector)[10])), INT2NUM((int16_t)(((cl_short*)vector)[11])), INT2NUM((int16_t)(((cl_short*)vector)[12])), INT2NUM((int16_t)(((cl_short*)vector)[13])), INT2NUM((int16_t)(((cl_short*)vector)[14])), INT2NUM((int16_t)(((cl_short*)vector)[15])));
#else
  return rb_ary_new3(16, INT2NUM((int16_t)(((cl_short*)vector)[15])), INT2NUM((int16_t)(((cl_short*)vector)[14])), INT2NUM((int16_t)(((cl_short*)vector)[13])), INT2NUM((int16_t)(((cl_short*)vector)[12])), INT2NUM((int16_t)(((cl_short*)vector)[11])), INT2NUM((int16_t)(((cl_short*)vector)[10])), INT2NUM((int16_t)(((cl_short*)vector)[9])), INT2NUM((int16_t)(((cl_short*)vector)[8])), INT2NUM((int16_t)(((cl_short*)vector)[7])), INT2NUM((int16_t)(((cl_short*)vector)[6])), INT2NUM((int16_t)(((cl_short*)vector)[5])), INT2NUM((int16_t)(((cl_short*)vector)[4])), INT2NUM((int16_t)(((cl_short*)vector)[3])), INT2NUM((int16_t)(((cl_short*)vector)[2])), INT2NUM((int16_t)(((cl_short*)vector)[1])), INT2NUM((int16_t)(((cl_short*)vector)[0])));
#endif
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
      for (n=0; n<(int)2; n++)
#ifdef CL_BIG_ENDIAN
        ((cl_ushort*)vector)[n] = (uint16_t)NUM2UINT(ptr[n]);
#else
        ((cl_ushort*)vector)[n] = (uint16_t)NUM2UINT(ptr[1-n]);
#endif
    }
  } else if (argc == 2) {
      for (n=0; n<(int)2; n++)
#ifdef CL_BIG_ENDIAN
        ((cl_ushort*)vector)[n] = (uint16_t)NUM2UINT(argv[n]);
#else
        ((cl_ushort*)vector)[n] = (uint16_t)NUM2UINT(argv[1-n]);
#endif
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
#ifdef CL_BIG_ENDIAN
  return rb_ary_new3(2, UINT2NUM((uint16_t)(((cl_ushort*)vector)[0])), UINT2NUM((uint16_t)(((cl_ushort*)vector)[1])));
#else
  return rb_ary_new3(2, UINT2NUM((uint16_t)(((cl_ushort*)vector)[1])), UINT2NUM((uint16_t)(((cl_ushort*)vector)[0])));
#endif
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
      for (n=0; n<(int)4; n++)
#ifdef CL_BIG_ENDIAN
        ((cl_ushort*)vector)[n] = (uint16_t)NUM2UINT(ptr[n]);
#else
        ((cl_ushort*)vector)[n] = (uint16_t)NUM2UINT(ptr[3-n]);
#endif
    }
  } else if (argc == 4) {
      for (n=0; n<(int)4; n++)
#ifdef CL_BIG_ENDIAN
        ((cl_ushort*)vector)[n] = (uint16_t)NUM2UINT(argv[n]);
#else
        ((cl_ushort*)vector)[n] = (uint16_t)NUM2UINT(argv[3-n]);
#endif
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
#ifdef CL_BIG_ENDIAN
  return rb_ary_new3(4, UINT2NUM((uint16_t)(((cl_ushort*)vector)[0])), UINT2NUM((uint16_t)(((cl_ushort*)vector)[1])), UINT2NUM((uint16_t)(((cl_ushort*)vector)[2])), UINT2NUM((uint16_t)(((cl_ushort*)vector)[3])));
#else
  return rb_ary_new3(4, UINT2NUM((uint16_t)(((cl_ushort*)vector)[3])), UINT2NUM((uint16_t)(((cl_ushort*)vector)[2])), UINT2NUM((uint16_t)(((cl_ushort*)vector)[1])), UINT2NUM((uint16_t)(((cl_ushort*)vector)[0])));
#endif
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
      for (n=0; n<(int)8; n++)
#ifdef CL_BIG_ENDIAN
        ((cl_ushort*)vector)[n] = (uint16_t)NUM2UINT(ptr[n]);
#else
        ((cl_ushort*)vector)[n] = (uint16_t)NUM2UINT(ptr[7-n]);
#endif
    }
  } else if (argc == 8) {
      for (n=0; n<(int)8; n++)
#ifdef CL_BIG_ENDIAN
        ((cl_ushort*)vector)[n] = (uint16_t)NUM2UINT(argv[n]);
#else
        ((cl_ushort*)vector)[n] = (uint16_t)NUM2UINT(argv[7-n]);
#endif
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
#ifdef CL_BIG_ENDIAN
  return rb_ary_new3(8, UINT2NUM((uint16_t)(((cl_ushort*)vector)[0])), UINT2NUM((uint16_t)(((cl_ushort*)vector)[1])), UINT2NUM((uint16_t)(((cl_ushort*)vector)[2])), UINT2NUM((uint16_t)(((cl_ushort*)vector)[3])), UINT2NUM((uint16_t)(((cl_ushort*)vector)[4])), UINT2NUM((uint16_t)(((cl_ushort*)vector)[5])), UINT2NUM((uint16_t)(((cl_ushort*)vector)[6])), UINT2NUM((uint16_t)(((cl_ushort*)vector)[7])));
#else
  return rb_ary_new3(8, UINT2NUM((uint16_t)(((cl_ushort*)vector)[7])), UINT2NUM((uint16_t)(((cl_ushort*)vector)[6])), UINT2NUM((uint16_t)(((cl_ushort*)vector)[5])), UINT2NUM((uint16_t)(((cl_ushort*)vector)[4])), UINT2NUM((uint16_t)(((cl_ushort*)vector)[3])), UINT2NUM((uint16_t)(((cl_ushort*)vector)[2])), UINT2NUM((uint16_t)(((cl_ushort*)vector)[1])), UINT2NUM((uint16_t)(((cl_ushort*)vector)[0])));
#endif
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
      for (n=0; n<(int)16; n++)
#ifdef CL_BIG_ENDIAN
        ((cl_ushort*)vector)[n] = (uint16_t)NUM2UINT(ptr[n]);
#else
        ((cl_ushort*)vector)[n] = (uint16_t)NUM2UINT(ptr[15-n]);
#endif
    }
  } else if (argc == 16) {
      for (n=0; n<(int)16; n++)
#ifdef CL_BIG_ENDIAN
        ((cl_ushort*)vector)[n] = (uint16_t)NUM2UINT(argv[n]);
#else
        ((cl_ushort*)vector)[n] = (uint16_t)NUM2UINT(argv[15-n]);
#endif
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
#ifdef CL_BIG_ENDIAN
  return rb_ary_new3(16, UINT2NUM((uint16_t)(((cl_ushort*)vector)[0])), UINT2NUM((uint16_t)(((cl_ushort*)vector)[1])), UINT2NUM((uint16_t)(((cl_ushort*)vector)[2])), UINT2NUM((uint16_t)(((cl_ushort*)vector)[3])), UINT2NUM((uint16_t)(((cl_ushort*)vector)[4])), UINT2NUM((uint16_t)(((cl_ushort*)vector)[5])), UINT2NUM((uint16_t)(((cl_ushort*)vector)[6])), UINT2NUM((uint16_t)(((cl_ushort*)vector)[7])), UINT2NUM((uint16_t)(((cl_ushort*)vector)[8])), UINT2NUM((uint16_t)(((cl_ushort*)vector)[9])), UINT2NUM((uint16_t)(((cl_ushort*)vector)[10])), UINT2NUM((uint16_t)(((cl_ushort*)vector)[11])), UINT2NUM((uint16_t)(((cl_ushort*)vector)[12])), UINT2NUM((uint16_t)(((cl_ushort*)vector)[13])), UINT2NUM((uint16_t)(((cl_ushort*)vector)[14])), UINT2NUM((uint16_t)(((cl_ushort*)vector)[15])));
#else
  return rb_ary_new3(16, UINT2NUM((uint16_t)(((cl_ushort*)vector)[15])), UINT2NUM((uint16_t)(((cl_ushort*)vector)[14])), UINT2NUM((uint16_t)(((cl_ushort*)vector)[13])), UINT2NUM((uint16_t)(((cl_ushort*)vector)[12])), UINT2NUM((uint16_t)(((cl_ushort*)vector)[11])), UINT2NUM((uint16_t)(((cl_ushort*)vector)[10])), UINT2NUM((uint16_t)(((cl_ushort*)vector)[9])), UINT2NUM((uint16_t)(((cl_ushort*)vector)[8])), UINT2NUM((uint16_t)(((cl_ushort*)vector)[7])), UINT2NUM((uint16_t)(((cl_ushort*)vector)[6])), UINT2NUM((uint16_t)(((cl_ushort*)vector)[5])), UINT2NUM((uint16_t)(((cl_ushort*)vector)[4])), UINT2NUM((uint16_t)(((cl_ushort*)vector)[3])), UINT2NUM((uint16_t)(((cl_ushort*)vector)[2])), UINT2NUM((uint16_t)(((cl_ushort*)vector)[1])), UINT2NUM((uint16_t)(((cl_ushort*)vector)[0])));
#endif
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
      for (n=0; n<(int)2; n++)
#ifdef CL_BIG_ENDIAN
        ((cl_int*)vector)[n] = (int32_t)NUM2INT(ptr[n]);
#else
        ((cl_int*)vector)[n] = (int32_t)NUM2INT(ptr[1-n]);
#endif
    }
  } else if (argc == 2) {
      for (n=0; n<(int)2; n++)
#ifdef CL_BIG_ENDIAN
        ((cl_int*)vector)[n] = (int32_t)NUM2INT(argv[n]);
#else
        ((cl_int*)vector)[n] = (int32_t)NUM2INT(argv[1-n]);
#endif
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
#ifdef CL_BIG_ENDIAN
  return rb_ary_new3(2, INT2NUM((int32_t)(((cl_int*)vector)[0])), INT2NUM((int32_t)(((cl_int*)vector)[1])));
#else
  return rb_ary_new3(2, INT2NUM((int32_t)(((cl_int*)vector)[1])), INT2NUM((int32_t)(((cl_int*)vector)[0])));
#endif
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
      for (n=0; n<(int)4; n++)
#ifdef CL_BIG_ENDIAN
        ((cl_int*)vector)[n] = (int32_t)NUM2INT(ptr[n]);
#else
        ((cl_int*)vector)[n] = (int32_t)NUM2INT(ptr[3-n]);
#endif
    }
  } else if (argc == 4) {
      for (n=0; n<(int)4; n++)
#ifdef CL_BIG_ENDIAN
        ((cl_int*)vector)[n] = (int32_t)NUM2INT(argv[n]);
#else
        ((cl_int*)vector)[n] = (int32_t)NUM2INT(argv[3-n]);
#endif
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
#ifdef CL_BIG_ENDIAN
  return rb_ary_new3(4, INT2NUM((int32_t)(((cl_int*)vector)[0])), INT2NUM((int32_t)(((cl_int*)vector)[1])), INT2NUM((int32_t)(((cl_int*)vector)[2])), INT2NUM((int32_t)(((cl_int*)vector)[3])));
#else
  return rb_ary_new3(4, INT2NUM((int32_t)(((cl_int*)vector)[3])), INT2NUM((int32_t)(((cl_int*)vector)[2])), INT2NUM((int32_t)(((cl_int*)vector)[1])), INT2NUM((int32_t)(((cl_int*)vector)[0])));
#endif
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
      for (n=0; n<(int)8; n++)
#ifdef CL_BIG_ENDIAN
        ((cl_int*)vector)[n] = (int32_t)NUM2INT(ptr[n]);
#else
        ((cl_int*)vector)[n] = (int32_t)NUM2INT(ptr[7-n]);
#endif
    }
  } else if (argc == 8) {
      for (n=0; n<(int)8; n++)
#ifdef CL_BIG_ENDIAN
        ((cl_int*)vector)[n] = (int32_t)NUM2INT(argv[n]);
#else
        ((cl_int*)vector)[n] = (int32_t)NUM2INT(argv[7-n]);
#endif
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
#ifdef CL_BIG_ENDIAN
  return rb_ary_new3(8, INT2NUM((int32_t)(((cl_int*)vector)[0])), INT2NUM((int32_t)(((cl_int*)vector)[1])), INT2NUM((int32_t)(((cl_int*)vector)[2])), INT2NUM((int32_t)(((cl_int*)vector)[3])), INT2NUM((int32_t)(((cl_int*)vector)[4])), INT2NUM((int32_t)(((cl_int*)vector)[5])), INT2NUM((int32_t)(((cl_int*)vector)[6])), INT2NUM((int32_t)(((cl_int*)vector)[7])));
#else
  return rb_ary_new3(8, INT2NUM((int32_t)(((cl_int*)vector)[7])), INT2NUM((int32_t)(((cl_int*)vector)[6])), INT2NUM((int32_t)(((cl_int*)vector)[5])), INT2NUM((int32_t)(((cl_int*)vector)[4])), INT2NUM((int32_t)(((cl_int*)vector)[3])), INT2NUM((int32_t)(((cl_int*)vector)[2])), INT2NUM((int32_t)(((cl_int*)vector)[1])), INT2NUM((int32_t)(((cl_int*)vector)[0])));
#endif
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
      for (n=0; n<(int)16; n++)
#ifdef CL_BIG_ENDIAN
        ((cl_int*)vector)[n] = (int32_t)NUM2INT(ptr[n]);
#else
        ((cl_int*)vector)[n] = (int32_t)NUM2INT(ptr[15-n]);
#endif
    }
  } else if (argc == 16) {
      for (n=0; n<(int)16; n++)
#ifdef CL_BIG_ENDIAN
        ((cl_int*)vector)[n] = (int32_t)NUM2INT(argv[n]);
#else
        ((cl_int*)vector)[n] = (int32_t)NUM2INT(argv[15-n]);
#endif
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
#ifdef CL_BIG_ENDIAN
  return rb_ary_new3(16, INT2NUM((int32_t)(((cl_int*)vector)[0])), INT2NUM((int32_t)(((cl_int*)vector)[1])), INT2NUM((int32_t)(((cl_int*)vector)[2])), INT2NUM((int32_t)(((cl_int*)vector)[3])), INT2NUM((int32_t)(((cl_int*)vector)[4])), INT2NUM((int32_t)(((cl_int*)vector)[5])), INT2NUM((int32_t)(((cl_int*)vector)[6])), INT2NUM((int32_t)(((cl_int*)vector)[7])), INT2NUM((int32_t)(((cl_int*)vector)[8])), INT2NUM((int32_t)(((cl_int*)vector)[9])), INT2NUM((int32_t)(((cl_int*)vector)[10])), INT2NUM((int32_t)(((cl_int*)vector)[11])), INT2NUM((int32_t)(((cl_int*)vector)[12])), INT2NUM((int32_t)(((cl_int*)vector)[13])), INT2NUM((int32_t)(((cl_int*)vector)[14])), INT2NUM((int32_t)(((cl_int*)vector)[15])));
#else
  return rb_ary_new3(16, INT2NUM((int32_t)(((cl_int*)vector)[15])), INT2NUM((int32_t)(((cl_int*)vector)[14])), INT2NUM((int32_t)(((cl_int*)vector)[13])), INT2NUM((int32_t)(((cl_int*)vector)[12])), INT2NUM((int32_t)(((cl_int*)vector)[11])), INT2NUM((int32_t)(((cl_int*)vector)[10])), INT2NUM((int32_t)(((cl_int*)vector)[9])), INT2NUM((int32_t)(((cl_int*)vector)[8])), INT2NUM((int32_t)(((cl_int*)vector)[7])), INT2NUM((int32_t)(((cl_int*)vector)[6])), INT2NUM((int32_t)(((cl_int*)vector)[5])), INT2NUM((int32_t)(((cl_int*)vector)[4])), INT2NUM((int32_t)(((cl_int*)vector)[3])), INT2NUM((int32_t)(((cl_int*)vector)[2])), INT2NUM((int32_t)(((cl_int*)vector)[1])), INT2NUM((int32_t)(((cl_int*)vector)[0])));
#endif
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
      for (n=0; n<(int)2; n++)
#ifdef CL_BIG_ENDIAN
        ((cl_uint*)vector)[n] = (uint32_t)NUM2UINT(ptr[n]);
#else
        ((cl_uint*)vector)[n] = (uint32_t)NUM2UINT(ptr[1-n]);
#endif
    }
  } else if (argc == 2) {
      for (n=0; n<(int)2; n++)
#ifdef CL_BIG_ENDIAN
        ((cl_uint*)vector)[n] = (uint32_t)NUM2UINT(argv[n]);
#else
        ((cl_uint*)vector)[n] = (uint32_t)NUM2UINT(argv[1-n]);
#endif
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
#ifdef CL_BIG_ENDIAN
  return rb_ary_new3(2, UINT2NUM((uint32_t)(((cl_uint*)vector)[0])), UINT2NUM((uint32_t)(((cl_uint*)vector)[1])));
#else
  return rb_ary_new3(2, UINT2NUM((uint32_t)(((cl_uint*)vector)[1])), UINT2NUM((uint32_t)(((cl_uint*)vector)[0])));
#endif
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
      for (n=0; n<(int)4; n++)
#ifdef CL_BIG_ENDIAN
        ((cl_uint*)vector)[n] = (uint32_t)NUM2UINT(ptr[n]);
#else
        ((cl_uint*)vector)[n] = (uint32_t)NUM2UINT(ptr[3-n]);
#endif
    }
  } else if (argc == 4) {
      for (n=0; n<(int)4; n++)
#ifdef CL_BIG_ENDIAN
        ((cl_uint*)vector)[n] = (uint32_t)NUM2UINT(argv[n]);
#else
        ((cl_uint*)vector)[n] = (uint32_t)NUM2UINT(argv[3-n]);
#endif
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
#ifdef CL_BIG_ENDIAN
  return rb_ary_new3(4, UINT2NUM((uint32_t)(((cl_uint*)vector)[0])), UINT2NUM((uint32_t)(((cl_uint*)vector)[1])), UINT2NUM((uint32_t)(((cl_uint*)vector)[2])), UINT2NUM((uint32_t)(((cl_uint*)vector)[3])));
#else
  return rb_ary_new3(4, UINT2NUM((uint32_t)(((cl_uint*)vector)[3])), UINT2NUM((uint32_t)(((cl_uint*)vector)[2])), UINT2NUM((uint32_t)(((cl_uint*)vector)[1])), UINT2NUM((uint32_t)(((cl_uint*)vector)[0])));
#endif
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
      for (n=0; n<(int)8; n++)
#ifdef CL_BIG_ENDIAN
        ((cl_uint*)vector)[n] = (uint32_t)NUM2UINT(ptr[n]);
#else
        ((cl_uint*)vector)[n] = (uint32_t)NUM2UINT(ptr[7-n]);
#endif
    }
  } else if (argc == 8) {
      for (n=0; n<(int)8; n++)
#ifdef CL_BIG_ENDIAN
        ((cl_uint*)vector)[n] = (uint32_t)NUM2UINT(argv[n]);
#else
        ((cl_uint*)vector)[n] = (uint32_t)NUM2UINT(argv[7-n]);
#endif
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
#ifdef CL_BIG_ENDIAN
  return rb_ary_new3(8, UINT2NUM((uint32_t)(((cl_uint*)vector)[0])), UINT2NUM((uint32_t)(((cl_uint*)vector)[1])), UINT2NUM((uint32_t)(((cl_uint*)vector)[2])), UINT2NUM((uint32_t)(((cl_uint*)vector)[3])), UINT2NUM((uint32_t)(((cl_uint*)vector)[4])), UINT2NUM((uint32_t)(((cl_uint*)vector)[5])), UINT2NUM((uint32_t)(((cl_uint*)vector)[6])), UINT2NUM((uint32_t)(((cl_uint*)vector)[7])));
#else
  return rb_ary_new3(8, UINT2NUM((uint32_t)(((cl_uint*)vector)[7])), UINT2NUM((uint32_t)(((cl_uint*)vector)[6])), UINT2NUM((uint32_t)(((cl_uint*)vector)[5])), UINT2NUM((uint32_t)(((cl_uint*)vector)[4])), UINT2NUM((uint32_t)(((cl_uint*)vector)[3])), UINT2NUM((uint32_t)(((cl_uint*)vector)[2])), UINT2NUM((uint32_t)(((cl_uint*)vector)[1])), UINT2NUM((uint32_t)(((cl_uint*)vector)[0])));
#endif
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
      for (n=0; n<(int)16; n++)
#ifdef CL_BIG_ENDIAN
        ((cl_uint*)vector)[n] = (uint32_t)NUM2UINT(ptr[n]);
#else
        ((cl_uint*)vector)[n] = (uint32_t)NUM2UINT(ptr[15-n]);
#endif
    }
  } else if (argc == 16) {
      for (n=0; n<(int)16; n++)
#ifdef CL_BIG_ENDIAN
        ((cl_uint*)vector)[n] = (uint32_t)NUM2UINT(argv[n]);
#else
        ((cl_uint*)vector)[n] = (uint32_t)NUM2UINT(argv[15-n]);
#endif
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
#ifdef CL_BIG_ENDIAN
  return rb_ary_new3(16, UINT2NUM((uint32_t)(((cl_uint*)vector)[0])), UINT2NUM((uint32_t)(((cl_uint*)vector)[1])), UINT2NUM((uint32_t)(((cl_uint*)vector)[2])), UINT2NUM((uint32_t)(((cl_uint*)vector)[3])), UINT2NUM((uint32_t)(((cl_uint*)vector)[4])), UINT2NUM((uint32_t)(((cl_uint*)vector)[5])), UINT2NUM((uint32_t)(((cl_uint*)vector)[6])), UINT2NUM((uint32_t)(((cl_uint*)vector)[7])), UINT2NUM((uint32_t)(((cl_uint*)vector)[8])), UINT2NUM((uint32_t)(((cl_uint*)vector)[9])), UINT2NUM((uint32_t)(((cl_uint*)vector)[10])), UINT2NUM((uint32_t)(((cl_uint*)vector)[11])), UINT2NUM((uint32_t)(((cl_uint*)vector)[12])), UINT2NUM((uint32_t)(((cl_uint*)vector)[13])), UINT2NUM((uint32_t)(((cl_uint*)vector)[14])), UINT2NUM((uint32_t)(((cl_uint*)vector)[15])));
#else
  return rb_ary_new3(16, UINT2NUM((uint32_t)(((cl_uint*)vector)[15])), UINT2NUM((uint32_t)(((cl_uint*)vector)[14])), UINT2NUM((uint32_t)(((cl_uint*)vector)[13])), UINT2NUM((uint32_t)(((cl_uint*)vector)[12])), UINT2NUM((uint32_t)(((cl_uint*)vector)[11])), UINT2NUM((uint32_t)(((cl_uint*)vector)[10])), UINT2NUM((uint32_t)(((cl_uint*)vector)[9])), UINT2NUM((uint32_t)(((cl_uint*)vector)[8])), UINT2NUM((uint32_t)(((cl_uint*)vector)[7])), UINT2NUM((uint32_t)(((cl_uint*)vector)[6])), UINT2NUM((uint32_t)(((cl_uint*)vector)[5])), UINT2NUM((uint32_t)(((cl_uint*)vector)[4])), UINT2NUM((uint32_t)(((cl_uint*)vector)[3])), UINT2NUM((uint32_t)(((cl_uint*)vector)[2])), UINT2NUM((uint32_t)(((cl_uint*)vector)[1])), UINT2NUM((uint32_t)(((cl_uint*)vector)[0])));
#endif
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
      for (n=0; n<(int)2; n++)
#ifdef CL_BIG_ENDIAN
        ((cl_long*)vector)[n] = NUM2LONG(ptr[n]);
#else
        ((cl_long*)vector)[n] = NUM2LONG(ptr[1-n]);
#endif
    }
  } else if (argc == 2) {
      for (n=0; n<(int)2; n++)
#ifdef CL_BIG_ENDIAN
        ((cl_long*)vector)[n] = NUM2LONG(argv[n]);
#else
        ((cl_long*)vector)[n] = NUM2LONG(argv[1-n]);
#endif
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
#ifdef CL_BIG_ENDIAN
  return rb_ary_new3(2, LONG2NUM((int64_t)(((cl_long*)vector)[0])), LONG2NUM((int64_t)(((cl_long*)vector)[1])));
#else
  return rb_ary_new3(2, LONG2NUM((int64_t)(((cl_long*)vector)[1])), LONG2NUM((int64_t)(((cl_long*)vector)[0])));
#endif
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
      for (n=0; n<(int)4; n++)
#ifdef CL_BIG_ENDIAN
        ((cl_long*)vector)[n] = NUM2LONG(ptr[n]);
#else
        ((cl_long*)vector)[n] = NUM2LONG(ptr[3-n]);
#endif
    }
  } else if (argc == 4) {
      for (n=0; n<(int)4; n++)
#ifdef CL_BIG_ENDIAN
        ((cl_long*)vector)[n] = NUM2LONG(argv[n]);
#else
        ((cl_long*)vector)[n] = NUM2LONG(argv[3-n]);
#endif
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
#ifdef CL_BIG_ENDIAN
  return rb_ary_new3(4, LONG2NUM((int64_t)(((cl_long*)vector)[0])), LONG2NUM((int64_t)(((cl_long*)vector)[1])), LONG2NUM((int64_t)(((cl_long*)vector)[2])), LONG2NUM((int64_t)(((cl_long*)vector)[3])));
#else
  return rb_ary_new3(4, LONG2NUM((int64_t)(((cl_long*)vector)[3])), LONG2NUM((int64_t)(((cl_long*)vector)[2])), LONG2NUM((int64_t)(((cl_long*)vector)[1])), LONG2NUM((int64_t)(((cl_long*)vector)[0])));
#endif
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
      for (n=0; n<(int)8; n++)
#ifdef CL_BIG_ENDIAN
        ((cl_long*)vector)[n] = NUM2LONG(ptr[n]);
#else
        ((cl_long*)vector)[n] = NUM2LONG(ptr[7-n]);
#endif
    }
  } else if (argc == 8) {
      for (n=0; n<(int)8; n++)
#ifdef CL_BIG_ENDIAN
        ((cl_long*)vector)[n] = NUM2LONG(argv[n]);
#else
        ((cl_long*)vector)[n] = NUM2LONG(argv[7-n]);
#endif
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
#ifdef CL_BIG_ENDIAN
  return rb_ary_new3(8, LONG2NUM((int64_t)(((cl_long*)vector)[0])), LONG2NUM((int64_t)(((cl_long*)vector)[1])), LONG2NUM((int64_t)(((cl_long*)vector)[2])), LONG2NUM((int64_t)(((cl_long*)vector)[3])), LONG2NUM((int64_t)(((cl_long*)vector)[4])), LONG2NUM((int64_t)(((cl_long*)vector)[5])), LONG2NUM((int64_t)(((cl_long*)vector)[6])), LONG2NUM((int64_t)(((cl_long*)vector)[7])));
#else
  return rb_ary_new3(8, LONG2NUM((int64_t)(((cl_long*)vector)[7])), LONG2NUM((int64_t)(((cl_long*)vector)[6])), LONG2NUM((int64_t)(((cl_long*)vector)[5])), LONG2NUM((int64_t)(((cl_long*)vector)[4])), LONG2NUM((int64_t)(((cl_long*)vector)[3])), LONG2NUM((int64_t)(((cl_long*)vector)[2])), LONG2NUM((int64_t)(((cl_long*)vector)[1])), LONG2NUM((int64_t)(((cl_long*)vector)[0])));
#endif
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
      for (n=0; n<(int)16; n++)
#ifdef CL_BIG_ENDIAN
        ((cl_long*)vector)[n] = NUM2LONG(ptr[n]);
#else
        ((cl_long*)vector)[n] = NUM2LONG(ptr[15-n]);
#endif
    }
  } else if (argc == 16) {
      for (n=0; n<(int)16; n++)
#ifdef CL_BIG_ENDIAN
        ((cl_long*)vector)[n] = NUM2LONG(argv[n]);
#else
        ((cl_long*)vector)[n] = NUM2LONG(argv[15-n]);
#endif
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
#ifdef CL_BIG_ENDIAN
  return rb_ary_new3(16, LONG2NUM((int64_t)(((cl_long*)vector)[0])), LONG2NUM((int64_t)(((cl_long*)vector)[1])), LONG2NUM((int64_t)(((cl_long*)vector)[2])), LONG2NUM((int64_t)(((cl_long*)vector)[3])), LONG2NUM((int64_t)(((cl_long*)vector)[4])), LONG2NUM((int64_t)(((cl_long*)vector)[5])), LONG2NUM((int64_t)(((cl_long*)vector)[6])), LONG2NUM((int64_t)(((cl_long*)vector)[7])), LONG2NUM((int64_t)(((cl_long*)vector)[8])), LONG2NUM((int64_t)(((cl_long*)vector)[9])), LONG2NUM((int64_t)(((cl_long*)vector)[10])), LONG2NUM((int64_t)(((cl_long*)vector)[11])), LONG2NUM((int64_t)(((cl_long*)vector)[12])), LONG2NUM((int64_t)(((cl_long*)vector)[13])), LONG2NUM((int64_t)(((cl_long*)vector)[14])), LONG2NUM((int64_t)(((cl_long*)vector)[15])));
#else
  return rb_ary_new3(16, LONG2NUM((int64_t)(((cl_long*)vector)[15])), LONG2NUM((int64_t)(((cl_long*)vector)[14])), LONG2NUM((int64_t)(((cl_long*)vector)[13])), LONG2NUM((int64_t)(((cl_long*)vector)[12])), LONG2NUM((int64_t)(((cl_long*)vector)[11])), LONG2NUM((int64_t)(((cl_long*)vector)[10])), LONG2NUM((int64_t)(((cl_long*)vector)[9])), LONG2NUM((int64_t)(((cl_long*)vector)[8])), LONG2NUM((int64_t)(((cl_long*)vector)[7])), LONG2NUM((int64_t)(((cl_long*)vector)[6])), LONG2NUM((int64_t)(((cl_long*)vector)[5])), LONG2NUM((int64_t)(((cl_long*)vector)[4])), LONG2NUM((int64_t)(((cl_long*)vector)[3])), LONG2NUM((int64_t)(((cl_long*)vector)[2])), LONG2NUM((int64_t)(((cl_long*)vector)[1])), LONG2NUM((int64_t)(((cl_long*)vector)[0])));
#endif
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
      for (n=0; n<(int)2; n++)
#ifdef CL_BIG_ENDIAN
        ((cl_ulong*)vector)[n] = (uint64_t)NUM2ULONG(ptr[n]);
#else
        ((cl_ulong*)vector)[n] = (uint64_t)NUM2ULONG(ptr[1-n]);
#endif
    }
  } else if (argc == 2) {
      for (n=0; n<(int)2; n++)
#ifdef CL_BIG_ENDIAN
        ((cl_ulong*)vector)[n] = (uint64_t)NUM2ULONG(argv[n]);
#else
        ((cl_ulong*)vector)[n] = (uint64_t)NUM2ULONG(argv[1-n]);
#endif
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
#ifdef CL_BIG_ENDIAN
  return rb_ary_new3(2, ULONG2NUM((uint64_t)(((cl_ulong*)vector)[0])), ULONG2NUM((uint64_t)(((cl_ulong*)vector)[1])));
#else
  return rb_ary_new3(2, ULONG2NUM((uint64_t)(((cl_ulong*)vector)[1])), ULONG2NUM((uint64_t)(((cl_ulong*)vector)[0])));
#endif
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
      for (n=0; n<(int)4; n++)
#ifdef CL_BIG_ENDIAN
        ((cl_ulong*)vector)[n] = (uint64_t)NUM2ULONG(ptr[n]);
#else
        ((cl_ulong*)vector)[n] = (uint64_t)NUM2ULONG(ptr[3-n]);
#endif
    }
  } else if (argc == 4) {
      for (n=0; n<(int)4; n++)
#ifdef CL_BIG_ENDIAN
        ((cl_ulong*)vector)[n] = (uint64_t)NUM2ULONG(argv[n]);
#else
        ((cl_ulong*)vector)[n] = (uint64_t)NUM2ULONG(argv[3-n]);
#endif
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
#ifdef CL_BIG_ENDIAN
  return rb_ary_new3(4, ULONG2NUM((uint64_t)(((cl_ulong*)vector)[0])), ULONG2NUM((uint64_t)(((cl_ulong*)vector)[1])), ULONG2NUM((uint64_t)(((cl_ulong*)vector)[2])), ULONG2NUM((uint64_t)(((cl_ulong*)vector)[3])));
#else
  return rb_ary_new3(4, ULONG2NUM((uint64_t)(((cl_ulong*)vector)[3])), ULONG2NUM((uint64_t)(((cl_ulong*)vector)[2])), ULONG2NUM((uint64_t)(((cl_ulong*)vector)[1])), ULONG2NUM((uint64_t)(((cl_ulong*)vector)[0])));
#endif
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
      for (n=0; n<(int)8; n++)
#ifdef CL_BIG_ENDIAN
        ((cl_ulong*)vector)[n] = (uint64_t)NUM2ULONG(ptr[n]);
#else
        ((cl_ulong*)vector)[n] = (uint64_t)NUM2ULONG(ptr[7-n]);
#endif
    }
  } else if (argc == 8) {
      for (n=0; n<(int)8; n++)
#ifdef CL_BIG_ENDIAN
        ((cl_ulong*)vector)[n] = (uint64_t)NUM2ULONG(argv[n]);
#else
        ((cl_ulong*)vector)[n] = (uint64_t)NUM2ULONG(argv[7-n]);
#endif
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
#ifdef CL_BIG_ENDIAN
  return rb_ary_new3(8, ULONG2NUM((uint64_t)(((cl_ulong*)vector)[0])), ULONG2NUM((uint64_t)(((cl_ulong*)vector)[1])), ULONG2NUM((uint64_t)(((cl_ulong*)vector)[2])), ULONG2NUM((uint64_t)(((cl_ulong*)vector)[3])), ULONG2NUM((uint64_t)(((cl_ulong*)vector)[4])), ULONG2NUM((uint64_t)(((cl_ulong*)vector)[5])), ULONG2NUM((uint64_t)(((cl_ulong*)vector)[6])), ULONG2NUM((uint64_t)(((cl_ulong*)vector)[7])));
#else
  return rb_ary_new3(8, ULONG2NUM((uint64_t)(((cl_ulong*)vector)[7])), ULONG2NUM((uint64_t)(((cl_ulong*)vector)[6])), ULONG2NUM((uint64_t)(((cl_ulong*)vector)[5])), ULONG2NUM((uint64_t)(((cl_ulong*)vector)[4])), ULONG2NUM((uint64_t)(((cl_ulong*)vector)[3])), ULONG2NUM((uint64_t)(((cl_ulong*)vector)[2])), ULONG2NUM((uint64_t)(((cl_ulong*)vector)[1])), ULONG2NUM((uint64_t)(((cl_ulong*)vector)[0])));
#endif
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
      for (n=0; n<(int)16; n++)
#ifdef CL_BIG_ENDIAN
        ((cl_ulong*)vector)[n] = (uint64_t)NUM2ULONG(ptr[n]);
#else
        ((cl_ulong*)vector)[n] = (uint64_t)NUM2ULONG(ptr[15-n]);
#endif
    }
  } else if (argc == 16) {
      for (n=0; n<(int)16; n++)
#ifdef CL_BIG_ENDIAN
        ((cl_ulong*)vector)[n] = (uint64_t)NUM2ULONG(argv[n]);
#else
        ((cl_ulong*)vector)[n] = (uint64_t)NUM2ULONG(argv[15-n]);
#endif
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
#ifdef CL_BIG_ENDIAN
  return rb_ary_new3(16, ULONG2NUM((uint64_t)(((cl_ulong*)vector)[0])), ULONG2NUM((uint64_t)(((cl_ulong*)vector)[1])), ULONG2NUM((uint64_t)(((cl_ulong*)vector)[2])), ULONG2NUM((uint64_t)(((cl_ulong*)vector)[3])), ULONG2NUM((uint64_t)(((cl_ulong*)vector)[4])), ULONG2NUM((uint64_t)(((cl_ulong*)vector)[5])), ULONG2NUM((uint64_t)(((cl_ulong*)vector)[6])), ULONG2NUM((uint64_t)(((cl_ulong*)vector)[7])), ULONG2NUM((uint64_t)(((cl_ulong*)vector)[8])), ULONG2NUM((uint64_t)(((cl_ulong*)vector)[9])), ULONG2NUM((uint64_t)(((cl_ulong*)vector)[10])), ULONG2NUM((uint64_t)(((cl_ulong*)vector)[11])), ULONG2NUM((uint64_t)(((cl_ulong*)vector)[12])), ULONG2NUM((uint64_t)(((cl_ulong*)vector)[13])), ULONG2NUM((uint64_t)(((cl_ulong*)vector)[14])), ULONG2NUM((uint64_t)(((cl_ulong*)vector)[15])));
#else
  return rb_ary_new3(16, ULONG2NUM((uint64_t)(((cl_ulong*)vector)[15])), ULONG2NUM((uint64_t)(((cl_ulong*)vector)[14])), ULONG2NUM((uint64_t)(((cl_ulong*)vector)[13])), ULONG2NUM((uint64_t)(((cl_ulong*)vector)[12])), ULONG2NUM((uint64_t)(((cl_ulong*)vector)[11])), ULONG2NUM((uint64_t)(((cl_ulong*)vector)[10])), ULONG2NUM((uint64_t)(((cl_ulong*)vector)[9])), ULONG2NUM((uint64_t)(((cl_ulong*)vector)[8])), ULONG2NUM((uint64_t)(((cl_ulong*)vector)[7])), ULONG2NUM((uint64_t)(((cl_ulong*)vector)[6])), ULONG2NUM((uint64_t)(((cl_ulong*)vector)[5])), ULONG2NUM((uint64_t)(((cl_ulong*)vector)[4])), ULONG2NUM((uint64_t)(((cl_ulong*)vector)[3])), ULONG2NUM((uint64_t)(((cl_ulong*)vector)[2])), ULONG2NUM((uint64_t)(((cl_ulong*)vector)[1])), ULONG2NUM((uint64_t)(((cl_ulong*)vector)[0])));
#endif
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
      for (n=0; n<(int)2; n++)
#ifdef CL_BIG_ENDIAN
        ((cl_float*)vector)[n] = (float)NUM2DBL(ptr[n]);
#else
        ((cl_float*)vector)[n] = (float)NUM2DBL(ptr[1-n]);
#endif
    }
  } else if (argc == 2) {
      for (n=0; n<(int)2; n++)
#ifdef CL_BIG_ENDIAN
        ((cl_float*)vector)[n] = (float)NUM2DBL(argv[n]);
#else
        ((cl_float*)vector)[n] = (float)NUM2DBL(argv[1-n]);
#endif
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
#ifdef CL_BIG_ENDIAN
  return rb_ary_new3(2, rb_float_new((double)(((cl_float*)vector)[0])), rb_float_new((double)(((cl_float*)vector)[1])));
#else
  return rb_ary_new3(2, rb_float_new((double)(((cl_float*)vector)[1])), rb_float_new((double)(((cl_float*)vector)[0])));
#endif
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
      for (n=0; n<(int)4; n++)
#ifdef CL_BIG_ENDIAN
        ((cl_float*)vector)[n] = (float)NUM2DBL(ptr[n]);
#else
        ((cl_float*)vector)[n] = (float)NUM2DBL(ptr[3-n]);
#endif
    }
  } else if (argc == 4) {
      for (n=0; n<(int)4; n++)
#ifdef CL_BIG_ENDIAN
        ((cl_float*)vector)[n] = (float)NUM2DBL(argv[n]);
#else
        ((cl_float*)vector)[n] = (float)NUM2DBL(argv[3-n]);
#endif
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
#ifdef CL_BIG_ENDIAN
  return rb_ary_new3(4, rb_float_new((double)(((cl_float*)vector)[0])), rb_float_new((double)(((cl_float*)vector)[1])), rb_float_new((double)(((cl_float*)vector)[2])), rb_float_new((double)(((cl_float*)vector)[3])));
#else
  return rb_ary_new3(4, rb_float_new((double)(((cl_float*)vector)[3])), rb_float_new((double)(((cl_float*)vector)[2])), rb_float_new((double)(((cl_float*)vector)[1])), rb_float_new((double)(((cl_float*)vector)[0])));
#endif
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
      for (n=0; n<(int)8; n++)
#ifdef CL_BIG_ENDIAN
        ((cl_float*)vector)[n] = (float)NUM2DBL(ptr[n]);
#else
        ((cl_float*)vector)[n] = (float)NUM2DBL(ptr[7-n]);
#endif
    }
  } else if (argc == 8) {
      for (n=0; n<(int)8; n++)
#ifdef CL_BIG_ENDIAN
        ((cl_float*)vector)[n] = (float)NUM2DBL(argv[n]);
#else
        ((cl_float*)vector)[n] = (float)NUM2DBL(argv[7-n]);
#endif
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
#ifdef CL_BIG_ENDIAN
  return rb_ary_new3(8, rb_float_new((double)(((cl_float*)vector)[0])), rb_float_new((double)(((cl_float*)vector)[1])), rb_float_new((double)(((cl_float*)vector)[2])), rb_float_new((double)(((cl_float*)vector)[3])), rb_float_new((double)(((cl_float*)vector)[4])), rb_float_new((double)(((cl_float*)vector)[5])), rb_float_new((double)(((cl_float*)vector)[6])), rb_float_new((double)(((cl_float*)vector)[7])));
#else
  return rb_ary_new3(8, rb_float_new((double)(((cl_float*)vector)[7])), rb_float_new((double)(((cl_float*)vector)[6])), rb_float_new((double)(((cl_float*)vector)[5])), rb_float_new((double)(((cl_float*)vector)[4])), rb_float_new((double)(((cl_float*)vector)[3])), rb_float_new((double)(((cl_float*)vector)[2])), rb_float_new((double)(((cl_float*)vector)[1])), rb_float_new((double)(((cl_float*)vector)[0])));
#endif
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
      for (n=0; n<(int)16; n++)
#ifdef CL_BIG_ENDIAN
        ((cl_float*)vector)[n] = (float)NUM2DBL(ptr[n]);
#else
        ((cl_float*)vector)[n] = (float)NUM2DBL(ptr[15-n]);
#endif
    }
  } else if (argc == 16) {
      for (n=0; n<(int)16; n++)
#ifdef CL_BIG_ENDIAN
        ((cl_float*)vector)[n] = (float)NUM2DBL(argv[n]);
#else
        ((cl_float*)vector)[n] = (float)NUM2DBL(argv[15-n]);
#endif
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
#ifdef CL_BIG_ENDIAN
  return rb_ary_new3(16, rb_float_new((double)(((cl_float*)vector)[0])), rb_float_new((double)(((cl_float*)vector)[1])), rb_float_new((double)(((cl_float*)vector)[2])), rb_float_new((double)(((cl_float*)vector)[3])), rb_float_new((double)(((cl_float*)vector)[4])), rb_float_new((double)(((cl_float*)vector)[5])), rb_float_new((double)(((cl_float*)vector)[6])), rb_float_new((double)(((cl_float*)vector)[7])), rb_float_new((double)(((cl_float*)vector)[8])), rb_float_new((double)(((cl_float*)vector)[9])), rb_float_new((double)(((cl_float*)vector)[10])), rb_float_new((double)(((cl_float*)vector)[11])), rb_float_new((double)(((cl_float*)vector)[12])), rb_float_new((double)(((cl_float*)vector)[13])), rb_float_new((double)(((cl_float*)vector)[14])), rb_float_new((double)(((cl_float*)vector)[15])));
#else
  return rb_ary_new3(16, rb_float_new((double)(((cl_float*)vector)[15])), rb_float_new((double)(((cl_float*)vector)[14])), rb_float_new((double)(((cl_float*)vector)[13])), rb_float_new((double)(((cl_float*)vector)[12])), rb_float_new((double)(((cl_float*)vector)[11])), rb_float_new((double)(((cl_float*)vector)[10])), rb_float_new((double)(((cl_float*)vector)[9])), rb_float_new((double)(((cl_float*)vector)[8])), rb_float_new((double)(((cl_float*)vector)[7])), rb_float_new((double)(((cl_float*)vector)[6])), rb_float_new((double)(((cl_float*)vector)[5])), rb_float_new((double)(((cl_float*)vector)[4])), rb_float_new((double)(((cl_float*)vector)[3])), rb_float_new((double)(((cl_float*)vector)[2])), rb_float_new((double)(((cl_float*)vector)[1])), rb_float_new((double)(((cl_float*)vector)[0])));
#endif
}
VALUE
rb_CreateDouble2(int argc, VALUE *argv, VALUE self)
{
  cl_double2 *vector;
  int n;

  vector = (cl_double2*)xmalloc(sizeof(cl_double2));
  if (argc == 1) {
    Check_Type(argv[0], T_ARRAY);
    if (RARRAY_LEN(argv[0])==2) {
      VALUE *ptr = (VALUE*)RARRAY_PTR(argv[0]);
      for (n=0; n<(int)2; n++)
#ifdef CL_BIG_ENDIAN
        ((cl_double*)vector)[n] = (double)NUM2DBL(ptr[n]);
#else
        ((cl_double*)vector)[n] = (double)NUM2DBL(ptr[1-n]);
#endif
    }
  } else if (argc == 2) {
      for (n=0; n<(int)2; n++)
#ifdef CL_BIG_ENDIAN
        ((cl_double*)vector)[n] = (double)NUM2DBL(argv[n]);
#else
        ((cl_double*)vector)[n] = (double)NUM2DBL(argv[1-n]);
#endif
  } else {
    rb_raise(rb_eArgError, "wrong number of arguments (%d for 2)", argc);
  }
  return Data_Wrap_Struct(rb_cDouble2, 0, vector_free, (void*)vector);
}
VALUE
rb_Double2_toA(int argc, VALUE *argv, VALUE self)
{
  cl_double2 *vector;

  if (argc > 0)
    rb_raise(rb_eArgError, "wrong number of arguments (%d for 0)", argc);
  Data_Get_Struct(self, cl_double2, vector);
#ifdef CL_BIG_ENDIAN
  return rb_ary_new3(2, rb_float_new((double)(((cl_double*)vector)[0])), rb_float_new((double)(((cl_double*)vector)[1])));
#else
  return rb_ary_new3(2, rb_float_new((double)(((cl_double*)vector)[1])), rb_float_new((double)(((cl_double*)vector)[0])));
#endif
}
VALUE
rb_CreateDouble4(int argc, VALUE *argv, VALUE self)
{
  cl_double4 *vector;
  int n;

  vector = (cl_double4*)xmalloc(sizeof(cl_double4));
  if (argc == 1) {
    Check_Type(argv[0], T_ARRAY);
    if (RARRAY_LEN(argv[0])==4) {
      VALUE *ptr = (VALUE*)RARRAY_PTR(argv[0]);
      for (n=0; n<(int)4; n++)
#ifdef CL_BIG_ENDIAN
        ((cl_double*)vector)[n] = (double)NUM2DBL(ptr[n]);
#else
        ((cl_double*)vector)[n] = (double)NUM2DBL(ptr[3-n]);
#endif
    }
  } else if (argc == 4) {
      for (n=0; n<(int)4; n++)
#ifdef CL_BIG_ENDIAN
        ((cl_double*)vector)[n] = (double)NUM2DBL(argv[n]);
#else
        ((cl_double*)vector)[n] = (double)NUM2DBL(argv[3-n]);
#endif
  } else {
    rb_raise(rb_eArgError, "wrong number of arguments (%d for 4)", argc);
  }
  return Data_Wrap_Struct(rb_cDouble4, 0, vector_free, (void*)vector);
}
VALUE
rb_Double4_toA(int argc, VALUE *argv, VALUE self)
{
  cl_double4 *vector;

  if (argc > 0)
    rb_raise(rb_eArgError, "wrong number of arguments (%d for 0)", argc);
  Data_Get_Struct(self, cl_double4, vector);
#ifdef CL_BIG_ENDIAN
  return rb_ary_new3(4, rb_float_new((double)(((cl_double*)vector)[0])), rb_float_new((double)(((cl_double*)vector)[1])), rb_float_new((double)(((cl_double*)vector)[2])), rb_float_new((double)(((cl_double*)vector)[3])));
#else
  return rb_ary_new3(4, rb_float_new((double)(((cl_double*)vector)[3])), rb_float_new((double)(((cl_double*)vector)[2])), rb_float_new((double)(((cl_double*)vector)[1])), rb_float_new((double)(((cl_double*)vector)[0])));
#endif
}
VALUE
rb_CreateDouble8(int argc, VALUE *argv, VALUE self)
{
  cl_double8 *vector;
  int n;

  vector = (cl_double8*)xmalloc(sizeof(cl_double8));
  if (argc == 1) {
    Check_Type(argv[0], T_ARRAY);
    if (RARRAY_LEN(argv[0])==8) {
      VALUE *ptr = (VALUE*)RARRAY_PTR(argv[0]);
      for (n=0; n<(int)8; n++)
#ifdef CL_BIG_ENDIAN
        ((cl_double*)vector)[n] = (double)NUM2DBL(ptr[n]);
#else
        ((cl_double*)vector)[n] = (double)NUM2DBL(ptr[7-n]);
#endif
    }
  } else if (argc == 8) {
      for (n=0; n<(int)8; n++)
#ifdef CL_BIG_ENDIAN
        ((cl_double*)vector)[n] = (double)NUM2DBL(argv[n]);
#else
        ((cl_double*)vector)[n] = (double)NUM2DBL(argv[7-n]);
#endif
  } else {
    rb_raise(rb_eArgError, "wrong number of arguments (%d for 8)", argc);
  }
  return Data_Wrap_Struct(rb_cDouble8, 0, vector_free, (void*)vector);
}
VALUE
rb_Double8_toA(int argc, VALUE *argv, VALUE self)
{
  cl_double8 *vector;

  if (argc > 0)
    rb_raise(rb_eArgError, "wrong number of arguments (%d for 0)", argc);
  Data_Get_Struct(self, cl_double8, vector);
#ifdef CL_BIG_ENDIAN
  return rb_ary_new3(8, rb_float_new((double)(((cl_double*)vector)[0])), rb_float_new((double)(((cl_double*)vector)[1])), rb_float_new((double)(((cl_double*)vector)[2])), rb_float_new((double)(((cl_double*)vector)[3])), rb_float_new((double)(((cl_double*)vector)[4])), rb_float_new((double)(((cl_double*)vector)[5])), rb_float_new((double)(((cl_double*)vector)[6])), rb_float_new((double)(((cl_double*)vector)[7])));
#else
  return rb_ary_new3(8, rb_float_new((double)(((cl_double*)vector)[7])), rb_float_new((double)(((cl_double*)vector)[6])), rb_float_new((double)(((cl_double*)vector)[5])), rb_float_new((double)(((cl_double*)vector)[4])), rb_float_new((double)(((cl_double*)vector)[3])), rb_float_new((double)(((cl_double*)vector)[2])), rb_float_new((double)(((cl_double*)vector)[1])), rb_float_new((double)(((cl_double*)vector)[0])));
#endif
}
VALUE
rb_CreateDouble16(int argc, VALUE *argv, VALUE self)
{
  cl_double16 *vector;
  int n;

  vector = (cl_double16*)xmalloc(sizeof(cl_double16));
  if (argc == 1) {
    Check_Type(argv[0], T_ARRAY);
    if (RARRAY_LEN(argv[0])==16) {
      VALUE *ptr = (VALUE*)RARRAY_PTR(argv[0]);
      for (n=0; n<(int)16; n++)
#ifdef CL_BIG_ENDIAN
        ((cl_double*)vector)[n] = (double)NUM2DBL(ptr[n]);
#else
        ((cl_double*)vector)[n] = (double)NUM2DBL(ptr[15-n]);
#endif
    }
  } else if (argc == 16) {
      for (n=0; n<(int)16; n++)
#ifdef CL_BIG_ENDIAN
        ((cl_double*)vector)[n] = (double)NUM2DBL(argv[n]);
#else
        ((cl_double*)vector)[n] = (double)NUM2DBL(argv[15-n]);
#endif
  } else {
    rb_raise(rb_eArgError, "wrong number of arguments (%d for 16)", argc);
  }
  return Data_Wrap_Struct(rb_cDouble16, 0, vector_free, (void*)vector);
}
VALUE
rb_Double16_toA(int argc, VALUE *argv, VALUE self)
{
  cl_double16 *vector;

  if (argc > 0)
    rb_raise(rb_eArgError, "wrong number of arguments (%d for 0)", argc);
  Data_Get_Struct(self, cl_double16, vector);
#ifdef CL_BIG_ENDIAN
  return rb_ary_new3(16, rb_float_new((double)(((cl_double*)vector)[0])), rb_float_new((double)(((cl_double*)vector)[1])), rb_float_new((double)(((cl_double*)vector)[2])), rb_float_new((double)(((cl_double*)vector)[3])), rb_float_new((double)(((cl_double*)vector)[4])), rb_float_new((double)(((cl_double*)vector)[5])), rb_float_new((double)(((cl_double*)vector)[6])), rb_float_new((double)(((cl_double*)vector)[7])), rb_float_new((double)(((cl_double*)vector)[8])), rb_float_new((double)(((cl_double*)vector)[9])), rb_float_new((double)(((cl_double*)vector)[10])), rb_float_new((double)(((cl_double*)vector)[11])), rb_float_new((double)(((cl_double*)vector)[12])), rb_float_new((double)(((cl_double*)vector)[13])), rb_float_new((double)(((cl_double*)vector)[14])), rb_float_new((double)(((cl_double*)vector)[15])));
#else
  return rb_ary_new3(16, rb_float_new((double)(((cl_double*)vector)[15])), rb_float_new((double)(((cl_double*)vector)[14])), rb_float_new((double)(((cl_double*)vector)[13])), rb_float_new((double)(((cl_double*)vector)[12])), rb_float_new((double)(((cl_double*)vector)[11])), rb_float_new((double)(((cl_double*)vector)[10])), rb_float_new((double)(((cl_double*)vector)[9])), rb_float_new((double)(((cl_double*)vector)[8])), rb_float_new((double)(((cl_double*)vector)[7])), rb_float_new((double)(((cl_double*)vector)[6])), rb_float_new((double)(((cl_double*)vector)[5])), rb_float_new((double)(((cl_double*)vector)[4])), rb_float_new((double)(((cl_double*)vector)[3])), rb_float_new((double)(((cl_double*)vector)[2])), rb_float_new((double)(((cl_double*)vector)[1])), rb_float_new((double)(((cl_double*)vector)[0])));
#endif
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
  case VA_DOUBLE:
    switch (n) {
    case 1:
      return rb_float_new((double)((cl_double*)ptr)[0]);
      break;
    case 2:
      return Data_Wrap_Struct(rb_cDouble2, 0, vector_free, ptr);
      break;
    case 4:
      return Data_Wrap_Struct(rb_cDouble4, 0, vector_free, ptr);
      break;
    case 8:
      return Data_Wrap_Struct(rb_cDouble8, 0, vector_free, ptr);
      break;
    case 16:
      return Data_Wrap_Struct(rb_cDouble16, 0, vector_free, ptr);
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
varray_free(struct_varray *s_array)
{
  if (s_array->obj == Qnil)
    xfree(s_array->ptr);
  xfree(s_array);
}
static void
varray_mark(struct_varray *s_array)
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
  case VA_DOUBLE:
    switch (n) {
    case 1:
      return sizeof(cl_double);
      break;
    case 2:
      return sizeof(cl_double2);
      break;
    case 4:
      return sizeof(cl_double4);
      break;
    case 8:
      return sizeof(cl_double8);
      break;
    case 16:
      return sizeof(cl_double16);
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
  struct_varray *s_array;

  s_array = (struct_varray*)xmalloc(sizeof(struct_varray));
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
  VALUE obj = Qnil;
  unsigned int len;
  void* ptr;
  size_t size;

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
  } else if ((argc==1 || argc==2) && NA_IsNArray(argv[0])) {
    struct NARRAY* nary;
    int ntype;
    if (argc==2) {
      Check_Type(argv[1], T_HASH);
      if (rb_hash_aref(argv[1], ID2SYM(rb_intern("binary"))) == Qtrue)
        obj = argv[0];
    }
    nary = NA_STRUCT(argv[0]);
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
    case NA_DFLOAT:
      vtype = VA_DOUBLE;
      break;
    default:
      rb_raise(rb_eArgError, "this type is not supported");
    }
    size = data_size(vtype, n);
    if (obj == Qnil) {
      ptr = (void*)ALLOC_N(char, size*len);
#ifdef CL_BIG_ENDIAN
      memcpy(ptr, nary->ptr, size*len);
#else
      if (n==1)
        memcpy(ptr, nary->ptr, size*len);
      else {
        size_t step = size/n;
        void *nptr = (void*)nary->ptr;
        int i, j;
        for(i=0;i<(int)len;i++)
          for(j=0;j<(int)n;j++)
            memcpy(((char*)ptr)+i*size+j*step, ((char*)nptr)+i*size+(n-j-1)*step, step);
      }
#endif
    } else
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
  struct_varray *s_array;

  if (argc != 0)
    rb_raise(rb_eArgError, "wrong number of arguments (%d for 0)", argc);
  Data_Get_Struct(self, struct_varray, s_array);
  return UINT2NUM(s_array->length);
}
VALUE
rb_VArray_data_size(int argc, VALUE *argv, VALUE self)
{
  struct_varray *s_array;

  if (argc != 0)
    rb_raise(rb_eArgError, "wrong number of arguments (%d for 0)", argc);
  Data_Get_Struct(self, struct_varray, s_array);
  return UINT2NUM(s_array->size);
}
VALUE
rb_VArray_toS(int argc, VALUE *argv, VALUE self)
{
  struct_varray *s_array;

  if (argc != 0)
    rb_raise(rb_eArgError, "wrong number of arguments (%d for 0)", argc);
  Data_Get_Struct(self, struct_varray, s_array);
  return rb_str_new(s_array->ptr, s_array->length*s_array->size);
}
VALUE
rb_VArray_typeCode(int argc, VALUE *argv, VALUE self)
{
  struct_varray *s_array;

  if (argc != 0)
    rb_raise(rb_eArgError, "wrong number of arguments (%d for 0)", argc);
  Data_Get_Struct(self, struct_varray, s_array);
  return UINT2NUM(vector_type_code(s_array->type,s_array->n));
}
VALUE
rb_VArray_aref(int argc, VALUE *argv, VALUE self)
{
  struct_varray *s_array;
  void *ptr;
  size_t size;

  if (argc!=1)
    rb_raise(rb_eArgError, "wrong number of arguments (%d for 1)", argc);
  Data_Get_Struct(self, struct_varray, s_array);
  size = s_array->size;
  if (FIXNUM_P(argv[0])) {
    int i = FIX2INT(argv[0]);
    if (i < 0)
      i += (int)s_array->length;
    if (i >= (int)s_array->length)
      rb_raise(rb_eArgError, "index %ld out of array (%ld)", i, s_array->length);
    ptr = (void*)xmalloc(size);
    return create_vector(memcpy(ptr, ((char*)(s_array->ptr))+size*i, size), s_array->type, s_array->n);
  } else if (rb_class_of(argv[0]) == rb_cRange) {
     long beg, len;
     rb_range_beg_len(argv[0], &beg, &len, s_array->length, 1);
     ptr = (void*)(((char*)s_array->ptr)+size*beg);
     return create_varray(ptr, len, s_array->type, s_array->n, s_array->size, self);
//     ptr = (void*)xmalloc(size*len);
//     memcpy(ptr, ((char*)s_array->ptr)+size*beg, size*len);
//     return create_varray(ptr, len, s_array->type, s_array->n, s_array->size, Qnil);
  } else
    rb_raise(rb_eArgError, "wrong type of the 1st argument");

  return Qnil;
}
VALUE
rb_VArray_aset(int argc, VALUE *argv, VALUE self)
{
  struct_varray *s_array;
  size_t size;
  long beg, len;
  int i, j;

  if (argc!=2)
    rb_raise(rb_eArgError, "wrong number of arguments (%d for 2)", argc);
  Data_Get_Struct(self, struct_varray, s_array);
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
    struct_varray *s_array1;
    Data_Get_Struct(argv[1], struct_varray, s_array1);
    if (s_array1->type == s_array->type && s_array1->n == s_array->n && (long)s_array1->length == len) {
      memcpy(((char*)s_array->ptr)+beg*size, s_array1->ptr, size*len);
      return argv[1];
    } else {
      rb_raise(rb_eArgError, "type_code or length is invalid");
    }
  }
  switch (s_array->type) {
  case VA_CHAR:
    if (rb_obj_is_kind_of(argv[1], rb_cNumeric)==Qtrue) {
      cl_char val = NUM2CHR(argv[1]);
      for (i=beg; i<beg+len; i++)
        for (j=0; j<(int)s_array->n; j++)
          ((cl_char*)(((char*)s_array->ptr)+size*i))[j] = val;
      return argv[1];
    }
    switch (s_array->n) {
    case 2:
      if (rb_class_of(argv[1]) == rb_cChar2) {
        cl_char2 *val;
        Data_Get_Struct(argv[1], cl_char2, val);
        for (i=beg; i<beg+len; i++)
          memcpy(((char*)s_array->ptr)+size*i, val, size);
        return argv[1];
      } else {
        rb_raise(rb_eArgError, "wrong type of the 2nd argument");
      }
      break;
    case 4:
      if (rb_class_of(argv[1]) == rb_cChar4) {
        cl_char4 *val;
        Data_Get_Struct(argv[1], cl_char4, val);
        for (i=beg; i<beg+len; i++)
          memcpy(((char*)s_array->ptr)+size*i, val, size);
        return argv[1];
      } else {
        rb_raise(rb_eArgError, "wrong type of the 2nd argument");
      }
      break;
    case 8:
      if (rb_class_of(argv[1]) == rb_cChar8) {
        cl_char8 *val;
        Data_Get_Struct(argv[1], cl_char8, val);
        for (i=beg; i<beg+len; i++)
          memcpy(((char*)s_array->ptr)+size*i, val, size);
        return argv[1];
      } else {
        rb_raise(rb_eArgError, "wrong type of the 2nd argument");
      }
      break;
    case 16:
      if (rb_class_of(argv[1]) == rb_cChar16) {
        cl_char16 *val;
        Data_Get_Struct(argv[1], cl_char16, val);
        for (i=beg; i<beg+len; i++)
          memcpy(((char*)s_array->ptr)+size*i, val, size);
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
      for (i=beg; i<beg+len; i++)
        for (j=0; j<(int)s_array->n; j++)
          ((cl_uchar*)(((char*)s_array->ptr)+size*i))[j] = val;
      return argv[1];
    }
    switch (s_array->n) {
    case 2:
      if (rb_class_of(argv[1]) == rb_cUchar2) {
        cl_uchar2 *val;
        Data_Get_Struct(argv[1], cl_uchar2, val);
        for (i=beg; i<beg+len; i++)
          memcpy(((char*)s_array->ptr)+size*i, val, size);
        return argv[1];
      } else {
        rb_raise(rb_eArgError, "wrong type of the 2nd argument");
      }
      break;
    case 4:
      if (rb_class_of(argv[1]) == rb_cUchar4) {
        cl_uchar4 *val;
        Data_Get_Struct(argv[1], cl_uchar4, val);
        for (i=beg; i<beg+len; i++)
          memcpy(((char*)s_array->ptr)+size*i, val, size);
        return argv[1];
      } else {
        rb_raise(rb_eArgError, "wrong type of the 2nd argument");
      }
      break;
    case 8:
      if (rb_class_of(argv[1]) == rb_cUchar8) {
        cl_uchar8 *val;
        Data_Get_Struct(argv[1], cl_uchar8, val);
        for (i=beg; i<beg+len; i++)
          memcpy(((char*)s_array->ptr)+size*i, val, size);
        return argv[1];
      } else {
        rb_raise(rb_eArgError, "wrong type of the 2nd argument");
      }
      break;
    case 16:
      if (rb_class_of(argv[1]) == rb_cUchar16) {
        cl_uchar16 *val;
        Data_Get_Struct(argv[1], cl_uchar16, val);
        for (i=beg; i<beg+len; i++)
          memcpy(((char*)s_array->ptr)+size*i, val, size);
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
      for (i=beg; i<beg+len; i++)
        for (j=0; j<(int)s_array->n; j++)
          ((cl_short*)(((char*)s_array->ptr)+size*i))[j] = val;
      return argv[1];
    }
    switch (s_array->n) {
    case 2:
      if (rb_class_of(argv[1]) == rb_cShort2) {
        cl_short2 *val;
        Data_Get_Struct(argv[1], cl_short2, val);
        for (i=beg; i<beg+len; i++)
          memcpy(((char*)s_array->ptr)+size*i, val, size);
        return argv[1];
      } else {
        rb_raise(rb_eArgError, "wrong type of the 2nd argument");
      }
      break;
    case 4:
      if (rb_class_of(argv[1]) == rb_cShort4) {
        cl_short4 *val;
        Data_Get_Struct(argv[1], cl_short4, val);
        for (i=beg; i<beg+len; i++)
          memcpy(((char*)s_array->ptr)+size*i, val, size);
        return argv[1];
      } else {
        rb_raise(rb_eArgError, "wrong type of the 2nd argument");
      }
      break;
    case 8:
      if (rb_class_of(argv[1]) == rb_cShort8) {
        cl_short8 *val;
        Data_Get_Struct(argv[1], cl_short8, val);
        for (i=beg; i<beg+len; i++)
          memcpy(((char*)s_array->ptr)+size*i, val, size);
        return argv[1];
      } else {
        rb_raise(rb_eArgError, "wrong type of the 2nd argument");
      }
      break;
    case 16:
      if (rb_class_of(argv[1]) == rb_cShort16) {
        cl_short16 *val;
        Data_Get_Struct(argv[1], cl_short16, val);
        for (i=beg; i<beg+len; i++)
          memcpy(((char*)s_array->ptr)+size*i, val, size);
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
      for (i=beg; i<beg+len; i++)
        for (j=0; j<(int)s_array->n; j++)
          ((cl_ushort*)(((char*)s_array->ptr)+size*i))[j] = val;
      return argv[1];
    }
    switch (s_array->n) {
    case 2:
      if (rb_class_of(argv[1]) == rb_cUshort2) {
        cl_ushort2 *val;
        Data_Get_Struct(argv[1], cl_ushort2, val);
        for (i=beg; i<beg+len; i++)
          memcpy(((char*)s_array->ptr)+size*i, val, size);
        return argv[1];
      } else {
        rb_raise(rb_eArgError, "wrong type of the 2nd argument");
      }
      break;
    case 4:
      if (rb_class_of(argv[1]) == rb_cUshort4) {
        cl_ushort4 *val;
        Data_Get_Struct(argv[1], cl_ushort4, val);
        for (i=beg; i<beg+len; i++)
          memcpy(((char*)s_array->ptr)+size*i, val, size);
        return argv[1];
      } else {
        rb_raise(rb_eArgError, "wrong type of the 2nd argument");
      }
      break;
    case 8:
      if (rb_class_of(argv[1]) == rb_cUshort8) {
        cl_ushort8 *val;
        Data_Get_Struct(argv[1], cl_ushort8, val);
        for (i=beg; i<beg+len; i++)
          memcpy(((char*)s_array->ptr)+size*i, val, size);
        return argv[1];
      } else {
        rb_raise(rb_eArgError, "wrong type of the 2nd argument");
      }
      break;
    case 16:
      if (rb_class_of(argv[1]) == rb_cUshort16) {
        cl_ushort16 *val;
        Data_Get_Struct(argv[1], cl_ushort16, val);
        for (i=beg; i<beg+len; i++)
          memcpy(((char*)s_array->ptr)+size*i, val, size);
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
      for (i=beg; i<beg+len; i++)
        for (j=0; j<(int)s_array->n; j++)
          ((cl_int*)(((char*)s_array->ptr)+size*i))[j] = val;
      return argv[1];
    }
    switch (s_array->n) {
    case 2:
      if (rb_class_of(argv[1]) == rb_cInt2) {
        cl_int2 *val;
        Data_Get_Struct(argv[1], cl_int2, val);
        for (i=beg; i<beg+len; i++)
          memcpy(((char*)s_array->ptr)+size*i, val, size);
        return argv[1];
      } else {
        rb_raise(rb_eArgError, "wrong type of the 2nd argument");
      }
      break;
    case 4:
      if (rb_class_of(argv[1]) == rb_cInt4) {
        cl_int4 *val;
        Data_Get_Struct(argv[1], cl_int4, val);
        for (i=beg; i<beg+len; i++)
          memcpy(((char*)s_array->ptr)+size*i, val, size);
        return argv[1];
      } else {
        rb_raise(rb_eArgError, "wrong type of the 2nd argument");
      }
      break;
    case 8:
      if (rb_class_of(argv[1]) == rb_cInt8) {
        cl_int8 *val;
        Data_Get_Struct(argv[1], cl_int8, val);
        for (i=beg; i<beg+len; i++)
          memcpy(((char*)s_array->ptr)+size*i, val, size);
        return argv[1];
      } else {
        rb_raise(rb_eArgError, "wrong type of the 2nd argument");
      }
      break;
    case 16:
      if (rb_class_of(argv[1]) == rb_cInt16) {
        cl_int16 *val;
        Data_Get_Struct(argv[1], cl_int16, val);
        for (i=beg; i<beg+len; i++)
          memcpy(((char*)s_array->ptr)+size*i, val, size);
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
      for (i=beg; i<beg+len; i++)
        for (j=0; j<(int)s_array->n; j++)
          ((cl_uint*)(((char*)s_array->ptr)+size*i))[j] = val;
      return argv[1];
    }
    switch (s_array->n) {
    case 2:
      if (rb_class_of(argv[1]) == rb_cUint2) {
        cl_uint2 *val;
        Data_Get_Struct(argv[1], cl_uint2, val);
        for (i=beg; i<beg+len; i++)
          memcpy(((char*)s_array->ptr)+size*i, val, size);
        return argv[1];
      } else {
        rb_raise(rb_eArgError, "wrong type of the 2nd argument");
      }
      break;
    case 4:
      if (rb_class_of(argv[1]) == rb_cUint4) {
        cl_uint4 *val;
        Data_Get_Struct(argv[1], cl_uint4, val);
        for (i=beg; i<beg+len; i++)
          memcpy(((char*)s_array->ptr)+size*i, val, size);
        return argv[1];
      } else {
        rb_raise(rb_eArgError, "wrong type of the 2nd argument");
      }
      break;
    case 8:
      if (rb_class_of(argv[1]) == rb_cUint8) {
        cl_uint8 *val;
        Data_Get_Struct(argv[1], cl_uint8, val);
        for (i=beg; i<beg+len; i++)
          memcpy(((char*)s_array->ptr)+size*i, val, size);
        return argv[1];
      } else {
        rb_raise(rb_eArgError, "wrong type of the 2nd argument");
      }
      break;
    case 16:
      if (rb_class_of(argv[1]) == rb_cUint16) {
        cl_uint16 *val;
        Data_Get_Struct(argv[1], cl_uint16, val);
        for (i=beg; i<beg+len; i++)
          memcpy(((char*)s_array->ptr)+size*i, val, size);
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
      for (i=beg; i<beg+len; i++)
        for (j=0; j<(int)s_array->n; j++)
          ((cl_long*)(((char*)s_array->ptr)+size*i))[j] = val;
      return argv[1];
    }
    switch (s_array->n) {
    case 2:
      if (rb_class_of(argv[1]) == rb_cLong2) {
        cl_long2 *val;
        Data_Get_Struct(argv[1], cl_long2, val);
        for (i=beg; i<beg+len; i++)
          memcpy(((char*)s_array->ptr)+size*i, val, size);
        return argv[1];
      } else {
        rb_raise(rb_eArgError, "wrong type of the 2nd argument");
      }
      break;
    case 4:
      if (rb_class_of(argv[1]) == rb_cLong4) {
        cl_long4 *val;
        Data_Get_Struct(argv[1], cl_long4, val);
        for (i=beg; i<beg+len; i++)
          memcpy(((char*)s_array->ptr)+size*i, val, size);
        return argv[1];
      } else {
        rb_raise(rb_eArgError, "wrong type of the 2nd argument");
      }
      break;
    case 8:
      if (rb_class_of(argv[1]) == rb_cLong8) {
        cl_long8 *val;
        Data_Get_Struct(argv[1], cl_long8, val);
        for (i=beg; i<beg+len; i++)
          memcpy(((char*)s_array->ptr)+size*i, val, size);
        return argv[1];
      } else {
        rb_raise(rb_eArgError, "wrong type of the 2nd argument");
      }
      break;
    case 16:
      if (rb_class_of(argv[1]) == rb_cLong16) {
        cl_long16 *val;
        Data_Get_Struct(argv[1], cl_long16, val);
        for (i=beg; i<beg+len; i++)
          memcpy(((char*)s_array->ptr)+size*i, val, size);
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
      for (i=beg; i<beg+len; i++)
        for (j=0; j<(int)s_array->n; j++)
          ((cl_ulong*)(((char*)s_array->ptr)+size*i))[j] = val;
      return argv[1];
    }
    switch (s_array->n) {
    case 2:
      if (rb_class_of(argv[1]) == rb_cUlong2) {
        cl_ulong2 *val;
        Data_Get_Struct(argv[1], cl_ulong2, val);
        for (i=beg; i<beg+len; i++)
          memcpy(((char*)s_array->ptr)+size*i, val, size);
        return argv[1];
      } else {
        rb_raise(rb_eArgError, "wrong type of the 2nd argument");
      }
      break;
    case 4:
      if (rb_class_of(argv[1]) == rb_cUlong4) {
        cl_ulong4 *val;
        Data_Get_Struct(argv[1], cl_ulong4, val);
        for (i=beg; i<beg+len; i++)
          memcpy(((char*)s_array->ptr)+size*i, val, size);
        return argv[1];
      } else {
        rb_raise(rb_eArgError, "wrong type of the 2nd argument");
      }
      break;
    case 8:
      if (rb_class_of(argv[1]) == rb_cUlong8) {
        cl_ulong8 *val;
        Data_Get_Struct(argv[1], cl_ulong8, val);
        for (i=beg; i<beg+len; i++)
          memcpy(((char*)s_array->ptr)+size*i, val, size);
        return argv[1];
      } else {
        rb_raise(rb_eArgError, "wrong type of the 2nd argument");
      }
      break;
    case 16:
      if (rb_class_of(argv[1]) == rb_cUlong16) {
        cl_ulong16 *val;
        Data_Get_Struct(argv[1], cl_ulong16, val);
        for (i=beg; i<beg+len; i++)
          memcpy(((char*)s_array->ptr)+size*i, val, size);
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
      for (i=beg; i<beg+len; i++)
        for (j=0; j<(int)s_array->n; j++)
          ((cl_float*)(((char*)s_array->ptr)+size*i))[j] = val;
      return argv[1];
    }
    switch (s_array->n) {
    case 2:
      if (rb_class_of(argv[1]) == rb_cFloat2) {
        cl_float2 *val;
        Data_Get_Struct(argv[1], cl_float2, val);
        for (i=beg; i<beg+len; i++)
          memcpy(((char*)s_array->ptr)+size*i, val, size);
        return argv[1];
      } else {
        rb_raise(rb_eArgError, "wrong type of the 2nd argument");
      }
      break;
    case 4:
      if (rb_class_of(argv[1]) == rb_cFloat4) {
        cl_float4 *val;
        Data_Get_Struct(argv[1], cl_float4, val);
        for (i=beg; i<beg+len; i++)
          memcpy(((char*)s_array->ptr)+size*i, val, size);
        return argv[1];
      } else {
        rb_raise(rb_eArgError, "wrong type of the 2nd argument");
      }
      break;
    case 8:
      if (rb_class_of(argv[1]) == rb_cFloat8) {
        cl_float8 *val;
        Data_Get_Struct(argv[1], cl_float8, val);
        for (i=beg; i<beg+len; i++)
          memcpy(((char*)s_array->ptr)+size*i, val, size);
        return argv[1];
      } else {
        rb_raise(rb_eArgError, "wrong type of the 2nd argument");
      }
      break;
    case 16:
      if (rb_class_of(argv[1]) == rb_cFloat16) {
        cl_float16 *val;
        Data_Get_Struct(argv[1], cl_float16, val);
        for (i=beg; i<beg+len; i++)
          memcpy(((char*)s_array->ptr)+size*i, val, size);
        return argv[1];
      } else {
        rb_raise(rb_eArgError, "wrong type of the 2nd argument");
      }
      break;
    default:
      rb_raise(rb_eArgError, "wrong type of the 2nd argument");
    }
    break;
  case VA_DOUBLE:
    if (rb_obj_is_kind_of(argv[1], rb_cNumeric)==Qtrue) {
      cl_double val = (double)NUM2DBL(argv[1]);
      for (i=beg; i<beg+len; i++)
        for (j=0; j<(int)s_array->n; j++)
          ((cl_double*)(((char*)s_array->ptr)+size*i))[j] = val;
      return argv[1];
    }
    switch (s_array->n) {
    case 2:
      if (rb_class_of(argv[1]) == rb_cDouble2) {
        cl_double2 *val;
        Data_Get_Struct(argv[1], cl_double2, val);
        for (i=beg; i<beg+len; i++)
          memcpy(((char*)s_array->ptr)+size*i, val, size);
        return argv[1];
      } else {
        rb_raise(rb_eArgError, "wrong type of the 2nd argument");
      }
      break;
    case 4:
      if (rb_class_of(argv[1]) == rb_cDouble4) {
        cl_double4 *val;
        Data_Get_Struct(argv[1], cl_double4, val);
        for (i=beg; i<beg+len; i++)
          memcpy(((char*)s_array->ptr)+size*i, val, size);
        return argv[1];
      } else {
        rb_raise(rb_eArgError, "wrong type of the 2nd argument");
      }
      break;
    case 8:
      if (rb_class_of(argv[1]) == rb_cDouble8) {
        cl_double8 *val;
        Data_Get_Struct(argv[1], cl_double8, val);
        for (i=beg; i<beg+len; i++)
          memcpy(((char*)s_array->ptr)+size*i, val, size);
        return argv[1];
      } else {
        rb_raise(rb_eArgError, "wrong type of the 2nd argument");
      }
      break;
    case 16:
      if (rb_class_of(argv[1]) == rb_cDouble16) {
        cl_double16 *val;
        Data_Get_Struct(argv[1], cl_double16, val);
        for (i=beg; i<beg+len; i++)
          memcpy(((char*)s_array->ptr)+size*i, val, size);
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
VALUE
rb_VArray_add(int argc, VALUE *argv, VALUE self)
{
  struct_varray *s_array;
  size_t size;
  int i, j;

  if (argc!=1)
    rb_raise(rb_eArgError, "wrong number of arguments (%d for 1)", argc);
  Data_Get_Struct(self, struct_varray, s_array);
  size = s_array->size;
  if (rb_class_of(argv[0]) == rb_cVArray) {
    struct_varray *s_array1;
    Data_Get_Struct(argv[0], struct_varray, s_array1);
    if (s_array1->type == s_array->type && s_array1->n == s_array->n && s_array1->length == s_array->length) {
      switch (s_array->type) {
      case VA_CHAR:
        for (i=0; i<(int)(s_array->length*s_array->n); i++)
          ((cl_char*)s_array->ptr)[i] += ((cl_char*)s_array1->ptr)[i];
        return self;
        break;
      case VA_UCHAR:
        for (i=0; i<(int)(s_array->length*s_array->n); i++)
          ((cl_uchar*)s_array->ptr)[i] += ((cl_uchar*)s_array1->ptr)[i];
        return self;
        break;
      case VA_SHORT:
        for (i=0; i<(int)(s_array->length*s_array->n); i++)
          ((cl_short*)s_array->ptr)[i] += ((cl_short*)s_array1->ptr)[i];
        return self;
        break;
      case VA_USHORT:
        for (i=0; i<(int)(s_array->length*s_array->n); i++)
          ((cl_ushort*)s_array->ptr)[i] += ((cl_ushort*)s_array1->ptr)[i];
        return self;
        break;
      case VA_INT:
        for (i=0; i<(int)(s_array->length*s_array->n); i++)
          ((cl_int*)s_array->ptr)[i] += ((cl_int*)s_array1->ptr)[i];
        return self;
        break;
      case VA_UINT:
        for (i=0; i<(int)(s_array->length*s_array->n); i++)
          ((cl_uint*)s_array->ptr)[i] += ((cl_uint*)s_array1->ptr)[i];
        return self;
        break;
      case VA_LONG:
        for (i=0; i<(int)(s_array->length*s_array->n); i++)
          ((cl_long*)s_array->ptr)[i] += ((cl_long*)s_array1->ptr)[i];
        return self;
        break;
      case VA_ULONG:
        for (i=0; i<(int)(s_array->length*s_array->n); i++)
          ((cl_ulong*)s_array->ptr)[i] += ((cl_ulong*)s_array1->ptr)[i];
        return self;
        break;
      case VA_FLOAT:
        for (i=0; i<(int)(s_array->length*s_array->n); i++)
          ((cl_float*)s_array->ptr)[i] += ((cl_float*)s_array1->ptr)[i];
        return self;
        break;
      case VA_DOUBLE:
        for (i=0; i<(int)(s_array->length*s_array->n); i++)
          ((cl_double*)s_array->ptr)[i] += ((cl_double*)s_array1->ptr)[i];
        return self;
        break;
      default:
        rb_raise(rb_eRuntimeError, "[BUG]");
      }
    } else {
      rb_raise(rb_eArgError, "type_code or length is invalid");
    }
  }
  switch (s_array->type) {
  case VA_CHAR:
    if (rb_obj_is_kind_of(argv[0], rb_cNumeric)==Qtrue) {
      cl_char val = NUM2CHR(argv[0]);
      for (i=0; i<(int)(s_array->length*s_array->n); i++)
        ((cl_char*)s_array->ptr)[i] += val;
      return self;
    }
    switch (s_array->n) {
    case 2:
      if (rb_class_of(argv[0]) == rb_cChar2) {
        cl_char2 *val;
        Data_Get_Struct(argv[0], cl_char2, val);
        for (i=0; i<(int)s_array->length; i++)
          for (j=0; j<(int)s_array->n; j++)
          ((cl_char*)(((char*)s_array->ptr)+s_array->size*i))[j] += ((cl_char*)val)[j];
        return self;
      } else {
        rb_raise(rb_eArgError, "wrong type of the argument");
      }
      break;
    case 4:
      if (rb_class_of(argv[0]) == rb_cChar4) {
        cl_char4 *val;
        Data_Get_Struct(argv[0], cl_char4, val);
        for (i=0; i<(int)s_array->length; i++)
          for (j=0; j<(int)s_array->n; j++)
          ((cl_char*)(((char*)s_array->ptr)+s_array->size*i))[j] += ((cl_char*)val)[j];
        return self;
      } else {
        rb_raise(rb_eArgError, "wrong type of the argument");
      }
      break;
    case 8:
      if (rb_class_of(argv[0]) == rb_cChar8) {
        cl_char8 *val;
        Data_Get_Struct(argv[0], cl_char8, val);
        for (i=0; i<(int)s_array->length; i++)
          for (j=0; j<(int)s_array->n; j++)
          ((cl_char*)(((char*)s_array->ptr)+s_array->size*i))[j] += ((cl_char*)val)[j];
        return self;
      } else {
        rb_raise(rb_eArgError, "wrong type of the argument");
      }
      break;
    case 16:
      if (rb_class_of(argv[0]) == rb_cChar16) {
        cl_char16 *val;
        Data_Get_Struct(argv[0], cl_char16, val);
        for (i=0; i<(int)s_array->length; i++)
          for (j=0; j<(int)s_array->n; j++)
          ((cl_char*)(((char*)s_array->ptr)+s_array->size*i))[j] += ((cl_char*)val)[j];
        return self;
      } else {
        rb_raise(rb_eArgError, "wrong type of the argument");
      }
      break;
    default:
      rb_raise(rb_eArgError, "wrong type of the argument");
    }
    break;
  case VA_UCHAR:
    if (rb_obj_is_kind_of(argv[0], rb_cNumeric)==Qtrue) {
      cl_uchar val = (uint8_t)NUM2UINT(argv[0]);
      for (i=0; i<(int)(s_array->length*s_array->n); i++)
        ((cl_uchar*)s_array->ptr)[i] += val;
      return self;
    }
    switch (s_array->n) {
    case 2:
      if (rb_class_of(argv[0]) == rb_cUchar2) {
        cl_uchar2 *val;
        Data_Get_Struct(argv[0], cl_uchar2, val);
        for (i=0; i<(int)s_array->length; i++)
          for (j=0; j<(int)s_array->n; j++)
          ((cl_uchar*)(((char*)s_array->ptr)+s_array->size*i))[j] += ((cl_uchar*)val)[j];
        return self;
      } else {
        rb_raise(rb_eArgError, "wrong type of the argument");
      }
      break;
    case 4:
      if (rb_class_of(argv[0]) == rb_cUchar4) {
        cl_uchar4 *val;
        Data_Get_Struct(argv[0], cl_uchar4, val);
        for (i=0; i<(int)s_array->length; i++)
          for (j=0; j<(int)s_array->n; j++)
          ((cl_uchar*)(((char*)s_array->ptr)+s_array->size*i))[j] += ((cl_uchar*)val)[j];
        return self;
      } else {
        rb_raise(rb_eArgError, "wrong type of the argument");
      }
      break;
    case 8:
      if (rb_class_of(argv[0]) == rb_cUchar8) {
        cl_uchar8 *val;
        Data_Get_Struct(argv[0], cl_uchar8, val);
        for (i=0; i<(int)s_array->length; i++)
          for (j=0; j<(int)s_array->n; j++)
          ((cl_uchar*)(((char*)s_array->ptr)+s_array->size*i))[j] += ((cl_uchar*)val)[j];
        return self;
      } else {
        rb_raise(rb_eArgError, "wrong type of the argument");
      }
      break;
    case 16:
      if (rb_class_of(argv[0]) == rb_cUchar16) {
        cl_uchar16 *val;
        Data_Get_Struct(argv[0], cl_uchar16, val);
        for (i=0; i<(int)s_array->length; i++)
          for (j=0; j<(int)s_array->n; j++)
          ((cl_uchar*)(((char*)s_array->ptr)+s_array->size*i))[j] += ((cl_uchar*)val)[j];
        return self;
      } else {
        rb_raise(rb_eArgError, "wrong type of the argument");
      }
      break;
    default:
      rb_raise(rb_eArgError, "wrong type of the argument");
    }
    break;
  case VA_SHORT:
    if (rb_obj_is_kind_of(argv[0], rb_cNumeric)==Qtrue) {
      cl_short val = (int16_t)NUM2INT(argv[0]);
      for (i=0; i<(int)(s_array->length*s_array->n); i++)
        ((cl_short*)s_array->ptr)[i] += val;
      return self;
    }
    switch (s_array->n) {
    case 2:
      if (rb_class_of(argv[0]) == rb_cShort2) {
        cl_short2 *val;
        Data_Get_Struct(argv[0], cl_short2, val);
        for (i=0; i<(int)s_array->length; i++)
          for (j=0; j<(int)s_array->n; j++)
          ((cl_short*)(((char*)s_array->ptr)+s_array->size*i))[j] += ((cl_short*)val)[j];
        return self;
      } else {
        rb_raise(rb_eArgError, "wrong type of the argument");
      }
      break;
    case 4:
      if (rb_class_of(argv[0]) == rb_cShort4) {
        cl_short4 *val;
        Data_Get_Struct(argv[0], cl_short4, val);
        for (i=0; i<(int)s_array->length; i++)
          for (j=0; j<(int)s_array->n; j++)
          ((cl_short*)(((char*)s_array->ptr)+s_array->size*i))[j] += ((cl_short*)val)[j];
        return self;
      } else {
        rb_raise(rb_eArgError, "wrong type of the argument");
      }
      break;
    case 8:
      if (rb_class_of(argv[0]) == rb_cShort8) {
        cl_short8 *val;
        Data_Get_Struct(argv[0], cl_short8, val);
        for (i=0; i<(int)s_array->length; i++)
          for (j=0; j<(int)s_array->n; j++)
          ((cl_short*)(((char*)s_array->ptr)+s_array->size*i))[j] += ((cl_short*)val)[j];
        return self;
      } else {
        rb_raise(rb_eArgError, "wrong type of the argument");
      }
      break;
    case 16:
      if (rb_class_of(argv[0]) == rb_cShort16) {
        cl_short16 *val;
        Data_Get_Struct(argv[0], cl_short16, val);
        for (i=0; i<(int)s_array->length; i++)
          for (j=0; j<(int)s_array->n; j++)
          ((cl_short*)(((char*)s_array->ptr)+s_array->size*i))[j] += ((cl_short*)val)[j];
        return self;
      } else {
        rb_raise(rb_eArgError, "wrong type of the argument");
      }
      break;
    default:
      rb_raise(rb_eArgError, "wrong type of the argument");
    }
    break;
  case VA_USHORT:
    if (rb_obj_is_kind_of(argv[0], rb_cNumeric)==Qtrue) {
      cl_ushort val = (uint16_t)NUM2UINT(argv[0]);
      for (i=0; i<(int)(s_array->length*s_array->n); i++)
        ((cl_ushort*)s_array->ptr)[i] += val;
      return self;
    }
    switch (s_array->n) {
    case 2:
      if (rb_class_of(argv[0]) == rb_cUshort2) {
        cl_ushort2 *val;
        Data_Get_Struct(argv[0], cl_ushort2, val);
        for (i=0; i<(int)s_array->length; i++)
          for (j=0; j<(int)s_array->n; j++)
          ((cl_ushort*)(((char*)s_array->ptr)+s_array->size*i))[j] += ((cl_ushort*)val)[j];
        return self;
      } else {
        rb_raise(rb_eArgError, "wrong type of the argument");
      }
      break;
    case 4:
      if (rb_class_of(argv[0]) == rb_cUshort4) {
        cl_ushort4 *val;
        Data_Get_Struct(argv[0], cl_ushort4, val);
        for (i=0; i<(int)s_array->length; i++)
          for (j=0; j<(int)s_array->n; j++)
          ((cl_ushort*)(((char*)s_array->ptr)+s_array->size*i))[j] += ((cl_ushort*)val)[j];
        return self;
      } else {
        rb_raise(rb_eArgError, "wrong type of the argument");
      }
      break;
    case 8:
      if (rb_class_of(argv[0]) == rb_cUshort8) {
        cl_ushort8 *val;
        Data_Get_Struct(argv[0], cl_ushort8, val);
        for (i=0; i<(int)s_array->length; i++)
          for (j=0; j<(int)s_array->n; j++)
          ((cl_ushort*)(((char*)s_array->ptr)+s_array->size*i))[j] += ((cl_ushort*)val)[j];
        return self;
      } else {
        rb_raise(rb_eArgError, "wrong type of the argument");
      }
      break;
    case 16:
      if (rb_class_of(argv[0]) == rb_cUshort16) {
        cl_ushort16 *val;
        Data_Get_Struct(argv[0], cl_ushort16, val);
        for (i=0; i<(int)s_array->length; i++)
          for (j=0; j<(int)s_array->n; j++)
          ((cl_ushort*)(((char*)s_array->ptr)+s_array->size*i))[j] += ((cl_ushort*)val)[j];
        return self;
      } else {
        rb_raise(rb_eArgError, "wrong type of the argument");
      }
      break;
    default:
      rb_raise(rb_eArgError, "wrong type of the argument");
    }
    break;
  case VA_INT:
    if (rb_obj_is_kind_of(argv[0], rb_cNumeric)==Qtrue) {
      cl_int val = (int32_t)NUM2INT(argv[0]);
      for (i=0; i<(int)(s_array->length*s_array->n); i++)
        ((cl_int*)s_array->ptr)[i] += val;
      return self;
    }
    switch (s_array->n) {
    case 2:
      if (rb_class_of(argv[0]) == rb_cInt2) {
        cl_int2 *val;
        Data_Get_Struct(argv[0], cl_int2, val);
        for (i=0; i<(int)s_array->length; i++)
          for (j=0; j<(int)s_array->n; j++)
          ((cl_int*)(((char*)s_array->ptr)+s_array->size*i))[j] += ((cl_int*)val)[j];
        return self;
      } else {
        rb_raise(rb_eArgError, "wrong type of the argument");
      }
      break;
    case 4:
      if (rb_class_of(argv[0]) == rb_cInt4) {
        cl_int4 *val;
        Data_Get_Struct(argv[0], cl_int4, val);
        for (i=0; i<(int)s_array->length; i++)
          for (j=0; j<(int)s_array->n; j++)
          ((cl_int*)(((char*)s_array->ptr)+s_array->size*i))[j] += ((cl_int*)val)[j];
        return self;
      } else {
        rb_raise(rb_eArgError, "wrong type of the argument");
      }
      break;
    case 8:
      if (rb_class_of(argv[0]) == rb_cInt8) {
        cl_int8 *val;
        Data_Get_Struct(argv[0], cl_int8, val);
        for (i=0; i<(int)s_array->length; i++)
          for (j=0; j<(int)s_array->n; j++)
          ((cl_int*)(((char*)s_array->ptr)+s_array->size*i))[j] += ((cl_int*)val)[j];
        return self;
      } else {
        rb_raise(rb_eArgError, "wrong type of the argument");
      }
      break;
    case 16:
      if (rb_class_of(argv[0]) == rb_cInt16) {
        cl_int16 *val;
        Data_Get_Struct(argv[0], cl_int16, val);
        for (i=0; i<(int)s_array->length; i++)
          for (j=0; j<(int)s_array->n; j++)
          ((cl_int*)(((char*)s_array->ptr)+s_array->size*i))[j] += ((cl_int*)val)[j];
        return self;
      } else {
        rb_raise(rb_eArgError, "wrong type of the argument");
      }
      break;
    default:
      rb_raise(rb_eArgError, "wrong type of the argument");
    }
    break;
  case VA_UINT:
    if (rb_obj_is_kind_of(argv[0], rb_cNumeric)==Qtrue) {
      cl_uint val = (uint32_t)NUM2UINT(argv[0]);
      for (i=0; i<(int)(s_array->length*s_array->n); i++)
        ((cl_uint*)s_array->ptr)[i] += val;
      return self;
    }
    switch (s_array->n) {
    case 2:
      if (rb_class_of(argv[0]) == rb_cUint2) {
        cl_uint2 *val;
        Data_Get_Struct(argv[0], cl_uint2, val);
        for (i=0; i<(int)s_array->length; i++)
          for (j=0; j<(int)s_array->n; j++)
          ((cl_uint*)(((char*)s_array->ptr)+s_array->size*i))[j] += ((cl_uint*)val)[j];
        return self;
      } else {
        rb_raise(rb_eArgError, "wrong type of the argument");
      }
      break;
    case 4:
      if (rb_class_of(argv[0]) == rb_cUint4) {
        cl_uint4 *val;
        Data_Get_Struct(argv[0], cl_uint4, val);
        for (i=0; i<(int)s_array->length; i++)
          for (j=0; j<(int)s_array->n; j++)
          ((cl_uint*)(((char*)s_array->ptr)+s_array->size*i))[j] += ((cl_uint*)val)[j];
        return self;
      } else {
        rb_raise(rb_eArgError, "wrong type of the argument");
      }
      break;
    case 8:
      if (rb_class_of(argv[0]) == rb_cUint8) {
        cl_uint8 *val;
        Data_Get_Struct(argv[0], cl_uint8, val);
        for (i=0; i<(int)s_array->length; i++)
          for (j=0; j<(int)s_array->n; j++)
          ((cl_uint*)(((char*)s_array->ptr)+s_array->size*i))[j] += ((cl_uint*)val)[j];
        return self;
      } else {
        rb_raise(rb_eArgError, "wrong type of the argument");
      }
      break;
    case 16:
      if (rb_class_of(argv[0]) == rb_cUint16) {
        cl_uint16 *val;
        Data_Get_Struct(argv[0], cl_uint16, val);
        for (i=0; i<(int)s_array->length; i++)
          for (j=0; j<(int)s_array->n; j++)
          ((cl_uint*)(((char*)s_array->ptr)+s_array->size*i))[j] += ((cl_uint*)val)[j];
        return self;
      } else {
        rb_raise(rb_eArgError, "wrong type of the argument");
      }
      break;
    default:
      rb_raise(rb_eArgError, "wrong type of the argument");
    }
    break;
  case VA_LONG:
    if (rb_obj_is_kind_of(argv[0], rb_cNumeric)==Qtrue) {
      cl_long val = NUM2LONG(argv[0]);
      for (i=0; i<(int)(s_array->length*s_array->n); i++)
        ((cl_long*)s_array->ptr)[i] += val;
      return self;
    }
    switch (s_array->n) {
    case 2:
      if (rb_class_of(argv[0]) == rb_cLong2) {
        cl_long2 *val;
        Data_Get_Struct(argv[0], cl_long2, val);
        for (i=0; i<(int)s_array->length; i++)
          for (j=0; j<(int)s_array->n; j++)
          ((cl_long*)(((char*)s_array->ptr)+s_array->size*i))[j] += ((cl_long*)val)[j];
        return self;
      } else {
        rb_raise(rb_eArgError, "wrong type of the argument");
      }
      break;
    case 4:
      if (rb_class_of(argv[0]) == rb_cLong4) {
        cl_long4 *val;
        Data_Get_Struct(argv[0], cl_long4, val);
        for (i=0; i<(int)s_array->length; i++)
          for (j=0; j<(int)s_array->n; j++)
          ((cl_long*)(((char*)s_array->ptr)+s_array->size*i))[j] += ((cl_long*)val)[j];
        return self;
      } else {
        rb_raise(rb_eArgError, "wrong type of the argument");
      }
      break;
    case 8:
      if (rb_class_of(argv[0]) == rb_cLong8) {
        cl_long8 *val;
        Data_Get_Struct(argv[0], cl_long8, val);
        for (i=0; i<(int)s_array->length; i++)
          for (j=0; j<(int)s_array->n; j++)
          ((cl_long*)(((char*)s_array->ptr)+s_array->size*i))[j] += ((cl_long*)val)[j];
        return self;
      } else {
        rb_raise(rb_eArgError, "wrong type of the argument");
      }
      break;
    case 16:
      if (rb_class_of(argv[0]) == rb_cLong16) {
        cl_long16 *val;
        Data_Get_Struct(argv[0], cl_long16, val);
        for (i=0; i<(int)s_array->length; i++)
          for (j=0; j<(int)s_array->n; j++)
          ((cl_long*)(((char*)s_array->ptr)+s_array->size*i))[j] += ((cl_long*)val)[j];
        return self;
      } else {
        rb_raise(rb_eArgError, "wrong type of the argument");
      }
      break;
    default:
      rb_raise(rb_eArgError, "wrong type of the argument");
    }
    break;
  case VA_ULONG:
    if (rb_obj_is_kind_of(argv[0], rb_cNumeric)==Qtrue) {
      cl_ulong val = (uint64_t)NUM2ULONG(argv[0]);
      for (i=0; i<(int)(s_array->length*s_array->n); i++)
        ((cl_ulong*)s_array->ptr)[i] += val;
      return self;
    }
    switch (s_array->n) {
    case 2:
      if (rb_class_of(argv[0]) == rb_cUlong2) {
        cl_ulong2 *val;
        Data_Get_Struct(argv[0], cl_ulong2, val);
        for (i=0; i<(int)s_array->length; i++)
          for (j=0; j<(int)s_array->n; j++)
          ((cl_ulong*)(((char*)s_array->ptr)+s_array->size*i))[j] += ((cl_ulong*)val)[j];
        return self;
      } else {
        rb_raise(rb_eArgError, "wrong type of the argument");
      }
      break;
    case 4:
      if (rb_class_of(argv[0]) == rb_cUlong4) {
        cl_ulong4 *val;
        Data_Get_Struct(argv[0], cl_ulong4, val);
        for (i=0; i<(int)s_array->length; i++)
          for (j=0; j<(int)s_array->n; j++)
          ((cl_ulong*)(((char*)s_array->ptr)+s_array->size*i))[j] += ((cl_ulong*)val)[j];
        return self;
      } else {
        rb_raise(rb_eArgError, "wrong type of the argument");
      }
      break;
    case 8:
      if (rb_class_of(argv[0]) == rb_cUlong8) {
        cl_ulong8 *val;
        Data_Get_Struct(argv[0], cl_ulong8, val);
        for (i=0; i<(int)s_array->length; i++)
          for (j=0; j<(int)s_array->n; j++)
          ((cl_ulong*)(((char*)s_array->ptr)+s_array->size*i))[j] += ((cl_ulong*)val)[j];
        return self;
      } else {
        rb_raise(rb_eArgError, "wrong type of the argument");
      }
      break;
    case 16:
      if (rb_class_of(argv[0]) == rb_cUlong16) {
        cl_ulong16 *val;
        Data_Get_Struct(argv[0], cl_ulong16, val);
        for (i=0; i<(int)s_array->length; i++)
          for (j=0; j<(int)s_array->n; j++)
          ((cl_ulong*)(((char*)s_array->ptr)+s_array->size*i))[j] += ((cl_ulong*)val)[j];
        return self;
      } else {
        rb_raise(rb_eArgError, "wrong type of the argument");
      }
      break;
    default:
      rb_raise(rb_eArgError, "wrong type of the argument");
    }
    break;
  case VA_FLOAT:
    if (rb_obj_is_kind_of(argv[0], rb_cNumeric)==Qtrue) {
      cl_float val = (float)NUM2DBL(argv[0]);
      for (i=0; i<(int)(s_array->length*s_array->n); i++)
        ((cl_float*)s_array->ptr)[i] += val;
      return self;
    }
    switch (s_array->n) {
    case 2:
      if (rb_class_of(argv[0]) == rb_cFloat2) {
        cl_float2 *val;
        Data_Get_Struct(argv[0], cl_float2, val);
        for (i=0; i<(int)s_array->length; i++)
          for (j=0; j<(int)s_array->n; j++)
          ((cl_float*)(((char*)s_array->ptr)+s_array->size*i))[j] += ((cl_float*)val)[j];
        return self;
      } else {
        rb_raise(rb_eArgError, "wrong type of the argument");
      }
      break;
    case 4:
      if (rb_class_of(argv[0]) == rb_cFloat4) {
        cl_float4 *val;
        Data_Get_Struct(argv[0], cl_float4, val);
        for (i=0; i<(int)s_array->length; i++)
          for (j=0; j<(int)s_array->n; j++)
          ((cl_float*)(((char*)s_array->ptr)+s_array->size*i))[j] += ((cl_float*)val)[j];
        return self;
      } else {
        rb_raise(rb_eArgError, "wrong type of the argument");
      }
      break;
    case 8:
      if (rb_class_of(argv[0]) == rb_cFloat8) {
        cl_float8 *val;
        Data_Get_Struct(argv[0], cl_float8, val);
        for (i=0; i<(int)s_array->length; i++)
          for (j=0; j<(int)s_array->n; j++)
          ((cl_float*)(((char*)s_array->ptr)+s_array->size*i))[j] += ((cl_float*)val)[j];
        return self;
      } else {
        rb_raise(rb_eArgError, "wrong type of the argument");
      }
      break;
    case 16:
      if (rb_class_of(argv[0]) == rb_cFloat16) {
        cl_float16 *val;
        Data_Get_Struct(argv[0], cl_float16, val);
        for (i=0; i<(int)s_array->length; i++)
          for (j=0; j<(int)s_array->n; j++)
          ((cl_float*)(((char*)s_array->ptr)+s_array->size*i))[j] += ((cl_float*)val)[j];
        return self;
      } else {
        rb_raise(rb_eArgError, "wrong type of the argument");
      }
      break;
    default:
      rb_raise(rb_eArgError, "wrong type of the argument");
    }
    break;
  case VA_DOUBLE:
    if (rb_obj_is_kind_of(argv[0], rb_cNumeric)==Qtrue) {
      cl_double val = (double)NUM2DBL(argv[0]);
      for (i=0; i<(int)(s_array->length*s_array->n); i++)
        ((cl_double*)s_array->ptr)[i] += val;
      return self;
    }
    switch (s_array->n) {
    case 2:
      if (rb_class_of(argv[0]) == rb_cDouble2) {
        cl_double2 *val;
        Data_Get_Struct(argv[0], cl_double2, val);
        for (i=0; i<(int)s_array->length; i++)
          for (j=0; j<(int)s_array->n; j++)
          ((cl_double*)(((char*)s_array->ptr)+s_array->size*i))[j] += ((cl_double*)val)[j];
        return self;
      } else {
        rb_raise(rb_eArgError, "wrong type of the argument");
      }
      break;
    case 4:
      if (rb_class_of(argv[0]) == rb_cDouble4) {
        cl_double4 *val;
        Data_Get_Struct(argv[0], cl_double4, val);
        for (i=0; i<(int)s_array->length; i++)
          for (j=0; j<(int)s_array->n; j++)
          ((cl_double*)(((char*)s_array->ptr)+s_array->size*i))[j] += ((cl_double*)val)[j];
        return self;
      } else {
        rb_raise(rb_eArgError, "wrong type of the argument");
      }
      break;
    case 8:
      if (rb_class_of(argv[0]) == rb_cDouble8) {
        cl_double8 *val;
        Data_Get_Struct(argv[0], cl_double8, val);
        for (i=0; i<(int)s_array->length; i++)
          for (j=0; j<(int)s_array->n; j++)
          ((cl_double*)(((char*)s_array->ptr)+s_array->size*i))[j] += ((cl_double*)val)[j];
        return self;
      } else {
        rb_raise(rb_eArgError, "wrong type of the argument");
      }
      break;
    case 16:
      if (rb_class_of(argv[0]) == rb_cDouble16) {
        cl_double16 *val;
        Data_Get_Struct(argv[0], cl_double16, val);
        for (i=0; i<(int)s_array->length; i++)
          for (j=0; j<(int)s_array->n; j++)
          ((cl_double*)(((char*)s_array->ptr)+s_array->size*i))[j] += ((cl_double*)val)[j];
        return self;
      } else {
        rb_raise(rb_eArgError, "wrong type of the argument");
      }
      break;
    default:
      rb_raise(rb_eArgError, "wrong type of the argument");
    }
    break;
  default:
    rb_raise(rb_eRuntimeError, "[BUG] invalid type");
  }

  return Qnil;
}
VALUE
rb_VArray_sbt(int argc, VALUE *argv, VALUE self)
{
  struct_varray *s_array;
  size_t size;
  int i, j;

  if (argc!=1)
    rb_raise(rb_eArgError, "wrong number of arguments (%d for 1)", argc);
  Data_Get_Struct(self, struct_varray, s_array);
  size = s_array->size;
  if (rb_class_of(argv[0]) == rb_cVArray) {
    struct_varray *s_array1;
    Data_Get_Struct(argv[0], struct_varray, s_array1);
    if (s_array1->type == s_array->type && s_array1->n == s_array->n && s_array1->length == s_array->length) {
      switch (s_array->type) {
      case VA_CHAR:
        for (i=0; i<(int)(s_array->length*s_array->n); i++)
          ((cl_char*)s_array->ptr)[i] = ((cl_char*)s_array1->ptr)[i];
        return self;
        break;
      case VA_UCHAR:
        for (i=0; i<(int)(s_array->length*s_array->n); i++)
          ((cl_uchar*)s_array->ptr)[i] = ((cl_uchar*)s_array1->ptr)[i];
        return self;
        break;
      case VA_SHORT:
        for (i=0; i<(int)(s_array->length*s_array->n); i++)
          ((cl_short*)s_array->ptr)[i] = ((cl_short*)s_array1->ptr)[i];
        return self;
        break;
      case VA_USHORT:
        for (i=0; i<(int)(s_array->length*s_array->n); i++)
          ((cl_ushort*)s_array->ptr)[i] = ((cl_ushort*)s_array1->ptr)[i];
        return self;
        break;
      case VA_INT:
        for (i=0; i<(int)(s_array->length*s_array->n); i++)
          ((cl_int*)s_array->ptr)[i] = ((cl_int*)s_array1->ptr)[i];
        return self;
        break;
      case VA_UINT:
        for (i=0; i<(int)(s_array->length*s_array->n); i++)
          ((cl_uint*)s_array->ptr)[i] = ((cl_uint*)s_array1->ptr)[i];
        return self;
        break;
      case VA_LONG:
        for (i=0; i<(int)(s_array->length*s_array->n); i++)
          ((cl_long*)s_array->ptr)[i] = ((cl_long*)s_array1->ptr)[i];
        return self;
        break;
      case VA_ULONG:
        for (i=0; i<(int)(s_array->length*s_array->n); i++)
          ((cl_ulong*)s_array->ptr)[i] = ((cl_ulong*)s_array1->ptr)[i];
        return self;
        break;
      case VA_FLOAT:
        for (i=0; i<(int)(s_array->length*s_array->n); i++)
          ((cl_float*)s_array->ptr)[i] = ((cl_float*)s_array1->ptr)[i];
        return self;
        break;
      case VA_DOUBLE:
        for (i=0; i<(int)(s_array->length*s_array->n); i++)
          ((cl_double*)s_array->ptr)[i] = ((cl_double*)s_array1->ptr)[i];
        return self;
        break;
      default:
        rb_raise(rb_eRuntimeError, "[BUG]");
      }
    } else {
      rb_raise(rb_eArgError, "type_code or length is invalid");
    }
  }
  switch (s_array->type) {
  case VA_CHAR:
    if (rb_obj_is_kind_of(argv[0], rb_cNumeric)==Qtrue) {
      cl_char val = NUM2CHR(argv[0]);
      for (i=0; i<(int)(s_array->length*s_array->n); i++)
        ((cl_char*)s_array->ptr)[i] = val;
      return self;
    }
    switch (s_array->n) {
    case 2:
      if (rb_class_of(argv[0]) == rb_cChar2) {
        cl_char2 *val;
        Data_Get_Struct(argv[0], cl_char2, val);
        for (i=0; i<(int)s_array->length; i++)
          for (j=0; j<(int)s_array->n; j++)
          ((cl_char*)(((char*)s_array->ptr)+s_array->size*i))[j] = ((cl_char*)val)[j];
        return self;
      } else {
        rb_raise(rb_eArgError, "wrong type of the argument");
      }
      break;
    case 4:
      if (rb_class_of(argv[0]) == rb_cChar4) {
        cl_char4 *val;
        Data_Get_Struct(argv[0], cl_char4, val);
        for (i=0; i<(int)s_array->length; i++)
          for (j=0; j<(int)s_array->n; j++)
          ((cl_char*)(((char*)s_array->ptr)+s_array->size*i))[j] = ((cl_char*)val)[j];
        return self;
      } else {
        rb_raise(rb_eArgError, "wrong type of the argument");
      }
      break;
    case 8:
      if (rb_class_of(argv[0]) == rb_cChar8) {
        cl_char8 *val;
        Data_Get_Struct(argv[0], cl_char8, val);
        for (i=0; i<(int)s_array->length; i++)
          for (j=0; j<(int)s_array->n; j++)
          ((cl_char*)(((char*)s_array->ptr)+s_array->size*i))[j] = ((cl_char*)val)[j];
        return self;
      } else {
        rb_raise(rb_eArgError, "wrong type of the argument");
      }
      break;
    case 16:
      if (rb_class_of(argv[0]) == rb_cChar16) {
        cl_char16 *val;
        Data_Get_Struct(argv[0], cl_char16, val);
        for (i=0; i<(int)s_array->length; i++)
          for (j=0; j<(int)s_array->n; j++)
          ((cl_char*)(((char*)s_array->ptr)+s_array->size*i))[j] = ((cl_char*)val)[j];
        return self;
      } else {
        rb_raise(rb_eArgError, "wrong type of the argument");
      }
      break;
    default:
      rb_raise(rb_eArgError, "wrong type of the argument");
    }
    break;
  case VA_UCHAR:
    if (rb_obj_is_kind_of(argv[0], rb_cNumeric)==Qtrue) {
      cl_uchar val = (uint8_t)NUM2UINT(argv[0]);
      for (i=0; i<(int)(s_array->length*s_array->n); i++)
        ((cl_uchar*)s_array->ptr)[i] = val;
      return self;
    }
    switch (s_array->n) {
    case 2:
      if (rb_class_of(argv[0]) == rb_cUchar2) {
        cl_uchar2 *val;
        Data_Get_Struct(argv[0], cl_uchar2, val);
        for (i=0; i<(int)s_array->length; i++)
          for (j=0; j<(int)s_array->n; j++)
          ((cl_uchar*)(((char*)s_array->ptr)+s_array->size*i))[j] = ((cl_uchar*)val)[j];
        return self;
      } else {
        rb_raise(rb_eArgError, "wrong type of the argument");
      }
      break;
    case 4:
      if (rb_class_of(argv[0]) == rb_cUchar4) {
        cl_uchar4 *val;
        Data_Get_Struct(argv[0], cl_uchar4, val);
        for (i=0; i<(int)s_array->length; i++)
          for (j=0; j<(int)s_array->n; j++)
          ((cl_uchar*)(((char*)s_array->ptr)+s_array->size*i))[j] = ((cl_uchar*)val)[j];
        return self;
      } else {
        rb_raise(rb_eArgError, "wrong type of the argument");
      }
      break;
    case 8:
      if (rb_class_of(argv[0]) == rb_cUchar8) {
        cl_uchar8 *val;
        Data_Get_Struct(argv[0], cl_uchar8, val);
        for (i=0; i<(int)s_array->length; i++)
          for (j=0; j<(int)s_array->n; j++)
          ((cl_uchar*)(((char*)s_array->ptr)+s_array->size*i))[j] = ((cl_uchar*)val)[j];
        return self;
      } else {
        rb_raise(rb_eArgError, "wrong type of the argument");
      }
      break;
    case 16:
      if (rb_class_of(argv[0]) == rb_cUchar16) {
        cl_uchar16 *val;
        Data_Get_Struct(argv[0], cl_uchar16, val);
        for (i=0; i<(int)s_array->length; i++)
          for (j=0; j<(int)s_array->n; j++)
          ((cl_uchar*)(((char*)s_array->ptr)+s_array->size*i))[j] = ((cl_uchar*)val)[j];
        return self;
      } else {
        rb_raise(rb_eArgError, "wrong type of the argument");
      }
      break;
    default:
      rb_raise(rb_eArgError, "wrong type of the argument");
    }
    break;
  case VA_SHORT:
    if (rb_obj_is_kind_of(argv[0], rb_cNumeric)==Qtrue) {
      cl_short val = (int16_t)NUM2INT(argv[0]);
      for (i=0; i<(int)(s_array->length*s_array->n); i++)
        ((cl_short*)s_array->ptr)[i] = val;
      return self;
    }
    switch (s_array->n) {
    case 2:
      if (rb_class_of(argv[0]) == rb_cShort2) {
        cl_short2 *val;
        Data_Get_Struct(argv[0], cl_short2, val);
        for (i=0; i<(int)s_array->length; i++)
          for (j=0; j<(int)s_array->n; j++)
          ((cl_short*)(((char*)s_array->ptr)+s_array->size*i))[j] = ((cl_short*)val)[j];
        return self;
      } else {
        rb_raise(rb_eArgError, "wrong type of the argument");
      }
      break;
    case 4:
      if (rb_class_of(argv[0]) == rb_cShort4) {
        cl_short4 *val;
        Data_Get_Struct(argv[0], cl_short4, val);
        for (i=0; i<(int)s_array->length; i++)
          for (j=0; j<(int)s_array->n; j++)
          ((cl_short*)(((char*)s_array->ptr)+s_array->size*i))[j] = ((cl_short*)val)[j];
        return self;
      } else {
        rb_raise(rb_eArgError, "wrong type of the argument");
      }
      break;
    case 8:
      if (rb_class_of(argv[0]) == rb_cShort8) {
        cl_short8 *val;
        Data_Get_Struct(argv[0], cl_short8, val);
        for (i=0; i<(int)s_array->length; i++)
          for (j=0; j<(int)s_array->n; j++)
          ((cl_short*)(((char*)s_array->ptr)+s_array->size*i))[j] = ((cl_short*)val)[j];
        return self;
      } else {
        rb_raise(rb_eArgError, "wrong type of the argument");
      }
      break;
    case 16:
      if (rb_class_of(argv[0]) == rb_cShort16) {
        cl_short16 *val;
        Data_Get_Struct(argv[0], cl_short16, val);
        for (i=0; i<(int)s_array->length; i++)
          for (j=0; j<(int)s_array->n; j++)
          ((cl_short*)(((char*)s_array->ptr)+s_array->size*i))[j] = ((cl_short*)val)[j];
        return self;
      } else {
        rb_raise(rb_eArgError, "wrong type of the argument");
      }
      break;
    default:
      rb_raise(rb_eArgError, "wrong type of the argument");
    }
    break;
  case VA_USHORT:
    if (rb_obj_is_kind_of(argv[0], rb_cNumeric)==Qtrue) {
      cl_ushort val = (uint16_t)NUM2UINT(argv[0]);
      for (i=0; i<(int)(s_array->length*s_array->n); i++)
        ((cl_ushort*)s_array->ptr)[i] = val;
      return self;
    }
    switch (s_array->n) {
    case 2:
      if (rb_class_of(argv[0]) == rb_cUshort2) {
        cl_ushort2 *val;
        Data_Get_Struct(argv[0], cl_ushort2, val);
        for (i=0; i<(int)s_array->length; i++)
          for (j=0; j<(int)s_array->n; j++)
          ((cl_ushort*)(((char*)s_array->ptr)+s_array->size*i))[j] = ((cl_ushort*)val)[j];
        return self;
      } else {
        rb_raise(rb_eArgError, "wrong type of the argument");
      }
      break;
    case 4:
      if (rb_class_of(argv[0]) == rb_cUshort4) {
        cl_ushort4 *val;
        Data_Get_Struct(argv[0], cl_ushort4, val);
        for (i=0; i<(int)s_array->length; i++)
          for (j=0; j<(int)s_array->n; j++)
          ((cl_ushort*)(((char*)s_array->ptr)+s_array->size*i))[j] = ((cl_ushort*)val)[j];
        return self;
      } else {
        rb_raise(rb_eArgError, "wrong type of the argument");
      }
      break;
    case 8:
      if (rb_class_of(argv[0]) == rb_cUshort8) {
        cl_ushort8 *val;
        Data_Get_Struct(argv[0], cl_ushort8, val);
        for (i=0; i<(int)s_array->length; i++)
          for (j=0; j<(int)s_array->n; j++)
          ((cl_ushort*)(((char*)s_array->ptr)+s_array->size*i))[j] = ((cl_ushort*)val)[j];
        return self;
      } else {
        rb_raise(rb_eArgError, "wrong type of the argument");
      }
      break;
    case 16:
      if (rb_class_of(argv[0]) == rb_cUshort16) {
        cl_ushort16 *val;
        Data_Get_Struct(argv[0], cl_ushort16, val);
        for (i=0; i<(int)s_array->length; i++)
          for (j=0; j<(int)s_array->n; j++)
          ((cl_ushort*)(((char*)s_array->ptr)+s_array->size*i))[j] = ((cl_ushort*)val)[j];
        return self;
      } else {
        rb_raise(rb_eArgError, "wrong type of the argument");
      }
      break;
    default:
      rb_raise(rb_eArgError, "wrong type of the argument");
    }
    break;
  case VA_INT:
    if (rb_obj_is_kind_of(argv[0], rb_cNumeric)==Qtrue) {
      cl_int val = (int32_t)NUM2INT(argv[0]);
      for (i=0; i<(int)(s_array->length*s_array->n); i++)
        ((cl_int*)s_array->ptr)[i] = val;
      return self;
    }
    switch (s_array->n) {
    case 2:
      if (rb_class_of(argv[0]) == rb_cInt2) {
        cl_int2 *val;
        Data_Get_Struct(argv[0], cl_int2, val);
        for (i=0; i<(int)s_array->length; i++)
          for (j=0; j<(int)s_array->n; j++)
          ((cl_int*)(((char*)s_array->ptr)+s_array->size*i))[j] = ((cl_int*)val)[j];
        return self;
      } else {
        rb_raise(rb_eArgError, "wrong type of the argument");
      }
      break;
    case 4:
      if (rb_class_of(argv[0]) == rb_cInt4) {
        cl_int4 *val;
        Data_Get_Struct(argv[0], cl_int4, val);
        for (i=0; i<(int)s_array->length; i++)
          for (j=0; j<(int)s_array->n; j++)
          ((cl_int*)(((char*)s_array->ptr)+s_array->size*i))[j] = ((cl_int*)val)[j];
        return self;
      } else {
        rb_raise(rb_eArgError, "wrong type of the argument");
      }
      break;
    case 8:
      if (rb_class_of(argv[0]) == rb_cInt8) {
        cl_int8 *val;
        Data_Get_Struct(argv[0], cl_int8, val);
        for (i=0; i<(int)s_array->length; i++)
          for (j=0; j<(int)s_array->n; j++)
          ((cl_int*)(((char*)s_array->ptr)+s_array->size*i))[j] = ((cl_int*)val)[j];
        return self;
      } else {
        rb_raise(rb_eArgError, "wrong type of the argument");
      }
      break;
    case 16:
      if (rb_class_of(argv[0]) == rb_cInt16) {
        cl_int16 *val;
        Data_Get_Struct(argv[0], cl_int16, val);
        for (i=0; i<(int)s_array->length; i++)
          for (j=0; j<(int)s_array->n; j++)
          ((cl_int*)(((char*)s_array->ptr)+s_array->size*i))[j] = ((cl_int*)val)[j];
        return self;
      } else {
        rb_raise(rb_eArgError, "wrong type of the argument");
      }
      break;
    default:
      rb_raise(rb_eArgError, "wrong type of the argument");
    }
    break;
  case VA_UINT:
    if (rb_obj_is_kind_of(argv[0], rb_cNumeric)==Qtrue) {
      cl_uint val = (uint32_t)NUM2UINT(argv[0]);
      for (i=0; i<(int)(s_array->length*s_array->n); i++)
        ((cl_uint*)s_array->ptr)[i] = val;
      return self;
    }
    switch (s_array->n) {
    case 2:
      if (rb_class_of(argv[0]) == rb_cUint2) {
        cl_uint2 *val;
        Data_Get_Struct(argv[0], cl_uint2, val);
        for (i=0; i<(int)s_array->length; i++)
          for (j=0; j<(int)s_array->n; j++)
          ((cl_uint*)(((char*)s_array->ptr)+s_array->size*i))[j] = ((cl_uint*)val)[j];
        return self;
      } else {
        rb_raise(rb_eArgError, "wrong type of the argument");
      }
      break;
    case 4:
      if (rb_class_of(argv[0]) == rb_cUint4) {
        cl_uint4 *val;
        Data_Get_Struct(argv[0], cl_uint4, val);
        for (i=0; i<(int)s_array->length; i++)
          for (j=0; j<(int)s_array->n; j++)
          ((cl_uint*)(((char*)s_array->ptr)+s_array->size*i))[j] = ((cl_uint*)val)[j];
        return self;
      } else {
        rb_raise(rb_eArgError, "wrong type of the argument");
      }
      break;
    case 8:
      if (rb_class_of(argv[0]) == rb_cUint8) {
        cl_uint8 *val;
        Data_Get_Struct(argv[0], cl_uint8, val);
        for (i=0; i<(int)s_array->length; i++)
          for (j=0; j<(int)s_array->n; j++)
          ((cl_uint*)(((char*)s_array->ptr)+s_array->size*i))[j] = ((cl_uint*)val)[j];
        return self;
      } else {
        rb_raise(rb_eArgError, "wrong type of the argument");
      }
      break;
    case 16:
      if (rb_class_of(argv[0]) == rb_cUint16) {
        cl_uint16 *val;
        Data_Get_Struct(argv[0], cl_uint16, val);
        for (i=0; i<(int)s_array->length; i++)
          for (j=0; j<(int)s_array->n; j++)
          ((cl_uint*)(((char*)s_array->ptr)+s_array->size*i))[j] = ((cl_uint*)val)[j];
        return self;
      } else {
        rb_raise(rb_eArgError, "wrong type of the argument");
      }
      break;
    default:
      rb_raise(rb_eArgError, "wrong type of the argument");
    }
    break;
  case VA_LONG:
    if (rb_obj_is_kind_of(argv[0], rb_cNumeric)==Qtrue) {
      cl_long val = NUM2LONG(argv[0]);
      for (i=0; i<(int)(s_array->length*s_array->n); i++)
        ((cl_long*)s_array->ptr)[i] = val;
      return self;
    }
    switch (s_array->n) {
    case 2:
      if (rb_class_of(argv[0]) == rb_cLong2) {
        cl_long2 *val;
        Data_Get_Struct(argv[0], cl_long2, val);
        for (i=0; i<(int)s_array->length; i++)
          for (j=0; j<(int)s_array->n; j++)
          ((cl_long*)(((char*)s_array->ptr)+s_array->size*i))[j] = ((cl_long*)val)[j];
        return self;
      } else {
        rb_raise(rb_eArgError, "wrong type of the argument");
      }
      break;
    case 4:
      if (rb_class_of(argv[0]) == rb_cLong4) {
        cl_long4 *val;
        Data_Get_Struct(argv[0], cl_long4, val);
        for (i=0; i<(int)s_array->length; i++)
          for (j=0; j<(int)s_array->n; j++)
          ((cl_long*)(((char*)s_array->ptr)+s_array->size*i))[j] = ((cl_long*)val)[j];
        return self;
      } else {
        rb_raise(rb_eArgError, "wrong type of the argument");
      }
      break;
    case 8:
      if (rb_class_of(argv[0]) == rb_cLong8) {
        cl_long8 *val;
        Data_Get_Struct(argv[0], cl_long8, val);
        for (i=0; i<(int)s_array->length; i++)
          for (j=0; j<(int)s_array->n; j++)
          ((cl_long*)(((char*)s_array->ptr)+s_array->size*i))[j] = ((cl_long*)val)[j];
        return self;
      } else {
        rb_raise(rb_eArgError, "wrong type of the argument");
      }
      break;
    case 16:
      if (rb_class_of(argv[0]) == rb_cLong16) {
        cl_long16 *val;
        Data_Get_Struct(argv[0], cl_long16, val);
        for (i=0; i<(int)s_array->length; i++)
          for (j=0; j<(int)s_array->n; j++)
          ((cl_long*)(((char*)s_array->ptr)+s_array->size*i))[j] = ((cl_long*)val)[j];
        return self;
      } else {
        rb_raise(rb_eArgError, "wrong type of the argument");
      }
      break;
    default:
      rb_raise(rb_eArgError, "wrong type of the argument");
    }
    break;
  case VA_ULONG:
    if (rb_obj_is_kind_of(argv[0], rb_cNumeric)==Qtrue) {
      cl_ulong val = (uint64_t)NUM2ULONG(argv[0]);
      for (i=0; i<(int)(s_array->length*s_array->n); i++)
        ((cl_ulong*)s_array->ptr)[i] = val;
      return self;
    }
    switch (s_array->n) {
    case 2:
      if (rb_class_of(argv[0]) == rb_cUlong2) {
        cl_ulong2 *val;
        Data_Get_Struct(argv[0], cl_ulong2, val);
        for (i=0; i<(int)s_array->length; i++)
          for (j=0; j<(int)s_array->n; j++)
          ((cl_ulong*)(((char*)s_array->ptr)+s_array->size*i))[j] = ((cl_ulong*)val)[j];
        return self;
      } else {
        rb_raise(rb_eArgError, "wrong type of the argument");
      }
      break;
    case 4:
      if (rb_class_of(argv[0]) == rb_cUlong4) {
        cl_ulong4 *val;
        Data_Get_Struct(argv[0], cl_ulong4, val);
        for (i=0; i<(int)s_array->length; i++)
          for (j=0; j<(int)s_array->n; j++)
          ((cl_ulong*)(((char*)s_array->ptr)+s_array->size*i))[j] = ((cl_ulong*)val)[j];
        return self;
      } else {
        rb_raise(rb_eArgError, "wrong type of the argument");
      }
      break;
    case 8:
      if (rb_class_of(argv[0]) == rb_cUlong8) {
        cl_ulong8 *val;
        Data_Get_Struct(argv[0], cl_ulong8, val);
        for (i=0; i<(int)s_array->length; i++)
          for (j=0; j<(int)s_array->n; j++)
          ((cl_ulong*)(((char*)s_array->ptr)+s_array->size*i))[j] = ((cl_ulong*)val)[j];
        return self;
      } else {
        rb_raise(rb_eArgError, "wrong type of the argument");
      }
      break;
    case 16:
      if (rb_class_of(argv[0]) == rb_cUlong16) {
        cl_ulong16 *val;
        Data_Get_Struct(argv[0], cl_ulong16, val);
        for (i=0; i<(int)s_array->length; i++)
          for (j=0; j<(int)s_array->n; j++)
          ((cl_ulong*)(((char*)s_array->ptr)+s_array->size*i))[j] = ((cl_ulong*)val)[j];
        return self;
      } else {
        rb_raise(rb_eArgError, "wrong type of the argument");
      }
      break;
    default:
      rb_raise(rb_eArgError, "wrong type of the argument");
    }
    break;
  case VA_FLOAT:
    if (rb_obj_is_kind_of(argv[0], rb_cNumeric)==Qtrue) {
      cl_float val = (float)NUM2DBL(argv[0]);
      for (i=0; i<(int)(s_array->length*s_array->n); i++)
        ((cl_float*)s_array->ptr)[i] = val;
      return self;
    }
    switch (s_array->n) {
    case 2:
      if (rb_class_of(argv[0]) == rb_cFloat2) {
        cl_float2 *val;
        Data_Get_Struct(argv[0], cl_float2, val);
        for (i=0; i<(int)s_array->length; i++)
          for (j=0; j<(int)s_array->n; j++)
          ((cl_float*)(((char*)s_array->ptr)+s_array->size*i))[j] = ((cl_float*)val)[j];
        return self;
      } else {
        rb_raise(rb_eArgError, "wrong type of the argument");
      }
      break;
    case 4:
      if (rb_class_of(argv[0]) == rb_cFloat4) {
        cl_float4 *val;
        Data_Get_Struct(argv[0], cl_float4, val);
        for (i=0; i<(int)s_array->length; i++)
          for (j=0; j<(int)s_array->n; j++)
          ((cl_float*)(((char*)s_array->ptr)+s_array->size*i))[j] = ((cl_float*)val)[j];
        return self;
      } else {
        rb_raise(rb_eArgError, "wrong type of the argument");
      }
      break;
    case 8:
      if (rb_class_of(argv[0]) == rb_cFloat8) {
        cl_float8 *val;
        Data_Get_Struct(argv[0], cl_float8, val);
        for (i=0; i<(int)s_array->length; i++)
          for (j=0; j<(int)s_array->n; j++)
          ((cl_float*)(((char*)s_array->ptr)+s_array->size*i))[j] = ((cl_float*)val)[j];
        return self;
      } else {
        rb_raise(rb_eArgError, "wrong type of the argument");
      }
      break;
    case 16:
      if (rb_class_of(argv[0]) == rb_cFloat16) {
        cl_float16 *val;
        Data_Get_Struct(argv[0], cl_float16, val);
        for (i=0; i<(int)s_array->length; i++)
          for (j=0; j<(int)s_array->n; j++)
          ((cl_float*)(((char*)s_array->ptr)+s_array->size*i))[j] = ((cl_float*)val)[j];
        return self;
      } else {
        rb_raise(rb_eArgError, "wrong type of the argument");
      }
      break;
    default:
      rb_raise(rb_eArgError, "wrong type of the argument");
    }
    break;
  case VA_DOUBLE:
    if (rb_obj_is_kind_of(argv[0], rb_cNumeric)==Qtrue) {
      cl_double val = (double)NUM2DBL(argv[0]);
      for (i=0; i<(int)(s_array->length*s_array->n); i++)
        ((cl_double*)s_array->ptr)[i] = val;
      return self;
    }
    switch (s_array->n) {
    case 2:
      if (rb_class_of(argv[0]) == rb_cDouble2) {
        cl_double2 *val;
        Data_Get_Struct(argv[0], cl_double2, val);
        for (i=0; i<(int)s_array->length; i++)
          for (j=0; j<(int)s_array->n; j++)
          ((cl_double*)(((char*)s_array->ptr)+s_array->size*i))[j] = ((cl_double*)val)[j];
        return self;
      } else {
        rb_raise(rb_eArgError, "wrong type of the argument");
      }
      break;
    case 4:
      if (rb_class_of(argv[0]) == rb_cDouble4) {
        cl_double4 *val;
        Data_Get_Struct(argv[0], cl_double4, val);
        for (i=0; i<(int)s_array->length; i++)
          for (j=0; j<(int)s_array->n; j++)
          ((cl_double*)(((char*)s_array->ptr)+s_array->size*i))[j] = ((cl_double*)val)[j];
        return self;
      } else {
        rb_raise(rb_eArgError, "wrong type of the argument");
      }
      break;
    case 8:
      if (rb_class_of(argv[0]) == rb_cDouble8) {
        cl_double8 *val;
        Data_Get_Struct(argv[0], cl_double8, val);
        for (i=0; i<(int)s_array->length; i++)
          for (j=0; j<(int)s_array->n; j++)
          ((cl_double*)(((char*)s_array->ptr)+s_array->size*i))[j] = ((cl_double*)val)[j];
        return self;
      } else {
        rb_raise(rb_eArgError, "wrong type of the argument");
      }
      break;
    case 16:
      if (rb_class_of(argv[0]) == rb_cDouble16) {
        cl_double16 *val;
        Data_Get_Struct(argv[0], cl_double16, val);
        for (i=0; i<(int)s_array->length; i++)
          for (j=0; j<(int)s_array->n; j++)
          ((cl_double*)(((char*)s_array->ptr)+s_array->size*i))[j] = ((cl_double*)val)[j];
        return self;
      } else {
        rb_raise(rb_eArgError, "wrong type of the argument");
      }
      break;
    default:
      rb_raise(rb_eArgError, "wrong type of the argument");
    }
    break;
  default:
    rb_raise(rb_eRuntimeError, "[BUG] invalid type");
  }

  return Qnil;
}
VALUE
rb_VArray_mul(int argc, VALUE *argv, VALUE self)
{
  struct_varray *s_array;
  size_t size;
  int i, j;

  if (argc!=1)
    rb_raise(rb_eArgError, "wrong number of arguments (%d for 1)", argc);
  Data_Get_Struct(self, struct_varray, s_array);
  size = s_array->size;
  if (rb_class_of(argv[0]) == rb_cVArray) {
    struct_varray *s_array1;
    Data_Get_Struct(argv[0], struct_varray, s_array1);
    if (s_array1->type == s_array->type && s_array1->n == s_array->n && s_array1->length == s_array->length) {
      switch (s_array->type) {
      case VA_CHAR:
        for (i=0; i<(int)(s_array->length*s_array->n); i++)
          ((cl_char*)s_array->ptr)[i] *= ((cl_char*)s_array1->ptr)[i];
        return self;
        break;
      case VA_UCHAR:
        for (i=0; i<(int)(s_array->length*s_array->n); i++)
          ((cl_uchar*)s_array->ptr)[i] *= ((cl_uchar*)s_array1->ptr)[i];
        return self;
        break;
      case VA_SHORT:
        for (i=0; i<(int)(s_array->length*s_array->n); i++)
          ((cl_short*)s_array->ptr)[i] *= ((cl_short*)s_array1->ptr)[i];
        return self;
        break;
      case VA_USHORT:
        for (i=0; i<(int)(s_array->length*s_array->n); i++)
          ((cl_ushort*)s_array->ptr)[i] *= ((cl_ushort*)s_array1->ptr)[i];
        return self;
        break;
      case VA_INT:
        for (i=0; i<(int)(s_array->length*s_array->n); i++)
          ((cl_int*)s_array->ptr)[i] *= ((cl_int*)s_array1->ptr)[i];
        return self;
        break;
      case VA_UINT:
        for (i=0; i<(int)(s_array->length*s_array->n); i++)
          ((cl_uint*)s_array->ptr)[i] *= ((cl_uint*)s_array1->ptr)[i];
        return self;
        break;
      case VA_LONG:
        for (i=0; i<(int)(s_array->length*s_array->n); i++)
          ((cl_long*)s_array->ptr)[i] *= ((cl_long*)s_array1->ptr)[i];
        return self;
        break;
      case VA_ULONG:
        for (i=0; i<(int)(s_array->length*s_array->n); i++)
          ((cl_ulong*)s_array->ptr)[i] *= ((cl_ulong*)s_array1->ptr)[i];
        return self;
        break;
      case VA_FLOAT:
        for (i=0; i<(int)(s_array->length*s_array->n); i++)
          ((cl_float*)s_array->ptr)[i] *= ((cl_float*)s_array1->ptr)[i];
        return self;
        break;
      case VA_DOUBLE:
        for (i=0; i<(int)(s_array->length*s_array->n); i++)
          ((cl_double*)s_array->ptr)[i] *= ((cl_double*)s_array1->ptr)[i];
        return self;
        break;
      default:
        rb_raise(rb_eRuntimeError, "[BUG]");
      }
    } else {
      rb_raise(rb_eArgError, "type_code or length is invalid");
    }
  }
  switch (s_array->type) {
  case VA_CHAR:
    if (rb_obj_is_kind_of(argv[0], rb_cNumeric)==Qtrue) {
      cl_char val = NUM2CHR(argv[0]);
      for (i=0; i<(int)(s_array->length*s_array->n); i++)
        ((cl_char*)s_array->ptr)[i] *= val;
      return self;
    }
    switch (s_array->n) {
    case 2:
      if (rb_class_of(argv[0]) == rb_cChar2) {
        cl_char2 *val;
        Data_Get_Struct(argv[0], cl_char2, val);
        for (i=0; i<(int)s_array->length; i++)
          for (j=0; j<(int)s_array->n; j++)
          ((cl_char*)(((char*)s_array->ptr)+s_array->size*i))[j] *= ((cl_char*)val)[j];
        return self;
      } else {
        rb_raise(rb_eArgError, "wrong type of the argument");
      }
      break;
    case 4:
      if (rb_class_of(argv[0]) == rb_cChar4) {
        cl_char4 *val;
        Data_Get_Struct(argv[0], cl_char4, val);
        for (i=0; i<(int)s_array->length; i++)
          for (j=0; j<(int)s_array->n; j++)
          ((cl_char*)(((char*)s_array->ptr)+s_array->size*i))[j] *= ((cl_char*)val)[j];
        return self;
      } else {
        rb_raise(rb_eArgError, "wrong type of the argument");
      }
      break;
    case 8:
      if (rb_class_of(argv[0]) == rb_cChar8) {
        cl_char8 *val;
        Data_Get_Struct(argv[0], cl_char8, val);
        for (i=0; i<(int)s_array->length; i++)
          for (j=0; j<(int)s_array->n; j++)
          ((cl_char*)(((char*)s_array->ptr)+s_array->size*i))[j] *= ((cl_char*)val)[j];
        return self;
      } else {
        rb_raise(rb_eArgError, "wrong type of the argument");
      }
      break;
    case 16:
      if (rb_class_of(argv[0]) == rb_cChar16) {
        cl_char16 *val;
        Data_Get_Struct(argv[0], cl_char16, val);
        for (i=0; i<(int)s_array->length; i++)
          for (j=0; j<(int)s_array->n; j++)
          ((cl_char*)(((char*)s_array->ptr)+s_array->size*i))[j] *= ((cl_char*)val)[j];
        return self;
      } else {
        rb_raise(rb_eArgError, "wrong type of the argument");
      }
      break;
    default:
      rb_raise(rb_eArgError, "wrong type of the argument");
    }
    break;
  case VA_UCHAR:
    if (rb_obj_is_kind_of(argv[0], rb_cNumeric)==Qtrue) {
      cl_uchar val = (uint8_t)NUM2UINT(argv[0]);
      for (i=0; i<(int)(s_array->length*s_array->n); i++)
        ((cl_uchar*)s_array->ptr)[i] *= val;
      return self;
    }
    switch (s_array->n) {
    case 2:
      if (rb_class_of(argv[0]) == rb_cUchar2) {
        cl_uchar2 *val;
        Data_Get_Struct(argv[0], cl_uchar2, val);
        for (i=0; i<(int)s_array->length; i++)
          for (j=0; j<(int)s_array->n; j++)
          ((cl_uchar*)(((char*)s_array->ptr)+s_array->size*i))[j] *= ((cl_uchar*)val)[j];
        return self;
      } else {
        rb_raise(rb_eArgError, "wrong type of the argument");
      }
      break;
    case 4:
      if (rb_class_of(argv[0]) == rb_cUchar4) {
        cl_uchar4 *val;
        Data_Get_Struct(argv[0], cl_uchar4, val);
        for (i=0; i<(int)s_array->length; i++)
          for (j=0; j<(int)s_array->n; j++)
          ((cl_uchar*)(((char*)s_array->ptr)+s_array->size*i))[j] *= ((cl_uchar*)val)[j];
        return self;
      } else {
        rb_raise(rb_eArgError, "wrong type of the argument");
      }
      break;
    case 8:
      if (rb_class_of(argv[0]) == rb_cUchar8) {
        cl_uchar8 *val;
        Data_Get_Struct(argv[0], cl_uchar8, val);
        for (i=0; i<(int)s_array->length; i++)
          for (j=0; j<(int)s_array->n; j++)
          ((cl_uchar*)(((char*)s_array->ptr)+s_array->size*i))[j] *= ((cl_uchar*)val)[j];
        return self;
      } else {
        rb_raise(rb_eArgError, "wrong type of the argument");
      }
      break;
    case 16:
      if (rb_class_of(argv[0]) == rb_cUchar16) {
        cl_uchar16 *val;
        Data_Get_Struct(argv[0], cl_uchar16, val);
        for (i=0; i<(int)s_array->length; i++)
          for (j=0; j<(int)s_array->n; j++)
          ((cl_uchar*)(((char*)s_array->ptr)+s_array->size*i))[j] *= ((cl_uchar*)val)[j];
        return self;
      } else {
        rb_raise(rb_eArgError, "wrong type of the argument");
      }
      break;
    default:
      rb_raise(rb_eArgError, "wrong type of the argument");
    }
    break;
  case VA_SHORT:
    if (rb_obj_is_kind_of(argv[0], rb_cNumeric)==Qtrue) {
      cl_short val = (int16_t)NUM2INT(argv[0]);
      for (i=0; i<(int)(s_array->length*s_array->n); i++)
        ((cl_short*)s_array->ptr)[i] *= val;
      return self;
    }
    switch (s_array->n) {
    case 2:
      if (rb_class_of(argv[0]) == rb_cShort2) {
        cl_short2 *val;
        Data_Get_Struct(argv[0], cl_short2, val);
        for (i=0; i<(int)s_array->length; i++)
          for (j=0; j<(int)s_array->n; j++)
          ((cl_short*)(((char*)s_array->ptr)+s_array->size*i))[j] *= ((cl_short*)val)[j];
        return self;
      } else {
        rb_raise(rb_eArgError, "wrong type of the argument");
      }
      break;
    case 4:
      if (rb_class_of(argv[0]) == rb_cShort4) {
        cl_short4 *val;
        Data_Get_Struct(argv[0], cl_short4, val);
        for (i=0; i<(int)s_array->length; i++)
          for (j=0; j<(int)s_array->n; j++)
          ((cl_short*)(((char*)s_array->ptr)+s_array->size*i))[j] *= ((cl_short*)val)[j];
        return self;
      } else {
        rb_raise(rb_eArgError, "wrong type of the argument");
      }
      break;
    case 8:
      if (rb_class_of(argv[0]) == rb_cShort8) {
        cl_short8 *val;
        Data_Get_Struct(argv[0], cl_short8, val);
        for (i=0; i<(int)s_array->length; i++)
          for (j=0; j<(int)s_array->n; j++)
          ((cl_short*)(((char*)s_array->ptr)+s_array->size*i))[j] *= ((cl_short*)val)[j];
        return self;
      } else {
        rb_raise(rb_eArgError, "wrong type of the argument");
      }
      break;
    case 16:
      if (rb_class_of(argv[0]) == rb_cShort16) {
        cl_short16 *val;
        Data_Get_Struct(argv[0], cl_short16, val);
        for (i=0; i<(int)s_array->length; i++)
          for (j=0; j<(int)s_array->n; j++)
          ((cl_short*)(((char*)s_array->ptr)+s_array->size*i))[j] *= ((cl_short*)val)[j];
        return self;
      } else {
        rb_raise(rb_eArgError, "wrong type of the argument");
      }
      break;
    default:
      rb_raise(rb_eArgError, "wrong type of the argument");
    }
    break;
  case VA_USHORT:
    if (rb_obj_is_kind_of(argv[0], rb_cNumeric)==Qtrue) {
      cl_ushort val = (uint16_t)NUM2UINT(argv[0]);
      for (i=0; i<(int)(s_array->length*s_array->n); i++)
        ((cl_ushort*)s_array->ptr)[i] *= val;
      return self;
    }
    switch (s_array->n) {
    case 2:
      if (rb_class_of(argv[0]) == rb_cUshort2) {
        cl_ushort2 *val;
        Data_Get_Struct(argv[0], cl_ushort2, val);
        for (i=0; i<(int)s_array->length; i++)
          for (j=0; j<(int)s_array->n; j++)
          ((cl_ushort*)(((char*)s_array->ptr)+s_array->size*i))[j] *= ((cl_ushort*)val)[j];
        return self;
      } else {
        rb_raise(rb_eArgError, "wrong type of the argument");
      }
      break;
    case 4:
      if (rb_class_of(argv[0]) == rb_cUshort4) {
        cl_ushort4 *val;
        Data_Get_Struct(argv[0], cl_ushort4, val);
        for (i=0; i<(int)s_array->length; i++)
          for (j=0; j<(int)s_array->n; j++)
          ((cl_ushort*)(((char*)s_array->ptr)+s_array->size*i))[j] *= ((cl_ushort*)val)[j];
        return self;
      } else {
        rb_raise(rb_eArgError, "wrong type of the argument");
      }
      break;
    case 8:
      if (rb_class_of(argv[0]) == rb_cUshort8) {
        cl_ushort8 *val;
        Data_Get_Struct(argv[0], cl_ushort8, val);
        for (i=0; i<(int)s_array->length; i++)
          for (j=0; j<(int)s_array->n; j++)
          ((cl_ushort*)(((char*)s_array->ptr)+s_array->size*i))[j] *= ((cl_ushort*)val)[j];
        return self;
      } else {
        rb_raise(rb_eArgError, "wrong type of the argument");
      }
      break;
    case 16:
      if (rb_class_of(argv[0]) == rb_cUshort16) {
        cl_ushort16 *val;
        Data_Get_Struct(argv[0], cl_ushort16, val);
        for (i=0; i<(int)s_array->length; i++)
          for (j=0; j<(int)s_array->n; j++)
          ((cl_ushort*)(((char*)s_array->ptr)+s_array->size*i))[j] *= ((cl_ushort*)val)[j];
        return self;
      } else {
        rb_raise(rb_eArgError, "wrong type of the argument");
      }
      break;
    default:
      rb_raise(rb_eArgError, "wrong type of the argument");
    }
    break;
  case VA_INT:
    if (rb_obj_is_kind_of(argv[0], rb_cNumeric)==Qtrue) {
      cl_int val = (int32_t)NUM2INT(argv[0]);
      for (i=0; i<(int)(s_array->length*s_array->n); i++)
        ((cl_int*)s_array->ptr)[i] *= val;
      return self;
    }
    switch (s_array->n) {
    case 2:
      if (rb_class_of(argv[0]) == rb_cInt2) {
        cl_int2 *val;
        Data_Get_Struct(argv[0], cl_int2, val);
        for (i=0; i<(int)s_array->length; i++)
          for (j=0; j<(int)s_array->n; j++)
          ((cl_int*)(((char*)s_array->ptr)+s_array->size*i))[j] *= ((cl_int*)val)[j];
        return self;
      } else {
        rb_raise(rb_eArgError, "wrong type of the argument");
      }
      break;
    case 4:
      if (rb_class_of(argv[0]) == rb_cInt4) {
        cl_int4 *val;
        Data_Get_Struct(argv[0], cl_int4, val);
        for (i=0; i<(int)s_array->length; i++)
          for (j=0; j<(int)s_array->n; j++)
          ((cl_int*)(((char*)s_array->ptr)+s_array->size*i))[j] *= ((cl_int*)val)[j];
        return self;
      } else {
        rb_raise(rb_eArgError, "wrong type of the argument");
      }
      break;
    case 8:
      if (rb_class_of(argv[0]) == rb_cInt8) {
        cl_int8 *val;
        Data_Get_Struct(argv[0], cl_int8, val);
        for (i=0; i<(int)s_array->length; i++)
          for (j=0; j<(int)s_array->n; j++)
          ((cl_int*)(((char*)s_array->ptr)+s_array->size*i))[j] *= ((cl_int*)val)[j];
        return self;
      } else {
        rb_raise(rb_eArgError, "wrong type of the argument");
      }
      break;
    case 16:
      if (rb_class_of(argv[0]) == rb_cInt16) {
        cl_int16 *val;
        Data_Get_Struct(argv[0], cl_int16, val);
        for (i=0; i<(int)s_array->length; i++)
          for (j=0; j<(int)s_array->n; j++)
          ((cl_int*)(((char*)s_array->ptr)+s_array->size*i))[j] *= ((cl_int*)val)[j];
        return self;
      } else {
        rb_raise(rb_eArgError, "wrong type of the argument");
      }
      break;
    default:
      rb_raise(rb_eArgError, "wrong type of the argument");
    }
    break;
  case VA_UINT:
    if (rb_obj_is_kind_of(argv[0], rb_cNumeric)==Qtrue) {
      cl_uint val = (uint32_t)NUM2UINT(argv[0]);
      for (i=0; i<(int)(s_array->length*s_array->n); i++)
        ((cl_uint*)s_array->ptr)[i] *= val;
      return self;
    }
    switch (s_array->n) {
    case 2:
      if (rb_class_of(argv[0]) == rb_cUint2) {
        cl_uint2 *val;
        Data_Get_Struct(argv[0], cl_uint2, val);
        for (i=0; i<(int)s_array->length; i++)
          for (j=0; j<(int)s_array->n; j++)
          ((cl_uint*)(((char*)s_array->ptr)+s_array->size*i))[j] *= ((cl_uint*)val)[j];
        return self;
      } else {
        rb_raise(rb_eArgError, "wrong type of the argument");
      }
      break;
    case 4:
      if (rb_class_of(argv[0]) == rb_cUint4) {
        cl_uint4 *val;
        Data_Get_Struct(argv[0], cl_uint4, val);
        for (i=0; i<(int)s_array->length; i++)
          for (j=0; j<(int)s_array->n; j++)
          ((cl_uint*)(((char*)s_array->ptr)+s_array->size*i))[j] *= ((cl_uint*)val)[j];
        return self;
      } else {
        rb_raise(rb_eArgError, "wrong type of the argument");
      }
      break;
    case 8:
      if (rb_class_of(argv[0]) == rb_cUint8) {
        cl_uint8 *val;
        Data_Get_Struct(argv[0], cl_uint8, val);
        for (i=0; i<(int)s_array->length; i++)
          for (j=0; j<(int)s_array->n; j++)
          ((cl_uint*)(((char*)s_array->ptr)+s_array->size*i))[j] *= ((cl_uint*)val)[j];
        return self;
      } else {
        rb_raise(rb_eArgError, "wrong type of the argument");
      }
      break;
    case 16:
      if (rb_class_of(argv[0]) == rb_cUint16) {
        cl_uint16 *val;
        Data_Get_Struct(argv[0], cl_uint16, val);
        for (i=0; i<(int)s_array->length; i++)
          for (j=0; j<(int)s_array->n; j++)
          ((cl_uint*)(((char*)s_array->ptr)+s_array->size*i))[j] *= ((cl_uint*)val)[j];
        return self;
      } else {
        rb_raise(rb_eArgError, "wrong type of the argument");
      }
      break;
    default:
      rb_raise(rb_eArgError, "wrong type of the argument");
    }
    break;
  case VA_LONG:
    if (rb_obj_is_kind_of(argv[0], rb_cNumeric)==Qtrue) {
      cl_long val = NUM2LONG(argv[0]);
      for (i=0; i<(int)(s_array->length*s_array->n); i++)
        ((cl_long*)s_array->ptr)[i] *= val;
      return self;
    }
    switch (s_array->n) {
    case 2:
      if (rb_class_of(argv[0]) == rb_cLong2) {
        cl_long2 *val;
        Data_Get_Struct(argv[0], cl_long2, val);
        for (i=0; i<(int)s_array->length; i++)
          for (j=0; j<(int)s_array->n; j++)
          ((cl_long*)(((char*)s_array->ptr)+s_array->size*i))[j] *= ((cl_long*)val)[j];
        return self;
      } else {
        rb_raise(rb_eArgError, "wrong type of the argument");
      }
      break;
    case 4:
      if (rb_class_of(argv[0]) == rb_cLong4) {
        cl_long4 *val;
        Data_Get_Struct(argv[0], cl_long4, val);
        for (i=0; i<(int)s_array->length; i++)
          for (j=0; j<(int)s_array->n; j++)
          ((cl_long*)(((char*)s_array->ptr)+s_array->size*i))[j] *= ((cl_long*)val)[j];
        return self;
      } else {
        rb_raise(rb_eArgError, "wrong type of the argument");
      }
      break;
    case 8:
      if (rb_class_of(argv[0]) == rb_cLong8) {
        cl_long8 *val;
        Data_Get_Struct(argv[0], cl_long8, val);
        for (i=0; i<(int)s_array->length; i++)
          for (j=0; j<(int)s_array->n; j++)
          ((cl_long*)(((char*)s_array->ptr)+s_array->size*i))[j] *= ((cl_long*)val)[j];
        return self;
      } else {
        rb_raise(rb_eArgError, "wrong type of the argument");
      }
      break;
    case 16:
      if (rb_class_of(argv[0]) == rb_cLong16) {
        cl_long16 *val;
        Data_Get_Struct(argv[0], cl_long16, val);
        for (i=0; i<(int)s_array->length; i++)
          for (j=0; j<(int)s_array->n; j++)
          ((cl_long*)(((char*)s_array->ptr)+s_array->size*i))[j] *= ((cl_long*)val)[j];
        return self;
      } else {
        rb_raise(rb_eArgError, "wrong type of the argument");
      }
      break;
    default:
      rb_raise(rb_eArgError, "wrong type of the argument");
    }
    break;
  case VA_ULONG:
    if (rb_obj_is_kind_of(argv[0], rb_cNumeric)==Qtrue) {
      cl_ulong val = (uint64_t)NUM2ULONG(argv[0]);
      for (i=0; i<(int)(s_array->length*s_array->n); i++)
        ((cl_ulong*)s_array->ptr)[i] *= val;
      return self;
    }
    switch (s_array->n) {
    case 2:
      if (rb_class_of(argv[0]) == rb_cUlong2) {
        cl_ulong2 *val;
        Data_Get_Struct(argv[0], cl_ulong2, val);
        for (i=0; i<(int)s_array->length; i++)
          for (j=0; j<(int)s_array->n; j++)
          ((cl_ulong*)(((char*)s_array->ptr)+s_array->size*i))[j] *= ((cl_ulong*)val)[j];
        return self;
      } else {
        rb_raise(rb_eArgError, "wrong type of the argument");
      }
      break;
    case 4:
      if (rb_class_of(argv[0]) == rb_cUlong4) {
        cl_ulong4 *val;
        Data_Get_Struct(argv[0], cl_ulong4, val);
        for (i=0; i<(int)s_array->length; i++)
          for (j=0; j<(int)s_array->n; j++)
          ((cl_ulong*)(((char*)s_array->ptr)+s_array->size*i))[j] *= ((cl_ulong*)val)[j];
        return self;
      } else {
        rb_raise(rb_eArgError, "wrong type of the argument");
      }
      break;
    case 8:
      if (rb_class_of(argv[0]) == rb_cUlong8) {
        cl_ulong8 *val;
        Data_Get_Struct(argv[0], cl_ulong8, val);
        for (i=0; i<(int)s_array->length; i++)
          for (j=0; j<(int)s_array->n; j++)
          ((cl_ulong*)(((char*)s_array->ptr)+s_array->size*i))[j] *= ((cl_ulong*)val)[j];
        return self;
      } else {
        rb_raise(rb_eArgError, "wrong type of the argument");
      }
      break;
    case 16:
      if (rb_class_of(argv[0]) == rb_cUlong16) {
        cl_ulong16 *val;
        Data_Get_Struct(argv[0], cl_ulong16, val);
        for (i=0; i<(int)s_array->length; i++)
          for (j=0; j<(int)s_array->n; j++)
          ((cl_ulong*)(((char*)s_array->ptr)+s_array->size*i))[j] *= ((cl_ulong*)val)[j];
        return self;
      } else {
        rb_raise(rb_eArgError, "wrong type of the argument");
      }
      break;
    default:
      rb_raise(rb_eArgError, "wrong type of the argument");
    }
    break;
  case VA_FLOAT:
    if (rb_obj_is_kind_of(argv[0], rb_cNumeric)==Qtrue) {
      cl_float val = (float)NUM2DBL(argv[0]);
      for (i=0; i<(int)(s_array->length*s_array->n); i++)
        ((cl_float*)s_array->ptr)[i] *= val;
      return self;
    }
    switch (s_array->n) {
    case 2:
      if (rb_class_of(argv[0]) == rb_cFloat2) {
        cl_float2 *val;
        Data_Get_Struct(argv[0], cl_float2, val);
        for (i=0; i<(int)s_array->length; i++)
          for (j=0; j<(int)s_array->n; j++)
          ((cl_float*)(((char*)s_array->ptr)+s_array->size*i))[j] *= ((cl_float*)val)[j];
        return self;
      } else {
        rb_raise(rb_eArgError, "wrong type of the argument");
      }
      break;
    case 4:
      if (rb_class_of(argv[0]) == rb_cFloat4) {
        cl_float4 *val;
        Data_Get_Struct(argv[0], cl_float4, val);
        for (i=0; i<(int)s_array->length; i++)
          for (j=0; j<(int)s_array->n; j++)
          ((cl_float*)(((char*)s_array->ptr)+s_array->size*i))[j] *= ((cl_float*)val)[j];
        return self;
      } else {
        rb_raise(rb_eArgError, "wrong type of the argument");
      }
      break;
    case 8:
      if (rb_class_of(argv[0]) == rb_cFloat8) {
        cl_float8 *val;
        Data_Get_Struct(argv[0], cl_float8, val);
        for (i=0; i<(int)s_array->length; i++)
          for (j=0; j<(int)s_array->n; j++)
          ((cl_float*)(((char*)s_array->ptr)+s_array->size*i))[j] *= ((cl_float*)val)[j];
        return self;
      } else {
        rb_raise(rb_eArgError, "wrong type of the argument");
      }
      break;
    case 16:
      if (rb_class_of(argv[0]) == rb_cFloat16) {
        cl_float16 *val;
        Data_Get_Struct(argv[0], cl_float16, val);
        for (i=0; i<(int)s_array->length; i++)
          for (j=0; j<(int)s_array->n; j++)
          ((cl_float*)(((char*)s_array->ptr)+s_array->size*i))[j] *= ((cl_float*)val)[j];
        return self;
      } else {
        rb_raise(rb_eArgError, "wrong type of the argument");
      }
      break;
    default:
      rb_raise(rb_eArgError, "wrong type of the argument");
    }
    break;
  case VA_DOUBLE:
    if (rb_obj_is_kind_of(argv[0], rb_cNumeric)==Qtrue) {
      cl_double val = (double)NUM2DBL(argv[0]);
      for (i=0; i<(int)(s_array->length*s_array->n); i++)
        ((cl_double*)s_array->ptr)[i] *= val;
      return self;
    }
    switch (s_array->n) {
    case 2:
      if (rb_class_of(argv[0]) == rb_cDouble2) {
        cl_double2 *val;
        Data_Get_Struct(argv[0], cl_double2, val);
        for (i=0; i<(int)s_array->length; i++)
          for (j=0; j<(int)s_array->n; j++)
          ((cl_double*)(((char*)s_array->ptr)+s_array->size*i))[j] *= ((cl_double*)val)[j];
        return self;
      } else {
        rb_raise(rb_eArgError, "wrong type of the argument");
      }
      break;
    case 4:
      if (rb_class_of(argv[0]) == rb_cDouble4) {
        cl_double4 *val;
        Data_Get_Struct(argv[0], cl_double4, val);
        for (i=0; i<(int)s_array->length; i++)
          for (j=0; j<(int)s_array->n; j++)
          ((cl_double*)(((char*)s_array->ptr)+s_array->size*i))[j] *= ((cl_double*)val)[j];
        return self;
      } else {
        rb_raise(rb_eArgError, "wrong type of the argument");
      }
      break;
    case 8:
      if (rb_class_of(argv[0]) == rb_cDouble8) {
        cl_double8 *val;
        Data_Get_Struct(argv[0], cl_double8, val);
        for (i=0; i<(int)s_array->length; i++)
          for (j=0; j<(int)s_array->n; j++)
          ((cl_double*)(((char*)s_array->ptr)+s_array->size*i))[j] *= ((cl_double*)val)[j];
        return self;
      } else {
        rb_raise(rb_eArgError, "wrong type of the argument");
      }
      break;
    case 16:
      if (rb_class_of(argv[0]) == rb_cDouble16) {
        cl_double16 *val;
        Data_Get_Struct(argv[0], cl_double16, val);
        for (i=0; i<(int)s_array->length; i++)
          for (j=0; j<(int)s_array->n; j++)
          ((cl_double*)(((char*)s_array->ptr)+s_array->size*i))[j] *= ((cl_double*)val)[j];
        return self;
      } else {
        rb_raise(rb_eArgError, "wrong type of the argument");
      }
      break;
    default:
      rb_raise(rb_eArgError, "wrong type of the argument");
    }
    break;
  default:
    rb_raise(rb_eRuntimeError, "[BUG] invalid type");
  }

  return Qnil;
}
VALUE
rb_VArray_div(int argc, VALUE *argv, VALUE self)
{
  struct_varray *s_array;
  size_t size;
  int i, j;

  if (argc!=1)
    rb_raise(rb_eArgError, "wrong number of arguments (%d for 1)", argc);
  Data_Get_Struct(self, struct_varray, s_array);
  size = s_array->size;
  if (rb_class_of(argv[0]) == rb_cVArray) {
    struct_varray *s_array1;
    Data_Get_Struct(argv[0], struct_varray, s_array1);
    if (s_array1->type == s_array->type && s_array1->n == s_array->n && s_array1->length == s_array->length) {
      switch (s_array->type) {
      case VA_CHAR:
        for (i=0; i<(int)(s_array->length*s_array->n); i++)
          ((cl_char*)s_array->ptr)[i] /= ((cl_char*)s_array1->ptr)[i];
        return self;
        break;
      case VA_UCHAR:
        for (i=0; i<(int)(s_array->length*s_array->n); i++)
          ((cl_uchar*)s_array->ptr)[i] /= ((cl_uchar*)s_array1->ptr)[i];
        return self;
        break;
      case VA_SHORT:
        for (i=0; i<(int)(s_array->length*s_array->n); i++)
          ((cl_short*)s_array->ptr)[i] /= ((cl_short*)s_array1->ptr)[i];
        return self;
        break;
      case VA_USHORT:
        for (i=0; i<(int)(s_array->length*s_array->n); i++)
          ((cl_ushort*)s_array->ptr)[i] /= ((cl_ushort*)s_array1->ptr)[i];
        return self;
        break;
      case VA_INT:
        for (i=0; i<(int)(s_array->length*s_array->n); i++)
          ((cl_int*)s_array->ptr)[i] /= ((cl_int*)s_array1->ptr)[i];
        return self;
        break;
      case VA_UINT:
        for (i=0; i<(int)(s_array->length*s_array->n); i++)
          ((cl_uint*)s_array->ptr)[i] /= ((cl_uint*)s_array1->ptr)[i];
        return self;
        break;
      case VA_LONG:
        for (i=0; i<(int)(s_array->length*s_array->n); i++)
          ((cl_long*)s_array->ptr)[i] /= ((cl_long*)s_array1->ptr)[i];
        return self;
        break;
      case VA_ULONG:
        for (i=0; i<(int)(s_array->length*s_array->n); i++)
          ((cl_ulong*)s_array->ptr)[i] /= ((cl_ulong*)s_array1->ptr)[i];
        return self;
        break;
      case VA_FLOAT:
        for (i=0; i<(int)(s_array->length*s_array->n); i++)
          ((cl_float*)s_array->ptr)[i] /= ((cl_float*)s_array1->ptr)[i];
        return self;
        break;
      case VA_DOUBLE:
        for (i=0; i<(int)(s_array->length*s_array->n); i++)
          ((cl_double*)s_array->ptr)[i] /= ((cl_double*)s_array1->ptr)[i];
        return self;
        break;
      default:
        rb_raise(rb_eRuntimeError, "[BUG]");
      }
    } else {
      rb_raise(rb_eArgError, "type_code or length is invalid");
    }
  }
  switch (s_array->type) {
  case VA_CHAR:
    if (rb_obj_is_kind_of(argv[0], rb_cNumeric)==Qtrue) {
      cl_char val = NUM2CHR(argv[0]);
      for (i=0; i<(int)(s_array->length*s_array->n); i++)
        ((cl_char*)s_array->ptr)[i] /= val;
      return self;
    }
    switch (s_array->n) {
    case 2:
      if (rb_class_of(argv[0]) == rb_cChar2) {
        cl_char2 *val;
        Data_Get_Struct(argv[0], cl_char2, val);
        for (i=0; i<(int)s_array->length; i++)
          for (j=0; j<(int)s_array->n; j++)
          ((cl_char*)(((char*)s_array->ptr)+s_array->size*i))[j] /= ((cl_char*)val)[j];
        return self;
      } else {
        rb_raise(rb_eArgError, "wrong type of the argument");
      }
      break;
    case 4:
      if (rb_class_of(argv[0]) == rb_cChar4) {
        cl_char4 *val;
        Data_Get_Struct(argv[0], cl_char4, val);
        for (i=0; i<(int)s_array->length; i++)
          for (j=0; j<(int)s_array->n; j++)
          ((cl_char*)(((char*)s_array->ptr)+s_array->size*i))[j] /= ((cl_char*)val)[j];
        return self;
      } else {
        rb_raise(rb_eArgError, "wrong type of the argument");
      }
      break;
    case 8:
      if (rb_class_of(argv[0]) == rb_cChar8) {
        cl_char8 *val;
        Data_Get_Struct(argv[0], cl_char8, val);
        for (i=0; i<(int)s_array->length; i++)
          for (j=0; j<(int)s_array->n; j++)
          ((cl_char*)(((char*)s_array->ptr)+s_array->size*i))[j] /= ((cl_char*)val)[j];
        return self;
      } else {
        rb_raise(rb_eArgError, "wrong type of the argument");
      }
      break;
    case 16:
      if (rb_class_of(argv[0]) == rb_cChar16) {
        cl_char16 *val;
        Data_Get_Struct(argv[0], cl_char16, val);
        for (i=0; i<(int)s_array->length; i++)
          for (j=0; j<(int)s_array->n; j++)
          ((cl_char*)(((char*)s_array->ptr)+s_array->size*i))[j] /= ((cl_char*)val)[j];
        return self;
      } else {
        rb_raise(rb_eArgError, "wrong type of the argument");
      }
      break;
    default:
      rb_raise(rb_eArgError, "wrong type of the argument");
    }
    break;
  case VA_UCHAR:
    if (rb_obj_is_kind_of(argv[0], rb_cNumeric)==Qtrue) {
      cl_uchar val = (uint8_t)NUM2UINT(argv[0]);
      for (i=0; i<(int)(s_array->length*s_array->n); i++)
        ((cl_uchar*)s_array->ptr)[i] /= val;
      return self;
    }
    switch (s_array->n) {
    case 2:
      if (rb_class_of(argv[0]) == rb_cUchar2) {
        cl_uchar2 *val;
        Data_Get_Struct(argv[0], cl_uchar2, val);
        for (i=0; i<(int)s_array->length; i++)
          for (j=0; j<(int)s_array->n; j++)
          ((cl_uchar*)(((char*)s_array->ptr)+s_array->size*i))[j] /= ((cl_uchar*)val)[j];
        return self;
      } else {
        rb_raise(rb_eArgError, "wrong type of the argument");
      }
      break;
    case 4:
      if (rb_class_of(argv[0]) == rb_cUchar4) {
        cl_uchar4 *val;
        Data_Get_Struct(argv[0], cl_uchar4, val);
        for (i=0; i<(int)s_array->length; i++)
          for (j=0; j<(int)s_array->n; j++)
          ((cl_uchar*)(((char*)s_array->ptr)+s_array->size*i))[j] /= ((cl_uchar*)val)[j];
        return self;
      } else {
        rb_raise(rb_eArgError, "wrong type of the argument");
      }
      break;
    case 8:
      if (rb_class_of(argv[0]) == rb_cUchar8) {
        cl_uchar8 *val;
        Data_Get_Struct(argv[0], cl_uchar8, val);
        for (i=0; i<(int)s_array->length; i++)
          for (j=0; j<(int)s_array->n; j++)
          ((cl_uchar*)(((char*)s_array->ptr)+s_array->size*i))[j] /= ((cl_uchar*)val)[j];
        return self;
      } else {
        rb_raise(rb_eArgError, "wrong type of the argument");
      }
      break;
    case 16:
      if (rb_class_of(argv[0]) == rb_cUchar16) {
        cl_uchar16 *val;
        Data_Get_Struct(argv[0], cl_uchar16, val);
        for (i=0; i<(int)s_array->length; i++)
          for (j=0; j<(int)s_array->n; j++)
          ((cl_uchar*)(((char*)s_array->ptr)+s_array->size*i))[j] /= ((cl_uchar*)val)[j];
        return self;
      } else {
        rb_raise(rb_eArgError, "wrong type of the argument");
      }
      break;
    default:
      rb_raise(rb_eArgError, "wrong type of the argument");
    }
    break;
  case VA_SHORT:
    if (rb_obj_is_kind_of(argv[0], rb_cNumeric)==Qtrue) {
      cl_short val = (int16_t)NUM2INT(argv[0]);
      for (i=0; i<(int)(s_array->length*s_array->n); i++)
        ((cl_short*)s_array->ptr)[i] /= val;
      return self;
    }
    switch (s_array->n) {
    case 2:
      if (rb_class_of(argv[0]) == rb_cShort2) {
        cl_short2 *val;
        Data_Get_Struct(argv[0], cl_short2, val);
        for (i=0; i<(int)s_array->length; i++)
          for (j=0; j<(int)s_array->n; j++)
          ((cl_short*)(((char*)s_array->ptr)+s_array->size*i))[j] /= ((cl_short*)val)[j];
        return self;
      } else {
        rb_raise(rb_eArgError, "wrong type of the argument");
      }
      break;
    case 4:
      if (rb_class_of(argv[0]) == rb_cShort4) {
        cl_short4 *val;
        Data_Get_Struct(argv[0], cl_short4, val);
        for (i=0; i<(int)s_array->length; i++)
          for (j=0; j<(int)s_array->n; j++)
          ((cl_short*)(((char*)s_array->ptr)+s_array->size*i))[j] /= ((cl_short*)val)[j];
        return self;
      } else {
        rb_raise(rb_eArgError, "wrong type of the argument");
      }
      break;
    case 8:
      if (rb_class_of(argv[0]) == rb_cShort8) {
        cl_short8 *val;
        Data_Get_Struct(argv[0], cl_short8, val);
        for (i=0; i<(int)s_array->length; i++)
          for (j=0; j<(int)s_array->n; j++)
          ((cl_short*)(((char*)s_array->ptr)+s_array->size*i))[j] /= ((cl_short*)val)[j];
        return self;
      } else {
        rb_raise(rb_eArgError, "wrong type of the argument");
      }
      break;
    case 16:
      if (rb_class_of(argv[0]) == rb_cShort16) {
        cl_short16 *val;
        Data_Get_Struct(argv[0], cl_short16, val);
        for (i=0; i<(int)s_array->length; i++)
          for (j=0; j<(int)s_array->n; j++)
          ((cl_short*)(((char*)s_array->ptr)+s_array->size*i))[j] /= ((cl_short*)val)[j];
        return self;
      } else {
        rb_raise(rb_eArgError, "wrong type of the argument");
      }
      break;
    default:
      rb_raise(rb_eArgError, "wrong type of the argument");
    }
    break;
  case VA_USHORT:
    if (rb_obj_is_kind_of(argv[0], rb_cNumeric)==Qtrue) {
      cl_ushort val = (uint16_t)NUM2UINT(argv[0]);
      for (i=0; i<(int)(s_array->length*s_array->n); i++)
        ((cl_ushort*)s_array->ptr)[i] /= val;
      return self;
    }
    switch (s_array->n) {
    case 2:
      if (rb_class_of(argv[0]) == rb_cUshort2) {
        cl_ushort2 *val;
        Data_Get_Struct(argv[0], cl_ushort2, val);
        for (i=0; i<(int)s_array->length; i++)
          for (j=0; j<(int)s_array->n; j++)
          ((cl_ushort*)(((char*)s_array->ptr)+s_array->size*i))[j] /= ((cl_ushort*)val)[j];
        return self;
      } else {
        rb_raise(rb_eArgError, "wrong type of the argument");
      }
      break;
    case 4:
      if (rb_class_of(argv[0]) == rb_cUshort4) {
        cl_ushort4 *val;
        Data_Get_Struct(argv[0], cl_ushort4, val);
        for (i=0; i<(int)s_array->length; i++)
          for (j=0; j<(int)s_array->n; j++)
          ((cl_ushort*)(((char*)s_array->ptr)+s_array->size*i))[j] /= ((cl_ushort*)val)[j];
        return self;
      } else {
        rb_raise(rb_eArgError, "wrong type of the argument");
      }
      break;
    case 8:
      if (rb_class_of(argv[0]) == rb_cUshort8) {
        cl_ushort8 *val;
        Data_Get_Struct(argv[0], cl_ushort8, val);
        for (i=0; i<(int)s_array->length; i++)
          for (j=0; j<(int)s_array->n; j++)
          ((cl_ushort*)(((char*)s_array->ptr)+s_array->size*i))[j] /= ((cl_ushort*)val)[j];
        return self;
      } else {
        rb_raise(rb_eArgError, "wrong type of the argument");
      }
      break;
    case 16:
      if (rb_class_of(argv[0]) == rb_cUshort16) {
        cl_ushort16 *val;
        Data_Get_Struct(argv[0], cl_ushort16, val);
        for (i=0; i<(int)s_array->length; i++)
          for (j=0; j<(int)s_array->n; j++)
          ((cl_ushort*)(((char*)s_array->ptr)+s_array->size*i))[j] /= ((cl_ushort*)val)[j];
        return self;
      } else {
        rb_raise(rb_eArgError, "wrong type of the argument");
      }
      break;
    default:
      rb_raise(rb_eArgError, "wrong type of the argument");
    }
    break;
  case VA_INT:
    if (rb_obj_is_kind_of(argv[0], rb_cNumeric)==Qtrue) {
      cl_int val = (int32_t)NUM2INT(argv[0]);
      for (i=0; i<(int)(s_array->length*s_array->n); i++)
        ((cl_int*)s_array->ptr)[i] /= val;
      return self;
    }
    switch (s_array->n) {
    case 2:
      if (rb_class_of(argv[0]) == rb_cInt2) {
        cl_int2 *val;
        Data_Get_Struct(argv[0], cl_int2, val);
        for (i=0; i<(int)s_array->length; i++)
          for (j=0; j<(int)s_array->n; j++)
          ((cl_int*)(((char*)s_array->ptr)+s_array->size*i))[j] /= ((cl_int*)val)[j];
        return self;
      } else {
        rb_raise(rb_eArgError, "wrong type of the argument");
      }
      break;
    case 4:
      if (rb_class_of(argv[0]) == rb_cInt4) {
        cl_int4 *val;
        Data_Get_Struct(argv[0], cl_int4, val);
        for (i=0; i<(int)s_array->length; i++)
          for (j=0; j<(int)s_array->n; j++)
          ((cl_int*)(((char*)s_array->ptr)+s_array->size*i))[j] /= ((cl_int*)val)[j];
        return self;
      } else {
        rb_raise(rb_eArgError, "wrong type of the argument");
      }
      break;
    case 8:
      if (rb_class_of(argv[0]) == rb_cInt8) {
        cl_int8 *val;
        Data_Get_Struct(argv[0], cl_int8, val);
        for (i=0; i<(int)s_array->length; i++)
          for (j=0; j<(int)s_array->n; j++)
          ((cl_int*)(((char*)s_array->ptr)+s_array->size*i))[j] /= ((cl_int*)val)[j];
        return self;
      } else {
        rb_raise(rb_eArgError, "wrong type of the argument");
      }
      break;
    case 16:
      if (rb_class_of(argv[0]) == rb_cInt16) {
        cl_int16 *val;
        Data_Get_Struct(argv[0], cl_int16, val);
        for (i=0; i<(int)s_array->length; i++)
          for (j=0; j<(int)s_array->n; j++)
          ((cl_int*)(((char*)s_array->ptr)+s_array->size*i))[j] /= ((cl_int*)val)[j];
        return self;
      } else {
        rb_raise(rb_eArgError, "wrong type of the argument");
      }
      break;
    default:
      rb_raise(rb_eArgError, "wrong type of the argument");
    }
    break;
  case VA_UINT:
    if (rb_obj_is_kind_of(argv[0], rb_cNumeric)==Qtrue) {
      cl_uint val = (uint32_t)NUM2UINT(argv[0]);
      for (i=0; i<(int)(s_array->length*s_array->n); i++)
        ((cl_uint*)s_array->ptr)[i] /= val;
      return self;
    }
    switch (s_array->n) {
    case 2:
      if (rb_class_of(argv[0]) == rb_cUint2) {
        cl_uint2 *val;
        Data_Get_Struct(argv[0], cl_uint2, val);
        for (i=0; i<(int)s_array->length; i++)
          for (j=0; j<(int)s_array->n; j++)
          ((cl_uint*)(((char*)s_array->ptr)+s_array->size*i))[j] /= ((cl_uint*)val)[j];
        return self;
      } else {
        rb_raise(rb_eArgError, "wrong type of the argument");
      }
      break;
    case 4:
      if (rb_class_of(argv[0]) == rb_cUint4) {
        cl_uint4 *val;
        Data_Get_Struct(argv[0], cl_uint4, val);
        for (i=0; i<(int)s_array->length; i++)
          for (j=0; j<(int)s_array->n; j++)
          ((cl_uint*)(((char*)s_array->ptr)+s_array->size*i))[j] /= ((cl_uint*)val)[j];
        return self;
      } else {
        rb_raise(rb_eArgError, "wrong type of the argument");
      }
      break;
    case 8:
      if (rb_class_of(argv[0]) == rb_cUint8) {
        cl_uint8 *val;
        Data_Get_Struct(argv[0], cl_uint8, val);
        for (i=0; i<(int)s_array->length; i++)
          for (j=0; j<(int)s_array->n; j++)
          ((cl_uint*)(((char*)s_array->ptr)+s_array->size*i))[j] /= ((cl_uint*)val)[j];
        return self;
      } else {
        rb_raise(rb_eArgError, "wrong type of the argument");
      }
      break;
    case 16:
      if (rb_class_of(argv[0]) == rb_cUint16) {
        cl_uint16 *val;
        Data_Get_Struct(argv[0], cl_uint16, val);
        for (i=0; i<(int)s_array->length; i++)
          for (j=0; j<(int)s_array->n; j++)
          ((cl_uint*)(((char*)s_array->ptr)+s_array->size*i))[j] /= ((cl_uint*)val)[j];
        return self;
      } else {
        rb_raise(rb_eArgError, "wrong type of the argument");
      }
      break;
    default:
      rb_raise(rb_eArgError, "wrong type of the argument");
    }
    break;
  case VA_LONG:
    if (rb_obj_is_kind_of(argv[0], rb_cNumeric)==Qtrue) {
      cl_long val = NUM2LONG(argv[0]);
      for (i=0; i<(int)(s_array->length*s_array->n); i++)
        ((cl_long*)s_array->ptr)[i] /= val;
      return self;
    }
    switch (s_array->n) {
    case 2:
      if (rb_class_of(argv[0]) == rb_cLong2) {
        cl_long2 *val;
        Data_Get_Struct(argv[0], cl_long2, val);
        for (i=0; i<(int)s_array->length; i++)
          for (j=0; j<(int)s_array->n; j++)
          ((cl_long*)(((char*)s_array->ptr)+s_array->size*i))[j] /= ((cl_long*)val)[j];
        return self;
      } else {
        rb_raise(rb_eArgError, "wrong type of the argument");
      }
      break;
    case 4:
      if (rb_class_of(argv[0]) == rb_cLong4) {
        cl_long4 *val;
        Data_Get_Struct(argv[0], cl_long4, val);
        for (i=0; i<(int)s_array->length; i++)
          for (j=0; j<(int)s_array->n; j++)
          ((cl_long*)(((char*)s_array->ptr)+s_array->size*i))[j] /= ((cl_long*)val)[j];
        return self;
      } else {
        rb_raise(rb_eArgError, "wrong type of the argument");
      }
      break;
    case 8:
      if (rb_class_of(argv[0]) == rb_cLong8) {
        cl_long8 *val;
        Data_Get_Struct(argv[0], cl_long8, val);
        for (i=0; i<(int)s_array->length; i++)
          for (j=0; j<(int)s_array->n; j++)
          ((cl_long*)(((char*)s_array->ptr)+s_array->size*i))[j] /= ((cl_long*)val)[j];
        return self;
      } else {
        rb_raise(rb_eArgError, "wrong type of the argument");
      }
      break;
    case 16:
      if (rb_class_of(argv[0]) == rb_cLong16) {
        cl_long16 *val;
        Data_Get_Struct(argv[0], cl_long16, val);
        for (i=0; i<(int)s_array->length; i++)
          for (j=0; j<(int)s_array->n; j++)
          ((cl_long*)(((char*)s_array->ptr)+s_array->size*i))[j] /= ((cl_long*)val)[j];
        return self;
      } else {
        rb_raise(rb_eArgError, "wrong type of the argument");
      }
      break;
    default:
      rb_raise(rb_eArgError, "wrong type of the argument");
    }
    break;
  case VA_ULONG:
    if (rb_obj_is_kind_of(argv[0], rb_cNumeric)==Qtrue) {
      cl_ulong val = (uint64_t)NUM2ULONG(argv[0]);
      for (i=0; i<(int)(s_array->length*s_array->n); i++)
        ((cl_ulong*)s_array->ptr)[i] /= val;
      return self;
    }
    switch (s_array->n) {
    case 2:
      if (rb_class_of(argv[0]) == rb_cUlong2) {
        cl_ulong2 *val;
        Data_Get_Struct(argv[0], cl_ulong2, val);
        for (i=0; i<(int)s_array->length; i++)
          for (j=0; j<(int)s_array->n; j++)
          ((cl_ulong*)(((char*)s_array->ptr)+s_array->size*i))[j] /= ((cl_ulong*)val)[j];
        return self;
      } else {
        rb_raise(rb_eArgError, "wrong type of the argument");
      }
      break;
    case 4:
      if (rb_class_of(argv[0]) == rb_cUlong4) {
        cl_ulong4 *val;
        Data_Get_Struct(argv[0], cl_ulong4, val);
        for (i=0; i<(int)s_array->length; i++)
          for (j=0; j<(int)s_array->n; j++)
          ((cl_ulong*)(((char*)s_array->ptr)+s_array->size*i))[j] /= ((cl_ulong*)val)[j];
        return self;
      } else {
        rb_raise(rb_eArgError, "wrong type of the argument");
      }
      break;
    case 8:
      if (rb_class_of(argv[0]) == rb_cUlong8) {
        cl_ulong8 *val;
        Data_Get_Struct(argv[0], cl_ulong8, val);
        for (i=0; i<(int)s_array->length; i++)
          for (j=0; j<(int)s_array->n; j++)
          ((cl_ulong*)(((char*)s_array->ptr)+s_array->size*i))[j] /= ((cl_ulong*)val)[j];
        return self;
      } else {
        rb_raise(rb_eArgError, "wrong type of the argument");
      }
      break;
    case 16:
      if (rb_class_of(argv[0]) == rb_cUlong16) {
        cl_ulong16 *val;
        Data_Get_Struct(argv[0], cl_ulong16, val);
        for (i=0; i<(int)s_array->length; i++)
          for (j=0; j<(int)s_array->n; j++)
          ((cl_ulong*)(((char*)s_array->ptr)+s_array->size*i))[j] /= ((cl_ulong*)val)[j];
        return self;
      } else {
        rb_raise(rb_eArgError, "wrong type of the argument");
      }
      break;
    default:
      rb_raise(rb_eArgError, "wrong type of the argument");
    }
    break;
  case VA_FLOAT:
    if (rb_obj_is_kind_of(argv[0], rb_cNumeric)==Qtrue) {
      cl_float val = (float)NUM2DBL(argv[0]);
      for (i=0; i<(int)(s_array->length*s_array->n); i++)
        ((cl_float*)s_array->ptr)[i] /= val;
      return self;
    }
    switch (s_array->n) {
    case 2:
      if (rb_class_of(argv[0]) == rb_cFloat2) {
        cl_float2 *val;
        Data_Get_Struct(argv[0], cl_float2, val);
        for (i=0; i<(int)s_array->length; i++)
          for (j=0; j<(int)s_array->n; j++)
          ((cl_float*)(((char*)s_array->ptr)+s_array->size*i))[j] /= ((cl_float*)val)[j];
        return self;
      } else {
        rb_raise(rb_eArgError, "wrong type of the argument");
      }
      break;
    case 4:
      if (rb_class_of(argv[0]) == rb_cFloat4) {
        cl_float4 *val;
        Data_Get_Struct(argv[0], cl_float4, val);
        for (i=0; i<(int)s_array->length; i++)
          for (j=0; j<(int)s_array->n; j++)
          ((cl_float*)(((char*)s_array->ptr)+s_array->size*i))[j] /= ((cl_float*)val)[j];
        return self;
      } else {
        rb_raise(rb_eArgError, "wrong type of the argument");
      }
      break;
    case 8:
      if (rb_class_of(argv[0]) == rb_cFloat8) {
        cl_float8 *val;
        Data_Get_Struct(argv[0], cl_float8, val);
        for (i=0; i<(int)s_array->length; i++)
          for (j=0; j<(int)s_array->n; j++)
          ((cl_float*)(((char*)s_array->ptr)+s_array->size*i))[j] /= ((cl_float*)val)[j];
        return self;
      } else {
        rb_raise(rb_eArgError, "wrong type of the argument");
      }
      break;
    case 16:
      if (rb_class_of(argv[0]) == rb_cFloat16) {
        cl_float16 *val;
        Data_Get_Struct(argv[0], cl_float16, val);
        for (i=0; i<(int)s_array->length; i++)
          for (j=0; j<(int)s_array->n; j++)
          ((cl_float*)(((char*)s_array->ptr)+s_array->size*i))[j] /= ((cl_float*)val)[j];
        return self;
      } else {
        rb_raise(rb_eArgError, "wrong type of the argument");
      }
      break;
    default:
      rb_raise(rb_eArgError, "wrong type of the argument");
    }
    break;
  case VA_DOUBLE:
    if (rb_obj_is_kind_of(argv[0], rb_cNumeric)==Qtrue) {
      cl_double val = (double)NUM2DBL(argv[0]);
      for (i=0; i<(int)(s_array->length*s_array->n); i++)
        ((cl_double*)s_array->ptr)[i] /= val;
      return self;
    }
    switch (s_array->n) {
    case 2:
      if (rb_class_of(argv[0]) == rb_cDouble2) {
        cl_double2 *val;
        Data_Get_Struct(argv[0], cl_double2, val);
        for (i=0; i<(int)s_array->length; i++)
          for (j=0; j<(int)s_array->n; j++)
          ((cl_double*)(((char*)s_array->ptr)+s_array->size*i))[j] /= ((cl_double*)val)[j];
        return self;
      } else {
        rb_raise(rb_eArgError, "wrong type of the argument");
      }
      break;
    case 4:
      if (rb_class_of(argv[0]) == rb_cDouble4) {
        cl_double4 *val;
        Data_Get_Struct(argv[0], cl_double4, val);
        for (i=0; i<(int)s_array->length; i++)
          for (j=0; j<(int)s_array->n; j++)
          ((cl_double*)(((char*)s_array->ptr)+s_array->size*i))[j] /= ((cl_double*)val)[j];
        return self;
      } else {
        rb_raise(rb_eArgError, "wrong type of the argument");
      }
      break;
    case 8:
      if (rb_class_of(argv[0]) == rb_cDouble8) {
        cl_double8 *val;
        Data_Get_Struct(argv[0], cl_double8, val);
        for (i=0; i<(int)s_array->length; i++)
          for (j=0; j<(int)s_array->n; j++)
          ((cl_double*)(((char*)s_array->ptr)+s_array->size*i))[j] /= ((cl_double*)val)[j];
        return self;
      } else {
        rb_raise(rb_eArgError, "wrong type of the argument");
      }
      break;
    case 16:
      if (rb_class_of(argv[0]) == rb_cDouble16) {
        cl_double16 *val;
        Data_Get_Struct(argv[0], cl_double16, val);
        for (i=0; i<(int)s_array->length; i++)
          for (j=0; j<(int)s_array->n; j++)
          ((cl_double*)(((char*)s_array->ptr)+s_array->size*i))[j] /= ((cl_double*)val)[j];
        return self;
      } else {
        rb_raise(rb_eArgError, "wrong type of the argument");
      }
      break;
    default:
      rb_raise(rb_eArgError, "wrong type of the argument");
    }
    break;
  default:
    rb_raise(rb_eRuntimeError, "[BUG] invalid type");
  }

  return Qnil;
}
VALUE
rb_VArray_copy(int argc, VALUE *argv, VALUE self)
{
  struct_varray *s_array;
  void *ptr;
  size_t size;

  if (argc!=0)
    rb_raise(rb_eArgError, "wrong number of arguments (%d for 0)", argc);
  Data_Get_Struct(self, struct_varray, s_array);
  size = s_array->size*s_array->length;
  ptr = (void*)xmalloc(size);
  memcpy(ptr, s_array->ptr, size);
  return create_varray(ptr, s_array->length, s_array->type, s_array->n, s_array->size, Qnil);
}

#ifdef HAVE_NARRAY_H
static void
cl_na_mark_ref(struct NARRAY *nary)
{
  rb_gc_mark(nary->ref);
}
static void
cl_na_free(struct NARRAY *nary)
{
  if (nary->ref == Qnil)
    xfree(nary->ptr);
  xfree(nary->shape);
  xfree(nary);
}
VALUE
rb_VArray_toNa(int argc, VALUE *argv, VALUE self)
{
  struct_varray *s_array;
  struct NARRAY *nary;
  int ntype;
  int binary = 0;

  if (argc != 0 && argc != 1)
    rb_raise(rb_eArgError, "wrong number of arguments (%d for 0)", argc);
  if (argc == 1) {
    Check_Type(argv[0], T_HASH);
    if (rb_hash_aref(argv[0], ID2SYM(rb_intern("binary"))) == Qtrue)
      binary = 1;
  }
  Data_Get_Struct(self, struct_varray, s_array);
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
  case VA_DOUBLE:
    ntype = NA_DFLOAT;
    break;
  default:
    rb_raise(rb_eRuntimeError, "this type is not supported");
  }
  nary = ALLOC(struct NARRAY);
  nary->rank = s_array->n == 1 ? 1 : 2;
  nary->total = s_array->n*s_array->length;
  nary->shape = ALLOC_N(int, nary->rank);
  nary->type = ntype;
  if (s_array->n == 1)
    nary->shape[0] = s_array->length;
  else {
    nary->shape[0] = s_array->n;
    nary->shape[1] = s_array->length;
  }
  if (binary) {
    nary->ptr = s_array->ptr;
    nary->ref = self;
    return Data_Wrap_Struct(cNArray, cl_na_mark_ref, cl_na_free, nary);
  } else {
    nary->ptr = ALLOC_N(char, s_array->size*s_array->length);
#ifdef CL_BIG_ENDIAN
    memcpy(nary->ptr, s_array->ptr, s_array->length*s_array->size);
#else
    if (s_array->n == 1)
      memcpy(nary->ptr, s_array->ptr, s_array->length*s_array->size);
    else {
      int n = s_array->n;
      int size = s_array->size;
      int step = size/n;
      void *vptr = s_array->ptr;
      void *nptr = (void*)nary->ptr;
      int i, j;
      for(i=0; i<(int)s_array->length; i++)
        for(j=0; j<(int)n; j++)
          memcpy(((char*)nptr)+i*size+j*step, ((char*)vptr)+i*size+(n-j-1)*step, step);
    }
#endif
    nary->ref = Qnil;
    return Data_Wrap_Struct(cNArray, 0, cl_na_free, nary);
  }
  return Qnil;
}
#endif
void
Init_opencl(void)
{
  rb_require("narray");

  rb_mOpenCL = rb_define_module("OpenCL");

  rb_cCLFloat = rb_define_class_under(rb_mOpenCL, "Float", rb_cFloat);
  rb_define_singleton_method(rb_cCLFloat, "new", rb_clfloat_new, 1);
  rb_cCLDouble = rb_define_class_under(rb_mOpenCL, "Double", rb_cFloat);
  rb_define_singleton_method(rb_cCLDouble, "new", rb_cldouble_new, 1);
  rb_cCLHalf = rb_define_class_under(rb_mOpenCL, "Half", rb_cFloat);
  rb_define_singleton_method(rb_cCLHalf, "new", rb_clhalf_new, 1);



  rb_cCLChar = rb_define_class_under(rb_mOpenCL, "Char", rb_cObject);
  rb_cCLUChar = rb_define_class_under(rb_mOpenCL, "UChar", rb_cObject);
  rb_cCLShort = rb_define_class_under(rb_mOpenCL, "Short", rb_cObject);
  rb_cCLUShort = rb_define_class_under(rb_mOpenCL, "UShort", rb_cObject);
  rb_cCLInt = rb_define_class_under(rb_mOpenCL, "Int", rb_cObject);
  rb_cCLUInt = rb_define_class_under(rb_mOpenCL, "UInt", rb_cObject);
  rb_cCLLong = rb_define_class_under(rb_mOpenCL, "Long", rb_cObject);
  rb_cCLULong = rb_define_class_under(rb_mOpenCL, "ULong", rb_cObject);
  rb_cPlatform = rb_define_class_under(rb_mOpenCL, "Platform", rb_cObject);
  rb_cDevice = rb_define_class_under(rb_mOpenCL, "Device", rb_cObject);
  rb_cContext = rb_define_class_under(rb_mOpenCL, "Context", rb_cObject);
  rb_cCommandQueue = rb_define_class_under(rb_mOpenCL, "CommandQueue", rb_cObject);
  rb_cMem = rb_define_class_under(rb_mOpenCL, "Mem", rb_cObject);
  rb_cBuffer = rb_define_class_under(rb_mOpenCL, "Buffer", rb_cMem);
  rb_cImage = rb_define_class_under(rb_mOpenCL, "Image", rb_cMem);
  rb_cImage2D = rb_define_class_under(rb_mOpenCL, "Image2D", rb_cImage);
  rb_cImage3D = rb_define_class_under(rb_mOpenCL, "Image3D", rb_cImage);
  rb_cImageFormat = rb_define_class_under(rb_mOpenCL, "ImageFormat", rb_cObject);
  rb_cSampler = rb_define_class_under(rb_mOpenCL, "Sampler", rb_cObject);
  rb_cProgram = rb_define_class_under(rb_mOpenCL, "Program", rb_cObject);
  rb_cKernel = rb_define_class_under(rb_mOpenCL, "Kernel", rb_cObject);
  rb_cEvent = rb_define_class_under(rb_mOpenCL, "Event", rb_cObject);

  // rb_mOpenCL
#ifdef CL_BUILD_SUCCESS
  rb_define_const(rb_mOpenCL, "BUILD_SUCCESS", INT2NUM((int)CL_BUILD_SUCCESS));
#endif
#ifdef CL_BUILD_NONE
  rb_define_const(rb_mOpenCL, "BUILD_NONE", INT2NUM((int)CL_BUILD_NONE));
#endif
#ifdef CL_BUILD_ERROR
  rb_define_const(rb_mOpenCL, "BUILD_ERROR", INT2NUM((int)CL_BUILD_ERROR));
#endif
#ifdef CL_BUILD_IN_PROGRESS
  rb_define_const(rb_mOpenCL, "BUILD_IN_PROGRESS", INT2NUM((int)CL_BUILD_IN_PROGRESS));
#endif
#ifdef CL_FALSE
  rb_define_const(rb_mOpenCL, "FALSE", INT2NUM((int)CL_FALSE));
#endif
#ifdef CL_TRUE
  rb_define_const(rb_mOpenCL, "TRUE", INT2NUM((int)CL_TRUE));
#endif
#ifdef CL_SUCCESS
  rb_define_const(rb_mOpenCL, "SUCCESS", INT2NUM((int)CL_SUCCESS));
#endif
#ifdef CL_DEVICE_NOT_FOUND
  rb_define_const(rb_mOpenCL, "DEVICE_NOT_FOUND", INT2NUM((int)CL_DEVICE_NOT_FOUND));
#endif
#ifdef CL_DEVICE_NOT_AVAILABLE
  rb_define_const(rb_mOpenCL, "DEVICE_NOT_AVAILABLE", INT2NUM((int)CL_DEVICE_NOT_AVAILABLE));
#endif
#ifdef CL_COMPILER_NOT_AVAILABLE
  rb_define_const(rb_mOpenCL, "COMPILER_NOT_AVAILABLE", INT2NUM((int)CL_COMPILER_NOT_AVAILABLE));
#endif
#ifdef CL_MEM_OBJECT_ALLOCATION_FAILURE
  rb_define_const(rb_mOpenCL, "MEM_OBJECT_ALLOCATION_FAILURE", INT2NUM((int)CL_MEM_OBJECT_ALLOCATION_FAILURE));
#endif
#ifdef CL_OUT_OF_RESOURCES
  rb_define_const(rb_mOpenCL, "OUT_OF_RESOURCES", INT2NUM((int)CL_OUT_OF_RESOURCES));
#endif
#ifdef CL_OUT_OF_HOST_MEMORY
  rb_define_const(rb_mOpenCL, "OUT_OF_HOST_MEMORY", INT2NUM((int)CL_OUT_OF_HOST_MEMORY));
#endif
#ifdef CL_PROFILING_INFO_NOT_AVAILABLE
  rb_define_const(rb_mOpenCL, "PROFILING_INFO_NOT_AVAILABLE", INT2NUM((int)CL_PROFILING_INFO_NOT_AVAILABLE));
#endif
#ifdef CL_MEM_COPY_OVERLAP
  rb_define_const(rb_mOpenCL, "MEM_COPY_OVERLAP", INT2NUM((int)CL_MEM_COPY_OVERLAP));
#endif
#ifdef CL_IMAGE_FORMAT_MISMATCH
  rb_define_const(rb_mOpenCL, "IMAGE_FORMAT_MISMATCH", INT2NUM((int)CL_IMAGE_FORMAT_MISMATCH));
#endif
#ifdef CL_IMAGE_FORMAT_NOT_SUPPORTED
  rb_define_const(rb_mOpenCL, "IMAGE_FORMAT_NOT_SUPPORTED", INT2NUM((int)CL_IMAGE_FORMAT_NOT_SUPPORTED));
#endif
#ifdef CL_BUILD_PROGRAM_FAILURE
  rb_define_const(rb_mOpenCL, "BUILD_PROGRAM_FAILURE", INT2NUM((int)CL_BUILD_PROGRAM_FAILURE));
#endif
#ifdef CL_MAP_FAILURE
  rb_define_const(rb_mOpenCL, "MAP_FAILURE", INT2NUM((int)CL_MAP_FAILURE));
#endif
#ifdef CL_MISALIGNED_SUB_BUFFER_OFFSET
  rb_define_const(rb_mOpenCL, "MISALIGNED_SUB_BUFFER_OFFSET", INT2NUM((int)CL_MISALIGNED_SUB_BUFFER_OFFSET));
#endif
#ifdef CL_EXEC_STATUS_ERROR_FOR_EVENTS_IN_WAIT_LIST
  rb_define_const(rb_mOpenCL, "EXEC_STATUS_ERROR_FOR_EVENTS_IN_WAIT_LIST", INT2NUM((int)CL_EXEC_STATUS_ERROR_FOR_EVENTS_IN_WAIT_LIST));
#endif
#ifdef CL_INVALID_VALUE
  rb_define_const(rb_mOpenCL, "INVALID_VALUE", INT2NUM((int)CL_INVALID_VALUE));
#endif
#ifdef CL_INVALID_DEVICE_TYPE
  rb_define_const(rb_mOpenCL, "INVALID_DEVICE_TYPE", INT2NUM((int)CL_INVALID_DEVICE_TYPE));
#endif
#ifdef CL_INVALID_PLATFORM
  rb_define_const(rb_mOpenCL, "INVALID_PLATFORM", INT2NUM((int)CL_INVALID_PLATFORM));
#endif
#ifdef CL_INVALID_DEVICE
  rb_define_const(rb_mOpenCL, "INVALID_DEVICE", INT2NUM((int)CL_INVALID_DEVICE));
#endif
#ifdef CL_INVALID_CONTEXT
  rb_define_const(rb_mOpenCL, "INVALID_CONTEXT", INT2NUM((int)CL_INVALID_CONTEXT));
#endif
#ifdef CL_INVALID_QUEUE_PROPERTIES
  rb_define_const(rb_mOpenCL, "INVALID_QUEUE_PROPERTIES", INT2NUM((int)CL_INVALID_QUEUE_PROPERTIES));
#endif
#ifdef CL_INVALID_COMMAND_QUEUE
  rb_define_const(rb_mOpenCL, "INVALID_COMMAND_QUEUE", INT2NUM((int)CL_INVALID_COMMAND_QUEUE));
#endif
#ifdef CL_INVALID_HOST_PTR
  rb_define_const(rb_mOpenCL, "INVALID_HOST_PTR", INT2NUM((int)CL_INVALID_HOST_PTR));
#endif
#ifdef CL_INVALID_MEM_OBJECT
  rb_define_const(rb_mOpenCL, "INVALID_MEM_OBJECT", INT2NUM((int)CL_INVALID_MEM_OBJECT));
#endif
#ifdef CL_INVALID_IMAGE_FORMAT_DESCRIPTOR
  rb_define_const(rb_mOpenCL, "INVALID_IMAGE_FORMAT_DESCRIPTOR", INT2NUM((int)CL_INVALID_IMAGE_FORMAT_DESCRIPTOR));
#endif
#ifdef CL_INVALID_IMAGE_SIZE
  rb_define_const(rb_mOpenCL, "INVALID_IMAGE_SIZE", INT2NUM((int)CL_INVALID_IMAGE_SIZE));
#endif
#ifdef CL_INVALID_SAMPLER
  rb_define_const(rb_mOpenCL, "INVALID_SAMPLER", INT2NUM((int)CL_INVALID_SAMPLER));
#endif
#ifdef CL_INVALID_BINARY
  rb_define_const(rb_mOpenCL, "INVALID_BINARY", INT2NUM((int)CL_INVALID_BINARY));
#endif
#ifdef CL_INVALID_BUILD_OPTIONS
  rb_define_const(rb_mOpenCL, "INVALID_BUILD_OPTIONS", INT2NUM((int)CL_INVALID_BUILD_OPTIONS));
#endif
#ifdef CL_INVALID_PROGRAM
  rb_define_const(rb_mOpenCL, "INVALID_PROGRAM", INT2NUM((int)CL_INVALID_PROGRAM));
#endif
#ifdef CL_INVALID_PROGRAM_EXECUTABLE
  rb_define_const(rb_mOpenCL, "INVALID_PROGRAM_EXECUTABLE", INT2NUM((int)CL_INVALID_PROGRAM_EXECUTABLE));
#endif
#ifdef CL_INVALID_KERNEL_NAME
  rb_define_const(rb_mOpenCL, "INVALID_KERNEL_NAME", INT2NUM((int)CL_INVALID_KERNEL_NAME));
#endif
#ifdef CL_INVALID_KERNEL_DEFINITION
  rb_define_const(rb_mOpenCL, "INVALID_KERNEL_DEFINITION", INT2NUM((int)CL_INVALID_KERNEL_DEFINITION));
#endif
#ifdef CL_INVALID_KERNEL
  rb_define_const(rb_mOpenCL, "INVALID_KERNEL", INT2NUM((int)CL_INVALID_KERNEL));
#endif
#ifdef CL_INVALID_ARG_INDEX
  rb_define_const(rb_mOpenCL, "INVALID_ARG_INDEX", INT2NUM((int)CL_INVALID_ARG_INDEX));
#endif
#ifdef CL_INVALID_ARG_VALUE
  rb_define_const(rb_mOpenCL, "INVALID_ARG_VALUE", INT2NUM((int)CL_INVALID_ARG_VALUE));
#endif
#ifdef CL_INVALID_ARG_SIZE
  rb_define_const(rb_mOpenCL, "INVALID_ARG_SIZE", INT2NUM((int)CL_INVALID_ARG_SIZE));
#endif
#ifdef CL_INVALID_KERNEL_ARGS
  rb_define_const(rb_mOpenCL, "INVALID_KERNEL_ARGS", INT2NUM((int)CL_INVALID_KERNEL_ARGS));
#endif
#ifdef CL_INVALID_WORK_DIMENSION
  rb_define_const(rb_mOpenCL, "INVALID_WORK_DIMENSION", INT2NUM((int)CL_INVALID_WORK_DIMENSION));
#endif
#ifdef CL_INVALID_WORK_GROUP_SIZE
  rb_define_const(rb_mOpenCL, "INVALID_WORK_GROUP_SIZE", INT2NUM((int)CL_INVALID_WORK_GROUP_SIZE));
#endif
#ifdef CL_INVALID_WORK_ITEM_SIZE
  rb_define_const(rb_mOpenCL, "INVALID_WORK_ITEM_SIZE", INT2NUM((int)CL_INVALID_WORK_ITEM_SIZE));
#endif
#ifdef CL_INVALID_GLOBAL_OFFSET
  rb_define_const(rb_mOpenCL, "INVALID_GLOBAL_OFFSET", INT2NUM((int)CL_INVALID_GLOBAL_OFFSET));
#endif
#ifdef CL_INVALID_EVENT_WAIT_LIST
  rb_define_const(rb_mOpenCL, "INVALID_EVENT_WAIT_LIST", INT2NUM((int)CL_INVALID_EVENT_WAIT_LIST));
#endif
#ifdef CL_INVALID_EVENT
  rb_define_const(rb_mOpenCL, "INVALID_EVENT", INT2NUM((int)CL_INVALID_EVENT));
#endif
#ifdef CL_INVALID_OPERATION
  rb_define_const(rb_mOpenCL, "INVALID_OPERATION", INT2NUM((int)CL_INVALID_OPERATION));
#endif
#ifdef CL_INVALID_GL_OBJECT
  rb_define_const(rb_mOpenCL, "INVALID_GL_OBJECT", INT2NUM((int)CL_INVALID_GL_OBJECT));
#endif
#ifdef CL_INVALID_BUFFER_SIZE
  rb_define_const(rb_mOpenCL, "INVALID_BUFFER_SIZE", INT2NUM((int)CL_INVALID_BUFFER_SIZE));
#endif
#ifdef CL_INVALID_MIP_LEVEL
  rb_define_const(rb_mOpenCL, "INVALID_MIP_LEVEL", INT2NUM((int)CL_INVALID_MIP_LEVEL));
#endif
#ifdef CL_INVALID_GLOBAL_WORK_SIZE
  rb_define_const(rb_mOpenCL, "INVALID_GLOBAL_WORK_SIZE", INT2NUM((int)CL_INVALID_GLOBAL_WORK_SIZE));
#endif
#ifdef CL_INVALID_PROPERTY
  rb_define_const(rb_mOpenCL, "INVALID_PROPERTY", INT2NUM((int)CL_INVALID_PROPERTY));
#endif
#ifdef CL_FILTER_NEAREST
  rb_define_const(rb_mOpenCL, "FILTER_NEAREST", UINT2NUM((uint)CL_FILTER_NEAREST));
#endif
#ifdef CL_FILTER_LINEAR
  rb_define_const(rb_mOpenCL, "FILTER_LINEAR", UINT2NUM((uint)CL_FILTER_LINEAR));
#endif
#ifdef CL_ADDRESS_NONE
  rb_define_const(rb_mOpenCL, "ADDRESS_NONE", UINT2NUM((uint)CL_ADDRESS_NONE));
#endif
#ifdef CL_ADDRESS_CLAMP_TO_EDGE
  rb_define_const(rb_mOpenCL, "ADDRESS_CLAMP_TO_EDGE", UINT2NUM((uint)CL_ADDRESS_CLAMP_TO_EDGE));
#endif
#ifdef CL_ADDRESS_CLAMP
  rb_define_const(rb_mOpenCL, "ADDRESS_CLAMP", UINT2NUM((uint)CL_ADDRESS_CLAMP));
#endif
#ifdef CL_ADDRESS_REPEAT
  rb_define_const(rb_mOpenCL, "ADDRESS_REPEAT", UINT2NUM((uint)CL_ADDRESS_REPEAT));
#endif
#ifdef CL_ADDRESS_MIRRORED_REPEAT
  rb_define_const(rb_mOpenCL, "ADDRESS_MIRRORED_REPEAT", UINT2NUM((uint)CL_ADDRESS_MIRRORED_REPEAT));
#endif
#ifdef CL_DEVICE_PREFERRED_VECTOR_WIDTH_HALF
  rb_define_const(rb_mOpenCL, "DEVICE_PREFERRED_VECTOR_WIDTH_HALF", UINT2NUM((uint)CL_DEVICE_PREFERRED_VECTOR_WIDTH_HALF));
#endif
#ifdef CL_DEVICE_HOST_UNIFIED_MEMORY
  rb_define_const(rb_mOpenCL, "DEVICE_HOST_UNIFIED_MEMORY", UINT2NUM((uint)CL_DEVICE_HOST_UNIFIED_MEMORY));
#endif
#ifdef CL_DEVICE_NATIVE_VECTOR_WIDTH_CHAR
  rb_define_const(rb_mOpenCL, "DEVICE_NATIVE_VECTOR_WIDTH_CHAR", UINT2NUM((uint)CL_DEVICE_NATIVE_VECTOR_WIDTH_CHAR));
#endif
#ifdef CL_DEVICE_NATIVE_VECTOR_WIDTH_SHORT
  rb_define_const(rb_mOpenCL, "DEVICE_NATIVE_VECTOR_WIDTH_SHORT", UINT2NUM((uint)CL_DEVICE_NATIVE_VECTOR_WIDTH_SHORT));
#endif
#ifdef CL_DEVICE_NATIVE_VECTOR_WIDTH_INT
  rb_define_const(rb_mOpenCL, "DEVICE_NATIVE_VECTOR_WIDTH_INT", UINT2NUM((uint)CL_DEVICE_NATIVE_VECTOR_WIDTH_INT));
#endif
#ifdef CL_DEVICE_NATIVE_VECTOR_WIDTH_LONG
  rb_define_const(rb_mOpenCL, "DEVICE_NATIVE_VECTOR_WIDTH_LONG", UINT2NUM((uint)CL_DEVICE_NATIVE_VECTOR_WIDTH_LONG));
#endif
#ifdef CL_DEVICE_NATIVE_VECTOR_WIDTH_FLOAT
  rb_define_const(rb_mOpenCL, "DEVICE_NATIVE_VECTOR_WIDTH_FLOAT", UINT2NUM((uint)CL_DEVICE_NATIVE_VECTOR_WIDTH_FLOAT));
#endif
#ifdef CL_DEVICE_NATIVE_VECTOR_WIDTH_DOUBLE
  rb_define_const(rb_mOpenCL, "DEVICE_NATIVE_VECTOR_WIDTH_DOUBLE", UINT2NUM((uint)CL_DEVICE_NATIVE_VECTOR_WIDTH_DOUBLE));
#endif
#ifdef CL_DEVICE_NATIVE_VECTOR_WIDTH_HALF
  rb_define_const(rb_mOpenCL, "DEVICE_NATIVE_VECTOR_WIDTH_HALF", UINT2NUM((uint)CL_DEVICE_NATIVE_VECTOR_WIDTH_HALF));
#endif
#ifdef CL_DEVICE_OPENCL_C_VERSION
  rb_define_const(rb_mOpenCL, "DEVICE_OPENCL_C_VERSION", UINT2NUM((uint)CL_DEVICE_OPENCL_C_VERSION));
#endif
#ifdef CL_COMMAND_NDRANGE_KERNEL
  rb_define_const(rb_mOpenCL, "COMMAND_NDRANGE_KERNEL", UINT2NUM((uint)CL_COMMAND_NDRANGE_KERNEL));
#endif
#ifdef CL_COMMAND_TASK
  rb_define_const(rb_mOpenCL, "COMMAND_TASK", UINT2NUM((uint)CL_COMMAND_TASK));
#endif
#ifdef CL_COMMAND_NATIVE_KERNEL
  rb_define_const(rb_mOpenCL, "COMMAND_NATIVE_KERNEL", UINT2NUM((uint)CL_COMMAND_NATIVE_KERNEL));
#endif
#ifdef CL_COMMAND_READ_BUFFER
  rb_define_const(rb_mOpenCL, "COMMAND_READ_BUFFER", UINT2NUM((uint)CL_COMMAND_READ_BUFFER));
#endif
#ifdef CL_COMMAND_WRITE_BUFFER
  rb_define_const(rb_mOpenCL, "COMMAND_WRITE_BUFFER", UINT2NUM((uint)CL_COMMAND_WRITE_BUFFER));
#endif
#ifdef CL_COMMAND_COPY_BUFFER
  rb_define_const(rb_mOpenCL, "COMMAND_COPY_BUFFER", UINT2NUM((uint)CL_COMMAND_COPY_BUFFER));
#endif
#ifdef CL_COMMAND_READ_IMAGE
  rb_define_const(rb_mOpenCL, "COMMAND_READ_IMAGE", UINT2NUM((uint)CL_COMMAND_READ_IMAGE));
#endif
#ifdef CL_COMMAND_WRITE_IMAGE
  rb_define_const(rb_mOpenCL, "COMMAND_WRITE_IMAGE", UINT2NUM((uint)CL_COMMAND_WRITE_IMAGE));
#endif
#ifdef CL_COMMAND_COPY_IMAGE
  rb_define_const(rb_mOpenCL, "COMMAND_COPY_IMAGE", UINT2NUM((uint)CL_COMMAND_COPY_IMAGE));
#endif
#ifdef CL_COMMAND_COPY_IMAGE_TO_BUFFER
  rb_define_const(rb_mOpenCL, "COMMAND_COPY_IMAGE_TO_BUFFER", UINT2NUM((uint)CL_COMMAND_COPY_IMAGE_TO_BUFFER));
#endif
#ifdef CL_COMMAND_COPY_BUFFER_TO_IMAGE
  rb_define_const(rb_mOpenCL, "COMMAND_COPY_BUFFER_TO_IMAGE", UINT2NUM((uint)CL_COMMAND_COPY_BUFFER_TO_IMAGE));
#endif
#ifdef CL_COMMAND_MAP_BUFFER
  rb_define_const(rb_mOpenCL, "COMMAND_MAP_BUFFER", UINT2NUM((uint)CL_COMMAND_MAP_BUFFER));
#endif
#ifdef CL_COMMAND_MAP_IMAGE
  rb_define_const(rb_mOpenCL, "COMMAND_MAP_IMAGE", UINT2NUM((uint)CL_COMMAND_MAP_IMAGE));
#endif
#ifdef CL_COMMAND_UNMAP_MEM_OBJECT
  rb_define_const(rb_mOpenCL, "COMMAND_UNMAP_MEM_OBJECT", UINT2NUM((uint)CL_COMMAND_UNMAP_MEM_OBJECT));
#endif
#ifdef CL_COMMAND_MARKER
  rb_define_const(rb_mOpenCL, "COMMAND_MARKER", UINT2NUM((uint)CL_COMMAND_MARKER));
#endif
#ifdef CL_COMMAND_ACQUIRE_GL_OBJECTS
  rb_define_const(rb_mOpenCL, "COMMAND_ACQUIRE_GL_OBJECTS", UINT2NUM((uint)CL_COMMAND_ACQUIRE_GL_OBJECTS));
#endif
#ifdef CL_COMMAND_RELEASE_GL_OBJECTS
  rb_define_const(rb_mOpenCL, "COMMAND_RELEASE_GL_OBJECTS", UINT2NUM((uint)CL_COMMAND_RELEASE_GL_OBJECTS));
#endif
#ifdef CL_COMMAND_READ_BUFFER_RECT
  rb_define_const(rb_mOpenCL, "COMMAND_READ_BUFFER_RECT", UINT2NUM((uint)CL_COMMAND_READ_BUFFER_RECT));
#endif
#ifdef CL_COMMAND_WRITE_BUFFER_RECT
  rb_define_const(rb_mOpenCL, "COMMAND_WRITE_BUFFER_RECT", UINT2NUM((uint)CL_COMMAND_WRITE_BUFFER_RECT));
#endif
#ifdef CL_COMMAND_COPY_BUFFER_RECT
  rb_define_const(rb_mOpenCL, "COMMAND_COPY_BUFFER_RECT", UINT2NUM((uint)CL_COMMAND_COPY_BUFFER_RECT));
#endif
#ifdef CL_COMMAND_USER
  rb_define_const(rb_mOpenCL, "COMMAND_USER", UINT2NUM((uint)CL_COMMAND_USER));
#endif
#ifdef CL_PROFILING_COMMAND_QUEUED
  rb_define_const(rb_mOpenCL, "PROFILING_COMMAND_QUEUED", UINT2NUM((uint)CL_PROFILING_COMMAND_QUEUED));
#endif
#ifdef CL_PROFILING_COMMAND_SUBMIT
  rb_define_const(rb_mOpenCL, "PROFILING_COMMAND_SUBMIT", UINT2NUM((uint)CL_PROFILING_COMMAND_SUBMIT));
#endif
#ifdef CL_PROFILING_COMMAND_START
  rb_define_const(rb_mOpenCL, "PROFILING_COMMAND_START", UINT2NUM((uint)CL_PROFILING_COMMAND_START));
#endif
#ifdef CL_PROFILING_COMMAND_END
  rb_define_const(rb_mOpenCL, "PROFILING_COMMAND_END", UINT2NUM((uint)CL_PROFILING_COMMAND_END));
#endif
#ifdef CL_MAP_READ
  rb_define_const(rb_mOpenCL, "MAP_READ", ULONG2NUM((ulong)CL_MAP_READ));
#endif
#ifdef CL_MAP_WRITE
  rb_define_const(rb_mOpenCL, "MAP_WRITE", ULONG2NUM((ulong)CL_MAP_WRITE));
#endif
#ifdef CL_R
  rb_define_const(rb_mOpenCL, "R", UINT2NUM((uint)CL_R));
#endif
#ifdef CL_A
  rb_define_const(rb_mOpenCL, "A", UINT2NUM((uint)CL_A));
#endif
#ifdef CL_RG
  rb_define_const(rb_mOpenCL, "RG", UINT2NUM((uint)CL_RG));
#endif
#ifdef CL_RA
  rb_define_const(rb_mOpenCL, "RA", UINT2NUM((uint)CL_RA));
#endif
#ifdef CL_RGB
  rb_define_const(rb_mOpenCL, "RGB", UINT2NUM((uint)CL_RGB));
#endif
#ifdef CL_RGBA
  rb_define_const(rb_mOpenCL, "RGBA", UINT2NUM((uint)CL_RGBA));
#endif
#ifdef CL_BGRA
  rb_define_const(rb_mOpenCL, "BGRA", UINT2NUM((uint)CL_BGRA));
#endif
#ifdef CL_ARGB
  rb_define_const(rb_mOpenCL, "ARGB", UINT2NUM((uint)CL_ARGB));
#endif
#ifdef CL_INTENSITY
  rb_define_const(rb_mOpenCL, "INTENSITY", UINT2NUM((uint)CL_INTENSITY));
#endif
#ifdef CL_LUMINANCE
  rb_define_const(rb_mOpenCL, "LUMINANCE", UINT2NUM((uint)CL_LUMINANCE));
#endif
#ifdef CL_SNORM_INT8
  rb_define_const(rb_mOpenCL, "SNORM_INT8", UINT2NUM((uint)CL_SNORM_INT8));
#endif
#ifdef CL_SNORM_INT16
  rb_define_const(rb_mOpenCL, "SNORM_INT16", UINT2NUM((uint)CL_SNORM_INT16));
#endif
#ifdef CL_UNORM_INT8
  rb_define_const(rb_mOpenCL, "UNORM_INT8", UINT2NUM((uint)CL_UNORM_INT8));
#endif
#ifdef CL_UNORM_INT16
  rb_define_const(rb_mOpenCL, "UNORM_INT16", UINT2NUM((uint)CL_UNORM_INT16));
#endif
#ifdef CL_UNORM_SHORT_565
  rb_define_const(rb_mOpenCL, "UNORM_SHORT_565", UINT2NUM((uint)CL_UNORM_SHORT_565));
#endif
#ifdef CL_UNORM_SHORT_555
  rb_define_const(rb_mOpenCL, "UNORM_SHORT_555", UINT2NUM((uint)CL_UNORM_SHORT_555));
#endif
#ifdef CL_UNORM_INT_101010
  rb_define_const(rb_mOpenCL, "UNORM_INT_101010", UINT2NUM((uint)CL_UNORM_INT_101010));
#endif
#ifdef CL_SIGNED_INT8
  rb_define_const(rb_mOpenCL, "SIGNED_INT8", UINT2NUM((uint)CL_SIGNED_INT8));
#endif
#ifdef CL_SIGNED_INT16
  rb_define_const(rb_mOpenCL, "SIGNED_INT16", UINT2NUM((uint)CL_SIGNED_INT16));
#endif
#ifdef CL_SIGNED_INT32
  rb_define_const(rb_mOpenCL, "SIGNED_INT32", UINT2NUM((uint)CL_SIGNED_INT32));
#endif
#ifdef CL_UNSIGNED_INT8
  rb_define_const(rb_mOpenCL, "UNSIGNED_INT8", UINT2NUM((uint)CL_UNSIGNED_INT8));
#endif
#ifdef CL_UNSIGNED_INT16
  rb_define_const(rb_mOpenCL, "UNSIGNED_INT16", UINT2NUM((uint)CL_UNSIGNED_INT16));
#endif
#ifdef CL_UNSIGNED_INT32
  rb_define_const(rb_mOpenCL, "UNSIGNED_INT32", UINT2NUM((uint)CL_UNSIGNED_INT32));
#endif
#ifdef CL_HALF_FLOAT
  rb_define_const(rb_mOpenCL, "HALF_FLOAT", UINT2NUM((uint)CL_HALF_FLOAT));
#endif
#ifdef CL_FLOAT
  rb_define_const(rb_mOpenCL, "FLOAT", UINT2NUM((uint)CL_FLOAT));
#endif
#ifdef CL_COMPLETE
  rb_define_const(rb_mOpenCL, "COMPLETE", UINT2NUM((uint)CL_COMPLETE));
#endif
#ifdef CL_RUNNING
  rb_define_const(rb_mOpenCL, "RUNNING", UINT2NUM((uint)CL_RUNNING));
#endif
#ifdef CL_SUBMITTED
  rb_define_const(rb_mOpenCL, "SUBMITTED", UINT2NUM((uint)CL_SUBMITTED));
#endif
#ifdef CL_QUEUED
  rb_define_const(rb_mOpenCL, "QUEUED", UINT2NUM((uint)CL_QUEUED));
#endif
#ifdef CL_VERSION_1_0
  rb_define_const(rb_mOpenCL, "VERSION_1_0", INT2NUM((int)CL_VERSION_1_0));
#endif
#ifdef CL_VERSION_1_1
  rb_define_const(rb_mOpenCL, "VERSION_1_1", INT2NUM((int)CL_VERSION_1_1));
#endif

  // rb_cPlatform
#ifdef CL_PLATFORM_PROFILE
  rb_define_const(rb_cPlatform, "PROFILE", UINT2NUM((uint)CL_PLATFORM_PROFILE));
#endif
#ifdef CL_PLATFORM_VERSION
  rb_define_const(rb_cPlatform, "VERSION", UINT2NUM((uint)CL_PLATFORM_VERSION));
#endif
#ifdef CL_PLATFORM_NAME
  rb_define_const(rb_cPlatform, "NAME", UINT2NUM((uint)CL_PLATFORM_NAME));
#endif
#ifdef CL_PLATFORM_VENDOR
  rb_define_const(rb_cPlatform, "VENDOR", UINT2NUM((uint)CL_PLATFORM_VENDOR));
#endif
#ifdef CL_PLATFORM_EXTENSIONS
  rb_define_const(rb_cPlatform, "EXTENSIONS", UINT2NUM((uint)CL_PLATFORM_EXTENSIONS));
#endif

  // rb_cDevice
#ifdef CL_NONE
  rb_define_const(rb_cDevice, "NONE", UINT2NUM((uint)CL_NONE));
#endif
#ifdef CL_READ_ONLY_CACHE
  rb_define_const(rb_cDevice, "READ_ONLY_CACHE", UINT2NUM((uint)CL_READ_ONLY_CACHE));
#endif
#ifdef CL_READ_WRITE_CACHE
  rb_define_const(rb_cDevice, "READ_WRITE_CACHE", UINT2NUM((uint)CL_READ_WRITE_CACHE));
#endif
#ifdef CL_EXEC_KERNEL
  rb_define_const(rb_cDevice, "EXEC_KERNEL", ULONG2NUM((ulong)CL_EXEC_KERNEL));
#endif
#ifdef CL_EXEC_NATIVE_KERNEL
  rb_define_const(rb_cDevice, "EXEC_NATIVE_KERNEL", ULONG2NUM((ulong)CL_EXEC_NATIVE_KERNEL));
#endif
#ifdef CL_DEVICE_TYPE_DEFAULT
  rb_define_const(rb_cDevice, "TYPE_DEFAULT", ULONG2NUM((ulong)CL_DEVICE_TYPE_DEFAULT));
#endif
#ifdef CL_DEVICE_TYPE_CPU
  rb_define_const(rb_cDevice, "TYPE_CPU", ULONG2NUM((ulong)CL_DEVICE_TYPE_CPU));
#endif
#ifdef CL_DEVICE_TYPE_GPU
  rb_define_const(rb_cDevice, "TYPE_GPU", ULONG2NUM((ulong)CL_DEVICE_TYPE_GPU));
#endif
#ifdef CL_DEVICE_TYPE_ACCELERATOR
  rb_define_const(rb_cDevice, "TYPE_ACCELERATOR", ULONG2NUM((ulong)CL_DEVICE_TYPE_ACCELERATOR));
#endif
#ifdef CL_DEVICE_TYPE_ALL
  rb_define_const(rb_cDevice, "TYPE_ALL", UINT2NUM((uint)CL_DEVICE_TYPE_ALL));
#endif
#ifdef CL_FP_DENORM
  rb_define_const(rb_cDevice, "FP_DENORM", ULONG2NUM((ulong)CL_FP_DENORM));
#endif
#ifdef CL_FP_INF_NAN
  rb_define_const(rb_cDevice, "FP_INF_NAN", ULONG2NUM((ulong)CL_FP_INF_NAN));
#endif
#ifdef CL_FP_ROUND_TO_NEAREST
  rb_define_const(rb_cDevice, "FP_ROUND_TO_NEAREST", ULONG2NUM((ulong)CL_FP_ROUND_TO_NEAREST));
#endif
#ifdef CL_FP_ROUND_TO_ZERO
  rb_define_const(rb_cDevice, "FP_ROUND_TO_ZERO", ULONG2NUM((ulong)CL_FP_ROUND_TO_ZERO));
#endif
#ifdef CL_FP_ROUND_TO_INF
  rb_define_const(rb_cDevice, "FP_ROUND_TO_INF", ULONG2NUM((ulong)CL_FP_ROUND_TO_INF));
#endif
#ifdef CL_FP_FMA
  rb_define_const(rb_cDevice, "FP_FMA", ULONG2NUM((ulong)CL_FP_FMA));
#endif
#ifdef CL_FP_SOFT_FLOAT
  rb_define_const(rb_cDevice, "FP_SOFT_FLOAT", ULONG2NUM((ulong)CL_FP_SOFT_FLOAT));
#endif
#ifdef CL_DEVICE_TYPE
  rb_define_const(rb_cDevice, "TYPE", UINT2NUM((uint)CL_DEVICE_TYPE));
#endif
#ifdef CL_DEVICE_VENDOR_ID
  rb_define_const(rb_cDevice, "VENDOR_ID", UINT2NUM((uint)CL_DEVICE_VENDOR_ID));
#endif
#ifdef CL_DEVICE_MAX_COMPUTE_UNITS
  rb_define_const(rb_cDevice, "MAX_COMPUTE_UNITS", UINT2NUM((uint)CL_DEVICE_MAX_COMPUTE_UNITS));
#endif
#ifdef CL_DEVICE_MAX_WORK_ITEM_DIMENSIONS
  rb_define_const(rb_cDevice, "MAX_WORK_ITEM_DIMENSIONS", UINT2NUM((uint)CL_DEVICE_MAX_WORK_ITEM_DIMENSIONS));
#endif
#ifdef CL_DEVICE_MAX_WORK_GROUP_SIZE
  rb_define_const(rb_cDevice, "MAX_WORK_GROUP_SIZE", UINT2NUM((uint)CL_DEVICE_MAX_WORK_GROUP_SIZE));
#endif
#ifdef CL_DEVICE_MAX_WORK_ITEM_SIZES
  rb_define_const(rb_cDevice, "MAX_WORK_ITEM_SIZES", UINT2NUM((uint)CL_DEVICE_MAX_WORK_ITEM_SIZES));
#endif
#ifdef CL_DEVICE_PREFERRED_VECTOR_WIDTH_CHAR
  rb_define_const(rb_cDevice, "PREFERRED_VECTOR_WIDTH_CHAR", UINT2NUM((uint)CL_DEVICE_PREFERRED_VECTOR_WIDTH_CHAR));
#endif
#ifdef CL_DEVICE_PREFERRED_VECTOR_WIDTH_SHORT
  rb_define_const(rb_cDevice, "PREFERRED_VECTOR_WIDTH_SHORT", UINT2NUM((uint)CL_DEVICE_PREFERRED_VECTOR_WIDTH_SHORT));
#endif
#ifdef CL_DEVICE_PREFERRED_VECTOR_WIDTH_INT
  rb_define_const(rb_cDevice, "PREFERRED_VECTOR_WIDTH_INT", UINT2NUM((uint)CL_DEVICE_PREFERRED_VECTOR_WIDTH_INT));
#endif
#ifdef CL_DEVICE_PREFERRED_VECTOR_WIDTH_LONG
  rb_define_const(rb_cDevice, "PREFERRED_VECTOR_WIDTH_LONG", UINT2NUM((uint)CL_DEVICE_PREFERRED_VECTOR_WIDTH_LONG));
#endif
#ifdef CL_DEVICE_PREFERRED_VECTOR_WIDTH_FLOAT
  rb_define_const(rb_cDevice, "PREFERRED_VECTOR_WIDTH_FLOAT", UINT2NUM((uint)CL_DEVICE_PREFERRED_VECTOR_WIDTH_FLOAT));
#endif
#ifdef CL_DEVICE_PREFERRED_VECTOR_WIDTH_DOUBLE
  rb_define_const(rb_cDevice, "PREFERRED_VECTOR_WIDTH_DOUBLE", UINT2NUM((uint)CL_DEVICE_PREFERRED_VECTOR_WIDTH_DOUBLE));
#endif
#ifdef CL_DEVICE_MAX_CLOCK_FREQUENCY
  rb_define_const(rb_cDevice, "MAX_CLOCK_FREQUENCY", UINT2NUM((uint)CL_DEVICE_MAX_CLOCK_FREQUENCY));
#endif
#ifdef CL_DEVICE_ADDRESS_BITS
  rb_define_const(rb_cDevice, "ADDRESS_BITS", UINT2NUM((uint)CL_DEVICE_ADDRESS_BITS));
#endif
#ifdef CL_DEVICE_MAX_READ_IMAGE_ARGS
  rb_define_const(rb_cDevice, "MAX_READ_IMAGE_ARGS", UINT2NUM((uint)CL_DEVICE_MAX_READ_IMAGE_ARGS));
#endif
#ifdef CL_DEVICE_MAX_WRITE_IMAGE_ARGS
  rb_define_const(rb_cDevice, "MAX_WRITE_IMAGE_ARGS", UINT2NUM((uint)CL_DEVICE_MAX_WRITE_IMAGE_ARGS));
#endif
#ifdef CL_DEVICE_MAX_MEM_ALLOC_SIZE
  rb_define_const(rb_cDevice, "MAX_MEM_ALLOC_SIZE", UINT2NUM((uint)CL_DEVICE_MAX_MEM_ALLOC_SIZE));
#endif
#ifdef CL_DEVICE_IMAGE2D_MAX_WIDTH
  rb_define_const(rb_cDevice, "IMAGE2D_MAX_WIDTH", UINT2NUM((uint)CL_DEVICE_IMAGE2D_MAX_WIDTH));
#endif
#ifdef CL_DEVICE_IMAGE2D_MAX_HEIGHT
  rb_define_const(rb_cDevice, "IMAGE2D_MAX_HEIGHT", UINT2NUM((uint)CL_DEVICE_IMAGE2D_MAX_HEIGHT));
#endif
#ifdef CL_DEVICE_IMAGE3D_MAX_WIDTH
  rb_define_const(rb_cDevice, "IMAGE3D_MAX_WIDTH", UINT2NUM((uint)CL_DEVICE_IMAGE3D_MAX_WIDTH));
#endif
#ifdef CL_DEVICE_IMAGE3D_MAX_HEIGHT
  rb_define_const(rb_cDevice, "IMAGE3D_MAX_HEIGHT", UINT2NUM((uint)CL_DEVICE_IMAGE3D_MAX_HEIGHT));
#endif
#ifdef CL_DEVICE_IMAGE3D_MAX_DEPTH
  rb_define_const(rb_cDevice, "IMAGE3D_MAX_DEPTH", UINT2NUM((uint)CL_DEVICE_IMAGE3D_MAX_DEPTH));
#endif
#ifdef CL_DEVICE_IMAGE_SUPPORT
  rb_define_const(rb_cDevice, "IMAGE_SUPPORT", UINT2NUM((uint)CL_DEVICE_IMAGE_SUPPORT));
#endif
#ifdef CL_DEVICE_MAX_PARAMETER_SIZE
  rb_define_const(rb_cDevice, "MAX_PARAMETER_SIZE", UINT2NUM((uint)CL_DEVICE_MAX_PARAMETER_SIZE));
#endif
#ifdef CL_DEVICE_MAX_SAMPLERS
  rb_define_const(rb_cDevice, "MAX_SAMPLERS", UINT2NUM((uint)CL_DEVICE_MAX_SAMPLERS));
#endif
#ifdef CL_DEVICE_MEM_BASE_ADDR_ALIGN
  rb_define_const(rb_cDevice, "MEM_BASE_ADDR_ALIGN", UINT2NUM((uint)CL_DEVICE_MEM_BASE_ADDR_ALIGN));
#endif
#ifdef CL_DEVICE_MIN_DATA_TYPE_ALIGN_SIZE
  rb_define_const(rb_cDevice, "MIN_DATA_TYPE_ALIGN_SIZE", UINT2NUM((uint)CL_DEVICE_MIN_DATA_TYPE_ALIGN_SIZE));
#endif
#ifdef CL_DEVICE_SINGLE_FP_CONFIG
  rb_define_const(rb_cDevice, "SINGLE_FP_CONFIG", UINT2NUM((uint)CL_DEVICE_SINGLE_FP_CONFIG));
#endif
#ifdef CL_DEVICE_GLOBAL_MEM_CACHE_TYPE
  rb_define_const(rb_cDevice, "GLOBAL_MEM_CACHE_TYPE", UINT2NUM((uint)CL_DEVICE_GLOBAL_MEM_CACHE_TYPE));
#endif
#ifdef CL_DEVICE_GLOBAL_MEM_CACHELINE_SIZE
  rb_define_const(rb_cDevice, "GLOBAL_MEM_CACHELINE_SIZE", UINT2NUM((uint)CL_DEVICE_GLOBAL_MEM_CACHELINE_SIZE));
#endif
#ifdef CL_DEVICE_GLOBAL_MEM_CACHE_SIZE
  rb_define_const(rb_cDevice, "GLOBAL_MEM_CACHE_SIZE", UINT2NUM((uint)CL_DEVICE_GLOBAL_MEM_CACHE_SIZE));
#endif
#ifdef CL_DEVICE_GLOBAL_MEM_SIZE
  rb_define_const(rb_cDevice, "GLOBAL_MEM_SIZE", UINT2NUM((uint)CL_DEVICE_GLOBAL_MEM_SIZE));
#endif
#ifdef CL_DEVICE_MAX_CONSTANT_BUFFER_SIZE
  rb_define_const(rb_cDevice, "MAX_CONSTANT_BUFFER_SIZE", UINT2NUM((uint)CL_DEVICE_MAX_CONSTANT_BUFFER_SIZE));
#endif
#ifdef CL_DEVICE_MAX_CONSTANT_ARGS
  rb_define_const(rb_cDevice, "MAX_CONSTANT_ARGS", UINT2NUM((uint)CL_DEVICE_MAX_CONSTANT_ARGS));
#endif
#ifdef CL_DEVICE_LOCAL_MEM_TYPE
  rb_define_const(rb_cDevice, "LOCAL_MEM_TYPE", UINT2NUM((uint)CL_DEVICE_LOCAL_MEM_TYPE));
#endif
#ifdef CL_DEVICE_LOCAL_MEM_SIZE
  rb_define_const(rb_cDevice, "LOCAL_MEM_SIZE", UINT2NUM((uint)CL_DEVICE_LOCAL_MEM_SIZE));
#endif
#ifdef CL_DEVICE_ERROR_CORRECTION_SUPPORT
  rb_define_const(rb_cDevice, "ERROR_CORRECTION_SUPPORT", UINT2NUM((uint)CL_DEVICE_ERROR_CORRECTION_SUPPORT));
#endif
#ifdef CL_DEVICE_PROFILING_TIMER_RESOLUTION
  rb_define_const(rb_cDevice, "PROFILING_TIMER_RESOLUTION", UINT2NUM((uint)CL_DEVICE_PROFILING_TIMER_RESOLUTION));
#endif
#ifdef CL_DEVICE_ENDIAN_LITTLE
  rb_define_const(rb_cDevice, "ENDIAN_LITTLE", UINT2NUM((uint)CL_DEVICE_ENDIAN_LITTLE));
#endif
#ifdef CL_DEVICE_AVAILABLE
  rb_define_const(rb_cDevice, "AVAILABLE", UINT2NUM((uint)CL_DEVICE_AVAILABLE));
#endif
#ifdef CL_DEVICE_COMPILER_AVAILABLE
  rb_define_const(rb_cDevice, "COMPILER_AVAILABLE", UINT2NUM((uint)CL_DEVICE_COMPILER_AVAILABLE));
#endif
#ifdef CL_DEVICE_EXECUTION_CAPABILITIES
  rb_define_const(rb_cDevice, "EXECUTION_CAPABILITIES", UINT2NUM((uint)CL_DEVICE_EXECUTION_CAPABILITIES));
#endif
#ifdef CL_DEVICE_QUEUE_PROPERTIES
  rb_define_const(rb_cDevice, "QUEUE_PROPERTIES", UINT2NUM((uint)CL_DEVICE_QUEUE_PROPERTIES));
#endif
#ifdef CL_DEVICE_NAME
  rb_define_const(rb_cDevice, "NAME", UINT2NUM((uint)CL_DEVICE_NAME));
#endif
#ifdef CL_DEVICE_VENDOR
  rb_define_const(rb_cDevice, "VENDOR", UINT2NUM((uint)CL_DEVICE_VENDOR));
#endif
#ifdef CL_DRIVER_VERSION
  rb_define_const(rb_cDevice, "DRIVER_VERSION", UINT2NUM((uint)CL_DRIVER_VERSION));
#endif
#ifdef CL_DEVICE_PROFILE
  rb_define_const(rb_cDevice, "PROFILE", UINT2NUM((uint)CL_DEVICE_PROFILE));
#endif
#ifdef CL_DEVICE_VERSION
  rb_define_const(rb_cDevice, "VERSION", UINT2NUM((uint)CL_DEVICE_VERSION));
#endif
#ifdef CL_DEVICE_EXTENSIONS
  rb_define_const(rb_cDevice, "EXTENSIONS", UINT2NUM((uint)CL_DEVICE_EXTENSIONS));
#endif
#ifdef CL_DEVICE_PLATFORM
  rb_define_const(rb_cDevice, "PLATFORM", UINT2NUM((uint)CL_DEVICE_PLATFORM));
#endif
#ifdef CL_LOCAL
  rb_define_const(rb_cDevice, "LOCAL", UINT2NUM((uint)CL_LOCAL));
#endif
#ifdef CL_GLOBAL
  rb_define_const(rb_cDevice, "GLOBAL", UINT2NUM((uint)CL_GLOBAL));
#endif

  // rb_cContext
#ifdef CL_CONTEXT_REFERENCE_COUNT
  rb_define_const(rb_cContext, "REFERENCE_COUNT", UINT2NUM((uint)CL_CONTEXT_REFERENCE_COUNT));
#endif
#ifdef CL_CONTEXT_DEVICES
  rb_define_const(rb_cContext, "DEVICES", UINT2NUM((uint)CL_CONTEXT_DEVICES));
#endif
#ifdef CL_CONTEXT_PROPERTIES
  rb_define_const(rb_cContext, "PROPERTIES", UINT2NUM((uint)CL_CONTEXT_PROPERTIES));
#endif
#ifdef CL_CONTEXT_NUM_DEVICES
  rb_define_const(rb_cContext, "NUM_DEVICES", UINT2NUM((uint)CL_CONTEXT_NUM_DEVICES));
#endif
#ifdef CL_CONTEXT_PLATFORM
  rb_define_const(rb_cContext, "PLATFORM", UINT2NUM((uint)CL_CONTEXT_PLATFORM));
#endif

  // rb_cCommandQueue
#ifdef CL_QUEUE_OUT_OF_ORDER_EXEC_MODE_ENABLE
  rb_define_const(rb_cCommandQueue, "OUT_OF_ORDER_EXEC_MODE_ENABLE", ULONG2NUM((ulong)CL_QUEUE_OUT_OF_ORDER_EXEC_MODE_ENABLE));
#endif
#ifdef CL_QUEUE_PROFILING_ENABLE
  rb_define_const(rb_cCommandQueue, "PROFILING_ENABLE", ULONG2NUM((ulong)CL_QUEUE_PROFILING_ENABLE));
#endif
#ifdef CL_QUEUE_CONTEXT
  rb_define_const(rb_cCommandQueue, "CONTEXT", UINT2NUM((uint)CL_QUEUE_CONTEXT));
#endif
#ifdef CL_QUEUE_DEVICE
  rb_define_const(rb_cCommandQueue, "DEVICE", UINT2NUM((uint)CL_QUEUE_DEVICE));
#endif
#ifdef CL_QUEUE_REFERENCE_COUNT
  rb_define_const(rb_cCommandQueue, "REFERENCE_COUNT", UINT2NUM((uint)CL_QUEUE_REFERENCE_COUNT));
#endif
#ifdef CL_QUEUE_PROPERTIES
  rb_define_const(rb_cCommandQueue, "PROPERTIES", UINT2NUM((uint)CL_QUEUE_PROPERTIES));
#endif

  // rb_cMem
#ifdef CL_MEM_TYPE
  rb_define_const(rb_cMem, "TYPE", UINT2NUM((uint)CL_MEM_TYPE));
#endif
#ifdef CL_MEM_FLAGS
  rb_define_const(rb_cMem, "FLAGS", UINT2NUM((uint)CL_MEM_FLAGS));
#endif
#ifdef CL_MEM_SIZE
  rb_define_const(rb_cMem, "SIZE", UINT2NUM((uint)CL_MEM_SIZE));
#endif
#ifdef CL_MEM_HOST_PTR
  rb_define_const(rb_cMem, "HOST_PTR", UINT2NUM((uint)CL_MEM_HOST_PTR));
#endif
#ifdef CL_MEM_MAP_COUNT
  rb_define_const(rb_cMem, "MAP_COUNT", UINT2NUM((uint)CL_MEM_MAP_COUNT));
#endif
#ifdef CL_MEM_REFERENCE_COUNT
  rb_define_const(rb_cMem, "REFERENCE_COUNT", UINT2NUM((uint)CL_MEM_REFERENCE_COUNT));
#endif
#ifdef CL_MEM_CONTEXT
  rb_define_const(rb_cMem, "CONTEXT", UINT2NUM((uint)CL_MEM_CONTEXT));
#endif
#ifdef CL_MEM_ASSOCIATED_MEMOBJECT
  rb_define_const(rb_cMem, "ASSOCIATED_MEMOBJECT", UINT2NUM((uint)CL_MEM_ASSOCIATED_MEMOBJECT));
#endif
#ifdef CL_MEM_OFFSET
  rb_define_const(rb_cMem, "OFFSET", UINT2NUM((uint)CL_MEM_OFFSET));
#endif
#ifdef CL_MEM_READ_WRITE
  rb_define_const(rb_cMem, "READ_WRITE", ULONG2NUM((ulong)CL_MEM_READ_WRITE));
#endif
#ifdef CL_MEM_WRITE_ONLY
  rb_define_const(rb_cMem, "WRITE_ONLY", ULONG2NUM((ulong)CL_MEM_WRITE_ONLY));
#endif
#ifdef CL_MEM_READ_ONLY
  rb_define_const(rb_cMem, "READ_ONLY", ULONG2NUM((ulong)CL_MEM_READ_ONLY));
#endif
#ifdef CL_MEM_USE_HOST_PTR
  rb_define_const(rb_cMem, "USE_HOST_PTR", ULONG2NUM((ulong)CL_MEM_USE_HOST_PTR));
#endif
#ifdef CL_MEM_ALLOC_HOST_PTR
  rb_define_const(rb_cMem, "ALLOC_HOST_PTR", ULONG2NUM((ulong)CL_MEM_ALLOC_HOST_PTR));
#endif
#ifdef CL_MEM_COPY_HOST_PTR
  rb_define_const(rb_cMem, "COPY_HOST_PTR", ULONG2NUM((ulong)CL_MEM_COPY_HOST_PTR));
#endif
#ifdef CL_MEM_OBJECT_BUFFER
  rb_define_const(rb_cMem, "BUFFER", UINT2NUM((uint)CL_MEM_OBJECT_BUFFER));
#endif
#ifdef CL_MEM_OBJECT_IMAGE2D
  rb_define_const(rb_cMem, "IMAGE2D", UINT2NUM((uint)CL_MEM_OBJECT_IMAGE2D));
#endif
#ifdef CL_MEM_OBJECT_IMAGE3D
  rb_define_const(rb_cMem, "IMAGE3D", UINT2NUM((uint)CL_MEM_OBJECT_IMAGE3D));
#endif

  // rb_cBuffer
#ifdef CL_BUFFER_CREATE_TYPE_REGION
  rb_define_const(rb_cBuffer, "CREATE_TYPE_REGION", UINT2NUM((uint)CL_BUFFER_CREATE_TYPE_REGION));
#endif

  // rb_cImage
#ifdef CL_IMAGE_FORMAT
  rb_define_const(rb_cImage, "FORMAT", UINT2NUM((uint)CL_IMAGE_FORMAT));
#endif
#ifdef CL_IMAGE_ELEMENT_SIZE
  rb_define_const(rb_cImage, "ELEMENT_SIZE", UINT2NUM((uint)CL_IMAGE_ELEMENT_SIZE));
#endif
#ifdef CL_IMAGE_ROW_PITCH
  rb_define_const(rb_cImage, "ROW_PITCH", UINT2NUM((uint)CL_IMAGE_ROW_PITCH));
#endif
#ifdef CL_IMAGE_SLICE_PITCH
  rb_define_const(rb_cImage, "SLICE_PITCH", UINT2NUM((uint)CL_IMAGE_SLICE_PITCH));
#endif
#ifdef CL_IMAGE_WIDTH
  rb_define_const(rb_cImage, "WIDTH", UINT2NUM((uint)CL_IMAGE_WIDTH));
#endif
#ifdef CL_IMAGE_HEIGHT
  rb_define_const(rb_cImage, "HEIGHT", UINT2NUM((uint)CL_IMAGE_HEIGHT));
#endif
#ifdef CL_IMAGE_DEPTH
  rb_define_const(rb_cImage, "DEPTH", UINT2NUM((uint)CL_IMAGE_DEPTH));
#endif

  // rb_cSampler
#ifdef CL_SAMPLER_REFERENCE_COUNT
  rb_define_const(rb_cSampler, "REFERENCE_COUNT", UINT2NUM((uint)CL_SAMPLER_REFERENCE_COUNT));
#endif
#ifdef CL_SAMPLER_CONTEXT
  rb_define_const(rb_cSampler, "CONTEXT", UINT2NUM((uint)CL_SAMPLER_CONTEXT));
#endif
#ifdef CL_SAMPLER_NORMALIZED_COORDS
  rb_define_const(rb_cSampler, "NORMALIZED_COORDS", UINT2NUM((uint)CL_SAMPLER_NORMALIZED_COORDS));
#endif
#ifdef CL_SAMPLER_ADDRESSING_MODE
  rb_define_const(rb_cSampler, "ADDRESSING_MODE", UINT2NUM((uint)CL_SAMPLER_ADDRESSING_MODE));
#endif
#ifdef CL_SAMPLER_FILTER_MODE
  rb_define_const(rb_cSampler, "FILTER_MODE", UINT2NUM((uint)CL_SAMPLER_FILTER_MODE));
#endif

  // rb_cProgram
#ifdef CL_PROGRAM_REFERENCE_COUNT
  rb_define_const(rb_cProgram, "REFERENCE_COUNT", UINT2NUM((uint)CL_PROGRAM_REFERENCE_COUNT));
#endif
#ifdef CL_PROGRAM_CONTEXT
  rb_define_const(rb_cProgram, "CONTEXT", UINT2NUM((uint)CL_PROGRAM_CONTEXT));
#endif
#ifdef CL_PROGRAM_NUM_DEVICES
  rb_define_const(rb_cProgram, "NUM_DEVICES", UINT2NUM((uint)CL_PROGRAM_NUM_DEVICES));
#endif
#ifdef CL_PROGRAM_DEVICES
  rb_define_const(rb_cProgram, "DEVICES", UINT2NUM((uint)CL_PROGRAM_DEVICES));
#endif
#ifdef CL_PROGRAM_SOURCE
  rb_define_const(rb_cProgram, "SOURCE", UINT2NUM((uint)CL_PROGRAM_SOURCE));
#endif
#ifdef CL_PROGRAM_BINARY_SIZES
  rb_define_const(rb_cProgram, "BINARY_SIZES", UINT2NUM((uint)CL_PROGRAM_BINARY_SIZES));
#endif
#ifdef CL_PROGRAM_BINARIES
  rb_define_const(rb_cProgram, "BINARIES", UINT2NUM((uint)CL_PROGRAM_BINARIES));
#endif
#ifdef CL_PROGRAM_BUILD_STATUS
  rb_define_const(rb_cProgram, "BUILD_STATUS", UINT2NUM((uint)CL_PROGRAM_BUILD_STATUS));
#endif
#ifdef CL_PROGRAM_BUILD_OPTIONS
  rb_define_const(rb_cProgram, "BUILD_OPTIONS", UINT2NUM((uint)CL_PROGRAM_BUILD_OPTIONS));
#endif
#ifdef CL_PROGRAM_BUILD_LOG
  rb_define_const(rb_cProgram, "BUILD_LOG", UINT2NUM((uint)CL_PROGRAM_BUILD_LOG));
#endif

  // rb_cKernel
#ifdef CL_KERNEL_FUNCTION_NAME
  rb_define_const(rb_cKernel, "FUNCTION_NAME", UINT2NUM((uint)CL_KERNEL_FUNCTION_NAME));
#endif
#ifdef CL_KERNEL_NUM_ARGS
  rb_define_const(rb_cKernel, "NUM_ARGS", UINT2NUM((uint)CL_KERNEL_NUM_ARGS));
#endif
#ifdef CL_KERNEL_REFERENCE_COUNT
  rb_define_const(rb_cKernel, "REFERENCE_COUNT", UINT2NUM((uint)CL_KERNEL_REFERENCE_COUNT));
#endif
#ifdef CL_KERNEL_CONTEXT
  rb_define_const(rb_cKernel, "CONTEXT", UINT2NUM((uint)CL_KERNEL_CONTEXT));
#endif
#ifdef CL_KERNEL_PROGRAM
  rb_define_const(rb_cKernel, "PROGRAM", UINT2NUM((uint)CL_KERNEL_PROGRAM));
#endif
#ifdef CL_KERNEL_WORK_GROUP_SIZE
  rb_define_const(rb_cKernel, "WORK_GROUP_SIZE", UINT2NUM((uint)CL_KERNEL_WORK_GROUP_SIZE));
#endif
#ifdef CL_KERNEL_COMPILE_WORK_GROUP_SIZE
  rb_define_const(rb_cKernel, "COMPILE_WORK_GROUP_SIZE", UINT2NUM((uint)CL_KERNEL_COMPILE_WORK_GROUP_SIZE));
#endif
#ifdef CL_KERNEL_LOCAL_MEM_SIZE
  rb_define_const(rb_cKernel, "LOCAL_MEM_SIZE", UINT2NUM((uint)CL_KERNEL_LOCAL_MEM_SIZE));
#endif
#ifdef CL_KERNEL_PREFERRED_WORK_GROUP_SIZE_MULTIPLE
  rb_define_const(rb_cKernel, "PREFERRED_WORK_GROUP_SIZE_MULTIPLE", UINT2NUM((uint)CL_KERNEL_PREFERRED_WORK_GROUP_SIZE_MULTIPLE));
#endif
#ifdef CL_KERNEL_PRIVATE_MEM_SIZE
  rb_define_const(rb_cKernel, "PRIVATE_MEM_SIZE", UINT2NUM((uint)CL_KERNEL_PRIVATE_MEM_SIZE));
#endif

  // rb_cEvent
#ifdef CL_EVENT_COMMAND_QUEUE
  rb_define_const(rb_cEvent, "COMMAND_QUEUE", UINT2NUM((uint)CL_EVENT_COMMAND_QUEUE));
#endif
#ifdef CL_EVENT_COMMAND_TYPE
  rb_define_const(rb_cEvent, "COMMAND_TYPE", UINT2NUM((uint)CL_EVENT_COMMAND_TYPE));
#endif
#ifdef CL_EVENT_REFERENCE_COUNT
  rb_define_const(rb_cEvent, "REFERENCE_COUNT", UINT2NUM((uint)CL_EVENT_REFERENCE_COUNT));
#endif
#ifdef CL_EVENT_COMMAND_EXECUTION_STATUS
  rb_define_const(rb_cEvent, "COMMAND_EXECUTION_STATUS", UINT2NUM((uint)CL_EVENT_COMMAND_EXECUTION_STATUS));
#endif
#ifdef CL_EVENT_CONTEXT
  rb_define_const(rb_cEvent, "CONTEXT", UINT2NUM((uint)CL_EVENT_CONTEXT));
#endif

#ifdef CL_VERSION_1_0
  rb_define_method(rb_cProgram, "build", rb_clBuildProgram, -1);
#endif
#ifdef CL_VERSION_1_0
  rb_define_singleton_method(rb_cBuffer, "new", rb_clCreateBuffer, -1);
#endif
#ifdef CL_VERSION_1_0
  rb_define_singleton_method(rb_cCommandQueue, "new", rb_clCreateCommandQueue, -1);
#endif
#ifdef CL_VERSION_1_0
  rb_define_singleton_method(rb_cContext, "new", rb_clCreateContext, -1);
#endif
#ifdef CL_VERSION_1_0
  rb_define_singleton_method(rb_cContext, "create_from_type", rb_clCreateContextFromType, -1);
#endif
#ifdef CL_VERSION_1_0
  rb_define_singleton_method(rb_cImage2D, "new", rb_clCreateImage2D, -1);
#endif
#ifdef CL_VERSION_1_0
  rb_define_singleton_method(rb_cImage3D, "new", rb_clCreateImage3D, -1);
#endif
#ifdef CL_VERSION_1_0
  rb_define_singleton_method(rb_cKernel, "new", rb_clCreateKernel, -1);
#endif
#ifdef CL_VERSION_1_0
  rb_define_method(rb_cProgram, "create_kernels", rb_clCreateKernelsInProgram, -1);
#endif
#ifdef CL_VERSION_1_0
  rb_define_method(rb_cContext, "create_program_with_binary", rb_clCreateProgramWithBinary, -1);
#endif
#ifdef CL_VERSION_1_0
  rb_define_singleton_method(rb_cProgram, "create_with_source", rb_clCreateProgramWithSource, -1);
#endif
#ifdef CL_VERSION_1_0
  rb_define_singleton_method(rb_cSampler, "new", rb_clCreateSampler, -1);
#endif
#ifdef CL_VERSION_1_1
  rb_define_method(rb_cMem, "create_sub_buffer", rb_clCreateSubBuffer, -1);
#endif
#ifdef CL_VERSION_1_0
  rb_define_method(rb_cCommandQueue, "enqueue_barrier", rb_clEnqueueBarrier, -1);
#endif
#ifdef CL_VERSION_1_0
  rb_define_method(rb_cCommandQueue, "enqueue_copy_buffer", rb_clEnqueueCopyBuffer, -1);
#endif
#ifdef CL_VERSION_1_1
  rb_define_method(rb_cCommandQueue, "enqueue_copy_buffer_rect", rb_clEnqueueCopyBufferRect, -1);
#endif
#ifdef CL_VERSION_1_0
  rb_define_method(rb_cCommandQueue, "enqueue_copy_buffer_to_image", rb_clEnqueueCopyBufferToImage, -1);
#endif
#ifdef CL_VERSION_1_0
  rb_define_method(rb_cCommandQueue, "enqueue_copy_image", rb_clEnqueueCopyImage, -1);
#endif
#ifdef CL_VERSION_1_0
  rb_define_method(rb_cCommandQueue, "enqueue_copy_image_to_buffer", rb_clEnqueueCopyImageToBuffer, -1);
#endif
#ifdef CL_VERSION_1_0
  rb_define_method(rb_cCommandQueue, "enqueue_map_buffer", rb_clEnqueueMapBuffer, -1);
#endif
#ifdef CL_VERSION_1_0
  rb_define_method(rb_cCommandQueue, "enqueue_map_image", rb_clEnqueueMapImage, -1);
#endif
#ifdef CL_VERSION_1_0
  rb_define_method(rb_cCommandQueue, "enqueue_marker", rb_clEnqueueMarker, -1);
#endif
#ifdef CL_VERSION_1_0
  rb_define_method(rb_cCommandQueue, "enqueue_NDrange_kernel", rb_clEnqueueNDRangeKernel, -1);
#endif
#ifdef CL_VERSION_1_0
  rb_define_method(rb_cCommandQueue, "enqueue_native_kernel", rb_clEnqueueNativeKernel, -1);
#endif
#ifdef CL_VERSION_1_0
  rb_define_method(rb_cCommandQueue, "enqueue_read_buffer", rb_clEnqueueReadBuffer, -1);
#endif
#ifdef CL_VERSION_1_1
  rb_define_method(rb_cCommandQueue, "enqueue_read_buffer_rect", rb_clEnqueueReadBufferRect, -1);
#endif
#ifdef CL_VERSION_1_0
  rb_define_method(rb_cCommandQueue, "enqueue_read_image", rb_clEnqueueReadImage, -1);
#endif
#ifdef CL_VERSION_1_0
  rb_define_method(rb_cCommandQueue, "enqueue_task", rb_clEnqueueTask, -1);
#endif
#ifdef CL_VERSION_1_0
  rb_define_method(rb_cCommandQueue, "enqueue_unmap_mem_object", rb_clEnqueueUnmapMemObject, -1);
#endif
#ifdef CL_VERSION_1_0
  rb_define_method(rb_cCommandQueue, "enqueue_wait_for_events", rb_clEnqueueWaitForEvents, -1);
#endif
#ifdef CL_VERSION_1_0
  rb_define_method(rb_cCommandQueue, "enqueue_write_buffer", rb_clEnqueueWriteBuffer, -1);
#endif
#ifdef CL_VERSION_1_1
  rb_define_method(rb_cCommandQueue, "enqueue_write_buffer_rect", rb_clEnqueueWriteBufferRect, -1);
#endif
#ifdef CL_VERSION_1_0
  rb_define_method(rb_cCommandQueue, "enqueue_write_image", rb_clEnqueueWriteImage, -1);
#endif
#ifdef CL_VERSION_1_0
  rb_define_method(rb_cCommandQueue, "finish", rb_clFinish, -1);
#endif
#ifdef CL_VERSION_1_0
  rb_define_method(rb_cCommandQueue, "flush", rb_clFlush, -1);
#endif
#ifdef CL_VERSION_1_0
  rb_define_method(rb_cCommandQueue, "get_info", rb_clGetCommandQueueInfo, -1);
#endif
#ifdef CL_VERSION_1_0
  rb_define_method(rb_cContext, "get_info", rb_clGetContextInfo, -1);
#endif
#ifdef CL_VERSION_1_0
  rb_define_singleton_method(rb_cDevice, "get_devices", rb_clGetDeviceIDs, -1);
#endif
#ifdef CL_VERSION_1_0
  rb_define_method(rb_cDevice, "get_info", rb_clGetDeviceInfo, -1);
#endif
#ifdef CL_VERSION_1_0
  rb_define_method(rb_cEvent, "get_info", rb_clGetEventInfo, -1);
#endif
#ifdef CL_VERSION_1_0
  rb_define_method(rb_cEvent, "get_profiling_info", rb_clGetEventProfilingInfo, -1);
#endif
#ifdef CL_VERSION_1_0
  rb_define_method(rb_cImage, "get_info", rb_clGetImageInfo, -1);
#endif
#ifdef CL_VERSION_1_0
  rb_define_method(rb_cKernel, "get_info", rb_clGetKernelInfo, -1);
#endif
#ifdef CL_VERSION_1_0
  rb_define_method(rb_cKernel, "get_work_group_info", rb_clGetKernelWorkGroupInfo, -1);
#endif
#ifdef CL_VERSION_1_0
  rb_define_method(rb_cMem, "get_info", rb_clGetMemObjectInfo, -1);
#endif
#ifdef CL_VERSION_1_0
  rb_define_singleton_method(rb_cPlatform, "get_platforms", rb_clGetPlatformIDs, -1);
#endif
#ifdef CL_VERSION_1_0
  rb_define_method(rb_cPlatform, "get_info", rb_clGetPlatformInfo, -1);
#endif
#ifdef CL_VERSION_1_0
  rb_define_method(rb_cProgram, "get_build_info", rb_clGetProgramBuildInfo, -1);
#endif
#ifdef CL_VERSION_1_0
  rb_define_method(rb_cProgram, "get_info", rb_clGetProgramInfo, -1);
#endif
#ifdef CL_VERSION_1_0
  rb_define_method(rb_cSampler, "get_info", rb_clGetSamplerInfo, -1);
#endif
#ifdef CL_VERSION_1_0
  rb_define_method(rb_cContext, "get_supported_image_formats", rb_clGetSupportedImageFormats, -1);
#endif
#ifdef CL_VERSION_1_1
  rb_define_method(rb_cEvent, "set_callback", rb_clSetEventCallback, -1);
#endif
#ifdef CL_VERSION_1_0
  rb_define_method(rb_cKernel, "set_arg", rb_clSetKernelArg, -1);
#endif
#ifdef CL_VERSION_1_1
  rb_define_method(rb_cEvent, "set_user_event_status", rb_clSetUserEventStatus, -1);
#endif
#ifdef CL_VERSION_1_0
  rb_define_module_function(rb_mOpenCL, "unload_compiler", rb_clUnloadCompiler, -1);
#endif
#ifdef CL_VERSION_1_0
  rb_define_singleton_method(rb_cEvent, "wait", rb_clWaitForEvents, -1);
#endif
  rb_define_method(rb_cContext, "devices", rb_GetContextDevices, -1);
  rb_define_method(rb_cProgram, "devices", rb_GetProgramDevices, -1);
  rb_define_method(rb_cCommandQueue, "device", rb_GetCommandQueueDevice, -1);
  rb_define_method(rb_cCommandQueue, "context", rb_GetCommandQueueContext, -1);
  rb_define_method(rb_cMem, "context", rb_GetMemObjectContext, -1);
  rb_define_method(rb_cSampler, "context", rb_GetSamplerContext, -1);
  rb_define_method(rb_cProgram, "context", rb_GetProgramContext, -1);
  rb_define_method(rb_cKernel, "context", rb_GetKernelContext, -1);
  rb_define_method(rb_cKernel, "program", rb_GetKernelProgram, -1);
  rb_define_method(rb_cEvent, "command_queue", rb_GetEventCommandQueue, -1);
  rb_define_singleton_method(rb_cImageFormat, "new", rb_CreateImageFormat, -1);
  rb_define_method(rb_cImageFormat, "image_channel_order", rb_GetImageFormatImageChannelOrder, -1);
  rb_define_method(rb_cImageFormat, "image_channel_data_type", rb_GetImageFormatImageChannelDataType, -1);


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
  rb_cDouble2 = rb_define_class_under(rb_mOpenCL, "Double2", rb_cVector);
  rb_cDouble4 = rb_define_class_under(rb_mOpenCL, "Double4", rb_cVector);
  rb_cDouble8 = rb_define_class_under(rb_mOpenCL, "Double8", rb_cVector);
  rb_cDouble16 = rb_define_class_under(rb_mOpenCL, "Double16", rb_cVector);

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
  rb_define_const(rb_cVArray, "DOUBLE", UINT2NUM(vector_type_code(VA_DOUBLE,1)));
  rb_define_const(rb_cVArray, "DOUBLE2", UINT2NUM(vector_type_code(VA_DOUBLE,2)));
  rb_define_const(rb_cVArray, "DOUBLE4", UINT2NUM(vector_type_code(VA_DOUBLE,4)));
  rb_define_const(rb_cVArray, "DOUBLE8", UINT2NUM(vector_type_code(VA_DOUBLE,8)));
  rb_define_const(rb_cVArray, "DOUBLE16", UINT2NUM(vector_type_code(VA_DOUBLE,16)));

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
  rb_define_singleton_method(rb_cDouble2, "new", rb_CreateDouble2, -1);
  rb_define_method(rb_cDouble2, "to_a", rb_Double2_toA, -1);
  rb_define_singleton_method(rb_cDouble4, "new", rb_CreateDouble4, -1);
  rb_define_method(rb_cDouble4, "to_a", rb_Double4_toA, -1);
  rb_define_singleton_method(rb_cDouble8, "new", rb_CreateDouble8, -1);
  rb_define_method(rb_cDouble8, "to_a", rb_Double8_toA, -1);
  rb_define_singleton_method(rb_cDouble16, "new", rb_CreateDouble16, -1);
  rb_define_method(rb_cDouble16, "to_a", rb_Double16_toA, -1);
  rb_define_singleton_method(rb_cVArray, "new", rb_CreateVArray, -1);
  rb_define_singleton_method(rb_cVArray, "to_va", rb_CreateVArrayFromObject, -1);
  rb_define_method(rb_cVArray, "length", rb_VArray_length, -1);
  rb_define_method(rb_cVArray, "data_size", rb_VArray_data_size, -1);
  rb_define_method(rb_cVArray, "to_s", rb_VArray_toS, -1);
  rb_define_method(rb_cVArray, "type_code", rb_VArray_typeCode, -1);
  rb_define_method(rb_cVArray, "[]", rb_VArray_aref, -1);
  rb_define_method(rb_cVArray, "[]=", rb_VArray_aset, -1);
  rb_define_method(rb_cVArray, "+", rb_VArray_add, -1);
  rb_define_method(rb_cVArray, "-", rb_VArray_sbt, -1);
  rb_define_method(rb_cVArray, "*", rb_VArray_mul, -1);
  rb_define_method(rb_cVArray, "/", rb_VArray_div, -1);
  rb_define_method(rb_cVArray, "copy", rb_VArray_copy, -1);
#ifdef HAVE_NARRAY_H
  rb_define_method(rb_cVArray, "to_na", rb_VArray_toNa, -1);

  rb_define_const(rb_cVArray, "NARRAY_ENABLED", Qtrue);
#else
  rb_define_const(rb_cVArray, "NARRAY_ENABLED", Qfalse);
#endif

#ifdef CL_BIG_ENDIAN
  rb_define_const(rb_cVector, "BIG_ENDIAN", Qtrue);
#else
  rb_define_const(rb_cVector, "BIG_ENDIAN", Qfalse);
#endif


}

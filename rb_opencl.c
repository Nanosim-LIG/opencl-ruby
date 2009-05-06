#include "ruby.h"
#include "cl.h"

static VALUE rb_mOpenCL;
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

struct  _struct_mem {
  cl_mem mem;
  VALUE host_ptr;
};
typedef struct _struct_mem *struct_mem;
static void
check_error(cl_int errcode)
{
  switch (errcode) {
  case CL_SUCCESS:
    rb_raise(rb_eRuntimeError, ": error code is %d", errcode);
    break;
  case CL_DEVICE_NOT_FOUND:
    rb_raise(rb_eRuntimeError, ": error code is %d", errcode);
    break;
  case CL_DEVICE_NOT_AVAILABLE:
    rb_raise(rb_eRuntimeError, ": error code is %d", errcode);
    break;
  case CL_DEVICE_COMPILER_NOT_AVAILABLE:
    rb_raise(rb_eRuntimeError, ": error code is %d", errcode);
    break;
  case CL_MEM_OBJECT_ALLOCATION_FAILURE:
    rb_raise(rb_eRuntimeError, ": error code is %d", errcode);
    break;
  case CL_OUT_OF_RESOURCES:
    rb_raise(rb_eRuntimeError, ": error code is %d", errcode);
    break;
  case CL_OUT_OF_HOST_MEMORY:
    rb_raise(rb_eRuntimeError, ": error code is %d", errcode);
    break;
  case CL_PROFILING_INFO_NOT_AVAILABLE:
    rb_raise(rb_eRuntimeError, ": error code is %d", errcode);
    break;
  case CL_MEM_COPY_OVERLAP:
    rb_raise(rb_eRuntimeError, ": error code is %d", errcode);
    break;
  case CL_IMAGE_FORMAT_MISMATCH:
    rb_raise(rb_eRuntimeError, ": error code is %d", errcode);
    break;
  case CL_IMAGE_FORMAT_NOT_SUPPORTED:
    rb_raise(rb_eRuntimeError, ": error code is %d", errcode);
    break;
  case CL_BUILD_PROGRAM_FAILURE:
    rb_raise(rb_eRuntimeError, ": error code is %d", errcode);
    break;
  case CL_MAP_FAILURE:
    rb_raise(rb_eRuntimeError, ": error code is %d", errcode);
    break;
  case CL_INVALID_VALUE:
    rb_raise(rb_eRuntimeError, "the values specified in properties are not valid: error code is %d", errcode);
    break;
  case CL_INVALID_DEVICE_TYPE:
    rb_raise(rb_eRuntimeError, ": error code is %d", errcode);
    break;
  case CL_INVALID_PLATFORM:
    rb_raise(rb_eRuntimeError, ": error code is %d", errcode);
    break;
  case CL_INVALID_DEVICE:
    rb_raise(rb_eRuntimeError, ": error code is %d", errcode);
    break;
  case CL_INVALID_CONTEXT:
    rb_raise(rb_eRuntimeError, ": error code is %d", errcode);
    break;
  case CL_INVALID_QUEUE_PROPERTIES:
    rb_raise(rb_eRuntimeError, "values specified in properties are not supported by the device: error code is %d", errcode);
    break;
  case CL_INVALID_COMMAND_QUEUE:
    rb_raise(rb_eRuntimeError, "command_queue is not a valid comand-queue: error code is %d", errcode);
    break;
  case CL_INVALID_HOST_PTR:
    rb_raise(rb_eRuntimeError, ": error code is %d", errcode);
    break;
  case CL_INVALID_MEM_OBJECT:
    rb_raise(rb_eRuntimeError, ": error code is %d", errcode);
    break;
  case CL_INVALID_IMAGE_FORMAT_DESCRIPTOR:
    rb_raise(rb_eRuntimeError, ": error code is %d", errcode);
    break;
  case CL_INVALID_IMAGE_SIZE:
    rb_raise(rb_eRuntimeError, ": error code is %d", errcode);
    break;
  case CL_INVALID_SAMPLER:
    rb_raise(rb_eRuntimeError, ": error code is %d", errcode);
    break;
  case CL_INVALID_BINARY:
    rb_raise(rb_eRuntimeError, ": error code is %d", errcode);
    break;
  case CL_INVALID_BUILD_OPTIONS:
    rb_raise(rb_eRuntimeError, ": error code is %d", errcode);
    break;
  case CL_INVALID_PROGRAM:
    rb_raise(rb_eRuntimeError, ": error code is %d", errcode);
    break;
  case CL_INVALID_PROGRAM_EXECUTABLE:
    rb_raise(rb_eRuntimeError, ": error code is %d", errcode);
    break;
  case CL_INVALID_KERNEL_NAME:
    rb_raise(rb_eRuntimeError, ": error code is %d", errcode);
    break;
  case CL_INVALID_KERNEL_DEFINITION:
    rb_raise(rb_eRuntimeError, ": error code is %d", errcode);
    break;
  case CL_INVALID_KERNEL:
    rb_raise(rb_eRuntimeError, ": error code is %d", errcode);
    break;
  case CL_INVALID_ARG_INDEX:
    rb_raise(rb_eRuntimeError, ": error code is %d", errcode);
    break;
  case CL_INVALID_ARG_VALUE:
    rb_raise(rb_eRuntimeError, ": error code is %d", errcode);
    break;
  case CL_INVALID_ARG_SIZE:
    rb_raise(rb_eRuntimeError, ": error code is %d", errcode);
    break;
  case CL_INVALID_KERNEL_ARGS:
    rb_raise(rb_eRuntimeError, ": error code is %d", errcode);
    break;
  case CL_INVALID_WORK_DIMENSION:
    rb_raise(rb_eRuntimeError, ": error code is %d", errcode);
    break;
  case CL_INVALID_WORK_GROUP_SIZE:
    rb_raise(rb_eRuntimeError, ": error code is %d", errcode);
    break;
  case CL_INVALID_GLOBAL_OFFSET:
    rb_raise(rb_eRuntimeError, ": error code is %d", errcode);
    break;
  case CL_INVALID_EVENT_WAIT_LIST:
    rb_raise(rb_eRuntimeError, ": error code is %d", errcode);
    break;
  case CL_INVALID_EVENT:
    rb_raise(rb_eRuntimeError, ": error code is %d", errcode);
    break;
  case CL_INVALID_OPERATION:
    rb_raise(rb_eRuntimeError, ": error code is %d", errcode);
    break;
  case CL_INVALID_GL_OBJECT:
    rb_raise(rb_eRuntimeError, ": error code is %d", errcode);
    break;
  case CL_INVALID_BUFFER_SIZE:
    rb_raise(rb_eRuntimeError, ": error code is %d", errcode);
    break;
  case CL_INVALID_MIP_LEVEL:
    rb_raise(rb_eRuntimeError, ": error code is %d", errcode);
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
  clRetainContext(context);
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
  clRetainCommandQueue(command_queue);
  return Data_Wrap_Struct(rb_cCommandQueue, 0, command_queue_free, (void*)command_queue);
}

static void
mem_free(struct_mem mem)
{
  clReleaseMemObject(mem->mem);
  free(mem);
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
  clRetainMemObject(mem->mem);
  return Data_Wrap_Struct(rb_cMem, mem_mark, mem_free, (void*)mem);
}

static void
image_format_free(cl_image_format *image_format)
{
  free(image_format);
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
  clRetainSampler(sampler);
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
  clRetainProgram(program);
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
  clRetainKernel(kernel);
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
  clRetainEvent(event);
  return Data_Wrap_Struct(rb_cEvent, 0, event_free, (void*)event);
}
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
  VALUE rb_command_queue = Qnil;
  VALUE rb_buffer = Qnil;
  VALUE rb_blocking_map = Qnil;
  VALUE rb_map_flags = Qnil;
  VALUE rb_offset = Qnil;
  VALUE rb_cb = Qnil;
  VALUE rb_event_wait_list = Qnil;
  VALUE rb_event = Qnil;

  VALUE result;

  if (argc > 5)
    rb_raise(rb_eArgError, "wrong number of arguments (%d for %d)", argc, 4);

  if (argc < 4)
    rb_raise(rb_eArgError, "wrong number of arguments (%d for 4)", argc);
  rb_command_queue = argv[0];
  Check_Type(rb_command_queue, T_DATA);
  if (CLASS_OF(rb_command_queue) != rb_cCommandQueue)
    rb_raise(rb_eRuntimeError, "type of command_queue is invalid: CommandQueue is expected");
  command_queue = (cl_command_queue)DATA_PTR(rb_command_queue);

  rb_buffer = argv[1];
  Check_Type(rb_buffer, T_DATA);
  if (CLASS_OF(rb_buffer) != rb_cMem)
    rb_raise(rb_eRuntimeError, "type of buffer is invalid: Mem is expected");
  buffer = ((struct_mem)DATA_PTR(rb_buffer))->mem;

  rb_blocking_map = argv[2];
  blocking_map = NUM2UINT(rb_blocking_map);

  rb_map_flags = argv[3];
  map_flags = NUM2ULONG(rb_map_flags);


  {
    VALUE _opt_hash = Qnil;

    if (argc > 4) {
      _opt_hash = argv[4];
      Check_Type(_opt_hash, T_HASH);
    }
    if (_opt_hash != Qnil) {
      rb_offset = rb_hash_aref(_opt_hash, rb_intern("offset"));
    }
    if (_opt_hash != Qnil && rb_offset != Qnil) {
      offset = NUM2ULONG(rb_offset);

    } else {
      offset = 0;
    }
    if (_opt_hash != Qnil) {
      rb_cb = rb_hash_aref(_opt_hash, rb_intern("cb"));
    }
    if (_opt_hash != Qnil && rb_cb != Qnil) {
      cb = NUM2ULONG(rb_cb);

    } else {
      cb = 0;
    }
    if (_opt_hash != Qnil) {
      rb_event_wait_list = rb_hash_aref(_opt_hash, rb_intern("event_wait_list"));
    }
    if (_opt_hash != Qnil && rb_event_wait_list != Qnil) {
      Check_Type(rb_event_wait_list, T_ARRAY);
      {
        int n;
        num_events_in_wait_list = RARRAY_LEN(rb_event_wait_list);
        event_wait_list = ALLOC_N(cl_event, num_events_in_wait_list);
        for (n=0; n<num_events_in_wait_list; n++) {
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


  ret = clEnqueueMapBuffer(command_queue, buffer, blocking_map, map_flags, offset, cb, num_events_in_wait_list, (const cl_event*) event_wait_list, &event, &errcode_ret);
  check_error(errcode_ret);

  {
    VALUE rb_ret;
    rb_ret = rb_str_new2(ret);

    rb_event = create_event(event);

    result = rb_ary_new3(2, ret, rb_event);
  }

  free(event_wait_list);

  return result;
}

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
  VALUE rb_command_queue = Qnil;
  VALUE rb_src_image = Qnil;
  VALUE rb_dst_image = Qnil;
  VALUE rb_src_origin = Qnil;
  VALUE rb_dst_origin = Qnil;
  VALUE rb_region = Qnil;
  VALUE rb_event_wait_list = Qnil;
  VALUE rb_event = Qnil;

  VALUE result;

  if (argc > 4)
    rb_raise(rb_eArgError, "wrong number of arguments (%d for %d)", argc, 3);

  if (argc < 3)
    rb_raise(rb_eArgError, "wrong number of arguments (%d for 3)", argc);
  rb_command_queue = argv[0];
  Check_Type(rb_command_queue, T_DATA);
  if (CLASS_OF(rb_command_queue) != rb_cCommandQueue)
    rb_raise(rb_eRuntimeError, "type of command_queue is invalid: CommandQueue is expected");
  command_queue = (cl_command_queue)DATA_PTR(rb_command_queue);

  rb_src_image = argv[1];
  Check_Type(rb_src_image, T_DATA);
  if (CLASS_OF(rb_src_image) != rb_cMem)
    rb_raise(rb_eRuntimeError, "type of src_image is invalid: Mem is expected");
  src_image = ((struct_mem)DATA_PTR(rb_src_image))->mem;

  rb_dst_image = argv[2];
  Check_Type(rb_dst_image, T_DATA);
  if (CLASS_OF(rb_dst_image) != rb_cMem)
    rb_raise(rb_eRuntimeError, "type of dst_image is invalid: Mem is expected");
  dst_image = ((struct_mem)DATA_PTR(rb_dst_image))->mem;


  {
    VALUE _opt_hash = Qnil;

    if (argc > 3) {
      _opt_hash = argv[3];
      Check_Type(_opt_hash, T_HASH);
    }
    if (_opt_hash != Qnil) {
      rb_src_origin = rb_hash_aref(_opt_hash, rb_intern("src_origin"));
    }
    if (_opt_hash != Qnil && rb_src_origin != Qnil) {
      Check_Type(rb_src_origin, T_ARRAY);
      {
        int n;
        src_origin = ALLOC_N(size_t, 3);
        for (n=0; n<3; n++) {
          src_origin[n] = NUM2ULONG(RARRAY_PTR(rb_src_origin)[n]);
        }
  }

    } else {
      src_origin = NULL;
    }
    if (_opt_hash != Qnil) {
      rb_dst_origin = rb_hash_aref(_opt_hash, rb_intern("dst_origin"));
    }
    if (_opt_hash != Qnil && rb_dst_origin != Qnil) {
      Check_Type(rb_dst_origin, T_ARRAY);
      {
        int n;
        dst_origin = ALLOC_N(size_t, 3);
        for (n=0; n<3; n++) {
          dst_origin[n] = NUM2ULONG(RARRAY_PTR(rb_dst_origin)[n]);
        }
  }

    } else {
      dst_origin = NULL;
    }
    if (_opt_hash != Qnil) {
      rb_region = rb_hash_aref(_opt_hash, rb_intern("region"));
    }
    if (_opt_hash != Qnil && rb_region != Qnil) {
      Check_Type(rb_region, T_ARRAY);
      {
        int n;
        region = ALLOC_N(size_t, 3);
        for (n=0; n<3; n++) {
          region[n] = NUM2ULONG(RARRAY_PTR(rb_region)[n]);
        }
  }

    } else {
      region = NULL;
    }
    if (_opt_hash != Qnil) {
      rb_event_wait_list = rb_hash_aref(_opt_hash, rb_intern("event_wait_list"));
    }
    if (_opt_hash != Qnil && rb_event_wait_list != Qnil) {
      Check_Type(rb_event_wait_list, T_ARRAY);
      {
        int n;
        num_events_in_wait_list = RARRAY_LEN(rb_event_wait_list);
        event_wait_list = ALLOC_N(cl_event, num_events_in_wait_list);
        for (n=0; n<num_events_in_wait_list; n++) {
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


  ret = clEnqueueCopyImage(command_queue, src_image, dst_image, (const size_t*) src_origin, (const size_t*) dst_origin, (const size_t*) region, num_events_in_wait_list, (const cl_event*) event_wait_list, &event);
  check_error(ret);

  {
    rb_event = create_event(event);

    result = rb_ary_new3(1, rb_event);
  }

  free(src_origin);
  free(dst_origin);
  free(region);
  free(event_wait_list);

  return result;
}

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
  VALUE rb_kernel = Qnil;
  VALUE rb_device = Qnil;
  VALUE rb_param_name = Qnil;
  VALUE rb_param_value = Qnil;

  VALUE result;

  if (argc > 4)
    rb_raise(rb_eArgError, "wrong number of arguments (%d for %d)", argc, 3);

  if (argc < 3)
    rb_raise(rb_eArgError, "wrong number of arguments (%d for 3)", argc);
  rb_kernel = argv[0];
  Check_Type(rb_kernel, T_DATA);
  if (CLASS_OF(rb_kernel) != rb_cKernel)
    rb_raise(rb_eRuntimeError, "type of kernel is invalid: Kernel is expected");
  kernel = (cl_kernel)DATA_PTR(rb_kernel);

  rb_device = argv[1];
  Check_Type(rb_device, T_DATA);
  if (CLASS_OF(rb_device) != rb_cDevice)
    rb_raise(rb_eRuntimeError, "type of device is invalid: Device is expected");
  device = (cl_device_id)DATA_PTR(rb_device);

  rb_param_name = argv[2];
  param_name = NUM2UINT(rb_param_name);




  ret = clGetKernelWorkGroupInfo(kernel, device, param_name, 0, NULL, &param_value_size_ret);
  param_value_size = param_value_size_ret;
  check_error(ret);
  param_value = (void*) xmalloc(param_value_size);
  ret = clGetKernelWorkGroupInfo(kernel, device, param_name, param_value_size, param_value, NULL);
  check_error(ret);

  {
    rb_param_value = rb_str_new2(param_value);

    result = rb_ary_new3(1, rb_param_value);
  }


  return result;
}

VALUE
rb_clSetKernelArg(int argc, VALUE *argv, VALUE self)
{
  cl_kernel kernel;
  cl_uint arg_index;
  size_t arg_size;
  void *arg_value;
  cl_int ret;
  VALUE rb_kernel = Qnil;
  VALUE rb_arg_index = Qnil;
  VALUE rb_arg_value = Qnil;

  VALUE result;

  if (argc > 4)
    rb_raise(rb_eArgError, "wrong number of arguments (%d for %d)", argc, 3);

  if (argc < 3)
    rb_raise(rb_eArgError, "wrong number of arguments (%d for 3)", argc);
  rb_kernel = argv[0];
  Check_Type(rb_kernel, T_DATA);
  if (CLASS_OF(rb_kernel) != rb_cKernel)
    rb_raise(rb_eRuntimeError, "type of kernel is invalid: Kernel is expected");
  kernel = (cl_kernel)DATA_PTR(rb_kernel);

  rb_arg_index = argv[1];
  arg_index = NUM2UINT(rb_arg_index);

  rb_arg_value = argv[2];
  arg_value = (void*) RSTRING_PTR(rb_arg_value);



  arg_size = RSTRING_LEN(rb_arg_value);

  ret = clSetKernelArg(kernel, arg_index, arg_size, (const void*) arg_value);
  check_error(ret);

  {
    result = Qnil;
  }


  return result;
}

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

  if (argc > 4)
    rb_raise(rb_eArgError, "wrong number of arguments (%d for %d)", argc, 3);

  if (argc < 3)
    rb_raise(rb_eArgError, "wrong number of arguments (%d for 3)", argc);
  rb_context = argv[0];
  Check_Type(rb_context, T_DATA);
  if (CLASS_OF(rb_context) != rb_cContext)
    rb_raise(rb_eRuntimeError, "type of context is invalid: Context is expected");
  context = (cl_context)DATA_PTR(rb_context);

  rb_flags = argv[1];
  flags = NUM2ULONG(rb_flags);

  rb_image_format = argv[2];
  Check_Type(rb_image_format, T_DATA);
  if (CLASS_OF(rb_image_format) != rb_cImageFormat)
    rb_raise(rb_eRuntimeError, "type of image_format is invalid: ImageFormat is expected");
  image_format = (cl_image_format*)DATA_PTR(rb_image_format);


  {
    VALUE _opt_hash = Qnil;

    if (argc > 3) {
      _opt_hash = argv[3];
      Check_Type(_opt_hash, T_HASH);
    }
    if (_opt_hash != Qnil) {
      rb_image_width = rb_hash_aref(_opt_hash, rb_intern("image_width"));
    }
    if (_opt_hash != Qnil && rb_image_width != Qnil) {
      image_width = NUM2ULONG(rb_image_width);

    } else {
      image_width = 0;
    }
    if (_opt_hash != Qnil) {
      rb_image_height = rb_hash_aref(_opt_hash, rb_intern("image_height"));
    }
    if (_opt_hash != Qnil && rb_image_height != Qnil) {
      image_height = NUM2ULONG(rb_image_height);

    } else {
      image_height = 0;
    }
    if (_opt_hash != Qnil) {
      rb_image_depth = rb_hash_aref(_opt_hash, rb_intern("image_depth"));
    }
    if (_opt_hash != Qnil && rb_image_depth != Qnil) {
      image_depth = NUM2ULONG(rb_image_depth);

    } else {
      image_depth = 0;
    }
    if (_opt_hash != Qnil) {
      rb_image_row_pitch = rb_hash_aref(_opt_hash, rb_intern("image_row_pitch"));
    }
    if (_opt_hash != Qnil && rb_image_row_pitch != Qnil) {
      image_row_pitch = NUM2ULONG(rb_image_row_pitch);

    } else {
      image_row_pitch = 0;
    }
    if (_opt_hash != Qnil) {
      rb_image_slice_pitch = rb_hash_aref(_opt_hash, rb_intern("image_slice_pitch"));
    }
    if (_opt_hash != Qnil && rb_image_slice_pitch != Qnil) {
      image_slice_pitch = NUM2ULONG(rb_image_slice_pitch);

    } else {
      image_slice_pitch = 0;
    }
    if (_opt_hash != Qnil) {
      rb_host_ptr = rb_hash_aref(_opt_hash, rb_intern("host_ptr"));
    }
    if (_opt_hash != Qnil && rb_host_ptr != Qnil) {
      host_ptr = (void*) RSTRING_PTR(rb_host_ptr);

    } else {
      host_ptr = NULL;
    }
  }


  ret = clCreateImage3D(context, flags, (const cl_image_format*) image_format, image_width, image_height, image_depth, image_row_pitch, image_slice_pitch, host_ptr, &errcode_ret);
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

    result = rb_ary_new3(1, ret);
  }


  return result;
}

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

  if (argc > 4)
    rb_raise(rb_eArgError, "wrong number of arguments (%d for %d)", argc, 3);

  if (argc < 3)
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
  properties = NUM2ULONG(rb_properties);




  ret = clCreateCommandQueue(context, device, properties, &errcode_ret);
  check_error(errcode_ret);

  {
    VALUE rb_ret;
    rb_ret = create_command_queue(ret);

    result = rb_ary_new3(1, ret);
  }


  return result;
}

void
clEnqueueNativeKernel_user_func(void * args)
{
  if (rb_block_given_p())
    rb_yield(rb_ary_new3(1, rb_str_new2(args)));
}
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
  VALUE rb_command_queue = Qnil;
  VALUE rb_args = Qnil;
  VALUE rb_mem_list = Qnil;
  VALUE rb_args_mem_loc = Qnil;
  VALUE rb_cb_args = Qnil;
  VALUE rb_event_wait_list = Qnil;
  VALUE rb_event = Qnil;

  VALUE result;

  if (argc > 6)
    rb_raise(rb_eArgError, "wrong number of arguments (%d for %d)", argc, 4);

  if (argc < 4)
    rb_raise(rb_eArgError, "wrong number of arguments (%d for 4)", argc);
  rb_command_queue = argv[0];
  Check_Type(rb_command_queue, T_DATA);
  if (CLASS_OF(rb_command_queue) != rb_cCommandQueue)
    rb_raise(rb_eRuntimeError, "type of command_queue is invalid: CommandQueue is expected");
  command_queue = (cl_command_queue)DATA_PTR(rb_command_queue);

  rb_args = argv[1];
  args = (void*) RSTRING_PTR(rb_args);

  rb_mem_list = argv[2];
  Check_Type(rb_mem_list, T_ARRAY);
  {
    int n;
    num_mem_objects = RARRAY_LEN(rb_mem_list);
    mem_list = ALLOC_N(cl_mem, num_mem_objects);
    for (n=0; n<num_mem_objects; n++) {
      Check_Type(RARRAY_PTR(rb_mem_list)[n], T_DATA);
      if (CLASS_OF(RARRAY_PTR(rb_mem_list)[n]) != rb_cMem)
        rb_raise(rb_eRuntimeError, "type of mem_list[n] is invalid: Mem is expected");
      mem_list[n] = ((struct_mem)DATA_PTR(RARRAY_PTR(rb_mem_list)[n]))->mem;
    }
  }

  rb_args_mem_loc = argv[3];
  Check_Type(rb_args_mem_loc, T_ARRAY);
  {
    int n;
    args_mem_loc = ALLOC_N(void*, num_mem_objects);
    for (n=0; n<num_mem_objects; n++) {
      args_mem_loc[n] = (void*) RSTRING_PTR(RARRAY_PTR(rb_args_mem_loc)[n]);
    }
  }


  {
    VALUE _opt_hash = Qnil;

    if (argc > 4) {
      _opt_hash = argv[4];
      Check_Type(_opt_hash, T_HASH);
    }
    if (_opt_hash != Qnil) {
      rb_cb_args = rb_hash_aref(_opt_hash, rb_intern("cb_args"));
    }
    if (_opt_hash != Qnil && rb_cb_args != Qnil) {
      cb_args = NUM2ULONG(rb_cb_args);

    } else {
      cb_args = 0;
    }
    if (_opt_hash != Qnil) {
      rb_event_wait_list = rb_hash_aref(_opt_hash, rb_intern("event_wait_list"));
    }
    if (_opt_hash != Qnil && rb_event_wait_list != Qnil) {
      Check_Type(rb_event_wait_list, T_ARRAY);
      {
        int n;
        num_events_in_wait_list = RARRAY_LEN(rb_event_wait_list);
        event_wait_list = ALLOC_N(cl_event, num_events_in_wait_list);
        for (n=0; n<num_events_in_wait_list; n++) {
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


  ret = clEnqueueNativeKernel(command_queue, clEnqueueNativeKernel_user_func, args, cb_args, num_mem_objects, (const cl_mem*) mem_list, (const void**) args_mem_loc, num_events_in_wait_list, (const cl_event*) event_wait_list, &event);
  check_error(ret);

  {
    rb_event = create_event(event);

    result = rb_ary_new3(1, rb_event);
  }

  free(mem_list);
  free(args_mem_loc);
  free(event_wait_list);

  return result;
}

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
  VALUE rb_command_queue = Qnil;
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

  if (argc > 5)
    rb_raise(rb_eArgError, "wrong number of arguments (%d for %d)", argc, 4);

  if (argc < 4)
    rb_raise(rb_eArgError, "wrong number of arguments (%d for 4)", argc);
  rb_command_queue = argv[0];
  Check_Type(rb_command_queue, T_DATA);
  if (CLASS_OF(rb_command_queue) != rb_cCommandQueue)
    rb_raise(rb_eRuntimeError, "type of command_queue is invalid: CommandQueue is expected");
  command_queue = (cl_command_queue)DATA_PTR(rb_command_queue);

  rb_image = argv[1];
  Check_Type(rb_image, T_DATA);
  if (CLASS_OF(rb_image) != rb_cMem)
    rb_raise(rb_eRuntimeError, "type of image is invalid: Mem is expected");
  image = ((struct_mem)DATA_PTR(rb_image))->mem;

  rb_blocking_map = argv[2];
  blocking_map = NUM2UINT(rb_blocking_map);

  rb_map_flags = argv[3];
  map_flags = NUM2ULONG(rb_map_flags);


  {
    VALUE _opt_hash = Qnil;

    if (argc > 4) {
      _opt_hash = argv[4];
      Check_Type(_opt_hash, T_HASH);
    }
    if (_opt_hash != Qnil) {
      rb_origin = rb_hash_aref(_opt_hash, rb_intern("origin"));
    }
    if (_opt_hash != Qnil && rb_origin != Qnil) {
      Check_Type(rb_origin, T_ARRAY);
      {
        int n;
        origin = ALLOC_N(size_t, 3);
        for (n=0; n<3; n++) {
          origin[n] = NUM2ULONG(RARRAY_PTR(rb_origin)[n]);
        }
  }

    } else {
      origin = NULL;
    }
    if (_opt_hash != Qnil) {
      rb_region = rb_hash_aref(_opt_hash, rb_intern("region"));
    }
    if (_opt_hash != Qnil && rb_region != Qnil) {
      Check_Type(rb_region, T_ARRAY);
      {
        int n;
        region = ALLOC_N(size_t, 3);
        for (n=0; n<3; n++) {
          region[n] = NUM2ULONG(RARRAY_PTR(rb_region)[n]);
        }
  }

    } else {
      region = NULL;
    }
    if (_opt_hash != Qnil) {
      rb_event_wait_list = rb_hash_aref(_opt_hash, rb_intern("event_wait_list"));
    }
    if (_opt_hash != Qnil && rb_event_wait_list != Qnil) {
      Check_Type(rb_event_wait_list, T_ARRAY);
      {
        int n;
        num_events_in_wait_list = RARRAY_LEN(rb_event_wait_list);
        event_wait_list = ALLOC_N(cl_event, num_events_in_wait_list);
        for (n=0; n<num_events_in_wait_list; n++) {
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


  ret = clEnqueueMapImage(command_queue, image, blocking_map, map_flags, (const size_t*) origin, (const size_t*) region, &image_row_pitch, &image_slice_pitch, num_events_in_wait_list, (const cl_event*) event_wait_list, &event, &errcode_ret);
  check_error(errcode_ret);

  {
    VALUE rb_ret;
    rb_ret = rb_str_new2(ret);

    rb_image_row_pitch = ULONG2NUM(image_row_pitch);

    rb_image_slice_pitch = ULONG2NUM(image_slice_pitch);

    rb_event = create_event(event);

    result = rb_ary_new3(4, ret, rb_image_row_pitch, rb_image_slice_pitch, rb_event);
  }

  free(origin);
  free(region);
  free(event_wait_list);

  return result;
}

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

  if (argc > 4)
    rb_raise(rb_eArgError, "wrong number of arguments (%d for %d)", argc, 3);

  if (argc < 3)
    rb_raise(rb_eArgError, "wrong number of arguments (%d for 3)", argc);
  rb_context = argv[0];
  Check_Type(rb_context, T_DATA);
  if (CLASS_OF(rb_context) != rb_cContext)
    rb_raise(rb_eRuntimeError, "type of context is invalid: Context is expected");
  context = (cl_context)DATA_PTR(rb_context);

  rb_flags = argv[1];
  flags = NUM2ULONG(rb_flags);

  rb_image_format = argv[2];
  Check_Type(rb_image_format, T_DATA);
  if (CLASS_OF(rb_image_format) != rb_cImageFormat)
    rb_raise(rb_eRuntimeError, "type of image_format is invalid: ImageFormat is expected");
  image_format = (cl_image_format*)DATA_PTR(rb_image_format);


  {
    VALUE _opt_hash = Qnil;

    if (argc > 3) {
      _opt_hash = argv[3];
      Check_Type(_opt_hash, T_HASH);
    }
    if (_opt_hash != Qnil) {
      rb_image_width = rb_hash_aref(_opt_hash, rb_intern("image_width"));
    }
    if (_opt_hash != Qnil && rb_image_width != Qnil) {
      image_width = NUM2ULONG(rb_image_width);

    } else {
      image_width = 0;
    }
    if (_opt_hash != Qnil) {
      rb_image_height = rb_hash_aref(_opt_hash, rb_intern("image_height"));
    }
    if (_opt_hash != Qnil && rb_image_height != Qnil) {
      image_height = NUM2ULONG(rb_image_height);

    } else {
      image_height = 0;
    }
    if (_opt_hash != Qnil) {
      rb_image_row_pitch = rb_hash_aref(_opt_hash, rb_intern("image_row_pitch"));
    }
    if (_opt_hash != Qnil && rb_image_row_pitch != Qnil) {
      image_row_pitch = NUM2ULONG(rb_image_row_pitch);

    } else {
      image_row_pitch = 0;
    }
    if (_opt_hash != Qnil) {
      rb_host_ptr = rb_hash_aref(_opt_hash, rb_intern("host_ptr"));
    }
    if (_opt_hash != Qnil && rb_host_ptr != Qnil) {
      host_ptr = (void*) RSTRING_PTR(rb_host_ptr);

    } else {
      host_ptr = NULL;
    }
  }


  ret = clCreateImage2D(context, flags, (const cl_image_format*) image_format, image_width, image_height, image_row_pitch, host_ptr, &errcode_ret);
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

    result = rb_ary_new3(1, ret);
  }


  return result;
}

VALUE
rb_clGetCommandQueueInfo(int argc, VALUE *argv, VALUE self)
{
  cl_command_queue command_queue;
  cl_command_queue_info param_name;
  size_t param_value_size;
  void *param_value;
  size_t param_value_size_ret;
  cl_int ret;
  VALUE rb_command_queue = Qnil;
  VALUE rb_param_name = Qnil;
  VALUE rb_param_value = Qnil;

  VALUE result;

  if (argc > 3)
    rb_raise(rb_eArgError, "wrong number of arguments (%d for %d)", argc, 2);

  if (argc < 2)
    rb_raise(rb_eArgError, "wrong number of arguments (%d for 2)", argc);
  rb_command_queue = argv[0];
  Check_Type(rb_command_queue, T_DATA);
  if (CLASS_OF(rb_command_queue) != rb_cCommandQueue)
    rb_raise(rb_eRuntimeError, "type of command_queue is invalid: CommandQueue is expected");
  command_queue = (cl_command_queue)DATA_PTR(rb_command_queue);

  rb_param_name = argv[1];
  param_name = NUM2UINT(rb_param_name);




  ret = clGetCommandQueueInfo(command_queue, param_name, 0, NULL, &param_value_size_ret);
  param_value_size = param_value_size_ret;
  check_error(ret);
  param_value = (void*) xmalloc(param_value_size);
  ret = clGetCommandQueueInfo(command_queue, param_name, param_value_size, param_value, NULL);
  check_error(ret);

  {
    rb_param_value = rb_str_new2(param_value);

    result = rb_ary_new3(1, rb_param_value);
  }


  return result;
}

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
  VALUE rb_command_queue = Qnil;
  VALUE rb_src_image = Qnil;
  VALUE rb_dst_buffer = Qnil;
  VALUE rb_src_origin = Qnil;
  VALUE rb_region = Qnil;
  VALUE rb_dst_offset = Qnil;
  VALUE rb_event_wait_list = Qnil;
  VALUE rb_event = Qnil;

  VALUE result;

  if (argc > 4)
    rb_raise(rb_eArgError, "wrong number of arguments (%d for %d)", argc, 3);

  if (argc < 3)
    rb_raise(rb_eArgError, "wrong number of arguments (%d for 3)", argc);
  rb_command_queue = argv[0];
  Check_Type(rb_command_queue, T_DATA);
  if (CLASS_OF(rb_command_queue) != rb_cCommandQueue)
    rb_raise(rb_eRuntimeError, "type of command_queue is invalid: CommandQueue is expected");
  command_queue = (cl_command_queue)DATA_PTR(rb_command_queue);

  rb_src_image = argv[1];
  Check_Type(rb_src_image, T_DATA);
  if (CLASS_OF(rb_src_image) != rb_cMem)
    rb_raise(rb_eRuntimeError, "type of src_image is invalid: Mem is expected");
  src_image = ((struct_mem)DATA_PTR(rb_src_image))->mem;

  rb_dst_buffer = argv[2];
  Check_Type(rb_dst_buffer, T_DATA);
  if (CLASS_OF(rb_dst_buffer) != rb_cMem)
    rb_raise(rb_eRuntimeError, "type of dst_buffer is invalid: Mem is expected");
  dst_buffer = ((struct_mem)DATA_PTR(rb_dst_buffer))->mem;


  {
    VALUE _opt_hash = Qnil;

    if (argc > 3) {
      _opt_hash = argv[3];
      Check_Type(_opt_hash, T_HASH);
    }
    if (_opt_hash != Qnil) {
      rb_src_origin = rb_hash_aref(_opt_hash, rb_intern("src_origin"));
    }
    if (_opt_hash != Qnil && rb_src_origin != Qnil) {
      Check_Type(rb_src_origin, T_ARRAY);
      {
        int n;
        src_origin = ALLOC_N(size_t, 3);
        for (n=0; n<3; n++) {
          src_origin[n] = NUM2ULONG(RARRAY_PTR(rb_src_origin)[n]);
        }
  }

    } else {
      src_origin = NULL;
    }
    if (_opt_hash != Qnil) {
      rb_region = rb_hash_aref(_opt_hash, rb_intern("region"));
    }
    if (_opt_hash != Qnil && rb_region != Qnil) {
      Check_Type(rb_region, T_ARRAY);
      {
        int n;
        region = ALLOC_N(size_t, 3);
        for (n=0; n<3; n++) {
          region[n] = NUM2ULONG(RARRAY_PTR(rb_region)[n]);
        }
  }

    } else {
      region = NULL;
    }
    if (_opt_hash != Qnil) {
      rb_dst_offset = rb_hash_aref(_opt_hash, rb_intern("dst_offset"));
    }
    if (_opt_hash != Qnil && rb_dst_offset != Qnil) {
      dst_offset = NUM2ULONG(rb_dst_offset);

    } else {
      dst_offset = 0;
    }
    if (_opt_hash != Qnil) {
      rb_event_wait_list = rb_hash_aref(_opt_hash, rb_intern("event_wait_list"));
    }
    if (_opt_hash != Qnil && rb_event_wait_list != Qnil) {
      Check_Type(rb_event_wait_list, T_ARRAY);
      {
        int n;
        num_events_in_wait_list = RARRAY_LEN(rb_event_wait_list);
        event_wait_list = ALLOC_N(cl_event, num_events_in_wait_list);
        for (n=0; n<num_events_in_wait_list; n++) {
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


  ret = clEnqueueCopyImageToBuffer(command_queue, src_image, dst_buffer, (const size_t*) src_origin, (const size_t*) region, dst_offset, num_events_in_wait_list, (const cl_event*) event_wait_list, &event);
  check_error(ret);

  {
    rb_event = create_event(event);

    result = rb_ary_new3(1, rb_event);
  }

  free(src_origin);
  free(region);
  free(event_wait_list);

  return result;
}

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

  if (argc > 3)
    rb_raise(rb_eArgError, "wrong number of arguments (%d for %d)", argc, 2);

  if (argc < 2)
    rb_raise(rb_eArgError, "wrong number of arguments (%d for 2)", argc);
  rb_program = argv[0];
  Check_Type(rb_program, T_DATA);
  if (CLASS_OF(rb_program) != rb_cProgram)
    rb_raise(rb_eRuntimeError, "type of program is invalid: Program is expected");
  program = (cl_program)DATA_PTR(rb_program);

  rb_kernel_name = argv[1];
  kernel_name = (char*) RSTRING_PTR(rb_kernel_name);




  ret = clCreateKernel(program, (const char*) kernel_name, &errcode_ret);
  check_error(errcode_ret);

  {
    VALUE rb_ret;
    rb_ret = create_kernel(ret);

    result = rb_ary_new3(1, ret);
  }


  return result;
}

void
clBuildProgram_pfn_notify(cl_program program, void * user_data)
{
  if (rb_block_given_p())
    rb_yield(rb_ary_new3(2, create_program(program), (VALUE) user_data));
}
VALUE
rb_clBuildProgram(int argc, VALUE *argv, VALUE self)
{
  cl_program program;
  cl_uint num_devices;
  cl_device_id *device_list;
  char *options;
  void *user_data;
  cl_int ret;
  VALUE rb_program = Qnil;
  VALUE rb_device_list = Qnil;
  VALUE rb_options = Qnil;
  VALUE rb_user_data = Qnil;

  VALUE result;

  if (argc > 6)
    rb_raise(rb_eArgError, "wrong number of arguments (%d for %d)", argc, 4);

  if (argc < 4)
    rb_raise(rb_eArgError, "wrong number of arguments (%d for 4)", argc);
  rb_program = argv[0];
  Check_Type(rb_program, T_DATA);
  if (CLASS_OF(rb_program) != rb_cProgram)
    rb_raise(rb_eRuntimeError, "type of program is invalid: Program is expected");
  program = (cl_program)DATA_PTR(rb_program);

  rb_device_list = argv[1];
  Check_Type(rb_device_list, T_ARRAY);
  {
    int n;
    num_devices = RARRAY_LEN(rb_device_list);
    device_list = ALLOC_N(cl_device_id, num_devices);
    for (n=0; n<num_devices; n++) {
      Check_Type(RARRAY_PTR(rb_device_list)[n], T_DATA);
      if (CLASS_OF(RARRAY_PTR(rb_device_list)[n]) != rb_cDevice)
        rb_raise(rb_eRuntimeError, "type of device_list[n] is invalid: Device is expected");
      device_list[n] = (cl_device_id)DATA_PTR(RARRAY_PTR(rb_device_list)[n]);
    }
  }

  rb_options = argv[2];
  options = (char*) RSTRING_PTR(rb_options);

  rb_user_data = argv[3];
  user_data = (void*) RSTRING_PTR(rb_user_data);




  ret = clBuildProgram(program, num_devices, (const cl_device_id*) device_list, (const char*) options, clBuildProgram_pfn_notify, user_data);
  check_error(ret);

  {
    result = Qnil;
  }

  free(device_list);

  return result;
}

VALUE
rb_clGetSamplerInfo(int argc, VALUE *argv, VALUE self)
{
  cl_sampler sampler;
  cl_sampler_info param_name;
  size_t param_value_size;
  void *param_value;
  size_t param_value_size_ret;
  cl_int ret;
  VALUE rb_sampler = Qnil;
  VALUE rb_param_name = Qnil;
  VALUE rb_param_value = Qnil;

  VALUE result;

  if (argc > 3)
    rb_raise(rb_eArgError, "wrong number of arguments (%d for %d)", argc, 2);

  if (argc < 2)
    rb_raise(rb_eArgError, "wrong number of arguments (%d for 2)", argc);
  rb_sampler = argv[0];
  Check_Type(rb_sampler, T_DATA);
  if (CLASS_OF(rb_sampler) != rb_cSampler)
    rb_raise(rb_eRuntimeError, "type of sampler is invalid: Sampler is expected");
  sampler = (cl_sampler)DATA_PTR(rb_sampler);

  rb_param_name = argv[1];
  param_name = NUM2UINT(rb_param_name);




  ret = clGetSamplerInfo(sampler, param_name, 0, NULL, &param_value_size_ret);
  param_value_size = param_value_size_ret;
  check_error(ret);
  param_value = (void*) xmalloc(param_value_size);
  ret = clGetSamplerInfo(sampler, param_name, param_value_size, param_value, NULL);
  check_error(ret);

  {
    rb_param_value = rb_str_new2(param_value);

    result = rb_ary_new3(1, rb_param_value);
  }


  return result;
}

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
  VALUE rb_context = Qnil;
  VALUE rb_flags = Qnil;
  VALUE rb_image_type = Qnil;
  VALUE rb_image_formats = Qnil;

  VALUE result;

  if (argc > 4)
    rb_raise(rb_eArgError, "wrong number of arguments (%d for %d)", argc, 3);

  if (argc < 3)
    rb_raise(rb_eArgError, "wrong number of arguments (%d for 3)", argc);
  rb_context = argv[0];
  Check_Type(rb_context, T_DATA);
  if (CLASS_OF(rb_context) != rb_cContext)
    rb_raise(rb_eRuntimeError, "type of context is invalid: Context is expected");
  context = (cl_context)DATA_PTR(rb_context);

  rb_flags = argv[1];
  flags = NUM2ULONG(rb_flags);

  rb_image_type = argv[2];
  image_type = NUM2UINT(rb_image_type);




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
      for (ii=0; ii<num_entries; ii++)
        ary[ii] = create_image_format(&image_formats[ii]);
      rb_image_formats = rb_ary_new4(num_entries, ary);
    }

    result = rb_ary_new3(1, rb_image_formats);
  }


  return result;
}

VALUE
rb_clSetCommandQueueProperty(int argc, VALUE *argv, VALUE self)
{
  cl_command_queue command_queue;
  cl_command_queue_properties properties;
  cl_bool enable;
  cl_command_queue_properties old_properties;
  cl_int ret;
  VALUE rb_command_queue = Qnil;
  VALUE rb_properties = Qnil;
  VALUE rb_enable = Qnil;
  VALUE rb_old_properties = Qnil;

  VALUE result;

  if (argc > 4)
    rb_raise(rb_eArgError, "wrong number of arguments (%d for %d)", argc, 3);

  if (argc < 3)
    rb_raise(rb_eArgError, "wrong number of arguments (%d for 3)", argc);
  rb_command_queue = argv[0];
  Check_Type(rb_command_queue, T_DATA);
  if (CLASS_OF(rb_command_queue) != rb_cCommandQueue)
    rb_raise(rb_eRuntimeError, "type of command_queue is invalid: CommandQueue is expected");
  command_queue = (cl_command_queue)DATA_PTR(rb_command_queue);

  rb_properties = argv[1];
  properties = NUM2ULONG(rb_properties);

  rb_enable = argv[2];
  enable = NUM2UINT(rb_enable);




  ret = clSetCommandQueueProperty(command_queue, properties, enable, &old_properties);
  check_error(ret);

  {
    rb_old_properties = ULONG2NUM(old_properties);

    result = rb_ary_new3(1, rb_old_properties);
  }


  return result;
}

VALUE
rb_clGetPlatformIDs(int argc, VALUE *argv, VALUE self)
{
  cl_uint num_entries;
  cl_platform_id *platforms;
  cl_uint num_platforms;
  cl_int ret;
  VALUE rb_platforms = Qnil;

  VALUE result;

  if (argc > 1)
    rb_raise(rb_eArgError, "wrong number of arguments (%d for %d)", argc, 0);

  if (argc < 0)
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
      for (ii=0; ii<num_entries; ii++)
        ary[ii] = create_platform(platforms[ii]);
      rb_platforms = rb_ary_new4(num_entries, ary);
    }

    result = rb_ary_new3(1, rb_platforms);
  }


  return result;
}

VALUE
rb_clEnqueueMarker(int argc, VALUE *argv, VALUE self)
{
  cl_command_queue command_queue;
  cl_event event;
  cl_int ret;
  VALUE rb_command_queue = Qnil;
  VALUE rb_event = Qnil;

  VALUE result;

  if (argc > 2)
    rb_raise(rb_eArgError, "wrong number of arguments (%d for %d)", argc, 1);

  if (argc < 1)
    rb_raise(rb_eArgError, "wrong number of arguments (%d for 1)", argc);
  rb_command_queue = argv[0];
  Check_Type(rb_command_queue, T_DATA);
  if (CLASS_OF(rb_command_queue) != rb_cCommandQueue)
    rb_raise(rb_eRuntimeError, "type of command_queue is invalid: CommandQueue is expected");
  command_queue = (cl_command_queue)DATA_PTR(rb_command_queue);




  ret = clEnqueueMarker(command_queue, &event);
  check_error(ret);

  {
    rb_event = create_event(event);

    result = rb_ary_new3(1, rb_event);
  }


  return result;
}

VALUE
rb_clCreateKernelsInProgram(int argc, VALUE *argv, VALUE self)
{
  cl_program program;
  cl_uint num_kernels;
  cl_kernel *kernels;
  cl_uint num_kernels_ret;
  cl_int ret;
  VALUE rb_program = Qnil;
  VALUE rb_kernels = Qnil;

  VALUE result;

  if (argc > 2)
    rb_raise(rb_eArgError, "wrong number of arguments (%d for %d)", argc, 1);

  if (argc < 1)
    rb_raise(rb_eArgError, "wrong number of arguments (%d for 1)", argc);
  rb_program = argv[0];
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
      for (ii=0; ii<num_kernels; ii++)
        ary[ii] = create_kernel(kernels[ii]);
      rb_kernels = rb_ary_new4(num_kernels, ary);
    }

    result = rb_ary_new3(1, rb_kernels);
  }


  return result;
}

void
clCreateContext_pfn_notify(const char * errinfo, const void * private_info, size_t cb, void * user_data)
{
  if (rb_block_given_p())
    rb_yield(rb_ary_new3(3, rb_str_new2(errinfo), rb_str_new(private_info, cb), (VALUE) user_data));
}
VALUE
rb_clCreateContext(int argc, VALUE *argv, VALUE self)
{
  cl_context_properties *properties;
  cl_uint num_devices;
  cl_device_id *devices;
  void *user_data;
  cl_int errcode_ret;
  cl_context ret;
  VALUE rb_devices = Qnil;
  VALUE rb_user_data = Qnil;

  VALUE result;

  if (argc > 4)
    rb_raise(rb_eArgError, "wrong number of arguments (%d for %d)", argc, 2);

  properties = NULL;
  if (argc < 2)
    rb_raise(rb_eArgError, "wrong number of arguments (%d for 2)", argc);
  rb_devices = argv[0];
  Check_Type(rb_devices, T_ARRAY);
  {
    int n;
    num_devices = RARRAY_LEN(rb_devices);
    devices = ALLOC_N(cl_device_id, num_devices);
    for (n=0; n<num_devices; n++) {
      Check_Type(RARRAY_PTR(rb_devices)[n], T_DATA);
      if (CLASS_OF(RARRAY_PTR(rb_devices)[n]) != rb_cDevice)
        rb_raise(rb_eRuntimeError, "type of devices[n] is invalid: Device is expected");
      devices[n] = (cl_device_id)DATA_PTR(RARRAY_PTR(rb_devices)[n]);
    }
  }

  rb_user_data = argv[1];
  user_data = (void*) RSTRING_PTR(rb_user_data);




  ret = clCreateContext(properties, num_devices, (const cl_device_id*) devices, clCreateContext_pfn_notify, user_data, &errcode_ret);
  check_error(errcode_ret);

  {
    VALUE rb_ret;
    rb_ret = create_context(ret);

    result = rb_ary_new3(1, ret);
  }

  free(devices);

  return result;
}

VALUE
rb_clEnqueueTask(int argc, VALUE *argv, VALUE self)
{
  cl_command_queue command_queue;
  cl_kernel kernel;
  cl_uint num_events_in_wait_list;
  cl_event *event_wait_list;
  cl_event event;
  cl_int ret;
  VALUE rb_command_queue = Qnil;
  VALUE rb_kernel = Qnil;
  VALUE rb_event_wait_list = Qnil;
  VALUE rb_event = Qnil;

  VALUE result;

  if (argc > 3)
    rb_raise(rb_eArgError, "wrong number of arguments (%d for %d)", argc, 2);

  if (argc < 2)
    rb_raise(rb_eArgError, "wrong number of arguments (%d for 2)", argc);
  rb_command_queue = argv[0];
  Check_Type(rb_command_queue, T_DATA);
  if (CLASS_OF(rb_command_queue) != rb_cCommandQueue)
    rb_raise(rb_eRuntimeError, "type of command_queue is invalid: CommandQueue is expected");
  command_queue = (cl_command_queue)DATA_PTR(rb_command_queue);

  rb_kernel = argv[1];
  Check_Type(rb_kernel, T_DATA);
  if (CLASS_OF(rb_kernel) != rb_cKernel)
    rb_raise(rb_eRuntimeError, "type of kernel is invalid: Kernel is expected");
  kernel = (cl_kernel)DATA_PTR(rb_kernel);


  {
    VALUE _opt_hash = Qnil;

    if (argc > 2) {
      _opt_hash = argv[2];
      Check_Type(_opt_hash, T_HASH);
    }
    if (_opt_hash != Qnil) {
      rb_event_wait_list = rb_hash_aref(_opt_hash, rb_intern("event_wait_list"));
    }
    if (_opt_hash != Qnil && rb_event_wait_list != Qnil) {
      Check_Type(rb_event_wait_list, T_ARRAY);
      {
        int n;
        num_events_in_wait_list = RARRAY_LEN(rb_event_wait_list);
        event_wait_list = ALLOC_N(cl_event, num_events_in_wait_list);
        for (n=0; n<num_events_in_wait_list; n++) {
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


  ret = clEnqueueTask(command_queue, kernel, num_events_in_wait_list, (const cl_event*) event_wait_list, &event);
  check_error(ret);

  {
    rb_event = create_event(event);

    result = rb_ary_new3(1, rb_event);
  }

  free(event_wait_list);

  return result;
}

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
  VALUE rb_command_queue = Qnil;
  VALUE rb_buffer = Qnil;
  VALUE rb_blocking_write = Qnil;
  VALUE rb_ptr = Qnil;
  VALUE rb_offset = Qnil;
  VALUE rb_cb = Qnil;
  VALUE rb_event_wait_list = Qnil;
  VALUE rb_event = Qnil;

  VALUE result;

  if (argc > 5)
    rb_raise(rb_eArgError, "wrong number of arguments (%d for %d)", argc, 4);

  if (argc < 4)
    rb_raise(rb_eArgError, "wrong number of arguments (%d for 4)", argc);
  rb_command_queue = argv[0];
  Check_Type(rb_command_queue, T_DATA);
  if (CLASS_OF(rb_command_queue) != rb_cCommandQueue)
    rb_raise(rb_eRuntimeError, "type of command_queue is invalid: CommandQueue is expected");
  command_queue = (cl_command_queue)DATA_PTR(rb_command_queue);

  rb_buffer = argv[1];
  Check_Type(rb_buffer, T_DATA);
  if (CLASS_OF(rb_buffer) != rb_cMem)
    rb_raise(rb_eRuntimeError, "type of buffer is invalid: Mem is expected");
  buffer = ((struct_mem)DATA_PTR(rb_buffer))->mem;

  rb_blocking_write = argv[2];
  blocking_write = NUM2UINT(rb_blocking_write);

  rb_ptr = argv[3];
  ptr = (void*) RSTRING_PTR(rb_ptr);


  {
    VALUE _opt_hash = Qnil;

    if (argc > 4) {
      _opt_hash = argv[4];
      Check_Type(_opt_hash, T_HASH);
    }
    if (_opt_hash != Qnil) {
      rb_offset = rb_hash_aref(_opt_hash, rb_intern("offset"));
    }
    if (_opt_hash != Qnil && rb_offset != Qnil) {
      offset = NUM2ULONG(rb_offset);

    } else {
      offset = 0;
    }
    if (_opt_hash != Qnil) {
      rb_cb = rb_hash_aref(_opt_hash, rb_intern("cb"));
    }
    if (_opt_hash != Qnil && rb_cb != Qnil) {
      cb = NUM2ULONG(rb_cb);

    } else {
      cb = 0;
    }
    if (_opt_hash != Qnil) {
      rb_event_wait_list = rb_hash_aref(_opt_hash, rb_intern("event_wait_list"));
    }
    if (_opt_hash != Qnil && rb_event_wait_list != Qnil) {
      Check_Type(rb_event_wait_list, T_ARRAY);
      {
        int n;
        num_events_in_wait_list = RARRAY_LEN(rb_event_wait_list);
        event_wait_list = ALLOC_N(cl_event, num_events_in_wait_list);
        for (n=0; n<num_events_in_wait_list; n++) {
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


  ret = clEnqueueWriteBuffer(command_queue, buffer, blocking_write, offset, cb, (const void*) ptr, num_events_in_wait_list, (const cl_event*) event_wait_list, &event);
  check_error(ret);

  {
    rb_event = create_event(event);

    result = rb_ary_new3(1, rb_event);
  }

  free(event_wait_list);

  return result;
}

VALUE
rb_clWaitForEvents(int argc, VALUE *argv, VALUE self)
{
  cl_uint num_events;
  cl_event *event_list;
  cl_int ret;
  VALUE rb_event_list = Qnil;

  VALUE result;

  if (argc > 2)
    rb_raise(rb_eArgError, "wrong number of arguments (%d for %d)", argc, 1);

  if (argc < 1)
    rb_raise(rb_eArgError, "wrong number of arguments (%d for 1)", argc);
  rb_event_list = argv[0];
  Check_Type(rb_event_list, T_ARRAY);
  {
    int n;
    num_events = RARRAY_LEN(rb_event_list);
    event_list = ALLOC_N(cl_event, num_events);
    for (n=0; n<num_events; n++) {
      Check_Type(RARRAY_PTR(rb_event_list)[n], T_DATA);
      if (CLASS_OF(RARRAY_PTR(rb_event_list)[n]) != rb_cEvent)
        rb_raise(rb_eRuntimeError, "type of event_list[n] is invalid: Event is expected");
      event_list[n] = (cl_event)DATA_PTR(RARRAY_PTR(rb_event_list)[n]);
    }
  }




  ret = clWaitForEvents(num_events, (const cl_event*) event_list);
  check_error(ret);

  {
    result = Qnil;
  }

  free(event_list);

  return result;
}

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

  if (argc > 3)
    rb_raise(rb_eArgError, "wrong number of arguments (%d for %d)", argc, 2);

  if (argc < 2)
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
    strings = ALLOC_N(char*, count);
    lengths = ALLOC_N(size_t, count);
    for (n=0; n<count; n++) {
      strings[n] = (char*) RSTRING_PTR(RARRAY_PTR(rb_strings)[n]);
      lengths[n] = 0;
    }
  }




  ret = clCreateProgramWithSource(context, count, (const char**) strings, (const size_t*) lengths, &errcode_ret);
  check_error(errcode_ret);

  {
    VALUE rb_ret;
    rb_ret = create_program(ret);

    result = rb_ary_new3(1, ret);
  }

  free(strings);
  free(lengths);

  return result;
}

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
  VALUE rb_command_queue = Qnil;
  VALUE rb_kernel = Qnil;
  VALUE rb_global_work_size = Qnil;
  VALUE rb_local_work_size = Qnil;
  VALUE rb_event_wait_list = Qnil;
  VALUE rb_event = Qnil;

  VALUE result;

  if (argc > 5)
    rb_raise(rb_eArgError, "wrong number of arguments (%d for %d)", argc, 4);

  global_work_offset = NULL;
  if (argc < 4)
    rb_raise(rb_eArgError, "wrong number of arguments (%d for 4)", argc);
  rb_command_queue = argv[0];
  Check_Type(rb_command_queue, T_DATA);
  if (CLASS_OF(rb_command_queue) != rb_cCommandQueue)
    rb_raise(rb_eRuntimeError, "type of command_queue is invalid: CommandQueue is expected");
  command_queue = (cl_command_queue)DATA_PTR(rb_command_queue);

  rb_kernel = argv[1];
  Check_Type(rb_kernel, T_DATA);
  if (CLASS_OF(rb_kernel) != rb_cKernel)
    rb_raise(rb_eRuntimeError, "type of kernel is invalid: Kernel is expected");
  kernel = (cl_kernel)DATA_PTR(rb_kernel);

  rb_global_work_size = argv[2];
  Check_Type(rb_global_work_size, T_ARRAY);
  work_dim = RARRAY_LEN(rb_global_work_size);
  {
    int n;
    global_work_size = ALLOC_N(size_t, work_dim);
    for (n=0; n<work_dim; n++) {
      global_work_size[n] = NUM2ULONG(RARRAY_PTR(rb_global_work_size)[n]);
    }
  }

  rb_local_work_size = argv[3];
  Check_Type(rb_local_work_size, T_ARRAY);
  {
    int n;
    local_work_size = ALLOC_N(size_t, work_dim);
    for (n=0; n<work_dim; n++) {
      local_work_size[n] = NUM2ULONG(RARRAY_PTR(rb_local_work_size)[n]);
    }
  }


  {
    VALUE _opt_hash = Qnil;

    if (argc > 4) {
      _opt_hash = argv[4];
      Check_Type(_opt_hash, T_HASH);
    }
    if (_opt_hash != Qnil) {
      rb_event_wait_list = rb_hash_aref(_opt_hash, rb_intern("event_wait_list"));
    }
    if (_opt_hash != Qnil && rb_event_wait_list != Qnil) {
      Check_Type(rb_event_wait_list, T_ARRAY);
      {
        int n;
        num_events_in_wait_list = RARRAY_LEN(rb_event_wait_list);
        event_wait_list = ALLOC_N(cl_event, num_events_in_wait_list);
        for (n=0; n<num_events_in_wait_list; n++) {
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


  ret = clEnqueueNDRangeKernel(command_queue, kernel, work_dim, (const size_t*) global_work_offset, (const size_t*) global_work_size, (const size_t*) local_work_size, num_events_in_wait_list, (const cl_event*) event_wait_list, &event);
  check_error(ret);

  {
    rb_event = create_event(event);

    result = rb_ary_new3(1, rb_event);
  }

  free(global_work_size);
  free(local_work_size);
  free(event_wait_list);

  return result;
}

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
  VALUE rb_command_queue = Qnil;
  VALUE rb_src_buffer = Qnil;
  VALUE rb_dst_image = Qnil;
  VALUE rb_src_offset = Qnil;
  VALUE rb_dst_origin = Qnil;
  VALUE rb_region = Qnil;
  VALUE rb_event_wait_list = Qnil;
  VALUE rb_event = Qnil;

  VALUE result;

  if (argc > 4)
    rb_raise(rb_eArgError, "wrong number of arguments (%d for %d)", argc, 3);

  if (argc < 3)
    rb_raise(rb_eArgError, "wrong number of arguments (%d for 3)", argc);
  rb_command_queue = argv[0];
  Check_Type(rb_command_queue, T_DATA);
  if (CLASS_OF(rb_command_queue) != rb_cCommandQueue)
    rb_raise(rb_eRuntimeError, "type of command_queue is invalid: CommandQueue is expected");
  command_queue = (cl_command_queue)DATA_PTR(rb_command_queue);

  rb_src_buffer = argv[1];
  Check_Type(rb_src_buffer, T_DATA);
  if (CLASS_OF(rb_src_buffer) != rb_cMem)
    rb_raise(rb_eRuntimeError, "type of src_buffer is invalid: Mem is expected");
  src_buffer = ((struct_mem)DATA_PTR(rb_src_buffer))->mem;

  rb_dst_image = argv[2];
  Check_Type(rb_dst_image, T_DATA);
  if (CLASS_OF(rb_dst_image) != rb_cMem)
    rb_raise(rb_eRuntimeError, "type of dst_image is invalid: Mem is expected");
  dst_image = ((struct_mem)DATA_PTR(rb_dst_image))->mem;


  {
    VALUE _opt_hash = Qnil;

    if (argc > 3) {
      _opt_hash = argv[3];
      Check_Type(_opt_hash, T_HASH);
    }
    if (_opt_hash != Qnil) {
      rb_src_offset = rb_hash_aref(_opt_hash, rb_intern("src_offset"));
    }
    if (_opt_hash != Qnil && rb_src_offset != Qnil) {
      src_offset = NUM2ULONG(rb_src_offset);

    } else {
      src_offset = 0;
    }
    if (_opt_hash != Qnil) {
      rb_dst_origin = rb_hash_aref(_opt_hash, rb_intern("dst_origin"));
    }
    if (_opt_hash != Qnil && rb_dst_origin != Qnil) {
      Check_Type(rb_dst_origin, T_ARRAY);
      {
        int n;
        dst_origin = ALLOC_N(size_t, 3);
        for (n=0; n<3; n++) {
          dst_origin[n] = NUM2ULONG(RARRAY_PTR(rb_dst_origin)[n]);
        }
  }

    } else {
      dst_origin = NULL;
    }
    if (_opt_hash != Qnil) {
      rb_region = rb_hash_aref(_opt_hash, rb_intern("region"));
    }
    if (_opt_hash != Qnil && rb_region != Qnil) {
      Check_Type(rb_region, T_ARRAY);
      {
        int n;
        region = ALLOC_N(size_t, 3);
        for (n=0; n<3; n++) {
          region[n] = NUM2ULONG(RARRAY_PTR(rb_region)[n]);
        }
  }

    } else {
      region = NULL;
    }
    if (_opt_hash != Qnil) {
      rb_event_wait_list = rb_hash_aref(_opt_hash, rb_intern("event_wait_list"));
    }
    if (_opt_hash != Qnil && rb_event_wait_list != Qnil) {
      Check_Type(rb_event_wait_list, T_ARRAY);
      {
        int n;
        num_events_in_wait_list = RARRAY_LEN(rb_event_wait_list);
        event_wait_list = ALLOC_N(cl_event, num_events_in_wait_list);
        for (n=0; n<num_events_in_wait_list; n++) {
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


  ret = clEnqueueCopyBufferToImage(command_queue, src_buffer, dst_image, src_offset, (const size_t*) dst_origin, (const size_t*) region, num_events_in_wait_list, (const cl_event*) event_wait_list, &event);
  check_error(ret);

  {
    rb_event = create_event(event);

    result = rb_ary_new3(1, rb_event);
  }

  free(dst_origin);
  free(region);
  free(event_wait_list);

  return result;
}

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
  VALUE rb_command_queue = Qnil;
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

  if (argc > 5)
    rb_raise(rb_eArgError, "wrong number of arguments (%d for %d)", argc, 4);

  if (argc < 4)
    rb_raise(rb_eArgError, "wrong number of arguments (%d for 4)", argc);
  rb_command_queue = argv[0];
  Check_Type(rb_command_queue, T_DATA);
  if (CLASS_OF(rb_command_queue) != rb_cCommandQueue)
    rb_raise(rb_eRuntimeError, "type of command_queue is invalid: CommandQueue is expected");
  command_queue = (cl_command_queue)DATA_PTR(rb_command_queue);

  rb_image = argv[1];
  Check_Type(rb_image, T_DATA);
  if (CLASS_OF(rb_image) != rb_cMem)
    rb_raise(rb_eRuntimeError, "type of image is invalid: Mem is expected");
  image = ((struct_mem)DATA_PTR(rb_image))->mem;

  rb_blocking_write = argv[2];
  blocking_write = NUM2UINT(rb_blocking_write);

  rb_ptr = argv[3];
  ptr = (void*) RSTRING_PTR(rb_ptr);


  {
    VALUE _opt_hash = Qnil;

    if (argc > 4) {
      _opt_hash = argv[4];
      Check_Type(_opt_hash, T_HASH);
    }
    if (_opt_hash != Qnil) {
      rb_origin = rb_hash_aref(_opt_hash, rb_intern("origin"));
    }
    if (_opt_hash != Qnil && rb_origin != Qnil) {
      Check_Type(rb_origin, T_ARRAY);
      {
        int n;
        origin = ALLOC_N(size_t, 3);
        for (n=0; n<3; n++) {
          origin[n] = NUM2ULONG(RARRAY_PTR(rb_origin)[n]);
        }
  }

    } else {
      origin = NULL;
    }
    if (_opt_hash != Qnil) {
      rb_region = rb_hash_aref(_opt_hash, rb_intern("region"));
    }
    if (_opt_hash != Qnil && rb_region != Qnil) {
      Check_Type(rb_region, T_ARRAY);
      {
        int n;
        region = ALLOC_N(size_t, 3);
        for (n=0; n<3; n++) {
          region[n] = NUM2ULONG(RARRAY_PTR(rb_region)[n]);
        }
  }

    } else {
      region = NULL;
    }
    if (_opt_hash != Qnil) {
      rb_input_row_pitch = rb_hash_aref(_opt_hash, rb_intern("input_row_pitch"));
    }
    if (_opt_hash != Qnil && rb_input_row_pitch != Qnil) {
      input_row_pitch = NUM2ULONG(rb_input_row_pitch);

    } else {
      input_row_pitch = 0;
    }
    if (_opt_hash != Qnil) {
      rb_input_slice_pitch = rb_hash_aref(_opt_hash, rb_intern("input_slice_pitch"));
    }
    if (_opt_hash != Qnil && rb_input_slice_pitch != Qnil) {
      input_slice_pitch = NUM2ULONG(rb_input_slice_pitch);

    } else {
      input_slice_pitch = 0;
    }
    if (_opt_hash != Qnil) {
      rb_event_wait_list = rb_hash_aref(_opt_hash, rb_intern("event_wait_list"));
    }
    if (_opt_hash != Qnil && rb_event_wait_list != Qnil) {
      Check_Type(rb_event_wait_list, T_ARRAY);
      {
        int n;
        num_events_in_wait_list = RARRAY_LEN(rb_event_wait_list);
        event_wait_list = ALLOC_N(cl_event, num_events_in_wait_list);
        for (n=0; n<num_events_in_wait_list; n++) {
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


  ret = clEnqueueWriteImage(command_queue, image, blocking_write, (const size_t*) origin, (const size_t*) region, input_row_pitch, input_slice_pitch, (const void*) ptr, num_events_in_wait_list, (const cl_event*) event_wait_list, &event);
  check_error(ret);

  {
    rb_event = create_event(event);

    result = rb_ary_new3(1, rb_event);
  }

  free(origin);
  free(region);
  free(event_wait_list);

  return result;
}

VALUE
rb_clGetEventInfo(int argc, VALUE *argv, VALUE self)
{
  cl_event event;
  cl_event_info param_name;
  size_t param_value_size;
  void *param_value;
  size_t param_value_size_ret;
  cl_int ret;
  VALUE rb_event = Qnil;
  VALUE rb_param_name = Qnil;
  VALUE rb_param_value = Qnil;

  VALUE result;

  if (argc > 3)
    rb_raise(rb_eArgError, "wrong number of arguments (%d for %d)", argc, 2);

  if (argc < 2)
    rb_raise(rb_eArgError, "wrong number of arguments (%d for 2)", argc);
  rb_event = argv[0];
  Check_Type(rb_event, T_DATA);
  if (CLASS_OF(rb_event) != rb_cEvent)
    rb_raise(rb_eRuntimeError, "type of event is invalid: Event is expected");
  event = (cl_event)DATA_PTR(rb_event);

  rb_param_name = argv[1];
  param_name = NUM2UINT(rb_param_name);




  ret = clGetEventInfo(event, param_name, 0, NULL, &param_value_size_ret);
  param_value_size = param_value_size_ret;
  check_error(ret);
  param_value = (void*) xmalloc(param_value_size);
  ret = clGetEventInfo(event, param_name, param_value_size, param_value, NULL);
  check_error(ret);

  {
    rb_param_value = rb_str_new2(param_value);

    result = rb_ary_new3(1, rb_param_value);
  }


  return result;
}

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
  VALUE rb_program = Qnil;
  VALUE rb_device = Qnil;
  VALUE rb_param_name = Qnil;
  VALUE rb_param_value = Qnil;

  VALUE result;

  if (argc > 4)
    rb_raise(rb_eArgError, "wrong number of arguments (%d for %d)", argc, 3);

  if (argc < 3)
    rb_raise(rb_eArgError, "wrong number of arguments (%d for 3)", argc);
  rb_program = argv[0];
  Check_Type(rb_program, T_DATA);
  if (CLASS_OF(rb_program) != rb_cProgram)
    rb_raise(rb_eRuntimeError, "type of program is invalid: Program is expected");
  program = (cl_program)DATA_PTR(rb_program);

  rb_device = argv[1];
  Check_Type(rb_device, T_DATA);
  if (CLASS_OF(rb_device) != rb_cDevice)
    rb_raise(rb_eRuntimeError, "type of device is invalid: Device is expected");
  device = (cl_device_id)DATA_PTR(rb_device);

  rb_param_name = argv[2];
  param_name = NUM2UINT(rb_param_name);




  ret = clGetProgramBuildInfo(program, device, param_name, 0, NULL, &param_value_size_ret);
  param_value_size = param_value_size_ret;
  check_error(ret);
  param_value = (void*) xmalloc(param_value_size);
  ret = clGetProgramBuildInfo(program, device, param_name, param_value_size, param_value, NULL);
  check_error(ret);

  {
    rb_param_value = rb_str_new2(param_value);

    result = rb_ary_new3(1, rb_param_value);
  }


  return result;
}

VALUE
rb_clEnqueueBarrier(int argc, VALUE *argv, VALUE self)
{
  cl_command_queue command_queue;
  cl_int ret;
  VALUE rb_command_queue = Qnil;

  VALUE result;

  if (argc > 2)
    rb_raise(rb_eArgError, "wrong number of arguments (%d for %d)", argc, 1);

  if (argc < 1)
    rb_raise(rb_eArgError, "wrong number of arguments (%d for 1)", argc);
  rb_command_queue = argv[0];
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
  VALUE rb_command_queue = Qnil;
  VALUE rb_image = Qnil;
  VALUE rb_blocking_read = Qnil;
  VALUE rb_origin = Qnil;
  VALUE rb_region = Qnil;
  VALUE rb_row_pitch = Qnil;
  VALUE rb_slice_pitch = Qnil;
  VALUE rb_ptr = Qnil;
  VALUE rb_event_wait_list = Qnil;
  VALUE rb_event = Qnil;

  VALUE result;

  if (argc > 4)
    rb_raise(rb_eArgError, "wrong number of arguments (%d for %d)", argc, 3);

  if (argc < 3)
    rb_raise(rb_eArgError, "wrong number of arguments (%d for 3)", argc);
  rb_command_queue = argv[0];
  Check_Type(rb_command_queue, T_DATA);
  if (CLASS_OF(rb_command_queue) != rb_cCommandQueue)
    rb_raise(rb_eRuntimeError, "type of command_queue is invalid: CommandQueue is expected");
  command_queue = (cl_command_queue)DATA_PTR(rb_command_queue);

  rb_image = argv[1];
  Check_Type(rb_image, T_DATA);
  if (CLASS_OF(rb_image) != rb_cMem)
    rb_raise(rb_eRuntimeError, "type of image is invalid: Mem is expected");
  image = ((struct_mem)DATA_PTR(rb_image))->mem;

  rb_blocking_read = argv[2];
  blocking_read = NUM2UINT(rb_blocking_read);


  {
    VALUE _opt_hash = Qnil;

    if (argc > 3) {
      _opt_hash = argv[3];
      Check_Type(_opt_hash, T_HASH);
    }
    if (_opt_hash != Qnil) {
      rb_origin = rb_hash_aref(_opt_hash, rb_intern("origin"));
    }
    if (_opt_hash != Qnil && rb_origin != Qnil) {
      Check_Type(rb_origin, T_ARRAY);
      {
        int n;
        origin = ALLOC_N(size_t, 3);
        for (n=0; n<3; n++) {
          origin[n] = NUM2ULONG(RARRAY_PTR(rb_origin)[n]);
        }
  }

    } else {
      origin = NULL;
    }
    if (_opt_hash != Qnil) {
      rb_region = rb_hash_aref(_opt_hash, rb_intern("region"));
    }
    if (_opt_hash != Qnil && rb_region != Qnil) {
      Check_Type(rb_region, T_ARRAY);
      {
        int n;
        region = ALLOC_N(size_t, 3);
        for (n=0; n<3; n++) {
          region[n] = NUM2ULONG(RARRAY_PTR(rb_region)[n]);
        }
  }

    } else {
      region = NULL;
    }
    if (_opt_hash != Qnil) {
      rb_row_pitch = rb_hash_aref(_opt_hash, rb_intern("row_pitch"));
    }
    if (_opt_hash != Qnil && rb_row_pitch != Qnil) {
      row_pitch = NUM2ULONG(rb_row_pitch);

    } else {
      row_pitch = 0;
    }
    if (_opt_hash != Qnil) {
      rb_slice_pitch = rb_hash_aref(_opt_hash, rb_intern("slice_pitch"));
    }
    if (_opt_hash != Qnil && rb_slice_pitch != Qnil) {
      slice_pitch = NUM2ULONG(rb_slice_pitch);

    } else {
      slice_pitch = 0;
    }
    if (_opt_hash != Qnil) {
      rb_ptr = rb_hash_aref(_opt_hash, rb_intern("ptr"));
    }
    if (_opt_hash != Qnil && rb_ptr != Qnil) {
      ptr = (void*) RSTRING_PTR(rb_ptr);

    } else {
      ptr = NULL;
    }
    if (_opt_hash != Qnil) {
      rb_event_wait_list = rb_hash_aref(_opt_hash, rb_intern("event_wait_list"));
    }
    if (_opt_hash != Qnil && rb_event_wait_list != Qnil) {
      Check_Type(rb_event_wait_list, T_ARRAY);
      {
        int n;
        num_events_in_wait_list = RARRAY_LEN(rb_event_wait_list);
        event_wait_list = ALLOC_N(cl_event, num_events_in_wait_list);
        for (n=0; n<num_events_in_wait_list; n++) {
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


  ret = clEnqueueReadImage(command_queue, image, blocking_read, (const size_t*) origin, (const size_t*) region, row_pitch, slice_pitch, ptr, num_events_in_wait_list, (const cl_event*) event_wait_list, &event);
  check_error(ret);

  {
    rb_event = create_event(event);

    result = rb_ary_new3(1, rb_event);
  }

  free(origin);
  free(region);
  free(event_wait_list);

  return result;
}

VALUE
rb_clGetKernelInfo(int argc, VALUE *argv, VALUE self)
{
  cl_kernel kernel;
  cl_kernel_info param_name;
  size_t param_value_size;
  void *param_value;
  size_t param_value_size_ret;
  cl_int ret;
  VALUE rb_kernel = Qnil;
  VALUE rb_param_name = Qnil;
  VALUE rb_param_value = Qnil;

  VALUE result;

  if (argc > 3)
    rb_raise(rb_eArgError, "wrong number of arguments (%d for %d)", argc, 2);

  if (argc < 2)
    rb_raise(rb_eArgError, "wrong number of arguments (%d for 2)", argc);
  rb_kernel = argv[0];
  Check_Type(rb_kernel, T_DATA);
  if (CLASS_OF(rb_kernel) != rb_cKernel)
    rb_raise(rb_eRuntimeError, "type of kernel is invalid: Kernel is expected");
  kernel = (cl_kernel)DATA_PTR(rb_kernel);

  rb_param_name = argv[1];
  param_name = NUM2UINT(rb_param_name);




  ret = clGetKernelInfo(kernel, param_name, 0, NULL, &param_value_size_ret);
  param_value_size = param_value_size_ret;
  check_error(ret);
  param_value = (void*) xmalloc(param_value_size);
  ret = clGetKernelInfo(kernel, param_name, param_value_size, param_value, NULL);
  check_error(ret);

  {
    rb_param_value = rb_str_new2(param_value);

    result = rb_ary_new3(1, rb_param_value);
  }


  return result;
}

VALUE
rb_clGetImageInfo(int argc, VALUE *argv, VALUE self)
{
  cl_mem image;
  cl_image_info param_name;
  size_t param_value_size;
  void *param_value;
  size_t param_value_size_ret;
  cl_int ret;
  VALUE rb_image = Qnil;
  VALUE rb_param_name = Qnil;
  VALUE rb_param_value = Qnil;

  VALUE result;

  if (argc > 3)
    rb_raise(rb_eArgError, "wrong number of arguments (%d for %d)", argc, 2);

  if (argc < 2)
    rb_raise(rb_eArgError, "wrong number of arguments (%d for 2)", argc);
  rb_image = argv[0];
  Check_Type(rb_image, T_DATA);
  if (CLASS_OF(rb_image) != rb_cMem)
    rb_raise(rb_eRuntimeError, "type of image is invalid: Mem is expected");
  image = ((struct_mem)DATA_PTR(rb_image))->mem;

  rb_param_name = argv[1];
  param_name = NUM2UINT(rb_param_name);




  ret = clGetImageInfo(image, param_name, 0, NULL, &param_value_size_ret);
  param_value_size = param_value_size_ret;
  check_error(ret);
  param_value = (void*) xmalloc(param_value_size);
  ret = clGetImageInfo(image, param_name, param_value_size, param_value, NULL);
  check_error(ret);

  {
    rb_param_value = rb_str_new2(param_value);

    result = rb_ary_new3(1, rb_param_value);
  }


  return result;
}

VALUE
rb_clGetDeviceInfo(int argc, VALUE *argv, VALUE self)
{
  cl_device_id device;
  cl_device_info param_name;
  size_t param_value_size;
  void *param_value;
  size_t param_value_size_ret;
  cl_int ret;
  VALUE rb_device = Qnil;
  VALUE rb_param_name = Qnil;
  VALUE rb_param_value = Qnil;

  VALUE result;

  if (argc > 3)
    rb_raise(rb_eArgError, "wrong number of arguments (%d for %d)", argc, 2);

  if (argc < 2)
    rb_raise(rb_eArgError, "wrong number of arguments (%d for 2)", argc);
  rb_device = argv[0];
  Check_Type(rb_device, T_DATA);
  if (CLASS_OF(rb_device) != rb_cDevice)
    rb_raise(rb_eRuntimeError, "type of device is invalid: Device is expected");
  device = (cl_device_id)DATA_PTR(rb_device);

  rb_param_name = argv[1];
  param_name = NUM2UINT(rb_param_name);




  ret = clGetDeviceInfo(device, param_name, 0, NULL, &param_value_size_ret);
  param_value_size = param_value_size_ret;
  check_error(ret);
  param_value = (void*) xmalloc(param_value_size);
  ret = clGetDeviceInfo(device, param_name, param_value_size, param_value, NULL);
  check_error(ret);

  {
    rb_param_value = rb_str_new2(param_value);

    result = rb_ary_new3(1, rb_param_value);
  }


  return result;
}

VALUE
rb_clEnqueueWaitForEvents(int argc, VALUE *argv, VALUE self)
{
  cl_command_queue command_queue;
  cl_uint num_events;
  cl_event *event_list;
  cl_int ret;
  VALUE rb_command_queue = Qnil;
  VALUE rb_event_list = Qnil;

  VALUE result;

  if (argc > 3)
    rb_raise(rb_eArgError, "wrong number of arguments (%d for %d)", argc, 2);

  if (argc < 2)
    rb_raise(rb_eArgError, "wrong number of arguments (%d for 2)", argc);
  rb_command_queue = argv[0];
  Check_Type(rb_command_queue, T_DATA);
  if (CLASS_OF(rb_command_queue) != rb_cCommandQueue)
    rb_raise(rb_eRuntimeError, "type of command_queue is invalid: CommandQueue is expected");
  command_queue = (cl_command_queue)DATA_PTR(rb_command_queue);

  rb_event_list = argv[1];
  Check_Type(rb_event_list, T_ARRAY);
  {
    int n;
    num_events = RARRAY_LEN(rb_event_list);
    event_list = ALLOC_N(cl_event, num_events);
    for (n=0; n<num_events; n++) {
      Check_Type(RARRAY_PTR(rb_event_list)[n], T_DATA);
      if (CLASS_OF(RARRAY_PTR(rb_event_list)[n]) != rb_cEvent)
        rb_raise(rb_eRuntimeError, "type of event_list[n] is invalid: Event is expected");
      event_list[n] = (cl_event)DATA_PTR(RARRAY_PTR(rb_event_list)[n]);
    }
  }




  ret = clEnqueueWaitForEvents(command_queue, num_events, (const cl_event*) event_list);
  check_error(ret);

  {
    result = Qnil;
  }

  free(event_list);

  return result;
}

VALUE
rb_clGetEventProfilingInfo(int argc, VALUE *argv, VALUE self)
{
  cl_event event;
  cl_profiling_info param_name;
  size_t param_value_size;
  void *param_value;
  size_t param_value_size_ret;
  cl_int ret;
  VALUE rb_event = Qnil;
  VALUE rb_param_name = Qnil;
  VALUE rb_param_value = Qnil;

  VALUE result;

  if (argc > 3)
    rb_raise(rb_eArgError, "wrong number of arguments (%d for %d)", argc, 2);

  if (argc < 2)
    rb_raise(rb_eArgError, "wrong number of arguments (%d for 2)", argc);
  rb_event = argv[0];
  Check_Type(rb_event, T_DATA);
  if (CLASS_OF(rb_event) != rb_cEvent)
    rb_raise(rb_eRuntimeError, "type of event is invalid: Event is expected");
  event = (cl_event)DATA_PTR(rb_event);

  rb_param_name = argv[1];
  param_name = NUM2UINT(rb_param_name);




  ret = clGetEventProfilingInfo(event, param_name, 0, NULL, &param_value_size_ret);
  param_value_size = param_value_size_ret;
  check_error(ret);
  param_value = (void*) xmalloc(param_value_size);
  ret = clGetEventProfilingInfo(event, param_name, param_value_size, param_value, NULL);
  check_error(ret);

  {
    rb_param_value = rb_str_new2(param_value);

    result = rb_ary_new3(1, rb_param_value);
  }


  return result;
}

VALUE
rb_clUnloadCompiler(int argc, VALUE *argv, VALUE self)
{
  cl_int ret;

  VALUE result;

  if (argc > 1)
    rb_raise(rb_eArgError, "wrong number of arguments (%d for %d)", argc, 0);

  if (argc < 0)
    rb_raise(rb_eArgError, "wrong number of arguments (%d for 0)", argc);



  ret = clUnloadCompiler();
  check_error(ret);

  {
    result = Qnil;
  }


  return result;
}

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

  if (argc > 5)
    rb_raise(rb_eArgError, "wrong number of arguments (%d for %d)", argc, 4);

  if (argc < 4)
    rb_raise(rb_eArgError, "wrong number of arguments (%d for 4)", argc);
  rb_context = argv[0];
  Check_Type(rb_context, T_DATA);
  if (CLASS_OF(rb_context) != rb_cContext)
    rb_raise(rb_eRuntimeError, "type of context is invalid: Context is expected");
  context = (cl_context)DATA_PTR(rb_context);

  rb_normalized_coords = argv[1];
  normalized_coords = NUM2UINT(rb_normalized_coords);

  rb_addressing_mode = argv[2];
  addressing_mode = NUM2UINT(rb_addressing_mode);

  rb_filter_mode = argv[3];
  filter_mode = NUM2UINT(rb_filter_mode);




  ret = clCreateSampler(context, normalized_coords, addressing_mode, filter_mode, &errcode_ret);
  check_error(errcode_ret);

  {
    VALUE rb_ret;
    rb_ret = create_sampler(ret);

    result = rb_ary_new3(1, ret);
  }


  return result;
}

void
clCreateContextFromType_pfn_notify(const char * errinfo, const void * private_info, size_t cb, void * user_data)
{
  if (rb_block_given_p())
    rb_yield(rb_ary_new3(3, rb_str_new2(errinfo), rb_str_new(private_info, cb), (VALUE) user_data));
}
VALUE
rb_clCreateContextFromType(int argc, VALUE *argv, VALUE self)
{
  cl_context_properties *properties;
  cl_device_type device_type;
  void *user_data;
  cl_int errcode_ret;
  cl_context ret;
  VALUE rb_device_type = Qnil;
  VALUE rb_user_data = Qnil;

  VALUE result;

  if (argc > 4)
    rb_raise(rb_eArgError, "wrong number of arguments (%d for %d)", argc, 2);

  properties = NULL;
  if (argc < 2)
    rb_raise(rb_eArgError, "wrong number of arguments (%d for 2)", argc);
  rb_device_type = argv[0];
  device_type = NUM2ULONG(rb_device_type);

  rb_user_data = argv[1];
  user_data = (void*) RSTRING_PTR(rb_user_data);




  ret = clCreateContextFromType(properties, device_type, clCreateContextFromType_pfn_notify, user_data, &errcode_ret);
  check_error(errcode_ret);

  {
    VALUE rb_ret;
    rb_ret = create_context(ret);

    result = rb_ary_new3(1, ret);
  }


  return result;
}

VALUE
rb_clGetPlatformInfo(int argc, VALUE *argv, VALUE self)
{
  cl_platform_id platform;
  cl_platform_info param_name;
  size_t param_value_size;
  void *param_value;
  size_t param_value_size_ret;
  cl_int ret;
  VALUE rb_platform = Qnil;
  VALUE rb_param_name = Qnil;
  VALUE rb_param_value = Qnil;

  VALUE result;

  if (argc > 3)
    rb_raise(rb_eArgError, "wrong number of arguments (%d for %d)", argc, 2);

  if (argc < 2)
    rb_raise(rb_eArgError, "wrong number of arguments (%d for 2)", argc);
  rb_platform = argv[0];
  Check_Type(rb_platform, T_DATA);
  if (CLASS_OF(rb_platform) != rb_cPlatform)
    rb_raise(rb_eRuntimeError, "type of platform is invalid: Platform is expected");
  platform = (cl_platform_id)DATA_PTR(rb_platform);

  rb_param_name = argv[1];
  param_name = NUM2UINT(rb_param_name);




  ret = clGetPlatformInfo(platform, param_name, 0, NULL, &param_value_size_ret);
  param_value_size = param_value_size_ret;
  check_error(ret);
  param_value = (void*) xmalloc(param_value_size);
  ret = clGetPlatformInfo(platform, param_name, param_value_size, param_value, NULL);
  check_error(ret);

  {
    rb_param_value = rb_str_new2(param_value);

    result = rb_ary_new3(1, rb_param_value);
  }


  return result;
}

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
  VALUE rb_command_queue = Qnil;
  VALUE rb_memobj = Qnil;
  VALUE rb_event_wait_list = Qnil;
  VALUE rb_event = Qnil;

  VALUE result;

  if (argc > 3)
    rb_raise(rb_eArgError, "wrong number of arguments (%d for %d)", argc, 2);

  mapped_ptr = NULL;
  if (argc < 2)
    rb_raise(rb_eArgError, "wrong number of arguments (%d for 2)", argc);
  rb_command_queue = argv[0];
  Check_Type(rb_command_queue, T_DATA);
  if (CLASS_OF(rb_command_queue) != rb_cCommandQueue)
    rb_raise(rb_eRuntimeError, "type of command_queue is invalid: CommandQueue is expected");
  command_queue = (cl_command_queue)DATA_PTR(rb_command_queue);

  rb_memobj = argv[1];
  Check_Type(rb_memobj, T_DATA);
  if (CLASS_OF(rb_memobj) != rb_cMem)
    rb_raise(rb_eRuntimeError, "type of memobj is invalid: Mem is expected");
  memobj = ((struct_mem)DATA_PTR(rb_memobj))->mem;


  {
    VALUE _opt_hash = Qnil;

    if (argc > 2) {
      _opt_hash = argv[2];
      Check_Type(_opt_hash, T_HASH);
    }
    if (_opt_hash != Qnil) {
      rb_event_wait_list = rb_hash_aref(_opt_hash, rb_intern("event_wait_list"));
    }
    if (_opt_hash != Qnil && rb_event_wait_list != Qnil) {
      Check_Type(rb_event_wait_list, T_ARRAY);
      {
        int n;
        num_events_in_wait_list = RARRAY_LEN(rb_event_wait_list);
        event_wait_list = ALLOC_N(cl_event, num_events_in_wait_list);
        for (n=0; n<num_events_in_wait_list; n++) {
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


  ret = clEnqueueUnmapMemObject(command_queue, memobj, mapped_ptr, num_events_in_wait_list, (const cl_event*) event_wait_list, &event);
  check_error(ret);

  {
    rb_event = create_event(event);

    result = rb_ary_new3(1, rb_event);
  }

  free(event_wait_list);

  return result;
}

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
  VALUE rb_command_queue = Qnil;
  VALUE rb_src_buffer = Qnil;
  VALUE rb_dst_buffer = Qnil;
  VALUE rb_src_offset = Qnil;
  VALUE rb_dst_offset = Qnil;
  VALUE rb_cb = Qnil;
  VALUE rb_event_wait_list = Qnil;
  VALUE rb_event = Qnil;

  VALUE result;

  if (argc > 4)
    rb_raise(rb_eArgError, "wrong number of arguments (%d for %d)", argc, 3);

  if (argc < 3)
    rb_raise(rb_eArgError, "wrong number of arguments (%d for 3)", argc);
  rb_command_queue = argv[0];
  Check_Type(rb_command_queue, T_DATA);
  if (CLASS_OF(rb_command_queue) != rb_cCommandQueue)
    rb_raise(rb_eRuntimeError, "type of command_queue is invalid: CommandQueue is expected");
  command_queue = (cl_command_queue)DATA_PTR(rb_command_queue);

  rb_src_buffer = argv[1];
  Check_Type(rb_src_buffer, T_DATA);
  if (CLASS_OF(rb_src_buffer) != rb_cMem)
    rb_raise(rb_eRuntimeError, "type of src_buffer is invalid: Mem is expected");
  src_buffer = ((struct_mem)DATA_PTR(rb_src_buffer))->mem;

  rb_dst_buffer = argv[2];
  Check_Type(rb_dst_buffer, T_DATA);
  if (CLASS_OF(rb_dst_buffer) != rb_cMem)
    rb_raise(rb_eRuntimeError, "type of dst_buffer is invalid: Mem is expected");
  dst_buffer = ((struct_mem)DATA_PTR(rb_dst_buffer))->mem;


  {
    VALUE _opt_hash = Qnil;

    if (argc > 3) {
      _opt_hash = argv[3];
      Check_Type(_opt_hash, T_HASH);
    }
    if (_opt_hash != Qnil) {
      rb_src_offset = rb_hash_aref(_opt_hash, rb_intern("src_offset"));
    }
    if (_opt_hash != Qnil && rb_src_offset != Qnil) {
      src_offset = NUM2ULONG(rb_src_offset);

    } else {
      src_offset = 0;
    }
    if (_opt_hash != Qnil) {
      rb_dst_offset = rb_hash_aref(_opt_hash, rb_intern("dst_offset"));
    }
    if (_opt_hash != Qnil && rb_dst_offset != Qnil) {
      dst_offset = NUM2ULONG(rb_dst_offset);

    } else {
      dst_offset = 0;
    }
    if (_opt_hash != Qnil) {
      rb_cb = rb_hash_aref(_opt_hash, rb_intern("cb"));
    }
    if (_opt_hash != Qnil && rb_cb != Qnil) {
      cb = NUM2ULONG(rb_cb);

    } else {
      cb = 0;
    }
    if (_opt_hash != Qnil) {
      rb_event_wait_list = rb_hash_aref(_opt_hash, rb_intern("event_wait_list"));
    }
    if (_opt_hash != Qnil && rb_event_wait_list != Qnil) {
      Check_Type(rb_event_wait_list, T_ARRAY);
      {
        int n;
        num_events_in_wait_list = RARRAY_LEN(rb_event_wait_list);
        event_wait_list = ALLOC_N(cl_event, num_events_in_wait_list);
        for (n=0; n<num_events_in_wait_list; n++) {
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


  ret = clEnqueueCopyBuffer(command_queue, src_buffer, dst_buffer, src_offset, dst_offset, cb, num_events_in_wait_list, (const cl_event*) event_wait_list, &event);
  check_error(ret);

  {
    rb_event = create_event(event);

    result = rb_ary_new3(1, rb_event);
  }

  free(event_wait_list);

  return result;
}

VALUE
rb_clFlush(int argc, VALUE *argv, VALUE self)
{
  cl_command_queue command_queue;
  cl_int ret;
  VALUE rb_command_queue = Qnil;

  VALUE result;

  if (argc > 2)
    rb_raise(rb_eArgError, "wrong number of arguments (%d for %d)", argc, 1);

  if (argc < 1)
    rb_raise(rb_eArgError, "wrong number of arguments (%d for 1)", argc);
  rb_command_queue = argv[0];
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

VALUE
rb_clGetProgramInfo(int argc, VALUE *argv, VALUE self)
{
  cl_program program;
  cl_program_info param_name;
  size_t param_value_size;
  void *param_value;
  size_t param_value_size_ret;
  cl_int ret;
  VALUE rb_program = Qnil;
  VALUE rb_param_name = Qnil;
  VALUE rb_param_value = Qnil;

  VALUE result;

  if (argc > 3)
    rb_raise(rb_eArgError, "wrong number of arguments (%d for %d)", argc, 2);

  if (argc < 2)
    rb_raise(rb_eArgError, "wrong number of arguments (%d for 2)", argc);
  rb_program = argv[0];
  Check_Type(rb_program, T_DATA);
  if (CLASS_OF(rb_program) != rb_cProgram)
    rb_raise(rb_eRuntimeError, "type of program is invalid: Program is expected");
  program = (cl_program)DATA_PTR(rb_program);

  rb_param_name = argv[1];
  param_name = NUM2UINT(rb_param_name);




  ret = clGetProgramInfo(program, param_name, 0, NULL, &param_value_size_ret);
  param_value_size = param_value_size_ret;
  check_error(ret);
  param_value = (void*) xmalloc(param_value_size);
  ret = clGetProgramInfo(program, param_name, param_value_size, param_value, NULL);
  check_error(ret);

  {
    rb_param_value = rb_str_new2(param_value);

    result = rb_ary_new3(1, rb_param_value);
  }


  return result;
}

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

  if (argc > 4)
    rb_raise(rb_eArgError, "wrong number of arguments (%d for %d)", argc, 3);

  if (argc < 3)
    rb_raise(rb_eArgError, "wrong number of arguments (%d for 3)", argc);
  rb_context = argv[0];
  Check_Type(rb_context, T_DATA);
  if (CLASS_OF(rb_context) != rb_cContext)
    rb_raise(rb_eRuntimeError, "type of context is invalid: Context is expected");
  context = (cl_context)DATA_PTR(rb_context);

  rb_flags = argv[1];
  flags = NUM2ULONG(rb_flags);

  rb_size = argv[2];
  size = NUM2ULONG(rb_size);


  {
    VALUE _opt_hash = Qnil;

    if (argc > 3) {
      _opt_hash = argv[3];
      Check_Type(_opt_hash, T_HASH);
    }
    if (_opt_hash != Qnil) {
      rb_host_ptr = rb_hash_aref(_opt_hash, rb_intern("host_ptr"));
    }
    if (_opt_hash != Qnil && rb_host_ptr != Qnil) {
      host_ptr = (void*) RSTRING_PTR(rb_host_ptr);

    } else {
      host_ptr = NULL;
    }
  }


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

    result = rb_ary_new3(1, ret);
  }


  return result;
}

VALUE
rb_clGetContextInfo(int argc, VALUE *argv, VALUE self)
{
  cl_context context;
  cl_context_info param_name;
  size_t param_value_size;
  void *param_value;
  size_t param_value_size_ret;
  cl_int ret;
  VALUE rb_context = Qnil;
  VALUE rb_param_name = Qnil;
  VALUE rb_param_value = Qnil;

  VALUE result;

  if (argc > 3)
    rb_raise(rb_eArgError, "wrong number of arguments (%d for %d)", argc, 2);

  if (argc < 2)
    rb_raise(rb_eArgError, "wrong number of arguments (%d for 2)", argc);
  rb_context = argv[0];
  Check_Type(rb_context, T_DATA);
  if (CLASS_OF(rb_context) != rb_cContext)
    rb_raise(rb_eRuntimeError, "type of context is invalid: Context is expected");
  context = (cl_context)DATA_PTR(rb_context);

  rb_param_name = argv[1];
  param_name = NUM2UINT(rb_param_name);




  ret = clGetContextInfo(context, param_name, 0, NULL, &param_value_size_ret);
  param_value_size = param_value_size_ret;
  check_error(ret);
  param_value = (void*) xmalloc(param_value_size);
  ret = clGetContextInfo(context, param_name, param_value_size, param_value, NULL);
  check_error(ret);

  {
    rb_param_value = rb_str_new2(param_value);

    result = rb_ary_new3(1, rb_param_value);
  }


  return result;
}

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
  VALUE rb_command_queue = Qnil;
  VALUE rb_buffer = Qnil;
  VALUE rb_blocking_read = Qnil;
  VALUE rb_offset = Qnil;
  VALUE rb_cb = Qnil;
  VALUE rb_ptr = Qnil;
  VALUE rb_event_wait_list = Qnil;
  VALUE rb_event = Qnil;

  VALUE result;

  if (argc > 4)
    rb_raise(rb_eArgError, "wrong number of arguments (%d for %d)", argc, 3);

  if (argc < 3)
    rb_raise(rb_eArgError, "wrong number of arguments (%d for 3)", argc);
  rb_command_queue = argv[0];
  Check_Type(rb_command_queue, T_DATA);
  if (CLASS_OF(rb_command_queue) != rb_cCommandQueue)
    rb_raise(rb_eRuntimeError, "type of command_queue is invalid: CommandQueue is expected");
  command_queue = (cl_command_queue)DATA_PTR(rb_command_queue);

  rb_buffer = argv[1];
  Check_Type(rb_buffer, T_DATA);
  if (CLASS_OF(rb_buffer) != rb_cMem)
    rb_raise(rb_eRuntimeError, "type of buffer is invalid: Mem is expected");
  buffer = ((struct_mem)DATA_PTR(rb_buffer))->mem;

  rb_blocking_read = argv[2];
  blocking_read = NUM2UINT(rb_blocking_read);


  {
    VALUE _opt_hash = Qnil;

    if (argc > 3) {
      _opt_hash = argv[3];
      Check_Type(_opt_hash, T_HASH);
    }
    if (_opt_hash != Qnil) {
      rb_offset = rb_hash_aref(_opt_hash, rb_intern("offset"));
    }
    if (_opt_hash != Qnil && rb_offset != Qnil) {
      offset = NUM2ULONG(rb_offset);

    } else {
      offset = 0;
    }
    if (_opt_hash != Qnil) {
      rb_cb = rb_hash_aref(_opt_hash, rb_intern("cb"));
    }
    if (_opt_hash != Qnil && rb_cb != Qnil) {
      cb = NUM2ULONG(rb_cb);

    } else {
      cb = 0;
    }
    if (_opt_hash != Qnil) {
      rb_ptr = rb_hash_aref(_opt_hash, rb_intern("ptr"));
    }
    if (_opt_hash != Qnil && rb_ptr != Qnil) {
      ptr = (void*) RSTRING_PTR(rb_ptr);

    } else {
      ptr = NULL;
    }
    if (_opt_hash != Qnil) {
      rb_event_wait_list = rb_hash_aref(_opt_hash, rb_intern("event_wait_list"));
    }
    if (_opt_hash != Qnil && rb_event_wait_list != Qnil) {
      Check_Type(rb_event_wait_list, T_ARRAY);
      {
        int n;
        num_events_in_wait_list = RARRAY_LEN(rb_event_wait_list);
        event_wait_list = ALLOC_N(cl_event, num_events_in_wait_list);
        for (n=0; n<num_events_in_wait_list; n++) {
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


  ret = clEnqueueReadBuffer(command_queue, buffer, blocking_read, offset, cb, ptr, num_events_in_wait_list, (const cl_event*) event_wait_list, &event);
  check_error(ret);

  {
    rb_event = create_event(event);

    result = rb_ary_new3(1, rb_event);
  }

  free(event_wait_list);

  return result;
}

VALUE
rb_clFinish(int argc, VALUE *argv, VALUE self)
{
  cl_command_queue command_queue;
  cl_int ret;
  VALUE rb_command_queue = Qnil;

  VALUE result;

  if (argc > 2)
    rb_raise(rb_eArgError, "wrong number of arguments (%d for %d)", argc, 1);

  if (argc < 1)
    rb_raise(rb_eArgError, "wrong number of arguments (%d for 1)", argc);
  rb_command_queue = argv[0];
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
  VALUE rb_context = Qnil;
  VALUE rb_device_list = Qnil;
  VALUE rb_binaries = Qnil;
  VALUE rb_binary_status = Qnil;

  VALUE result;

  if (argc > 4)
    rb_raise(rb_eArgError, "wrong number of arguments (%d for %d)", argc, 3);

  if (argc < 3)
    rb_raise(rb_eArgError, "wrong number of arguments (%d for 3)", argc);
  rb_context = argv[0];
  Check_Type(rb_context, T_DATA);
  if (CLASS_OF(rb_context) != rb_cContext)
    rb_raise(rb_eRuntimeError, "type of context is invalid: Context is expected");
  context = (cl_context)DATA_PTR(rb_context);

  rb_device_list = argv[1];
  Check_Type(rb_device_list, T_ARRAY);
  {
    int n;
    num_devices = RARRAY_LEN(rb_device_list);
    device_list = ALLOC_N(cl_device_id, num_devices);
    for (n=0; n<num_devices; n++) {
      Check_Type(RARRAY_PTR(rb_device_list)[n], T_DATA);
      if (CLASS_OF(RARRAY_PTR(rb_device_list)[n]) != rb_cDevice)
        rb_raise(rb_eRuntimeError, "type of device_list[n] is invalid: Device is expected");
      device_list[n] = (cl_device_id)DATA_PTR(RARRAY_PTR(rb_device_list)[n]);
    }
  }

  rb_binaries = argv[2];
  Check_Type(rb_binaries, T_ARRAY);
  {
    int n;
    binaries = ALLOC_N(unsigned char*, num_devices);
    lengths = ALLOC_N(size_t, num_devices);
    for (n=0; n<num_devices; n++) {
      binaries[n] = (unsigned char*) RSTRING_PTR(RARRAY_PTR(rb_binaries)[n]);
      lengths[n] = RSTRING_LEN(RARRAY_PTR(rb_binaries)[n]);
    }
  }




  ret = clCreateProgramWithBinary(context, num_devices, (const cl_device_id*) device_list, (const size_t*) lengths, (const unsigned char**) binaries, &binary_status, &errcode_ret);
  check_error(errcode_ret);

  {
    VALUE rb_ret;
    rb_ret = create_program(ret);

    rb_binary_status = INT2NUM(binary_status);

    result = rb_ary_new3(2, ret, rb_binary_status);
  }

  free(device_list);
  free(binaries);
  free(lengths);

  return result;
}

VALUE
rb_clGetMemObjectInfo(int argc, VALUE *argv, VALUE self)
{
  cl_mem memobj;
  cl_mem_info param_name;
  size_t param_value_size;
  void *param_value;
  size_t param_value_size_ret;
  cl_int ret;
  VALUE rb_memobj = Qnil;
  VALUE rb_param_name = Qnil;
  VALUE rb_param_value = Qnil;

  VALUE result;

  if (argc > 3)
    rb_raise(rb_eArgError, "wrong number of arguments (%d for %d)", argc, 2);

  if (argc < 2)
    rb_raise(rb_eArgError, "wrong number of arguments (%d for 2)", argc);
  rb_memobj = argv[0];
  Check_Type(rb_memobj, T_DATA);
  if (CLASS_OF(rb_memobj) != rb_cMem)
    rb_raise(rb_eRuntimeError, "type of memobj is invalid: Mem is expected");
  memobj = ((struct_mem)DATA_PTR(rb_memobj))->mem;

  rb_param_name = argv[1];
  param_name = NUM2UINT(rb_param_name);




  ret = clGetMemObjectInfo(memobj, param_name, 0, NULL, &param_value_size_ret);
  param_value_size = param_value_size_ret;
  check_error(ret);
  param_value = (void*) xmalloc(param_value_size);
  ret = clGetMemObjectInfo(memobj, param_name, param_value_size, param_value, NULL);
  check_error(ret);

  {
    rb_param_value = rb_str_new2(param_value);

    result = rb_ary_new3(1, rb_param_value);
  }


  return result;
}

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

  if (argc > 3)
    rb_raise(rb_eArgError, "wrong number of arguments (%d for %d)", argc, 2);

  if (argc < 2)
    rb_raise(rb_eArgError, "wrong number of arguments (%d for 2)", argc);
  rb_platform = argv[0];
  Check_Type(rb_platform, T_DATA);
  if (CLASS_OF(rb_platform) != rb_cPlatform)
    rb_raise(rb_eRuntimeError, "type of platform is invalid: Platform is expected");
  platform = (cl_platform_id)DATA_PTR(rb_platform);

  rb_device_type = argv[1];
  device_type = NUM2ULONG(rb_device_type);




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
      for (ii=0; ii<num_entries; ii++)
        ary[ii] = create_device(devices[ii]);
      rb_devices = rb_ary_new4(num_entries, ary);
    }

    result = rb_ary_new3(1, rb_devices);
  }


  return result;
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
  image_channel_order = NUM2UINT(rb_image_channel_order);
  rb_image_channel_data_type = argv[1];
  image_channel_data_type = NUM2UINT(rb_image_channel_data_type);

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

  return UINT2NUM(image_format->image_channel_order);
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

  return UINT2NUM(image_format->image_channel_data_type);
}
void Init_opencl(void)
{
  rb_mOpenCL = rb_define_module("OpenCL");

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
  rb_define_const(rb_mOpenCL, "FALSE", INT2NUM(CL_FALSE));
  rb_define_const(rb_mOpenCL, "TRUE", INT2NUM(CL_TRUE));
  rb_define_const(rb_mOpenCL, "FILTER_NEAREST", ULONG2NUM(CL_FILTER_NEAREST));
  rb_define_const(rb_mOpenCL, "FILTER_LINEAR", ULONG2NUM(CL_FILTER_LINEAR));
  rb_define_const(rb_mOpenCL, "COMMAND_NDRANGE_KERNEL", ULONG2NUM(CL_COMMAND_NDRANGE_KERNEL));
  rb_define_const(rb_mOpenCL, "COMMAND_TASK", ULONG2NUM(CL_COMMAND_TASK));
  rb_define_const(rb_mOpenCL, "COMMAND_NATIVE_KERNEL", ULONG2NUM(CL_COMMAND_NATIVE_KERNEL));
  rb_define_const(rb_mOpenCL, "COMMAND_READ_BUFFER", ULONG2NUM(CL_COMMAND_READ_BUFFER));
  rb_define_const(rb_mOpenCL, "COMMAND_WRITE_BUFFER", ULONG2NUM(CL_COMMAND_WRITE_BUFFER));
  rb_define_const(rb_mOpenCL, "COMMAND_COPY_BUFFER", ULONG2NUM(CL_COMMAND_COPY_BUFFER));
  rb_define_const(rb_mOpenCL, "COMMAND_READ_IMAGE", ULONG2NUM(CL_COMMAND_READ_IMAGE));
  rb_define_const(rb_mOpenCL, "COMMAND_WRITE_IMAGE", ULONG2NUM(CL_COMMAND_WRITE_IMAGE));
  rb_define_const(rb_mOpenCL, "COMMAND_COPY_IMAGE", ULONG2NUM(CL_COMMAND_COPY_IMAGE));
  rb_define_const(rb_mOpenCL, "COMMAND_COPY_IMAGE_TO_BUFFER", ULONG2NUM(CL_COMMAND_COPY_IMAGE_TO_BUFFER));
  rb_define_const(rb_mOpenCL, "COMMAND_COPY_BUFFER_TO_IMAGE", ULONG2NUM(CL_COMMAND_COPY_BUFFER_TO_IMAGE));
  rb_define_const(rb_mOpenCL, "COMMAND_MAP_BUFFER", ULONG2NUM(CL_COMMAND_MAP_BUFFER));
  rb_define_const(rb_mOpenCL, "COMMAND_MAP_IMAGE", ULONG2NUM(CL_COMMAND_MAP_IMAGE));
  rb_define_const(rb_mOpenCL, "COMMAND_UNMAP_MEM_OBJECT", ULONG2NUM(CL_COMMAND_UNMAP_MEM_OBJECT));
  rb_define_const(rb_mOpenCL, "COMMAND_MARKER", ULONG2NUM(CL_COMMAND_MARKER));
  rb_define_const(rb_mOpenCL, "COMMAND_WAIT_FOR_EVENTS", ULONG2NUM(CL_COMMAND_WAIT_FOR_EVENTS));
  rb_define_const(rb_mOpenCL, "COMMAND_BARRIER", ULONG2NUM(CL_COMMAND_BARRIER));
  rb_define_const(rb_mOpenCL, "COMMAND_ACQUIRE_GL_OBJECTS", ULONG2NUM(CL_COMMAND_ACQUIRE_GL_OBJECTS));
  rb_define_const(rb_mOpenCL, "COMMAND_RELEASE_GL_OBJECTS", ULONG2NUM(CL_COMMAND_RELEASE_GL_OBJECTS));
  rb_define_const(rb_mOpenCL, "VERSION_1_0", INT2NUM(CL_VERSION_1_0));
  rb_define_const(rb_mOpenCL, "SNORM_INT8", ULONG2NUM(CL_SNORM_INT8));
  rb_define_const(rb_mOpenCL, "SNORM_INT16", ULONG2NUM(CL_SNORM_INT16));
  rb_define_const(rb_mOpenCL, "UNORM_INT8", ULONG2NUM(CL_UNORM_INT8));
  rb_define_const(rb_mOpenCL, "UNORM_INT16", ULONG2NUM(CL_UNORM_INT16));
  rb_define_const(rb_mOpenCL, "UNORM_SHORT_565", ULONG2NUM(CL_UNORM_SHORT_565));
  rb_define_const(rb_mOpenCL, "UNORM_SHORT_555", ULONG2NUM(CL_UNORM_SHORT_555));
  rb_define_const(rb_mOpenCL, "UNORM_INT_101010", ULONG2NUM(CL_UNORM_INT_101010));
  rb_define_const(rb_mOpenCL, "SIGNED_INT8", ULONG2NUM(CL_SIGNED_INT8));
  rb_define_const(rb_mOpenCL, "SIGNED_INT16", ULONG2NUM(CL_SIGNED_INT16));
  rb_define_const(rb_mOpenCL, "SIGNED_INT32", ULONG2NUM(CL_SIGNED_INT32));
  rb_define_const(rb_mOpenCL, "UNSIGNED_INT8", ULONG2NUM(CL_UNSIGNED_INT8));
  rb_define_const(rb_mOpenCL, "UNSIGNED_INT16", ULONG2NUM(CL_UNSIGNED_INT16));
  rb_define_const(rb_mOpenCL, "UNSIGNED_INT32", ULONG2NUM(CL_UNSIGNED_INT32));
  rb_define_const(rb_mOpenCL, "HALF_FLOAT", ULONG2NUM(CL_HALF_FLOAT));
  rb_define_const(rb_mOpenCL, "FLOAT", ULONG2NUM(CL_FLOAT));
  rb_define_const(rb_mOpenCL, "PROFILING_COMMAND_QUEUED", ULONG2NUM(CL_PROFILING_COMMAND_QUEUED));
  rb_define_const(rb_mOpenCL, "PROFILING_COMMAND_SUBMIT", ULONG2NUM(CL_PROFILING_COMMAND_SUBMIT));
  rb_define_const(rb_mOpenCL, "PROFILING_COMMAND_START", ULONG2NUM(CL_PROFILING_COMMAND_START));
  rb_define_const(rb_mOpenCL, "PROFILING_COMMAND_END", ULONG2NUM(CL_PROFILING_COMMAND_END));
  rb_define_const(rb_mOpenCL, "BUILD_SUCCESS", INT2NUM(CL_BUILD_SUCCESS));
  rb_define_const(rb_mOpenCL, "BUILD_NONE", INT2NUM(CL_BUILD_NONE));
  rb_define_const(rb_mOpenCL, "BUILD_ERROR", INT2NUM(CL_BUILD_ERROR));
  rb_define_const(rb_mOpenCL, "BUILD_IN_PROGRESS", INT2NUM(CL_BUILD_IN_PROGRESS));
  rb_define_const(rb_mOpenCL, "MAP_READ", ULONG2NUM(CL_MAP_READ));
  rb_define_const(rb_mOpenCL, "MAP_WRITE", ULONG2NUM(CL_MAP_WRITE));
  rb_define_const(rb_mOpenCL, "SUCCESS", INT2NUM(CL_SUCCESS));
  rb_define_const(rb_mOpenCL, "DEVICE_NOT_FOUND", INT2NUM(CL_DEVICE_NOT_FOUND));
  rb_define_const(rb_mOpenCL, "DEVICE_NOT_AVAILABLE", INT2NUM(CL_DEVICE_NOT_AVAILABLE));
  rb_define_const(rb_mOpenCL, "DEVICE_COMPILER_NOT_AVAILABLE", INT2NUM(CL_DEVICE_COMPILER_NOT_AVAILABLE));
  rb_define_const(rb_mOpenCL, "MEM_OBJECT_ALLOCATION_FAILURE", INT2NUM(CL_MEM_OBJECT_ALLOCATION_FAILURE));
  rb_define_const(rb_mOpenCL, "OUT_OF_RESOURCES", INT2NUM(CL_OUT_OF_RESOURCES));
  rb_define_const(rb_mOpenCL, "OUT_OF_HOST_MEMORY", INT2NUM(CL_OUT_OF_HOST_MEMORY));
  rb_define_const(rb_mOpenCL, "PROFILING_INFO_NOT_AVAILABLE", INT2NUM(CL_PROFILING_INFO_NOT_AVAILABLE));
  rb_define_const(rb_mOpenCL, "MEM_COPY_OVERLAP", INT2NUM(CL_MEM_COPY_OVERLAP));
  rb_define_const(rb_mOpenCL, "IMAGE_FORMAT_MISMATCH", INT2NUM(CL_IMAGE_FORMAT_MISMATCH));
  rb_define_const(rb_mOpenCL, "IMAGE_FORMAT_NOT_SUPPORTED", INT2NUM(CL_IMAGE_FORMAT_NOT_SUPPORTED));
  rb_define_const(rb_mOpenCL, "BUILD_PROGRAM_FAILURE", INT2NUM(CL_BUILD_PROGRAM_FAILURE));
  rb_define_const(rb_mOpenCL, "MAP_FAILURE", INT2NUM(CL_MAP_FAILURE));
  rb_define_const(rb_mOpenCL, "INVALID_VALUE", INT2NUM(CL_INVALID_VALUE));
  rb_define_const(rb_mOpenCL, "INVALID_DEVICE_TYPE", INT2NUM(CL_INVALID_DEVICE_TYPE));
  rb_define_const(rb_mOpenCL, "INVALID_PLATFORM", INT2NUM(CL_INVALID_PLATFORM));
  rb_define_const(rb_mOpenCL, "INVALID_DEVICE", INT2NUM(CL_INVALID_DEVICE));
  rb_define_const(rb_mOpenCL, "INVALID_CONTEXT", INT2NUM(CL_INVALID_CONTEXT));
  rb_define_const(rb_mOpenCL, "INVALID_QUEUE_PROPERTIES", INT2NUM(CL_INVALID_QUEUE_PROPERTIES));
  rb_define_const(rb_mOpenCL, "INVALID_COMMAND_QUEUE", INT2NUM(CL_INVALID_COMMAND_QUEUE));
  rb_define_const(rb_mOpenCL, "INVALID_HOST_PTR", INT2NUM(CL_INVALID_HOST_PTR));
  rb_define_const(rb_mOpenCL, "INVALID_MEM_OBJECT", INT2NUM(CL_INVALID_MEM_OBJECT));
  rb_define_const(rb_mOpenCL, "INVALID_IMAGE_FORMAT_DESCRIPTOR", INT2NUM(CL_INVALID_IMAGE_FORMAT_DESCRIPTOR));
  rb_define_const(rb_mOpenCL, "INVALID_IMAGE_SIZE", INT2NUM(CL_INVALID_IMAGE_SIZE));
  rb_define_const(rb_mOpenCL, "INVALID_SAMPLER", INT2NUM(CL_INVALID_SAMPLER));
  rb_define_const(rb_mOpenCL, "INVALID_BINARY", INT2NUM(CL_INVALID_BINARY));
  rb_define_const(rb_mOpenCL, "INVALID_BUILD_OPTIONS", INT2NUM(CL_INVALID_BUILD_OPTIONS));
  rb_define_const(rb_mOpenCL, "INVALID_PROGRAM", INT2NUM(CL_INVALID_PROGRAM));
  rb_define_const(rb_mOpenCL, "INVALID_PROGRAM_EXECUTABLE", INT2NUM(CL_INVALID_PROGRAM_EXECUTABLE));
  rb_define_const(rb_mOpenCL, "INVALID_KERNEL_NAME", INT2NUM(CL_INVALID_KERNEL_NAME));
  rb_define_const(rb_mOpenCL, "INVALID_KERNEL_DEFINITION", INT2NUM(CL_INVALID_KERNEL_DEFINITION));
  rb_define_const(rb_mOpenCL, "INVALID_KERNEL", INT2NUM(CL_INVALID_KERNEL));
  rb_define_const(rb_mOpenCL, "INVALID_ARG_INDEX", INT2NUM(CL_INVALID_ARG_INDEX));
  rb_define_const(rb_mOpenCL, "INVALID_ARG_VALUE", INT2NUM(CL_INVALID_ARG_VALUE));
  rb_define_const(rb_mOpenCL, "INVALID_ARG_SIZE", INT2NUM(CL_INVALID_ARG_SIZE));
  rb_define_const(rb_mOpenCL, "INVALID_KERNEL_ARGS", INT2NUM(CL_INVALID_KERNEL_ARGS));
  rb_define_const(rb_mOpenCL, "INVALID_WORK_DIMENSION", INT2NUM(CL_INVALID_WORK_DIMENSION));
  rb_define_const(rb_mOpenCL, "INVALID_WORK_GROUP_SIZE", INT2NUM(CL_INVALID_WORK_GROUP_SIZE));
  rb_define_const(rb_mOpenCL, "INVALID_WORK_ITEM_SIZE", INT2NUM(CL_INVALID_WORK_ITEM_SIZE));
  rb_define_const(rb_mOpenCL, "INVALID_GLOBAL_OFFSET", INT2NUM(CL_INVALID_GLOBAL_OFFSET));
  rb_define_const(rb_mOpenCL, "INVALID_EVENT_WAIT_LIST", INT2NUM(CL_INVALID_EVENT_WAIT_LIST));
  rb_define_const(rb_mOpenCL, "INVALID_EVENT", INT2NUM(CL_INVALID_EVENT));
  rb_define_const(rb_mOpenCL, "INVALID_OPERATION", INT2NUM(CL_INVALID_OPERATION));
  rb_define_const(rb_mOpenCL, "INVALID_GL_OBJECT", INT2NUM(CL_INVALID_GL_OBJECT));
  rb_define_const(rb_mOpenCL, "INVALID_BUFFER_SIZE", INT2NUM(CL_INVALID_BUFFER_SIZE));
  rb_define_const(rb_mOpenCL, "INVALID_MIP_LEVEL", INT2NUM(CL_INVALID_MIP_LEVEL));
  rb_define_const(rb_mOpenCL, "COMPLETE", ULONG2NUM(CL_COMPLETE));
  rb_define_const(rb_mOpenCL, "RUNNING", ULONG2NUM(CL_RUNNING));
  rb_define_const(rb_mOpenCL, "SUBMITTED", ULONG2NUM(CL_SUBMITTED));
  rb_define_const(rb_mOpenCL, "QUEUED", ULONG2NUM(CL_QUEUED));
  rb_define_const(rb_mOpenCL, "ADDRESS_NONE", ULONG2NUM(CL_ADDRESS_NONE));
  rb_define_const(rb_mOpenCL, "ADDRESS_CLAMP_TO_EDGE", ULONG2NUM(CL_ADDRESS_CLAMP_TO_EDGE));
  rb_define_const(rb_mOpenCL, "ADDRESS_CLAMP", ULONG2NUM(CL_ADDRESS_CLAMP));
  rb_define_const(rb_mOpenCL, "ADDRESS_REPEAT", ULONG2NUM(CL_ADDRESS_REPEAT));
  rb_define_const(rb_mOpenCL, "R", ULONG2NUM(CL_R));
  rb_define_const(rb_mOpenCL, "A", ULONG2NUM(CL_A));
  rb_define_const(rb_mOpenCL, "RG", ULONG2NUM(CL_RG));
  rb_define_const(rb_mOpenCL, "RA", ULONG2NUM(CL_RA));
  rb_define_const(rb_mOpenCL, "RGB", ULONG2NUM(CL_RGB));
  rb_define_const(rb_mOpenCL, "RGBA", ULONG2NUM(CL_RGBA));
  rb_define_const(rb_mOpenCL, "BGRA", ULONG2NUM(CL_BGRA));
  rb_define_const(rb_mOpenCL, "ARGB", ULONG2NUM(CL_ARGB));
  rb_define_const(rb_mOpenCL, "INTENSITY", ULONG2NUM(CL_INTENSITY));
  rb_define_const(rb_mOpenCL, "LUMINANCE", ULONG2NUM(CL_LUMINANCE));

  // rb_cPlatform
  rb_define_const(rb_cPlatform, "PROFILE", ULONG2NUM(CL_PLATFORM_PROFILE));
  rb_define_const(rb_cPlatform, "VERSION", ULONG2NUM(CL_PLATFORM_VERSION));
  rb_define_const(rb_cPlatform, "NAME", ULONG2NUM(CL_PLATFORM_NAME));
  rb_define_const(rb_cPlatform, "VENDOR", ULONG2NUM(CL_PLATFORM_VENDOR));

  // rb_cDevice
  rb_define_const(rb_cDevice, "LOCAL", ULONG2NUM(CL_LOCAL));
  rb_define_const(rb_cDevice, "GLOBAL", ULONG2NUM(CL_GLOBAL));
  rb_define_const(rb_cDevice, "ADDRESS_32_BITS", ULONG2NUM(CL_DEVICE_ADDRESS_32_BITS));
  rb_define_const(rb_cDevice, "ADDRESS_64_BITS", ULONG2NUM(CL_DEVICE_ADDRESS_64_BITS));
  rb_define_const(rb_cDevice, "TYPE", ULONG2NUM(CL_DEVICE_TYPE));
  rb_define_const(rb_cDevice, "VENDOR_ID", ULONG2NUM(CL_DEVICE_VENDOR_ID));
  rb_define_const(rb_cDevice, "MAX_COMPUTE_UNITS", ULONG2NUM(CL_DEVICE_MAX_COMPUTE_UNITS));
  rb_define_const(rb_cDevice, "MAX_WORK_ITEM_DIMENSIONS", ULONG2NUM(CL_DEVICE_MAX_WORK_ITEM_DIMENSIONS));
  rb_define_const(rb_cDevice, "MAX_WORK_GROUP_SIZE", ULONG2NUM(CL_DEVICE_MAX_WORK_GROUP_SIZE));
  rb_define_const(rb_cDevice, "MAX_WORK_ITEM_SIZES", ULONG2NUM(CL_DEVICE_MAX_WORK_ITEM_SIZES));
  rb_define_const(rb_cDevice, "PREFERRED_VECTOR_WIDTH_CHAR", ULONG2NUM(CL_DEVICE_PREFERRED_VECTOR_WIDTH_CHAR));
  rb_define_const(rb_cDevice, "PREFERRED_VECTOR_WIDTH_SHORT", ULONG2NUM(CL_DEVICE_PREFERRED_VECTOR_WIDTH_SHORT));
  rb_define_const(rb_cDevice, "PREFERRED_VECTOR_WIDTH_INT", ULONG2NUM(CL_DEVICE_PREFERRED_VECTOR_WIDTH_INT));
  rb_define_const(rb_cDevice, "PREFERRED_VECTOR_WIDTH_LONG", ULONG2NUM(CL_DEVICE_PREFERRED_VECTOR_WIDTH_LONG));
  rb_define_const(rb_cDevice, "PREFERRED_VECTOR_WIDTH_FLOAT", ULONG2NUM(CL_DEVICE_PREFERRED_VECTOR_WIDTH_FLOAT));
  rb_define_const(rb_cDevice, "PREFERRED_VECTOR_WIDTH_DOUBLE", ULONG2NUM(CL_DEVICE_PREFERRED_VECTOR_WIDTH_DOUBLE));
  rb_define_const(rb_cDevice, "MAX_CLOCK_FREQUENCY", ULONG2NUM(CL_DEVICE_MAX_CLOCK_FREQUENCY));
  rb_define_const(rb_cDevice, "ADDRESS_BITS", ULONG2NUM(CL_DEVICE_ADDRESS_BITS));
  rb_define_const(rb_cDevice, "MAX_READ_IMAGE_ARGS", ULONG2NUM(CL_DEVICE_MAX_READ_IMAGE_ARGS));
  rb_define_const(rb_cDevice, "MAX_WRITE_IMAGE_ARGS", ULONG2NUM(CL_DEVICE_MAX_WRITE_IMAGE_ARGS));
  rb_define_const(rb_cDevice, "MAX_MEM_ALLOC_SIZE", ULONG2NUM(CL_DEVICE_MAX_MEM_ALLOC_SIZE));
  rb_define_const(rb_cDevice, "IMAGE2D_MAX_WIDTH", ULONG2NUM(CL_DEVICE_IMAGE2D_MAX_WIDTH));
  rb_define_const(rb_cDevice, "IMAGE2D_MAX_HEIGHT", ULONG2NUM(CL_DEVICE_IMAGE2D_MAX_HEIGHT));
  rb_define_const(rb_cDevice, "IMAGE3D_MAX_WIDTH", ULONG2NUM(CL_DEVICE_IMAGE3D_MAX_WIDTH));
  rb_define_const(rb_cDevice, "IMAGE3D_MAX_HEIGHT", ULONG2NUM(CL_DEVICE_IMAGE3D_MAX_HEIGHT));
  rb_define_const(rb_cDevice, "IMAGE3D_MAX_DEPTH", ULONG2NUM(CL_DEVICE_IMAGE3D_MAX_DEPTH));
  rb_define_const(rb_cDevice, "IMAGE_SUPPORT", ULONG2NUM(CL_DEVICE_IMAGE_SUPPORT));
  rb_define_const(rb_cDevice, "MAX_PARAMETER_SIZE", ULONG2NUM(CL_DEVICE_MAX_PARAMETER_SIZE));
  rb_define_const(rb_cDevice, "MAX_SAMPLERS", ULONG2NUM(CL_DEVICE_MAX_SAMPLERS));
  rb_define_const(rb_cDevice, "MEM_BASE_ADDR_ALIGN", ULONG2NUM(CL_DEVICE_MEM_BASE_ADDR_ALIGN));
  rb_define_const(rb_cDevice, "MIN_DATA_TYPE_ALIGN_SIZE", ULONG2NUM(CL_DEVICE_MIN_DATA_TYPE_ALIGN_SIZE));
  rb_define_const(rb_cDevice, "SINGLE_FP_CONFIG", ULONG2NUM(CL_DEVICE_SINGLE_FP_CONFIG));
  rb_define_const(rb_cDevice, "GLOBAL_MEM_CACHE_TYPE", ULONG2NUM(CL_DEVICE_GLOBAL_MEM_CACHE_TYPE));
  rb_define_const(rb_cDevice, "GLOBAL_MEM_CACHELINE_SIZE", ULONG2NUM(CL_DEVICE_GLOBAL_MEM_CACHELINE_SIZE));
  rb_define_const(rb_cDevice, "GLOBAL_MEM_CACHE_SIZE", ULONG2NUM(CL_DEVICE_GLOBAL_MEM_CACHE_SIZE));
  rb_define_const(rb_cDevice, "GLOBAL_MEM_SIZE", ULONG2NUM(CL_DEVICE_GLOBAL_MEM_SIZE));
  rb_define_const(rb_cDevice, "MAX_CONSTANT_BUFFER_SIZE", ULONG2NUM(CL_DEVICE_MAX_CONSTANT_BUFFER_SIZE));
  rb_define_const(rb_cDevice, "MAX_CONSTANT_ARGS", ULONG2NUM(CL_DEVICE_MAX_CONSTANT_ARGS));
  rb_define_const(rb_cDevice, "LOCAL_MEM_TYPE", ULONG2NUM(CL_DEVICE_LOCAL_MEM_TYPE));
  rb_define_const(rb_cDevice, "LOCAL_MEM_SIZE", ULONG2NUM(CL_DEVICE_LOCAL_MEM_SIZE));
  rb_define_const(rb_cDevice, "ERROR_CORRECTION_SUPPORT", ULONG2NUM(CL_DEVICE_ERROR_CORRECTION_SUPPORT));
  rb_define_const(rb_cDevice, "PROFILING_TIMER_RESOLUTION", ULONG2NUM(CL_DEVICE_PROFILING_TIMER_RESOLUTION));
  rb_define_const(rb_cDevice, "ENDIAN_LITTLE", ULONG2NUM(CL_DEVICE_ENDIAN_LITTLE));
  rb_define_const(rb_cDevice, "AVAILABLE", ULONG2NUM(CL_DEVICE_AVAILABLE));
  rb_define_const(rb_cDevice, "COMPILER_AVAILABLE", ULONG2NUM(CL_DEVICE_COMPILER_AVAILABLE));
  rb_define_const(rb_cDevice, "EXECUTION_CAPABILITIES", ULONG2NUM(CL_DEVICE_EXECUTION_CAPABILITIES));
  rb_define_const(rb_cDevice, "QUEUE_PROPERTIES", ULONG2NUM(CL_DEVICE_QUEUE_PROPERTIES));
  rb_define_const(rb_cDevice, "NAME", ULONG2NUM(CL_DEVICE_NAME));
  rb_define_const(rb_cDevice, "VENDOR", ULONG2NUM(CL_DEVICE_VENDOR));
  rb_define_const(rb_cDevice, "DRIVER_VERSION", ULONG2NUM(CL_DRIVER_VERSION));
  rb_define_const(rb_cDevice, "PROFILE", ULONG2NUM(CL_DEVICE_PROFILE));
  rb_define_const(rb_cDevice, "VERSION", ULONG2NUM(CL_DEVICE_VERSION));
  rb_define_const(rb_cDevice, "EXTENSIONS", ULONG2NUM(CL_DEVICE_EXTENSIONS));
  rb_define_const(rb_cDevice, "PLATFORM", ULONG2NUM(CL_DEVICE_PLATFORM));
  rb_define_const(rb_cDevice, "EXEC_KERNEL", ULONG2NUM(CL_EXEC_KERNEL));
  rb_define_const(rb_cDevice, "EXEC_NATIVE_KERNEL", ULONG2NUM(CL_EXEC_NATIVE_KERNEL));
  rb_define_const(rb_cDevice, "TYPE_DEFAULT", ULONG2NUM(CL_DEVICE_TYPE_DEFAULT));
  rb_define_const(rb_cDevice, "TYPE_CPU", ULONG2NUM(CL_DEVICE_TYPE_CPU));
  rb_define_const(rb_cDevice, "TYPE_GPU", ULONG2NUM(CL_DEVICE_TYPE_GPU));
  rb_define_const(rb_cDevice, "TYPE_ACCELERATOR", ULONG2NUM(CL_DEVICE_TYPE_ACCELERATOR));
  rb_define_const(rb_cDevice, "TYPE_ALL", ULONG2NUM(CL_DEVICE_TYPE_ALL));
  rb_define_const(rb_cDevice, "NONE", ULONG2NUM(CL_NONE));
  rb_define_const(rb_cDevice, "READ_ONLY_CACHE", ULONG2NUM(CL_READ_ONLY_CACHE));
  rb_define_const(rb_cDevice, "READ_WRITE_CACHE", ULONG2NUM(CL_READ_WRITE_CACHE));
  rb_define_const(rb_cDevice, "FP_DENORM", ULONG2NUM(CL_FP_DENORM));
  rb_define_const(rb_cDevice, "FP_INF_NAN", ULONG2NUM(CL_FP_INF_NAN));
  rb_define_const(rb_cDevice, "FP_ROUND_TO_NEAREST", ULONG2NUM(CL_FP_ROUND_TO_NEAREST));
  rb_define_const(rb_cDevice, "FP_ROUND_TO_ZERO", ULONG2NUM(CL_FP_ROUND_TO_ZERO));
  rb_define_const(rb_cDevice, "FP_ROUND_TO_INF", ULONG2NUM(CL_FP_ROUND_TO_INF));
  rb_define_const(rb_cDevice, "FP_FMA", ULONG2NUM(CL_FP_FMA));

  // rb_cContext
  rb_define_const(rb_cContext, "REFERENCE_COUNT", ULONG2NUM(CL_CONTEXT_REFERENCE_COUNT));
  rb_define_const(rb_cContext, "NUM_DEVICES", ULONG2NUM(CL_CONTEXT_NUM_DEVICES));
  rb_define_const(rb_cContext, "DEVICES", ULONG2NUM(CL_CONTEXT_DEVICES));
  rb_define_const(rb_cContext, "PROPERTIES", ULONG2NUM(CL_CONTEXT_PROPERTIES));
  rb_define_const(rb_cContext, "PLATFORM", ULONG2NUM(CL_CONTEXT_PLATFORM));

  // rb_cCommandQueue
  rb_define_const(rb_cCommandQueue, "QUEUE_OUT_OF_ORDER_EXEC_MODE_ENABLE", ULONG2NUM(CL_QUEUE_OUT_OF_ORDER_EXEC_MODE_ENABLE));
  rb_define_const(rb_cCommandQueue, "QUEUE_PROFILING_ENABLE", ULONG2NUM(CL_QUEUE_PROFILING_ENABLE));
  rb_define_const(rb_cCommandQueue, "QUEUE_CONTEXT", ULONG2NUM(CL_QUEUE_CONTEXT));
  rb_define_const(rb_cCommandQueue, "QUEUE_DEVICE", ULONG2NUM(CL_QUEUE_DEVICE));
  rb_define_const(rb_cCommandQueue, "QUEUE_REFERENCE_COUNT", ULONG2NUM(CL_QUEUE_REFERENCE_COUNT));
  rb_define_const(rb_cCommandQueue, "QUEUE_PROPERTIES", ULONG2NUM(CL_QUEUE_PROPERTIES));

  // rb_cMem
  rb_define_const(rb_cMem, "READ_WRITE", ULONG2NUM(CL_MEM_READ_WRITE));
  rb_define_const(rb_cMem, "WRITE_ONLY", ULONG2NUM(CL_MEM_WRITE_ONLY));
  rb_define_const(rb_cMem, "READ_ONLY", ULONG2NUM(CL_MEM_READ_ONLY));
  rb_define_const(rb_cMem, "USE_HOST_PTR", ULONG2NUM(CL_MEM_USE_HOST_PTR));
  rb_define_const(rb_cMem, "ALLOC_HOST_PTR", ULONG2NUM(CL_MEM_ALLOC_HOST_PTR));
  rb_define_const(rb_cMem, "COPY_HOST_PTR", ULONG2NUM(CL_MEM_COPY_HOST_PTR));
  rb_define_const(rb_cMem, "TYPE", ULONG2NUM(CL_MEM_TYPE));
  rb_define_const(rb_cMem, "FLAGS", ULONG2NUM(CL_MEM_FLAGS));
  rb_define_const(rb_cMem, "SIZE", ULONG2NUM(CL_MEM_SIZE));
  rb_define_const(rb_cMem, "HOST_PTR", ULONG2NUM(CL_MEM_HOST_PTR));
  rb_define_const(rb_cMem, "MAP_COUNT", ULONG2NUM(CL_MEM_MAP_COUNT));
  rb_define_const(rb_cMem, "REFERENCE_COUNT", ULONG2NUM(CL_MEM_REFERENCE_COUNT));
  rb_define_const(rb_cMem, "CONTEXT", ULONG2NUM(CL_MEM_CONTEXT));
  rb_define_const(rb_cMem, "OBJECT_BUFFER", ULONG2NUM(CL_MEM_OBJECT_BUFFER));
  rb_define_const(rb_cMem, "OBJECT_IMAGE2D", ULONG2NUM(CL_MEM_OBJECT_IMAGE2D));
  rb_define_const(rb_cMem, "OBJECT_IMAGE3D", ULONG2NUM(CL_MEM_OBJECT_IMAGE3D));

  // rb_cImage
  rb_define_const(rb_cImage, "FORMAT", ULONG2NUM(CL_IMAGE_FORMAT));
  rb_define_const(rb_cImage, "ELEMENT_SIZE", ULONG2NUM(CL_IMAGE_ELEMENT_SIZE));
  rb_define_const(rb_cImage, "ROW_PITCH", ULONG2NUM(CL_IMAGE_ROW_PITCH));
  rb_define_const(rb_cImage, "SLICE_PITCH", ULONG2NUM(CL_IMAGE_SLICE_PITCH));
  rb_define_const(rb_cImage, "WIDTH", ULONG2NUM(CL_IMAGE_WIDTH));
  rb_define_const(rb_cImage, "HEIGHT", ULONG2NUM(CL_IMAGE_HEIGHT));
  rb_define_const(rb_cImage, "DEPTH", ULONG2NUM(CL_IMAGE_DEPTH));

  // rb_cSampler
  rb_define_const(rb_cSampler, "REFERENCE_COUNT", ULONG2NUM(CL_SAMPLER_REFERENCE_COUNT));
  rb_define_const(rb_cSampler, "CONTEXT", ULONG2NUM(CL_SAMPLER_CONTEXT));
  rb_define_const(rb_cSampler, "NORMALIZED_COORDS", ULONG2NUM(CL_SAMPLER_NORMALIZED_COORDS));
  rb_define_const(rb_cSampler, "ADDRESSING_MODE", ULONG2NUM(CL_SAMPLER_ADDRESSING_MODE));
  rb_define_const(rb_cSampler, "FILTER_MODE", ULONG2NUM(CL_SAMPLER_FILTER_MODE));

  // rb_cProgram
  rb_define_const(rb_cProgram, "BUILD_STATUS", ULONG2NUM(CL_PROGRAM_BUILD_STATUS));
  rb_define_const(rb_cProgram, "BUILD_OPTIONS", ULONG2NUM(CL_PROGRAM_BUILD_OPTIONS));
  rb_define_const(rb_cProgram, "BUILD_LOG", ULONG2NUM(CL_PROGRAM_BUILD_LOG));
  rb_define_const(rb_cProgram, "REFERENCE_COUNT", ULONG2NUM(CL_PROGRAM_REFERENCE_COUNT));
  rb_define_const(rb_cProgram, "CONTEXT", ULONG2NUM(CL_PROGRAM_CONTEXT));
  rb_define_const(rb_cProgram, "NUM_DEVICES", ULONG2NUM(CL_PROGRAM_NUM_DEVICES));
  rb_define_const(rb_cProgram, "DEVICES", ULONG2NUM(CL_PROGRAM_DEVICES));
  rb_define_const(rb_cProgram, "SOURCE", ULONG2NUM(CL_PROGRAM_SOURCE));
  rb_define_const(rb_cProgram, "BINARY_SIZES", ULONG2NUM(CL_PROGRAM_BINARY_SIZES));
  rb_define_const(rb_cProgram, "BINARIES", ULONG2NUM(CL_PROGRAM_BINARIES));

  // rb_cKernel
  rb_define_const(rb_cKernel, "WORK_GROUP_SIZE", ULONG2NUM(CL_KERNEL_WORK_GROUP_SIZE));
  rb_define_const(rb_cKernel, "COMPILE_WORK_GROUP_SIZE", ULONG2NUM(CL_KERNEL_COMPILE_WORK_GROUP_SIZE));
  rb_define_const(rb_cKernel, "FUNCTION_NAME", ULONG2NUM(CL_KERNEL_FUNCTION_NAME));
  rb_define_const(rb_cKernel, "NUM_ARGS", ULONG2NUM(CL_KERNEL_NUM_ARGS));
  rb_define_const(rb_cKernel, "REFERENCE_COUNT", ULONG2NUM(CL_KERNEL_REFERENCE_COUNT));
  rb_define_const(rb_cKernel, "CONTEXT", ULONG2NUM(CL_KERNEL_CONTEXT));
  rb_define_const(rb_cKernel, "PROGRAM", ULONG2NUM(CL_KERNEL_PROGRAM));

  // rb_cEvent
  rb_define_const(rb_cEvent, "COMMAND_QUEUE", ULONG2NUM(CL_EVENT_COMMAND_QUEUE));
  rb_define_const(rb_cEvent, "COMMAND_TYPE", ULONG2NUM(CL_EVENT_COMMAND_TYPE));
  rb_define_const(rb_cEvent, "REFERENCE_COUNT", ULONG2NUM(CL_EVENT_REFERENCE_COUNT));
  rb_define_const(rb_cEvent, "COMMAND_EXECUTION_STATUS", ULONG2NUM(CL_EVENT_COMMAND_EXECUTION_STATUS));

  rb_define_method(rb_cCommandQueue, "enqueue_map_buffer", rb_clEnqueueMapBuffer, -1);
  rb_define_method(rb_cCommandQueue, "enqueue_copy_image", rb_clEnqueueCopyImage, -1);
  rb_define_method(rb_cKernel, "get_work_group_info", rb_clGetKernelWorkGroupInfo, -1);
  rb_define_method(rb_cKernel, "set_arg", rb_clSetKernelArg, -1);
  rb_define_singleton_method(rb_cImage3D, "new", rb_clCreateImage3D, -1);
  rb_define_singleton_method(rb_cCommandQueue, "new", rb_clCreateCommandQueue, -1);
  rb_define_method(rb_cCommandQueue, "enqueue_native_kernel", rb_clEnqueueNativeKernel, -1);
  rb_define_method(rb_cCommandQueue, "enqueue_map_image", rb_clEnqueueMapImage, -1);
  rb_define_singleton_method(rb_cImage2D, "new", rb_clCreateImage2D, -1);
  rb_define_method(rb_cCommandQueue, "get_info", rb_clGetCommandQueueInfo, -1);
  rb_define_method(rb_cCommandQueue, "enqueue_copy_image_to_buffer", rb_clEnqueueCopyImageToBuffer, -1);
  rb_define_singleton_method(rb_cKernel, "new", rb_clCreateKernel, -1);
  rb_define_method(rb_cProgram, "build", rb_clBuildProgram, -1);
  rb_define_method(rb_cSampler, "get_info", rb_clGetSamplerInfo, -1);
  rb_define_method(rb_cContext, "get_supported_image_formats", rb_clGetSupportedImageFormats, -1);
  rb_define_method(rb_cCommandQueue, "set_property", rb_clSetCommandQueueProperty, -1);
  rb_define_singleton_method(rb_cPlatform, "get_platforms", rb_clGetPlatformIDs, -1);
  rb_define_method(rb_cCommandQueue, "enqueue_marker", rb_clEnqueueMarker, -1);
  rb_define_method(rb_cProgram, "create_kernels", rb_clCreateKernelsInProgram, -1);
  rb_define_singleton_method(rb_cContext, "new", rb_clCreateContext, -1);
  rb_define_method(rb_cCommandQueue, "enqueue_task", rb_clEnqueueTask, -1);
  rb_define_method(rb_cCommandQueue, "enqueue_write_buffer", rb_clEnqueueWriteBuffer, -1);
  rb_define_singleton_method(rb_cEvent, "wait", rb_clWaitForEvents, -1);
  rb_define_method(rb_cContext, "create_program_with_source", rb_clCreateProgramWithSource, -1);
  rb_define_method(rb_cCommandQueue, "enqueue_n_d_range_kernel", rb_clEnqueueNDRangeKernel, -1);
  rb_define_method(rb_cCommandQueue, "enqueue_copy_buffer_to_image", rb_clEnqueueCopyBufferToImage, -1);
  rb_define_method(rb_cCommandQueue, "enqueue_write_image", rb_clEnqueueWriteImage, -1);
  rb_define_method(rb_cEvent, "get_info", rb_clGetEventInfo, -1);
  rb_define_method(rb_cProgram, "get_build_info", rb_clGetProgramBuildInfo, -1);
  rb_define_method(rb_cCommandQueue, "enqueue_barrier", rb_clEnqueueBarrier, -1);
  rb_define_method(rb_cCommandQueue, "enqueue_read_image", rb_clEnqueueReadImage, -1);
  rb_define_method(rb_cKernel, "get_info", rb_clGetKernelInfo, -1);
  rb_define_module_function(rb_mOpenCL, "get_image_info", rb_clGetImageInfo, -1);
  rb_define_method(rb_cDevice, "get_info", rb_clGetDeviceInfo, -1);
  rb_define_method(rb_cCommandQueue, "enqueue_wait_for_events", rb_clEnqueueWaitForEvents, -1);
  rb_define_method(rb_cEvent, "get_profiling_info", rb_clGetEventProfilingInfo, -1);
  rb_define_module_function(rb_mOpenCL, "unload_compiler", rb_clUnloadCompiler, -1);
  rb_define_singleton_method(rb_cSampler, "new", rb_clCreateSampler, -1);
  rb_define_singleton_method(rb_cContext, "new", rb_clCreateContextFromType, -1);
  rb_define_method(rb_cPlatform, "get_info", rb_clGetPlatformInfo, -1);
  rb_define_method(rb_cCommandQueue, "enqueue_unmap_mem_object", rb_clEnqueueUnmapMemObject, -1);
  rb_define_method(rb_cCommandQueue, "enqueue_copy_buffer", rb_clEnqueueCopyBuffer, -1);
  rb_define_method(rb_cCommandQueue, "flush", rb_clFlush, -1);
  rb_define_method(rb_cProgram, "get_info", rb_clGetProgramInfo, -1);
  rb_define_singleton_method(rb_cBuffer, "new", rb_clCreateBuffer, -1);
  rb_define_method(rb_cContext, "get_info", rb_clGetContextInfo, -1);
  rb_define_method(rb_cCommandQueue, "enqueue_read_buffer", rb_clEnqueueReadBuffer, -1);
  rb_define_method(rb_cCommandQueue, "finish", rb_clFinish, -1);
  rb_define_method(rb_cContext, "create_program_with_binary", rb_clCreateProgramWithBinary, -1);
  rb_define_method(rb_cMem, "get_object_info", rb_clGetMemObjectInfo, -1);
  rb_define_singleton_method(rb_cDevice, "get_devices", rb_clGetDeviceIDs, -1);
  rb_define_singleton_method(rb_cImageFormat, "new", rb_CreateImageFormat, -1);
  rb_define_method(rb_cImageFormat, "image_channel_order", rb_GetImageFormatImageChannelOrder, -1);
  rb_define_method(rb_cImageFormat, "image_channel_data_type", rb_GetImageFormatImageChannelDataType, -1);
}

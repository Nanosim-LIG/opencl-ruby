require 'ffi'

module OpenCL
  extend FFI::Library
  ffi_lib "libOpenCL.so"
  #:stopdoc:
  SUCCESS = 0
  DEVICE_NOT_FOUND = -1
  DEVICE_NOT_AVAILABLE = -2
  COMPILER_NOT_AVAILABLE = -3
  MEM_OBJECT_ALLOCATION_FAILURE = -4
  OUT_OF_RESOURCES = -5
  OUT_OF_HOST_MEMORY = -6
  PROFILING_INFO_NOT_AVAILABLE = -7
  MEM_COPY_OVERLAP = -8
  IMAGE_FORMAT_MISMATCH = -9
  IMAGE_FORMAT_NOT_SUPPORTED = -10
  BUILD_PROGRAM_FAILURE = -11
  MAP_FAILURE = -12
  MISALIGNED_SUB_BUFFER_OFFSET = -13
  EXEC_STATUS_ERROR_FOR_EVENTS_IN_WAIT_LIST = -14
  COMPILE_PROGRAM_FAILURE = -15
  LINKER_NOT_AVAILABLE = -16
  LINK_PROGRAM_FAILURE = -17
  DEVICE_PARTITION_FAILED = -18
  KERNEL_ARG_INFO_NOT_AVAILABLE = -19
  INVALID_VALUE = -30
  INVALID_DEVICE_TYPE = -31
  INVALID_PLATFORM = -32
  INVALID_DEVICE = -33
  INVALID_CONTEXT = -34
  INVALID_QUEUE_PROPERTIES = -35
  INVALID_COMMAND_QUEUE = -36
  INVALID_HOST_PTR = -37
  INVALID_MEM_OBJECT = -38
  INVALID_IMAGE_FORMAT_DESCRIPTOR = -39
  INVALID_IMAGE_SIZE = -40
  INVALID_SAMPLER = -41
  INVALID_BINARY = -42
  INVALID_BUILD_OPTIONS = -43
  INVALID_PROGRAM = -44
  INVALID_PROGRAM_EXECUTABLE = -45
  INVALID_KERNEL_NAME = -46
  INVALID_KERNEL_DEFINITION = -47
  INVALID_KERNEL = -48
  INVALID_ARG_INDEX = -49
  INVALID_ARG_VALUE = -50
  INVALID_ARG_SIZE = -51
  INVALID_KERNEL_ARGS = -52
  INVALID_WORK_DIMENSION = -53
  INVALID_WORK_GROUP_SIZE = -54
  INVALID_WORK_ITEM_SIZE = -55
  INVALID_GLOBAL_OFFSET = -56
  INVALID_EVENT_WAIT_LIST = -57
  INVALID_EVENT = -58
  INVALID_OPERATION = -59
  INVALID_GL_OBJECT = -60
  INVALID_BUFFER_SIZE = -61
  INVALID_MIP_LEVEL = -62
  INVALID_GLOBAL_WORK_SIZE = -63
  INVALID_PROPERTY = -64
  INVALID_IMAGE_DESCRIPTOR = -65
  INVALID_COMPILER_OPTIONS = -66
  INVALID_LINKER_OPTIONS = -67
  INVALID_DEVICE_PARTITION_COUNT = -68
  VERSION_1_0 = 1
  VERSION_1_1 = 1
  VERSION_1_2 = 1
  FALSE = 0
  TRUE = 1
  BLOCKING = TRUE
  NON_BLOCKING = FALSE
  PLATFORM_PROFILE = 0x0900
  PLATFORM_VERSION = 0x0901
  PLATFORM_NAME = 0x0902
  PLATFORM_VENDOR = 0x0903
  PLATFORM_EXTENSIONS = 0x0904
  DEVICE_TYPE_DEFAULT = (1 << 0)
  DEVICE_TYPE_CPU = (1 << 1)
  DEVICE_TYPE_GPU = (1 << 2)
  DEVICE_TYPE_ACCELERATOR = (1 << 3)
  DEVICE_TYPE_CUSTOM = (1 << 4)
  DEVICE_TYPE_ALL = 0xFFFFFFFF
  DEVICE_TYPE = 0x1000
  DEVICE_VENDOR_ID = 0x1001
  DEVICE_MAX_COMPUTE_UNITS = 0x1002
  DEVICE_MAX_WORK_ITEM_DIMENSIONS = 0x1003
  DEVICE_MAX_WORK_GROUP_SIZE = 0x1004
  DEVICE_MAX_WORK_ITEM_SIZES = 0x1005
  DEVICE_PREFERRED_VECTOR_WIDTH_CHAR = 0x1006
  DEVICE_PREFERRED_VECTOR_WIDTH_SHORT = 0x1007
  DEVICE_PREFERRED_VECTOR_WIDTH_INT = 0x1008
  DEVICE_PREFERRED_VECTOR_WIDTH_LONG = 0x1009
  DEVICE_PREFERRED_VECTOR_WIDTH_FLOAT = 0x100A
  DEVICE_PREFERRED_VECTOR_WIDTH_DOUBLE = 0x100B
  DEVICE_MAX_CLOCK_FREQUENCY = 0x100C
  DEVICE_ADDRESS_BITS = 0x100D
  DEVICE_MAX_READ_IMAGE_ARGS = 0x100E
  DEVICE_MAX_WRITE_IMAGE_ARGS = 0x100F
  DEVICE_MAX_MEM_ALLOC_SIZE = 0x1010
  DEVICE_IMAGE2D_MAX_WIDTH = 0x1011
  DEVICE_IMAGE2D_MAX_HEIGHT = 0x1012
  DEVICE_IMAGE3D_MAX_WIDTH = 0x1013
  DEVICE_IMAGE3D_MAX_HEIGHT = 0x1014
  DEVICE_IMAGE3D_MAX_DEPTH = 0x1015
  DEVICE_IMAGE_SUPPORT = 0x1016
  DEVICE_MAX_PARAMETER_SIZE = 0x1017
  DEVICE_MAX_SAMPLERS = 0x1018
  DEVICE_MEM_BASE_ADDR_ALIGN = 0x1019
  DEVICE_MIN_DATA_TYPE_ALIGN_SIZE = 0x101A
  DEVICE_SINGLE_FP_CONFIG = 0x101B
  DEVICE_GLOBAL_MEM_CACHE_TYPE = 0x101C
  DEVICE_GLOBAL_MEM_CACHELINE_SIZE = 0x101D
  DEVICE_GLOBAL_MEM_CACHE_SIZE = 0x101E
  DEVICE_GLOBAL_MEM_SIZE = 0x101F
  DEVICE_MAX_CONSTANT_BUFFER_SIZE = 0x1020
  DEVICE_MAX_CONSTANT_ARGS = 0x1021
  DEVICE_LOCAL_MEM_TYPE = 0x1022
  DEVICE_LOCAL_MEM_SIZE = 0x1023
  DEVICE_ERROR_CORRECTION_SUPPORT = 0x1024
  DEVICE_PROFILING_TIMER_RESOLUTION = 0x1025
  DEVICE_ENDIAN_LITTLE = 0x1026
  DEVICE_AVAILABLE = 0x1027
  DEVICE_COMPILER_AVAILABLE = 0x1028
  DEVICE_EXECUTION_CAPABILITIES = 0x1029
  DEVICE_QUEUE_PROPERTIES = 0x102A
  DEVICE_NAME = 0x102B
  DEVICE_VENDOR = 0x102C
  DRIVER_VERSION = 0x102D
  DEVICE_PROFILE = 0x102E
  DEVICE_VERSION = 0x102F
  DEVICE_EXTENSIONS = 0x1030
  DEVICE_PLATFORM = 0x1031
  DEVICE_DOUBLE_FP_CONFIG = 0x1032
  DEVICE_PREFERRED_VECTOR_WIDTH_HALF = 0x1034
  DEVICE_HOST_UNIFIED_MEMORY = 0x1035
  DEVICE_NATIVE_VECTOR_WIDTH_CHAR = 0x1036
  DEVICE_NATIVE_VECTOR_WIDTH_SHORT = 0x1037
  DEVICE_NATIVE_VECTOR_WIDTH_INT = 0x1038
  DEVICE_NATIVE_VECTOR_WIDTH_LONG = 0x1039
  DEVICE_NATIVE_VECTOR_WIDTH_FLOAT = 0x103A
  DEVICE_NATIVE_VECTOR_WIDTH_DOUBLE = 0x103B
  DEVICE_NATIVE_VECTOR_WIDTH_HALF = 0x103C
  DEVICE_OPENCL_C_VERSION = 0x103D
  DEVICE_LINKER_AVAILABLE = 0x103E
  DEVICE_BUILT_IN_KERNELS = 0x103F
  DEVICE_IMAGE_MAX_BUFFER_SIZE = 0x1040
  DEVICE_IMAGE_MAX_ARRAY_SIZE = 0x1041
  DEVICE_PARENT_DEVICE = 0x1042
  DEVICE_PARTITION_MAX_SUB_DEVICES = 0x1043
  DEVICE_PARTITION_PROPERTIES = 0x1044
  DEVICE_PARTITION_AFFINITY_DOMAIN = 0x1045
  DEVICE_PARTITION_TYPE = 0x1046
  DEVICE_REFERENCE_COUNT = 0x1047
  DEVICE_PREFERRED_INTEROP_USER_SYNC = 0x1048
  DEVICE_PRINTF_BUFFER_SIZE = 0x1049
  DEVICE_IMAGE_PITCH_ALIGNMENT = 0x104A
  DEVICE_IMAGE_BASE_ADDRESS_ALIGNMENT = 0x104B
  FP_DENORM = (1 << 0)
  FP_INF_NAN = (1 << 1)
  FP_ROUND_TO_NEAREST = (1 << 2)
  FP_ROUND_TO_ZERO = (1 << 3)
  FP_ROUND_TO_INF = (1 << 4)
  FP_FMA = (1 << 5)
  FP_SOFT_FLOAT = (1 << 6)
  FP_CORRECTLY_ROUNDED_DIVIDE_SQRT = (1 << 7)
  NONE = 0x0
  READ_ONLY_CACHE = 0x1
  READ_WRITE_CACHE = 0x2
  LOCAL = 0x1
  GLOBAL = 0x2
  EXEC_KERNEL = (1 << 0)
  EXEC_NATIVE_KERNEL = (1 << 1)
  QUEUE_OUT_OF_ORDER_EXEC_MODE_ENABLE = (1 << 0)
  QUEUE_PROFILING_ENABLE = (1 << 1)
  CONTEXT_REFERENCE_COUNT = 0x1080
  CONTEXT_DEVICES = 0x1081
  CONTEXT_PROPERTIES = 0x1082
  CONTEXT_NUM_DEVICES = 0x1083
  CONTEXT_PLATFORM = 0x1084
  CONTEXT_INTEROP_USER_SYNC = 0x1085
  DEVICE_PARTITION_EQUALLY = 0x1086
  DEVICE_PARTITION_BY_COUNTS = 0x1087
  DEVICE_PARTITION_BY_COUNTS_LIST_END = 0x0
  DEVICE_PARTITION_BY_AFFINITY_DOMAIN = 0x1088
  DEVICE_AFFINITY_DOMAIN_NUMA = (1 << 0)
  DEVICE_AFFINITY_DOMAIN_L4_CACHE = (1 << 1)
  DEVICE_AFFINITY_DOMAIN_L3_CACHE = (1 << 2)
  DEVICE_AFFINITY_DOMAIN_L2_CACHE = (1 << 3)
  DEVICE_AFFINITY_DOMAIN_L1_CACHE = (1 << 4)
  DEVICE_AFFINITY_DOMAIN_NEXT_PARTITIONABLE = (1 << 5)
  QUEUE_CONTEXT = 0x1090
  QUEUE_DEVICE = 0x1091
  QUEUE_REFERENCE_COUNT = 0x1092
  QUEUE_PROPERTIES = 0x1093
  MEM_READ_WRITE = (1 << 0)
  MEM_WRITE_ONLY = (1 << 1)
  MEM_READ_ONLY = (1 << 2)
  MEM_USE_HOST_PTR = (1 << 3)
  MEM_ALLOC_HOST_PTR = (1 << 4)
  MEM_COPY_HOST_PTR = (1 << 5)
  MEM_HOST_WRITE_ONLY = (1 << 7)
  MEM_HOST_READ_ONLY = (1 << 8)
  MEM_HOST_NO_ACCESS = (1 << 9)
  MIGRATE_MEM_OBJECT_HOST = (1 << 0)
  MIGRATE_MEM_OBJECT_CONTENT_UNDEFINED = (1 << 1)
  R = 0x10B0
  A = 0x10B1
  RG = 0x10B2
  RA = 0x10B3
  RGB = 0x10B4
  RGBA = 0x10B5
  BGRA = 0x10B6
  ARGB = 0x10B7
  INTENSITY = 0x10B8
  LUMINANCE = 0x10B9
  Rx = 0x10BA
  RGx = 0x10BB
  RGBx = 0x10BC
  DEPTH = 0x10BD
  DEPTH_STENCIL = 0x10BE
  SNORM_INT8 = 0x10D0
  SNORM_INT16 = 0x10D1
  UNORM_INT8 = 0x10D2
  UNORM_INT16 = 0x10D3
  UNORM_SHORT_565 = 0x10D4
  UNORM_SHORT_555 = 0x10D5
  UNORM_INT_101010 = 0x10D6
  SIGNED_INT8 = 0x10D7
  SIGNED_INT16 = 0x10D8
  SIGNED_INT32 = 0x10D9
  UNSIGNED_INT8 = 0x10DA
  UNSIGNED_INT16 = 0x10DB
  UNSIGNED_INT32 = 0x10DC
  HALF_FLOAT = 0x10DD
  FLOAT = 0x10DE
  UNORM_INT24 = 0x10DF
  MEM_OBJECT_BUFFER = 0x10F0
  MEM_OBJECT_IMAGE2D = 0x10F1
  MEM_OBJECT_IMAGE3D = 0x10F2
  MEM_OBJECT_IMAGE2D_ARRAY = 0x10F3
  MEM_OBJECT_IMAGE1D = 0x10F4
  MEM_OBJECT_IMAGE1D_ARRAY = 0x10F5
  MEM_OBJECT_IMAGE1D_BUFFER = 0x10F6
  MEM_TYPE = 0x1100
  MEM_FLAGS = 0x1101
  MEM_SIZE = 0x1102
  MEM_HOST_PTR = 0x1103
  MEM_MAP_COUNT = 0x1104
  MEM_REFERENCE_COUNT = 0x1105
  MEM_CONTEXT = 0x1106
  MEM_ASSOCIATED_MEMOBJECT = 0x1107
  MEM_OFFSET = 0x1108
  IMAGE_FORMAT = 0x1110
  IMAGE_ELEMENT_SIZE = 0x1111
  IMAGE_ROW_PITCH = 0x1112
  IMAGE_SLICE_PITCH = 0x1113
  IMAGE_WIDTH = 0x1114
  IMAGE_HEIGHT = 0x1115
  IMAGE_DEPTH = 0x1116
  IMAGE_ARRAY_SIZE = 0x1117
  IMAGE_BUFFER = 0x1118
  IMAGE_NUM_MIP_LEVELS = 0x1119
  IMAGE_NUM_SAMPLES = 0x111A
  ADDRESS_NONE = 0x1130
  ADDRESS_CLAMP_TO_EDGE = 0x1131
  ADDRESS_CLAMP = 0x1132
  ADDRESS_REPEAT = 0x1133
  ADDRESS_MIRRORED_REPEAT = 0x1134
  FILTER_NEAREST = 0x1140
  FILTER_LINEAR = 0x1141
  SAMPLER_REFERENCE_COUNT = 0x1150
  SAMPLER_CONTEXT = 0x1151
  SAMPLER_NORMALIZED_COORDS = 0x1152
  SAMPLER_ADDRESSING_MODE = 0x1153
  SAMPLER_FILTER_MODE = 0x1154
  MAP_READ = (1 << 0)
  MAP_WRITE = (1 << 1)
  MAP_WRITE_INVALIDATE_REGION = (1 << 2)
  PROGRAM_REFERENCE_COUNT = 0x1160
  PROGRAM_CONTEXT = 0x1161
  PROGRAM_NUM_DEVICES = 0x1162
  PROGRAM_DEVICES = 0x1163
  PROGRAM_SOURCE = 0x1164
  PROGRAM_BINARY_SIZES = 0x1165
  PROGRAM_BINARIES = 0x1166
  PROGRAM_NUM_KERNELS = 0x1167
  PROGRAM_KERNEL_NAMES = 0x1168
  PROGRAM_BUILD_STATUS = 0x1181
  PROGRAM_BUILD_OPTIONS = 0x1182
  PROGRAM_BUILD_LOG = 0x1183
  PROGRAM_BINARY_TYPE = 0x1184
  PROGRAM_BINARY_TYPE_NONE = 0x0
  PROGRAM_BINARY_TYPE_COMPILED_OBJECT = 0x1
  PROGRAM_BINARY_TYPE_LIBRARY = 0x2
  PROGRAM_BINARY_TYPE_EXECUTABLE = 0x4
  BUILD_SUCCESS = 0
  BUILD_NONE = -1
  BUILD_ERROR = -2
  BUILD_IN_PROGRESS = -3
  KERNEL_FUNCTION_NAME = 0x1190
  KERNEL_NUM_ARGS = 0x1191
  KERNEL_REFERENCE_COUNT = 0x1192
  KERNEL_CONTEXT = 0x1193
  KERNEL_PROGRAM = 0x1194
  KERNEL_ATTRIBUTES = 0x1195
  KERNEL_ARG_ADDRESS_QUALIFIER = 0x1196
  KERNEL_ARG_ACCESS_QUALIFIER = 0x1197
  KERNEL_ARG_TYPE_NAME = 0x1198
  KERNEL_ARG_TYPE_QUALIFIER = 0x1199
  KERNEL_ARG_NAME = 0x119A
  KERNEL_ARG_ADDRESS_GLOBAL = 0x119B
  KERNEL_ARG_ADDRESS_LOCAL = 0x119C
  KERNEL_ARG_ADDRESS_CONSTANT = 0x119D
  KERNEL_ARG_ADDRESS_PRIVATE = 0x119E
  KERNEL_ARG_ACCESS_READ_ONLY = 0x11A0
  KERNEL_ARG_ACCESS_WRITE_ONLY = 0x11A1
  KERNEL_ARG_ACCESS_READ_WRITE = 0x11A2
  KERNEL_ARG_ACCESS_NONE = 0x11A3
  KERNEL_ARG_TYPE_NONE = 0
  KERNEL_ARG_TYPE_CONST = (1 << 0)
  KERNEL_ARG_TYPE_RESTRICT = (1 << 1)
  KERNEL_ARG_TYPE_VOLATILE = (1 << 2)
  KERNEL_WORK_GROUP_SIZE = 0x11B0
  KERNEL_COMPILE_WORK_GROUP_SIZE = 0x11B1
  KERNEL_LOCAL_MEM_SIZE = 0x11B2
  KERNEL_PREFERRED_WORK_GROUP_SIZE_MULTIPLE = 0x11B3
  KERNEL_PRIVATE_MEM_SIZE = 0x11B4
  KERNEL_GLOBAL_WORK_SIZE = 0x11B5
  EVENT_COMMAND_QUEUE = 0x11D0
  EVENT_COMMAND_TYPE = 0x11D1
  EVENT_REFERENCE_COUNT = 0x11D2
  EVENT_COMMAND_EXECUTION_STATUS = 0x11D3
  EVENT_CONTEXT = 0x11D4
  COMMAND_NDRANGE_KERNEL = 0x11F0
  COMMAND_TASK = 0x11F1
  COMMAND_NATIVE_KERNEL = 0x11F2
  COMMAND_READ_BUFFER = 0x11F3
  COMMAND_WRITE_BUFFER = 0x11F4
  COMMAND_COPY_BUFFER = 0x11F5
  COMMAND_READ_IMAGE = 0x11F6
  COMMAND_WRITE_IMAGE = 0x11F7
  COMMAND_COPY_IMAGE = 0x11F8
  COMMAND_COPY_IMAGE_TO_BUFFER = 0x11F9
  COMMAND_COPY_BUFFER_TO_IMAGE = 0x11FA
  COMMAND_MAP_BUFFER = 0x11FB
  COMMAND_MAP_IMAGE = 0x11FC
  COMMAND_UNMAP_MEM_OBJECT = 0x11FD
  COMMAND_MARKER = 0x11FE
  COMMAND_ACQUIRE_GL_OBJECTS = 0x11FF
  COMMAND_RELEASE_GL_OBJECTS = 0x1200
  COMMAND_READ_BUFFER_RECT = 0x1201
  COMMAND_WRITE_BUFFER_RECT = 0x1202
  COMMAND_COPY_BUFFER_RECT = 0x1203
  COMMAND_USER = 0x1204
  COMMAND_BARRIER = 0x1205
  COMMAND_MIGRATE_MEM_OBJECTS = 0x1206
  COMMAND_FILL_BUFFER = 0x1207
  COMMAND_FILL_IMAGE = 0x1208
  COMPLETE = 0x0
  RUNNING = 0x1
  SUBMITTED = 0x2
  QUEUED = 0x3
  BUFFER_CREATE_TYPE_REGION = 0x1220
  PROFILING_COMMAND_QUEUED = 0x1280
  PROFILING_COMMAND_SUBMIT = 0x1281
  PROFILING_COMMAND_START = 0x1282
  PROFILING_COMMAND_END = 0x1283
  GL_OBJECT_BUFFER = 0x2000
  GL_OBJECT_TEXTURE2D = 0x2001
  GL_OBJECT_TEXTURE3D = 0x2002
  GL_OBJECT_RENDERBUFFER = 0x2003
  GL_OBJECT_TEXTURE2D_ARRAY = 0x200E
  GL_OBJECT_TEXTURE1D = 0x200F
  GL_OBJECT_TEXTURE1D_ARRAY = 0x2010
  GL_OBJECT_TEXTURE_BUFFER = 0x2011
  GL_TEXTURE_TARGET = 0x2004
  GL_MIPMAP_LEVEL = 0x2005
  GL_NUM_SAMPLES = 0x2012
  cl_khr_gl_sharing = 1
  INVALID_GL_SHAREGROUP_REFERENCE_KHR = -1000
  CURRENT_DEVICE_FOR_GL_CONTEXT_KHR = 0x2006
  DEVICES_FOR_GL_CONTEXT_KHR = 0x2007
  GL_CONTEXT_KHR = 0x2008
  EGL_DISPLAY_KHR = 0x2009
  GLX_DISPLAY_KHR = 0x200A
  WGL_HDC_KHR = 0x200B
  CGL_SHAREGROUP_KHR = 0x200C
  DEVICE_HALF_FP_CONFIG = 0x1033
  cl_APPLE_SetMemObjectDestructor = 1
  cl_APPLE_ContextLoggingFunctions = 1
  cl_khr_icd = 1
  PLATFORM_ICD_SUFFIX_KHR = 0x0920
  PLATFORM_NOT_FOUND_KHR = -1001
  CONTEXT_MEMORY_INITIALIZE_KHR = 0x200E
  DEVICE_TERMINATE_CAPABILITY_KHR = 0x200F
  CONTEXT_TERMINATE_KHR = 0x2010
  cl_khr_terminate_context = 1
  DEVICE_COMPUTE_CAPABILITY_MAJOR_NV = 0x4000
  DEVICE_COMPUTE_CAPABILITY_MINOR_NV = 0x4001
  DEVICE_REGISTERS_PER_BLOCK_NV = 0x4002
  DEVICE_WARP_SIZE_NV = 0x4003
  DEVICE_GPU_OVERLAP_NV = 0x4004
  DEVICE_KERNEL_EXEC_TIMEOUT_NV = 0x4005
  DEVICE_INTEGRATED_MEMORY_NV = 0x4006
  cl_amd_device_memory_flags = 1
  MEM_USE_PERSISTENT_MEM_AMD = (1 << 6)        
  DEVICE_MAX_ATOMIC_COUNTERS_EXT = 0x4032
  DEVICE_PROFILING_TIMER_OFFSET_AMD = 0x4036
  DEVICE_TOPOLOGY_AMD = 0x4037
  DEVICE_BOARD_NAME_AMD = 0x4038
  DEVICE_GLOBAL_FREE_MEMORY_AMD = 0x4039
  DEVICE_SIMD_PER_COMPUTE_UNIT_AMD = 0x4040
  DEVICE_SIMD_WIDTH_AMD = 0x4041
  DEVICE_SIMD_INSTRUCTION_WIDTH_AMD = 0x4042
  DEVICE_WAVEFRONT_WIDTH_AMD = 0x4043
  DEVICE_GLOBAL_MEM_CHANNELS_AMD = 0x4044
  DEVICE_GLOBAL_MEM_CHANNEL_BANKS_AMD = 0x4045
  DEVICE_GLOBAL_MEM_CHANNEL_BANK_WIDTH_AMD = 0x4046
  DEVICE_LOCAL_MEM_SIZE_PER_COMPUTE_UNIT_AMD = 0x4047
  DEVICE_LOCAL_MEM_BANKS_AMD = 0x4048
  DEVICE_TOPOLOGY_TYPE_PCIE_AMD = 1
  CONTEXT_OFFLINE_DEVICES_AMD = 0x403F
  MEM_EXT_HOST_PTR_QCOM = (1 << 29)
  DEVICE_EXT_MEM_PADDING_IN_BYTES_QCOM = 0x40A0      
  DEVICE_PAGE_SIZE_QCOM = 0x40A1
  IMAGE_ROW_ALIGNMENT_QCOM = 0x40A2
  IMAGE_SLICE_ALIGNMENT_QCOM = 0x40A3
  MEM_HOST_UNCACHED_QCOM = 0x40A4
  MEM_HOST_WRITEBACK_QCOM = 0x40A5
  MEM_HOST_WRITETHROUGH_QCOM = 0x40A6
  MEM_HOST_WRITE_COMBINING_QCOM = 0x40A7
  MEM_ION_HOST_PTR_QCOM = 0x40A8
  #:startdoc:
  class Error < StandardError
    @@codes = {}
    @@codes[-1001] = 'PLATFORM_NOT_FOUND_KHR'
    @@codes[-1000] = 'INVALID_GL_SHAREGROUP_REFERENCE_KHR'
    @@codes[-3] = 'COMPILER_NOT_AVAILABLE'
    @@codes[-2] = 'DEVICE_NOT_AVAILABLE'
    @@codes[-1] = 'DEVICE_NOT_FOUND'
    @@codes[-68] = 'INVALID_DEVICE_PARTITION_COUNT'
    @@codes[-67] = 'INVALID_LINKER_OPTIONS'
    @@codes[-66] = 'INVALID_COMPILER_OPTIONS'
    @@codes[-65] = 'INVALID_IMAGE_DESCRIPTOR'
    @@codes[-64] = 'INVALID_PROPERTY'
    @@codes[-63] = 'INVALID_GLOBAL_WORK_SIZE'
    @@codes[-62] = 'INVALID_MIP_LEVEL'
    @@codes[-61] = 'INVALID_BUFFER_SIZE'
    @@codes[-60] = 'INVALID_GL_OBJECT'
    @@codes[-59] = 'INVALID_OPERATION'
    @@codes[-58] = 'INVALID_EVENT'
    @@codes[-57] = 'INVALID_EVENT_WAIT_LIST'
    @@codes[-56] = 'INVALID_GLOBAL_OFFSET'
    @@codes[-55] = 'INVALID_WORK_ITEM_SIZE'
    @@codes[-54] = 'INVALID_WORK_GROUP_SIZE'
    @@codes[-53] = 'INVALID_WORK_DIMENSION'
    @@codes[-52] = 'INVALID_KERNEL_ARGS'
    @@codes[-51] = 'INVALID_ARG_SIZE'
    @@codes[-50] = 'INVALID_ARG_VALUE'
    @@codes[-49] = 'INVALID_ARG_INDEX'
    @@codes[-48] = 'INVALID_KERNEL'
    @@codes[-47] = 'INVALID_KERNEL_DEFINITION'
    @@codes[-46] = 'INVALID_KERNEL_NAME'
    @@codes[-45] = 'INVALID_PROGRAM_EXECUTABLE'
    @@codes[-44] = 'INVALID_PROGRAM'
    @@codes[-43] = 'INVALID_BUILD_OPTIONS'
    @@codes[-42] = 'INVALID_BINARY'
    @@codes[-41] = 'INVALID_SAMPLER'
    @@codes[-40] = 'INVALID_IMAGE_SIZE'
    @@codes[-39] = 'INVALID_IMAGE_FORMAT_DESCRIPTOR'
    @@codes[-38] = 'INVALID_MEM_OBJECT'
    @@codes[-37] = 'INVALID_HOST_PTR'
    @@codes[-36] = 'INVALID_COMMAND_QUEUE'
    @@codes[-35] = 'INVALID_QUEUE_PROPERTIES'
    @@codes[-34] = 'INVALID_CONTEXT'
    @@codes[-33] = 'INVALID_DEVICE'
    @@codes[-32] = 'INVALID_PLATFORM'
    @@codes[-31] = 'INVALID_DEVICE_TYPE'
    @@codes[-30] = 'INVALID_VALUE'
    @@codes[-19] = 'KERNEL_ARG_INFO_NOT_AVAILABLE'
    @@codes[-18] = 'DEVICE_PARTITION_FAILED'
    @@codes[-17] = 'LINK_PROGRAM_FAILURE'
    @@codes[-16] = 'LINKER_NOT_AVAILABLE'
    @@codes[-15] = 'COMPILE_PROGRAM_FAILURE'
    @@codes[-14] = 'EXEC_STATUS_ERROR_FOR_EVENTS_IN_WAIT_LIST'
    @@codes[-13] = 'MISALIGNED_SUB_BUFFER_OFFSET'
    @@codes[-12] = 'MAP_FAILURE'
    @@codes[-11] = 'BUILD_PROGRAM_FAILURE'
    @@codes[-10] = 'IMAGE_FORMAT_NOT_SUPPORTED'
    @@codes[-9] = 'IMAGE_FORMAT_MISMATCH'
    @@codes[-8] = 'MEM_COPY_OVERLAP'
    @@codes[-7] = 'PROFILING_INFO_NOT_AVAILABLE'
    @@codes[-6] = 'OUT_OF_HOST_MEMORY'
    @@codes[-5] = 'OUT_OF_RESOURCES'
    @@codes[-4] = 'MEM_OBJECT_ALLOCATION_FAILURE'
    def self.get_error_string(errcode)
      return "CL Error: #{@@codes[errcode]} (#{errcode})"
    end
    def self.get_name(errcode)
      return @@codes[errcode]
    end
  end
  FFI::typedef :int8, :cl_char
  FFI::typedef :uint8, :cl_uchar
  FFI::typedef :int16, :cl_short
  FFI::typedef :uint16, :cl_ushort
  FFI::typedef :int32, :cl_int
  FFI::typedef :uint32, :cl_uint
  FFI::typedef :int64, :cl_long
  FFI::typedef :uint64, :cl_ulong
  FFI::typedef :uint16, :cl_half
  FFI::typedef :float, :cl_float
  FFI::typedef :double, :cl_double
  FFI::typedef :uint32, :cl_GLuint
  FFI::typedef :int32, :cl_GLint
  FFI::typedef :uint32, :cl_GLenum
  FFI::typedef :cl_uint, :cl_bool
  FFI::typedef :cl_ulong, :cl_bitfield
  FFI::typedef :cl_bitfield, :cl_device_type
  FFI::typedef :cl_uint, :cl_platform_info
  FFI::typedef :cl_uint, :cl_device_info
  FFI::typedef :cl_bitfield, :cl_device_fp_config
  FFI::typedef :cl_uint, :cl_device_mem_cache_type
  FFI::typedef :cl_uint, :cl_device_local_mem_type
  FFI::typedef :cl_bitfield, :cl_device_exec_capabilities
  FFI::typedef :cl_bitfield, :cl_command_queue_properties
  FFI::typedef :pointer, :cl_device_partition_property
  FFI::typedef :cl_bitfield, :cl_device_affinity_domain
  FFI::typedef :pointer, :cl_context_properties
  FFI::typedef :cl_uint, :cl_context_info
  FFI::typedef :cl_uint, :cl_command_queue_info
  FFI::typedef :cl_uint, :cl_channel_order
  FFI::typedef :cl_uint, :cl_channel_type
  FFI::typedef :cl_bitfield, :cl_mem_flags
  FFI::typedef :cl_uint, :cl_mem_object_type
  FFI::typedef :cl_uint, :cl_mem_info
  FFI::typedef :cl_bitfield, :cl_mem_migration_flags
  FFI::typedef :cl_uint, :cl_image_info
  FFI::typedef :cl_uint, :cl_buffer_create_type
  FFI::typedef :cl_uint, :cl_addressing_mode
  FFI::typedef :cl_uint, :cl_filter_mode
  FFI::typedef :cl_uint, :cl_sampler_info
  FFI::typedef :cl_bitfield, :cl_map_flags
  FFI::typedef :cl_uint, :cl_program_info
  FFI::typedef :cl_uint, :cl_program_build_info
  FFI::typedef :cl_uint, :cl_program_binary_type
  FFI::typedef :cl_int, :cl_build_status
  FFI::typedef :cl_uint, :cl_kernel_info
  FFI::typedef :cl_uint, :cl_kernel_arg_info
  FFI::typedef :cl_uint, :cl_kernel_arg_address_qualifier
  FFI::typedef :cl_uint, :cl_kernel_arg_access_qualifier
  FFI::typedef :cl_bitfield, :cl_kernel_arg_type_qualifier
  FFI::typedef :cl_uint, :cl_kernel_work_group_info
  FFI::typedef :cl_uint, :cl_event_info
  FFI::typedef :cl_uint, :cl_command_type
  FFI::typedef :cl_uint, :cl_profiling_info
  FFI::typedef :cl_uint, :cl_gl_object_type
  FFI::typedef :cl_uint, :cl_gl_texture_info
  FFI::typedef :cl_uint, :cl_gl_platform_info
  FFI::typedef :cl_uint, :cl_gl_context_info
  class Enum
    extend FFI::DataConverter
    native_type :cl_uint
    def initialize( val = 0 )
      super()
      @val = val
    end

    def is?(val)
      return true if @val == val
    end

    def ==(val)
      return true if @val == val
    end

    def to_s
      return "#{self.name}"
    end

    def to_i
      return @val
    end

    def self.to_native(value, context)
      if value then
        return value.flags
      else
        return 0
      end
    end

    def self.from_native(value, context)
      new(value)
    end

    def self.size
      FFI::find_type(:cl_uint).size
    end

    def self.reference_required?
      return false
    end

  end

  class Bitfield
    extend FFI::DataConverter
    native_type :cl_bitfield
    def initialize( val = 0 )
      super()
      @val = val
    end

    def include?(flag)
      return true if ( @val & flag ) == flag
      return false
    end

    def to_s
      return "#{self.names}"
    end

    def to_i
      return @val
    end

    def &(f)
      return @val & f
    end

    def ^(f)
      return @val ^ f
    end

    def |(f)
      return @val | f
    end

    def flags
      return @val
    end

    def flags=(val)
      @val = val
    end
    
    def self.to_native(value, context)
      if value then
        return value.flags
      else
        return 0
      end
    end

    def self.from_native(value, context)
      new(value)
    end

    def self.size
      FFI::find_type(:cl_bitfield).size
    end

    def self.reference_required?
      return false
    end

  end
  class Platform < FFI::ManagedStruct
    layout :dummy, :pointer
    #:stopdoc:
    PROFILE = 0x0900
    VERSION = 0x0901
    NAME = 0x0902
    VENDOR = 0x0903
    EXTENSIONS = 0x0904
    ICD_SUFFIX_KHR = 0x0920
    #:startdoc:
    def self.release(ptr)
    end
  end

  class Device < FFI::ManagedStruct
    layout :dummy, :pointer
    #:stopdoc:
    TYPE_DEFAULT = (1 << 0)
    TYPE_CPU = (1 << 1)
    TYPE_GPU = (1 << 2)
    TYPE_ACCELERATOR = (1 << 3)
    TYPE_CUSTOM = (1 << 4)
    TYPE_ALL = 0xFFFFFFFF
    TYPE = 0x1000
    VENDOR_ID = 0x1001
    MAX_COMPUTE_UNITS = 0x1002
    MAX_WORK_ITEM_DIMENSIONS = 0x1003
    MAX_WORK_GROUP_SIZE = 0x1004
    MAX_WORK_ITEM_SIZES = 0x1005
    PREFERRED_VECTOR_WIDTH_CHAR = 0x1006
    PREFERRED_VECTOR_WIDTH_SHORT = 0x1007
    PREFERRED_VECTOR_WIDTH_INT = 0x1008
    PREFERRED_VECTOR_WIDTH_LONG = 0x1009
    PREFERRED_VECTOR_WIDTH_FLOAT = 0x100A
    PREFERRED_VECTOR_WIDTH_DOUBLE = 0x100B
    MAX_CLOCK_FREQUENCY = 0x100C
    ADDRESS_BITS = 0x100D
    MAX_READ_IMAGE_ARGS = 0x100E
    MAX_WRITE_IMAGE_ARGS = 0x100F
    MAX_MEM_ALLOC_SIZE = 0x1010
    IMAGE2D_MAX_WIDTH = 0x1011
    IMAGE2D_MAX_HEIGHT = 0x1012
    IMAGE3D_MAX_WIDTH = 0x1013
    IMAGE3D_MAX_HEIGHT = 0x1014
    IMAGE3D_MAX_DEPTH = 0x1015
    IMAGE_SUPPORT = 0x1016
    MAX_PARAMETER_SIZE = 0x1017
    MAX_SAMPLERS = 0x1018
    MEM_BASE_ADDR_ALIGN = 0x1019
    MIN_DATA_TYPE_ALIGN_SIZE = 0x101A
    SINGLE_FP_CONFIG = 0x101B
    GLOBAL_MEM_CACHE_TYPE = 0x101C
    GLOBAL_MEM_CACHELINE_SIZE = 0x101D
    GLOBAL_MEM_CACHE_SIZE = 0x101E
    GLOBAL_MEM_SIZE = 0x101F
    MAX_CONSTANT_BUFFER_SIZE = 0x1020
    MAX_CONSTANT_ARGS = 0x1021
    LOCAL_MEM_TYPE = 0x1022
    LOCAL_MEM_SIZE = 0x1023
    ERROR_CORRECTION_SUPPORT = 0x1024
    PROFILING_TIMER_RESOLUTION = 0x1025
    ENDIAN_LITTLE = 0x1026
    AVAILABLE = 0x1027
    COMPILER_AVAILABLE = 0x1028
    EXECUTION_CAPABILITIES = 0x1029
    QUEUE_PROPERTIES = 0x102A
    NAME = 0x102B
    VENDOR = 0x102C
    PROFILE = 0x102E
    VERSION = 0x102F
    EXTENSIONS = 0x1030
    PLATFORM = 0x1031
    DOUBLE_FP_CONFIG = 0x1032
    PREFERRED_VECTOR_WIDTH_HALF = 0x1034
    HOST_UNIFIED_MEMORY = 0x1035
    NATIVE_VECTOR_WIDTH_CHAR = 0x1036
    NATIVE_VECTOR_WIDTH_SHORT = 0x1037
    NATIVE_VECTOR_WIDTH_INT = 0x1038
    NATIVE_VECTOR_WIDTH_LONG = 0x1039
    NATIVE_VECTOR_WIDTH_FLOAT = 0x103A
    NATIVE_VECTOR_WIDTH_DOUBLE = 0x103B
    NATIVE_VECTOR_WIDTH_HALF = 0x103C
    OPENCL_C_VERSION = 0x103D
    LINKER_AVAILABLE = 0x103E
    BUILT_IN_KERNELS = 0x103F
    IMAGE_MAX_BUFFER_SIZE = 0x1040
    IMAGE_MAX_ARRAY_SIZE = 0x1041
    PARENT_DEVICE = 0x1042
    PARTITION_MAX_SUB_DEVICES = 0x1043
    PARTITION_PROPERTIES = 0x1044
    PARTITION_AFFINITY_DOMAIN = 0x1045
    PARTITION_TYPE = 0x1046
    REFERENCE_COUNT = 0x1047
    PREFERRED_INTEROP_USER_SYNC = 0x1048
    PRINTF_BUFFER_SIZE = 0x1049
    IMAGE_PITCH_ALIGNMENT = 0x104A
    IMAGE_BASE_ADDRESS_ALIGNMENT = 0x104B
    PARTITION_EQUALLY = 0x1086
    PARTITION_BY_COUNTS = 0x1087
    PARTITION_BY_COUNTS_LIST_END = 0x0
    PARTITION_BY_AFFINITY_DOMAIN = 0x1088
    AFFINITY_DOMAIN_NUMA = (1 << 0)
    AFFINITY_DOMAIN_L4_CACHE = (1 << 1)
    AFFINITY_DOMAIN_L3_CACHE = (1 << 2)
    AFFINITY_DOMAIN_L2_CACHE = (1 << 3)
    AFFINITY_DOMAIN_L1_CACHE = (1 << 4)
    AFFINITY_DOMAIN_NEXT_PARTITIONABLE = (1 << 5)
    HALF_FP_CONFIG = 0x1033
    TERMINATE_CAPABILITY_KHR = 0x200F
    COMPUTE_CAPABILITY_MAJOR_NV = 0x4000
    COMPUTE_CAPABILITY_MINOR_NV = 0x4001
    REGISTERS_PER_BLOCK_NV = 0x4002
    WARP_SIZE_NV = 0x4003
    GPU_OVERLAP_NV = 0x4004
    KERNEL_EXEC_TIMEOUT_NV = 0x4005
    INTEGRATED_MEMORY_NV = 0x4006
    MAX_ATOMIC_COUNTERS_EXT = 0x4032
    PROFILING_TIMER_OFFSET_AMD = 0x4036
    TOPOLOGY_AMD = 0x4037
    BOARD_NAME_AMD = 0x4038
    GLOBAL_FREE_MEMORY_AMD = 0x4039
    SIMD_PER_COMPUTE_UNIT_AMD = 0x4040
    SIMD_WIDTH_AMD = 0x4041
    SIMD_INSTRUCTION_WIDTH_AMD = 0x4042
    WAVEFRONT_WIDTH_AMD = 0x4043
    GLOBAL_MEM_CHANNELS_AMD = 0x4044
    GLOBAL_MEM_CHANNEL_BANKS_AMD = 0x4045
    GLOBAL_MEM_CHANNEL_BANK_WIDTH_AMD = 0x4046
    LOCAL_MEM_SIZE_PER_COMPUTE_UNIT_AMD = 0x4047
    LOCAL_MEM_BANKS_AMD = 0x4048
    TOPOLOGY_TYPE_PCIE_AMD = 1
    EXT_MEM_PADDING_IN_BYTES_QCOM = 0x40A0      
    PAGE_SIZE_QCOM = 0x40A1
    #:startdoc:
    def self.release(ptr)
      return if self.platform.version_number < 1.2
      error = OpenCL.clReleaseDevice(ptr.read_ptr)
      OpenCL.error_check( error )
    end
  end

  class Device
    class Type < OpenCL::Bitfield
      #:stopdoc:
      DEFAULT = (1 << 0)
      CPU = (1 << 1)
      GPU = (1 << 2)
      ACCELERATOR = (1 << 3)
      CUSTOM = (1 << 4)
      ALL = 0xFFFFFFFF
      #:startdoc:
      def names
        fs = []
        %w( DEFAULT CPU GPU ACCELERATOR CUSTOM ALL ).each { |f|
          fs.push(f) if self.include?( self.class.const_get(f) )
        }
        return fs
      end
    end

    class FPConfig < OpenCL::Bitfield
      #:stopdoc:
      DENORM = (1 << 0)
      INF_NAN = (1 << 1)
      ROUND_TO_NEAREST = (1 << 2)
      ROUND_TO_ZERO = (1 << 3)
      ROUND_TO_INF = (1 << 4)
      FMA = (1 << 5)
      SOFT_FLOAT = (1 << 6)
      CORRECTLY_ROUNDED_DIVIDE_SQRT = (1 << 7)
      #:startdoc:
      def names
        fs = []
        %w( DENORM INF_NAN ROUND_TO_NEAREST ROUND_TO_ZERO ROUND_TO_INF FMA SOFT_FLOAT CORRECTLY_ROUNDED_DIVIDE_SQRT ).each { |f|
          fs.push(f) if self.include?( self.class.const_get(f) )
        }
        return fs
      end
    end

    class ExecCapabilities < OpenCL::Bitfield
      #:stopdoc:
      KERNEL = (1 << 0)
      NATIVE_KERNEL = (1 << 1)
      #:startdoc:
      def names
        fs = []
        %w( KERNEL NATIVE_KERNEL ).each { |f|
          fs.push(f) if self.include?( self.class.const_get(f) )
        }
        return fs
      end
    end

    class MemCacheType < OpenCL::Enum
      #:stopdoc:
      NONE = 0x0
      READ_ONLY_CACHE = 0x1
      READ_WRITE_CACHE = 0x2
      #:startdoc:
      def name
        %w( NONE READ_ONLY_CACHE READ_WRITE_CACHE ).each { |f|
          return f if @val == self.class.const_get(f)
        }
        return nil
      end
    end

    class LocalMemType < OpenCL::Enum
      #:stopdoc:
      LOCAL = 0x1
      GLOBAL = 0x2
      #:startdoc:
      def name
        %w( LOCAL GLOBAL ).each { |f|
          return f if @val == self.class.const_get(f)
        }
        return nil
      end
    end

    class AffinityDomain < OpenCL::Bitfield
      #:stopdoc:
      NUMA = (1 << 0)
      L4_CACHE = (1 << 1)
      L3_CACHE = (1 << 2)
      L2_CACHE = (1 << 3)
      L1_CACHE = (1 << 4)
      NEXT_PARTITIONABLE = (1 << 5)
      #:startdoc:
      def names
        fs = []
        %w( NUMA L4_CACHE L3_CACHE L2_CACHE L1_CACHE NEXT_PARTITIONABLE ).each { |f|
          fs.push(f) if self.include?( self.class.const_get(f) )
        }
        return fs
      end
    end

  end
  class Context < FFI::ManagedStruct
    layout :dummy, :pointer
    #:stopdoc:
    REFERENCE_COUNT = 0x1080
    DEVICES = 0x1081
    PROPERTIES = 0x1082
    NUM_DEVICES = 0x1083
    PLATFORM = 0x1084
    INTEROP_USER_SYNC = 0x1085
    MEMORY_INITIALIZE_KHR = 0x200E
    TERMINATE_KHR = 0x2010
    OFFLINE_DEVICES_AMD = 0x403F
    #:startdoc:
    def self.release(ptr)
      error = OpenCL.clReleaseContext(ptr.read_ptr)
      OpenCL.error_check( error )
    end
  end

  class CommandQueue < FFI::ManagedStruct
    layout :dummy, :pointer
    #:stopdoc:
    OUT_OF_ORDER_EXEC_MODE_ENABLE = (1 << 0)
    PROFILING_ENABLE = (1 << 1)
    CONTEXT = 0x1090
    DEVICE = 0x1091
    REFERENCE_COUNT = 0x1092
    PROPERTIES = 0x1093
    #:startdoc:
    def self.release(ptr)
      error = OpenCL.clReleaseCommandQueue(ptr.read_ptr)
      OpenCL.error_check( error )
    end
  end

  class CommandQueue
    class Properties < OpenCL::Bitfield
      #:stopdoc:
      OUT_OF_ORDER_EXEC_MODE_ENABLE = (1 << 0)
      PROFILING_ENABLE = (1 << 1)
      #:startdoc:
      def names
        fs = []
        %w( OUT_OF_ORDER_EXEC_MODE_ENABLE PROFILING_ENABLE ).each { |f|
          fs.push(f) if self.include?( self.class.const_get(f) )
        }
        return fs
      end
    end

  end
  class Mem < FFI::ManagedStruct
    layout :dummy, :pointer
    #:stopdoc:
    READ_WRITE = (1 << 0)
    WRITE_ONLY = (1 << 1)
    READ_ONLY = (1 << 2)
    USE_HOST_PTR = (1 << 3)
    ALLOC_HOST_PTR = (1 << 4)
    COPY_HOST_PTR = (1 << 5)
    HOST_WRITE_ONLY = (1 << 7)
    HOST_READ_ONLY = (1 << 8)
    HOST_NO_ACCESS = (1 << 9)
    BUFFER = 0x10F0
    IMAGE2D = 0x10F1
    IMAGE3D = 0x10F2
    IMAGE2D_ARRAY = 0x10F3
    IMAGE1D = 0x10F4
    IMAGE1D_ARRAY = 0x10F5
    IMAGE1D_BUFFER = 0x10F6
    TYPE = 0x1100
    FLAGS = 0x1101
    SIZE = 0x1102
    HOST_PTR = 0x1103
    MAP_COUNT = 0x1104
    REFERENCE_COUNT = 0x1105
    CONTEXT = 0x1106
    ASSOCIATED_MEMOBJECT = 0x1107
    OFFSET = 0x1108
    USE_PERSISTENT_MEM_AMD = (1 << 6)        
    EXT_HOST_PTR_QCOM = (1 << 29)
    HOST_UNCACHED_QCOM = 0x40A4
    HOST_WRITEBACK_QCOM = 0x40A5
    HOST_WRITETHROUGH_QCOM = 0x40A6
    HOST_WRITE_COMBINING_QCOM = 0x40A7
    ION_HOST_PTR_QCOM = 0x40A8
    #:startdoc:
    def self.release(ptr)
      error = OpenCL.clReleaseMemObject(ptr.read_ptr)
      OpenCL.error_check( error )
    end
  end

  class Mem
    class Flags < OpenCL::Bitfield
      #:stopdoc:
      READ_WRITE = (1 << 0)
      WRITE_ONLY = (1 << 1)
      READ_ONLY = (1 << 2)
      USE_HOST_PTR = (1 << 3)
      ALLOC_HOST_PTR = (1 << 4)
      COPY_HOST_PTR = (1 << 5)
      HOST_WRITE_ONLY = (1 << 7)
      HOST_READ_ONLY = (1 << 8)
      HOST_NO_ACCESS = (1 << 9)
      #:startdoc:
      def names
        fs = []
        %w( READ_WRITE WRITE_ONLY READ_ONLY USE_HOST_PTR ALLOC_HOST_PTR COPY_HOST_PTR HOST_WRITE_ONLY HOST_READ_ONLY HOST_NO_ACCESS ).each { |f|
          fs.push(f) if self.include?( self.class.const_get(f) )
        }
        return fs
      end
    end

    class MigrationFlags < OpenCL::Bitfield
      #:stopdoc:
      HOST = (1 << 0)
      CONTENT_UNDEFINED = (1 << 1)
      #:startdoc:
      def names
        fs = []
        %w( HOST CONTENT_UNDEFINED ).each { |f|
          fs.push(f) if self.include?( self.class.const_get(f) )
        }
        return fs
      end
    end

    class Type < OpenCL::Enum
      #:stopdoc:
      BUFFER = 0x10F0
      IMAGE2D = 0x10F1
      IMAGE3D = 0x10F2
      IMAGE2D_ARRAY = 0x10F3
      IMAGE1D = 0x10F4
      IMAGE1D_ARRAY = 0x10F5
      IMAGE1D_BUFFER = 0x10F6
      #:startdoc:
      def name
        %w( BUFFER IMAGE2D IMAGE3D IMAGE2D_ARRAY IMAGE1D IMAGE1D_ARRAY IMAGE1D_BUFFER ).each { |f|
          return f if @val == self.class.const_get(f)
        }
        return nil
      end
    end

  end
  class Program < FFI::ManagedStruct
    layout :dummy, :pointer
    #:stopdoc:
    REFERENCE_COUNT = 0x1160
    CONTEXT = 0x1161
    NUM_DEVICES = 0x1162
    DEVICES = 0x1163
    SOURCE = 0x1164
    BINARY_SIZES = 0x1165
    BINARIES = 0x1166
    NUM_KERNELS = 0x1167
    KERNEL_NAMES = 0x1168
    BUILD_STATUS = 0x1181
    BUILD_OPTIONS = 0x1182
    BUILD_LOG = 0x1183
    BINARY_TYPE = 0x1184
    BINARY_TYPE_NONE = 0x0
    BINARY_TYPE_COMPILED_OBJECT = 0x1
    BINARY_TYPE_LIBRARY = 0x2
    BINARY_TYPE_EXECUTABLE = 0x4
    #:startdoc:
    def self.release(ptr)
      error = OpenCL.clReleaseProgram(ptr.read_ptr)
      OpenCL.error_check( error )
    end
  end

  class Program
    class BinaryType < OpenCL::Enum
      #:stopdoc:
      NONE = 0x0
      COMPILED_OBJECT = 0x1
      LIBRARY = 0x2
      EXECUTABLE = 0x4
      #:startdoc:
      def name
        %w( NONE COMPILED_OBJECT LIBRARY EXECUTABLE ).each { |f|
          return f if @val == self.class.const_get(f)
        }
        return nil
      end
    end

  end
  class Kernel < FFI::ManagedStruct
    layout :dummy, :pointer
    #:stopdoc:
    FUNCTION_NAME = 0x1190
    NUM_ARGS = 0x1191
    REFERENCE_COUNT = 0x1192
    CONTEXT = 0x1193
    PROGRAM = 0x1194
    ATTRIBUTES = 0x1195
    ARG_ADDRESS_QUALIFIER = 0x1196
    ARG_ACCESS_QUALIFIER = 0x1197
    ARG_TYPE_NAME = 0x1198
    ARG_TYPE_QUALIFIER = 0x1199
    ARG_NAME = 0x119A
    ARG_ADDRESS_GLOBAL = 0x119B
    ARG_ADDRESS_LOCAL = 0x119C
    ARG_ADDRESS_CONSTANT = 0x119D
    ARG_ADDRESS_PRIVATE = 0x119E
    ARG_ACCESS_READ_ONLY = 0x11A0
    ARG_ACCESS_WRITE_ONLY = 0x11A1
    ARG_ACCESS_READ_WRITE = 0x11A2
    ARG_ACCESS_NONE = 0x11A3
    ARG_TYPE_NONE = 0
    ARG_TYPE_CONST = (1 << 0)
    ARG_TYPE_RESTRICT = (1 << 1)
    ARG_TYPE_VOLATILE = (1 << 2)
    WORK_GROUP_SIZE = 0x11B0
    COMPILE_WORK_GROUP_SIZE = 0x11B1
    LOCAL_MEM_SIZE = 0x11B2
    PREFERRED_WORK_GROUP_SIZE_MULTIPLE = 0x11B3
    PRIVATE_MEM_SIZE = 0x11B4
    GLOBAL_WORK_SIZE = 0x11B5
    #:startdoc:
    def self.release(ptr)
      error = OpenCL.clReleaseKernel(ptr.read_ptr)
      OpenCL.error_check( error )
    end
  end

  class Kernel
    class Arg
      #:stopdoc:
      ADDRESS_QUALIFIER = 0x1196
      ACCESS_QUALIFIER = 0x1197
      TYPE_NAME = 0x1198
      TYPE_QUALIFIER = 0x1199
      NAME = 0x119A
      ADDRESS_GLOBAL = 0x119B
      ADDRESS_LOCAL = 0x119C
      ADDRESS_CONSTANT = 0x119D
      ADDRESS_PRIVATE = 0x119E
      ACCESS_READ_ONLY = 0x11A0
      ACCESS_WRITE_ONLY = 0x11A1
      ACCESS_READ_WRITE = 0x11A2
      ACCESS_NONE = 0x11A3
      TYPE_NONE = 0
      TYPE_CONST = (1 << 0)
      TYPE_RESTRICT = (1 << 1)
      TYPE_VOLATILE = (1 << 2)
      #:startdoc:
    end

    class Arg
      class AddressQualifier < OpenCL::Enum
        #:stopdoc:
        GLOBAL = 0x119B
        LOCAL = 0x119C
        CONSTANT = 0x119D
        PRIVATE = 0x119E
        #:startdoc:
        def name
          %w( GLOBAL LOCAL CONSTANT PRIVATE ).each { |f|
            return f if @val == self.class.const_get(f)
          }
          return nil
        end
      end

      class AccessQualifier < OpenCL::Enum
        #:stopdoc:
        READ_ONLY = 0x11A0
        WRITE_ONLY = 0x11A1
        READ_WRITE = 0x11A2
        NONE = 0x11A3
        #:startdoc:
        def name
          %w( READ_ONLY WRITE_ONLY READ_WRITE NONE ).each { |f|
            return f if @val == self.class.const_get(f)
          }
          return nil
        end
      end

      class TypeQualifier < OpenCL::Bitfield
        #:stopdoc:
        NONE = 0
        CONST = (1 << 0)
        RESTRICT = (1 << 1)
        VOLATILE = (1 << 2)
        #:startdoc:
        def names
          fs = []
          %w( NONE CONST RESTRICT VOLATILE ).each { |f|
            fs.push(f) if self.include?( self.class.const_get(f) )
          }
          return fs
        end
      end

    end
  end
  class Event < FFI::ManagedStruct
    layout :dummy, :pointer
    #:stopdoc:
    COMMAND_QUEUE = 0x11D0
    COMMAND_TYPE = 0x11D1
    REFERENCE_COUNT = 0x11D2
    COMMAND_EXECUTION_STATUS = 0x11D3
    CONTEXT = 0x11D4
    #:startdoc:
    def self.release(ptr)
      error = OpenCL.clReleaseEvent(ptr.read_ptr)
      OpenCL.error_check( error )
    end
  end

  class Sampler < FFI::ManagedStruct
    layout :dummy, :pointer
    #:stopdoc:
    REFERENCE_COUNT = 0x1150
    CONTEXT = 0x1151
    NORMALIZED_COORDS = 0x1152
    ADDRESSING_MODE = 0x1153
    FILTER_MODE = 0x1154
    #:startdoc:
    def self.release(ptr)
      error = OpenCL.clReleaseSampler(ptr.read_ptr)
      OpenCL.error_check( error )
    end
  end

  class GLsync < FFI::ManagedStruct
    layout :dummy, :pointer
    #:stopdoc:
    
    #:startdoc:
    def self.release(ptr)
    end
  end

  class ChannelOrder < OpenCL::Enum
    #:stopdoc:
    R = 0x10B0
    A = 0x10B1
    RG = 0x10B2
    RA = 0x10B3
    RGB = 0x10B4
    RGBA = 0x10B5
    BGRA = 0x10B6
    ARGB = 0x10B7
    INTENSITY = 0x10B8
    LUMINANCE = 0x10B9
    Rx = 0x10BA
    RGx = 0x10BB
    RGBx = 0x10BC
    DEPTH = 0x10BD
    DEPTH_STENCIL = 0x10BE
    #:startdoc:
    def name
      %w( R A RG RA RGB RGBA BGRA ARGB INTENSITY LUMINANCE Rx RGx RGBx DEPTH DEPTH_STENCIL ).each { |f|
        return f if @val == self.class.const_get(f)
      }
      return nil
    end
  end

  class ChannelType < OpenCL::Enum
    #:stopdoc:
    SNORM_INT8 = 0x10D0
    SNORM_INT16 = 0x10D1
    UNORM_INT8 = 0x10D2
    UNORM_INT16 = 0x10D3
    UNORM_SHORT_565 = 0x10D4
    UNORM_SHORT_555 = 0x10D5
    UNORM_INT_101010 = 0x10D6
    SIGNED_INT8 = 0x10D7
    SIGNED_INT16 = 0x10D8
    SIGNED_INT32 = 0x10D9
    UNSIGNED_INT8 = 0x10DA
    UNSIGNED_INT16 = 0x10DB
    UNSIGNED_INT32 = 0x10DC
    HALF_FLOAT = 0x10DD
    FLOAT = 0x10DE
    UNORM_INT24 = 0x10DF
    #:startdoc:
    def name
      %w( SNORM_INT8 SNORM_INT16 UNORM_INT8 UNORM_INT16 UNORM_SHORT_565 UNORM_SHORT_555 UNORM_INT_101010 SIGNED_INT8 SIGNED_INT16 SIGNED_INT32 UNSIGNED_INT8 UNSIGNED_INT16 UNSIGNED_INT32 HALF_FLOAT FLOAT UNORM_INT24 ).each { |f|
        return f if @val == self.class.const_get(f)
      }
      return nil
    end
  end

  class AddressingMode < OpenCL::Enum
    #:stopdoc:
    NONE = 0x1130
    CLAMP_TO_EDGE = 0x1131
    CLAMP = 0x1132
    REPEAT = 0x1133
    MIRRORED_REPEAT = 0x1134
    #:startdoc:
    def name
      %w( NONE CLAMP_TO_EDGE CLAMP REPEAT MIRRORED_REPEAT ).each { |f|
        return f if @val == self.class.const_get(f)
      }
      return nil
    end
  end

  class FilterMode < OpenCL::Enum
    #:stopdoc:
    NEAREST = 0x1140
    LINEAR = 0x1141
    #:startdoc:
    def name
      %w( NEAREST LINEAR ).each { |f|
        return f if @val == self.class.const_get(f)
      }
      return nil
    end
  end

  class MapFlags < OpenCL::Bitfield
    #:stopdoc:
    READ = (1 << 0)
    WRITE = (1 << 1)
    WRITE_INVALIDATE_REGION = (1 << 2)
    #:startdoc:
    def names
      fs = []
      %w( READ WRITE WRITE_INVALIDATE_REGION ).each { |f|
        fs.push(f) if self.include?( self.class.const_get(f) )
      }
      return fs
    end
  end

  class CommandType < OpenCL::Enum
    #:stopdoc:
    NDRANGE_KERNEL = 0x11F0
    TASK = 0x11F1
    NATIVE_KERNEL = 0x11F2
    READ_BUFFER = 0x11F3
    WRITE_BUFFER = 0x11F4
    COPY_BUFFER = 0x11F5
    READ_IMAGE = 0x11F6
    WRITE_IMAGE = 0x11F7
    COPY_IMAGE = 0x11F8
    COPY_IMAGE_TO_BUFFER = 0x11F9
    COPY_BUFFER_TO_IMAGE = 0x11FA
    MAP_BUFFER = 0x11FB
    MAP_IMAGE = 0x11FC
    UNMAP_MEM_OBJECT = 0x11FD
    MARKER = 0x11FE
    ACQUIRE_GL_OBJECTS = 0x11FF
    RELEASE_GL_OBJECTS = 0x1200
    READ_BUFFER_RECT = 0x1201
    WRITE_BUFFER_RECT = 0x1202
    COPY_BUFFER_RECT = 0x1203
    USER = 0x1204
    BARRIER = 0x1205
    MIGRATE_MEM_OBJECTS = 0x1206
    FILL_BUFFER = 0x1207
    FILL_IMAGE = 0x1208
    #:startdoc:
    def name
      %w( NDRANGE_KERNEL TASK NATIVE_KERNEL READ_BUFFER WRITE_BUFFER COPY_BUFFER READ_IMAGE WRITE_IMAGE COPY_IMAGE COPY_IMAGE_TO_BUFFER COPY_BUFFER_TO_IMAGE MAP_BUFFER MAP_IMAGE UNMAP_MEM_OBJECT MARKER ACQUIRE_GL_OBJECTS RELEASE_GL_OBJECTS READ_BUFFER_RECT WRITE_BUFFER_RECT COPY_BUFFER_RECT USER BARRIER MIGRATE_MEM_OBJECTS FILL_BUFFER FILL_IMAGE ).each { |f|
        return f if @val == self.class.const_get(f)
      }
      return nil
    end
  end

  class GLObjectType < OpenCL::Enum
    #:stopdoc:
    BUFFER = 0x2000
    TEXTURE2D = 0x2001
    TEXTURE3D = 0x2002
    RENDERBUFFER = 0x2003
    TEXTURE2D_ARRAY = 0x200E
    TEXTURE1D = 0x200F
    TEXTURE1D_ARRAY = 0x2010
    TEXTURE_BUFFER = 0x2011
    #:startdoc:
    def name
      %w( BUFFER TEXTURE2D TEXTURE3D RENDERBUFFER TEXTURE2D_ARRAY TEXTURE1D TEXTURE1D_ARRAY TEXTURE_BUFFER ).each { |f|
        return f if @val == self.class.const_get(f)
      }
      return nil
    end
  end

  class Image < Mem
    layout :dummy, :pointer
    #:stopdoc:
    FORMAT_MISMATCH = -9
    FORMAT_NOT_SUPPORTED = -10
    FORMAT = 0x1110
    ELEMENT_SIZE = 0x1111
    ROW_PITCH = 0x1112
    SLICE_PITCH = 0x1113
    WIDTH = 0x1114
    HEIGHT = 0x1115
    DEPTH = 0x1116
    ARRAY_SIZE = 0x1117
    BUFFER = 0x1118
    NUM_MIP_LEVELS = 0x1119
    NUM_SAMPLES = 0x111A
    ROW_ALIGNMENT_QCOM = 0x40A2
    SLICE_ALIGNMENT_QCOM = 0x40A3
    #:startdoc:
  end
  attach_function :clGetPlatformIDs, [:cl_uint,:pointer,:pointer], :cl_int
  attach_function :clGetPlatformInfo, [Platform,:cl_platform_info,:size_t,:pointer,:pointer], :cl_int
  attach_function :clGetDeviceIDs, [Platform,:cl_device_type,:cl_uint,:pointer,:pointer], :cl_int
  attach_function :clGetDeviceInfo, [Device,:cl_device_info,:size_t,:pointer,:pointer], :cl_int
  attach_function :clCreateSubDevices, [Device,:pointer,:cl_uint,:pointer,:pointer], :cl_int
  attach_function :clRetainDevice, [Device], :cl_int
  attach_function :clReleaseDevice, [Device], :cl_int
  callback :clCreateContext_notify, [:pointer,:pointer,:size_t,:pointer], :void
  attach_function :clCreateContext, [:pointer,:cl_uint,:pointer,:clCreateContext_notify,:pointer,:pointer], Context
  callback :clCreateContextFromType_notify, [:pointer,:pointer,:size_t,:pointer], :void
  attach_function :clCreateContextFromType, [:pointer,:cl_device_type,:clCreateContextFromType_notify,:pointer,:pointer], Context
  attach_function :clRetainContext, [Context], :cl_int
  attach_function :clReleaseContext, [Context], :cl_int
  attach_function :clGetContextInfo, [Context,:cl_context_info,:size_t,:pointer,:pointer], :cl_int
  attach_function :clCreateCommandQueue, [Context,Device,:cl_command_queue_properties,:pointer], CommandQueue
  attach_function :clRetainCommandQueue, [CommandQueue], :cl_int
  attach_function :clReleaseCommandQueue, [CommandQueue], :cl_int
  attach_function :clGetCommandQueueInfo, [CommandQueue,:cl_command_queue_info,:size_t,:pointer,:pointer], :cl_int
  attach_function :clCreateBuffer, [Context,:cl_mem_flags,:size_t,:pointer,:pointer], Mem
  attach_function :clCreateSubBuffer, [Mem,:cl_mem_flags,:cl_buffer_create_type,:pointer,:pointer], Mem
  attach_function :clCreateImage, [Context,:cl_mem_flags,:pointer,:pointer,:pointer,:pointer], Mem
  attach_function :clRetainMemObject, [Mem], :cl_int
  attach_function :clReleaseMemObject, [Mem], :cl_int
  attach_function :clGetSupportedImageFormats, [Context,:cl_mem_flags,:cl_mem_object_type,:cl_uint,:pointer,:pointer], :cl_int
  attach_function :clGetMemObjectInfo, [Mem,:cl_mem_info,:size_t,:pointer,:pointer], :cl_int
  attach_function :clGetImageInfo, [Mem,:cl_image_info,:size_t,:pointer,:pointer], :cl_int
  callback :clSetMemObjectDestructorCallback_notify, [Mem.by_ref,:pointer], :void
  attach_function :clSetMemObjectDestructorCallback, [Mem,:clSetMemObjectDestructorCallback_notify,:pointer], :cl_int
  attach_function :clCreateSampler, [Context,:cl_bool,:cl_addressing_mode,:cl_filter_mode,:pointer], Sampler
  attach_function :clRetainSampler, [Sampler], :cl_int
  attach_function :clReleaseSampler, [Sampler], :cl_int
  attach_function :clGetSamplerInfo, [Sampler,:cl_sampler_info,:size_t,:pointer,:pointer], :cl_int
  attach_function :clCreateProgramWithSource, [Context,:cl_uint,:pointer,:pointer,:pointer], Program
  attach_function :clCreateProgramWithBinary, [Context,:cl_uint,:pointer,:pointer,:pointer,:pointer,:pointer], Program
  attach_function :clCreateProgramWithBuiltInKernels, [Context,:cl_uint,:pointer,:pointer,:pointer], Program
  attach_function :clRetainProgram, [Program], :cl_int
  attach_function :clReleaseProgram, [Program], :cl_int
  callback :clBuildProgram_notify, [Program.by_ref,:pointer], :void
  attach_function :clBuildProgram, [Program,:cl_uint,:pointer,:pointer,:clBuildProgram_notify,:pointer], :cl_int
  callback :clCompileProgram_notify, [Program.by_ref,:pointer], :void
  attach_function :clCompileProgram, [Program,:cl_uint,:pointer,:pointer,:cl_uint,:pointer,:pointer,:clCompileProgram_notify,:pointer], :cl_int
  callback :clLinkProgram_notify, [Program.by_ref,:pointer], :void
  attach_function :clLinkProgram, [Context,:cl_uint,:pointer,:pointer,:cl_uint,:pointer,:clLinkProgram_notify,:pointer,:pointer], Program
  attach_function :clUnloadPlatformCompiler, [Platform], :cl_int
  attach_function :clGetProgramInfo, [Program,:cl_program_info,:size_t,:pointer,:pointer], :cl_int
  attach_function :clGetProgramBuildInfo, [Program,Device,:cl_program_build_info,:size_t,:pointer,:pointer], :cl_int
  attach_function :clCreateKernel, [Program,:pointer,:pointer], Kernel
  attach_function :clCreateKernelsInProgram, [Program,:cl_uint,:pointer,:pointer], :cl_int
  attach_function :clRetainKernel, [Kernel], :cl_int
  attach_function :clReleaseKernel, [Kernel], :cl_int
  attach_function :clSetKernelArg, [Kernel,:cl_uint,:size_t,:pointer], :cl_int
  attach_function :clGetKernelInfo, [Kernel,:cl_kernel_info,:size_t,:pointer,:pointer], :cl_int
  attach_function :clGetKernelArgInfo, [Kernel,:cl_uint,:cl_kernel_arg_info,:size_t,:pointer,:pointer], :cl_int
  attach_function :clGetKernelWorkGroupInfo, [Kernel,Device,:cl_kernel_work_group_info,:size_t,:pointer,:pointer], :cl_int
  attach_function :clWaitForEvents, [:cl_uint,:pointer], :cl_int
  attach_function :clGetEventInfo, [Event,:cl_event_info,:size_t,:pointer,:pointer], :cl_int
  attach_function :clCreateUserEvent, [Context,:pointer], Event
  attach_function :clRetainEvent, [Event], :cl_int
  attach_function :clReleaseEvent, [Event], :cl_int
  attach_function :clSetUserEventStatus, [Event,:cl_int], :cl_int
  callback :clSetEventCallback_notify, [Event.by_ref,:cl_int,:pointer], :void
  attach_function :clSetEventCallback, [Event,:cl_int,:clSetEventCallback_notify,:pointer], :cl_int
  attach_function :clGetEventProfilingInfo, [Event,:cl_profiling_info,:size_t,:pointer,:pointer], :cl_int
  attach_function :clFlush, [CommandQueue], :cl_int
  attach_function :clFinish, [CommandQueue], :cl_int
  attach_function :clEnqueueReadBuffer, [CommandQueue,Mem,:cl_bool,:size_t,:size_t,:pointer,:cl_uint,:pointer,:pointer], :cl_int
  attach_function :clEnqueueReadBufferRect, [CommandQueue,Mem,:cl_bool,:pointer,:pointer,:pointer,:size_t,:size_t,:size_t,:size_t,:pointer,:cl_uint,:pointer,:pointer], :cl_int
  attach_function :clEnqueueWriteBuffer, [CommandQueue,Mem,:cl_bool,:size_t,:size_t,:pointer,:cl_uint,:pointer,:pointer], :cl_int
  attach_function :clEnqueueWriteBufferRect, [CommandQueue,Mem,:cl_bool,:pointer,:pointer,:pointer,:size_t,:size_t,:size_t,:size_t,:pointer,:cl_uint,:pointer,:pointer], :cl_int
  attach_function :clEnqueueFillBuffer, [CommandQueue,Mem,:pointer,:size_t,:size_t,:size_t,:cl_uint,:pointer,:pointer], :cl_int
  attach_function :clEnqueueCopyBuffer, [CommandQueue,Mem,Mem,:size_t,:size_t,:size_t,:cl_uint,:pointer,:pointer], :cl_int
  attach_function :clEnqueueCopyBufferRect, [CommandQueue,Mem,Mem,:pointer,:pointer,:pointer,:size_t,:size_t,:size_t,:size_t,:cl_uint,:pointer,:pointer], :cl_int
  attach_function :clEnqueueReadImage, [CommandQueue,Mem,:cl_bool,:pointer,:pointer,:size_t,:size_t,:pointer,:cl_uint,:pointer,:pointer], :cl_int
  attach_function :clEnqueueWriteImage, [CommandQueue,Mem,:cl_bool,:pointer,:pointer,:size_t,:size_t,:pointer,:cl_uint,:pointer,:pointer], :cl_int
  attach_function :clEnqueueFillImage, [CommandQueue,Mem,:pointer,:pointer,:pointer,:cl_uint,:pointer,:pointer], :cl_int
  attach_function :clEnqueueCopyImage, [CommandQueue,Mem,Mem,:pointer,:pointer,:pointer,:cl_uint,:pointer,:pointer], :cl_int
  attach_function :clEnqueueCopyImageToBuffer, [CommandQueue,Mem,Mem,:pointer,:pointer,:size_t,:cl_uint,:pointer,:pointer], :cl_int
  attach_function :clEnqueueCopyBufferToImage, [CommandQueue,Mem,Mem,:size_t,:pointer,:pointer,:cl_uint,:pointer,:pointer], :cl_int
  attach_function :clEnqueueMapBuffer, [CommandQueue,Mem,:cl_bool,:cl_map_flags,:size_t,:size_t,:cl_uint,:pointer,:pointer,:pointer], :pointer
  attach_function :clEnqueueMapImage, [CommandQueue,Mem,:cl_bool,:cl_map_flags,:pointer,:pointer,:pointer,:pointer,:cl_uint,:pointer,:pointer,:pointer], :pointer
  attach_function :clEnqueueUnmapMemObject, [CommandQueue,Mem,:pointer,:cl_uint,:pointer,:pointer], :cl_int
  attach_function :clEnqueueMigrateMemObjects, [CommandQueue,:cl_uint,:pointer,:cl_mem_migration_flags,:cl_uint,:pointer,:pointer], :cl_int
  attach_function :clEnqueueNDRangeKernel, [CommandQueue,Kernel,:cl_uint,:pointer,:pointer,:pointer,:cl_uint,:pointer,:pointer], :cl_int
  attach_function :clEnqueueTask, [CommandQueue,Kernel,:cl_uint,:pointer,:pointer], :cl_int
  callback :clEnqueueNativeKernel_notify, [:pointer], :void
  attach_function :clEnqueueNativeKernel, [CommandQueue,:clEnqueueNativeKernel_notify,:pointer,:size_t,:cl_uint,:pointer,:pointer,:cl_uint,:pointer,:pointer], :cl_int
  attach_function :clEnqueueMarkerWithWaitList, [CommandQueue,:cl_uint,:pointer,:pointer], :cl_int
  attach_function :clEnqueueBarrierWithWaitList, [CommandQueue,:cl_uint,:pointer,:pointer], :cl_int
  attach_function :clGetExtensionFunctionAddressForPlatform, [Platform,:pointer], :pointer
  attach_function :clCreateImage2D, [Context,:cl_mem_flags,:pointer,:size_t,:size_t,:size_t,:pointer,:pointer], Mem
  attach_function :clCreateImage3D, [Context,:cl_mem_flags,:pointer,:size_t,:size_t,:size_t,:size_t,:size_t,:pointer,:pointer], Mem
  attach_function :clEnqueueMarker, [CommandQueue,:pointer], :cl_int
  attach_function :clEnqueueWaitForEvents, [CommandQueue,:cl_uint,:pointer], :cl_int
  attach_function :clEnqueueBarrier, [CommandQueue], :cl_int
  attach_function :clUnloadCompiler, [:void], :cl_int
  attach_function :clGetExtensionFunctionAddress, [:pointer], :pointer
  attach_function :clCreateFromGLBuffer, [Context,:cl_mem_flags,:cl_GLuint,:pointer], Mem
  attach_function :clCreateFromGLTexture, [Context,:cl_mem_flags,:cl_GLenum,:cl_GLint,:cl_GLuint,:pointer], Mem
  attach_function :clCreateFromGLRenderbuffer, [Context,:cl_mem_flags,:cl_GLuint,:pointer], Mem
  attach_function :clGetGLObjectInfo, [Mem,:pointer,:pointer], :cl_int
  attach_function :clGetGLTextureInfo, [Mem,:cl_gl_texture_info,:size_t,:pointer,:pointer], :cl_int
  attach_function :clEnqueueAcquireGLObjects, [CommandQueue,:cl_uint,:pointer,:cl_uint,:pointer,:pointer], :cl_int
  attach_function :clEnqueueReleaseGLObjects, [CommandQueue,:cl_uint,:pointer,:cl_uint,:pointer,:pointer], :cl_int
  attach_function :clCreateFromGLTexture2D, [Context,:cl_mem_flags,:cl_GLenum,:cl_GLint,:cl_GLuint,:pointer], Mem
  attach_function :clCreateFromGLTexture3D, [Context,:cl_mem_flags,:cl_GLenum,:cl_GLint,:cl_GLuint,:pointer], Mem
  attach_function :clGetGLContextInfoKHR, [:pointer,:cl_gl_context_info,:size_t,:pointer,:pointer], :cl_int
  attach_function :clReleaseDeviceEXT, [Device], :cl_int
  attach_function :clRetainDeviceEXT, [Device], :cl_int
  attach_function :clCreateSubDevicesEXT, [Device,:pointer,:cl_uint,:pointer,:pointer], :cl_int
  attach_function :clCreateEventFromGLsyncKHR, [Context,GLsync,:pointer], Event
end

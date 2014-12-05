require 'ffi'

# Maps the OpenCL API using FFI
module OpenCL
  extend FFI::Library
  begin
    ffi_lib "OpenCL"
  rescue LoadError => e
    begin
      ffi_lib "libOpenCL.so.1"
    rescue LoadError => e
      begin
        ffi_lib '/System/Library/Frameworks/OpenCL.framework/OpenCL'
      rescue LoadError => e
        raise "OpenCL implementation not found!"
      end
    end
  end
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
  INVALID_PIPE_SIZE = -69
  INVALID_DEVICE_QUEUE = -70
  VERSION_1_0 = 1
  VERSION_1_1 = 1
  VERSION_1_2 = 1
  VERSION_2_0 = 1
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
  DEVICE_QUEUE_ON_HOST_PROPERTIES = 0x102A
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
  DEVICE_MAX_READ_WRITE_IMAGE_ARGS = 0x104C
  DEVICE_MAX_GLOBAL_VARIABLE_SIZE = 0x104D
  DEVICE_QUEUE_ON_DEVICE_PROPERTIES = 0x104E
  DEVICE_QUEUE_ON_DEVICE_PREFERRED_SIZE = 0x104F
  DEVICE_QUEUE_ON_DEVICE_MAX_SIZE = 0x1050
  DEVICE_MAX_ON_DEVICE_QUEUES = 0x1051
  DEVICE_MAX_ON_DEVICE_EVENTS = 0x1052
  DEVICE_SVM_CAPABILITIES = 0x1053
  DEVICE_GLOBAL_VARIABLE_PREFERRED_TOTAL_SIZE = 0x1054
  DEVICE_MAX_PIPE_ARGS = 0x1055
  DEVICE_PIPE_MAX_ACTIVE_RESERVATIONS = 0x1056
  DEVICE_PIPE_MAX_PACKET_SIZE = 0x1057
  DEVICE_PREFERRED_PLATFORM_ATOMIC_ALIGNMENT = 0x1058
  DEVICE_PREFERRED_GLOBAL_ATOMIC_ALIGNMENT = 0x1059
  DEVICE_PREFERRED_LOCAL_ATOMIC_ALIGNMENT = 0x105A
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
  QUEUE_ON_DEVICE = (1 << 2)
  QUEUE_ON_DEVICE_DEFAULT = (1 << 3)
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
  DEVICE_SVM_COARSE_GRAIN_BUFFER = (1 << 0)
  DEVICE_SVM_FINE_GRAIN_BUFFER = (1 << 1)
  DEVICE_SVM_FINE_GRAIN_SYSTEM = (1 << 2)
  DEVICE_SVM_ATOMICS = (1 << 3)
  QUEUE_CONTEXT = 0x1090
  QUEUE_DEVICE = 0x1091
  QUEUE_REFERENCE_COUNT = 0x1092
  QUEUE_PROPERTIES = 0x1093
  QUEUE_SIZE = 0x1094
  MEM_READ_WRITE = (1 << 0)
  MEM_WRITE_ONLY = (1 << 1)
  MEM_READ_ONLY = (1 << 2)
  MEM_USE_HOST_PTR = (1 << 3)
  MEM_ALLOC_HOST_PTR = (1 << 4)
  MEM_COPY_HOST_PTR = (1 << 5)
  MEM_HOST_WRITE_ONLY = (1 << 7)
  MEM_HOST_READ_ONLY = (1 << 8)
  MEM_HOST_NO_ACCESS = (1 << 9)
  MEM_SVM_FINE_GRAIN_BUFFER = (1 << 10)
  MEM_SVM_ATOMICS = (1 << 11)
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
  sRGB = 0x10BF
  sRGBx = 0x10C0
  sRGBA = 0x10C1
  sBGRA = 0x10C2
  ABGR = 0x10C3
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
  MEM_OBJECT_PIPE = 0x10F7
  MEM_TYPE = 0x1100
  MEM_FLAGS = 0x1101
  MEM_SIZE = 0x1102
  MEM_HOST_PTR = 0x1103
  MEM_MAP_COUNT = 0x1104
  MEM_REFERENCE_COUNT = 0x1105
  MEM_CONTEXT = 0x1106
  MEM_ASSOCIATED_MEMOBJECT = 0x1107
  MEM_OFFSET = 0x1108
  MEM_USES_SVM_POINTER = 0x1109
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
  PIPE_PACKET_SIZE = 0x1120
  PIPE_MAX_PACKETS = 0x1121
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
  SAMPLER_MIP_FILTER_MODE = 0x1155
  SAMPLER_LOD_MIN = 0x1156
  SAMPLER_LOD_MAX = 0x1157
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
  PROGRAM_BUILD_GLOBAL_VARIABLE_TOTAL_SIZE = 0x1185
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
  KERNEL_ARG_TYPE_PIPE = (1 << 3)
  KERNEL_WORK_GROUP_SIZE = 0x11B0
  KERNEL_COMPILE_WORK_GROUP_SIZE = 0x11B1
  KERNEL_LOCAL_MEM_SIZE = 0x11B2
  KERNEL_PREFERRED_WORK_GROUP_SIZE_MULTIPLE = 0x11B3
  KERNEL_PRIVATE_MEM_SIZE = 0x11B4
  KERNEL_GLOBAL_WORK_SIZE = 0x11B5
  KERNEL_EXEC_INFO_SVM_PTRS = 0x11B6
  KERNEL_EXEC_INFO_SVM_FINE_GRAIN_SYSTEM = 0x11B7
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
  COMMAND_SVM_FREE = 0x1209
  COMMAND_SVM_MEMCPY = 0x120A
  COMMAND_SVM_MEMFILL = 0x120B
  COMMAND_SVM_MAP = 0x120C
  COMMAND_SVM_UNMAP = 0x120D
  COMPLETE = 0x0
  RUNNING = 0x1
  SUBMITTED = 0x2
  QUEUED = 0x3
  BUFFER_CREATE_TYPE_REGION = 0x1220
  PROFILING_COMMAND_QUEUED = 0x1280
  PROFILING_COMMAND_SUBMIT = 0x1281
  PROFILING_COMMAND_START = 0x1282
  PROFILING_COMMAND_END = 0x1283
  PROFILING_COMMAND_COMPLETE = 0x1284
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
  DEVICE_SPIR_VERSIONS = 0x40E0
  PROGRAM_BINARY_TYPE_INTERMEDIATE = 0x40E1
  DEVICE_COMPUTE_CAPABILITY_MAJOR_NV = 0x4000
  DEVICE_COMPUTE_CAPABILITY_MINOR_NV = 0x4001
  DEVICE_REGISTERS_PER_BLOCK_NV = 0x4002
  DEVICE_WARP_SIZE_NV = 0x4003
  DEVICE_GPU_OVERLAP_NV = 0x4004
  DEVICE_KERNEL_EXEC_TIMEOUT_NV = 0x4005
  DEVICE_INTEGRATED_MEMORY_NV = 0x4006
  DEVICE_PROFILING_TIMER_OFFSET_AMD = 0x4036
  PRINTF_CALLBACK_ARM = 0x40B0
  PRINTF_BUFFERSIZE_ARM = 0x40B1
  DEVICE_PAGE_SIZE_QCOM = 0x40A1
  IMAGE_ROW_ALIGNMENT_QCOM = 0x40A2
  IMAGE_SLICE_ALIGNMENT_QCOM = 0x40A3
  MEM_HOST_UNCACHED_QCOM = 0x40A4
  MEM_HOST_WRITEBACK_QCOM = 0x40A5
  MEM_HOST_WRITETHROUGH_QCOM = 0x40A6
  MEM_HOST_WRITE_COMBINING_QCOM = 0x40A7
  MEM_ION_HOST_PTR_QCOM = 0x40A8
  #:startdoc:
  # Parent claas to map OpenCL errors, and is used to raise unknown errors
  class Error < StandardError
    attr_reader :code

    def initialize(code)
      @code = code
      super("#{code}")
    end

    #:stopdoc:
    CLASSES = {}
    #:startdoc:

    private_constant :CLASSES

    # Returns the class corresponding to the error code (if any)
    def self.error_class(errcode)
      return CLASSES[errcode]
    end

    # Returns a string representing the name corresponding to the error code
    def self.name(code)
      if CLASSES[code] then
        return CLASSES[code].name
      else
        return "#{code}"
      end
    end

    # Returns a string representing the name corresponding to the error
    def name
      return "#{@code}"
    end

    # Represents the OpenCL CL_PLATFORM_NOT_FOUND_KHR error
    class PLATFORM_NOT_FOUND_KHR < Error

      # Initilizes code to -1001
      def initialize
        super(-1001)
      end

      # Returns a string representing the name corresponding to the error classe
      def self.name
        return "PLATFORM_NOT_FOUND_KHR"
      end

      # Returns a string representing the name corresponding to the error
      def name
        return "PLATFORM_NOT_FOUND_KHR"
      end

      # Returns the code corresponding to this error class
      def self.code
        return -1001
      end

    end

    CLASSES[-1001] = PLATFORM_NOT_FOUND_KHR
    PlatformNotFoundKHR = PLATFORM_NOT_FOUND_KHR

    # Represents the OpenCL CL_INVALID_GL_SHAREGROUP_REFERENCE_KHR error
    class INVALID_GL_SHAREGROUP_REFERENCE_KHR < Error

      # Initilizes code to -1000
      def initialize
        super(-1000)
      end

      # Returns a string representing the name corresponding to the error classe
      def self.name
        return "INVALID_GL_SHAREGROUP_REFERENCE_KHR"
      end

      # Returns a string representing the name corresponding to the error
      def name
        return "INVALID_GL_SHAREGROUP_REFERENCE_KHR"
      end

      # Returns the code corresponding to this error class
      def self.code
        return -1000
      end

    end

    CLASSES[-1000] = INVALID_GL_SHAREGROUP_REFERENCE_KHR
    InvalidGLSharegroupReferenceKHR = INVALID_GL_SHAREGROUP_REFERENCE_KHR

    # Represents the OpenCL CL_COMPILER_NOT_AVAILABLE error
    class COMPILER_NOT_AVAILABLE < Error

      # Initilizes code to -3
      def initialize
        super(-3)
      end

      # Returns a string representing the name corresponding to the error classe
      def self.name
        return "COMPILER_NOT_AVAILABLE"
      end

      # Returns a string representing the name corresponding to the error
      def name
        return "COMPILER_NOT_AVAILABLE"
      end

      # Returns the code corresponding to this error class
      def self.code
        return -3
      end

    end

    CLASSES[-3] = COMPILER_NOT_AVAILABLE
    CompilerNotAvailable = COMPILER_NOT_AVAILABLE

    # Represents the OpenCL CL_DEVICE_NOT_AVAILABLE error
    class DEVICE_NOT_AVAILABLE < Error

      # Initilizes code to -2
      def initialize
        super(-2)
      end

      # Returns a string representing the name corresponding to the error classe
      def self.name
        return "DEVICE_NOT_AVAILABLE"
      end

      # Returns a string representing the name corresponding to the error
      def name
        return "DEVICE_NOT_AVAILABLE"
      end

      # Returns the code corresponding to this error class
      def self.code
        return -2
      end

    end

    CLASSES[-2] = DEVICE_NOT_AVAILABLE
    DeviceNotAvailable = DEVICE_NOT_AVAILABLE

    # Represents the OpenCL CL_DEVICE_NOT_FOUND error
    class DEVICE_NOT_FOUND < Error

      # Initilizes code to -1
      def initialize
        super(-1)
      end

      # Returns a string representing the name corresponding to the error classe
      def self.name
        return "DEVICE_NOT_FOUND"
      end

      # Returns a string representing the name corresponding to the error
      def name
        return "DEVICE_NOT_FOUND"
      end

      # Returns the code corresponding to this error class
      def self.code
        return -1
      end

    end

    CLASSES[-1] = DEVICE_NOT_FOUND
    DeviceNotFound = DEVICE_NOT_FOUND

    # Represents the OpenCL CL_INVALID_DEVICE_QUEUE error
    class INVALID_DEVICE_QUEUE < Error

      # Initilizes code to -70
      def initialize
        super(-70)
      end

      # Returns a string representing the name corresponding to the error classe
      def self.name
        return "INVALID_DEVICE_QUEUE"
      end

      # Returns a string representing the name corresponding to the error
      def name
        return "INVALID_DEVICE_QUEUE"
      end

      # Returns the code corresponding to this error class
      def self.code
        return -70
      end

    end

    CLASSES[-70] = INVALID_DEVICE_QUEUE
    InvalidDeviceQueue = INVALID_DEVICE_QUEUE

    # Represents the OpenCL CL_INVALID_PIPE_SIZE error
    class INVALID_PIPE_SIZE < Error

      # Initilizes code to -69
      def initialize
        super(-69)
      end

      # Returns a string representing the name corresponding to the error classe
      def self.name
        return "INVALID_PIPE_SIZE"
      end

      # Returns a string representing the name corresponding to the error
      def name
        return "INVALID_PIPE_SIZE"
      end

      # Returns the code corresponding to this error class
      def self.code
        return -69
      end

    end

    CLASSES[-69] = INVALID_PIPE_SIZE
    InvalidPipeSize = INVALID_PIPE_SIZE

    # Represents the OpenCL CL_INVALID_DEVICE_PARTITION_COUNT error
    class INVALID_DEVICE_PARTITION_COUNT < Error

      # Initilizes code to -68
      def initialize
        super(-68)
      end

      # Returns a string representing the name corresponding to the error classe
      def self.name
        return "INVALID_DEVICE_PARTITION_COUNT"
      end

      # Returns a string representing the name corresponding to the error
      def name
        return "INVALID_DEVICE_PARTITION_COUNT"
      end

      # Returns the code corresponding to this error class
      def self.code
        return -68
      end

    end

    CLASSES[-68] = INVALID_DEVICE_PARTITION_COUNT
    InvalidDevicePartitionCount = INVALID_DEVICE_PARTITION_COUNT

    # Represents the OpenCL CL_INVALID_LINKER_OPTIONS error
    class INVALID_LINKER_OPTIONS < Error

      # Initilizes code to -67
      def initialize
        super(-67)
      end

      # Returns a string representing the name corresponding to the error classe
      def self.name
        return "INVALID_LINKER_OPTIONS"
      end

      # Returns a string representing the name corresponding to the error
      def name
        return "INVALID_LINKER_OPTIONS"
      end

      # Returns the code corresponding to this error class
      def self.code
        return -67
      end

    end

    CLASSES[-67] = INVALID_LINKER_OPTIONS
    InvalidLinkerOptions = INVALID_LINKER_OPTIONS

    # Represents the OpenCL CL_INVALID_COMPILER_OPTIONS error
    class INVALID_COMPILER_OPTIONS < Error

      # Initilizes code to -66
      def initialize
        super(-66)
      end

      # Returns a string representing the name corresponding to the error classe
      def self.name
        return "INVALID_COMPILER_OPTIONS"
      end

      # Returns a string representing the name corresponding to the error
      def name
        return "INVALID_COMPILER_OPTIONS"
      end

      # Returns the code corresponding to this error class
      def self.code
        return -66
      end

    end

    CLASSES[-66] = INVALID_COMPILER_OPTIONS
    InvalidCompilerOptions = INVALID_COMPILER_OPTIONS

    # Represents the OpenCL CL_INVALID_IMAGE_DESCRIPTOR error
    class INVALID_IMAGE_DESCRIPTOR < Error

      # Initilizes code to -65
      def initialize
        super(-65)
      end

      # Returns a string representing the name corresponding to the error classe
      def self.name
        return "INVALID_IMAGE_DESCRIPTOR"
      end

      # Returns a string representing the name corresponding to the error
      def name
        return "INVALID_IMAGE_DESCRIPTOR"
      end

      # Returns the code corresponding to this error class
      def self.code
        return -65
      end

    end

    CLASSES[-65] = INVALID_IMAGE_DESCRIPTOR
    InvalidImageDescriptor = INVALID_IMAGE_DESCRIPTOR

    # Represents the OpenCL CL_INVALID_PROPERTY error
    class INVALID_PROPERTY < Error

      # Initilizes code to -64
      def initialize
        super(-64)
      end

      # Returns a string representing the name corresponding to the error classe
      def self.name
        return "INVALID_PROPERTY"
      end

      # Returns a string representing the name corresponding to the error
      def name
        return "INVALID_PROPERTY"
      end

      # Returns the code corresponding to this error class
      def self.code
        return -64
      end

    end

    CLASSES[-64] = INVALID_PROPERTY
    InvalidProperty = INVALID_PROPERTY

    # Represents the OpenCL CL_INVALID_GLOBAL_WORK_SIZE error
    class INVALID_GLOBAL_WORK_SIZE < Error

      # Initilizes code to -63
      def initialize
        super(-63)
      end

      # Returns a string representing the name corresponding to the error classe
      def self.name
        return "INVALID_GLOBAL_WORK_SIZE"
      end

      # Returns a string representing the name corresponding to the error
      def name
        return "INVALID_GLOBAL_WORK_SIZE"
      end

      # Returns the code corresponding to this error class
      def self.code
        return -63
      end

    end

    CLASSES[-63] = INVALID_GLOBAL_WORK_SIZE
    InvalidGLOBALWorkSize = INVALID_GLOBAL_WORK_SIZE

    # Represents the OpenCL CL_INVALID_MIP_LEVEL error
    class INVALID_MIP_LEVEL < Error

      # Initilizes code to -62
      def initialize
        super(-62)
      end

      # Returns a string representing the name corresponding to the error classe
      def self.name
        return "INVALID_MIP_LEVEL"
      end

      # Returns a string representing the name corresponding to the error
      def name
        return "INVALID_MIP_LEVEL"
      end

      # Returns the code corresponding to this error class
      def self.code
        return -62
      end

    end

    CLASSES[-62] = INVALID_MIP_LEVEL
    InvalidMipLevel = INVALID_MIP_LEVEL

    # Represents the OpenCL CL_INVALID_BUFFER_SIZE error
    class INVALID_BUFFER_SIZE < Error

      # Initilizes code to -61
      def initialize
        super(-61)
      end

      # Returns a string representing the name corresponding to the error classe
      def self.name
        return "INVALID_BUFFER_SIZE"
      end

      # Returns a string representing the name corresponding to the error
      def name
        return "INVALID_BUFFER_SIZE"
      end

      # Returns the code corresponding to this error class
      def self.code
        return -61
      end

    end

    CLASSES[-61] = INVALID_BUFFER_SIZE
    InvalidBufferSize = INVALID_BUFFER_SIZE

    # Represents the OpenCL CL_INVALID_GL_OBJECT error
    class INVALID_GL_OBJECT < Error

      # Initilizes code to -60
      def initialize
        super(-60)
      end

      # Returns a string representing the name corresponding to the error classe
      def self.name
        return "INVALID_GL_OBJECT"
      end

      # Returns a string representing the name corresponding to the error
      def name
        return "INVALID_GL_OBJECT"
      end

      # Returns the code corresponding to this error class
      def self.code
        return -60
      end

    end

    CLASSES[-60] = INVALID_GL_OBJECT
    InvalidGLObject = INVALID_GL_OBJECT

    # Represents the OpenCL CL_INVALID_OPERATION error
    class INVALID_OPERATION < Error

      # Initilizes code to -59
      def initialize
        super(-59)
      end

      # Returns a string representing the name corresponding to the error classe
      def self.name
        return "INVALID_OPERATION"
      end

      # Returns a string representing the name corresponding to the error
      def name
        return "INVALID_OPERATION"
      end

      # Returns the code corresponding to this error class
      def self.code
        return -59
      end

    end

    CLASSES[-59] = INVALID_OPERATION
    InvalidOperation = INVALID_OPERATION

    # Represents the OpenCL CL_INVALID_EVENT error
    class INVALID_EVENT < Error

      # Initilizes code to -58
      def initialize
        super(-58)
      end

      # Returns a string representing the name corresponding to the error classe
      def self.name
        return "INVALID_EVENT"
      end

      # Returns a string representing the name corresponding to the error
      def name
        return "INVALID_EVENT"
      end

      # Returns the code corresponding to this error class
      def self.code
        return -58
      end

    end

    CLASSES[-58] = INVALID_EVENT
    InvalidEvent = INVALID_EVENT

    # Represents the OpenCL CL_INVALID_EVENT_WAIT_LIST error
    class INVALID_EVENT_WAIT_LIST < Error

      # Initilizes code to -57
      def initialize
        super(-57)
      end

      # Returns a string representing the name corresponding to the error classe
      def self.name
        return "INVALID_EVENT_WAIT_LIST"
      end

      # Returns a string representing the name corresponding to the error
      def name
        return "INVALID_EVENT_WAIT_LIST"
      end

      # Returns the code corresponding to this error class
      def self.code
        return -57
      end

    end

    CLASSES[-57] = INVALID_EVENT_WAIT_LIST
    InvalidEventWaitList = INVALID_EVENT_WAIT_LIST

    # Represents the OpenCL CL_INVALID_GLOBAL_OFFSET error
    class INVALID_GLOBAL_OFFSET < Error

      # Initilizes code to -56
      def initialize
        super(-56)
      end

      # Returns a string representing the name corresponding to the error classe
      def self.name
        return "INVALID_GLOBAL_OFFSET"
      end

      # Returns a string representing the name corresponding to the error
      def name
        return "INVALID_GLOBAL_OFFSET"
      end

      # Returns the code corresponding to this error class
      def self.code
        return -56
      end

    end

    CLASSES[-56] = INVALID_GLOBAL_OFFSET
    InvalidGLOBALOffset = INVALID_GLOBAL_OFFSET

    # Represents the OpenCL CL_INVALID_WORK_ITEM_SIZE error
    class INVALID_WORK_ITEM_SIZE < Error

      # Initilizes code to -55
      def initialize
        super(-55)
      end

      # Returns a string representing the name corresponding to the error classe
      def self.name
        return "INVALID_WORK_ITEM_SIZE"
      end

      # Returns a string representing the name corresponding to the error
      def name
        return "INVALID_WORK_ITEM_SIZE"
      end

      # Returns the code corresponding to this error class
      def self.code
        return -55
      end

    end

    CLASSES[-55] = INVALID_WORK_ITEM_SIZE
    InvalidWorkItemSize = INVALID_WORK_ITEM_SIZE

    # Represents the OpenCL CL_INVALID_WORK_GROUP_SIZE error
    class INVALID_WORK_GROUP_SIZE < Error

      # Initilizes code to -54
      def initialize
        super(-54)
      end

      # Returns a string representing the name corresponding to the error classe
      def self.name
        return "INVALID_WORK_GROUP_SIZE"
      end

      # Returns a string representing the name corresponding to the error
      def name
        return "INVALID_WORK_GROUP_SIZE"
      end

      # Returns the code corresponding to this error class
      def self.code
        return -54
      end

    end

    CLASSES[-54] = INVALID_WORK_GROUP_SIZE
    InvalidWorkGroupSize = INVALID_WORK_GROUP_SIZE

    # Represents the OpenCL CL_INVALID_WORK_DIMENSION error
    class INVALID_WORK_DIMENSION < Error

      # Initilizes code to -53
      def initialize
        super(-53)
      end

      # Returns a string representing the name corresponding to the error classe
      def self.name
        return "INVALID_WORK_DIMENSION"
      end

      # Returns a string representing the name corresponding to the error
      def name
        return "INVALID_WORK_DIMENSION"
      end

      # Returns the code corresponding to this error class
      def self.code
        return -53
      end

    end

    CLASSES[-53] = INVALID_WORK_DIMENSION
    InvalidWorkDimension = INVALID_WORK_DIMENSION

    # Represents the OpenCL CL_INVALID_KERNEL_ARGS error
    class INVALID_KERNEL_ARGS < Error

      # Initilizes code to -52
      def initialize
        super(-52)
      end

      # Returns a string representing the name corresponding to the error classe
      def self.name
        return "INVALID_KERNEL_ARGS"
      end

      # Returns a string representing the name corresponding to the error
      def name
        return "INVALID_KERNEL_ARGS"
      end

      # Returns the code corresponding to this error class
      def self.code
        return -52
      end

    end

    CLASSES[-52] = INVALID_KERNEL_ARGS
    InvalidKernelArgs = INVALID_KERNEL_ARGS

    # Represents the OpenCL CL_INVALID_ARG_SIZE error
    class INVALID_ARG_SIZE < Error

      # Initilizes code to -51
      def initialize
        super(-51)
      end

      # Returns a string representing the name corresponding to the error classe
      def self.name
        return "INVALID_ARG_SIZE"
      end

      # Returns a string representing the name corresponding to the error
      def name
        return "INVALID_ARG_SIZE"
      end

      # Returns the code corresponding to this error class
      def self.code
        return -51
      end

    end

    CLASSES[-51] = INVALID_ARG_SIZE
    InvalidArgSize = INVALID_ARG_SIZE

    # Represents the OpenCL CL_INVALID_ARG_VALUE error
    class INVALID_ARG_VALUE < Error

      # Initilizes code to -50
      def initialize
        super(-50)
      end

      # Returns a string representing the name corresponding to the error classe
      def self.name
        return "INVALID_ARG_VALUE"
      end

      # Returns a string representing the name corresponding to the error
      def name
        return "INVALID_ARG_VALUE"
      end

      # Returns the code corresponding to this error class
      def self.code
        return -50
      end

    end

    CLASSES[-50] = INVALID_ARG_VALUE
    InvalidArgValue = INVALID_ARG_VALUE

    # Represents the OpenCL CL_INVALID_ARG_INDEX error
    class INVALID_ARG_INDEX < Error

      # Initilizes code to -49
      def initialize
        super(-49)
      end

      # Returns a string representing the name corresponding to the error classe
      def self.name
        return "INVALID_ARG_INDEX"
      end

      # Returns a string representing the name corresponding to the error
      def name
        return "INVALID_ARG_INDEX"
      end

      # Returns the code corresponding to this error class
      def self.code
        return -49
      end

    end

    CLASSES[-49] = INVALID_ARG_INDEX
    InvalidArgIndex = INVALID_ARG_INDEX

    # Represents the OpenCL CL_INVALID_KERNEL error
    class INVALID_KERNEL < Error

      # Initilizes code to -48
      def initialize
        super(-48)
      end

      # Returns a string representing the name corresponding to the error classe
      def self.name
        return "INVALID_KERNEL"
      end

      # Returns a string representing the name corresponding to the error
      def name
        return "INVALID_KERNEL"
      end

      # Returns the code corresponding to this error class
      def self.code
        return -48
      end

    end

    CLASSES[-48] = INVALID_KERNEL
    InvalidKernel = INVALID_KERNEL

    # Represents the OpenCL CL_INVALID_KERNEL_DEFINITION error
    class INVALID_KERNEL_DEFINITION < Error

      # Initilizes code to -47
      def initialize
        super(-47)
      end

      # Returns a string representing the name corresponding to the error classe
      def self.name
        return "INVALID_KERNEL_DEFINITION"
      end

      # Returns a string representing the name corresponding to the error
      def name
        return "INVALID_KERNEL_DEFINITION"
      end

      # Returns the code corresponding to this error class
      def self.code
        return -47
      end

    end

    CLASSES[-47] = INVALID_KERNEL_DEFINITION
    InvalidKernelDefinition = INVALID_KERNEL_DEFINITION

    # Represents the OpenCL CL_INVALID_KERNEL_NAME error
    class INVALID_KERNEL_NAME < Error

      # Initilizes code to -46
      def initialize
        super(-46)
      end

      # Returns a string representing the name corresponding to the error classe
      def self.name
        return "INVALID_KERNEL_NAME"
      end

      # Returns a string representing the name corresponding to the error
      def name
        return "INVALID_KERNEL_NAME"
      end

      # Returns the code corresponding to this error class
      def self.code
        return -46
      end

    end

    CLASSES[-46] = INVALID_KERNEL_NAME
    InvalidKernelName = INVALID_KERNEL_NAME

    # Represents the OpenCL CL_INVALID_PROGRAM_EXECUTABLE error
    class INVALID_PROGRAM_EXECUTABLE < Error

      # Initilizes code to -45
      def initialize
        super(-45)
      end

      # Returns a string representing the name corresponding to the error classe
      def self.name
        return "INVALID_PROGRAM_EXECUTABLE"
      end

      # Returns a string representing the name corresponding to the error
      def name
        return "INVALID_PROGRAM_EXECUTABLE"
      end

      # Returns the code corresponding to this error class
      def self.code
        return -45
      end

    end

    CLASSES[-45] = INVALID_PROGRAM_EXECUTABLE
    InvalidProgramExecutable = INVALID_PROGRAM_EXECUTABLE

    # Represents the OpenCL CL_INVALID_PROGRAM error
    class INVALID_PROGRAM < Error

      # Initilizes code to -44
      def initialize
        super(-44)
      end

      # Returns a string representing the name corresponding to the error classe
      def self.name
        return "INVALID_PROGRAM"
      end

      # Returns a string representing the name corresponding to the error
      def name
        return "INVALID_PROGRAM"
      end

      # Returns the code corresponding to this error class
      def self.code
        return -44
      end

    end

    CLASSES[-44] = INVALID_PROGRAM
    InvalidProgram = INVALID_PROGRAM

    # Represents the OpenCL CL_INVALID_BUILD_OPTIONS error
    class INVALID_BUILD_OPTIONS < Error

      # Initilizes code to -43
      def initialize
        super(-43)
      end

      # Returns a string representing the name corresponding to the error classe
      def self.name
        return "INVALID_BUILD_OPTIONS"
      end

      # Returns a string representing the name corresponding to the error
      def name
        return "INVALID_BUILD_OPTIONS"
      end

      # Returns the code corresponding to this error class
      def self.code
        return -43
      end

    end

    CLASSES[-43] = INVALID_BUILD_OPTIONS
    InvalidBuildOptions = INVALID_BUILD_OPTIONS

    # Represents the OpenCL CL_INVALID_BINARY error
    class INVALID_BINARY < Error

      # Initilizes code to -42
      def initialize
        super(-42)
      end

      # Returns a string representing the name corresponding to the error classe
      def self.name
        return "INVALID_BINARY"
      end

      # Returns a string representing the name corresponding to the error
      def name
        return "INVALID_BINARY"
      end

      # Returns the code corresponding to this error class
      def self.code
        return -42
      end

    end

    CLASSES[-42] = INVALID_BINARY
    InvalidBinary = INVALID_BINARY

    # Represents the OpenCL CL_INVALID_SAMPLER error
    class INVALID_SAMPLER < Error

      # Initilizes code to -41
      def initialize
        super(-41)
      end

      # Returns a string representing the name corresponding to the error classe
      def self.name
        return "INVALID_SAMPLER"
      end

      # Returns a string representing the name corresponding to the error
      def name
        return "INVALID_SAMPLER"
      end

      # Returns the code corresponding to this error class
      def self.code
        return -41
      end

    end

    CLASSES[-41] = INVALID_SAMPLER
    InvalidSampler = INVALID_SAMPLER

    # Represents the OpenCL CL_INVALID_IMAGE_SIZE error
    class INVALID_IMAGE_SIZE < Error

      # Initilizes code to -40
      def initialize
        super(-40)
      end

      # Returns a string representing the name corresponding to the error classe
      def self.name
        return "INVALID_IMAGE_SIZE"
      end

      # Returns a string representing the name corresponding to the error
      def name
        return "INVALID_IMAGE_SIZE"
      end

      # Returns the code corresponding to this error class
      def self.code
        return -40
      end

    end

    CLASSES[-40] = INVALID_IMAGE_SIZE
    InvalidImageSize = INVALID_IMAGE_SIZE

    # Represents the OpenCL CL_INVALID_IMAGE_FORMAT_DESCRIPTOR error
    class INVALID_IMAGE_FORMAT_DESCRIPTOR < Error

      # Initilizes code to -39
      def initialize
        super(-39)
      end

      # Returns a string representing the name corresponding to the error classe
      def self.name
        return "INVALID_IMAGE_FORMAT_DESCRIPTOR"
      end

      # Returns a string representing the name corresponding to the error
      def name
        return "INVALID_IMAGE_FORMAT_DESCRIPTOR"
      end

      # Returns the code corresponding to this error class
      def self.code
        return -39
      end

    end

    CLASSES[-39] = INVALID_IMAGE_FORMAT_DESCRIPTOR
    InvalidImageFormatDescriptor = INVALID_IMAGE_FORMAT_DESCRIPTOR

    # Represents the OpenCL CL_INVALID_MEM_OBJECT error
    class INVALID_MEM_OBJECT < Error

      # Initilizes code to -38
      def initialize
        super(-38)
      end

      # Returns a string representing the name corresponding to the error classe
      def self.name
        return "INVALID_MEM_OBJECT"
      end

      # Returns a string representing the name corresponding to the error
      def name
        return "INVALID_MEM_OBJECT"
      end

      # Returns the code corresponding to this error class
      def self.code
        return -38
      end

    end

    CLASSES[-38] = INVALID_MEM_OBJECT
    InvalidMemObject = INVALID_MEM_OBJECT

    # Represents the OpenCL CL_INVALID_HOST_PTR error
    class INVALID_HOST_PTR < Error

      # Initilizes code to -37
      def initialize
        super(-37)
      end

      # Returns a string representing the name corresponding to the error classe
      def self.name
        return "INVALID_HOST_PTR"
      end

      # Returns a string representing the name corresponding to the error
      def name
        return "INVALID_HOST_PTR"
      end

      # Returns the code corresponding to this error class
      def self.code
        return -37
      end

    end

    CLASSES[-37] = INVALID_HOST_PTR
    InvalidHostPtr = INVALID_HOST_PTR

    # Represents the OpenCL CL_INVALID_COMMAND_QUEUE error
    class INVALID_COMMAND_QUEUE < Error

      # Initilizes code to -36
      def initialize
        super(-36)
      end

      # Returns a string representing the name corresponding to the error classe
      def self.name
        return "INVALID_COMMAND_QUEUE"
      end

      # Returns a string representing the name corresponding to the error
      def name
        return "INVALID_COMMAND_QUEUE"
      end

      # Returns the code corresponding to this error class
      def self.code
        return -36
      end

    end

    CLASSES[-36] = INVALID_COMMAND_QUEUE
    InvalidCommandQueue = INVALID_COMMAND_QUEUE

    # Represents the OpenCL CL_INVALID_QUEUE_PROPERTIES error
    class INVALID_QUEUE_PROPERTIES < Error

      # Initilizes code to -35
      def initialize
        super(-35)
      end

      # Returns a string representing the name corresponding to the error classe
      def self.name
        return "INVALID_QUEUE_PROPERTIES"
      end

      # Returns a string representing the name corresponding to the error
      def name
        return "INVALID_QUEUE_PROPERTIES"
      end

      # Returns the code corresponding to this error class
      def self.code
        return -35
      end

    end

    CLASSES[-35] = INVALID_QUEUE_PROPERTIES
    InvalidQueueProperties = INVALID_QUEUE_PROPERTIES

    # Represents the OpenCL CL_INVALID_CONTEXT error
    class INVALID_CONTEXT < Error

      # Initilizes code to -34
      def initialize
        super(-34)
      end

      # Returns a string representing the name corresponding to the error classe
      def self.name
        return "INVALID_CONTEXT"
      end

      # Returns a string representing the name corresponding to the error
      def name
        return "INVALID_CONTEXT"
      end

      # Returns the code corresponding to this error class
      def self.code
        return -34
      end

    end

    CLASSES[-34] = INVALID_CONTEXT
    InvalidContext = INVALID_CONTEXT

    # Represents the OpenCL CL_INVALID_DEVICE error
    class INVALID_DEVICE < Error

      # Initilizes code to -33
      def initialize
        super(-33)
      end

      # Returns a string representing the name corresponding to the error classe
      def self.name
        return "INVALID_DEVICE"
      end

      # Returns a string representing the name corresponding to the error
      def name
        return "INVALID_DEVICE"
      end

      # Returns the code corresponding to this error class
      def self.code
        return -33
      end

    end

    CLASSES[-33] = INVALID_DEVICE
    InvalidDevice = INVALID_DEVICE

    # Represents the OpenCL CL_INVALID_PLATFORM error
    class INVALID_PLATFORM < Error

      # Initilizes code to -32
      def initialize
        super(-32)
      end

      # Returns a string representing the name corresponding to the error classe
      def self.name
        return "INVALID_PLATFORM"
      end

      # Returns a string representing the name corresponding to the error
      def name
        return "INVALID_PLATFORM"
      end

      # Returns the code corresponding to this error class
      def self.code
        return -32
      end

    end

    CLASSES[-32] = INVALID_PLATFORM
    InvalidPlatform = INVALID_PLATFORM

    # Represents the OpenCL CL_INVALID_DEVICE_TYPE error
    class INVALID_DEVICE_TYPE < Error

      # Initilizes code to -31
      def initialize
        super(-31)
      end

      # Returns a string representing the name corresponding to the error classe
      def self.name
        return "INVALID_DEVICE_TYPE"
      end

      # Returns a string representing the name corresponding to the error
      def name
        return "INVALID_DEVICE_TYPE"
      end

      # Returns the code corresponding to this error class
      def self.code
        return -31
      end

    end

    CLASSES[-31] = INVALID_DEVICE_TYPE
    InvalidDeviceType = INVALID_DEVICE_TYPE

    # Represents the OpenCL CL_INVALID_VALUE error
    class INVALID_VALUE < Error

      # Initilizes code to -30
      def initialize
        super(-30)
      end

      # Returns a string representing the name corresponding to the error classe
      def self.name
        return "INVALID_VALUE"
      end

      # Returns a string representing the name corresponding to the error
      def name
        return "INVALID_VALUE"
      end

      # Returns the code corresponding to this error class
      def self.code
        return -30
      end

    end

    CLASSES[-30] = INVALID_VALUE
    InvalidValue = INVALID_VALUE

    # Represents the OpenCL CL_KERNEL_ARG_INFO_NOT_AVAILABLE error
    class KERNEL_ARG_INFO_NOT_AVAILABLE < Error

      # Initilizes code to -19
      def initialize
        super(-19)
      end

      # Returns a string representing the name corresponding to the error classe
      def self.name
        return "KERNEL_ARG_INFO_NOT_AVAILABLE"
      end

      # Returns a string representing the name corresponding to the error
      def name
        return "KERNEL_ARG_INFO_NOT_AVAILABLE"
      end

      # Returns the code corresponding to this error class
      def self.code
        return -19
      end

    end

    CLASSES[-19] = KERNEL_ARG_INFO_NOT_AVAILABLE
    KernelArgInfoNotAvailable = KERNEL_ARG_INFO_NOT_AVAILABLE

    # Represents the OpenCL CL_DEVICE_PARTITION_FAILED error
    class DEVICE_PARTITION_FAILED < Error

      # Initilizes code to -18
      def initialize
        super(-18)
      end

      # Returns a string representing the name corresponding to the error classe
      def self.name
        return "DEVICE_PARTITION_FAILED"
      end

      # Returns a string representing the name corresponding to the error
      def name
        return "DEVICE_PARTITION_FAILED"
      end

      # Returns the code corresponding to this error class
      def self.code
        return -18
      end

    end

    CLASSES[-18] = DEVICE_PARTITION_FAILED
    DevicePartitionFailed = DEVICE_PARTITION_FAILED

    # Represents the OpenCL CL_LINK_PROGRAM_FAILURE error
    class LINK_PROGRAM_FAILURE < Error

      # Initilizes code to -17
      def initialize
        super(-17)
      end

      # Returns a string representing the name corresponding to the error classe
      def self.name
        return "LINK_PROGRAM_FAILURE"
      end

      # Returns a string representing the name corresponding to the error
      def name
        return "LINK_PROGRAM_FAILURE"
      end

      # Returns the code corresponding to this error class
      def self.code
        return -17
      end

    end

    CLASSES[-17] = LINK_PROGRAM_FAILURE
    LinkProgramFailure = LINK_PROGRAM_FAILURE

    # Represents the OpenCL CL_LINKER_NOT_AVAILABLE error
    class LINKER_NOT_AVAILABLE < Error

      # Initilizes code to -16
      def initialize
        super(-16)
      end

      # Returns a string representing the name corresponding to the error classe
      def self.name
        return "LINKER_NOT_AVAILABLE"
      end

      # Returns a string representing the name corresponding to the error
      def name
        return "LINKER_NOT_AVAILABLE"
      end

      # Returns the code corresponding to this error class
      def self.code
        return -16
      end

    end

    CLASSES[-16] = LINKER_NOT_AVAILABLE
    LinkerNotAvailable = LINKER_NOT_AVAILABLE

    # Represents the OpenCL CL_COMPILE_PROGRAM_FAILURE error
    class COMPILE_PROGRAM_FAILURE < Error

      # Initilizes code to -15
      def initialize
        super(-15)
      end

      # Returns a string representing the name corresponding to the error classe
      def self.name
        return "COMPILE_PROGRAM_FAILURE"
      end

      # Returns a string representing the name corresponding to the error
      def name
        return "COMPILE_PROGRAM_FAILURE"
      end

      # Returns the code corresponding to this error class
      def self.code
        return -15
      end

    end

    CLASSES[-15] = COMPILE_PROGRAM_FAILURE
    CompileProgramFailure = COMPILE_PROGRAM_FAILURE

    # Represents the OpenCL CL_EXEC_STATUS_ERROR_FOR_EVENTS_IN_WAIT_LIST error
    class EXEC_STATUS_ERROR_FOR_EVENTS_IN_WAIT_LIST < Error

      # Initilizes code to -14
      def initialize
        super(-14)
      end

      # Returns a string representing the name corresponding to the error classe
      def self.name
        return "EXEC_STATUS_ERROR_FOR_EVENTS_IN_WAIT_LIST"
      end

      # Returns a string representing the name corresponding to the error
      def name
        return "EXEC_STATUS_ERROR_FOR_EVENTS_IN_WAIT_LIST"
      end

      # Returns the code corresponding to this error class
      def self.code
        return -14
      end

    end

    CLASSES[-14] = EXEC_STATUS_ERROR_FOR_EVENTS_IN_WAIT_LIST
    ExecStatusErrorForEventsInWaitList = EXEC_STATUS_ERROR_FOR_EVENTS_IN_WAIT_LIST

    # Represents the OpenCL CL_MISALIGNED_SUB_BUFFER_OFFSET error
    class MISALIGNED_SUB_BUFFER_OFFSET < Error

      # Initilizes code to -13
      def initialize
        super(-13)
      end

      # Returns a string representing the name corresponding to the error classe
      def self.name
        return "MISALIGNED_SUB_BUFFER_OFFSET"
      end

      # Returns a string representing the name corresponding to the error
      def name
        return "MISALIGNED_SUB_BUFFER_OFFSET"
      end

      # Returns the code corresponding to this error class
      def self.code
        return -13
      end

    end

    CLASSES[-13] = MISALIGNED_SUB_BUFFER_OFFSET
    MisalignedSubBufferOffset = MISALIGNED_SUB_BUFFER_OFFSET

    # Represents the OpenCL CL_MAP_FAILURE error
    class MAP_FAILURE < Error

      # Initilizes code to -12
      def initialize
        super(-12)
      end

      # Returns a string representing the name corresponding to the error classe
      def self.name
        return "MAP_FAILURE"
      end

      # Returns a string representing the name corresponding to the error
      def name
        return "MAP_FAILURE"
      end

      # Returns the code corresponding to this error class
      def self.code
        return -12
      end

    end

    CLASSES[-12] = MAP_FAILURE
    MapFailure = MAP_FAILURE

    # Represents the OpenCL CL_BUILD_PROGRAM_FAILURE error
    class BUILD_PROGRAM_FAILURE < Error

      # Initilizes code to -11
      def initialize
        super(-11)
      end

      # Returns a string representing the name corresponding to the error classe
      def self.name
        return "BUILD_PROGRAM_FAILURE"
      end

      # Returns a string representing the name corresponding to the error
      def name
        return "BUILD_PROGRAM_FAILURE"
      end

      # Returns the code corresponding to this error class
      def self.code
        return -11
      end

    end

    CLASSES[-11] = BUILD_PROGRAM_FAILURE
    BuildProgramFailure = BUILD_PROGRAM_FAILURE

    # Represents the OpenCL CL_IMAGE_FORMAT_NOT_SUPPORTED error
    class IMAGE_FORMAT_NOT_SUPPORTED < Error

      # Initilizes code to -10
      def initialize
        super(-10)
      end

      # Returns a string representing the name corresponding to the error classe
      def self.name
        return "IMAGE_FORMAT_NOT_SUPPORTED"
      end

      # Returns a string representing the name corresponding to the error
      def name
        return "IMAGE_FORMAT_NOT_SUPPORTED"
      end

      # Returns the code corresponding to this error class
      def self.code
        return -10
      end

    end

    CLASSES[-10] = IMAGE_FORMAT_NOT_SUPPORTED
    ImageFormatNotSupported = IMAGE_FORMAT_NOT_SUPPORTED

    # Represents the OpenCL CL_IMAGE_FORMAT_MISMATCH error
    class IMAGE_FORMAT_MISMATCH < Error

      # Initilizes code to -9
      def initialize
        super(-9)
      end

      # Returns a string representing the name corresponding to the error classe
      def self.name
        return "IMAGE_FORMAT_MISMATCH"
      end

      # Returns a string representing the name corresponding to the error
      def name
        return "IMAGE_FORMAT_MISMATCH"
      end

      # Returns the code corresponding to this error class
      def self.code
        return -9
      end

    end

    CLASSES[-9] = IMAGE_FORMAT_MISMATCH
    ImageFormatMismatch = IMAGE_FORMAT_MISMATCH

    # Represents the OpenCL CL_MEM_COPY_OVERLAP error
    class MEM_COPY_OVERLAP < Error

      # Initilizes code to -8
      def initialize
        super(-8)
      end

      # Returns a string representing the name corresponding to the error classe
      def self.name
        return "MEM_COPY_OVERLAP"
      end

      # Returns a string representing the name corresponding to the error
      def name
        return "MEM_COPY_OVERLAP"
      end

      # Returns the code corresponding to this error class
      def self.code
        return -8
      end

    end

    CLASSES[-8] = MEM_COPY_OVERLAP
    MemCopyOverlap = MEM_COPY_OVERLAP

    # Represents the OpenCL CL_PROFILING_INFO_NOT_AVAILABLE error
    class PROFILING_INFO_NOT_AVAILABLE < Error

      # Initilizes code to -7
      def initialize
        super(-7)
      end

      # Returns a string representing the name corresponding to the error classe
      def self.name
        return "PROFILING_INFO_NOT_AVAILABLE"
      end

      # Returns a string representing the name corresponding to the error
      def name
        return "PROFILING_INFO_NOT_AVAILABLE"
      end

      # Returns the code corresponding to this error class
      def self.code
        return -7
      end

    end

    CLASSES[-7] = PROFILING_INFO_NOT_AVAILABLE
    ProfilingInfoNotAvailable = PROFILING_INFO_NOT_AVAILABLE

    # Represents the OpenCL CL_OUT_OF_HOST_MEMORY error
    class OUT_OF_HOST_MEMORY < Error

      # Initilizes code to -6
      def initialize
        super(-6)
      end

      # Returns a string representing the name corresponding to the error classe
      def self.name
        return "OUT_OF_HOST_MEMORY"
      end

      # Returns a string representing the name corresponding to the error
      def name
        return "OUT_OF_HOST_MEMORY"
      end

      # Returns the code corresponding to this error class
      def self.code
        return -6
      end

    end

    CLASSES[-6] = OUT_OF_HOST_MEMORY
    OutOfHostMemory = OUT_OF_HOST_MEMORY

    # Represents the OpenCL CL_OUT_OF_RESOURCES error
    class OUT_OF_RESOURCES < Error

      # Initilizes code to -5
      def initialize
        super(-5)
      end

      # Returns a string representing the name corresponding to the error classe
      def self.name
        return "OUT_OF_RESOURCES"
      end

      # Returns a string representing the name corresponding to the error
      def name
        return "OUT_OF_RESOURCES"
      end

      # Returns the code corresponding to this error class
      def self.code
        return -5
      end

    end

    CLASSES[-5] = OUT_OF_RESOURCES
    OutOfResources = OUT_OF_RESOURCES

    # Represents the OpenCL CL_MEM_OBJECT_ALLOCATION_FAILURE error
    class MEM_OBJECT_ALLOCATION_FAILURE < Error

      # Initilizes code to -4
      def initialize
        super(-4)
      end

      # Returns a string representing the name corresponding to the error classe
      def self.name
        return "MEM_OBJECT_ALLOCATION_FAILURE"
      end

      # Returns a string representing the name corresponding to the error
      def name
        return "MEM_OBJECT_ALLOCATION_FAILURE"
      end

      # Returns the code corresponding to this error class
      def self.code
        return -4
      end

    end

    CLASSES[-4] = MEM_OBJECT_ALLOCATION_FAILURE
    MemObjectAllocationFailure = MEM_OBJECT_ALLOCATION_FAILURE
  end
  FFI.typedef :int8, :cl_char
  FFI.typedef :uint8, :cl_uchar
  FFI.typedef :int16, :cl_short
  FFI.typedef :uint16, :cl_ushort
  FFI.typedef :int32, :cl_int
  FFI.typedef :uint32, :cl_uint
  FFI.typedef :int64, :cl_long
  FFI.typedef :uint64, :cl_ulong
  FFI.typedef :uint16, :cl_half
  FFI.typedef :float, :cl_float
  FFI.typedef :double, :cl_double
  FFI.typedef :uint32, :cl_GLuint
  FFI.typedef :int32, :cl_GLint
  FFI.typedef :uint32, :cl_GLenum
  FFI.typedef :cl_uint, :cl_bool
  FFI.typedef :cl_ulong, :cl_bitfield
  FFI.typedef :cl_bitfield, :cl_device_type
  FFI.typedef :cl_uint, :cl_platform_info
  FFI.typedef :cl_uint, :cl_device_info
  FFI.typedef :cl_bitfield, :cl_device_fp_config
  FFI.typedef :cl_uint, :cl_device_mem_cache_type
  FFI.typedef :cl_uint, :cl_device_local_mem_type
  FFI.typedef :cl_bitfield, :cl_device_exec_capabilities
  FFI.typedef :cl_bitfield, :cl_device_svm_capabilities
  FFI.typedef :cl_bitfield, :cl_command_queue_properties
  FFI.typedef :pointer, :cl_device_partition_property
  FFI.typedef :cl_bitfield, :cl_device_affinity_domain
  FFI.typedef :pointer, :cl_context_properties
  FFI.typedef :cl_uint, :cl_context_info
  FFI.typedef :cl_bitfield, :cl_queue_properties
  FFI.typedef :cl_uint, :cl_command_queue_info
  FFI.typedef :cl_uint, :cl_channel_order
  FFI.typedef :cl_uint, :cl_channel_type
  FFI.typedef :cl_bitfield, :cl_mem_flags
  FFI.typedef :cl_bitfield, :cl_svm_mem_flags
  FFI.typedef :cl_uint, :cl_mem_object_type
  FFI.typedef :cl_uint, :cl_mem_info
  FFI.typedef :cl_bitfield, :cl_mem_migration_flags
  FFI.typedef :cl_uint, :cl_image_info
  FFI.typedef :cl_uint, :cl_buffer_create_type
  FFI.typedef :cl_uint, :cl_addressing_mode
  FFI.typedef :cl_uint, :cl_filter_mode
  FFI.typedef :cl_uint, :cl_sampler_info
  FFI.typedef :cl_bitfield, :cl_map_flags
  FFI.typedef :pointer, :cl_pipe_properties
  FFI.typedef :cl_uint, :cl_pipe_info
  FFI.typedef :cl_uint, :cl_program_info
  FFI.typedef :cl_uint, :cl_program_build_info
  FFI.typedef :cl_uint, :cl_program_binary_type
  FFI.typedef :cl_int, :cl_build_status
  FFI.typedef :cl_uint, :cl_kernel_info
  FFI.typedef :cl_uint, :cl_kernel_arg_info
  FFI.typedef :cl_uint, :cl_kernel_arg_address_qualifier
  FFI.typedef :cl_uint, :cl_kernel_arg_access_qualifier
  FFI.typedef :cl_bitfield, :cl_kernel_arg_type_qualifier
  FFI.typedef :cl_uint, :cl_kernel_work_group_info
  FFI.typedef :cl_uint, :cl_event_info
  FFI.typedef :cl_uint, :cl_command_type
  FFI.typedef :cl_uint, :cl_profiling_info
  FFI.typedef :cl_bitfield, :cl_sampler_properties
  FFI.typedef :cl_uint, :cl_kernel_exec_info
  FFI.typedef :cl_uint, :cl_gl_object_type
  FFI.typedef :cl_uint, :cl_gl_texture_info
  FFI.typedef :cl_uint, :cl_gl_platform_info
  FFI.typedef :cl_uint, :cl_gl_context_info
  # A parent class to represent OpenCL enums that use :cl_uint
  class Enum
#    extend FFI::DataConverter
#    native_type :cl_uint
    @@codes = {}

    # Initializes an enum with the given val
    def initialize( val )
      OpenCL::check_error( OpenCL::INVALID_VALUE ) if not @@codes[val]
      super()
      @val = val
    end

    # Sets the internal value of the enum
    def val=(v)
      OpenCL::check_error( OpenCL::INVALID_VALUE ) if not @@codes[val]
      @val = v
    end

    # Returns true if val corresponds to the enum value
    def is?(val)
      return true if @val == val
    end

    # Return true if val corresponds to the enum value
    def ==(val)
      return true if @val == val
    end

    # Returns a String corresponfing to the Enum value
    def to_s
      return "#{self.name}"
    end

    # Returns the integer representing the Enum value
    def to_i
      return @val
    end

    # Returns the integer representing the Enum value
    def to_int
      return @val
    end

#    #:stopdoc:
#    def self.to_native(value, context)
#      if value then
#        return value.flags
#      else
#        return 0
#      end
#    end
#
#    def self.from_native(value, context)
#      new(value)
#    end
#
#    def self.size
#      FFI::find_type(:cl_uint).size
#    end
#
#    def self.reference_required?
#      return false
#    end
#    #:startdoc:

  end

  # A parent class to represent enums that use cl_int
  class EnumInt < Enum
#    extend FFI::DataConverter
#    native_type :cl_int
  end

  # A parent class to represent OpenCL bitfields that use :cl_bitfield
  class Bitfield
#    extend FFI::DataConverter
#    native_type :cl_bitfield

    # Initializes a new Bitfield to val
    def initialize( val = 0 )
      super()
      @val = val
    end

    # Returns true if flag is bitwise included in the Bitfield
    def include?(flag)
      return true if ( @val & flag ) == flag
      return false
    end

    # Returns a String corresponfing to the Bitfield value
    def to_s
      return "#{self.names}"
    end

    # Returns the integer representing the Bitfield value
    def to_i
      return @val
    end

    # Returns the integer representing the Bitfield value
    def to_int
      return @val
    end

    # Returns the bitwise & operation between f and the internal Bitfield representation
    def &(f)
      return self.class::new( @val & f )
    end

    # Returns the bitwise ^ operation between f and the internal Bitfield representation
    def ^(f)
      return self.class::new( @val ^ f )
    end

    # Returns the bitwise | operation between f and the internal Bitfield representation
    def |(f)
      return self.class::new( @val | f )
    end

    # Returns the internal representation of the Bitfield
    def flags
      return @val
    end

    # Setss the internal representation of the Bitfield to val
    def flags=(val)
      @val = val
    end

#    #:stopdoc:
#    def self.to_native(value, context)
#      if value then
#        return value.flags
#      else
#        return 0
#      end
#    end
#
#    def self.from_native(value, context)
#      new(value)
#    end
#
#    def self.size
#      FFI::find_type(:cl_bitfield).size
#    end
#
#    def self.reference_required?
#      return false
#    end
#    #:startdoc:

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
  
    # Creates a new Platform and retains it if specified and aplicable
    def initialize(ptr, retain = true)
      super(ptr)
      #STDERR.puts "Allocating Platform: #{ptr}"
    end
  
    # method called at Platform deletion, releases the object if aplicable
    def self.release(ptr)
    end
    #:startdoc:
  
    def to_s
      if self.respond_to?(:name) then
        return self.name
      else
        return super
      end
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
    QUEUE_ON_HOST_PROPERTIES = 0x102A
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
    MAX_READ_WRITE_IMAGE_ARGS = 0x104C
    MAX_GLOBAL_VARIABLE_SIZE = 0x104D
    QUEUE_ON_DEVICE_PROPERTIES = 0x104E
    QUEUE_ON_DEVICE_PREFERRED_SIZE = 0x104F
    QUEUE_ON_DEVICE_MAX_SIZE = 0x1050
    MAX_ON_DEVICE_QUEUES = 0x1051
    MAX_ON_DEVICE_EVENTS = 0x1052
    SVM_CAPABILITIES = 0x1053
    GLOBAL_VARIABLE_PREFERRED_TOTAL_SIZE = 0x1054
    MAX_PIPE_ARGS = 0x1055
    PIPE_MAX_ACTIVE_RESERVATIONS = 0x1056
    PIPE_MAX_PACKET_SIZE = 0x1057
    PREFERRED_PLATFORM_ATOMIC_ALIGNMENT = 0x1058
    PREFERRED_GLOBAL_ATOMIC_ALIGNMENT = 0x1059
    PREFERRED_LOCAL_ATOMIC_ALIGNMENT = 0x105A
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
    SVM_COARSE_GRAIN_BUFFER = (1 << 0)
    SVM_FINE_GRAIN_BUFFER = (1 << 1)
    SVM_FINE_GRAIN_SYSTEM = (1 << 2)
    SVM_ATOMICS = (1 << 3)
    HALF_FP_CONFIG = 0x1033
    TERMINATE_CAPABILITY_KHR = 0x200F
    SPIR_VERSIONS = 0x40E0
    COMPUTE_CAPABILITY_MAJOR_NV = 0x4000
    COMPUTE_CAPABILITY_MINOR_NV = 0x4001
    REGISTERS_PER_BLOCK_NV = 0x4002
    WARP_SIZE_NV = 0x4003
    GPU_OVERLAP_NV = 0x4004
    KERNEL_EXEC_TIMEOUT_NV = 0x4005
    INTEGRATED_MEMORY_NV = 0x4006
    PROFILING_TIMER_OFFSET_AMD = 0x4036
    PAGE_SIZE_QCOM = 0x40A1
  
    # Creates a new Device and retains it if specified and aplicable
    def initialize(ptr, retain = true)
      super(ptr)
      platform = FFI::MemoryPointer::new( Platform )
      OpenCL.clGetDeviceInfo( ptr, OpenCL::Device::PLATFORM, platform.size, platform, nil)
      p = OpenCL::Platform::new(platform.read_pointer)
      if p.version_number >= 1.2 and retain then
        error = OpenCL.clRetainDevice(ptr)
        error_check( error )
      end
      #STDERR.puts "Allocating Device: #{ptr}"
    end
  
    # method called at Device deletion, releases the object if aplicable
    def self.release(ptr)
      platform = FFI::MemoryPointer::new( Platform )
      OpenCL.clGetDeviceInfo( ptr, OpenCL::Device::PLATFORM, platform.size, platform, nil)
      p = OpenCL::Platform::new(platform.read_pointer)
      if p.version_number >= 1.2 then
        error = OpenCL.clReleaseDevice(ptr)
        error_check( error )
      end
    end
    #:startdoc:
  
    def to_s
      if self.respond_to?(:name) then
        return self.name
      else
        return super
      end
    end
  
  end

  class Device
    # Bitfield that maps the :cl_device_type type
    class Type < Bitfield
      DEFAULT = (1 << 0)
      CPU = (1 << 1)
      GPU = (1 << 2)
      ACCELERATOR = (1 << 3)
      CUSTOM = (1 << 4)
      ALL = 0xFFFFFFFF
      # Returns an Array of String representing the different flags set
      def names
        fs = []
        %w( DEFAULT CPU GPU ACCELERATOR CUSTOM ALL ).each { |f|
          fs.push(f) if self.include?( self.class.const_get(f) )
        }
        return fs
      end
    end

    # Bitfield that maps the :cl_device_fp_config type
    class FPConfig < Bitfield
      DENORM = (1 << 0)
      INF_NAN = (1 << 1)
      ROUND_TO_NEAREST = (1 << 2)
      ROUND_TO_ZERO = (1 << 3)
      ROUND_TO_INF = (1 << 4)
      FMA = (1 << 5)
      SOFT_FLOAT = (1 << 6)
      CORRECTLY_ROUNDED_DIVIDE_SQRT = (1 << 7)
      # Returns an Array of String representing the different flags set
      def names
        fs = []
        %w( DENORM INF_NAN ROUND_TO_NEAREST ROUND_TO_ZERO ROUND_TO_INF FMA SOFT_FLOAT CORRECTLY_ROUNDED_DIVIDE_SQRT ).each { |f|
          fs.push(f) if self.include?( self.class.const_get(f) )
        }
        return fs
      end
    end

    # Bitfield that maps the :cl_device_exec_capabilities type
    class ExecCapabilities < Bitfield
      KERNEL = (1 << 0)
      NATIVE_KERNEL = (1 << 1)
      # Returns an Array of String representing the different flags set
      def names
        fs = []
        %w( KERNEL NATIVE_KERNEL ).each { |f|
          fs.push(f) if self.include?( self.class.const_get(f) )
        }
        return fs
      end
    end

    # Enum that maps the :cl_device_mem_cache_type type
    class MemCacheType < Enum
      NONE = 0x0
      READ_ONLY_CACHE = 0x1
      READ_WRITE_CACHE = 0x2
      @@codes[0x0] = 'NONE'
      @@codes[0x1] = 'READ_ONLY_CACHE'
      @@codes[0x2] = 'READ_WRITE_CACHE'
      # Returns a String representing the Enum value name
      def name
        return @@codes[@val]
      end
    end

    # Enum that maps the :cl_device_local_mem_type type
    class LocalMemType < Enum
      LOCAL = 0x1
      GLOBAL = 0x2
      @@codes[0x1] = 'LOCAL'
      @@codes[0x2] = 'GLOBAL'
      # Returns a String representing the Enum value name
      def name
        return @@codes[@val]
      end
    end

    # Bitfield that maps the :cl_device_affinity_domain type
    class AffinityDomain < Bitfield
      NUMA = (1 << 0)
      L4_CACHE = (1 << 1)
      L3_CACHE = (1 << 2)
      L2_CACHE = (1 << 3)
      L1_CACHE = (1 << 4)
      NEXT_PARTITIONABLE = (1 << 5)
      # Returns an Array of String representing the different flags set
      def names
        fs = []
        %w( NUMA L4_CACHE L3_CACHE L2_CACHE L1_CACHE NEXT_PARTITIONABLE ).each { |f|
          fs.push(f) if self.include?( self.class.const_get(f) )
        }
        return fs
      end
    end

    # Bitfield that maps the :cl_device_svm_capabilities
    class SVMCapabilities < Bitfield
      COARSE_GRAIN_BUFFER = (1 << 0)
      FINE_GRAIN_BUFFER = (1 << 1)
      FINE_GRAIN_SYSTEM = (1 << 2)
      ATOMICS = (1 << 3)
      # Returns an Array of String representing the different flags set
      def names
        fs = []
        %w( COARSE_GRAIN_BUFFER FINE_GRAIN_BUFFER FINE_GRAIN_SYSTEM ATOMICS ).each { |f|
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
  
    # Creates a new Context and retains it if specified and aplicable
    def initialize(ptr, retain = true)
      super(ptr)
      OpenCL.clRetainContext(ptr) if retain
      #STDERR.puts "Allocating Context: #{ptr}"
    end
  
    # method called at Context deletion, releases the object if aplicable
    def self.release(ptr)
      #STDERR.puts "Releasing Context: #{ptr}"
      #ref_count = FFI::MemoryPointer::new( :cl_uint ) 
      #OpenCL.clGetContextInfo(ptr, OpenCL::Context::REFERENCE_COUNT, ref_count.size, ref_count, nil)
      #STDERR.puts "reference counter: #{ref_count.read_cl_uint}"
      error = OpenCL.clReleaseContext(ptr)
      #STDERR.puts "Object released! #{error}"
      error_check( error )
    end
    #:startdoc:
  
    def to_s
      if self.respond_to?(:name) then
        return self.name
      else
        return super
      end
    end
  
  end

  class CommandQueue < FFI::ManagedStruct
    layout :dummy, :pointer
    #:stopdoc:
    OUT_OF_ORDER_EXEC_MODE_ENABLE = (1 << 0)
    PROFILING_ENABLE = (1 << 1)
    ON_DEVICE = (1 << 2)
    ON_DEVICE_DEFAULT = (1 << 3)
    CONTEXT = 0x1090
    DEVICE = 0x1091
    REFERENCE_COUNT = 0x1092
    PROPERTIES = 0x1093
    SIZE = 0x1094
  
    # Creates a new CommandQueue and retains it if specified and aplicable
    def initialize(ptr, retain = true)
      super(ptr)
      OpenCL.clRetainCommandQueue(ptr) if retain
      #STDERR.puts "Allocating CommandQueue: #{ptr}"
    end
  
    # method called at CommandQueue deletion, releases the object if aplicable
    def self.release(ptr)
      #STDERR.puts "Releasing CommandQueue: #{ptr}"
      #ref_count = FFI::MemoryPointer::new( :cl_uint ) 
      #OpenCL.clGetCommandQueueInfo(ptr, OpenCL::CommandQueue::REFERENCE_COUNT, ref_count.size, ref_count, nil)
      #STDERR.puts "reference counter: #{ref_count.read_cl_uint}"
      error = OpenCL.clReleaseCommandQueue(ptr)
      #STDERR.puts "Object released! #{error}"
      error_check( error )
    end
    #:startdoc:
  
    def to_s
      if self.respond_to?(:name) then
        return self.name
      else
        return super
      end
    end
  
  end

  class CommandQueue
    class Properties < Bitfield
      OUT_OF_ORDER_EXEC_MODE_ENABLE = (1 << 0)
      PROFILING_ENABLE = (1 << 1)
      ON_DEVICE = (1 << 2)
      ON_DEVICE_DEFAULT = (1 << 3)
      # Returns an Array of String representing the different flags set
      def names
        fs = []
        %w( OUT_OF_ORDER_EXEC_MODE_ENABLE PROFILING_ENABLE ON_DEVICE ON_DEVICE_DEFAULT ).each { |f|
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
    SVM_FINE_GRAIN_BUFFER = (1 << 10)
    SVM_ATOMICS = (1 << 11)
    BUFFER = 0x10F0
    IMAGE2D = 0x10F1
    IMAGE3D = 0x10F2
    IMAGE2D_ARRAY = 0x10F3
    IMAGE1D = 0x10F4
    IMAGE1D_ARRAY = 0x10F5
    IMAGE1D_BUFFER = 0x10F6
    PIPE = 0x10F7
    TYPE = 0x1100
    FLAGS = 0x1101
    SIZE = 0x1102
    HOST_PTR = 0x1103
    MAP_COUNT = 0x1104
    REFERENCE_COUNT = 0x1105
    CONTEXT = 0x1106
    ASSOCIATED_MEMOBJECT = 0x1107
    OFFSET = 0x1108
    USES_SVM_POINTER = 0x1109
    HOST_UNCACHED_QCOM = 0x40A4
    HOST_WRITEBACK_QCOM = 0x40A5
    HOST_WRITETHROUGH_QCOM = 0x40A6
    HOST_WRITE_COMBINING_QCOM = 0x40A7
    ION_HOST_PTR_QCOM = 0x40A8
  
    # Creates a new Mem and retains it if specified and aplicable
    def initialize(ptr, retain = true)
      super(ptr)
      OpenCL.clRetainMemObject(ptr) if retain
      #STDERR.puts "Allocating Mem: #{ptr}"
    end
  
    # method called at Mem deletion, releases the object if aplicable
    def self.release(ptr)
      #STDERR.puts "Releasing Mem: #{ptr}"
      #ref_count = FFI::MemoryPointer::new( :cl_uint ) 
      #OpenCL.clGetMemObjectInfo(ptr, OpenCL::Mem::REFERENCE_COUNT, ref_count.size, ref_count, nil)
      #STDERR.puts "reference counter: #{ref_count.read_cl_uint}"
      error = OpenCL.clReleaseMemObject(ptr)
      #STDERR.puts "Object released! #{error}"
      error_check( error )
    end
    #:startdoc:
  
    def to_s
      if self.respond_to?(:name) then
        return self.name
      else
        return super
      end
    end
  
  end

  class Mem
    # Bitfield that maps the :cl_mem_flags type
    class Flags < Bitfield
      READ_WRITE = (1 << 0)
      WRITE_ONLY = (1 << 1)
      READ_ONLY = (1 << 2)
      USE_HOST_PTR = (1 << 3)
      ALLOC_HOST_PTR = (1 << 4)
      COPY_HOST_PTR = (1 << 5)
      HOST_WRITE_ONLY = (1 << 7)
      HOST_READ_ONLY = (1 << 8)
      HOST_NO_ACCESS = (1 << 9)
      # Returns an Array of String representing the different flags set
      def names
        fs = []
        %w( READ_WRITE WRITE_ONLY READ_ONLY USE_HOST_PTR ALLOC_HOST_PTR COPY_HOST_PTR HOST_WRITE_ONLY HOST_READ_ONLY HOST_NO_ACCESS ).each { |f|
          fs.push(f) if self.include?( self.class.const_get(f) )
        }
        return fs
      end
    end

    # Bitfield that maps the :cl_mem_migration_flags type
    class MigrationFlags < Bitfield
      HOST = (1 << 0)
      CONTENT_UNDEFINED = (1 << 1)
      # Returns an Array of String representing the different flags set
      def names
        fs = []
        %w( HOST CONTENT_UNDEFINED ).each { |f|
          fs.push(f) if self.include?( self.class.const_get(f) )
        }
        return fs
      end
    end

    # Enum that maps the :cl_mem_object_type
    class Type < Enum
      BUFFER = 0x10F0
      IMAGE2D = 0x10F1
      IMAGE3D = 0x10F2
      IMAGE2D_ARRAY = 0x10F3
      IMAGE1D = 0x10F4
      IMAGE1D_ARRAY = 0x10F5
      IMAGE1D_BUFFER = 0x10F6
      PIPE = 0x10F7
      @@codes[0x10F0] = 'BUFFER'
      @@codes[0x10F1] = 'IMAGE2D'
      @@codes[0x10F2] = 'IMAGE3D'
      @@codes[0x10F3] = 'IMAGE2D_ARRAY'
      @@codes[0x10F4] = 'IMAGE1D'
      @@codes[0x10F5] = 'IMAGE1D_ARRAY'
      @@codes[0x10F6] = 'IMAGE1D_BUFFER'
      @@codes[0x10F7] = 'PIPE'
      # Returns a String representing the Enum value name
      def name
        return @@codes[@val]
      end
    end

    # Bitfield that maps the :cl_svm_mem_flags type
    class SVMFlags < Bitfield
      READ_WRITE = (1 << 0)
      WRITE_ONLY = (1 << 1)
      READ_ONLY = (1 << 2)
      SVM_FINE_GRAIN_BUFFER = (1 << 10)
      SVM_ATOMICS = (1 << 11)
      # Returns an Array of String representing the different flags set
      def names
        fs = []
        %w( READ_WRITE WRITE_ONLY READ_ONLY SVM_FINE_GRAIN_BUFFER SVM_ATOMICS ).each { |f|
          fs.push(f) if self.include?( self.class.const_get(f) )
        }
        return fs
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
    BUILD_GLOBAL_VARIABLE_TOTAL_SIZE = 0x1185
    BINARY_TYPE_NONE = 0x0
    BINARY_TYPE_COMPILED_OBJECT = 0x1
    BINARY_TYPE_LIBRARY = 0x2
    BINARY_TYPE_EXECUTABLE = 0x4
    BINARY_TYPE_INTERMEDIATE = 0x40E1
  
    # Creates a new Program and retains it if specified and aplicable
    def initialize(ptr, retain = true)
      super(ptr)
      OpenCL.clRetainProgram(ptr) if retain
      #STDERR.puts "Allocating Program: #{ptr}"
    end
  
    # method called at Program deletion, releases the object if aplicable
    def self.release(ptr)
      #STDERR.puts "Releasing Program: #{ptr}"
      #ref_count = FFI::MemoryPointer::new( :cl_uint ) 
      #OpenCL.clGetProgramInfo(ptr, OpenCL::Program::REFERENCE_COUNT, ref_count.size, ref_count, nil)
      #STDERR.puts "reference counter: #{ref_count.read_cl_uint}"
      error = OpenCL.clReleaseProgram(ptr)
      #STDERR.puts "Object released! #{error}"
      error_check( error )
    end
    #:startdoc:
  
    def to_s
      if self.respond_to?(:name) then
        return self.name
      else
        return super
      end
    end
  
  end

  class Program
    # Enum that maps the :cl_program_binary_type type
    class BinaryType < Enum
      NONE = 0x0
      COMPILED_OBJECT = 0x1
      LIBRARY = 0x2
      EXECUTABLE = 0x4
      INTERMEDIATE = 0x40E1
      @@codes[0x0] = 'NONE'
      @@codes[0x1] = 'COMPILED_OBJECT'
      @@codes[0x2] = 'LIBRARY'
      @@codes[0x4] = 'EXECUTABLE'
      @@codes[0x40E1] = 'INTERMEDIATE'
      # Returns a String representing the Enum value name
      def name
        return @@codes[@val]
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
    ARG_TYPE_PIPE = (1 << 3)
    WORK_GROUP_SIZE = 0x11B0
    COMPILE_WORK_GROUP_SIZE = 0x11B1
    LOCAL_MEM_SIZE = 0x11B2
    PREFERRED_WORK_GROUP_SIZE_MULTIPLE = 0x11B3
    PRIVATE_MEM_SIZE = 0x11B4
    GLOBAL_WORK_SIZE = 0x11B5
    EXEC_INFO_SVM_PTRS = 0x11B6
    EXEC_INFO_SVM_FINE_GRAIN_SYSTEM = 0x11B7
  
    # Creates a new Kernel and retains it if specified and aplicable
    def initialize(ptr, retain = true)
      super(ptr)
      OpenCL.clRetainKernel(ptr) if retain
      #STDERR.puts "Allocating Kernel: #{ptr}"
    end
  
    # method called at Kernel deletion, releases the object if aplicable
    def self.release(ptr)
      #STDERR.puts "Releasing Kernel: #{ptr}"
      #ref_count = FFI::MemoryPointer::new( :cl_uint ) 
      #OpenCL.clGetKernelInfo(ptr, OpenCL::Kernel::REFERENCE_COUNT, ref_count.size, ref_count, nil)
      #STDERR.puts "reference counter: #{ref_count.read_cl_uint}"
      error = OpenCL.clReleaseKernel(ptr)
      #STDERR.puts "Object released! #{error}"
      error_check( error )
    end
    #:startdoc:
  
    def to_s
      if self.respond_to?(:name) then
        return self.name
      else
        return super
      end
    end
  
  end

  class Kernel
    # Maps the arg logical OpenCL objects
    class Arg
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
      TYPE_PIPE = (1 << 3)
    end

    class Arg
      # Enum that maps the :cl_kernel_arg_address_qualifier type
      class AddressQualifier < Enum
        GLOBAL = 0x119B
        LOCAL = 0x119C
        CONSTANT = 0x119D
        PRIVATE = 0x119E
        @@codes[0x119B] = 'GLOBAL'
        @@codes[0x119C] = 'LOCAL'
        @@codes[0x119D] = 'CONSTANT'
        @@codes[0x119E] = 'PRIVATE'
        # Returns a String representing the Enum value name
        def name
          return @@codes[@val]
        end
      end

      # Enum that maps the :cl_kernel_arg_access_qualifier type
      class AccessQualifier < Enum
        READ_ONLY = 0x11A0
        WRITE_ONLY = 0x11A1
        READ_WRITE = 0x11A2
        NONE = 0x11A3
        @@codes[0x11A0] = 'READ_ONLY'
        @@codes[0x11A1] = 'WRITE_ONLY'
        @@codes[0x11A2] = 'READ_WRITE'
        @@codes[0x11A3] = 'NONE'
        # Returns a String representing the Enum value name
        def name
          return @@codes[@val]
        end
      end

      # Bitfield that maps the :cl_kernel_arg_type_qualifier type
      class TypeQualifier < Bitfield
        NONE = 0
        CONST = (1 << 0)
        RESTRICT = (1 << 1)
        VOLATILE = (1 << 2)
        PIPE = (1 << 3)
        # Returns an Array of String representing the different flags set
        def names
          fs = []
          %w( NONE CONST RESTRICT VOLATILE PIPE ).each { |f|
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
  
    # Creates a new Event and retains it if specified and aplicable
    def initialize(ptr, retain = true)
      super(ptr)
      OpenCL.clRetainEvent(ptr) if retain
      #STDERR.puts "Allocating Event: #{ptr}"
    end
  
    # method called at Event deletion, releases the object if aplicable
    def self.release(ptr)
      #STDERR.puts "Releasing Event: #{ptr}"
      #ref_count = FFI::MemoryPointer::new( :cl_uint ) 
      #OpenCL.clGetEventInfo(ptr, OpenCL::Event::REFERENCE_COUNT, ref_count.size, ref_count, nil)
      #STDERR.puts "reference counter: #{ref_count.read_cl_uint}"
      error = OpenCL.clReleaseEvent(ptr)
      #STDERR.puts "Object released! #{error}"
      error_check( error )
    end
    #:startdoc:
  
    def to_s
      if self.respond_to?(:name) then
        return self.name
      else
        return super
      end
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
    MIP_FILTER_MODE = 0x1155
    LOD_MIN = 0x1156
    LOD_MAX = 0x1157
  
    # Creates a new Sampler and retains it if specified and aplicable
    def initialize(ptr, retain = true)
      super(ptr)
      OpenCL.clRetainSampler(ptr) if retain
      #STDERR.puts "Allocating Sampler: #{ptr}"
    end
  
    # method called at Sampler deletion, releases the object if aplicable
    def self.release(ptr)
      #STDERR.puts "Releasing Sampler: #{ptr}"
      #ref_count = FFI::MemoryPointer::new( :cl_uint ) 
      #OpenCL.clGetSamplerInfo(ptr, OpenCL::Sampler::REFERENCE_COUNT, ref_count.size, ref_count, nil)
      #STDERR.puts "reference counter: #{ref_count.read_cl_uint}"
      error = OpenCL.clReleaseSampler(ptr)
      #STDERR.puts "Object released! #{error}"
      error_check( error )
    end
    #:startdoc:
  
    def to_s
      if self.respond_to?(:name) then
        return self.name
      else
        return super
      end
    end
  
  end

  class Sampler
    # Enum that maps the :cl_sampler_properties
    class Type < Enum
      NORMALIZED_COORDS = 0x1152
      ADDRESSING_MODE = 0x1153
      FILTER_MODE = 0x1154
      MIP_FILTER_MODE = 0x1155
      LOD_MIN = 0x1156
      LOD_MAX = 0x1157
      @@codes[0x1152] = 'NORMALIZED_COORDS'
      @@codes[0x1153] = 'ADDRESSING_MODE'
      @@codes[0x1154] = 'FILTER_MODE'
      @@codes[0x1155] = 'MIP_FILTER_MODE'
      @@codes[0x1156] = 'LOD_MIN'
      @@codes[0x1157] = 'LOD_MAX'
      # Returns a String representing the Enum value name
      def name
        return @@codes[@val]
      end
    end

  end
  class GLsync < FFI::ManagedStruct
    layout :dummy, :pointer
    #:stopdoc:
    
  
    # Creates a new GLsync and retains it if specified and aplicable
    def initialize(ptr, retain = true)
      super(ptr)
      #STDERR.puts "Allocating GLsync: #{ptr}"
    end
  
    # method called at GLsync deletion, releases the object if aplicable
    def self.release(ptr)
    end
    #:startdoc:
  
    def to_s
      if self.respond_to?(:name) then
        return self.name
      else
        return super
      end
    end
  
  end

  # Enum that maps the :cl_channel_order type
  class ChannelOrder < Enum
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
    sRGB = 0x10BF
    sRGBx = 0x10C0
    sRGBA = 0x10C1
    sBGRA = 0x10C2
    ABGR = 0x10C3
    @@codes[0x10B0] = 'R'
    @@codes[0x10B1] = 'A'
    @@codes[0x10B2] = 'RG'
    @@codes[0x10B3] = 'RA'
    @@codes[0x10B4] = 'RGB'
    @@codes[0x10B5] = 'RGBA'
    @@codes[0x10B6] = 'BGRA'
    @@codes[0x10B7] = 'ARGB'
    @@codes[0x10B8] = 'INTENSITY'
    @@codes[0x10B9] = 'LUMINANCE'
    @@codes[0x10BA] = 'Rx'
    @@codes[0x10BB] = 'RGx'
    @@codes[0x10BC] = 'RGBx'
    @@codes[0x10BD] = 'DEPTH'
    @@codes[0x10BE] = 'DEPTH_STENCIL'
    @@codes[0x10BF] = 'sRGB'
    @@codes[0x10C0] = 'sRGBx'
    @@codes[0x10C1] = 'sRGBA'
    @@codes[0x10C2] = 'sBGRA'
    @@codes[0x10C3] = 'ABGR'
    # Returns a String representing the Enum value name
    def name
      return @@codes[@val]
    end
  end

  # Enum that maps the :cl_channel_type type
  class ChannelType < Enum
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
    @@codes[0x10D0] = 'SNORM_INT8'
    @@codes[0x10D1] = 'SNORM_INT16'
    @@codes[0x10D2] = 'UNORM_INT8'
    @@codes[0x10D3] = 'UNORM_INT16'
    @@codes[0x10D4] = 'UNORM_SHORT_565'
    @@codes[0x10D5] = 'UNORM_SHORT_555'
    @@codes[0x10D6] = 'UNORM_INT_101010'
    @@codes[0x10D7] = 'SIGNED_INT8'
    @@codes[0x10D8] = 'SIGNED_INT16'
    @@codes[0x10D9] = 'SIGNED_INT32'
    @@codes[0x10DA] = 'UNSIGNED_INT8'
    @@codes[0x10DB] = 'UNSIGNED_INT16'
    @@codes[0x10DC] = 'UNSIGNED_INT32'
    @@codes[0x10DD] = 'HALF_FLOAT'
    @@codes[0x10DE] = 'FLOAT'
    @@codes[0x10DF] = 'UNORM_INT24'
    # Returns a String representing the Enum value name
    def name
      return @@codes[@val]
    end
  end

  # Enum that maps the :cl_addressing_mode type
  class AddressingMode < Enum
    NONE = 0x1130
    CLAMP_TO_EDGE = 0x1131
    CLAMP = 0x1132
    REPEAT = 0x1133
    MIRRORED_REPEAT = 0x1134
    @@codes[0x1130] = 'NONE'
    @@codes[0x1131] = 'CLAMP_TO_EDGE'
    @@codes[0x1132] = 'CLAMP'
    @@codes[0x1133] = 'REPEAT'
    @@codes[0x1134] = 'MIRRORED_REPEAT'
    # Returns a String representing the Enum value name
    def name
      return @@codes[@val]
    end
  end

  # Enum that maps the :cl_filter_mode type
  class FilterMode < Enum
    NEAREST = 0x1140
    LINEAR = 0x1141
    @@codes[0x1140] = 'NEAREST'
    @@codes[0x1141] = 'LINEAR'
    # Returns a String representing the Enum value name
    def name
      return @@codes[@val]
    end
  end

  # Bitfield that maps the :cl_map_flags type
  class MapFlags < Bitfield
    READ = (1 << 0)
    WRITE = (1 << 1)
    WRITE_INVALIDATE_REGION = (1 << 2)
    # Returns an Array of String representing the different flags set
    def names
      fs = []
      %w( READ WRITE WRITE_INVALIDATE_REGION ).each { |f|
        fs.push(f) if self.include?( self.class.const_get(f) )
      }
      return fs
    end
  end

  # Enum that maps the :cl_command_type type
  class CommandType < Enum
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
    SVM_FREE = 0x1209
    SVM_MEMCPY = 0x120A
    SVM_MEMFILL = 0x120B
    SVM_MAP = 0x120C
    SVM_UNMAP = 0x120D
    @@codes[0x11F0] = 'NDRANGE_KERNEL'
    @@codes[0x11F1] = 'TASK'
    @@codes[0x11F2] = 'NATIVE_KERNEL'
    @@codes[0x11F3] = 'READ_BUFFER'
    @@codes[0x11F4] = 'WRITE_BUFFER'
    @@codes[0x11F5] = 'COPY_BUFFER'
    @@codes[0x11F6] = 'READ_IMAGE'
    @@codes[0x11F7] = 'WRITE_IMAGE'
    @@codes[0x11F8] = 'COPY_IMAGE'
    @@codes[0x11F9] = 'COPY_IMAGE_TO_BUFFER'
    @@codes[0x11FA] = 'COPY_BUFFER_TO_IMAGE'
    @@codes[0x11FB] = 'MAP_BUFFER'
    @@codes[0x11FC] = 'MAP_IMAGE'
    @@codes[0x11FD] = 'UNMAP_MEM_OBJECT'
    @@codes[0x11FE] = 'MARKER'
    @@codes[0x11FF] = 'ACQUIRE_GL_OBJECTS'
    @@codes[0x1200] = 'RELEASE_GL_OBJECTS'
    @@codes[0x1201] = 'READ_BUFFER_RECT'
    @@codes[0x1202] = 'WRITE_BUFFER_RECT'
    @@codes[0x1203] = 'COPY_BUFFER_RECT'
    @@codes[0x1204] = 'USER'
    @@codes[0x1205] = 'BARRIER'
    @@codes[0x1206] = 'MIGRATE_MEM_OBJECTS'
    @@codes[0x1207] = 'FILL_BUFFER'
    @@codes[0x1208] = 'FILL_IMAGE'
    @@codes[0x1209] = 'SVM_FREE'
    @@codes[0x120A] = 'SVM_MEMCPY'
    @@codes[0x120B] = 'SVM_MEMFILL'
    @@codes[0x120C] = 'SVM_MAP'
    @@codes[0x120D] = 'SVM_UNMAP'
    # Returns a String representing the Enum value name
    def name
      return @@codes[@val]
    end
  end

  # Enum that maps the :cl_gl_object_type type
  class GLObjectType < Enum
    BUFFER = 0x2000
    TEXTURE2D = 0x2001
    TEXTURE3D = 0x2002
    RENDERBUFFER = 0x2003
    TEXTURE2D_ARRAY = 0x200E
    TEXTURE1D = 0x200F
    TEXTURE1D_ARRAY = 0x2010
    TEXTURE_BUFFER = 0x2011
    @@codes[0x2000] = 'BUFFER'
    @@codes[0x2001] = 'TEXTURE2D'
    @@codes[0x2002] = 'TEXTURE3D'
    @@codes[0x2003] = 'RENDERBUFFER'
    @@codes[0x200E] = 'TEXTURE2D_ARRAY'
    @@codes[0x200F] = 'TEXTURE1D'
    @@codes[0x2010] = 'TEXTURE1D_ARRAY'
    @@codes[0x2011] = 'TEXTURE_BUFFER'
    # Returns a String representing the Enum value name
    def name
      return @@codes[@val]
    end
  end

  # Enum that maps the :cl_build_status type
  class BuildStatus < EnumInt
    SUCCESS = 0
    NONE = -1
    ERROR = -2
    IN_PROGRESS = -3
    @@codes[0] = 'SUCCESS'
    @@codes[-1] = 'NONE'
    @@codes[-2] = 'ERROR'
    @@codes[-3] = 'IN_PROGRESS'
    # Returns a String representing the Enum value name
    def name
      return @@codes[@val]
    end
  end

  # Enum that maps the command execution status logical type
  class CommandExecutionStatus < EnumInt
    COMPLETE = 0x0
    RUNNING = 0x1
    SUBMITTED = 0x2
    QUEUED = 0x3
    @@codes[0x0] = 'COMPLETE'
    @@codes[0x1] = 'RUNNING'
    @@codes[0x2] = 'SUBMITTED'
    @@codes[0x3] = 'QUEUED'
    # Returns a String representing the Enum value name
    def name
      return @@codes[@val]
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
  class Pipe < Mem
    layout :dummy, :pointer
    #:stopdoc:
    PACKET_SIZE = 0x1120
    MAX_PACKETS = 0x1121
    #:startdoc:
  end
  attach_function :clGetPlatformIDs, [:cl_uint,:pointer,:pointer], :cl_int
  attach_function :clGetPlatformInfo, [Platform,:cl_platform_info,:size_t,:pointer,:pointer], :cl_int
  attach_function :clGetDeviceIDs, [Platform,:cl_device_type,:cl_uint,:pointer,:pointer], :cl_int
  attach_function :clGetDeviceInfo, [Device,:cl_device_info,:size_t,:pointer,:pointer], :cl_int
  callback :clCreateContext_notify, [:pointer,:pointer,:size_t,:pointer], :void
  attach_function :clCreateContext, [:pointer,:cl_uint,:pointer,:clCreateContext_notify,:pointer,:pointer], Context
  callback :clCreateContextFromType_notify, [:pointer,:pointer,:size_t,:pointer], :void
  attach_function :clCreateContextFromType, [:pointer,:cl_device_type,:clCreateContextFromType_notify,:pointer,:pointer], Context
  attach_function :clRetainContext, [Context], :cl_int
  attach_function :clReleaseContext, [Context], :cl_int
  attach_function :clGetContextInfo, [Context,:cl_context_info,:size_t,:pointer,:pointer], :cl_int
  attach_function :clRetainCommandQueue, [CommandQueue], :cl_int
  attach_function :clReleaseCommandQueue, [CommandQueue], :cl_int
  attach_function :clGetCommandQueueInfo, [CommandQueue,:cl_command_queue_info,:size_t,:pointer,:pointer], :cl_int
  attach_function :clCreateBuffer, [Context,:cl_mem_flags,:size_t,:pointer,:pointer], Mem
  attach_function :clCreateSubBuffer, [Mem,:cl_mem_flags,:cl_buffer_create_type,:pointer,:pointer], Mem
  attach_function :clRetainMemObject, [Mem], :cl_int
  attach_function :clReleaseMemObject, [Mem], :cl_int
  attach_function :clGetSupportedImageFormats, [Context,:cl_mem_flags,:cl_mem_object_type,:cl_uint,:pointer,:pointer], :cl_int
  attach_function :clGetMemObjectInfo, [Mem,:cl_mem_info,:size_t,:pointer,:pointer], :cl_int
  attach_function :clGetImageInfo, [Mem,:cl_image_info,:size_t,:pointer,:pointer], :cl_int
  callback :clSetMemObjectDestructorCallback_notify, [:pointer,:pointer], :void
  attach_function :clSetMemObjectDestructorCallback, [Mem,:clSetMemObjectDestructorCallback_notify,:pointer], :cl_int
  attach_function :clRetainSampler, [Sampler], :cl_int
  attach_function :clReleaseSampler, [Sampler], :cl_int
  attach_function :clGetSamplerInfo, [Sampler,:cl_sampler_info,:size_t,:pointer,:pointer], :cl_int
  attach_function :clCreateProgramWithSource, [Context,:cl_uint,:pointer,:pointer,:pointer], Program
  attach_function :clCreateProgramWithBinary, [Context,:cl_uint,:pointer,:pointer,:pointer,:pointer,:pointer], Program
  attach_function :clRetainProgram, [Program], :cl_int
  attach_function :clReleaseProgram, [Program], :cl_int
  callback :clBuildProgram_notify, [Program.by_ref,:pointer], :void
  attach_function :clBuildProgram, [Program,:cl_uint,:pointer,:pointer,:clBuildProgram_notify,:pointer], :cl_int
  attach_function :clGetProgramInfo, [Program,:cl_program_info,:size_t,:pointer,:pointer], :cl_int
  attach_function :clGetProgramBuildInfo, [Program,Device,:cl_program_build_info,:size_t,:pointer,:pointer], :cl_int
  attach_function :clCreateKernel, [Program,:pointer,:pointer], Kernel
  attach_function :clCreateKernelsInProgram, [Program,:cl_uint,:pointer,:pointer], :cl_int
  attach_function :clRetainKernel, [Kernel], :cl_int
  attach_function :clReleaseKernel, [Kernel], :cl_int
  attach_function :clSetKernelArg, [Kernel,:cl_uint,:size_t,:pointer], :cl_int
  attach_function :clGetKernelInfo, [Kernel,:cl_kernel_info,:size_t,:pointer,:pointer], :cl_int
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
  attach_function :clEnqueueCopyBuffer, [CommandQueue,Mem,Mem,:size_t,:size_t,:size_t,:cl_uint,:pointer,:pointer], :cl_int
  attach_function :clEnqueueCopyBufferRect, [CommandQueue,Mem,Mem,:pointer,:pointer,:pointer,:size_t,:size_t,:size_t,:size_t,:cl_uint,:pointer,:pointer], :cl_int
  attach_function :clEnqueueReadImage, [CommandQueue,Mem,:cl_bool,:pointer,:pointer,:size_t,:size_t,:pointer,:cl_uint,:pointer,:pointer], :cl_int
  attach_function :clEnqueueWriteImage, [CommandQueue,Mem,:cl_bool,:pointer,:pointer,:size_t,:size_t,:pointer,:cl_uint,:pointer,:pointer], :cl_int
  attach_function :clEnqueueCopyImage, [CommandQueue,Mem,Mem,:pointer,:pointer,:pointer,:cl_uint,:pointer,:pointer], :cl_int
  attach_function :clEnqueueCopyImageToBuffer, [CommandQueue,Mem,Mem,:pointer,:pointer,:size_t,:cl_uint,:pointer,:pointer], :cl_int
  attach_function :clEnqueueCopyBufferToImage, [CommandQueue,Mem,Mem,:size_t,:pointer,:pointer,:cl_uint,:pointer,:pointer], :cl_int
  attach_function :clEnqueueMapBuffer, [CommandQueue,Mem,:cl_bool,:cl_map_flags,:size_t,:size_t,:cl_uint,:pointer,:pointer,:pointer], :pointer
  attach_function :clEnqueueMapImage, [CommandQueue,Mem,:cl_bool,:cl_map_flags,:pointer,:pointer,:pointer,:pointer,:cl_uint,:pointer,:pointer,:pointer], :pointer
  attach_function :clEnqueueUnmapMemObject, [CommandQueue,Mem,:pointer,:cl_uint,:pointer,:pointer], :cl_int
  attach_function :clEnqueueNDRangeKernel, [CommandQueue,Kernel,:cl_uint,:pointer,:pointer,:pointer,:cl_uint,:pointer,:pointer], :cl_int
  callback :clEnqueueNativeKernel_notify, [:pointer], :void
  attach_function :clEnqueueNativeKernel, [CommandQueue,:clEnqueueNativeKernel_notify,:pointer,:size_t,:cl_uint,:pointer,:pointer,:cl_uint,:pointer,:pointer], :cl_int
  attach_function :clCreateImage2D, [Context,:cl_mem_flags,:pointer,:size_t,:size_t,:size_t,:pointer,:pointer], Mem
  attach_function :clCreateImage3D, [Context,:cl_mem_flags,:pointer,:size_t,:size_t,:size_t,:size_t,:size_t,:pointer,:pointer], Mem
  attach_function :clEnqueueMarker, [CommandQueue,:pointer], :cl_int
  attach_function :clEnqueueWaitForEvents, [CommandQueue,:cl_uint,:pointer], :cl_int
  attach_function :clEnqueueBarrier, [CommandQueue], :cl_int
  attach_function :clUnloadCompiler, [:void], :cl_int
  attach_function :clGetExtensionFunctionAddress, [:pointer], :pointer
  attach_function :clCreateCommandQueue, [Context,Device,:cl_command_queue_properties,:pointer], CommandQueue
  attach_function :clCreateSampler, [Context,:cl_bool,:cl_addressing_mode,:cl_filter_mode,:pointer], Sampler
  attach_function :clEnqueueTask, [CommandQueue,Kernel,:cl_uint,:pointer,:pointer], :cl_int
  attach_function :clCreateFromGLBuffer, [Context,:cl_mem_flags,:cl_GLuint,:pointer], Mem
  attach_function :clCreateFromGLRenderbuffer, [Context,:cl_mem_flags,:cl_GLuint,:pointer], Mem
  attach_function :clGetGLObjectInfo, [Mem,:pointer,:pointer], :cl_int
  attach_function :clGetGLTextureInfo, [Mem,:cl_gl_texture_info,:size_t,:pointer,:pointer], :cl_int
  attach_function :clEnqueueAcquireGLObjects, [CommandQueue,:cl_uint,:pointer,:cl_uint,:pointer,:pointer], :cl_int
  attach_function :clEnqueueReleaseGLObjects, [CommandQueue,:cl_uint,:pointer,:cl_uint,:pointer,:pointer], :cl_int
  attach_function :clCreateFromGLTexture2D, [Context,:cl_mem_flags,:cl_GLenum,:cl_GLint,:cl_GLuint,:pointer], Mem
  attach_function :clCreateFromGLTexture3D, [Context,:cl_mem_flags,:cl_GLenum,:cl_GLint,:cl_GLuint,:pointer], Mem
  begin
    attach_function :clCreateSubDevices, [Device,:pointer,:cl_uint,:pointer,:pointer], :cl_int
    attach_function :clRetainDevice, [Device], :cl_int
    attach_function :clReleaseDevice, [Device], :cl_int
    attach_function :clCreateImage, [Context,:cl_mem_flags,:pointer,:pointer,:pointer,:pointer], Mem
    attach_function :clCreateProgramWithBuiltInKernels, [Context,:cl_uint,:pointer,:pointer,:pointer], Program
    callback :clCompileProgram_notify, [Program.by_ref,:pointer], :void
    attach_function :clCompileProgram, [Program,:cl_uint,:pointer,:pointer,:cl_uint,:pointer,:pointer,:clCompileProgram_notify,:pointer], :cl_int
    callback :clLinkProgram_notify, [Program.by_ref,:pointer], :void
    attach_function :clLinkProgram, [Context,:cl_uint,:pointer,:pointer,:cl_uint,:pointer,:clLinkProgram_notify,:pointer,:pointer], Program
    attach_function :clUnloadPlatformCompiler, [Platform], :cl_int
    attach_function :clGetKernelArgInfo, [Kernel,:cl_uint,:cl_kernel_arg_info,:size_t,:pointer,:pointer], :cl_int
    attach_function :clEnqueueFillBuffer, [CommandQueue,Mem,:pointer,:size_t,:size_t,:size_t,:cl_uint,:pointer,:pointer], :cl_int
    attach_function :clEnqueueFillImage, [CommandQueue,Mem,:pointer,:pointer,:pointer,:cl_uint,:pointer,:pointer], :cl_int
    attach_function :clEnqueueMigrateMemObjects, [CommandQueue,:cl_uint,:pointer,:cl_mem_migration_flags,:cl_uint,:pointer,:pointer], :cl_int
    attach_function :clEnqueueMarkerWithWaitList, [CommandQueue,:cl_uint,:pointer,:pointer], :cl_int
    attach_function :clEnqueueBarrierWithWaitList, [CommandQueue,:cl_uint,:pointer,:pointer], :cl_int
    attach_function :clGetExtensionFunctionAddressForPlatform, [Platform,:pointer], :pointer
    attach_function :clCreateFromGLTexture, [Context,:cl_mem_flags,:cl_GLenum,:cl_GLint,:cl_GLuint,:pointer], Mem
    begin
      attach_function :clCreateCommandQueueWithProperties, [Context,Device,:pointer,:pointer], CommandQueue
      attach_function :clCreatePipe, [Context,:cl_mem_flags,:cl_uint,:cl_uint,:pointer,:pointer], Mem
      attach_function :clGetPipeInfo, [Mem,:cl_pipe_info,:size_t,:pointer,:pointer], :cl_int
      attach_function :clSVMAlloc, [Context,:cl_svm_mem_flags,:size_t,:cl_uint], :pointer
      attach_function :clSVMFree, [Context,:pointer], :void
      attach_function :clCreateSamplerWithProperties, [Context,:pointer,:pointer], Sampler
      attach_function :clSetKernelArgSVMPointer, [Kernel,:cl_uint,:pointer], :cl_int
      attach_function :clSetKernelExecInfo, [Kernel,:cl_kernel_exec_info,:size_t,:pointer], :cl_int
      callback :clEnqueueSVMFree_notify, [CommandQueue.by_ref,:cl_uint,:pointer,:pointer], :void
      attach_function :clEnqueueSVMFree, [CommandQueue,:cl_uint,:pointer,:clEnqueueSVMFree_notify,:pointer,:cl_uint,:pointer,:pointer], :cl_int
      attach_function :clEnqueueSVMMemcpy, [CommandQueue,:cl_bool,:pointer,:pointer,:size_t,:cl_uint,:pointer,:pointer], :cl_int
      attach_function :clEnqueueSVMMemFill, [CommandQueue,:pointer,:pointer,:size_t,:size_t,:cl_uint,:pointer,:pointer], :cl_int
      attach_function :clEnqueueSVMMap, [CommandQueue,:cl_bool,:cl_map_flags,:pointer,:size_t,:cl_uint,:pointer,:pointer], :cl_int
      attach_function :clEnqueueSVMUnmap, [CommandQueue,:pointer,:cl_uint,:pointer,:pointer], :cl_int
    rescue FFI::NotFoundError => e
      STDERR.puts "Warning OpenCL 1.2 loader detected!"
    end
  rescue FFI::NotFoundError => e
    STDERR.puts "Warning OpenCL 1.1 loader detected!"
  end
end

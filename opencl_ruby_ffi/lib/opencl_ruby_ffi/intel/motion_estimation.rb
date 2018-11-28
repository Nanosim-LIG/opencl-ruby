using OpenCLRefinements if RUBY_VERSION.scan(/\d+/).collect(&:to_i).first >= 2

require_relative 'accelerator'

module OpenCL
  ACCELERATOR_TYPE_MOTION_ESTIMATION_INTEL = 0x0
  ME_MB_TYPE_16x16_INTEL = 0x0
  ME_MB_TYPE_8x8_INTEL = 0x1
  ME_MB_TYPE_4x4_INTEL = 0x2
  ME_SUBPIXEL_MODE_INTEGER_INTEL = 0x0
  ME_SUBPIXEL_MODE_HPEL_INTEL = 0x1
  ME_SUBPIXEL_MODE_QPEL_INTEL = 0x2
  ME_SAD_ADJUST_MODE_NONE_INTEL = 0x0
  ME_SAD_ADJUST_MODE_HAAR_INTEL = 0x1
  ME_SEARCH_PATH_RADIUS_2_2_INTEL = 0x0
  ME_SEARCH_PATH_RADIUS_4_4_INTEL = 0x1
  ME_SEARCH_PATH_RADIUS_16_12_INTEL = 0x5

  class MotionEstimationDescINTEL < FFI::Struct
    layout :mb_block_type, :cl_uint,
           :subpixel_mode, :cl_uint,
           :sad_adjust_mode, :cl_uint,
           :search_path_type, :cl_uint
  end

end

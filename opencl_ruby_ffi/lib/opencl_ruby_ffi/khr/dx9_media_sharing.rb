using OpenCLRefinements if RUBY_VERSION.scan(/\d+/).collect(&:to_i).first >= 2

module OpenCL

  INVALID_DX9_MEDIA_ADAPTER_KHR = -1010
  INVALID_DX9_MEDIA_SURFACE_KHR = -1011
  DX9_MEDIA_SURFACE_ALREADY_ACQUIRED_KHR = -1012
  DX9_MEDIA_SURFACE_NOT_ACQUIRED_KHR = -1013

  ADAPTER_D3D9_KHR = 0x2020
  ADAPTER_D3D9EX_KHR = 0x2021
  ADAPTER_DXVA_KHR = 0x2022
  PREFERRED_DEVICES_FOR_DX9_MEDIA_ADAPTER_KHR = 0x2023
  ALL_DEVICES_FOR_DX9_MEDIA_ADAPTER_KHR = 0x2024
  CONTEXT_ADAPTER_D3D9_KHR = 0x2025
  CONTEXT_ADAPTER_D3D9EX_KHR = 0x2026
  CONTEXT_ADAPTER_DXVA_KHR = 0x2027
  MEM_DX9_MEDIA_ADAPTER_TYPE_KHR = 0x2028
  MEM_DX9_MEDIA_SURFACE_INFO_KHR = 0x2029
  IMAGE_DX9_MEDIA_PLANE_KHR = 0x202A
  COMMAND_ACQUIRE_DX9_MEDIA_SURFACES_KHR = 0x202B
  COMMAND_RELEASE_DX9_MEDIA_SURFACES_KHR = 0x202C

  class Error

    eval error_class_constructor( :INVALID_DX9_MEDIA_ADAPTER_KHR,          :InvalidDX9MediaAdapterKHR )
    eval error_class_constructor( :INVALID_DX9_MEDIA_SURFACE_KHR,          :InvalidDX9MediaSurfaceKHR )
    eval error_class_constructor( :DX9_MEDIA_SURFACE_ALREADY_ACQUIRED_KHR, :DX9MediaSurfaceAlreadyAcquiredKHR )
    eval error_class_constructor( :DX9_MEDIA_SURFACE_NOT_ACQUIRED_KHR,     :DX9MediaSurfaceNotAcquiredKHR )

  end

  class Context
    ADAPTER_D3D9_KHR = 0x2025
    ADAPTER_D3D9EX_KHR = 0x2026
    ADAPTER_DXVA_KHR = 0x2027

    class Properties
      ADAPTER_D3D9_KHR = 0x2025
      ADAPTER_D3D9EX_KHR = 0x2026
      ADAPTER_DXVA_KHR = 0x2027
      @codes[0x2025] = 'ADAPTER_D3D9_KHR'
      @codes[0x2026] = 'ADAPTER_D3D9EX_KHR'
      @codes[0x2026] = 'ADAPTER_DXVA_KHR'
    end

  end

  class Mem
    DX9_MEDIA_ADAPTER_TYPE_KHR = 0x2028
    DX9_MEDIA_SURFACE_INFO_KHR = 0x2029
  end

  class Image
    DX9_MEDIA_PLANE_KHR = 0x202A
  end

  class CommandType
    ACQUIRE_DX9_MEDIA_SURFACES_KHR = 0x202B
    RELEASE_DX9_MEDIA_SURFACES_KHR = 0x202C
    @codes[0x202B] = 'ACQUIRE_DX9_MEDIA_SURFACES_KHR'
    @codes[0x202C] = 'RELEASE_DX9_MEDIA_SURFACES_KHR'
  end

  [
    [ "clGetDeviceIDsFromDX9MediaAdapterKHR",
      :cl_int,
      [ Platform,
        :cl_uint,
        :pointer,
        :pointer,
        :cl_dx9_media_adapter_set_khr,
        :cl_uint,
        :pointer,
        :pointer
      ]
    ], [
      "clCreateFromDX9MediaSurfaceKHR",
      Mem,
      [ Context,
        :cl_mem_flags,
        :cl_dx9_media_adapter_type_khr,
        :pointer,
        :cl_uint,
        :pointer
      ]
    ], [
      "clEnqueueAcquireDX9MediaSurfacesKHR",
      :cl_int,
      [ CommandQueue,
        :cl_uint,
        :pointer,
        :cl_uint,
        :pointer,
        :pointer,
      ]
    ], [
      "clEnqueueReleaseDX9MediaSurfacesKHR",
      :cl_int,
      [ CommandQueue,
        :cl_uint,
        :pointer,
        :cl_uint,
        :pointer,
        :pointer,
      ]
    ]
  ].each { |name, return_type, args|
    attach_extension_function(name, return_type, args)
  }

end

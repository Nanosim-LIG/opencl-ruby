require 'opencl_ruby_ffi'
using OpenCLRefinements if RUBY_VERSION.scan(/\d+/).collect(&:to_i).first >= 2

module OpenCL

  INVALID_D3D11_DEVICE_KHR = -1006
  INVALID_D3D11_RESOURCE_KHR = -1007
  D3D11_RESOURCE_ALREADY_ACQUIRED_KHR = -1008
  D3D11_RESOURCE_NOT_ACQUIRED_KHR = -1009

  D3D11_DEVICE_KHR = 0x4019
  D3D11_DXGI_ADAPTER_KHR = 0x401A
  PREFERRED_DEVICES_FOR_D3D11_KHR = 0x401B
  ALL_DEVICES_FOR_D3D11_KHR = 0x401C
  CONTEXT_D3D11_DEVICE_KHR = 0x401D
  CONTEXT_D3D11_PREFER_SHARED_RESOURCES_KHR = 0x402D
  MEM_D3D11_RESOURCE_KHR = 0x401E
  IMAGE_D3D11_SUBRESOURCE_KHR = 0x401F
  COMMAND_ACQUIRE_D3D11_OBJECTS_KHR = 0x4020
  COMMAND_RELEASE_D3D11_OBJECTS_KHR = 0x4021

  class Error

    eval error_class_constructor( :INVALID_D3D11_DEVICE_KHR,            :InvalidD3D11DeviceKHR )
    eval error_class_constructor( :INVALID_D3D11_RESOURCE_KHR,          :InvalidD3D11ResourceKHR )
    eval error_class_constructor( :D3D11_RESOURCE_ALREADY_ACQUIRED_KHR, :D3D11ResourceAlreadyAcquiredKHR )
    eval error_class_constructor( :D3D11_RESOURCE_NOT_ACQUIRED_KHR,     :D3D11ResourceNotAcquiredKHR )

  end

  class Context
    D3D11_DEVICE_KHR = 0x401D
    D3D11_PREFER_SHARED_RESOURCES_KHR = 0x402D

    class Properties
      D3D11_DEVICE_KHR = 0x401D
      D3D11_PREFER_SHARED_RESOURCES_KHR = 0x402D
      @codes[0x401D] = 'D3D11_DEVICE_KHR'
      @codes[0x402D] = 'D3D11_PREFER_SHARED_RESOURCES_KHR'
    end

  end

  class Mem
    D3D11_RESOURCE_KHR = 0x401E
  end

  class Image
    D3D11_SUBRESOURCE_KHR = 0x401F
  end

  class CommandType
    ACQUIRE_D3D11_OBJECTS_KHR = 0x4020
    RELEASE_D3D11_OBJECTS_KHR = 0x4021
    @codes[0x4020] = 'ACQUIRE_D3D11_OBJECTS_KHR'
    @codes[0x4021] = 'RELEASE_D3D11_OBJECTS_KHR'
  end

  [
    [ "clGetDeviceIDsFromD3D11KHR",
      :cl_int,
      [ Platform,
        :cl_d3d11_device_source_khr,
        :pointer,
        :cl_d3d11_device_set_khr,
        :cl_uint,
        :pointer,
        :pointer
      ]
    ], [
      "clCreateFromD3D11BufferKHR",
      Mem,
      [ Context,
        :cl_mem_flags,
        :pointer,
        :pointer ]
    ], [
      "clCreateFromD3D11Texture2DKHR",
      Mem,
      [ Context, 
        :cl_mem_flags, 
        :pointer,
        :cl_uint,
        :pointer
      ]
    ], [
      "clCreateFromD3D11Texture3DKHR",
      Mem,
      [ Context, 
        :cl_mem_flags, 
        :pointer,
        :cl_uint,
        :pointer
      ]
    ], [
      "clEnqueueAcquireD3D11ObjectsKHR",
      :cl_int,
      [ CommandQueue,
        :cl_uint,
        :pointer,
        :cl_uint,
        :pointer,
        :pointer,
      ]
    ], [
      "clEnqueueReleaseD3D11ObjectsKHR",
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

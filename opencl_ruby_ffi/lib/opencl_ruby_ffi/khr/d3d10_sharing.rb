using OpenCLRefinements if RUBY_VERSION.scan(/\d+/).collect(&:to_i).first >= 2

module OpenCL

  INVALID_D3D10_DEVICE_KHR = -1002
  INVALID_D3D10_RESOURCE_KHR = -1003
  D3D10_RESOURCE_ALREADY_ACQUIRED_KHR = -1004
  D3D10_RESOURCE_NOT_ACQUIRED_KHR = -1005

  D3D10_DEVICE_KHR = 0x4010
  D3D10_DXGI_ADAPTER_KHR = 0x4011
  PREFERRED_DEVICES_FOR_D3D10_KHR = 0x4012
  ALL_DEVICES_FOR_D3D10_KHR = 0x4013
  CONTEXT_D3D10_DEVICE_KHR = 0x4014
  CONTEXT_D3D10_PREFER_SHARED_RESOURCES_KHR = 0x402C
  MEM_D3D10_RESOURCE_KHR = 0x4015
  IMAGE_D3D10_SUBRESOURCE_KHR = 0x4016
  COMMAND_ACQUIRE_D3D10_OBJECTS_KHR = 0x4017
  COMMAND_RELEASE_D3D10_OBJECTS_KHR = 0x4018

  class Error

    eval error_class_constructor( :INVALID_D3D10_DEVICE_KHR,            :InvalidD3D10DeviceKHR )
    eval error_class_constructor( :INVALID_D3D10_RESOURCE_KHR,          :InvalidD3D10ResourceKHR )
    eval error_class_constructor( :D3D10_RESOURCE_ALREADY_ACQUIRED_KHR, :D3D10ResourceAlreadyAcquiredKHR )
    eval error_class_constructor( :D3D10_RESOURCE_NOT_ACQUIRED_KHR,     :D3D10ResourceNotAcquiredKHR )

  end

  class Context
    D3D10_DEVICE_KHR = 0x4014
    D3D10_PREFER_SHARED_RESOURCES_KHR = 0x402C

    class Properties
      D3D10_DEVICE_KHR = 0x4014
      D3D10_PREFER_SHARED_RESOURCES_KHR = 0x402C
      @codes[0x4014] = 'D3D10_DEVICE_KHR'
      @codes[0x402C] = 'D3D10_PREFER_SHARED_RESOURCES_KHR'
    end

  end

  class Mem
    D3D10_RESOURCE_KHR = 0x4015
  end

  class Image
    D3D10_SUBRESOURCE_KHR = 0x4016
  end

  class CommandType
    ACQUIRE_D3D10_OBJECTS_KHR = 0x4017
    RELEASE_D3D10_OBJECTS_KHR = 0x4018
    @codes[0x4017] = 'ACQUIRE_D3D10_OBJECTS_KHR'
    @codes[0x4018] = 'RELEASE_D3D10_OBJECTS_KHR'
  end

  [
    [ "clGetDeviceIDsFromD3D10KHR",
      :cl_int,
      [ Platform,
        :cl_d3d10_device_source_khr,
        :pointer,
        :cl_d3d10_device_set_khr,
        :cl_uint,
        :pointer,
        :pointer
      ]
    ], [
      "clCreateFromD3D10BufferKHR",
      Mem,
      [ Context,
        :cl_mem_flags,
        :pointer,
        :pointer ]
    ], [
      "clCreateFromD3D10Texture2DKHR",
      Mem,
      [ Context, 
        :cl_mem_flags, 
        :pointer,
        :cl_uint,
        :pointer
      ]
    ], [
      "clCreateFromD3D10Texture3DKHR",
      Mem,
      [ Context, 
        :cl_mem_flags, 
        :pointer,
        :cl_uint,
        :pointer
      ]
    ], [
      "clEnqueueAcquireD3D10ObjectsKHR",
      :cl_int,
      [ CommandQueue,
        :cl_uint,
        :pointer,
        :cl_uint,
        :pointer,
        :pointer,
      ]
    ], [
      "clEnqueueReleaseD3D10ObjectsKHR",
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

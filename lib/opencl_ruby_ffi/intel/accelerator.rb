module OpenCL

  ACCELERATOR_DESCRIPTOR_INTEL = 0x4090
  ACCELERATOR_REFERENCE_COUNT_INTEL = 0x4091
  ACCELERATOR_CONTEXT_INTEL = 0x4092
  ACCELERATOR_TYPE_INTEL = 0x4093
  INVALID_ACCELERATOR_INTEL = -1094
  INVALID_ACCELERATOR_TYPE_INTEL = -1095
  INVALID_ACCELERATOR_DESCRIPTOR_INTEL = -1096
  ACCELERATOR_TYPE_NOT_SUPPORTED_INTEL = -1097

  typedef :cl_uint, :cl_accelerator_type_intel
  typedef :cl_uint, :cl_accelerator_info_intel

end

if RUBY_VERSION.scan(/\d+/).collect(&:to_i).first >= 2
  module OpenCLRefinements
    refine FFI::Pointer do
      methods_prefix = [:put, :get, :write, :read, :put_array_of, :get_array_of]
      [[:cl_uint, :cl_accelerator_type_intel],
       [:cl_uint, :cl_accelerator_info_intel]].each { |orig, add|
        methods_prefix.each { |meth|
          alias_method "#{meth}_#{add}".to_sym, "#{meth}_#{orig}".to_sym
        }
      }
    end
  end
  using OpenCLRefinements
else
  class FFI::Pointer
    methods_prefix = [:put, :get, :write, :read, :put_array_of, :get_array_of]
    [[:cl_uint, :cl_accelerator_type_intel],
     [:cl_uint, :cl_accelerator_info_intel]].each { |orig, add|
      methods_prefix.each { |meth|
          alias_method "#{meth}_#{add}".to_sym, "#{meth}_#{orig}".to_sym
      }
    }
  end
end

module OpenCL

  class Error
    eval error_class_constructor( :INVALID_ACCELERATOR_INTEL, :InvalidAcceleratorINTEL )
    eval error_class_constructor( :INVALID_ACCELERATOR_TYPE_INTEL, :InvalidAcceleratorTypeINTEL )
    eval error_class_constructor( :INVALID_ACCELERATOR_DESCRIPTOR_INTEL, :InvalidAcceleratorDescriptorINTEL )
    eval error_class_constructor( :ACCELERATOR_TYPE_NOT_SUPPORTED_INTEL, :AcceleratorTypeNotSupportedINTEL )
  end

  class AcceleratorINTEL < ExtendedStruct
    class AcceleratorINTELPointer < FFI::Pointer
      attr_accessor :context
      def initialize(ptr, context)
        super(ptr)
        @context = context
      end
    end

    include InnerInterface
    extend ExtensionInnerGenerator
    layout :dummy, :pointer
    DESCRIPTOR_INTEL = 0x4090
    REFERENCE_COUNT_INTEL = 0x4091
    CONTEXT_INTEL = 0x4092
    TYPE_INTEL = 0x4093

    def platform
      @context.platform
    end

    def initialize(ptr, context = ptr.context, retain = true)
      super(AcceleratorINTELPointer::new(ptr, context))
      @context = context
      context.__retain_accelerator_intel(ptr) if retain
    end

    def self.release(ptr)
      ptr.context.__release_accelerator_intel(ptr)
    end

    def descriptor_intel
      f = platform.get_extension_function("clGetAcceleratorInfoINTEL", :cl_int,
            [OpenCL::AcceleratorINTEL, :cl_accelerator_info_intel, :size_t, :pointer, :pointer])
      error_check(OpenCL::INVALID_OPERATION) unless f

      ptr1 = MemoryPointer::new( :size_t, 1)
      error = f.call(self, DESCRIPTOR_INTEL, 0, nil, ptr1)
      error_check(error)
      ptr2 = MemoryPointer::new( ptr1.read_size_t )
      error = f.call(self, DESCRIPTOR_INTEL, ptr1.read_size_t, ptr2, nil)
      error_check(error)
      return ptr2
    end

    def context_intel
      f = platform.get_extension_function("clGetAcceleratorInfoINTEL", :cl_int,
            [OpenCL::AcceleratorINTEL, :cl_accelerator_info_intel, :size_t, :pointer, :pointer])
      error_check(OpenCL::INVALID_OPERATION) unless f

      ptr = MemoryPointer::new( Context )
      error = f.call(self, CONTEXT_INTEL, Context.size, ptr, nil)
      error_check(error)
      return Context::new( ptr.read_pointer )
    end

    get_info_ext("AcceleratorINTEL", :cl_uint, "reference_count_intel", "clGetAcceleratorInfoINTEL")
    get_info_ext("AcceleratorINTEL", :cl_uint, "type_intel", "clGetAcceleratorInfoINTEL")

  end

  class Context
    module AcceleratorINTEL

      def create_accelerator_intel(accelerator_type, descriptor, options = {})
        name = "clCreateAcceleratorINTEL"
        return_type = OpenCL::AcceleratorINTEL
        params = [Context, :cl_accelerator_type_intel, :size_t, :pointer, :pointer]
        f = platform.get_extension_function(name, return_type, params)
        error_check(OpenCL::INVALID_OPERATION) unless f
        error = MemoryPointer::new( :cl_int )
        size = descriptor.size
        acc = f.call(self, accelerator_type, size, descriptor, error)
        error_check(error.read_cl_int)
        return OpenCL::AcceleratorINTEL::new( acc, self, false )
      end

      def __release_accelerator_intel(ptr)
        name = "clReleaseAcceleratorINTEL"
        return_type = :cl_int
        params = [OpenCL::AcceleratorINTEL]
        f = platform.get_extension_function(name, return_type, params)
        error_check(OpenCL::INVALID_OPERATION) unless f
        error = f.call(ptr)
        error_check(error)
      end

      def __retain_accelerator_intel(ptr)
        name = "clRetainAcceleratorINTEL"
        return_type = :cl_int
        params = [OpenCL::AcceleratorINTEL]
        f = platform.get_extension_function(name, return_type, params)
        error_check(OpenCL::INVALID_OPERATION) unless f
        error = f.call(ptr)
        error_check(error)
      end

    end
    register_extension( :cl_intel_accelerator, AcceleratorINTEL, "platform.extensions.include?(\"cl_intel_accelerator\")" )
  end

end

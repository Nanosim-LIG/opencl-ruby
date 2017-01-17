using OpenCLRefinements if RUBY_VERSION.scan(/\d+/).collect(&:to_i).first >= 2

module OpenCL

  CONTEXT_MEMORY_INITIALIZE_KHR = 0x200E

  class Context

    MEMORY_INITIALIZE_KHR = 0x200E

    class Properties
      MEMORY_INITIALIZE_KHR = 0x2030
      @codes[0x2030] = 'MEMORY_INITIALIZE_KHR'
    end

  end
 
end

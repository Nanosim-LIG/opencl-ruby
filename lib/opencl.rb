require "opencl.so"

module OpenCL

  class Vector
    def inspect
      "#<#{self.class}: #{self.to_a.join(", ")}>"
    end
  end

  class VArray
    def inspect
      "#<#{self.class}: length=#{self.length}, type_code=#{self.type_code}>"
    end
  end

end

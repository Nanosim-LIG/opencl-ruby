require "narray"
require "opencl.so"

module OpenCL

  class Vector
    def inspect
      "#<#{self.class}: #{self.to_a.join(", ")}>"
    end
  end

  class VArray
    def inspect
      data = Array.new
      [self.length,4].min.times do |i|
        data.push self.type_code%100==1 ? self[i] : self[i].to_a.inspect
      end
      "#<#{self.class}: length=#{self.length}, type_code=#{self.type_code},\n  data=[#{data.join(", ")}#{self.length>4 ? ", ..." : ""}]>"
    end
  end

end

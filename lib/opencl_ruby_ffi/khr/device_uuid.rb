using OpenCLRefinements if RUBY_VERSION.scan(/\d+/).collect(&:to_i).first >= 2

module OpenCL

  UUID_SIZE_KHR = 16
  LUID_SIZE_KHR = 8

  DEVICE_UUID_KHR = 0x106A
  DRIVER_UUID_KHR = 0x106B
  DEVICE_LUID_VALID_KHR = 0x106C
  DEVICE_LUID_KHR = 0x106D
  DEVICE_NODE_MASK_KHR = 0x106E

  class UUID < Struct
    layout :id, [ OpenCL.find_type(:cl_uchar), UUID_SIZE_KHR ]
    def to_s
      a = self[:id].to_a
      s = ""
      s << "%02x" % a[15]
      s << "%02x" % a[14]
      s << "%02x" % a[13]
      s << "%02x" % a[12]
      s << "-"
      s << "%02x" % a[11]
      s << "%02x" % a[10]
      s << "-"
      s << "%02x" % a[9]
      s << "%02x" % a[8]
      s << "-"
      s << "%02x" % a[7]
      s << "%02x" % a[6]
      s << "-"
      s << "%02x" % a[5]
      s << "%02x" % a[4]
      s << "%02x" % a[3]
      s << "%02x" % a[2]
      s << "%02x" % a[1]
      s << "%02x" % a[0]
    end

    def self.from_string(uuid)
      new.from_string(uuid)
    end

    def from_string(uuid)
      m = uuid.match(/(\h\h)(\h\h)(\h\h)(\h\h)-(\h\h)(\h\h)-(\h\h)(\h\h)-(\h\h)(\h\h)-(\h\h)(\h\h)(\h\h)(\h\h)(\h\h)(\h\h)/)
      raise "invalid format" unless m
      UUID_SIZE_KHR.times { |i|
        self[:id][UUID_SIZE_KHR-1-i] = m[i+1].to_i(16)
      }
      self
    end
  end

  class LUID < Struct
    layout :id, [ OpenCL.find_type(:cl_uchar), LUID_SIZE_KHR ]
    def to_s
      a = self[:id].to_a
      s = ""
      s << "%02x" % a[7]
      s << "%02x" % a[6]
      s << "%02x" % a[5]
      s << "%02x" % a[4]
      s << "%02x" % a[3]
      s << "%02x" % a[2]
      s << "%02x" % a[1]
      s << "%02x" % a[0]
    end

    def self.from_string(uuid)
      new.from_string(uuid)
    end

    def from_string(uuid)
      m = uuid.match(/(\h\h)(\h\h)(\h\h)(\h\h)(\h\h)(\h\h)(\h\h)(\h\h)/)
      raise "invalid format" unless m
      LUID_SIZE_KHR.times { |i|
        self[:id][LUID_SIZE_KHR-1-i] = m[i+1].to_i(16)
      }
      self
    end
  end

  class Device
    UUID_KHR = 0x106A
    LUID_VALID_KHR = 0x106C
    LUID_KHR = 0x106D
    NODE_MASK_KHR = 0x106E

    module KHRDeviceUUID
      extend InnerGenerator
      get_info("Device", :cl_bool, "luid_valid_khr")
      get_info("Device", :cl_uint, "node_mask_khr")

      def uuid_khr
        id = UUID.new
        error = OpenCL.clGetDeviceInfo( self, UUID_KHR, UUID_SIZE_KHR, id, nil)
        error_check(error)
        return id
      end

      def driver_uuid_khr
        id = UUID.new
        error = OpenCL.clGetDeviceInfo( self, DRIVER_UUID_KHR, UUID_SIZE_KHR, id, nil)
        error_check(error)
        return id
      end

      def luid_khr
        id = LUID.new
        error = OpenCL.clGetDeviceInfo( self, LUID_KHR, LUID_SIZE_KHR, id, nil)
        error_check(error)
        return id
      end
    end
    register_extension( :cl_khr_device_uuid, KHRDeviceUUID, "extensions.include?(\"cl_khr_device_uuid\")" )
  end

end

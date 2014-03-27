module OpenCL
  # Maps the cl_char type of OpenCL
  class Char < FFI::Struct
    @size = FFI.find_type(:cl_char).size * 1
    @layout = FFI::StructLayout::new([ FFI::StructLayout::Field::new( "s0", FFI.find_type(:cl_char).size * 0, FFI.find_type(:cl_char) ) ], FFI.find_type(:cl_char).size * 1, FFI.find_type(:cl_char).size * 1 )
    # Creates a new Char with members set to 0 or to the user specified values
    def initialize( s0 = 0 )
      super()
      self[:s0] = s0
    end
    # Reads the s0 member
    def s0
     return self[:s0]
    end
    # Sets the s0 member to value
    def s0=(value)
     self[:s0] = value
    end
    def to_s
      return "Char{ #{self[:s0]} }"
    end
  end
  # Maps the cl_uchar type of OpenCL
  class UChar < FFI::Struct
    @size = FFI.find_type(:cl_uchar).size * 1
    @layout = FFI::StructLayout::new([ FFI::StructLayout::Field::new( "s0", FFI.find_type(:cl_uchar).size * 0, FFI.find_type(:cl_uchar) ) ], FFI.find_type(:cl_uchar).size * 1, FFI.find_type(:cl_uchar).size * 1 )
    # Creates a new UChar with members set to 0 or to the user specified values
    def initialize( s0 = 0 )
      super()
      self[:s0] = s0
    end
    # Reads the s0 member
    def s0
     return self[:s0]
    end
    # Sets the s0 member to value
    def s0=(value)
     self[:s0] = value
    end
    def to_s
      return "UChar{ #{self[:s0]} }"
    end
  end
  # Maps the cl_short type of OpenCL
  class Short < FFI::Struct
    @size = FFI.find_type(:cl_short).size * 1
    @layout = FFI::StructLayout::new([ FFI::StructLayout::Field::new( "s0", FFI.find_type(:cl_short).size * 0, FFI.find_type(:cl_short) ) ], FFI.find_type(:cl_short).size * 1, FFI.find_type(:cl_short).size * 1 )
    # Creates a new Short with members set to 0 or to the user specified values
    def initialize( s0 = 0 )
      super()
      self[:s0] = s0
    end
    # Reads the s0 member
    def s0
     return self[:s0]
    end
    # Sets the s0 member to value
    def s0=(value)
     self[:s0] = value
    end
    def to_s
      return "Short{ #{self[:s0]} }"
    end
  end
  # Maps the cl_ushort type of OpenCL
  class UShort < FFI::Struct
    @size = FFI.find_type(:cl_ushort).size * 1
    @layout = FFI::StructLayout::new([ FFI::StructLayout::Field::new( "s0", FFI.find_type(:cl_ushort).size * 0, FFI.find_type(:cl_ushort) ) ], FFI.find_type(:cl_ushort).size * 1, FFI.find_type(:cl_ushort).size * 1 )
    # Creates a new UShort with members set to 0 or to the user specified values
    def initialize( s0 = 0 )
      super()
      self[:s0] = s0
    end
    # Reads the s0 member
    def s0
     return self[:s0]
    end
    # Sets the s0 member to value
    def s0=(value)
     self[:s0] = value
    end
    def to_s
      return "UShort{ #{self[:s0]} }"
    end
  end
  # Maps the cl_int type of OpenCL
  class Int < FFI::Struct
    @size = FFI.find_type(:cl_int).size * 1
    @layout = FFI::StructLayout::new([ FFI::StructLayout::Field::new( "s0", FFI.find_type(:cl_int).size * 0, FFI.find_type(:cl_int) ) ], FFI.find_type(:cl_int).size * 1, FFI.find_type(:cl_int).size * 1 )
    # Creates a new Int with members set to 0 or to the user specified values
    def initialize( s0 = 0 )
      super()
      self[:s0] = s0
    end
    # Reads the s0 member
    def s0
     return self[:s0]
    end
    # Sets the s0 member to value
    def s0=(value)
     self[:s0] = value
    end
    def to_s
      return "Int{ #{self[:s0]} }"
    end
  end
  # Maps the cl_uint type of OpenCL
  class UInt < FFI::Struct
    @size = FFI.find_type(:cl_uint).size * 1
    @layout = FFI::StructLayout::new([ FFI::StructLayout::Field::new( "s0", FFI.find_type(:cl_uint).size * 0, FFI.find_type(:cl_uint) ) ], FFI.find_type(:cl_uint).size * 1, FFI.find_type(:cl_uint).size * 1 )
    # Creates a new UInt with members set to 0 or to the user specified values
    def initialize( s0 = 0 )
      super()
      self[:s0] = s0
    end
    # Reads the s0 member
    def s0
     return self[:s0]
    end
    # Sets the s0 member to value
    def s0=(value)
     self[:s0] = value
    end
    def to_s
      return "UInt{ #{self[:s0]} }"
    end
  end
  # Maps the cl_long type of OpenCL
  class Long < FFI::Struct
    @size = FFI.find_type(:cl_long).size * 1
    @layout = FFI::StructLayout::new([ FFI::StructLayout::Field::new( "s0", FFI.find_type(:cl_long).size * 0, FFI.find_type(:cl_long) ) ], FFI.find_type(:cl_long).size * 1, FFI.find_type(:cl_long).size * 1 )
    # Creates a new Long with members set to 0 or to the user specified values
    def initialize( s0 = 0 )
      super()
      self[:s0] = s0
    end
    # Reads the s0 member
    def s0
     return self[:s0]
    end
    # Sets the s0 member to value
    def s0=(value)
     self[:s0] = value
    end
    def to_s
      return "Long{ #{self[:s0]} }"
    end
  end
  # Maps the cl_ulong type of OpenCL
  class ULong < FFI::Struct
    @size = FFI.find_type(:cl_ulong).size * 1
    @layout = FFI::StructLayout::new([ FFI::StructLayout::Field::new( "s0", FFI.find_type(:cl_ulong).size * 0, FFI.find_type(:cl_ulong) ) ], FFI.find_type(:cl_ulong).size * 1, FFI.find_type(:cl_ulong).size * 1 )
    # Creates a new ULong with members set to 0 or to the user specified values
    def initialize( s0 = 0 )
      super()
      self[:s0] = s0
    end
    # Reads the s0 member
    def s0
     return self[:s0]
    end
    # Sets the s0 member to value
    def s0=(value)
     self[:s0] = value
    end
    def to_s
      return "ULong{ #{self[:s0]} }"
    end
  end
  # Maps the cl_float type of OpenCL
  class Float < FFI::Struct
    @size = FFI.find_type(:cl_float).size * 1
    @layout = FFI::StructLayout::new([ FFI::StructLayout::Field::new( "s0", FFI.find_type(:cl_float).size * 0, FFI.find_type(:cl_float) ) ], FFI.find_type(:cl_float).size * 1, FFI.find_type(:cl_float).size * 1 )
    # Creates a new Float with members set to 0 or to the user specified values
    def initialize( s0 = 0.0 )
      super()
      self[:s0] = s0
    end
    # Reads the s0 member
    def s0
     return self[:s0]
    end
    # Sets the s0 member to value
    def s0=(value)
     self[:s0] = value
    end
    def to_s
      return "Float{ #{self[:s0]} }"
    end
  end
  # Maps the cl_double type of OpenCL
  class Double < FFI::Struct
    @size = FFI.find_type(:cl_double).size * 1
    @layout = FFI::StructLayout::new([ FFI::StructLayout::Field::new( "s0", FFI.find_type(:cl_double).size * 0, FFI.find_type(:cl_double) ) ], FFI.find_type(:cl_double).size * 1, FFI.find_type(:cl_double).size * 1 )
    # Creates a new Double with members set to 0 or to the user specified values
    def initialize( s0 = 0.0 )
      super()
      self[:s0] = s0
    end
    # Reads the s0 member
    def s0
     return self[:s0]
    end
    # Sets the s0 member to value
    def s0=(value)
     self[:s0] = value
    end
    def to_s
      return "Double{ #{self[:s0]} }"
    end
  end
  # Maps the cl_half type of OpenCL
  class Half < FFI::Struct
    @size = FFI.find_type(:cl_half).size * 1
    @layout = FFI::StructLayout::new([ FFI::StructLayout::Field::new( "s0", FFI.find_type(:cl_half).size * 0, FFI.find_type(:cl_half) ) ], FFI.find_type(:cl_half).size * 1, FFI.find_type(:cl_half).size * 1 )
    # Creates a new Half with members set to 0 or to the user specified values
    def initialize( s0 = 0.0 )
      super()
      self[:s0] = s0
    end
    # Reads the s0 member
    def s0
     return self[:s0]
    end
    # Sets the s0 member to value
    def s0=(value)
     self[:s0] = value
    end
    def to_s
      return "Half{ #{self[:s0]} }"
    end
  end
  # Maps the cl_char2 type of OpenCL
  class Char2 < FFI::Struct
    @size = FFI.find_type(:cl_char).size * 2
    @layout = FFI::StructLayout::new([ FFI::StructLayout::Field::new( "s0", FFI.find_type(:cl_char).size * 0, FFI.find_type(:cl_char) ), FFI::StructLayout::Field::new( "s1", FFI.find_type(:cl_char).size * 1, FFI.find_type(:cl_char) ) ], FFI.find_type(:cl_char).size * 2, FFI.find_type(:cl_char).size * 2 )
    # Creates a new Char2 with members set to 0 or to the user specified values
    def initialize( s0 = 0, s1 = 0 )
      super()
      self[:s0] = s0
      self[:s1] = s1
    end
    # Reads the s0 member
    def s0
     return self[:s0]
    end
    # Reads the s1 member
    def s1
     return self[:s1]
    end
    # Sets the s0 member to value
    def s0=(value)
     self[:s0] = value
    end
    # Sets the s1 member to value
    def s1=(value)
     self[:s1] = value
    end
    def to_s
      return "Char2{ #{self[:s0]}, #{self[:s1]} }"
    end
  end
  # Maps the cl_uchar2 type of OpenCL
  class UChar2 < FFI::Struct
    @size = FFI.find_type(:cl_uchar).size * 2
    @layout = FFI::StructLayout::new([ FFI::StructLayout::Field::new( "s0", FFI.find_type(:cl_uchar).size * 0, FFI.find_type(:cl_uchar) ), FFI::StructLayout::Field::new( "s1", FFI.find_type(:cl_uchar).size * 1, FFI.find_type(:cl_uchar) ) ], FFI.find_type(:cl_uchar).size * 2, FFI.find_type(:cl_uchar).size * 2 )
    # Creates a new UChar2 with members set to 0 or to the user specified values
    def initialize( s0 = 0, s1 = 0 )
      super()
      self[:s0] = s0
      self[:s1] = s1
    end
    # Reads the s0 member
    def s0
     return self[:s0]
    end
    # Reads the s1 member
    def s1
     return self[:s1]
    end
    # Sets the s0 member to value
    def s0=(value)
     self[:s0] = value
    end
    # Sets the s1 member to value
    def s1=(value)
     self[:s1] = value
    end
    def to_s
      return "UChar2{ #{self[:s0]}, #{self[:s1]} }"
    end
  end
  # Maps the cl_short2 type of OpenCL
  class Short2 < FFI::Struct
    @size = FFI.find_type(:cl_short).size * 2
    @layout = FFI::StructLayout::new([ FFI::StructLayout::Field::new( "s0", FFI.find_type(:cl_short).size * 0, FFI.find_type(:cl_short) ), FFI::StructLayout::Field::new( "s1", FFI.find_type(:cl_short).size * 1, FFI.find_type(:cl_short) ) ], FFI.find_type(:cl_short).size * 2, FFI.find_type(:cl_short).size * 2 )
    # Creates a new Short2 with members set to 0 or to the user specified values
    def initialize( s0 = 0, s1 = 0 )
      super()
      self[:s0] = s0
      self[:s1] = s1
    end
    # Reads the s0 member
    def s0
     return self[:s0]
    end
    # Reads the s1 member
    def s1
     return self[:s1]
    end
    # Sets the s0 member to value
    def s0=(value)
     self[:s0] = value
    end
    # Sets the s1 member to value
    def s1=(value)
     self[:s1] = value
    end
    def to_s
      return "Short2{ #{self[:s0]}, #{self[:s1]} }"
    end
  end
  # Maps the cl_ushort2 type of OpenCL
  class UShort2 < FFI::Struct
    @size = FFI.find_type(:cl_ushort).size * 2
    @layout = FFI::StructLayout::new([ FFI::StructLayout::Field::new( "s0", FFI.find_type(:cl_ushort).size * 0, FFI.find_type(:cl_ushort) ), FFI::StructLayout::Field::new( "s1", FFI.find_type(:cl_ushort).size * 1, FFI.find_type(:cl_ushort) ) ], FFI.find_type(:cl_ushort).size * 2, FFI.find_type(:cl_ushort).size * 2 )
    # Creates a new UShort2 with members set to 0 or to the user specified values
    def initialize( s0 = 0, s1 = 0 )
      super()
      self[:s0] = s0
      self[:s1] = s1
    end
    # Reads the s0 member
    def s0
     return self[:s0]
    end
    # Reads the s1 member
    def s1
     return self[:s1]
    end
    # Sets the s0 member to value
    def s0=(value)
     self[:s0] = value
    end
    # Sets the s1 member to value
    def s1=(value)
     self[:s1] = value
    end
    def to_s
      return "UShort2{ #{self[:s0]}, #{self[:s1]} }"
    end
  end
  # Maps the cl_int2 type of OpenCL
  class Int2 < FFI::Struct
    @size = FFI.find_type(:cl_int).size * 2
    @layout = FFI::StructLayout::new([ FFI::StructLayout::Field::new( "s0", FFI.find_type(:cl_int).size * 0, FFI.find_type(:cl_int) ), FFI::StructLayout::Field::new( "s1", FFI.find_type(:cl_int).size * 1, FFI.find_type(:cl_int) ) ], FFI.find_type(:cl_int).size * 2, FFI.find_type(:cl_int).size * 2 )
    # Creates a new Int2 with members set to 0 or to the user specified values
    def initialize( s0 = 0, s1 = 0 )
      super()
      self[:s0] = s0
      self[:s1] = s1
    end
    # Reads the s0 member
    def s0
     return self[:s0]
    end
    # Reads the s1 member
    def s1
     return self[:s1]
    end
    # Sets the s0 member to value
    def s0=(value)
     self[:s0] = value
    end
    # Sets the s1 member to value
    def s1=(value)
     self[:s1] = value
    end
    def to_s
      return "Int2{ #{self[:s0]}, #{self[:s1]} }"
    end
  end
  # Maps the cl_uint2 type of OpenCL
  class UInt2 < FFI::Struct
    @size = FFI.find_type(:cl_uint).size * 2
    @layout = FFI::StructLayout::new([ FFI::StructLayout::Field::new( "s0", FFI.find_type(:cl_uint).size * 0, FFI.find_type(:cl_uint) ), FFI::StructLayout::Field::new( "s1", FFI.find_type(:cl_uint).size * 1, FFI.find_type(:cl_uint) ) ], FFI.find_type(:cl_uint).size * 2, FFI.find_type(:cl_uint).size * 2 )
    # Creates a new UInt2 with members set to 0 or to the user specified values
    def initialize( s0 = 0, s1 = 0 )
      super()
      self[:s0] = s0
      self[:s1] = s1
    end
    # Reads the s0 member
    def s0
     return self[:s0]
    end
    # Reads the s1 member
    def s1
     return self[:s1]
    end
    # Sets the s0 member to value
    def s0=(value)
     self[:s0] = value
    end
    # Sets the s1 member to value
    def s1=(value)
     self[:s1] = value
    end
    def to_s
      return "UInt2{ #{self[:s0]}, #{self[:s1]} }"
    end
  end
  # Maps the cl_long2 type of OpenCL
  class Long2 < FFI::Struct
    @size = FFI.find_type(:cl_long).size * 2
    @layout = FFI::StructLayout::new([ FFI::StructLayout::Field::new( "s0", FFI.find_type(:cl_long).size * 0, FFI.find_type(:cl_long) ), FFI::StructLayout::Field::new( "s1", FFI.find_type(:cl_long).size * 1, FFI.find_type(:cl_long) ) ], FFI.find_type(:cl_long).size * 2, FFI.find_type(:cl_long).size * 2 )
    # Creates a new Long2 with members set to 0 or to the user specified values
    def initialize( s0 = 0, s1 = 0 )
      super()
      self[:s0] = s0
      self[:s1] = s1
    end
    # Reads the s0 member
    def s0
     return self[:s0]
    end
    # Reads the s1 member
    def s1
     return self[:s1]
    end
    # Sets the s0 member to value
    def s0=(value)
     self[:s0] = value
    end
    # Sets the s1 member to value
    def s1=(value)
     self[:s1] = value
    end
    def to_s
      return "Long2{ #{self[:s0]}, #{self[:s1]} }"
    end
  end
  # Maps the cl_ulong2 type of OpenCL
  class ULong2 < FFI::Struct
    @size = FFI.find_type(:cl_ulong).size * 2
    @layout = FFI::StructLayout::new([ FFI::StructLayout::Field::new( "s0", FFI.find_type(:cl_ulong).size * 0, FFI.find_type(:cl_ulong) ), FFI::StructLayout::Field::new( "s1", FFI.find_type(:cl_ulong).size * 1, FFI.find_type(:cl_ulong) ) ], FFI.find_type(:cl_ulong).size * 2, FFI.find_type(:cl_ulong).size * 2 )
    # Creates a new ULong2 with members set to 0 or to the user specified values
    def initialize( s0 = 0, s1 = 0 )
      super()
      self[:s0] = s0
      self[:s1] = s1
    end
    # Reads the s0 member
    def s0
     return self[:s0]
    end
    # Reads the s1 member
    def s1
     return self[:s1]
    end
    # Sets the s0 member to value
    def s0=(value)
     self[:s0] = value
    end
    # Sets the s1 member to value
    def s1=(value)
     self[:s1] = value
    end
    def to_s
      return "ULong2{ #{self[:s0]}, #{self[:s1]} }"
    end
  end
  # Maps the cl_float2 type of OpenCL
  class Float2 < FFI::Struct
    @size = FFI.find_type(:cl_float).size * 2
    @layout = FFI::StructLayout::new([ FFI::StructLayout::Field::new( "s0", FFI.find_type(:cl_float).size * 0, FFI.find_type(:cl_float) ), FFI::StructLayout::Field::new( "s1", FFI.find_type(:cl_float).size * 1, FFI.find_type(:cl_float) ) ], FFI.find_type(:cl_float).size * 2, FFI.find_type(:cl_float).size * 2 )
    # Creates a new Float2 with members set to 0 or to the user specified values
    def initialize( s0 = 0.0, s1 = 0.0 )
      super()
      self[:s0] = s0
      self[:s1] = s1
    end
    # Reads the s0 member
    def s0
     return self[:s0]
    end
    # Reads the s1 member
    def s1
     return self[:s1]
    end
    # Sets the s0 member to value
    def s0=(value)
     self[:s0] = value
    end
    # Sets the s1 member to value
    def s1=(value)
     self[:s1] = value
    end
    def to_s
      return "Float2{ #{self[:s0]}, #{self[:s1]} }"
    end
  end
  # Maps the cl_double2 type of OpenCL
  class Double2 < FFI::Struct
    @size = FFI.find_type(:cl_double).size * 2
    @layout = FFI::StructLayout::new([ FFI::StructLayout::Field::new( "s0", FFI.find_type(:cl_double).size * 0, FFI.find_type(:cl_double) ), FFI::StructLayout::Field::new( "s1", FFI.find_type(:cl_double).size * 1, FFI.find_type(:cl_double) ) ], FFI.find_type(:cl_double).size * 2, FFI.find_type(:cl_double).size * 2 )
    # Creates a new Double2 with members set to 0 or to the user specified values
    def initialize( s0 = 0.0, s1 = 0.0 )
      super()
      self[:s0] = s0
      self[:s1] = s1
    end
    # Reads the s0 member
    def s0
     return self[:s0]
    end
    # Reads the s1 member
    def s1
     return self[:s1]
    end
    # Sets the s0 member to value
    def s0=(value)
     self[:s0] = value
    end
    # Sets the s1 member to value
    def s1=(value)
     self[:s1] = value
    end
    def to_s
      return "Double2{ #{self[:s0]}, #{self[:s1]} }"
    end
  end
  # Maps the cl_half2 type of OpenCL
  class Half2 < FFI::Struct
    @size = FFI.find_type(:cl_half).size * 2
    @layout = FFI::StructLayout::new([ FFI::StructLayout::Field::new( "s0", FFI.find_type(:cl_half).size * 0, FFI.find_type(:cl_half) ), FFI::StructLayout::Field::new( "s1", FFI.find_type(:cl_half).size * 1, FFI.find_type(:cl_half) ) ], FFI.find_type(:cl_half).size * 2, FFI.find_type(:cl_half).size * 2 )
    # Creates a new Half2 with members set to 0 or to the user specified values
    def initialize( s0 = 0.0, s1 = 0.0 )
      super()
      self[:s0] = s0
      self[:s1] = s1
    end
    # Reads the s0 member
    def s0
     return self[:s0]
    end
    # Reads the s1 member
    def s1
     return self[:s1]
    end
    # Sets the s0 member to value
    def s0=(value)
     self[:s0] = value
    end
    # Sets the s1 member to value
    def s1=(value)
     self[:s1] = value
    end
    def to_s
      return "Half2{ #{self[:s0]}, #{self[:s1]} }"
    end
  end
  # Maps the cl_char4 type of OpenCL
  class Char4 < FFI::Struct
    @size = FFI.find_type(:cl_char).size * 4
    @layout = FFI::StructLayout::new([ FFI::StructLayout::Field::new( "s0", FFI.find_type(:cl_char).size * 0, FFI.find_type(:cl_char) ), FFI::StructLayout::Field::new( "s1", FFI.find_type(:cl_char).size * 1, FFI.find_type(:cl_char) ), FFI::StructLayout::Field::new( "s2", FFI.find_type(:cl_char).size * 2, FFI.find_type(:cl_char) ), FFI::StructLayout::Field::new( "s3", FFI.find_type(:cl_char).size * 3, FFI.find_type(:cl_char) ) ], FFI.find_type(:cl_char).size * 4, FFI.find_type(:cl_char).size * 4 )
    # Creates a new Char4 with members set to 0 or to the user specified values
    def initialize( s0 = 0, s1 = 0, s2 = 0, s3 = 0 )
      super()
      self[:s0] = s0
      self[:s1] = s1
      self[:s2] = s2
      self[:s3] = s3
    end
    # Reads the s0 member
    def s0
     return self[:s0]
    end
    # Reads the s1 member
    def s1
     return self[:s1]
    end
    # Reads the s2 member
    def s2
     return self[:s2]
    end
    # Reads the s3 member
    def s3
     return self[:s3]
    end
    # Sets the s0 member to value
    def s0=(value)
     self[:s0] = value
    end
    # Sets the s1 member to value
    def s1=(value)
     self[:s1] = value
    end
    # Sets the s2 member to value
    def s2=(value)
     self[:s2] = value
    end
    # Sets the s3 member to value
    def s3=(value)
     self[:s3] = value
    end
    def to_s
      return "Char4{ #{self[:s0]}, #{self[:s1]}, #{self[:s2]}, #{self[:s3]} }"
    end
  end
  # Maps the cl_uchar4 type of OpenCL
  class UChar4 < FFI::Struct
    @size = FFI.find_type(:cl_uchar).size * 4
    @layout = FFI::StructLayout::new([ FFI::StructLayout::Field::new( "s0", FFI.find_type(:cl_uchar).size * 0, FFI.find_type(:cl_uchar) ), FFI::StructLayout::Field::new( "s1", FFI.find_type(:cl_uchar).size * 1, FFI.find_type(:cl_uchar) ), FFI::StructLayout::Field::new( "s2", FFI.find_type(:cl_uchar).size * 2, FFI.find_type(:cl_uchar) ), FFI::StructLayout::Field::new( "s3", FFI.find_type(:cl_uchar).size * 3, FFI.find_type(:cl_uchar) ) ], FFI.find_type(:cl_uchar).size * 4, FFI.find_type(:cl_uchar).size * 4 )
    # Creates a new UChar4 with members set to 0 or to the user specified values
    def initialize( s0 = 0, s1 = 0, s2 = 0, s3 = 0 )
      super()
      self[:s0] = s0
      self[:s1] = s1
      self[:s2] = s2
      self[:s3] = s3
    end
    # Reads the s0 member
    def s0
     return self[:s0]
    end
    # Reads the s1 member
    def s1
     return self[:s1]
    end
    # Reads the s2 member
    def s2
     return self[:s2]
    end
    # Reads the s3 member
    def s3
     return self[:s3]
    end
    # Sets the s0 member to value
    def s0=(value)
     self[:s0] = value
    end
    # Sets the s1 member to value
    def s1=(value)
     self[:s1] = value
    end
    # Sets the s2 member to value
    def s2=(value)
     self[:s2] = value
    end
    # Sets the s3 member to value
    def s3=(value)
     self[:s3] = value
    end
    def to_s
      return "UChar4{ #{self[:s0]}, #{self[:s1]}, #{self[:s2]}, #{self[:s3]} }"
    end
  end
  # Maps the cl_short4 type of OpenCL
  class Short4 < FFI::Struct
    @size = FFI.find_type(:cl_short).size * 4
    @layout = FFI::StructLayout::new([ FFI::StructLayout::Field::new( "s0", FFI.find_type(:cl_short).size * 0, FFI.find_type(:cl_short) ), FFI::StructLayout::Field::new( "s1", FFI.find_type(:cl_short).size * 1, FFI.find_type(:cl_short) ), FFI::StructLayout::Field::new( "s2", FFI.find_type(:cl_short).size * 2, FFI.find_type(:cl_short) ), FFI::StructLayout::Field::new( "s3", FFI.find_type(:cl_short).size * 3, FFI.find_type(:cl_short) ) ], FFI.find_type(:cl_short).size * 4, FFI.find_type(:cl_short).size * 4 )
    # Creates a new Short4 with members set to 0 or to the user specified values
    def initialize( s0 = 0, s1 = 0, s2 = 0, s3 = 0 )
      super()
      self[:s0] = s0
      self[:s1] = s1
      self[:s2] = s2
      self[:s3] = s3
    end
    # Reads the s0 member
    def s0
     return self[:s0]
    end
    # Reads the s1 member
    def s1
     return self[:s1]
    end
    # Reads the s2 member
    def s2
     return self[:s2]
    end
    # Reads the s3 member
    def s3
     return self[:s3]
    end
    # Sets the s0 member to value
    def s0=(value)
     self[:s0] = value
    end
    # Sets the s1 member to value
    def s1=(value)
     self[:s1] = value
    end
    # Sets the s2 member to value
    def s2=(value)
     self[:s2] = value
    end
    # Sets the s3 member to value
    def s3=(value)
     self[:s3] = value
    end
    def to_s
      return "Short4{ #{self[:s0]}, #{self[:s1]}, #{self[:s2]}, #{self[:s3]} }"
    end
  end
  # Maps the cl_ushort4 type of OpenCL
  class UShort4 < FFI::Struct
    @size = FFI.find_type(:cl_ushort).size * 4
    @layout = FFI::StructLayout::new([ FFI::StructLayout::Field::new( "s0", FFI.find_type(:cl_ushort).size * 0, FFI.find_type(:cl_ushort) ), FFI::StructLayout::Field::new( "s1", FFI.find_type(:cl_ushort).size * 1, FFI.find_type(:cl_ushort) ), FFI::StructLayout::Field::new( "s2", FFI.find_type(:cl_ushort).size * 2, FFI.find_type(:cl_ushort) ), FFI::StructLayout::Field::new( "s3", FFI.find_type(:cl_ushort).size * 3, FFI.find_type(:cl_ushort) ) ], FFI.find_type(:cl_ushort).size * 4, FFI.find_type(:cl_ushort).size * 4 )
    # Creates a new UShort4 with members set to 0 or to the user specified values
    def initialize( s0 = 0, s1 = 0, s2 = 0, s3 = 0 )
      super()
      self[:s0] = s0
      self[:s1] = s1
      self[:s2] = s2
      self[:s3] = s3
    end
    # Reads the s0 member
    def s0
     return self[:s0]
    end
    # Reads the s1 member
    def s1
     return self[:s1]
    end
    # Reads the s2 member
    def s2
     return self[:s2]
    end
    # Reads the s3 member
    def s3
     return self[:s3]
    end
    # Sets the s0 member to value
    def s0=(value)
     self[:s0] = value
    end
    # Sets the s1 member to value
    def s1=(value)
     self[:s1] = value
    end
    # Sets the s2 member to value
    def s2=(value)
     self[:s2] = value
    end
    # Sets the s3 member to value
    def s3=(value)
     self[:s3] = value
    end
    def to_s
      return "UShort4{ #{self[:s0]}, #{self[:s1]}, #{self[:s2]}, #{self[:s3]} }"
    end
  end
  # Maps the cl_int4 type of OpenCL
  class Int4 < FFI::Struct
    @size = FFI.find_type(:cl_int).size * 4
    @layout = FFI::StructLayout::new([ FFI::StructLayout::Field::new( "s0", FFI.find_type(:cl_int).size * 0, FFI.find_type(:cl_int) ), FFI::StructLayout::Field::new( "s1", FFI.find_type(:cl_int).size * 1, FFI.find_type(:cl_int) ), FFI::StructLayout::Field::new( "s2", FFI.find_type(:cl_int).size * 2, FFI.find_type(:cl_int) ), FFI::StructLayout::Field::new( "s3", FFI.find_type(:cl_int).size * 3, FFI.find_type(:cl_int) ) ], FFI.find_type(:cl_int).size * 4, FFI.find_type(:cl_int).size * 4 )
    # Creates a new Int4 with members set to 0 or to the user specified values
    def initialize( s0 = 0, s1 = 0, s2 = 0, s3 = 0 )
      super()
      self[:s0] = s0
      self[:s1] = s1
      self[:s2] = s2
      self[:s3] = s3
    end
    # Reads the s0 member
    def s0
     return self[:s0]
    end
    # Reads the s1 member
    def s1
     return self[:s1]
    end
    # Reads the s2 member
    def s2
     return self[:s2]
    end
    # Reads the s3 member
    def s3
     return self[:s3]
    end
    # Sets the s0 member to value
    def s0=(value)
     self[:s0] = value
    end
    # Sets the s1 member to value
    def s1=(value)
     self[:s1] = value
    end
    # Sets the s2 member to value
    def s2=(value)
     self[:s2] = value
    end
    # Sets the s3 member to value
    def s3=(value)
     self[:s3] = value
    end
    def to_s
      return "Int4{ #{self[:s0]}, #{self[:s1]}, #{self[:s2]}, #{self[:s3]} }"
    end
  end
  # Maps the cl_uint4 type of OpenCL
  class UInt4 < FFI::Struct
    @size = FFI.find_type(:cl_uint).size * 4
    @layout = FFI::StructLayout::new([ FFI::StructLayout::Field::new( "s0", FFI.find_type(:cl_uint).size * 0, FFI.find_type(:cl_uint) ), FFI::StructLayout::Field::new( "s1", FFI.find_type(:cl_uint).size * 1, FFI.find_type(:cl_uint) ), FFI::StructLayout::Field::new( "s2", FFI.find_type(:cl_uint).size * 2, FFI.find_type(:cl_uint) ), FFI::StructLayout::Field::new( "s3", FFI.find_type(:cl_uint).size * 3, FFI.find_type(:cl_uint) ) ], FFI.find_type(:cl_uint).size * 4, FFI.find_type(:cl_uint).size * 4 )
    # Creates a new UInt4 with members set to 0 or to the user specified values
    def initialize( s0 = 0, s1 = 0, s2 = 0, s3 = 0 )
      super()
      self[:s0] = s0
      self[:s1] = s1
      self[:s2] = s2
      self[:s3] = s3
    end
    # Reads the s0 member
    def s0
     return self[:s0]
    end
    # Reads the s1 member
    def s1
     return self[:s1]
    end
    # Reads the s2 member
    def s2
     return self[:s2]
    end
    # Reads the s3 member
    def s3
     return self[:s3]
    end
    # Sets the s0 member to value
    def s0=(value)
     self[:s0] = value
    end
    # Sets the s1 member to value
    def s1=(value)
     self[:s1] = value
    end
    # Sets the s2 member to value
    def s2=(value)
     self[:s2] = value
    end
    # Sets the s3 member to value
    def s3=(value)
     self[:s3] = value
    end
    def to_s
      return "UInt4{ #{self[:s0]}, #{self[:s1]}, #{self[:s2]}, #{self[:s3]} }"
    end
  end
  # Maps the cl_long4 type of OpenCL
  class Long4 < FFI::Struct
    @size = FFI.find_type(:cl_long).size * 4
    @layout = FFI::StructLayout::new([ FFI::StructLayout::Field::new( "s0", FFI.find_type(:cl_long).size * 0, FFI.find_type(:cl_long) ), FFI::StructLayout::Field::new( "s1", FFI.find_type(:cl_long).size * 1, FFI.find_type(:cl_long) ), FFI::StructLayout::Field::new( "s2", FFI.find_type(:cl_long).size * 2, FFI.find_type(:cl_long) ), FFI::StructLayout::Field::new( "s3", FFI.find_type(:cl_long).size * 3, FFI.find_type(:cl_long) ) ], FFI.find_type(:cl_long).size * 4, FFI.find_type(:cl_long).size * 4 )
    # Creates a new Long4 with members set to 0 or to the user specified values
    def initialize( s0 = 0, s1 = 0, s2 = 0, s3 = 0 )
      super()
      self[:s0] = s0
      self[:s1] = s1
      self[:s2] = s2
      self[:s3] = s3
    end
    # Reads the s0 member
    def s0
     return self[:s0]
    end
    # Reads the s1 member
    def s1
     return self[:s1]
    end
    # Reads the s2 member
    def s2
     return self[:s2]
    end
    # Reads the s3 member
    def s3
     return self[:s3]
    end
    # Sets the s0 member to value
    def s0=(value)
     self[:s0] = value
    end
    # Sets the s1 member to value
    def s1=(value)
     self[:s1] = value
    end
    # Sets the s2 member to value
    def s2=(value)
     self[:s2] = value
    end
    # Sets the s3 member to value
    def s3=(value)
     self[:s3] = value
    end
    def to_s
      return "Long4{ #{self[:s0]}, #{self[:s1]}, #{self[:s2]}, #{self[:s3]} }"
    end
  end
  # Maps the cl_ulong4 type of OpenCL
  class ULong4 < FFI::Struct
    @size = FFI.find_type(:cl_ulong).size * 4
    @layout = FFI::StructLayout::new([ FFI::StructLayout::Field::new( "s0", FFI.find_type(:cl_ulong).size * 0, FFI.find_type(:cl_ulong) ), FFI::StructLayout::Field::new( "s1", FFI.find_type(:cl_ulong).size * 1, FFI.find_type(:cl_ulong) ), FFI::StructLayout::Field::new( "s2", FFI.find_type(:cl_ulong).size * 2, FFI.find_type(:cl_ulong) ), FFI::StructLayout::Field::new( "s3", FFI.find_type(:cl_ulong).size * 3, FFI.find_type(:cl_ulong) ) ], FFI.find_type(:cl_ulong).size * 4, FFI.find_type(:cl_ulong).size * 4 )
    # Creates a new ULong4 with members set to 0 or to the user specified values
    def initialize( s0 = 0, s1 = 0, s2 = 0, s3 = 0 )
      super()
      self[:s0] = s0
      self[:s1] = s1
      self[:s2] = s2
      self[:s3] = s3
    end
    # Reads the s0 member
    def s0
     return self[:s0]
    end
    # Reads the s1 member
    def s1
     return self[:s1]
    end
    # Reads the s2 member
    def s2
     return self[:s2]
    end
    # Reads the s3 member
    def s3
     return self[:s3]
    end
    # Sets the s0 member to value
    def s0=(value)
     self[:s0] = value
    end
    # Sets the s1 member to value
    def s1=(value)
     self[:s1] = value
    end
    # Sets the s2 member to value
    def s2=(value)
     self[:s2] = value
    end
    # Sets the s3 member to value
    def s3=(value)
     self[:s3] = value
    end
    def to_s
      return "ULong4{ #{self[:s0]}, #{self[:s1]}, #{self[:s2]}, #{self[:s3]} }"
    end
  end
  # Maps the cl_float4 type of OpenCL
  class Float4 < FFI::Struct
    @size = FFI.find_type(:cl_float).size * 4
    @layout = FFI::StructLayout::new([ FFI::StructLayout::Field::new( "s0", FFI.find_type(:cl_float).size * 0, FFI.find_type(:cl_float) ), FFI::StructLayout::Field::new( "s1", FFI.find_type(:cl_float).size * 1, FFI.find_type(:cl_float) ), FFI::StructLayout::Field::new( "s2", FFI.find_type(:cl_float).size * 2, FFI.find_type(:cl_float) ), FFI::StructLayout::Field::new( "s3", FFI.find_type(:cl_float).size * 3, FFI.find_type(:cl_float) ) ], FFI.find_type(:cl_float).size * 4, FFI.find_type(:cl_float).size * 4 )
    # Creates a new Float4 with members set to 0 or to the user specified values
    def initialize( s0 = 0.0, s1 = 0.0, s2 = 0.0, s3 = 0.0 )
      super()
      self[:s0] = s0
      self[:s1] = s1
      self[:s2] = s2
      self[:s3] = s3
    end
    # Reads the s0 member
    def s0
     return self[:s0]
    end
    # Reads the s1 member
    def s1
     return self[:s1]
    end
    # Reads the s2 member
    def s2
     return self[:s2]
    end
    # Reads the s3 member
    def s3
     return self[:s3]
    end
    # Sets the s0 member to value
    def s0=(value)
     self[:s0] = value
    end
    # Sets the s1 member to value
    def s1=(value)
     self[:s1] = value
    end
    # Sets the s2 member to value
    def s2=(value)
     self[:s2] = value
    end
    # Sets the s3 member to value
    def s3=(value)
     self[:s3] = value
    end
    def to_s
      return "Float4{ #{self[:s0]}, #{self[:s1]}, #{self[:s2]}, #{self[:s3]} }"
    end
  end
  # Maps the cl_double4 type of OpenCL
  class Double4 < FFI::Struct
    @size = FFI.find_type(:cl_double).size * 4
    @layout = FFI::StructLayout::new([ FFI::StructLayout::Field::new( "s0", FFI.find_type(:cl_double).size * 0, FFI.find_type(:cl_double) ), FFI::StructLayout::Field::new( "s1", FFI.find_type(:cl_double).size * 1, FFI.find_type(:cl_double) ), FFI::StructLayout::Field::new( "s2", FFI.find_type(:cl_double).size * 2, FFI.find_type(:cl_double) ), FFI::StructLayout::Field::new( "s3", FFI.find_type(:cl_double).size * 3, FFI.find_type(:cl_double) ) ], FFI.find_type(:cl_double).size * 4, FFI.find_type(:cl_double).size * 4 )
    # Creates a new Double4 with members set to 0 or to the user specified values
    def initialize( s0 = 0.0, s1 = 0.0, s2 = 0.0, s3 = 0.0 )
      super()
      self[:s0] = s0
      self[:s1] = s1
      self[:s2] = s2
      self[:s3] = s3
    end
    # Reads the s0 member
    def s0
     return self[:s0]
    end
    # Reads the s1 member
    def s1
     return self[:s1]
    end
    # Reads the s2 member
    def s2
     return self[:s2]
    end
    # Reads the s3 member
    def s3
     return self[:s3]
    end
    # Sets the s0 member to value
    def s0=(value)
     self[:s0] = value
    end
    # Sets the s1 member to value
    def s1=(value)
     self[:s1] = value
    end
    # Sets the s2 member to value
    def s2=(value)
     self[:s2] = value
    end
    # Sets the s3 member to value
    def s3=(value)
     self[:s3] = value
    end
    def to_s
      return "Double4{ #{self[:s0]}, #{self[:s1]}, #{self[:s2]}, #{self[:s3]} }"
    end
  end
  # Maps the cl_half4 type of OpenCL
  class Half4 < FFI::Struct
    @size = FFI.find_type(:cl_half).size * 4
    @layout = FFI::StructLayout::new([ FFI::StructLayout::Field::new( "s0", FFI.find_type(:cl_half).size * 0, FFI.find_type(:cl_half) ), FFI::StructLayout::Field::new( "s1", FFI.find_type(:cl_half).size * 1, FFI.find_type(:cl_half) ), FFI::StructLayout::Field::new( "s2", FFI.find_type(:cl_half).size * 2, FFI.find_type(:cl_half) ), FFI::StructLayout::Field::new( "s3", FFI.find_type(:cl_half).size * 3, FFI.find_type(:cl_half) ) ], FFI.find_type(:cl_half).size * 4, FFI.find_type(:cl_half).size * 4 )
    # Creates a new Half4 with members set to 0 or to the user specified values
    def initialize( s0 = 0.0, s1 = 0.0, s2 = 0.0, s3 = 0.0 )
      super()
      self[:s0] = s0
      self[:s1] = s1
      self[:s2] = s2
      self[:s3] = s3
    end
    # Reads the s0 member
    def s0
     return self[:s0]
    end
    # Reads the s1 member
    def s1
     return self[:s1]
    end
    # Reads the s2 member
    def s2
     return self[:s2]
    end
    # Reads the s3 member
    def s3
     return self[:s3]
    end
    # Sets the s0 member to value
    def s0=(value)
     self[:s0] = value
    end
    # Sets the s1 member to value
    def s1=(value)
     self[:s1] = value
    end
    # Sets the s2 member to value
    def s2=(value)
     self[:s2] = value
    end
    # Sets the s3 member to value
    def s3=(value)
     self[:s3] = value
    end
    def to_s
      return "Half4{ #{self[:s0]}, #{self[:s1]}, #{self[:s2]}, #{self[:s3]} }"
    end
  end
  # Maps the cl_char8 type of OpenCL
  class Char8 < FFI::Struct
    @size = FFI.find_type(:cl_char).size * 8
    @layout = FFI::StructLayout::new([ FFI::StructLayout::Field::new( "s0", FFI.find_type(:cl_char).size * 0, FFI.find_type(:cl_char) ), FFI::StructLayout::Field::new( "s1", FFI.find_type(:cl_char).size * 1, FFI.find_type(:cl_char) ), FFI::StructLayout::Field::new( "s2", FFI.find_type(:cl_char).size * 2, FFI.find_type(:cl_char) ), FFI::StructLayout::Field::new( "s3", FFI.find_type(:cl_char).size * 3, FFI.find_type(:cl_char) ), FFI::StructLayout::Field::new( "s4", FFI.find_type(:cl_char).size * 4, FFI.find_type(:cl_char) ), FFI::StructLayout::Field::new( "s5", FFI.find_type(:cl_char).size * 5, FFI.find_type(:cl_char) ), FFI::StructLayout::Field::new( "s6", FFI.find_type(:cl_char).size * 6, FFI.find_type(:cl_char) ), FFI::StructLayout::Field::new( "s7", FFI.find_type(:cl_char).size * 7, FFI.find_type(:cl_char) ) ], FFI.find_type(:cl_char).size * 8, FFI.find_type(:cl_char).size * 8 )
    # Creates a new Char8 with members set to 0 or to the user specified values
    def initialize( s0 = 0, s1 = 0, s2 = 0, s3 = 0, s4 = 0, s5 = 0, s6 = 0, s7 = 0 )
      super()
      self[:s0] = s0
      self[:s1] = s1
      self[:s2] = s2
      self[:s3] = s3
      self[:s4] = s4
      self[:s5] = s5
      self[:s6] = s6
      self[:s7] = s7
    end
    # Reads the s0 member
    def s0
     return self[:s0]
    end
    # Reads the s1 member
    def s1
     return self[:s1]
    end
    # Reads the s2 member
    def s2
     return self[:s2]
    end
    # Reads the s3 member
    def s3
     return self[:s3]
    end
    # Reads the s4 member
    def s4
     return self[:s4]
    end
    # Reads the s5 member
    def s5
     return self[:s5]
    end
    # Reads the s6 member
    def s6
     return self[:s6]
    end
    # Reads the s7 member
    def s7
     return self[:s7]
    end
    # Sets the s0 member to value
    def s0=(value)
     self[:s0] = value
    end
    # Sets the s1 member to value
    def s1=(value)
     self[:s1] = value
    end
    # Sets the s2 member to value
    def s2=(value)
     self[:s2] = value
    end
    # Sets the s3 member to value
    def s3=(value)
     self[:s3] = value
    end
    # Sets the s4 member to value
    def s4=(value)
     self[:s4] = value
    end
    # Sets the s5 member to value
    def s5=(value)
     self[:s5] = value
    end
    # Sets the s6 member to value
    def s6=(value)
     self[:s6] = value
    end
    # Sets the s7 member to value
    def s7=(value)
     self[:s7] = value
    end
    def to_s
      return "Char8{ #{self[:s0]}, #{self[:s1]}, #{self[:s2]}, #{self[:s3]}, #{self[:s4]}, #{self[:s5]}, #{self[:s6]}, #{self[:s7]} }"
    end
  end
  # Maps the cl_uchar8 type of OpenCL
  class UChar8 < FFI::Struct
    @size = FFI.find_type(:cl_uchar).size * 8
    @layout = FFI::StructLayout::new([ FFI::StructLayout::Field::new( "s0", FFI.find_type(:cl_uchar).size * 0, FFI.find_type(:cl_uchar) ), FFI::StructLayout::Field::new( "s1", FFI.find_type(:cl_uchar).size * 1, FFI.find_type(:cl_uchar) ), FFI::StructLayout::Field::new( "s2", FFI.find_type(:cl_uchar).size * 2, FFI.find_type(:cl_uchar) ), FFI::StructLayout::Field::new( "s3", FFI.find_type(:cl_uchar).size * 3, FFI.find_type(:cl_uchar) ), FFI::StructLayout::Field::new( "s4", FFI.find_type(:cl_uchar).size * 4, FFI.find_type(:cl_uchar) ), FFI::StructLayout::Field::new( "s5", FFI.find_type(:cl_uchar).size * 5, FFI.find_type(:cl_uchar) ), FFI::StructLayout::Field::new( "s6", FFI.find_type(:cl_uchar).size * 6, FFI.find_type(:cl_uchar) ), FFI::StructLayout::Field::new( "s7", FFI.find_type(:cl_uchar).size * 7, FFI.find_type(:cl_uchar) ) ], FFI.find_type(:cl_uchar).size * 8, FFI.find_type(:cl_uchar).size * 8 )
    # Creates a new UChar8 with members set to 0 or to the user specified values
    def initialize( s0 = 0, s1 = 0, s2 = 0, s3 = 0, s4 = 0, s5 = 0, s6 = 0, s7 = 0 )
      super()
      self[:s0] = s0
      self[:s1] = s1
      self[:s2] = s2
      self[:s3] = s3
      self[:s4] = s4
      self[:s5] = s5
      self[:s6] = s6
      self[:s7] = s7
    end
    # Reads the s0 member
    def s0
     return self[:s0]
    end
    # Reads the s1 member
    def s1
     return self[:s1]
    end
    # Reads the s2 member
    def s2
     return self[:s2]
    end
    # Reads the s3 member
    def s3
     return self[:s3]
    end
    # Reads the s4 member
    def s4
     return self[:s4]
    end
    # Reads the s5 member
    def s5
     return self[:s5]
    end
    # Reads the s6 member
    def s6
     return self[:s6]
    end
    # Reads the s7 member
    def s7
     return self[:s7]
    end
    # Sets the s0 member to value
    def s0=(value)
     self[:s0] = value
    end
    # Sets the s1 member to value
    def s1=(value)
     self[:s1] = value
    end
    # Sets the s2 member to value
    def s2=(value)
     self[:s2] = value
    end
    # Sets the s3 member to value
    def s3=(value)
     self[:s3] = value
    end
    # Sets the s4 member to value
    def s4=(value)
     self[:s4] = value
    end
    # Sets the s5 member to value
    def s5=(value)
     self[:s5] = value
    end
    # Sets the s6 member to value
    def s6=(value)
     self[:s6] = value
    end
    # Sets the s7 member to value
    def s7=(value)
     self[:s7] = value
    end
    def to_s
      return "UChar8{ #{self[:s0]}, #{self[:s1]}, #{self[:s2]}, #{self[:s3]}, #{self[:s4]}, #{self[:s5]}, #{self[:s6]}, #{self[:s7]} }"
    end
  end
  # Maps the cl_short8 type of OpenCL
  class Short8 < FFI::Struct
    @size = FFI.find_type(:cl_short).size * 8
    @layout = FFI::StructLayout::new([ FFI::StructLayout::Field::new( "s0", FFI.find_type(:cl_short).size * 0, FFI.find_type(:cl_short) ), FFI::StructLayout::Field::new( "s1", FFI.find_type(:cl_short).size * 1, FFI.find_type(:cl_short) ), FFI::StructLayout::Field::new( "s2", FFI.find_type(:cl_short).size * 2, FFI.find_type(:cl_short) ), FFI::StructLayout::Field::new( "s3", FFI.find_type(:cl_short).size * 3, FFI.find_type(:cl_short) ), FFI::StructLayout::Field::new( "s4", FFI.find_type(:cl_short).size * 4, FFI.find_type(:cl_short) ), FFI::StructLayout::Field::new( "s5", FFI.find_type(:cl_short).size * 5, FFI.find_type(:cl_short) ), FFI::StructLayout::Field::new( "s6", FFI.find_type(:cl_short).size * 6, FFI.find_type(:cl_short) ), FFI::StructLayout::Field::new( "s7", FFI.find_type(:cl_short).size * 7, FFI.find_type(:cl_short) ) ], FFI.find_type(:cl_short).size * 8, FFI.find_type(:cl_short).size * 8 )
    # Creates a new Short8 with members set to 0 or to the user specified values
    def initialize( s0 = 0, s1 = 0, s2 = 0, s3 = 0, s4 = 0, s5 = 0, s6 = 0, s7 = 0 )
      super()
      self[:s0] = s0
      self[:s1] = s1
      self[:s2] = s2
      self[:s3] = s3
      self[:s4] = s4
      self[:s5] = s5
      self[:s6] = s6
      self[:s7] = s7
    end
    # Reads the s0 member
    def s0
     return self[:s0]
    end
    # Reads the s1 member
    def s1
     return self[:s1]
    end
    # Reads the s2 member
    def s2
     return self[:s2]
    end
    # Reads the s3 member
    def s3
     return self[:s3]
    end
    # Reads the s4 member
    def s4
     return self[:s4]
    end
    # Reads the s5 member
    def s5
     return self[:s5]
    end
    # Reads the s6 member
    def s6
     return self[:s6]
    end
    # Reads the s7 member
    def s7
     return self[:s7]
    end
    # Sets the s0 member to value
    def s0=(value)
     self[:s0] = value
    end
    # Sets the s1 member to value
    def s1=(value)
     self[:s1] = value
    end
    # Sets the s2 member to value
    def s2=(value)
     self[:s2] = value
    end
    # Sets the s3 member to value
    def s3=(value)
     self[:s3] = value
    end
    # Sets the s4 member to value
    def s4=(value)
     self[:s4] = value
    end
    # Sets the s5 member to value
    def s5=(value)
     self[:s5] = value
    end
    # Sets the s6 member to value
    def s6=(value)
     self[:s6] = value
    end
    # Sets the s7 member to value
    def s7=(value)
     self[:s7] = value
    end
    def to_s
      return "Short8{ #{self[:s0]}, #{self[:s1]}, #{self[:s2]}, #{self[:s3]}, #{self[:s4]}, #{self[:s5]}, #{self[:s6]}, #{self[:s7]} }"
    end
  end
  # Maps the cl_ushort8 type of OpenCL
  class UShort8 < FFI::Struct
    @size = FFI.find_type(:cl_ushort).size * 8
    @layout = FFI::StructLayout::new([ FFI::StructLayout::Field::new( "s0", FFI.find_type(:cl_ushort).size * 0, FFI.find_type(:cl_ushort) ), FFI::StructLayout::Field::new( "s1", FFI.find_type(:cl_ushort).size * 1, FFI.find_type(:cl_ushort) ), FFI::StructLayout::Field::new( "s2", FFI.find_type(:cl_ushort).size * 2, FFI.find_type(:cl_ushort) ), FFI::StructLayout::Field::new( "s3", FFI.find_type(:cl_ushort).size * 3, FFI.find_type(:cl_ushort) ), FFI::StructLayout::Field::new( "s4", FFI.find_type(:cl_ushort).size * 4, FFI.find_type(:cl_ushort) ), FFI::StructLayout::Field::new( "s5", FFI.find_type(:cl_ushort).size * 5, FFI.find_type(:cl_ushort) ), FFI::StructLayout::Field::new( "s6", FFI.find_type(:cl_ushort).size * 6, FFI.find_type(:cl_ushort) ), FFI::StructLayout::Field::new( "s7", FFI.find_type(:cl_ushort).size * 7, FFI.find_type(:cl_ushort) ) ], FFI.find_type(:cl_ushort).size * 8, FFI.find_type(:cl_ushort).size * 8 )
    # Creates a new UShort8 with members set to 0 or to the user specified values
    def initialize( s0 = 0, s1 = 0, s2 = 0, s3 = 0, s4 = 0, s5 = 0, s6 = 0, s7 = 0 )
      super()
      self[:s0] = s0
      self[:s1] = s1
      self[:s2] = s2
      self[:s3] = s3
      self[:s4] = s4
      self[:s5] = s5
      self[:s6] = s6
      self[:s7] = s7
    end
    # Reads the s0 member
    def s0
     return self[:s0]
    end
    # Reads the s1 member
    def s1
     return self[:s1]
    end
    # Reads the s2 member
    def s2
     return self[:s2]
    end
    # Reads the s3 member
    def s3
     return self[:s3]
    end
    # Reads the s4 member
    def s4
     return self[:s4]
    end
    # Reads the s5 member
    def s5
     return self[:s5]
    end
    # Reads the s6 member
    def s6
     return self[:s6]
    end
    # Reads the s7 member
    def s7
     return self[:s7]
    end
    # Sets the s0 member to value
    def s0=(value)
     self[:s0] = value
    end
    # Sets the s1 member to value
    def s1=(value)
     self[:s1] = value
    end
    # Sets the s2 member to value
    def s2=(value)
     self[:s2] = value
    end
    # Sets the s3 member to value
    def s3=(value)
     self[:s3] = value
    end
    # Sets the s4 member to value
    def s4=(value)
     self[:s4] = value
    end
    # Sets the s5 member to value
    def s5=(value)
     self[:s5] = value
    end
    # Sets the s6 member to value
    def s6=(value)
     self[:s6] = value
    end
    # Sets the s7 member to value
    def s7=(value)
     self[:s7] = value
    end
    def to_s
      return "UShort8{ #{self[:s0]}, #{self[:s1]}, #{self[:s2]}, #{self[:s3]}, #{self[:s4]}, #{self[:s5]}, #{self[:s6]}, #{self[:s7]} }"
    end
  end
  # Maps the cl_int8 type of OpenCL
  class Int8 < FFI::Struct
    @size = FFI.find_type(:cl_int).size * 8
    @layout = FFI::StructLayout::new([ FFI::StructLayout::Field::new( "s0", FFI.find_type(:cl_int).size * 0, FFI.find_type(:cl_int) ), FFI::StructLayout::Field::new( "s1", FFI.find_type(:cl_int).size * 1, FFI.find_type(:cl_int) ), FFI::StructLayout::Field::new( "s2", FFI.find_type(:cl_int).size * 2, FFI.find_type(:cl_int) ), FFI::StructLayout::Field::new( "s3", FFI.find_type(:cl_int).size * 3, FFI.find_type(:cl_int) ), FFI::StructLayout::Field::new( "s4", FFI.find_type(:cl_int).size * 4, FFI.find_type(:cl_int) ), FFI::StructLayout::Field::new( "s5", FFI.find_type(:cl_int).size * 5, FFI.find_type(:cl_int) ), FFI::StructLayout::Field::new( "s6", FFI.find_type(:cl_int).size * 6, FFI.find_type(:cl_int) ), FFI::StructLayout::Field::new( "s7", FFI.find_type(:cl_int).size * 7, FFI.find_type(:cl_int) ) ], FFI.find_type(:cl_int).size * 8, FFI.find_type(:cl_int).size * 8 )
    # Creates a new Int8 with members set to 0 or to the user specified values
    def initialize( s0 = 0, s1 = 0, s2 = 0, s3 = 0, s4 = 0, s5 = 0, s6 = 0, s7 = 0 )
      super()
      self[:s0] = s0
      self[:s1] = s1
      self[:s2] = s2
      self[:s3] = s3
      self[:s4] = s4
      self[:s5] = s5
      self[:s6] = s6
      self[:s7] = s7
    end
    # Reads the s0 member
    def s0
     return self[:s0]
    end
    # Reads the s1 member
    def s1
     return self[:s1]
    end
    # Reads the s2 member
    def s2
     return self[:s2]
    end
    # Reads the s3 member
    def s3
     return self[:s3]
    end
    # Reads the s4 member
    def s4
     return self[:s4]
    end
    # Reads the s5 member
    def s5
     return self[:s5]
    end
    # Reads the s6 member
    def s6
     return self[:s6]
    end
    # Reads the s7 member
    def s7
     return self[:s7]
    end
    # Sets the s0 member to value
    def s0=(value)
     self[:s0] = value
    end
    # Sets the s1 member to value
    def s1=(value)
     self[:s1] = value
    end
    # Sets the s2 member to value
    def s2=(value)
     self[:s2] = value
    end
    # Sets the s3 member to value
    def s3=(value)
     self[:s3] = value
    end
    # Sets the s4 member to value
    def s4=(value)
     self[:s4] = value
    end
    # Sets the s5 member to value
    def s5=(value)
     self[:s5] = value
    end
    # Sets the s6 member to value
    def s6=(value)
     self[:s6] = value
    end
    # Sets the s7 member to value
    def s7=(value)
     self[:s7] = value
    end
    def to_s
      return "Int8{ #{self[:s0]}, #{self[:s1]}, #{self[:s2]}, #{self[:s3]}, #{self[:s4]}, #{self[:s5]}, #{self[:s6]}, #{self[:s7]} }"
    end
  end
  # Maps the cl_uint8 type of OpenCL
  class UInt8 < FFI::Struct
    @size = FFI.find_type(:cl_uint).size * 8
    @layout = FFI::StructLayout::new([ FFI::StructLayout::Field::new( "s0", FFI.find_type(:cl_uint).size * 0, FFI.find_type(:cl_uint) ), FFI::StructLayout::Field::new( "s1", FFI.find_type(:cl_uint).size * 1, FFI.find_type(:cl_uint) ), FFI::StructLayout::Field::new( "s2", FFI.find_type(:cl_uint).size * 2, FFI.find_type(:cl_uint) ), FFI::StructLayout::Field::new( "s3", FFI.find_type(:cl_uint).size * 3, FFI.find_type(:cl_uint) ), FFI::StructLayout::Field::new( "s4", FFI.find_type(:cl_uint).size * 4, FFI.find_type(:cl_uint) ), FFI::StructLayout::Field::new( "s5", FFI.find_type(:cl_uint).size * 5, FFI.find_type(:cl_uint) ), FFI::StructLayout::Field::new( "s6", FFI.find_type(:cl_uint).size * 6, FFI.find_type(:cl_uint) ), FFI::StructLayout::Field::new( "s7", FFI.find_type(:cl_uint).size * 7, FFI.find_type(:cl_uint) ) ], FFI.find_type(:cl_uint).size * 8, FFI.find_type(:cl_uint).size * 8 )
    # Creates a new UInt8 with members set to 0 or to the user specified values
    def initialize( s0 = 0, s1 = 0, s2 = 0, s3 = 0, s4 = 0, s5 = 0, s6 = 0, s7 = 0 )
      super()
      self[:s0] = s0
      self[:s1] = s1
      self[:s2] = s2
      self[:s3] = s3
      self[:s4] = s4
      self[:s5] = s5
      self[:s6] = s6
      self[:s7] = s7
    end
    # Reads the s0 member
    def s0
     return self[:s0]
    end
    # Reads the s1 member
    def s1
     return self[:s1]
    end
    # Reads the s2 member
    def s2
     return self[:s2]
    end
    # Reads the s3 member
    def s3
     return self[:s3]
    end
    # Reads the s4 member
    def s4
     return self[:s4]
    end
    # Reads the s5 member
    def s5
     return self[:s5]
    end
    # Reads the s6 member
    def s6
     return self[:s6]
    end
    # Reads the s7 member
    def s7
     return self[:s7]
    end
    # Sets the s0 member to value
    def s0=(value)
     self[:s0] = value
    end
    # Sets the s1 member to value
    def s1=(value)
     self[:s1] = value
    end
    # Sets the s2 member to value
    def s2=(value)
     self[:s2] = value
    end
    # Sets the s3 member to value
    def s3=(value)
     self[:s3] = value
    end
    # Sets the s4 member to value
    def s4=(value)
     self[:s4] = value
    end
    # Sets the s5 member to value
    def s5=(value)
     self[:s5] = value
    end
    # Sets the s6 member to value
    def s6=(value)
     self[:s6] = value
    end
    # Sets the s7 member to value
    def s7=(value)
     self[:s7] = value
    end
    def to_s
      return "UInt8{ #{self[:s0]}, #{self[:s1]}, #{self[:s2]}, #{self[:s3]}, #{self[:s4]}, #{self[:s5]}, #{self[:s6]}, #{self[:s7]} }"
    end
  end
  # Maps the cl_long8 type of OpenCL
  class Long8 < FFI::Struct
    @size = FFI.find_type(:cl_long).size * 8
    @layout = FFI::StructLayout::new([ FFI::StructLayout::Field::new( "s0", FFI.find_type(:cl_long).size * 0, FFI.find_type(:cl_long) ), FFI::StructLayout::Field::new( "s1", FFI.find_type(:cl_long).size * 1, FFI.find_type(:cl_long) ), FFI::StructLayout::Field::new( "s2", FFI.find_type(:cl_long).size * 2, FFI.find_type(:cl_long) ), FFI::StructLayout::Field::new( "s3", FFI.find_type(:cl_long).size * 3, FFI.find_type(:cl_long) ), FFI::StructLayout::Field::new( "s4", FFI.find_type(:cl_long).size * 4, FFI.find_type(:cl_long) ), FFI::StructLayout::Field::new( "s5", FFI.find_type(:cl_long).size * 5, FFI.find_type(:cl_long) ), FFI::StructLayout::Field::new( "s6", FFI.find_type(:cl_long).size * 6, FFI.find_type(:cl_long) ), FFI::StructLayout::Field::new( "s7", FFI.find_type(:cl_long).size * 7, FFI.find_type(:cl_long) ) ], FFI.find_type(:cl_long).size * 8, FFI.find_type(:cl_long).size * 8 )
    # Creates a new Long8 with members set to 0 or to the user specified values
    def initialize( s0 = 0, s1 = 0, s2 = 0, s3 = 0, s4 = 0, s5 = 0, s6 = 0, s7 = 0 )
      super()
      self[:s0] = s0
      self[:s1] = s1
      self[:s2] = s2
      self[:s3] = s3
      self[:s4] = s4
      self[:s5] = s5
      self[:s6] = s6
      self[:s7] = s7
    end
    # Reads the s0 member
    def s0
     return self[:s0]
    end
    # Reads the s1 member
    def s1
     return self[:s1]
    end
    # Reads the s2 member
    def s2
     return self[:s2]
    end
    # Reads the s3 member
    def s3
     return self[:s3]
    end
    # Reads the s4 member
    def s4
     return self[:s4]
    end
    # Reads the s5 member
    def s5
     return self[:s5]
    end
    # Reads the s6 member
    def s6
     return self[:s6]
    end
    # Reads the s7 member
    def s7
     return self[:s7]
    end
    # Sets the s0 member to value
    def s0=(value)
     self[:s0] = value
    end
    # Sets the s1 member to value
    def s1=(value)
     self[:s1] = value
    end
    # Sets the s2 member to value
    def s2=(value)
     self[:s2] = value
    end
    # Sets the s3 member to value
    def s3=(value)
     self[:s3] = value
    end
    # Sets the s4 member to value
    def s4=(value)
     self[:s4] = value
    end
    # Sets the s5 member to value
    def s5=(value)
     self[:s5] = value
    end
    # Sets the s6 member to value
    def s6=(value)
     self[:s6] = value
    end
    # Sets the s7 member to value
    def s7=(value)
     self[:s7] = value
    end
    def to_s
      return "Long8{ #{self[:s0]}, #{self[:s1]}, #{self[:s2]}, #{self[:s3]}, #{self[:s4]}, #{self[:s5]}, #{self[:s6]}, #{self[:s7]} }"
    end
  end
  # Maps the cl_ulong8 type of OpenCL
  class ULong8 < FFI::Struct
    @size = FFI.find_type(:cl_ulong).size * 8
    @layout = FFI::StructLayout::new([ FFI::StructLayout::Field::new( "s0", FFI.find_type(:cl_ulong).size * 0, FFI.find_type(:cl_ulong) ), FFI::StructLayout::Field::new( "s1", FFI.find_type(:cl_ulong).size * 1, FFI.find_type(:cl_ulong) ), FFI::StructLayout::Field::new( "s2", FFI.find_type(:cl_ulong).size * 2, FFI.find_type(:cl_ulong) ), FFI::StructLayout::Field::new( "s3", FFI.find_type(:cl_ulong).size * 3, FFI.find_type(:cl_ulong) ), FFI::StructLayout::Field::new( "s4", FFI.find_type(:cl_ulong).size * 4, FFI.find_type(:cl_ulong) ), FFI::StructLayout::Field::new( "s5", FFI.find_type(:cl_ulong).size * 5, FFI.find_type(:cl_ulong) ), FFI::StructLayout::Field::new( "s6", FFI.find_type(:cl_ulong).size * 6, FFI.find_type(:cl_ulong) ), FFI::StructLayout::Field::new( "s7", FFI.find_type(:cl_ulong).size * 7, FFI.find_type(:cl_ulong) ) ], FFI.find_type(:cl_ulong).size * 8, FFI.find_type(:cl_ulong).size * 8 )
    # Creates a new ULong8 with members set to 0 or to the user specified values
    def initialize( s0 = 0, s1 = 0, s2 = 0, s3 = 0, s4 = 0, s5 = 0, s6 = 0, s7 = 0 )
      super()
      self[:s0] = s0
      self[:s1] = s1
      self[:s2] = s2
      self[:s3] = s3
      self[:s4] = s4
      self[:s5] = s5
      self[:s6] = s6
      self[:s7] = s7
    end
    # Reads the s0 member
    def s0
     return self[:s0]
    end
    # Reads the s1 member
    def s1
     return self[:s1]
    end
    # Reads the s2 member
    def s2
     return self[:s2]
    end
    # Reads the s3 member
    def s3
     return self[:s3]
    end
    # Reads the s4 member
    def s4
     return self[:s4]
    end
    # Reads the s5 member
    def s5
     return self[:s5]
    end
    # Reads the s6 member
    def s6
     return self[:s6]
    end
    # Reads the s7 member
    def s7
     return self[:s7]
    end
    # Sets the s0 member to value
    def s0=(value)
     self[:s0] = value
    end
    # Sets the s1 member to value
    def s1=(value)
     self[:s1] = value
    end
    # Sets the s2 member to value
    def s2=(value)
     self[:s2] = value
    end
    # Sets the s3 member to value
    def s3=(value)
     self[:s3] = value
    end
    # Sets the s4 member to value
    def s4=(value)
     self[:s4] = value
    end
    # Sets the s5 member to value
    def s5=(value)
     self[:s5] = value
    end
    # Sets the s6 member to value
    def s6=(value)
     self[:s6] = value
    end
    # Sets the s7 member to value
    def s7=(value)
     self[:s7] = value
    end
    def to_s
      return "ULong8{ #{self[:s0]}, #{self[:s1]}, #{self[:s2]}, #{self[:s3]}, #{self[:s4]}, #{self[:s5]}, #{self[:s6]}, #{self[:s7]} }"
    end
  end
  # Maps the cl_float8 type of OpenCL
  class Float8 < FFI::Struct
    @size = FFI.find_type(:cl_float).size * 8
    @layout = FFI::StructLayout::new([ FFI::StructLayout::Field::new( "s0", FFI.find_type(:cl_float).size * 0, FFI.find_type(:cl_float) ), FFI::StructLayout::Field::new( "s1", FFI.find_type(:cl_float).size * 1, FFI.find_type(:cl_float) ), FFI::StructLayout::Field::new( "s2", FFI.find_type(:cl_float).size * 2, FFI.find_type(:cl_float) ), FFI::StructLayout::Field::new( "s3", FFI.find_type(:cl_float).size * 3, FFI.find_type(:cl_float) ), FFI::StructLayout::Field::new( "s4", FFI.find_type(:cl_float).size * 4, FFI.find_type(:cl_float) ), FFI::StructLayout::Field::new( "s5", FFI.find_type(:cl_float).size * 5, FFI.find_type(:cl_float) ), FFI::StructLayout::Field::new( "s6", FFI.find_type(:cl_float).size * 6, FFI.find_type(:cl_float) ), FFI::StructLayout::Field::new( "s7", FFI.find_type(:cl_float).size * 7, FFI.find_type(:cl_float) ) ], FFI.find_type(:cl_float).size * 8, FFI.find_type(:cl_float).size * 8 )
    # Creates a new Float8 with members set to 0 or to the user specified values
    def initialize( s0 = 0.0, s1 = 0.0, s2 = 0.0, s3 = 0.0, s4 = 0.0, s5 = 0.0, s6 = 0.0, s7 = 0.0 )
      super()
      self[:s0] = s0
      self[:s1] = s1
      self[:s2] = s2
      self[:s3] = s3
      self[:s4] = s4
      self[:s5] = s5
      self[:s6] = s6
      self[:s7] = s7
    end
    # Reads the s0 member
    def s0
     return self[:s0]
    end
    # Reads the s1 member
    def s1
     return self[:s1]
    end
    # Reads the s2 member
    def s2
     return self[:s2]
    end
    # Reads the s3 member
    def s3
     return self[:s3]
    end
    # Reads the s4 member
    def s4
     return self[:s4]
    end
    # Reads the s5 member
    def s5
     return self[:s5]
    end
    # Reads the s6 member
    def s6
     return self[:s6]
    end
    # Reads the s7 member
    def s7
     return self[:s7]
    end
    # Sets the s0 member to value
    def s0=(value)
     self[:s0] = value
    end
    # Sets the s1 member to value
    def s1=(value)
     self[:s1] = value
    end
    # Sets the s2 member to value
    def s2=(value)
     self[:s2] = value
    end
    # Sets the s3 member to value
    def s3=(value)
     self[:s3] = value
    end
    # Sets the s4 member to value
    def s4=(value)
     self[:s4] = value
    end
    # Sets the s5 member to value
    def s5=(value)
     self[:s5] = value
    end
    # Sets the s6 member to value
    def s6=(value)
     self[:s6] = value
    end
    # Sets the s7 member to value
    def s7=(value)
     self[:s7] = value
    end
    def to_s
      return "Float8{ #{self[:s0]}, #{self[:s1]}, #{self[:s2]}, #{self[:s3]}, #{self[:s4]}, #{self[:s5]}, #{self[:s6]}, #{self[:s7]} }"
    end
  end
  # Maps the cl_double8 type of OpenCL
  class Double8 < FFI::Struct
    @size = FFI.find_type(:cl_double).size * 8
    @layout = FFI::StructLayout::new([ FFI::StructLayout::Field::new( "s0", FFI.find_type(:cl_double).size * 0, FFI.find_type(:cl_double) ), FFI::StructLayout::Field::new( "s1", FFI.find_type(:cl_double).size * 1, FFI.find_type(:cl_double) ), FFI::StructLayout::Field::new( "s2", FFI.find_type(:cl_double).size * 2, FFI.find_type(:cl_double) ), FFI::StructLayout::Field::new( "s3", FFI.find_type(:cl_double).size * 3, FFI.find_type(:cl_double) ), FFI::StructLayout::Field::new( "s4", FFI.find_type(:cl_double).size * 4, FFI.find_type(:cl_double) ), FFI::StructLayout::Field::new( "s5", FFI.find_type(:cl_double).size * 5, FFI.find_type(:cl_double) ), FFI::StructLayout::Field::new( "s6", FFI.find_type(:cl_double).size * 6, FFI.find_type(:cl_double) ), FFI::StructLayout::Field::new( "s7", FFI.find_type(:cl_double).size * 7, FFI.find_type(:cl_double) ) ], FFI.find_type(:cl_double).size * 8, FFI.find_type(:cl_double).size * 8 )
    # Creates a new Double8 with members set to 0 or to the user specified values
    def initialize( s0 = 0.0, s1 = 0.0, s2 = 0.0, s3 = 0.0, s4 = 0.0, s5 = 0.0, s6 = 0.0, s7 = 0.0 )
      super()
      self[:s0] = s0
      self[:s1] = s1
      self[:s2] = s2
      self[:s3] = s3
      self[:s4] = s4
      self[:s5] = s5
      self[:s6] = s6
      self[:s7] = s7
    end
    # Reads the s0 member
    def s0
     return self[:s0]
    end
    # Reads the s1 member
    def s1
     return self[:s1]
    end
    # Reads the s2 member
    def s2
     return self[:s2]
    end
    # Reads the s3 member
    def s3
     return self[:s3]
    end
    # Reads the s4 member
    def s4
     return self[:s4]
    end
    # Reads the s5 member
    def s5
     return self[:s5]
    end
    # Reads the s6 member
    def s6
     return self[:s6]
    end
    # Reads the s7 member
    def s7
     return self[:s7]
    end
    # Sets the s0 member to value
    def s0=(value)
     self[:s0] = value
    end
    # Sets the s1 member to value
    def s1=(value)
     self[:s1] = value
    end
    # Sets the s2 member to value
    def s2=(value)
     self[:s2] = value
    end
    # Sets the s3 member to value
    def s3=(value)
     self[:s3] = value
    end
    # Sets the s4 member to value
    def s4=(value)
     self[:s4] = value
    end
    # Sets the s5 member to value
    def s5=(value)
     self[:s5] = value
    end
    # Sets the s6 member to value
    def s6=(value)
     self[:s6] = value
    end
    # Sets the s7 member to value
    def s7=(value)
     self[:s7] = value
    end
    def to_s
      return "Double8{ #{self[:s0]}, #{self[:s1]}, #{self[:s2]}, #{self[:s3]}, #{self[:s4]}, #{self[:s5]}, #{self[:s6]}, #{self[:s7]} }"
    end
  end
  # Maps the cl_half8 type of OpenCL
  class Half8 < FFI::Struct
    @size = FFI.find_type(:cl_half).size * 8
    @layout = FFI::StructLayout::new([ FFI::StructLayout::Field::new( "s0", FFI.find_type(:cl_half).size * 0, FFI.find_type(:cl_half) ), FFI::StructLayout::Field::new( "s1", FFI.find_type(:cl_half).size * 1, FFI.find_type(:cl_half) ), FFI::StructLayout::Field::new( "s2", FFI.find_type(:cl_half).size * 2, FFI.find_type(:cl_half) ), FFI::StructLayout::Field::new( "s3", FFI.find_type(:cl_half).size * 3, FFI.find_type(:cl_half) ), FFI::StructLayout::Field::new( "s4", FFI.find_type(:cl_half).size * 4, FFI.find_type(:cl_half) ), FFI::StructLayout::Field::new( "s5", FFI.find_type(:cl_half).size * 5, FFI.find_type(:cl_half) ), FFI::StructLayout::Field::new( "s6", FFI.find_type(:cl_half).size * 6, FFI.find_type(:cl_half) ), FFI::StructLayout::Field::new( "s7", FFI.find_type(:cl_half).size * 7, FFI.find_type(:cl_half) ) ], FFI.find_type(:cl_half).size * 8, FFI.find_type(:cl_half).size * 8 )
    # Creates a new Half8 with members set to 0 or to the user specified values
    def initialize( s0 = 0.0, s1 = 0.0, s2 = 0.0, s3 = 0.0, s4 = 0.0, s5 = 0.0, s6 = 0.0, s7 = 0.0 )
      super()
      self[:s0] = s0
      self[:s1] = s1
      self[:s2] = s2
      self[:s3] = s3
      self[:s4] = s4
      self[:s5] = s5
      self[:s6] = s6
      self[:s7] = s7
    end
    # Reads the s0 member
    def s0
     return self[:s0]
    end
    # Reads the s1 member
    def s1
     return self[:s1]
    end
    # Reads the s2 member
    def s2
     return self[:s2]
    end
    # Reads the s3 member
    def s3
     return self[:s3]
    end
    # Reads the s4 member
    def s4
     return self[:s4]
    end
    # Reads the s5 member
    def s5
     return self[:s5]
    end
    # Reads the s6 member
    def s6
     return self[:s6]
    end
    # Reads the s7 member
    def s7
     return self[:s7]
    end
    # Sets the s0 member to value
    def s0=(value)
     self[:s0] = value
    end
    # Sets the s1 member to value
    def s1=(value)
     self[:s1] = value
    end
    # Sets the s2 member to value
    def s2=(value)
     self[:s2] = value
    end
    # Sets the s3 member to value
    def s3=(value)
     self[:s3] = value
    end
    # Sets the s4 member to value
    def s4=(value)
     self[:s4] = value
    end
    # Sets the s5 member to value
    def s5=(value)
     self[:s5] = value
    end
    # Sets the s6 member to value
    def s6=(value)
     self[:s6] = value
    end
    # Sets the s7 member to value
    def s7=(value)
     self[:s7] = value
    end
    def to_s
      return "Half8{ #{self[:s0]}, #{self[:s1]}, #{self[:s2]}, #{self[:s3]}, #{self[:s4]}, #{self[:s5]}, #{self[:s6]}, #{self[:s7]} }"
    end
  end
  # Maps the cl_char16 type of OpenCL
  class Char16 < FFI::Struct
    @size = FFI.find_type(:cl_char).size * 16
    @layout = FFI::StructLayout::new([ FFI::StructLayout::Field::new( "s0", FFI.find_type(:cl_char).size * 0, FFI.find_type(:cl_char) ), FFI::StructLayout::Field::new( "s1", FFI.find_type(:cl_char).size * 1, FFI.find_type(:cl_char) ), FFI::StructLayout::Field::new( "s2", FFI.find_type(:cl_char).size * 2, FFI.find_type(:cl_char) ), FFI::StructLayout::Field::new( "s3", FFI.find_type(:cl_char).size * 3, FFI.find_type(:cl_char) ), FFI::StructLayout::Field::new( "s4", FFI.find_type(:cl_char).size * 4, FFI.find_type(:cl_char) ), FFI::StructLayout::Field::new( "s5", FFI.find_type(:cl_char).size * 5, FFI.find_type(:cl_char) ), FFI::StructLayout::Field::new( "s6", FFI.find_type(:cl_char).size * 6, FFI.find_type(:cl_char) ), FFI::StructLayout::Field::new( "s7", FFI.find_type(:cl_char).size * 7, FFI.find_type(:cl_char) ), FFI::StructLayout::Field::new( "s8", FFI.find_type(:cl_char).size * 8, FFI.find_type(:cl_char) ), FFI::StructLayout::Field::new( "s9", FFI.find_type(:cl_char).size * 9, FFI.find_type(:cl_char) ), FFI::StructLayout::Field::new( "sa", FFI.find_type(:cl_char).size * 10, FFI.find_type(:cl_char) ), FFI::StructLayout::Field::new( "sb", FFI.find_type(:cl_char).size * 11, FFI.find_type(:cl_char) ), FFI::StructLayout::Field::new( "sc", FFI.find_type(:cl_char).size * 12, FFI.find_type(:cl_char) ), FFI::StructLayout::Field::new( "sd", FFI.find_type(:cl_char).size * 13, FFI.find_type(:cl_char) ), FFI::StructLayout::Field::new( "se", FFI.find_type(:cl_char).size * 14, FFI.find_type(:cl_char) ), FFI::StructLayout::Field::new( "sf", FFI.find_type(:cl_char).size * 15, FFI.find_type(:cl_char) ) ], FFI.find_type(:cl_char).size * 16, FFI.find_type(:cl_char).size * 16 )
    # Creates a new Char16 with members set to 0 or to the user specified values
    def initialize( s0 = 0, s1 = 0, s2 = 0, s3 = 0, s4 = 0, s5 = 0, s6 = 0, s7 = 0, s8 = 0, s9 = 0, sa = 0, sb = 0, sc = 0, sd = 0, se = 0, sf = 0 )
      super()
      self[:s0] = s0
      self[:s1] = s1
      self[:s2] = s2
      self[:s3] = s3
      self[:s4] = s4
      self[:s5] = s5
      self[:s6] = s6
      self[:s7] = s7
      self[:s8] = s8
      self[:s9] = s9
      self[:sa] = sa
      self[:sb] = sb
      self[:sc] = sc
      self[:sd] = sd
      self[:se] = se
      self[:sf] = sf
    end
    # Reads the s0 member
    def s0
     return self[:s0]
    end
    # Reads the s1 member
    def s1
     return self[:s1]
    end
    # Reads the s2 member
    def s2
     return self[:s2]
    end
    # Reads the s3 member
    def s3
     return self[:s3]
    end
    # Reads the s4 member
    def s4
     return self[:s4]
    end
    # Reads the s5 member
    def s5
     return self[:s5]
    end
    # Reads the s6 member
    def s6
     return self[:s6]
    end
    # Reads the s7 member
    def s7
     return self[:s7]
    end
    # Reads the s8 member
    def s8
     return self[:s8]
    end
    # Reads the s9 member
    def s9
     return self[:s9]
    end
    # Reads the sa member
    def sa
     return self[:sa]
    end
    # Reads the sb member
    def sb
     return self[:sb]
    end
    # Reads the sc member
    def sc
     return self[:sc]
    end
    # Reads the sd member
    def sd
     return self[:sd]
    end
    # Reads the se member
    def se
     return self[:se]
    end
    # Reads the sf member
    def sf
     return self[:sf]
    end
    # Sets the s0 member to value
    def s0=(value)
     self[:s0] = value
    end
    # Sets the s1 member to value
    def s1=(value)
     self[:s1] = value
    end
    # Sets the s2 member to value
    def s2=(value)
     self[:s2] = value
    end
    # Sets the s3 member to value
    def s3=(value)
     self[:s3] = value
    end
    # Sets the s4 member to value
    def s4=(value)
     self[:s4] = value
    end
    # Sets the s5 member to value
    def s5=(value)
     self[:s5] = value
    end
    # Sets the s6 member to value
    def s6=(value)
     self[:s6] = value
    end
    # Sets the s7 member to value
    def s7=(value)
     self[:s7] = value
    end
    # Sets the s8 member to value
    def s8=(value)
     self[:s8] = value
    end
    # Sets the s9 member to value
    def s9=(value)
     self[:s9] = value
    end
    # Sets the sa member to value
    def sa=(value)
     self[:sa] = value
    end
    # Sets the sb member to value
    def sb=(value)
     self[:sb] = value
    end
    # Sets the sc member to value
    def sc=(value)
     self[:sc] = value
    end
    # Sets the sd member to value
    def sd=(value)
     self[:sd] = value
    end
    # Sets the se member to value
    def se=(value)
     self[:se] = value
    end
    # Sets the sf member to value
    def sf=(value)
     self[:sf] = value
    end
    def to_s
      return "Char16{ #{self[:s0]}, #{self[:s1]}, #{self[:s2]}, #{self[:s3]}, #{self[:s4]}, #{self[:s5]}, #{self[:s6]}, #{self[:s7]}, #{self[:s8]}, #{self[:s9]}, #{self[:sa]}, #{self[:sb]}, #{self[:sc]}, #{self[:sd]}, #{self[:se]}, #{self[:sf]} }"
    end
  end
  # Maps the cl_uchar16 type of OpenCL
  class UChar16 < FFI::Struct
    @size = FFI.find_type(:cl_uchar).size * 16
    @layout = FFI::StructLayout::new([ FFI::StructLayout::Field::new( "s0", FFI.find_type(:cl_uchar).size * 0, FFI.find_type(:cl_uchar) ), FFI::StructLayout::Field::new( "s1", FFI.find_type(:cl_uchar).size * 1, FFI.find_type(:cl_uchar) ), FFI::StructLayout::Field::new( "s2", FFI.find_type(:cl_uchar).size * 2, FFI.find_type(:cl_uchar) ), FFI::StructLayout::Field::new( "s3", FFI.find_type(:cl_uchar).size * 3, FFI.find_type(:cl_uchar) ), FFI::StructLayout::Field::new( "s4", FFI.find_type(:cl_uchar).size * 4, FFI.find_type(:cl_uchar) ), FFI::StructLayout::Field::new( "s5", FFI.find_type(:cl_uchar).size * 5, FFI.find_type(:cl_uchar) ), FFI::StructLayout::Field::new( "s6", FFI.find_type(:cl_uchar).size * 6, FFI.find_type(:cl_uchar) ), FFI::StructLayout::Field::new( "s7", FFI.find_type(:cl_uchar).size * 7, FFI.find_type(:cl_uchar) ), FFI::StructLayout::Field::new( "s8", FFI.find_type(:cl_uchar).size * 8, FFI.find_type(:cl_uchar) ), FFI::StructLayout::Field::new( "s9", FFI.find_type(:cl_uchar).size * 9, FFI.find_type(:cl_uchar) ), FFI::StructLayout::Field::new( "sa", FFI.find_type(:cl_uchar).size * 10, FFI.find_type(:cl_uchar) ), FFI::StructLayout::Field::new( "sb", FFI.find_type(:cl_uchar).size * 11, FFI.find_type(:cl_uchar) ), FFI::StructLayout::Field::new( "sc", FFI.find_type(:cl_uchar).size * 12, FFI.find_type(:cl_uchar) ), FFI::StructLayout::Field::new( "sd", FFI.find_type(:cl_uchar).size * 13, FFI.find_type(:cl_uchar) ), FFI::StructLayout::Field::new( "se", FFI.find_type(:cl_uchar).size * 14, FFI.find_type(:cl_uchar) ), FFI::StructLayout::Field::new( "sf", FFI.find_type(:cl_uchar).size * 15, FFI.find_type(:cl_uchar) ) ], FFI.find_type(:cl_uchar).size * 16, FFI.find_type(:cl_uchar).size * 16 )
    # Creates a new UChar16 with members set to 0 or to the user specified values
    def initialize( s0 = 0, s1 = 0, s2 = 0, s3 = 0, s4 = 0, s5 = 0, s6 = 0, s7 = 0, s8 = 0, s9 = 0, sa = 0, sb = 0, sc = 0, sd = 0, se = 0, sf = 0 )
      super()
      self[:s0] = s0
      self[:s1] = s1
      self[:s2] = s2
      self[:s3] = s3
      self[:s4] = s4
      self[:s5] = s5
      self[:s6] = s6
      self[:s7] = s7
      self[:s8] = s8
      self[:s9] = s9
      self[:sa] = sa
      self[:sb] = sb
      self[:sc] = sc
      self[:sd] = sd
      self[:se] = se
      self[:sf] = sf
    end
    # Reads the s0 member
    def s0
     return self[:s0]
    end
    # Reads the s1 member
    def s1
     return self[:s1]
    end
    # Reads the s2 member
    def s2
     return self[:s2]
    end
    # Reads the s3 member
    def s3
     return self[:s3]
    end
    # Reads the s4 member
    def s4
     return self[:s4]
    end
    # Reads the s5 member
    def s5
     return self[:s5]
    end
    # Reads the s6 member
    def s6
     return self[:s6]
    end
    # Reads the s7 member
    def s7
     return self[:s7]
    end
    # Reads the s8 member
    def s8
     return self[:s8]
    end
    # Reads the s9 member
    def s9
     return self[:s9]
    end
    # Reads the sa member
    def sa
     return self[:sa]
    end
    # Reads the sb member
    def sb
     return self[:sb]
    end
    # Reads the sc member
    def sc
     return self[:sc]
    end
    # Reads the sd member
    def sd
     return self[:sd]
    end
    # Reads the se member
    def se
     return self[:se]
    end
    # Reads the sf member
    def sf
     return self[:sf]
    end
    # Sets the s0 member to value
    def s0=(value)
     self[:s0] = value
    end
    # Sets the s1 member to value
    def s1=(value)
     self[:s1] = value
    end
    # Sets the s2 member to value
    def s2=(value)
     self[:s2] = value
    end
    # Sets the s3 member to value
    def s3=(value)
     self[:s3] = value
    end
    # Sets the s4 member to value
    def s4=(value)
     self[:s4] = value
    end
    # Sets the s5 member to value
    def s5=(value)
     self[:s5] = value
    end
    # Sets the s6 member to value
    def s6=(value)
     self[:s6] = value
    end
    # Sets the s7 member to value
    def s7=(value)
     self[:s7] = value
    end
    # Sets the s8 member to value
    def s8=(value)
     self[:s8] = value
    end
    # Sets the s9 member to value
    def s9=(value)
     self[:s9] = value
    end
    # Sets the sa member to value
    def sa=(value)
     self[:sa] = value
    end
    # Sets the sb member to value
    def sb=(value)
     self[:sb] = value
    end
    # Sets the sc member to value
    def sc=(value)
     self[:sc] = value
    end
    # Sets the sd member to value
    def sd=(value)
     self[:sd] = value
    end
    # Sets the se member to value
    def se=(value)
     self[:se] = value
    end
    # Sets the sf member to value
    def sf=(value)
     self[:sf] = value
    end
    def to_s
      return "UChar16{ #{self[:s0]}, #{self[:s1]}, #{self[:s2]}, #{self[:s3]}, #{self[:s4]}, #{self[:s5]}, #{self[:s6]}, #{self[:s7]}, #{self[:s8]}, #{self[:s9]}, #{self[:sa]}, #{self[:sb]}, #{self[:sc]}, #{self[:sd]}, #{self[:se]}, #{self[:sf]} }"
    end
  end
  # Maps the cl_short16 type of OpenCL
  class Short16 < FFI::Struct
    @size = FFI.find_type(:cl_short).size * 16
    @layout = FFI::StructLayout::new([ FFI::StructLayout::Field::new( "s0", FFI.find_type(:cl_short).size * 0, FFI.find_type(:cl_short) ), FFI::StructLayout::Field::new( "s1", FFI.find_type(:cl_short).size * 1, FFI.find_type(:cl_short) ), FFI::StructLayout::Field::new( "s2", FFI.find_type(:cl_short).size * 2, FFI.find_type(:cl_short) ), FFI::StructLayout::Field::new( "s3", FFI.find_type(:cl_short).size * 3, FFI.find_type(:cl_short) ), FFI::StructLayout::Field::new( "s4", FFI.find_type(:cl_short).size * 4, FFI.find_type(:cl_short) ), FFI::StructLayout::Field::new( "s5", FFI.find_type(:cl_short).size * 5, FFI.find_type(:cl_short) ), FFI::StructLayout::Field::new( "s6", FFI.find_type(:cl_short).size * 6, FFI.find_type(:cl_short) ), FFI::StructLayout::Field::new( "s7", FFI.find_type(:cl_short).size * 7, FFI.find_type(:cl_short) ), FFI::StructLayout::Field::new( "s8", FFI.find_type(:cl_short).size * 8, FFI.find_type(:cl_short) ), FFI::StructLayout::Field::new( "s9", FFI.find_type(:cl_short).size * 9, FFI.find_type(:cl_short) ), FFI::StructLayout::Field::new( "sa", FFI.find_type(:cl_short).size * 10, FFI.find_type(:cl_short) ), FFI::StructLayout::Field::new( "sb", FFI.find_type(:cl_short).size * 11, FFI.find_type(:cl_short) ), FFI::StructLayout::Field::new( "sc", FFI.find_type(:cl_short).size * 12, FFI.find_type(:cl_short) ), FFI::StructLayout::Field::new( "sd", FFI.find_type(:cl_short).size * 13, FFI.find_type(:cl_short) ), FFI::StructLayout::Field::new( "se", FFI.find_type(:cl_short).size * 14, FFI.find_type(:cl_short) ), FFI::StructLayout::Field::new( "sf", FFI.find_type(:cl_short).size * 15, FFI.find_type(:cl_short) ) ], FFI.find_type(:cl_short).size * 16, FFI.find_type(:cl_short).size * 16 )
    # Creates a new Short16 with members set to 0 or to the user specified values
    def initialize( s0 = 0, s1 = 0, s2 = 0, s3 = 0, s4 = 0, s5 = 0, s6 = 0, s7 = 0, s8 = 0, s9 = 0, sa = 0, sb = 0, sc = 0, sd = 0, se = 0, sf = 0 )
      super()
      self[:s0] = s0
      self[:s1] = s1
      self[:s2] = s2
      self[:s3] = s3
      self[:s4] = s4
      self[:s5] = s5
      self[:s6] = s6
      self[:s7] = s7
      self[:s8] = s8
      self[:s9] = s9
      self[:sa] = sa
      self[:sb] = sb
      self[:sc] = sc
      self[:sd] = sd
      self[:se] = se
      self[:sf] = sf
    end
    # Reads the s0 member
    def s0
     return self[:s0]
    end
    # Reads the s1 member
    def s1
     return self[:s1]
    end
    # Reads the s2 member
    def s2
     return self[:s2]
    end
    # Reads the s3 member
    def s3
     return self[:s3]
    end
    # Reads the s4 member
    def s4
     return self[:s4]
    end
    # Reads the s5 member
    def s5
     return self[:s5]
    end
    # Reads the s6 member
    def s6
     return self[:s6]
    end
    # Reads the s7 member
    def s7
     return self[:s7]
    end
    # Reads the s8 member
    def s8
     return self[:s8]
    end
    # Reads the s9 member
    def s9
     return self[:s9]
    end
    # Reads the sa member
    def sa
     return self[:sa]
    end
    # Reads the sb member
    def sb
     return self[:sb]
    end
    # Reads the sc member
    def sc
     return self[:sc]
    end
    # Reads the sd member
    def sd
     return self[:sd]
    end
    # Reads the se member
    def se
     return self[:se]
    end
    # Reads the sf member
    def sf
     return self[:sf]
    end
    # Sets the s0 member to value
    def s0=(value)
     self[:s0] = value
    end
    # Sets the s1 member to value
    def s1=(value)
     self[:s1] = value
    end
    # Sets the s2 member to value
    def s2=(value)
     self[:s2] = value
    end
    # Sets the s3 member to value
    def s3=(value)
     self[:s3] = value
    end
    # Sets the s4 member to value
    def s4=(value)
     self[:s4] = value
    end
    # Sets the s5 member to value
    def s5=(value)
     self[:s5] = value
    end
    # Sets the s6 member to value
    def s6=(value)
     self[:s6] = value
    end
    # Sets the s7 member to value
    def s7=(value)
     self[:s7] = value
    end
    # Sets the s8 member to value
    def s8=(value)
     self[:s8] = value
    end
    # Sets the s9 member to value
    def s9=(value)
     self[:s9] = value
    end
    # Sets the sa member to value
    def sa=(value)
     self[:sa] = value
    end
    # Sets the sb member to value
    def sb=(value)
     self[:sb] = value
    end
    # Sets the sc member to value
    def sc=(value)
     self[:sc] = value
    end
    # Sets the sd member to value
    def sd=(value)
     self[:sd] = value
    end
    # Sets the se member to value
    def se=(value)
     self[:se] = value
    end
    # Sets the sf member to value
    def sf=(value)
     self[:sf] = value
    end
    def to_s
      return "Short16{ #{self[:s0]}, #{self[:s1]}, #{self[:s2]}, #{self[:s3]}, #{self[:s4]}, #{self[:s5]}, #{self[:s6]}, #{self[:s7]}, #{self[:s8]}, #{self[:s9]}, #{self[:sa]}, #{self[:sb]}, #{self[:sc]}, #{self[:sd]}, #{self[:se]}, #{self[:sf]} }"
    end
  end
  # Maps the cl_ushort16 type of OpenCL
  class UShort16 < FFI::Struct
    @size = FFI.find_type(:cl_ushort).size * 16
    @layout = FFI::StructLayout::new([ FFI::StructLayout::Field::new( "s0", FFI.find_type(:cl_ushort).size * 0, FFI.find_type(:cl_ushort) ), FFI::StructLayout::Field::new( "s1", FFI.find_type(:cl_ushort).size * 1, FFI.find_type(:cl_ushort) ), FFI::StructLayout::Field::new( "s2", FFI.find_type(:cl_ushort).size * 2, FFI.find_type(:cl_ushort) ), FFI::StructLayout::Field::new( "s3", FFI.find_type(:cl_ushort).size * 3, FFI.find_type(:cl_ushort) ), FFI::StructLayout::Field::new( "s4", FFI.find_type(:cl_ushort).size * 4, FFI.find_type(:cl_ushort) ), FFI::StructLayout::Field::new( "s5", FFI.find_type(:cl_ushort).size * 5, FFI.find_type(:cl_ushort) ), FFI::StructLayout::Field::new( "s6", FFI.find_type(:cl_ushort).size * 6, FFI.find_type(:cl_ushort) ), FFI::StructLayout::Field::new( "s7", FFI.find_type(:cl_ushort).size * 7, FFI.find_type(:cl_ushort) ), FFI::StructLayout::Field::new( "s8", FFI.find_type(:cl_ushort).size * 8, FFI.find_type(:cl_ushort) ), FFI::StructLayout::Field::new( "s9", FFI.find_type(:cl_ushort).size * 9, FFI.find_type(:cl_ushort) ), FFI::StructLayout::Field::new( "sa", FFI.find_type(:cl_ushort).size * 10, FFI.find_type(:cl_ushort) ), FFI::StructLayout::Field::new( "sb", FFI.find_type(:cl_ushort).size * 11, FFI.find_type(:cl_ushort) ), FFI::StructLayout::Field::new( "sc", FFI.find_type(:cl_ushort).size * 12, FFI.find_type(:cl_ushort) ), FFI::StructLayout::Field::new( "sd", FFI.find_type(:cl_ushort).size * 13, FFI.find_type(:cl_ushort) ), FFI::StructLayout::Field::new( "se", FFI.find_type(:cl_ushort).size * 14, FFI.find_type(:cl_ushort) ), FFI::StructLayout::Field::new( "sf", FFI.find_type(:cl_ushort).size * 15, FFI.find_type(:cl_ushort) ) ], FFI.find_type(:cl_ushort).size * 16, FFI.find_type(:cl_ushort).size * 16 )
    # Creates a new UShort16 with members set to 0 or to the user specified values
    def initialize( s0 = 0, s1 = 0, s2 = 0, s3 = 0, s4 = 0, s5 = 0, s6 = 0, s7 = 0, s8 = 0, s9 = 0, sa = 0, sb = 0, sc = 0, sd = 0, se = 0, sf = 0 )
      super()
      self[:s0] = s0
      self[:s1] = s1
      self[:s2] = s2
      self[:s3] = s3
      self[:s4] = s4
      self[:s5] = s5
      self[:s6] = s6
      self[:s7] = s7
      self[:s8] = s8
      self[:s9] = s9
      self[:sa] = sa
      self[:sb] = sb
      self[:sc] = sc
      self[:sd] = sd
      self[:se] = se
      self[:sf] = sf
    end
    # Reads the s0 member
    def s0
     return self[:s0]
    end
    # Reads the s1 member
    def s1
     return self[:s1]
    end
    # Reads the s2 member
    def s2
     return self[:s2]
    end
    # Reads the s3 member
    def s3
     return self[:s3]
    end
    # Reads the s4 member
    def s4
     return self[:s4]
    end
    # Reads the s5 member
    def s5
     return self[:s5]
    end
    # Reads the s6 member
    def s6
     return self[:s6]
    end
    # Reads the s7 member
    def s7
     return self[:s7]
    end
    # Reads the s8 member
    def s8
     return self[:s8]
    end
    # Reads the s9 member
    def s9
     return self[:s9]
    end
    # Reads the sa member
    def sa
     return self[:sa]
    end
    # Reads the sb member
    def sb
     return self[:sb]
    end
    # Reads the sc member
    def sc
     return self[:sc]
    end
    # Reads the sd member
    def sd
     return self[:sd]
    end
    # Reads the se member
    def se
     return self[:se]
    end
    # Reads the sf member
    def sf
     return self[:sf]
    end
    # Sets the s0 member to value
    def s0=(value)
     self[:s0] = value
    end
    # Sets the s1 member to value
    def s1=(value)
     self[:s1] = value
    end
    # Sets the s2 member to value
    def s2=(value)
     self[:s2] = value
    end
    # Sets the s3 member to value
    def s3=(value)
     self[:s3] = value
    end
    # Sets the s4 member to value
    def s4=(value)
     self[:s4] = value
    end
    # Sets the s5 member to value
    def s5=(value)
     self[:s5] = value
    end
    # Sets the s6 member to value
    def s6=(value)
     self[:s6] = value
    end
    # Sets the s7 member to value
    def s7=(value)
     self[:s7] = value
    end
    # Sets the s8 member to value
    def s8=(value)
     self[:s8] = value
    end
    # Sets the s9 member to value
    def s9=(value)
     self[:s9] = value
    end
    # Sets the sa member to value
    def sa=(value)
     self[:sa] = value
    end
    # Sets the sb member to value
    def sb=(value)
     self[:sb] = value
    end
    # Sets the sc member to value
    def sc=(value)
     self[:sc] = value
    end
    # Sets the sd member to value
    def sd=(value)
     self[:sd] = value
    end
    # Sets the se member to value
    def se=(value)
     self[:se] = value
    end
    # Sets the sf member to value
    def sf=(value)
     self[:sf] = value
    end
    def to_s
      return "UShort16{ #{self[:s0]}, #{self[:s1]}, #{self[:s2]}, #{self[:s3]}, #{self[:s4]}, #{self[:s5]}, #{self[:s6]}, #{self[:s7]}, #{self[:s8]}, #{self[:s9]}, #{self[:sa]}, #{self[:sb]}, #{self[:sc]}, #{self[:sd]}, #{self[:se]}, #{self[:sf]} }"
    end
  end
  # Maps the cl_int16 type of OpenCL
  class Int16 < FFI::Struct
    @size = FFI.find_type(:cl_int).size * 16
    @layout = FFI::StructLayout::new([ FFI::StructLayout::Field::new( "s0", FFI.find_type(:cl_int).size * 0, FFI.find_type(:cl_int) ), FFI::StructLayout::Field::new( "s1", FFI.find_type(:cl_int).size * 1, FFI.find_type(:cl_int) ), FFI::StructLayout::Field::new( "s2", FFI.find_type(:cl_int).size * 2, FFI.find_type(:cl_int) ), FFI::StructLayout::Field::new( "s3", FFI.find_type(:cl_int).size * 3, FFI.find_type(:cl_int) ), FFI::StructLayout::Field::new( "s4", FFI.find_type(:cl_int).size * 4, FFI.find_type(:cl_int) ), FFI::StructLayout::Field::new( "s5", FFI.find_type(:cl_int).size * 5, FFI.find_type(:cl_int) ), FFI::StructLayout::Field::new( "s6", FFI.find_type(:cl_int).size * 6, FFI.find_type(:cl_int) ), FFI::StructLayout::Field::new( "s7", FFI.find_type(:cl_int).size * 7, FFI.find_type(:cl_int) ), FFI::StructLayout::Field::new( "s8", FFI.find_type(:cl_int).size * 8, FFI.find_type(:cl_int) ), FFI::StructLayout::Field::new( "s9", FFI.find_type(:cl_int).size * 9, FFI.find_type(:cl_int) ), FFI::StructLayout::Field::new( "sa", FFI.find_type(:cl_int).size * 10, FFI.find_type(:cl_int) ), FFI::StructLayout::Field::new( "sb", FFI.find_type(:cl_int).size * 11, FFI.find_type(:cl_int) ), FFI::StructLayout::Field::new( "sc", FFI.find_type(:cl_int).size * 12, FFI.find_type(:cl_int) ), FFI::StructLayout::Field::new( "sd", FFI.find_type(:cl_int).size * 13, FFI.find_type(:cl_int) ), FFI::StructLayout::Field::new( "se", FFI.find_type(:cl_int).size * 14, FFI.find_type(:cl_int) ), FFI::StructLayout::Field::new( "sf", FFI.find_type(:cl_int).size * 15, FFI.find_type(:cl_int) ) ], FFI.find_type(:cl_int).size * 16, FFI.find_type(:cl_int).size * 16 )
    # Creates a new Int16 with members set to 0 or to the user specified values
    def initialize( s0 = 0, s1 = 0, s2 = 0, s3 = 0, s4 = 0, s5 = 0, s6 = 0, s7 = 0, s8 = 0, s9 = 0, sa = 0, sb = 0, sc = 0, sd = 0, se = 0, sf = 0 )
      super()
      self[:s0] = s0
      self[:s1] = s1
      self[:s2] = s2
      self[:s3] = s3
      self[:s4] = s4
      self[:s5] = s5
      self[:s6] = s6
      self[:s7] = s7
      self[:s8] = s8
      self[:s9] = s9
      self[:sa] = sa
      self[:sb] = sb
      self[:sc] = sc
      self[:sd] = sd
      self[:se] = se
      self[:sf] = sf
    end
    # Reads the s0 member
    def s0
     return self[:s0]
    end
    # Reads the s1 member
    def s1
     return self[:s1]
    end
    # Reads the s2 member
    def s2
     return self[:s2]
    end
    # Reads the s3 member
    def s3
     return self[:s3]
    end
    # Reads the s4 member
    def s4
     return self[:s4]
    end
    # Reads the s5 member
    def s5
     return self[:s5]
    end
    # Reads the s6 member
    def s6
     return self[:s6]
    end
    # Reads the s7 member
    def s7
     return self[:s7]
    end
    # Reads the s8 member
    def s8
     return self[:s8]
    end
    # Reads the s9 member
    def s9
     return self[:s9]
    end
    # Reads the sa member
    def sa
     return self[:sa]
    end
    # Reads the sb member
    def sb
     return self[:sb]
    end
    # Reads the sc member
    def sc
     return self[:sc]
    end
    # Reads the sd member
    def sd
     return self[:sd]
    end
    # Reads the se member
    def se
     return self[:se]
    end
    # Reads the sf member
    def sf
     return self[:sf]
    end
    # Sets the s0 member to value
    def s0=(value)
     self[:s0] = value
    end
    # Sets the s1 member to value
    def s1=(value)
     self[:s1] = value
    end
    # Sets the s2 member to value
    def s2=(value)
     self[:s2] = value
    end
    # Sets the s3 member to value
    def s3=(value)
     self[:s3] = value
    end
    # Sets the s4 member to value
    def s4=(value)
     self[:s4] = value
    end
    # Sets the s5 member to value
    def s5=(value)
     self[:s5] = value
    end
    # Sets the s6 member to value
    def s6=(value)
     self[:s6] = value
    end
    # Sets the s7 member to value
    def s7=(value)
     self[:s7] = value
    end
    # Sets the s8 member to value
    def s8=(value)
     self[:s8] = value
    end
    # Sets the s9 member to value
    def s9=(value)
     self[:s9] = value
    end
    # Sets the sa member to value
    def sa=(value)
     self[:sa] = value
    end
    # Sets the sb member to value
    def sb=(value)
     self[:sb] = value
    end
    # Sets the sc member to value
    def sc=(value)
     self[:sc] = value
    end
    # Sets the sd member to value
    def sd=(value)
     self[:sd] = value
    end
    # Sets the se member to value
    def se=(value)
     self[:se] = value
    end
    # Sets the sf member to value
    def sf=(value)
     self[:sf] = value
    end
    def to_s
      return "Int16{ #{self[:s0]}, #{self[:s1]}, #{self[:s2]}, #{self[:s3]}, #{self[:s4]}, #{self[:s5]}, #{self[:s6]}, #{self[:s7]}, #{self[:s8]}, #{self[:s9]}, #{self[:sa]}, #{self[:sb]}, #{self[:sc]}, #{self[:sd]}, #{self[:se]}, #{self[:sf]} }"
    end
  end
  # Maps the cl_uint16 type of OpenCL
  class UInt16 < FFI::Struct
    @size = FFI.find_type(:cl_uint).size * 16
    @layout = FFI::StructLayout::new([ FFI::StructLayout::Field::new( "s0", FFI.find_type(:cl_uint).size * 0, FFI.find_type(:cl_uint) ), FFI::StructLayout::Field::new( "s1", FFI.find_type(:cl_uint).size * 1, FFI.find_type(:cl_uint) ), FFI::StructLayout::Field::new( "s2", FFI.find_type(:cl_uint).size * 2, FFI.find_type(:cl_uint) ), FFI::StructLayout::Field::new( "s3", FFI.find_type(:cl_uint).size * 3, FFI.find_type(:cl_uint) ), FFI::StructLayout::Field::new( "s4", FFI.find_type(:cl_uint).size * 4, FFI.find_type(:cl_uint) ), FFI::StructLayout::Field::new( "s5", FFI.find_type(:cl_uint).size * 5, FFI.find_type(:cl_uint) ), FFI::StructLayout::Field::new( "s6", FFI.find_type(:cl_uint).size * 6, FFI.find_type(:cl_uint) ), FFI::StructLayout::Field::new( "s7", FFI.find_type(:cl_uint).size * 7, FFI.find_type(:cl_uint) ), FFI::StructLayout::Field::new( "s8", FFI.find_type(:cl_uint).size * 8, FFI.find_type(:cl_uint) ), FFI::StructLayout::Field::new( "s9", FFI.find_type(:cl_uint).size * 9, FFI.find_type(:cl_uint) ), FFI::StructLayout::Field::new( "sa", FFI.find_type(:cl_uint).size * 10, FFI.find_type(:cl_uint) ), FFI::StructLayout::Field::new( "sb", FFI.find_type(:cl_uint).size * 11, FFI.find_type(:cl_uint) ), FFI::StructLayout::Field::new( "sc", FFI.find_type(:cl_uint).size * 12, FFI.find_type(:cl_uint) ), FFI::StructLayout::Field::new( "sd", FFI.find_type(:cl_uint).size * 13, FFI.find_type(:cl_uint) ), FFI::StructLayout::Field::new( "se", FFI.find_type(:cl_uint).size * 14, FFI.find_type(:cl_uint) ), FFI::StructLayout::Field::new( "sf", FFI.find_type(:cl_uint).size * 15, FFI.find_type(:cl_uint) ) ], FFI.find_type(:cl_uint).size * 16, FFI.find_type(:cl_uint).size * 16 )
    # Creates a new UInt16 with members set to 0 or to the user specified values
    def initialize( s0 = 0, s1 = 0, s2 = 0, s3 = 0, s4 = 0, s5 = 0, s6 = 0, s7 = 0, s8 = 0, s9 = 0, sa = 0, sb = 0, sc = 0, sd = 0, se = 0, sf = 0 )
      super()
      self[:s0] = s0
      self[:s1] = s1
      self[:s2] = s2
      self[:s3] = s3
      self[:s4] = s4
      self[:s5] = s5
      self[:s6] = s6
      self[:s7] = s7
      self[:s8] = s8
      self[:s9] = s9
      self[:sa] = sa
      self[:sb] = sb
      self[:sc] = sc
      self[:sd] = sd
      self[:se] = se
      self[:sf] = sf
    end
    # Reads the s0 member
    def s0
     return self[:s0]
    end
    # Reads the s1 member
    def s1
     return self[:s1]
    end
    # Reads the s2 member
    def s2
     return self[:s2]
    end
    # Reads the s3 member
    def s3
     return self[:s3]
    end
    # Reads the s4 member
    def s4
     return self[:s4]
    end
    # Reads the s5 member
    def s5
     return self[:s5]
    end
    # Reads the s6 member
    def s6
     return self[:s6]
    end
    # Reads the s7 member
    def s7
     return self[:s7]
    end
    # Reads the s8 member
    def s8
     return self[:s8]
    end
    # Reads the s9 member
    def s9
     return self[:s9]
    end
    # Reads the sa member
    def sa
     return self[:sa]
    end
    # Reads the sb member
    def sb
     return self[:sb]
    end
    # Reads the sc member
    def sc
     return self[:sc]
    end
    # Reads the sd member
    def sd
     return self[:sd]
    end
    # Reads the se member
    def se
     return self[:se]
    end
    # Reads the sf member
    def sf
     return self[:sf]
    end
    # Sets the s0 member to value
    def s0=(value)
     self[:s0] = value
    end
    # Sets the s1 member to value
    def s1=(value)
     self[:s1] = value
    end
    # Sets the s2 member to value
    def s2=(value)
     self[:s2] = value
    end
    # Sets the s3 member to value
    def s3=(value)
     self[:s3] = value
    end
    # Sets the s4 member to value
    def s4=(value)
     self[:s4] = value
    end
    # Sets the s5 member to value
    def s5=(value)
     self[:s5] = value
    end
    # Sets the s6 member to value
    def s6=(value)
     self[:s6] = value
    end
    # Sets the s7 member to value
    def s7=(value)
     self[:s7] = value
    end
    # Sets the s8 member to value
    def s8=(value)
     self[:s8] = value
    end
    # Sets the s9 member to value
    def s9=(value)
     self[:s9] = value
    end
    # Sets the sa member to value
    def sa=(value)
     self[:sa] = value
    end
    # Sets the sb member to value
    def sb=(value)
     self[:sb] = value
    end
    # Sets the sc member to value
    def sc=(value)
     self[:sc] = value
    end
    # Sets the sd member to value
    def sd=(value)
     self[:sd] = value
    end
    # Sets the se member to value
    def se=(value)
     self[:se] = value
    end
    # Sets the sf member to value
    def sf=(value)
     self[:sf] = value
    end
    def to_s
      return "UInt16{ #{self[:s0]}, #{self[:s1]}, #{self[:s2]}, #{self[:s3]}, #{self[:s4]}, #{self[:s5]}, #{self[:s6]}, #{self[:s7]}, #{self[:s8]}, #{self[:s9]}, #{self[:sa]}, #{self[:sb]}, #{self[:sc]}, #{self[:sd]}, #{self[:se]}, #{self[:sf]} }"
    end
  end
  # Maps the cl_long16 type of OpenCL
  class Long16 < FFI::Struct
    @size = FFI.find_type(:cl_long).size * 16
    @layout = FFI::StructLayout::new([ FFI::StructLayout::Field::new( "s0", FFI.find_type(:cl_long).size * 0, FFI.find_type(:cl_long) ), FFI::StructLayout::Field::new( "s1", FFI.find_type(:cl_long).size * 1, FFI.find_type(:cl_long) ), FFI::StructLayout::Field::new( "s2", FFI.find_type(:cl_long).size * 2, FFI.find_type(:cl_long) ), FFI::StructLayout::Field::new( "s3", FFI.find_type(:cl_long).size * 3, FFI.find_type(:cl_long) ), FFI::StructLayout::Field::new( "s4", FFI.find_type(:cl_long).size * 4, FFI.find_type(:cl_long) ), FFI::StructLayout::Field::new( "s5", FFI.find_type(:cl_long).size * 5, FFI.find_type(:cl_long) ), FFI::StructLayout::Field::new( "s6", FFI.find_type(:cl_long).size * 6, FFI.find_type(:cl_long) ), FFI::StructLayout::Field::new( "s7", FFI.find_type(:cl_long).size * 7, FFI.find_type(:cl_long) ), FFI::StructLayout::Field::new( "s8", FFI.find_type(:cl_long).size * 8, FFI.find_type(:cl_long) ), FFI::StructLayout::Field::new( "s9", FFI.find_type(:cl_long).size * 9, FFI.find_type(:cl_long) ), FFI::StructLayout::Field::new( "sa", FFI.find_type(:cl_long).size * 10, FFI.find_type(:cl_long) ), FFI::StructLayout::Field::new( "sb", FFI.find_type(:cl_long).size * 11, FFI.find_type(:cl_long) ), FFI::StructLayout::Field::new( "sc", FFI.find_type(:cl_long).size * 12, FFI.find_type(:cl_long) ), FFI::StructLayout::Field::new( "sd", FFI.find_type(:cl_long).size * 13, FFI.find_type(:cl_long) ), FFI::StructLayout::Field::new( "se", FFI.find_type(:cl_long).size * 14, FFI.find_type(:cl_long) ), FFI::StructLayout::Field::new( "sf", FFI.find_type(:cl_long).size * 15, FFI.find_type(:cl_long) ) ], FFI.find_type(:cl_long).size * 16, FFI.find_type(:cl_long).size * 16 )
    # Creates a new Long16 with members set to 0 or to the user specified values
    def initialize( s0 = 0, s1 = 0, s2 = 0, s3 = 0, s4 = 0, s5 = 0, s6 = 0, s7 = 0, s8 = 0, s9 = 0, sa = 0, sb = 0, sc = 0, sd = 0, se = 0, sf = 0 )
      super()
      self[:s0] = s0
      self[:s1] = s1
      self[:s2] = s2
      self[:s3] = s3
      self[:s4] = s4
      self[:s5] = s5
      self[:s6] = s6
      self[:s7] = s7
      self[:s8] = s8
      self[:s9] = s9
      self[:sa] = sa
      self[:sb] = sb
      self[:sc] = sc
      self[:sd] = sd
      self[:se] = se
      self[:sf] = sf
    end
    # Reads the s0 member
    def s0
     return self[:s0]
    end
    # Reads the s1 member
    def s1
     return self[:s1]
    end
    # Reads the s2 member
    def s2
     return self[:s2]
    end
    # Reads the s3 member
    def s3
     return self[:s3]
    end
    # Reads the s4 member
    def s4
     return self[:s4]
    end
    # Reads the s5 member
    def s5
     return self[:s5]
    end
    # Reads the s6 member
    def s6
     return self[:s6]
    end
    # Reads the s7 member
    def s7
     return self[:s7]
    end
    # Reads the s8 member
    def s8
     return self[:s8]
    end
    # Reads the s9 member
    def s9
     return self[:s9]
    end
    # Reads the sa member
    def sa
     return self[:sa]
    end
    # Reads the sb member
    def sb
     return self[:sb]
    end
    # Reads the sc member
    def sc
     return self[:sc]
    end
    # Reads the sd member
    def sd
     return self[:sd]
    end
    # Reads the se member
    def se
     return self[:se]
    end
    # Reads the sf member
    def sf
     return self[:sf]
    end
    # Sets the s0 member to value
    def s0=(value)
     self[:s0] = value
    end
    # Sets the s1 member to value
    def s1=(value)
     self[:s1] = value
    end
    # Sets the s2 member to value
    def s2=(value)
     self[:s2] = value
    end
    # Sets the s3 member to value
    def s3=(value)
     self[:s3] = value
    end
    # Sets the s4 member to value
    def s4=(value)
     self[:s4] = value
    end
    # Sets the s5 member to value
    def s5=(value)
     self[:s5] = value
    end
    # Sets the s6 member to value
    def s6=(value)
     self[:s6] = value
    end
    # Sets the s7 member to value
    def s7=(value)
     self[:s7] = value
    end
    # Sets the s8 member to value
    def s8=(value)
     self[:s8] = value
    end
    # Sets the s9 member to value
    def s9=(value)
     self[:s9] = value
    end
    # Sets the sa member to value
    def sa=(value)
     self[:sa] = value
    end
    # Sets the sb member to value
    def sb=(value)
     self[:sb] = value
    end
    # Sets the sc member to value
    def sc=(value)
     self[:sc] = value
    end
    # Sets the sd member to value
    def sd=(value)
     self[:sd] = value
    end
    # Sets the se member to value
    def se=(value)
     self[:se] = value
    end
    # Sets the sf member to value
    def sf=(value)
     self[:sf] = value
    end
    def to_s
      return "Long16{ #{self[:s0]}, #{self[:s1]}, #{self[:s2]}, #{self[:s3]}, #{self[:s4]}, #{self[:s5]}, #{self[:s6]}, #{self[:s7]}, #{self[:s8]}, #{self[:s9]}, #{self[:sa]}, #{self[:sb]}, #{self[:sc]}, #{self[:sd]}, #{self[:se]}, #{self[:sf]} }"
    end
  end
  # Maps the cl_ulong16 type of OpenCL
  class ULong16 < FFI::Struct
    @size = FFI.find_type(:cl_ulong).size * 16
    @layout = FFI::StructLayout::new([ FFI::StructLayout::Field::new( "s0", FFI.find_type(:cl_ulong).size * 0, FFI.find_type(:cl_ulong) ), FFI::StructLayout::Field::new( "s1", FFI.find_type(:cl_ulong).size * 1, FFI.find_type(:cl_ulong) ), FFI::StructLayout::Field::new( "s2", FFI.find_type(:cl_ulong).size * 2, FFI.find_type(:cl_ulong) ), FFI::StructLayout::Field::new( "s3", FFI.find_type(:cl_ulong).size * 3, FFI.find_type(:cl_ulong) ), FFI::StructLayout::Field::new( "s4", FFI.find_type(:cl_ulong).size * 4, FFI.find_type(:cl_ulong) ), FFI::StructLayout::Field::new( "s5", FFI.find_type(:cl_ulong).size * 5, FFI.find_type(:cl_ulong) ), FFI::StructLayout::Field::new( "s6", FFI.find_type(:cl_ulong).size * 6, FFI.find_type(:cl_ulong) ), FFI::StructLayout::Field::new( "s7", FFI.find_type(:cl_ulong).size * 7, FFI.find_type(:cl_ulong) ), FFI::StructLayout::Field::new( "s8", FFI.find_type(:cl_ulong).size * 8, FFI.find_type(:cl_ulong) ), FFI::StructLayout::Field::new( "s9", FFI.find_type(:cl_ulong).size * 9, FFI.find_type(:cl_ulong) ), FFI::StructLayout::Field::new( "sa", FFI.find_type(:cl_ulong).size * 10, FFI.find_type(:cl_ulong) ), FFI::StructLayout::Field::new( "sb", FFI.find_type(:cl_ulong).size * 11, FFI.find_type(:cl_ulong) ), FFI::StructLayout::Field::new( "sc", FFI.find_type(:cl_ulong).size * 12, FFI.find_type(:cl_ulong) ), FFI::StructLayout::Field::new( "sd", FFI.find_type(:cl_ulong).size * 13, FFI.find_type(:cl_ulong) ), FFI::StructLayout::Field::new( "se", FFI.find_type(:cl_ulong).size * 14, FFI.find_type(:cl_ulong) ), FFI::StructLayout::Field::new( "sf", FFI.find_type(:cl_ulong).size * 15, FFI.find_type(:cl_ulong) ) ], FFI.find_type(:cl_ulong).size * 16, FFI.find_type(:cl_ulong).size * 16 )
    # Creates a new ULong16 with members set to 0 or to the user specified values
    def initialize( s0 = 0, s1 = 0, s2 = 0, s3 = 0, s4 = 0, s5 = 0, s6 = 0, s7 = 0, s8 = 0, s9 = 0, sa = 0, sb = 0, sc = 0, sd = 0, se = 0, sf = 0 )
      super()
      self[:s0] = s0
      self[:s1] = s1
      self[:s2] = s2
      self[:s3] = s3
      self[:s4] = s4
      self[:s5] = s5
      self[:s6] = s6
      self[:s7] = s7
      self[:s8] = s8
      self[:s9] = s9
      self[:sa] = sa
      self[:sb] = sb
      self[:sc] = sc
      self[:sd] = sd
      self[:se] = se
      self[:sf] = sf
    end
    # Reads the s0 member
    def s0
     return self[:s0]
    end
    # Reads the s1 member
    def s1
     return self[:s1]
    end
    # Reads the s2 member
    def s2
     return self[:s2]
    end
    # Reads the s3 member
    def s3
     return self[:s3]
    end
    # Reads the s4 member
    def s4
     return self[:s4]
    end
    # Reads the s5 member
    def s5
     return self[:s5]
    end
    # Reads the s6 member
    def s6
     return self[:s6]
    end
    # Reads the s7 member
    def s7
     return self[:s7]
    end
    # Reads the s8 member
    def s8
     return self[:s8]
    end
    # Reads the s9 member
    def s9
     return self[:s9]
    end
    # Reads the sa member
    def sa
     return self[:sa]
    end
    # Reads the sb member
    def sb
     return self[:sb]
    end
    # Reads the sc member
    def sc
     return self[:sc]
    end
    # Reads the sd member
    def sd
     return self[:sd]
    end
    # Reads the se member
    def se
     return self[:se]
    end
    # Reads the sf member
    def sf
     return self[:sf]
    end
    # Sets the s0 member to value
    def s0=(value)
     self[:s0] = value
    end
    # Sets the s1 member to value
    def s1=(value)
     self[:s1] = value
    end
    # Sets the s2 member to value
    def s2=(value)
     self[:s2] = value
    end
    # Sets the s3 member to value
    def s3=(value)
     self[:s3] = value
    end
    # Sets the s4 member to value
    def s4=(value)
     self[:s4] = value
    end
    # Sets the s5 member to value
    def s5=(value)
     self[:s5] = value
    end
    # Sets the s6 member to value
    def s6=(value)
     self[:s6] = value
    end
    # Sets the s7 member to value
    def s7=(value)
     self[:s7] = value
    end
    # Sets the s8 member to value
    def s8=(value)
     self[:s8] = value
    end
    # Sets the s9 member to value
    def s9=(value)
     self[:s9] = value
    end
    # Sets the sa member to value
    def sa=(value)
     self[:sa] = value
    end
    # Sets the sb member to value
    def sb=(value)
     self[:sb] = value
    end
    # Sets the sc member to value
    def sc=(value)
     self[:sc] = value
    end
    # Sets the sd member to value
    def sd=(value)
     self[:sd] = value
    end
    # Sets the se member to value
    def se=(value)
     self[:se] = value
    end
    # Sets the sf member to value
    def sf=(value)
     self[:sf] = value
    end
    def to_s
      return "ULong16{ #{self[:s0]}, #{self[:s1]}, #{self[:s2]}, #{self[:s3]}, #{self[:s4]}, #{self[:s5]}, #{self[:s6]}, #{self[:s7]}, #{self[:s8]}, #{self[:s9]}, #{self[:sa]}, #{self[:sb]}, #{self[:sc]}, #{self[:sd]}, #{self[:se]}, #{self[:sf]} }"
    end
  end
  # Maps the cl_float16 type of OpenCL
  class Float16 < FFI::Struct
    @size = FFI.find_type(:cl_float).size * 16
    @layout = FFI::StructLayout::new([ FFI::StructLayout::Field::new( "s0", FFI.find_type(:cl_float).size * 0, FFI.find_type(:cl_float) ), FFI::StructLayout::Field::new( "s1", FFI.find_type(:cl_float).size * 1, FFI.find_type(:cl_float) ), FFI::StructLayout::Field::new( "s2", FFI.find_type(:cl_float).size * 2, FFI.find_type(:cl_float) ), FFI::StructLayout::Field::new( "s3", FFI.find_type(:cl_float).size * 3, FFI.find_type(:cl_float) ), FFI::StructLayout::Field::new( "s4", FFI.find_type(:cl_float).size * 4, FFI.find_type(:cl_float) ), FFI::StructLayout::Field::new( "s5", FFI.find_type(:cl_float).size * 5, FFI.find_type(:cl_float) ), FFI::StructLayout::Field::new( "s6", FFI.find_type(:cl_float).size * 6, FFI.find_type(:cl_float) ), FFI::StructLayout::Field::new( "s7", FFI.find_type(:cl_float).size * 7, FFI.find_type(:cl_float) ), FFI::StructLayout::Field::new( "s8", FFI.find_type(:cl_float).size * 8, FFI.find_type(:cl_float) ), FFI::StructLayout::Field::new( "s9", FFI.find_type(:cl_float).size * 9, FFI.find_type(:cl_float) ), FFI::StructLayout::Field::new( "sa", FFI.find_type(:cl_float).size * 10, FFI.find_type(:cl_float) ), FFI::StructLayout::Field::new( "sb", FFI.find_type(:cl_float).size * 11, FFI.find_type(:cl_float) ), FFI::StructLayout::Field::new( "sc", FFI.find_type(:cl_float).size * 12, FFI.find_type(:cl_float) ), FFI::StructLayout::Field::new( "sd", FFI.find_type(:cl_float).size * 13, FFI.find_type(:cl_float) ), FFI::StructLayout::Field::new( "se", FFI.find_type(:cl_float).size * 14, FFI.find_type(:cl_float) ), FFI::StructLayout::Field::new( "sf", FFI.find_type(:cl_float).size * 15, FFI.find_type(:cl_float) ) ], FFI.find_type(:cl_float).size * 16, FFI.find_type(:cl_float).size * 16 )
    # Creates a new Float16 with members set to 0 or to the user specified values
    def initialize( s0 = 0.0, s1 = 0.0, s2 = 0.0, s3 = 0.0, s4 = 0.0, s5 = 0.0, s6 = 0.0, s7 = 0.0, s8 = 0.0, s9 = 0.0, sa = 0.0, sb = 0.0, sc = 0.0, sd = 0.0, se = 0.0, sf = 0.0 )
      super()
      self[:s0] = s0
      self[:s1] = s1
      self[:s2] = s2
      self[:s3] = s3
      self[:s4] = s4
      self[:s5] = s5
      self[:s6] = s6
      self[:s7] = s7
      self[:s8] = s8
      self[:s9] = s9
      self[:sa] = sa
      self[:sb] = sb
      self[:sc] = sc
      self[:sd] = sd
      self[:se] = se
      self[:sf] = sf
    end
    # Reads the s0 member
    def s0
     return self[:s0]
    end
    # Reads the s1 member
    def s1
     return self[:s1]
    end
    # Reads the s2 member
    def s2
     return self[:s2]
    end
    # Reads the s3 member
    def s3
     return self[:s3]
    end
    # Reads the s4 member
    def s4
     return self[:s4]
    end
    # Reads the s5 member
    def s5
     return self[:s5]
    end
    # Reads the s6 member
    def s6
     return self[:s6]
    end
    # Reads the s7 member
    def s7
     return self[:s7]
    end
    # Reads the s8 member
    def s8
     return self[:s8]
    end
    # Reads the s9 member
    def s9
     return self[:s9]
    end
    # Reads the sa member
    def sa
     return self[:sa]
    end
    # Reads the sb member
    def sb
     return self[:sb]
    end
    # Reads the sc member
    def sc
     return self[:sc]
    end
    # Reads the sd member
    def sd
     return self[:sd]
    end
    # Reads the se member
    def se
     return self[:se]
    end
    # Reads the sf member
    def sf
     return self[:sf]
    end
    # Sets the s0 member to value
    def s0=(value)
     self[:s0] = value
    end
    # Sets the s1 member to value
    def s1=(value)
     self[:s1] = value
    end
    # Sets the s2 member to value
    def s2=(value)
     self[:s2] = value
    end
    # Sets the s3 member to value
    def s3=(value)
     self[:s3] = value
    end
    # Sets the s4 member to value
    def s4=(value)
     self[:s4] = value
    end
    # Sets the s5 member to value
    def s5=(value)
     self[:s5] = value
    end
    # Sets the s6 member to value
    def s6=(value)
     self[:s6] = value
    end
    # Sets the s7 member to value
    def s7=(value)
     self[:s7] = value
    end
    # Sets the s8 member to value
    def s8=(value)
     self[:s8] = value
    end
    # Sets the s9 member to value
    def s9=(value)
     self[:s9] = value
    end
    # Sets the sa member to value
    def sa=(value)
     self[:sa] = value
    end
    # Sets the sb member to value
    def sb=(value)
     self[:sb] = value
    end
    # Sets the sc member to value
    def sc=(value)
     self[:sc] = value
    end
    # Sets the sd member to value
    def sd=(value)
     self[:sd] = value
    end
    # Sets the se member to value
    def se=(value)
     self[:se] = value
    end
    # Sets the sf member to value
    def sf=(value)
     self[:sf] = value
    end
    def to_s
      return "Float16{ #{self[:s0]}, #{self[:s1]}, #{self[:s2]}, #{self[:s3]}, #{self[:s4]}, #{self[:s5]}, #{self[:s6]}, #{self[:s7]}, #{self[:s8]}, #{self[:s9]}, #{self[:sa]}, #{self[:sb]}, #{self[:sc]}, #{self[:sd]}, #{self[:se]}, #{self[:sf]} }"
    end
  end
  # Maps the cl_double16 type of OpenCL
  class Double16 < FFI::Struct
    @size = FFI.find_type(:cl_double).size * 16
    @layout = FFI::StructLayout::new([ FFI::StructLayout::Field::new( "s0", FFI.find_type(:cl_double).size * 0, FFI.find_type(:cl_double) ), FFI::StructLayout::Field::new( "s1", FFI.find_type(:cl_double).size * 1, FFI.find_type(:cl_double) ), FFI::StructLayout::Field::new( "s2", FFI.find_type(:cl_double).size * 2, FFI.find_type(:cl_double) ), FFI::StructLayout::Field::new( "s3", FFI.find_type(:cl_double).size * 3, FFI.find_type(:cl_double) ), FFI::StructLayout::Field::new( "s4", FFI.find_type(:cl_double).size * 4, FFI.find_type(:cl_double) ), FFI::StructLayout::Field::new( "s5", FFI.find_type(:cl_double).size * 5, FFI.find_type(:cl_double) ), FFI::StructLayout::Field::new( "s6", FFI.find_type(:cl_double).size * 6, FFI.find_type(:cl_double) ), FFI::StructLayout::Field::new( "s7", FFI.find_type(:cl_double).size * 7, FFI.find_type(:cl_double) ), FFI::StructLayout::Field::new( "s8", FFI.find_type(:cl_double).size * 8, FFI.find_type(:cl_double) ), FFI::StructLayout::Field::new( "s9", FFI.find_type(:cl_double).size * 9, FFI.find_type(:cl_double) ), FFI::StructLayout::Field::new( "sa", FFI.find_type(:cl_double).size * 10, FFI.find_type(:cl_double) ), FFI::StructLayout::Field::new( "sb", FFI.find_type(:cl_double).size * 11, FFI.find_type(:cl_double) ), FFI::StructLayout::Field::new( "sc", FFI.find_type(:cl_double).size * 12, FFI.find_type(:cl_double) ), FFI::StructLayout::Field::new( "sd", FFI.find_type(:cl_double).size * 13, FFI.find_type(:cl_double) ), FFI::StructLayout::Field::new( "se", FFI.find_type(:cl_double).size * 14, FFI.find_type(:cl_double) ), FFI::StructLayout::Field::new( "sf", FFI.find_type(:cl_double).size * 15, FFI.find_type(:cl_double) ) ], FFI.find_type(:cl_double).size * 16, FFI.find_type(:cl_double).size * 16 )
    # Creates a new Double16 with members set to 0 or to the user specified values
    def initialize( s0 = 0.0, s1 = 0.0, s2 = 0.0, s3 = 0.0, s4 = 0.0, s5 = 0.0, s6 = 0.0, s7 = 0.0, s8 = 0.0, s9 = 0.0, sa = 0.0, sb = 0.0, sc = 0.0, sd = 0.0, se = 0.0, sf = 0.0 )
      super()
      self[:s0] = s0
      self[:s1] = s1
      self[:s2] = s2
      self[:s3] = s3
      self[:s4] = s4
      self[:s5] = s5
      self[:s6] = s6
      self[:s7] = s7
      self[:s8] = s8
      self[:s9] = s9
      self[:sa] = sa
      self[:sb] = sb
      self[:sc] = sc
      self[:sd] = sd
      self[:se] = se
      self[:sf] = sf
    end
    # Reads the s0 member
    def s0
     return self[:s0]
    end
    # Reads the s1 member
    def s1
     return self[:s1]
    end
    # Reads the s2 member
    def s2
     return self[:s2]
    end
    # Reads the s3 member
    def s3
     return self[:s3]
    end
    # Reads the s4 member
    def s4
     return self[:s4]
    end
    # Reads the s5 member
    def s5
     return self[:s5]
    end
    # Reads the s6 member
    def s6
     return self[:s6]
    end
    # Reads the s7 member
    def s7
     return self[:s7]
    end
    # Reads the s8 member
    def s8
     return self[:s8]
    end
    # Reads the s9 member
    def s9
     return self[:s9]
    end
    # Reads the sa member
    def sa
     return self[:sa]
    end
    # Reads the sb member
    def sb
     return self[:sb]
    end
    # Reads the sc member
    def sc
     return self[:sc]
    end
    # Reads the sd member
    def sd
     return self[:sd]
    end
    # Reads the se member
    def se
     return self[:se]
    end
    # Reads the sf member
    def sf
     return self[:sf]
    end
    # Sets the s0 member to value
    def s0=(value)
     self[:s0] = value
    end
    # Sets the s1 member to value
    def s1=(value)
     self[:s1] = value
    end
    # Sets the s2 member to value
    def s2=(value)
     self[:s2] = value
    end
    # Sets the s3 member to value
    def s3=(value)
     self[:s3] = value
    end
    # Sets the s4 member to value
    def s4=(value)
     self[:s4] = value
    end
    # Sets the s5 member to value
    def s5=(value)
     self[:s5] = value
    end
    # Sets the s6 member to value
    def s6=(value)
     self[:s6] = value
    end
    # Sets the s7 member to value
    def s7=(value)
     self[:s7] = value
    end
    # Sets the s8 member to value
    def s8=(value)
     self[:s8] = value
    end
    # Sets the s9 member to value
    def s9=(value)
     self[:s9] = value
    end
    # Sets the sa member to value
    def sa=(value)
     self[:sa] = value
    end
    # Sets the sb member to value
    def sb=(value)
     self[:sb] = value
    end
    # Sets the sc member to value
    def sc=(value)
     self[:sc] = value
    end
    # Sets the sd member to value
    def sd=(value)
     self[:sd] = value
    end
    # Sets the se member to value
    def se=(value)
     self[:se] = value
    end
    # Sets the sf member to value
    def sf=(value)
     self[:sf] = value
    end
    def to_s
      return "Double16{ #{self[:s0]}, #{self[:s1]}, #{self[:s2]}, #{self[:s3]}, #{self[:s4]}, #{self[:s5]}, #{self[:s6]}, #{self[:s7]}, #{self[:s8]}, #{self[:s9]}, #{self[:sa]}, #{self[:sb]}, #{self[:sc]}, #{self[:sd]}, #{self[:se]}, #{self[:sf]} }"
    end
  end
  # Maps the cl_half16 type of OpenCL
  class Half16 < FFI::Struct
    @size = FFI.find_type(:cl_half).size * 16
    @layout = FFI::StructLayout::new([ FFI::StructLayout::Field::new( "s0", FFI.find_type(:cl_half).size * 0, FFI.find_type(:cl_half) ), FFI::StructLayout::Field::new( "s1", FFI.find_type(:cl_half).size * 1, FFI.find_type(:cl_half) ), FFI::StructLayout::Field::new( "s2", FFI.find_type(:cl_half).size * 2, FFI.find_type(:cl_half) ), FFI::StructLayout::Field::new( "s3", FFI.find_type(:cl_half).size * 3, FFI.find_type(:cl_half) ), FFI::StructLayout::Field::new( "s4", FFI.find_type(:cl_half).size * 4, FFI.find_type(:cl_half) ), FFI::StructLayout::Field::new( "s5", FFI.find_type(:cl_half).size * 5, FFI.find_type(:cl_half) ), FFI::StructLayout::Field::new( "s6", FFI.find_type(:cl_half).size * 6, FFI.find_type(:cl_half) ), FFI::StructLayout::Field::new( "s7", FFI.find_type(:cl_half).size * 7, FFI.find_type(:cl_half) ), FFI::StructLayout::Field::new( "s8", FFI.find_type(:cl_half).size * 8, FFI.find_type(:cl_half) ), FFI::StructLayout::Field::new( "s9", FFI.find_type(:cl_half).size * 9, FFI.find_type(:cl_half) ), FFI::StructLayout::Field::new( "sa", FFI.find_type(:cl_half).size * 10, FFI.find_type(:cl_half) ), FFI::StructLayout::Field::new( "sb", FFI.find_type(:cl_half).size * 11, FFI.find_type(:cl_half) ), FFI::StructLayout::Field::new( "sc", FFI.find_type(:cl_half).size * 12, FFI.find_type(:cl_half) ), FFI::StructLayout::Field::new( "sd", FFI.find_type(:cl_half).size * 13, FFI.find_type(:cl_half) ), FFI::StructLayout::Field::new( "se", FFI.find_type(:cl_half).size * 14, FFI.find_type(:cl_half) ), FFI::StructLayout::Field::new( "sf", FFI.find_type(:cl_half).size * 15, FFI.find_type(:cl_half) ) ], FFI.find_type(:cl_half).size * 16, FFI.find_type(:cl_half).size * 16 )
    # Creates a new Half16 with members set to 0 or to the user specified values
    def initialize( s0 = 0.0, s1 = 0.0, s2 = 0.0, s3 = 0.0, s4 = 0.0, s5 = 0.0, s6 = 0.0, s7 = 0.0, s8 = 0.0, s9 = 0.0, sa = 0.0, sb = 0.0, sc = 0.0, sd = 0.0, se = 0.0, sf = 0.0 )
      super()
      self[:s0] = s0
      self[:s1] = s1
      self[:s2] = s2
      self[:s3] = s3
      self[:s4] = s4
      self[:s5] = s5
      self[:s6] = s6
      self[:s7] = s7
      self[:s8] = s8
      self[:s9] = s9
      self[:sa] = sa
      self[:sb] = sb
      self[:sc] = sc
      self[:sd] = sd
      self[:se] = se
      self[:sf] = sf
    end
    # Reads the s0 member
    def s0
     return self[:s0]
    end
    # Reads the s1 member
    def s1
     return self[:s1]
    end
    # Reads the s2 member
    def s2
     return self[:s2]
    end
    # Reads the s3 member
    def s3
     return self[:s3]
    end
    # Reads the s4 member
    def s4
     return self[:s4]
    end
    # Reads the s5 member
    def s5
     return self[:s5]
    end
    # Reads the s6 member
    def s6
     return self[:s6]
    end
    # Reads the s7 member
    def s7
     return self[:s7]
    end
    # Reads the s8 member
    def s8
     return self[:s8]
    end
    # Reads the s9 member
    def s9
     return self[:s9]
    end
    # Reads the sa member
    def sa
     return self[:sa]
    end
    # Reads the sb member
    def sb
     return self[:sb]
    end
    # Reads the sc member
    def sc
     return self[:sc]
    end
    # Reads the sd member
    def sd
     return self[:sd]
    end
    # Reads the se member
    def se
     return self[:se]
    end
    # Reads the sf member
    def sf
     return self[:sf]
    end
    # Sets the s0 member to value
    def s0=(value)
     self[:s0] = value
    end
    # Sets the s1 member to value
    def s1=(value)
     self[:s1] = value
    end
    # Sets the s2 member to value
    def s2=(value)
     self[:s2] = value
    end
    # Sets the s3 member to value
    def s3=(value)
     self[:s3] = value
    end
    # Sets the s4 member to value
    def s4=(value)
     self[:s4] = value
    end
    # Sets the s5 member to value
    def s5=(value)
     self[:s5] = value
    end
    # Sets the s6 member to value
    def s6=(value)
     self[:s6] = value
    end
    # Sets the s7 member to value
    def s7=(value)
     self[:s7] = value
    end
    # Sets the s8 member to value
    def s8=(value)
     self[:s8] = value
    end
    # Sets the s9 member to value
    def s9=(value)
     self[:s9] = value
    end
    # Sets the sa member to value
    def sa=(value)
     self[:sa] = value
    end
    # Sets the sb member to value
    def sb=(value)
     self[:sb] = value
    end
    # Sets the sc member to value
    def sc=(value)
     self[:sc] = value
    end
    # Sets the sd member to value
    def sd=(value)
     self[:sd] = value
    end
    # Sets the se member to value
    def se=(value)
     self[:se] = value
    end
    # Sets the sf member to value
    def sf=(value)
     self[:sf] = value
    end
    def to_s
      return "Half16{ #{self[:s0]}, #{self[:s1]}, #{self[:s2]}, #{self[:s3]}, #{self[:s4]}, #{self[:s5]}, #{self[:s6]}, #{self[:s7]}, #{self[:s8]}, #{self[:s9]}, #{self[:sa]}, #{self[:sb]}, #{self[:sc]}, #{self[:sd]}, #{self[:se]}, #{self[:sf]} }"
    end
  end
end

module OpenCL
  # Maps the cl_char type of OpenCL
  class Char1 < Struct
    type = OpenCL.find_type(:cl_char)
    size = type.size
    @size = size * 1
    @layout = OpenCL::StructLayout::new([ OpenCL::StructLayout::Field::new( "s0", size * 0, type ) ], size * 1, size * 1 )
    # Creates a new Char1 with members set to 0 or to the user specified values. If a Pointer is passed as the first argument, Char1 maps the memory pointed.
    def initialize( s0 = 0 )
      if s0.is_a?(FFI::Pointer) then
        super(s0)
      else
        super()
        self[:s0] = s0
      end
    end
    # Reads the s0 member
    def s0
     return self[:s0]
    end
    # Sets the s0 member to value
    def s0=(value)
     self[:s0] = value
    end

    def inspect
      return "#<#{self.class.name}: #{self[:s0]}>"
    end

    def to_s
      return "Char1{ #{self[:s0]} }"
    end
  end
  Char = OpenCL.find_type(:cl_char)
  # Maps the cl_uchar type of OpenCL
  class UChar1 < Struct
    type = OpenCL.find_type(:cl_uchar)
    size = type.size
    @size = size * 1
    @layout = OpenCL::StructLayout::new([ OpenCL::StructLayout::Field::new( "s0", size * 0, type ) ], size * 1, size * 1 )
    # Creates a new UChar1 with members set to 0 or to the user specified values. If a Pointer is passed as the first argument, UChar1 maps the memory pointed.
    def initialize( s0 = 0 )
      if s0.is_a?(FFI::Pointer) then
        super(s0)
      else
        super()
        self[:s0] = s0
      end
    end
    # Reads the s0 member
    def s0
     return self[:s0]
    end
    # Sets the s0 member to value
    def s0=(value)
     self[:s0] = value
    end

    def inspect
      return "#<#{self.class.name}: #{self[:s0]}>"
    end

    def to_s
      return "UChar1{ #{self[:s0]} }"
    end
  end
  UChar = OpenCL.find_type(:cl_uchar)
  # Maps the cl_short type of OpenCL
  class Short1 < Struct
    type = OpenCL.find_type(:cl_short)
    size = type.size
    @size = size * 1
    @layout = OpenCL::StructLayout::new([ OpenCL::StructLayout::Field::new( "s0", size * 0, type ) ], size * 1, size * 1 )
    # Creates a new Short1 with members set to 0 or to the user specified values. If a Pointer is passed as the first argument, Short1 maps the memory pointed.
    def initialize( s0 = 0 )
      if s0.is_a?(FFI::Pointer) then
        super(s0)
      else
        super()
        self[:s0] = s0
      end
    end
    # Reads the s0 member
    def s0
     return self[:s0]
    end
    # Sets the s0 member to value
    def s0=(value)
     self[:s0] = value
    end

    def inspect
      return "#<#{self.class.name}: #{self[:s0]}>"
    end

    def to_s
      return "Short1{ #{self[:s0]} }"
    end
  end
  Short = OpenCL.find_type(:cl_short)
  # Maps the cl_ushort type of OpenCL
  class UShort1 < Struct
    type = OpenCL.find_type(:cl_ushort)
    size = type.size
    @size = size * 1
    @layout = OpenCL::StructLayout::new([ OpenCL::StructLayout::Field::new( "s0", size * 0, type ) ], size * 1, size * 1 )
    # Creates a new UShort1 with members set to 0 or to the user specified values. If a Pointer is passed as the first argument, UShort1 maps the memory pointed.
    def initialize( s0 = 0 )
      if s0.is_a?(FFI::Pointer) then
        super(s0)
      else
        super()
        self[:s0] = s0
      end
    end
    # Reads the s0 member
    def s0
     return self[:s0]
    end
    # Sets the s0 member to value
    def s0=(value)
     self[:s0] = value
    end

    def inspect
      return "#<#{self.class.name}: #{self[:s0]}>"
    end

    def to_s
      return "UShort1{ #{self[:s0]} }"
    end
  end
  UShort = OpenCL.find_type(:cl_ushort)
  # Maps the cl_int type of OpenCL
  class Int1 < Struct
    type = OpenCL.find_type(:cl_int)
    size = type.size
    @size = size * 1
    @layout = OpenCL::StructLayout::new([ OpenCL::StructLayout::Field::new( "s0", size * 0, type ) ], size * 1, size * 1 )
    # Creates a new Int1 with members set to 0 or to the user specified values. If a Pointer is passed as the first argument, Int1 maps the memory pointed.
    def initialize( s0 = 0 )
      if s0.is_a?(FFI::Pointer) then
        super(s0)
      else
        super()
        self[:s0] = s0
      end
    end
    # Reads the s0 member
    def s0
     return self[:s0]
    end
    # Sets the s0 member to value
    def s0=(value)
     self[:s0] = value
    end

    def inspect
      return "#<#{self.class.name}: #{self[:s0]}>"
    end

    def to_s
      return "Int1{ #{self[:s0]} }"
    end
  end
  Int = OpenCL.find_type(:cl_int)
  # Maps the cl_uint type of OpenCL
  class UInt1 < Struct
    type = OpenCL.find_type(:cl_uint)
    size = type.size
    @size = size * 1
    @layout = OpenCL::StructLayout::new([ OpenCL::StructLayout::Field::new( "s0", size * 0, type ) ], size * 1, size * 1 )
    # Creates a new UInt1 with members set to 0 or to the user specified values. If a Pointer is passed as the first argument, UInt1 maps the memory pointed.
    def initialize( s0 = 0 )
      if s0.is_a?(FFI::Pointer) then
        super(s0)
      else
        super()
        self[:s0] = s0
      end
    end
    # Reads the s0 member
    def s0
     return self[:s0]
    end
    # Sets the s0 member to value
    def s0=(value)
     self[:s0] = value
    end

    def inspect
      return "#<#{self.class.name}: #{self[:s0]}>"
    end

    def to_s
      return "UInt1{ #{self[:s0]} }"
    end
  end
  UInt = OpenCL.find_type(:cl_uint)
  # Maps the cl_long type of OpenCL
  class Long1 < Struct
    type = OpenCL.find_type(:cl_long)
    size = type.size
    @size = size * 1
    @layout = OpenCL::StructLayout::new([ OpenCL::StructLayout::Field::new( "s0", size * 0, type ) ], size * 1, size * 1 )
    # Creates a new Long1 with members set to 0 or to the user specified values. If a Pointer is passed as the first argument, Long1 maps the memory pointed.
    def initialize( s0 = 0 )
      if s0.is_a?(FFI::Pointer) then
        super(s0)
      else
        super()
        self[:s0] = s0
      end
    end
    # Reads the s0 member
    def s0
     return self[:s0]
    end
    # Sets the s0 member to value
    def s0=(value)
     self[:s0] = value
    end

    def inspect
      return "#<#{self.class.name}: #{self[:s0]}>"
    end

    def to_s
      return "Long1{ #{self[:s0]} }"
    end
  end
  Long = OpenCL.find_type(:cl_long)
  # Maps the cl_ulong type of OpenCL
  class ULong1 < Struct
    type = OpenCL.find_type(:cl_ulong)
    size = type.size
    @size = size * 1
    @layout = OpenCL::StructLayout::new([ OpenCL::StructLayout::Field::new( "s0", size * 0, type ) ], size * 1, size * 1 )
    # Creates a new ULong1 with members set to 0 or to the user specified values. If a Pointer is passed as the first argument, ULong1 maps the memory pointed.
    def initialize( s0 = 0 )
      if s0.is_a?(FFI::Pointer) then
        super(s0)
      else
        super()
        self[:s0] = s0
      end
    end
    # Reads the s0 member
    def s0
     return self[:s0]
    end
    # Sets the s0 member to value
    def s0=(value)
     self[:s0] = value
    end

    def inspect
      return "#<#{self.class.name}: #{self[:s0]}>"
    end

    def to_s
      return "ULong1{ #{self[:s0]} }"
    end
  end
  ULong = OpenCL.find_type(:cl_ulong)
  # Maps the cl_float type of OpenCL
  class Float1 < Struct
    type = OpenCL.find_type(:cl_float)
    size = type.size
    @size = size * 1
    @layout = OpenCL::StructLayout::new([ OpenCL::StructLayout::Field::new( "s0", size * 0, type ) ], size * 1, size * 1 )
    # Creates a new Float1 with members set to 0 or to the user specified values. If a Pointer is passed as the first argument, Float1 maps the memory pointed.
    def initialize( s0 = 0.0 )
      if s0.is_a?(FFI::Pointer) then
        super(s0)
      else
        super()
        self[:s0] = s0
      end
    end
    # Reads the s0 member
    def s0
     return self[:s0]
    end
    # Sets the s0 member to value
    def s0=(value)
     self[:s0] = value
    end

    def inspect
      return "#<#{self.class.name}: #{self[:s0]}>"
    end

    def to_s
      return "Float1{ #{self[:s0]} }"
    end
  end
  Float = OpenCL.find_type(:cl_float)
  # Maps the cl_double type of OpenCL
  class Double1 < Struct
    type = OpenCL.find_type(:cl_double)
    size = type.size
    @size = size * 1
    @layout = OpenCL::StructLayout::new([ OpenCL::StructLayout::Field::new( "s0", size * 0, type ) ], size * 1, size * 1 )
    # Creates a new Double1 with members set to 0 or to the user specified values. If a Pointer is passed as the first argument, Double1 maps the memory pointed.
    def initialize( s0 = 0.0 )
      if s0.is_a?(FFI::Pointer) then
        super(s0)
      else
        super()
        self[:s0] = s0
      end
    end
    # Reads the s0 member
    def s0
     return self[:s0]
    end
    # Sets the s0 member to value
    def s0=(value)
     self[:s0] = value
    end

    def inspect
      return "#<#{self.class.name}: #{self[:s0]}>"
    end

    def to_s
      return "Double1{ #{self[:s0]} }"
    end
  end
  Double = OpenCL.find_type(:cl_double)
  # Maps the cl_half type of OpenCL
  class Half1 < Struct
    type = OpenCL.find_type(:cl_half)
    size = type.size
    @size = size * 1
    @layout = OpenCL::StructLayout::new([ OpenCL::StructLayout::Field::new( "s0", size * 0, type ) ], size * 1, size * 1 )
    # Creates a new Half1 with members set to 0 or to the user specified values. If a Pointer is passed as the first argument, Half1 maps the memory pointed.
    def initialize( s0 = 0.0 )
      if s0.is_a?(FFI::Pointer) then
        super(s0)
      else
        super()
        self[:s0] = s0
      end
    end
    # Reads the s0 member
    def s0
     return self[:s0]
    end
    # Sets the s0 member to value
    def s0=(value)
     self[:s0] = value
    end

    def inspect
      return "#<#{self.class.name}: #{self[:s0]}>"
    end

    def to_s
      return "Half1{ #{self[:s0]} }"
    end
  end
  Half = OpenCL.find_type(:cl_half)
  # Maps the cl_char2 type of OpenCL
  class Char2 < Struct
    type = OpenCL.find_type(:cl_char)
    size = type.size
    @size = size * 2
    @layout = OpenCL::StructLayout::new([ OpenCL::StructLayout::Field::new( "s0", size * 0, type ), OpenCL::StructLayout::Field::new( "s1", size * 1, type ) ], size * 2, size * 2 )
    # Creates a new Char2 with members set to 0 or to the user specified values. If a Pointer is passed as the first argument, Char2 maps the memory pointed.
    def initialize( s0 = 0, s1 = 0 )
      if s0.is_a?(FFI::Pointer) then
        super(s0)
      else
        super()
        self[:s0] = s0
        self[:s1] = s1
      end
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

    def inspect
      return "#<#{self.class.name}: #{self[:s0]}, #{self[:s1]}>"
    end

    def to_s
      return "Char2{ #{self[:s0]}, #{self[:s1]} }"
    end
  end
  # Maps the cl_uchar2 type of OpenCL
  class UChar2 < Struct
    type = OpenCL.find_type(:cl_uchar)
    size = type.size
    @size = size * 2
    @layout = OpenCL::StructLayout::new([ OpenCL::StructLayout::Field::new( "s0", size * 0, type ), OpenCL::StructLayout::Field::new( "s1", size * 1, type ) ], size * 2, size * 2 )
    # Creates a new UChar2 with members set to 0 or to the user specified values. If a Pointer is passed as the first argument, UChar2 maps the memory pointed.
    def initialize( s0 = 0, s1 = 0 )
      if s0.is_a?(FFI::Pointer) then
        super(s0)
      else
        super()
        self[:s0] = s0
        self[:s1] = s1
      end
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

    def inspect
      return "#<#{self.class.name}: #{self[:s0]}, #{self[:s1]}>"
    end

    def to_s
      return "UChar2{ #{self[:s0]}, #{self[:s1]} }"
    end
  end
  # Maps the cl_short2 type of OpenCL
  class Short2 < Struct
    type = OpenCL.find_type(:cl_short)
    size = type.size
    @size = size * 2
    @layout = OpenCL::StructLayout::new([ OpenCL::StructLayout::Field::new( "s0", size * 0, type ), OpenCL::StructLayout::Field::new( "s1", size * 1, type ) ], size * 2, size * 2 )
    # Creates a new Short2 with members set to 0 or to the user specified values. If a Pointer is passed as the first argument, Short2 maps the memory pointed.
    def initialize( s0 = 0, s1 = 0 )
      if s0.is_a?(FFI::Pointer) then
        super(s0)
      else
        super()
        self[:s0] = s0
        self[:s1] = s1
      end
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

    def inspect
      return "#<#{self.class.name}: #{self[:s0]}, #{self[:s1]}>"
    end

    def to_s
      return "Short2{ #{self[:s0]}, #{self[:s1]} }"
    end
  end
  # Maps the cl_ushort2 type of OpenCL
  class UShort2 < Struct
    type = OpenCL.find_type(:cl_ushort)
    size = type.size
    @size = size * 2
    @layout = OpenCL::StructLayout::new([ OpenCL::StructLayout::Field::new( "s0", size * 0, type ), OpenCL::StructLayout::Field::new( "s1", size * 1, type ) ], size * 2, size * 2 )
    # Creates a new UShort2 with members set to 0 or to the user specified values. If a Pointer is passed as the first argument, UShort2 maps the memory pointed.
    def initialize( s0 = 0, s1 = 0 )
      if s0.is_a?(FFI::Pointer) then
        super(s0)
      else
        super()
        self[:s0] = s0
        self[:s1] = s1
      end
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

    def inspect
      return "#<#{self.class.name}: #{self[:s0]}, #{self[:s1]}>"
    end

    def to_s
      return "UShort2{ #{self[:s0]}, #{self[:s1]} }"
    end
  end
  # Maps the cl_int2 type of OpenCL
  class Int2 < Struct
    type = OpenCL.find_type(:cl_int)
    size = type.size
    @size = size * 2
    @layout = OpenCL::StructLayout::new([ OpenCL::StructLayout::Field::new( "s0", size * 0, type ), OpenCL::StructLayout::Field::new( "s1", size * 1, type ) ], size * 2, size * 2 )
    # Creates a new Int2 with members set to 0 or to the user specified values. If a Pointer is passed as the first argument, Int2 maps the memory pointed.
    def initialize( s0 = 0, s1 = 0 )
      if s0.is_a?(FFI::Pointer) then
        super(s0)
      else
        super()
        self[:s0] = s0
        self[:s1] = s1
      end
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

    def inspect
      return "#<#{self.class.name}: #{self[:s0]}, #{self[:s1]}>"
    end

    def to_s
      return "Int2{ #{self[:s0]}, #{self[:s1]} }"
    end
  end
  # Maps the cl_uint2 type of OpenCL
  class UInt2 < Struct
    type = OpenCL.find_type(:cl_uint)
    size = type.size
    @size = size * 2
    @layout = OpenCL::StructLayout::new([ OpenCL::StructLayout::Field::new( "s0", size * 0, type ), OpenCL::StructLayout::Field::new( "s1", size * 1, type ) ], size * 2, size * 2 )
    # Creates a new UInt2 with members set to 0 or to the user specified values. If a Pointer is passed as the first argument, UInt2 maps the memory pointed.
    def initialize( s0 = 0, s1 = 0 )
      if s0.is_a?(FFI::Pointer) then
        super(s0)
      else
        super()
        self[:s0] = s0
        self[:s1] = s1
      end
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

    def inspect
      return "#<#{self.class.name}: #{self[:s0]}, #{self[:s1]}>"
    end

    def to_s
      return "UInt2{ #{self[:s0]}, #{self[:s1]} }"
    end
  end
  # Maps the cl_long2 type of OpenCL
  class Long2 < Struct
    type = OpenCL.find_type(:cl_long)
    size = type.size
    @size = size * 2
    @layout = OpenCL::StructLayout::new([ OpenCL::StructLayout::Field::new( "s0", size * 0, type ), OpenCL::StructLayout::Field::new( "s1", size * 1, type ) ], size * 2, size * 2 )
    # Creates a new Long2 with members set to 0 or to the user specified values. If a Pointer is passed as the first argument, Long2 maps the memory pointed.
    def initialize( s0 = 0, s1 = 0 )
      if s0.is_a?(FFI::Pointer) then
        super(s0)
      else
        super()
        self[:s0] = s0
        self[:s1] = s1
      end
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

    def inspect
      return "#<#{self.class.name}: #{self[:s0]}, #{self[:s1]}>"
    end

    def to_s
      return "Long2{ #{self[:s0]}, #{self[:s1]} }"
    end
  end
  # Maps the cl_ulong2 type of OpenCL
  class ULong2 < Struct
    type = OpenCL.find_type(:cl_ulong)
    size = type.size
    @size = size * 2
    @layout = OpenCL::StructLayout::new([ OpenCL::StructLayout::Field::new( "s0", size * 0, type ), OpenCL::StructLayout::Field::new( "s1", size * 1, type ) ], size * 2, size * 2 )
    # Creates a new ULong2 with members set to 0 or to the user specified values. If a Pointer is passed as the first argument, ULong2 maps the memory pointed.
    def initialize( s0 = 0, s1 = 0 )
      if s0.is_a?(FFI::Pointer) then
        super(s0)
      else
        super()
        self[:s0] = s0
        self[:s1] = s1
      end
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

    def inspect
      return "#<#{self.class.name}: #{self[:s0]}, #{self[:s1]}>"
    end

    def to_s
      return "ULong2{ #{self[:s0]}, #{self[:s1]} }"
    end
  end
  # Maps the cl_float2 type of OpenCL
  class Float2 < Struct
    type = OpenCL.find_type(:cl_float)
    size = type.size
    @size = size * 2
    @layout = OpenCL::StructLayout::new([ OpenCL::StructLayout::Field::new( "s0", size * 0, type ), OpenCL::StructLayout::Field::new( "s1", size * 1, type ) ], size * 2, size * 2 )
    # Creates a new Float2 with members set to 0 or to the user specified values. If a Pointer is passed as the first argument, Float2 maps the memory pointed.
    def initialize( s0 = 0.0, s1 = 0.0 )
      if s0.is_a?(FFI::Pointer) then
        super(s0)
      else
        super()
        self[:s0] = s0
        self[:s1] = s1
      end
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

    def inspect
      return "#<#{self.class.name}: #{self[:s0]}, #{self[:s1]}>"
    end

    def to_s
      return "Float2{ #{self[:s0]}, #{self[:s1]} }"
    end
  end
  # Maps the cl_double2 type of OpenCL
  class Double2 < Struct
    type = OpenCL.find_type(:cl_double)
    size = type.size
    @size = size * 2
    @layout = OpenCL::StructLayout::new([ OpenCL::StructLayout::Field::new( "s0", size * 0, type ), OpenCL::StructLayout::Field::new( "s1", size * 1, type ) ], size * 2, size * 2 )
    # Creates a new Double2 with members set to 0 or to the user specified values. If a Pointer is passed as the first argument, Double2 maps the memory pointed.
    def initialize( s0 = 0.0, s1 = 0.0 )
      if s0.is_a?(FFI::Pointer) then
        super(s0)
      else
        super()
        self[:s0] = s0
        self[:s1] = s1
      end
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

    def inspect
      return "#<#{self.class.name}: #{self[:s0]}, #{self[:s1]}>"
    end

    def to_s
      return "Double2{ #{self[:s0]}, #{self[:s1]} }"
    end
  end
  # Maps the cl_half2 type of OpenCL
  class Half2 < Struct
    type = OpenCL.find_type(:cl_half)
    size = type.size
    @size = size * 2
    @layout = OpenCL::StructLayout::new([ OpenCL::StructLayout::Field::new( "s0", size * 0, type ), OpenCL::StructLayout::Field::new( "s1", size * 1, type ) ], size * 2, size * 2 )
    # Creates a new Half2 with members set to 0 or to the user specified values. If a Pointer is passed as the first argument, Half2 maps the memory pointed.
    def initialize( s0 = 0.0, s1 = 0.0 )
      if s0.is_a?(FFI::Pointer) then
        super(s0)
      else
        super()
        self[:s0] = s0
        self[:s1] = s1
      end
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

    def inspect
      return "#<#{self.class.name}: #{self[:s0]}, #{self[:s1]}>"
    end

    def to_s
      return "Half2{ #{self[:s0]}, #{self[:s1]} }"
    end
  end
  # Maps the cl_char4 type of OpenCL
  class Char4 < Struct
    type = OpenCL.find_type(:cl_char)
    size = type.size
    @size = size * 4
    @layout = OpenCL::StructLayout::new([ OpenCL::StructLayout::Field::new( "s0", size * 0, type ), OpenCL::StructLayout::Field::new( "s1", size * 1, type ), OpenCL::StructLayout::Field::new( "s2", size * 2, type ), OpenCL::StructLayout::Field::new( "s3", size * 3, type ) ], size * 4, size * 4 )
    # Creates a new Char4 with members set to 0 or to the user specified values. If a Pointer is passed as the first argument, Char4 maps the memory pointed.
    def initialize( s0 = 0, s1 = 0, s2 = 0, s3 = 0 )
      if s0.is_a?(FFI::Pointer) then
        super(s0)
      else
        super()
        self[:s0] = s0
        self[:s1] = s1
        self[:s2] = s2
        self[:s3] = s3
      end
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

    def inspect
      return "#<#{self.class.name}: #{self[:s0]}, #{self[:s1]}, #{self[:s2]}, #{self[:s3]}>"
    end

    def to_s
      return "Char4{ #{self[:s0]}, #{self[:s1]}, #{self[:s2]}, #{self[:s3]} }"
    end
  end
  # Maps the cl_uchar4 type of OpenCL
  class UChar4 < Struct
    type = OpenCL.find_type(:cl_uchar)
    size = type.size
    @size = size * 4
    @layout = OpenCL::StructLayout::new([ OpenCL::StructLayout::Field::new( "s0", size * 0, type ), OpenCL::StructLayout::Field::new( "s1", size * 1, type ), OpenCL::StructLayout::Field::new( "s2", size * 2, type ), OpenCL::StructLayout::Field::new( "s3", size * 3, type ) ], size * 4, size * 4 )
    # Creates a new UChar4 with members set to 0 or to the user specified values. If a Pointer is passed as the first argument, UChar4 maps the memory pointed.
    def initialize( s0 = 0, s1 = 0, s2 = 0, s3 = 0 )
      if s0.is_a?(FFI::Pointer) then
        super(s0)
      else
        super()
        self[:s0] = s0
        self[:s1] = s1
        self[:s2] = s2
        self[:s3] = s3
      end
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

    def inspect
      return "#<#{self.class.name}: #{self[:s0]}, #{self[:s1]}, #{self[:s2]}, #{self[:s3]}>"
    end

    def to_s
      return "UChar4{ #{self[:s0]}, #{self[:s1]}, #{self[:s2]}, #{self[:s3]} }"
    end
  end
  # Maps the cl_short4 type of OpenCL
  class Short4 < Struct
    type = OpenCL.find_type(:cl_short)
    size = type.size
    @size = size * 4
    @layout = OpenCL::StructLayout::new([ OpenCL::StructLayout::Field::new( "s0", size * 0, type ), OpenCL::StructLayout::Field::new( "s1", size * 1, type ), OpenCL::StructLayout::Field::new( "s2", size * 2, type ), OpenCL::StructLayout::Field::new( "s3", size * 3, type ) ], size * 4, size * 4 )
    # Creates a new Short4 with members set to 0 or to the user specified values. If a Pointer is passed as the first argument, Short4 maps the memory pointed.
    def initialize( s0 = 0, s1 = 0, s2 = 0, s3 = 0 )
      if s0.is_a?(FFI::Pointer) then
        super(s0)
      else
        super()
        self[:s0] = s0
        self[:s1] = s1
        self[:s2] = s2
        self[:s3] = s3
      end
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

    def inspect
      return "#<#{self.class.name}: #{self[:s0]}, #{self[:s1]}, #{self[:s2]}, #{self[:s3]}>"
    end

    def to_s
      return "Short4{ #{self[:s0]}, #{self[:s1]}, #{self[:s2]}, #{self[:s3]} }"
    end
  end
  # Maps the cl_ushort4 type of OpenCL
  class UShort4 < Struct
    type = OpenCL.find_type(:cl_ushort)
    size = type.size
    @size = size * 4
    @layout = OpenCL::StructLayout::new([ OpenCL::StructLayout::Field::new( "s0", size * 0, type ), OpenCL::StructLayout::Field::new( "s1", size * 1, type ), OpenCL::StructLayout::Field::new( "s2", size * 2, type ), OpenCL::StructLayout::Field::new( "s3", size * 3, type ) ], size * 4, size * 4 )
    # Creates a new UShort4 with members set to 0 or to the user specified values. If a Pointer is passed as the first argument, UShort4 maps the memory pointed.
    def initialize( s0 = 0, s1 = 0, s2 = 0, s3 = 0 )
      if s0.is_a?(FFI::Pointer) then
        super(s0)
      else
        super()
        self[:s0] = s0
        self[:s1] = s1
        self[:s2] = s2
        self[:s3] = s3
      end
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

    def inspect
      return "#<#{self.class.name}: #{self[:s0]}, #{self[:s1]}, #{self[:s2]}, #{self[:s3]}>"
    end

    def to_s
      return "UShort4{ #{self[:s0]}, #{self[:s1]}, #{self[:s2]}, #{self[:s3]} }"
    end
  end
  # Maps the cl_int4 type of OpenCL
  class Int4 < Struct
    type = OpenCL.find_type(:cl_int)
    size = type.size
    @size = size * 4
    @layout = OpenCL::StructLayout::new([ OpenCL::StructLayout::Field::new( "s0", size * 0, type ), OpenCL::StructLayout::Field::new( "s1", size * 1, type ), OpenCL::StructLayout::Field::new( "s2", size * 2, type ), OpenCL::StructLayout::Field::new( "s3", size * 3, type ) ], size * 4, size * 4 )
    # Creates a new Int4 with members set to 0 or to the user specified values. If a Pointer is passed as the first argument, Int4 maps the memory pointed.
    def initialize( s0 = 0, s1 = 0, s2 = 0, s3 = 0 )
      if s0.is_a?(FFI::Pointer) then
        super(s0)
      else
        super()
        self[:s0] = s0
        self[:s1] = s1
        self[:s2] = s2
        self[:s3] = s3
      end
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

    def inspect
      return "#<#{self.class.name}: #{self[:s0]}, #{self[:s1]}, #{self[:s2]}, #{self[:s3]}>"
    end

    def to_s
      return "Int4{ #{self[:s0]}, #{self[:s1]}, #{self[:s2]}, #{self[:s3]} }"
    end
  end
  # Maps the cl_uint4 type of OpenCL
  class UInt4 < Struct
    type = OpenCL.find_type(:cl_uint)
    size = type.size
    @size = size * 4
    @layout = OpenCL::StructLayout::new([ OpenCL::StructLayout::Field::new( "s0", size * 0, type ), OpenCL::StructLayout::Field::new( "s1", size * 1, type ), OpenCL::StructLayout::Field::new( "s2", size * 2, type ), OpenCL::StructLayout::Field::new( "s3", size * 3, type ) ], size * 4, size * 4 )
    # Creates a new UInt4 with members set to 0 or to the user specified values. If a Pointer is passed as the first argument, UInt4 maps the memory pointed.
    def initialize( s0 = 0, s1 = 0, s2 = 0, s3 = 0 )
      if s0.is_a?(FFI::Pointer) then
        super(s0)
      else
        super()
        self[:s0] = s0
        self[:s1] = s1
        self[:s2] = s2
        self[:s3] = s3
      end
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

    def inspect
      return "#<#{self.class.name}: #{self[:s0]}, #{self[:s1]}, #{self[:s2]}, #{self[:s3]}>"
    end

    def to_s
      return "UInt4{ #{self[:s0]}, #{self[:s1]}, #{self[:s2]}, #{self[:s3]} }"
    end
  end
  # Maps the cl_long4 type of OpenCL
  class Long4 < Struct
    type = OpenCL.find_type(:cl_long)
    size = type.size
    @size = size * 4
    @layout = OpenCL::StructLayout::new([ OpenCL::StructLayout::Field::new( "s0", size * 0, type ), OpenCL::StructLayout::Field::new( "s1", size * 1, type ), OpenCL::StructLayout::Field::new( "s2", size * 2, type ), OpenCL::StructLayout::Field::new( "s3", size * 3, type ) ], size * 4, size * 4 )
    # Creates a new Long4 with members set to 0 or to the user specified values. If a Pointer is passed as the first argument, Long4 maps the memory pointed.
    def initialize( s0 = 0, s1 = 0, s2 = 0, s3 = 0 )
      if s0.is_a?(FFI::Pointer) then
        super(s0)
      else
        super()
        self[:s0] = s0
        self[:s1] = s1
        self[:s2] = s2
        self[:s3] = s3
      end
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

    def inspect
      return "#<#{self.class.name}: #{self[:s0]}, #{self[:s1]}, #{self[:s2]}, #{self[:s3]}>"
    end

    def to_s
      return "Long4{ #{self[:s0]}, #{self[:s1]}, #{self[:s2]}, #{self[:s3]} }"
    end
  end
  # Maps the cl_ulong4 type of OpenCL
  class ULong4 < Struct
    type = OpenCL.find_type(:cl_ulong)
    size = type.size
    @size = size * 4
    @layout = OpenCL::StructLayout::new([ OpenCL::StructLayout::Field::new( "s0", size * 0, type ), OpenCL::StructLayout::Field::new( "s1", size * 1, type ), OpenCL::StructLayout::Field::new( "s2", size * 2, type ), OpenCL::StructLayout::Field::new( "s3", size * 3, type ) ], size * 4, size * 4 )
    # Creates a new ULong4 with members set to 0 or to the user specified values. If a Pointer is passed as the first argument, ULong4 maps the memory pointed.
    def initialize( s0 = 0, s1 = 0, s2 = 0, s3 = 0 )
      if s0.is_a?(FFI::Pointer) then
        super(s0)
      else
        super()
        self[:s0] = s0
        self[:s1] = s1
        self[:s2] = s2
        self[:s3] = s3
      end
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

    def inspect
      return "#<#{self.class.name}: #{self[:s0]}, #{self[:s1]}, #{self[:s2]}, #{self[:s3]}>"
    end

    def to_s
      return "ULong4{ #{self[:s0]}, #{self[:s1]}, #{self[:s2]}, #{self[:s3]} }"
    end
  end
  # Maps the cl_float4 type of OpenCL
  class Float4 < Struct
    type = OpenCL.find_type(:cl_float)
    size = type.size
    @size = size * 4
    @layout = OpenCL::StructLayout::new([ OpenCL::StructLayout::Field::new( "s0", size * 0, type ), OpenCL::StructLayout::Field::new( "s1", size * 1, type ), OpenCL::StructLayout::Field::new( "s2", size * 2, type ), OpenCL::StructLayout::Field::new( "s3", size * 3, type ) ], size * 4, size * 4 )
    # Creates a new Float4 with members set to 0 or to the user specified values. If a Pointer is passed as the first argument, Float4 maps the memory pointed.
    def initialize( s0 = 0.0, s1 = 0.0, s2 = 0.0, s3 = 0.0 )
      if s0.is_a?(FFI::Pointer) then
        super(s0)
      else
        super()
        self[:s0] = s0
        self[:s1] = s1
        self[:s2] = s2
        self[:s3] = s3
      end
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

    def inspect
      return "#<#{self.class.name}: #{self[:s0]}, #{self[:s1]}, #{self[:s2]}, #{self[:s3]}>"
    end

    def to_s
      return "Float4{ #{self[:s0]}, #{self[:s1]}, #{self[:s2]}, #{self[:s3]} }"
    end
  end
  # Maps the cl_double4 type of OpenCL
  class Double4 < Struct
    type = OpenCL.find_type(:cl_double)
    size = type.size
    @size = size * 4
    @layout = OpenCL::StructLayout::new([ OpenCL::StructLayout::Field::new( "s0", size * 0, type ), OpenCL::StructLayout::Field::new( "s1", size * 1, type ), OpenCL::StructLayout::Field::new( "s2", size * 2, type ), OpenCL::StructLayout::Field::new( "s3", size * 3, type ) ], size * 4, size * 4 )
    # Creates a new Double4 with members set to 0 or to the user specified values. If a Pointer is passed as the first argument, Double4 maps the memory pointed.
    def initialize( s0 = 0.0, s1 = 0.0, s2 = 0.0, s3 = 0.0 )
      if s0.is_a?(FFI::Pointer) then
        super(s0)
      else
        super()
        self[:s0] = s0
        self[:s1] = s1
        self[:s2] = s2
        self[:s3] = s3
      end
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

    def inspect
      return "#<#{self.class.name}: #{self[:s0]}, #{self[:s1]}, #{self[:s2]}, #{self[:s3]}>"
    end

    def to_s
      return "Double4{ #{self[:s0]}, #{self[:s1]}, #{self[:s2]}, #{self[:s3]} }"
    end
  end
  # Maps the cl_half4 type of OpenCL
  class Half4 < Struct
    type = OpenCL.find_type(:cl_half)
    size = type.size
    @size = size * 4
    @layout = OpenCL::StructLayout::new([ OpenCL::StructLayout::Field::new( "s0", size * 0, type ), OpenCL::StructLayout::Field::new( "s1", size * 1, type ), OpenCL::StructLayout::Field::new( "s2", size * 2, type ), OpenCL::StructLayout::Field::new( "s3", size * 3, type ) ], size * 4, size * 4 )
    # Creates a new Half4 with members set to 0 or to the user specified values. If a Pointer is passed as the first argument, Half4 maps the memory pointed.
    def initialize( s0 = 0.0, s1 = 0.0, s2 = 0.0, s3 = 0.0 )
      if s0.is_a?(FFI::Pointer) then
        super(s0)
      else
        super()
        self[:s0] = s0
        self[:s1] = s1
        self[:s2] = s2
        self[:s3] = s3
      end
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

    def inspect
      return "#<#{self.class.name}: #{self[:s0]}, #{self[:s1]}, #{self[:s2]}, #{self[:s3]}>"
    end

    def to_s
      return "Half4{ #{self[:s0]}, #{self[:s1]}, #{self[:s2]}, #{self[:s3]} }"
    end
  end
  # Maps the cl_char8 type of OpenCL
  class Char8 < Struct
    type = OpenCL.find_type(:cl_char)
    size = type.size
    @size = size * 8
    @layout = OpenCL::StructLayout::new([ OpenCL::StructLayout::Field::new( "s0", size * 0, type ), OpenCL::StructLayout::Field::new( "s1", size * 1, type ), OpenCL::StructLayout::Field::new( "s2", size * 2, type ), OpenCL::StructLayout::Field::new( "s3", size * 3, type ), OpenCL::StructLayout::Field::new( "s4", size * 4, type ), OpenCL::StructLayout::Field::new( "s5", size * 5, type ), OpenCL::StructLayout::Field::new( "s6", size * 6, type ), OpenCL::StructLayout::Field::new( "s7", size * 7, type ) ], size * 8, size * 8 )
    # Creates a new Char8 with members set to 0 or to the user specified values. If a Pointer is passed as the first argument, Char8 maps the memory pointed.
    def initialize( s0 = 0, s1 = 0, s2 = 0, s3 = 0, s4 = 0, s5 = 0, s6 = 0, s7 = 0 )
      if s0.is_a?(FFI::Pointer) then
        super(s0)
      else
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

    def inspect
      return "#<#{self.class.name}: #{self[:s0]}, #{self[:s1]}, #{self[:s2]}, #{self[:s3]}, #{self[:s4]}, #{self[:s5]}, #{self[:s6]}, #{self[:s7]}>"
    end

    def to_s
      return "Char8{ #{self[:s0]}, #{self[:s1]}, #{self[:s2]}, #{self[:s3]}, #{self[:s4]}, #{self[:s5]}, #{self[:s6]}, #{self[:s7]} }"
    end
  end
  # Maps the cl_uchar8 type of OpenCL
  class UChar8 < Struct
    type = OpenCL.find_type(:cl_uchar)
    size = type.size
    @size = size * 8
    @layout = OpenCL::StructLayout::new([ OpenCL::StructLayout::Field::new( "s0", size * 0, type ), OpenCL::StructLayout::Field::new( "s1", size * 1, type ), OpenCL::StructLayout::Field::new( "s2", size * 2, type ), OpenCL::StructLayout::Field::new( "s3", size * 3, type ), OpenCL::StructLayout::Field::new( "s4", size * 4, type ), OpenCL::StructLayout::Field::new( "s5", size * 5, type ), OpenCL::StructLayout::Field::new( "s6", size * 6, type ), OpenCL::StructLayout::Field::new( "s7", size * 7, type ) ], size * 8, size * 8 )
    # Creates a new UChar8 with members set to 0 or to the user specified values. If a Pointer is passed as the first argument, UChar8 maps the memory pointed.
    def initialize( s0 = 0, s1 = 0, s2 = 0, s3 = 0, s4 = 0, s5 = 0, s6 = 0, s7 = 0 )
      if s0.is_a?(FFI::Pointer) then
        super(s0)
      else
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

    def inspect
      return "#<#{self.class.name}: #{self[:s0]}, #{self[:s1]}, #{self[:s2]}, #{self[:s3]}, #{self[:s4]}, #{self[:s5]}, #{self[:s6]}, #{self[:s7]}>"
    end

    def to_s
      return "UChar8{ #{self[:s0]}, #{self[:s1]}, #{self[:s2]}, #{self[:s3]}, #{self[:s4]}, #{self[:s5]}, #{self[:s6]}, #{self[:s7]} }"
    end
  end
  # Maps the cl_short8 type of OpenCL
  class Short8 < Struct
    type = OpenCL.find_type(:cl_short)
    size = type.size
    @size = size * 8
    @layout = OpenCL::StructLayout::new([ OpenCL::StructLayout::Field::new( "s0", size * 0, type ), OpenCL::StructLayout::Field::new( "s1", size * 1, type ), OpenCL::StructLayout::Field::new( "s2", size * 2, type ), OpenCL::StructLayout::Field::new( "s3", size * 3, type ), OpenCL::StructLayout::Field::new( "s4", size * 4, type ), OpenCL::StructLayout::Field::new( "s5", size * 5, type ), OpenCL::StructLayout::Field::new( "s6", size * 6, type ), OpenCL::StructLayout::Field::new( "s7", size * 7, type ) ], size * 8, size * 8 )
    # Creates a new Short8 with members set to 0 or to the user specified values. If a Pointer is passed as the first argument, Short8 maps the memory pointed.
    def initialize( s0 = 0, s1 = 0, s2 = 0, s3 = 0, s4 = 0, s5 = 0, s6 = 0, s7 = 0 )
      if s0.is_a?(FFI::Pointer) then
        super(s0)
      else
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

    def inspect
      return "#<#{self.class.name}: #{self[:s0]}, #{self[:s1]}, #{self[:s2]}, #{self[:s3]}, #{self[:s4]}, #{self[:s5]}, #{self[:s6]}, #{self[:s7]}>"
    end

    def to_s
      return "Short8{ #{self[:s0]}, #{self[:s1]}, #{self[:s2]}, #{self[:s3]}, #{self[:s4]}, #{self[:s5]}, #{self[:s6]}, #{self[:s7]} }"
    end
  end
  # Maps the cl_ushort8 type of OpenCL
  class UShort8 < Struct
    type = OpenCL.find_type(:cl_ushort)
    size = type.size
    @size = size * 8
    @layout = OpenCL::StructLayout::new([ OpenCL::StructLayout::Field::new( "s0", size * 0, type ), OpenCL::StructLayout::Field::new( "s1", size * 1, type ), OpenCL::StructLayout::Field::new( "s2", size * 2, type ), OpenCL::StructLayout::Field::new( "s3", size * 3, type ), OpenCL::StructLayout::Field::new( "s4", size * 4, type ), OpenCL::StructLayout::Field::new( "s5", size * 5, type ), OpenCL::StructLayout::Field::new( "s6", size * 6, type ), OpenCL::StructLayout::Field::new( "s7", size * 7, type ) ], size * 8, size * 8 )
    # Creates a new UShort8 with members set to 0 or to the user specified values. If a Pointer is passed as the first argument, UShort8 maps the memory pointed.
    def initialize( s0 = 0, s1 = 0, s2 = 0, s3 = 0, s4 = 0, s5 = 0, s6 = 0, s7 = 0 )
      if s0.is_a?(FFI::Pointer) then
        super(s0)
      else
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

    def inspect
      return "#<#{self.class.name}: #{self[:s0]}, #{self[:s1]}, #{self[:s2]}, #{self[:s3]}, #{self[:s4]}, #{self[:s5]}, #{self[:s6]}, #{self[:s7]}>"
    end

    def to_s
      return "UShort8{ #{self[:s0]}, #{self[:s1]}, #{self[:s2]}, #{self[:s3]}, #{self[:s4]}, #{self[:s5]}, #{self[:s6]}, #{self[:s7]} }"
    end
  end
  # Maps the cl_int8 type of OpenCL
  class Int8 < Struct
    type = OpenCL.find_type(:cl_int)
    size = type.size
    @size = size * 8
    @layout = OpenCL::StructLayout::new([ OpenCL::StructLayout::Field::new( "s0", size * 0, type ), OpenCL::StructLayout::Field::new( "s1", size * 1, type ), OpenCL::StructLayout::Field::new( "s2", size * 2, type ), OpenCL::StructLayout::Field::new( "s3", size * 3, type ), OpenCL::StructLayout::Field::new( "s4", size * 4, type ), OpenCL::StructLayout::Field::new( "s5", size * 5, type ), OpenCL::StructLayout::Field::new( "s6", size * 6, type ), OpenCL::StructLayout::Field::new( "s7", size * 7, type ) ], size * 8, size * 8 )
    # Creates a new Int8 with members set to 0 or to the user specified values. If a Pointer is passed as the first argument, Int8 maps the memory pointed.
    def initialize( s0 = 0, s1 = 0, s2 = 0, s3 = 0, s4 = 0, s5 = 0, s6 = 0, s7 = 0 )
      if s0.is_a?(FFI::Pointer) then
        super(s0)
      else
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

    def inspect
      return "#<#{self.class.name}: #{self[:s0]}, #{self[:s1]}, #{self[:s2]}, #{self[:s3]}, #{self[:s4]}, #{self[:s5]}, #{self[:s6]}, #{self[:s7]}>"
    end

    def to_s
      return "Int8{ #{self[:s0]}, #{self[:s1]}, #{self[:s2]}, #{self[:s3]}, #{self[:s4]}, #{self[:s5]}, #{self[:s6]}, #{self[:s7]} }"
    end
  end
  # Maps the cl_uint8 type of OpenCL
  class UInt8 < Struct
    type = OpenCL.find_type(:cl_uint)
    size = type.size
    @size = size * 8
    @layout = OpenCL::StructLayout::new([ OpenCL::StructLayout::Field::new( "s0", size * 0, type ), OpenCL::StructLayout::Field::new( "s1", size * 1, type ), OpenCL::StructLayout::Field::new( "s2", size * 2, type ), OpenCL::StructLayout::Field::new( "s3", size * 3, type ), OpenCL::StructLayout::Field::new( "s4", size * 4, type ), OpenCL::StructLayout::Field::new( "s5", size * 5, type ), OpenCL::StructLayout::Field::new( "s6", size * 6, type ), OpenCL::StructLayout::Field::new( "s7", size * 7, type ) ], size * 8, size * 8 )
    # Creates a new UInt8 with members set to 0 or to the user specified values. If a Pointer is passed as the first argument, UInt8 maps the memory pointed.
    def initialize( s0 = 0, s1 = 0, s2 = 0, s3 = 0, s4 = 0, s5 = 0, s6 = 0, s7 = 0 )
      if s0.is_a?(FFI::Pointer) then
        super(s0)
      else
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

    def inspect
      return "#<#{self.class.name}: #{self[:s0]}, #{self[:s1]}, #{self[:s2]}, #{self[:s3]}, #{self[:s4]}, #{self[:s5]}, #{self[:s6]}, #{self[:s7]}>"
    end

    def to_s
      return "UInt8{ #{self[:s0]}, #{self[:s1]}, #{self[:s2]}, #{self[:s3]}, #{self[:s4]}, #{self[:s5]}, #{self[:s6]}, #{self[:s7]} }"
    end
  end
  # Maps the cl_long8 type of OpenCL
  class Long8 < Struct
    type = OpenCL.find_type(:cl_long)
    size = type.size
    @size = size * 8
    @layout = OpenCL::StructLayout::new([ OpenCL::StructLayout::Field::new( "s0", size * 0, type ), OpenCL::StructLayout::Field::new( "s1", size * 1, type ), OpenCL::StructLayout::Field::new( "s2", size * 2, type ), OpenCL::StructLayout::Field::new( "s3", size * 3, type ), OpenCL::StructLayout::Field::new( "s4", size * 4, type ), OpenCL::StructLayout::Field::new( "s5", size * 5, type ), OpenCL::StructLayout::Field::new( "s6", size * 6, type ), OpenCL::StructLayout::Field::new( "s7", size * 7, type ) ], size * 8, size * 8 )
    # Creates a new Long8 with members set to 0 or to the user specified values. If a Pointer is passed as the first argument, Long8 maps the memory pointed.
    def initialize( s0 = 0, s1 = 0, s2 = 0, s3 = 0, s4 = 0, s5 = 0, s6 = 0, s7 = 0 )
      if s0.is_a?(FFI::Pointer) then
        super(s0)
      else
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

    def inspect
      return "#<#{self.class.name}: #{self[:s0]}, #{self[:s1]}, #{self[:s2]}, #{self[:s3]}, #{self[:s4]}, #{self[:s5]}, #{self[:s6]}, #{self[:s7]}>"
    end

    def to_s
      return "Long8{ #{self[:s0]}, #{self[:s1]}, #{self[:s2]}, #{self[:s3]}, #{self[:s4]}, #{self[:s5]}, #{self[:s6]}, #{self[:s7]} }"
    end
  end
  # Maps the cl_ulong8 type of OpenCL
  class ULong8 < Struct
    type = OpenCL.find_type(:cl_ulong)
    size = type.size
    @size = size * 8
    @layout = OpenCL::StructLayout::new([ OpenCL::StructLayout::Field::new( "s0", size * 0, type ), OpenCL::StructLayout::Field::new( "s1", size * 1, type ), OpenCL::StructLayout::Field::new( "s2", size * 2, type ), OpenCL::StructLayout::Field::new( "s3", size * 3, type ), OpenCL::StructLayout::Field::new( "s4", size * 4, type ), OpenCL::StructLayout::Field::new( "s5", size * 5, type ), OpenCL::StructLayout::Field::new( "s6", size * 6, type ), OpenCL::StructLayout::Field::new( "s7", size * 7, type ) ], size * 8, size * 8 )
    # Creates a new ULong8 with members set to 0 or to the user specified values. If a Pointer is passed as the first argument, ULong8 maps the memory pointed.
    def initialize( s0 = 0, s1 = 0, s2 = 0, s3 = 0, s4 = 0, s5 = 0, s6 = 0, s7 = 0 )
      if s0.is_a?(FFI::Pointer) then
        super(s0)
      else
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

    def inspect
      return "#<#{self.class.name}: #{self[:s0]}, #{self[:s1]}, #{self[:s2]}, #{self[:s3]}, #{self[:s4]}, #{self[:s5]}, #{self[:s6]}, #{self[:s7]}>"
    end

    def to_s
      return "ULong8{ #{self[:s0]}, #{self[:s1]}, #{self[:s2]}, #{self[:s3]}, #{self[:s4]}, #{self[:s5]}, #{self[:s6]}, #{self[:s7]} }"
    end
  end
  # Maps the cl_float8 type of OpenCL
  class Float8 < Struct
    type = OpenCL.find_type(:cl_float)
    size = type.size
    @size = size * 8
    @layout = OpenCL::StructLayout::new([ OpenCL::StructLayout::Field::new( "s0", size * 0, type ), OpenCL::StructLayout::Field::new( "s1", size * 1, type ), OpenCL::StructLayout::Field::new( "s2", size * 2, type ), OpenCL::StructLayout::Field::new( "s3", size * 3, type ), OpenCL::StructLayout::Field::new( "s4", size * 4, type ), OpenCL::StructLayout::Field::new( "s5", size * 5, type ), OpenCL::StructLayout::Field::new( "s6", size * 6, type ), OpenCL::StructLayout::Field::new( "s7", size * 7, type ) ], size * 8, size * 8 )
    # Creates a new Float8 with members set to 0 or to the user specified values. If a Pointer is passed as the first argument, Float8 maps the memory pointed.
    def initialize( s0 = 0.0, s1 = 0.0, s2 = 0.0, s3 = 0.0, s4 = 0.0, s5 = 0.0, s6 = 0.0, s7 = 0.0 )
      if s0.is_a?(FFI::Pointer) then
        super(s0)
      else
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

    def inspect
      return "#<#{self.class.name}: #{self[:s0]}, #{self[:s1]}, #{self[:s2]}, #{self[:s3]}, #{self[:s4]}, #{self[:s5]}, #{self[:s6]}, #{self[:s7]}>"
    end

    def to_s
      return "Float8{ #{self[:s0]}, #{self[:s1]}, #{self[:s2]}, #{self[:s3]}, #{self[:s4]}, #{self[:s5]}, #{self[:s6]}, #{self[:s7]} }"
    end
  end
  # Maps the cl_double8 type of OpenCL
  class Double8 < Struct
    type = OpenCL.find_type(:cl_double)
    size = type.size
    @size = size * 8
    @layout = OpenCL::StructLayout::new([ OpenCL::StructLayout::Field::new( "s0", size * 0, type ), OpenCL::StructLayout::Field::new( "s1", size * 1, type ), OpenCL::StructLayout::Field::new( "s2", size * 2, type ), OpenCL::StructLayout::Field::new( "s3", size * 3, type ), OpenCL::StructLayout::Field::new( "s4", size * 4, type ), OpenCL::StructLayout::Field::new( "s5", size * 5, type ), OpenCL::StructLayout::Field::new( "s6", size * 6, type ), OpenCL::StructLayout::Field::new( "s7", size * 7, type ) ], size * 8, size * 8 )
    # Creates a new Double8 with members set to 0 or to the user specified values. If a Pointer is passed as the first argument, Double8 maps the memory pointed.
    def initialize( s0 = 0.0, s1 = 0.0, s2 = 0.0, s3 = 0.0, s4 = 0.0, s5 = 0.0, s6 = 0.0, s7 = 0.0 )
      if s0.is_a?(FFI::Pointer) then
        super(s0)
      else
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

    def inspect
      return "#<#{self.class.name}: #{self[:s0]}, #{self[:s1]}, #{self[:s2]}, #{self[:s3]}, #{self[:s4]}, #{self[:s5]}, #{self[:s6]}, #{self[:s7]}>"
    end

    def to_s
      return "Double8{ #{self[:s0]}, #{self[:s1]}, #{self[:s2]}, #{self[:s3]}, #{self[:s4]}, #{self[:s5]}, #{self[:s6]}, #{self[:s7]} }"
    end
  end
  # Maps the cl_half8 type of OpenCL
  class Half8 < Struct
    type = OpenCL.find_type(:cl_half)
    size = type.size
    @size = size * 8
    @layout = OpenCL::StructLayout::new([ OpenCL::StructLayout::Field::new( "s0", size * 0, type ), OpenCL::StructLayout::Field::new( "s1", size * 1, type ), OpenCL::StructLayout::Field::new( "s2", size * 2, type ), OpenCL::StructLayout::Field::new( "s3", size * 3, type ), OpenCL::StructLayout::Field::new( "s4", size * 4, type ), OpenCL::StructLayout::Field::new( "s5", size * 5, type ), OpenCL::StructLayout::Field::new( "s6", size * 6, type ), OpenCL::StructLayout::Field::new( "s7", size * 7, type ) ], size * 8, size * 8 )
    # Creates a new Half8 with members set to 0 or to the user specified values. If a Pointer is passed as the first argument, Half8 maps the memory pointed.
    def initialize( s0 = 0.0, s1 = 0.0, s2 = 0.0, s3 = 0.0, s4 = 0.0, s5 = 0.0, s6 = 0.0, s7 = 0.0 )
      if s0.is_a?(FFI::Pointer) then
        super(s0)
      else
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

    def inspect
      return "#<#{self.class.name}: #{self[:s0]}, #{self[:s1]}, #{self[:s2]}, #{self[:s3]}, #{self[:s4]}, #{self[:s5]}, #{self[:s6]}, #{self[:s7]}>"
    end

    def to_s
      return "Half8{ #{self[:s0]}, #{self[:s1]}, #{self[:s2]}, #{self[:s3]}, #{self[:s4]}, #{self[:s5]}, #{self[:s6]}, #{self[:s7]} }"
    end
  end
  # Maps the cl_char16 type of OpenCL
  class Char16 < Struct
    type = OpenCL.find_type(:cl_char)
    size = type.size
    @size = size * 16
    @layout = OpenCL::StructLayout::new([ OpenCL::StructLayout::Field::new( "s0", size * 0, type ), OpenCL::StructLayout::Field::new( "s1", size * 1, type ), OpenCL::StructLayout::Field::new( "s2", size * 2, type ), OpenCL::StructLayout::Field::new( "s3", size * 3, type ), OpenCL::StructLayout::Field::new( "s4", size * 4, type ), OpenCL::StructLayout::Field::new( "s5", size * 5, type ), OpenCL::StructLayout::Field::new( "s6", size * 6, type ), OpenCL::StructLayout::Field::new( "s7", size * 7, type ), OpenCL::StructLayout::Field::new( "s8", size * 8, type ), OpenCL::StructLayout::Field::new( "s9", size * 9, type ), OpenCL::StructLayout::Field::new( "sa", size * 10, type ), OpenCL::StructLayout::Field::new( "sb", size * 11, type ), OpenCL::StructLayout::Field::new( "sc", size * 12, type ), OpenCL::StructLayout::Field::new( "sd", size * 13, type ), OpenCL::StructLayout::Field::new( "se", size * 14, type ), OpenCL::StructLayout::Field::new( "sf", size * 15, type ) ], size * 16, size * 16 )
    # Creates a new Char16 with members set to 0 or to the user specified values. If a Pointer is passed as the first argument, Char16 maps the memory pointed.
    def initialize( s0 = 0, s1 = 0, s2 = 0, s3 = 0, s4 = 0, s5 = 0, s6 = 0, s7 = 0, s8 = 0, s9 = 0, sa = 0, sb = 0, sc = 0, sd = 0, se = 0, sf = 0 )
      if s0.is_a?(FFI::Pointer) then
        super(s0)
      else
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

    def inspect
      return "#<#{self.class.name}: #{self[:s0]}, #{self[:s1]}, #{self[:s2]}, #{self[:s3]}, #{self[:s4]}, #{self[:s5]}, #{self[:s6]}, #{self[:s7]}, #{self[:s8]}, #{self[:s9]}, #{self[:sa]}, #{self[:sb]}, #{self[:sc]}, #{self[:sd]}, #{self[:se]}, #{self[:sf]}>"
    end

    def to_s
      return "Char16{ #{self[:s0]}, #{self[:s1]}, #{self[:s2]}, #{self[:s3]}, #{self[:s4]}, #{self[:s5]}, #{self[:s6]}, #{self[:s7]}, #{self[:s8]}, #{self[:s9]}, #{self[:sa]}, #{self[:sb]}, #{self[:sc]}, #{self[:sd]}, #{self[:se]}, #{self[:sf]} }"
    end
  end
  # Maps the cl_uchar16 type of OpenCL
  class UChar16 < Struct
    type = OpenCL.find_type(:cl_uchar)
    size = type.size
    @size = size * 16
    @layout = OpenCL::StructLayout::new([ OpenCL::StructLayout::Field::new( "s0", size * 0, type ), OpenCL::StructLayout::Field::new( "s1", size * 1, type ), OpenCL::StructLayout::Field::new( "s2", size * 2, type ), OpenCL::StructLayout::Field::new( "s3", size * 3, type ), OpenCL::StructLayout::Field::new( "s4", size * 4, type ), OpenCL::StructLayout::Field::new( "s5", size * 5, type ), OpenCL::StructLayout::Field::new( "s6", size * 6, type ), OpenCL::StructLayout::Field::new( "s7", size * 7, type ), OpenCL::StructLayout::Field::new( "s8", size * 8, type ), OpenCL::StructLayout::Field::new( "s9", size * 9, type ), OpenCL::StructLayout::Field::new( "sa", size * 10, type ), OpenCL::StructLayout::Field::new( "sb", size * 11, type ), OpenCL::StructLayout::Field::new( "sc", size * 12, type ), OpenCL::StructLayout::Field::new( "sd", size * 13, type ), OpenCL::StructLayout::Field::new( "se", size * 14, type ), OpenCL::StructLayout::Field::new( "sf", size * 15, type ) ], size * 16, size * 16 )
    # Creates a new UChar16 with members set to 0 or to the user specified values. If a Pointer is passed as the first argument, UChar16 maps the memory pointed.
    def initialize( s0 = 0, s1 = 0, s2 = 0, s3 = 0, s4 = 0, s5 = 0, s6 = 0, s7 = 0, s8 = 0, s9 = 0, sa = 0, sb = 0, sc = 0, sd = 0, se = 0, sf = 0 )
      if s0.is_a?(FFI::Pointer) then
        super(s0)
      else
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

    def inspect
      return "#<#{self.class.name}: #{self[:s0]}, #{self[:s1]}, #{self[:s2]}, #{self[:s3]}, #{self[:s4]}, #{self[:s5]}, #{self[:s6]}, #{self[:s7]}, #{self[:s8]}, #{self[:s9]}, #{self[:sa]}, #{self[:sb]}, #{self[:sc]}, #{self[:sd]}, #{self[:se]}, #{self[:sf]}>"
    end

    def to_s
      return "UChar16{ #{self[:s0]}, #{self[:s1]}, #{self[:s2]}, #{self[:s3]}, #{self[:s4]}, #{self[:s5]}, #{self[:s6]}, #{self[:s7]}, #{self[:s8]}, #{self[:s9]}, #{self[:sa]}, #{self[:sb]}, #{self[:sc]}, #{self[:sd]}, #{self[:se]}, #{self[:sf]} }"
    end
  end
  # Maps the cl_short16 type of OpenCL
  class Short16 < Struct
    type = OpenCL.find_type(:cl_short)
    size = type.size
    @size = size * 16
    @layout = OpenCL::StructLayout::new([ OpenCL::StructLayout::Field::new( "s0", size * 0, type ), OpenCL::StructLayout::Field::new( "s1", size * 1, type ), OpenCL::StructLayout::Field::new( "s2", size * 2, type ), OpenCL::StructLayout::Field::new( "s3", size * 3, type ), OpenCL::StructLayout::Field::new( "s4", size * 4, type ), OpenCL::StructLayout::Field::new( "s5", size * 5, type ), OpenCL::StructLayout::Field::new( "s6", size * 6, type ), OpenCL::StructLayout::Field::new( "s7", size * 7, type ), OpenCL::StructLayout::Field::new( "s8", size * 8, type ), OpenCL::StructLayout::Field::new( "s9", size * 9, type ), OpenCL::StructLayout::Field::new( "sa", size * 10, type ), OpenCL::StructLayout::Field::new( "sb", size * 11, type ), OpenCL::StructLayout::Field::new( "sc", size * 12, type ), OpenCL::StructLayout::Field::new( "sd", size * 13, type ), OpenCL::StructLayout::Field::new( "se", size * 14, type ), OpenCL::StructLayout::Field::new( "sf", size * 15, type ) ], size * 16, size * 16 )
    # Creates a new Short16 with members set to 0 or to the user specified values. If a Pointer is passed as the first argument, Short16 maps the memory pointed.
    def initialize( s0 = 0, s1 = 0, s2 = 0, s3 = 0, s4 = 0, s5 = 0, s6 = 0, s7 = 0, s8 = 0, s9 = 0, sa = 0, sb = 0, sc = 0, sd = 0, se = 0, sf = 0 )
      if s0.is_a?(FFI::Pointer) then
        super(s0)
      else
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

    def inspect
      return "#<#{self.class.name}: #{self[:s0]}, #{self[:s1]}, #{self[:s2]}, #{self[:s3]}, #{self[:s4]}, #{self[:s5]}, #{self[:s6]}, #{self[:s7]}, #{self[:s8]}, #{self[:s9]}, #{self[:sa]}, #{self[:sb]}, #{self[:sc]}, #{self[:sd]}, #{self[:se]}, #{self[:sf]}>"
    end

    def to_s
      return "Short16{ #{self[:s0]}, #{self[:s1]}, #{self[:s2]}, #{self[:s3]}, #{self[:s4]}, #{self[:s5]}, #{self[:s6]}, #{self[:s7]}, #{self[:s8]}, #{self[:s9]}, #{self[:sa]}, #{self[:sb]}, #{self[:sc]}, #{self[:sd]}, #{self[:se]}, #{self[:sf]} }"
    end
  end
  # Maps the cl_ushort16 type of OpenCL
  class UShort16 < Struct
    type = OpenCL.find_type(:cl_ushort)
    size = type.size
    @size = size * 16
    @layout = OpenCL::StructLayout::new([ OpenCL::StructLayout::Field::new( "s0", size * 0, type ), OpenCL::StructLayout::Field::new( "s1", size * 1, type ), OpenCL::StructLayout::Field::new( "s2", size * 2, type ), OpenCL::StructLayout::Field::new( "s3", size * 3, type ), OpenCL::StructLayout::Field::new( "s4", size * 4, type ), OpenCL::StructLayout::Field::new( "s5", size * 5, type ), OpenCL::StructLayout::Field::new( "s6", size * 6, type ), OpenCL::StructLayout::Field::new( "s7", size * 7, type ), OpenCL::StructLayout::Field::new( "s8", size * 8, type ), OpenCL::StructLayout::Field::new( "s9", size * 9, type ), OpenCL::StructLayout::Field::new( "sa", size * 10, type ), OpenCL::StructLayout::Field::new( "sb", size * 11, type ), OpenCL::StructLayout::Field::new( "sc", size * 12, type ), OpenCL::StructLayout::Field::new( "sd", size * 13, type ), OpenCL::StructLayout::Field::new( "se", size * 14, type ), OpenCL::StructLayout::Field::new( "sf", size * 15, type ) ], size * 16, size * 16 )
    # Creates a new UShort16 with members set to 0 or to the user specified values. If a Pointer is passed as the first argument, UShort16 maps the memory pointed.
    def initialize( s0 = 0, s1 = 0, s2 = 0, s3 = 0, s4 = 0, s5 = 0, s6 = 0, s7 = 0, s8 = 0, s9 = 0, sa = 0, sb = 0, sc = 0, sd = 0, se = 0, sf = 0 )
      if s0.is_a?(FFI::Pointer) then
        super(s0)
      else
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

    def inspect
      return "#<#{self.class.name}: #{self[:s0]}, #{self[:s1]}, #{self[:s2]}, #{self[:s3]}, #{self[:s4]}, #{self[:s5]}, #{self[:s6]}, #{self[:s7]}, #{self[:s8]}, #{self[:s9]}, #{self[:sa]}, #{self[:sb]}, #{self[:sc]}, #{self[:sd]}, #{self[:se]}, #{self[:sf]}>"
    end

    def to_s
      return "UShort16{ #{self[:s0]}, #{self[:s1]}, #{self[:s2]}, #{self[:s3]}, #{self[:s4]}, #{self[:s5]}, #{self[:s6]}, #{self[:s7]}, #{self[:s8]}, #{self[:s9]}, #{self[:sa]}, #{self[:sb]}, #{self[:sc]}, #{self[:sd]}, #{self[:se]}, #{self[:sf]} }"
    end
  end
  # Maps the cl_int16 type of OpenCL
  class Int16 < Struct
    type = OpenCL.find_type(:cl_int)
    size = type.size
    @size = size * 16
    @layout = OpenCL::StructLayout::new([ OpenCL::StructLayout::Field::new( "s0", size * 0, type ), OpenCL::StructLayout::Field::new( "s1", size * 1, type ), OpenCL::StructLayout::Field::new( "s2", size * 2, type ), OpenCL::StructLayout::Field::new( "s3", size * 3, type ), OpenCL::StructLayout::Field::new( "s4", size * 4, type ), OpenCL::StructLayout::Field::new( "s5", size * 5, type ), OpenCL::StructLayout::Field::new( "s6", size * 6, type ), OpenCL::StructLayout::Field::new( "s7", size * 7, type ), OpenCL::StructLayout::Field::new( "s8", size * 8, type ), OpenCL::StructLayout::Field::new( "s9", size * 9, type ), OpenCL::StructLayout::Field::new( "sa", size * 10, type ), OpenCL::StructLayout::Field::new( "sb", size * 11, type ), OpenCL::StructLayout::Field::new( "sc", size * 12, type ), OpenCL::StructLayout::Field::new( "sd", size * 13, type ), OpenCL::StructLayout::Field::new( "se", size * 14, type ), OpenCL::StructLayout::Field::new( "sf", size * 15, type ) ], size * 16, size * 16 )
    # Creates a new Int16 with members set to 0 or to the user specified values. If a Pointer is passed as the first argument, Int16 maps the memory pointed.
    def initialize( s0 = 0, s1 = 0, s2 = 0, s3 = 0, s4 = 0, s5 = 0, s6 = 0, s7 = 0, s8 = 0, s9 = 0, sa = 0, sb = 0, sc = 0, sd = 0, se = 0, sf = 0 )
      if s0.is_a?(FFI::Pointer) then
        super(s0)
      else
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

    def inspect
      return "#<#{self.class.name}: #{self[:s0]}, #{self[:s1]}, #{self[:s2]}, #{self[:s3]}, #{self[:s4]}, #{self[:s5]}, #{self[:s6]}, #{self[:s7]}, #{self[:s8]}, #{self[:s9]}, #{self[:sa]}, #{self[:sb]}, #{self[:sc]}, #{self[:sd]}, #{self[:se]}, #{self[:sf]}>"
    end

    def to_s
      return "Int16{ #{self[:s0]}, #{self[:s1]}, #{self[:s2]}, #{self[:s3]}, #{self[:s4]}, #{self[:s5]}, #{self[:s6]}, #{self[:s7]}, #{self[:s8]}, #{self[:s9]}, #{self[:sa]}, #{self[:sb]}, #{self[:sc]}, #{self[:sd]}, #{self[:se]}, #{self[:sf]} }"
    end
  end
  # Maps the cl_uint16 type of OpenCL
  class UInt16 < Struct
    type = OpenCL.find_type(:cl_uint)
    size = type.size
    @size = size * 16
    @layout = OpenCL::StructLayout::new([ OpenCL::StructLayout::Field::new( "s0", size * 0, type ), OpenCL::StructLayout::Field::new( "s1", size * 1, type ), OpenCL::StructLayout::Field::new( "s2", size * 2, type ), OpenCL::StructLayout::Field::new( "s3", size * 3, type ), OpenCL::StructLayout::Field::new( "s4", size * 4, type ), OpenCL::StructLayout::Field::new( "s5", size * 5, type ), OpenCL::StructLayout::Field::new( "s6", size * 6, type ), OpenCL::StructLayout::Field::new( "s7", size * 7, type ), OpenCL::StructLayout::Field::new( "s8", size * 8, type ), OpenCL::StructLayout::Field::new( "s9", size * 9, type ), OpenCL::StructLayout::Field::new( "sa", size * 10, type ), OpenCL::StructLayout::Field::new( "sb", size * 11, type ), OpenCL::StructLayout::Field::new( "sc", size * 12, type ), OpenCL::StructLayout::Field::new( "sd", size * 13, type ), OpenCL::StructLayout::Field::new( "se", size * 14, type ), OpenCL::StructLayout::Field::new( "sf", size * 15, type ) ], size * 16, size * 16 )
    # Creates a new UInt16 with members set to 0 or to the user specified values. If a Pointer is passed as the first argument, UInt16 maps the memory pointed.
    def initialize( s0 = 0, s1 = 0, s2 = 0, s3 = 0, s4 = 0, s5 = 0, s6 = 0, s7 = 0, s8 = 0, s9 = 0, sa = 0, sb = 0, sc = 0, sd = 0, se = 0, sf = 0 )
      if s0.is_a?(FFI::Pointer) then
        super(s0)
      else
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

    def inspect
      return "#<#{self.class.name}: #{self[:s0]}, #{self[:s1]}, #{self[:s2]}, #{self[:s3]}, #{self[:s4]}, #{self[:s5]}, #{self[:s6]}, #{self[:s7]}, #{self[:s8]}, #{self[:s9]}, #{self[:sa]}, #{self[:sb]}, #{self[:sc]}, #{self[:sd]}, #{self[:se]}, #{self[:sf]}>"
    end

    def to_s
      return "UInt16{ #{self[:s0]}, #{self[:s1]}, #{self[:s2]}, #{self[:s3]}, #{self[:s4]}, #{self[:s5]}, #{self[:s6]}, #{self[:s7]}, #{self[:s8]}, #{self[:s9]}, #{self[:sa]}, #{self[:sb]}, #{self[:sc]}, #{self[:sd]}, #{self[:se]}, #{self[:sf]} }"
    end
  end
  # Maps the cl_long16 type of OpenCL
  class Long16 < Struct
    type = OpenCL.find_type(:cl_long)
    size = type.size
    @size = size * 16
    @layout = OpenCL::StructLayout::new([ OpenCL::StructLayout::Field::new( "s0", size * 0, type ), OpenCL::StructLayout::Field::new( "s1", size * 1, type ), OpenCL::StructLayout::Field::new( "s2", size * 2, type ), OpenCL::StructLayout::Field::new( "s3", size * 3, type ), OpenCL::StructLayout::Field::new( "s4", size * 4, type ), OpenCL::StructLayout::Field::new( "s5", size * 5, type ), OpenCL::StructLayout::Field::new( "s6", size * 6, type ), OpenCL::StructLayout::Field::new( "s7", size * 7, type ), OpenCL::StructLayout::Field::new( "s8", size * 8, type ), OpenCL::StructLayout::Field::new( "s9", size * 9, type ), OpenCL::StructLayout::Field::new( "sa", size * 10, type ), OpenCL::StructLayout::Field::new( "sb", size * 11, type ), OpenCL::StructLayout::Field::new( "sc", size * 12, type ), OpenCL::StructLayout::Field::new( "sd", size * 13, type ), OpenCL::StructLayout::Field::new( "se", size * 14, type ), OpenCL::StructLayout::Field::new( "sf", size * 15, type ) ], size * 16, size * 16 )
    # Creates a new Long16 with members set to 0 or to the user specified values. If a Pointer is passed as the first argument, Long16 maps the memory pointed.
    def initialize( s0 = 0, s1 = 0, s2 = 0, s3 = 0, s4 = 0, s5 = 0, s6 = 0, s7 = 0, s8 = 0, s9 = 0, sa = 0, sb = 0, sc = 0, sd = 0, se = 0, sf = 0 )
      if s0.is_a?(FFI::Pointer) then
        super(s0)
      else
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

    def inspect
      return "#<#{self.class.name}: #{self[:s0]}, #{self[:s1]}, #{self[:s2]}, #{self[:s3]}, #{self[:s4]}, #{self[:s5]}, #{self[:s6]}, #{self[:s7]}, #{self[:s8]}, #{self[:s9]}, #{self[:sa]}, #{self[:sb]}, #{self[:sc]}, #{self[:sd]}, #{self[:se]}, #{self[:sf]}>"
    end

    def to_s
      return "Long16{ #{self[:s0]}, #{self[:s1]}, #{self[:s2]}, #{self[:s3]}, #{self[:s4]}, #{self[:s5]}, #{self[:s6]}, #{self[:s7]}, #{self[:s8]}, #{self[:s9]}, #{self[:sa]}, #{self[:sb]}, #{self[:sc]}, #{self[:sd]}, #{self[:se]}, #{self[:sf]} }"
    end
  end
  # Maps the cl_ulong16 type of OpenCL
  class ULong16 < Struct
    type = OpenCL.find_type(:cl_ulong)
    size = type.size
    @size = size * 16
    @layout = OpenCL::StructLayout::new([ OpenCL::StructLayout::Field::new( "s0", size * 0, type ), OpenCL::StructLayout::Field::new( "s1", size * 1, type ), OpenCL::StructLayout::Field::new( "s2", size * 2, type ), OpenCL::StructLayout::Field::new( "s3", size * 3, type ), OpenCL::StructLayout::Field::new( "s4", size * 4, type ), OpenCL::StructLayout::Field::new( "s5", size * 5, type ), OpenCL::StructLayout::Field::new( "s6", size * 6, type ), OpenCL::StructLayout::Field::new( "s7", size * 7, type ), OpenCL::StructLayout::Field::new( "s8", size * 8, type ), OpenCL::StructLayout::Field::new( "s9", size * 9, type ), OpenCL::StructLayout::Field::new( "sa", size * 10, type ), OpenCL::StructLayout::Field::new( "sb", size * 11, type ), OpenCL::StructLayout::Field::new( "sc", size * 12, type ), OpenCL::StructLayout::Field::new( "sd", size * 13, type ), OpenCL::StructLayout::Field::new( "se", size * 14, type ), OpenCL::StructLayout::Field::new( "sf", size * 15, type ) ], size * 16, size * 16 )
    # Creates a new ULong16 with members set to 0 or to the user specified values. If a Pointer is passed as the first argument, ULong16 maps the memory pointed.
    def initialize( s0 = 0, s1 = 0, s2 = 0, s3 = 0, s4 = 0, s5 = 0, s6 = 0, s7 = 0, s8 = 0, s9 = 0, sa = 0, sb = 0, sc = 0, sd = 0, se = 0, sf = 0 )
      if s0.is_a?(FFI::Pointer) then
        super(s0)
      else
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

    def inspect
      return "#<#{self.class.name}: #{self[:s0]}, #{self[:s1]}, #{self[:s2]}, #{self[:s3]}, #{self[:s4]}, #{self[:s5]}, #{self[:s6]}, #{self[:s7]}, #{self[:s8]}, #{self[:s9]}, #{self[:sa]}, #{self[:sb]}, #{self[:sc]}, #{self[:sd]}, #{self[:se]}, #{self[:sf]}>"
    end

    def to_s
      return "ULong16{ #{self[:s0]}, #{self[:s1]}, #{self[:s2]}, #{self[:s3]}, #{self[:s4]}, #{self[:s5]}, #{self[:s6]}, #{self[:s7]}, #{self[:s8]}, #{self[:s9]}, #{self[:sa]}, #{self[:sb]}, #{self[:sc]}, #{self[:sd]}, #{self[:se]}, #{self[:sf]} }"
    end
  end
  # Maps the cl_float16 type of OpenCL
  class Float16 < Struct
    type = OpenCL.find_type(:cl_float)
    size = type.size
    @size = size * 16
    @layout = OpenCL::StructLayout::new([ OpenCL::StructLayout::Field::new( "s0", size * 0, type ), OpenCL::StructLayout::Field::new( "s1", size * 1, type ), OpenCL::StructLayout::Field::new( "s2", size * 2, type ), OpenCL::StructLayout::Field::new( "s3", size * 3, type ), OpenCL::StructLayout::Field::new( "s4", size * 4, type ), OpenCL::StructLayout::Field::new( "s5", size * 5, type ), OpenCL::StructLayout::Field::new( "s6", size * 6, type ), OpenCL::StructLayout::Field::new( "s7", size * 7, type ), OpenCL::StructLayout::Field::new( "s8", size * 8, type ), OpenCL::StructLayout::Field::new( "s9", size * 9, type ), OpenCL::StructLayout::Field::new( "sa", size * 10, type ), OpenCL::StructLayout::Field::new( "sb", size * 11, type ), OpenCL::StructLayout::Field::new( "sc", size * 12, type ), OpenCL::StructLayout::Field::new( "sd", size * 13, type ), OpenCL::StructLayout::Field::new( "se", size * 14, type ), OpenCL::StructLayout::Field::new( "sf", size * 15, type ) ], size * 16, size * 16 )
    # Creates a new Float16 with members set to 0 or to the user specified values. If a Pointer is passed as the first argument, Float16 maps the memory pointed.
    def initialize( s0 = 0.0, s1 = 0.0, s2 = 0.0, s3 = 0.0, s4 = 0.0, s5 = 0.0, s6 = 0.0, s7 = 0.0, s8 = 0.0, s9 = 0.0, sa = 0.0, sb = 0.0, sc = 0.0, sd = 0.0, se = 0.0, sf = 0.0 )
      if s0.is_a?(FFI::Pointer) then
        super(s0)
      else
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

    def inspect
      return "#<#{self.class.name}: #{self[:s0]}, #{self[:s1]}, #{self[:s2]}, #{self[:s3]}, #{self[:s4]}, #{self[:s5]}, #{self[:s6]}, #{self[:s7]}, #{self[:s8]}, #{self[:s9]}, #{self[:sa]}, #{self[:sb]}, #{self[:sc]}, #{self[:sd]}, #{self[:se]}, #{self[:sf]}>"
    end

    def to_s
      return "Float16{ #{self[:s0]}, #{self[:s1]}, #{self[:s2]}, #{self[:s3]}, #{self[:s4]}, #{self[:s5]}, #{self[:s6]}, #{self[:s7]}, #{self[:s8]}, #{self[:s9]}, #{self[:sa]}, #{self[:sb]}, #{self[:sc]}, #{self[:sd]}, #{self[:se]}, #{self[:sf]} }"
    end
  end
  # Maps the cl_double16 type of OpenCL
  class Double16 < Struct
    type = OpenCL.find_type(:cl_double)
    size = type.size
    @size = size * 16
    @layout = OpenCL::StructLayout::new([ OpenCL::StructLayout::Field::new( "s0", size * 0, type ), OpenCL::StructLayout::Field::new( "s1", size * 1, type ), OpenCL::StructLayout::Field::new( "s2", size * 2, type ), OpenCL::StructLayout::Field::new( "s3", size * 3, type ), OpenCL::StructLayout::Field::new( "s4", size * 4, type ), OpenCL::StructLayout::Field::new( "s5", size * 5, type ), OpenCL::StructLayout::Field::new( "s6", size * 6, type ), OpenCL::StructLayout::Field::new( "s7", size * 7, type ), OpenCL::StructLayout::Field::new( "s8", size * 8, type ), OpenCL::StructLayout::Field::new( "s9", size * 9, type ), OpenCL::StructLayout::Field::new( "sa", size * 10, type ), OpenCL::StructLayout::Field::new( "sb", size * 11, type ), OpenCL::StructLayout::Field::new( "sc", size * 12, type ), OpenCL::StructLayout::Field::new( "sd", size * 13, type ), OpenCL::StructLayout::Field::new( "se", size * 14, type ), OpenCL::StructLayout::Field::new( "sf", size * 15, type ) ], size * 16, size * 16 )
    # Creates a new Double16 with members set to 0 or to the user specified values. If a Pointer is passed as the first argument, Double16 maps the memory pointed.
    def initialize( s0 = 0.0, s1 = 0.0, s2 = 0.0, s3 = 0.0, s4 = 0.0, s5 = 0.0, s6 = 0.0, s7 = 0.0, s8 = 0.0, s9 = 0.0, sa = 0.0, sb = 0.0, sc = 0.0, sd = 0.0, se = 0.0, sf = 0.0 )
      if s0.is_a?(FFI::Pointer) then
        super(s0)
      else
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

    def inspect
      return "#<#{self.class.name}: #{self[:s0]}, #{self[:s1]}, #{self[:s2]}, #{self[:s3]}, #{self[:s4]}, #{self[:s5]}, #{self[:s6]}, #{self[:s7]}, #{self[:s8]}, #{self[:s9]}, #{self[:sa]}, #{self[:sb]}, #{self[:sc]}, #{self[:sd]}, #{self[:se]}, #{self[:sf]}>"
    end

    def to_s
      return "Double16{ #{self[:s0]}, #{self[:s1]}, #{self[:s2]}, #{self[:s3]}, #{self[:s4]}, #{self[:s5]}, #{self[:s6]}, #{self[:s7]}, #{self[:s8]}, #{self[:s9]}, #{self[:sa]}, #{self[:sb]}, #{self[:sc]}, #{self[:sd]}, #{self[:se]}, #{self[:sf]} }"
    end
  end
  # Maps the cl_half16 type of OpenCL
  class Half16 < Struct
    type = OpenCL.find_type(:cl_half)
    size = type.size
    @size = size * 16
    @layout = OpenCL::StructLayout::new([ OpenCL::StructLayout::Field::new( "s0", size * 0, type ), OpenCL::StructLayout::Field::new( "s1", size * 1, type ), OpenCL::StructLayout::Field::new( "s2", size * 2, type ), OpenCL::StructLayout::Field::new( "s3", size * 3, type ), OpenCL::StructLayout::Field::new( "s4", size * 4, type ), OpenCL::StructLayout::Field::new( "s5", size * 5, type ), OpenCL::StructLayout::Field::new( "s6", size * 6, type ), OpenCL::StructLayout::Field::new( "s7", size * 7, type ), OpenCL::StructLayout::Field::new( "s8", size * 8, type ), OpenCL::StructLayout::Field::new( "s9", size * 9, type ), OpenCL::StructLayout::Field::new( "sa", size * 10, type ), OpenCL::StructLayout::Field::new( "sb", size * 11, type ), OpenCL::StructLayout::Field::new( "sc", size * 12, type ), OpenCL::StructLayout::Field::new( "sd", size * 13, type ), OpenCL::StructLayout::Field::new( "se", size * 14, type ), OpenCL::StructLayout::Field::new( "sf", size * 15, type ) ], size * 16, size * 16 )
    # Creates a new Half16 with members set to 0 or to the user specified values. If a Pointer is passed as the first argument, Half16 maps the memory pointed.
    def initialize( s0 = 0.0, s1 = 0.0, s2 = 0.0, s3 = 0.0, s4 = 0.0, s5 = 0.0, s6 = 0.0, s7 = 0.0, s8 = 0.0, s9 = 0.0, sa = 0.0, sb = 0.0, sc = 0.0, sd = 0.0, se = 0.0, sf = 0.0 )
      if s0.is_a?(FFI::Pointer) then
        super(s0)
      else
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

    def inspect
      return "#<#{self.class.name}: #{self[:s0]}, #{self[:s1]}, #{self[:s2]}, #{self[:s3]}, #{self[:s4]}, #{self[:s5]}, #{self[:s6]}, #{self[:s7]}, #{self[:s8]}, #{self[:s9]}, #{self[:sa]}, #{self[:sb]}, #{self[:sc]}, #{self[:sd]}, #{self[:se]}, #{self[:sf]}>"
    end

    def to_s
      return "Half16{ #{self[:s0]}, #{self[:s1]}, #{self[:s2]}, #{self[:s3]}, #{self[:s4]}, #{self[:s5]}, #{self[:s6]}, #{self[:s7]}, #{self[:s8]}, #{self[:s9]}, #{self[:sa]}, #{self[:sb]}, #{self[:sc]}, #{self[:sd]}, #{self[:se]}, #{self[:sf]} }"
    end
  end
end

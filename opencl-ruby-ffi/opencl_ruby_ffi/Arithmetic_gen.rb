module OpenCL
  class Char < FFI::Struct
    @size = FFI.find_type(:cl_char).size * 1
    @layout = FFI::StructLayout::new([ FFI::StructLayout::Field::new( "s0", FFI.find_type(:cl_char).size * 0, FFI.find_type(:cl_char) ) ], FFI.find_type(:cl_char).size * 1, FFI.find_type(:cl_char).size * 1 )
    def initialize( s0 = 0 )
      super()
      self[:s0] = s0
    end
  end
  class UChar < FFI::Struct
    @size = FFI.find_type(:cl_uchar).size * 1
    @layout = FFI::StructLayout::new([ FFI::StructLayout::Field::new( "s0", FFI.find_type(:cl_uchar).size * 0, FFI.find_type(:cl_uchar) ) ], FFI.find_type(:cl_uchar).size * 1, FFI.find_type(:cl_uchar).size * 1 )
    def initialize( s0 = 0 )
      super()
      self[:s0] = s0
    end
  end
  class Short < FFI::Struct
    @size = FFI.find_type(:cl_short).size * 1
    @layout = FFI::StructLayout::new([ FFI::StructLayout::Field::new( "s0", FFI.find_type(:cl_short).size * 0, FFI.find_type(:cl_short) ) ], FFI.find_type(:cl_short).size * 1, FFI.find_type(:cl_short).size * 1 )
    def initialize( s0 = 0 )
      super()
      self[:s0] = s0
    end
  end
  class UShort < FFI::Struct
    @size = FFI.find_type(:cl_ushort).size * 1
    @layout = FFI::StructLayout::new([ FFI::StructLayout::Field::new( "s0", FFI.find_type(:cl_ushort).size * 0, FFI.find_type(:cl_ushort) ) ], FFI.find_type(:cl_ushort).size * 1, FFI.find_type(:cl_ushort).size * 1 )
    def initialize( s0 = 0 )
      super()
      self[:s0] = s0
    end
  end
  class Int < FFI::Struct
    @size = FFI.find_type(:cl_int).size * 1
    @layout = FFI::StructLayout::new([ FFI::StructLayout::Field::new( "s0", FFI.find_type(:cl_int).size * 0, FFI.find_type(:cl_int) ) ], FFI.find_type(:cl_int).size * 1, FFI.find_type(:cl_int).size * 1 )
    def initialize( s0 = 0 )
      super()
      self[:s0] = s0
    end
  end
  class UInt < FFI::Struct
    @size = FFI.find_type(:cl_uint).size * 1
    @layout = FFI::StructLayout::new([ FFI::StructLayout::Field::new( "s0", FFI.find_type(:cl_uint).size * 0, FFI.find_type(:cl_uint) ) ], FFI.find_type(:cl_uint).size * 1, FFI.find_type(:cl_uint).size * 1 )
    def initialize( s0 = 0 )
      super()
      self[:s0] = s0
    end
  end
  class Long < FFI::Struct
    @size = FFI.find_type(:cl_long).size * 1
    @layout = FFI::StructLayout::new([ FFI::StructLayout::Field::new( "s0", FFI.find_type(:cl_long).size * 0, FFI.find_type(:cl_long) ) ], FFI.find_type(:cl_long).size * 1, FFI.find_type(:cl_long).size * 1 )
    def initialize( s0 = 0 )
      super()
      self[:s0] = s0
    end
  end
  class ULong < FFI::Struct
    @size = FFI.find_type(:cl_ulong).size * 1
    @layout = FFI::StructLayout::new([ FFI::StructLayout::Field::new( "s0", FFI.find_type(:cl_ulong).size * 0, FFI.find_type(:cl_ulong) ) ], FFI.find_type(:cl_ulong).size * 1, FFI.find_type(:cl_ulong).size * 1 )
    def initialize( s0 = 0 )
      super()
      self[:s0] = s0
    end
  end
  class Float < FFI::Struct
    @size = FFI.find_type(:cl_float).size * 1
    @layout = FFI::StructLayout::new([ FFI::StructLayout::Field::new( "s0", FFI.find_type(:cl_float).size * 0, FFI.find_type(:cl_float) ) ], FFI.find_type(:cl_float).size * 1, FFI.find_type(:cl_float).size * 1 )
    def initialize( s0 = 0.0 )
      super()
      self[:s0] = s0
    end
  end
  class Double < FFI::Struct
    @size = FFI.find_type(:cl_double).size * 1
    @layout = FFI::StructLayout::new([ FFI::StructLayout::Field::new( "s0", FFI.find_type(:cl_double).size * 0, FFI.find_type(:cl_double) ) ], FFI.find_type(:cl_double).size * 1, FFI.find_type(:cl_double).size * 1 )
    def initialize( s0 = 0.0 )
      super()
      self[:s0] = s0
    end
  end
  class Half < FFI::Struct
    @size = FFI.find_type(:cl_half).size * 1
    @layout = FFI::StructLayout::new([ FFI::StructLayout::Field::new( "s0", FFI.find_type(:cl_half).size * 0, FFI.find_type(:cl_half) ) ], FFI.find_type(:cl_half).size * 1, FFI.find_type(:cl_half).size * 1 )
    def initialize( s0 = 0.0 )
      super()
      self[:s0] = s0
    end
  end
  class Char2 < FFI::Struct
    @size = FFI.find_type(:cl_char).size * 2
    @layout = FFI::StructLayout::new([ FFI::StructLayout::Field::new( "s0", FFI.find_type(:cl_char).size * 0, FFI.find_type(:cl_char) ), FFI::StructLayout::Field::new( "s1", FFI.find_type(:cl_char).size * 1, FFI.find_type(:cl_char) ) ], FFI.find_type(:cl_char).size * 2, FFI.find_type(:cl_char).size * 2 )
    def initialize( s0 = 0, s1 = 0 )
      super()
      self[:s0] = s0
      self[:s1] = s1
    end
  end
  class UChar2 < FFI::Struct
    @size = FFI.find_type(:cl_uchar).size * 2
    @layout = FFI::StructLayout::new([ FFI::StructLayout::Field::new( "s0", FFI.find_type(:cl_uchar).size * 0, FFI.find_type(:cl_uchar) ), FFI::StructLayout::Field::new( "s1", FFI.find_type(:cl_uchar).size * 1, FFI.find_type(:cl_uchar) ) ], FFI.find_type(:cl_uchar).size * 2, FFI.find_type(:cl_uchar).size * 2 )
    def initialize( s0 = 0, s1 = 0 )
      super()
      self[:s0] = s0
      self[:s1] = s1
    end
  end
  class Short2 < FFI::Struct
    @size = FFI.find_type(:cl_short).size * 2
    @layout = FFI::StructLayout::new([ FFI::StructLayout::Field::new( "s0", FFI.find_type(:cl_short).size * 0, FFI.find_type(:cl_short) ), FFI::StructLayout::Field::new( "s1", FFI.find_type(:cl_short).size * 1, FFI.find_type(:cl_short) ) ], FFI.find_type(:cl_short).size * 2, FFI.find_type(:cl_short).size * 2 )
    def initialize( s0 = 0, s1 = 0 )
      super()
      self[:s0] = s0
      self[:s1] = s1
    end
  end
  class UShort2 < FFI::Struct
    @size = FFI.find_type(:cl_ushort).size * 2
    @layout = FFI::StructLayout::new([ FFI::StructLayout::Field::new( "s0", FFI.find_type(:cl_ushort).size * 0, FFI.find_type(:cl_ushort) ), FFI::StructLayout::Field::new( "s1", FFI.find_type(:cl_ushort).size * 1, FFI.find_type(:cl_ushort) ) ], FFI.find_type(:cl_ushort).size * 2, FFI.find_type(:cl_ushort).size * 2 )
    def initialize( s0 = 0, s1 = 0 )
      super()
      self[:s0] = s0
      self[:s1] = s1
    end
  end
  class Int2 < FFI::Struct
    @size = FFI.find_type(:cl_int).size * 2
    @layout = FFI::StructLayout::new([ FFI::StructLayout::Field::new( "s0", FFI.find_type(:cl_int).size * 0, FFI.find_type(:cl_int) ), FFI::StructLayout::Field::new( "s1", FFI.find_type(:cl_int).size * 1, FFI.find_type(:cl_int) ) ], FFI.find_type(:cl_int).size * 2, FFI.find_type(:cl_int).size * 2 )
    def initialize( s0 = 0, s1 = 0 )
      super()
      self[:s0] = s0
      self[:s1] = s1
    end
  end
  class UInt2 < FFI::Struct
    @size = FFI.find_type(:cl_uint).size * 2
    @layout = FFI::StructLayout::new([ FFI::StructLayout::Field::new( "s0", FFI.find_type(:cl_uint).size * 0, FFI.find_type(:cl_uint) ), FFI::StructLayout::Field::new( "s1", FFI.find_type(:cl_uint).size * 1, FFI.find_type(:cl_uint) ) ], FFI.find_type(:cl_uint).size * 2, FFI.find_type(:cl_uint).size * 2 )
    def initialize( s0 = 0, s1 = 0 )
      super()
      self[:s0] = s0
      self[:s1] = s1
    end
  end
  class Long2 < FFI::Struct
    @size = FFI.find_type(:cl_long).size * 2
    @layout = FFI::StructLayout::new([ FFI::StructLayout::Field::new( "s0", FFI.find_type(:cl_long).size * 0, FFI.find_type(:cl_long) ), FFI::StructLayout::Field::new( "s1", FFI.find_type(:cl_long).size * 1, FFI.find_type(:cl_long) ) ], FFI.find_type(:cl_long).size * 2, FFI.find_type(:cl_long).size * 2 )
    def initialize( s0 = 0, s1 = 0 )
      super()
      self[:s0] = s0
      self[:s1] = s1
    end
  end
  class ULong2 < FFI::Struct
    @size = FFI.find_type(:cl_ulong).size * 2
    @layout = FFI::StructLayout::new([ FFI::StructLayout::Field::new( "s0", FFI.find_type(:cl_ulong).size * 0, FFI.find_type(:cl_ulong) ), FFI::StructLayout::Field::new( "s1", FFI.find_type(:cl_ulong).size * 1, FFI.find_type(:cl_ulong) ) ], FFI.find_type(:cl_ulong).size * 2, FFI.find_type(:cl_ulong).size * 2 )
    def initialize( s0 = 0, s1 = 0 )
      super()
      self[:s0] = s0
      self[:s1] = s1
    end
  end
  class Float2 < FFI::Struct
    @size = FFI.find_type(:cl_float).size * 2
    @layout = FFI::StructLayout::new([ FFI::StructLayout::Field::new( "s0", FFI.find_type(:cl_float).size * 0, FFI.find_type(:cl_float) ), FFI::StructLayout::Field::new( "s1", FFI.find_type(:cl_float).size * 1, FFI.find_type(:cl_float) ) ], FFI.find_type(:cl_float).size * 2, FFI.find_type(:cl_float).size * 2 )
    def initialize( s0 = 0.0, s1 = 0.0 )
      super()
      self[:s0] = s0
      self[:s1] = s1
    end
  end
  class Double2 < FFI::Struct
    @size = FFI.find_type(:cl_double).size * 2
    @layout = FFI::StructLayout::new([ FFI::StructLayout::Field::new( "s0", FFI.find_type(:cl_double).size * 0, FFI.find_type(:cl_double) ), FFI::StructLayout::Field::new( "s1", FFI.find_type(:cl_double).size * 1, FFI.find_type(:cl_double) ) ], FFI.find_type(:cl_double).size * 2, FFI.find_type(:cl_double).size * 2 )
    def initialize( s0 = 0.0, s1 = 0.0 )
      super()
      self[:s0] = s0
      self[:s1] = s1
    end
  end
  class Half2 < FFI::Struct
    @size = FFI.find_type(:cl_half).size * 2
    @layout = FFI::StructLayout::new([ FFI::StructLayout::Field::new( "s0", FFI.find_type(:cl_half).size * 0, FFI.find_type(:cl_half) ), FFI::StructLayout::Field::new( "s1", FFI.find_type(:cl_half).size * 1, FFI.find_type(:cl_half) ) ], FFI.find_type(:cl_half).size * 2, FFI.find_type(:cl_half).size * 2 )
    def initialize( s0 = 0.0, s1 = 0.0 )
      super()
      self[:s0] = s0
      self[:s1] = s1
    end
  end
  class Char4 < FFI::Struct
    @size = FFI.find_type(:cl_char).size * 4
    @layout = FFI::StructLayout::new([ FFI::StructLayout::Field::new( "s0", FFI.find_type(:cl_char).size * 0, FFI.find_type(:cl_char) ), FFI::StructLayout::Field::new( "s1", FFI.find_type(:cl_char).size * 1, FFI.find_type(:cl_char) ), FFI::StructLayout::Field::new( "s2", FFI.find_type(:cl_char).size * 2, FFI.find_type(:cl_char) ), FFI::StructLayout::Field::new( "s3", FFI.find_type(:cl_char).size * 3, FFI.find_type(:cl_char) ) ], FFI.find_type(:cl_char).size * 4, FFI.find_type(:cl_char).size * 4 )
    def initialize( s0 = 0, s1 = 0, s2 = 0, s3 = 0 )
      super()
      self[:s0] = s0
      self[:s1] = s1
      self[:s2] = s2
      self[:s3] = s3
    end
  end
  class UChar4 < FFI::Struct
    @size = FFI.find_type(:cl_uchar).size * 4
    @layout = FFI::StructLayout::new([ FFI::StructLayout::Field::new( "s0", FFI.find_type(:cl_uchar).size * 0, FFI.find_type(:cl_uchar) ), FFI::StructLayout::Field::new( "s1", FFI.find_type(:cl_uchar).size * 1, FFI.find_type(:cl_uchar) ), FFI::StructLayout::Field::new( "s2", FFI.find_type(:cl_uchar).size * 2, FFI.find_type(:cl_uchar) ), FFI::StructLayout::Field::new( "s3", FFI.find_type(:cl_uchar).size * 3, FFI.find_type(:cl_uchar) ) ], FFI.find_type(:cl_uchar).size * 4, FFI.find_type(:cl_uchar).size * 4 )
    def initialize( s0 = 0, s1 = 0, s2 = 0, s3 = 0 )
      super()
      self[:s0] = s0
      self[:s1] = s1
      self[:s2] = s2
      self[:s3] = s3
    end
  end
  class Short4 < FFI::Struct
    @size = FFI.find_type(:cl_short).size * 4
    @layout = FFI::StructLayout::new([ FFI::StructLayout::Field::new( "s0", FFI.find_type(:cl_short).size * 0, FFI.find_type(:cl_short) ), FFI::StructLayout::Field::new( "s1", FFI.find_type(:cl_short).size * 1, FFI.find_type(:cl_short) ), FFI::StructLayout::Field::new( "s2", FFI.find_type(:cl_short).size * 2, FFI.find_type(:cl_short) ), FFI::StructLayout::Field::new( "s3", FFI.find_type(:cl_short).size * 3, FFI.find_type(:cl_short) ) ], FFI.find_type(:cl_short).size * 4, FFI.find_type(:cl_short).size * 4 )
    def initialize( s0 = 0, s1 = 0, s2 = 0, s3 = 0 )
      super()
      self[:s0] = s0
      self[:s1] = s1
      self[:s2] = s2
      self[:s3] = s3
    end
  end
  class UShort4 < FFI::Struct
    @size = FFI.find_type(:cl_ushort).size * 4
    @layout = FFI::StructLayout::new([ FFI::StructLayout::Field::new( "s0", FFI.find_type(:cl_ushort).size * 0, FFI.find_type(:cl_ushort) ), FFI::StructLayout::Field::new( "s1", FFI.find_type(:cl_ushort).size * 1, FFI.find_type(:cl_ushort) ), FFI::StructLayout::Field::new( "s2", FFI.find_type(:cl_ushort).size * 2, FFI.find_type(:cl_ushort) ), FFI::StructLayout::Field::new( "s3", FFI.find_type(:cl_ushort).size * 3, FFI.find_type(:cl_ushort) ) ], FFI.find_type(:cl_ushort).size * 4, FFI.find_type(:cl_ushort).size * 4 )
    def initialize( s0 = 0, s1 = 0, s2 = 0, s3 = 0 )
      super()
      self[:s0] = s0
      self[:s1] = s1
      self[:s2] = s2
      self[:s3] = s3
    end
  end
  class Int4 < FFI::Struct
    @size = FFI.find_type(:cl_int).size * 4
    @layout = FFI::StructLayout::new([ FFI::StructLayout::Field::new( "s0", FFI.find_type(:cl_int).size * 0, FFI.find_type(:cl_int) ), FFI::StructLayout::Field::new( "s1", FFI.find_type(:cl_int).size * 1, FFI.find_type(:cl_int) ), FFI::StructLayout::Field::new( "s2", FFI.find_type(:cl_int).size * 2, FFI.find_type(:cl_int) ), FFI::StructLayout::Field::new( "s3", FFI.find_type(:cl_int).size * 3, FFI.find_type(:cl_int) ) ], FFI.find_type(:cl_int).size * 4, FFI.find_type(:cl_int).size * 4 )
    def initialize( s0 = 0, s1 = 0, s2 = 0, s3 = 0 )
      super()
      self[:s0] = s0
      self[:s1] = s1
      self[:s2] = s2
      self[:s3] = s3
    end
  end
  class UInt4 < FFI::Struct
    @size = FFI.find_type(:cl_uint).size * 4
    @layout = FFI::StructLayout::new([ FFI::StructLayout::Field::new( "s0", FFI.find_type(:cl_uint).size * 0, FFI.find_type(:cl_uint) ), FFI::StructLayout::Field::new( "s1", FFI.find_type(:cl_uint).size * 1, FFI.find_type(:cl_uint) ), FFI::StructLayout::Field::new( "s2", FFI.find_type(:cl_uint).size * 2, FFI.find_type(:cl_uint) ), FFI::StructLayout::Field::new( "s3", FFI.find_type(:cl_uint).size * 3, FFI.find_type(:cl_uint) ) ], FFI.find_type(:cl_uint).size * 4, FFI.find_type(:cl_uint).size * 4 )
    def initialize( s0 = 0, s1 = 0, s2 = 0, s3 = 0 )
      super()
      self[:s0] = s0
      self[:s1] = s1
      self[:s2] = s2
      self[:s3] = s3
    end
  end
  class Long4 < FFI::Struct
    @size = FFI.find_type(:cl_long).size * 4
    @layout = FFI::StructLayout::new([ FFI::StructLayout::Field::new( "s0", FFI.find_type(:cl_long).size * 0, FFI.find_type(:cl_long) ), FFI::StructLayout::Field::new( "s1", FFI.find_type(:cl_long).size * 1, FFI.find_type(:cl_long) ), FFI::StructLayout::Field::new( "s2", FFI.find_type(:cl_long).size * 2, FFI.find_type(:cl_long) ), FFI::StructLayout::Field::new( "s3", FFI.find_type(:cl_long).size * 3, FFI.find_type(:cl_long) ) ], FFI.find_type(:cl_long).size * 4, FFI.find_type(:cl_long).size * 4 )
    def initialize( s0 = 0, s1 = 0, s2 = 0, s3 = 0 )
      super()
      self[:s0] = s0
      self[:s1] = s1
      self[:s2] = s2
      self[:s3] = s3
    end
  end
  class ULong4 < FFI::Struct
    @size = FFI.find_type(:cl_ulong).size * 4
    @layout = FFI::StructLayout::new([ FFI::StructLayout::Field::new( "s0", FFI.find_type(:cl_ulong).size * 0, FFI.find_type(:cl_ulong) ), FFI::StructLayout::Field::new( "s1", FFI.find_type(:cl_ulong).size * 1, FFI.find_type(:cl_ulong) ), FFI::StructLayout::Field::new( "s2", FFI.find_type(:cl_ulong).size * 2, FFI.find_type(:cl_ulong) ), FFI::StructLayout::Field::new( "s3", FFI.find_type(:cl_ulong).size * 3, FFI.find_type(:cl_ulong) ) ], FFI.find_type(:cl_ulong).size * 4, FFI.find_type(:cl_ulong).size * 4 )
    def initialize( s0 = 0, s1 = 0, s2 = 0, s3 = 0 )
      super()
      self[:s0] = s0
      self[:s1] = s1
      self[:s2] = s2
      self[:s3] = s3
    end
  end
  class Float4 < FFI::Struct
    @size = FFI.find_type(:cl_float).size * 4
    @layout = FFI::StructLayout::new([ FFI::StructLayout::Field::new( "s0", FFI.find_type(:cl_float).size * 0, FFI.find_type(:cl_float) ), FFI::StructLayout::Field::new( "s1", FFI.find_type(:cl_float).size * 1, FFI.find_type(:cl_float) ), FFI::StructLayout::Field::new( "s2", FFI.find_type(:cl_float).size * 2, FFI.find_type(:cl_float) ), FFI::StructLayout::Field::new( "s3", FFI.find_type(:cl_float).size * 3, FFI.find_type(:cl_float) ) ], FFI.find_type(:cl_float).size * 4, FFI.find_type(:cl_float).size * 4 )
    def initialize( s0 = 0.0, s1 = 0.0, s2 = 0.0, s3 = 0.0 )
      super()
      self[:s0] = s0
      self[:s1] = s1
      self[:s2] = s2
      self[:s3] = s3
    end
  end
  class Double4 < FFI::Struct
    @size = FFI.find_type(:cl_double).size * 4
    @layout = FFI::StructLayout::new([ FFI::StructLayout::Field::new( "s0", FFI.find_type(:cl_double).size * 0, FFI.find_type(:cl_double) ), FFI::StructLayout::Field::new( "s1", FFI.find_type(:cl_double).size * 1, FFI.find_type(:cl_double) ), FFI::StructLayout::Field::new( "s2", FFI.find_type(:cl_double).size * 2, FFI.find_type(:cl_double) ), FFI::StructLayout::Field::new( "s3", FFI.find_type(:cl_double).size * 3, FFI.find_type(:cl_double) ) ], FFI.find_type(:cl_double).size * 4, FFI.find_type(:cl_double).size * 4 )
    def initialize( s0 = 0.0, s1 = 0.0, s2 = 0.0, s3 = 0.0 )
      super()
      self[:s0] = s0
      self[:s1] = s1
      self[:s2] = s2
      self[:s3] = s3
    end
  end
  class Half4 < FFI::Struct
    @size = FFI.find_type(:cl_half).size * 4
    @layout = FFI::StructLayout::new([ FFI::StructLayout::Field::new( "s0", FFI.find_type(:cl_half).size * 0, FFI.find_type(:cl_half) ), FFI::StructLayout::Field::new( "s1", FFI.find_type(:cl_half).size * 1, FFI.find_type(:cl_half) ), FFI::StructLayout::Field::new( "s2", FFI.find_type(:cl_half).size * 2, FFI.find_type(:cl_half) ), FFI::StructLayout::Field::new( "s3", FFI.find_type(:cl_half).size * 3, FFI.find_type(:cl_half) ) ], FFI.find_type(:cl_half).size * 4, FFI.find_type(:cl_half).size * 4 )
    def initialize( s0 = 0.0, s1 = 0.0, s2 = 0.0, s3 = 0.0 )
      super()
      self[:s0] = s0
      self[:s1] = s1
      self[:s2] = s2
      self[:s3] = s3
    end
  end
  class Char8 < FFI::Struct
    @size = FFI.find_type(:cl_char).size * 8
    @layout = FFI::StructLayout::new([ FFI::StructLayout::Field::new( "s0", FFI.find_type(:cl_char).size * 0, FFI.find_type(:cl_char) ), FFI::StructLayout::Field::new( "s1", FFI.find_type(:cl_char).size * 1, FFI.find_type(:cl_char) ), FFI::StructLayout::Field::new( "s2", FFI.find_type(:cl_char).size * 2, FFI.find_type(:cl_char) ), FFI::StructLayout::Field::new( "s3", FFI.find_type(:cl_char).size * 3, FFI.find_type(:cl_char) ), FFI::StructLayout::Field::new( "s4", FFI.find_type(:cl_char).size * 4, FFI.find_type(:cl_char) ), FFI::StructLayout::Field::new( "s5", FFI.find_type(:cl_char).size * 5, FFI.find_type(:cl_char) ), FFI::StructLayout::Field::new( "s6", FFI.find_type(:cl_char).size * 6, FFI.find_type(:cl_char) ), FFI::StructLayout::Field::new( "s7", FFI.find_type(:cl_char).size * 7, FFI.find_type(:cl_char) ) ], FFI.find_type(:cl_char).size * 8, FFI.find_type(:cl_char).size * 8 )
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
  end
  class UChar8 < FFI::Struct
    @size = FFI.find_type(:cl_uchar).size * 8
    @layout = FFI::StructLayout::new([ FFI::StructLayout::Field::new( "s0", FFI.find_type(:cl_uchar).size * 0, FFI.find_type(:cl_uchar) ), FFI::StructLayout::Field::new( "s1", FFI.find_type(:cl_uchar).size * 1, FFI.find_type(:cl_uchar) ), FFI::StructLayout::Field::new( "s2", FFI.find_type(:cl_uchar).size * 2, FFI.find_type(:cl_uchar) ), FFI::StructLayout::Field::new( "s3", FFI.find_type(:cl_uchar).size * 3, FFI.find_type(:cl_uchar) ), FFI::StructLayout::Field::new( "s4", FFI.find_type(:cl_uchar).size * 4, FFI.find_type(:cl_uchar) ), FFI::StructLayout::Field::new( "s5", FFI.find_type(:cl_uchar).size * 5, FFI.find_type(:cl_uchar) ), FFI::StructLayout::Field::new( "s6", FFI.find_type(:cl_uchar).size * 6, FFI.find_type(:cl_uchar) ), FFI::StructLayout::Field::new( "s7", FFI.find_type(:cl_uchar).size * 7, FFI.find_type(:cl_uchar) ) ], FFI.find_type(:cl_uchar).size * 8, FFI.find_type(:cl_uchar).size * 8 )
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
  end
  class Short8 < FFI::Struct
    @size = FFI.find_type(:cl_short).size * 8
    @layout = FFI::StructLayout::new([ FFI::StructLayout::Field::new( "s0", FFI.find_type(:cl_short).size * 0, FFI.find_type(:cl_short) ), FFI::StructLayout::Field::new( "s1", FFI.find_type(:cl_short).size * 1, FFI.find_type(:cl_short) ), FFI::StructLayout::Field::new( "s2", FFI.find_type(:cl_short).size * 2, FFI.find_type(:cl_short) ), FFI::StructLayout::Field::new( "s3", FFI.find_type(:cl_short).size * 3, FFI.find_type(:cl_short) ), FFI::StructLayout::Field::new( "s4", FFI.find_type(:cl_short).size * 4, FFI.find_type(:cl_short) ), FFI::StructLayout::Field::new( "s5", FFI.find_type(:cl_short).size * 5, FFI.find_type(:cl_short) ), FFI::StructLayout::Field::new( "s6", FFI.find_type(:cl_short).size * 6, FFI.find_type(:cl_short) ), FFI::StructLayout::Field::new( "s7", FFI.find_type(:cl_short).size * 7, FFI.find_type(:cl_short) ) ], FFI.find_type(:cl_short).size * 8, FFI.find_type(:cl_short).size * 8 )
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
  end
  class UShort8 < FFI::Struct
    @size = FFI.find_type(:cl_ushort).size * 8
    @layout = FFI::StructLayout::new([ FFI::StructLayout::Field::new( "s0", FFI.find_type(:cl_ushort).size * 0, FFI.find_type(:cl_ushort) ), FFI::StructLayout::Field::new( "s1", FFI.find_type(:cl_ushort).size * 1, FFI.find_type(:cl_ushort) ), FFI::StructLayout::Field::new( "s2", FFI.find_type(:cl_ushort).size * 2, FFI.find_type(:cl_ushort) ), FFI::StructLayout::Field::new( "s3", FFI.find_type(:cl_ushort).size * 3, FFI.find_type(:cl_ushort) ), FFI::StructLayout::Field::new( "s4", FFI.find_type(:cl_ushort).size * 4, FFI.find_type(:cl_ushort) ), FFI::StructLayout::Field::new( "s5", FFI.find_type(:cl_ushort).size * 5, FFI.find_type(:cl_ushort) ), FFI::StructLayout::Field::new( "s6", FFI.find_type(:cl_ushort).size * 6, FFI.find_type(:cl_ushort) ), FFI::StructLayout::Field::new( "s7", FFI.find_type(:cl_ushort).size * 7, FFI.find_type(:cl_ushort) ) ], FFI.find_type(:cl_ushort).size * 8, FFI.find_type(:cl_ushort).size * 8 )
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
  end
  class Int8 < FFI::Struct
    @size = FFI.find_type(:cl_int).size * 8
    @layout = FFI::StructLayout::new([ FFI::StructLayout::Field::new( "s0", FFI.find_type(:cl_int).size * 0, FFI.find_type(:cl_int) ), FFI::StructLayout::Field::new( "s1", FFI.find_type(:cl_int).size * 1, FFI.find_type(:cl_int) ), FFI::StructLayout::Field::new( "s2", FFI.find_type(:cl_int).size * 2, FFI.find_type(:cl_int) ), FFI::StructLayout::Field::new( "s3", FFI.find_type(:cl_int).size * 3, FFI.find_type(:cl_int) ), FFI::StructLayout::Field::new( "s4", FFI.find_type(:cl_int).size * 4, FFI.find_type(:cl_int) ), FFI::StructLayout::Field::new( "s5", FFI.find_type(:cl_int).size * 5, FFI.find_type(:cl_int) ), FFI::StructLayout::Field::new( "s6", FFI.find_type(:cl_int).size * 6, FFI.find_type(:cl_int) ), FFI::StructLayout::Field::new( "s7", FFI.find_type(:cl_int).size * 7, FFI.find_type(:cl_int) ) ], FFI.find_type(:cl_int).size * 8, FFI.find_type(:cl_int).size * 8 )
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
  end
  class UInt8 < FFI::Struct
    @size = FFI.find_type(:cl_uint).size * 8
    @layout = FFI::StructLayout::new([ FFI::StructLayout::Field::new( "s0", FFI.find_type(:cl_uint).size * 0, FFI.find_type(:cl_uint) ), FFI::StructLayout::Field::new( "s1", FFI.find_type(:cl_uint).size * 1, FFI.find_type(:cl_uint) ), FFI::StructLayout::Field::new( "s2", FFI.find_type(:cl_uint).size * 2, FFI.find_type(:cl_uint) ), FFI::StructLayout::Field::new( "s3", FFI.find_type(:cl_uint).size * 3, FFI.find_type(:cl_uint) ), FFI::StructLayout::Field::new( "s4", FFI.find_type(:cl_uint).size * 4, FFI.find_type(:cl_uint) ), FFI::StructLayout::Field::new( "s5", FFI.find_type(:cl_uint).size * 5, FFI.find_type(:cl_uint) ), FFI::StructLayout::Field::new( "s6", FFI.find_type(:cl_uint).size * 6, FFI.find_type(:cl_uint) ), FFI::StructLayout::Field::new( "s7", FFI.find_type(:cl_uint).size * 7, FFI.find_type(:cl_uint) ) ], FFI.find_type(:cl_uint).size * 8, FFI.find_type(:cl_uint).size * 8 )
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
  end
  class Long8 < FFI::Struct
    @size = FFI.find_type(:cl_long).size * 8
    @layout = FFI::StructLayout::new([ FFI::StructLayout::Field::new( "s0", FFI.find_type(:cl_long).size * 0, FFI.find_type(:cl_long) ), FFI::StructLayout::Field::new( "s1", FFI.find_type(:cl_long).size * 1, FFI.find_type(:cl_long) ), FFI::StructLayout::Field::new( "s2", FFI.find_type(:cl_long).size * 2, FFI.find_type(:cl_long) ), FFI::StructLayout::Field::new( "s3", FFI.find_type(:cl_long).size * 3, FFI.find_type(:cl_long) ), FFI::StructLayout::Field::new( "s4", FFI.find_type(:cl_long).size * 4, FFI.find_type(:cl_long) ), FFI::StructLayout::Field::new( "s5", FFI.find_type(:cl_long).size * 5, FFI.find_type(:cl_long) ), FFI::StructLayout::Field::new( "s6", FFI.find_type(:cl_long).size * 6, FFI.find_type(:cl_long) ), FFI::StructLayout::Field::new( "s7", FFI.find_type(:cl_long).size * 7, FFI.find_type(:cl_long) ) ], FFI.find_type(:cl_long).size * 8, FFI.find_type(:cl_long).size * 8 )
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
  end
  class ULong8 < FFI::Struct
    @size = FFI.find_type(:cl_ulong).size * 8
    @layout = FFI::StructLayout::new([ FFI::StructLayout::Field::new( "s0", FFI.find_type(:cl_ulong).size * 0, FFI.find_type(:cl_ulong) ), FFI::StructLayout::Field::new( "s1", FFI.find_type(:cl_ulong).size * 1, FFI.find_type(:cl_ulong) ), FFI::StructLayout::Field::new( "s2", FFI.find_type(:cl_ulong).size * 2, FFI.find_type(:cl_ulong) ), FFI::StructLayout::Field::new( "s3", FFI.find_type(:cl_ulong).size * 3, FFI.find_type(:cl_ulong) ), FFI::StructLayout::Field::new( "s4", FFI.find_type(:cl_ulong).size * 4, FFI.find_type(:cl_ulong) ), FFI::StructLayout::Field::new( "s5", FFI.find_type(:cl_ulong).size * 5, FFI.find_type(:cl_ulong) ), FFI::StructLayout::Field::new( "s6", FFI.find_type(:cl_ulong).size * 6, FFI.find_type(:cl_ulong) ), FFI::StructLayout::Field::new( "s7", FFI.find_type(:cl_ulong).size * 7, FFI.find_type(:cl_ulong) ) ], FFI.find_type(:cl_ulong).size * 8, FFI.find_type(:cl_ulong).size * 8 )
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
  end
  class Float8 < FFI::Struct
    @size = FFI.find_type(:cl_float).size * 8
    @layout = FFI::StructLayout::new([ FFI::StructLayout::Field::new( "s0", FFI.find_type(:cl_float).size * 0, FFI.find_type(:cl_float) ), FFI::StructLayout::Field::new( "s1", FFI.find_type(:cl_float).size * 1, FFI.find_type(:cl_float) ), FFI::StructLayout::Field::new( "s2", FFI.find_type(:cl_float).size * 2, FFI.find_type(:cl_float) ), FFI::StructLayout::Field::new( "s3", FFI.find_type(:cl_float).size * 3, FFI.find_type(:cl_float) ), FFI::StructLayout::Field::new( "s4", FFI.find_type(:cl_float).size * 4, FFI.find_type(:cl_float) ), FFI::StructLayout::Field::new( "s5", FFI.find_type(:cl_float).size * 5, FFI.find_type(:cl_float) ), FFI::StructLayout::Field::new( "s6", FFI.find_type(:cl_float).size * 6, FFI.find_type(:cl_float) ), FFI::StructLayout::Field::new( "s7", FFI.find_type(:cl_float).size * 7, FFI.find_type(:cl_float) ) ], FFI.find_type(:cl_float).size * 8, FFI.find_type(:cl_float).size * 8 )
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
  end
  class Double8 < FFI::Struct
    @size = FFI.find_type(:cl_double).size * 8
    @layout = FFI::StructLayout::new([ FFI::StructLayout::Field::new( "s0", FFI.find_type(:cl_double).size * 0, FFI.find_type(:cl_double) ), FFI::StructLayout::Field::new( "s1", FFI.find_type(:cl_double).size * 1, FFI.find_type(:cl_double) ), FFI::StructLayout::Field::new( "s2", FFI.find_type(:cl_double).size * 2, FFI.find_type(:cl_double) ), FFI::StructLayout::Field::new( "s3", FFI.find_type(:cl_double).size * 3, FFI.find_type(:cl_double) ), FFI::StructLayout::Field::new( "s4", FFI.find_type(:cl_double).size * 4, FFI.find_type(:cl_double) ), FFI::StructLayout::Field::new( "s5", FFI.find_type(:cl_double).size * 5, FFI.find_type(:cl_double) ), FFI::StructLayout::Field::new( "s6", FFI.find_type(:cl_double).size * 6, FFI.find_type(:cl_double) ), FFI::StructLayout::Field::new( "s7", FFI.find_type(:cl_double).size * 7, FFI.find_type(:cl_double) ) ], FFI.find_type(:cl_double).size * 8, FFI.find_type(:cl_double).size * 8 )
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
  end
  class Half8 < FFI::Struct
    @size = FFI.find_type(:cl_half).size * 8
    @layout = FFI::StructLayout::new([ FFI::StructLayout::Field::new( "s0", FFI.find_type(:cl_half).size * 0, FFI.find_type(:cl_half) ), FFI::StructLayout::Field::new( "s1", FFI.find_type(:cl_half).size * 1, FFI.find_type(:cl_half) ), FFI::StructLayout::Field::new( "s2", FFI.find_type(:cl_half).size * 2, FFI.find_type(:cl_half) ), FFI::StructLayout::Field::new( "s3", FFI.find_type(:cl_half).size * 3, FFI.find_type(:cl_half) ), FFI::StructLayout::Field::new( "s4", FFI.find_type(:cl_half).size * 4, FFI.find_type(:cl_half) ), FFI::StructLayout::Field::new( "s5", FFI.find_type(:cl_half).size * 5, FFI.find_type(:cl_half) ), FFI::StructLayout::Field::new( "s6", FFI.find_type(:cl_half).size * 6, FFI.find_type(:cl_half) ), FFI::StructLayout::Field::new( "s7", FFI.find_type(:cl_half).size * 7, FFI.find_type(:cl_half) ) ], FFI.find_type(:cl_half).size * 8, FFI.find_type(:cl_half).size * 8 )
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
  end
  class Char16 < FFI::Struct
    @size = FFI.find_type(:cl_char).size * 16
    @layout = FFI::StructLayout::new([ FFI::StructLayout::Field::new( "s0", FFI.find_type(:cl_char).size * 0, FFI.find_type(:cl_char) ), FFI::StructLayout::Field::new( "s1", FFI.find_type(:cl_char).size * 1, FFI.find_type(:cl_char) ), FFI::StructLayout::Field::new( "s2", FFI.find_type(:cl_char).size * 2, FFI.find_type(:cl_char) ), FFI::StructLayout::Field::new( "s3", FFI.find_type(:cl_char).size * 3, FFI.find_type(:cl_char) ), FFI::StructLayout::Field::new( "s4", FFI.find_type(:cl_char).size * 4, FFI.find_type(:cl_char) ), FFI::StructLayout::Field::new( "s5", FFI.find_type(:cl_char).size * 5, FFI.find_type(:cl_char) ), FFI::StructLayout::Field::new( "s6", FFI.find_type(:cl_char).size * 6, FFI.find_type(:cl_char) ), FFI::StructLayout::Field::new( "s7", FFI.find_type(:cl_char).size * 7, FFI.find_type(:cl_char) ), FFI::StructLayout::Field::new( "s8", FFI.find_type(:cl_char).size * 8, FFI.find_type(:cl_char) ), FFI::StructLayout::Field::new( "s9", FFI.find_type(:cl_char).size * 9, FFI.find_type(:cl_char) ), FFI::StructLayout::Field::new( "sa", FFI.find_type(:cl_char).size * 10, FFI.find_type(:cl_char) ), FFI::StructLayout::Field::new( "sb", FFI.find_type(:cl_char).size * 11, FFI.find_type(:cl_char) ), FFI::StructLayout::Field::new( "sc", FFI.find_type(:cl_char).size * 12, FFI.find_type(:cl_char) ), FFI::StructLayout::Field::new( "sd", FFI.find_type(:cl_char).size * 13, FFI.find_type(:cl_char) ), FFI::StructLayout::Field::new( "se", FFI.find_type(:cl_char).size * 14, FFI.find_type(:cl_char) ), FFI::StructLayout::Field::new( "sf", FFI.find_type(:cl_char).size * 15, FFI.find_type(:cl_char) ) ], FFI.find_type(:cl_char).size * 16, FFI.find_type(:cl_char).size * 16 )
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
  end
  class UChar16 < FFI::Struct
    @size = FFI.find_type(:cl_uchar).size * 16
    @layout = FFI::StructLayout::new([ FFI::StructLayout::Field::new( "s0", FFI.find_type(:cl_uchar).size * 0, FFI.find_type(:cl_uchar) ), FFI::StructLayout::Field::new( "s1", FFI.find_type(:cl_uchar).size * 1, FFI.find_type(:cl_uchar) ), FFI::StructLayout::Field::new( "s2", FFI.find_type(:cl_uchar).size * 2, FFI.find_type(:cl_uchar) ), FFI::StructLayout::Field::new( "s3", FFI.find_type(:cl_uchar).size * 3, FFI.find_type(:cl_uchar) ), FFI::StructLayout::Field::new( "s4", FFI.find_type(:cl_uchar).size * 4, FFI.find_type(:cl_uchar) ), FFI::StructLayout::Field::new( "s5", FFI.find_type(:cl_uchar).size * 5, FFI.find_type(:cl_uchar) ), FFI::StructLayout::Field::new( "s6", FFI.find_type(:cl_uchar).size * 6, FFI.find_type(:cl_uchar) ), FFI::StructLayout::Field::new( "s7", FFI.find_type(:cl_uchar).size * 7, FFI.find_type(:cl_uchar) ), FFI::StructLayout::Field::new( "s8", FFI.find_type(:cl_uchar).size * 8, FFI.find_type(:cl_uchar) ), FFI::StructLayout::Field::new( "s9", FFI.find_type(:cl_uchar).size * 9, FFI.find_type(:cl_uchar) ), FFI::StructLayout::Field::new( "sa", FFI.find_type(:cl_uchar).size * 10, FFI.find_type(:cl_uchar) ), FFI::StructLayout::Field::new( "sb", FFI.find_type(:cl_uchar).size * 11, FFI.find_type(:cl_uchar) ), FFI::StructLayout::Field::new( "sc", FFI.find_type(:cl_uchar).size * 12, FFI.find_type(:cl_uchar) ), FFI::StructLayout::Field::new( "sd", FFI.find_type(:cl_uchar).size * 13, FFI.find_type(:cl_uchar) ), FFI::StructLayout::Field::new( "se", FFI.find_type(:cl_uchar).size * 14, FFI.find_type(:cl_uchar) ), FFI::StructLayout::Field::new( "sf", FFI.find_type(:cl_uchar).size * 15, FFI.find_type(:cl_uchar) ) ], FFI.find_type(:cl_uchar).size * 16, FFI.find_type(:cl_uchar).size * 16 )
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
  end
  class Short16 < FFI::Struct
    @size = FFI.find_type(:cl_short).size * 16
    @layout = FFI::StructLayout::new([ FFI::StructLayout::Field::new( "s0", FFI.find_type(:cl_short).size * 0, FFI.find_type(:cl_short) ), FFI::StructLayout::Field::new( "s1", FFI.find_type(:cl_short).size * 1, FFI.find_type(:cl_short) ), FFI::StructLayout::Field::new( "s2", FFI.find_type(:cl_short).size * 2, FFI.find_type(:cl_short) ), FFI::StructLayout::Field::new( "s3", FFI.find_type(:cl_short).size * 3, FFI.find_type(:cl_short) ), FFI::StructLayout::Field::new( "s4", FFI.find_type(:cl_short).size * 4, FFI.find_type(:cl_short) ), FFI::StructLayout::Field::new( "s5", FFI.find_type(:cl_short).size * 5, FFI.find_type(:cl_short) ), FFI::StructLayout::Field::new( "s6", FFI.find_type(:cl_short).size * 6, FFI.find_type(:cl_short) ), FFI::StructLayout::Field::new( "s7", FFI.find_type(:cl_short).size * 7, FFI.find_type(:cl_short) ), FFI::StructLayout::Field::new( "s8", FFI.find_type(:cl_short).size * 8, FFI.find_type(:cl_short) ), FFI::StructLayout::Field::new( "s9", FFI.find_type(:cl_short).size * 9, FFI.find_type(:cl_short) ), FFI::StructLayout::Field::new( "sa", FFI.find_type(:cl_short).size * 10, FFI.find_type(:cl_short) ), FFI::StructLayout::Field::new( "sb", FFI.find_type(:cl_short).size * 11, FFI.find_type(:cl_short) ), FFI::StructLayout::Field::new( "sc", FFI.find_type(:cl_short).size * 12, FFI.find_type(:cl_short) ), FFI::StructLayout::Field::new( "sd", FFI.find_type(:cl_short).size * 13, FFI.find_type(:cl_short) ), FFI::StructLayout::Field::new( "se", FFI.find_type(:cl_short).size * 14, FFI.find_type(:cl_short) ), FFI::StructLayout::Field::new( "sf", FFI.find_type(:cl_short).size * 15, FFI.find_type(:cl_short) ) ], FFI.find_type(:cl_short).size * 16, FFI.find_type(:cl_short).size * 16 )
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
  end
  class UShort16 < FFI::Struct
    @size = FFI.find_type(:cl_ushort).size * 16
    @layout = FFI::StructLayout::new([ FFI::StructLayout::Field::new( "s0", FFI.find_type(:cl_ushort).size * 0, FFI.find_type(:cl_ushort) ), FFI::StructLayout::Field::new( "s1", FFI.find_type(:cl_ushort).size * 1, FFI.find_type(:cl_ushort) ), FFI::StructLayout::Field::new( "s2", FFI.find_type(:cl_ushort).size * 2, FFI.find_type(:cl_ushort) ), FFI::StructLayout::Field::new( "s3", FFI.find_type(:cl_ushort).size * 3, FFI.find_type(:cl_ushort) ), FFI::StructLayout::Field::new( "s4", FFI.find_type(:cl_ushort).size * 4, FFI.find_type(:cl_ushort) ), FFI::StructLayout::Field::new( "s5", FFI.find_type(:cl_ushort).size * 5, FFI.find_type(:cl_ushort) ), FFI::StructLayout::Field::new( "s6", FFI.find_type(:cl_ushort).size * 6, FFI.find_type(:cl_ushort) ), FFI::StructLayout::Field::new( "s7", FFI.find_type(:cl_ushort).size * 7, FFI.find_type(:cl_ushort) ), FFI::StructLayout::Field::new( "s8", FFI.find_type(:cl_ushort).size * 8, FFI.find_type(:cl_ushort) ), FFI::StructLayout::Field::new( "s9", FFI.find_type(:cl_ushort).size * 9, FFI.find_type(:cl_ushort) ), FFI::StructLayout::Field::new( "sa", FFI.find_type(:cl_ushort).size * 10, FFI.find_type(:cl_ushort) ), FFI::StructLayout::Field::new( "sb", FFI.find_type(:cl_ushort).size * 11, FFI.find_type(:cl_ushort) ), FFI::StructLayout::Field::new( "sc", FFI.find_type(:cl_ushort).size * 12, FFI.find_type(:cl_ushort) ), FFI::StructLayout::Field::new( "sd", FFI.find_type(:cl_ushort).size * 13, FFI.find_type(:cl_ushort) ), FFI::StructLayout::Field::new( "se", FFI.find_type(:cl_ushort).size * 14, FFI.find_type(:cl_ushort) ), FFI::StructLayout::Field::new( "sf", FFI.find_type(:cl_ushort).size * 15, FFI.find_type(:cl_ushort) ) ], FFI.find_type(:cl_ushort).size * 16, FFI.find_type(:cl_ushort).size * 16 )
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
  end
  class Int16 < FFI::Struct
    @size = FFI.find_type(:cl_int).size * 16
    @layout = FFI::StructLayout::new([ FFI::StructLayout::Field::new( "s0", FFI.find_type(:cl_int).size * 0, FFI.find_type(:cl_int) ), FFI::StructLayout::Field::new( "s1", FFI.find_type(:cl_int).size * 1, FFI.find_type(:cl_int) ), FFI::StructLayout::Field::new( "s2", FFI.find_type(:cl_int).size * 2, FFI.find_type(:cl_int) ), FFI::StructLayout::Field::new( "s3", FFI.find_type(:cl_int).size * 3, FFI.find_type(:cl_int) ), FFI::StructLayout::Field::new( "s4", FFI.find_type(:cl_int).size * 4, FFI.find_type(:cl_int) ), FFI::StructLayout::Field::new( "s5", FFI.find_type(:cl_int).size * 5, FFI.find_type(:cl_int) ), FFI::StructLayout::Field::new( "s6", FFI.find_type(:cl_int).size * 6, FFI.find_type(:cl_int) ), FFI::StructLayout::Field::new( "s7", FFI.find_type(:cl_int).size * 7, FFI.find_type(:cl_int) ), FFI::StructLayout::Field::new( "s8", FFI.find_type(:cl_int).size * 8, FFI.find_type(:cl_int) ), FFI::StructLayout::Field::new( "s9", FFI.find_type(:cl_int).size * 9, FFI.find_type(:cl_int) ), FFI::StructLayout::Field::new( "sa", FFI.find_type(:cl_int).size * 10, FFI.find_type(:cl_int) ), FFI::StructLayout::Field::new( "sb", FFI.find_type(:cl_int).size * 11, FFI.find_type(:cl_int) ), FFI::StructLayout::Field::new( "sc", FFI.find_type(:cl_int).size * 12, FFI.find_type(:cl_int) ), FFI::StructLayout::Field::new( "sd", FFI.find_type(:cl_int).size * 13, FFI.find_type(:cl_int) ), FFI::StructLayout::Field::new( "se", FFI.find_type(:cl_int).size * 14, FFI.find_type(:cl_int) ), FFI::StructLayout::Field::new( "sf", FFI.find_type(:cl_int).size * 15, FFI.find_type(:cl_int) ) ], FFI.find_type(:cl_int).size * 16, FFI.find_type(:cl_int).size * 16 )
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
  end
  class UInt16 < FFI::Struct
    @size = FFI.find_type(:cl_uint).size * 16
    @layout = FFI::StructLayout::new([ FFI::StructLayout::Field::new( "s0", FFI.find_type(:cl_uint).size * 0, FFI.find_type(:cl_uint) ), FFI::StructLayout::Field::new( "s1", FFI.find_type(:cl_uint).size * 1, FFI.find_type(:cl_uint) ), FFI::StructLayout::Field::new( "s2", FFI.find_type(:cl_uint).size * 2, FFI.find_type(:cl_uint) ), FFI::StructLayout::Field::new( "s3", FFI.find_type(:cl_uint).size * 3, FFI.find_type(:cl_uint) ), FFI::StructLayout::Field::new( "s4", FFI.find_type(:cl_uint).size * 4, FFI.find_type(:cl_uint) ), FFI::StructLayout::Field::new( "s5", FFI.find_type(:cl_uint).size * 5, FFI.find_type(:cl_uint) ), FFI::StructLayout::Field::new( "s6", FFI.find_type(:cl_uint).size * 6, FFI.find_type(:cl_uint) ), FFI::StructLayout::Field::new( "s7", FFI.find_type(:cl_uint).size * 7, FFI.find_type(:cl_uint) ), FFI::StructLayout::Field::new( "s8", FFI.find_type(:cl_uint).size * 8, FFI.find_type(:cl_uint) ), FFI::StructLayout::Field::new( "s9", FFI.find_type(:cl_uint).size * 9, FFI.find_type(:cl_uint) ), FFI::StructLayout::Field::new( "sa", FFI.find_type(:cl_uint).size * 10, FFI.find_type(:cl_uint) ), FFI::StructLayout::Field::new( "sb", FFI.find_type(:cl_uint).size * 11, FFI.find_type(:cl_uint) ), FFI::StructLayout::Field::new( "sc", FFI.find_type(:cl_uint).size * 12, FFI.find_type(:cl_uint) ), FFI::StructLayout::Field::new( "sd", FFI.find_type(:cl_uint).size * 13, FFI.find_type(:cl_uint) ), FFI::StructLayout::Field::new( "se", FFI.find_type(:cl_uint).size * 14, FFI.find_type(:cl_uint) ), FFI::StructLayout::Field::new( "sf", FFI.find_type(:cl_uint).size * 15, FFI.find_type(:cl_uint) ) ], FFI.find_type(:cl_uint).size * 16, FFI.find_type(:cl_uint).size * 16 )
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
  end
  class Long16 < FFI::Struct
    @size = FFI.find_type(:cl_long).size * 16
    @layout = FFI::StructLayout::new([ FFI::StructLayout::Field::new( "s0", FFI.find_type(:cl_long).size * 0, FFI.find_type(:cl_long) ), FFI::StructLayout::Field::new( "s1", FFI.find_type(:cl_long).size * 1, FFI.find_type(:cl_long) ), FFI::StructLayout::Field::new( "s2", FFI.find_type(:cl_long).size * 2, FFI.find_type(:cl_long) ), FFI::StructLayout::Field::new( "s3", FFI.find_type(:cl_long).size * 3, FFI.find_type(:cl_long) ), FFI::StructLayout::Field::new( "s4", FFI.find_type(:cl_long).size * 4, FFI.find_type(:cl_long) ), FFI::StructLayout::Field::new( "s5", FFI.find_type(:cl_long).size * 5, FFI.find_type(:cl_long) ), FFI::StructLayout::Field::new( "s6", FFI.find_type(:cl_long).size * 6, FFI.find_type(:cl_long) ), FFI::StructLayout::Field::new( "s7", FFI.find_type(:cl_long).size * 7, FFI.find_type(:cl_long) ), FFI::StructLayout::Field::new( "s8", FFI.find_type(:cl_long).size * 8, FFI.find_type(:cl_long) ), FFI::StructLayout::Field::new( "s9", FFI.find_type(:cl_long).size * 9, FFI.find_type(:cl_long) ), FFI::StructLayout::Field::new( "sa", FFI.find_type(:cl_long).size * 10, FFI.find_type(:cl_long) ), FFI::StructLayout::Field::new( "sb", FFI.find_type(:cl_long).size * 11, FFI.find_type(:cl_long) ), FFI::StructLayout::Field::new( "sc", FFI.find_type(:cl_long).size * 12, FFI.find_type(:cl_long) ), FFI::StructLayout::Field::new( "sd", FFI.find_type(:cl_long).size * 13, FFI.find_type(:cl_long) ), FFI::StructLayout::Field::new( "se", FFI.find_type(:cl_long).size * 14, FFI.find_type(:cl_long) ), FFI::StructLayout::Field::new( "sf", FFI.find_type(:cl_long).size * 15, FFI.find_type(:cl_long) ) ], FFI.find_type(:cl_long).size * 16, FFI.find_type(:cl_long).size * 16 )
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
  end
  class ULong16 < FFI::Struct
    @size = FFI.find_type(:cl_ulong).size * 16
    @layout = FFI::StructLayout::new([ FFI::StructLayout::Field::new( "s0", FFI.find_type(:cl_ulong).size * 0, FFI.find_type(:cl_ulong) ), FFI::StructLayout::Field::new( "s1", FFI.find_type(:cl_ulong).size * 1, FFI.find_type(:cl_ulong) ), FFI::StructLayout::Field::new( "s2", FFI.find_type(:cl_ulong).size * 2, FFI.find_type(:cl_ulong) ), FFI::StructLayout::Field::new( "s3", FFI.find_type(:cl_ulong).size * 3, FFI.find_type(:cl_ulong) ), FFI::StructLayout::Field::new( "s4", FFI.find_type(:cl_ulong).size * 4, FFI.find_type(:cl_ulong) ), FFI::StructLayout::Field::new( "s5", FFI.find_type(:cl_ulong).size * 5, FFI.find_type(:cl_ulong) ), FFI::StructLayout::Field::new( "s6", FFI.find_type(:cl_ulong).size * 6, FFI.find_type(:cl_ulong) ), FFI::StructLayout::Field::new( "s7", FFI.find_type(:cl_ulong).size * 7, FFI.find_type(:cl_ulong) ), FFI::StructLayout::Field::new( "s8", FFI.find_type(:cl_ulong).size * 8, FFI.find_type(:cl_ulong) ), FFI::StructLayout::Field::new( "s9", FFI.find_type(:cl_ulong).size * 9, FFI.find_type(:cl_ulong) ), FFI::StructLayout::Field::new( "sa", FFI.find_type(:cl_ulong).size * 10, FFI.find_type(:cl_ulong) ), FFI::StructLayout::Field::new( "sb", FFI.find_type(:cl_ulong).size * 11, FFI.find_type(:cl_ulong) ), FFI::StructLayout::Field::new( "sc", FFI.find_type(:cl_ulong).size * 12, FFI.find_type(:cl_ulong) ), FFI::StructLayout::Field::new( "sd", FFI.find_type(:cl_ulong).size * 13, FFI.find_type(:cl_ulong) ), FFI::StructLayout::Field::new( "se", FFI.find_type(:cl_ulong).size * 14, FFI.find_type(:cl_ulong) ), FFI::StructLayout::Field::new( "sf", FFI.find_type(:cl_ulong).size * 15, FFI.find_type(:cl_ulong) ) ], FFI.find_type(:cl_ulong).size * 16, FFI.find_type(:cl_ulong).size * 16 )
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
  end
  class Float16 < FFI::Struct
    @size = FFI.find_type(:cl_float).size * 16
    @layout = FFI::StructLayout::new([ FFI::StructLayout::Field::new( "s0", FFI.find_type(:cl_float).size * 0, FFI.find_type(:cl_float) ), FFI::StructLayout::Field::new( "s1", FFI.find_type(:cl_float).size * 1, FFI.find_type(:cl_float) ), FFI::StructLayout::Field::new( "s2", FFI.find_type(:cl_float).size * 2, FFI.find_type(:cl_float) ), FFI::StructLayout::Field::new( "s3", FFI.find_type(:cl_float).size * 3, FFI.find_type(:cl_float) ), FFI::StructLayout::Field::new( "s4", FFI.find_type(:cl_float).size * 4, FFI.find_type(:cl_float) ), FFI::StructLayout::Field::new( "s5", FFI.find_type(:cl_float).size * 5, FFI.find_type(:cl_float) ), FFI::StructLayout::Field::new( "s6", FFI.find_type(:cl_float).size * 6, FFI.find_type(:cl_float) ), FFI::StructLayout::Field::new( "s7", FFI.find_type(:cl_float).size * 7, FFI.find_type(:cl_float) ), FFI::StructLayout::Field::new( "s8", FFI.find_type(:cl_float).size * 8, FFI.find_type(:cl_float) ), FFI::StructLayout::Field::new( "s9", FFI.find_type(:cl_float).size * 9, FFI.find_type(:cl_float) ), FFI::StructLayout::Field::new( "sa", FFI.find_type(:cl_float).size * 10, FFI.find_type(:cl_float) ), FFI::StructLayout::Field::new( "sb", FFI.find_type(:cl_float).size * 11, FFI.find_type(:cl_float) ), FFI::StructLayout::Field::new( "sc", FFI.find_type(:cl_float).size * 12, FFI.find_type(:cl_float) ), FFI::StructLayout::Field::new( "sd", FFI.find_type(:cl_float).size * 13, FFI.find_type(:cl_float) ), FFI::StructLayout::Field::new( "se", FFI.find_type(:cl_float).size * 14, FFI.find_type(:cl_float) ), FFI::StructLayout::Field::new( "sf", FFI.find_type(:cl_float).size * 15, FFI.find_type(:cl_float) ) ], FFI.find_type(:cl_float).size * 16, FFI.find_type(:cl_float).size * 16 )
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
  end
  class Double16 < FFI::Struct
    @size = FFI.find_type(:cl_double).size * 16
    @layout = FFI::StructLayout::new([ FFI::StructLayout::Field::new( "s0", FFI.find_type(:cl_double).size * 0, FFI.find_type(:cl_double) ), FFI::StructLayout::Field::new( "s1", FFI.find_type(:cl_double).size * 1, FFI.find_type(:cl_double) ), FFI::StructLayout::Field::new( "s2", FFI.find_type(:cl_double).size * 2, FFI.find_type(:cl_double) ), FFI::StructLayout::Field::new( "s3", FFI.find_type(:cl_double).size * 3, FFI.find_type(:cl_double) ), FFI::StructLayout::Field::new( "s4", FFI.find_type(:cl_double).size * 4, FFI.find_type(:cl_double) ), FFI::StructLayout::Field::new( "s5", FFI.find_type(:cl_double).size * 5, FFI.find_type(:cl_double) ), FFI::StructLayout::Field::new( "s6", FFI.find_type(:cl_double).size * 6, FFI.find_type(:cl_double) ), FFI::StructLayout::Field::new( "s7", FFI.find_type(:cl_double).size * 7, FFI.find_type(:cl_double) ), FFI::StructLayout::Field::new( "s8", FFI.find_type(:cl_double).size * 8, FFI.find_type(:cl_double) ), FFI::StructLayout::Field::new( "s9", FFI.find_type(:cl_double).size * 9, FFI.find_type(:cl_double) ), FFI::StructLayout::Field::new( "sa", FFI.find_type(:cl_double).size * 10, FFI.find_type(:cl_double) ), FFI::StructLayout::Field::new( "sb", FFI.find_type(:cl_double).size * 11, FFI.find_type(:cl_double) ), FFI::StructLayout::Field::new( "sc", FFI.find_type(:cl_double).size * 12, FFI.find_type(:cl_double) ), FFI::StructLayout::Field::new( "sd", FFI.find_type(:cl_double).size * 13, FFI.find_type(:cl_double) ), FFI::StructLayout::Field::new( "se", FFI.find_type(:cl_double).size * 14, FFI.find_type(:cl_double) ), FFI::StructLayout::Field::new( "sf", FFI.find_type(:cl_double).size * 15, FFI.find_type(:cl_double) ) ], FFI.find_type(:cl_double).size * 16, FFI.find_type(:cl_double).size * 16 )
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
  end
  class Half16 < FFI::Struct
    @size = FFI.find_type(:cl_half).size * 16
    @layout = FFI::StructLayout::new([ FFI::StructLayout::Field::new( "s0", FFI.find_type(:cl_half).size * 0, FFI.find_type(:cl_half) ), FFI::StructLayout::Field::new( "s1", FFI.find_type(:cl_half).size * 1, FFI.find_type(:cl_half) ), FFI::StructLayout::Field::new( "s2", FFI.find_type(:cl_half).size * 2, FFI.find_type(:cl_half) ), FFI::StructLayout::Field::new( "s3", FFI.find_type(:cl_half).size * 3, FFI.find_type(:cl_half) ), FFI::StructLayout::Field::new( "s4", FFI.find_type(:cl_half).size * 4, FFI.find_type(:cl_half) ), FFI::StructLayout::Field::new( "s5", FFI.find_type(:cl_half).size * 5, FFI.find_type(:cl_half) ), FFI::StructLayout::Field::new( "s6", FFI.find_type(:cl_half).size * 6, FFI.find_type(:cl_half) ), FFI::StructLayout::Field::new( "s7", FFI.find_type(:cl_half).size * 7, FFI.find_type(:cl_half) ), FFI::StructLayout::Field::new( "s8", FFI.find_type(:cl_half).size * 8, FFI.find_type(:cl_half) ), FFI::StructLayout::Field::new( "s9", FFI.find_type(:cl_half).size * 9, FFI.find_type(:cl_half) ), FFI::StructLayout::Field::new( "sa", FFI.find_type(:cl_half).size * 10, FFI.find_type(:cl_half) ), FFI::StructLayout::Field::new( "sb", FFI.find_type(:cl_half).size * 11, FFI.find_type(:cl_half) ), FFI::StructLayout::Field::new( "sc", FFI.find_type(:cl_half).size * 12, FFI.find_type(:cl_half) ), FFI::StructLayout::Field::new( "sd", FFI.find_type(:cl_half).size * 13, FFI.find_type(:cl_half) ), FFI::StructLayout::Field::new( "se", FFI.find_type(:cl_half).size * 14, FFI.find_type(:cl_half) ), FFI::StructLayout::Field::new( "sf", FFI.find_type(:cl_half).size * 15, FFI.find_type(:cl_half) ) ], FFI.find_type(:cl_half).size * 16, FFI.find_type(:cl_half).size * 16 )
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
  end
end

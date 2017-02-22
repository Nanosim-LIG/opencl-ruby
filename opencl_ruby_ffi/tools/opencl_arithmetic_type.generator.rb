base_directory = "../lib/opencl_ruby_ffi"
$types = { :cl_char   => 0,
           :cl_uchar  => 0,
           :cl_short  => 0,
           :cl_ushort => 0,
           :cl_int    => 0,
           :cl_uint   => 0,
           :cl_long   => 0,
           :cl_ulong  => 0,
           :cl_float  => 0.0,
           :cl_double => 0.0,
           :cl_half   => 0.0 }

def generate_arithmetic_type( output, type, vector_length = 1 )

  klass_name = "#{type}".sub("cl_","").capitalize
  klass_name += "#{vector_length}"
  klass_name[1] = klass_name[1].upcase if klass_name[0] == "U"
  member_corresp = { }
  i = 0
  (0..9).each { |c|
    member_corresp[i] = c
    i += 1
  }
  ('a'..'f').each { |c|
    member_corresp[i] = c
    i += 1
  }

  members = []
  members_decl = []
  members_init = []
  members_reader = []
  members_seter = []
  members_printer = []
  vector_length.times { |i|
    members.push( "OpenCL::StructLayout::Field::new( \"s#{member_corresp[i]}\", OpenCL.find_type(:#{type}).size * #{i}, OpenCL.find_type(:#{type}) )" )
    members_decl.push( "s#{member_corresp[i]} = #{$types[type]}" )
    members_init.push( "self[:s#{member_corresp[i]}] = s#{member_corresp[i]}" )
    members_reader.push( "# Reads the s#{member_corresp[i]} member\n    def s#{member_corresp[i]}\n     return self[:s#{member_corresp[i]}]\n    end" )
    members_seter.push( "# Sets the s#{member_corresp[i]} member to value\n    def s#{member_corresp[i]}=(value)\n     self[:s#{member_corresp[i]}] = value\n    end" )
    members_printer.push( "\#{self[:s#{member_corresp[i]}]}" )
  }
  output.puts <<EOF
  # Maps the #{type}#{vector_length > 1 ? vector_length : nil} type of OpenCL
  class #{klass_name} < Struct
    @size = OpenCL.find_type(:#{type}).size * #{vector_length}
    @layout = OpenCL::StructLayout::new([ #{members.join(", ")} ], OpenCL.find_type(:#{type}).size * #{vector_length}, OpenCL.find_type(:#{type}).size * #{vector_length} )
    # Creates a new #{klass_name} with members set to 0 or to the user specified values. If a Pointer is passed as the first argument, #{klass_name} maps the memory pointed.
    def initialize( #{members_decl.join(', ')} )
      if s0.is_a?(FFI::Pointer) then
        super(s0)
      else
        super()
        #{members_init.join("\n        ")}
      end
    end
    #{members_reader.join("\n    ")}
    #{members_seter.join("\n    ")}

    def inspect
      return "#<\#{self.class.name}: #{members_printer.join(", ")}>"
    end

    def to_s
      return "#{klass_name}{ #{members_printer.join(", ")} }"
    end
  end
EOF
  if vector_length == 1 then
    output.puts "  #{klass_name[0..-2]} = OpenCL.find_type(:#{type})"
  end
end

sizes = [ 1, 2, 4, 8, 16]

output = File::new(base_directory+"/"+"opencl_arithmetic_gen.rb","w+")
output.puts "module OpenCL"
sizes.each { |s|
  $types.each_key { |t|
    generate_arithmetic_type(output, t, s)
  }
}
output.puts "end"
output.close

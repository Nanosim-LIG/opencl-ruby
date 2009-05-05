require "erb"
require "pp"

fname = ARGV.shift || "./include/cl.h"


class String
  def camelcase
    self.split("_").map{|s| s.capitalize.sub(/(\d)d\z/,'\1D')}.join
  end
  def decamelcase
    str = self
    while /\A(.*)([A-Z])(.*)\z/ =~ str
      str = $1 + "_" + $2.downcase + $3
    end
    return str.sub(/\A_/,"")
  end
end

def c2r(name, type)
  if type.is_a?(String) && /\Acl_/=~ type
    s = @typedef[type]
    unless s
      case type
      when "cl_int"
        s = :int
      else
        raise "invalid: #{type}"
      end
    end
    type = s
  end
  case type
  when :int
    return "INT2NUM(#{name})"
  when :uint
    return "UINT2NUM(#{name})"
  when :ulong
    return "ULONG2NUM(#{name})"
  when "void*"
    return "rb_str_new2(#{name})"
  when "size_t"
    return "ULONG2NUM(#{name})"
  else
    raise "not supported yet: #{type}"
  end
end

def r2c(name, type)
  if type.is_a?(String) && /\Acl_/=~ type
    s = @typedef[type]
    unless s
      raise "invalid: #{type}"
    end
    type = s
  end
  case type
  when :int
    return "NUM2INT(#{name})"
  when :uint
    return "NUM2UINT(#{name})"
  when :ulong, "size_t"
    return "NUM2ULONG(#{name})"
  when "void*", "char*", "unsigned char*"
    return "(#{type}) RSTRING_PTR(#{name})"
  else
    raise "not supported yet: #{type}"
  end
end

def default_value(type, ptr)
  if ptr
    return "NULL"
  end
  case type
  when "size_t"
    return "0"
  else
    raise "not supported yet: #{type}"
  end
end


def data_get_struct(type, cname=nil, rname=nil, indent=2)
  type2 = type.sub(/\Acl_/,"").sub(/_id\z/,"")
  klass = type2.camelcase
  dep = @klass_deps[klass]
  cname ||= type2
  rname ||= "rb_#{cname}"
  indent = " "*indent
  prefix = dep ? "struct" : "cl"
  suffix = (type2=="device" || type2=="platform") ? "_id" : ""
  ptr = type2=="image_format" ? "*" : ""
  ERB.new(<<EOF, nil, 2).result(binding)
Check_Type(<%=rname%>, T_DATA);
<%=indent%>if (CLASS_OF(<%=rname%>) != rb_c<%=klass%>)
<%=indent%>  rb_raise(rb_eRuntimeError, "type of <%=cname%> is invalid: <%=klass%> is expected");
<%=indent%><%=cname%> = <%=dep ? "(" : ""%>(<%=prefix%>_<%=type2%><%=suffix%><%=ptr%>)DATA_PTR(<%=rname%>)<%=dep ? ")->"+type2 : ""%>;
EOF
end

def get_arg(name, arg_hash, arg_names, knames, alloc, nindent=2, num=nil)
  type = arg_hash[:type]
  type2 = "#{type}#{arg_hash[:ptr]}".sub(/\*\z/,"")
  indent = " "*nindent
  ERB.new(<<EOF, nil, 2).result(binding)
<% if knames.include?(type.sub(/\\Acl_/,"").sub(/_id\\z/,"")) %>
<%   if arg_hash[:ptr] && type != "cl_image_format" %>
Check_Type(rb_<%=name%>, T_ARRAY);
<%=indent%>{
<%=indent%>  int n;
<%     sarg = arg_names.find{|an| an=="num_\#{name.sub(/_list\\z/,"s")}" || (name=="event_wait_list"&&an=="num_events_in_wait_list") || (name=="mem_list"&&an=="num_mem_objects")} %>
<%     unless sarg %>
<%       raise "size argument was not found: \#{name}, \#{name}" %>
<%     end %>
<%     num << sarg if num %>
<%=indent%>  <%=sarg%> = RARRAY_LEN(rb_<%=name%>);
<%=indent%>  <%=name%> = ALLOC_N(<%=type2%>, <%=sarg%>);
<%     alloc.push name %>
<%=indent%>  for (n=0; n<<%=sarg%>; n++) {
<%=indent%>    <%=data_get_struct(type2, "\#{name}[n]", "RARRAY_PTR(rb_\#{name})[n]", nindent+4)%>
<%=indent%>  }
<%=indent%>}
<%   else %>
<%=data_get_struct(type2, name, nil, nindent)%>
<%   end %>
<% elsif name=="args_mem_loc" || /\\A(strings|binaries)\\z/=~name || /\\A(global|local)_work_size\\z/=~name || /(origin|region)\\z/ =~ name %>
<%   if arg_hash[:size] %>
<%     n = arg_hash[:size] %>
<%   else %>
<%     n = {"args_mem_loc"=>"num_mem_objects","strings"=>"count","binaries"=>"num_devices","global_work_size"=>"work_dim","local_work_size"=>"work_dim"}[name] %>
<%     unless n %>
<%       raise "size argument was not found: \#{name}, \#{name}" %>
<%     end %>
<%   end %>
Check_Type(rb_<%=name%>, T_ARRAY);
<%   unless arg_hash[:size] || name=="args_mem_loc" || name=="local_work_size" || name=="binaries" %>
<%=indent%><%=n%> = RARRAY_LEN(rb_<%=name%>);
<%   end %>
<%=indent%>{
<%=indent%>  int n;
<%=indent%>  <%=name%> = ALLOC_N(<%=type2%>, <%=n%>);
<%   alloc.push name %>
<%   if name=="strings" || name=="binaries" %>
<%=indent%>  lengths = ALLOC_N(size_t, <%=n%>);
<%   alloc.push "lengths" %>
<%   end %>
<%=indent%>  for (n=0; n<<%=n%>; n++) {
<%=indent%>    <%=name%>[n] = <%=r2c("RARRAY_PTR(rb_\#{name})[n]", type2)%>;
<%   if name=="strings" %>
<%=indent%>    lengths[n] = 0;
<%   elsif name=="binaries" %>
<%=indent%>    lengths[n] = RSTRING_LEN(RARRAY_PTR(rb_<%=name%>)[n]);
<%   end %>
<%=indent%>  }
  }
<% else %>
<%=name%> = <%=r2c("rb_\#{name}", "\#{type}\#{arg_hash[:ptr]}")%>;
<% end %>
EOF
end

def get_output(name, type, size, knames, indent=4)
  indent = " "*indent
  type2 = type.sub(/\Acl_/,"").sub(/_id\z/,"")
  klass = type2.camelcase
  dep = @klass_deps[klass]
  ERB.new(<<EOF, nil, 2).result(binding)
<% if knames.include?(type.sub(/\\Acl_/,"").sub(/_id\\z/,"")) %>
<%   if dep %>
{
<%=indent%>  struct_<%=type2%> s_<%=name%>;
<%=indent%>  s_<%=name%> = (struct_<%=type2%>)xmalloc(sizeof(struct _struct_<%=type2%>));
<%=indent%>  s_<%=name%>-><%=type2%> = <%=name%>;
<%     dep.each do |dp| %>
<%=indent%>  s_<%=name%>-><%=dp%> = rb_<%=dp%>;
<%     end %>
<%   end %>
<%   if size %>
<%     raise("both of size and dep are not supported") if dep %>
<%=dep ? indent+"  " : ""%>{
<%=indent%>  VALUE ary[<%=size%>];
<%=indent%>  int ii;
<%=indent%>  for (ii=0; ii<<%=size%>; ii++)
<%=indent%>    ary[ii] = create_<%=type2%>(<%=type2=="image_format" ? "&" : ""%><%=name%>[ii]);
<%=indent%>  rb_<%=name%> = rb_ary_new4(<%=size%>, ary);
<%=indent%>}
<%   else %>
<%=dep ? indent+"  " : ""%>rb_<%=name%> = create_<%=type2%>(<%=dep ? "s_" : ""%><%=name%>);
<%   end %>
<%   if dep %>
<%=indent%>}
<%   end %>
<% else %>
<%   if size %>
<%=dep ? indent+"  " : ""%>{
<%=indent%>  VALUE ary[<%=size%>];
<%=indent%>  int ii;
<%=indent%>  for (ii=0; ii<<%=size%>; ii++)
<%=indent%>    ary[ii] = c2r(name, type);
<%=indent%>  rb_<%=name%> = rb_ary_new4(<%=size%>, ary);
<%=indent%>}
<%   else %>
rb_<%=name%> = <%=c2r(name, type)%>;
<%   end %>
<% end %>
EOF
end


def create_method(klass)
  name = klass.decamelcase

  ptr = name == "image_format" ? "*" : ""
  dep = @klass_deps[klass]
  type = "#{dep ? "struct" : "cl"}_#{name}#{(name=="platform" || name=="device") ? "_id" : ""}"
  kname =  klass=="Mem" ? "MemObject" : klass
  free = @apis["clRelease#{kname}"]

  ERB.new(<<EOF, nil, 2).result(binding)

<% if free %>
static void
<%=name%>_free(<%=type%> <%=name%>)
{
  clRelease<%=kname%>(<%=name%><%= dep ? "->#{name}" : ""%>);
<%   if dep %>
  free(<%=name%>);
<%   end %>
}
<% end %>
<% if name == "image_format"%>
static void
<%=name%>_free(<%=type%> *<%=name%>)
{
  free(<%=name%>);
}
<% end %>
<% if dep %>
static void
<%=name%>_mark(<%=type%> <%=name%>)
{
<%  dep.each do |dn| %>
  if (<%=name%>-><%=dn%>)
    rb_gc_mark(<%=name%>-><%=dn%>);
<% end %>
}
<% end %>
static VALUE
create_<%=name%>(<%=type%> <%=ptr%><%=name%>)
{
<% if free %>
  clRetain<%=kname%>(<%=name%><%= dep ? "->#{name}" : ""%>);
<% elsif name=="image_format" %>
<%   free = true %>
<% end %>
  return Data_Wrap_Struct(rb_c<%=klass%>, <%=dep ? name+"_mark" : 0%>, <%=free ? name+"_free" : 0%>, (void*)<%=name%>);
}
EOF
end


def rb_api(name, hash)
  type = hash[:type]
  ptr = hash[:ptr]
  arg_names = hash[:arg_names]
  arg_hash = hash[:arg_hash]
  func = hash[:func]

  inputs = Array.new
  opts = Array.new
  outputs = Array.new
  knames = @klass_names.map{|k| k.decamelcase} + ["memobj"]
  kname_lists = knames.map{|k| k+"s"}
  innames = %w(properties user_data enable size image_type normalized_coords addressing_mode filter_mode src_buffer src_image dst_buffer dst_image arg_index args)
  outnames = %w(param_value old_properties binary_status)
  optnames = %w(host_ptr image_width image_height image_depth ptr cb event_wait_list cb_args)
  const_optnames = %w(event_wait_list)
  const_ignores = %w(lengths  global_work_offset)
  ignores = %w(work_dim mapped_ptr)
  arg_names.each do |aname|
    next if aname == "##func##"
    arg = arg_hash[aname]
    atype = arg[:type]
    if arg[:const]
      if const_ignores.include?(aname)
        next
      elsif /(origin|region|offset)/=~aname || const_optnames.include?(aname)
        opts.push aname
      else
        inputs.push aname
      end
    else
      if /_(info|flags)\z/=~atype || /(\Ablocking_|_type\z)/=~aname || (innames.include?(aname)&&atype!="cl_context_properties") || (knames.include?(aname)&&(aname!="event"||!arg[:ptr]))
        inputs.push aname
      elsif (/_pitch\z/=~aname&&arg[:ptr]) || aname=="event" || outnames.include?(aname) || kname_lists.include?(aname)
        outputs.push aname
      elsif (/_pitch\z/=~aname&&!arg[:ptr]) || /offset\z/=~aname || optnames.include?(aname)
        opts.push aname
      elsif /\Anum_/=~aname || /_size\z/=~aname || /_ret\z/=~aname || /\Acount\z/=~aname || aname=="##func##" || ignores.include?(aname) || atype=="cl_context_properties"
        next
      else
        raise "parse error: #{name}, #{aname}, #{arg.inspect}"
      end
    end
  end

  outputs.each do |output|
   if /s\z/=~output && (output!="old_properties") && (output!="binary_status")
     n = arg_names.find{|ar| (/\Anum_#{output}\z/=~ar&&(!arg_hash[ar][:ptr]))}
     unless n
         n = "num_entries" if arg_names.include?("num_entries")
       raise("size cannot found: #{name}, #{output}") unless n
     end
     arg_hash[output][:size] = n
   end
 end

  ERB.new(<<EOF, nil, 2).result(binding)
<% if func %>
void
<%=name%>_<%=func[:name]%>(<%=func[:args].join(", ")%>)
{
}
<% end %>
VALUE
rb_<%=name%>(int argc, VALUE *argv, VALUE self)
{
<% arg_names.each_with_index do |arg,i| %>
<%   next if arg == "##func##" %>
<%   ah = arg_hash[arg] %>
<%   ap = ah[:ptr] %>
<%   if (outputs.include?(arg) && !ah[:size] && ah[:type]!="void") || /_ret\\z/ =~arg || (/\\AclGet/=~name && /\\Anum_.+s\\z/=~arg && arg!="num_entries") %>
<%     ap = nil %>
<%     arg_names[i] = "&"+arg %>
<%   end %>
  <%=ah[:type]%> <%=ap%><%=arg%>;
<%   kn = ah[:type].sub(/\\Acl_/,"").sub(/_id\\z/,"").camelcase %>
<%   if @klass_names.include?(kn) && @klass_deps[kn] && outputs.include?(arg) %>
  struct_<%=kn.decamelcase%> <%=ah[:ptr]%>s_<%=arg%>;
<%   end %>
<% end %>
  <%=type%> <%=ptr%>ret;
<% (inputs+opts+outputs).each do |input| %>
  VALUE rb_<%=input%> = Qnil;
<% end %>

  VALUE result;

  if (argc > <%=inputs.length + 1 + (func ? 1 : 0)%>)
    rb_raise(rb_eArgError, "wrong number of arguments (%d for %d)", argc, <%=inputs.length%>);

<% if (ah=arg_hash["properties"]) && (ah[:type] == "cl_context_properties") %>
  properties = NULL;
<% end %>
<% if arg_names.include?("global_work_offset") %>
  global_work_offset = NULL;
<% end %>
<% if arg_names.include?("mapped_ptr") %>
  mapped_ptr = NULL;
<% end %>
<% alloc = Array.new %>
  if (argc < <%=inputs.length%>)
    rb_raise(rb_eArgError, "wrong number of arguments (%d for <%=inputs.length%>)", argc);
<% inputs.each_with_index do |input,i| %>
  rb_<%=input%> = argv[<%=i%>];
  <%=get_arg(input, arg_hash[input], arg_names, knames, alloc, 2)%>
<% end %>

<% if opts.length > 0 %>
  {
    VALUE _opt_hash = Qnil;

    if (argc > <%=inputs.length%>) {
      _opt_hash = argv[<%=inputs.length%>];
      Check_Type(_opt_hash, T_HASH);
    }
<%   opts.each do |opt| %>
    if (_opt_hash != Qnil) {
      rb_<%=opt%> = rb_hash_aref(_opt_hash, rb_intern("<%=opt%>"));
    }
    if (_opt_hash != Qnil && rb_<%=opt%> != Qnil) {
<%     num = "" %>
      <%=get_arg(opt, arg_hash[opt], arg_names, knames, alloc, 6, num)%>
    } else {
      <%=opt%> = <%=default_value(arg_hash[opt][:type], arg_hash[opt][:ptr])%>;
<%     if num != "" %>
      <%=num%> = 0;
<%     end %>
    }
<%   end %>
  }
<% end %>

<% if func %>
<%   m = arg_names.index("##func##") %>
<%   raise("bug") unless m %>
<%   arg_names = arg_names.dup %>
<%   arg_names[m] = "\#{name}_\#{func[:name]}" %>
<% end %>
<% if arg_names.include?("arg_size") %>
  arg_size = RSTRING_LEN(rb_arg_value);
<% end %>

<% if /\\AclGet/ =~ name || name == "clCreateKernelsInProgram" %>
<%   case name %>
<%   when /Info\\z/ %>
<%     size = "param_value_size" %>
<%     size_ret = "param_value_size_ret" %>
<%     value = "param_value" %>
<%   when /\\AclGet/ %>
<%     size = "num_entries" %>
<%     size_ret = arg_names.find{|an| /\\A\&num_/=~an}.sub(/\\A\&/,"") %>
<%     raise("size parameter was not found: \#{name}, \#{arg_names.inspect}") unless size_ret %>
<%     value = size_ret.sub(/\\Anum_/,"") %>
<%     raise("size_ret parameter was not found: \#{name}, \#{arg_names.inspect}") unless arg_names.include?(value) %>
<%   else %>
<%     size = arg_names.find{|an| /\\Anum_.+s\\z/=~an} %>
<%     raise("size parameter was not found: \#{name}, \#{arg_names.inspect}") unless size %>
<%     size_ret = size+"_ret" %>
<%     raise("\#{size_ret} was not found: \#{name}, \#{arg_names.inspect}") unless arg_names.include?("&\#{size_ret}") %>
<%     value = size.sub(/\\Anum_/,"") %>
<%     raise("\#{value} was not found: \#{name}, \#{arg_names.inspect}") unless arg_names.include?(value) %>
<%   end %>
<%   ans = arg_names.dup %>
<%   (ia = ans.index(size)) || raise("\#{size} was not found: \#{name}, \#{ans.inspect}") %>
<%   ans[ia] = "0" %>
<%   (ia = ans.index(value)) || raise("\#{value} was not found: \#{name}, \#{ans.inspect}") %>
<%   ans[ia] = "NULL" %>
  ret = <%=name%>(<%=ans.join(", ")%>);
  <%=size%> = <%=size_ret%>;
<%   if arg_names.include?("&errcode_ret") %>
  check_error(errcode_ret);
<%   elsif type == "cl_int" && !ptr %>
  check_error(ret);
<%   end %>
<%   (ia = arg_names.index("&\#{size_ret}")) || raise("\#{size_ret} was not found: \#{name}, \#{arg_names.inspect}") %>
<%   arg_names[ia] = "NULL" %>
<%   if /Info\\z/ =~ name %>
  <%=value%> = (void*) xmalloc(<%=size%>);
<%   end %>
<% end %>
<% outputs.each do |output| %>
<%   if n = arg_hash[output][:size] %>
  <%=output%> = ALLOC_N(<%=arg_hash[output][:type]%>, <%=n%>);
<%   end %>
<% end %>
  ret = <%=name%>(<%=arg_names.map{|an| ((ah = arg_hash[an]) && ah[:const]) ? "(const \#{ah[:type]}\#{ah[:ptr]}) \#{an}" : an}.join(", ")%>);
<% oflag = true %>
<% if arg_names.include?("&errcode_ret") %>
  check_error(errcode_ret);
<% elsif type == "cl_int" && !ptr %>
  check_error(ret);
<%   oflag = false %>
<% end %>

<% ary = Array.new %>
  {
<% if oflag && (type!="void"||ptr)%>
    VALUE rb_ret;
    <%=get_output("ret", "\#{type}\#{ptr}", nil, knames) %>
<%   ary.push "ret" %>
<% end %>
<% outputs.each do |output| %>
<% ah = arg_hash[output] %>
<% ty = ah[:type] %>
<% ty = "\#{ty}\#{ah[:ptr]}" if ty == "void" %>
    <%=get_output(output, ty, ah[:size], knames) %>
<%   ary.push "rb_"+output %>
<% end %>
<% if ary.length > 0 %>
    result = rb_ary_new3(<%=ary.length%>, <%=ary.join(", ")%>);
<% else %>
    result = Qnil;
<% end %>
  }

<% alloc.each do |al| %>
  free(<%=al%>);
<% end %>

  return result;
}

EOF

end



line_cont = nil
title = nil
@typedef = {"cl_uint" => :uint, "cl_ulong" => :ulong}
consts = Hash.new
@apis = Hash.new
File.foreach(fname) do |line|
  line.chop!
  if line_cont
    line = (line_cont << " " << line)
  end
  if /\,\s*\z/ =~ line || /\Aextern CL_[^\(]+\z/ =~ line
    line_cont = line
    next
  else
    line_cont = nil
  end

  if /\Atypedef (cl_[\w_]+)\s+(cl_[\w_]+);/ =~ line
    org = $1
    new = $2
    @typedef[new] = (@typedef[org] || org)
    next
  end

  if /\A\/\/\s+(\w[\w\s-]+)\z/ =~ line
    title = $1
    next
  end

  if /\A\#define (CL_[A-Z_\d]+)\s+(.+)\z/ =~ line
    name = $1
    value = $2
    case value
    when /\A[-\d]+\z/
      type = :int
    when/\A0x[\dA-F]+\z/, /\A\(\d+ << \d+\)\z/
      type = :ulong
    else
    end
    ary = (consts[title] ||= Array.new)
    ary.push [name, type]
    next
  end

  if /\Aextern CL_API_ENTRY ([\w_]+) (\*)?\s*CL_API_CALL\s+(cl[\w\d]+)\((.+)\) CL_API_SUFFIX__VERSION_1_0;\z/ =~ line
    type = $1
    ptr = $2
    name = $3
    args = $4
    func = nil
    while /\A([^\(]+),\s+void \(\*([^\)]+)\)\(([^\)]+)\)[^,]*,\s*(.*)\z/ =~ args
      pre = $1
      fn = $2
      fa = $3
      suf = $4
      if func
        raise "multiple func were found"
      end
      ifa = 0
      fa = fa.split(",").map do |s|
        s.strip!
        if /\A(.+)\s+\/\*\s+([\w_]+)\s+\*\// =~ s
          s = $1 + " " +$2
        elsif /\AclCreateContext/ =~ name
          s = s + " " + ["errinfo","private_info", "cb", "user_data"][ifa]
        elsif name == "clEnqueueNativeKernel"
          s = s + " " + "args"
        else
          raise "error: #{name}, #{fa.inspect}"
        end
        ifa += 1
        s
      end
      func = {:name => fn, :args => fa }
      args = "#{pre}, ##func##, #{suf}"
    end
    if args == "void"
      arg_names = Array.new
      arg_hash = Hash.new
    else
      arg_names = Array.new
      arg_hash = Hash.new
      args.split(",").each do |s|
        s.strip!
        si = nil
        case s
        when "##func##"
          na = func[:name]
          tp = "void*"
          arg_names.push "##func##"
        when /\A(const )?((?:unsigned )?[\w\d_]+)\s+(\*|\*\*)?\s*\/\*\s+([\w\d_]+)(\[\d+\])?\s+\*\/\z/
          co = $1
          tp = $2
          po = $3
          na = $4
          si = $5
          si &&= si.sub(/\A\[/,"").sub(/\]\z/,"")
          arg_names.push na
        else
          raise "parse error: '#{s}' in #{name}"
        end
        arg_hash[na] = {:const => co, :type => tp, :ptr => po, :size => si}
      end
    end
    @apis[name] =  {:type => type, :ptr => ptr, :arg_names => arg_names, :arg_hash => arg_hash, :func => func}
    next
  end

  if $DEBUG
    unless /\A\s*\z/ =~ line
      p line
    end
  end

end



@klass_names = %w(Platform Device Context CommandQueue Mem Buffer Image Image2D Image3D ImageFormat Sampler Program Kernel Event)

@klass_parent = {
  "Buffer" => "Mem",
  "Image" => "Mem",
  "Image2D" => "Image",
  "Image3D" => "Image"
}
@klass_deps = {
 "Mem" => ["host_ptr"]
}





hash = Hash.new
consts.each do |title, ary|
  parent = nil
  @klass_names.each do |name|
    if /\Acl_#{name.decamelcase}/ =~ title
      parent = name
      break
    end
  end
  ary.each do |name, type|
    na = name.sub(/\ACL_/,"")
    if parent
      na = na.sub(/\A#{parent.upcase}_/,"")
      obj = "rb_c#{parent}"
    else
      obj = "rb_mOpenCL"
    end
    hash[obj] ||= Array.new
    hash[obj].push( {:name => na, :value => c2r(name, type)} )
  end
end
consts = hash




source_init = ERB.new(<<EOF, nil, 2).result(binding)
#include "ruby.h"
#include "cl.h"

static VALUE rb_mOpenCL;
<% @klass_names.each do |name| %>
static VALUE rb_c<%=name%>;
<% end %>

<% @klass_deps.each do |klass,dep| %>
<%  name = klass.decamelcase %>
struct  _struct_<%=name%> {
  cl_<%=name%> <%=name%>;
<%   dep.each do |dn| %>
  VALUE <%=dn%>;
<%   end %>
};
typedef struct _struct_<%=name%> *struct_<%=name%>;
<% end %>
EOF

source_check_error = <<EOF
static void
check_error(cl_int errcode)
{
  switch (errcode) {
  case CL_SUCCESS:
    rb_raise(rb_eRuntimeError, ": error code is %d", errcode);
    break;
  case CL_DEVICE_NOT_FOUND:
    rb_raise(rb_eRuntimeError, ": error code is %d", errcode);
    break;
  case CL_DEVICE_NOT_AVAILABLE:
    rb_raise(rb_eRuntimeError, ": error code is %d", errcode);
    break;
  case CL_DEVICE_COMPILER_NOT_AVAILABLE:
    rb_raise(rb_eRuntimeError, ": error code is %d", errcode);
    break;
  case CL_MEM_OBJECT_ALLOCATION_FAILURE:
    rb_raise(rb_eRuntimeError, ": error code is %d", errcode);
    break;
  case CL_OUT_OF_RESOURCES:
    rb_raise(rb_eRuntimeError, ": error code is %d", errcode);
    break;
  case CL_OUT_OF_HOST_MEMORY:
    rb_raise(rb_eRuntimeError, ": error code is %d", errcode);
    break;
  case CL_PROFILING_INFO_NOT_AVAILABLE:
    rb_raise(rb_eRuntimeError, ": error code is %d", errcode);
    break;
  case CL_MEM_COPY_OVERLAP:
    rb_raise(rb_eRuntimeError, ": error code is %d", errcode);
    break;
  case CL_IMAGE_FORMAT_MISMATCH:
    rb_raise(rb_eRuntimeError, ": error code is %d", errcode);
    break;
  case CL_IMAGE_FORMAT_NOT_SUPPORTED:
    rb_raise(rb_eRuntimeError, ": error code is %d", errcode);
    break;
  case CL_BUILD_PROGRAM_FAILURE:
    rb_raise(rb_eRuntimeError, ": error code is %d", errcode);
    break;
  case CL_MAP_FAILURE:
    rb_raise(rb_eRuntimeError, ": error code is %d", errcode);
    break;
  case CL_INVALID_VALUE:
    rb_raise(rb_eRuntimeError, "the values specified in properties are not valid: error code is %d", errcode);
    break;
  case CL_INVALID_DEVICE_TYPE:
    rb_raise(rb_eRuntimeError, ": error code is %d", errcode);
    break;
  case CL_INVALID_PLATFORM:
    rb_raise(rb_eRuntimeError, ": error code is %d", errcode);
    break;
  case CL_INVALID_DEVICE:
    rb_raise(rb_eRuntimeError, ": error code is %d", errcode);
    break;
  case CL_INVALID_CONTEXT:
    rb_raise(rb_eRuntimeError, ": error code is %d", errcode);
    break;
  case CL_INVALID_QUEUE_PROPERTIES:
    rb_raise(rb_eRuntimeError, "values specified in properties are not supported by the device: error code is %d", errcode);
    break;
  case CL_INVALID_COMMAND_QUEUE:
    rb_raise(rb_eRuntimeError, "command_queue is not a valid comand-queue: error code is %d", errcode);
    break;
  case CL_INVALID_HOST_PTR:
    rb_raise(rb_eRuntimeError, ": error code is %d", errcode);
    break;
  case CL_INVALID_MEM_OBJECT:
    rb_raise(rb_eRuntimeError, ": error code is %d", errcode);
    break;
  case CL_INVALID_IMAGE_FORMAT_DESCRIPTOR:
    rb_raise(rb_eRuntimeError, ": error code is %d", errcode);
    break;
  case CL_INVALID_IMAGE_SIZE:
    rb_raise(rb_eRuntimeError, ": error code is %d", errcode);
    break;
  case CL_INVALID_SAMPLER:
    rb_raise(rb_eRuntimeError, ": error code is %d", errcode);
    break;
  case CL_INVALID_BINARY:
    rb_raise(rb_eRuntimeError, ": error code is %d", errcode);
    break;
  case CL_INVALID_BUILD_OPTIONS:
    rb_raise(rb_eRuntimeError, ": error code is %d", errcode);
    break;
  case CL_INVALID_PROGRAM:
    rb_raise(rb_eRuntimeError, ": error code is %d", errcode);
    break;
  case CL_INVALID_PROGRAM_EXECUTABLE:
    rb_raise(rb_eRuntimeError, ": error code is %d", errcode);
    break;
  case CL_INVALID_KERNEL_NAME:
    rb_raise(rb_eRuntimeError, ": error code is %d", errcode);
    break;
  case CL_INVALID_KERNEL_DEFINITION:
    rb_raise(rb_eRuntimeError, ": error code is %d", errcode);
    break;
  case CL_INVALID_KERNEL:
    rb_raise(rb_eRuntimeError, ": error code is %d", errcode);
    break;
  case CL_INVALID_ARG_INDEX:
    rb_raise(rb_eRuntimeError, ": error code is %d", errcode);
    break;
  case CL_INVALID_ARG_VALUE:
    rb_raise(rb_eRuntimeError, ": error code is %d", errcode);
    break;
  case CL_INVALID_ARG_SIZE:
    rb_raise(rb_eRuntimeError, ": error code is %d", errcode);
    break;
  case CL_INVALID_KERNEL_ARGS:
    rb_raise(rb_eRuntimeError, ": error code is %d", errcode);
    break;
  case CL_INVALID_WORK_DIMENSION:
    rb_raise(rb_eRuntimeError, ": error code is %d", errcode);
    break;
  case CL_INVALID_WORK_GROUP_SIZE:
    rb_raise(rb_eRuntimeError, ": error code is %d", errcode);
    break;
  case CL_INVALID_GLOBAL_OFFSET:
    rb_raise(rb_eRuntimeError, ": error code is %d", errcode);
    break;
  case CL_INVALID_EVENT_WAIT_LIST:
    rb_raise(rb_eRuntimeError, ": error code is %d", errcode);
    break;
  case CL_INVALID_EVENT:
    rb_raise(rb_eRuntimeError, ": error code is %d", errcode);
    break;
  case CL_INVALID_OPERATION:
    rb_raise(rb_eRuntimeError, ": error code is %d", errcode);
    break;
  case CL_INVALID_GL_OBJECT:
    rb_raise(rb_eRuntimeError, ": error code is %d", errcode);
    break;
  case CL_INVALID_BUFFER_SIZE:
    rb_raise(rb_eRuntimeError, ": error code is %d", errcode);
    break;
  case CL_INVALID_MIP_LEVEL:
    rb_raise(rb_eRuntimeError, ": error code is %d", errcode);
    break;
  default:
    rb_raise(rb_eRuntimeError, "unexpected error was occured: error code is %d", errcode);
  }
}
EOF


source_apis = ""
@klass_names.each do |name|
  unless @klass_parent[name]
    source_apis += ERB.new(create_method(name), nil, 2).result(binding)
  end
end

method_def = Array.new
@apis.each do |name, hash|
  unless /(Retain|Release)/ =~ name
    source_apis += ERB.new(rb_api(name, hash), nil, 2).result(binding)
    if /\AclCreate(.+)\z/ =~ name && (klass = $1) && @klass_names.include?(klass)
      sgt = true
      mname = "new"
    elsif /\AclCreate(.+)FromType\z/ =~ name && (klass = $1) && @klass_names.include?(klass)
      sgt = true
      mname = "new"
    elsif /\AclGet(.+)IDs\z/ =~ name && (klass = $1) && @klass_names.include?(klass)
      sgt = true
      mname = "get_" + $1.decamelcase + "s"
    elsif /\Acl(Wait)ForEvents\z/ =~ name
      sgt = true
      klass = "Event"
      mname = $1.decamelcase
    elsif (ah = hash[:arg_hash][hash[:arg_names][0]]) && !ah[:ptr] && /\Acl_(.+?)(?:_id)?\z/ =~ ah[:type] && (klass = $1.camelcase) && @klass_names.include?(klass)
      sgt = false
      case name
      when /\Acl(Enqueue.+)\z/
        mname = $1.decamelcase
      when /\AclGet#{klass}(.*Info)\z/
        mname = "get_" + $1.decamelcase
      when /\AclGet#{@klass_parent[klass]}(.*Info)\z/
        klass = @klass_parent[klass]
        mname = "get_" + $1.decamelcase
      when /\AclSet#{klass}(.+)\z/
        mname = "set_" + $1.decamelcase
      when /\Acl(Build)#{klass}\z/, /\Acl(GetSupportedImageFormats)\z/, /\Acl(CreateKernels)In#{klass}\z/, /\Acl(CreateProgramWith(?:Source|Binary))\z/, /\Acl(Flush|Finish)\z/
        mname = $1.decamelcase
      else
        raise "error: #{name}, #{klass}"
      end
    elsif /\Acl(UnloadCompiler)\z/ =~ name
      klass = nil
      sgt = true
      mname = $1.decamelcase
    else
      p ah
      raise "error: #{name}"
    end
    method_def.push [klass, sgt, mname, "rb_#{name}"]
  end
end

args = %w(image_channel_order image_channel_data_type)
source_apis += ERB.new(<<EOF, nil, 2).result(binding)
VALUE
rb_CreateImageFormat(int argc, VALUE *argv, VALUE self)
{
<% args.each do |arg| %>
  cl<%=arg.sub(/\\Aimage/,"").sub(/_data/,"")%> <%=arg%>;
<% end %>
  cl_image_format *s_image_format;

<% args.each do |arg| %>
  VALUE rb_<%=arg%>;
<% end %>

  if (argc != 2)
    rb_raise(rb_eArgError, "wrong number of arguments (%d for 2)", argc);
  
<% args.each_with_index do |arg,i| %>
  rb_<%=arg%> = argv[<%=i%>];
  <%=arg%> = <%=r2c("rb_\#{arg}","cl\#{arg.sub(/\\Aimage/,"").sub(/_data/,"")}")%>;
<% end %>

  s_image_format = (cl_image_format*) xmalloc(sizeof(cl_image_format));
<% args.each do |arg| %>
  s_image_format-><%=arg%> = <%=arg%>;
<% end %>

  return create_image_format(s_image_format);
}
<% args.each do |arg| %>
VALUE
rb_GetImageFormat<%=arg.camelcase%>(int argc, VALUE *argv, VALUE self)
{
  cl_image_format *image_format;

  if (argc != 0)
    rb_raise(rb_eArgError, "wrong number of arguments (%d for 2)", argc);

  <%=data_get_struct("cl_image_format", nil, "self")%>
  return <%=c2r("image_format->\#{arg}", "cl\#{arg.sub(/\\Aimage/,"").sub(/_data/,"")}")%>;
}
<% end %>
EOF
method_def.push ["ImageFormat", true, "new", "rb_CreateImageFormat"]
args.each do |arg|
  method_def.push ["ImageFormat", false, arg, "rb_GetImageFormat#{arg.camelcase}"]
end



source_main = ERB.new(<<EOF, nil, 2).result(binding)
void Init_opencl(void)
{
  rb_mOpenCL = rb_define_module("OpenCL");

<% @klass_names.each do |name| %>
<%   parent = @klass_parent[name] || "Object" %>
  rb_c<%=name%> = rb_define_class_under(rb_mOpenCL, "<%=name%>", rb_c<%=parent%>);
<%   end %>
<% (["rb_mOpenCL"] + @klass_names.map{|na| "rb_c"+na}).each do |parent| %>
<%   if consts[parent] %>

  // <%=parent.sub(/\Arb_[cm]/,"")%>
<%     consts[parent].each do |hash| %>
  rb_define_const(<%=parent%>, "<%=hash[:name]%>", <%=hash[:value]%>);
<%     end %>
<%   end %>
<% end %>

<% method_def.each do |klass, sgt, name, fname| %>
<%   if klass %>
  rb_define_<%=sgt ? "singleton_" : ""%>method(rb_c<%=klass%>, "<%=name%>", <%=fname%>, -1);
<%   else %>
  rb_define_module_function(rb_mOpenCL, "<%=name%>", <%=fname%>, -1);
<%   end %>
<% end%>
}
EOF


File.open("rb_opencl.c","w") do |file|
  file.print source_init

  file.print source_check_error

  file.print source_apis

  file.print source_main

end

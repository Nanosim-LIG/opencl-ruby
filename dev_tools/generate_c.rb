require "erb"

fname = ARGV.shift || "./include/cl.h"
unless File.exist?(fname)
  raise "Usage: ruby #$0 <path to cl.h>"
end


class String
  def camelcase
    self.split("_").map{|s| s.capitalize.sub(/(\d)d\z/,'\1D')}.join
  end
  def decamelcase
    str = self
    while /\A(.*)([A-Z])(.*)\z/ =~ str
      str = $1 + "_" + $2.downcase + $3
    end
    return str.sub(/\A_/,"").sub(/n_d_range/,"NDrange")
  end
end

def c2r(name, type, len=nil)
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
  case type.to_s
  when "int8_t"
    return "CHR2FIX(#{name})"
  when "int", "int16_t", "int32_t"
    return "INT2NUM((#{type})#{name})"
  when "uint", "uint8_t", "uint16_t", "uint32_t"
    return "UINT2NUM((#{type})#{name})"
  when "long", "int64_t"
    return "LONG2NUM((#{type})#{name})"
  when "ulong", "uint64_t"
    return "ULONG2NUM((#{type})#{name})"
  when "float", "double"
    return "rb_float_new((double)#{name})"
  when "void*"
    return len ? "rb_str_new(#{name}, #{len})" : "rb_str_new2(#{name})"
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
  if name == "user_data"
    return "(void*) rb_#{name}"
  end
  case type
  when "int8_t"
    return "NUM2CHR(#{name})"
  when "int16_t", "int32_t", "int"
    return "(#{type})NUM2INT(#{name})"
  when "uint8_t", "uint16_t", "uint32_t"
    return "(#{type})NUM2UINT(#{name})"
  when "int64_t"
    return "NUM2LONG(#{name})"
  when "uint64_t", "size_t"
    return "(#{type})NUM2ULONG(#{name})"
  when "float", "double"
    return "(#{type})NUM2DBL(#{name})"
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
<%=indent%>  if (RARRAY_LEN(rb_<%=name%>) != <%=n%>)
<%=indent%>    rb_raise(rb_eArgError, "length of rb_\#{name} is invalid");
<%=indent%>  <%=name%> = ALLOC_N(<%=type2%>, <%=n%>);
<%   alloc.push name %>
<%   if name=="strings" || name=="binaries" %>
<%=indent%>  lengths = ALLOC_N(size_t, <%=n%>);
<%     alloc.push "lengths" %>
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
<% elsif /ptr\\z/ =~ name %>
if (TYPE(rb_<%=name%>) == T_STRING) {
<%   if arg_hash[:const] %>
<%=indent%>  char *c = RSTRING_PTR(rb_<%=name%>);
<%=indent%>  <%=name%> = (void*)&c;
<%   else %>
<%=indent%>  <%=name%> = RSTRING_PTR(rb_<%=name%>);
<%   end %>
<%   if name == "host_ptr" && arg_names.include?("size") %>
<%=indent%>  size = RSTRING_LEN(rb_<%=name%>);
<%   elsif name == "ptr" && arg_names.include?("cb") %>
<%=indent%>  cb = RSTRING_LEN(rb_<%=name%>);
<%   end %>
<%=indent%>} else if (CLASS_OF(rb_<%=name%>) == rb_cVArray) {
<%=indent%>  struct_varray *s_vary;
<%=indent%>  Data_Get_Struct(rb_<%=name%>, struct_varray, s_vary);
<%   if arg_hash[:const] %>
<%=indent%>  char *c = s_vary->ptr;
<%=indent%>  <%=name%> = (void*)c;
<%   else %>
<%=indent%>  <%=name%> = s_vary->ptr;
<%   end %>
<%   if name == "host_ptr" && arg_names.include?("size") %>
<%=indent%>  size = s_vary->size*s_vary->length;
<%   elsif name == "ptr" && arg_names.include?("cb") %>
<%=indent%>  cb = s_vary->size*s_vary->length;
<%   end %>
<%=indent%>} else
<%=indent%>  rb_raise(rb_eArgError, "wrong type of the argument");
<% elsif name == "properties" && type == "cl_context_properties" %>
if (rb_<%=name%> == Qnil) {
<%=indent%>  <%=name%> = NULL;
<%=indent%>} else {
<%=indent%>  Check_Type(rb_<%=name%>, T_ARRAY);
<%=indent%>  int len_prop = RARRAY_LEN(rb_<%=name%>);
<%=indent%>  int n;
<%=indent%>  <%=name%> = ALLOC_N(<%=type2%>, len_prop+1);
<%=indent%>  for (n=0; n<len_prop; n++) {
<%=indent%>    <%=name%>[n] = <%=r2c("RARRAY_PTR(rb_\#{name})[n]", "int")%>;
<%=indent%>  }
<%=indent%>  <%=name%>[len_prop] = 0;
<%=indent%>}
<%     alloc.push name %>
<% else %>
<%=name%> = <%=r2c("rb_\#{name}", "\#{type}\#{arg_hash[:ptr]}")%>;
<% end %>
EOF
end

def get_output(name, type, size, knames, indent=4, len=nil)
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
<%   elsif name=="ptr" && type == "void*" %>
rb_<%=name%> = rb_str_new(NULL, <%=len%>);
<%=indent%>free(RSTRING(rb_ptr)->ptr);
<%=indent%>RSTRING(rb_ptr)->ptr = #{name};
<%   else %>
rb_<%=name%> = <%=c2r(name, type, len)%>;
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
  xfree(<%=name%>);
<%   end %>
}
<% end %>
<% if name == "image_format"%>
static void
<%=name%>_free(<%=type%> *<%=name%>)
{
  xfree(<%=name%>);
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
<% if name=="image_format" %>
<%   free = true %>
<% end %>
  return Data_Wrap_Struct(rb_c<%=klass%>, <%=dep ? name+"_mark" : 0%>, <%=free ? name+"_free" : 0%>, (void*)<%=name%>);
}
EOF
end


def rb_api(name, hash, klass, sgt, mname)
  type = hash[:type]
  ptr = hash[:ptr]
  arg_names = hash[:arg_names]
  arg_hash = hash[:arg_hash]
  func = hash[:func]

  sobj = nil
  inputs = Array.new
  opts = Array.new
  outputs = Array.new
  knames = @klass_names_host.map{|k| k.decamelcase} + ["memobj"]
  kname_lists = knames.map{|k| k+"s"}
  innames = %w(properties enable image_type normalized_coords addressing_mode filter_mode src_buffer src_image dst_buffer dst_image arg_index args)
  outnames = %w(param_value old_properties binary_status ptr)
  optnames = %w(host_ptr image_width image_height image_depth cb event_wait_list cb_args arg_size size user_data)
  const_optnames = %w(event_wait_list options opt)
  const_ignores = %w(lengths  global_work_offset)
  ignores = %w(work_dim mapped_ptr)
  arg_names.each do |aname|
    next if aname == "##func##"
    arg = arg_hash[aname]
    atype = arg[:type]
    if arg[:const]
      if const_ignores.include?(aname)
        next
      elsif /(origin|region|offset)/=~aname || (name=="clBuildProgram"&&aname=="device_list") || const_optnames.include?(aname)
        opts.push aname
      else
        if (!sgt) && sobj.nil?
          sobj = aname
        else
          inputs.push aname
        end
      end
    else
      if /_(info|flags)\z/=~atype || /(\Ablocking_|_type\z)/=~aname || (innames.include?(aname)) || (knames.include?(aname)&&(aname!="event"||!arg[:ptr]))
        if (!sgt) && sobj.nil?
          sobj = aname
        else
          inputs.push aname
        end
      elsif (/_pitch\z/=~aname&&arg[:ptr]) || aname=="event" || outnames.include?(aname) || kname_lists.include?(aname)
        outputs.push aname
      elsif (/_pitch\z/=~aname&&!arg[:ptr]) || /offset\z/=~aname || optnames.include?(aname)
        opts.push aname
      elsif /\Anum_/=~aname || /_size\z/=~aname || /_ret\z/=~aname || /\Acount\z/=~aname || aname=="##func##" || ignores.include?(aname)
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
<% fas = func[:args] %>
void
<%=name%>_<%=func[:name]%>(<%=fas.join(", ")%>)
{
<% ary = Array.new %>
<% fas = fas.map{|fa| /([^\s]+)\\z/ =~ fa; $1} %>
<% fas.each_with_index do |fa,i| %>
<%   case fa %>
<%   when "errinfo" %>
<%     ary.push "rb_str_new2(\#{fa})" %>
<%   when "private_info" %>
<%     if fas[i+1] == "cb" %>
<%       ary.push "rb_str_new(\#{fa}, cb)" %>
<%     else %>
<%       raise("error: cb was not found") %>
<%     end %>
<%   when "cb" %>
<%     unless fas[i-1] == "private_info" %>
<%       raise("error: private_info was not found") %>
<%     end %>
<%   when "user_data" %>
<%     ary.push "(VALUE) \#{fa}" %>
<%   when "program" %>
<%     ary.push "create_\#{fa}(\#{fa})" %>
<%   else %>
<%     if name == "clEnqueueNativeKernel" && fa == "args" %>
<%       ary.push "rb_str_new2(\#{fa})" %>
<%     else %>
<%       raise("error: \#{fa}, \#{name}") %>
<%     end %>
<%   end %>
<% end %>
  if (rb_block_given_p())
    rb_yield(rb_ary_new3(<%=ary.length%>, <%=ary.join(", ")%>));
}
<% end %>
/*
 *  call-seq:
 *     <%=sgt ? (klass ? klass+"." : "") : klass.downcase+"."%><%=mname%>(<%=inputs.join(", ")%><%=opts.length>0 ? "[, opts]" : ""%>)<%=func ? "{ }" : ""%> -> <%= (type == "cl_int" && !ptr) ? (outputs.length>0 ? outputs.join(", ") : "nil") : ([type.sub(/\\Acl_/,"")]+outputs).join(", ")%>
 *
<% if opts.length > 0 %>
 *  opts: <%=opts.join(", ")%>
<% end %>
 */
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
<%   if @klass_names_host.include?(kn) && @klass_deps[kn] && outputs.include?(arg) %>
  struct_<%=kn.decamelcase%> <%=ah[:ptr]%>s_<%=arg%>;
<%   end %>
<% end %>
  <%=type%> <%=ptr%>ret;
<% if sobj %>
  VALUE rb_<%=sobj%>;
<% end %>
<% (inputs+opts+outputs).each do |input| %>
  VALUE rb_<%=input%> = Qnil;
<% end %>

  VALUE result;

  if (argc > <%=inputs.length + (opts.length>0 ? 1 : 0) + (func ? 1 : 0)%> || argc < <%=inputs.length%>)
    rb_raise(rb_eArgError, "wrong number of arguments (%d for <%=inputs.length%>)", argc);

<% if arg_names.include?("global_work_offset") %>
  global_work_offset = NULL;
<% end %>
<% if arg_names.include?("mapped_ptr") %>
  mapped_ptr = NULL;
<% end %>
<% alloc = Array.new %>
<% if opts.length > 0 %>
  {
    VALUE _opt_hash = Qnil;

    if (argc > <%=inputs.length%>) {
      _opt_hash = argv[<%=inputs.length%>];
      Check_Type(_opt_hash, T_HASH);
    }
<%   opts.each do |opt| %>
    if (_opt_hash != Qnil) {
      rb_<%=opt%> = rb_hash_aref(_opt_hash, ID2SYM(rb_intern("<%=opt%>")));
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

<% if sobj %>
  rb_<%=sobj%> = self;
  <%=get_arg(sobj, arg_hash[sobj], arg_names, knames, alloc, 2)%>
<% end %>
<% inputs.each_with_index do |input,i| %>
  rb_<%=input%> = argv[<%=i%>];
<%   if name=="clSetKernelArg" && input=="arg_value"%>
  if (TYPE(rb_<%=input%>)==T_FIXNUM) {
    long l = FIX2LONG(rb_<%=input%>);
    <%=input%> = (void*)&l;
    arg_size = sizeof(long);
  } else if (TYPE(rb_<%=input%>)==T_FLOAT) {
    double d = NUM2DBL(rb_<%=input%>);
    <%=input%> = (void*)&d;
    arg_size = sizeof(double);
  } else if (TYPE(rb_<%=input%>)==T_STRING) {
    char *c = (char*)RSTRING_PTR(rb_<%=input%>);
    <%=input%> = (void*)c;
    arg_size = RSTRING_LEN(rb_<%=input%>);
  } else if (rb_<%=input%>==Qnil) {
    char *c = 0;
    <%=input%> = (void*)c;
  } else if (CLASS_OF(rb_<%=input%>)==rb_cSampler) {
    cl_sampler sampler;
    <%=data_get_struct("cl_sampler", "sampler", "rb_"+input, 4)%>
    <%=input%> = (void*)&sampler;
    arg_size = sizeof(cl_sampler);
  } else if (rb_obj_is_kind_of(rb_<%=input%>,rb_cMem)==Qtrue) {
    cl_mem mem;
    <%=data_get_struct("cl_mem", "mem", "rb_"+input, 4)%>
    <%=input%> = (void*)&mem;
    arg_size = sizeof(cl_mem);
  } else
    rb_raise(rb_eArgError, "wrong type of the <%=i%>th argument");
<%   else %>
  <%=get_arg(input, arg_hash[input], arg_names, knames, alloc, 2)%>
<%   end %>
<% end %>


<% if func %>
<%   m = arg_names.index("##func##") %>
<%   raise("bug") unless m %>
<%   arg_names = arg_names.dup %>
<%   arg_names[m] = "\#{name}_\#{func[:name]}" %>
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
<%   elsif output=="ptr" %>
<%     if /EnqueueReadBuffer/ =~ name %>
  if (cb==0)
    check_error(clGetMemObjectInfo(buffer, CL_MEM_SIZE, sizeof(size_t), &cb, NULL));
  ptr = (void*)xmalloc(cb);
<%     elsif /EnqueueReadImage/ =~ name %>
  {
    size_t size;
    if (region)
      size = region[0]*region[1]*region[2];
    else {
      size_t r;
      check_error(clGetImageInfo(image, CL_IMAGE_WIDTH, sizeof(size_t), &r, NULL));
      size = r;
      check_error(clGetImageInfo(image, CL_IMAGE_HEIGHT, sizeof(size_t), &r, NULL));
      size = size*r;
      check_error(clGetImageInfo(image, CL_IMAGE_DEPTH, sizeof(size_t), &r, NULL));
      if (r)
        size = size*r;
    }
    ptr = (void*)xmalloc(size);
  }
<%     end %>
<%   end %>
<% end %>

  ret = <%=name%>(<%=arg_names.map{|an| ((ah = arg_hash[an]) && ah[:const]) ? "(const \#{ah[:type]}\#{ah[:ptr]})\#{an}" : an}.join(", ")%>);
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
<%   ary.push "rb_ret" %>
<% end %>
<% outputs.each do |output| %>
<% ah = arg_hash[output] %>
<% ty = ah[:type] %>
<% ty = "\#{ty}\#{ah[:ptr]}" if ty == "void" %>
<% if /Info\\z/ =~ name && output == "param_value" %>
    <%=get_output(output, ty, ah[:size], knames, 4, "param_value_size") %>
<% elsif /clEnqueueReadBuffer/ =~ name && output == "ptr" %>
    <%=get_output(output, ty, ah[:size], knames, 4, "cb") %>
<% elsif /clEnqueueReadImage/ =~ name && output == "ptr" %>
    <%=get_output(output, ty, ah[:size], knames, 4, "(row_pitch ? row_pitch : region[0])*(slice_pitch ? slice_pitch : region[1])*(region[2])") %>
<% else %>
    <%=get_output(output, ty, ah[:size], knames) %>
<% end %>
<%   ary.push "rb_"+output %>
<% end %>
<% case ary.length %>
<% when 0 %>
    result = Qnil;
<% when 1 %>
    result = <%=ary[0]%>;
<% else %>
    result = rb_ary_new3(<%=ary.length%>, <%=ary.join(", ")%>);
<% end %>
  }

<% alloc.each do |al| %>
  if (<%=al%>) xfree(<%=al%>);
<% end %>

  return result;
}

EOF

end



line_cont = nil
title = nil
@typedef = {
  "cl_char" => "int8_t",
  "cl_uchar" => "uint8_t",
  "cl_short" => "int16_t",
  "cl_ushort" => "uint16_t",
  "cl_int" => "int32_t",
  "cl_uint" => "uint32_t",
  "cl_long" => "int64_t",
  "cl_ulong" => "uint64_t",
  "cl_half" => "uint16_t",
  "cl_float" => "float",
  "cl_double" => "double"
}
consts = Hash.new
@apis = Hash.new
ary = nil
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

  if /\Atypedef (cl_[\w_]+|intptr_t)\s+(cl_[\w_]+);/ =~ line
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
    when /\A[-+]?[\d]+\z/, /\A\([-\d]+\)\z/
      type = :int
    when/\A0x[\da-f]+U\z/, /\A0x[\da-fA-F]{1,8}\z/
      type = :uint
    when/\A\(\(cl_long\) -?0x[\dA-F]+LL( - [\d]+LL)?\)\z/
      type = :long
    when/\A\(\(cl_ulong\) 0x[\dA-F]+ULL\)\z/, /\A\(\d+ << \d+\)\z/
      type = :ulong
    when /\AFLT_/, /\ADBL_/
      type = :double
    when /\ACL_[_\w]+\z/
      if (a = ary.assoc(value))
        type = a[1]
      else
        raise "cannot find #{value}"
      end
    else
      raise "cannot parse: #{name} #{value}"
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



@klass_names_host = %w(Platform Device Context CommandQueue Mem Buffer Image Image2D Image3D ImageFormat Sampler Program Kernel Event)

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
  @klass_names_host.each do |name|
    if /\Acl_#{name.decamelcase}/ =~ title
      parent = name
      break
    end
  end
  ary.each do |name, type|
    na = name.sub(/\ACL_/,"")
    if parent
      na = na.sub(/\A#{parent.sub(/Command/,"").upcase}_/,"").sub(/\AOBJECT_/,"")
      obj = "rb_c#{parent}"
    else
      obj = "rb_mOpenCL"
    end
    hash[obj] ||= Array.new
    hash[obj].push( {:name => na, :value => c2r(name, type)} )
  end
end
consts_host = hash






source_check_error = <<EOF
static void
check_error(cl_int errcode)
{
  switch (errcode) {
  case CL_SUCCESS:
    break;
  case CL_DEVICE_NOT_FOUND:
    rb_raise(rb_eRuntimeError, ": error code is %d", errcode);
    break;
  case CL_DEVICE_NOT_AVAILABLE:
    rb_raise(rb_eRuntimeError, ": error code is %d", errcode);
    break;
  case CL_COMPILER_NOT_AVAILABLE:
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
@klass_names_host.each do |name|
  unless @klass_parent[name]
    source_apis += ERB.new(create_method(name), nil, 2).result(binding)
  end
end

method_def_host = Array.new
@apis.sort.each do |name, hash|
  unless /(Retain|Release)/ =~ name
    if /\AclCreate(.+)\z/ =~ name && (klass = $1) && @klass_names_host.include?(klass)
      sgt = true
      mname = "new"
    elsif /\AclCreate(.+)FromType\z/ =~ name && (klass = $1) && @klass_names_host.include?(klass)
      sgt = true
      mname = "create_from_type"
    elsif /\AclCreate(.+)WithSource\z/ =~ name && (klass = $1) && @klass_names_host.include?(klass)
      sgt = true
      mname = "create_with_source"
    elsif /\AclGet(.+)IDs\z/ =~ name && (klass = $1) && @klass_names_host.include?(klass)
      sgt = true
      mname = "get_" + $1.decamelcase + "s"
    elsif /\Acl(Wait)ForEvents\z/ =~ name
      sgt = true
      klass = "Event"
      mname = $1.decamelcase
    elsif (ah = hash[:arg_hash][hash[:arg_names][0]]) && !ah[:ptr] && /\Acl_(.+?)(?:_id)?\z/ =~ ah[:type] && (klass = $1.camelcase) && @klass_names_host.include?(klass)
      sgt = false
      case name
      when /\Acl(Enqueue.+)\z/
        mname = $1.decamelcase
      when /\AclGet#{klass}(.*Info)\z/
        if klass == "Mem"
          mname = "get_" + $1.sub(/^Object/,"").decamelcase
        else
          mname = "get_" + $1.decamelcase
        end
      when /\AclGet([A-Z][^A-Z]+)(.*Info)\z/
        mname = "get_" + $2.decamelcase
        if @klass_parent[$1] == klass
          klass = $1
        else
          raise "[BUG]: #{klass}"
        end
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
    elsif name == "clGetExtensionFunctionAddress"
      next
    else
      p ah
      raise "error: #{name}"
    end
    source_apis += ERB.new(rb_api(name, hash, klass, sgt, mname), nil, 2).result(binding)
    method_def_host.push [klass, sgt, mname, "rb_#{name}"]
  end
end

%w(Context Program).each do |klass|
  source_apis += ERB.new(<<EOF, nil, 2).result(binding)
VALUE
rb_Get<%=klass%>Devices(int argc, VALUE *argv, VALUE self)
{
  VALUE str;
  VALUE param;
  cl_device_id *devs;
  size_t len;
  VALUE *ary;
  VALUE ret;
  int i;

  if (argc!=0)
    rb_raise(rb_eArgError, "wrong number of arguments (%d for 0)", argc);
  param = UINT2NUM(CL_<%=klass.upcase%>_DEVICES);
  str = rb_clGet<%=klass%>Info(1, &param, self);
  devs = (cl_device_id*)RSTRING_PTR(str);
  len = RSTRING_LEN(str)/sizeof(cl_device_id*);
  ary = ALLOC_N(VALUE, len);
  for (i=0; i<len; i++)
    ary[i] = create_device(devs[i]);
  ret = rb_ary_new4(len, ary);
  xfree(ary);
  return ret;
}
EOF
  method_def_host.push [klass, false, "devices", "rb_Get#{klass}Devices"]
end
str = ERB.new(<<EOF, nil, 2)
VALUE
rb_Get<%=klass%><%=target.camelcase%>(int argc, VALUE *argv, VALUE self)
{
  VALUE param;
  VALUE str;
  cl_<%=target%><%=target=="device" ? "_id" : ""%> *target;

  if (argc!=0)
    rb_raise(rb_eArgError, "wrong number of arguments (%d for 0)", argc);
  param = UINT2NUM(CL_<%=klass.sub(/Command/,"").sub(/Object/,"").upcase%>_<%=target.upcase%>);
  str = rb_clGet<%=klass%>Info(1, &param, self);
  target = (cl_<%=target%><%=target=="device" ? "_id" : ""%>*) RSTRING_PTR(str);
<% if target != "device" %>
  clRetain<%=target.camelcase%>(*target);
<% end %>
  return create_<%=target%>(*target);
}
EOF
%w(CommandQueue).each do |klass|
  target = "device"
  source_apis += str.result(binding)
  method_def_host.push [klass, false, target, "rb_Get#{klass}#{target.camelcase}"]
end
%w(CommandQueue MemObject Sampler Program Kernel).each do |klass|
  target = "context"
  source_apis += str.result(binding)
  method_def_host.push [klass.sub(/Object/,""), false, target, "rb_Get#{klass}#{target.camelcase}"]
end
%w(Kernel).each do |klass|
  target = "program"
  source_apis += str.result(binding)
  method_def_host.push [klass, false, target, "rb_Get#{klass}#{target.camelcase}"]
end
%w(Event).each do |klass|
  target = "command_queue"
  source_apis += str.result(binding)
  method_def_host.push [klass, false, target, "rb_Get#{klass}#{target.camelcase}"]
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
method_def_host.push ["ImageFormat", true, "new", "rb_CreateImageFormat"]
args.each do |arg|
  method_def_host.push ["ImageFormat", false, arg, "rb_GetImageFormat#{arg.camelcase}"]
end





@klass_names_vect = ["Vector", "VArray"]
method_def_vect = Array.new
vector_types = %w(char uchar short ushort int uint long ulong float double)
ns = [2,4,8,16]

source_vector = ERB.new(<<EOF, nil, 2).result(binding)
static void
vector_free(void* ptr)
{
  xfree(ptr);
}
EOF
vector_types.each do |type0|
  ns.each do |n|
    type1 = "#{type0}#{n}"
    type = "cl_#{type1}"
    klass = type1.capitalize
    @klass_names_vect << klass
    @klass_parent[klass] = "Vector"
    source_vector += ERB.new(<<EOF, nil, 2).result(binding)
VALUE
rb_Create<%=klass%>(int argc, VALUE *argv, VALUE self)
{
  <%=type%> *vector;
  int n;

  vector = (<%=type%>*)xmalloc(sizeof(<%=type%>));
  if (argc == 1) {
    Check_Type(argv[0], T_ARRAY);
    if (RARRAY_LEN(argv[0])==<%=n%>) {
      VALUE *ptr = (VALUE*)RARRAY_PTR(argv[0]);
      for (n=0; n<<%=n%>; n++)
#ifdef CL_BIG_ENDIAN
        ((<%=type.sub(/\\d+\\z/,"")%>*)vector)[n] = <%=r2c("ptr[n]","cl_\#{type0}")%>;
#else
        ((<%=type.sub(/\\d+\\z/,"")%>*)vector)[n] = <%=r2c("ptr[\#{n-1}-n]","cl_\#{type0}")%>;
#endif
    }
  } else if (argc == <%=n%>) {
      for (n=0; n<<%=n%>; n++)
#ifdef CL_BIG_ENDIAN
        ((<%=type.sub(/\\d+\\z/,"")%>*)vector)[n] = <%=r2c("argv[n]","cl_\#{type0}")%>;
#else
        ((<%=type.sub(/\\d+\\z/,"")%>*)vector)[n] = <%=r2c("argv[\#{n-1}-n]","cl_\#{type0}")%>;
#endif
  } else {
    rb_raise(rb_eArgError, "wrong number of arguments (%d for <%=n%>)", argc);
  }
  return Data_Wrap_Struct(rb_c<%=klass%>, 0, vector_free, (void*)vector);
}
VALUE
rb_<%=klass%>_toA(int argc, VALUE *argv, VALUE self)
{
  <%=type%> *vector;

  if (argc > 0)
    rb_raise(rb_eArgError, "wrong number of arguments (%d for 0)", argc);
  Data_Get_Struct(self, <%=type%>, vector);
<% ary = Array.new %>
#ifdef CL_BIG_ENDIAN
<% n.times{|nn| ary[nn] = c2r("(((#{type.sub(/\d+\z/,'')}*)vector)[\#{nn}])","cl_#{type0}")} %>
  return rb_ary_new3(<%=n%>, <%=ary.join(", ")%>);
#else
<% n.times{|nn| ary[nn] = c2r("(((#{type.sub(/\d+\z/,'')}*)vector)[\#{n-nn-1}])","cl_#{type0}")} %>
  return rb_ary_new3(<%=n%>, <%=ary.join(", ")%>);
#endif
}
EOF
    method_def_vect.push [klass, true, "new", "rb_Create#{klass}"]
    method_def_vect.push [klass, false, "to_a", "rb_#{klass}_toA"]
  end
end
source_vector += ERB.new(<<EOF, nil, 2).result(binding)
static VALUE
create_vector(void *ptr, enum vector_type type, unsigned int n)
{

  switch (type) {
<% vector_types.each do |type| %>
  case VA_<%=type.upcase%>:
    switch (n) {
    case 1:
      return <%=c2r("((cl_\#{type}*)ptr)[0]", "cl_\#{type}")%>;
      break;
<%   ns.each do |n| %>
    case <%=n%>:
      return Data_Wrap_Struct(rb_c<%=type.camelcase%><%=n%>, 0, vector_free, ptr);
      break;
<%   end %>
    default:
      rb_raise(rb_eRuntimeError, "vector type is invalid");
    }
<% end %>
  default:
    rb_raise(rb_eRuntimeError, "vector type is invalid");
  }
  return Qnil;
}
EOF

source_vector += ERB.new(<<EOF, nil, 2).result(binding)

static void
varray_free(struct_varray *s_array)
{
  if (s_array->obj == Qnil)
    xfree(s_array->ptr);
  xfree(s_array);
}
static void
varray_mark(struct_varray *s_array)
{
  if (s_array->obj != Qnil)
    rb_gc_mark(s_array->obj);
}
static size_t
data_size(enum vector_type type, unsigned int n)
{
  switch (type) {
<% vector_types.each do |type| %>
  case VA_<%=type.upcase%>:
    switch (n) {
    case 1:
      return sizeof(cl_<%=type%>);
      break;
<%   ns.each do |n| %>
    case <%=n%>:
      return sizeof(cl_<%=type%><%=n%>);
      break;
<%   end %>
    default:
      rb_raise(rb_eRuntimeError, "vector type is invalid: type_code=%d, n=%d", type, n);
    }
<% end %>
  default:
    rb_raise(rb_eRuntimeError, "vector type is invalid: type_code=%d, n=%d", type, n);
  }
  return -1;
}
static unsigned int
vector_type_code(enum vector_type type, unsigned int n)
{
  return type*100+n;
}
static void
vector_type_n(unsigned int type_code, enum vector_type *type, unsigned int *n)
{
  *type = type_code/100;
  *n = type_code%100;
}
static VALUE
create_varray(void* ptr, size_t len, enum vector_type type, unsigned int n, size_t size, VALUE obj)
{
  struct_varray *s_array;

  s_array = (struct_varray*)xmalloc(sizeof(struct_varray));
  s_array->ptr = ptr;
  s_array->length = len;
  s_array->type = type;
  s_array->n = n;
  s_array->size = size;
  s_array->obj = obj;
  return Data_Wrap_Struct(rb_cVArray, varray_mark, varray_free, (void*)s_array);
}
VALUE
rb_CreateVArray(int argc, VALUE *argv, VALUE self)
{
  enum vector_type vtype;
  unsigned int n;
  unsigned int len;
  void* ptr;
  size_t size;

  if (argc != 2)
    rb_raise(rb_eArgError, "wrong number of arguments (%d for 2)", argc);
  vector_type_n(NUM2UINT(argv[0]), &vtype, &n);
  len = NUM2UINT(argv[1]);
  size = data_size(vtype, n);
  ptr = (void*)xmalloc(len*size);
  return create_varray(ptr, len, vtype, n, size, Qnil);
}
VALUE
rb_CreateVArrayFromObject(int argc, VALUE *argv, VALUE self)
{
  enum vector_type vtype;
  unsigned int n;
  VALUE obj = Qnil;
  unsigned int len;
  void* ptr;
  size_t size;

  if (argc==2 && TYPE(argv[1]) == T_STRING) {
    n = NUM2UINT(argv[0]);
    vector_type_n(n, &vtype, &n);
    obj = argv[1];
    len = RSTRING_LEN(obj);
    size = data_size(vtype, n);
    if (len%size != 0)
      rb_raise(rb_eArgError, "size of the string (%d) is not multiple of size of the type (%d)", len, size);
    len = len/size;
    ptr = (void*) RSTRING_PTR(obj);
#ifdef HAVE_NARRAY_H
  } else if ((argc==1 || argc==2) && NA_IsNArray(argv[0])) {
    struct NARRAY* nary;
    int ntype;
    if (argc==2) {
      Check_Type(argv[1], T_HASH);
      if (rb_hash_aref(argv[1], ID2SYM(rb_intern("binary"))) == Qtrue)
        obj = argv[0];
    }
    nary = NA_STRUCT(argv[0]);
    switch (nary->rank) {
    case 1:
      n = 1;
      len = nary->shape[0];
      break;
    case 2:
      n = nary->shape[0];
      len = nary->shape[1];
      if (<%=ns.map{|n| "n!=\#{n}"}.join(" && ")%>)
        rb_raise(rb_eArgError, "shape[0] of narray is invalid");
      break;
    default:
      rb_raise(rb_eArgError, "rank of narray must be 1 or 2");
    }
    ntype = nary->type;
    switch (ntype) {
    case NA_BYTE:
      vtype = VA_CHAR;
      break;
    case NA_SINT:
      vtype = VA_SHORT;
      break;
    case NA_LINT:
      vtype = VA_INT;
      break;
    case NA_SFLOAT:
      vtype = VA_FLOAT;
      break;
    case NA_DFLOAT:
      vtype = VA_DOUBLE;
      break;
    default:
      rb_raise(rb_eArgError, "this type is not supported");
    }
    size = data_size(vtype, n);
    if (obj == Qnil) {
      ptr = (void*)ALLOC_N(char, size*len);
#ifdef CL_BIG_ENDIAN
      memcpy(ptr, nary->ptr, size*len);
#else
      if (n==1)
        memcpy(ptr, nary->ptr, size*len);
      else {
        size_t step = size/n;
        void *nptr = (void*)nary->ptr;
        int i, j;
        for(i=0;i<len;i++)
          for(j=0;j<n;j++)
            memcpy(ptr+i*size+j*step, nptr+i*size+(n-j-1)*step, step);
      }
#endif
    } else
      ptr = (void*) nary->ptr;
#endif
  } else {
    rb_raise(rb_eArgError, "wrong number of arguments");
  }

  return create_varray(ptr, len, vtype, n, size, obj);
}
VALUE
rb_VArray_length(int argc, VALUE *argv, VALUE self)
{
  struct_varray *s_array;

  if (argc != 0)
    rb_raise(rb_eArgError, "wrong number of arguments (%d for 0)", argc);
  Data_Get_Struct(self, struct_varray, s_array);
  return UINT2NUM(s_array->length);
}
VALUE
rb_VArray_toS(int argc, VALUE *argv, VALUE self)
{
  struct_varray *s_array;

  if (argc != 0)
    rb_raise(rb_eArgError, "wrong number of arguments (%d for 0)", argc);
  Data_Get_Struct(self, struct_varray, s_array);
  return rb_str_new(s_array->ptr, s_array->length*s_array->size);
}
VALUE
rb_VArray_typeCode(int argc, VALUE *argv, VALUE self)
{
  struct_varray *s_array;

  if (argc != 0)
    rb_raise(rb_eArgError, "wrong number of arguments (%d for 0)", argc);
  Data_Get_Struct(self, struct_varray, s_array);
  return UINT2NUM(vector_type_code(s_array->type,s_array->n));
}
VALUE
rb_VArray_aref(int argc, VALUE *argv, VALUE self)
{
  struct_varray *s_array;
  void *ptr;
  size_t size;

  if (argc!=1)
    rb_raise(rb_eArgError, "wrong number of arguments (%d for 1)", argc);
  Data_Get_Struct(self, struct_varray, s_array);
  size = s_array->size;
  if (FIXNUM_P(argv[0])) {
    int i = FIX2INT(argv[0]);
    if (i < 0)
      i += (int)s_array->length;
    if (i >= (int)s_array->length)
      rb_raise(rb_eArgError, "index %ld out of array (%ld)", i, s_array->length);
    ptr = (void*)xmalloc(size);
    return create_vector(memcpy(ptr, (s_array->ptr)+size*i, size), s_array->type, s_array->n);
  } else if (rb_class_of(argv[0]) == rb_cRange) {
     long beg, len;
     rb_range_beg_len(argv[0], &beg, &len, s_array->length, 1);
     ptr = (void*)(s_array->ptr+size*beg);
     return create_varray(ptr, len, s_array->type, s_array->n, s_array->size, self);
//     ptr = (void*)xmalloc(size*len);
//     memcpy(ptr, (s_array->ptr)+size*beg, size*len);
//     return create_varray(ptr, len, s_array->type, s_array->n, s_array->size, Qnil);
  } else
    rb_raise(rb_eArgError, "wrong type of the 1st argument");

  return Qnil;
}
VALUE
rb_VArray_aset(int argc, VALUE *argv, VALUE self)
{
  struct_varray *s_array;
  size_t size;
  long beg, len;
  int i, j;

  if (argc!=2)
    rb_raise(rb_eArgError, "wrong number of arguments (%d for 2)", argc);
  Data_Get_Struct(self, struct_varray, s_array);
  if (FIXNUM_P(argv[0])) {
    i = FIX2INT(argv[0]);
    if (i < 0)
      i += (int)s_array->length;
    if (i >= (int)s_array->length)
      rb_raise(rb_eArgError, "index %ld out of array (%ld)", i, s_array->length);
    beg = i;
    len = 1;
  } else if (rb_class_of(argv[0]) == rb_cRange) {
     rb_range_beg_len(argv[0], &beg, &len, s_array->length, 1);
  } else
    rb_raise(rb_eArgError, "wrong type of the 1st argument");
  size = s_array->size;
  if (rb_class_of(argv[1]) == rb_cVArray) {
    struct_varray *s_array1;
    Data_Get_Struct(argv[1], struct_varray, s_array1);
    if (s_array1->type == s_array->type && s_array1->n == s_array->n && s_array1->length == len) {
      memcpy(s_array->ptr+beg*size, s_array1->ptr, size*len);
      return argv[1];
    } else {
      rb_raise(rb_eArgError, "type_code or length is invalid");
    }
  }
  switch (s_array->type) {
<% vector_types.each do |type| %>
  case VA_<%=type.upcase%>:
    if (rb_obj_is_kind_of(argv[1], rb_cNumeric)==Qtrue) {
      cl_<%=type%> val = <%=r2c("argv[1]", "cl_\#{type}")%>;
      for (i=beg; i<beg+len; i++)
        for (j=0; j<(int)s_array->n; j++)
          ((cl_<%=type%>*)(s_array->ptr+size*i))[j] = val;
      return argv[1];
    }
    switch (s_array->n) {
<%   ns.each do |n| %>
    case <%=n%>:
      if (rb_class_of(argv[1]) == rb_c<%=type.camelcase%><%=n%>) {
        cl_<%=type%><%=n%> *val;
        Data_Get_Struct(argv[1], cl_<%=type%><%=n%>, val);
        for (i=beg; i<beg+len; i++)
          memcpy(s_array->ptr+size*i, val, size);
        return argv[1];
      } else {
        rb_raise(rb_eArgError, "wrong type of the 2nd argument");
      }
      break;
<%   end %>
    default:
      rb_raise(rb_eArgError, "wrong type of the 2nd argument");
    }
    break;
<% end %>
  default:
    rb_raise(rb_eRuntimeError, "[BUG] invalid type");
  }

  return Qnil;
}
<% cal_sim = {"add"=>"+", "stb"=>"-", "mul"=>"*", "div"=>"/"} %>
<% %w(add sbt mul div).each do |cal| %>
VALUE
rb_VArray_<%=cal%>(int argc, VALUE *argv, VALUE self)
{
  struct_varray *s_array;
  size_t size;
  int i, j;

  if (argc!=1)
    rb_raise(rb_eArgError, "wrong number of arguments (%d for 1)", argc);
  Data_Get_Struct(self, struct_varray, s_array);
  size = s_array->size;
  if (rb_class_of(argv[0]) == rb_cVArray) {
    struct_varray *s_array1;
    Data_Get_Struct(argv[0], struct_varray, s_array1);
    if (s_array1->type == s_array->type && s_array1->n == s_array->n && s_array1->length == s_array->length) {
      switch (s_array->type) {
<%   vector_types.each do |type| %>
      case VA_<%=type.upcase%>:
        for (i=0; i<s_array->length*s_array->n; i++)
          ((cl_<%=type%>*)s_array->ptr)[i] <%=cal_sim[cal]%>= ((cl_<%=type%>*)s_array1->ptr)[i];
        return self;
        break;
<%   end %>
      default:
        rb_raise(rb_eRuntimeError, "[BUG]");
      }
    } else {
      rb_raise(rb_eArgError, "type_code or length is invalid");
    }
  }
  switch (s_array->type) {
<%   vector_types.each do |type| %>
  case VA_<%=type.upcase%>:
    if (rb_obj_is_kind_of(argv[0], rb_cNumeric)==Qtrue) {
      cl_<%=type%> val = <%=r2c("argv[0]", "cl_\#{type}")%>;
      for (i=0; i<s_array->length*s_array->n; i++)
        ((cl_<%=type%>*)s_array->ptr)[i] <%=cal_sim[cal]%>= val;
      return self;
    }
    switch (s_array->n) {
<%     ns.each do |n| %>
    case <%=n%>:
      if (rb_class_of(argv[0]) == rb_c<%=type.camelcase%><%=n%>) {
        cl_<%=type%><%=n%> *val;
        Data_Get_Struct(argv[0], cl_<%=type%><%=n%>, val);
        for (i=0; i<s_array->length; i++)
          for (j=0; j<s_array->n; j++)
          ((cl_<%=type%>*)(s_array->ptr+s_array->size*i))[j] <%=cal_sim[cal]%>= ((cl_<%=type%>*)val)[j];
        return self;
      } else {
        rb_raise(rb_eArgError, "wrong type of the argument");
      }
      break;
<%     end %>
    default:
      rb_raise(rb_eArgError, "wrong type of the argument");
    }
    break;
<%   end %>
  default:
    rb_raise(rb_eRuntimeError, "[BUG] invalid type");
  }

  return Qnil;
}
<% end %>
VALUE
rb_VArray_copy(int argc, VALUE *argv, VALUE self)
{
  struct_varray *s_array;
  void *ptr;
  size_t size;

  if (argc!=0)
    rb_raise(rb_eArgError, "wrong number of arguments (%d for 0)", argc);
  Data_Get_Struct(self, struct_varray, s_array);
  size = s_array->size*s_array->length;
  ptr = (void*)xmalloc(size);
  memcpy(ptr, s_array->ptr, size);
  return create_varray(ptr, s_array->length, s_array->type, s_array->n, s_array->size, Qnil);
}
EOF

method_def_vect.push ["VArray", true, "new", "rb_CreateVArray"]
method_def_vect.push ["VArray", true, "to_va", "rb_CreateVArrayFromObject"]
method_def_vect.push ["VArray", false, "length", "rb_VArray_length"]
method_def_vect.push ["VArray", false, "to_s", "rb_VArray_toS"]
method_def_vect.push ["VArray", false, "type_code", "rb_VArray_typeCode"]
method_def_vect.push ["VArray", false, "[]", "rb_VArray_aref"]
method_def_vect.push ["VArray", false, "[]=", "rb_VArray_aset"]
method_def_vect.push ["VArray", false, "+", "rb_VArray_add"]
method_def_vect.push ["VArray", false, "-", "rb_VArray_sbt"]
method_def_vect.push ["VArray", false, "*", "rb_VArray_mul"]
method_def_vect.push ["VArray", false, "/", "rb_VArray_div"]
method_def_vect.push ["VArray", false, "copy", "rb_VArray_copy"]


source_vector += ERB.new(<<EOF, nil, 2).result(binding)

#ifdef HAVE_NARRAY_H
static void
cl_na_mark_ref(struct NARRAY *nary)
{
  rb_gc_mark(nary->ref);
}
static void
cl_na_free(struct NARRAY *nary)
{
  if (nary->ref == Qnil)
    xfree(nary->ptr);
  xfree(nary->shape);
  xfree(nary);
}
VALUE
rb_VArray_toNa(int argc, VALUE *argv, VALUE self)
{
  struct_varray *s_array;
  struct NARRAY *nary;
  int ntype;
  int binary = 0;

  if (argc != 0 && argc != 1)
    rb_raise(rb_eArgError, "wrong number of arguments (%d for 0)", argc);
  if (argc == 1) {
    Check_Type(argv[0], T_HASH);
    if (rb_hash_aref(argv[0], ID2SYM(rb_intern("binary"))) == Qtrue)
      binary = 1;
  }
  Data_Get_Struct(self, struct_varray, s_array);
  switch (s_array->type) {
  case VA_CHAR:
    ntype = NA_BYTE;
    break;
  case VA_SHORT:
    ntype = NA_SINT;
    break;
  case VA_INT:
    ntype = NA_LINT;
    break;
  case VA_FLOAT:
    ntype = NA_SFLOAT;
    break;
  case VA_DOUBLE:
    ntype = NA_DFLOAT;
    break;
  default:
    rb_raise(rb_eRuntimeError, "this type is not supported");
  }
  nary = ALLOC(struct NARRAY);
  nary->rank = s_array->n == 1 ? 1 : 2;
  nary->total = s_array->n*s_array->length;
  nary->shape = ALLOC_N(int, nary->rank);
  nary->type = ntype;
  if (s_array->n == 1)
    nary->shape[0] = s_array->length;
  else {
    nary->shape[0] = s_array->n;
    nary->shape[1] = s_array->length;
  }
  if (binary) {
    nary->ptr = s_array->ptr;
    nary->ref = self;
    return Data_Wrap_Struct(cNArray, cl_na_mark_ref, cl_na_free, nary);
  } else {
    nary->ptr = ALLOC_N(char, s_array->size*s_array->length);
#ifdef CL_BIG_ENDIAN
    memcpy(nary->ptr, s_array->ptr, s_array->length*s_array->size);
#else
    if (s_array->n == 1)
      memcpy(nary->ptr, s_array->ptr, s_array->length*s_array->size);
    else {
      int n = s_array->n;
      int size = s_array->size;
      int step = size/n;
      void *vptr = s_array->ptr;
      void *nptr = (void*)nary->ptr;
      int i, j;
      for(i=0; i<s_array->length; i++)
        for(j=0; j<n; j++)
          memcpy(nptr+i*size+j*step, vptr+i*size+(n-j-1)*step, step);
    }
#endif
    nary->ref = Qnil;
    return Data_Wrap_Struct(cNArray, 0, cl_na_free, nary);
  }
  return Qnil;
}
#endif
EOF



ary = Array.new
vector_types.each do |type|
  name = type.upcase
  ary.push( {:name => name, :value => "UINT2NUM(vector_type_code(VA_#{name},1))"} )
  ns.each do |n|
    ary.push( {:name => "#{name}#{n}", :value => "UINT2NUM(vector_type_code(VA_#{name},#{n}))"} )
  end
end
consts_vect = Hash.new
consts_vect["rb_cVArray"] = ary



source_header = ERB.new(<<EOF, nil, 2).result(binding)
#include <string.h>
#include "ruby.h"
#include "CL/cl.h"
#ifdef HAVE_NARRAY_H
#include "narray.h"
#endif

VALUE rb_mOpenCL;

<% @klass_names_host.each do |name| %>
static VALUE rb_c<%=name%>;
<% end %>

<% @klass_names_vect.each do |name| %>
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


enum vector_type {
  VA_NONE,
<% vector_types.each do |type| %>
  VA_<%=type.upcase%>,
<% end %>
  VA_ERROR
};

typedef struct _struct_varray {
  void* ptr;
  enum vector_type type;
  unsigned int n;
  size_t length;
  size_t size;
  VALUE obj;
} struct_varray;


EOF




source_main = Hash.new
%w(host vect).each do |name|
  source_main[name] = ERB.new(<<EOF, nil, 2).result(binding)

<% @klass_names_#{name}.each do |kname| %>
<%   parent = @klass_parent[kname] || "Object" %>
  rb_c<%=kname%> = rb_define_class_under(rb_mOpenCL, "<%=kname%>", rb_c<%=parent%>);
<%   end %>
<% (["rb_mOpenCL"] + @klass_names_#{name}.map{|na| "rb_c"+na}).each do |parent| %>
<%   if consts_#{name}[parent] %>

  // <%=parent.sub(/\Arb_[cm]/,"")%>
<%     consts_#{name}[parent].each do |hash| %>
  rb_define_const(<%=parent%>, "<%=hash[:name]%>", <%=hash[:value]%>);
<%     end %>
<%   end %>
<% end %>

<% method_def_#{name}.each do |klass, sgt, mname, fname| %>
<%   if klass %>
  rb_define_<%=sgt ? "singleton_" : ""%>method(rb_c<%=klass%>, "<%=mname%>", <%=fname%>, -1);
<%   else %>
  rb_define_module_function(rb_mOpenCL, "<%=mname%>", <%=fname%>, -1);
<%   end %>
<% end%>
<% if name == "vect" %>
#ifdef HAVE_NARRAY_H
  rb_define_method(rb_cVArray, "to_na", rb_VArray_toNa, -1);

  rb_define_const(rb_cVArray, "NARRAY_ENABLED", Qtrue);
#else
  rb_define_const(rb_cVArray, "NARRAY_ENABLED", Qfalse);
#endif

#ifdef CL_BIG_ENDIAN
  rb_define_const(rb_cVector, "BIG_ENDIAN", Qtrue);
#else
  rb_define_const(rb_cVector, "BIG_ENDIAN", Qfalse);
#endif
<% end %>

EOF
end




File.open("rb_opencl.c","w") do |file|

  file.print source_header

  file.print source_check_error

  file.print source_apis

  file.print source_vector

  file.print <<EOF
void
Init_opencl(void)
{
  rb_require("narray");

  rb_mOpenCL = rb_define_module("OpenCL");

EOF

  file.print source_main["host"]

  file.print source_main["vect"]

  file.print <<EOF

}
EOF
end

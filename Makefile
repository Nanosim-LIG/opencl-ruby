
SHELL = /bin/sh

#### Start of system configuration section. ####

srcdir = .
topdir = /usr/lib/ruby/1.8/x86_64-linux
hdrdir = $(topdir)
VPATH = $(srcdir):$(topdir):$(hdrdir)
prefix = $(DESTDIR)/usr
exec_prefix = $(prefix)
vendorarchdir = $(vendorlibdir)/$(sitearch)
docdir = $(datarootdir)/doc/$(PACKAGE)
rubylibdir = $(libdir)/ruby/$(ruby_version)
vendorlibdir = $(vendordir)/$(ruby_version)
sharedstatedir = $(prefix)/com
mandir = $(prefix)/share/man
bindir = $(exec_prefix)/bin
dvidir = $(docdir)
sitedir = $(DESTDIR)/usr/local/lib/site_ruby
htmldir = $(docdir)
sitearchdir = $(sitelibdir)/$(sitearch)
oldincludedir = $(DESTDIR)/usr/include
includedir = $(prefix)/include
psdir = $(docdir)
datadir = $(datarootdir)
sbindir = $(exec_prefix)/sbin
datarootdir = $(prefix)/share
sysconfdir = $(DESTDIR)/etc
libdir = $(exec_prefix)/lib
archdir = $(rubylibdir)/$(arch)
localedir = $(datarootdir)/locale
localstatedir = $(DESTDIR)/var
pdfdir = $(docdir)
libexecdir = $(prefix)/lib/ruby1.8
sitelibdir = $(sitedir)/$(ruby_version)
infodir = $(prefix)/share/info
vendordir = $(libdir)/ruby/vendor_ruby

CC = gcc
LIBRUBY = $(LIBRUBY_SO)
LIBRUBY_A = lib$(RUBY_SO_NAME)-static.a
LIBRUBYARG_SHARED = -l$(RUBY_SO_NAME)
LIBRUBYARG_STATIC = -l$(RUBY_SO_NAME)-static

RUBY_EXTCONF_H = 
CFLAGS   =  -fPIC -fno-strict-aliasing -g -g -O2  -fPIC $(cflags) 
INCFLAGS = -I. -I. -I/usr/lib/ruby/1.8/x86_64-linux -I.
DEFS     = 
CPPFLAGS = -DHAVE_CL_OPENCL_H -DHAVE_NARRAY_H -DCL_LITTLE_ENDIAN -I/var/lib/gems/1.8/gems/narray-0.6.0.1 -I/usr/lib/ruby/1.8/x86_64-linux/include -I./include   
CXXFLAGS = $(CFLAGS) 
ldflags  = -L. -Wl,-Bsymbolic-functions -rdynamic -Wl,-export-dynamic
dldflags = 
archflag = 
DLDFLAGS = $(ldflags) $(dldflags) $(archflag)
LDSHARED = $(CC) -shared
AR = ar
EXEEXT = 

RUBY_INSTALL_NAME = ruby1.8
RUBY_SO_NAME = ruby1.8
arch = x86_64-linux
sitearch = x86_64-linux
ruby_version = 1.8
ruby = /usr/bin/ruby1.8
RUBY = $(ruby)
RM = rm -f
MAKEDIRS = mkdir -p
INSTALL = /usr/bin/install -c
INSTALL_PROG = $(INSTALL) -m 0755
INSTALL_DATA = $(INSTALL) -m 644
COPY = cp

#### End of system configuration section. ####

preload = 

libpath = . $(libdir) /usr/lib/ruby/1.8/x86_64-linux/lib ./lib
LIBPATH =  -L. -L$(libdir) -L/usr/lib/ruby/1.8/x86_64-linux/lib -L./lib
DEFFILE = 

CLEANFILES = mkmf.log
DISTCLEANFILES = 

extout = 
extout_prefix = 
target_prefix = 
LOCAL_LIBS = 
LIBS = $(LIBRUBYARG_SHARED) -lOpenCL  -lpthread -lrt -ldl -lcrypt -lm   -lc
SRCS = rb_opencl.c
OBJS = rb_opencl.o
TARGET = opencl
DLLIB = $(TARGET).so
EXTSTATIC = 
STATIC_LIB = 

BINDIR        = $(bindir)
RUBYCOMMONDIR = $(sitedir)$(target_prefix)
RUBYLIBDIR    = $(sitelibdir)$(target_prefix)
RUBYARCHDIR   = $(sitearchdir)$(target_prefix)

TARGET_SO     = $(DLLIB)
CLEANLIBS     = $(TARGET).so $(TARGET).il? $(TARGET).tds $(TARGET).map
CLEANOBJS     = *.o *.a *.s[ol] *.pdb *.exp *.bak

all:		$(DLLIB)
static:		$(STATIC_LIB)

clean:
		@-$(RM) $(CLEANLIBS) $(CLEANOBJS) $(CLEANFILES)

distclean:	clean
		@-$(RM) Makefile $(RUBY_EXTCONF_H) conftest.* mkmf.log
		@-$(RM) core ruby$(EXEEXT) *~ $(DISTCLEANFILES)

realclean:	distclean
install: install-so install-rb

install-so: $(RUBYARCHDIR)
install-so: $(RUBYARCHDIR)/$(DLLIB)
$(RUBYARCHDIR)/$(DLLIB): $(DLLIB)
	$(INSTALL_PROG) $(DLLIB) $(RUBYARCHDIR)
install-rb: pre-install-rb install-rb-default
install-rb-default: pre-install-rb-default
pre-install-rb: Makefile
pre-install-rb-default: Makefile
pre-install-rb-default: $(RUBYLIBDIR)
install-rb-default: $(RUBYLIBDIR)/quick_opencl.rb
$(RUBYLIBDIR)/quick_opencl.rb: $(srcdir)/lib/quick_opencl.rb $(RUBYLIBDIR)
	$(INSTALL_DATA) $(srcdir)/lib/quick_opencl.rb $(@D)
install-rb-default: $(RUBYLIBDIR)/opencl.rb
$(RUBYLIBDIR)/opencl.rb: $(srcdir)/lib/opencl.rb $(RUBYLIBDIR)
	$(INSTALL_DATA) $(srcdir)/lib/opencl.rb $(@D)
$(RUBYARCHDIR):
	$(MAKEDIRS) $@
$(RUBYLIBDIR):
	$(MAKEDIRS) $@

site-install: site-install-so site-install-rb
site-install-so: install-so
site-install-rb: install-rb

.SUFFIXES: .c .m .cc .cxx .cpp .C .o

.cc.o:
	$(CXX) $(INCFLAGS) $(CPPFLAGS) $(CXXFLAGS) -c $<

.cxx.o:
	$(CXX) $(INCFLAGS) $(CPPFLAGS) $(CXXFLAGS) -c $<

.cpp.o:
	$(CXX) $(INCFLAGS) $(CPPFLAGS) $(CXXFLAGS) -c $<

.C.o:
	$(CXX) $(INCFLAGS) $(CPPFLAGS) $(CXXFLAGS) -c $<

.c.o:
	$(CC) $(INCFLAGS) $(CPPFLAGS) $(CFLAGS) -c $<

$(DLLIB): $(OBJS) Makefile
	@-$(RM) $@
	$(LDSHARED) -o $@ $(OBJS) $(LIBPATH) $(DLDFLAGS) $(LOCAL_LIBS) $(LIBS)



$(OBJS): ruby.h defines.h

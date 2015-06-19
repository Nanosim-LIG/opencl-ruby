Written by Yassine Jazouani, 2015

The LLVM pass code can be found in opencl-ruby/opencl_ruby_ffi_spir/test/addArgumentPass.cpp

To be able to generate the bytecode from file.c  : clang -c -emit-llvm file.c -o file.bc
To be able to compile the LLVM code              : opt-load LLVMHello.so -opCounter -disable-output file.bc

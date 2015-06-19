#define DEBUG_TYPE "addArg" 
#include "/home/jazouani/llvm/llvm-3.2/include/llvm/Pass.h"    
#include "/home/jazouani/llvm/llvm-3.2/include/llvm/ADT/ilist.h"    
#include "/home/jazouani/llvm/llvm-3.2/include/llvm/ADT/ArrayRef.h"    
#include "/home/jazouani/llvm/llvm-3.2/include/llvm/Argument.h" 
#include "/home/jazouani/llvm/llvm-3.2/include/llvm/Function.h" 
#include "/home/jazouani/llvm/llvm-3.2/include/llvm/Module.h" 
#include "/home/jazouani/llvm/llvm-3.2/include/llvm/Support/raw_ostream.h" 
#include "/home/jazouani/llvm/llvm-3.2/include/llvm/IRBuilder.h" 
#include "/home/jazouani/llvm/llvm-3.2/include/llvm/Type.h" 
#include "/home/jazouani/llvm/llvm-3.2/include/llvm/DerivedTypes.h" 
#include "/home/jazouani/llvm/llvm-3.2/include/llvm/GlobalValue.h" 
#include "/home/jazouani/llvm/llvm-3.2/include/llvm/TypeFinder.h" 
#include "/home/jazouani/llvm/llvm-3.2/include/llvm/Instructions.h" 
#include "/home/jazouani/llvm/llvm-3.2/include/llvm/Support/Casting.h" 
#include "/home/jazouani/llvm/llvm-3.2/include/llvm/InstrTypes.h"
#include "/home/jazouani/llvm/llvm-3.2/include/llvm/Metadata.h"
#include "/home/jazouani/llvm/llvm-3.2/include/llvm/Constant.h"
#include "/home/jazouani/llvm/llvm-3.2/include/llvm/MDBuilder.h"
#include "/home/jazouani/llvm/llvm-3.2/include/llvm/Transforms/Utils/Cloning.h"

#include <map> 
#include <vector> 


using namespace llvm; 
namespace 
{
  struct CountOp : public ModulePass 
  {
    std::map<std::string, int> opCounter;
    std::vector<std::string> addSize;
    std::vector<Function*> fns;
    std::vector<Function*> clones;
    static char ID; CountOp() : ModulePass(ID) {} 

    static MDNode* concatenate(LLVMContext& ctx, MDNode *a, MDNode *b) {
      std::vector<Value*> values;

      for (int i = 0, end = a->getNumOperands(); i < end; i++)
        values.push_back(a->getOperand(i));

      for (int i = 0, end = b->getNumOperands(); i < end; i++)
        values.push_back(b->getOperand(i));

      return MDNode::get(ctx, values);
    }

    virtual bool runOnModule(Module& m) 
    {
        IRBuilder<> irb(m.getContext());

        for (Module::iterator I = m.getFunctionList().begin(), E = m.getFunctionList().end(); I != E; ++I) 
        {
          if (I->empty())
            continue;
          fns.push_back(I);
        }

        for (std::vector<Function*>::iterator fnn = fns.begin(), EN = fns.end(); fnn != EN; ++fnn) 
        {
          Function* fn = *fnn;

          Function::const_arg_iterator AB = fn->arg_begin();
          Function::const_arg_iterator AE = fn->arg_end();
          while(AB != AE)
          {
            if(AB->getType()->isPointerTy())
            {
              Type* tmp = AB->getType();
              if(cast<PointerType>(tmp)->getAddressSpace() == 1)
              {  
                std::string name = "size_"+AB->getName().str();
                addSize.push_back(name);
              }
            }
            AB++;
          }

          FunctionType* oldType = fn->getFunctionType();

          std::vector<Type*> params;
          unsigned it = 0;
          while( it != oldType->getNumParams())
          {
            params.push_back(oldType->getParamType(it));
            it++;
          }

          std::vector <std::string>::iterator i = addSize.begin(); 
          std::vector <std::string>::iterator e = addSize.end(); 

          while (i != e) 
          { 
            params.push_back(irb.getInt32Ty());
            i++; 
          }

          FunctionType* newType = FunctionType::get(oldType->getReturnType(), params, false);
          
          Function* clone = Function::Create(newType, fn->getLinkage(), "", &m);
          clone->takeName(fn);

          std::vector <std::string>::iterator ii = addSize.begin(); 
          std::vector <std::string>::iterator ee = addSize.end();
          ValueToValueMapTy VMap;

          // Loop over the arguments, copying the names of the mapped arguments over...
          Function::arg_iterator DestI = clone->arg_begin();
          for (Function::const_arg_iterator I = fn->arg_begin(), E = fn->arg_end(); I != E; ++I)
          {
            if (VMap.count(I) == 0) 
            {   
              DestI->setName(I->getName()); // Copy the name over...
              VMap[I] = DestI++;        // Add mapping to VMap
            }
          }

          std::vector <std::string>::iterator ia = addSize.begin(); 
          std::vector <std::string>::iterator ea = addSize.end();
          for (Function::arg_iterator I = clone->arg_begin(), E = clone->arg_end(); I != E; ++I)
          {
            if(I->getName().empty())
            {
              I->setName(*ia);
              ia++;
            }
          }
 
          SmallVector<ReturnInst*, 5> returns;
          llvm::CloneFunctionInto(clone, fn,
                           VMap,
                           false, /*TODO???*/
                           returns,
                           "");

          fn->eraseFromParent();

          clones.push_back(clone);


        }

        NamedMDNode* opencl_kernels = m.getNamedMetadata("opencl.kernels");
        std::vector<MDNode*> kernels;

        for (int i = 0, end = opencl_kernels->getNumOperands(); i != end; i++) 
        {
          MDNode* old_kernel = opencl_kernels->getOperand(i);
          int numArgs = addSize.size();
          assert(old_kernel->getNumOperands() == 6);

          Value*     kernel_fn              = old_kernel->getOperand(0);
          MDNode*    kernel_arg_addr_space  = cast<MDNode>(old_kernel->getOperand(1));
          MDNode*    kernel_arg_access_qual = cast<MDNode>(old_kernel->getOperand(2));
          MDNode*    kernel_arg_type        = cast<MDNode>(old_kernel->getOperand(3));
          MDNode*    kernel_arg_type_qual   = cast<MDNode>(old_kernel->getOperand(4));
          MDNode*    kernel_arg_base_type   = cast<MDNode>(old_kernel->getOperand(5));

          // if we did not clone the function we don't have to clone the metadata
          // if (original_2_clone.count(kernel_fn) == 0)
          //   return NULL;

          IRBuilder<> irb(m.getContext());
          MDBuilder mdb(m.getContext());  

          /*************************************************************/

          // std::vector<Value*> testt;
          // for (int j = 0; j < numArgs; j++)
          // {
          //   testt.push_back(irb.getInt32(0));
          //   // arg_addr_space.push_back(irb.createglobalstring("foo"));// MDString
          // }

          // MDNode* test = concatenate(m.getContext(),
          //   NULL,
          //   MDNode::get(m.getContext(), testt)
          // );

          errs() << "avannnt\n";
          Value* jesuisentraindetester = irb.CreateGlobalString("foo");
          errs() << "apres\n";


          /*************************************************************/

          std::vector<Value*> arg_addr_space;
          for (int j = 0; j < numArgs; j++)
          {
            arg_addr_space.push_back(irb.getInt32(0));
          }

          MDNode* new_kernel_arg_addr_space = concatenate(m.getContext(),
            kernel_arg_addr_space,
            MDNode::get(m.getContext(), arg_addr_space)
          );

          /*************************************************************/

          MDNode* new_kernel_arg_access = kernel_arg_access_qual;
          for (int j = 0; j < numArgs; j++)
          {
            new_kernel_arg_access = concatenate(m.getContext(),
                new_kernel_arg_access,
                MDNode::get(m.getContext(), mdb.createString("none"))
            );
          }

          /*************************************************************/

          MDNode* new_kernel_arg_type = kernel_arg_type;
          for (int j = 0; j < numArgs; j++)
          {
            new_kernel_arg_type = concatenate(m.getContext(),
                new_kernel_arg_type,
                MDNode::get(m.getContext(), mdb.createString("int"))
            );
          }

          /*************************************************************/

          MDNode* new_kernel_arg_type_qual = kernel_arg_type_qual;
          for (int j = 0; j < numArgs; j++)
          {
            new_kernel_arg_type_qual = concatenate(m.getContext(),
                new_kernel_arg_type_qual,
                MDNode::get(m.getContext(), mdb.createString(""))
            );
          }

          /*************************************************************/

          MDNode* new_kernel_arg_base_type = kernel_arg_base_type;
          for (int j = 0; j < numArgs; j++)
          {
            new_kernel_arg_base_type = concatenate(m.getContext(),
                new_kernel_arg_base_type,
                MDNode::get(m.getContext(), mdb.createString("int"))
            );
          }

          /*************************************************************/
          
          errs() << "5" << "\n";

          // create new kernel metadata
          std::vector<Value*> new_args;
          // new_args.push_back(original_2_clone);
          // new_args.push_back(test);
          new_args.push_back(jesuisentraindetester);
          new_args.push_back(new_kernel_arg_addr_space);
          new_args.push_back(new_kernel_arg_access);
          new_args.push_back(new_kernel_arg_type);
          new_args.push_back(new_kernel_arg_type_qual);
          new_args.push_back(new_kernel_arg_base_type);

          MDNode* new_kernel = MDNode::get(m.getContext(), new_args);

          // create new metadata
          kernels.push_back(new_kernel ? new_kernel : old_kernel);

        }
        m.eraseNamedMetadata(opencl_kernels);
        opencl_kernels = m.getOrInsertNamedMetadata("opencl.kernels");

        for (std::vector<MDNode*>::iterator I = kernels.begin(), E = kernels.end(); I != E; ++I)
        {
          opencl_kernels->addOperand(*I);
        }
        m.dump();

        return true;
  }

};
}/**************************************************************************/



char CountOp::ID = 0; static RegisterPass<CountOp> X("addArg", "Adds needed argument in function");

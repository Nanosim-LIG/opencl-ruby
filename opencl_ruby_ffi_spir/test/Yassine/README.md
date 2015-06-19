Written by Yassine Jazouani 2015


--------------------------------------------------HOW IT WORKS------------------------------------------------------

The pass in run on the current module. Here a the steps of the code :

1) Get all functions of the module and put them in a list (fns)
2) Iterate on the arguments of the functions. Each time there's an argument of pointer type float and address space is 1,
   it's a kernel buffer and save them in addSize vector.
3) For each functions, we will add more arguments in their signature. To do so we create a clone function which will 
   contain the same body, the old arguments but also added arguments. 
4) When the clone function is set, we delete the old one.
5) Now, we need to add metadata regarding the added kernel buffer size arguments.
6) Done !

---------------------------------------------------------------------------------------------------------------------




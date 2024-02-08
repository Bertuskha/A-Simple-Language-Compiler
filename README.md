# A-Simple-Language Compiler
A compiler in C++ for an imperative language called "A Simple Language". It comes with a synthax lexer & parser, type checker, symbols table and code generation (which is executable using a virtual machine called TVM). 

This project uses and expands upon a basic antlr grammar & visitor framework. It also uses a virtual machine environment for code linking and execution. All documentation here: https://www.cs.upc.edu/~cl/practica/

---
## Directory structure

The repository is divided into 3 directories:

- **Asl:** Contains all the source code for the project, from the ANTLR4 grammar to the code visitors.
- **Examples:** Contains example files to test the compiler functionalities (Explained further in the *Execution & testing* section).
- **TVM:** Contains the virtual machine program **TVM** to execute the generated code (Explained further in the *Execution & testing* section). 

---
## Execution & testing

**Compilation:** To compile the project, first run `make antlr` to compile the ANTLR4 grammar and base visitor for the Abstract Syntax Tree (AST). Then, run `make` with default rule to compile each of the specific purpose visitors and the main code of the program.

### Type Check & Symbols Table tests

All test files called `jpbasic_chkt_XX` or `jp_chkt_XX`, test only the part of the compiler that handles synthax errors, type errors and symbols errors. As these tests always contain some kind of error, they won't generate any code and will just output an error log. To execute the program just run the following command:

`$ ./asl/asl > ./examples/jp(basic)_chkt_XX.asl < jp(basic)_chkt_XX.out` This runs the `asl` executable inside the `asl` directory. The input file is any of the typecheck test files mentioned before. The output displays any error detected, their position and the type. If we redirect the default output channel to a file as shown in the example, we can check if the compiler is detecting the proper errors comparing it to the `jp(basic)_chkt_XX.err` by running a diff command.

### Code Generation tests

All tests files called `jpbasic_genc_XX` or `jp_genc_XX`, are examples of inputs without errors. 



- *



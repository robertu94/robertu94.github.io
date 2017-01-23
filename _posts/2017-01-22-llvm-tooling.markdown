---
layout: post
title: "LLVM Tooling for C++"
date:   2017-01-22 18:58:14 -0500
tags:
- "C/C++"
- testing
- programming
---

C++ is a both a fantastic language and a mess.
It supports at least 4 programming paradigms (procedural, functional, object-oriented, template meta-programming).
In some senses, many languages give you one great way to do things: C++ gives you every way and trusts you to use them well.
With this flexibility comes problems that C++ seems to have beyond what other languages experience.
Therefore, having effective tooling to develop and use C++ is essential.

The LLVM project is was designed to be a very modular compiler infrastructure.
While it was designed to write compilers, the [LLVM](http://llvm.org/) project has facilitated a variety of code analysis and source-to-source transition tools.

## Getting started

Many LLVM based tools require a ["compilation database"][compilation-database] file in order to know what flags to pass to the compiler when extracting the abstract syntax tree.
Generating this file by hand is a bit of a pain, but if you use [CMake][cmake], it will generate the compilation database.
Just add the following line to your `CMakeLists.txt` file

```cmake
set(CMAKE_EXPORT_COMPILE_COMMANDS ON)
```

## Code Quality Tools

Of the various tools included, those that warn about code quality problems are probably the most useful.
The LLVM code quality warnings are divided into 3 types:

1.	**Errors and Warnings** emitted by the **compiler**: these are almost always not desired behavior.
2.	**Warnings** emitted by the **static analyzer**: these are more often not desired behavior or are less reliable checks that have a higher false positive rate than those in the compiler.
3.	**Warnings** emitted by the **clang-tidy**: these are more subjective tests such as those regarding to a style guide or those that discourage c-based constructs in favor of c++ equivalents.

Since most are familiar with compiler warnings, I will focus on the latter two.
The easiest way to run the static analyzer is via the `scan-build` utility:
The scan-build utility instruments a build by modifying the `CXX`, `CXXFLAGS`, and other similar environment variables.
One common stumbling block is that scan build will only instrument active builds.
Therefore, if the file in question is "up to date" according to your build system, then scan build will not check that file.
Just run a "clean" on the object files first:

```bash
make clean
scan-build make
```

Clang-tidy provides some additional advise about improving the quality of your code.
Of particular use is the `moderize-*` checkers which advise on how to use `c++11` constructs in existing code.
Also useful are the `cert-*` checkers which look for common security vulnerabilities

```bash
#list all avialible checks
clang-tidy -checks="*" -list-checks

#run all checkers on all files
clang-tidy -p /path/to/build/dir --checks="*" *.cc 

#run just the moderize checks on all files
clang-tidy -p /path/to/build/dir --checks="moderize-*" *.cc 
```

It is also possible to write your own [checks using AstMatchers][write-checkers]


## Other Tools

At the time of writing, general refactoring tools in LLVM are still in their infancy.
There are two that are considerable farther along:

+	`clang-rename` -- rename a symbol from a fully qualified name or offset.  Currently this tool only renames a symbols within a single translation unit which is useful enough, but leaves you wanting with large object oriented projects.
+	`clang-include-fixer` -- add missing includes from within the projects.  This project requires a yaml database in addition the compile.json file.  This file can be created using the run-find-all-symbols.py (which on Gentoo is installed into /usr/share/clang/run-find-all-symbols.py).

There are several other useful tools worth mentioning:

+	`clang-format` a C++ code formatting tool.
+	`clang-query` a tool to inspect the clang Ast that you can use in building a custom tool. 
+	`lldb` the llvm debugger which is considerably more script-able than GDB.


There are too may tools to cover in a single post.
Check out the [clang docs][clang-docs] for a more complete listing.
For further reading, I recommend the work of [Eli Bendersky][eli] who has written several posts on LLVM and clang.

Happy programming!



[cmake]: https://cmake.org/
[clang-docs]: http://clang.llvm.org/docs/index.html
[write-checkers]: http://eli.thegreenplace.net/2014/07/29/ast-matchers-and-clang-refactoring-tools
[compilation-database]: http://eli.thegreenplace.net/2014/05/21/compilation-databases-for-clang-based-tools
[eli]: http://eli.thegreenplace.net/

---
layout: post
title:  "External Clang-Tidy Modules! C++ Refactoring for the Common Project"
date:   2023-03-10
tags: 
- programming
- clang-tidy
- refactoring
- libtooling
---

Clang style refactoring has been something I've been admiring from afar for
quite a while now.  However for a user to actually use it, it has previously
required forking llvm to be able to use it in a reasonable fashion because of
things like the hack in clang used to locate the resource directory or other
fragile hacks like `LD_PRELOAD`.

Recently, the Clang/LLVM developers vastly improved the situation by allowing
loadable clang-tidy modules and by installing all of the headers that you
actually need to do something with clang tidy, and they are finally packaged on
both Fedora and Ubuntu!

While you may think that clang-tidy modules are just for linting, they are actually a
super helpful simple way to build clang based tooling that have access to  most if not
all of the features that you would like to have to do refactoring including

+ diagnostics
+ ast matchers
+ fix-it hints including simple source replacement with clangTransformer
+ `compile_commands.json` support
+ and much much more

To show this off, I created [this example repo](https://github.com/robertu94/clang-tidy-external-example)
which roughly follows the [Clang-Tidy](https://clang.llvm.org/extra/clang-tidy/Contributing.html) documentation to create the check.
However, I needed to do a few small things to get things working externally:

First you need to do a dance with CMake to add the appropriate build commands:

```cmake
find_package(Clang REQUIRED)
list(APPEND CMAKE_MODULE_PATH "${CLANG_CMAKE_DIR}")
list(APPEND CMAKE_MODULE_PATH "${LLVM_CMAKE_DIR}")
include(AddLLVM)
include(AddClang)
set( LLVM_LINK_COMPONENTS
  ${LLVM_TARGETS_TO_BUILD}
  Core
  Option
  Support
  )
```

Which makes the cmake commands `add_clang_library` and `clang_target_link_libraries` which understand the specific linking syntax used for clang and LLVM.

Next, you need to use these commands to create your check module:

```cmake
add_clang_library(myclang_tidy SHARED
  ./src/clangtidy_libpressio.cc
  ./include/clangtidy_libpressio.h
  )
clang_target_link_libraries(myclang_tidy
  PRIVATE
  clangAnalysis
  clangAST
  clangASTMatchers
  clangBasic
  clangFormat
  clangFrontend
  clangLex
  clangRewrite
  clangSema
  clangSerialization
  clangTooling
  clangToolingCore
  clangTidy
  clangTidyModule
  )
```

I'm not sure if all of these modules are needed, but this is what `clang-tidy` used at the time of writing.

That's it.  `add_clang_library` adds install rules for you to install it in a reasonable place.
So you are ready to write your clang-tidy check.

Hope this help!

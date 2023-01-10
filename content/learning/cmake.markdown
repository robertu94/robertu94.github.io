---
layout: post
title:  "Learning to Learn: CMake"
date:   2022-11-15 05:00:00 -0500
tags: 
- Learning to Learn
- Programming
- C++
---

CMake is the de-facto C++ build system used by an overwhelming number of C++ projects.
Even if you personally favor more modern alternatives such as Meson, Bazel, or Pants, if you 
ever pull in a 3rd party dependency, there is a good chance that it uses CMake so
knowing enough about CMake to understand it is worth knowing.

# How to get started

I recommend new users to CMake start with the following resources:

+ [Mastering CMake](https://cmake.org/cmake/help/book/mastering-cmake/) is a high level overview of how to use CMake developed and maintained by the CMake Developers.
+ [Modern CMake](https://cliutils.gitlab.io/modern-cmake/) Is focuses on a useful subset of CMake for a number of common tasks.

# Using CMake to build something

If a package cmake 3.15 or newer (most people), the following sequence will build and install a cmake project

```bash
cmake -S ./path/to/sourcedir -B ./path/to/builddir
cmake --build -j $(nproc)
cmake --install
```

Here `./path/to/sourcedir` is the directory where you source files (specifically the "toplevel" `CMakeLists.txt` is stored).
and `./path/to/builddir` is a directory (which may not exist) where you want to store build artifacts prior to installation.

You can customize the build by passing flags to the first cmake command.  I commonly use the following

```bash
cmake -S ./path/to/sourcedir -B ./path/to/builddir \
        -G Ninja \
        -DCMAKE_INSTALL_PREFIX=$(pwd)/.local \
        -DBUILD_SHARED_LIBS=ON \
        -DBUILD_TESTING=ON \
        -DCMAKE_BUILD_TYPE=Debug \
        -DCMAKE_CXX_COMPILER_LAUNCHER=ccache \
        -DCMAKE_C_COMPILER_LAUNCHER=ccache \
        -DCMAKE_EXPORT_COMPILE_COMMANDS=ON
cmake --build -j $(nproc)
cmake --install
```

To prefer the `Ninja` build generator, and `ccache` for faster development builds with shared libraries
installed to my user's prefix instaed of the the `/` or `/usr` prefix which may require admin privledges
and to enable LLVM based tooliing (i.e. `clangd` for completions in my editor).  These preferences
are encoded into my [`m` build tool](https://github.com/robertu94/m).

CMake also respects GNU style envionment variables (i.e. `CXX`, `CC`, `CFLAGS`,
`CXXFLAGS`, and `LDLIBS`) to pick up common defaults.


# Key Commands

Required boilerplate that must appear at the top of your top-level cmake

+ `cmake_minimum_required`
+ `project`

Basics

+ `add_library` and `add_executable` create build objects
+ `target_link_libraries` and `PUBLIC` vs `PRIVATE` to consume dependancies (including their header file flags) and link libraries
+ `target_include_directories` to set include paths not provided by link libraries
+ `target_compile_features` a portable way to set the C++ standard
+ The most essential cmake variables `$CMAKE_CURRENT_SOURCE_DIRECTORY` and `$CMAKE_CURRENT_BINARY_DIRECTORY`
+ Basic generator expressions such as `$<BUILD_INTERFACE:>` vs `$<INSTALL_INTERFACE:>` for use with `target_include_directories`
+ `add_subdirectory` for code organization

Adding 3rd party dependancies.  Do yourself a favor and put all dependancies imports at the top level so the scope is right for the whole project.

+ `find_package` to import dependancies built using CMake and certain system dependancies such as threads, MPI, Python, and OpenMP.
+ `find_package(PkgConfig)` and `pkg_search_modules` to import dependencies described by pkg-config
+ `FetchContent` download and provide dependencies as part of the build.

Build Options

+ `option` to add build options
+ `if` for basic control flow
+ `configure_file` to add a "configure file" which is typically header which has `#defines` for certain build system variables set with `#cmakedefine` or `#cmakedefine01`
+ `target_add_sources` to add additional source files to a library after the fact.

Installation

+ `include(GNUInstallDirs)` and its associated variables like `CMAKE_INSTALL_PREFIX`, `CMAKE_INSTALL_INCLUDEDIR` , and `CMAKE_INSTALL_LIBDIR`
+ `install(TARGETS)` to install your libraries and their export files 
+ `install(DIRECTORY)` to install your header files and data files
+ `include(CMakePackageConfigHelpers)` and `configure_package_config_file` and `write_basic_package_version_file` to make your package importable by others

Testing

+ `include(CTest)`, `BUILD_TESTING`, and `add_test`
+ `include(GoogleTest)` and `gtest_discover_tests` for high quality integration of googletest based tests

CMake Magic Variables to reconfigure builds

+ `CMAKE_BUILD_TYPE` automatically configure optimizations like `-O2` and `-Og -g` with settings like `Release` or `Debug` there are also other settings for `RelWithDebInfo` and `MinSizeRel` for small build artifacts
+ `BUILD_SHARED_LIBS` to choose between shared and static linking
+ `INTERPROCEDURAL_OPTIMIZATION` property enables IPO for faster optimizations

# Enabling 3rd Party technologies

CMake provides most of what you want on its own, but a few tools are worth knowing about:

+ `spack` a dependencies manager for HPC software
+ `connan` and `vcpackage` a dependency managers more common in enterprise
+ `ccache` and `sccache` can be provided to `CMAKE_<Lang>_COMPILER_LAUNCHER` to dramatically speed up re-builds builds
+ `ninja` is a much faster project builder than `Make`.  You can enable it with `-G` passed to cmake
+ `ccmake` a terminal user interface for setting cmake build options
+ `clang-tidy` and `include-what-you-use` for extra static analysis can be used by setting the `<LANG>_CLANG_TIDY` and `<LANG>_INCLUDE_WHAT_YOU_USE`
+ `Doxygen` for automatic documentation form the header-files of your project

# Important Concepts

+ `PUBLIC`, `INTERFACE` vs `PRIVATE` dependency and configurations
+ `SHARED`, `STATIC`, `INTERFACE` vs `IMPORTED` libraries.  The later you will use directly only seldomly but is used for `find_package` internally.
+ that `target_*` functions accumulate from everywhere they are used allowing code that adds specific features to be spread out
+ Don't use globbing to add files to a build.  List them explictly for best performance


# Advanced Topics

+ `for`, `function`, and `macro` for advanced control flow
+ `execute_process` for when you just need to run a script
+ CUDA and other accelerator language support

# Where to learn more

+ [The Offical CMake Documentation](https://cmake.org/cmake/help/latest/index.html)

# Changelog

+ 2023-01-09 Added basic usage example
+ 2022-11-15 Created


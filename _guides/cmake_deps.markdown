---
title: "How to add a dependency in CMake"
layout: post
date: 2022-10-19
...

# tl;dr

Most of the time simply use `find_package`, set `CMAKE_PREFIX_PATH` to include the path specified in  `CMAKE_INSTALL_PREFIX` when the package was installed like so:

```cmake
find_package(std_compat REQUIRED)
target_link_libraries(my_library PUBLIC std_compat::std_compat)
```

Tools like `spack` will set `CMAKE_PREFIX_PATH` for you.  Otherwise specify it using an envionment variable or with a `-D` flag to cmake.

# How to add the dependency

Adding a dependency in CMake is pretty straight forward, but depends on where it is coming from.  You should do the first one that is applicable.

1. If a library is defined in the same cmake file or one in a parent directory, you can use it directly.
2. If a library is defined in some other cmake project, you often import it with `find_package`
3. If a library has a pkg-config, you should use `pkg_search_module` to import it.
4. If a library has a find command such as `llvm-config` or Tensorflow's you can create an imported target, use `execute_process` to get the flags, and use the `SHELL:` prefix for `target_compile_options` and or `target_link_options` to set the build options
5. If a library has none of these, locate the library with `find_library` and header with `find_file` then create a imported target.

# Public vs Private

If the thing you are building is a library, generally choose `PUBLIC` unless it you are writing a header only library in which case choose `INTERFACE`.

If the thing you are building is an executable, choose `PRIVATE`.

You can also choose `PRIVATE` if none of the headers you link to are in the transitive closure of any of your public header files.


# What is the name to pass to `find_package` and `target_link_libraries`

If it is one of the built-ins (i.e. MPI/OpenMP), check the CMake docs.

If it comes from a user-defined package, look for a directory called `cmake` installed with the package.  In there should be a file called `...Targets.cmake` where the `...` is some name.  The text before `Targets.cmake` is the entry to pass to `find_package`.  In this file is a list of `expectedTargets` which will contain the names the package exports.


# Importing PkgConfig libraries

```cmake
find_package(PkgConfig REQUIRED)
pkg_search_module(ZSTD IMPORTED_TARGET GLOBAL libzstd)
target_link_libraries(my_library PUBLIC PkgConfig::ZSTD)
```

There isn't anything sacred about `ZSTD` as the name here.  It can be replaced with another name that makes sense.
The `libzstd` bit is what pkg-config looks for.
`IMPORTED_TARGET GLOBAL` makes things "modern" allowing you to just add a `target_link_library` command to add the include flags.
`pkg-config --list-all |grep $name_of_package` can help you find package config files.


# Importing libraries with a find tool

Example using Tensorflow:

```cmake
find_package(Python REQUIRED)
execute_process(COMMAND "${Python_EXECUTABLE}" "-c" "import tensorflow as tf; print(*tf.sysconfig.get_compile_flags())"
  OUTPUT_VARIABLE TENSORFLOW_COMPILE_FLAGS
	OUTPUT_STRIP_TRAILING_WHITESPACE)
execute_process(COMMAND "${Python_EXECUTABLE}" "-c" "import tensorflow as tf; print(*tf.sysconfig.get_link_flags())"
  OUTPUT_VARIABLE TENSORFLOW_LINK_FLAGS
	OUTPUT_STRIP_TRAILING_WHITESPACE)
target_link_options(my_library PUBLIC
  SHELL:${TENSORFLOW_LINK_FLAGS}
  )
target_compile_options(my_library PUBLIC
  SHELL:${TENSORFLOW_COMPILE_FLAGS}
  )
```

# Transitive Dependencies

tl;dr, add the find_package or similar commands to `FooConfig.cmake.in` file
you wrote for each `PUBLIC`, `INTERFACE` or `IMPORTED` dependency that you add.
This isn't required for `PRIVATE` dependencies. Or
[LibPressioTools](https://github.com/robertu94/pressio-tools/blob/f2bc306102845cdf8a4a1602b9bf1091db5c2e04/LibPressioToolsConfig.cmake.in#L8-L35)
for an example with several optional dependencies.

[See the docs for more details](https://cmake.org/cmake/help/latest/module/CMakePackageConfigHelpers.html)

# Using `find_library` `find_program` and `find_file`

Avoid this if possible.

```cmake
find_library(CUFile_LIBRARY cufile PATHS ${CUDAToolkit_LIBRARY_DIR} REQUIRED)
find_file(CUFile_HEADER cufile.h PATHS ${CUDAToolkit_INCLUDE_DIR} REQUIRED)

# After CMake 3.20, prefer `cmake_path` instead because it doesn't access the filesystem
get_filename_component(CUFile_HEADER_DIR "${CUFile_HEADER}" DIRECTORY)

# it's probably better to create an IMPORTED library here than to just add them all to the library I want to link
# cuFile to, but CUDA::cuda_driver and CUDA::cuda_rt are link # dependencies for cufile that I found in the documentation

target_link_libraries(libpressio PRIVATE CUDA::cuda_driver CUDA::cudart ${CUFile_LIBRARY})
target_include_directories(libpressio PRIVATE ${CUFile_HEADER_DIR})
```

These often need to be exported differently.  [See the docs for best practices to export these](https://cmake.org/cmake/help/latest/manual/cmake-developer.7.html#find-modules)

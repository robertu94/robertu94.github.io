---
title: "What to support if you are supporting"
layout: post
date: 2023-09-12
---

Dependencies matter a lot in terms of who can easily install and use your software.
However there are trade-offs in what features are provided by each version and the availability of these versions.
This presents an opinionated take on what these trade-offs are so one can know what can be widely supported.

Last update: 2023-09-12

# Major Linux Distros

| Distro              | Standard EoL     |
|---------------------|------------------|
| CentOS-8 compatible | December 2021`*` |
| CentOS-9 stream     | May 2027`*`      |
| OpenSUSE Leap 15.6  | December 2025    |
| Ubuntu 20.04        | April 2025       |
| Ubuntu 22.04        | April 2027       |
| Ubuntu 24.04        | April 2029       |

+ Ubuntu LTS releases generally get 5 years of standard support
+ Fedora releases generally get ~1 year of support
+ `*` Third party vendors such as AlmaLinux support these for much longer 2029 for CentOS-8, and 2032 for CentOS-9.

# Tooling Versions

| Tool     | Ubuntu 20.04 | Ubuntu 22.04 |Ubuntu 24.04 |  CentOS 8        | CentOS 9 Stream | SUSELeap       |Fedora       |
|----------|--------------|--------------|-------------|------------------|-----------------|----------------|-------------|
| gcc      |  9.4.0       | 11.4.0       | 13.2.0      |  8.5.0           | 11.3            | 7.5.0`^` to 14 | 14.2.1      |
| clang    |  10.0.0      | 14.0.0       | 18.1.3      |  15.0.0          | 16.0            | 17.0.6         | 18.1.6      |
| cmake    |  3.16.3      | 3.22.1       | 3.28.3      |  3.20            | 3.20            | 3.28.3         | 3.28.2      |
| python3  |  3.8.10      | 3.10.0       | 3.12.3      |  3.6-3.9         | 3.9,3.11        | 3.6.15         | 3.12        |
| julia    |  1.4.1`#`    | n/a          | n/a         |  n/a             | n/a             | 1.0.3`#`       | 1.11.0-beta1|
| cargo    |  1.66.1      | 1.66.1       | 1.75.0      |  1.66.1          | 1.61.1          | 1.82.0         | 1.80.1      |
| swig     |  4.0         | 4.0          | 4.2.0       |  3.0.12          | 3.0.12          | 4.1.1          | 4.2.1       |
| nvcc `*` |  10.1        | 11.5.0       | 12.0.140    |  n/a `*`         | n/a `*`         | n/a `*`        | n/a `*`     |
| numpy    |  1.17.4      | 1.21.5       | 1.26.4      |  1.14.3          | 1.20.1          | 1.17.3         | 1.26.4      |

`#1` has known issues and upstream [recommends avoiding using this version](https://old.reddit.com/r/Julia/comments/ubdva0/what_happened_to_julia_on_ubuntu_2204_repos/i65xf8n/)
`*` CentOS, and Fedora do not package CUDA themselves, but instead rely on Nvidia to provide the package which provides the newest version.
`^` OpenSUSE Leap provides many gcc compilers, the default is 7.5.0

# Language Features

## C++

For more information consult [cppreference.com](https://cppreference.com)
C++ is divided into language and library features.  Generally Language features are implemented before library features.
While Clang originally led for compliance, increasingly GCC is getting newer features sooner.

### C++14

You can safely assume that C++14 is supported on all major distributions.

| Compiler | C++14 (language full) | C++14 (language 90%) | Missing | C++14 (library full) | C++14 (library 90%) | Missing |
|----------|-----------------------|----------------------|---------|----------------------|---------------------|---------|
| GCC/libstdc++      | 5                     | 5                    | N/A     | 10                   | 5                   | partial support for null forward iterators (N3644) |
| Clang/libc++    | 3.4                   | 3.4                  | N/A     | 3.4                  | 3.4                 | N/A          |

### C++17

C++17 language features are supported on all major distributions.

C++17 library features require very new compilers to implement fully and are not widely available on LTS systems.  The most common things to lag behind being parallel parallel algorithms, so-called special math functions used in statistics, and OS assisted features like hardware interference size.  In many cases these can be "poly filled"

| Compiler | C++17 (language full) | C++17 (language 90%) | Missing | C++17 (library full) | C++17 (library 90%) | Missing |
|----------|-----------------------|----------------------|---------|----------------------|---------------------|---------|
| GCC/libstdc++      | 7                     | 7                    | N/A     | 12                   | 9                   | "elementary string conversions" (P0067R5),          |
| Clang/libc++    | 4                     | 4                    | N/A     | No                   | 17                  | parallel algoirthms, hardware interference size, special math functions        |

### C++20

C++20 language features are not not fully implemented in even the newest compilers.  The biggest holdout is modules and features like consteval, but compilers that implement 90% of the features are present in recent LTSes.

C++20 library features are more sparsely implemented, but are now fully implemented in GCC 14 and 90% implemented as of clang 18 starting to be available in "cutting edge distros" such as Fedora and some LTSes.

| Compiler     | C++20 (language full) | C++20 (language 90%) | Missing                                                                                      | C++20 (library full) | C++20 (library 90%) | Missing |
|--------------|-----------------------|----------------------|----------------------------------------------------------------------------------------------|----------------------|---------------------|---------|
| GCC/libstdc++| 11`*`                 | 10                   | Only partial support for Modules add in 11, using enum, `operator<=>(...)=default`, consteval| 14                   | 11                  | `calendar`, text formatting, atomics |
| Clang/libc++ | No                    | 17                   | Modules, Coroutines, Non-type template parameters                                            | No                   | 18                  | atomics, source location, `operator<=>` |

`*` full support for modules is the lone holdout.


### C++23

Bleeding edge compilers now have 90% support for C++23 language features.

Library features are not widely implemented in compilers, however some major constexpr features (e.g. constexpr unique_ptr, optional, variant) as well as some new vocabulary types like std::expected now have support.


| Compiler     | C++20 (language full) | C++20 (language 90%) | Missing                                                                                      | C++20 (library full) | C++20 (library 90%) | Missing |
|--------------|-----------------------|----------------------|----------------------------------------------------------------------------------------------|----------------------|---------------------|---------|
| GCC/libstdc++| No                    | 15                   | lifetime extensions for range `for` loops, scope for training lambda return types            | No                   | No                  | lots    |
| Clang/libc++ | No                    | 19                   | sized float types, CTAD from inherited constructors, pointers in costexprs,                  | No                   | No                  | lots    |

### C++26

It is too early to start looking at C++26 compiler conformance.

### CMake 

Every major non-EoL distribution supports at least CMake 3.16.
If you need to do things with CUDA try to stick to CMake 3.20 or newer which has much more robust support for GPU programs which is available on all distributions except CentOS7.
3.25 is needed for cuFILE APIs which is only available on more cutting edge distros.

+ **3.10** Added `flang,`ccache` for Ninja, GoogleTest `gtest_discover_tests()`
+ **3.11** Added `add_library` without sources, `FindDoxygen`, `
+ **3.12** Added `cmake --build`, `<PackageName>_ROOT` for `find_package`, many improvements to `FindSwig`
+ **3.13** Added `cmake -S ... -B ...` to set source and build dirs, `target_link_libraries` can now be called on targets from different directories., more improvements to `Swig`
+ **3.14** Added `get_filename_component()`, `install(FILES)`/`install(DIRECTORIES)` now uses GNUInstallDirs by default, `FtechContent_MakeAvailable()`, numpy support in `FindPython`
+ **3.15** Improved Python lookups and `Python3::Module`, `$<COMPILE_LANGUAGE:>` with a single language, `--install`
+ **3.16** Added support for unity builds
+ **3.17** Added Ninja multi-config, `CMAKE_FIND_DEBUG_MODE`, `FindCUDAToolkit`, 
+ **3.18** `add_library` can now create Alias targets (useful for FetchContent), `CMAKE_CUDA_ARCHITECTURES`, FindLapack imported target, improvements to GoogleTest test discovery
+ **3.19** Apple Silicon, `CheckCompilerFlag` generalizes C/C++ specific versions
+ **3.20** `CUDAARCHES` environment variable added, Nvidia HPC SDK, OneAPI compilers, improved FindCudaToolkit with ccache, better implicit dependencies.
+ **3.21** cmake-presets, Fujitsu compiler
+ **3.22** `CMAKE_BULID_TYPE` default variable 
+ **3.23** improvements to presets, `HEADER_SETS` for IDE integration, many improvements to CUDA seperate compilation
+ **3.24** improvements to presets, `CMAKE_CUDA_ARCHITECTURES=native`, fetch content can now try find_package first
+ **3.25** improvements to presets, `block` scoping, try_compile doesn't need a binary directory, cufile
+ **3.26** imagemagick imported targets, Python "Stable ABI" targets 
+ **3.27** Cuda Object libraries, FindDoxygen config file support, FindCUDA (old and deprecated) removed
+ **3.28** Cmake modules support is stable but not supported compilers until GCC 14 and LLVM 16 and using the Ninja generator, CMAKE_HIP_PLATFORM to compile hip code using Nvidia GPUs, CrayClang, many commands became `JOB_SEVER_AWARE` to better support nested builds.
+ **3.29** `CMAKE_INSTALL_PREFIX` env variable, ctest jobserver support
+ **3.30** c++26 support, Backtrace module support, free threaded python support
+ **3.31** OpenMP CUDA support, `cmake_pkg_config` to avoid native pkg-config dependency


### Swig

Swig 3 is widely available, but Swig 4 is not -- try to avoid C++14 in swig wrapped interfaces.

+ **4.2** Many improvements for std::array, std::map, std::string_view, python3.12
+ **4.1** Added move semantics support improved, many new languages supported (e.g. Node 18, Php 8, Python 3.11)
+ **4.0** Added C++11 STL container support to Python, and better support for C++14 code
+ **3.0** Added C++11 language support

### Cuda

CUDA places requirements on your GCC/clang version, but also places requirements on supported hardware.
This [note has much more detail](https://gist.github.com/ax3l/9489132).

When using NVCC:

| cuda version | max gcc | sm versions       |
|--------------|---------|-------------------|
| **8.1**      | 5.3     | 2-6.x             |
| **9.1**      | 6       | 4-7.2             |
| **11.5**     | 11      | 3.5-8.6           |
| **12.0**     | 12.1    | 4-9               |
| **12.1-3**   | 12.2    | 4-9               |
| **12.1-3**   | 12.2    | 4-9               |
| **12.4-5**   | 13.2    | 4-9               |

It is also possible to use clang++ to compile cuda

| clang version | cuda release | sm versions  |
|---------------|--------------|--------------|
| 6             | 7-9          | 3-7.0        |
| 10            | 7-10.1       | 3-7.5        |
| 14            | 7-11.0       | 3-8.0        |
| 15            | 7-11.5       | 3-8.6        |
| 16            | 7-11.8       | 3-9.0        |
| 17            | 7-12.1       | 3-9.0        |

In newer versions of cuda, this command outputs your compute version.

```bash
nvidia-smi --query-gpu=compute_cap --format=csv
```


## Python

For widest compatibility, avoid features newer than 3.6, however when CentOS7 is EoL, 3.8 is the next lowest common denominator.

+ **3.6** Added `fstring`s, types for variables, async generators, `PYTHONMALLOC` and more.
+ **3.7** Added `breakpoint()`, `@dataclass`, `time.perf_counter_ns()` and more
+ **3.8** Added `:=` operator, position only parameters, fstring `{var=}` syntax, and more
+ **3.9** Added `|` for `dict`, `list` instead of `List` in types, and is much faster and more
+ **3.10** Added `match` pattern matching, parenthesized context managers, type `|` operator,  and more
+ **3.11** Added exception groups, tomllib, variatic generics, Self type, string literal type, is much faster and more
+ **3.12** Added `Path.walk`, improved f-strings, type alias, `sys.monitoring`, `collections.abc.Buffer`
+ **3.13** Added improved interpreter and error messages, jit bytecode interpreter for faster hot functions, `copy.replace`. Experimental support for noGIL python

### Manylinux

Python's pip uses `manylinux` containers to provide broadly compatible binaries for use with python.

| Version                       | GCC  | Python                   | Base        |
|-------------------------------|------|--------------------------|-------------|
| manylinux_2_28                | 12   | 3.8.10+, 3.9.5+, 3.10.0+ | Almalinux 8 |

PEP 600 defines manylinux_x_y where x==glibc_major version, y==glibc_minor_version.
There are docker containers that provide build envionments for these packages that should be preferred.
One should also check the `auditwheel` command to ensure that the compiled library does not link to a disallowed library.

### Numpy

+ 1.17 `__array_function__` support, `random` module made more modular
+ 1.18 64 bit BLAS/LAPACK support
+ 1.19 dropped support for python < 3.6
+ 1.20 Numpy added typing support, wider use of SIMD, start of dtype refactor
+ 1.21 more type annotations, more SIMD
+ 1.22 most of main numpy is typed, array api and C support for dlpack supported
+ 1.23 python support for dlpack
+ 1.26 support array_api v0.2022.12, but fft not supported for now; new build flags
+ 2.0 many changes to the public/private api, changes to C functions, many performance improvements
+ 2.1 support for array_api v2023.12, prelimiary support for GIL free python

## Julia

Generally Julia installations will be relatively new since they are often not provided by the package manager.
There have been significant reductions in time to first plot in recent versions

+ **1.5** threading, `@ccall`
+ **1.6** various quality of life improvements
+ **1.7** property destructuring, `@atomic`, reproducible RNG, libblastrampoline
+ **1.8** const on fields in mutable structs, `SIGUSR1` profiling
+ **1.9** `:interactive` threads, `jl_adopt_thread`, `Iterators.flatmap`, Package Extensions
+ **1.10** CartesianIndex can now broadcast, vastly improved package compilation times
+ **1.11** new `Memory` type, `public` keyword, `@main` for an opt-in entrypoint, greedy `Threads.@threads`


Hope this helps!

# Changelog

+ 2024-08-28: comprehensive updates, addeed numpy to tracking
+ 2024-02-22: added python and cuda and updated cmake
+ 2023-09-12: Created

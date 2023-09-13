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
| CentOS-7 compatible | July 2024        |
| CentOS-8 compatible | December 2021`*` |
| CentOS-8 stream     | May 2024         |
| CentOS-9 stream     | May 2027`*`      |
| Ubuntu 16.04        | April 2021       |
| Ubuntu 18.04        | April 2023       |
| Ubuntu 20.04        | April 2025       |
| Ubuntu 22.04        | April 2027       |

+ Ubuntu LTS releases generally get 5 years of standard support
+ Fedora releases generally get ~1 year of support
+ `*` Third party vendors such as AlmaLinux support these for much longer 2029 for CentOS-8, and 2032 for CentOS-9.

# Tooling Versions

| Tool    | Ubuntu 18.04 | Ubuntu 20.04 | Ubuntu 22.04 | CentOS 7 | CentOS 8        | CentOS 9 Stream | Fedora |
|---------|--------------|--------------|--------------|----------|-----------------|-----------------|--------|
| gcc     | 7.5.0        |  9.4.0       | 11.4.0       | 4.8.5    | 8.5.0           | 11.3            | 13     |
| clang   | 6.0.0        |  10.0.0      | 14.0.0       | 3.4.2    | 15.0.0          | 16.0            | 16     |
| cmake   | 3.10.2       |  3.16.3      | 3.22.1       | 3.17.5   | 3.20            | 3.20            | 3.27   |
| python3 | 3.6.9        |  3.8.10      | 3.10.0       | 3.6.8    | 3.6-3.9         | 3.9,3.11        | 3.11   |
| julia   | n/a          |  1.4.1`#`    | n/a          | n/a      | n/a             | n/a             | 1.9.2  |
| cargo   | 1.65.0       |  1.66.1      | 1.66.1       | 1.72.0   | 1.66.1          | 1.61.1          | 1.72.0 |
| swig    | 1.65.0       |  4.0         | 4.0          | 3.0.12   | 3.0.12          | 3.0.12          | 4.1.1  |

`#` has known issues and upstream [recommends avoiding using this version](https://old.reddit.com/r/Julia/comments/ubdva0/what_happened_to_julia_on_ubuntu_2204_repos/i65xf8n/)

# Language Features

## C++

For more information consult [cppreference.com](https://cppreference.com)
C++ is divided into language and library features.  Generally Language features are implemented before library features.
While Clang originally led for compliance, increassingly GCC is getting newer features sooner.

### C++14

Generally C++14 language features can be used safely on all but the oldest systems (e.g. CentOS7).
With one minor exception, C++14 library features can be used on all but the oldest systems (e.g. CentOS7), but complete support requires a much newer version for GCC.

| Compiler | C++14 (language full) | C++14 (language 90%) | Missing | C++14 (library full) | C++14 (library 90%) | Missing |
|----------|-----------------------|----------------------|---------|----------------------|---------------------|---------|
| GCC/libstdc++      | 5                     | 5                    | N/A     | 10                   | 5                   | partial support for null forward iterators (N3644) |
| Clang/libc++    | 3.4                   | 3.4                  | N/A     | 3.4                  | 3.4                 | N/A          |

### C++17

Generally C++17 language features are supported on all but the oldest systems (e.g. CentOS7).
C++17 library features require very new compilers to implement fully and are not widely available on LTS systems.  The most common things to lag behind being parallel parallel algorithms, so-called special math functions used in statistics, and OS assisted features like hardware interference size.  In many cases these can be "poly filled"

| Compiler | C++17 (language full) | C++17 (language 90%) | Missing | C++17 (library full) | C++17 (library 90%) | Missing |
|----------|-----------------------|----------------------|---------|----------------------|---------------------|---------|
| GCC/libstdc++      | 7                     | 7                    | N/A     | 12                   | 9                   | "elementary string conversions" (P0067R5),          |
| Clang/libc++    | 4                     | 4                    | N/A     | No                   | 17                  | parallel algoirthms, hardware interference size, special math functions        |

### C++20

C++20 language features are not not fully implemented in even the newest compilers.  The biggest holdout is modules and features like consteval.
C++20 library features are even more sparsely implemented, but are now fully implemented in GCC 14 starting to be available in "cutting edge distros" such as Fedora.

| Compiler | C++20 (language full) | C++20 (language 90%) | Missing | C++20 (library full) | C++20 (library 90%) | Missing |
|----------|-----------------------|----------------------|---------|----------------------|---------------------|---------|
| GCC/libstdc++ | 11`*`               | 10                   | Only partial support for Modules add in 11, using enum, `operator<=>(...)=default`, consteval| 14 | 11 | `calendar`, text formatting, atomics |
| Clang/libc++ | No               | 17                   | Modules, Coroutines, Non-type template parameters| No | No | atomics, source location, `operator<=>` |

It is too early to start looking at C++23 compiler conformance.

### CMake 

Every major non-EoL distribution supports at least CMake 3.16.
If you need to do things with CUDA try to stick to CMake 3.20 or newer which has much more robust support for GPU programs which is available on all distributions except CentOS7.
3.25 is needed for cuFILE APIs which is only available on more cutting edge distros.

+ **3.10** Added `flang,`ccache` for Ninja, GoogleTest `gtest_discover_tests()`
+ **3.11** Added `add_library` without sources, `FindDoxygen`, `
+ **3.12** Added `cmake --build`, `<PackageName>_ROOT` for `find_package`, many improvements to `FindSwig`
+ **3.13** Added `cmake -S ... -B ...` to set source and build dirs, `target_link_libraries` can now be called on targets from different directories., more improvements to `Swig`
+ **3.14** Added `get_filename_component()`, `install(FILES)`/`install(DIRECTORIES)` now uses GNUInstallDirs by default, `FtechContent_MakeAvailable()`, numpy support in `FindPython`
+ **3.15** Improved Python lookups and `Python3::Module`, `$<COMPILE_LANGUAGE:>` with a single language, 
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


### Swig

Swig 3 is widely available, but Swig 4 is not -- try to avoid C++14 in swig wrapped interfaces.

+ **4.0** Added C++11 STL container support to Python, and better support for C++14 code
+ **3.0** Added C++11 language support

## Python

For widest compatibility, avoid features newer than 3.6, however when CentOS7 is EoL, 3.8 is the next lowest common denominator.

+ **3.6** Added `fstring`s, types for variables, async generators, `PYTHONMALLOC` and more.
+ **3.7** Added `breakpoint()`, `@dataclass`, `time.perf_counter_ns()` and more
+ **3.8** Added `:=` operator, position only parameters, fstring `{var=}` syntax, and more
+ **3.9** Added `|` for `dict`, `list` instead of `List` in types, and is much faster and more
+ **3.10** Added `match` pattern matching, parenthesized context managers, type `|` operator,  and more
+ **3.11** Added exception groups, tomllib, variatic generics, Self type, string literal type, is much faster and more

## Julia

Generally Julia installations will be relatively new since they are often not provided by the package manager.
There have been significant reductions in time to first plot in recent versions

+ **1.5** threading, `@ccall`
+ **1.6** various quality of life improvements
+ **1.7** property destructuring, `@atomic`, reproducible RNG, libblastrampoline
+ **1.8** const on fields in mutable structs, `SIGUSR1` profiling
+ **1.9** `:interactive` threads, `jl_adopt_thread`, `Iterators.flatmap`, Package Extensions


Hope this helps!

# Changelog

+ 2023-09-12: Created

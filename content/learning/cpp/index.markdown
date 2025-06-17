---
layout: post
title:  "Learning to Learn: C++"
date:   2018-01-12 19:00:14 -0500
tags: 
- Learning to Learn
- Programming
- C++
---

C++ is a huge language.  It has tools form imperative, functional, object-oriented, and generic paradigms.  And that leaves out the extremely fine control over things like memory allocation strategies in the standard library not generally available elsewhere. In this post, I present my learning path through C++ and offer some suggestions for learning this multi-faceted language.

# Order of Topics

This is not intended to be an exhaustive (for that would be far too long), or optimal (for that would be context dependent) listing of the topics, but rather the path that I took through the language.

## Beginning C++

Everyone needs to start somewhere, for C++ I would start here.

For this section, I would read at least Effective C++ and Effective Modern C++, and then I would skim the C++ Core Guidelines.  Together these will give you a broad basis to learn more about C++.  The other references are still useful, but maybe not as pressing.

1. Effective C++ by Scott Meyers - still the best beginners book for C++ and overviews common design concerns in C++.  While it focuses on C++98, much of this book still applies.
2. Effective STL C++ by Scott Meyers - Overview the standard template libary (set of containers and algorithms included in the standard libary) and how to use the common parts effectively.
3. More Effective C++ by Scott Meyers - Extensions to "Effective C++" but more special purpose than the base book. While it focuses on C++98, much of this book still applies.
4. Modern Effective C++ by Scott Meyers - How to effectively use new features in C++11 which radically modernized the language.
5. [C++ Core Guidelines](https://github.com/isocpp/CppCoreGuidelines/blob/master/CppCoreGuidelines.md) - How to effectively use newer parts of the language.

Here are some challenges to improve your C++ knowledge

+ Implement `std::unique_ptr` and then `std::shared_ptr` from scratch.
+ Implement `std::tuple`, `std::variant` and `std::any` from scratch.
+ Implement a function `fmap` that takes a arbitrary `Container` of with elements of type `T`, a function which may convert each `T` to a possibly different type `V` and then stores the result into an instance of that container.  Ensure your function works for `std::vector`, `std::map`, `std::optional`, and `std::tuple`.
+ Implement a function `curry` that take a function of arity `k` and an argument of the type of the first argument and returns a function of arity `k-1`.
+ Implement a function `flatten` that takes possibly arbitrarily nested sequence containers and returns all of the items fully un-nested.
{.activity}

## Standard Library

It almost goes without saying that the C++ Standard library is incredibly useful, and you should almost always start here.  Its not as complete as say Python's standard library, but its far more flexible.  I would use [cppreference.com](http://en.cppreference.com/w/) or [devdoc.io](https://devdocs.io/) to read documentation on the standard library.

I would at least know about the following core objects in the standard library ordered by how roughly important I find them.

| Name              | Use                                                                         |
| ---------------   | --------------------------------------------------------------------------- |
| `<algoritm>`      | generally useful functions                                                  |
| `std::unique_ptr`        | pointers that are the only reference to an object in memory                 |
| `std::shared_ptr`       | pointers that automatically count references                                |
| `std::format`            | a typesafe printf-like alterative to iostreams                              |
| `std::array`             | a statically allocated array with handy bindings                            |
| `std::vector`            | a dynamically resizing array                                                |
| `std::map`               | key value store, often implemented as a red-black tree                      |
| `std::unordered_map`     | key value store, often implemented as a hash table                          |
| `std::set`               | key store, often implemented as a red-black tree                            |
| `std::unordered_set`     | key store, often implemented as a hash table                                |
| Iterator Concepts/Ranges | simplifies accessing members of a collection                                |
| `std::string`            | dynamically resizing character data                                         |
| `std::span`              | a nonowning view into an existing container                                 |
| `std::string_view`       | a non-owning reference to character data                                    |
| `std::tuple`             | a generic version of a struct useful for generic programming                |
| `std::list`              | a doublely linked list                                                      |
| `std::ostream`           | output to file, string, or stdout                                           |
| `std::istream`           | input from file, string, stdin                                              |
| `std::exception`         | indicates extra-ordinary circumstances                                      |

## Build Systems and the C++ Ecosystem

Tools are important to getting actual work done while programming.  Because of the nature of C++ I find that it has and need more types of tools than you may have used in other languages.  I target this section to Linux/Unix platforms because it is what I use most often.  When I list multiple tools, you generally only need one, and I list them in order of personal preference.

For this section, read what each class of tool does; then use it as a reference when you need an instance of that kind of tool.  By no means is this a comprehensive list.

| Purpose                       | Tool                        | Why                                                      |
| ---------------               | ------------                | -------------------------------------------              |
| Backend Builder               | Ninja                       | Much faster than Make                                    |
| Backend Builder               | Make                        | Incredibly common on Unix platforms                      |
| Backend Builder               | Bear                        | Generates `compile-commands.json` files for other projects |
| Build System                  | Meson                       | Easy to use, Very fast                                   |
| Build System                  | CMake                       | More easy to use                                         |
| Build System                  | Autotools                   | Works on esoteric platforms where other choke            |
| Compile Cache                 | ccache                      | Dramatically speeds up incremental builds                |
| Distributed Builds            | icecc/icecream              | Spread builds out to a server of faster machines         |
| Code Formatting               | clang-format                | Easy, Highly customizeable, sane defaults                |
| Compilers                     | clang                       | Better Error messages, clang/llvm Ecosystem              |
| Compilers                     | GCC `g++`                   | Currently still faster, more common                      |
| IDE Integratin                | clangd                      | Clang based IDE integration shows warnings and advice    |
| Debugger                      | lldb                        | Highly programmable, handles templates well, easy to use |
| Debugger                      | gdb                         | The standard debugger, esoteric interface, [more on gdb here]({{< ref gdb.markdown >}})                |
| Debugger                      | templight                   | Specialized debugger for compile time C++ code           |
| Debugger                      | metashell                   | An older, ease of use tool built atop templight          |
| Indexing                      | Exhuberant Ctags            | The de facto tool for this job                           |
| Linting                       | clang-tidy                  | Most extensive and "correct" linter                      |
| Profiling                     | perf                        | Linux Specific, Extremely robust, easy to use            |
| Searching                     | ag/ripgrep                  | insanely fast, sane defaults, not syntactic sensitive    |
| Searching                     | clang-query                 | Slow, semantic sensitive                                 |
| Searching                     | grep                        | Common, pretty fast, not semantic sensitive              |
| Tracer                        | ltrace                      | Trace shared library calls                               |
| Tracer                        | strace                      | Trace system calls                                       |
| Tracer                        | dtrace                      | Trace/Profile kernel and elsewhere, not widely available |
| Tracer                        | llvm-xray                   | Tracer with similar design principles to dtrace, but requires recompilation and is more available |
| Leak Checking                 | Leak Sanitizer              | locate various memory leaks in programs                  |
| Undefined Behavior Checking   | Address Sanitizer           | locate various memory misuses in programs                |
| Undefined Behavior Checking   | Memory Sanitizer            | locate uninitialized reads in programs                   |
| Undefined Behavior Checking   | UndefinedBehavior Sanitizer | locate other undefined behavior in programs              |
| Undefined Behavior Checking   | Thread Sanitizer            | locate data races in programs                            |
| Package Manager               | Spack                       | Package manager focused on HPC; Similar to PIP           |
| Package Manager               | VcPkg/Connan/Wraptool       | C++ centric package managers; you miliage may very depending your usecase  |

I've recently added a learning to learn document for [CMake]({{< ref cmake.markdown >}})


You'll also eventually decide that you need/want some libraries to get useful work done.
This post would be remiss if I didn't mention a few cross cutting libraries.

+	Boost - a family of libraries that stretch the limits of what C++ can do.  Libraries from Boost often become standardized.  The best reference I have found is [The Boost C++ libraries book](https://theboostcpplibraries.com/).
+	Qt - While primarily a UI toolkit, it features a bunch of useful features.  The [online documentation](https://doc.qt.io/) is great.
+	Abseil - Google's take on a general purpose library. Provides backward compatibility for new standard concepts. The [comprehensive docs](https://abseil.io/docs/cpp.html) are sparse, but the code is well documented.

Here is a list of other libraries that I have used and would recommend.

| Purpose                 | Library            | Why                                                       |
| ---------------         | ------------       | -------------------------------------------               |
| Commandline parsing     | getopt             | Very common command line parser, very portable, not pretty|
| Unit Testing            | Google Test        | Very common testing tool, easy to use                     |
| Benchmarking            | Google Benchmark   | Very common benchmarking tool, easy to use                |
| Networking              | Protobuf/gRPC      | Networking Server/Communication framework                 |
| Networking              | Boost.ASIO         | De facto C++ native networking library                    |
| Networking              | `sys/socket.h`       | Still works, arguably simpler than ASIO                   |
| Graphs                  | Boost.Graph        | Tons of standard graph algorithms and structures          |
| Date Math               | `date.h`             | Incredibly fast, easy to use; now in the standard library |
| JSON/XML Parsing        | Boost.PropertyTree | Easy to use                                               |
| JSON Parsing        | nholman-json | Extreemly easy to use                                               |
| Distributed Programming | HPX                | A different take on HPC; I would argue easier to use      |
| Distributed Programming | Boost.MPI          | More native than standard MPI; fewer interfaces           |
| Distributed Programming | OpenMPI/MPICH            | Very flexible                                             |

+ Profile some C++ that you wrote.  What is are the bottlenecks in your code and why?
+ Port the build system of a package that you use to another build system.  What was easier or harder?
+ Configure your build system to run your tests, run `clang-format`, `clang-tidy` and `clangd`
+ Create a program trace with `ltrace`, `strace`, `llvm-xray`, and `perf` compare and contrast the outputs
+ Write a `clang-query` script to find all references to a function or of an enum value.
+ Try accelerating your build with `ccache`/`sccache` or `icecream`/`distcc`.
{.activity}

## Profiling and Speeding up C++ builds

C++ can take a long time to build especially when your code is really template heavy.
First just adopt ccache, it will dramatically speed things up for you for incremental builds.

Here is how I profile C++ builds.
First if you are using `ninja`, you can clean your build, delete your `.ninja_log` file, and run your build.
This will populate this file with a log of the build process.
Next, You can extract timings for the build using [this ninja stats script written in AWK](https://github.com/ninja-build/ninja/issues/1080#issuecomment-255436851`).
Once you've narrowed down your search to a few files, you can use clang's `-ftime-trace` to get a detailed view of what is taking so long to compile/instantiate.
See [The Blog post "time-trace: timeline / flame chart profiler for Clang"](https://aras-p.info/blog/2019/01/16/time-trace-timeline-flame-chart-profiler-for-Clang/) for more information about how to use these traces.

Once you've made as many changes to your problematic structures and functions as you can, you may further reduce build times by using "precompiled headers" and "unity builds".  Precompiled headers work by serializing the compilers internal state so that the parsing phase of C++ can be skipped.  Unity builds reduce the time required to instantiate identical headers by grouping source files for compilation.  These both are not without their drawbacks for tooling which relies on source file names such as clangd, but I am hopeful that both of these techniques will be obviated with C++20 modules while improving the tooling situation.  However, at time of writing, C++20 modules are not yet completely implemented by most major compilers.

+ use clang's `-ftime-trace` or a similar feature in another compiler to profile your build.  What could you do to accelerate the build?
{.activity}

## Object-Oriented C++

C++ has a uniquely complicated object oriented system.  Most of this is due to the use of templates for generic programming and Turing-completeness of templates.

For this section, the ordering is less important.  Several of these books apply to more than just C++, but are especially important in a language as verbose as C++.

1.	"Design Patterns Elements of Reusable Software" by the "Gang of Four" - before the pitch-forks come out: 1) the examples of patterns in this book are often in C++, 2) object-oriented programming is object-oriented programming, and it doesn't change much from language to language.  I also find that most people struggle in OO to reinvent the wheel labeled by these four in 1994.  It changed the way that I structure programs that I write.
2.	"Refactoring: Improving the Design of Existing Software" by Martin Fowler - over the course of learning C++ you'll discover that you've done horrible, terrible things.  This book while targeted at a general audience will help you fix them.  It also puts the proper focus on usable, understandable interfaces and code over the spaghetti I often see in new C++ developers.
3.	The Pimpl Idiom - Pointer to Implementation is a powerful technique to reduce compile time dependancies.  Read the set of [two articles](https://herbsutter.com/gotw/) entitled "Compilation Firewalls" by Herb Sutter.
4.	The RAII Pattern - Resource Acquisition is Initialization is a fundamental to memory and exception safe programming in C++. Read the [article about RAII](http://en.cppreference.com/w/cpp/language/raii) on CPP Reference.
5.	Modern C++ Design: Generic Programming and Design Patterns Applied by Andrei Alexandrescu - One of the few uniquely C++ Object-Oriented books I have read.  It assumes a fair bit of knowledge on generics and templates so read about it first.
6.	[Metaclasses: Thoughts on Generative C++](https://www.youtube.com/watch?v=4AfRAVcThyA) by Herb Sutter - This video highlights were object oriented C++ maybe going at time of writing in early 2018.

+ Wrap a c library that you use to use RAII.  How much more concise is the user code?
+ Try implementing generic versions of the Gang of Four patterns from "Object Oriented Design Patterns".  The flyweight pattern and factory pattern are especially rewarding to implement.
{.activity}

## Generic C++ and Templates

Generics and Templates are among C++ most powerful features.  Every C++ programmer should know the basics.

For this section, the ordering is especially important, the later items are quite advanced and build on the previous items.

1.	"C++ Templates the Complete Guide" by David Vandevoorde, Nicolai M. Josuttis, and Douglas Gregor - An easy as possible introduction to the sometimes black magic of C++ templates.
2.	Curiously Recurring Template Pattern - while discussed in the Vandevoorde book, I found the article, ["Polymorphic Clones in Modern C++"](https://www.fluentcpp.com/2017/09/08/make-polymorphic-copy-modern-cpp/) by Jonathan Boccara a much more practical example of where this may be used.
3.	"Modern C++ Design: Generic Programming and Design Patterns Applied" by Andrei Alexandrescu - I listed this in the object-oriented section, but this book opened my eyes the possibilities of C++ templates and generic programming in general.


If you can't figure out why a particular template won't compile, consider using `templight` or `metashell`.


## Functional C++

This is an evolving category of C++.  As such, I expect these to be much more in the coming years.

For this section, I would read all of the articles, they are not too long.

1.	lambda expressions - a key building block for functional programming in C++.  Read the [CPP reference documentation on lambdas](http://en.cppreference.com/w/cpp/language/lambda).
2.	`std::function` - a generic means of storing type-specified references to a function.  Read [CPP references documentation on std::function](http://en.cppreference.com/w/cpp/utility/functional)
3.	`<algorithm>` - a example of a library that makes extensive use of functional concepts. Read [CPP references documentation on \<algorithm\>](http://en.cppreference.com/w/cpp/algorithm)

## What next?

When you've read most of the above, and are still looking to improve, I use the following to stay sharp.

1.	CPPCon - the yearly C++ developers conference.  Filled with thought provoking talks and most are on YouTube.
2.	Read llvm's `libtooling`, clang's `libC++` or Google's `abseil` source code to see clear examples of well-written C++ code.
3.	Read the C++ Standard - it's not for the feint of heart.  The final version is behind a pay-wall, but the drafts are not.  Read this if you want to understand some of the deeper behaviors of C++.
4. C++Weekly - A video podcast that overviews different aspects of C++ in bite size chunks.
5. CPP Cast - An audio podcast that covers upcoming C++ news

# Suggestions to Learn the language

I have two key suggestions to learn the language:

1.	Start small: choose a subset of the language that you want to learn well.  The language is too large for most if not all people to be an expert on all parts of the language.  Somethings like parameter passing should be in everyone's subset, but the oddities of `std::atomic<>`, `vector<bool>` or the CRTP probably don't need to be.
2.	Expand your subset as needed: choose a series of small projects that motivate why you want to learn various aspects of the language.  This will help you practice and remember what you've learned.


I hope you find this useful.  Until next time!

## Change Notes

+ 2023 - improved formatting, updated tools
+ 2020 - Added section on build profiling, updated tools, library components to learn, and further resources
+ 2018 - Initial version

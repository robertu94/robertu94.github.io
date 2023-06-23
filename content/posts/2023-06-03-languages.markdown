---
layout: post
title:  "How I Work: Killer Libraries"
date:   2023-04-24
tags: 
- programming
---

Most successful langauges have a "killer" features that motivates

In my previous post, I commented on the tools that I use for software development, but I didn't talk about either the process of choosing a language or the libraries within a language that I use most frequently.  This post expands on how I work within a language and specific "killer" libraries that I use most and how they compare to facililties that I know from other languages.

# Langauges I use reguarly

## C++

C++ is probably the langauge that I use most often.  This is driven by a couple key factors: 

1. its expressive type system --  With classes, templates, template templates, concepts (and perhaps in the future meta-classes), C++'s type system is very expressive allowing encoding sophisticated abtractions concisely.  In my mind, only Haskell and its decendents with [true higher kinded types and linear types](https://serokell.io/blog/kinds-and-hkts-in-haskell) truely exceed it in its expressiveness, and only Rust comes close to matching it, [but lacking a few key notions (e.g. variadics)](https://soasis.org/posts/a-mirror-for-rust-a-plan-for-generic-compile-time-introspection-in-rust/).
2. "zero-cost" abstractions -- a key motivating principle in C++ is that using an abstraction in the [language has as close to the same overhead as what the equivelent C would have if you wrote it from scratch, and you do not pay for what you do not use](https://www.stroustrup.com/abstraction-and-machine.pdf) meaning that you can use many of C++'s abstractions with little concern about how it will effect performance.  [^1].  Rust does compete in this aspect, but few higher level langauges do.
3. C interopablility and FFI -- nearly every language that exists can interoperate with C through an FFI mechanism.  Being able to write code that exposes a C ABI that can be used in most higher level languges is a key feature.  Only Rust and C itself complete in this particular factet
4. I and many of my colleagues in HPC can at least consume C++ libraries even if they may not know how to fully write it themselves.

Here are things that I frequently reach for C++ for:

+ code that I know I want to use from many langauges
+ performance critical code that will run on a super computer
+ code that needs to access some hardware device (a GPU, a network card) to use acceleration
+ code that I share with my colleagues in HPC

A few of the libraries that I frequenly reach for:

+ MPI -- distribute jobs in parallel across a computing cluster efficently.  I've written extensively elsewhere on my usage of MPI.
+ fmt -- this might become less important when std::print get's widely implemented in standard libraries, but this vastly improves the default experience with C++ when printing and formatting messages 
+ LibPressio and various compression libraries -- many compression libraries are written in either C, C++, Cuda, SYCL, or HIP -- C++ is the lowest common denominator for working with these.
+ OpenMP -- few libraries beat the compiler extension OpenMP for a consise way to write imparitive thread parallel code -- Rust probably has a more ergonomic tasking system in tokio, but for other programming paradigms, OpenMP get the job done quickly and relatively performantly.
+ Mochi/Thallium -- a high level abstraction for writing RPC services in C++ exposing features of high perfomrance network interconnects that appear on clusters.
+ sol2 -- one of the best embedded intepreters out there.


## Rust

Rust for me is an up and coming language.  

1. I find it's dependency management and ecosystem story vastly superior to C++, but inferior to Julia. Rust frequently has dependencies that help writing and interacting with Web services and low level system aspects, but it's ecosystem especially around AI/HPC to be lacking (e.g. the MPI wrapper is in-complete, very little GP-GPU support, limited AI libraries that would complete with Tensorflow or Pytorch).
2. Rust's async runtimes and strong correctness garuntees give me confidence that I did it right the first time, and debugging tools when to fix it when I didn't. 
3. Many of my collagues don't know rust, and it takes a long time time to begin being productive with Rust.  Even knowing C++ and Haskell -- two languages on which Rust is obstensibly inspired --, it took me close a month to become even mildly productive with Rust because of its expansive number of methods on its ubiquitous data structures like Map or Vec and unique ownership model and borrow checker.

I reach for Rust when:

+ Writing small unix-like utilties or web-services that need to interact with a 3rd party service because of its robust third party ecosystem.
+ Any time I need to spawn and interact with multiple processes.
+ When I want the protection of Rust's advanced type system and production garuntees to prevent memory leaks, overflows, and other kinds of subtle hard to diagnose bugs.
+ Writing non-HPC async code.  If I need to interact with too many HPC libraries I'll fall back to C++.
+ Graphical User Interfaces -- Tauri is one of the best GUI libraries that I've encoutered in any langauge producing web powered abstractions, easy developer experience, and a small application size.

Some Libraries that I find are awesome from Rust: 

+ serde -- one of the most sophisticated and elegant serialization libraries that I've ever encoutered.
+ bindgen and cbindgen -- makes it really easy to import C code into Rust and visa-versa.
+ tauri -- I firmly believe that the web is one of the best GUI platforms from a developer experience perspective.  Tauri provides the ability to easily combine a platform native web-view with a rust backend and a web-frontend in a small bundle.  Super cool IMHO, and probably my go-to GUI library.
+ tokio -- one of the most sophisticated and complete async task libraries in a native compiled langauge
+ wasmer/wasmtime and web-sys -- While I am concerned about the implications for the openness of the web, I genuinely think WebAssembly is a extreemly promising technology not just for the web, but for sandbox-able plugin systems everywhere -- I eagerly await when I can just run 6 python interpreters in a single process each with completely independent state and clone them initialized with just a memcpy using webassembly, but we are not quite there yet.  Rust's webassembly capabilities are first class with a promising future.

## Julia

Julia is another up and coming language concieved for productive HPC.  This is influenced by:

1. It's best in class dependency management system.  Not only is it easy to package and install dependencies including native dependencies, but it is super simple to ensure that you have reproducable  envionment (C++, Python cough, cough) that don't install mulitple copies of every package on your system (Rust, Python cough, cough). It even uses a solver to properly resolve dependencies as opposed to python's indeterministic mess where which packages are installed depends in large part on the order that they were installed or uninstalled over time.
2. The sheer number of common HPC operations that are concise and easy to interface with.  Want to solve a linear system `A\b`?  Want to do elementwise multiple `A.*B`, matrix multiplcation `A*B`.  apply a function over a vector `foo.(A)`.  Learning these functions will require some doing unless you have frequenly used Matlab, but once you have its straightforward.  Interfacing with schedulers and threading are pretty simple too.
3. Several best in class packages for HPC tasks that work together because of multiple dispatch and what appears to be a set of well defined standards for several key functions.

I reach for Julia when:

+ I use it whenever I want to prototype some thing in HPC, but don't need to handle memory management yet.
+ Anything dealing with tabular data manipulatpion and plotting  

Some killer libraries in Julia: 

+ MKL.jl and OpenBLAS.jl -- best in class linear algebra primitives make it effortless to get good performance with easily readable code that closely resembles the math you are trying to implement.
+ Cuda.jl -- one of the best and most productive GPU programming frameworks that I've encoutered for the GPU.  Not only can you write kernels yourself, but high level routines pretty much just work as well.  Sure port to the native langauge if you need that last 5% performance, but Julia gets you more than half way there.
+ DataFrames.jl -- I love Pandas from Python, but for whatever reason the way that it handles joins and group operations has never felt intuitive for me.  DataFrames.jl does, and it is substantially faster in many cases.
+ Plots.jl and Makie.jl -- While I love Pandas, matplotlib is one of the most frustrating aspects of the python ecosystem.  I can almost never seem to get it to do what I want outside of the most basic of plots.  I was productively making advanced plots with Plots.jl within an hour.  Makie takes that a step further and made making interactive plots easy too.
+ Distributed -- makes it easy to distribute a Julia code across a cluster with limited direct interaction with the scheduler
+ Debugger.jl -- one of the best and most sophisticated debuggers in any interpreted langauge. It rivals GDB for its capabilities.
+ Revise.jl -- While I often use Julia as a REPL for short functions, when interating on a package Revise is the way to go.  It automates the python equivelent of `mylib = importlib.reload(mylib)` making experimentation quick and easy
+ JuMP -- JuMP is one of the best optimization libraries in any langauge. For me it is both intuitive and fast allowing me to quickly express different optimization tasks, and use different solvers and get good performance.
+ PyCall, RCall, CXX, Clang.jl, etc... -- Julia has great facilities to call functions from other programming languages from Julia making it easier to work around that say 10% of your problem that may not have a great native julia experience.

## Python

Another language that I reach for frequently, but is slowly being overcome by other languages.  I does however lead in a few areas:

1. Ease of learning.  Learning the basics of python can be done in an afternoon which is a super power not easily overstated.
2. It's incredibly vast library ecosystem.  The a reason why ProgrammingHumor jokes that python [`import`s its homework](https://www.google.com/url?sa=i&url=https%3A%2F%2Fwww.reddit.com%2Fr%2FProgrammerHumor%2Fcomments%2F6a59fw%2Fimport_essay%2F&psig=AOvVaw3VA1QDtbmqZkyns0vof43K&ust=1687174596245000&source=images&cd=vfe&ved=0CBIQ3YkBahcKEwjwxLKm3cz_AhUAAAAAHQAAAAAQBA).  This includes many best in class data science and AI packages.
3. Ubiquity -- many tools that I frequently use allow python extensions: GDB, LLDB, Ansible, Dagger, m, etc...  Python is nearly everywhere so knowing a little goes a long way.

I reach for python when:

1. I am integrating into a tool that uses it
2. I am doing machine learning or AI
3. I am doing something short that would otherwise need to be a bash script

+ pytorch/tensorflow -- the two leading AI libraries that everyone builds with.
+ mpi4py -- one of the easiest ways to write a task pool with MPI.
+ scikit-learn -- for classical machine learning, few libraries beat the breadth and API consistency of scikit-learn which makes working with it simple and productive.
+ scipy -- scipy what seems like 1000s of scientific APIs that cover many uses cases.  With it's partners in crime cupy and numpy, it is the backbone of scientific computing in python
+ argparse -- one of the best argument parsing libraries in any language.  Often imitated, seldom replicated.

# Languages that I use infrequently

## Lua

Lua's super power is that multiple independent copies of lua's interpreter can be used in a single process.  Couple that with it's relatively simple to learn syntax, and it is used for embedded scripting all over the place.

## Haskell

Haskell's super power is its incredibly sophisticated type system that allows writing extreemly elegent poems for programs.  One of the most frequently cited typeclasses is the `Monad` which while often misunderstood is the "programmable semi-colon" of the language giving extreem powers that are difficult to replicate in other lanaguges.  Most other non-functional languages fail to model concepts like Monads despite them slowly creeping into other langauges as they are better understood by the larger programming community.

## LaTeX

LaTeX's super power is typesettings.  While I use LaTeX nearly weekly, I certainly do not use its more programatic elements like functions, counters, or conditionals directly.

## Flex/Bison/Antlr

These related languages super power is writing lexers and parsers for other lanaguges.  While often a regex will do, when it won't these languages are some of the best for parsing context free grammers -- Haskell is a close second.

## C

It's super power is that it is the foundation of most modern programs.  It's simple grammer and semantics make it the portable assembly of the world.  For me C is nearly completely replaced by C++, but there are a few embedded envionments and codes where you need to use proper C (often due to the lack of a C++ compiler or a policy that forbids them).  

## Go

Go's super power is its deliberate simplicity, writing concurrent network services, fast build times, and easy to distribute binaries.  I find it's lack of a more sophisticated type system to be limiting, but I also haven't used the recently added Generics very much.  It's used extensively across the cloud native world.

## Javascript/Typescript

Javascript and Typescripts's super powers are there ubuiquity on the web platform.  I find myself frustrated by the loose language semantics, but you have to know it if you want to program client side on the web. Typescript largely replaces Javascript for me because I prefer types.

## SQL

SQL dialects like those in PostgresQL and SQlite super power is consise expressions for retrieving data from tabular databases.  I personally don't use relational databases extensively, but if you need a tranactional datastore that can survive a power outage, SQL and databases can vastly simplify things.

## bash

I use bash regularly, but at the point that I am doing anything more than something trivial, I want to switch to Python.

# Non-entries that deserve a quick mention

HTML and Markdown are not programming langauges in that they are not turing complete[^2], but these are the formatting languages of the web, and are worth some time familarizing yourself with as one of the best ways to create graphical interfaces.

# Changelog

+ 2023-06-23  created


[^1]: There are a few notable exceptions (e.g. [`<regex>`, moving a `std::unique_ptr` into a function call in hot path extreemly performance critical code where inlining can't happen](https://open-std.org/jtc1/sc22/wg21/docs/papers/2020/p1863r1.pdf)), but largely you can trust that the C++ will do higher level things efficently where possible.
[^2]: Ok, HTML [might be in the same way that powerpoint is](https://stackoverflow.com/questions/30719221/is-html-turing-complete), but please no.
---
title:    "Learning to Learn: GDB"
date:     2023-01-22 21:01
tags: 
- Learning to Learn
- Programming
- C++
- GDB
---

GDB is a powerful tool that is underutilized by most programmers that I've met.
It can tell you the state of one or more running or crashed programs, and even manipulate the memory of a running process.
It is an invaluable tool for understanding what is going wrong with your programs.

# How to get started

To get the most out of GDB you need to compile your program with debug information -- metadata that describes the program source. If writing proprietary software, be careful who gets access to debug builds of your software, it embeds the entire source code of your application into the debugging information.

If using `gcc` or `clang`, you can get debugging information by simply adding `-g` to the compilation flags and recompiling.  If using CMake, you can enable debugging information by using either `CMAKE_BUILD_TYPE=Debug` or `CMAKE_BUILD_TYPE=RelWithDebInfo` -- similar options exist for other buildsystems and compilers.

Once you have a debug build you can run your program as `gdb --args ./path/to/program example arguments`.  When the program crashes, type `bt` at the prompt, and you will get a trace of the stack at the time the program crashed,  you can then type `info locals` to get a printout of all the local variables, and you can then type `dis` to see the assembely where the program crashed.  If this was all GDB did it would be enormously helpful.

# Core functionality

Here is some of the most valuable capabilities provided by GDB:

**Printing local variables** you can print a local variable by calling `p variablename`.  You can also print simple expressions such as `p var1+var2` or `p some_func(var1)`.  You can print an array `a` like so `p a[0]@length`.  C++ objects in the standard library have pretty printers so you get sane output for things like `std::vector` by calling `p v`.

**Breakpoints** allow you stop execution of a program at a certain location.  You can call `break some_func` to break on a function name and complete names with `tab`.  For C++ which includes function overloads, you can break on specific template and overloads by `tab`bing out the specific implementation.  You can also break at file locations `break foo.cc:30`. You can run until a breakpoint is hit by running `continue` or `run` to start for the first time.  Breakpoints can also be conditional on boolean expressions `break foo.cc:30 if a==3` to break at line 30 of file `foo.cc` if and only if `a` is 3.  Lastly, you can `break` at an individual instruction which is powerful when you don't have symbols

You can also break on C++ exceptions with `catch throw` and C signals with `catch signal`.

**Running commands at breakpoints** After defining a breakpoint, you can provide a set of commands that will run after the breakpoint is hit.  For example:

```gdb
break foo.cc:30
commands
print a
contine
end
```

Would print `a` and then `continue` automatically.


**Watch points**  in addition to breaking on a function location, you can also break when a variable is modified.  When this has hardware support it is reasonably fast, but only supports a small number of bytes.  You can watch expressions such as `watch left`.

**Iterative debugging (make)** GDB allows you run `make` followed by `run` to rebuild and re-run.  If you use `cmake` you can run `!cmake --build builddir -j 8` to run builds too.

**Stepping, navigating the stack** GDB also allows you to single step and move up and down the stack with commands like `s` step into a function call, `n` go to the next program line, `ni` go to the next instruction, `up` go up the stack, `down` go down the stack, and `fin` to run until a function returns.  However, these functions exist to supplement the functions described above instead of the primary means of using GDB.

## Examining Memory

**Printing raw memory** GDB allows you to print raw memory using commands like `x/8xg to print the next 64 bytes as hex.  This can be useful to debug when something was overwritten or to debug without debug symbols.

## Source and where to find it

**Types of debuginfo** there are many kinds of debug info.  On linux systems, the most common kind is `dwarf` (what you get with `-g`).  Dwarf verbosity can be increased with GCC by using `-g3` which includes for example macro definitions in the source code.

**Stripping** in addition to compiling with debug info the `strip` command allow removing this after the fact, this allows you to produce debug information and then re attach it later without having to ship it with every copy of the binary.

**Source directory (re-pathed)** if you still have the source directory arround, you can tell GDB where to find it if it doesn't automatically.  You can provide it with `symbol-file` and if the path needs to be re-written, you can use `set substitute-path` to provide rules to re-write file paths in symbol files.

**Debuginfod**  linux distributions such as Fedora and CentOS now provide debuginfod servers which provide debug symbols for system libraries.  This can provide symbols when they aren't installed by default.

**Spack** By default, spack compiles cmake projects with `RelWithDebInfo` which provides basic debugging symbols, however the source is not installed by default.  By using spack envionments and `spack develop` it does the right thing, and you can get the source.

## Debugging Libraries

**Listing what shared libraries are loaded** sometimes you want to know what libraries where loaded. `info sharedlibrary` to get a list of them.  I used this to detect a version mismatch between uses of two different zfp libraries that were both installed.

## Multi Process/Thread

GDB provides abilities to debug multi-process and multi-thread programs as well as those that call `exec`.  The `follow-fork` and `follow-exec` commands do what you would expect.  You can use `catch fork` and `catch exec` to break on fork and exec.

**Non-stop mode and background commands**** allows non-main threads to continue to run when the focused thread is stopped. This is essential in many cases for debugging multi-threaded programs. To debug multiple threads simultaneously you will often need to run commands in the background by appending the `&` character to them.  You can re-forground a thread by usingthe `interrupt` command

# Advanced ways to start GDB

In addition to starting a command under gdb, there are two other key ways to use GDB -- core dumps and attaching to running processes.

## Core dumps 

**What is a core dump**  Core dumps are a copy of all registers and memory.  These can be taken at any time, but are created automatically when a signal such as `sigsegv` terminates a process.

**Enabling core dumps** if they are not enabled, there are a few key steps to enable them:
If you are using `systemd`, you can use `coredumpctl gdb` if you are a member of the `journald` group.
If you are not a member of `journald`, and your system uses `systemd`, you don't really have a way to enable core dumps without root privileges.
If you are not using `systemd`, the core gets written to the location specified by `kernel.core_pattern` sysctl.
Lastly, the process has to have a positive core dump limit which are defaulted by `/etc/security/limits.conf`

**Using core dumps** once you have a core file, you can debug a core file with `gdb -c ./path/to/core ./path/to/program`  You can't use breakpoints, but you can inspect local variables and final stack information.

## Connecting to a running process

Connecting GDB to a running process require privileges  -- namely `CAP_SYS_PTRACE` or `CAP_SYS_ADMIN` -- to attach to a process.  You also will need permissions (e.g., user or gropus) to access the running process.  You can connect to a running process with `gdb -p $PID /path/to/command`.

## GDB Server

Beyond basic uses of GDB to connect to remote processes, GDB can also attach to remote processes or embeded devices.  I've written a program called [`mpigdb`](https://github.com/robertu94/mpigdb) that uses this functionality to debug MPI programs.  To use this functionality start the program under `gdbserver` with a connection string and other flags you would otherwise pass to `gdb`.  Once the GDB server is started, you can connect to a GDB server with `target remote`.

This functionality is also used for embedded devices.  Lastly, GDB server functionality is also used with Valgrind's interactive memory sanitizer to get much more information about memory leaks at runtime.

# Other Advanced Features

GDB has many more advanced features, and only so many of them can be covered here.  Here are a few more of the ones that I find very useful

## GDB Scripting

Beyond just running commands at breakpoints, you can put a set of commands in to a file to be executed when GDB starts by passing `-x ./path-to-script.gdb`.

**Settings you'll want to adjust** To write effective scripts there are a few settings you will want to adjust: 

+ safe mode -- what directories GDB can load scripts from
+ pagination -- GDB pauses when pagniation happens so using it scripts often requires turning this off.
+ fork/exec/non-stop modes -- set the fork and exec modes you need to be appropriate for your application

**Setting variables** often when writing scripts requires needing variables.  GDB allows what are called convenience variables -- variables which are not stored in the program's memory.  These variables are prefixed with a `$` character and set with the `set` command.

## Python Extensions 

If GDB scripts in it's scripting language are too primitive, you can also write extension commands and pretty printers in Python.  These are simple python classes that have access to most of the capabilities of GDB.

These functionalities have been used for capabilities like debugging Python modules with C extensions.  For example when running a python program (assuming everything has been configured correctly), you can call `py-bt` to get the python strack trace in addition to the C/C++ backtrack allowing you to vastly improve your ability to debug things.

# Where to learn more?

I've just scratched the surface.  There are many more powerful features that I haven't discussed such as reverse debugging, trace points, and more.

For more information see the [GDB documentation](https://sourceware.org/gdb/onlinedocs/gdb/)

I hope this helps!

# Changelog

+ 2023-01-25 Created this document.


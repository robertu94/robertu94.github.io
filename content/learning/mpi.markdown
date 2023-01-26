---
title:    "Learning to Learn: MPI"
date:     2023-01-22 21:01
tags: 
- Learning to Learn
- Programming
- C++
- MPI
---

MPI is the de-facto standard way to write distributed programs that run on super computers.
Many have tried to replace it, but so far none of them have succeeded.
Learning to use it successfully, will enable you to write powerful distributed programs.

# Order of Topics

MPI has a minimal powerful and useful core, but really tries to completely own it's space.

I strongly reccommend reading "Using MPI" by Gropp et al. which opened my eyes to the power of MPI
I would focus on learning MPI in the following order:

+ `MPI_Init` and `MPI_Finalize`
+ The [6 basic routines](#beginning-mpi)
+ Collectives
+ Communicators to preform collectives on subsets of ranks
+ Asynchronous MPI
+ MPI's Advanced features (inter-communicators, groups, error handling, info structures, dynamic processes, File IO, One-Sided Communication)
+ Research features included in major MPI distributions such as Fault Tolerant MPI (i.e. [ULFM](https://docs.open-mpi.org/en/main/features/ulfm.html))


# Beginning MPI -- Important Functions

You really can do an amazing amount with just 6 routines:

+ `MPI_Init` -- startup MPI
+ `MPI_Finalize` -- shutdown MPI
+ `MPI_Send` -- send a message from a source to a target
+ `MPI_Receive` -- receive a message from a source at the target
+ `MPI_Comm_rank` -- ask for the ID of a process
+ `MPI_Comm_size` -- ask for the total number of processes

With these functions you have all of the primitives that you need to write distributed programs.
However very quickly, you will want to have groups of processes work together to solve common problems.  For this MPI provides collectives:

+ `MPI_Bcast` -- send from one rank to all ranks
+ `MPI_Reduce` -- compute a reduction from all ranks send the result to one rank
+ `MPI_AllReduce` -- compute a reduction from all ranks send the result to all ranks
+ `MPI_Gather` -- send data from all ranks combine them for one rank
+ `MPI_Scatter` -- split and send data from one rank to all ranks

You also will quickly want to compute collectives subsets of processes.  For this, `MPI_Comm_split` and `MPI_Comm_split_type`.

However to scale, you frequently need non-blocking versions of these calls.
Many routines have an `I` variant which is non-blocking such as `MPI_Ibcast` for `MPI_Bcast`.
However MPI provides much, much more capabilities allowing collectives and failures to be isolated to a subset o processes.
I recommend you learn these as you need them.


# Important Tools / 3rd party libraries

**Debugging**  Debugging MPI programs can be tricky without appropriate tools.  There are specialized debuggers such as `TotalView` and `DDD` which are propriety and very expensive.  I've written a simply version built around standard MPI features and new versions of GDB called [`mpigdb`](https://github.com/robertu94/mpigdb)

**Boost.MPI** MPI 2 introduced a standard C++ api.  Almost no-one used it, and it was removed in MPI 3.  If you want a C++ API, either use the C api (which is quite serviceable), or use the Boost.MPI version.   I've also written a lighter weight version called [libdistributed](https://github.com/robertu94/libdistributed) provides basic features `send`, `recv`, and `bcast` for C++ types as well as a work-queue.

**TAU (profiler)**  If you need to profile an MPI application and you don't want to use the provided `PMPI` features directly, you can use [`tau`](https://www.cs.uoregon.edu/research/tau/home.php).  Tau will profile most of the events that you care about, and can be a good place to start.

**Math libraries (PETSc/ScaLAPACK/FFTw/etc)**  If you want to do things that look like linear algrebra or a fourier transform, don't write them yourself, use one of the standard libraries that allow distributing things using MPI.

**Graph Libraries** If you need to do graph algorithms, Boost's graph library is MPI aware and can be distributed across the network.

**Storage Libraries (parallel HDF5)**  If you need to write data, HDF5 does a number of optimizations to write data from a large number of nodes much more efficiently than a naïve use of POSIX APIs can be.  You can also use `mpiio` instread of hdf5 if you want to avoid a dependency, but `hdf5` frequently does what you want, and is much more full featured.

# Major Concepts Worth Knowing About

A few other major topics that may be deceptively simple, but actually provide substantial depth:

**Tags** `MPI_Send` and `MPI_Recv` allow for a tag object.  If multiple sends or receives are in flight simultaneously, they can be matched based on the tag, or you can use `MPI_ANY_TAG` to recieve any tag.  This allows for a work queue style workflow which a lead process checks for any of a collection of worker processes has completed some task.

**MPI Communicators** in addition to serving as the basis for collectives, MPI communicators provide a powerful set of abstractions for working with subsets of processes, customizing error handling, and segregating messages sent to different nodes.  A messages sent via `MPI_Send` and `MPI_Recv` only actually matches if the communicator and tag also match.  This allows libraries to segregate their own communication from the communication from the user of the library.

**MPI+Threads** by default, MPI does not enable thread safety unless started with `MPI_Init_thread` and the library was compiled with thread support.  If you have a multi-threaded program, you probably want this flag enabled.

**Nonblocking MPI**  Nonblocking MPI uses `MPI_Request` objects.  You can check them with `MPI_Test` or block waiting for them `MPI_Wait`.  If `MPI_Test` and `MPI_Wait` will de-allocate the `MPI_Request` object if the indicate that the request was completed.  If you need this to be idempotent, you need to maintain boolean to track if this call ever returned success for a particular call.  There also calls for `MPI_Waitany` `MPI_Waitsome` and `MPI_waitall` to wait for groups of requests at the same time.

**MPI Datatypes** allow you to send data structures that have irregular shapes (i.e. arrays, structs, etc...) in a single `MPI_Send` or `MPI_Recv` calls which can dramatically simplify code that uses these.

**One-sided MPI** allows you to preform one-sided RDMA operations including one-sided atomic operations can offer substantial performance increases over two sided MPI operations.

# What's Next

+ Read "Using Advanced MPI" by Gropp et al. is a great next step after reading "Using MPI"
+ William "Bill" Gropp also has an excelent set of lecture slides on MPI that aren't too hard to find online.
+ Read the Standard -- as far as programming system standards go, this document is remarkably easy to read.

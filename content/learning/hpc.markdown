---
layout: post
title:  "Learning to Learn: High Performance Computing"
date:   2019-08-25 08:00:00 -0500
tags: 
- Learning to Learn
- HPC
---

There's at least for me an inherent coolness to be able to say that I can run code on a super computer.
However, there is often a gap between the kind of programming that you learned in your introductory classes, and what kind of code runs well on a computing cluster.
In this post, I try to provide an introduction to high performance computing, and some of the differences between it and personal computing.

What is a super computer really? Modern super computers are not really a single physical machine, but instead a collection of commodity machines that are networked together with specialized software that helps them work together to solve problems larger than any individual machine could solve on its own. 

Why run something on a super computer? Super computers can be used when the problem is either too large to solve or too large to solve in a reasonable amount of time. 

# Key First Steps:

+ Read the user guide for your specific cluster, it will highlight important details that are specific to your cluster such as hardware details and configuration as well as preferred and available software. Every super computer has unique hardware that should be accounted for when choosing what software to run because it can have dramatic performance impacts. 
+ Learn a language with good tooling for HPC, supported on your cluster. Writing software for one machine is hard; writing software for a team of machines with diverse and specialized hardware is harder. Using a language that has mature libraries to support different use cases will make things easier. 
  + [C/C++](learning/cpp.html)
  + [Python](learning/python.html)
  + Fortran, [Julia]({{< ref  2022-12-15-three-neat-things-with-julia.markdown >}}), and Scala (for big data) are also popular
+ Learn how to schedule batch jobs and run interactively on your cluster. On super computers, you often need to request time to run a task rather than just running it. The software that allows you to request time is called the scheduler. Often it provides facilities to coordinate between jobs, monitor their progress, and to notify you when they are finished. 
+ Profile first to understand the bottlenecks of your applications. Learn how to user a profiling tool available on your system.

>

+ Profile an application that you use on a super computing cluster.  What parts of it are slow?  How efficiently are you using the hardware capabilities of the machine?  What libraries or tools exist that could enable you to speed up and better utilize the machine?
{.activity}

# Common Frameworks and Their Alternatives

It is desire-able to be able to write one set of code and have that code have optimal performance on every machine that you might want to run it on. To this end, library and framework authors attempt to write libraries that will help make this task easier.
However truly performance portable code is largely an illusion. Each machine will have different hardware and configuration options that will be best tuned for certain kinds of workloads. In order to take best advantage of these systems, it's important to understand a variety of frameworks and methods to best tune code for a machine. 

## Inter-Node Parallelism -- MPI (Message Passing Interface)

In HPC, The Message Passing Interface is the de-facto lower level programming framework for coordination between nodes. It provides relatively low level primitives that can be built upon to coordinate work amongst the cluster. Because of its importance in HPC, I plan to write a separate learning to learn on it because of its importance to HPC.  However for a deep dive to learn more about MPI consider reading the books "Using MPI" and "Using Advanced MPI" to get started followed by the MPI standards specifications for details as needed.   You can find more on [MPI here]({{< ref mpi.markdown >}})

However since MPI is fairly low level, it has encouraged the development of higher level libraries to support applications real world usage. Two of the most notable are PETSc and HDF5. The former provides matrix math facilities and the latter IO. 

However there are some notable alternatives to MPI include global memory systems such as upc++ and RPC systems such as Thallium or gRPC. 

## Intra-Node Parallelism -- OpenMP (Open Multi Processing)

Historically, MPI has been most used for distributed memory parallelism, and other systems are used for unified memory parallelism because unified memory systems can make simplifying assumptions that can improve performance. One of the most prevalent unified memory systems is OpenMP. 

OpenMP enables multi-threading and heterogeneous programming within a single node. Unlike MPI which is a library, OpenMP is best thought of a series of compiler extensions for C, C++, and Fortran compilers that parallelize code marked with special directives. Recently OpenMP gained concepts for heterogeneous computing as well allowing the programming of GPUs and other specialized accelerators with minimal syntax.

Other alternatives for OpenMP could be parallel algorithms in your language's standard library, vendor specific offloading tools like Cuda, hip, or OneAPI, the SYCL extensions to C++, as well as user level threading libraries like argobots. 


## Parallel IO -- HDF5 (Hierarchical Data Format)

For large programs that leverage super computers, IO can become a performance bottleneck. To alleviate this, supercomputers have developed parallel IO libraries to write to the distributed file systems. Often these are built atop MPI's file IO standard. 

For simple file formats, it is possible to use MPI-IO directly, however in practice it is generally better to just use HDF5. HDF5 provides a set of routines to read and write large self-describing volumes of data. It's documentation is fragmented and dense, but there is tons of straight forward example code that is easy to use. HDF5 also provides high level facilities for operating on tables of data or other specialized structures.

Some alternatives to HDF5 include Mochi and DAOS which both take a more "micro-services" based approach to IO. 

## Math Libraries

One of the most common operations performed on super computers are matrix math. This is because of both the ubiquity of these operations in scientific codes, but also the relative intensity of these operations. There are a few performance optimized libraries that have are commonly used to support these operations. 

For dense matrix algebra there are BLAS and LAPACK. The former provides primitives for vector and matrix math. The later tools for solving matrix systems. Later distributed memory parallel implementations of BLAS and LAPACK were developed called PBLAS and ScaLAPACK respectfully. Lastly there are recent developments in libraries like MAGMA which further extend these classic libraries for heterogeneous programming. Each system will have its own set of these libraries to best optimize these routines. 

FFTW is a library for performing fast Fourier transforms. It provides both a distributed and unified memory versions. While many libraries may beat FFTW in raw performance for a little while, it doesn't tend to remain that way for long. One thing to be aware of is that FFTW is GPL licensed, which has implications for how you publish software that uses it. As a result, there have been re-implementations of its interface in libraries like MKL from Intel that have other licenses. Read these licenses carefully before you use these pieces of software. 

SuiteSparse is a collection of primitives and solvers for sparse matrices and vectors. While many HPC problems are dense, a growing number of them are modeled as sparse. SuiteSparse provides similar routines to BLAS and LAPACK but for sparse problems. 

You probably don't use these directly, instead use a higher level library like Eigen or PETSc if you need distributed computing.

## Patterns for Parallel Computing

As mentioned above, often software needs to be refactored to achieve optimal performance. Here are a list of patterns that are commonly used to adapt software for parallel and distributed environments. 

| pattern                     | problem                                                                                                                       |
|-----------------------------|-------------------------------------------------------------------------------------------------------------------------------|
| map/embarrassingly parallel | perform many completely independent problems                                                                                  |
| reduce                      | combine many associative operations                                                                                           |
| repository                  | need common configuration shared across nodes                                                                                 |
| divide and conquer          | problems that can be partitioned into independent sub problems                                                                |
| pipeline                    | a series of steps that need to be preformed in order, but otherwise are independent                                           |
| grid/stencil problems       | calculations on a grid of values                                                                                              |
| caching                     | store the results of expensive calculations/load/stores in faster storage for reuse                                           |
| pooling                     | allocate a large chunk of resources (memory, disk, nodes, etc...) to avoid repeatedly preforming an expensive allocation      |
| fast-path optimization      | write code to skip expensive checks/verification in the typical case                                                          |
| reader/writer partitioning  | separate tasks into readers and writers to enable fast, parallel reads when a write isn't occurring                            |
| journaling                  | write messages to an append only queue then commit them to storage periodically to avoid random writes                        |
| flyweight                   | reuse a single copy of an immutable data structure  that is frequently used                                                   |
| strategy                    | provide multiple implementation of an operation and choose between them at runtime to minimize runtime on available resources |
| auto-tuning                 | run an experiment or series of experiments to choose between the fastest implementation                                       |
| batching                    | rather than doing many small operations, group them to do more work at once                                                   |
| speculative execution       | compute a result before it is needed in anticipation of needing it, and discarding it if unused                               |
| local execution             | move computation to data to increase locality                                                                                 |
| delayed synchronization     | synchronize less frequently to avoid expensive communication at the possible cost of some accuracy                             |
| check-point restart         | mitigate the possibility of failure by periodically taking, and allowing restarting from a saved copy of the program state    |
| replica                     | preform operations multiple times or store multiple copies in memory to enable restarts in case of failure                    |
| erasure codes               | a less memory/disk intensive form of replica which can recompute the state provided a certain number of "copies" survive      |
| heart-beat/gossip protocols | actively or passively periodically check the state of remote nodes to ensure that they are still functioning                  |
| bulkhead                    | design the application to anticipate failure of one or more components and recover gracefully                                 |
| exponential back-off        | avoid contention by backing off a progressively increasing amount of time on each timeout                                     |
| reconfiguration             | upon failure, reconfigure the application to run in a reduced mode                                                            |
| reconstruction              | upon failure, partially rebuild the application using new resources                                                           |
| inexact algorithms          | using approximate algorithms/functions which are faster, but less precise                                                     |
| proxy-model                 | use an statistical model which emulates a full computation                                                                                                                     |
| compression                 | use a compressed representation of the state to save disk/memory/bandwidth                                                                                                                                                                         |
| lossy compression           | use an compressed representation of the approximate state to save even more memory/disk/bandwidth                                                                                                                                                  |
| leader election             | select one or more process dynamically to preform synchronized operations                                                     |
| atomic instructions         | use specialized instructions to avoid explicit locking                                                                        |
| futures                     | represents a handle to a async computation that can be waited upon and possibly canceled                                      |
| queuing                     | place work to be done on a queue to be evaluated when resources are available                                                 |

+ Which if any of these patterns can you use to accelerate your program?
{.activity}

# Reproduce-ability

Broadly speaking there are two approaches to reproducible HPC programs. Use a specialized package management system that creates as close to a hermetic build as possible like Spack, or use a container runtime environment like singularity with all of your dependencies self contained. These approaches can be complementary and systems like Spack can build containers. 

+ What can you do to make your results more reproducible?
{.activity}

# What next?

If you are looking for more resources here is where I would get started:

1. Read the specific documentation for the libraries and software that you intend to use.
2. Academic conferences like Super Computing, International Super Computing, the International Parallel and Distributed Processing Symposium are major venues where technologies related to HPC are announced and demonstrated.  Papers from these conferences are available online from IEEE or the ACM depending on the year.


## Suggestions to learn HPC

To learn HPC I have a few recommendations:

1. Build your own virtual or Raspberry Pi cluster.  Building a cluster will give you a greater appreciation of how the underlying software that drives HPC works.  You can either build it in a set of 3-4 VMs or Raspberry Pi or similar single board computer.  Many commercial cloud providers also have easy cluster setup systems.
2. Port a code that you have to run on a HPC cluster.  This will enable you to get some hands on experience with the software and technologies involved.

## Change Notes

+ 2023 Added remarks on profiling
+ 2021 Initial Version

---
draft: true
---

# Template

## Intent 
short what does this do
## Motivation
why is intent useful
## Applicability
limitations and strengths regarding when you should use this
## Structure
diagram
## Participants/Elements 
what can be tweaked
## Collaboration with other patterns
## Code Examples
## Consequences of using pattern
pros and cons
## Implementation considerations



\--------------------------------------------------------------------------------

## Scan/Reduce

+ differences between scans and reductions  
+ tree-based methods, 2 pass reduction   
+ decoupled lookback leveraging task monotonisity on Cuda with atomic operations   
+ scans and reductions with NPU/TPUs via linear algebra leveraging the matrix vector unit  
+ Reduce by key \-- uses a fused scan with a reduce  
+ implementation with linear algebra 

## Sort

Radix sort  
Merge sort


# Advanced Parallel Patterns and Libraries

## Linear Algebra and BLAS

+ Vector vector (BLAS level 1\)  
+ Matrix Vector (BLAS level 2\)  
+ Matrix Matrix (BLAS level 3\)  
+ SparseBLAS  
+ GraphBLAS

## Pipelines

+ DAGs  
+ fault recovery  
+ data flow architectures

## Grid/stencil problems

+ Computation ordering and systolic arrays to maximize parallelism and cache utilization compared to dag scheduling methods can use lightweight message information

# Strategy

Techniques in this category, determine what computation is performed to achieve acceleration.

## Auto-Tuning

Auto tuning as a strategy, dispatches multiple versions of a routine to achieve a desired performance characteristic. The method for deciding which version to employ is determined using either a set of statically defined rules, or empirical observation of the system. Examples of auto-tuning include setting appropriate tile sizes for matrix multiplication.

## Hardware Specialization

Hardware specialization is a special case of strategy, where the specialization is made to utilize some accelerated or more efficient operation on certain hardware.  For example, utilizing a hardware atomic, a specialized accelerator, a persistent memory device, or specialized instructions that may not be available on all systems.
## Optimize Common Operations (e.g. Reader/Writer, Journaling)

If one operation is substantially more common than another, one can optimize that operation in favor of another. For example, in journaling file systems optimize the right performance by making the write operations a simple append to a continuous log, but read operations require comparatively more effort to locate the desired information in the log.
## Fast-Path Optimization

Fastpass optimization is a technique that prioritizes the performance of a common or compute-intensive case over the general case. For example, in the libpressio compression Library, algorithms are optimized for 1D through 4D, and a generic lower-performance implementation is provided for higher dimensional data sets. 

This differs from optimizing common operations in that fast-path optimizations do not trade lower performance/utilization on one task to gain performance on another task.
## Speculative Execution

Speculative execution goes beyond fast path optimization to speculate that a fast path will be taken, and if it is not taken the work that was done in advance to prepare for the fast path will be discarded. prior to the  Specter and meltdown CPU vulnerabilities, this was a common means of accelerating CPU tasks in processor architecture. However, it is not limited to architecture and maybe implemented in any generic tasking workflow. 

## Operator Fusion and Reordering
Combines multiple operations into a single operation possibly reordering them to achieve higher performance (e.g. a SQL query planner)


# Load Balancing

## Move Execution

The move execution pattern relocates execution within a distributed system. One reason to relocate execution is to impact the locality of the data. A classic example includes the Hadoop “map-reduce” implementation which launched calculations on the data nodes where the data was housed. 

Alternatively, the execution could be moved to a remote note to enable parallelism, to improve the balance of resources across the collection of nodes, or for administrative reasons such as taking a note off-line also known as coordinating

## Batching

Batching speaks less to the location of the data, but how many requests are processed at the same time batching requests may allow for a greater overlap of communication or operations training throughput for latency
## Work Stealing

Work stealing is a type of load balancing that attempts to load across the collection of servers cooperatively. Spreading occurs through the relocation of certain parts of the task queue from one node to another node. It is most useful when there is a high degree of task imbalance.

## Exponential Back-off

Exponential back-off is an autonomous load-balancing mechanism. It detects load monitoring request response times when these times exceed a threshold, the system weights a progressively longer and longer period before requesting additional resources. Often this is combined with randomized task weights to spread a thundering, herd problem.


# Resource Management

Techniques in the realm of resource management, determine how to utilize available resources. These techniques balance the competing objectives of the system through the scheduling of available resources.

## Cooperative scheduling

Lower switching overheads by using a lighter-weight process abstraction that doesn't support preemption.

+ green threads
+ polling

## Task Preemption and Priority

Methods for responding preemptively to high-priority tasks by marking certain resources for high-priority tasks

+ Interrupts 
+ Demand queues

## Backfill

Backfill is a technique that instead of allowing resources to remain idol schedules, often smaller or lower priority tasks. Backfill scheduling can be either preemptive or non-preemptive in the case of preemptive backfill. Low-priority tasks can be evicted when a higher-priority task arrives. In the case of non-preemptive backfill, tasks are scheduled according to the resource request made by each task. A task can only then be scheduled if there is available capacity remaining.

+ Use underutilized resources for another task

## Pooling

Use fixed-sized allocations to reduce allocation overhead and external fragmentation or to avoid “startup” and “shutdown” costs

## Specialized Scheduling Techniques

Additional but more niche scheduling techniques (e.g. realtime scheduling with earliest deadline first)

# Resilience Patterns

When computing at scale failures and errors happen. Techniques in the resilience patterns section help mitigate various forms of failures that occur.

## Checkpoint restart

Checkpoint restart is the foundational resilience pattern. It operates by capturing a consistent state of the system periodically throughout the execution of the program. Checkpoint can be either synchronous or asynchronous concerning the execution of the program. Synchronous checkpoint blocks further computation until the capturing of the checkpoint is a complete asynchronous checkpoint, on the other hand, allows computation to continue at the cost of possible interference between the checkpointing system in the primary code. Check-pointing libraries can be either application level or system level. Application level checks when libraries cooperate with the application to capture a minimal checkpoint. System-level checks occur without the application's cooperation to broaden the checkpoint system's applicability.  key factors in the design of checkpoint systems is the so-called checkpoint interval. The checkpoint interval decides how frequently check flinch shall be made. In the case of Poisson distributed mean time between failure, the young daily checkpoint formula describes an optimal trade-off for a linear work stream. However, in real systems poisson distributed failures and linear work sequences are not always present, requiring other checkpoint approaches. For more details, see the paper Beyond Young Daily by Yves Robert et al.


## Replica

Replicas are another strategy to protect the execution of programs. When using replicas multiple copies of the same program are executed concurrently, the program results are compared, and a voting scheme determines whether or not failure has occurred.

## Heart-beat

A key challenge in the design of distributed systems is determining when a failure has occurred. Heartbeat protocols detect no failure by periodically, indicating the liveness of a node to a set of interested parties at a periodic interval. When a node has not heard a heartbeat notification within some multiple of the expected interval, the node is presumed dead.

## Gossip protocols

Gossip protocols are a technique that communicates information about the state of the system alongside other requests that are being fulfilled as part of the normal operation of the system. This can be used to communicate the liveness or perceived death of a node in the system.

## Bulkhead

The bulkhead design pattern describes how failures propagate in the distributed system. Specifically, failures on one side of the bulkhead are not allowed to propagate to the other side of the bulkhead.

## Reconfiguration

Reconfiguration is an approach to fault tolerance that runs a different version of a calculation in the event of failure. For example, a different leader may be elected, or a different parameterization of the problem may run.

## Reconstruction

Reconstruction is an approach to default tolerance that runs the same calculation on a different set of hardware or a subset of the original hardware that the calculation was performed upon

## Erasure codes

Erase your codes are in optimization upon data replication that enables fewer copies to be stored in exchange for some computation required to perform a restoration

## Merkle trees


Merkel trees are a pattern that ensures the integrity of subsets of a state by hashing, each subset, and the combination of the ashes of all subsets. The system can then verify the hash of the hole by checking only the root hash.
## Algorithm Based Fault Tolerance

Some operations are inherently resilient to faults and could be corrected or detected with some additional calculations (e.g. computing a checksum during matrix multiplication).


# Approximation

Approximation is a class of patterns, where a precise version of a computation is used instead of a precise version to obtain some other operational characteristic, such as improved runtime or reduced memory consumption. 

## Inexact Algorithms

This class pattern utilizes lower precision calculations in place of precision alternatives, examples include precision, arithmetic, reduced order, approximations, such as for the signer cosign, or polynomial time approximations NP-hard or inky complete problems that produce an answer that is some multiple of the correct answer. A key aspect of these algorithms is that they provide a rigorous bound on the inaccuracy of the approach.
## Proxy-model

Proxy models like in-exact algorithms use a lower precision version of a calculation, but unlike in-exact algorithms do not provide a rigorous bound on the correctness of the solution


## Dimension/Feature Reduction

Dimension reduction algorithms such as principal component analysis, represent a problem in a smaller state space through means of a projection.
## Sampling

Sampling is an intuitive approach that reduces the number of observations rather than the complexity of each observation.

## Lossless Compression

Lossless compression techniques reduce the footprint of data, but not the number of observations nor the number of features in each observation.  While it reduces the footprint and can be restored lossless, it has limited effectiveness for some datatypes because of fundamental limits on compress-ability called Shannon’s entropy.
## Lossy Compression

Lossy compression can make data much smaller than lossless compression in some exchange for some amount of loss that occurs during the compression operation.  Modern lossy compression routines provide a-priori bounds on the amount of loss to the data or to certain derived quantities.


# Synchronization Patterns

The CAP theorem controls here. The CAP theorem states that you can have only two of consistency availability and partition tolerance in any distributed system. Consistency means you can have all nodes give the same response for a given request. Availability means that all nodes must be capable of performing any request at any time. Partition Tolerance means the properties of consistency and availability still hold regardless of what communication pathways are broken.

Consistency can be relaxed Using eventually consistent algorithms such as conflict-free replicated data types and delayed synchronization.

Availability can be relaxed when strict consistency is required. often a subset of operations will be supported under the condition of partitions. for example reads maybe allowed but writes are not.

Partition tolerance can be relaxed if an algorithm is capable of overcoming a split brain scenario  where different subsets of the cluster have different Notions of the current state of the system. 

## atomic instructions

Atomic instructions provide a mechanism for conducting certain sets of operations as a transaction meaning either all of them occur or none of them occur. one of the most common forms of an atomic instruction include the comparison and swap operation. They can be used to implement distributed operations.
## Strong Consensus and Leader election
Leader election is a mechanism to determine which nodes are capable of performing certain critical operations. it is a special case of consensus algorithms such as paxos or raft. essentially, consensus is reached on a leader, and once a leader is elected it can stipulate the definitive form of State until it is retired and another leader is elected
## Futures

Futures are an example of the continuation monad. they provide a concise way to express synchronous computations that are run in the background, or concurrently with foreground applications.   many programming languages Provide support for futures as a language primitive using syntax similar to async await.
## Queuing/Actor Model

An alternative approach to futures is the so-called actor model or queue model. in an actor model, the distributed system is composed of a collection of actors that are capable of processing tasks in a queue. Synchronization is then performed by the passing of messages onto these queues.

## Two Stage Commit

Two-stage commit is a strategy for committing large segments of information to a distributed Ledger such that it is all added or not added atomically. in two-stage commit, the system first accepts proposed changes in a series of messages, 
## Delayed Synchronization

In some algorithms, synchronization can be delayed or skipped in exchange from some loss in quality of the synchronized result.
## Conflict-free Replicated Data Types

A specific application of a mathematical data structure called a monoid that supports associative operations.  Because the conflicts are handled in an associative way, any ordering of operations will result in the same ultimate data structure making them a powerful way to implement distributed computations in an eventually consistent way.






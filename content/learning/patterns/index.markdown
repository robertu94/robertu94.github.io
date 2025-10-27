---
layout: post
title:  "Learning to Learn: Software Patterns"
date:   2018-01-12 19:00:14 -0500
tags: 
- Learning to Learn
- Programming
---

# Foundation Parallel Operations

Fundamental to developing high-performance software is having an understanding of the basics of parallel architecture.

## Enumeration and Grouping

### Intent

Label each processing element in a group with a distinct label and describe new groups in a way that is consistent across nodes.

### Motivation

Enumeration and grouping is foundational to other parallel primitives such as Send/Recv, which need these labels to identify sources and targets.  It is often also used as a primitive in larger algorithms to statically partition work between a collection of processing elements.  Lastly, programs might create multiple distinct enumerations for various subtasks to facilitate collectives on subsets of processes better, or create new groups dynamically to via collaboration with the scheduler to expand the quantity of resources for a task.  This also applies to GPU device programming (e.g. threadId.x in CUDA).

### Applicability

* As a fundamental primitive, it's applicable to almost all use cases  
* For systems with rapidly changing group members, other work partitioning schemes and addressing schemes that hide this aspect from the user may be more important

### Structure


{{< mermaid >}}
classDiagram
    class User:::user
    class ResourceManager:::optional  {
        +group(): Group
    }
    class Scheduler:::optional  {
        +allocate(r: Request): Lease
        +deallocate(l: Lease)
    }
    class Element:::required
    class Group:::required {
        +id(Element: e): int
        +size(): int
    }
    Group "1..n" <-- "1" Element: Belongs To
    ResourceManager --> Group: Creates
    ResourceManager <-- Scheduler: Provisions
    Scheduler "1" --> "*" Element: Allocates/Deallocates
    User "1" --> "1" Scheduler: Requests

    classDef required fill:#f9f,stroke:#333,stroke-width:4px;
    classDef optional fill:#bbf,stroke:#333,stroke-width:4px;
    classDef user fill:#eea,stroke:#333,stroke-width:4px;
{{< /mermaid >}}

### Participants/Elements

* Elements - an individual processing element
* Groups – collections of processing elements  
* (optional) resource manager – a leader (see leader election) that decides identity within a group  
* (optional) scheduler – used to allocate/deallocate additional elements

### Collaboration with other patterns

* A fundamental concept used in most other operations  
* Dynamic group management often requires interaction with the scheduler and thus resource management patterns  
* Dynamic group management allows fault tolerance on collectives and thus resilience patterns

### Code Examples

MPI Comm examples using Sessions, which interact with the resource manager to create processes aligned with hardware resources

```cxx  
#include <mpi.h>  
#include <stdio.h>  
#include <stdlib.h>  
#include <string>

int main(int argc, char *argv[]) {

    // Initialize an MPI session  
    MPI_Session session;  
    int err = MPI_Session_init(MPI_INFO_NULL, MPI_ERRORS_RETURN, &session);  
    if (err != MPI_SUCCESS) {  
        fprintf(stderr, "MPI_Session_init failedn");  
        MPI_Abort(MPI_COMM_WORLD, err);  
    }

    //query the runtime what processes sets exist (implementation defined)  
    int num_p_sets;  
    MPI_Session_get_num_psets(session, MPI_INFO_NULL, &num_p_sets);  
    std::string pset_name;  
    for(int i = 0; i < num_p_sets; ++i) {  
        int psetlen = 0;  
        MPI_Session_get_nth_pset(session, MPI_INFO_NULL, i, &psetlen, NULL);  
        pset_name.resize(psetlen - 1, '0');  
        MPI_Session_get_nth_pset(session, MPI_INFO_NULL, i, &psetlen, pset_name.data());

        //match the specified process set  
        if (pset_name == argv[1]) break;  
    }

    //groups on their own do not facilitate communication, they just enumerate processes  
    MPI_Group world_group;  
    if (MPI_Group_from_session_pset(session, pset_name.c_str(), &world_group) != MPI_SUCCESS) {  
        return 1;  
    }

    int grank, gsize;  
    MPI_Group_rank(world_group, &grank);  
    MPI_Group_size(world_group, &gsize);

    printf("Hello from grank %d out of %dn", grank, gsize);

    //create a communicator to actually communicate between the processes  
    MPI_Comm comm;  
    if (MPI_Comm_create_from_group(world_group, "world_set", MPI_INFO_NULL, MPI_ERRORS_RETURN, &comm) != MPI_SUCCESS) {  
        return 1;  
    }

    int rank, size;  
    MPI_Comm_rank(comm, &rank);  
    MPI_Comm_size(comm, &size);

    printf("Hello from rank %d out of %dn", rank, size);

    // Cleanup  
    MPI_Comm_free(&comm);  
    MPI_Group_free(&world_group);  
    MPI_Session_finalize(&session);  
    return 0;  
}  
```

MPI Comm example using COMM\_WORLD

```cxx
#include <mpi.h>

int main(int argc, char* argv[]) {
    MPI_Init(&argc, &argv);

    int rank, size;  
    MPI_Comm_rank(MPI_COMM_WORLD, &rank);  
    MPI_Comm_size(MPI_COMM_WORLD, &size);

    printf("Hello from rank %d out of %dn", rank, size);

    MPI_Finalize();
}

```

CUDA kernel launch examples

```cpp
#include <random>
#include <vector>

__global__ void vadd(float* a, float* b, float* c, size_t n) {
    //enumerates a block
    i = threadIdx.x + blockIdx.x * blockDim.x;

    //because the number of tasks may not be evenly divisible by what is
    //efficent on the hardware you almost always get a more threads than tasks
    if (i < n) {
        c[i] = b[i] + a[i];
    }
}
int main(){
    constexpr size_t dims = 1024;

    //performs
    std::vector<float> h_a(dims);
    std::vector<float> h_b(dims);
    std::uniform_real_distribution<float> dist;
    std::mt19937 gen;
    auto rng = []{ return dist(gen); };
    std::generate(std::begin(h_a), std::end(h_a), rng);
    std::generate(std::begin(h_b), std::end(h_b), rng);

    float *d_a,*d_b,*d_c;
    cudaMalloc(&d_a, sizeof(float)*dims);
    cudaMalloc(&d_b, sizeof(float)*dims);
    cudaMalloc(&d_c, sizeof(float)*dims);

    cudaMemcpy(d_a, h_a.data(), dims*sizeof(float), cudaMemcpyHostToDevice);
    cudaMemcpy(d_b, h_b.data(), dims*sizeof(float), cudaMemcpyHostToDevice);

    size_t threads_per_block = 256;
    size_t blocks_per_grid = (dims+threads_per_block-1)/threads_per_block;

    //requests creation of block_per_grid*threads_per_block threads
    //threads_per_block has a max limit based on hardware width
    <<<blocks_per_grid, threads_per_block>>>vadd(d_a, d_b, d_c, dims);

    cudaMemcpy(h_c.data(), d_c, dims*sizeof(float), cudaMemcpyDeviceToHost);
    cudaFree(d_a);
    cudaFree(d_b);
    cudaFree(d_c);
}

```

// etcd

```
```

### Concequences (pros and cons of use)

* Use of groups may simplify programming by allowing collective operations to be used as opposed to independent operations  
* The creation of strongly consistent groups is a syncronization point which inroduces overhead especially for extreemly large number of processing elements.

### Implementation considerations

* Static vs Dynamic number of processing elements – this addresses whether or not groups can be created or destroyed at runtime by introducing or removing processing elements.  The creating groups proses an operational challenge if the number of nodes exceeds the current resource request because the overall system may not have sufficent resources to satisfy the request.  In which case the scheduler accepts immediately, either refueses, or accepts with a delay.  Refusing could result in the task having insufficent resources, delaying often causes waiting while resources are allocated.  The case where the new request is fits within an existing allocation is much more operatoinally simple, but requires additional resources be allocated by scheduler but for some of the job might be unused.  
* Static vs Dynamic membership of groups – this addresses whether or not an existing groups membership can change.  Allowing changes of group membership allows for more better handling of failures and more dynamic right-sizing of resource needs, but increases complexity to handle cases where a node is deallocated from or added to a group.  
* Strict consistency vs Weak consistency – can group members have an inconsistent view of group membership?  Weak consistency can enable lower overhead (from less syncronization), more scalablity (from less syncronization) and greater fault tolerance (because groups can remain if one of its members die).  Strong consistency of group membership is dramatically easier to reason about.

### Known uses

* MPI\_Communicators are strongly consistent  
  * MPI\_Comm\_size, MPI\_Comm\_rank – get the number of processing elements in a group and the id of a specific processing element  
  * MPI\_Comm\_split – allows creating subgroups from existing resources  
  * MPI\_Comm\_spawn – allows creating new groups on additional resources  
  * MPI\_Comm\_connect – allows connecting two groups  
* etcd, zookeeper, mochi-ssg – implements weakly consistent dynamic group management  
* CUDA – strongly consistent, uses dynamic group creation, but not dynamic membership changes 

## Send/Recv

### Intent

Fundmental primiative describing point to point communication between two processing elements.

### Motivation

Without some mechanism to communicate between physically distinct hardware, parallel and distributed software does not exist.  It important to note this even applies withing a single node on systems featuring multiple Non Uniform Memory Access (NUMA) domains which violate traditional Von Neuman assumptions around system architecture by having some memory that is “lower latency” to computation on certain processing elements than others.  It can seldonly be completely avoided.

### Applicability

* As a fundemental primitive, it is applicable to almost all use cases  
* Some communication patterns can be more consisely expressed using higher level primatives which can then be then be specialized for the underlying hardware capabilties.  In such cases, higher level collective operations can be used.  
* Some uses cases (e.g. consistent and partition tolerant systems like traditional relational database managment systems like PostgresQL, some aspects of filesystems) require frequent syncronization to maintain consistency.  In such systems, avoiding distributing the workload requires fewer expensive syncronizations that occur over the network and may improve performance.

### Structure

### Participants/Elements

* Message – what is being sent  
* Sender – who is communicating information  
* Reciever – who is obtaining information  
* Switch(es)/Interconnect – intermediate network devices/nodes that transpartently conveys a message

### Collaboration with other patterns

* Scatter/Gather/Broadcast – depending on hardware, these higher level collectives are implemented in terms of a point-to-point communication method.  
* Hardware specialization – these routines are so primiative that often one or more aspect of them are implemented in dedicated hardware  
* Pooling – often underlying resources use for sending and recieving messages are pooled  
* Syncronization and Resilance patterns – use these as a primitive

### Code Example(s)

// example from an RPC based system

// example from MPI

```cxx

```

// example from MPI One-sided

// example from MPI partitioned send

// example from a GASNet based approach

### Concequences

* Communication incurs overhead which is often orders of magnitude slower than simple computations.  
* Communication enables greater access to resources via horizontal scaling (more nodes) which is often cheaper than vertical scaling (more powerful nodes) past a certain scale due to the difficulty of implicity maintaining coherence on progressively larger systems.  
* Communication introduces complexity of managing distributed state to the application  
* Communication enables fault recovery and resilance by reducing the probability of a single point of failiure from a single node failure.

### Implementation considerations

* Implicit (Global Address Space) vs Explicit (e.g. Message Passing).  There are two fundemental models of communication – explicit models where the programmer specifically describes which processes send and which recieve – this describes UNIX sockets as well as HPC oriented solutions such as MPI.  There is however an alternative with global addressing systems which instead make communication implict much like the communication between threads.  At scale, there tends to be a tradeoff between performance (explicit) and productivity (implicit), but depending on the usage pattern, this performance overhead can be either minimal or catestrophic.  
* Message Sizes – The performance of small messages are dominated by the latency to send any data at all.  Large messages are dominated by the bandwidth of the system.  Often there is a tradeoff between latency and throughput.  Frequenly a small amount of throughput can be sacrificed for much lower latency.  Frequenly, these choices are made by your networking library, but may be tunable for a specific code.  
* Addressing – How do you identify a specific sender or reciever pair?  Systems such as MPI use an integer value \`rank\` to identify a specific processing element within a communicator (group of processing elements).  For recieving operations, MPI allows recieving from any process in a group which enables implementing constructs like work queues.  MPI further specifies this with TAGs which allow multiple distinct messages to be sent concurrently – e.g. to impement a cancelation channel or to indicate an exception channel.  
* Routing – how is the route between nodes determined.  Often this is the responsability of the networking library or hardware.  Some network topologies (e.g. fat-trees, toruses) have specialized routing algorithms that minimize contention or ensure low latency.  Other topologies feature slow links (e.g. wide area networks) that may need to be deprioritized.  Lastly, some networking libraries and hardware allow for “multi-path” communication which enables higher throughput at the cost of additional adminstrative and implementation complexity.  
* Asyncronous vs Syncronous – are the routines to initate sends blocking with respect to the caller, or not?  Non-blocking routines enable the overlapping of computation with communication, but at the cost of increased complexity.  Modern hardware is natively asyncronous with respect to the CPU.  
* Zero Copy – are copies require to send messages?  In UNIX sockets, the user provided buffer supplied to send() is copied to user space to kernel space before the routine returns.  Then the kernel copies from the kernel based buffer to the network interface where the message is transmitted to the recieving node which then copies the data from its network interface to a kernel buffer, before it is finally copied to the user memory.  In zero copy networking, the user writes directly to the sends network interface’s buffer and the recieving node’s network interface writes directly to user memory bypassing copies to the kernel.  This potentially has security trade-offs if implemented poorly, but can dramtically improve send/recv latency.  
* OS Bypass – In UNIX sockets, a system call write()/read() is required to initiate a read or write on the network which incurs overhad from context switching as well as potential overhead from context switching to other tasks which are prefered along system call boundries.  
* “Queueing” and SENDRECV – even when using zero copy transfers, it is possible that the network interface may not have suffcent capacity to accomidate all read/write requests and a request will need to queued.  To prevent deadlocks from queuing in large pair-wise exchanges, “buffered sends” or “asyncronous sends and recieves” which pre-allocate the network interface memory or alternatively combined “sendrecv” can be used which atomically swap buffers can be used to avoid deadlock.  Queuing can be mangaed by the network interface or or coordinated by the switchs/routers on the network (in the case of infiniband).  
* Partitioned Operations and Device Initiated Sends – currently some devices (e.g. GPUs) have limited ability to initate network operations on their own, and require another device (e.g. the CPU or the network interface) to initate the request.  Some fabrics and devices implment so-called partiioned sends which divide the declaration that a send should occur from the declaration that memory is ready to send, and from the actual send of the data.  In such cases, the network interface enques a task to initate the sends/recieves on the behalf of the device using low level routines that allow the device to wait for a condition (e.g cuStreamWaitValue32 which issues a callback when a particular memory address is set to a particular value).  This is frequently combined with atomic additions or bitwise operations to indicate that an operation is ready.  At time of writing this requires close collaboration between the network and device (e.g. HPE Slingshot 11 and Nvidia CUDA).  A special case of this exists for sends (writes) and recvs (reads) from the filesystem under branding like GPUDirect Storage.  
* Reliability – does the protocol (e.g. tcp/udp, infiniband RC/UC) ensure that messages are actually delievered.  Reliable messages are easier to reason about, but are less robust to heavy contention or packet loss scenarios where latency can spike as messages are retransmitted to ensure delivery.  Unreliable messages in contrast have no delivery garuntees, but if the application tolerates some information loss (e.g. video transmission, gossip messages), unreliable messages can be used to greatly reduce latency.  
* Error Handling – how are errors identified and reported to the user?  Some errors can be definitivley return (e.g. ENOPERM for disallowed operations), but others can be harder to detect especially in the context of node failures which can be difficult to distinguish from heavy contention or insufficent progress.  See heart beat and gossip protocols for more information.  
* One Sided vs Two Sided – are both sides of the communication involved with the communication or is just one?  Two sided operations are classic in explicit message passing systems.  One sided operations utilize a hardware feature known as remote direct memory access (RDMA) to allow remote hosts to issues commands to read or write to user space memory on a remote host and are present in both global address based systems as well as modern explicit message passing libraries.  In the case of two sided operations, the sender and reciever are syncroized when the message is communicated, but one-sided operations, some other mechanism is used to explicity syncronize calls to lower overhead (e.g. communication epochs).  
* Progress – how does the system decide when to actually perform operations.  Some system require explicit progress to give control about when operations are performed to provide lower latency.  Others implicity handle progress either specific calls that advance progress as collateral to other operations, or with a dedicated progress thread which can be simplier to use.  
* Atomisity – what operations can be performed on remote memory?  At its simplist, read/writes are allowed, but more modern systems allow certain atomic operations such as arithmatic, bitwise, and certian other operations to be preformed in such a way that either the entire operation is performed or none of the operation is performed allowing lower overhead and not requring return messages.  Hardware frequently limits this to a single 64 bit instruction having atomic operations.  If an array of such values are “atomically” operated on, each value is independently treated as atomic but the ordering of operations to each value may be arbitarily interleaved.  
* Security – in HPC systems, security of communication is often handled at the network level and communication initation stage  rather than at the node level while non-HPC system often implement security at the node level assuming the network is untrusted.  This allows less overhead enforcing access controls, but requires a trusted adminstrative domain.

### Known uses

* Lower Level  
  * TCP/UDP/ROCE over IP  
  * IO\_URing  
  * Infiniband  
  * Machine Specific HPC Fabrics Slingshot/ToFuD  
* Higher Level  
  * MPI Implementations of Send/Recv, MPI\_Win one sided functions   
  * RPC systems (e.g. Mochi, GRPC)  
  * GASNet based Languages (e.g. Chapel, upc++)  
  * Device \<-\> Host in GPU Programing (e.g. OpenMP Target, CUDA, SYCL, etc…)

## Collectives

### Intent

A collective operations that send data from one node to collection of other nodes either in whole (broadcast) or in part (scatter) of others or visa versa to send from many nodes to one node (gather) or all nodes (allgather), or from all nodes to all other nodes (all to all).

### Motivation

These are foundational communication patterns for group of nodes.  This might be used to spread work out to a group of nodes, inform them of a request, wait for them (or some subset of them) to complete a request.

### Applicability

* As a fundemental primitive, it is applicable to almost all use cases  
* Collectives are often “implicit” in global address space schemes so may not be explicity invoked by the user making them less relevent in this context.  
* The larger the group of processes collectively performing some task, the greater the overhead can be from a straggler who takes a disproportionately long time to complete the collective operation.

### Structure


### Participants/Elements

* (optional) a root process \[for broadcast, gather, scatter\]  
* A group of processing elements

### Collaboration with other patterns

* As a fundemental primative, this patterns is used to build many large patterns

### Code Example

### Concequences

* Collective simplify code and allow performance portability accross diverse architectures.  
* Collectives can become a point of failure in large jobs when one or more nodes fail during a collective

### Implementation considerations

* Syncronous vs Asyncronous – asyncronous collectives allow computation or other communication to occur during a collective operation, but increase the complexity of the underlying implementation  
* Non-contigious collectives – collectives may support sending different quantties of information during a collective (e.g. gatherv/scatterv)  
* Cancelation – can an operation be canceled after it has been started, if so is the cancelation premptive or collaborative?  Allowing cancelation makes it easier to implement patterns such as “racing” queries where you want the first and then not wasting resources on the remaining operation  
* Toleration of stagglers/failures – does the collective require all nodes to complete the operation, or mearly some predetermined fraction of them?  
* Topology awareness – especially in the context of wide area network such as on the Eagle supercomputer which spans multiple datacenters and some links between nodes are dramatically slower than others.  In such as system, these algorithms should be specialized to avoid sending more communication over the slow link than is strictly nessisary either communication batching strategies or ordering of pairwise steps in the collective.  
* Choice of algorithms  
  * Ring – process i sends to process i+1%n  
    * Torrus – a special case of ring algorithms where the ring is aligned to the torus network topology  
  * Butterfly– has a consistent more consistent runtime per process in the collective  
  * Bionomial Tree – minimizes volumes of communication and maximizes throughput by communicating in k-nary tree  
  * Linear – offers lower latency in some cases (e.g. small numbers of processes sending small messages)

### Known uses

* MPI Collectives  
* NCCL (network)/CUB(device) collectives for CUDA

## Map

### Intent

Applies the “same” function to a collection of tasks in parallel

###  Motivation

This is a foundational programming pattern.  It can be used in parallel or serial cases whenever "the same" independent operation needs to be performed on a collection of elements.

###  Applicability

* As a fundamental primitive, it is applicable to many use cases
* This pattern is still applicable for use cases where different operations (including no-ops) need to be performed on non-overlapping subsets of elements provided that the decision of which operation should be performed can be determined only by considering each element individually.
* Not appropriate for cases where tasks need to synchronize/communicate with each other, instead consider reductions or scans

###  Structure

###  Participants/Elements

* Workers – who performs the tasks  
* Tasks – the actual work to be performed
* (optional) Scheduler – decides which tasks process each work element

###  Collaboration with other patterns

* Load balancing – load balancing patterns can be used to deal with imbalanced workloads which require inconsistent quantities of resources per task  
* Resource Management  – how tasks are assigned to resources can dramatically effect performance
* Hardware specialization – common and foundational operations are often implemented in hardware (e.g. vector addition, matrix matrix multiply for small matrices) in a paradigm referred to as Single Instruction Multiple Data (SIMD).  GPUs implement Single Instruction Multiple Threads (SIMT) which allows for an additional level of hierarchy.
+ Fault Tolerance - how errors and cancellation are handled has implications for fault tolerance of parallel maps especially checkpointing, bulkheads, replicas and algorithm based fault tolerance.

###  Code Example

###  Consequences

* Tasks can be distributed over processing elements in parallel allowing for less wallclock execution time.  
* Starting/tearing down parallel resources has some overhead, or may introduce less regular data access patterns resulting in less efficent data access than the serial case.

###  Implementation considerations

* Serial vs parallel -- are the tasks performed in serial or in parallel.  Performing tasks in serial may be optimal when the overhead for creating the workers or scheduling the tasks exceeds the benefits from parallel execution.
* Task heterogenitity vs homogenity -- heterogeneous tasks often feature greater load imbalance than homogeneous tasks and may be harder to schedule on certain kinds of hardware platforms.  For example on GPUs, there is both a limit on the number of heterogenous tasks that can execute concurrently (which can be lower than on CPUs), but even for homogenous workflows also when there is divergence in the workflow (e.g. some tasks take different branches of an "if" statement), GPUs may pause execution on for threads while other threads in the same team take a different branch resulting in dramatically increase execution time.
* Static vs dynamic task assignment  -- once a task is assigned to a worker, can the task be re-assigned to another worker?  Cluster wide HPC schedulers (e.g. Slurm, PBS) tend to perform static task assignment which is much easier to implement.  Node local, tasking runtime, and cloud oriented schedulers (e.g. Linux, OpenMP, Kubernetes) may perform dynamic task assignment to better balance load, to facilitate system maintenance, or to perform efficient packing of jobs.  Dynamic scheduling often requires careful attention to task migration, but is easier in the case of "Map" tasks which are independent.  See work stealing for additional discussion.
+ Collective vs Non-Collective -- do all workers obtain the results of the other workers after the map is completed (i.e. Collective) or not (i.e. non-Collective)?  A non-collective implementation can be made to be collective by adding a collective operation (e.g. gather or all-gather) after the map; collective implementations can be easier to reason about.  See collectives.
+ Returning `void` -- sometimes the user does not care about the return value of the function only that the side effects of the function occur eventually (e.g. Providing a progress notification to the user, or reporting some metrics to metrics collection endpoint).  These are sometimes called "fire-and-forget" functions or "detached" functions.  In practice, I find the true use cases for this to be rare; you almost always want to know if something failed unexpectedly and be able to handle that condition or to ensure that something eventually completes (e.g. asynchronous checkpointing).  Instead prefer queuing style systems where error conditions and progress can be handled in a structured way.
+ Preserving the ordering to tasks -- if tasks are provided in the order from 1..N, are they returned in the same order or some other order.  Returning tasks in a different order (e.g. In the order of completion) may reduce synchronization between tasks, but introduces synchronization where the elements are returned as tasks compete to be the next value to return.
+ lazy vs eager -- are the tasks launched as soon as the function and returned synchronously (e.g. `Vector<T>`) is called or are they called later either all  at once (e.g. `Future<Vector<T>>`) or batch by batch (e.g. `Generator<T>` or `Generator<Vector<T>>`).  Lazy execution can be more resource efficient if not all tasks are required or can reduce the operating memory overhead by not materializing the entire structure in memory.
* Static or dynamic queue contents  -- are all tasks known at the beginning of the execution of the first task, or are tasks added to the queue as the workflow progresses?  Static queue contents may allow for more detailed and optimal scheduling decisions than in the dynamic case.  If tasks are added to the queue, how are they scheduled relative to existing tasks?  See resource management for additional discussion.
* Cancellation -- At which points can tasks be canceled?  Popular choices include never unless the program is killed (e.g. CUDA), prior to task execution, at dedicated points during task execution (e.g. Green threads, pthread\_cancel with deferred cancellation, see cooperative scheduling), or at any point (e.g. Linux threads, most HPC schedulers see task preemption).  Allowing cancellation may requires additional synchronization or overhead compared to not allowing cancelation, but allows tasks that are no longer needed to be discarded.
* Error Handling -- what happens if an error occurs during the execution of a task?  Does the entire program attempt to terminate (e.g. `MPI_ERRORS_FATAL`), does the task complete with an exception, does the task complete and the user is required to implement error handling?  Like cancellation, this allows tasks to end earlier than expected, but unlike cancellation may effect fault tolerance
* scheduling -- discussed in more detail for scans and reduces which introduces task dependencies.  Even in the case of maps, scheduling decisions can be made based on expected/allocated execution time, resource utilization and availability (e.g. requires a GPU but none is currently available), status (e.g. waiting for a file read), fairness (e.g. how to ensure the long tasks continue to make forward progress), priority, and in the case of real-time systems deadlines.

###  Known uses

+ the *Map* in *MapReduce* in Hadoop
+ `#pragma omp parallel for` in OpenMP
+ `Kokkos::parallel_for` in Kokkos
+ Job Arrays in OpenPBS/PBSPro/Slurm
+ Kubernetes Jobs with multiple completions

## Scan/Reduce

### Intent 

This pattern combines multiple elements of a data structure into a single cumulative result.  The result can represent a single element (a reduction), or a collection of elements (a scan).

### Motivation

Reductions and scans are foundational parallel programming patterns.  They can be used in parallel and serial use cases where multiple element of a data structure need to be combined to produce a result.

### Applicability

* As a fundamental primitive, it is applicable to almost all use cases where you need to combine the values of multiple elements of a data structure such as `filter` operations and `aggregations` (e.g. count, mean, etc...)
* While it is possible to implement `map` using a scan, this will likely introduce undue synchronization overhead.

### Structure


### Participants/Elements 

+ tasks -- what work needs to be performed
    + "the zero/identity element" -- what is the initial state of the reduction, or alternatively how is the inital state created?
    + the binary operation -- how are elements of the data structure combined?  Is the operation associative, or effectful?
+ workers -- where the work of the reduction preformed
+ scheduler -- how tasks are mapped to workers

### Collaboration with other patterns

Many of the same collaborations as Map.  This list focuses on distinctive of Reduces/Scans.

* Operator Fusion and Reordering -- the ordering of reductions compared to other operations can have substantial effects on the amount of work to be performed
* Load balancing – reduces and scans are inherently less load balanced than map (i.e. the root of the reduction has more work to do than the leaves) so is a more important consideration.
* Hardware specialization – common and foundational operations are often implemented in hardware (e.g. Vector dot product) in a paradigm referred to as Single Instruction Multiple Data (SIMD).  GPUs implement hierarchical primitives (e.g. Shuffles, warp/group primitives) that can also accelerate these functions.
* Synchronization patterns -- unlike map, synchronization is inherent to reductions/scans so careful attention to these patterns is critical for performance and correctness.
+ Fault Tolerance -- Unlike map, there are more meaningful intermediate states that can potentially be checkpointed, and more complexity in recovering from failures because the loss of a node necessitates additional communication with the other nodes that would otherwise need to cooperate in a reduction/scan.


### Code Examples

### Consequences of using pattern

+ parallel reductions can require less wallclock time by distributing the work to be performed over multiple processing elements.
+ more-so than map, reductions/scans require synchronizations that introduce overhead when conducted in parallel.

### Implementation considerations

+ What kind of iterator model exists for the collection?
    + For random access and continuious iterators parallelism is possible because multiple processors can "jump" to a portion of the collection for processing. 
    + For input, output, forward, and bidirectional iterators limited parallelism is possible without first converting to a random or continuous iterator because the inherently serial nature of advancing iterators one by one prohibits parallelism.
+ Are you producing a single result or a collection of results?
    + scans (`scanl operation init collection :: Foldable f => (b -> a -> b) -> b -> f a -> f b` ) produce a collection of elements instead of a single element for example a prefix sum, a maximum value in each subtree, or a shortest path from one node to any node in a graph.
    + reductions (`foldl operation init collection :: Foldable f => (b -> a -> b) -> b -> f a -> b`) produce a single element such as a maximum, the final state of a state machine over a series of events, the depth of a tree, or the size of the largest connected component.
    + There are also variants of these operations such as "Reduce by Key" which uses a fused scan with a reduce to process a group of elements with the same key together.
    + There are other variants of reductions that take additional arguments to the reduction function (e.g. `paramorphisms` that pass the original data structure in addition to the reduction state, `histomorphisms` which can look at multiple preceding states)  For more information refer to the paper ["Fantastic Morphisms and Where to Find Them A Guide to Recursion Schemes"](https://yangzhixuan.github.io/pdf/fantastic-morphisms.pdf).
+ What are the properties of the binary operation?
    + magmas vs semi-groups and associativity.  A magma is just a binary operation that peserves type.  A semi-group godes further and requires that the operation be associative.  Associativity is a key property in that it allows for operations to be grouped in an arbitary order which enables parallelism by allowing operations to be scattered to multiple parallel processing elements and performed in an arbitary order.  Sometimes, it is possible to conduct these operations as if they are a true semi-group, but are not.  For example floating point operations are not truely associative, but are approximately associative.  By relaxing the constraint and allowing associtaivity, the computation can be performed faster, but at the cost of some accuracy.  Further more a semi-group can be an Abelian semi-group further allowing communativity -- or reordering of operations.  This enables a further set of performance improvements by allowing more arbitary work stealing which is useful in the case of load imbalanced problems.
    + semi-groups vs monoids  and the "zero"/"identity" element.  A monoid is just a semi-group that has a "zero element" also known as an "identity element".  The identity element combined using the binary operation with any other element produces the other element unchanged.  For addtion, this is `0`; for multication this is `1`.  Monoids offer an advantage over semigroups for parallelism because multiple elements can be "lifted" into the monoid using the identity element allowing for multiple starting positions instead of a single element.  In contrast, for semi-groups, the user needs to provide an explicit base case of the reduction or scan.
    + monoids vs monads and effectful reductions.  Monads are "programmable semi-colons" -- they describe how to take the value in a "wrapped" value and return a new "wrapped" value -- for example optionals and futures are monads.  There are more abstact notions of monads such as `IO` in haskell that model side effects of calling functions (e.g. printing a value).  If the order of the effects "matters" for the correctness of your program, this will limit parallelism.  Just as you can sometimes "cheat" and ignore the ordering imposed by magmas you can do the same for monads (e.g. if two prints are out of order, that can be confusing for the debugging/monitoring of a program, but likely not impactful for correctness).
+ The optimal implementation of a scan/reduce is effected by the programming model
    + tree-based methods, 2 pass reduction.  This pattern maps nicely onto many hardware types and is the principle way to implement distributed reductions.  In this pattern, each iteration elements are paired up and passed to the binary function, and then the process is repeated taking the outputs of the pairs are passed to the as the inputs to the next iteration until only a single element remains.  Some optimizations may implement this as a multi-level reduction the width of the nodes changes depending on their depth in the tree.  To implement a scan using this design, a "upward" pass that computes the reduction of each subtree is computed, and then a "downward" pass computes the actual prefix values.
    + decoupled lookback -- On CUDA and GPUs, scans can be efficiently implemented by leveraging the aspect of the hardware that threads are scheduled in a montonistically increasing manner. This means that the $i^{th}$ thread knows that at least threads $i-1$ have begun to execute (even if they haven't finished).  Decoupled lookback combines this with hardware atomic operations to mark reductions as pending, prefix available , or aggregate available.  In the case that fewer than $2^62$ elements are processed, the atomic store of the status can be stored with the aggregate into a single 64 bit integer register atomically.
    + For NPU and TPUs which feature hardware instructions for matrix-vector multiplication scans and reductions for certain datatypes can be implemented by multiplication by a specially designed matrix.  For a scan, this is the upper triagular matrix of ones.  For a reduction, it is the matrix where the matrix with the top row contains only ones.
+ error handling and cancellation -- unlike maps, reductions and scans have more complex error handling because the operations that fail may be intermediate results from the scan or reduction instead of from the raw elements.  In this case, it may be desirable for a reduction to accumulate the errors either in an aabitary order (see magmas vs semigroups) or in the order of the original elements.  This also has implications for recovering from failures as resuming from a failure in the middle of a reduction requires additional effort and careful syncroinzation during recovery.  See the discussion on checkpointing of directed acyclic graphs for additional discussion.

### Known Uses

+ MPI features Scan and Reduce collectives
+ OpenMP features Reduce and now Scan intents for loops.
+ Cuda's CUB (now part of NCCL) impement device (and collective) reductions respectively
+ In MapReduce/Hadoop, the Reducer implements a reduce by key.
+ Functional programming languages such as Haskell have the most robust notions of reductions (called fold) and scans.

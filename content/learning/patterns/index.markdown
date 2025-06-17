---
layout: post
title:  "Learning to Learn: Software Patterns"
date:   2018-01-12 19:00:14 -0500
tags: 
- Learning to Learn
- Programming
---

# **Foundation Parallel Operations**

Fundamental to developing high-performance software is having an understanding of the basics of parallel architecture.

## **Enumeration and Grouping**

### **Intent**

Label each processing element in a group with a distinct label and describe new groups in a way that is consistent across nodes.

### **Motivation**

Enumeration and grouping is foundational to other parallel primitives such as Send/Recv, which need these labels to identify sources and targets.  It is often also used as a primitive in larger algorithms to statically partition work between a collection of processing elements.  Lastly, programs might create multiple distinct enumerations for various subtasks to facilitate collectives on subsets of processes better, or create new groups dynamically to via collaboration with the scheduler to expand the quantity of resources for a task.  This also applies to GPU device programming (e.g. threadId.x in CUDA).

### **Applicability**

* As a fundamental primitive, it's applicable to almost all use cases  
* For systems with rapidly changing group members, other work partitioning schemes and addressing schemes that hide this aspect from the user may be more important

### **Structure**

### **Participants/Elements**

* Groups – collections of processing elements  
* (optional) resource manager – a leader (see leader election) that decides identity within a group  
* (optional) scheduler – used to allocate/deallocate additional resources

### **Collaboration with other patterns**

* A fundamental concept used in most other operations  
* Dynamic group management often requires interaction with the scheduler and thus resource management patterns  
* Dynamic group management allows fault tolerance on collectives and thus resilience patterns

### **Code Examples**

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

```cuda
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

### **Concequences (pros and cons of use)**

* Use of groups may simplify programming by allowing collective operations to be used as opposed to independent operations  
* The creation of strongly consistent groups is a syncronization point which inroduces overhead especially for extreemly large number of processing elements.

### **Implementation considerations**

* Static vs Dynamic number of processing elements – this addresses whether or not groups can be created or destroyed at runtime by introducing or removing processing elements.  The creating groups proses an operational challenge if the number of nodes exceeds the current resource request because the overall system may not have sufficent resources to satisfy the request.  In which case the scheduler accepts immediately, either refueses, or accepts with a delay.  Refusing could result in the task having insufficent resources, delaying often causes waiting while resources are allocated.  The case where the new request is fits within an existing allocation is much more operatoinally simple, but requires additional resources be allocated by scheduler but for some of the job might be unused.  
* Static vs Dynamic membership of groups – this addresses whether or not an existing groups membership can change.  Allowing changes of group membership allows for more better handling of failures and more dynamic right-sizing of resource needs, but increases complexity to handle cases where a node is deallocated from or added to a group.  
* Strict consistency vs Weak consistency – can group members have an inconsistent view of group membership?  Weak consistency can enable lower overhead (from less syncronization), more scalablity (from less syncronization) and greater fault tolerance (because groups can remain if one of its members die).  Strong consistency of group membership is dramatically easier to reason about.

### **Known uses**

* MPI\_Communicators are strongly consistent  
  * MPI\_Comm\_size, MPI\_Comm\_rank – get the number of processing elements in a group and the id of a specific processing element  
  * MPI\_Comm\_split – allows creating subgroups from existing resources  
  * MPI\_Comm\_spawn – allows creating new groups on additional resources  
  * MPI\_Comm\_connect – allows connecting two groups  
* etcd, zookeeper, mochi-ssg – implements weakly consistent dynamic group management  
* CUDA – strongly consistent, uses dynamic group creation, but not dynamic membership changes 

## **Send/Recv**

### **Intent**

Fundmental primiative describing point to point communication between two processing elements.

### **Motivation**

Without some mechanism to communicate between physically distinct hardware, parallel and distributed software does not exist.  It important to note this even applies withing a single node on systems featuring multiple Non Uniform Memory Access (NUMA) domains which violate traditional Von Neuman assumptions around system architecture by having some memory that is “lower latency” to computation on certain processing elements than others.  It can seldonly be completely avoided.

### **Applicability**

* As a fundemental primitive, it is applicable to almost all use cases  
* Some communication patterns can be more consisely expressed using higher level primatives which can then be then be specialized for the underlying hardware capabilties.  In such cases, higher level collective operations can be used.  
* Some uses cases (e.g. consistent and partition tolerant systems like traditional relational database managment systems like PostgresQL, some aspects of filesystems) require frequent syncronization to maintain consistency.  In such systems, avoiding distributing the workload requires fewer expensive syncronizations that occur over the network and may improve performance.

### **Structure**

### **Participants/Elements**

* Message – what is being sent  
* Sender – who is communicating information  
* Reciever – who is obtaining information  
* Switch(es)/Interconnect – intermediate network devices/nodes that transpartently conveys a message

### **Collaboration with other patterns**

* Scatter/Gather/Broadcast – depending on hardware, these higher level collectives are implemented in terms of a point-to-point communication method.  
* Hardware specialization – these routines are so primiative that often one or more aspect of them are implemented in dedicated hardware  
* Pooling – often underlying resources use for sending and recieving messages are pooled  
* Syncronization and Resilance patterns – use these as a primitive

### **Code Example(s)**

// example from an RPC based system

// example from MPI

```cxx

```

// example from MPI One-sided

// example from MPI partitioned send

// example from a GASNet based approach

### **Concequences**

* Communication incurs overhead which is often orders of magnitude slower than simple computations.  
* Communication enables greater access to resources via horizontal scaling (more nodes) which is often cheaper than vertical scaling (more powerful nodes) past a certain scale due to the difficulty of implicity maintaining coherence on progressively larger systems.  
* Communication introduces complexity of managing distributed state to the application  
* Communication enables fault recovery and resilance by reducing the probability of a single point of failiure from a single node failure.

### **Implementation considerations**

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

### **Known uses**

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

## **Collectives**

### **Intent**

A collective operations that send data from one node to collection of other nodes either in whole (broadcast) or in part (scatter) of others or visa versa to send from many nodes to one node (gather) or all nodes (allgather), or from all nodes to all other nodes (all to all).

### **Motivation**

These are foundational communication patterns for group of nodes.  This might be used to spread work out to a group of nodes, inform them of a request, wait for them (or some subset of them) to complete a request.

### **Applicability**

* As a fundemental primitive, it is applicable to almost all use cases  
* Collectives are often “implicit” in global address space schemes so may not be explicity invoked by the user making them less relevent in this context.  
* The larger the group of processes collectively performing some task, the greater the overhead can be from a straggler who takes a disproportionately long time to complete the collective operation.

### **Structure**

### **Participants/Elements**

* (optional) a root process \[for broadcast, gather, scatter\]  
* A group of processing elements

### **Collaboration with other patterns**

* As a fundemental primative, this patterns is used to build many large patterns

### **Code Example**

### **Concequences**

* Collective simplify code and allow performance portability accross diverse architectures.  
* Collectives can become a point of failure in large jobs when one or more nodes fail during a collective

### **Implementation considerations**

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

### **Known uses**

* MPI Collectives  
* NCCL (network)/CUB(device) collectives for CUDA

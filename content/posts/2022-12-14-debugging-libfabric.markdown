---
title: Debugging Inconsistent Network Performance
date: 2022-12-14
tags:
- networking
- debugging
---

High-performance network interconnects, such as Infiniband, are common in high performance computing environments. Recently, my colleagues, and I ran a series of experiments on the Cooley system at the Argonne Leadership Computing Facility. For one set of experiments, the network performance was consistent and fast, but for the others we periodically had poor performance. Up until this point in my work, I had not directly used or configured network libraries below this layer. This post summarizes the steps we took to investigate the performance. 

Not knowing what the possible cause was we considered that the input, configuration, software or hardware could be different.
As far as we knew, we were providing the same input to both runs.
We ran `ldd` on the associated binaries for each experiment and confirmed that each experiments were loading the same dynamic libraries giving us confidence that it wasn't the software.
Not being super familar with the hardware hardware was on the node. We ran `hwloc-ls` to see the Node hardware.

```console
$ hwloc-ls
Machine (378GB total)
  ...<snip>...
  NUMANode L#1 (P#1 189GB)
    Package L#1 + L3 L#1 (15MB)
      L2 L#6 (256KB) + L1d L#6 (32KB) + L1i L#6 (32KB) + Core L#6 + PU L#6 (P#6)
      L2 L#7 (256KB) + L1d L#7 (32KB) + L1i L#7 (32KB) + Core L#7 + PU L#7 (P#7)
      L2 L#8 (256KB) + L1d L#8 (32KB) + L1i L#8 (32KB) + Core L#8 + PU L#8 (P#8)
      L2 L#9 (256KB) + L1d L#9 (32KB) + L1i L#9 (32KB) + Core L#9 + PU L#9 (P#9)
      L2 L#10 (256KB) + L1d L#10 (32KB) + L1i L#10 (32KB) + Core L#10 + PU L#10 (P#10)
      L2 L#11 (256KB) + L1d L#11 (32KB) + L1i L#11 (32KB) + Core L#11 + PU L#11 (P#11)
    HostBridge L#7
      PCIBridge
        PCI 15b3:1011
          Net L#10 "ib1"
          Net L#11 "ib0"
          OpenFabrics L#12 "mlx5_0"
      PCIBridge
        PCI 15b3:1003
          Net L#13 "eth2"
          OpenFabrics L#14 "mlx4_0"
```

The output to our surprise lists two network interfaces: one was an Mellanox version 4 card (`mlx4_0`) and the other was a Mellanox version 5 (`mlx5_0`) card. We noted the network device names, and that it one of them was using Ethernet and one was using Infiniband protocol at Layer 2.  

We then we were curious what devices each of our experiments were configured to use. One set or experiments was using the parallel file system, and the others were using Mochi -- a libfabric based networking library. Running `mount` told us that the experiments using the file system were transiting over the newer card, but we didn't know what the libfabric library was doing. Libfabric provides some debugging command like `fi_info` and `fi_pingpong`.  Running `fi_info -p verbs` we saw both devices were available with the verbs provider, and interestingly the `mlx4_0` was returned first. That didn't mean that our code was necessarily using this interface, but it was a hint. We then printed out the address of the clients and servers as determined by our high level library, and sure enough it was using the `mlx4_0` card which we confirmed against the output of `ip addr`. 

Now this wasn't enough to declare victory. We next tried to replicate the issue with `fi_pingpong -vvv` on both client and server, and sure enough when using the `mlx4_0` card we saw the same kinds of hangs we did in our experiments. We then tried the same thing with the `mlx5_0` card, and we didn't see any more hangs. We then reconfigured our Mochi based experiments to use `ofi+verbs://mlx5_0` to use this card, and sure enough we were able to resolve the issue with hangs.

Hope this helps!

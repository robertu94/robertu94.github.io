---
layout: post
title:  "Configuration Management: the Related Systems"
date:   2018-07-31 08:00:00 -0500
tags: 
- Ansible
- Chef
- Puppet
- SaltStack
---

Configuration Management Systems like Ansible, Chef, Puppet, and SaltStack are in my opinion are nearly essential if you find yourself managing more than 5 machines.
But what exactly are they, which is better for my circumstances, do I still need them if I use a container based infrastructure, how do I get started?
This post is the first in a series of posts that will attempt to answer these questions.


Configurations Management systems enforce a software-defined policy against the running state of computer systems.
I think this is best thought of in terms of some other important but different systems.

# Shell Scripts

Like shell scripts, Configuration management systems allow you to write a series of configuration steps into code that are executed on machines.
However, unlike shell scripts, these systems strive for idempotency by default -- actions are run if and only if they are needed.
Additionally configuration management systems often manage the parallelism of running the configuration on a variety of different machines.
Together idempotency potency and built-in parallelism make implementing scalable, repeatable systems substantially more pleasant.

# Package Management Systems (dnf, apt, pacman, portage, etc...)

Package managers can be used to install software files, configure users, network configurations, and more through the use of specially designed custom packages.
However, using systems to manage things like users or network configurations can be tricky, because it is required to track all potential starting points of the systems and code to get them to the desired current state.
Some package managers explicitly prohibit any changes to files owned by other packages.
While this is good for ensuing a consistent file systems, it makes it hard if not impossible to manage files like `/etc/hostname` that are often owned by some base file system layout package using these mechanisms.

# Firstboot Management Systems (packer, cloudinit, kickstart, sytstemd, etc...)

Packer is a software package that allows you to construct a distributable image your base system that can define things like your preferred dhcp configuration or ensure that your configuration management system agent is installed if required to bootstrap later management.
Likewise the couldinit, kickstart, or systemd's `ConditionFirstBoot=` option allow you to specify many of these initial configuration requirements required to bootstrap everything that comes after.
However, since these operate on first boot only, they can't effectively be used to manage on-going configuration management without making the base OS immutable which isn't done that often outside of container environments that are designed to work in this manner.

# Container Management Systems (docker, kubernetes)

Container Management systems such as Docker and Kubernetes in many ways can stand in the place of Configuration Management systems.
Often in container-oriented architectures, you have some resilient, distributed key store such as `etcd` that stores configuration for services running in the containers.
Additionally, for state-ful services you have something like a `PersistantStorageClaim`  that reserves some amount of storage on a possibly remote storage device or service (iSCSI, RDB, FiberChannel, etc...) or a separate database service.
Then the container manager ensures that you have a sufficient number of replicas running at any given time.
Some approaches like the one taken by Fedora-CoreOS (formally Fedora Project Atomic and Container Linux) operate by distributing an immutable image that is then first-booted every time and managed using the tools described above.
In many cases, this can obviate the need for a configuration management system.

However, there are some cases where configuration management systems are still useful.
Managing the underlying services that support the container environment is often difficult because fundamentally these services are hard to contain: they often need direct, physical access to hardware; need to manage the container engine itself; or need privileges that you don't want to provide to a container.
A configuration management system can help fill this gap in managing the base infrastructure required: for example allocating new VMs or machines to join your kubernetes cluster, configuring the routers or switches so that they can be later managed by Kubernetes or Docker.

That concludes the first post in this series.  Next time, I'll cover some of the major systems that operate in this space, and the means by which I compare them.

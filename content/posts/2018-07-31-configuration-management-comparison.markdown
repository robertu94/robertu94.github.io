---
layout: post
title:  "Configuration Management: the Battle Royal"
date:   2018-07-31 09:00:00 -0500
tags: 
- Ansible
- Chef
- Puppet
- SaltStack
---

So, you need a Configuration Management System, so which one do you choose?
This post is the second in a three part series on configuration management.
In this post, I'll highlight the strengths of these systems and their respective weaknesses.

Every evaluation needs to have criteria to be useful.
Here are some of the criteria that I have had when I thought about this question.

+	Ease of Use
+	Time to Setup
+	Difficulty of Adding More Machines
+	Difficulty of Creating New Modules
+	Difficulty of Supporting More Configurations
+	Quality of Documentation


# Puppet

Puppet is the oldest open source configuration management system, and perhaps the mostly widely deployed in enterprise environments.
In my opinion, it is the most different out of the four open source configuration management systems.
It uses a completely declarative language that requires some getting used to.
It managements ordering by the use of explicit ordering statements.
Additionally each resource, may only be declared once.
The problem this proposes is with inter-module dependency management.
Puppet solves this problem with the use of virtual resources.
Virtual resources then can be "realized" multiple times, but only one instance of the resource will be created.
For those unfamiliar with this concept, it takes a while to get used to.
Using the completely graph oriented execution policy allows Puppet to create highly parallel and fast execution graphs to apply the specified policy.

Puppet uses a client-server architecture with multiple components.
Each managed box runs a copy of the agent which is intended to run in concert with a master.
The agent registers with the Puppet master which then applies the policy with according to a specified regularity.
The other key components of Puppet are , `facter`, `hiera`, and `puppetdb`.
`facter` is responsible for gather "facts" about the nodes such as the hostname, number of cpus, or the ip-address.
`hiera` is responsible for providing hierarchical information to the nodes such as what group(s) a node belongs to and group based variables.
`puppetdb` acts as a "fact cache" and repository of events that happen on the nodes.

Adding a new box generally requires the agent requesting a master to sign a certificate request.
Without the signing their request, the agents will not be delivered a configuration to deploy.
This can provides a high level of security, but is admit auntly harder to configure than some of the other solutions.

Supporting more configurations is somewhat easy to do using Puppet.
There are two common ways this is accomplished.
The first is using so-called "parameter modules" which are small Puppet files that use conditional expressions to specify an appropriate values based on the facts on a system.
The other method is using `hiera` to specify different values.
The `hiera` should be thought of providing different values based on role, where as "parameter modules" should be thought of providing for variations on the same role.
However, the exact point to draw the line between the two is not always clear which in my opinion cases some confusion.

Creating new resources types can be done with ruby.
Puppet types are simply ruby classes that provide certain members and methods.
For those who know ruby, extending Puppet is a breeze.

Puppets documentation is perhaps its worst facet.
It is at times impenetrable at others hopeless vague and unhelpful.
Its gotten better since when I first used it over four years ago, but it is still the worst of the four by far.

# Ansible

Ansible is another early open source configuration management system.
Unlike Puppet, Ansible uses "playbooks" which are linear lists of instructions that generally execute from top to bottom.
While this makes it easier to use and reason about, it can make it slower to execute.
There is additionally no restraint on having resources managed in only one location.
This creates a greater possibility of error if there are conflicting requirements, but makes it easier to work with common resources.
Additionally recently, it was acquired by Red Hat making it likely to stick around and be well supported for years to come.

Instead of requiring its own agent infrastructure, Ansible reuses `ssh` and `python` making it fairly easy to adopt since most systems already have these installed.
The ansible agent is temporarily loaded on to the system when the master connects.
This obviates the need to maintain or update the agent since it is loaded fresh each time.
This temporary agent does all required fact finding and receives the appropriate set of host and group facts from the master.

Adding a new box is a breeze with Ansible.
Simply use `ssh-copy-id` to copy the master's ssh key on the node, and ensure that a somewhat recent venison of `python` is installed.
It may be one of the easiest system to get started.

Supporting new configurations with Ansible is easy.
Ansible has a clearly defined variable precedence hierarchy.
Simply define variables with the appropriate level of precedence.
There is one exception to this: Windows.
Windows systems often require different modules that make it more difficulty to integrate them using the same role files.

Creating new ansible modules (what Puppet calls a resource) can be done with `python`.
They are simply scripts that accept from standard input and return JSON to standard output as text.
Additionally, Ansible provides a large number of helper methods in `python` to make it easy to develop new modules.
For windows systems, they provide a set of power shell modules that provide similar features.

Ansible's documentation is the best of the four by far.
It has both extensive high level documentation making it easy to get started, but also extensive and up-to-date low level documentation to make it easy to reference for experienced users.
The documentation has ample examples of usage that demonstrate a variety of use cases.

# SaltStack

SaltStack is one of the slightly newer configuration management systems.
SaltStack brings refinement to the modules design presented by ansible.
Many of the cross distribution abstractions in SaltStack are more refined than their Ansible counter parts.
One annoying weaknesses of Salt is there is no concept of a comment in the files.
This makes it harder to documentation more obscure configuration choices.

Like puppet, it recommends a agent to be running on the client machines.
However like Ansible it does not strictly require one via the SaltSSH feature; technically puppet has a currently experimental feature called "bolt" that provides this functionality, but it very much is experimental.
The agent still must register with the master for the agent based mode, but this is relatively easy.

Supporting new configurations in SaltStack is about as easy as Puppet.
Simply define a pillar (SaltStack's admittedly simpler, but less flexible version of `hiera`) with the appropriate variables defined or create a new grain (SaltStack's version of a fact) that determines the appropriate information.

Creating new SaltStack modules is easily done with python.
Modules are simply functions in a python file that accept and return a dictionary.
This is substantially more polished than the clunky text oriented approach used by Ansible.
This makes them fairly easy to implement, but perhaps not as refined as Puppet's object oriented approach.

SaltStack's documentation is not as well refined as Ansible's.
While it still has excellent low level documentation, its high level documentation is not quite as refined.
I believe this combined with the less support for various modules than Ansible has hindered SaltStack's adoption.

# Chef

Chef is the other prominently used configuration management tool.
Unlike SaltStack, Puppet, or Ansible, Chef uses nearly pure ruby to describe its configuration which it calls cookbooks.
This has the advantage of being flexible, but the disadvantage of being harder to learn to use well than the descriptive domain specific languages used by the other three.
Unfortunately of the four commonly used configuration management tools it is the one that I have the least experience with.
I have used each of other systems to manage several systems that I consider production, and I have only managed test systems with Chef.

Like Puppet and SaltStack, Chef uses a client-server architecture.
However, unlike Puppet and Chef getting started on new nodes is very easy because of the chef `knife` feature.
The `knife` tool allows you to easily bootstrap the chef agent on other machines making it almost as easy to get started as Ansible.
Additionally the `kitchen` tool allows you to create and manage virtual machines for the purposes of testing applied configurations.
This gives it a very compelling story form a getting started perspective.

Since chef supports nearly arbitrary ruby code in "cookbooks", making supporting new configurations is easy, but perhaps not quite as clean as some of the other systems such as Ansible.
Chef like SaltStack has respectable and reasonably mature abstractions to make cross distribution development reasonable.

Creating new chef types is as simple as writing new ruby classes.
Since it uses nearly pure ruby, you can reach into the vast array of existing ruby libraries to build your modules.

Chef has ok documentation, but I find that it misses some of the high level documentation that really makes Ansible shine, however I would rate it above SaltStack.

# Which is Better?

Before deciding on which system you should use, you should think about what requirements you have and why you have them.
I'd also consider writing a small project in each when evaluating if it meets your needs.
Some things like ease of use are highly subjective, so don't take my word for them try them yourself.
I would recommend something simple like installing your dotfiles.

That brings an end to part 2 of this series.  In the final part of this series, I'll offer some advise built on years of experience using configuration management systems.

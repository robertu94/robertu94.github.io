---
layout: post
title:  "Faster than light"
date:   "2017-01-29 10:06:14 -0500"
tags: 
- ansible
- parallel
- programming
---

[Ansible][ansible] is probably my favorite provisioning and configuration management tool.
Its syntax is concise, expressive, and elegant.
Unlike other tools in its category, it has [excellent documentation][docs] with working examples and intuitive naming.
Learning it use it effectively can help you be a more productive developer.


## Speeding Up Ansible

Anyone that has used ansible for more than a few hosts with more than a few tasks knows that by default it can be really slow.
However with two simple options, you can dramatically improve the responsiveness of ansible playbooks without any other changes.
For one set of playbooks that I wrote, these changes cut the run-time from an hour to 15 minutes.

First is the number of forks.
Forks controls how many hosts ansible will connect to at a time.
So as not to overwhelm a small ansible master, the default is set to a measly 5 forks.
Most of the time, the master is only responsible for doling out tasks to the slave nodes.
And since most modern computers have at least 8 cores, you can easily increase this to a larger value.
I use 25 on my 8 core machine.

Second, is [ssh pipelining][pipeline].
Pipelining allows ansible, to reuse the same ssh connection for multiple actions which dramatically improves performance.
However, it is not the default because there are a few old systems that do not support this configuration by default.

To enable both of these features, put the following in a file called `ansible.cfg` or in `/etc/ansible/ansible.cfg`

```ini
[defaults]
forks = 25
pipelining = True
```

## Don't Repeat Yourself

DRY or Don't Repeat Yourself is a cornerstone of software design.
For most of Ansible 1.X, there were several examples of often repeated stanzas that would appear in Ansible playbooks:
The two most common were `tags` and `become` that allow you to run some subset of a playbook and to execute with elevated privileges respectfully.
Ansible 2.0 introduced the concept of [blocks][blocks].
Blocks allow you to apply common options to a set of commands.
For example, in Ansible 1.X:

```ansible
- name: install vim
  dnf: name="vim" state="installed"
  become: True
  tags:
   - install
- name: update all packages
  dnf: name='*' state=latest
  become: True
  tags:
   - install
```

Becomes:

```ansible
- block:
  - name: install vim
    dnf: name="vim" state="installed"
  - name: update all packages
    dnf: name='*' state=latest
  become: True
  tags:
   - install
```

## Don't Re-run The Whole Playbook

Suppose that almost all of your playbook runs correctly, but you hit the end, and there is one command that fails.
Previously, you would either have to create a playbook with just that task/role, and re-run it or use tags for each action.
Now you can simply use the [`--start-at-task="<name>"`][start-at] option to re-run just the commands you are interested in.
There is one slight issue: If the name that you want to start at is based on a section conditional using a custom fact module, you need to ensure that the custom fact is run first.

## Don't Wait On a Slow Host

Another possible pain point for ansible is if one host in a set needs to do more work than the others.
Ansible 2.X added the concept of [strategies][strategies] which control how a role is executed.
One of these strategies is `free` which allows each host in the list to advances as through the play as quickly as possible.
For plays that depend on other hosts in the managed group, be sure to use a `wait_for` command to ensure the servies you are expecting exists.

Happy Programming!

[ansible]: https://docs.ansible.com
[docs]: https://docs.ansible.com/ansible/playbooks_best_practices.html
[forks]: https://docs.ansible.com/ansible/intro_configuration.html#forks
[pipeline]: https://docs.ansible.com/ansible/intro_configuration.html#pipelining
[blocks]: https://docs.ansible.com/ansible/playbooks_blocks.html
[start-at]: https://docs.ansible.com/ansible/playbooks_startnstep.html#start-at-task
[strategies]: https://docs.ansible.com/ansible/playbooks_strategies.html

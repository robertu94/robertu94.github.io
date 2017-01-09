---
layout: post
title:  "Poor Man's Parallelism"
date:   2017-01-08 10:58:14 -0500
tags: 
- shell
- parallel
- programming
---

I really like orchestration tools such as [Ansible][ansible] or [SaltStack][salt].
They can make running tasks on a group of machines a breeze.
But sometimes you can't or don't want to install these tools on a machine.
In cases like these, it is helpful to know how to parallelize some tasks in the shell.

You can do this via Unix/shell job control:

```bash
cmd="systemctl enable --now docker.service"
hosts=(host{1..4})

for host in ${hosts[@]}
do
	ssh & $host $cmd
done
```

However from experience, this can be very error prone.
For example, The placement of the `&` is important so as to background the ssh command and not the command on the remote machine.
Additionally, what if you had a lot of hosts and you didn't want to run all of them at once.
Instead, you want to utilize a bounded pool of processes.

There are a few ways of doing this: most ways are messy or or fairly non-portable.
On systems with the util-linux installed you might use `flock` or `lockfile`, but then you have essentially to implement semaphores using mutex locks and shell arithmetic.
If you don't have util-linux you can accomplish the same thing taking advantage of the atomicity of `mkdir` [on most (but not all) file systems][mkdir]:

However rather than doing this, take a look at the fairly pervasive `xargs` command.
According the manpage, [`xargs`][xargs] "builds and executes command lines from standard input."
It has an option `-P <NUM_PROCS>` that takes determines how many commands to run in parallel.
With this, it is just a matter of formatting commands in a way that `xargs` understands.

```bash
cmd="systemctl enable --now docker.service"
hosts=(host{1..4})
numprocs=8
echo ${hosts[@]} | xargs -P $numprocs -d" " -I{} -n 1 ssh {} $cmd
```

Admittedly this looks a bit cryptic. 
It helps to know that `-d` is setting the delimiter from the default newline to space, 
`-n <NUM_ARGS>` sets the number of arguments to pass to each command, and 
`-I <REPLACE_STR>` is setting the replacement string for `xargs` so that `ssh {} $cmd` becomes `ssh host1 $cmd` for the first command and so on.
The `xargs` command also accepts an input file option (`-a <file>`) where we could put each host on a newline to simplify the call.

Now we can easily create process pools in a mostly portable fashion in shell scripts.
There are lots of useful things you could do with this, but here are two recipes that I came up with:


```bash
#copy a file to many nodes
function pcopy(){
filename=$1
dest=$2
shift 2
echo $* | xargs -d" " -P 8 -I{} -n 1 scp  $filename {}:$dest
}
pcopy somefile.txt host{1..8}

#retrieve files from many nodes
function pget(){
filename=$1
shift
echo $* | xargs -d" " -P 8 -I{} -n 1 scp {}:$filename $(basename $filename).{}
}
```

Happy shell scripting!

[salt]: https://docs.saltstack.com
[ansible]: https://docs.ansible.com
[mkdir]: http://mywiki.wooledge.org/BashFAQ/045
[xargs]: https://linux.die.net/man/1/xargs

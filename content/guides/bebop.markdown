---
title: "Spack on Bebop"
layout: post
date: 2022-07-19
---

# tl;dr

Put the following in your `.bashrc`

```bash
use_build() {
  if hostname | grep bebop &>/dev/null; then
      echo "loading bebop spack"
      module load gcc/11.4.0
      module load intel-oneapi-mpi/2021.12.1-tjkrnei
      module load intel-oneapi-mkl/2024.0.0-jfwrhz5
      source $HOME/git/spack-bebop/share/spack/setup-env.sh
      source $HOME/git/spack-bebop/share/spack/spack-completion.bash
      export clustername=bebop
  fi
  #other LCRC Machines
  export SPACK_USER_CONFIG_PATH="$HOME/.spack/$clustername"
  export SPACK_USER_CACHE_PATH="$SPACK_USER_CONFIG_PATH"
}
```

Then run

```bash
mkdir -p ~/git
git clone https://github.com/spack/spack git/spack-bebop
git clone https://github.com/robertu94/spack_packages git/robertu94_packages
source ~/.bashrc

# for extra packages like libpressio
spack repo add ~/git/robertu94_packages
```



Bebop provides default configurations for packages and compilers so you are ready to go!
And now spack should work.  On your next login, just call `use_build` to reload spack.

For the longer version see the guide on [configuring spack]({% link _guides/spack.markdown %})

# What makes this machine special?

1. Spack shares a home filesystem with other machines like `swing`  these
   machines are completely different hardware wise and use different module
   systems.  The load function loads a copy of spack specifically for Bebop and uses
   a separate spark instance for other machines.  We use spack's `SPACK_USER_CONFIG_PATH` 
   to keep these cleanly separate.
2. The Bebop admins have configured spack with a bunch of sane defaults, so you can leave these alone :)

# Changelog

+ 2022-07-19 created this document
+ 2022-08-11 updated to use Intel-MPI
+ 2024-07-11 updated after the bebop update

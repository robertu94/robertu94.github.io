---
title: "Spack on Bebop"
layout: post
date: 2022-07-19
---

# tl;dr

Put the following in your `.bashrc`

```bash
use_build() {
  if hostname | grep "^i" &>/dev/null; then
      echo "loading improv spack"
      module load gcc/13.2.0
      module load openmpi/5.0.1-gcc-13.2.0
      source $HOME/git/spack-improv/share/spack/setup-env.sh
      source $HOME/git/spack-improv/share/spack/spack-completion.bash
      export clustername=improv
  fi
  #other LCRC Machines
  export SPACK_USER_CONFIG_PATH="$HOME/.spack/$clustername"
  export SPACK_USER_CACHE_PATH="$SPACK_USER_CONFIG_PATH"
}
```

Then run

```bash
mkdir -p ~/git
git clone https://github.com/spack/spack git/spack-improv
git clone https://github.com/robertu94/spack_packages git/robertu94_packages
source ~/.bashrc
use_build
spack compiler find

# for extra packages like libpressio
spack repo add ~/git/robertu94_packages
```



First create `packages.yaml` at `~/.spack/improv/packages.yaml` with:

```yaml
packages:
  all:
    providers:
      blas: [openblas]
      lapack: [openblas]
      mpi: [openmpi]
  openmpi:
    externals:
    - spec: openmpi@5.0.1+atomics~cuda~java~memchecker~static~wrapper-rpath fabrics=ucx
      prefix: /gpfs/fs1/soft/improv/software/spack-built/linux-rhel8-zen3/gcc-13.2.0/openmpi-5.0.1-yhyhopk
      modules: [openmpi/5.0.1-gcc-13.2.0]
    buildable: False
```

After that create `compilers.yaml` at `~/.spack/improv/linux/compilers.yaml` with:

```yaml
compilers:
- compiler:
    spec: gcc@=13.2.0
    paths:
      cc: /gpfs/fs1/soft/improv/software/spack-built/linux-rhel8-x86_64/gcc-8.5.0/gcc-13.2.0-iyqxotb/bin/gcc
      cxx: /gpfs/fs1/soft/improv/software/spack-built/linux-rhel8-x86_64/gcc-8.5.0/gcc-13.2.0-iyqxotb/bin/g++
      f77: /gpfs/fs1/soft/improv/software/spack-built/linux-rhel8-x86_64/gcc-8.5.0/gcc-13.2.0-iyqxotb/bin/gfortran
      fc: /gpfs/fs1/soft/improv/software/spack-built/linux-rhel8-x86_64/gcc-8.5.0/gcc-13.2.0-iyqxotb/bin/gfortran
    flags: {}
    operating_system: rhel8
    target: x86_64
    modules: [gcc/13.2.0]
    environment: {}
    extra_rpaths: []
```

And now spack should work.  On your next login, just call `use_build` to reload spack.

For the longer version see the guide on [configuring spack]({% link _guides/spack.markdown %})

# What makes this machine special?

2. We use mpi from the system to avoid configuring them
3. We load a new compiler from a module to have access to newer C++ features
4. Improv shares a home filesystem with other machines like `swing`  these
   machines are completely different hardware wise and use different module
   systems.  The load function loads a copy of spack specifically for Improv and uses
   a separate spark instance for other machines.  We use spack's `SPACK_USER_CONFIG_PATH` 
   to keep these cleanly separate.

# Changelog

+ 2024-02-22 created document

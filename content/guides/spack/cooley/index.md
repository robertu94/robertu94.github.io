---
title: "Spack on Cooley"
layout: post
date: 2022-07-19
summary: "configure spack for ANL ALCF cooley"
---

# tl;dr

Put the following in your `.bashrc`

```bash
function use_build {
    # other ALCF machines
    if hostname | grep cooley &>/dev/null || hostname | grep cc &> /dev/null; then
       soft add +gcc-8.2.0
       soft add +cmake-3.20.4
       soft add +cuda-11.0.2
       soft add +mvapich2
       source ${HOME}/git/spack-cooley/share/spack/setup-env.sh
       export clustername=cooley
    fi  
    export SPACK_USER_CONFIG_PATH="$HOME/.spack/$clustername"
    export SPACK_USER_CACHE_PATH="$SPACK_USER_CONFIG_PATH"
}
```

Then run

```bash
mkdir -p ~/git
git clone https://github.com/spack/spack git/spack-cooley
git clone https://github.com/robertu94/spack_packages git/robertu94_packages
source ~/.bashrc
use_build
spack compiler find

# for extra packages like libpressio
spack repo add ~/git/robertu94_packages
```



First create `packages.yaml` at `~/.spack/cooley/packages.yaml` with:

```yaml
packages:
  all:
    providers: 
      blas: [intel-mkl]
      lapack: [intel-mkl]
      fftw-api: [intel-mkl]
      scalapack: [intel-mkl]
      mkl: [intel-mkl]
  git:
    externals:
    - spec: git@2.17.1+tcltk
      prefix: /usr
    buildable: false
  openssh:
    externals:
    - spec: openssh@7.4p1
      prefix: /usr
    buildable: false
  curl:
    externals:
    - spec: curl@7.29.0+ldap
      prefix: /usr
    buildable: false
  cuda:
    externals:
    - spec: cuda@11.0.194
      prefix: /soft/visualization/cuda-11.0.2
    buildable: false
  mvapich2:
    externals:
    - spec: mvapich2@2.2~cuda~debug~regcache~wrapperrpath
      prefix: /soft/libraries/mpi/mvapich2/gcc
    buildable: false
 rdma-core:
    externals:
    - spec: rdma-core@22.4
      prefix: /usr
    buildable: false
```

After that create `compilers.yaml` at `~/.spack/cooley/linux/compilers.yaml` with:

```yaml
compilers:
compilers:
- compiler:
    spec: gcc@4.8.5
    paths:
      cc: /bin/gcc
      cxx: /bin/g++
      f77: /bin/gfortran
      fc: /bin/gfortran
    flags: {}
    operating_system: rhel7
    target: x86_64
    modules: []
    environment: {}
    extra_rpaths: []
- compiler:
    spec: gcc@8.2.0
    paths:
      cc: /soft/compilers/gcc/8.2.0/bin/gcc
      cxx: /soft/compilers/gcc/8.2.0/bin/g++
      f77: /soft/compilers/gcc/8.2.0/bin/gfortran
      fc: /soft/compilers/gcc/8.2.0/bin/gfortran
    flags: {}
    operating_system: rhel7
    target: x86_64
    modules: []
    environment: {}
    extra_rpaths: []
```

And now spack should work.  On your next login, just call `use_build` to reload spack.

For the longer version see the guide on [configuring spack]({% link _guides/spack.markdown %})

# What makes this machine special?

1. We prefer intel-mkl for blas/lapack because of the Intel CPUs
2. We use openssl and mpi (with RDMA Core) from the system to avoid configuring them
3. We load a new compiler from a softenv because the default is ancient.
   Spack doesn't know about softenv, so paths are passed via the prefix as here
5. Spack shares a home filesystem with other machines like `theta`  these
   machines are completely different hardware wise and use different module
   systems.  The load function loads a copy of spack specifically for Cooley and uses
   a separate spark instance for other machines.  We use spack's
   `SPACK_USER_CONFIG_PATH` variable to keep these cleanly separate.

# Changelog

+ 2022-08-11 created this document

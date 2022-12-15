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
      module load gcc/10.2.0-z53hda3
      module load intel-mpi/2019.10.317-qn674hj
      module load intel-mkl/2020.4.304
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
spack compiler find

# for extra packages like libpressio
spack repo add ~/git/robertu94_packages
```



First create `packages.yaml` at `~/.spack/bebop/packages.yaml` with:

```yaml
packages:
  all:
    providers:
      blas: [intel-mkl]
      lapack: [intel-mkl]
      fftw-api: [intel-mkl]
      scalapack: [intel-mkl]
      mkl: [intel-mkl]
      mpi: [intel-mpi]
  openssl:
    externals:
    - spec: openssl@1.0.2k-fips
      prefix: /usr
    buildable: false
```

After that create `compilers.yaml` at `~/.spack/bebop/linux/compilers.yaml` with:

```yaml
compilers:
- compiler:
    spec: gcc@10.2.0
    paths:
      cc: /gpfs/fs1/software/centos7/spack-latest/opt/spack/linux-centos7-x86_64/gcc-6.5.0/gcc-10.2.0-z53hda3/bin/gcc
      cxx: /gpfs/fs1/software/centos7/spack-latest/opt/spack/linux-centos7-x86_64/gcc-6.5.0/gcc-10.2.0-z53hda3/bin/g++
      f77: /gpfs/fs1/software/centos7/spack-latest/opt/spack/linux-centos7-x86_64/gcc-6.5.0/gcc-10.2.0-z53hda3/bin/gfortran
      fc: /gpfs/fs1/software/centos7/spack-latest/opt/spack/linux-centos7-x86_64/gcc-6.5.0/gcc-10.2.0-z53hda3/bin/gfortran
    flags: {}
    operating_system: centos7
    target: x86_64
    modules: [gcc/10.2.0-z53hda3]
    environment: {}
    extra_rpaths: []
```

And now spack should work.  On your next login, just call `use_build` to reload spack.

For the longer version see the guide on [configuring spack]({% link _guides/spack.markdown %})

# What makes this machine special?

1. We prefer intel-mkl for blas/lapack because of the Intel CPUs
2. We use openssl and mpi from the system to avoid configuring them
3. We load a new compiler from a module because the default is ancient
4. Spack shares a home filesystem with other machines like `swing`  these
   machines are completely different hardware wise and use different module
   systems.  The load function loads a copy of spack specifically for Bebop and uses
   a separate spark instance for other machines.  We use spack's `SPACK_USER_CONFIG_PATH` 
   to keep these cleanly separate.

# Changelog

+ 2022-07-19 created this document
+ 2022-08-11 updated to use Intel-MPI

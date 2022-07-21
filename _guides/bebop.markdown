---
title: "Spack on Bebop"
layout: post
date: 2022-07-19
...

# tl;dr

Put the following in your `.bashrc`

```bash
use_build() {
  if hostname | grep bebop &>/dev/null; then
      echo "loading bebop spack"
      module load gcc/9.2.0-pkmzczt
      module load openmpi/4.1.2
      source $HOME/git/spack-bebop/share/spack/setup-env.sh
      source $HOME/git/spack-bebop/share/spack/spack-completion.bash
  fi
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



First create `packages.yaml` at `~/git/spack-bebop/etc/spack/packages.yaml` with:

```yaml
packages:
  all:
    providers: 
      blas: [intel-mkl]
      lapack: [intel-mkl]
      fftw-api: [intel-mkl]
      scalapack: [intel-mkl]
      mkl: [intel-mkl]
  openssl:
    externals:
    - spec: openssl@1.0.2k-fips
      prefix: /usr
    buildable: false
  openmpi:
    externals:
      - spec: openmpi@4.1.2~cuda~cxx~cxx_exceptions~java~memchecker+pmi~sqlite3~static~thread_multiple~wrapper-rpath fabrics=ofi,psm2 schedulers=slurm
        modules: [openmpi/4.1.2]
    buildable: false
```

After that create `compilers.yaml` at `~/git/spack-bebop/etc/spack/compilers.yaml` with:

```yaml
compilers:
- compiler:
    spec: gcc@4.8.5
    paths:
      cc: /usr/bin/gcc
      cxx: /usr/bin/g++
      f77: /usr/bin/gfortran
      fc: /usr/bin/gfortran
    flags: {}
    operating_system: centos7
    target: x86_64
    modules: []
    environment: {}
    extra_rpaths: []
- compiler:
    spec: gcc@9.2.0
    paths:
      cc: /blues/gpfs/software/centos7/spack-latest/opt/spack/linux-centos7-x86_64/gcc-6.5.0/gcc-9.2.0-pkmzczt/bin/gcc
      cxx: /blues/gpfs/software/centos7/spack-latest/opt/spack/linux-centos7-x86_64/gcc-6.5.0/gcc-9.2.0-pkmzczt/bin/g++
      f77: /blues/gpfs/software/centos7/spack-latest/opt/spack/linux-centos7-x86_64/gcc-6.5.0/gcc-9.2.0-pkmzczt/bin/gfortran
      fc: /blues/gpfs/software/centos7/spack-latest/opt/spack/linux-centos7-x86_64/gcc-6.5.0/gcc-9.2.0-pkmzczt/bin/gfortran
    flags: {}
    operating_system: centos7
    target: x86_64
    modules: []
    environment: {}
    extra_rpaths: []
```

And now spack should work.  On your next login, just call `use_build` to reload spack.

For the longer version see the guide on [configuring spack]({% link _guides/spack.markdown %})

# What makes this machine special?

1. We prefer intel-mkl for blas/lapack because of the Intel CPUs
2. We use openssl and mpi from the sytstem to avoid configuring them
3. We load a new compiler from a module because the default is ancient
4. Spack shares a home filesystem with other machines like `swing`  these
   machines are completely different hardware wise and use different module
   systems.  The load function loads a copy of spack specifically for Bebop and uses
   a separate spark instance for other machines.  We use spack's `site` scope
   to keep these cleanly separate.

# Changelog

+ 2022-07-19 created this document

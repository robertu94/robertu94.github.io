---
title: "Spack on Summit"
layout: post
date: 2022-10-25
summary: "configure spack on ORNL OLCF Summit"
---

# tl;dr

Put the following in your `.bashrc`

```bash
use_build() {
  if hostname | grep summit &>/dev/null; then
      echo "loading summit spack"
      module load gcc/10.2.0
      export clustername=summit
  fi
  #other OLCF Machines
  export SPACK_USER_CONFIG_PATH="$HOME/.spack/$clustername"
  export SPACK_USER_CACHE_PATH="$SPACK_USER_CONFIG_PATH"
  source $HOME/git/spack-summit/share/spack/setup-env.sh
  source $HOME/git/spack-summit/share/spack/spack-completion.bash
}
```

Then run

```bash
mkdir -p ~/git
git clone https://github.com/spack/spack git/spack-summit
source ~/.bashrc
spack compiler find
```



First create `packages.yaml` at `~/.spack/summit/packages.yaml` with:

```yaml
packages:
  all:
    providers:
      mpi: [spectrum-mpi]
  openssl:
    externals:
    - spec: openssl@1.1.1c
      prefix: /usr
    buildable: False
  openssh:
    externals:
    - spec: openssh@8.0p1
      prefix: /usr
    buildable: False
  cuda:
    externals:
    - spec: cuda@11.0.221
      prefix: /sw/summit/cuda/11.0.3
    buildable: False
  spectrum-mpi:
    externals:
    - spec: spectrum-mpi@10.4.0.03rtm4
      prefix: /sw/summit/spack-envs/base/opt/linux-rhel8-ppc64le/gcc-10.2.0/spectrum-mpi-10.4.0.3-20210112-ht5bw4jruhjujvkzcvpra5lryg5vfhy4
    buildable: False
  tar:
    externals:
    - spec: tar@1.30
      prefix: /usr
  cvs:
    externals:
    - spec: cvs@1.11.23
      prefix: /usr
  diffutils:
    externals:
    - spec: diffutils@3.6
      prefix: /usr
  groff:
    externals:
    - spec: groff@1.22.3
      prefix: /usr
  bison:
    externals:
    - spec: bison@3.0.4
      prefix: /usr
  gawk:
    externals:
    - spec: gawk@4.2.1
      prefix: /usr
  pkgconf:
    externals:
    - spec: pkgconf@1.4.2
      prefix: /usr
  m4:
    externals:
    - spec: m4@1.4.18
      prefix: /usr
  git:
    externals:
    - spec: git@2.18.4~tcltk
      prefix: /usr
  binutils:
    externals:
    - spec: binutils@2.30.73
      prefix: /usr
  automake:
    externals:
    - spec: automake@1.16.1
      prefix: /usr
  flex:
    externals:
    - spec: flex@2.6.1+lex
      prefix: /usr
  coreutils:
    externals:
    - spec: coreutils@8.30
      prefix: /usr
  autoconf:
    externals:
    - spec: autoconf@2.69
      prefix: /usr
  gmake:
    externals:
    - spec: gmake@4.2.1
      prefix: /usr
  libtool:
    externals:
    - spec: libtool@2.4.6
      prefix: /usr
  findutils:
    externals:
    - spec: findutils@4.6.0
      prefix: /usr
  curl:
    externals:
    - spec: curl@7.61.1+gssapi+ldap+nghttp2
      prefix: /usr
  texinfo:
    externals:
    - spec: texinfo@6.5
      prefix: /usr
```

After that create `compilers.yaml` at `~/.spack/summit/linux/compilers.yaml` with:

```yaml
compilers:
- compiler:
    spec: gcc@10.2.0
    paths:
      cc: /sw/summit/gcc/10.2.0-2/bin/gcc
      cxx: /sw/summit/gcc/10.2.0-2/bin/g++
      f77: /sw/summit/gcc/10.2.0-2/bin/gfortran
      fc: /sw/summit/gcc/10.2.0-2/bin/gfortran
    flags: {}
    operating_system: rhel8
    target: ppc64le
    modules: []
    environment: {}
    extra_rpaths: []
```

And now spack should work.  On your next login, just call `use_build` to reload spack.

For the longer version see the guide on [configuring spack]({% link _guides/spack.markdown %})

# What makes this machine special?

1. Summit is a powerpc machine and uses IBM's Spectrum-MPI for best performance
2. We load a new compiler from a module because the default is IBM XL lacking some features from Modern GCC
3. Summit shares a home filesystem with other machines like `Crusher`  these
   machines are completely different hardware wise and use different module
   systems.  The load function loads a copy of spack specifically for Summit and uses
   a separate spark instance for other machines.  We use spack's `SPACK_USER_CONFIG_PATH` 
   to keep these cleanly separate.

# Changelog

+ 2022-10-25 created this document

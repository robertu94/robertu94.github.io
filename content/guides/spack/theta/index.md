---
title: "Spack on Theta"
layout: post
date: 2022-07-19
summary: "configure spack for ANL ALCF Theta"
---

# tl;dr

Put the following in your `.bashrc`

```bash
function use_build {
    # other ALCF machines
    if hostname | grep theta &>/dev/null; then
       echo "loading theta spack"
       module swap PrgEnv-intel PrgEnv-gnu
       module swap gcc/11.2.0
       source ${HOME}/git/spack-theta/share/spack/setup-env.sh
       export CRAYPE_LINK_TYPE=dynamic
       export clustername=theta
       export HTTP_PROXY=http://theta-proxy.tmi.alcf.anl.gov:3128
       export HTTPS_PROXY=http://theta-proxy.tmi.alcf.anl.gov:3128
       export http_proxy=http://theta-proxy.tmi.alcf.anl.gov:3128
       export https_proxy=http://theta-proxy.tmi.alcf.anl.gov:3128
     fi
    export SPACK_USER_CONFIG_PATH="$HOME/.spack/$clustername"
    export SPACK_USER_CACHE_PATH="$SPACK_USER_CONFIG_PATH"
}
```

Then run

```bash
mkdir -p ~/git
git clone https://github.com/spack/spack git/spack-theta
git clone https://github.com/robertu94/spack_packages git/robertu94_packages
git clone https://github.com/mochi-hpc/mochi-spack-packages git/mochi-spack-packages
source ~/.bashrc
use_build
spack compiler find

# for extra packages like libpressio and thallium
spack repo add ~/git/robertu94_packages
spack repo add ~/git/mochi-spack-packages
```



First create `packages.yaml` at `~/.spack/theta/packages.yaml` with:

```yaml
packages:
  all:
    providers:
      mpi: [cray-mpich]
      blas: [intel-mkl]
      lapack: [intel-mkl]
      fftw-api: [intel-mkl]
      scalapack: [intel-mkl]
      mkl: [intel-mkl]
  cray-mpich:
    externals:
    - spec: cray-mpich@7.7.14
      modules: [cray-mpich/7.7.14]
    buildable: False
  subversion:
    externals:
    - spec: subversion@1.10.6
      prefix: /usr
  cmake:
    externals:
    - spec: cmake@3.10.2
      prefix: /usr
  cvs:
    externals:
    - spec: cvs@1.12.12
      prefix: /usr
  texinfo:
    externals:
    - spec: texinfo@6.5
      prefix: /usr
  autoconf:
    externals:
    - spec: autoconf@2.69
      prefix: /usr
  bison:
    externals:
    - spec: bison@3.0.4
      prefix: /usr
  flex:
    externals:
    - spec: flex@2.6.4+lex
      prefix: /usr
  groff:
    externals:
    - spec: groff@1.22.3
      prefix: /usr
  openssl:
    externals:
    - spec: openssl@1.1.0i-fips
      prefix: /usr
  git:
    externals:
    - spec: git@2.26.2~tcltk
      prefix: /usr
  diffutils:
    externals:
    - spec: diffutils@3.6
      prefix: /usr
  tar:
    externals:
    - spec: tar@1.30
      prefix: /usr
  automake:
    externals:
    - spec: automake@1.15.1
      prefix: /usr
  gmake:
    externals:
    - spec: gmake@4.2.1
      prefix: /usr
  m4:
    externals:
    - spec: m4@1.4.18
      prefix: /usr
  openssh:
    externals:
    - spec: openssh@7.9p1
      prefix: /usr
  binutils:
    externals:
    - spec: binutils@2.35.1
      prefix: /usr
  findutils:
    externals:
    - spec: findutils@4.6.0
      prefix: /usr
  pkg-config:
    externals:
    - spec: pkg-config@0.29.2
      prefix: /usr
  libtool:
    externals:
    - spec: libtool@2.4.6
      prefix: /usr
  libfabric:
    variants: fabrics=gni
  mercury:
    variants: +udreg ~boostsys ~checksum
  gawk:
    externals:
    - spec: gawk@4.2.1
      prefix: /usr
  rdma-credentials:
        buildable: false
        version: []
        target: []
        compiler: []
        providers: {}
        externals:
        - spec: rdma-credentials@1.2.25 arch=cray-cnl7-mic_knl
          modules:
          - rdma-credentials/1.2.25-7.0.2.1_4.3__g67c8aa4.ari
```

After that create `compilers.yaml` at `~/.spack/theta/cray/compilers.yaml` with:

```yaml
compilers:
- compiler:
    spec: gcc@11.2.0
    paths:
      cc: cc
      cxx: CC
      f77: ftn 
      fc: ftn 
    flags: {}
    operating_system: cnl7
    target: any 
    modules:
    - PrgEnv-gnu
    - gcc/11.2.0
    environment: {}
    extra_rpaths: []
```

And now spack should work.  On your next login, just call `use_build` to reload spack.

For the longer version see the guide on [configuring spack]({% link _guides/spack.markdown %})

# What makes this machine special?

1. We prefer intel-mkl for blas/lapack because of the Intel CPUs
2. We use openssl and mpi from the system to avoid configuring them
3. We load a new compiler and programming environment because the default is ancient.
5. Spack shares a home filesystem with other machines like `cooley`  these
   machines are completely different hardware wise and use different module
   systems.  The load function loads a copy of spack specifically for Cooley and uses
   a separate spark instance for other machines.  We use spack's
   `SPACK_USER_CONFIG_PATH` variable to keep these cleanly separate.
6. Theta is a cray machine, so needs some cray special sauce like the
   PrgEnv-gnu and CRAYPE_LINK_TYPE=dynamic to behave more sanely.
7. Very often you will want to include `--attr enable-ssh=1` in your COBALT flags to enable
   TCP access to the nodes (i.e. SSH)

# Changelog

+ 2022-08-16 created this document


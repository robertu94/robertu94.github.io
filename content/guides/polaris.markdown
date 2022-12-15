---
title: "Spack on Polaris"
layout: post
date: 2022-07-19
---

# tl;dr

Put the following in your `.bashrc`

```bash
function use_build {
    # other ALCF machines
    if hostname -f  | grep polaris &>/dev/null; then
       echo "loading polaris spack"
       module swap PrgEnv-nvhpc PrgEnv-gnu
       module load cudatoolkit-standalone
       source ${HOME}/git/spack-theta/share/spack/setup-env.sh
       export CRAYPE_LINK_TYPE=dynamic
       export clustername=polaris
     fi
    export SPACK_USER_CONFIG_PATH="$HOME/.spack/$clustername"
    export SPACK_USER_CACHE_PATH="$SPACK_USER_CONFIG_PATH"
}
```

Then run

```bash
mkdir -p ~/git
git clone https://github.com/spack/spack git/spack-polaris
git clone https://github.com/robertu94/spack_packages git/robertu94_packages
git clone https://github.com/mochi-hpc/mochi-spack-packages git/mochi-spack-packages
source ~/.bashrc
use_build
spack compiler find

# for extra packages like libpressio and thallium
spack repo add ~/git/robertu94_packages
spack repo add ~/git/mochi-spack-packages
```



First create `packages.yaml` at `~/.spack/polaris/packages.yaml` with:

```yaml
packages:
  all:
    providers:
        mpi: [cray-mpich]
  cuda:
    externals:
      - spec: cuda@11.6.2
        modules: ['cudatoolkit-standalone/11.6.2']
    buildable: False
  libfabric:
    externals:
      - spec: libfabric@1.11.0
        modules: ['libfabric/1.11.0.4.125']
    buildable: False
  cray-mpich:
    externals:
      - spec: cray-mpich@8.1.16+wrappers
        modules: ['cray-mpich/8.1.16']
    buildable: False
  openssl:
    externals:
    - spec: openssl@1.1.1d
      prefix: /usr
    buildable: False
```

After that create `compilers.yaml` at `~/.spack/polaris/cray/compilers.yaml` with:

```yaml
- compiler:
    spec: gcc@11.2.0
    paths:
      cc: cc
      cxx: CC
      f77: ftn
      fc: ftn
    flags: {}
    operating_system: sles15
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

1. We use openssl and mpi from the system to avoid configuring them
2. We load a new compiler and programming environment because the default is older.
3. Spack shares a home filesystem with other machines like `cooley`  these
   machines are completely different hardware wise and use different module
   systems.  The load function loads a copy of spack specifically for Cooley and uses
   a separate spark instance for other machines.  We use spack's
   `SPACK_USER_CONFIG_PATH` variable to keep these cleanly separate.
4. Polaris is a cray machine, so needs some cray special sauce like the
   PrgEnv-gnu to behave more sanely.  However, unlike theta it uses
   `CRAYPE_LINK_TYPE=dynamic` as the default behavior so we don't need to set it here.
5. As of writing, Polaris uses slingshot 10 and will be updated to Slingshot 11 in Fall 2022
   While this should not change the configuration used here, it may change the connection strings
   for certain applications using mochi/margo based services from using from `verbs;ofi_rxm` to `cxi`

# Changelog

+ 2022-08-29 created this document



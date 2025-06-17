---
title: "Spack on Crusher"
layout: post
date: 2022-10-26
summary: "Configure spack for ORNL OLCF Crusher"
---

# tl;dr

Put the following in your `.bashrc`

```bash
use_build() {
  if hostname | grep summit &>/dev/null; then
      echo "loading crusher spack"
      module swap PrgEnv-cray PrgEnv-gnu
      module load craype-accel-amd-gfx90a
      module load rocm
      export clustername=crusher
  fi
  #other OLCF Machines
  export SPACK_USER_CONFIG_PATH="$HOME/.spack/$clustername"
  export SPACK_USER_CACHE_PATH="$SPACK_USER_CONFIG_PATH"
  source $HOME/git/spack-crusher/share/spack/setup-env.sh
  source $HOME/git/spack-crusher/share/spack/spack-completion.bash
}
```

Then run

```bash
mkdir -p ~/git
git clone https://github.com/spack/spack git/spack-crusher
source ~/.bashrc
spack compiler find
```



First create `packages.yaml` at `~/.spack/crusher/packages.yaml` with:

```yaml
  cmake:
    externals:
    - spec: cmake@3.17.0
      prefix: /usr
  all:
    providers:
      mpi: [cray-mpich]
  hdf5:
    externals:
    - spec: hdf5@1.12.2+mpi+shared+hl
      prefix: /opt/cray/pe/hdf5-parallel/1.12.1.5/gnu/9.1
    buildable: False
  cray-mpich:
    externals:
    - spec: cray-mpich@8.1.16
      modules: [cray-mpich/8.1.16, libfabric/1.15.0.0, craype-accel-amd-gfx90a, rocm/5.1.0]
    buildable: false
```

After that create `compilers.yaml` at `~/.spack/crusher/cray/compilers.yaml` with:

```yaml
compilers:
- compiler:
    spec: gcc@12.1.0
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
    - gcc/12.1.0
    - cray-mpich/8.1.16
    - craype-accel-amd-gfx90a
    - rocm/5.1.0
    environment:
      set:
        PE_MPICH_GTL_DIR_amd_gfx90a: "-L/opt/cray/pe/mpich/8.1.16/gtl/lib"
        PE_MPICH_GTL_LIBS_amd_gfx90a: "-lmpi_gtl_hsa"
```

And now spack should work.  On your next login, just call `use_build` to reload spack.

For the longer version see the guide on [configuring spack]({% link _guides/spack.markdown %})

# What makes this machine special?

1. Crusher's module system seems to be more picky than most needing a rocm and craype-accel to be present for most uses.  We provide these.  There are also some magic environment variables that the [OLCF docs said to add to the environment](https://github.com/olcf/olcf-user-docs/blob/master/systems/crusher_quick_start_guide.rst#1-compiling-with-the-cray-compiler-wrappers-cc-or-cc).
2. We use Cray's provided MPI and HDF5 to get the most oout of the platform.
3. We load a GNU compiler from a module because it seems to work most reliably
4. Crusher shares a home filesystem with other machines like `Summit`  these
   machines are completely different hardware wise and use different module
   systems.  The load function loads a copy of spack specifically for Crusher and uses
   a separate spark instance for other machines.  We use spack's `SPACK_USER_CONFIG_PATH` 
   to keep these cleanly separate.

# Changelog

+ 2022-10-26 created this document

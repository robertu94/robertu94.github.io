---
title: "Shortcut Guide for Configuring Spack for a New HPC System"
layout: post
date: 2022-07-19
---

# Setting up spack

The way that I use spack, there are 6 major steps to configuring spack:

1. Determine what system compiler, python, and MPI you will use
2. Telling spack how to find your compiler
3. Telling spack find major system dependencies such as MPI and OpenSSL as external dependencies
4. Configuring preferred providers for virtual dependencies and target architectures
5. Configuring spack to use a binary cache if it will matter
6. Setting up a shell shortcut for loading spack

## What system dependencies to use

Spack does a pretty good job "living off the land" using what ever dependencies you may need.
There are a few packages that benefit from just using the versions provided by your system
administrator typically your compilers, python (used to invoke spack; not the one you intend to use), 
MPI, and OpenSSL.

Compilers and Python are hard dependencies of spack, and it can't be used without them.  You
probably want to grab a somewhat recent compiler if it is available to you.  Spack can install
compilers for you, but they often take a long time to compile so reusing a prebuilt compiler if
possible is really nice.

MPI is special both because it often has to be paired with a specific compiler version to work
correctly, but also because MPI implementations has so many variants and options, it can be
difficult to configure correctly.  Using the system MPI hopefully ensures you get the right one.

OpenSSL is also special because spack itself needs a working OpenSSL to do many thing involving
downloading packages, and using a non-standard OpenSSL will break commands like `curl` and `git`.
You can work around this,  but it is often best to just use the system version of this package

## Configuring the spack compiler

If a module is needed for your compiler load that first.

After that, Spack's built-in `spack compiler find` command does most of what you will want.  However
there is one nuance is that won't correctly determine what modules it should load.  

If you determined you need a compiler provided by a module, you need to tell spack about that now
using the `module` entry in spack.


##  Configuring Major Dependencies 

If a module is required for your MPI module, load that first.

After that Spack's built-in `spack external find $spack_name_for_mpi_version` will do what you want
for MPI.  Likewise `spack external find openssl` will handle OpenSSL.

If you determined you need a MPI provided by a module, you need to tell spack about that now
using the `module` entry in spack.

## Configuring Preferred Variants and Targets

Some hardware will have hardware optimized libraries or prefered configurations.  Set these now in
the `all` packages variants section of `package.yaml`.

On heterogeneous clusters, setting `target=` to your common CPU hardware architecture can vastly
simplify deployment at modest performance cost.  Alternatively, provide a list of architectures to
cross compile as needed.

## Configuring spack to use a binary cache

Some systems (mainly LTS Ubuntu) have binary caches pre-built for spack that can vastly improve
install times for common packages builtin in common ways.  For Ubuntu 18.04 this works wonders to
decrease build times:

```bash
spack mirror add binary_mirror  https://binaries.spack.io/releases/v0.18
spack buildcache keys --install --trust
```

The other popular cache is e4s which supports a newer ubuntu LTS release, and some other distros
provided you are willing to build your own compiler.

```bash
spack mirror add E4S https://cache.e4s.io
spack buildcache keys --install --trust
```

## Setting up a shell shortcut

I like to have a single command to load spack and any MPI or compiler modules that I may need which
I often call use build.


# Updating Spack

I generally recommend rebuilding your spack envirionments whenever you update spack's major version
or whenever there is a major change to your HPC system (new modules for core dependencies, new OS
version, new hardware).  Because with spack environments re-building a specific environment is easy,
I often do this by `rm -rf spack` and re-building from scratch.

I find that more incremental updates can be more buggy than they are worth.

# Changelog

+ 2022-07-19 created this document

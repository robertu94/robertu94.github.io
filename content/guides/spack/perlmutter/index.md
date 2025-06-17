---
title: "Spack on Perlmutter"
layout: post
date: 2024-07-11
summary: "configure spack for NERSC Perlmutter"
---

# tl;dr

```
module load spack

git clone https://github.com/robertu94/spack_packages robertu94_packages
spack repo add ./robertu94_packages
```

# What makes this machine special?

+ the team at NERSC works [hard to maintain an up to date and customized spack
  environment](https://docs.nersc.gov/development/build-tools/spack).  Unless
  you have a need for something special use theirs

For the longer version see the guide on [configuring spack]({% link _guides/spack.markdown %})

# Changelog

+ 2024-07-12 created this document

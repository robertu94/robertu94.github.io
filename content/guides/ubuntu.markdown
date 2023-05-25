---
title: "Spack on Ubuntu 20.04"
layout: post
date: 2023-05-25
---

Spack installations can be really slow on some platforms, however, there are pre-built packages for ubuntu 20.04

```bash
sudo add-apt-repository ppa:ubuntu-toolchain-r/test
sudo apt update
apt install gcc-11
spack mirror add spack-build-cache-develop https://binaries.spack.io/develop
spack buildcache keys --install --trust
```

And now you have spack pre-compiled goodness for your packages!

You can see the [spack cache index](https://cache.spack.io/tag/develop/) for details for what packages are pre-built for which platforms.

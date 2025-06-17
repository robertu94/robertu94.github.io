---
title: "Updating LibPressio with Spack"
layout: post
date: 2022-09-13
summary: "how can you update your copy of libpressio via spack?"
---

#tl;dr

```bash
# set NEW_VERSION to the desired version
cd $SPACK_ROOT
git pull 
cd $(spack repo list | grep robertu94 | sed -E 's/robertu94[[:space:]]+//') && git pull
spack install libpressio-tools ^libpressio${NEW_VERSION}
spack load libpressio-tools ^libpressio${NEW_VERSION}
```

# `libpressio` is now Mainline

LibPressio is now in the mainline version of spack (as of commit `da6aeaad44e434da5563d32f2fa9900de362b2ed`, October 17, 2022). You no longer need to add `robertu94_packages` unless you need a development version. You can either `spack repo rm robertu94`, or the next pull of `robertu94_packages` will include a dummy package to refer back to the builtin version.

You can now update like so (without `robertu94_packages`) 

```
cd $SPACK_ROOT
git pull
spack install libpressio-tools ^libpressio${NEW_VERSION}
spack load libpressio-tools ^libpressio${NEW_VERSION}
```

# the longer version

Updating LibPressio with spack generally has several steps:

1. update your spack install `git pull $SPACK_ROOT`
  + if your HPC system has updated (i.e. after system-wide maintenance) you might need to adjust the modules loaded for your compiler, MPI, or other critical external packages.  See the guides for the latest guides on the systems that I use.
  + Be sure to check the spack release notes for other configuration changes that might be needed
2. update your `robertu94_packages` with `cd $(spack repo list | grep robertu94 | sed -E 's/robertu94[[:space:]]+//') && git pull`
  + This may not be necessary for many users after [LibPressio is merged into upstream Spack](https://github.com/spack/spack/pull/32630).  Hopefully in Fall 2022.  Users working on development versions of these packages will still want to use the 3rd party repository
  + After LibPressio is merged into upstream spack.  Users may want to `spack repo remove robertu94` to prefer using the stable versions in upstream spack.
3. Spack install your new version.  If you passed variants to your install command, be sure to include them again here.  A good place to start is `spack install libpressio-tools ^ libpressio+sz`
4. Spack load the built libraries.
  + this can be done via the hash of the built package (which is robust to new versions being built)
  + It can also be done via `spack load libpressio-tools`.  The later may error if a new version is added.  If you get an error regarding multiple versions, you can uninstall one of the older versions with `spack uninstall $HASH` where `$HASH` is the hash of the older version or by requesting the specific version.
  + You can list available versions and their configuration with `spack find -lvd --loaded`

## Changelog

- 19 October 2022 -- libpressio has been merged in upstream spack and no longer needs robertu94_packages in most cases.

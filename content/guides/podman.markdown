# For Windows

```bash
choco.exe install podman
podman machine init
podman machine start
```


# For MacOS

```sh
# install brew
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# use brew to install podman and qemu
brew install podman qemu

# configure podman to have a linux vm
podman machine init
podman machine start
```

You may also want to run an `x86_64` container in which case you will need the `--platform linux/amd64` flag

# For Linux

## Ubuntu

```bash
apt update
apt install podman
```

## Fedora

```bash
dnf install podman
```


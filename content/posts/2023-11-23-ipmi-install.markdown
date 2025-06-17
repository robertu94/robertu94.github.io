---
layout: post
title:  "Installing My Server Fully Remotely"
date:   "2023-11-23 12:17:00 -0500"
tags: 
- server administration
---

I run a small tower server in my house to provide services that I use for
software development, recently CentOS-8-Stream reached end of life.
Since this server distribution doesn't support in-place updates, updating
requires reinstalling with a new version of the CentOS-9-Stream.  This post
documents the challenges that I hit along the way.

# Challenge 1: My server is older than all of my monitors

I purchased my server used during the pandemic. While my server has serial line
and VGA outputs, however after my wife and I moved, none of our remaining
monitors support either of these inputs. So, how am I going to connect to the
server to see the settings in the BIOS in order to perform the installation.
IPMI to the rescue. For those who don't know, IPMI is a remote management
protocol that connects to a special piece of hardware installed in many
enterprise grade servers.  In my Dell server, IPMI is banded iDRAC, but works
the same way.

First we need to install and configure ipmi on the server

```bash
# interactive shell for IPMI
sudo dnf install ipmitool openipmi

# interactive shell for IPMI
sudo ipmitool shell
```

Next we need to configure ipmi for remote access on the sever itself

```bash
ipmi_channelid=1
ipmi_userid=1
ipmi_ipaddr=192.168.1.120

sudo ipmitool lan set $ipmi_channelid ipsrc static
sudo ipmitool lan set $ipmi_channelid ipaddr $ipmi_ipaddr
sudo ipmitool lan set $ipmi_channelid netmask 255.255.255.0
sudo ipmitool lan set $ipmi_channelid defgw 192.168.1.1
sudo ipmitool lan set $ipmi_channelid arp respond on
sudo ipmitool lan set $ipmi_channelid access on
sudo ipmitool lan print 1

sudo ipmitool user set name $ipmi_userid root
sudo ipmitool user set password $ipmi_userid

#privilege 4 is admin privileges need for things like power control and console access
sudo ipmitool channel setaccess $ipmi_channelid $ipmi_userid link=on ipmi=on callin=on privilege=4
sudo ipmitool user enable $ipmi_userid
sudo ipmitool user list

sudo ipmitool lan set $ipmi_channelid auth USER MD5
```

Now we can acesss ipmi from the over network:

```bash
ipmitool -I lanplus -H $ipmi_ipaddr -U $ipmiuser shell

# floppy is the boot device used for any USB on this system
chassis bootdev floppy
chassis power cycle
sol activate
```

However, my linux ISO doesn't configure the serial port for installation so we
need to modify grub so that the serial console is configured for the install,
and we can then access the actual installation media over VNC

```grub
#Installing from a serial console, start a VNC server to run the grahical install
# add this to the end of the kernel command line
console=tty0 console=ttyS0,115200 inst.vnc
```

And finally we can install the server over VNC which works as normal.

# Challenge 2: Re-configuring Tailscale

I use tailscale for remote management of my server and so things like backups work outside of the house.
When I did this, I set this up last, but in hindsight it should have been one of the first ones to redo
because I want all the services to be accessible over tailscale which only happens if the `tailscale0` tunnel
exists when the services bind.  However, I don't want to connect yet until I re-setup the home directories
when I configure ZFS

```bash
dnf config-manager --add-repo https://pkgs.tailscale.com/stable/centos/9/tailscale.repo
dnf install tailscale
sysetmctl enable --now tailscaled
tailscale up
# edit machine name in tailscale so "magic-dns" works
firewall-cmd --zone=public --add-interface=tailscale0
systemctl restart sshd
```

# Challenge 3: Re-configuring Samba

Samba comes next after Tailscale because the permissions and packages for samba need to be installed
so that the ZFS user shares are made public when ZFS comes back on line.

```bash
dnf install -y samba samba-client
systemctl enable --now smb nmb

#add and enable the samba user (different from the Linux user)
firewall-cmd --permanent --zone=public --add-service=samba
firewall-cmd --zone=public --add-service=samba
setsebool -P samba_enable_home_dirs

# setup of users appears below
```
# Challenge 4: Reconnecting my ZFS array and recreating users

ZFS is where all the user data is stored.  Now I just need to reload it.

```bash
dnf install https://zfsonlinux.org/epel/zfs-release-2-3$(rpm --eval "%{dist}").noarcupdate
dnf install -y epel-release
dnf install -y kernel-devel
dnf install -y zfs
modprobe zfs
zpool import tank
# edit /etc/passwd to point the user home directories on /tank
usermod $USER -d /tank/$USER

# re-add the other service account users with the old UID/GIDs
groupadd plex -g 1003
useradd plex -u 1003 -g plex

#finish setting up SAMBA users because I think this needs the home directories
smbpasswd -a $USER
smbpasswd -e $USER
```

# Challenge 5: Reconfiguring LibVirt

I have a few odd VMs on the server and libvirt/cockpit machine is how I manage them.

```bash
dnf install -y libvirt cockpit-machines
systemctl enable --now libvirt.socket
```

# Challenge 6: Restart services

The remaining services I use rely on podman.  Because I am lazy, I have a
folder called `docker` in my home directory.  In this are sub directories that
contain scripts called `up.sh` that download the container and re-setup the
service and set appropriate firewall rules.

```bash
dnf install vim podman-docker
systemctl start podman.socket
for i in docker/*
do
    cd $i
    ./up.sh
    cd ../..
done
```

Hope you learned something!

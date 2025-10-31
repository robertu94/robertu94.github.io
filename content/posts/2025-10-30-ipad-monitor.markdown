---
layout: post
title:  "Using my iPad as a Second Monitor with KDE Plasma"
date:   "2025-10-30 10:58:14 -0500"
tags: 
- plasma
- ipad
- display
---

When traveling it is sometimes helpful to have access to a second monitor.
An iPad does a passable job for this when your traveling and just need a little more screen real-estate.


```console
krfb-virtualmonitor --name WirelessDisplay --resolution 2420x1668 --password "$PASSWORD" --port 5900
```

Then connect to the VNC server using an iPad app client.

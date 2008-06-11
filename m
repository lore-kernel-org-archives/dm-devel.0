From: Adam Hamsik <haaaad@gmail.com>
Subject: NetBSD libdevmapper port
Date: Wed, 11 Jun 2008 15:57:49 +0200
Message-ID: <7F5B52C7-1511-49C8-B81A-D4D58E6B12F3@gmail.com>
Mime-Version: 1.0 (Apple Message framework v924)
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit
Return-path: <bounces-tech-kern-owner-netbsd-tech-kern=m.gmane.org@NetBSD.org>
Sender: tech-kern-owner@NetBSD.org
To: dm-devel@redhat.com
Cc: tech-kern@netbsd.org
List-Id: dm-devel.ids

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Hi,

*** Please keep me on CC when you replying from dm-devel list I'm not  
currently subscribed there. ***

My name is Adam Hamsik and this summer I'm working on GSOC project  
Write and improve LVM driver. As my task I have rewritten (We can't  
include GPL software into NetBSD kernel therefore I have rewritten it  
from scratch)dm like driver for NetBSD and ported libdevmapper +  
lvm2tools to NetBSD. There are some small differences between
Linux and NetBSD such as:

a) NetBSD doesn't use proc filesystem like linux does.

b) NetBSD has 2 types of devices(when we talk about disk devices) raw  
and block.
   raw device is char device which allow users directly from  
device(without buffer cache).

After the first implementation of dm-driver my mentor suggested to  
rewrite/clean dm-ioctl interface to be more NetBSD-like. I have  
implemented new interface based on proplib library [1] it is based on  
work
made by apple [2]. I have added 3 files to libdevmapper

include/netbsd/netbsd-dm.h -> file shared between kernel driver and  
libdevmapper.
lib/ioctl/libdm_netbsd.c   -> file with external functions for parsing  
native NetBSD proplist dictionaries to
			      libdevmapper dm_ioctl structure.

lib/ioctl/libdm-nbsd-iface.c -> this is copied/changed libdm-iface.c I  
found that number of NetBSD specific 					changes is bigger than I can  
easily #ifdef them, therefore I have added new
				NetBSD interface file.

I have created patch against latest release of libdevmapper, it would  
be great if we will be able to manage
commiting of this patch to libdevmapper main repo. My patch is  
currently not ready to commit, it needs major cleanup, but I thought  
that it would be good to let dm developers know about my effort and  
show my work to them.

My patch is located here [3], I have uploaded patch against lvm2tools,  
too. But it is patch against 2.02.28.
Because there were quite massive changes to lvm2tools in latest  
releases I will report lvm2tools again and
merge my changes with latest lvm release.

There is also my BSD licensed device-mapper driver which is located  
here [5].

Any suggestions, comments are welcome.


[1] http://netbsd.gw.com/cgi-bin/man-cgi/man?proplib+3+NetBSD-current
[2] http://developer.apple.com/documentation/Darwin/Reference/ManPages/man5/plist.5.html
[3] http://www.netbsd.org/~haad/libdevmapper_netbsd.diff
[4] http://www.netbsd.org/~haad/lvm2_netbsd.diff
[5] http://www.netbsd.org/~haad/dm20080610.tar.bz2

Regards

Adam.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (Darwin)

iD8DBQFIT9nelIxPgX3Go0MRAmU5AJ4+HgffqYCUAfotrS2IsyE9Wjth9ACgmd20
XcqvpqhmlgBy7/rlzdptjTM=
=W1/N
-----END PGP SIGNATURE-----

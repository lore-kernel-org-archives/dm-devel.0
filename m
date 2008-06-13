From: Mikulas Patocka <mpatocka@redhat.com>
Subject: Re: NetBSD libdevmapper port
Date: Fri, 13 Jun 2008 12:51:48 -0400 (EDT)
Message-ID: <Pine.LNX.4.64.0806131236500.32455@engineering.redhat.com>
References: <7F5B52C7-1511-49C8-B81A-D4D58E6B12F3@gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <7F5B52C7-1511-49C8-B81A-D4D58E6B12F3@gmail.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Adam Hamsik <haaaad@gmail.com>
Cc: dm-devel@redhat.com, tech-kern@netbsd.org
List-Id: dm-devel.ids

Hi

If you are rewriting it --- have you somehow thought about avoiding 
suspend?

A big source of problems in Linux is, that when you suspend a device, you 
can do only a limited set of calls --- basically, you must avoid anything 
that could possibly wait for I/O or allocate memory --- or you might end 
up waiting for the suspended device and deadlock. And I know still about 3 
places in kernel that have this error possibility.

A Linux LVM does something like: suspend old table, write to disk with 
direct i/o, resume new table. I'd suggest that you invent some method how 
to batch these operations into single syscall --- or you run into a 
several years of deadlock problems on NetBSD --- basically, on Linux, we 
have to preallocate a stack and heap (so that running LVM process won't 
cause a page fault --- the question --- how to do it portably on all 
NetBSD architectures?), mlock the process, make sure that we don't open 
files or write anything to terminal while suspended, make sure that the 
ioctl syscall doesn't allocate anything (currently false, it won't 
deadlock but it could randomly fail), make sure that O_DIRECT write 
syscall doesn't allocate anything or wait for other I/O (currently it 
false, there is a deadlock possibility) ... etc.

--- if you port lvm2 as it is, you'll have to audit (and maybe rewrite) 
many parts of NetBSD kernel for not waiting for I/O. If you do it badly, 
you'll get deadlocks.

This suspend thing was a big misdesign and if you are writing it from 
scratch, try to avoid it.

Mikulas

> -----BEGIN PGP SIGNED MESSAGE-----
> Hash: SHA1
>
> Hi,
>
> *** Please keep me on CC when you replying from dm-devel list I'm not 
> currently subscribed there. ***
>
> My name is Adam Hamsik and this summer I'm working on GSOC project Write and 
> improve LVM driver. As my task I have rewritten (We can't include GPL 
> software into NetBSD kernel therefore I have rewritten it from scratch)dm 
> like driver for NetBSD and ported libdevmapper + lvm2tools to NetBSD. There 
> are some small differences between
> Linux and NetBSD such as:
>
> a) NetBSD doesn't use proc filesystem like linux does.
>
> b) NetBSD has 2 types of devices(when we talk about disk devices) raw and 
> block.
> raw device is char device which allow users directly from device(without 
> buffer cache).
>
> After the first implementation of dm-driver my mentor suggested to 
> rewrite/clean dm-ioctl interface to be more NetBSD-like. I have implemented 
> new interface based on proplib library [1] it is based on work
> made by apple [2]. I have added 3 files to libdevmapper
>
> include/netbsd/netbsd-dm.h -> file shared between kernel driver and 
> libdevmapper.
> lib/ioctl/libdm_netbsd.c   -> file with external functions for parsing native 
> NetBSD proplist dictionaries to
> 			      libdevmapper dm_ioctl structure.
>
> lib/ioctl/libdm-nbsd-iface.c -> this is copied/changed libdm-iface.c I found 
> that number of NetBSD specific 					changes is 
> bigger than I can easily #ifdef them, therefore I have added new
> 				NetBSD interface file.
>
> I have created patch against latest release of libdevmapper, it would be 
> great if we will be able to manage
> commiting of this patch to libdevmapper main repo. My patch is currently not 
> ready to commit, it needs major cleanup, but I thought that it would be good 
> to let dm developers know about my effort and show my work to them.
>
> My patch is located here [3], I have uploaded patch against lvm2tools, too. 
> But it is patch against 2.02.28.
> Because there were quite massive changes to lvm2tools in latest releases I 
> will report lvm2tools again and
> merge my changes with latest lvm release.
>
> There is also my BSD licensed device-mapper driver which is located here [5].
>
> Any suggestions, comments are welcome.
>
>
> [1] http://netbsd.gw.com/cgi-bin/man-cgi/man?proplib+3+NetBSD-current
> [2] 
> http://developer.apple.com/documentation/Darwin/Reference/ManPages/man5/plist.5.html
> [3] http://www.netbsd.org/~haad/libdevmapper_netbsd.diff
> [4] http://www.netbsd.org/~haad/lvm2_netbsd.diff
> [5] http://www.netbsd.org/~haad/dm20080610.tar.bz2
>
> Regards
>
> Adam.
>
> -----BEGIN PGP SIGNATURE-----
> Version: GnuPG v1.4.7 (Darwin)
>
> iD8DBQFIT9nelIxPgX3Go0MRAmU5AJ4+HgffqYCUAfotrS2IsyE9Wjth9ACgmd20
> XcqvpqhmlgBy7/rlzdptjTM=
> =W1/N
> -----END PGP SIGNATURE-----
>
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel

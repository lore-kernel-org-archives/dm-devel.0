From: Ron Peterson <rpeterso@mtholyoke.edu>
Subject: kpartx and udev problem
Date: Tue, 3 Jun 2008 17:57:43 -0400
Message-ID: <20080603215743.GA6113@localhost.localdomain>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com
List-Id: dm-devel.ids

Hi,

I am having trouble getting kpartx to run reliably from udev.  My config
files look like:
________________________________________________________________________
/etc/udev/rules.d/z60_multipath.rules:

RUN+="socket:/org/kernel/dm/multipath_event"

________________________________________________________________________
/etc/udev/rules.d/z60_kpartx.rules:

KERNEL!="dm-*", GOTO="kpartx_end"
ACTION=="remove", GOTO="kpartx_end"
ACTION=="modify", GOTO="kpartx_end"

ACTION=="add", \
    SUBSYSTEM=="block", \
    KERNEL=="dm-*", \
    PROGRAM="/sbin/devmap_name %M %m", \
    RUN+="/sbin/kpartx -a /dev/mapper/%c"

LABEL="kpartx_end"

##

When I run 'multipath', my /dev/mapper directory looks something like:

brw-rw---- 1 root disk   253, 22 2008-06-03 12:21 db1
brw-rw---- 1 root disk   253, 26 2008-06-03 12:21 db1p1
brw-rw---- 1 root disk   253,  1 2008-06-03 12:21 db2
brw-rw---- 1 root disk   253,  3 2008-06-03 12:21 db3
brw-rw---- 1 root disk   253,  4 2008-06-03 12:21 db4
brw-rw---- 1 root disk   253, 13 2008-06-03 12:21 f3a00
brw-rw---- 1 root disk   253, 14 2008-06-03 12:21 f3a01
etc...

All of these devices have one or more partitions; i.e. there should be a
db2p1, and a db3p1, and so on.

As you can see, /some/ of my partitions are showing up, but others do not.

If I run kpartx manually, it works; e.g.

1110# kpartx -a /dev/mapper/db2

1111# ll /dev/mapper/db2*
brw-rw---- 1 root disk 253,  1 2008-06-03 12:21 /dev/mapper/db2
brw-rw---- 1 root disk 253, 33 2008-06-03 12:29 /dev/mapper/db2p1

I'm running multipath-tools version 0.4.8 on debian etch, running my own
kernel, which at the moment is 2.6.25.4, but I've experienced the same
trouble on other kernel versions.

Interestingly, on kernel 2.6.23.16 as it happens, I was able to make
this work by wrapping kpartx in a little script called my_kpartx.sh like
this:

#!/bin/sh
(
/bin/sleep 1
/sbin/kpartx $1 $2
) &

Then, in my z60_kpartx.rules file, I called /sbin/my_kpartx rather than
/sbin/kpartx.  This doesn't work in 2.6.25.4 though.

So that's my sad tale of woe.  Any suggestions that might cheer me up?

-- 
Ron Peterson
Network & Systems Manager
Mount Holyoke College
http://www.mtholyoke.edu/~rpeterso
-
I wish my computer would do what I want it to do - not what I tell it to do.

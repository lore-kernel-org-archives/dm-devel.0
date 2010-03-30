From: Martin Schwenke <martin@meltin.net>
Subject: RHEL 5.4 multipath doesn't handle virtio block devices
Date: Tue, 30 Mar 2010 12:16:06 +1100
Message-ID: <20100330121606.54b4a50c@martins.ozlabs.org>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
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

[Repost since subscribing - post from 2010-03-23 never made it...]

multipath in RHEL 5.4 doesn't handle virtio block devices.  It excludes
them because they use a sysfs bus that is not recognised.

Here's a patch that seems to fix this:

diff -r -u multipath-tools-0.4.7.rhel5.16.orig/libmultipath/discovery.c multipath-tools-0.4.7.rhel5.16/libmultipath/discovery.c
--- multipath-tools-0.4.7.rhel5.16.orig/libmultipath/discovery.c	2009-04-21 10:05:22.000000000 +1000
+++ multipath-tools-0.4.7.rhel5.16/libmultipath/discovery.c	2010-03-22 10:17:36.000000000 +1100
@@ -486,8 +486,6 @@
 		pp->bus = SYSFS_BUS_CCW;
 	else if (!strncmp(sdev->bus, "cciss", 5)) 
 		pp->bus = SYSFS_BUS_CCISS;
-	else
-		return 1;
 
 	sysfs_close_device(sdev);
 


The problem occurs because on line 490 of libmultipath/discovery.c
sysfs_get_bus() returns 1 (failure) if the bus type is not recognised.
The function should just fall through and return 0 (success), leaving
pp->bus set to the default value SYSFS_BUS_UNDEF.

This can be confirmed by noting that SYSFS_BUS_IDE is only ever used
once in the code (i.e. when pp->bus is set to SYSFS_BUS_IDE in
sysfs_get_bus()).  This shows that although there is no special case
code for SYSFS_BUS_IDE the rest of code works fine.  Similarly,
without a special case for SYSFS_BUS_UNDEF the rest of the code will
work fine.

To complicate the analysis very slightly, sysfs_pathinfo() does have a
special case for SYSFS_BUS_UNDEF.  However, it could be removed
because it simply returns 0 and this is the default return value of
sysfs_pathinfo()...

A quick scan of the current upstream multipath code in git seems to
suggest that it copes fine with unknown sysfs bus types and behaves as I
describe above.  In fact, the code no longer seems to have a special
case for SYSFS_BUS_IDE, which seems sensible.

I've tested the patch above on a KVM guest with virtio block devices
and it appears to work just fine.  Given that IDE (apparently) works
and the code has no special handling for it suggests that the change
should be backward compatible.  However, I don't have various pieces of
hardware handy to test with.

I'm happy to post a description of how to reproduce this if anyone is
interested.  It basically involves writing a unique ID at the beginning
each disk image, telling libvirt to create 2 devices pointing at each
image and then using a script for getuid_callout that reads the unique
IDs.  Hence, we're able to simulate multiple paths on virtio block
devices.

peace & happiness,
martin

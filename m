From: Luciano Chavez <lnx1138@us.ibm.com>
Subject: Activation of paths fail if SCSI rev string is not
	retrieved
Date: Wed, 29 Nov 2006 21:05:32 -0600
Message-ID: <1164855933.6825.0.camel@localhost>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="=-+GK+rNuDHbYw9y6ST0qh"
Return-path: <dm-devel-bounces@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids


--=-+GK+rNuDHbYw9y6ST0qh
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

I debugged a problem reported with an IBM POWER5 570 system using an
LPAR with two VIOS. Both VIOS see one LUN exported from a DS4300. The
VSCSI devices for the MPIO are /dev/sdc and /dev/sdd. There are also a
couple of other VDASD devices /dev/sda and /dev/sdb which are not
multipathed. The problem is that the multipath -v3 command discovers all
four devices but does not create and activate the multipath device
for /dev/sdc and /dev/sdd because of an issue with the sysfs information
retrieved for the /dev/sda and /dev/sdb devices. 

After running the multipath command through gdb, I see why even though
the sdc/sdd multipath are found,  it doesn't get far enough to activate
an mpath for them. We start back where multipath initiates path
discovery:

        if (path_discovery(pathvec, conf, di_flag))
                goto out;

In path_discovery() it appears to increment an accumulator any time that
store_pathinfo() ends up returning NULL. In effect, we get that twice.
Once for sda and once for sdb though sdc and sdd end up returning a
path.

Following store_pathinfo() down to scsi_sysfs_pathinfo() I see that an
eventual call to sys_get_rev() returns 1 for which the entire call chain
ends up returning in error. The sys_get_rev() basically is trying to get
some information from /sys/block/%s/device/rev. Here is what I see for
the devices in question:

[root@570-lpar10 libmultipath]# cat /sys/block/sda/device/rev

[root@570-lpar10 libmultipath]# cat /sys/block/sdb/device/rev

[root@570-lpar10 libmultipath]# cat /sys/block/sdc/device/rev
0001
[root@570-lpar10 libmultipath]# cat /sys/block/sdd/device/rev
0001

The logic in sysfs_get_rev(), or that is the generic
declare_sysfs_get_str macro that creates it, apperently doesn't like the
buffer to contain less than a certain number of characters for the
attribute. The two non-MP VDASD devices report an empty string for the
rev attribute.

The failure of sysfs_get_rev() to retrieve a rev of a minimal length in
turn makes the accumulator returned from path_discovery() never allow
the rest of the multipath configuration (such as creating the dm
devices) to ever get done even though the two interested paths did get
discovered successfully.

I realize that sda and sdb in this case won't produce a multipath device
since they aren't worthy but the rev being too short or empty seems to
be fatal to the whole discovery process when it doesn't seem all that
critical. I produced a simple patch to allow scsi_sysfs_pathinfo() to
use an empty string rather than return an error if a scsi rev string was
not obtained. This allows path discovery process to continue rather than
aborting activation later on just for this particular case. With the
patch, even though sda and sdb do get ignored, the sdc/sdd paths are
configured. The only places in the code I actually see the rev used is
for display purposes so I believe the change is low risk.

This problem was originally reported on the multipath-tools version
supplied with RHEL 4 U4 but I believe the mainline source would still
have this problem. I've attached the patch done against the
multipath-tools-0.4.7 version for your evaluation.

regards,
-- 
Luciano Chavez <lnx1138@us.ibm.com>
IBM

--=-+GK+rNuDHbYw9y6ST0qh
Content-Disposition: attachment; filename=mp-tools-scsi-rev.patch
Content-Type: text/x-patch; name=mp-tools-scsi-rev.patch; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

--- multipath-tools-0.4.7/libmultipath/discovery.c.orig	2006-11-28 10:14:01.000000000 -0600
+++ multipath-tools-0.4.7/libmultipath/discovery.c	2006-11-28 10:43:29.000000000 -0600
@@ -433,7 +433,7 @@
 
 	if (sysfs_get_rev(sysfs_path, pp->dev,
 			  pp->rev, SCSI_REV_SIZE))
-		return 1;
+		pp->rev[0] = '\0';
 
 	condlog(3, "%s: rev = %s", pp->dev, pp->rev);
 

--=-+GK+rNuDHbYw9y6ST0qh
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--=-+GK+rNuDHbYw9y6ST0qh--

From: Guido Guenther <agx@sigxcpu.org>
Subject: dm-ioctl on amd64 with 32bit userspace
Date: Mon, 17 Sep 2007 18:57:26 +0200
Message-ID: <20070917165726.GA11958@bogon.ms20.nix>
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
To: Alasdair G Kergon <agk@redhat.com>
Cc: Andrew Morton <akpm@osdl.org>, dm-devel@redhat.com
List-Id: dm-devel.ids

Hi,

using something like:

dmsetup message <mpath> 0 fail_if_no_path

on a 32 bit dmsetup with a amd64 kernel currently fails with:
 "Invalid target message parameters."

since the structure padding is 8 bytes and so we're looking at a 4 byte
to high address in target_message() - this also affects dev_rename() and
dev_set_geometry(). The attached patch works around the problem but
doesn't look like a proper fix. But since all the 32bit to 64bit ioctl
conversion in device mapper seems a bit strange, I'm not sure where to
fix this properly.

The bad thing about this is that multipath failover after a trespas on
such a system won't work (among other things). This at least has been
broken since 2.6.18 (I doubt it ever worked) and is still broken in
2.6.23-rc6-git7. With this patch, failover after a trespas and device
renaming works as expected.
Cheers,
 -- Guido

Signed-off-by: Guido Guenther <agx@sigxcpu.org>

--- aa-amd64-smp/drivers/md/dm-ioctl.c	2007-09-17 14:51:10.000000000 +0000
+++ linux-2.6.22/drivers/md/dm-ioctl.c	2007-07-08 23:32:17.000000000 +0000
@@ -700,7 +700,7 @@
 	int r;
 	char *new_name = (char *) param + param->data_start;
 
-	if (new_name < (char *) (param + 1) ||
+	if (new_name < (char *) ((void*)(param + 1) - 4) ||
 	    invalid_str(new_name, (void *) param + param_size)) {
 		DMWARN("Invalid new logical volume name supplied.");
 		return -EINVAL;
@@ -726,7 +726,7 @@
 	if (!md)
 		return -ENXIO;
 
-	if (geostr < (char *) (param + 1) ||
+	if (geostr < (char *) ((void *)(param + 1) - 4) ||
 	    invalid_str(geostr, (void *) param + param_size)) {
 		DMWARN("Invalid geometry supplied.");
 		goto out;
@@ -1233,7 +1233,7 @@
 	if (r)
 		goto out;
 
-	if (tmsg < (struct dm_target_msg *) (param + 1) ||
+	if (tmsg < (struct dm_target_msg *) ((void*)(param + 1) - 4) ||
 	    invalid_str(tmsg->message, (void *) param + param_size)) {
 		DMWARN("Invalid target message parameters.");
 		r = -EINVAL;

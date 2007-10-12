From: Alasdair G Kergon <agk@redhat.com>
Subject: [2.6.24 PATCH 02/25] dm io:ctl use constant struct size
Date: Fri, 12 Oct 2007 18:05:09 +0100
Message-ID: <20071012170509.GM24157@agk.fab.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1761576AbXJLRFy@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: dm-devel@redhat.com, linux-kernel@vger.kernel.org, Milan Broz <mbroz@redhat.com>, Guido Guenther <agx@sigxcpu.org>, Kevin Corry <kevcorry@us.ibm.com>, stable@kernel.org
List-Id: dm-devel.ids

From: Milan Broz <mbroz@redhat.com>

Make size of dm_ioctl struct always 312 bytes on all supported
architectures.

This change retains compatibility with already-compiled code because
it uses an embedded offset to locate the payload that follows the
structure.

On 64-bit architectures there is no change at all; on 32-bit
we are increasing the size of dm-ioctl from 308 to 312 bytes.

Currently with 32-bit userspace / 64-bit kernel on x86_64
some ioctls (including rename, message) are incorrectly rejected
by the comparison against 'param + 1'.  This breaks userspace
lvrename and multipath 'fail_if_no_path' changes, for example.

(BTW Device-mapper uses its own versioning and ignores the ioctl
size bits.  Only the generic ioctl compat code on mixed arches
checks them, and that will continue to accept both sizes for now,
but we intend to list 308 as deprecated and eventually remove it.)

Signed-off-by: Milan Broz <mbroz@redhat.com>
Signed-off-by: Alasdair G Kergon <agk@redhat.com>
Cc: Guido Guenther <agx@sigxcpu.org>
Cc: Kevin Corry <kevcorry@us.ibm.com>
Cc: stable@kernel.org

---
 drivers/md/dm-ioctl.c    |    6 +++---
 include/linux/dm-ioctl.h |    5 +++--
 2 files changed, 6 insertions(+), 5 deletions(-)

Index: linux-2.6.23/drivers/md/dm-ioctl.c
===================================================================
--- linux-2.6.23.orig/drivers/md/dm-ioctl.c	2007-10-12 13:15:21.000000000 +0100
+++ linux-2.6.23/drivers/md/dm-ioctl.c	2007-10-12 13:15:29.000000000 +0100
@@ -700,7 +700,7 @@ static int dev_rename(struct dm_ioctl *p
 	int r;
 	char *new_name = (char *) param + param->data_start;
 
-	if (new_name < (char *) (param + 1) ||
+	if (new_name < (char *) param->data ||
 	    invalid_str(new_name, (void *) param + param_size)) {
 		DMWARN("Invalid new logical volume name supplied.");
 		return -EINVAL;
@@ -726,7 +726,7 @@ static int dev_set_geometry(struct dm_io
 	if (!md)
 		return -ENXIO;
 
-	if (geostr < (char *) (param + 1) ||
+	if (geostr < (char *) param->data ||
 	    invalid_str(geostr, (void *) param + param_size)) {
 		DMWARN("Invalid geometry supplied.");
 		goto out;
@@ -1233,7 +1233,7 @@ static int target_message(struct dm_ioct
 	if (r)
 		goto out;
 
-	if (tmsg < (struct dm_target_msg *) (param + 1) ||
+	if (tmsg < (struct dm_target_msg *) param->data ||
 	    invalid_str(tmsg->message, (void *) param + param_size)) {
 		DMWARN("Invalid target message parameters.");
 		r = -EINVAL;
Index: linux-2.6.23/include/linux/dm-ioctl.h
===================================================================
--- linux-2.6.23.orig/include/linux/dm-ioctl.h	2007-10-12 13:15:21.000000000 +0100
+++ linux-2.6.23/include/linux/dm-ioctl.h	2007-10-12 13:15:29.000000000 +0100
@@ -131,6 +131,7 @@ struct dm_ioctl {
 	char name[DM_NAME_LEN];	/* device name */
 	char uuid[DM_UUID_LEN];	/* unique identifier for
 				 * the block device */
+	char data[7];		/* padding or data */
 };
 
 /*
@@ -285,9 +286,9 @@ typedef char ioctl_struct[308];
 #define DM_DEV_SET_GEOMETRY	_IOWR(DM_IOCTL, DM_DEV_SET_GEOMETRY_CMD, struct dm_ioctl)
 
 #define DM_VERSION_MAJOR	4
-#define DM_VERSION_MINOR	11
+#define DM_VERSION_MINOR	12
 #define DM_VERSION_PATCHLEVEL	0
-#define DM_VERSION_EXTRA	"-ioctl (2006-10-12)"
+#define DM_VERSION_EXTRA	"-ioctl (2007-10-02)"
 
 /* Status bits */
 #define DM_READONLY_FLAG	(1 << 0) /* In/Out */

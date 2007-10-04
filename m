From: Alasdair G Kergon <agk@redhat.com>
Subject: Re: Re: dm-ioctl on amd64 with 32bit userspace
Date: Thu, 4 Oct 2007 18:28:24 +0100
Message-ID: <20071004172824.GV18444@agk.fab.redhat.com>
References: <20070917165726.GA11958@bogon.ms20.nix>
	<20070920153210.GP18444@agk.fab.redhat.com>
	<20070920184641.GA5869@bogon.ms20.nix>
	<20070929132754.GA19089@bogon.ms20.nix>
	<20071002010519.GB18444@agk.fab.redhat.com>
	<20071002071647.GA11183@bogon.ms20.nix>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20071002071647.GA11183@bogon.ms20.nix>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Guido Guenther <agx@sigxcpu.org>
Cc: Andrew Morton <akpm@osdl.org>, dm-devel@redhat.com, Kevin Corry <kevcorry@us.ibm.com>
List-Id: dm-devel.ids

Here's the latest - hopefully final - incarnation of the patch.

Alasdair.


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

Index: linux-2.6.23-rc8/drivers/md/dm-ioctl.c
===================================================================
--- linux-2.6.23-rc8.orig/drivers/md/dm-ioctl.c	2007-10-04 17:24:00.000000000 +0100
+++ linux-2.6.23-rc8/drivers/md/dm-ioctl.c	2007-10-04 17:24:02.000000000 +0100
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
Index: linux-2.6.23-rc8/include/linux/dm-ioctl.h
===================================================================
--- linux-2.6.23-rc8.orig/include/linux/dm-ioctl.h	2007-10-04 17:24:00.000000000 +0100
+++ linux-2.6.23-rc8/include/linux/dm-ioctl.h	2007-10-04 17:24:02.000000000 +0100
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

From: Milan Broz <mbroz@redhat.com>
Subject: [PATCH 3/3] dm ioctl: add data secure (bufer wipe) flag
Date: Thu,  3 Feb 2011 01:08:16 +0100
Message-ID: <1296691696-23722-3-git-send-email-mbroz@redhat.com>
References: <1296691696-23722-1-git-send-email-mbroz@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1296691696-23722-1-git-send-email-mbroz@redhat.com>
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
Cc: Milan Broz <mbroz@redhat.com>
List-Id: dm-devel.ids

Add DM_SECURE_DATA_FLAG which userspace can use to control
that all allocated buffers for dm-ioctl are wiped
immediatelly after use.

The user buffer is wipes as well (we do not want to keep
and return sensitive data back to userspace if flag is set).

Wiping is useful mainly for cryptsetup to control that key
is present in memory only on defined places and only
for time needed.

(For crypt, key can be present in table during load ot table
status, wait and message command).

Signed-off-by: Milan Broz <mbroz@redhat.com>
---
 drivers/md/dm-ioctl.c    |   10 ++++++++++
 include/linux/dm-ioctl.h |   12 +++++++++---
 2 files changed, 19 insertions(+), 3 deletions(-)

diff --git a/drivers/md/dm-ioctl.c b/drivers/md/dm-ioctl.c
index 189c7ab..9284c38 100644
--- a/drivers/md/dm-ioctl.c
+++ b/drivers/md/dm-ioctl.c
@@ -1518,9 +1518,16 @@ static int copy_params(struct dm_ioctl __user *user, struct dm_ioctl **param)
 	if (copy_from_user(dmi, user, tmp.data_size))
 		goto fail;
 
+	/* Wipe the user buffer so we do not return it to userspace */
+	if ((tmp.flags & DM_SECURE_DATA_FLAG) &&
+	    clear_user(user, tmp.data_size))
+		goto fail;
+
 	*param = dmi;
 	return 0;
 fail:
+	if (tmp.flags & DM_SECURE_DATA_FLAG)
+		memset(dmi, 0, tmp.data_size);
 	vfree(dmi);
 	return -EFAULT;
 }
@@ -1621,6 +1628,9 @@ static int ctl_ioctl(uint command, struct dm_ioctl __user *user)
 	if (!r && copy_to_user(user, param, param->data_size))
 		r = -EFAULT;
 out:
+	if (param->flags & DM_SECURE_DATA_FLAG)
+		memset(param, 0, param_size);
+
 	vfree(param);
 	return r;
 }
diff --git a/include/linux/dm-ioctl.h b/include/linux/dm-ioctl.h
index 78bbf47..c314198 100644
--- a/include/linux/dm-ioctl.h
+++ b/include/linux/dm-ioctl.h
@@ -267,9 +267,9 @@ enum {
 #define DM_DEV_SET_GEOMETRY	_IOWR(DM_IOCTL, DM_DEV_SET_GEOMETRY_CMD, struct dm_ioctl)
 
 #define DM_VERSION_MAJOR	4
-#define DM_VERSION_MINOR	19
-#define DM_VERSION_PATCHLEVEL	1
-#define DM_VERSION_EXTRA	"-ioctl (2011-01-07)"
+#define DM_VERSION_MINOR	20
+#define DM_VERSION_PATCHLEVEL	0
+#define DM_VERSION_EXTRA	"-ioctl (2011-02-02)"
 
 /* Status bits */
 #define DM_READONLY_FLAG	(1 << 0) /* In/Out */
@@ -328,4 +328,10 @@ enum {
  */
 #define DM_UUID_FLAG			(1 << 14) /* In */
 
+/*
+ * If set, all buffers are wiped after use. Used when sending
+ * or requesting sensitive data like crypt key.
+ */
+#define DM_SECURE_DATA_FLAG		(1 << 15) /* In */
+
 #endif				/* _LINUX_DM_IOCTL_H */
-- 
1.7.2.3

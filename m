From: okozina@redhat.com
Subject: [RFC PATCH 3/4] Adds support for security checks in the
	linear target
Date: Wed,  2 May 2012 21:13:52 +0200
Message-ID: <1335986033-15236-4-git-send-email-okozina@redhat.com>
References: <1335986033-15236-1-git-send-email-okozina@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1335986033-15236-1-git-send-email-okozina@redhat.com>
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
Cc: Ondrej Kozina <okozina@redhat.com>, mgrac@redhat.com, kas@fi.muni.cz
List-Id: dm-devel.ids

From: Ondrej Kozina <okozina@redhat.com>

Just a security check implementation for the linear target

---
 drivers/md/dm-linear.c |   49 +++++++++++++++++++++++++++++++++++++++++++++++-
 1 files changed, 48 insertions(+), 1 deletions(-)

diff --git a/drivers/md/dm-linear.c b/drivers/md/dm-linear.c
index 3639eea..68345ad 100644
--- a/drivers/md/dm-linear.c
+++ b/drivers/md/dm-linear.c
@@ -153,9 +153,55 @@ static int linear_iterate_devices(struct dm_target *ti,
 	return fn(ti, lc->dev, lc->start, ti->len, data);
 }
 
+/*
+ * This function checks wheter user has right to create the target with passed
+ * parameters.
+ *
+ * NOTE: Right now it checks access rights against dentry for device node.
+ * 	 There's problem with translation from major:minor to dentry (which one
+ * 	 of possibly many dentries?)
+ *
+ * 	 In the end, it should do checks against block device itself! But
+ * 	 we can't set security context for bdev->bd_inode because bdev
+ * 	 inodes do not support extended attributes.
+ */
+static int linear_security(struct dm_target *ti, unsigned int argc, char **argv)
+{
+	int perm = 0, r;
+	struct dentry *bdev_dentry;
+
+	if (argc < 1) {
+		ti->error = "dm-linear: Security check: invalid number of parameters";
+		return -EINVAL;
+	}
+
+	bdev_dentry = dm_lookup_bdev_dentry(argv[0]);
+
+	if (IS_ERR(bdev_dentry)) {
+		ti->error = "dm-linear: security_check: Couldn't get dentry for bdev";
+		r = PTR_ERR(bdev_dentry);
+		goto err;
+	}
+
+	/* FIXME: MAY_ACCESS, MAY_OPEN ?*/
+	if (dm_table_get_mode(ti->table) & FMODE_READ)
+		perm |= MAY_READ;
+	if (dm_table_get_mode(ti->table) & FMODE_WRITE)
+		perm |= MAY_WRITE;
+
+	r = inode_permission(bdev_dentry->d_inode, perm);
+
+	if (r)
+		ti->error = "dm-linear: Security check failed";
+
+	dput(bdev_dentry);
+err:
+	return r;
+}
+
 static struct target_type linear_target = {
 	.name   = "linear",
-	.version = {1, 1, 0},
+	.version = {1, 2, 0},
 	.module = THIS_MODULE,
 	.ctr    = linear_ctr,
 	.dtr    = linear_dtr,
@@ -164,6 +210,7 @@ static struct target_type linear_target = {
 	.ioctl  = linear_ioctl,
 	.merge  = linear_merge,
 	.iterate_devices = linear_iterate_devices,
+	.security = linear_security
 };
 
 int __init dm_linear_init(void)
-- 
1.7.8.5

From: okozina@redhat.com
Subject: [RFC PATCH 4/4] Adds support for security checks in the
	crypt target
Date: Wed,  2 May 2012 21:13:53 +0200
Message-ID: <1335986033-15236-5-git-send-email-okozina@redhat.com>
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

Just a security check implementation for the crypt target

---
 drivers/md/dm-crypt.c |   37 ++++++++++++++++++++++++++++++++++++-
 1 files changed, 36 insertions(+), 1 deletions(-)

diff --git a/drivers/md/dm-crypt.c b/drivers/md/dm-crypt.c
index 3f06df5..06e2018 100644
--- a/drivers/md/dm-crypt.c
+++ b/drivers/md/dm-crypt.c
@@ -28,6 +28,7 @@
 #include <crypto/algapi.h>
 
 #include <linux/device-mapper.h>
+#include "dm.h"
 
 #define DM_MSG_PREFIX "crypt"
 
@@ -1867,9 +1868,42 @@ static int crypt_iterate_devices(struct dm_target *ti,
 	return fn(ti, cc->dev, cc->start, ti->len, data);
 }
 
+static int crypt_security(struct dm_target *ti, unsigned int argc, char **argv)
+{
+	int perm = 0, r;
+	struct dentry *bdev_dentry;
+
+	if (argc < 4) {
+		ti->error = "dm-crypt: Security check: invalid number of parameters";
+		return -EINVAL;
+	}
+	bdev_dentry = dm_lookup_bdev_dentry(argv[3]);
+
+	if (IS_ERR(bdev_dentry)) {
+		ti->error = "dm-crypt: security_check: Couldn't get dentry for bdev";
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
+		ti->error = "dm-crypt: Security check failed";
+
+	dput(bdev_dentry);
+err:
+	return r;
+}
+
 static struct target_type crypt_target = {
 	.name   = "crypt",
-	.version = {1, 11, 0},
+	.version = {1, 12, 0},
 	.module = THIS_MODULE,
 	.ctr    = crypt_ctr,
 	.dtr    = crypt_dtr,
@@ -1881,6 +1915,7 @@ static struct target_type crypt_target = {
 	.message = crypt_message,
 	.merge  = crypt_merge,
 	.iterate_devices = crypt_iterate_devices,
+	.security = crypt_security
 };
 
 static int __init dm_crypt_init(void)
-- 
1.7.8.5

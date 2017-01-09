From: Andy Grover <agrover@redhat.com>
Subject: [PATCH 3/3] dm: Allow associated fd to be used for
	TABLE_STATUS
Date: Mon,  9 Jan 2017 10:20:40 -0800
Message-ID: <20170109182040.31337-4-agrover@redhat.com>
References: <20170109182040.31337-1-agrover@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20170109182040.31337-1-agrover@redhat.com>
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

Allows TABLE_STATUS to be used without specifying the dm device in the
ioctl, if it has previously been associated with a device.

Signed-off-by: Andy Grover <agrover@redhat.com>
---
 drivers/md/dm-ioctl.c | 25 ++++++++++++++++---------
 1 file changed, 16 insertions(+), 9 deletions(-)

diff --git a/drivers/md/dm-ioctl.c b/drivers/md/dm-ioctl.c
index c5fc53c..c4c47a6 100644
--- a/drivers/md/dm-ioctl.c
+++ b/drivers/md/dm-ioctl.c
@@ -1504,13 +1504,19 @@ static int table_deps(struct file *filp, struct dm_ioctl *param, size_t param_si
  */
 static int table_status(struct file *filp, struct dm_ioctl *param, size_t param_size)
 {
+	struct dm_file *priv = filp->private_data;
 	struct mapped_device *md;
 	struct dm_table *table;
 	int srcu_idx;
 
-	md = find_device(param);
-	if (!md)
-		return -ENXIO;
+	if (priv && priv->md) {
+		md = priv->md;
+		dm_get(md);
+	} else {
+		md = find_device(param);
+		if (!md)
+			return -ENXIO;
+	}
 
 	__dev_status(md, param);
 
@@ -1868,12 +1874,6 @@ static int ctl_ioctl(struct file *file, uint command, struct dm_ioctl __user *us
 	if (cmd == DM_VERSION_CMD)
 		return 0;
 
-	/*
-	 * Cannot use files that have been associated for most ioctls.
-	 * See dev_assoc_set().
-	 */
-	if (file->private_data)
-		return -EINVAL;
 
 	fn = lookup_ioctl(cmd, &ioctl_flags);
 	if (!fn) {
@@ -1882,6 +1882,13 @@ static int ctl_ioctl(struct file *file, uint command, struct dm_ioctl __user *us
 	}
 
 	/*
+	 * Cannot use files that have been associated for ioctls other than
+	 * VERSION and TABLE_STATUS.
+	 */
+	if (file->private_data && cmd != DM_TABLE_STATUS_CMD)
+		return -EINVAL;
+
+	/*
 	 * Copy the parameters into kernel space.
 	 */
 	r = copy_params(user, &param_kernel, ioctl_flags, &param, &param_flags);
-- 
2.9.3

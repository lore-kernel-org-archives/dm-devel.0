From: heinzm@redhat.com
Subject: [PATCH 1/2] md: add raid4/5/6 journal mode API (for
	dm-raid use)
Date: Wed, 22 Mar 2017 17:43:30 +0100
Message-ID: <20170322164331.20924-2-heinzm@redhat.com>
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
Cc: heinzm@redhat.com
List-Id: dm-devel.ids

From: Heinz Mauelshagen <heinzm@redhat.com>

Upstream commit 2ded370373a400c20cf0c6e941e724e61582a867
started the addition of "write-back" mode to MD (raid5-cache),
i.e. support write-back caching on the raid journal device.

In order to allow the dm-raid target to switch between
the available "write-through" and "write-back" modes,
provide new r5c_journal_mode_set() API.

Use the new API in existing r5c_journal_mode_store()

Signed-off-by: Heinz Mauelshagen <heinzm@redhat.com>
---
 drivers/md/raid5-cache.c | 62 ++++++++++++++++++++++++++----------------------
 drivers/md/raid5.h       | 11 +++++++++
 2 files changed, 45 insertions(+), 28 deletions(-)

diff --git a/drivers/md/raid5-cache.c b/drivers/md/raid5-cache.c
index 3f307be..218b6f3 100644
--- a/drivers/md/raid5-cache.c
+++ b/drivers/md/raid5-cache.c
@@ -53,16 +53,6 @@
  */
 #define R5L_POOL_SIZE	4
 
-/*
- * r5c journal modes of the array: write-back or write-through.
- * write-through mode has identical behavior as existing log only
- * implementation.
- */
-enum r5c_journal_mode {
-	R5C_JOURNAL_MODE_WRITE_THROUGH = 0,
-	R5C_JOURNAL_MODE_WRITE_BACK = 1,
-};
-
 static char *r5c_journal_mode_str[] = {"write-through",
 				       "write-back"};
 /*
@@ -2327,40 +2317,56 @@ static ssize_t r5c_journal_mode_show(struct mddev *mddev, char *page)
 	return ret;
 }
 
-static ssize_t r5c_journal_mode_store(struct mddev *mddev,
-				      const char *page, size_t length)
+/*
+ * Set journal cache mode on @mddev (external API initially needed by dm-raid).
+ *
+ * @mode as defined in 'enum r5c_journal_mode'.
+ *
+ */
+int r5c_journal_mode_set(struct mddev *mddev, int mode)
 {
 	struct r5conf *conf = mddev->private;
 	struct r5l_log *log = conf->log;
-	int val = -1, i;
-	int len = length;
 
 	if (!log)
 		return -ENODEV;
 
-	if (len && page[len - 1] == '\n')
-		len -= 1;
-	for (i = 0; i < ARRAY_SIZE(r5c_journal_mode_str); i++)
-		if (strlen(r5c_journal_mode_str[i]) == len &&
-		    strncmp(page, r5c_journal_mode_str[i], len) == 0) {
-			val = i;
-			break;
-		}
-	if (val < R5C_JOURNAL_MODE_WRITE_THROUGH ||
-	    val > R5C_JOURNAL_MODE_WRITE_BACK)
+	if (mode < R5C_JOURNAL_MODE_WRITE_THROUGH ||
+	    mode > R5C_JOURNAL_MODE_WRITE_BACK)
 		return -EINVAL;
 
 	if (raid5_calc_degraded(conf) > 0 &&
-	    val == R5C_JOURNAL_MODE_WRITE_BACK)
+	    mode == R5C_JOURNAL_MODE_WRITE_BACK)
 		return -EINVAL;
 
 	mddev_suspend(mddev);
-	conf->log->r5c_journal_mode = val;
+	conf->log->r5c_journal_mode = mode;
 	mddev_resume(mddev);
 
 	pr_debug("md/raid:%s: setting r5c cache mode to %d: %s\n",
-		 mdname(mddev), val, r5c_journal_mode_str[val]);
-	return length;
+		 mdname(mddev), mode, r5c_journal_mode_str[mode]);
+	return 0;
+}
+EXPORT_SYMBOL(r5c_journal_mode_set);
+
+static ssize_t r5c_journal_mode_store(struct mddev *mddev,
+				      const char *page, size_t length)
+{
+	int mode = ARRAY_SIZE(r5c_journal_mode_str);
+	size_t len = length;
+
+	if (len < 2)
+		return -EINVAL;
+
+	if (page[len - 1] == '\n')
+		len--;
+
+	while (mode--)
+		if (strlen(r5c_journal_mode_str[mode]) == len &&
+		    !strncmp(page, r5c_journal_mode_str[mode], len))
+			break;
+
+	return r5c_journal_mode_set(mddev, mode) ?: length;
 }
 
 struct md_sysfs_entry
diff --git a/drivers/md/raid5.h b/drivers/md/raid5.h
index 4bb27b9..ec8ca15 100644
--- a/drivers/md/raid5.h
+++ b/drivers/md/raid5.h
@@ -547,6 +547,16 @@ struct r5worker_group {
 	int stripes_cnt;
 };
 
+/*
+ * r5c journal modes of the array: write-back or write-through.
+ * write-through mode has identical behavior as existing log only
+ * implementation.
+ */
+enum r5c_journal_mode {
+	R5C_JOURNAL_MODE_WRITE_THROUGH = 0,
+	R5C_JOURNAL_MODE_WRITE_BACK = 1,
+};
+
 enum r5_cache_state {
 	R5_INACTIVE_BLOCKED,	/* release of inactive stripes blocked,
 				 * waiting for 25% to be free
@@ -795,4 +805,5 @@ extern void r5c_check_cached_full_stripe(struct r5conf *conf);
 extern struct md_sysfs_entry r5c_journal_mode;
 extern void r5c_update_on_rdev_error(struct mddev *mddev);
 extern bool r5c_big_stripe_cached(struct r5conf *conf, sector_t sect);
+extern int r5c_journal_mode_set(struct mddev *mddev, int journal_mode);
 #endif
-- 
2.9.3

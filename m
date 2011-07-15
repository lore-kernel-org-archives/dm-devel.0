From: Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH] dm table: fold __table_get_device into
	dm_get_device
Date: Fri, 15 Jul 2011 15:23:49 -0400
Message-ID: <1310757829-4076-1-git-send-email-snitzer@redhat.com>
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

There is no need for __table_get_device to be factored out.

Signed-off-by: Mike Snitzer <snitzer@redhat.com>
---
 drivers/md/dm-table.c |   42 ++++++++++++++++++------------------------
 1 files changed, 18 insertions(+), 24 deletions(-)

diff --git a/drivers/md/dm-table.c b/drivers/md/dm-table.c
index 15c9ff4..e966a40 100644
--- a/drivers/md/dm-table.c
+++ b/drivers/md/dm-table.c
@@ -451,13 +451,14 @@ static int upgrade_mode(struct dm_dev_internal *dd, fmode_t new_mode,
  * Add a device to the list, or just increment the usage count if
  * it's already present.
  */
-static int __table_get_device(struct dm_table *t, struct dm_target *ti,
-		      const char *path, fmode_t mode, struct dm_dev **result)
+int dm_get_device(struct dm_target *ti, const char *path, fmode_t mode,
+		  struct dm_dev **result)
 {
 	int r;
 	dev_t uninitialized_var(dev);
 	struct dm_dev_internal *dd;
 	unsigned int major, minor;
+	struct dm_table *t = ti->table;
 
 	BUG_ON(!t);
 
@@ -506,6 +507,21 @@ static int __table_get_device(struct dm_table *t, struct dm_target *ti,
 	return 0;
 }
 
+/*
+ * Decrement a devices use count and remove it if necessary.
+ */
+void dm_put_device(struct dm_target *ti, struct dm_dev *d)
+{
+	struct dm_dev_internal *dd = container_of(d, struct dm_dev_internal,
+						  dm_dev);
+
+	if (atomic_dec_and_test(&dd->count)) {
+		close_dev(dd, ti->table->md);
+		list_del(&dd->list);
+		kfree(dd);
+	}
+}
+
 int dm_set_device_limits(struct dm_target *ti, struct dm_dev *dev,
 			 sector_t start, sector_t len, void *data)
 {
@@ -542,28 +558,6 @@ int dm_set_device_limits(struct dm_target *ti, struct dm_dev *dev,
 }
 EXPORT_SYMBOL_GPL(dm_set_device_limits);
 
-int dm_get_device(struct dm_target *ti, const char *path, fmode_t mode,
-		  struct dm_dev **result)
-{
-	return __table_get_device(ti->table, ti, path, mode, result);
-}
-
-
-/*
- * Decrement a devices use count and remove it if necessary.
- */
-void dm_put_device(struct dm_target *ti, struct dm_dev *d)
-{
-	struct dm_dev_internal *dd = container_of(d, struct dm_dev_internal,
-						  dm_dev);
-
-	if (atomic_dec_and_test(&dd->count)) {
-		close_dev(dd, ti->table->md);
-		list_del(&dd->list);
-		kfree(dd);
-	}
-}
-
 /*
  * Checks to see if the target joins onto the end of the table.
  */
-- 
1.7.1

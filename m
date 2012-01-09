From: Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH] dm thin metadata: clarify __open_device
	functionality and fix callers
Date: Mon,  9 Jan 2012 15:33:08 -0500
Message-ID: <1326141188-2172-1-git-send-email-snitzer@redhat.com>
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
To: thornber@redhat.com
Cc: dm-devel@redhat.com, Mike Snitzer <snitzer@redhat.com>
List-Id: dm-devel.ids

The __open_device() error path of __create_thin() and __create_snap()
will call __close_device() even if td was not initialized by
__open_device().

Clearly define what callers should expect from __open_device()'s
return.

Also, remove redundant 'td->changed = 1' in __create_thin() --
__open_device() with create=1 will have set td->changed on successful
return.

Signed-off-by: Mike Snitzer <snitzer@redhat.com>
---
 drivers/md/dm-thin-metadata.c |   22 ++++++++++++++++++----
 1 files changed, 18 insertions(+), 4 deletions(-)

diff --git a/drivers/md/dm-thin-metadata.c b/drivers/md/dm-thin-metadata.c
index 59c4f04..28f98cb 100644
--- a/drivers/md/dm-thin-metadata.c
+++ b/drivers/md/dm-thin-metadata.c
@@ -789,6 +789,11 @@ int dm_pool_metadata_close(struct dm_pool_metadata *pmd)
 	return 0;
 }
 
+/*
+ * __open_device: lookup @td if already open, allocate @td on first open.
+ * on success, return @td with an incremented reference count.
+ * on failure, @td is not initialized.
+ */
 static int __open_device(struct dm_pool_metadata *pmd,
 			 dm_thin_id dev, int create,
 			 struct dm_thin_device **td)
@@ -803,6 +808,13 @@ static int __open_device(struct dm_pool_metadata *pmd,
 	 */
 	list_for_each_entry(td2, &pmd->thin_devices, list)
 		if (td2->id == dev) {
+			if (create) {
+				/*
+				 * inconsistency if looking to create
+				 * an already open device.
+				 */
+				return -EINVAL;
+			}
 			td2->open_count++;
 			*td = td2;
 			return 0;
@@ -817,6 +829,9 @@ static int __open_device(struct dm_pool_metadata *pmd,
 		if (r != -ENODATA || !create)
 			return r;
 
+		/*
+		 * Open is for device creation.
+		 */
 		changed = 1;
 		details_le.mapped_blocks = 0;
 		details_le.transaction_id = cpu_to_le64(pmd->trans_id);
@@ -882,12 +897,10 @@ static int __create_thin(struct dm_pool_metadata *pmd,
 
 	r = __open_device(pmd, dev, 1, &td);
 	if (r) {
-		__close_device(td);
 		dm_btree_remove(&pmd->tl_info, pmd->root, &key, &pmd->root);
 		dm_btree_del(&pmd->bl_info, dev_root);
 		return r;
 	}
-	td->changed = 1;
 	__close_device(td);
 
 	return r;
@@ -967,14 +980,15 @@ static int __create_snap(struct dm_pool_metadata *pmd,
 		goto bad;
 
 	r = __set_snapshot_details(pmd, td, origin, pmd->time);
-	if (r)
+	if (r) {
+		__close_device(td);
 		goto bad;
+	}
 
 	__close_device(td);
 	return 0;
 
 bad:
-	__close_device(td);
 	dm_btree_remove(&pmd->tl_info, pmd->root, &key, &pmd->root);
 	dm_btree_remove(&pmd->details_info, pmd->details_root,
 			&key, &pmd->details_root);
-- 
1.7.4.4

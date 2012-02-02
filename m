From: Joe Thornber <ejt@redhat.com>
Subject: [PATCH 11/11] [dm-thin] some tidy ups of the
	__open_device() error path (Mike Snitzer)
Date: Thu,  2 Feb 2012 16:39:14 +0000
Message-ID: <1328200754-13642-12-git-send-email-ejt@redhat.com>
References: <1328200754-13642-1-git-send-email-ejt@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1328200754-13642-1-git-send-email-ejt@redhat.com>
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
Cc: Joe Thornber <ejt@redhat.com>
List-Id: dm-devel.ids

---
 drivers/md/dm-thin-metadata.c |   22 ++++++++++++++++++----
 1 files changed, 18 insertions(+), 4 deletions(-)

diff --git a/drivers/md/dm-thin-metadata.c b/drivers/md/dm-thin-metadata.c
index 1aeef4e..0bc3033 100644
--- a/drivers/md/dm-thin-metadata.c
+++ b/drivers/md/dm-thin-metadata.c
@@ -790,6 +790,11 @@ int dm_pool_metadata_close(struct dm_pool_metadata *pmd)
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
@@ -804,6 +809,13 @@ static int __open_device(struct dm_pool_metadata *pmd,
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
@@ -818,6 +830,9 @@ static int __open_device(struct dm_pool_metadata *pmd,
 		if (r != -ENODATA || !create)
 			return r;
 
+		/*
+		 * Open is for device creation.
+		 */
 		changed = 1;
 		details_le.mapped_blocks = 0;
 		details_le.transaction_id = cpu_to_le64(pmd->trans_id);
@@ -883,12 +898,10 @@ static int __create_thin(struct dm_pool_metadata *pmd,
 
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
@@ -968,14 +981,15 @@ static int __create_snap(struct dm_pool_metadata *pmd,
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
1.7.5.4

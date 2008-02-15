From: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Subject: [PATCH] dm core: remove dead codes
Date: Fri, 15 Feb 2008 17:55:05 -0500 (EST)
Message-ID: <20080215.175505.34761653.k-ueda@ct.jp.nec.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com
Cc: j-nomura@ce.jp.nec.com, k-ueda@ct.jp.nec.com
List-Id: dm-devel.ids

Hi Alasdair,

This patch removes dead codes for the noflush suspend.
No functional change.

The dm_queue_flush(md, DM_WQ_FLUSH_ALL, NULL) in dm_suspend()
is never invoked because:
  - The 'goto flush_and_out' is same as 'goto out', because
    the 'goto flush_and_out' is called only when '!noflush'
  - If the 'r && noflush' is true, the interrupt check code above
    is invoked and 'goto out'

The DM_WQ_FLUSH_ALL type is used only in dm_suspend().
So no need any more.

Should be applied on top of 2.6.25-rc1.
Please review and apply.

Signed-off-by: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Signed-off-by: Jun'ichi Nomura <j-nomura@ce.jp.nec.com>
---
 drivers/md/dm.c |   14 +-------------
 1 files changed, 1 insertion(+), 13 deletions(-)

Index: 2.6.25-rc1/drivers/md/dm.c
===================================================================
--- 2.6.25-rc1.orig/drivers/md/dm.c
+++ 2.6.25-rc1/drivers/md/dm.c
@@ -76,7 +76,6 @@ union map_info *dm_get_mapinfo(struct bi
  */
 struct dm_wq_req {
 	enum {
-		DM_WQ_FLUSH_ALL,
 		DM_WQ_FLUSH_DEFERRED,
 	} type;
 	struct work_struct work;
@@ -1340,9 +1339,6 @@ static void dm_wq_work(struct work_struc
 
 	down_write(&md->io_lock);
 	switch (req->type) {
-	case DM_WQ_FLUSH_ALL:
-		__merge_pushback_list(md);
-		/* pass through */
 	case DM_WQ_FLUSH_DEFERRED:
 		__flush_deferred_io(md);
 		break;
@@ -1472,7 +1468,7 @@ int dm_suspend(struct mapped_device *md,
 		if (!md->suspended_bdev) {
 			DMWARN("bdget failed in dm_suspend");
 			r = -ENOMEM;
-			goto flush_and_out;
+			goto out;
 		}
 
 		/*
@@ -1523,14 +1519,6 @@ int dm_suspend(struct mapped_device *md,
 
 	set_bit(DMF_SUSPENDED, &md->flags);
 
-flush_and_out:
-	if (r && noflush)
-		/*
-		 * Because there may be already I/Os in the pushback list,
-		 * flush them before return.
-		 */
-		dm_queue_flush(md, DM_WQ_FLUSH_ALL, NULL);
-
 out:
 	if (r && md->suspended_bdev) {
 		bdput(md->suspended_bdev);

Thanks,
Kiyoshi Ueda

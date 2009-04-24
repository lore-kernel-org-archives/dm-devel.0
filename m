From: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Subject: [PATCH 4/7] dm core: don't set QUEUE_ORDERED_DRAIN for
 request-based dm
Date: Fri, 24 Apr 2009 17:14:43 +0900
Message-ID: <49F174F3.8010008@ct.jp.nec.com>
References: <49F17409.4060201@ct.jp.nec.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <49F17409.4060201@ct.jp.nec.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Alasdair Kergon <agk@redhat.com>
Cc: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

Request-based dm doesn't have barrier support yet.
So we need to set QUEUE_ORDERED_DRAIN only for bio-based dm.
Since the device type is decided at the first table loading time,
the flag set is deferred until then.


Signed-off-by: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Signed-off-by: Jun'ichi Nomura <j-nomura@ce.jp.nec.com>
Cc: Alasdair G Kergon <agk@redhat.com>
---
 drivers/md/dm-table.c |    5 +++++
 drivers/md/dm.c       |   11 ++++++++++-
 drivers/md/dm.h       |    1 +
 3 files changed, 16 insertions(+), 1 deletion(-)

Index: 2.6.30-rc3/drivers/md/dm-table.c
===================================================================
--- 2.6.30-rc3.orig/drivers/md/dm-table.c
+++ 2.6.30-rc3/drivers/md/dm-table.c
@@ -819,6 +819,11 @@ int dm_table_get_type(struct dm_table *t
 		DM_TYPE_BIO_BASED : DM_TYPE_REQUEST_BASED;
 }
 
+int dm_table_bio_based(struct dm_table *t)
+{
+	return dm_table_get_type(t) == DM_TYPE_BIO_BASED;
+}
+
 int dm_table_request_based(struct dm_table *t)
 {
 	return dm_table_get_type(t) == DM_TYPE_REQUEST_BASED;
Index: 2.6.30-rc3/drivers/md/dm.c
===================================================================
--- 2.6.30-rc3.orig/drivers/md/dm.c
+++ 2.6.30-rc3/drivers/md/dm.c
@@ -1779,7 +1779,6 @@ static struct mapped_device *alloc_dev(i
 	md->queue->backing_dev_info.congested_fn = dm_any_congested;
 	md->queue->backing_dev_info.congested_data = md;
 	blk_queue_make_request(md->queue, dm_request);
-	blk_queue_ordered(md->queue, QUEUE_ORDERED_DRAIN, NULL);
 	blk_queue_bounce_limit(md->queue, BLK_BOUNCE_ANY);
 	md->queue->unplug_fn = dm_unplug_all;
 	blk_queue_merge_bvec(md->queue, dm_merge_bvec);
@@ -2206,6 +2205,16 @@ int dm_swap_table(struct mapped_device *
 		goto out;
 	}
 
+	/*
+	 * It is enought that blk_queue_ordered() is called only once when
+	 * the first bio-based table is bound.
+	 *
+	 * This setting should be moved to alloc_dev() when request-based dm
+	 * supports barrier.
+	 */
+	if (!md->map && dm_table_bio_based(table))
+		blk_queue_ordered(md->queue, QUEUE_ORDERED_DRAIN, NULL);
+
 	__unbind(md);
 	r = __bind(md, table);
 
Index: 2.6.30-rc3/drivers/md/dm.h
===================================================================
--- 2.6.30-rc3.orig/drivers/md/dm.h
+++ 2.6.30-rc3/drivers/md/dm.h
@@ -58,6 +58,7 @@ int dm_table_any_congested(struct dm_tab
 int dm_table_any_busy_target(struct dm_table *t);
 int dm_table_set_type(struct dm_table *t);
 int dm_table_get_type(struct dm_table *t);
+int dm_table_bio_based(struct dm_table *t);
 int dm_table_request_based(struct dm_table *t);
 int dm_table_alloc_md_mempools(struct dm_table *t);
 void dm_table_free_md_mempools(struct dm_table *t);

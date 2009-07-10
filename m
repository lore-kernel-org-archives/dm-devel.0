From: Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH] dm: remove all 'next_ordered' work-arounds
Date: Fri, 10 Jul 2009 14:08:08 -0400
Message-ID: <1247249288-7704-1-git-send-email-snitzer@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
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
Cc: Jun'ichi Nomura <j-nomura@ce.jp.nec.com>, Kiyoshi Ueda <k-ueda@ct.jp.nec.com>, Mikulas Patocka <mpatocka@redhat.com>
List-Id: dm-devel.ids

bio-based DM was changed to work-around the previously misplaced
next_ordered check with this commit:
99360b4c18f7675b50d283301d46d755affe75fd

request-based DM does not yet support barriers but reacted to the above
bio-based DM change with this commit:
5d67aa2366ccb8257d103d0b43df855605c3c086

The above changes are no longer needed given Neil Brown's recent fix to
put the next_ordered check in the __make_request path:
db64f680ba4b5c56c4be59f0698000df89ff0281

This patch removes DM's bio-based vs request-based conditional setting
of next_ordered.  For bio-based DM the next_ordered check is no longer a
concern (as that check is now in the __make_request path).  For
request-based DM the default of QUEUE_ORDERED_NONE is appropriate.

Signed-off-by: Mike Snitzer <snitzer@redhat.com>
Cc: Mikulas Patocka <mpatocka@redhat.com>
Cc: Kiyoshi Ueda <k-ueda@ct.jp.nec.com> 
Cc: Jun'ichi Nomura <j-nomura@ce.jp.nec.com>
Cc: NeilBrown <neilb@suse.de>
---

diff --git a/drivers/md/dm-table.c b/drivers/md/dm-table.c
index 2cba557..5d16d06 100644
--- a/drivers/md/dm-table.c
+++ b/drivers/md/dm-table.c
@@ -830,11 +830,6 @@ unsigned dm_table_get_type(struct dm_table *t)
 	return t->type;
 }
 
-bool dm_table_bio_based(struct dm_table *t)
-{
-	return dm_table_get_type(t) == DM_TYPE_BIO_BASED;
-}
-
 bool dm_table_request_based(struct dm_table *t)
 {
 	return dm_table_get_type(t) == DM_TYPE_REQUEST_BASED;
diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index 9acd54a..8a311ea 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -2203,16 +2203,6 @@ int dm_swap_table(struct mapped_device *md, struct dm_table *table)
 		goto out;
 	}
 
-	/*
-	 * It is enought that blk_queue_ordered() is called only once when
-	 * the first bio-based table is bound.
-	 *
-	 * This setting should be moved to alloc_dev() when request-based dm
-	 * supports barrier.
-	 */
-	if (!md->map && dm_table_bio_based(table))
-		blk_queue_ordered(md->queue, QUEUE_ORDERED_DRAIN, NULL);
-
 	__unbind(md);
 	r = __bind(md, table, &limits);
 
diff --git a/drivers/md/dm.h b/drivers/md/dm.h
index 23278ae..a7663eb 100644
--- a/drivers/md/dm.h
+++ b/drivers/md/dm.h
@@ -61,7 +61,6 @@ int dm_table_any_congested(struct dm_table *t, int bdi_bits);
 int dm_table_any_busy_target(struct dm_table *t);
 int dm_table_set_type(struct dm_table *t);
 unsigned dm_table_get_type(struct dm_table *t);
-bool dm_table_bio_based(struct dm_table *t);
 bool dm_table_request_based(struct dm_table *t);
 int dm_table_alloc_md_mempools(struct dm_table *t);
 void dm_table_free_md_mempools(struct dm_table *t);

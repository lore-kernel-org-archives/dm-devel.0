From: Damien Le Moal <damien.lemoal@wdc.com>
Subject: [PATCH 1/2] dm zoned: Fix zone reclaim trigger
Date: Wed,  8 Jul 2020 09:20:22 +0900
Message-ID: <20200708002023.738147-2-damien.lemoal@wdc.com>
References: <20200708002023.738147-1-damien.lemoal@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20200708002023.738147-1-damien.lemoal@wdc.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com, Mike Snitzer <snitzer@redhat.com>
Cc: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>, Damien Le Moal <damien.lemoal@wdc.com>
List-Id: dm-devel.ids

Triggerring reclaim only based on the percentage of unmapped cache
zones can fail to detect cases where reclaim is needed, e.g. if the
target has only 2 or 3 cache zones and only one unmapped cache zone,
the percentage of free cache zone is higher than
DMZ_RECLAIM_LOW_UNMAP_ZONES (30%) and reclaim does not trigger.
This problem, combined with the fact that dmz_schedule_reclaim() is
called from dmz_handle_bio() without the map lock held leads to a race
between zone allocation and dmz_should_reclaim() result. Depending on
the workload applied, this race can lead to the write path forever
waiting for a free zone without reclaim being triggerred.

Fix this by moving dmz_schedule_reclaim() inside dmz_alloc_zone()
under the map lock, checking the need for zone reclaim whenever a new
data or buffer zone needs to be allocated.

Also fix dmz_reclaim_percentage() to always return 0 if the number of
unmapped cache (or random) zone is less than or equal to 1.

Suggested-by: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Signed-off-by: Damien Le Moal <damien.lemoal@wdc.com>
---
 drivers/md/dm-zoned-metadata.c |  9 ++++++++-
 drivers/md/dm-zoned-reclaim.c  |  2 ++
 drivers/md/dm-zoned-target.c   | 10 +---------
 3 files changed, 11 insertions(+), 10 deletions(-)

diff --git a/drivers/md/dm-zoned-metadata.c b/drivers/md/dm-zoned-metadata.c
index 5cf6f5f552e0..b298fefb022e 100644
--- a/drivers/md/dm-zoned-metadata.c
+++ b/drivers/md/dm-zoned-metadata.c
@@ -2217,8 +2217,15 @@ struct dm_zone *dmz_alloc_zone(struct dmz_metadata *zmd, unsigned int dev_idx,
 {
 	struct list_head *list;
 	struct dm_zone *zone;
-	int i = 0;
+	int i;
+
+	/* Schedule reclaim to ensure free zones are available */
+	if (!(flags & DMZ_ALLOC_RECLAIM)) {
+		for (i = 0; i < zmd->nr_devs; i++)
+			dmz_schedule_reclaim(zmd->dev[i].reclaim);
+	}
 
+	i = 0;
 again:
 	if (flags & DMZ_ALLOC_CACHE)
 		list = &zmd->unmap_cache_list;
diff --git a/drivers/md/dm-zoned-reclaim.c b/drivers/md/dm-zoned-reclaim.c
index dd1eebf6e50f..9c6e264465bc 100644
--- a/drivers/md/dm-zoned-reclaim.c
+++ b/drivers/md/dm-zoned-reclaim.c
@@ -456,6 +456,8 @@ static unsigned int dmz_reclaim_percentage(struct dmz_reclaim *zrc)
 		nr_zones = dmz_nr_rnd_zones(zmd, zrc->dev_idx);
 		nr_unmap = dmz_nr_unmap_rnd_zones(zmd, zrc->dev_idx);
 	}
+	if (nr_unmap <= 1)
+		return 0;
 	return nr_unmap * 100 / nr_zones;
 }
 
diff --git a/drivers/md/dm-zoned-target.c b/drivers/md/dm-zoned-target.c
index cf915009c306..42aa5139df7c 100644
--- a/drivers/md/dm-zoned-target.c
+++ b/drivers/md/dm-zoned-target.c
@@ -400,15 +400,7 @@ static void dmz_handle_bio(struct dmz_target *dmz, struct dm_chunk_work *cw,
 		dm_per_bio_data(bio, sizeof(struct dmz_bioctx));
 	struct dmz_metadata *zmd = dmz->metadata;
 	struct dm_zone *zone;
-	int i, ret;
-
-	/*
-	 * Write may trigger a zone allocation. So make sure the
-	 * allocation can succeed.
-	 */
-	if (bio_op(bio) == REQ_OP_WRITE)
-		for (i = 0; i < dmz->nr_ddevs; i++)
-			dmz_schedule_reclaim(dmz->dev[i].reclaim);
+	int ret;
 
 	dmz_lock_metadata(zmd);
 
-- 
2.26.2

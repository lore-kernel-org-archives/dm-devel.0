From: Dmitry Fomichev <dmitry.fomichev@wdc.com>
Subject: [PATCH 1/3] dm-zoned: improve error handling in reclaim
Date: Mon,  5 Aug 2019 18:06:23 -0700
Message-ID: <20190806010625.27503-2-dmitry.fomichev@wdc.com>
References: <20190806010625.27503-1-dmitry.fomichev@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20190806010625.27503-1-dmitry.fomichev@wdc.com>
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
Cc: Damien Le Moal <damien.lemoal@wdc.com>
List-Id: dm-devel.ids

There are several places in reclaim code where errors are not
propagated to the main function, dmz_reclaim(). This function
is responsible for unlocking zones that might be still locked
at the end of any failed reclaim iterations. As the result,
some device zones may be left permanently locked for reclaim,
degrading target's capability to reclaim zones.

This patch fixes these issues as follows -

Make sure that dmz_reclaim_buf(), dmz_reclaim_seq_data() and
dmz_reclaim_rnd_data() return error codes to the caller.

dmz_reclaim() function is renamed to dmz_do_reclaim() to avoid
clashing with "struct dmz_reclaim" and is modified to return the
error to the caller.

dmz_get_zone_for_reclaim() now returns an error instead of NULL
pointer and reclaim code checks for that error.

Error logging/debug messages are added where necessary.

Fixes: 3b1a94c88b79 ("dm zoned: drive-managed zoned block device target")
Cc: stable@vger.kernel.org
Signed-off-by: Dmitry Fomichev <dmitry.fomichev@wdc.com>
---
 drivers/md/dm-zoned-metadata.c |  4 ++--
 drivers/md/dm-zoned-reclaim.c  | 28 +++++++++++++++++++---------
 2 files changed, 21 insertions(+), 11 deletions(-)

diff --git a/drivers/md/dm-zoned-metadata.c b/drivers/md/dm-zoned-metadata.c
index ded4984d18c9..6b7fbbd735ef 100644
--- a/drivers/md/dm-zoned-metadata.c
+++ b/drivers/md/dm-zoned-metadata.c
@@ -1543,7 +1543,7 @@ static struct dm_zone *dmz_get_rnd_zone_for_reclaim(struct dmz_metadata *zmd)
 	struct dm_zone *zone;
 
 	if (list_empty(&zmd->map_rnd_list))
-		return NULL;
+		return ERR_PTR(-EBUSY);
 
 	list_for_each_entry(zone, &zmd->map_rnd_list, link) {
 		if (dmz_is_buf(zone))
@@ -1554,7 +1554,7 @@ static struct dm_zone *dmz_get_rnd_zone_for_reclaim(struct dmz_metadata *zmd)
 			return dzone;
 	}
 
-	return NULL;
+	return ERR_PTR(-EBUSY);
 }
 
 /*
diff --git a/drivers/md/dm-zoned-reclaim.c b/drivers/md/dm-zoned-reclaim.c
index 260e3598199e..26e34493a2db 100644
--- a/drivers/md/dm-zoned-reclaim.c
+++ b/drivers/md/dm-zoned-reclaim.c
@@ -216,7 +216,7 @@ static int dmz_reclaim_buf(struct dmz_reclaim *zrc, struct dm_zone *dzone)
 
 	dmz_unlock_flush(zmd);
 
-	return 0;
+	return ret;
 }
 
 /*
@@ -260,7 +260,7 @@ static int dmz_reclaim_seq_data(struct dmz_reclaim *zrc, struct dm_zone *dzone)
 
 	dmz_unlock_flush(zmd);
 
-	return 0;
+	return ret;
 }
 
 /*
@@ -313,7 +313,7 @@ static int dmz_reclaim_rnd_data(struct dmz_reclaim *zrc, struct dm_zone *dzone)
 
 	dmz_unlock_flush(zmd);
 
-	return 0;
+	return ret;
 }
 
 /*
@@ -335,7 +335,7 @@ static void dmz_reclaim_empty(struct dmz_reclaim *zrc, struct dm_zone *dzone)
 /*
  * Find a candidate zone for reclaim and process it.
  */
-static void dmz_reclaim(struct dmz_reclaim *zrc)
+static int dmz_do_reclaim(struct dmz_reclaim *zrc)
 {
 	struct dmz_metadata *zmd = zrc->metadata;
 	struct dm_zone *dzone;
@@ -345,8 +345,8 @@ static void dmz_reclaim(struct dmz_reclaim *zrc)
 
 	/* Get a data zone */
 	dzone = dmz_get_zone_for_reclaim(zmd);
-	if (!dzone)
-		return;
+	if (IS_ERR(dzone))
+		return PTR_ERR(dzone);
 
 	start = jiffies;
 
@@ -392,13 +392,20 @@ static void dmz_reclaim(struct dmz_reclaim *zrc)
 out:
 	if (ret) {
 		dmz_unlock_zone_reclaim(dzone);
-		return;
+		return ret;
 	}
 
-	(void) dmz_flush_metadata(zrc->metadata);
+	ret = dmz_flush_metadata(zrc->metadata);
+	if (ret) {
+		dmz_dev_debug(zrc->dev,
+			      "Metadata flush for zone %u failed, err %d\n",
+			      dmz_id(zmd, rzone), ret);
+		return ret;
+	}
 
 	dmz_dev_debug(zrc->dev, "Reclaimed zone %u in %u ms",
 		      dmz_id(zmd, rzone), jiffies_to_msecs(jiffies - start));
+	return 0;
 }
 
 /*
@@ -443,6 +450,7 @@ static void dmz_reclaim_work(struct work_struct *work)
 	struct dmz_metadata *zmd = zrc->metadata;
 	unsigned int nr_rnd, nr_unmap_rnd;
 	unsigned int p_unmap_rnd;
+	int ret;
 
 	if (!dmz_should_reclaim(zrc)) {
 		mod_delayed_work(zrc->wq, &zrc->work, DMZ_IDLE_PERIOD);
@@ -472,7 +480,9 @@ static void dmz_reclaim_work(struct work_struct *work)
 		      (dmz_target_idle(zrc) ? "Idle" : "Busy"),
 		      p_unmap_rnd, nr_unmap_rnd, nr_rnd);
 
-	dmz_reclaim(zrc);
+	ret = dmz_do_reclaim(zrc);
+	if (ret)
+		dmz_dev_debug(zrc->dev, "Reclaim error %d\n", ret);
 
 	dmz_schedule_reclaim(zrc);
 }
-- 
2.21.0

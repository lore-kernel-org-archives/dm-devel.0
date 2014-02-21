From: Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH for-dm-3.14-fixes 2/8] dm thin: set flag when
	over the metadata low watermark threshold
Date: Thu, 20 Feb 2014 21:55:59 -0500
Message-ID: <1392951365-9829-3-git-send-email-snitzer@redhat.com>
References: <1392951365-9829-1-git-send-email-snitzer@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1392951365-9829-1-git-send-email-snitzer@redhat.com>
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

The threshold boundary code in persistent-data/dm-space-map-metadata.c
was too racey and resulted in a flood of warnings and events.

Check the 'metadata_low_water_triggered' flag in metadata_low_callback()
before logging a warning and sending an event.

Signed-off-by: Mike Snitzer <snitzer@redhat.com>
---
 drivers/md/dm-thin.c                               | 11 ++++++++++-
 drivers/md/persistent-data/dm-space-map-metadata.c | 19 +------------------
 2 files changed, 11 insertions(+), 19 deletions(-)

diff --git a/drivers/md/dm-thin.c b/drivers/md/dm-thin.c
index 9facc6f..42d08eb 100644
--- a/drivers/md/dm-thin.c
+++ b/drivers/md/dm-thin.c
@@ -165,6 +165,7 @@ struct pool {
 
 	struct pool_features pf;
 	bool low_water_triggered:1;	/* A dm event has been sent */
+	bool metadata_low_water_triggered:1;
 
 	struct dm_bio_prison *prison;
 	struct dm_kcopyd_client *copier;
@@ -1824,6 +1825,7 @@ static struct pool *pool_create(struct mapped_device *pool_md,
 	INIT_LIST_HEAD(&pool->prepared_mappings);
 	INIT_LIST_HEAD(&pool->prepared_discards);
 	pool->low_water_triggered = false;
+	pool->metadata_low_water_triggered = false;
 	bio_list_init(&pool->retry_on_resume_list);
 
 	pool->shared_read_ds = dm_deferred_set_create();
@@ -1993,10 +1995,16 @@ static int parse_pool_features(struct dm_arg_set *as, struct pool_features *pf,
 static void metadata_low_callback(void *context)
 {
 	struct pool *pool = context;
+	unsigned long flags;
+
+	if (pool->metadata_low_water_triggered)
+		return;
 
 	DMWARN("%s: reached low water mark for metadata device: sending event.",
 	       dm_device_name(pool->pool_md));
-
+	spin_lock_irqsave(&pool->lock, flags);
+	pool->metadata_low_water_triggered = true;
+	spin_unlock_irqrestore(&pool->lock, flags);
 	dm_table_event(pool->ti->table);
 }
 
@@ -2350,6 +2358,7 @@ static void pool_resume(struct dm_target *ti)
 
 	spin_lock_irqsave(&pool->lock, flags);
 	pool->low_water_triggered = false;
+	pool->metadata_low_water_triggered = false;
 	__requeue_bios(pool);
 	spin_unlock_irqrestore(&pool->lock, flags);
 
diff --git a/drivers/md/persistent-data/dm-space-map-metadata.c b/drivers/md/persistent-data/dm-space-map-metadata.c
index 536782e..a0231d3 100644
--- a/drivers/md/persistent-data/dm-space-map-metadata.c
+++ b/drivers/md/persistent-data/dm-space-map-metadata.c
@@ -21,9 +21,7 @@
  */
 struct threshold {
 	bool threshold_set;
-	bool value_set;
 	dm_block_t threshold;
-	dm_block_t current_value;
 	dm_sm_threshold_fn fn;
 	void *context;
 };
@@ -31,7 +29,6 @@ struct threshold {
 static void threshold_init(struct threshold *t)
 {
 	t->threshold_set = false;
-	t->value_set = false;
 }
 
 static void set_threshold(struct threshold *t, dm_block_t value,
@@ -43,24 +40,10 @@ static void set_threshold(struct threshold *t, dm_block_t value,
 	t->context = context;
 }
 
-static bool below_threshold(struct threshold *t, dm_block_t value)
-{
-	return t->threshold_set && value <= t->threshold;
-}
-
-static bool threshold_already_triggered(struct threshold *t)
-{
-	return t->value_set && below_threshold(t, t->current_value);
-}
-
 static void check_threshold(struct threshold *t, dm_block_t value)
 {
-	if (below_threshold(t, value) &&
-	    !threshold_already_triggered(t))
+	if (t->threshold_set && value <= t->threshold)
 		t->fn(t->context);
-
-	t->value_set = true;
-	t->current_value = value;
 }
 
 /*----------------------------------------------------------------*/
-- 
1.8.3.1

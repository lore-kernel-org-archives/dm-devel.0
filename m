From: Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH] dm thin: commit pool's metadata on last close of
	thin device
Date: Wed, 16 May 2012 18:19:53 -0400
Message-ID: <1337206793-30658-1-git-send-email-snitzer@redhat.com>
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

Reinstate dm_flush_all and dm_table_flush_all.  dm_blk_close will
now trigger the .flush method of all targets within a table on the last
close of a DM device.

In the case of the thin target, the thin_flush method will commit the
backing pool's metadata.

Doing so avoids a deadlock that has been observed with the following
sequence (as can be triggered via "dmsetup remove_all"):
- IO is issued to a thin device, thin device is closed
- pool's metadata device is suspended before the pool is
- because the pool still has outstanding IO we deadlock because the
  pool's metadata device is suspended

Signed-off-by: Mike Snitzer <snitzer@redhat.com>
Cc: stable@vger.kernel.org
---
 drivers/md/dm-table.c |    9 +++++++++
 drivers/md/dm-thin.c  |   19 +++++++++++++++++++
 drivers/md/dm.c       |   20 +++++++++++++++++++-
 drivers/md/dm.h       |    1 +
 4 files changed, 48 insertions(+), 1 deletions(-)

diff --git a/drivers/md/dm-table.c b/drivers/md/dm-table.c
index 2e227fb..077fff8 100644
--- a/drivers/md/dm-table.c
+++ b/drivers/md/dm-table.c
@@ -1487,6 +1487,15 @@ int dm_table_resume_targets(struct dm_table *t)
 	return 0;
 }
 
+void dm_table_flush_all(struct dm_table *t)
+{
+	unsigned i;
+
+	for (i = 0; i < t->num_targets; i++)
+		if (t->targets[i].type->flush)
+			t->targets[i].type->flush(&t->targets[i]);
+}
+
 void dm_table_add_target_callbacks(struct dm_table *t, struct dm_target_callbacks *cb)
 {
 	list_add(&cb->list, &t->target_callbacks);
diff --git a/drivers/md/dm-thin.c b/drivers/md/dm-thin.c
index c514078..f64c7e6 100644
--- a/drivers/md/dm-thin.c
+++ b/drivers/md/dm-thin.c
@@ -2429,6 +2429,24 @@ static void thin_io_hints(struct dm_target *ti, struct queue_limits *limits)
 	set_discard_limits(pool, limits);
 }
 
+static void thin_flush(struct dm_target *ti)
+{
+	int r;
+	struct thin_c *tc = ti->private;
+	struct pool *pool = tc->pool;
+
+	/*
+	 * A bit heavy-handed but the only existing way to batch
+	 * metadata commits is to issue() a FLUSH bio -- but DM
+	 * doesn't allocate bios outside the DM core.
+	 */
+	r = dm_pool_commit_metadata(pool->pmd);
+	if (r < 0) {
+		DMERR("%s: dm_pool_commit_metadata() failed, error = %d",
+		      __func__, r);
+	}
+}
+
 static struct target_type thin_target = {
 	.name = "thin",
 	.version = {1, 1, 0},
@@ -2441,6 +2459,7 @@ static struct target_type thin_target = {
 	.status = thin_status,
 	.iterate_devices = thin_iterate_devices,
 	.io_hints = thin_io_hints,
+	.flush = thin_flush,
 };
 
 /*----------------------------------------------------------------*/
diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index 23a1a84..715ee57 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -487,6 +487,16 @@ out:
 	return md ? 0 : -ENXIO;
 }
 
+static void dm_flush_all(struct mapped_device *md)
+{
+	struct dm_table *t = dm_get_live_table(md);
+	
+	if (t) {
+		dm_table_flush_all(t);
+		dm_table_put(t);
+	}
+}
+
 static int dm_blk_close(struct gendisk *disk, fmode_t mode)
 {
 	struct mapped_device *md = disk->private_data;
@@ -494,10 +504,17 @@ static int dm_blk_close(struct gendisk *disk, fmode_t mode)
 	spin_lock(&_minor_lock);
 
 	atomic_dec(&md->open_count);
-	dm_put(md);
 
 	spin_unlock(&_minor_lock);
 
+	/*
+	 * Flush all targets on last close
+	 */
+	if (!dm_open_count(md))
+		dm_flush_all(md);
+
+	dm_put(md);	
+
 	return 0;
 }
 
@@ -2468,6 +2485,7 @@ void dm_destroy_immediate(struct mapped_device *md)
 void dm_put(struct mapped_device *md)
 {
 	atomic_dec(&md->holders);
+	smp_mb__after_atomic_dec();
 }
 EXPORT_SYMBOL_GPL(dm_put);
 
diff --git a/drivers/md/dm.h b/drivers/md/dm.h
index b7dacd5..82199a1 100644
--- a/drivers/md/dm.h
+++ b/drivers/md/dm.h
@@ -66,6 +66,7 @@ bool dm_table_supports_discards(struct dm_table *t);
 int dm_table_alloc_md_mempools(struct dm_table *t);
 void dm_table_free_md_mempools(struct dm_table *t);
 struct dm_md_mempools *dm_table_get_md_mempools(struct dm_table *t);
+void dm_table_flush_all(struct dm_table *t);
 
 int dm_queue_merge_is_compulsory(struct request_queue *q);
 
-- 
1.7.1

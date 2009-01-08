From: Milan Broz <mbroz@redhat.com>
Subject: [PATCH 1/4] dm-core: remove current partial barrier
	implementation
Date: Thu, 08 Jan 2009 17:13:12 +0100
Message-ID: <49662618.80600@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
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
To: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

Prepare for full barrier implementation - remove the simple one

Signed-off-by: Milan Broz <mbroz@redhat.com>

---
 drivers/md/dm-linear.c        |    1 -
 drivers/md/dm-table.c         |   19 -------------------
 drivers/md/dm.c               |   15 ++++++++++-----
 drivers/md/dm.h               |    1 -
 include/linux/device-mapper.h |    1 -
 5 files changed, 10 insertions(+), 27 deletions(-)

diff --git a/drivers/md/dm-linear.c b/drivers/md/dm-linear.c
index bfa107f..79fb53e 100644
--- a/drivers/md/dm-linear.c
+++ b/drivers/md/dm-linear.c
@@ -142,7 +142,6 @@ static struct target_type linear_target = {
 	.status = linear_status,
 	.ioctl  = linear_ioctl,
 	.merge  = linear_merge,
-	.features = DM_TARGET_SUPPORTS_BARRIERS,
 };
 
 int __init dm_linear_init(void)
diff --git a/drivers/md/dm-table.c b/drivers/md/dm-table.c
index 2fd66c3..d599143 100644
--- a/drivers/md/dm-table.c
+++ b/drivers/md/dm-table.c
@@ -52,8 +52,6 @@ struct dm_table {
 	sector_t *highs;
 	struct dm_target *targets;
 
-	unsigned barriers_supported:1;
-
 	/*
 	 * Indicates the rw permissions for the new logical
 	 * device.  This should be a combination of FMODE_READ
@@ -243,7 +241,6 @@ int dm_table_create(struct dm_table **result, fmode_t mode,
 
 	INIT_LIST_HEAD(&t->devices);
 	atomic_set(&t->holders, 0);
-	t->barriers_supported = 1;
 
 	if (!num_targets)
 		num_targets = KEYS_PER_NODE;
@@ -749,10 +746,6 @@ int dm_table_add_target(struct dm_table *t, const char *type,
 	/* FIXME: the plan is to combine high here and then have
 	 * the merge fn apply the target level restrictions. */
 	combine_restrictions_low(&t->limits, &tgt->limits);
-
-	if (!(tgt->type->features & DM_TARGET_SUPPORTS_BARRIERS))
-		t->barriers_supported = 0;
-
 	return 0;
 
  bad:
@@ -797,12 +790,6 @@ int dm_table_complete(struct dm_table *t)
 
 	check_for_valid_limits(&t->limits);
 
-	/*
-	 * We only support barriers if there is exactly one underlying device.
-	 */
-	if (!list_is_singular(&t->devices))
-		t->barriers_supported = 0;
-
 	/* how many indexes will the btree have ? */
 	leaf_nodes = dm_div_up(t->num_targets, KEYS_PER_NODE);
 	t->depth = 1 + int_log(leaf_nodes, CHILDREN_PER_NODE);
@@ -1017,12 +1004,6 @@ struct mapped_device *dm_table_get_md(struct dm_table *t)
 	return t->md;
 }
 
-int dm_table_barrier_ok(struct dm_table *t)
-{
-	return t->barriers_supported;
-}
-EXPORT_SYMBOL(dm_table_barrier_ok);
-
 EXPORT_SYMBOL(dm_vcalloc);
 EXPORT_SYMBOL(dm_get_device);
 EXPORT_SYMBOL(dm_put_device);
diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index 51ba1db..a9aa699 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -838,11 +838,7 @@ static int __split_bio(struct mapped_device *md, struct bio *bio)
 	ci.map = dm_get_table(md);
 	if (unlikely(!ci.map))
 		return -EIO;
-	if (unlikely(bio_barrier(bio) && !dm_table_barrier_ok(ci.map))) {
-		dm_table_put(ci.map);
-		bio_endio(bio, -EOPNOTSUPP);
-		return 0;
-	}
+
 	ci.md = md;
 	ci.bio = bio;
 	ci.io = alloc_io(md);
@@ -926,6 +922,15 @@ static int dm_request(struct request_queue *q, struct bio *bio)
 	struct mapped_device *md = q->queuedata;
 	int cpu;
 
+	/*
+	 * There is no use in forwarding any barrier request since we can't
+	 * guarantee it is (or can be) handled by the targets correctly.
+	 */
+	if (unlikely(bio_barrier(bio))) {
+		bio_endio(bio, -EOPNOTSUPP);
+		return 0;
+	}
+
 	down_read(&md->io_lock);
 
 	cpu = part_stat_lock();
diff --git a/drivers/md/dm.h b/drivers/md/dm.h
index 20194e0..7e1af9b 100644
--- a/drivers/md/dm.h
+++ b/drivers/md/dm.h
@@ -52,7 +52,6 @@ int dm_table_any_congested(struct dm_table *t, int bdi_bits);
  * To check the return value from dm_table_find_target().
  */
 #define dm_target_is_valid(t) ((t)->table)
-int dm_table_barrier_ok(struct dm_table *t);
 
 /*-----------------------------------------------------------------
  * A registry of target types.
diff --git a/include/linux/device-mapper.h b/include/linux/device-mapper.h
index 8209e08..27dfba2 100644
--- a/include/linux/device-mapper.h
+++ b/include/linux/device-mapper.h
@@ -116,7 +116,6 @@ void dm_put_device(struct dm_target *ti, struct dm_dev *d);
 /*
  * Target features
  */
-#define DM_TARGET_SUPPORTS_BARRIERS 0x00000001
 
 struct target_type {
 	uint64_t features;

From: Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH 12/14] barriers
Date: Mon, 23 Feb 2009 14:22:36 -0500 (EST)
Message-ID: <Pine.LNX.4.64.0902231422280.23293@hs20-bc2-1.build.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
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
List-Id: dm-devel.ids

From mbroz@redhat.com Thu Jan  8 11:14:02 2009
Date: Thu, 08 Jan 2009 17:13:12 +0100
From: Milan Broz <mbroz@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
To: device-mapper development <dm-devel@redhat.com>
Subject: [dm-devel] [PATCH 1/4] dm-core: remove current partial barrier implementation

Prepare for full barrier implementation - remove the simple one

Signed-off-by: Milan Broz <mbroz@redhat.com>

---
 drivers/md/dm-linear.c        |    1 -
 drivers/md/dm-table.c         |   19 -------------------
 drivers/md/dm.c               |   15 ++++++++++-----
 drivers/md/dm.h               |    1 -
 include/linux/device-mapper.h |    1 -
 5 files changed, 10 insertions(+), 27 deletions(-)

Index: linux-2.6.29-rc3-devel/drivers/md/dm-linear.c
===================================================================
--- linux-2.6.29-rc3-devel.orig/drivers/md/dm-linear.c	2009-02-05 05:33:47.000000000 +0100
+++ linux-2.6.29-rc3-devel/drivers/md/dm-linear.c	2009-02-05 05:33:52.000000000 +0100
@@ -142,7 +142,6 @@ static struct target_type linear_target 
 	.status = linear_status,
 	.ioctl  = linear_ioctl,
 	.merge  = linear_merge,
-	.features = DM_TARGET_SUPPORTS_BARRIERS,
 };
 
 int __init dm_linear_init(void)
Index: linux-2.6.29-rc3-devel/drivers/md/dm-table.c
===================================================================
--- linux-2.6.29-rc3-devel.orig/drivers/md/dm-table.c	2009-02-05 05:33:48.000000000 +0100
+++ linux-2.6.29-rc3-devel/drivers/md/dm-table.c	2009-02-05 05:33:52.000000000 +0100
@@ -52,8 +52,6 @@ struct dm_table {
 	sector_t *highs;
 	struct dm_target *targets;
 
-	unsigned barriers_supported:1;
-
 	/*
 	 * Indicates the rw permissions for the new logical
 	 * device.  This should be a combination of FMODE_READ
@@ -240,7 +238,6 @@ int dm_table_create(struct dm_table **re
 
 	INIT_LIST_HEAD(&t->devices);
 	atomic_set(&t->holders, 0);
-	t->barriers_supported = 1;
 
 	if (!num_targets)
 		num_targets = KEYS_PER_NODE;
@@ -741,10 +738,6 @@ int dm_table_add_target(struct dm_table 
 	/* FIXME: the plan is to combine high here and then have
 	 * the merge fn apply the target level restrictions. */
 	combine_restrictions_low(&t->limits, &tgt->limits);
-
-	if (!(tgt->type->features & DM_TARGET_SUPPORTS_BARRIERS))
-		t->barriers_supported = 0;
-
 	return 0;
 
  bad:
@@ -789,12 +782,6 @@ int dm_table_complete(struct dm_table *t
 
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
@@ -1008,12 +995,6 @@ struct mapped_device *dm_table_get_md(st
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
Index: linux-2.6.29-rc3-devel/drivers/md/dm.c
===================================================================
--- linux-2.6.29-rc3-devel.orig/drivers/md/dm.c	2009-02-05 05:33:51.000000000 +0100
+++ linux-2.6.29-rc3-devel/drivers/md/dm.c	2009-02-05 05:33:52.000000000 +0100
@@ -831,11 +831,7 @@ static void __process_bio(struct mapped_
 		bio_io_error(bio);
 		return;
 	}
-	if (unlikely(bio_barrier(bio) && !dm_table_barrier_ok(ci.map))) {
-		dm_table_put(ci.map);
-		bio_endio(bio, -EOPNOTSUPP);
-		return;
-	}
+
 	ci.md = md;
 	ci.bio = bio;
 	ci.io = alloc_io(md);
@@ -917,6 +913,15 @@ static int dm_request(struct request_que
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
Index: linux-2.6.29-rc3-devel/drivers/md/dm.h
===================================================================
--- linux-2.6.29-rc3-devel.orig/drivers/md/dm.h	2009-02-05 05:33:48.000000000 +0100
+++ linux-2.6.29-rc3-devel/drivers/md/dm.h	2009-02-05 05:33:52.000000000 +0100
@@ -52,7 +52,6 @@ int dm_table_any_congested(struct dm_tab
  * To check the return value from dm_table_find_target().
  */
 #define dm_target_is_valid(t) ((t)->table)
-int dm_table_barrier_ok(struct dm_table *t);
 
 /*-----------------------------------------------------------------
  * A registry of target types.
Index: linux-2.6.29-rc3-devel/include/linux/device-mapper.h
===================================================================
--- linux-2.6.29-rc3-devel.orig/include/linux/device-mapper.h	2009-02-05 05:33:48.000000000 +0100
+++ linux-2.6.29-rc3-devel/include/linux/device-mapper.h	2009-02-05 05:33:52.000000000 +0100
@@ -116,7 +116,6 @@ void dm_put_device(struct dm_target *ti,
 /*
  * Target features
  */
-#define DM_TARGET_SUPPORTS_BARRIERS 0x00000001
 
 struct target_type {
 	uint64_t features;

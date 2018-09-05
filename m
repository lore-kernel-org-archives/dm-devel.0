From: Heinz Mauelshagen <heinzm@redhat.com>
Subject: [PATCH 1/5] dm-raid: fix reshape race on small devices
Date: Wed,  5 Sep 2018 19:36:41 +0200
Message-ID: <c36f1d8ac8518924fed6e65ae9c2cf57642d573c.1536167421.git.heinzm@redhat.com>
References: <cover.1536167421.git.heinzm@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <cover.1536167421.git.heinzm@redhat.com>
In-Reply-To: <cover.1536167421.git.heinzm@redhat.com>
References: <cover.1536167421.git.heinzm@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: heinzm@redhat.com, dm-devel@redhat.com
List-Id: dm-devel.ids

This race does not occur with usual raid device sizes but
with small ones (e.g. those created by the lvm2 test suite).

Race scenario:

Loading a new mapping table, the dm-raid target's constructor
retrieves the volatile reshaping state from the raid superblocks.

When the new table is activated in a following resume, the actual
reshape position is retrieved.  The reshape driven by the previous
mapping can already have finished on small and/or fast devices thus
updating raid superblocks about the new raid layout.

This causes the actual array state (e.g. stripe size reshape finished)
to be inconsistent with the one in the new mapping causing hangs with
left behind devices.

Fix by keeping the array frozen until the reloaded table is resumed.

Whilst on this, add/fix comments.

Signed-off-by: Heinz Mauelshagen <heinzm@redhat.com>
---
 Documentation/device-mapper/dm-raid.txt |  1 +
 drivers/md/dm-raid.c                    | 58 +++----------------------
 2 files changed, 8 insertions(+), 51 deletions(-)

diff --git a/Documentation/device-mapper/dm-raid.txt b/Documentation/device-mapper/dm-raid.txt
index 390c145f01d7..f68d06d6f28b 100644
--- a/Documentation/device-mapper/dm-raid.txt
+++ b/Documentation/device-mapper/dm-raid.txt
@@ -348,3 +348,4 @@ Version History
 1.13.1  Fix deadlock caused by early md_stop_writes().  Also fix size an
 	state races.
 1.13.2  Fix raid redundancy validation and avoid keeping raid set frozen
+1.13.3  Fix reshape race on small devices
diff --git a/drivers/md/dm-raid.c b/drivers/md/dm-raid.c
index cae689de75fd..ecb7706f7330 100644
--- a/drivers/md/dm-raid.c
+++ b/drivers/md/dm-raid.c
@@ -1,6 +1,6 @@
 /*
  * Copyright (C) 2010-2011 Neil Brown
- * Copyright (C) 2010-2017 Red Hat, Inc. All rights reserved.
+ * Copyright (C) 2010-2018 Red Hat, Inc. All rights reserved.
  *
  * This file is released under the GPL.
  */
@@ -29,9 +29,6 @@
  */
 #define	MIN_RAID456_JOURNAL_SPACE (4*2048)
 
-/* Global list of all raid sets */
-static LIST_HEAD(raid_sets);
-
 static bool devices_handle_discard_safely = false;
 
 /*
@@ -227,7 +224,6 @@ struct rs_layout {
 
 struct raid_set {
 	struct dm_target *ti;
-	struct list_head list;
 
 	uint32_t stripe_cache_entries;
 	unsigned long ctr_flags;
@@ -273,19 +269,6 @@ static void rs_config_restore(struct raid_set *rs, struct rs_layout *l)
 	mddev->new_chunk_sectors = l->new_chunk_sectors;
 }
 
-/* Find any raid_set in active slot for @rs on global list */
-static struct raid_set *rs_find_active(struct raid_set *rs)
-{
-	struct raid_set *r;
-	struct mapped_device *md = dm_table_get_md(rs->ti->table);
-
-	list_for_each_entry(r, &raid_sets, list)
-		if (r != rs && dm_table_get_md(r->ti->table) == md)
-			return r;
-
-	return NULL;
-}
-
 /* raid10 algorithms (i.e. formats) */
 #define	ALGORITHM_RAID10_DEFAULT	0
 #define	ALGORITHM_RAID10_NEAR		1
@@ -764,7 +747,6 @@ static struct raid_set *raid_set_alloc(struct dm_target *ti, struct raid_type *r
 
 	mddev_init(&rs->md);
 
-	INIT_LIST_HEAD(&rs->list);
 	rs->raid_disks = raid_devs;
 	rs->delta_disks = 0;
 
@@ -782,9 +764,6 @@ static struct raid_set *raid_set_alloc(struct dm_target *ti, struct raid_type *r
 	for (i = 0; i < raid_devs; i++)
 		md_rdev_init(&rs->dev[i].rdev);
 
-	/* Add @rs to global list. */
-	list_add(&rs->list, &raid_sets);
-
 	/*
 	 * Remaining items to be initialized by further RAID params:
 	 *  rs->md.persistent
@@ -797,7 +776,7 @@ static struct raid_set *raid_set_alloc(struct dm_target *ti, struct raid_type *r
 	return rs;
 }
 
-/* Free all @rs allocations and remove it from global list. */
+/* Free all @rs allocations */
 static void raid_set_free(struct raid_set *rs)
 {
 	int i;
@@ -815,8 +794,6 @@ static void raid_set_free(struct raid_set *rs)
 			dm_put_device(rs->ti, rs->dev[i].data_dev);
 	}
 
-	list_del(&rs->list);
-
 	kfree(rs);
 }
 
@@ -2649,7 +2626,7 @@ static int rs_adjust_data_offsets(struct raid_set *rs)
 		return 0;
 	}
 
-	/* HM FIXME: get InSync raid_dev? */
+	/* HM FIXME: get In_Sync raid_dev? */
 	rdev = &rs->dev[0].rdev;
 
 	if (rs->delta_disks < 0) {
@@ -3242,6 +3219,8 @@ static int raid_ctr(struct dm_target *ti, unsigned int argc, char **argv)
 	/* Start raid set read-only and assumed clean to change in raid_resume() */
 	rs->md.ro = 1;
 	rs->md.in_sync = 1;
+
+	/* Keep array frozen */
 	set_bit(MD_RECOVERY_FROZEN, &rs->md.recovery);
 
 	/* Has to be held on running the array */
@@ -3265,7 +3244,7 @@ static int raid_ctr(struct dm_target *ti, unsigned int argc, char **argv)
 	rs->callbacks.congested_fn = raid_is_congested;
 	dm_table_add_target_callbacks(ti->table, &rs->callbacks);
 
-	/* If raid4/5/6 journal mode explictely requested (only possible with journal dev) -> set it */
+	/* If raid4/5/6 journal mode explicitly requested (only possible with journal dev) -> set it */
 	if (test_bit(__CTR_FLAG_JOURNAL_MODE, &rs->ctr_flags)) {
 		r = r5c_journal_mode_set(&rs->md, rs->journal_dev.mode);
 		if (r) {
@@ -3947,29 +3926,6 @@ static int raid_preresume(struct dm_target *ti)
 	if (test_and_set_bit(RT_FLAG_RS_PRERESUMED, &rs->runtime_flags))
 		return 0;
 
-	if (!test_bit(__CTR_FLAG_REBUILD, &rs->ctr_flags)) {
-		struct raid_set *rs_active = rs_find_active(rs);
-
-		if (rs_active) {
-			/*
-			 * In case no rebuilds have been requested
-			 * and an active table slot exists, copy
-			 * current resynchonization completed and
-			 * reshape position pointers across from
-			 * suspended raid set in the active slot.
-			 *
-			 * This resumes the new mapping at current
-			 * offsets to continue recover/reshape without
-			 * necessarily redoing a raid set partially or
-			 * causing data corruption in case of a reshape.
-			 */
-			if (rs_active->md.curr_resync_completed != MaxSector)
-				mddev->curr_resync_completed = rs_active->md.curr_resync_completed;
-			if (rs_active->md.reshape_position != MaxSector)
-				mddev->reshape_position = rs_active->md.reshape_position;
-		}
-	}
-
 	/*
 	 * The superblocks need to be updated on disk if the
 	 * array is new or new devices got added (thus zeroed
@@ -4046,7 +4002,7 @@ static void raid_resume(struct dm_target *ti)
 
 static struct target_type raid_target = {
 	.name = "raid",
-	.version = {1, 13, 2},
+	.version = {1, 13, 3},
 	.module = THIS_MODULE,
 	.ctr = raid_ctr,
 	.dtr = raid_dtr,
-- 
2.17.1

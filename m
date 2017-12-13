From: Heinz Mauelshagen <heinzm@redhat.com>
Subject: [PATCH 2/5] dm raid: avoid keeping raid set frozen
	altogether
Date: Wed, 13 Dec 2017 03:02:35 +0100
Message-ID: <f852e4a25120ea55bb0ddd92453af7b106d7b06c.1513125666.git.heinzm@redhat.com>
References: <cover.1513125666.git.heinzm@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <cover.1513125666.git.heinzm@redhat.com>
In-Reply-To: <cover.1513125666.git.heinzm@redhat.com>
References: <cover.1513125666.git.heinzm@redhat.com>
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
Cc: snitzer@redhat.com
List-Id: dm-devel.ids

In order to avoid redoing synchronization/recovery/reshape partially,
the raid set got frozen until after all passed in table line flags had
been cleared.  The related table reload sequence had to be precisely
followed, or reshaping may lead to data corruption caused by the active
mapping carrying on with a reshape when the inactive mapping already
had retrieved a stale reshape position.

Harden by retrieving the actual resync/recovery/reshape position
during resume whilst the active table is suspended thus avoiding
to keep the raid set frozen altogether.  This prevents superfluous
redoing of an already resynchronized or recovered segment and,
most importantly, potential redoing of an already reshaped
segment causing data corruption.

This is an enhancement to upstream commit
d39f0010e40964d959c5157be02839da8a178015.

Bump target version to reflect these changes.

Also update Documentation respectively.

Signed-off-by: Heinz Mauelshagen <heinzm@redhat.com>
---
 Documentation/device-mapper/dm-raid.txt |   1 +
 drivers/md/dm-raid.c                    | 109 ++++++++++++++++++++------------
 2 files changed, 71 insertions(+), 39 deletions(-)

diff --git a/Documentation/device-mapper/dm-raid.txt b/Documentation/device-mapper/dm-raid.txt
index 4d260fedcd8b..9ee76904fbff 100644
--- a/Documentation/device-mapper/dm-raid.txt
+++ b/Documentation/device-mapper/dm-raid.txt
@@ -346,3 +346,4 @@ Version History
 1.12.1  Fix for MD deadlock between mddev_suspend() and md_write_start() available
 1.13.0  Fix dev_health status at end of "recover" (was 'a', now 'A')
 1.13.1  Fix deadlock caused by early md_stop_writes()
+1.13.2  Fix raid redundancy validation and avoid keeping raid set frozen
diff --git a/drivers/md/dm-raid.c b/drivers/md/dm-raid.c
index c9287666ee5a..0e1a296cd08d 100644
--- a/drivers/md/dm-raid.c
+++ b/drivers/md/dm-raid.c
@@ -29,6 +29,9 @@
  */
 #define	MIN_RAID456_JOURNAL_SPACE (4*2048)
 
+/* Global list of all raid sets */
+LIST_HEAD(raid_sets);
+
 static bool devices_handle_discard_safely = false;
 
 /*
@@ -105,8 +108,6 @@ struct raid_dev {
 #define CTR_FLAG_JOURNAL_DEV		(1 << __CTR_FLAG_JOURNAL_DEV)
 #define CTR_FLAG_JOURNAL_MODE		(1 << __CTR_FLAG_JOURNAL_MODE)
 
-#define RESUME_STAY_FROZEN_FLAGS (CTR_FLAG_DELTA_DISKS | CTR_FLAG_DATA_OFFSET)
-
 /*
  * Definitions of various constructor flags to
  * be used in checks of valid / invalid flags
@@ -226,6 +227,7 @@ struct rs_layout {
 
 struct raid_set {
 	struct dm_target *ti;
+	struct list_head list;
 
 	uint32_t stripe_cache_entries;
 	unsigned long ctr_flags;
@@ -271,6 +273,19 @@ static void rs_config_restore(struct raid_set *rs, struct rs_layout *l)
 	mddev->new_chunk_sectors = l->new_chunk_sectors;
 }
 
+/* Find any raid_set in active slot for @rs on global list */
+static struct raid_set *rs_find_active(struct raid_set *rs)
+{
+	struct raid_set *r;
+	struct mapped_device *md = dm_table_get_md(rs->ti->table);
+
+	list_for_each_entry(r, &raid_sets, list)
+		if (r != rs && dm_table_get_md(r->ti->table) == md)
+			return r;
+
+	return NULL;
+}
+
 /* raid10 algorithms (i.e. formats) */
 #define	ALGORITHM_RAID10_DEFAULT	0
 #define	ALGORITHM_RAID10_NEAR		1
@@ -749,6 +764,7 @@ static struct raid_set *raid_set_alloc(struct dm_target *ti, struct raid_type *r
 
 	mddev_init(&rs->md);
 
+	INIT_LIST_HEAD(&rs->list);
 	rs->raid_disks = raid_devs;
 	rs->delta_disks = 0;
 
@@ -766,6 +782,9 @@ static struct raid_set *raid_set_alloc(struct dm_target *ti, struct raid_type *r
 	for (i = 0; i < raid_devs; i++)
 		md_rdev_init(&rs->dev[i].rdev);
 
+	/* Add @rs to global list. */
+	list_add(&rs->list, &raid_sets);
+
 	/*
 	 * Remaining items to be initialized by further RAID params:
 	 *  rs->md.persistent
@@ -778,6 +797,7 @@ static struct raid_set *raid_set_alloc(struct dm_target *ti, struct raid_type *r
 	return rs;
 }
 
+/* Free all @rs allocations and remove it from global list. */
 static void raid_set_free(struct raid_set *rs)
 {
 	int i;
@@ -795,6 +815,8 @@ static void raid_set_free(struct raid_set *rs)
 			dm_put_device(rs->ti, rs->dev[i].data_dev);
 	}
 
+	list_del(&rs->list);
+
 	kfree(rs);
 }
 
@@ -2371,7 +2393,7 @@ static int super_init_validation(struct raid_set *rs, struct md_rdev *rdev)
 			DMERR("new device%s provided without 'rebuild'",
 			      new_devs > 1 ? "s" : "");
 			return -EINVAL;
-		} else if (rs_is_recovering(rs)) {
+		} else if (!test_bit(__CTR_FLAG_REBUILD, &rs->ctr_flags) && rs_is_recovering(rs)) {
 			DMERR("'rebuild' specified while raid set is not in-sync (recovery_cp=%llu)",
 			      (unsigned long long) mddev->recovery_cp);
 			return -EINVAL;
@@ -3173,19 +3195,22 @@ static int raid_ctr(struct dm_target *ti, unsigned int argc, char **argv)
 			goto bad;
 		}
 
-		/*
-		  * We can only prepare for a reshape here, because the
-		  * raid set needs to run to provide the repective reshape
-		  * check functions via its MD personality instance.
-		  *
-		  * So do the reshape check after md_run() succeeded.
-		  */
-		r = rs_prepare_reshape(rs);
-		if (r)
-			return r;
+		/* Out-of-place space has to be available to allow for a reshape unless raid1! */
+		if (reshape_sectors || rs_is_raid1(rs)) {
+			/*
+			  * We can only prepare for a reshape here, because the
+			  * raid set needs to run to provide the repective reshape
+			  * check functions via its MD personality instance.
+			  *
+			  * So do the reshape check after md_run() succeeded.
+			  */
+			r = rs_prepare_reshape(rs);
+			if (r)
+				return r;
 
-		/* Reshaping ain't recovery, so disable recovery */
-		rs_setup_recovery(rs, MaxSector);
+			/* Reshaping ain't recovery, so disable recovery */
+			rs_setup_recovery(rs, MaxSector);
+		}
 		rs_set_cur(rs);
 	} else {
 		/* May not set recovery when a device rebuild is requested */
@@ -3395,7 +3420,6 @@ static sector_t rs_get_progress(struct raid_set *rs, unsigned long recovery,
 		} else if (test_bit(MD_RECOVERY_NEEDED, &recovery) ||
 			   test_bit(MD_RECOVERY_RUNNING, &recovery))
 			r = mddev->curr_resync_completed;
-
 		else
 			r = mddev->recovery_cp;
 
@@ -3908,10 +3932,33 @@ static int raid_preresume(struct dm_target *ti)
 	struct raid_set *rs = ti->private;
 	struct mddev *mddev = &rs->md;
 
-	/* This is a resume after a suspend of the set -> it's already started */
+	/* This is a resume after a suspend of the set -> it's already started. */
 	if (test_and_set_bit(RT_FLAG_RS_PRERESUMED, &rs->runtime_flags))
 		return 0;
 
+	if (!test_bit(__CTR_FLAG_REBUILD, &rs->ctr_flags)) {
+		struct raid_set *rs_active = rs_find_active(rs);
+
+		if (rs_active) {
+			/*
+			 * In case no rebuilds have been requested
+			 * and an active table slot exists, copy
+			 * current resynchonization completed and
+			 * reshape position pointers across from
+			 * suspended raid set in the active slot.
+			 *
+			 * This resumes the new mapping at current
+			 * offsets to continue recover/reshape without
+			 * necessarily redoing a raid set partially or
+			 * causing data corruption in case of a reshape.
+			 */
+			if (rs_active->md.curr_resync_completed != MaxSector)
+				mddev->curr_resync_completed = rs_active->md.curr_resync_completed;
+			if (rs_active->md.reshape_position != MaxSector)
+				mddev->reshape_position = rs_active->md.reshape_position;
+		}
+	}
+
 	/*
 	 * The superblocks need to be updated on disk if the
 	 * array is new or new devices got added (thus zeroed
@@ -3972,29 +4019,13 @@ static void raid_resume(struct dm_target *ti)
 		attempt_restore_of_faulty_devices(rs);
 	}
 
-	/* Only reduce raid set size before running a disk removing reshape. */
-	if (mddev->delta_disks < 0)
-		rs_set_capacity(rs);
-
-	/*
-	 * Keep the RAID set frozen if reshape/rebuild flags are set.
-	 * The RAID set is unfrozen once the next table load/resume,
-	 * which clears the reshape/rebuild flags, occurs.
-	 * This ensures that the constructor for the inactive table
-	 * retrieves an up-to-date reshape_position.
-	 */
-	if (!test_and_clear_bit(RT_FLAG_RESHAPE_RS, &rs->runtime_flags) &&
-	    !(rs->ctr_flags & RESUME_STAY_FROZEN_FLAGS)) {
-		if (rs_is_reshapable(rs)) {
-			if (!rs_is_reshaping(rs) ||
-			    _get_reshape_sectors(rs))
-				clear_bit(MD_RECOVERY_FROZEN, &mddev->recovery);
-		} else
-			clear_bit(MD_RECOVERY_FROZEN, &mddev->recovery);
-	}
-
 	if (test_and_clear_bit(RT_FLAG_RS_SUSPENDED, &rs->runtime_flags)) {
+		/* Only reduce raid set size before running a disk removing reshape. */
+		if (mddev->delta_disks < 0)
+			rs_set_capacity(rs);
+
 		mddev_lock_nointr(mddev);
+		clear_bit(MD_RECOVERY_FROZEN, &mddev->recovery);
 		mddev->ro = 0;
 		mddev->in_sync = 0;
 		mddev_resume(mddev);
@@ -4004,7 +4035,7 @@ static void raid_resume(struct dm_target *ti)
 
 static struct target_type raid_target = {
 	.name = "raid",
-	.version = {1, 13, 1},
+	.version = {1, 13, 2},
 	.module = THIS_MODULE,
 	.ctr = raid_ctr,
 	.dtr = raid_dtr,
-- 
2.13.6

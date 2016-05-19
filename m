From: heinzm@redhat.com
Subject: [PATCH 11/11] dm-raid: enhance status interface and
	fixup takeover/raid0
Date: Thu, 19 May 2016 18:49:34 +0200
Message-ID: <1463676574-12596-12-git-send-email-heinzm@redhat.com>
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
Cc: Heinz Mauelshagen <heinzm@redhat.com>
List-Id: dm-devel.ids

From: Heinz Mauelshagen <heinzm@redhat.com>

The targets status interface has to provide the new 'data_offset' value
to allow userspace to retrieve the kernels offset to the data on each
raid device of a raid set. This is the base for out-of-place reshaping
required to not write over any data during reshaping
(e.g. change raid6_zr -> raid6_nc):

 - add rs_set_cur() to be able to start up existing array in case of no takeover;
   use in ctr on takeover check

 - enhance raid_status()

 - add supporting functions to get resync/reshape progress and raid device status chars

 - fixup rebuild table line output race, which does miss to emit
   'rebuild N' on fully synced/rebuild devices, because it is
   relying on the transient 'In_sync' raid device flag 

 - add new status line output for 'data_offset', which'll
   later be used for out-of-place reshaping

 - fixup takeover not working for all levels 

 - fixup raid0 message interface oops caused by missing checks
   for the md threads, which don't exist in case of raid0

 - remove ALL_FREEZE_FLAGS not needed for takeover

 - adjust comments

Signed-off-by: Heinz Mauelshagen <heinzm@redhat.com>
---
 drivers/md/dm-raid.c | 453 ++++++++++++++++++++++++++++++---------------------
 1 file changed, 265 insertions(+), 188 deletions(-)

diff --git a/drivers/md/dm-raid.c b/drivers/md/dm-raid.c
index 29a3910..16b4cd2 100644
--- a/drivers/md/dm-raid.c
+++ b/drivers/md/dm-raid.c
@@ -98,13 +98,6 @@ struct raid_dev {
 #define ALL_CTR_FLAGS		(CTR_FLAG_OPTIONS_NO_ARGS | \
 				 CTR_FLAG_OPTIONS_ONE_ARG)
 
-/*
- * All flags which cause a recovery unfreeze once they got stored in the raid metadata
- */
-#define	ALL_FREEZE_FLAGS (ALL_CTR_FLAGS & ~(CTR_FLAG_REGION_SIZE | CTR_FLAGS_ANY_SYNC | \
-					    CTR_FLAG_RAID10_FORMAT | CTR_FLAG_RAID10_COPIES | \
-					    CTR_FLAG_RAID10_USE_NEAR_SETS))
-
 /* Invalid options definitions per raid level... */
 
 /* "raid0" does not accept any options */
@@ -620,6 +613,19 @@ static struct raid_type *get_raid_type_by_ll(const int level, const int layout)
 }
 
 /*
+ * Set the mddev properties in @rs to the current
+ * ones retrieved from the freshest superblock
+ */
+static void rs_set_cur(struct raid_set *rs)
+{
+	struct mddev *mddev = &rs->md;
+
+	mddev->new_level = mddev->level;
+	mddev->new_layout = mddev->layout;
+	mddev->new_chunk_sectors = mddev->chunk_sectors;
+}
+
+/*
  * Set the mddev properties in @rs to the new
  * ones requested by the ctr
  */
@@ -630,6 +636,7 @@ static void rs_set_new(struct raid_set *rs)
 	mddev->level = mddev->new_level;
 	mddev->layout = mddev->new_layout;
 	mddev->chunk_sectors = mddev->new_chunk_sectors;
+	mddev->raid_disks = rs->raid_disks;
 	mddev->delta_disks = 0;
 }
 
@@ -775,7 +782,7 @@ static int parse_dev_params(struct raid_set *rs, struct dm_arg_set *as)
 			rs->dev[i].rdev.meta_bdev = rs->dev[i].meta_dev->bdev;
 		}
 		rs->dev[i].rdev.bdev = rs->dev[i].data_dev->bdev;
-		list_add(&rs->dev[i].rdev.same_set, &rs->md.disks);
+		list_add_tail(&rs->dev[i].rdev.same_set, &rs->md.disks);
 		if (!test_bit(In_sync, &rs->dev[i].rdev.flags))
 			rebuild++;
 	}
@@ -1247,6 +1254,12 @@ static int parse_raid_params(struct raid_set *rs, struct dm_arg_set *as,
 	return rs_check_for_invalid_flags(rs);
 }
 
+/* Return # of data stripes as kept in mddev as of @rs (i.e. as of superblock) */
+static unsigned int mddev_data_stripes(struct raid_set *rs)
+{
+	return rs->md.raid_disks - rs->raid_type->parity_devs;
+}
+
 static void do_table_event(struct work_struct *ws)
 {
 	struct raid_set *rs = container_of(ws, struct raid_set, md.event_work);
@@ -1739,7 +1752,7 @@ static int super_init_validation(struct raid_set *rs, struct md_rdev *rdev)
 
 	} else {
 		/*
-		 * Reshaping is not allowed, because we don't have the appropriate metadata
+		 * No takeover/reshaping, because we don't have the extended v1.8.0 metadata
 		 */
 		if (le32_to_cpu(sb->level) != mddev->level) {
 			DMERR("Reshaping/takeover raid sets not yet supported. (raid level/stripes/size change)");
@@ -1824,14 +1837,16 @@ static int super_init_validation(struct raid_set *rs, struct md_rdev *rdev)
 		      rebuilds, new_devs);
 		return -EINVAL;
 	} else if (rebuilds) {
-		if (rebuild_and_new && rebuilds != rebuild_and_new) {
-			DMERR("new device%s provided w/o 'rebuild'",
-			      new_devs > 1 ? "s" : "");
-			return -EINVAL;
-		} else if (mddev->recovery_cp != MaxSector) {
-			DMERR("'rebuild' specified while raid set is not in-sync (recovery_cp=%llu)",
-			      (unsigned long long) mddev->recovery_cp);
-			return -EINVAL;
+		if (rebuilds != rebuild_and_new) {
+			if (rebuild_and_new) {
+				DMERR("new device%s provided w/o 'rebuild'",
+				      new_devs > 1 ? "s" : "");
+				return -EINVAL;
+			} else if (mddev->recovery_cp != MaxSector) {
+				DMERR("'rebuild' specified while raid set is not in-sync (recovery_cp=%llu)",
+				      (unsigned long long) mddev->recovery_cp);
+				return -EINVAL;
+			}
 		} else if (mddev->reshape_position != MaxSector) {
 			DMERR("'rebuild' specified while raid set is being reshaped");
 			return -EINVAL;
@@ -1893,7 +1908,8 @@ static int super_validate(struct raid_set *rs, struct md_rdev *rdev)
 	struct mddev *mddev = &rs->md;
 	struct dm_raid_superblock *sb;
 
-	if (!rdev->sb_page)
+	if (rs_is_raid0(rs) ||
+	    !rdev->sb_page)
 		return 0;
 
 	sb = page_address(rdev->sb_page);
@@ -1913,7 +1929,6 @@ static int super_validate(struct raid_set *rs, struct md_rdev *rdev)
 	mddev->bitmap_info.offset = rt_is_raid0(rs->raid_type) ? 0 : to_sector(4096);
 	rdev->mddev->bitmap_info.default_offset = mddev->bitmap_info.offset;
 
-
 	if (!test_and_clear_bit(FirstUse, &rdev->flags)) {
 		/* Retrieve device size stored in superblock to be prepared for shrink */
 		rdev->sectors = le64_to_cpu(sb->sectors);
@@ -2088,8 +2103,7 @@ static int rs_setup_takeover(struct raid_set *rs)
 		rdev->new_data_offset = new_data_offset;
 	}
 
-	rs_set_new(rs);
-	set_bit(MD_CHANGE_DEVS, &mddev->flags);
+	mddev->recovery_cp = 0;
 
 	return 0;
 }
@@ -2236,8 +2250,11 @@ static int raid_ctr(struct dm_target *ti, unsigned argc, char **argv)
 		if (r)
 			return r;
 
+		/* Tell preresume to update superblocks with new layout */
 		_set_flag(RT_FLAG_UPDATE_SBS, &rs->runtime_flags);
-	}
+		rs_set_new(rs);
+	} else
+		rs_set_cur(rs);
 
 	/* Start raid set read-only and assumed clean to change in raid_resume() */
 	rs->md.ro = 1;
@@ -2292,6 +2309,7 @@ static int raid_map(struct dm_target *ti, struct bio *bio)
 	return DM_MAPIO_SUBMITTED;
 }
 
+/* Return string describing the current sync action of @mddev */
 static const char *decipher_sync_action(struct mddev *mddev)
 {
 	if (test_bit(MD_RECOVERY_FROZEN, &mddev->recovery))
@@ -2317,181 +2335,251 @@ static const char *decipher_sync_action(struct mddev *mddev)
 	return "idle";
 }
 
-static void raid_status(struct dm_target *ti, status_type_t type,
-			unsigned status_flags, char *result, unsigned maxlen)
+/*
+ * Return status string @rdev
+ *
+ * Status characters:
+ *
+ *  'D' = Dead/Failed device
+ *  'a' = Alive but not in-sync
+ *  'A' = Alive and in-sync
+ */
+static const char *_raid_dev_status(struct md_rdev *rdev, bool array_in_sync)
 {
-	struct raid_set *rs = ti->private;
-	unsigned raid_param_cnt = 1; /* at least 1 for chunksize */
-	unsigned sz = 0;
-	int i, array_in_sync = 0;
-	sector_t sync;
+	if (test_bit(Faulty, &rdev->flags))
+		return "D";
+	else if (!array_in_sync || !test_bit(In_sync, &rdev->flags))
+		return "a";
+	else
+		return "A";
+}
 
-	switch (type) {
-	case STATUSTYPE_INFO:
-		DMEMIT("%s %d ", rs->raid_type->name, rs->md.raid_disks);
+/* Helper to return resync/reshape progress for @rs and @array_in_sync */
+static sector_t rs_get_progress(struct raid_set *rs,
+				sector_t resync_max_sectors, bool *array_in_sync)
+{
+	sector_t r, recovery_cp, curr_resync_completed;
+	struct mddev *mddev = &rs->md;
 
-		if (!rt_is_raid0(rs->raid_type)) {
-			if (test_bit(MD_RECOVERY_RUNNING, &rs->md.recovery))
-				sync = rs->md.curr_resync_completed;
-			else
-				sync = rs->md.recovery_cp;
-
-			if (sync >= rs->md.resync_max_sectors) {
-				/*
-				 * Sync complete.
-				 */
-				array_in_sync = 1;
-				sync = rs->md.resync_max_sectors;
-			} else if (test_bit(MD_RECOVERY_REQUESTED, &rs->md.recovery)) {
-				/*
-				 * If "check" or "repair" is occurring, the array has
-				 * undergone and initial sync and the health characters
-				 * should not be 'a' anymore.
-				 */
-				array_in_sync = 1;
+	curr_resync_completed = mddev->curr_resync_completed ?: mddev->recovery_cp;
+	recovery_cp = mddev->recovery_cp;
+	*array_in_sync = false;
+
+	if (rs_is_raid0(rs)) {
+		r = resync_max_sectors;
+		*array_in_sync = true;
+
+	} else {
+		r = mddev->reshape_position;
+
+		/* Reshape is relative to the array size */
+		if (test_bit(MD_RECOVERY_RESHAPE, &mddev->recovery) ||
+		    r != MaxSector) {
+			if (r == MaxSector) {
+				*array_in_sync = true;
+				r = resync_max_sectors;
 			} else {
-				/*
-				 * The array may be doing an initial sync, or it may
-				 * be rebuilding individual components.  If all the
-				 * devices are In_sync, then it is the array that is
-				 * being initialized.
-				 */
-				for (i = 0; i < rs->md.raid_disks; i++)
-					if (!test_bit(In_sync, &rs->dev[i].rdev.flags))
-						array_in_sync = 1;
+				/* Got to reverse on backward reshape */
+				if (mddev->reshape_backwards)
+					r = mddev->array_sectors - r;
+
+				/* Devide by # of data stripes */
+				sector_div(r, mddev_data_stripes(rs));
 			}
+
+		/* Sync is relative to the component device size */
+		} else if (test_bit(MD_RECOVERY_RUNNING, &mddev->recovery))
+			r = curr_resync_completed;
+		else
+			r = recovery_cp;
+
+		if (r == MaxSector) {
+			/*
+			 * Sync complete.
+			 */
+			*array_in_sync = true;
+			r = resync_max_sectors;
+		} else if (test_bit(MD_RECOVERY_REQUESTED, &mddev->recovery)) {
+			/*
+			 * If "check" or "repair" is occurring, the raid set has
+			 * undergone an initial sync and the health characters
+			 * should not be 'a' anymore.
+			 */
+			*array_in_sync = true;
 		} else {
-			/* RAID0 */
-			array_in_sync = 1;
-			sync = rs->md.resync_max_sectors;
-		}
+			struct md_rdev *rdev;
 
-		/*
-		 * Status characters:
-		 *  'D' = Dead/Failed device
-		 *  'a' = Alive but not in-sync
-		 *  'A' = Alive and in-sync
-		 */
-		for (i = 0; i < rs->md.raid_disks; i++) {
-			if (test_bit(Faulty, &rs->dev[i].rdev.flags))
-				DMEMIT("D");
-			else if (!array_in_sync ||
-				 !test_bit(In_sync, &rs->dev[i].rdev.flags))
-				DMEMIT("a");
-			else
-				DMEMIT("A");
+			/*
+			 * The raid set may be doing an initial sync, or it may
+			 * be rebuilding individual components.  If all the
+			 * devices are In_sync, then it is the raid set that is
+			 * being initialized.
+			 */
+			rdev_for_each(rdev, mddev)
+				if (!test_bit(In_sync, &rdev->flags))
+					*array_in_sync = true;
+#if 0
+			r = 0; /* HM FIXME: TESTME: https://bugzilla.redhat.com/show_bug.cgi?id=1210637 ? */
+#endif
 		}
+	}
+
+	return r;
+}
+
+/* Helper to return @dev name or "-" if !@dev */
+static const char *_get_dev_name(struct dm_dev *dev)
+{
+	return dev ? dev->name : "-";
+}
+
+static void raid_status(struct dm_target *ti, status_type_t type,
+			unsigned int status_flags, char *result, unsigned int maxlen)
+{
+	struct raid_set *rs = ti->private;
+	struct mddev *mddev = &rs->md;
+	struct r5conf *conf = mddev->private;
+	int max_nr_stripes = conf ? conf->max_nr_stripes : 0;
+	bool array_in_sync;
+	unsigned int raid_param_cnt = 1; /* at least 1 for chunksize */
+	unsigned int sz = 0;
+	unsigned int write_mostly_params = 0;
+	sector_t progress, resync_max_sectors, resync_mismatches;
+	const char *sync_action;
+	struct raid_type *rt;
+	struct md_rdev *rdev;
+
+	switch (type) {
+	case STATUSTYPE_INFO:
+		/* *Should* always succeed */
+		rt = get_raid_type_by_ll(mddev->new_level, mddev->new_layout);
+		if (!rt)
+			return;
+
+		DMEMIT("%s %d ", rt ? rt->name : "unknown", mddev->raid_disks);
+
+		/* Access most recent mddev properties for status output */
+		smp_rmb();
+		/* Get sensible max sectors even if raid set not yet started */
+		resync_max_sectors = _test_flag(RT_FLAG_RS_PRERESUMED, rs->runtime_flags) ?
+				      mddev->resync_max_sectors : mddev->dev_sectors;
+		progress = rs_get_progress(rs, resync_max_sectors, &array_in_sync);
+		resync_mismatches = (mddev->last_sync_action && !strcasecmp(mddev->last_sync_action, "check")) ?
+				    (unsigned int) atomic64_read(&mddev->resync_mismatches) : 0;
+		sync_action = decipher_sync_action(&rs->md);
+
+		/* HM FIXME: do we want another state char for raid0? It shows 'D' or 'A' now */
+		rdev_for_each(rdev, mddev)
+			DMEMIT(_raid_dev_status(rdev, array_in_sync));
 
 		/*
-		 * In-sync ratio:
+		 * In-sync/Reshape ratio:
 		 *  The in-sync ratio shows the progress of:
-		 *   - Initializing the array
-		 *   - Rebuilding a subset of devices of the array
+		 *   - Initializing the raid set
+		 *   - Rebuilding a subset of devices of the raid set
 		 *  The user can distinguish between the two by referring
 		 *  to the status characters.
+		 *
+		 *  The reshape ratio shows the progress of
+		 *  changing the raid layout or the number of
+		 *  disks of a raid set
 		 */
-		DMEMIT(" %llu/%llu",
-		       (unsigned long long) sync,
-		       (unsigned long long) rs->md.resync_max_sectors);
+		DMEMIT(" %llu/%llu", (unsigned long long) progress,
+				     (unsigned long long) resync_max_sectors);
 
 		/*
+		 * v1.5.0+:
+		 *
 		 * Sync action:
-		 *   See Documentation/device-mapper/dm-raid.c for
+		 *   See Documentation/device-mapper/dm-raid.txt for
 		 *   information on each of these states.
 		 */
-		DMEMIT(" %s", decipher_sync_action(&rs->md));
+		DMEMIT(" %s", sync_action);
 
 		/*
+		 * v1.5.0+:
+		 *
 		 * resync_mismatches/mismatch_cnt
 		 *   This field shows the number of discrepancies found when
-		 *   performing a "check" of the array.
+		 *   performing a "check" of the raid set.
 		 */
-		DMEMIT(" %llu",
-		       (strcmp(rs->md.last_sync_action, "check")) ? 0 :
-		       (unsigned long long)
-		       atomic64_read(&rs->md.resync_mismatches));
-		break;
-	case STATUSTYPE_TABLE:
-		/* The string you would use to construct this array */
-		for (i = 0; i < rs->md.raid_disks; i++) {
-			if (_test_flag(CTR_FLAG_REBUILD, rs->ctr_flags) &&
-			    rs->dev[i].data_dev &&
-			    !test_bit(In_sync, &rs->dev[i].rdev.flags))
-				raid_param_cnt += 2; /* for rebuilds */
-			if (rs->dev[i].data_dev &&
-			    test_bit(WriteMostly, &rs->dev[i].rdev.flags))
-				raid_param_cnt += 2;
-		}
-
-		raid_param_cnt += (hweight32(rs->ctr_flags & ~CTR_FLAG_REBUILD) * 2);
-		if (rs->ctr_flags & (CTR_FLAG_SYNC | CTR_FLAG_NOSYNC))
-			raid_param_cnt--;
+		DMEMIT(" %llu", (unsigned long long) resync_mismatches);
 
-		DMEMIT("%s %u %u", rs->raid_type->name,
-		       raid_param_cnt, rs->md.chunk_sectors);
+		/*
+		 * v1.8.0+:
+		 *
+		 * data_offset (needed for out of space reshaping)
+		 *   This field shows the data offset into the data
+		 *   image LV where the first stripes data starts.
+		 *
+		 * We keep data_offset equal on all raid disks of the set,
+		 * so retrieving it from the first raid disk is sufficient.
+		 */
+		DMEMIT(" %llu", (unsigned long long) rs->dev[0].rdev.data_offset);
+		break;
 
-		if (_test_flag(CTR_FLAG_SYNC, rs->ctr_flags) &&
-		    rs->md.recovery_cp == MaxSector)
-			DMEMIT(" sync");
+	case STATUSTYPE_TABLE:
+		/* Report the table line string you would use to construct this raid set */
+
+		/* Calculate raid parameter count */
+		rdev_for_each(rdev, mddev)
+			if (test_bit(WriteMostly, &rdev->flags))
+				write_mostly_params += 2;
+		raid_param_cnt += memweight(rs->rebuild_disks,
+					    DISKS_ARRAY_ELEMS * sizeof(*rs->rebuild_disks)) * 2 +
+				  write_mostly_params +
+				  hweight32(rs->ctr_flags & CTR_FLAG_OPTIONS_NO_ARGS) +
+				  hweight32(rs->ctr_flags & CTR_FLAG_OPTIONS_ONE_ARG) * 2;
+		/* Emit table line */
+		DMEMIT("%s %u %u", rs->raid_type->name, raid_param_cnt, mddev->new_chunk_sectors);
+		if (_test_flag(CTR_FLAG_RAID10_FORMAT, rs->ctr_flags))
+			DMEMIT(" %s %s", _argname_by_flag(CTR_FLAG_RAID10_FORMAT),
+					 raid10_md_layout_to_format(mddev->layout));
+		if (_test_flag(CTR_FLAG_RAID10_COPIES, rs->ctr_flags))
+			DMEMIT(" %s %d", _argname_by_flag(CTR_FLAG_RAID10_COPIES),
+					 raid10_md_layout_to_copies(mddev->layout));
 		if (_test_flag(CTR_FLAG_NOSYNC, rs->ctr_flags))
-			DMEMIT(" nosync");
-
-		for (i = 0; i < rs->md.raid_disks; i++)
-			if (_test_flag(CTR_FLAG_REBUILD, rs->ctr_flags) &&
-			    rs->dev[i].data_dev &&
-			    !test_bit(In_sync, &rs->dev[i].rdev.flags))
-				DMEMIT(" rebuild %u", i);
-
+			DMEMIT(" %s", _argname_by_flag(CTR_FLAG_NOSYNC));
+		if (_test_flag(CTR_FLAG_SYNC, rs->ctr_flags))
+			DMEMIT(" %s", _argname_by_flag(CTR_FLAG_SYNC));
+		if (_test_flag(CTR_FLAG_REGION_SIZE, rs->ctr_flags))
+			DMEMIT(" %s %llu", _argname_by_flag(CTR_FLAG_REGION_SIZE),
+					   (unsigned long long) to_sector(mddev->bitmap_info.chunksize));
+		if (_test_flag(CTR_FLAG_DATA_OFFSET, rs->ctr_flags))
+			DMEMIT(" %s %llu", _argname_by_flag(CTR_FLAG_DATA_OFFSET),
+					   (unsigned long long) rs->data_offset);
 		if (_test_flag(CTR_FLAG_DAEMON_SLEEP, rs->ctr_flags))
-			DMEMIT(" daemon_sleep %lu",
-			       rs->md.bitmap_info.daemon_sleep);
-
-		if (_test_flag(CTR_FLAG_MIN_RECOVERY_RATE, rs->ctr_flags))
-			DMEMIT(" min_recovery_rate %d", rs->md.sync_speed_min);
-
-		if (_test_flag(CTR_FLAG_MAX_RECOVERY_RATE, rs->ctr_flags))
-			DMEMIT(" max_recovery_rate %d", rs->md.sync_speed_max);
-
-		for (i = 0; i < rs->md.raid_disks; i++)
-			if (rs->dev[i].data_dev &&
-			    test_bit(WriteMostly, &rs->dev[i].rdev.flags))
-				DMEMIT(" write_mostly %u", i);
-
+			DMEMIT(" %s %lu", _argname_by_flag(CTR_FLAG_DAEMON_SLEEP),
+					  mddev->bitmap_info.daemon_sleep);
+		if (_test_flag(CTR_FLAG_DELTA_DISKS, rs->ctr_flags))
+			DMEMIT(" %s %d", _argname_by_flag(CTR_FLAG_DELTA_DISKS),
+					 mddev->delta_disks);
+		if (_test_flag(CTR_FLAG_STRIPE_CACHE, rs->ctr_flags))
+			DMEMIT(" %s %d", _argname_by_flag(CTR_FLAG_STRIPE_CACHE),
+					 max_nr_stripes);
+		rdev_for_each(rdev, mddev)
+			if (test_bit(rdev->raid_disk, (void *) rs->rebuild_disks))
+				DMEMIT(" %s %u", _argname_by_flag(CTR_FLAG_REBUILD),
+						 rdev->raid_disk);
+		rdev_for_each(rdev, mddev)
+			if (test_bit(WriteMostly, &rdev->flags))
+				DMEMIT(" %s %d", _argname_by_flag(CTR_FLAG_WRITE_MOSTLY),
+						 rdev->raid_disk);
 		if (_test_flag(CTR_FLAG_MAX_WRITE_BEHIND, rs->ctr_flags))
-			DMEMIT(" max_write_behind %lu",
-			       rs->md.bitmap_info.max_write_behind);
-
-		if (_test_flag(CTR_FLAG_STRIPE_CACHE, rs->ctr_flags)) {
-			struct r5conf *conf = rs->md.private;
-
-			/* convert from kiB to sectors */
-			DMEMIT(" stripe_cache %d",
-			       conf ? conf->max_nr_stripes * 2 : 0);
-		}
-
-		if (_test_flag(CTR_FLAG_REGION_SIZE, rs->ctr_flags))
-			DMEMIT(" region_size %lu",
-			       rs->md.bitmap_info.chunksize >> 9);
-
-		if (_test_flag(CTR_FLAG_RAID10_COPIES, rs->ctr_flags))
-			DMEMIT(" raid10_copies %u",
-			       raid10_md_layout_to_copies(rs->md.layout));
-
-		if (_test_flag(CTR_FLAG_RAID10_FORMAT, rs->ctr_flags))
-			DMEMIT(" raid10_format %s",
-			       raid10_md_layout_to_format(rs->md.layout));
-
-		DMEMIT(" %d", rs->md.raid_disks);
-		for (i = 0; i < rs->md.raid_disks; i++) {
-			if (rs->dev[i].meta_dev)
-				DMEMIT(" %s", rs->dev[i].meta_dev->name);
-			else
-				DMEMIT(" -");
-
-			if (rs->dev[i].data_dev)
-				DMEMIT(" %s", rs->dev[i].data_dev->name);
-			else
-				DMEMIT(" -");
+			DMEMIT(" %s %lu", _argname_by_flag(CTR_FLAG_MAX_WRITE_BEHIND),
+					  mddev->bitmap_info.max_write_behind);
+		if (_test_flag(CTR_FLAG_MAX_RECOVERY_RATE, rs->ctr_flags))
+			DMEMIT(" %s %d", _argname_by_flag(CTR_FLAG_MAX_RECOVERY_RATE),
+					 mddev->sync_speed_max);
+		if (_test_flag(CTR_FLAG_MIN_RECOVERY_RATE, rs->ctr_flags))
+			DMEMIT(" %s %d", _argname_by_flag(CTR_FLAG_MIN_RECOVERY_RATE),
+					 mddev->sync_speed_min);
+		DMEMIT(" %d", rs->raid_disks);
+		rdev_for_each(rdev, mddev) {
+			struct raid_dev *rd = container_of(rdev, struct raid_dev, rdev);
+
+			DMEMIT(" %s %s", _get_dev_name(rd->meta_dev),
+					 _get_dev_name(rd->data_dev));
 		}
 	}
 }
@@ -2523,11 +2611,10 @@ static int raid_message(struct dm_target *ti, unsigned argc, char **argv)
 		   test_bit(MD_RECOVERY_NEEDED, &mddev->recovery))
 		return -EBUSY;
 	else if (!strcasecmp(argv[0], "resync"))
-		set_bit(MD_RECOVERY_NEEDED, &mddev->recovery);
-	else if (!strcasecmp(argv[0], "recover")) {
+		; /* MD_RECOVERY_NEEDED set below */
+	else if (!strcasecmp(argv[0], "recover"))
 		set_bit(MD_RECOVERY_RECOVER, &mddev->recovery);
-		set_bit(MD_RECOVERY_NEEDED, &mddev->recovery);
-	} else {
+	else {
 		if (!strcasecmp(argv[0], "check"))
 			set_bit(MD_RECOVERY_CHECK, &mddev->recovery);
 		else if (!!strcasecmp(argv[0], "repair"))
@@ -2540,11 +2627,11 @@ static int raid_message(struct dm_target *ti, unsigned argc, char **argv)
 		 * canceling read-auto mode
 		 */
 		mddev->ro = 0;
-		if (!mddev->suspended)
+		if (!mddev->suspended && mddev->sync_thread)
 			md_wakeup_thread(mddev->sync_thread);
 	}
 	set_bit(MD_RECOVERY_NEEDED, &mddev->recovery);
-	if (!mddev->suspended)
+	if (!mddev->suspended && mddev->thread)
 		md_wakeup_thread(mddev->thread);
 
 	return 0;
@@ -2715,23 +2802,12 @@ static void raid_resume(struct dm_target *ti)
 		 */
 		attempt_restore_of_faulty_devices(rs);
 
-	} else {
-		mddev->in_sync = 0;
-
-		/*
-		 * If any of the constructor flags got passed in
-		 * but "region_size" (gets always passed in for
-		 * mappings with bitmap), we expect userspace to
-		 * reset them and reload the mapping anyway.
-		 *
-		 * -> don't unfreeze resynchronization until imminant
-		 *    reload of the table w/o theses flags
-		 */
-		if (!_test_flags(ALL_FREEZE_FLAGS, rs->ctr_flags))
-			clear_bit(MD_RECOVERY_FROZEN, &mddev->recovery);
 	}
 
 	mddev->ro = 0;
+	mddev->in_sync = 0;
+	clear_bit(MD_RECOVERY_FROZEN, &mddev->recovery);
+
 	if (mddev->suspended)
 		mddev_resume(mddev);
 }
@@ -2781,4 +2857,5 @@ MODULE_ALIAS("dm-raid4");
 MODULE_ALIAS("dm-raid5");
 MODULE_ALIAS("dm-raid6");
 MODULE_AUTHOR("Neil Brown <dm-devel@redhat.com>");
+MODULE_AUTHOR("Heinz Mauelshagen <dm-devel@redhat.com>");
 MODULE_LICENSE("GPL");
-- 
2.5.5

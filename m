From: Heinz Mauelshagen <heinzm@redhat.com>
Subject: [PATCH 4/4] dm raid: streamline rs_get_progress() and
	its raid_status() caller side
Date: Tue,  1 Oct 2019 17:47:55 +0200
Message-ID: <1bf5a0b2c4de7dfa013e7d8ea451af3a5398f8f4.1569888100.git.heinzm@redhat.com>
References: <cover.1569888100.git.heinzm@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <cover.1569888100.git.heinzm@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: heinzm@redhat.com, dm-devel@redhat.com, snitzer@redhat.com
List-Id: dm-devel.ids

Pass already deciphered state into rs_get_progress, simplify recovery offset
definition and combine two st_resync, st_reshape conditionals into one as is
already the case with st_check and st_repair.

Signed-off-by: Heinz Mauelshagen <heinzm@redhat.com>
---
 drivers/md/dm-raid.c | 52 ++++++++++++++++++--------------------------
 1 file changed, 21 insertions(+), 31 deletions(-)

diff --git a/drivers/md/dm-raid.c b/drivers/md/dm-raid.c
index 9aa830c53844..153654ae84ae 100644
--- a/drivers/md/dm-raid.c
+++ b/drivers/md/dm-raid.c
@@ -3413,10 +3413,9 @@ static const char *__raid_dev_status(struct raid_set *rs, struct md_rdev *rdev)
 
 /* Helper to return resync/reshape progress for @rs and runtime flags for raid set in sync / resynching */
 static sector_t rs_get_progress(struct raid_set *rs, unsigned long recovery,
-				sector_t resync_max_sectors)
+				enum sync_state state, sector_t resync_max_sectors)
 {
 	sector_t r;
-	enum sync_state state;
 	struct mddev *mddev = &rs->md;
 
 	clear_bit(RT_FLAG_RS_IN_SYNC, &rs->runtime_flags);
@@ -3427,12 +3426,7 @@ static sector_t rs_get_progress(struct raid_set *rs, unsigned long recovery,
 		set_bit(RT_FLAG_RS_IN_SYNC, &rs->runtime_flags);
 
 	} else {
-		state = decipher_sync_action(mddev, recovery);
-
-		if (state == st_idle && !test_bit(MD_RECOVERY_INTR, &recovery))
-			r = mddev->recovery_cp;
-		else
-			r = mddev->curr_resync_completed;
+		r = max(mddev->recovery_cp, mddev->curr_resync_completed);
 
 		if (state == st_idle && r >= resync_max_sectors) {
 			/*
@@ -3446,18 +3440,14 @@ static sector_t rs_get_progress(struct raid_set *rs, unsigned long recovery,
 			/*
 			 * In case we are recovering, the array is not in sync
 			 * and health chars should show the recovering legs.
+			 *
+			 * Already retrieved recovery offset from curr_resync_completed above.
 			 */
 			;
-		else if (state == st_resync)
-			/*
-			 * If "resync" is occurring, the raid set
-			 * is or may be out of sync hence the health
-			 * characters shall be 'a'.
-			 */
-			set_bit(RT_FLAG_RS_RESYNCING, &rs->runtime_flags);
-		else if (state == st_reshape)
+
+		else if (state == st_resync || state == st_reshape)
 			/*
-			 * If "reshape" is occurring, the raid set
+			 * If "resync/reshape" is occurring, the raid set
 			 * is or may be out of sync hence the health
 			 * characters shall be 'a'.
 			 */
@@ -3471,22 +3461,22 @@ static sector_t rs_get_progress(struct raid_set *rs, unsigned long recovery,
 			 */
 			set_bit(RT_FLAG_RS_IN_SYNC, &rs->runtime_flags);
 
-		else {
-			struct md_rdev *rdev;
-
+		else if (test_bit(MD_RECOVERY_NEEDED, &recovery))
 			/*
 			 * We are idle and recovery is needed, prevent 'A' chars race
 			 * caused by components still set to in-sync by constructor.
 			 */
-			if (test_bit(MD_RECOVERY_NEEDED, &recovery))
-				set_bit(RT_FLAG_RS_RESYNCING, &rs->runtime_flags);
+			set_bit(RT_FLAG_RS_RESYNCING, &rs->runtime_flags);
 
+		else {
 			/*
-			 * The raid set may be doing an initial sync, or it may
-			 * be rebuilding individual components.	 If all the
-			 * devices are In_sync, then it is the raid set that is
-			 * being initialized.
+			 * We are idle and the raid set may be doing an initial
+			 * sync, or it may be rebuilding individual components.
+			 * If all the devices are In_sync, then it is the raid set
+			 * that is being initialized.
 			 */
+			struct md_rdev *rdev;
+
 			set_bit(RT_FLAG_RS_IN_SYNC, &rs->runtime_flags);
 			rdev_for_each(rdev, mddev)
 				if (!test_bit(Journal, &rdev->flags) &&
@@ -3519,7 +3509,7 @@ static void raid_status(struct dm_target *ti, status_type_t type,
 	unsigned int rebuild_disks;
 	unsigned int write_mostly_params = 0;
 	sector_t progress, resync_max_sectors, resync_mismatches;
-	const char *sync_action;
+	enum sync_state state;
 	struct raid_type *rt;
 
 	switch (type) {
@@ -3533,14 +3523,14 @@ static void raid_status(struct dm_target *ti, status_type_t type,
 
 		/* Access most recent mddev properties for status output */
 		smp_rmb();
-		recovery = rs->md.recovery;
 		/* Get sensible max sectors even if raid set not yet started */
 		resync_max_sectors = test_bit(RT_FLAG_RS_PRERESUMED, &rs->runtime_flags) ?
 				      mddev->resync_max_sectors : mddev->dev_sectors;
-		progress = rs_get_progress(rs, recovery, resync_max_sectors);
+		recovery = rs->md.recovery;
+		state = decipher_sync_action(mddev, recovery);
+		progress = rs_get_progress(rs, recovery, state, resync_max_sectors);
 		resync_mismatches = (mddev->last_sync_action && !strcasecmp(mddev->last_sync_action, "check")) ?
 				    atomic64_read(&mddev->resync_mismatches) : 0;
-		sync_action = sync_str(decipher_sync_action(&rs->md, recovery));
 
 		/* HM FIXME: do we want another state char for raid0? It shows 'D'/'A'/'-' now */
 		for (i = 0; i < rs->raid_disks; i++)
@@ -3568,7 +3558,7 @@ static void raid_status(struct dm_target *ti, status_type_t type,
 		 *   See Documentation/admin-guide/device-mapper/dm-raid.rst for
 		 *   information on each of these states.
 		 */
-		DMEMIT(" %s", sync_action);
+		DMEMIT(" %s", sync_str(state));
 
 		/*
 		 * v1.5.0+:
-- 
2.21.0

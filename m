From: Heinz Mauelshagen <heinzm@redhat.com>
Subject: [PATCH 3/5] dm-raid: correct explicit superblock update
	requests
Date: Wed,  5 Sep 2018 19:36:43 +0200
Message-ID: <62c2b6e2f3fd78591c15144970791416a9012a55.1536167421.git.heinzm@redhat.com>
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

Critical:

Request superblock updates when particular devices are requested
to be rebuild (e.g. via lvconvert --replace ...) to avoid racy
"New device injected into existing raid set without 'delta_disks'
 or 'rebuild' parameter specified" kernel error messages.

Cleanup:

Remove request to write superblocks in super_load() when new,
because raid_ctr() requests it already via flag RT_FLAG_UPDATE_SBS
for new arrays (it's performed in preresume).

Avoid explicit superblocks update in rs_start_reshape() because
it's already requested before for new reshapes in
rs_prepare_reshape().

Signed-off-by: Heinz Mauelshagen <heinzm@redhat.com>
---
 drivers/md/dm-raid.c | 18 ++++++------------
 1 file changed, 6 insertions(+), 12 deletions(-)

diff --git a/drivers/md/dm-raid.c b/drivers/md/dm-raid.c
index 03dd915eff9e..efe035fcb23e 100644
--- a/drivers/md/dm-raid.c
+++ b/drivers/md/dm-raid.c
@@ -2202,9 +2202,6 @@ static int super_load(struct md_rdev *rdev, struct md_rdev *refdev)
 		set_bit(FirstUse, &rdev->flags);
 		sb->compat_features = cpu_to_le32(FEATURE_FLAG_SUPPORTS_V190);
 
-		/* Force writing of superblocks to disk */
-		set_bit(MD_SB_CHANGE_DEVS, &rdev->mddev->sb_flags);
-
 		/* Any superblock is better than none, choose that if given */
 		return refdev ? 0 : 1;
 	}
@@ -3126,6 +3123,11 @@ static int raid_ctr(struct dm_target *ti, unsigned int argc, char **argv)
 		set_bit(RT_FLAG_UPDATE_SBS, &rs->runtime_flags);
 		rs_set_new(rs);
 	} else if (rs_is_recovering(rs)) {
+		/* Rebuild particular devices */
+		if (test_bit(__CTR_FLAG_REBUILD, &rs->ctr_flags)) {
+			set_bit(RT_FLAG_UPDATE_SBS, &rs->runtime_flags);
+			rs_setup_recovery(rs, MaxSector);
+		}
 		/* A recovering raid set may be resized */
 		; /* skip setup rs */
 	} else if (rs_is_reshaping(rs)) {
@@ -3234,7 +3236,6 @@ static int raid_ctr(struct dm_target *ti, unsigned int argc, char **argv)
 	}
 
 	r = md_start(&rs->md);
-
 	if (r) {
 		ti->error = "Failed to start raid array";
 		mddev_unlock(&rs->md);
@@ -3846,7 +3847,7 @@ static int __load_dirty_region_bitmap(struct raid_set *rs)
 	return r;
 }
 
-/* Enforce updating all superblocks */
+/* Enforce updating new superblocks */
 static void rs_update_sbs(struct raid_set *rs)
 {
 	struct mddev *mddev = &rs->md;
@@ -3901,13 +3902,6 @@ static int rs_start_reshape(struct raid_set *rs)
 		}
 	}
 
-	/*
-	 * Now reshape got set up, update superblocks to
-	 * reflect the fact so that a table reload will
-	 * access proper superblock content in the ctr.
-	 */
-	rs_update_sbs(rs);
-
 	return 0;
 }
 
-- 
2.17.1

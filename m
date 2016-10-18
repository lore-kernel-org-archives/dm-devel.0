From: Heinz Mauelshagen <heinzm@redhat.com>
Subject: [PATCH] dm raid: correct error messages on old metadata
	validation
Date: Tue, 18 Oct 2016 17:46:45 +0200
Message-ID: <1476805605-19477-1-git-send-email-heinzm@redhat.com>
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
Cc: Heinz Mauelshagen <heinzm@redhat.com>, snitzer@redhat.com
List-Id: dm-devel.ids

When target 1.9.1 gets takeover/reshape requests on devices with old superblock
format not supporting such conversions and rejects them in super_init_validation(),
it logs bogus error message (e.g. Reshape when a takeover is requested).

Whilst on it, add messages for disk adding/removing and stripe sectors
reshape requests, use the newer rs_{takeover,reshape}_requested() API,
address a false raid10 positive in checking array positions and
remove rs_set_new() because device members are already set proper.

Resolves: rhbz1386194

Signed-off-by: Heinz Mauelshagen <heinzm@redhat.com>
---
 drivers/md/dm-raid.c | 71 +++++++++++++++++++++++++++++-----------------------
 1 file changed, 39 insertions(+), 32 deletions(-)

diff --git a/drivers/md/dm-raid.c b/drivers/md/dm-raid.c
index 6d53810..698b03e 100644
--- a/drivers/md/dm-raid.c
+++ b/drivers/md/dm-raid.c
@@ -2050,16 +2050,17 @@ static int super_init_validation(struct raid_set *rs, struct md_rdev *rdev)
 
 	mddev->reshape_position = MaxSector;
 
+	mddev->raid_disks = le32_to_cpu(sb->num_devices);
+	mddev->level = le32_to_cpu(sb->level);
+	mddev->layout = le32_to_cpu(sb->layout);
+	mddev->chunk_sectors = le32_to_cpu(sb->stripe_sectors);
+
 	/*
 	 * Reshaping is supported, e.g. reshape_position is valid
 	 * in superblock and superblock content is authoritative.
 	 */
 	if (le32_to_cpu(sb->compat_features) & FEATURE_FLAG_SUPPORTS_V190) {
 		/* Superblock is authoritative wrt given raid set layout! */
-		mddev->raid_disks = le32_to_cpu(sb->num_devices);
-		mddev->level = le32_to_cpu(sb->level);
-		mddev->layout = le32_to_cpu(sb->layout);
-		mddev->chunk_sectors = le32_to_cpu(sb->stripe_sectors);
 		mddev->new_level = le32_to_cpu(sb->new_level);
 		mddev->new_layout = le32_to_cpu(sb->new_layout);
 		mddev->new_chunk_sectors = le32_to_cpu(sb->new_stripe_sectors);
@@ -2087,38 +2088,44 @@ static int super_init_validation(struct raid_set *rs, struct md_rdev *rdev)
 		/*
 		 * No takeover/reshaping, because we don't have the extended v1.9.0 metadata
 		 */
-		if (le32_to_cpu(sb->level) != mddev->new_level) {
-			DMERR("Reshaping/takeover raid sets not yet supported. (raid level/stripes/size change)");
-			return -EINVAL;
-		}
-		if (le32_to_cpu(sb->layout) != mddev->new_layout) {
-			DMERR("Reshaping raid sets not yet supported. (raid layout change)");
-			DMERR("	 0x%X vs 0x%X", le32_to_cpu(sb->layout), mddev->layout);
-			DMERR("	 Old layout: %s w/ %d copies",
-			      raid10_md_layout_to_format(le32_to_cpu(sb->layout)),
-			      raid10_md_layout_to_copies(le32_to_cpu(sb->layout)));
-			DMERR("	 New layout: %s w/ %d copies",
-			      raid10_md_layout_to_format(mddev->layout),
-			      raid10_md_layout_to_copies(mddev->layout));
-			return -EINVAL;
-		}
-		if (le32_to_cpu(sb->stripe_sectors) != mddev->new_chunk_sectors) {
-			DMERR("Reshaping raid sets not yet supported. (stripe sectors change)");
-			return -EINVAL;
-		}
+		struct raid_type *rt_cur = get_raid_type_by_ll(mddev->level, mddev->layout);
+		struct raid_type *rt_new = get_raid_type_by_ll(mddev->new_level, mddev->new_layout);
 
-		/* We can only change the number of devices in raid1 with old (i.e. pre 1.0.7) metadata */
-		if (!rt_is_raid1(rs->raid_type) &&
-		    (le32_to_cpu(sb->num_devices) != mddev->raid_disks)) {
-			DMERR("Reshaping raid sets not yet supported. (device count change from %u to %u)",
-			      sb->num_devices, mddev->raid_disks);
+		if (rs_takeover_requested(rs)) {
+			if (rt_cur && rt_new)
+				DMERR("Takeover raid sets from %s to %s not yet supported by metadata. (raid level change)",
+				      rt_cur->name, rt_new->name);
+			else
+				DMERR("Takeover raid sets not yet supported by metadata. (raid level change)");
+			return -EINVAL;
+		} else if (rs_reshape_requested(rs)) {
+			DMERR("Reshaping raid sets not yet supported by metadata. (raid layout change keeping level)");
+			if (mddev->layout != mddev->new_layout) {
+				if (rt_cur && rt_new)
+					DMERR("	 current layout %s vs new layout %s",
+					      rt_cur->name, rt_new->name);
+				else
+					DMERR("	 current layout 0x%X vs new layout 0x%X",
+					      le32_to_cpu(sb->layout), mddev->new_layout);
+			}
+			if (mddev->chunk_sectors != mddev->new_chunk_sectors)
+				DMERR("	 current stripe sectors %u vs new stripe sectors %u",
+				      mddev->chunk_sectors, mddev->new_chunk_sectors);
+			if (rs->delta_disks)
+				DMERR("	 current %u disks vs new %u disks",
+				      mddev->raid_disks, mddev->raid_disks + rs->delta_disks);
+			if (rs_is_raid10(rs)) {
+				DMERR("	 Old layout: %s w/ %u copies",
+				      raid10_md_layout_to_format(mddev->layout),
+				      raid10_md_layout_to_copies(mddev->layout));
+				DMERR("	 New layout: %s w/ %u copies",
+				      raid10_md_layout_to_format(mddev->new_layout),
+				      raid10_md_layout_to_copies(mddev->new_layout));
+			}
 			return -EINVAL;
 		}
 
 		DMINFO("Discovered old metadata format; upgrading to extended metadata format");
-
-		/* Table line is checked vs. authoritative superblock */
-		rs_set_new(rs);
 	}
 
 	if (!test_bit(__CTR_FLAG_NOSYNC, &rs->ctr_flags))
@@ -2211,7 +2218,7 @@ static int super_init_validation(struct raid_set *rs, struct md_rdev *rdev)
 				continue;
 
 			if (role != r->raid_disk) {
-				if (__is_raid10_near(mddev->layout)) {
+				if (rs_is_raid10(rs) && __is_raid10_near(mddev->layout)) {
 					if (mddev->raid_disks % __raid10_near_copies(mddev->layout) ||
 					    rs->raid_disks % rs->raid10_copies) {
 						rs->ti->error =
-- 
2.7.4

From: heinzm@redhat.com
Subject: [PATCH] dm raid: fix oops on upgrading to extended
	superblock format
Date: Fri, 23 Jun 2017 17:27:01 +0200
Message-ID: <20170623152701.20977-1-heinzm@redhat.com>
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
Cc: heinzm@redhat.com
List-Id: dm-devel.ids

From: Heinz Mauelshagen <heinzm@redhat.com>

When a RAID set was created on dm-raid version < 1.9.0
(old RAID superblock format), none of the new members of the
superblock have been set including the device sectors member
needed to support shrinking.

Don't access such member unconditionally.

Add respective comments.

Resolves: rhbz1464274

diff --git a/drivers/md/dm-raid.c b/drivers/md/dm-raid.c
index 7d89322..2e15623 100644
--- a/drivers/md/dm-raid.c
+++ b/drivers/md/dm-raid.c
@@ -1927,7 +1927,7 @@ struct dm_raid_superblock {
 	/********************************************************************
 	 * BELOW FOLLOW V1.9.0 EXTENSIONS TO THE PRISTINE SUPERBLOCK FORMAT!!!
 	 *
-	 * FEATURE_FLAG_SUPPORTS_V190 in the features member indicates that those exist
+	 * FEATURE_FLAG_SUPPORTS_V190 in the compat_features member indicates that those exist
 	 */
 
 	__le32 flags; /* Flags defining array states for reshaping */
@@ -2092,6 +2092,11 @@ static void super_sync(struct mddev *mddev, struct md_rdev *rdev)
 	sb->layout = cpu_to_le32(mddev->layout);
 	sb->stripe_sectors = cpu_to_le32(mddev->chunk_sectors);
 
+	/********************************************************************
+	 * BELOW FOLLOW V1.9.0 EXTENSIONS TO THE PRISTINE SUPERBLOCK FORMAT!!!
+	 *
+	 * FEATURE_FLAG_SUPPORTS_V190 in the compat_features member indicates that those exist
+	 */
 	sb->new_level = cpu_to_le32(mddev->new_level);
 	sb->new_layout = cpu_to_le32(mddev->new_layout);
 	sb->new_stripe_sectors = cpu_to_le32(mddev->new_chunk_sectors);
@@ -2438,8 +2443,17 @@ static int super_validate(struct raid_set *rs, struct md_rdev *rdev)
 	mddev->bitmap_info.default_offset = mddev->bitmap_info.offset;
 
 	if (!test_and_clear_bit(FirstUse, &rdev->flags)) {
-		/* Retrieve device size stored in superblock to be prepared for shrink */
-		rdev->sectors = le64_to_cpu(sb->sectors);
+		/*
+		 * Retrieve rdev size stored in superblock to be prepared for shrink.
+		 *
+		 * Check extended superblock members present to
+		 * access the size member or it will not be set!
+		 *
+		 * https://bugzilla.redhat.com/1464274
+		 */
+		if (le32_to_cpu(sb->compat_features) & FEATURE_FLAG_SUPPORTS_V190)
+			rdev->sectors = le64_to_cpu(sb->sectors);
+
 		rdev->recovery_offset = le64_to_cpu(sb->disk_recovery_offset);
 		if (rdev->recovery_offset == MaxSector)
 			set_bit(In_sync, &rdev->flags);
-- 
2.9.4

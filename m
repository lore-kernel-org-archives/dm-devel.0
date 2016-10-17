From: Heinz Mauelshagen <heinzm@redhat.com>
Subject: [PATCH] dm raid: fix activation of exisiting raid4/10
	mapped devices
Date: Mon, 17 Oct 2016 21:20:07 +0200
Message-ID: <1476732007-15202-1-git-send-email-heinzm@redhat.com>
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

dm-raid 1.9.0 fails to activate existing RAID4/10 mapped devices
created with old superblock format without takeover/reshaping support
prior to upstream commit 33e53f06850f44ec9722e08a993ecf8816e447a5.

Fix by reverting to the old raid4 layout and basing checks on
mddev->new_{level,layout,...} members in super_init_validation()
in the validation path for old superblocks.

Resolves: rhbz1385149

Signed-off-by: Heinz Mauelshagen <heinzm@redhat.com>
---
 Documentation/device-mapper/dm-raid.txt |  1 +
 drivers/md/dm-raid.c                    | 12 +++++++-----
 2 files changed, 8 insertions(+), 5 deletions(-)

diff --git a/Documentation/device-mapper/dm-raid.txt b/Documentation/device-mapper/dm-raid.txt
index e5b6497..c75b64a 100644
--- a/Documentation/device-mapper/dm-raid.txt
+++ b/Documentation/device-mapper/dm-raid.txt
@@ -309,3 +309,4 @@ Version History
 	with a reshape in progress.
 1.9.0   Add support for RAID level takeover/reshape/region size
 	and set size reduction.
+1.9.1   Fix activation of existing RAID 4/10 mapped devices
diff --git a/drivers/md/dm-raid.c b/drivers/md/dm-raid.c
index 2a39700..09dc022 100644
--- a/drivers/md/dm-raid.c
+++ b/drivers/md/dm-raid.c
@@ -266,7 +266,7 @@ static struct raid_type {
 	{"raid10_offset", "raid10 offset (striped mirrors)",	    0, 2, 10, ALGORITHM_RAID10_OFFSET},
 	{"raid10_near",	  "raid10 near (striped mirrors)",	    0, 2, 10, ALGORITHM_RAID10_NEAR},
 	{"raid10",	  "raid10 (striped mirrors)",		    0, 2, 10, ALGORITHM_RAID10_DEFAULT},
-	{"raid4",	  "raid4 (dedicated last parity disk)",	    1, 2, 4,  ALGORITHM_PARITY_N}, /* raid4 layout = raid5_n */
+	{"raid4",	  "raid4 (dedicated first parity disk)",    1, 2, 5,  ALGORITHM_PARITY_0}, /* raid4 layout = raid5_0 */
 	{"raid5_n",	  "raid5 (dedicated last parity disk)",	    1, 2, 5,  ALGORITHM_PARITY_N},
 	{"raid5_ls",	  "raid5 (left symmetric)",		    1, 2, 5,  ALGORITHM_LEFT_SYMMETRIC},
 	{"raid5_rs",	  "raid5 (right symmetric)",		    1, 2, 5,  ALGORITHM_RIGHT_SYMMETRIC},
@@ -2087,11 +2087,13 @@ static int super_init_validation(struct raid_set *rs, struct md_rdev *rdev)
 		/*
 		 * No takeover/reshaping, because we don't have the extended v1.9.0 metadata
 		 */
-		if (le32_to_cpu(sb->level) != mddev->level) {
+		DMINFO("Discovered old metadata format; upgrading to extended v1.9.0");
+
+		if (le32_to_cpu(sb->level) != mddev->new_level) {
 			DMERR("Reshaping/takeover raid sets not yet supported. (raid level/stripes/size change)");
 			return -EINVAL;
 		}
-		if (le32_to_cpu(sb->layout) != mddev->layout) {
+		if (le32_to_cpu(sb->layout) != mddev->new_layout) {
 			DMERR("Reshaping raid sets not yet supported. (raid layout change)");
 			DMERR("	 0x%X vs 0x%X", le32_to_cpu(sb->layout), mddev->layout);
 			DMERR("	 Old layout: %s w/ %d copies",
@@ -2102,7 +2104,7 @@ static int super_init_validation(struct raid_set *rs, struct md_rdev *rdev)
 			      raid10_md_layout_to_copies(mddev->layout));
 			return -EINVAL;
 		}
-		if (le32_to_cpu(sb->stripe_sectors) != mddev->chunk_sectors) {
+		if (le32_to_cpu(sb->stripe_sectors) != mddev->new_chunk_sectors) {
 			DMERR("Reshaping raid sets not yet supported. (stripe sectors change)");
 			return -EINVAL;
 		}
@@ -3647,7 +3649,7 @@ static void raid_resume(struct dm_target *ti)
 
 static struct target_type raid_target = {
 	.name = "raid",
-	.version = {1, 9, 0},
+	.version = {1, 9, 1},
 	.module = THIS_MODULE,
 	.ctr = raid_ctr,
 	.dtr = raid_dtr,
-- 
2.7.4

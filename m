From: heinzm@redhat.com
Subject: [PATCH] dm raid: support raid0 with missing metadata
	devices
Date: Wed, 17 Aug 2016 15:36:36 +0200
Message-ID: <1471440996-25626-1-git-send-email-heinzm@redhat.com>
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

The raid0 MD personality does not start a raid0 array
with any of its data devices missing.

dm-raid was removing data/metadata device pairs unconditionally in
case it failed to read a superblock off the respective metadata device
of such pair, hence starting the array failed in the raid0 personality.

Avoid removing any data/metadata device pairs in case of raid0
(e.g. lvm2 segment type 'raid0_meta') thus allowing MD to start
the array.

Once on it avoid region size validation for raid0

Signed-off-by: Heinz Mauelshagen <heinzm@redhat.com>
---
 drivers/md/dm-raid.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/drivers/md/dm-raid.c b/drivers/md/dm-raid.c
index b1c251872..8abde6b 100644
--- a/drivers/md/dm-raid.c
+++ b/drivers/md/dm-raid.c
@@ -860,6 +860,9 @@ static int validate_region_size(struct raid_set *rs, unsigned long region_size)
 {
 	unsigned long min_region_size = rs->ti->len / (1 << 21);
 
+	if (rs_is_raid0(rs))
+		return 0;
+
 	if (!region_size) {
 		/*
 		 * Choose a reasonable default.	 All figures in sectors.
@@ -929,6 +932,8 @@ static int validate_raid_redundancy(struct raid_set *rs)
 			rebuild_cnt++;
 
 	switch (rs->raid_type->level) {
+	case 0:
+		break;
 	case 1:
 		if (rebuild_cnt >= rs->md.raid_disks)
 			goto too_many;
@@ -2334,6 +2339,13 @@ static int analyse_superblocks(struct dm_target *ti, struct raid_set *rs)
 		case 0:
 			break;
 		default:
+			/*
+			 * We have to keep any raid0 data/metadata device pairs or
+			 * the MD raid0 personality will fail to start the array.
+			 */
+			if (rs_is_raid0(rs))
+				continue;
+
 			dev = container_of(rdev, struct raid_dev, rdev);
 			if (dev->meta_dev)
 				dm_put_device(ti, dev->meta_dev);
-- 
2.7.4

From: heinzm@redhat.com
Subject: [PATCH v2 5/4] dm-raid: add merge method to target
Date: Fri, 15 May 2015 16:03:49 +0200
Message-ID: <1431698629-29805-1-git-send-email-heinzm@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
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

Patch series
"[PATCH v2 0/4] dm-raid: Add support for the MD RAID0 personality"
is missing a merge function which can lead to data corruption
on read ahead.

This patch introduces it
It inquires the MD raid0 personalities mergeable_bvec
to make sure, that read ahead payload gets limited properly.

The problem did not occur with the other raid levels,
because it either did not apply without striping or got
avoided via stripe caching.


Signed-of-by: Heinz Mauelshagen <heinzm@redhat.com>
Tested-by: Heinz Mauelshagen <heinzm@redhat.com>

---
 drivers/md/dm-raid.c | 19 +++++++++++++++++++
 1 file changed, 19 insertions(+)

diff --git a/drivers/md/dm-raid.c b/drivers/md/dm-raid.c
index 97e1651..06f9d63 100644
--- a/drivers/md/dm-raid.c
+++ b/drivers/md/dm-raid.c
@@ -1717,6 +1717,24 @@ static void raid_resume(struct dm_target *ti)
 	mddev_resume(&rs->md);
 }
 
+static int raid_merge(struct dm_target *ti, struct bvec_merge_data *bvm,
+		      struct bio_vec *biovec, int max_size)
+{
+	struct raid_set *rs = ti->private;
+	struct md_personality *pers = rs->md.pers;
+
+	if (pers && pers->mergeable_bvec)
+		return min(max_size, pers->mergeable_bvec(&rs->md, bvm, biovec));
+
+	/*
+	 * In case we can't request the personality because
+	 * the raid set is not running yet
+	 *
+	 * -> return safe minimum
+	 */
+	return rs->md.chunk_sectors;
+}
+
 static struct target_type raid_target = {
 	.name = "raid",
 	.version = {1, 7, 0},
@@ -1731,6 +1749,7 @@ static struct target_type raid_target = {
 	.presuspend = raid_presuspend,
 	.postsuspend = raid_postsuspend,
 	.resume = raid_resume,
+	.merge = raid_merge
 };
 
 static int __init dm_raid_init(void)
-- 
2.1.0

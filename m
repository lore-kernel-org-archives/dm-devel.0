From: heinzm@redhat.com
Subject: [PATCH 13/26] dm raid: fix raid10 device size error on
	out-of-place reshape
Date: Wed,  6 Jul 2016 19:24:44 +0200
Message-ID: <1467825897-26058-14-git-send-email-heinzm@redhat.com>
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

Signed-off-by: Heinz Mauelshagen <heinzm@redhat.com>
---
 drivers/md/dm-raid.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/md/dm-raid.c b/drivers/md/dm-raid.c
index 6dc4940..8118f1e 100644
--- a/drivers/md/dm-raid.c
+++ b/drivers/md/dm-raid.c
@@ -622,8 +622,16 @@ static struct raid_type *get_raid_type_by_ll(const int level, const int layout)
 static void rs_set_capacity(struct raid_set *rs)
 {
 	struct mddev *mddev = &rs->md;
+	struct md_rdev *rdev;
 	struct gendisk *gendisk = dm_disk(dm_table_get_md(rs->ti->table));
 
+	/*
+	 * raid10 sets rdev->sector to the device size, which
+	 * is unintended in case of out-of-place reshaping
+	 */
+	rdev_for_each(rdev, mddev)
+		rdev->sectors = mddev->dev_sectors;
+
 	set_capacity(gendisk, mddev->array_sectors);
 	revalidate_disk(gendisk);
 }
-- 
2.5.5

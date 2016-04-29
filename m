From: heinzm@redhat.com
Subject: [PATCH] dm-raid: check for zero feature flags in metadata
Date: Fri, 29 Apr 2016 18:59:56 +0200
Message-ID: <1461949196-17999-1-git-send-email-heinzm@redhat.com>
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

Because we don't support any feature flags in the dm-raid ondisk
metadata yet (see struct dm_raid_superblock, 'features' member), 
this patch adds a check to ensure no flags are actually set or
reject the activation of the RAID mapping.

This is to prevent possible data corruption in case of a
kernel downgrade when there'll potentially be feature flags
set by a future dm-raid target.


Signed-off-by: Heinz Mauelshagen <heinzm@redhat.com>

---
 drivers/md/dm-raid.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/md/dm-raid.c b/drivers/md/dm-raid.c
index a090121..5f05ba0 100644
--- a/drivers/md/dm-raid.c
+++ b/drivers/md/dm-raid.c
@@ -1037,6 +1037,10 @@ static int super_validate(struct raid_set *rs, struct md_rdev *rdev)
 	if (!mddev->events && super_init_validation(mddev, rdev))
 		return -EINVAL;
 
+	rs->ti->error = "Unable to assemble array: No feature flags supported yet";
+	if (le32_to_cpu(sb->features)) /* No features supported yet */
+		return -EINVAL;
+
 	/* Enable bitmap creation for RAID levels != 0 */
 	mddev->bitmap_info.offset = (rs->raid_type->level) ? to_sector(4096) : 0;
 	rdev->mddev->bitmap_info.default_offset = mddev->bitmap_info.offset;
-- 
2.5.5

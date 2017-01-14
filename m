From: heinzm@redhat.com
Subject: [PATCH v2 5/5] dm raid: use mddev rather than rdev->mddev
Date: Sat, 14 Jan 2017 03:53:11 +0100
Message-ID: <20170114025311.22762-6-heinzm@redhat.com>
References: <20170114025311.22762-1-heinzm@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20170114025311.22762-1-heinzm@redhat.com>
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
 drivers/md/dm-raid.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/md/dm-raid.c b/drivers/md/dm-raid.c
index 424c93c..ee96ba3 100644
--- a/drivers/md/dm-raid.c
+++ b/drivers/md/dm-raid.c
@@ -2370,7 +2370,7 @@ static int super_validate(struct raid_set *rs, struct md_rdev *rdev)
 
 	/* Enable bitmap creation for RAID levels != 0 */
 	mddev->bitmap_info.offset = rt_is_raid0(rs->raid_type) ? 0 : to_sector(4096);
-	rdev->mddev->bitmap_info.default_offset = mddev->bitmap_info.offset;
+	mddev->bitmap_info.default_offset = mddev->bitmap_info.offset;
 
 	if (!test_and_clear_bit(FirstUse, &rdev->flags)) {
 		/* Retrieve device size stored in superblock to be prepared for shrink */
-- 
2.9.3

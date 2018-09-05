From: Heinz Mauelshagen <heinzm@redhat.com>
Subject: [PATCH 5/5] dm-raid: disable bitmap when journaled
Date: Wed,  5 Sep 2018 19:36:45 +0200
Message-ID: <a5d728db7e1123e0626d44a9c8cf0e2e4ecefe16.1536167421.git.heinzm@redhat.com>
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

When a journal device for raid4/5/6 is used,
don't create a mutually exclusive write intent bitmap.

Signed-off-by: Heinz Mauelshagen <heinzm@redhat.com>
---
 drivers/md/dm-raid.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/md/dm-raid.c b/drivers/md/dm-raid.c
index 9754ef24fd0b..1f0e85f6f7e6 100644
--- a/drivers/md/dm-raid.c
+++ b/drivers/md/dm-raid.c
@@ -2472,7 +2472,7 @@ static int super_validate(struct raid_set *rs, struct md_rdev *rdev)
 	}
 
 	/* Enable bitmap creation for RAID levels != 0 */
-	mddev->bitmap_info.offset = rt_is_raid0(rs->raid_type) ? 0 : to_sector(4096);
+	mddev->bitmap_info.offset = (rt_is_raid0(rs->raid_type) || rs->journal_dev.dev) ? 0 : to_sector(4096);
 	mddev->bitmap_info.default_offset = mddev->bitmap_info.offset;
 
 	if (!test_and_clear_bit(FirstUse, &rdev->flags)) {
-- 
2.17.1

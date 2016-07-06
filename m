From: heinzm@redhat.com
Subject: [PATCH 15/26] dm raid: fix new superblock/bitmap
	creation on disk addition
Date: Wed,  6 Jul 2016 19:24:46 +0200
Message-ID: <1467825897-26058-16-git-send-email-heinzm@redhat.com>
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
 drivers/md/dm-raid.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/md/dm-raid.c b/drivers/md/dm-raid.c
index 4572202..5e41bf3 100644
--- a/drivers/md/dm-raid.c
+++ b/drivers/md/dm-raid.c
@@ -2850,8 +2850,9 @@ static int raid_ctr(struct dm_target *ti, unsigned argc, char **argv)
 			set_bit(RT_FLAG_KEEP_RS_FROZEN, &rs->runtime_flags);
 		}
 
+		/* Create new superblocks and bitmaps, if any */
 		if (rs->md.raid_disks < rs->raid_disks)
-			set_bit(MD_ARRAY_FIRST_USE, &mddev->flags);
+			set_bit(RT_FLAG_UPDATE_SBS, &rs->runtime_flags);
 
 		rs_set_cur(rs);
 		rs_setup_recovery(rs, MaxSector);
-- 
2.5.5

From: heinzm@redhat.com
Subject: [PATCH 25/26] dm raid: use rdev_for_each in status
Date: Wed,  6 Jul 2016 19:24:56 +0200
Message-ID: <1467825897-26058-26-git-send-email-heinzm@redhat.com>
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
 drivers/md/dm-raid.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/md/dm-raid.c b/drivers/md/dm-raid.c
index 2ea3982..e4d0bc1 100644
--- a/drivers/md/dm-raid.c
+++ b/drivers/md/dm-raid.c
@@ -3186,8 +3186,8 @@ static void raid_status(struct dm_target *ti, status_type_t type,
 		sync_action = decipher_sync_action(&rs->md);
 
 		/* HM FIXME: do we want another state char for raid0? It shows 'D' or 'A' now */
-		for (i = 0; i < rs->raid_disks; i++)
-			DMEMIT(__raid_dev_status(&rs->dev[i].rdev, array_in_sync));
+		rdev_for_each(rdev, mddev)
+			DMEMIT(__raid_dev_status(rdev, array_in_sync));
 
 		/*
 		 * In-sync/Reshape ratio:
-- 
2.5.5

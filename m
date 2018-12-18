From: Heinz Mauelshagen <heinzm@redhat.com>
Subject: [PATCH] dm raid: avoid busy error on scrubbing message
Date: Tue, 18 Dec 2018 17:35:41 +0100
Message-ID: <94d065d1aa09b9151280a0fd34502ac335e1ac3e.1545150818.git.heinzm@redhat.com>
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
To: heinzm@redhat.com, dm-devel@redhat.com
List-Id: dm-devel.ids

Sending a check/repair message infrequently leads to -EBUSY
as oposed to identifying an active resync properly.
Cause is raid_message() testing recovery bits in a racy way.

Fix by calling decipher_sync_action() from raid_message()
to identify the idle state of the RAID device properly.

Signed-off-by: Heinz Mauelshagen <heinzm@redhat.com>
---
 drivers/md/dm-raid.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/md/dm-raid.c b/drivers/md/dm-raid.c
index e1dd1622a290..adcfe8ae10aa 100644
--- a/drivers/md/dm-raid.c
+++ b/drivers/md/dm-raid.c
@@ -3690,8 +3690,7 @@ static int raid_message(struct dm_target *ti, unsigned int argc, char **argv,
 			set_bit(MD_RECOVERY_INTR, &mddev->recovery);
 			md_reap_sync_thread(mddev);
 		}
-	} else if (test_bit(MD_RECOVERY_RUNNING, &mddev->recovery) ||
-		   test_bit(MD_RECOVERY_NEEDED, &mddev->recovery))
+	} else if (decipher_sync_action(mddev, mddev->recovery) != st_idle)
 		return -EBUSY;
 	else if (!strcasecmp(argv[0], "resync"))
 		; /* MD_RECOVERY_NEEDED set below */
-- 
2.19.2

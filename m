From: Takahiro Yasui <tyasui@redhat.com>
Subject: [PATCH][BUGFIX] dm-raid1: fix data lost on success
 return at log failure
Date: Wed, 23 Dec 2009 17:18:41 -0500
Message-ID: <4B329741.9050704@redhat.com>
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
To: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

This patch fix the case that I/Os return "success" (0) even though
they have never been attempted on the devices. When the log has
failed and the DM_RAID_HANDLE_ERRORS flag is not set, I/Os are put
in the failures queue and return "success" (0) in the do_failures()
function. This is really *data lost*. When the log has failed, all
I/Os should be held in kernel as 2.6.32 kernel does.


Signed-off-by: Takahiro Yasui <tyasui@redhat.com>
---
 drivers/md/dm-raid1.c |   11 ++++-------
 1 file changed, 4 insertions(+), 7 deletions(-)

Index: linux-2.6.33-rc1-dm/drivers/md/dm-raid1.c
===================================================================
--- linux-2.6.33-rc1-dm.orig/drivers/md/dm-raid1.c
+++ linux-2.6.33-rc1-dm/drivers/md/dm-raid1.c
@@ -724,13 +724,10 @@ static void do_writes(struct mirror_set 
 	/*
 	 * Dispatch io.
 	 */
-	if (unlikely(ms->log_failure)) {
-		spin_lock_irq(&ms->lock);
-		bio_list_merge(&ms->failures, &sync);
-		spin_unlock_irq(&ms->lock);
-		wakeup_mirrord(ms);
-	} else
-		while ((bio = bio_list_pop(&sync)))
+	while ((bio = bio_list_pop(&sync)))
+		if (unlikely(ms->log_failure))
+			hold_bio(ms, bio);
+		else
 			do_write(ms, bio);
 
 	while ((bio = bio_list_pop(&recover)))

-- 
Takahiro Yasui
Hitachi Computer Products (America), Inc.

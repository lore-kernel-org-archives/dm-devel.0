From: Jonathan Brassow <jbrassow@redhat.com>
Subject: [PATCH 1 of 2] dm-raid: set recovery flags on resume
Date: Mon, 16 Apr 2012 18:45:35 -0500
Message-ID: <1334619935.16017.26.camel@f14.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: dm-devel@redhat.com, linux-raid@vger.kernel.org
Cc: agk@redhat.com, neilb@suse.de
List-Id: dm-devel.ids

Set recovery flags so that recovery restarts when DM device is resumed.

When a device-mapper device is suspended, all I/O must stop.  This is done by
calling 'md_stop_writes' and 'mddev_suspend'.  These calls in-turn manipulate
the recovery flags - including setting 'MD_RECOVERY_FROZEN'.  The DM device
may have been suspended while recovery was not yet complete, so the process
needs to pick-up where it left off.  Since 'mddev_resume' does not unset
'MD_RECOVERY_FROZEN' and set 'MD_RECOVERY_NEEDED', we must do it ourselves before
calling 'mddev_resume'.

Signed-off-by: Jonathan Brassow <jbrassow@redhat.com>

Index: linux-upstream/drivers/md/dm-raid.c
===================================================================
--- linux-upstream.orig/drivers/md/dm-raid.c
+++ linux-upstream/drivers/md/dm-raid.c
@@ -1255,9 +1255,11 @@ static void raid_resume(struct dm_target
 	if (!rs->bitmap_loaded) {
 		bitmap_load(&rs->md);
 		rs->bitmap_loaded = 1;
-	} else
+	} else {
+		set_bit(MD_RECOVERY_NEEDED, &rs->md.recovery);
+		clear_bit(MD_RECOVERY_FROZEN, &rs->md.recovery);
 		md_wakeup_thread(rs->md.thread);
-
+	}
 	mddev_resume(&rs->md);
 }
 



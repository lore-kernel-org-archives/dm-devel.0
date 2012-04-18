From: Jonathan Brassow <jbrassow@redhat.com>
Subject: [PATCH 1 of 5] DM RAID: Set recovery flags on resume
Date: Tue, 17 Apr 2012 21:36:05 -0500
Message-ID: <1334716565.23908.19.camel@f14.redhat.com>
References: <1334716219.23908.14.camel@f14.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1334716219.23908.14.camel@f14.redhat.com>
Sender: linux-raid-owner@vger.kernel.org
To: dm-devel@redhat.com, linux-raid@vger.kernel.org
Cc: neilb@suse.de, agk@redhat.com
List-Id: dm-devel.ids

Properly initialize MD recovery flags when resuming device-mapper devices.

When a device-mapper device is suspended, all I/O must stop.  This is done by
calling 'md_stop_writes' and 'mddev_suspend'.  These calls in-turn manipulate
the recovery flags - including setting 'MD_RECOVERY_FROZEN'.  The DM device
may have been suspended while recovery was not yet complete, so the process
needs to pick-up where it left off.  Since 'mddev_resume' does not unset
'MD_RECOVERY_FROZEN' and set 'MD_RECOVERY_NEEDED', we must do it ourselves.
'MD_RECOVERY_NEEDED' can safely be set in 'mddev_resume', but 'MD_RECOVERY_FROZEN'
must be set outside of 'mddev_resume' due to how MD handles RAID reshaping.
(e.g.  It is possible for a user to delay reshaping a RAID5->RAID6 by purposefully
setting 'MD_RECOVERY_FROZEN'.  Clearing it in 'mddev_resume' would override the
desired behavior.)

Because 'mddev_resume' already unconditionally calls 'md_wakeup_thread(mddev->thread)'
there is no need to make this call from 'raid_resume' since it calls 'mddev_resume'.

Signed-off-by: Jonathan Brassow <jbrassow@redhat.com>

Index: linux-upstream/drivers/md/dm-raid.c
===================================================================
--- linux-upstream.orig/drivers/md/dm-raid.c
+++ linux-upstream/drivers/md/dm-raid.c
@@ -1255,9 +1255,9 @@ static void raid_resume(struct dm_target
 	if (!rs->bitmap_loaded) {
 		bitmap_load(&rs->md);
 		rs->bitmap_loaded = 1;
-	} else
-		md_wakeup_thread(rs->md.thread);
+	}
 
+	clear_bit(MD_RECOVERY_FROZEN, &rs->md.recovery);
 	mddev_resume(&rs->md);
 }
 
Index: linux-upstream/drivers/md/md.c
===================================================================
--- linux-upstream.orig/drivers/md/md.c
+++ linux-upstream/drivers/md/md.c
@@ -400,6 +400,7 @@ void mddev_resume(struct mddev *mddev)
 	wake_up(&mddev->sb_wait);
 	mddev->pers->quiesce(mddev, 0);
 
+	set_bit(MD_RECOVERY_NEEDED, &mddev->recovery);
 	md_wakeup_thread(mddev->thread);
 	md_wakeup_thread(mddev->sync_thread); /* possibly kick off a reshape */
 }



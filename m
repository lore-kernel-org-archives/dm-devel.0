From: Jonathan Brassow <jbrassow@redhat.com>
Subject: [PATCH 1/1] MD/DM RAID: Fix hang due to recent RAID5 locking changes
Date: Sun, 24 Nov 2013 17:30:43 -0600
Message-ID: <1385335843-14021-2-git-send-email-jbrassow@redhat.com>
References: <1385335843-14021-1-git-send-email-jbrassow@redhat.com>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1385335843-14021-1-git-send-email-jbrassow@redhat.com>
Sender: linux-raid-owner@vger.kernel.org
To: jbrassow@redhat.com, neilb@suse.de, linux-raid@vger.kernel.org, dm-devel@redhat.com
List-Id: dm-devel.ids

When commit 773ca82 was made in v3.12-rc1, it caused RAID4/5/6 devices
that were created via device-mapper (dm-raid.c) to hang on creation.
This is not necessarily the fault of that commit, but perhaps the way
dm-raid.c was setting-up and activating devices.

Device-mapper allows I/O and memory allocations in the constructor
(i.e. raid_ctr()), but nominal and recovery I/O should not be allowed
until a 'resume' is issued (i.e. raid_resume()).  It has been problematic
(at least in the past) to call mddev_resume before mddev_suspend was
called, but this is how DM behaves - CTR then resume.  To solve the
problem, raid_ctr() was setting up the structures, calling md_run(), and
then also calling mddev_suspend().  The stage was then set for raid_resume()
to call mddev_resume().

Commit 773ca82 caused a change in behavior during raid5.c:run().
'setup_conf->grow_stripes->grow_one_stripe' is called which creates the
stripe cache and increments 'active_stripes'.
'grow_one_stripe->release_stripe' doesn't actually decrement 'active_stripes'
anymore.  The side effect of this is that when raid_ctr calls mddev_suspend,
it waits for 'active_stripes' to reduce to 0 - which never happens.

You could argue that the MD personalities should be able to handle either
a suspend or a resume after 'md_run' is called, but it can't really handle
either.  To fix this, I've removed the call to mddev_suspend in raid_ctr and
I've made the call to the personality's 'quiesce' function within
mddev_resume dependent on whether the device is currently suspended.

This patch is suitable and recommended for 3.12.

Signed-off-by: Jonathan Brassow <jbrassow@redhat.com>
---
 drivers/md/dm-raid.c |    1 -
 drivers/md/md.c      |    5 ++++-
 2 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/md/dm-raid.c b/drivers/md/dm-raid.c
index 4880b69..cdad87c 100644
--- a/drivers/md/dm-raid.c
+++ b/drivers/md/dm-raid.c
@@ -1249,7 +1249,6 @@ static int raid_ctr(struct dm_target *ti, unsigned argc, char **argv)
 	rs->callbacks.congested_fn = raid_is_congested;
 	dm_table_add_target_callbacks(ti->table, &rs->callbacks);
 
-	mddev_suspend(&rs->md);
 	return 0;
 
 size_mismatch:
diff --git a/drivers/md/md.c b/drivers/md/md.c
index 561a65f..383980d 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -359,9 +359,12 @@ EXPORT_SYMBOL_GPL(mddev_suspend);
 
 void mddev_resume(struct mddev *mddev)
 {
+	int should_quiesce = mddev->suspended;
+
 	mddev->suspended = 0;
 	wake_up(&mddev->sb_wait);
-	mddev->pers->quiesce(mddev, 0);
+	if (should_quiesce)
+		mddev->pers->quiesce(mddev, 0);
 
 	set_bit(MD_RECOVERY_NEEDED, &mddev->recovery);
 	md_wakeup_thread(mddev->thread);
-- 
1.7.7.6


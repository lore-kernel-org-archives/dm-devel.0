From: Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH v3 8/8] dm raid: add suspend and resume functions
Date: Mon, 20 Dec 2010 21:37:45 -0500
Message-ID: <1292899065-31943-9-git-send-email-snitzer@redhat.com>
References: <1292899065-31943-1-git-send-email-snitzer@redhat.com>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1292899065-31943-1-git-send-email-snitzer@redhat.com>
Sender: linux-raid-owner@vger.kernel.org
To: jbrassow@redhat.com, neilb@suse.de
Cc: agk@redhat.com, dm-devel@redhat.com, linux-raid@vger.kernel.org
List-Id: dm-devel.ids

From: NeilBrown <neilb@suse.de>

Add .*suspend and .resume functions required by device-mapper target
implementations.

Signed-off-by: NeilBrown <neilb@suse.de>
Signed-off-by: Jonathan Brassow <jbrassow@redhat.com>
Signed-off-by: Mike Snitzer <snitzer@redhat.com>
---
 drivers/md/dm-raid.c |   22 ++++++++++++++++++++++
 1 files changed, 22 insertions(+), 0 deletions(-)

diff --git a/drivers/md/dm-raid.c b/drivers/md/dm-raid.c
index 6494833..91770de 100644
--- a/drivers/md/dm-raid.c
+++ b/drivers/md/dm-raid.c
@@ -608,6 +608,25 @@ static void raid_io_hints(struct dm_target *ti,
 			  (conf->raid_disks - conf->max_degraded));
 }
 
+static void raid_presuspend(struct dm_target *ti)
+{
+	struct raid_set *rs = ti->private;
+	md_stop_writes(&rs->md);
+}
+
+static void raid_postsuspend(struct dm_target *ti)
+{
+	struct raid_set *rs = ti->private;
+	mddev_suspend(&rs->md);
+}
+
+static void raid_resume(struct dm_target *ti)
+{
+	struct raid_set *rs = ti->private;
+
+	mddev_resume(&rs->md);
+}
+
 static struct target_type raid_target = {
 	.name = "raid",
 	.version = {1, 0, 0},
@@ -618,6 +637,9 @@ static struct target_type raid_target = {
 	.status = raid_status,
 	.iterate_devices = raid_iterate_devices,
 	.io_hints = raid_io_hints,
+	.presuspend = raid_presuspend,
+	.postsuspend = raid_postsuspend,
+	.resume = raid_resume,
 };
 
 static int __init dm_raid_init(void)
-- 
1.7.2.3


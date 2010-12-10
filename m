From: Jonathan Brassow <jbrassow@redhat.com>
Subject: [PATCH 8 of 8] dm raid suspend and resume fns
Date: Fri, 10 Dec 2010 17:24:53 -0600
Message-ID: <201012102324.oBANOrL0019982@hydrogen.msp.redhat.com>
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
To: dm-devel@redhat.com
Cc: agk@redhat.com
List-Id: dm-devel.ids

Patch name: dm-raid-suspend-and-resume-fns.patch

Addition of .*suspend and .resume functions required
by device-mapper target implementations... further fleshing
out the new target.

Signed-off-by: NeilBrown <neilb@suse.de>
Signed-off-by: Jonathan Brassow <jbrassow@redhat.com>

Index: linux-2.6/drivers/md/dm-raid.c
===================================================================
--- linux-2.6.orig/drivers/md/dm-raid.c
+++ linux-2.6/drivers/md/dm-raid.c
@@ -571,6 +571,25 @@ static void raid_io_hints(struct dm_targ
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
@@ -581,6 +600,9 @@ static struct target_type raid_target = 
 	.status = raid_status,
 	.iterate_devices = raid_iterate_devices,
 	.io_hints = raid_io_hints,
+	.presuspend = raid_presuspend,
+	.postsuspend = raid_postsuspend,
+	.resume = raid_resume,
 };
 
 static int __init dm_raid_init(void)

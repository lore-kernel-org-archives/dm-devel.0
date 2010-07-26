From: NeilBrown <nfbrown@novell.com>
Subject: [PATCH 5/8] dm-raid456: add suspend/resume method
Date: Mon, 26 Jul 2010 13:24:35 +1000
Message-ID: <20100726032435.29687.8430.stgit@localhost.localdomain>
References: <20100726032230.29687.5366.stgit@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20100726032230.29687.5366.stgit@localhost.localdomain>
Sender: linux-raid-owner@vger.kernel.org
To: Heinz Mauelshagen <heinzm@redhat.com>, Alasdair G Kergon <agk@redhat.com>
Cc: linux-raid@vger.kernel.org, dm-devel@redhat.com
List-Id: dm-devel.ids

These just call in to the md methods.

Signed-off-by: NeilBrown <neilb@suse.de>
---
 drivers/md/dm-raid456.c |   22 ++++++++++++++++++++++
 1 files changed, 22 insertions(+), 0 deletions(-)

diff --git a/drivers/md/dm-raid456.c b/drivers/md/dm-raid456.c
index 4ffd654..e2546fc 100644
--- a/drivers/md/dm-raid456.c
+++ b/drivers/md/dm-raid456.c
@@ -466,6 +466,25 @@ static void raid_io_hints(struct dm_target *ti,
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
 	.name = "raid45",
 	.version = {1, 0, 0},
@@ -476,6 +495,9 @@ static struct target_type raid_target = {
 	.status = raid_status,
 	.iterate_devices = raid_iterate_devices,
 	.io_hints = raid_io_hints,
+	.presuspend = raid_presuspend,
+	.postsuspend = raid_postsuspend,
+	.resume = raid_resume,
 };
 
 static int __init dm_raid_init(void)



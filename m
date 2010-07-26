From: NeilBrown <nfbrown@novell.com>
Subject: [PATCH 6/8] dm-raid456: add message handler.
Date: Mon, 26 Jul 2010 13:24:35 +1000
Message-ID: <20100726032435.29687.88413.stgit@localhost.localdomain>
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

Support messages to:
 - change the size of the stripe cache
 - change the speed limiter on resync.

Signed-off-by: NeilBrown <neilb@suse.de>
---
 drivers/md/dm-raid456.c |   26 ++++++++++++++++++++++++++
 1 files changed, 26 insertions(+), 0 deletions(-)

diff --git a/drivers/md/dm-raid456.c b/drivers/md/dm-raid456.c
index e2546fc..a2567b0 100644
--- a/drivers/md/dm-raid456.c
+++ b/drivers/md/dm-raid456.c
@@ -485,6 +485,31 @@ static void raid_resume(struct dm_target *ti)
 	mddev_resume(&rs->md);
 }
 
+/* Parse and handle a message from userspace
+ * Messages are:
+ *    stripecache  N  (pages per devices)
+ *    minspeed  N          (kibibytes per seconds)
+ */
+static int raid_message(struct dm_target *ti, unsigned argc, char **argv)
+{
+	struct raid_set *rs = ti->private;
+
+	if (argc == 2 && strcmp(argv[0], "stripecache") == 0) {
+		unsigned long size;
+		if (strict_strtoul(argv[1], 10, &size))
+			return -EINVAL;
+		return raid5_set_cache_size(&rs->md, size);
+	}
+	if (argc == 2 && strcmp(argv[0], "minspeed") == 0) {
+		unsigned long speed;
+		if (strict_strtoul(argv[1], 10, &speed))
+			return -EINVAL;
+		rs->md.sync_speed_min = speed;
+		return 0;
+	}
+	return -EINVAL;
+}
+
 static struct target_type raid_target = {
 	.name = "raid45",
 	.version = {1, 0, 0},
@@ -498,6 +523,7 @@ static struct target_type raid_target = {
 	.presuspend = raid_presuspend,
 	.postsuspend = raid_postsuspend,
 	.resume = raid_resume,
+	.message = raid_message,
 };
 
 static int __init dm_raid_init(void)



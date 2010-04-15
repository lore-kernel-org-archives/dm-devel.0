From: NeilBrown <neilb@suse.de>
Subject: [PATCH 12/12] dm-raid456: add message handler.
Date: Thu, 15 Apr 2010 16:43:02 +1000
Message-ID: <20100415064302.15646.93062.stgit@notabene.brown>
References: <20100415062909.15646.16.stgit@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20100415062909.15646.16.stgit@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: dm-devel@redhat.com
Cc: linux-raid@vger.kernel.org
List-Id: dm-devel.ids

Support messages to:
 - change the size of the stripe cache
 - change the speed limiter on resync.

Signed-off-by: NeilBrown <neilb@suse.de>
---
 drivers/md/dm-raid456.c |   26 ++++++++++++++++++++++++++
 drivers/md/raid5.c      |    3 ++-
 drivers/md/raid5.h      |    1 +
 3 files changed, 29 insertions(+), 1 deletions(-)

diff --git a/drivers/md/dm-raid456.c b/drivers/md/dm-raid456.c
index 126042d..62c2807 100644
--- a/drivers/md/dm-raid456.c
+++ b/drivers/md/dm-raid456.c
@@ -478,6 +478,31 @@ static void raid_resume(struct dm_target *ti)
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
@@ -490,6 +515,7 @@ static struct target_type raid_target = {
 	.io_hints = raid_io_hints,
 	.presuspend = raid_presuspend,
 	.resume = raid_resume,
+	.message = raid_message,
 };
 
 static int __init dm_raid_init(void)
diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index 138f65f..805f229 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -4503,7 +4503,7 @@ raid5_show_stripe_cache_size(mddev_t *mddev, char *page)
 		return 0;
 }
 
-static int
+int
 raid5_set_cache_size(mddev_t *mddev, int size)
 {
 	raid5_conf_t *conf = mddev->private;
@@ -4527,6 +4527,7 @@ raid5_set_cache_size(mddev_t *mddev, int size)
 	}
 	return 0;
 }
+EXPORT_SYMBOL(raid5_set_cache_size);
 
 static ssize_t
 raid5_store_stripe_cache_size(mddev_t *mddev, const char *page, size_t len)
diff --git a/drivers/md/raid5.h b/drivers/md/raid5.h
index 69dfe39..a08c71b 100644
--- a/drivers/md/raid5.h
+++ b/drivers/md/raid5.h
@@ -502,4 +502,5 @@ static inline int algorithm_is_DDF(int layout)
 }
 extern int md_raid5_congested(mddev_t *mddev, int bits);
 extern void raid5_unplug_device(raid5_conf_t *conf);
+extern int raid5_set_cache_size(mddev_t *mddev, int size);
 #endif



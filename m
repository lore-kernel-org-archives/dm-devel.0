From: NeilBrown <neilb@suse.de>
Subject: [PATCH 16/24] dm-raid456: add message handler.
Date: Tue, 01 Jun 2010 19:56:20 +1000
Message-ID: <20100601095620.565.49108.stgit@notabene.brown>
References: <20100601094414.565.3638.stgit@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20100601094414.565.3638.stgit@notabene.brown>
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
 drivers/md/raid5.c      |    3 ++-
 drivers/md/raid5.h      |    1 +
 3 files changed, 29 insertions(+), 1 deletions(-)

diff --git a/drivers/md/dm-raid456.c b/drivers/md/dm-raid456.c
index 044faae..3fda954 100644
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
diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index be5cab8..8ac122d 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -4500,7 +4500,7 @@ raid5_show_stripe_cache_size(mddev_t *mddev, char *page)
 		return 0;
 }
 
-static int
+int
 raid5_set_cache_size(mddev_t *mddev, int size)
 {
 	raid5_conf_t *conf = mddev->private;
@@ -4524,6 +4524,7 @@ raid5_set_cache_size(mddev_t *mddev, int size)
 	}
 	return 0;
 }
+EXPORT_SYMBOL(raid5_set_cache_size);
 
 static ssize_t
 raid5_store_stripe_cache_size(mddev_t *mddev, const char *page, size_t len)
diff --git a/drivers/md/raid5.h b/drivers/md/raid5.h
index fa3938a..292a9c6 100644
--- a/drivers/md/raid5.h
+++ b/drivers/md/raid5.h
@@ -502,4 +502,5 @@ static inline int algorithm_is_DDF(int layout)
 }
 extern int md_raid5_congested(mddev_t *mddev, int bits);
 extern void raid5_unplug_device(raid5_conf_t *conf);
+extern int raid5_set_cache_size(mddev_t *mddev, int size);
 #endif



From: NeilBrown <nfbrown@novell.com>
Subject: [PATCH 8/8] dm-raid456: switch to use dm_dirty_log for tracking dirty
	regions.
Date: Mon, 26 Jul 2010 13:24:35 +1000
Message-ID: <20100726032435.29687.88509.stgit@localhost.localdomain>
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

Rather than faking a 'core' dirty log, we can now use the dm_dirty_log
mechanism directly and thus potentially benefit from a permanent dirty
log.

Signed-off-by: NeilBrown <neilb@suse.de>
---
 drivers/md/dm-raid456.c |   46 +++++++++++++++++++++++++++++++++++++---------
 1 files changed, 37 insertions(+), 9 deletions(-)

diff --git a/drivers/md/dm-raid456.c b/drivers/md/dm-raid456.c
index a2567b0..5355342 100644
--- a/drivers/md/dm-raid456.c
+++ b/drivers/md/dm-raid456.c
@@ -7,6 +7,8 @@
 #include "md.h"
 #include "raid5.h"
 #include "dm.h"
+#include "bitmap.h"
+#include <linux/dm-dirty-log.h>
 
 struct raid_dev {
 	struct dm_dev *dev;
@@ -183,7 +185,8 @@ static int raid_ctr(struct dm_target *ti, unsigned argc, char **argv)
 {
 	char *err = NULL;
 	int errnum = -EINVAL;
-	unsigned long cnt;
+	unsigned long cnt, log_cnt;
+	char **log_argv;
 	struct raid_type *rt;
 	unsigned long chunk_size;
 	int recovery = 1;
@@ -192,16 +195,18 @@ static int raid_ctr(struct dm_target *ti, unsigned argc, char **argv)
 	sector_t sectors_per_dev, chunks;
 	struct raid_set *rs = NULL;
 	int in_sync, i;
+	struct dm_dirty_log *log = NULL;
 
-	/* log type - core XXX [no]sync */
+	/* log type - type arg-count args */
 	err = "Cannot parse log type";
 	if (argc < 2 ||
-	    strcmp(argv[0], "core") != 0 ||
 	    strict_strtoul(argv[1], 10, &cnt) < 0 ||
 	    cnt + 2 > argc)
 		goto err;
-	if (cnt >= 2 && strcmp(argv[3], "sync") == 0)
-		recovery = 0;
+
+	log_cnt = cnt;
+	log_argv = argv;
+
 	argc -= cnt+2;
 	argv += cnt+2;
 
@@ -276,6 +281,11 @@ static int raid_ctr(struct dm_target *ti, unsigned argc, char **argv)
 	if (sector_div(chunks, chunk_size))
 		goto err;
 
+	log = dm_dirty_log_create(log_argv[0], ti, sectors_per_dev,
+				  NULL, log_cnt, log_argv+2);
+	err = "Error creating dirty log";
+	if (!log)
+		goto err;
 
 	/* Now the devices: three words each */
 	rs = context_alloc(rt, chunk_size, recovery,
@@ -318,6 +328,11 @@ static int raid_ctr(struct dm_target *ti, unsigned argc, char **argv)
 	ti->split_io = rs->md.chunk_sectors;
 	ti->private = rs;
 
+	rs->md.bitmap_info.log = log;
+	rs->md.bitmap_info.daemon_sleep = 10 * HZ;
+	rs->md.bitmap_info.chunksize = log->type->get_region_size(log) * 512;
+	rs->md.bitmap_info.external = 1;
+
 	mutex_lock(&rs->md.reconfig_mutex);
 	err = "Fail to run raid array";
 	errnum = md_run(&rs->md);
@@ -332,6 +347,8 @@ static int raid_ctr(struct dm_target *ti, unsigned argc, char **argv)
 
 	return 0;
 err:
+	if (log)
+		dm_dirty_log_destroy(log);
 	if (rs)
 		context_free(rs);
 	ti->error = err;
@@ -343,6 +360,7 @@ static void raid_dtr(struct dm_target *ti)
 	struct raid_set *rs = ti->private;
 
 	list_del_init(&rs->callbacks.list);
+	dm_dirty_log_destroy(rs->md.bitmap_info.log);
 	md_stop(&rs->md);
 	context_free(rs);
 }
@@ -362,6 +380,7 @@ static int raid_status(struct dm_target *ti, status_type_t type,
 {
 	struct raid_set *rs = ti->private;
 	struct raid5_private_data *conf = rs->md.private;
+	struct dm_dirty_log *log = conf->mddev->bitmap_info.log;
 	int sz = 0;
 	int rbcnt;
 	int i;
@@ -394,14 +413,14 @@ static int raid_status(struct dm_target *ti, status_type_t type,
 		DMEMIT("%llu/%llu ",
 		       (unsigned long long) sync,
 		       (unsigned long long) rs->md.resync_max_sectors);
-		DMEMIT("1 core");
+
+		sz += log->type->status(log, type, result + sz, maxlen - sz);
 
 		break;
 	case STATUSTYPE_TABLE:
 		/* The string you would use to construct this array */
-		/* Pretend to use a core log with a region size of 1 sector */
-		DMEMIT("core 2 %u %ssync ", 1,
-		       rs->md.recovery_cp == MaxSector ? "" : "no");
+		sz += log->type->status(log, type, result + sz, maxlen - sz);
+
 		DMEMIT("%s ", rs->raid_type->name);
 		DMEMIT("1 %u ", rs->md.chunk_sectors);
 
@@ -469,19 +488,28 @@ static void raid_io_hints(struct dm_target *ti,
 static void raid_presuspend(struct dm_target *ti)
 {
 	struct raid_set *rs = ti->private;
+	struct dm_dirty_log *log = rs->md.bitmap_info.log;
+
 	md_stop_writes(&rs->md);
+	log->type->presuspend(log);
 }
 
 static void raid_postsuspend(struct dm_target *ti)
 {
 	struct raid_set *rs = ti->private;
+	struct dm_dirty_log *log = rs->md.bitmap_info.log;
+
 	mddev_suspend(&rs->md);
+	log->type->postsuspend(log);
 }
 
 static void raid_resume(struct dm_target *ti)
 {
 	struct raid_set *rs = ti->private;
+	struct dm_dirty_log *log = rs->md.bitmap_info.log;
 
+	log->type->resume(log);
+	bitmap_load(&rs->md);
 	mddev_resume(&rs->md);
 }
 



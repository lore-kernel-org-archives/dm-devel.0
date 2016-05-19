From: heinzm@redhat.com
Subject: [PATCH 01/11] dm-raid: rename variable 'ret' to 'r' to
	conform to other dm code
Date: Thu, 19 May 2016 18:49:24 +0200
Message-ID: <1463676574-12596-2-git-send-email-heinzm@redhat.com>
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
Cc: Heinz Mauelshagen <heinzm@redhat.com>
List-Id: dm-devel.ids

From: Heinz Mauelshagen <heinzm@redhat.com>

Change return variable name for conformance reasons.

Signed-off-by: Heinz Mauelshagen <heinzm@redhat.com>
---
 drivers/md/dm-raid.c | 68 +++++++++++++++++++++++++++-------------------------
 1 file changed, 36 insertions(+), 32 deletions(-)

diff --git a/drivers/md/dm-raid.c b/drivers/md/dm-raid.c
index a090121..91af447 100644
--- a/drivers/md/dm-raid.c
+++ b/drivers/md/dm-raid.c
@@ -225,7 +225,7 @@ static int dev_parms(struct raid_set *rs, char **argv)
 	int i;
 	int rebuild = 0;
 	int metadata_available = 0;
-	int ret = 0;
+	int r = 0;
 
 	for (i = 0; i < rs->md.raid_disks; i++, argv += 2) {
 		rs->dev[i].rdev.raid_disk = i;
@@ -241,12 +241,12 @@ static int dev_parms(struct raid_set *rs, char **argv)
 		rs->dev[i].rdev.mddev = &rs->md;
 
 		if (strcmp(argv[0], "-")) {
-			ret = dm_get_device(rs->ti, argv[0],
+			r = dm_get_device(rs->ti, argv[0],
 					    dm_table_get_mode(rs->ti->table),
 					    &rs->dev[i].meta_dev);
 			rs->ti->error = "RAID metadata device lookup failure";
-			if (ret)
-				return ret;
+			if (r)
+				return r;
 
 			rs->dev[i].rdev.sb_page = alloc_page(GFP_KERNEL);
 			if (!rs->dev[i].rdev.sb_page)
@@ -267,12 +267,12 @@ static int dev_parms(struct raid_set *rs, char **argv)
 			continue;
 		}
 
-		ret = dm_get_device(rs->ti, argv[1],
+		r = dm_get_device(rs->ti, argv[1],
 				    dm_table_get_mode(rs->ti->table),
 				    &rs->dev[i].data_dev);
-		if (ret) {
+		if (r) {
 			rs->ti->error = "RAID device lookup failure";
-			return ret;
+			return r;
 		}
 
 		if (rs->dev[i].meta_dev) {
@@ -848,7 +848,7 @@ static void super_sync(struct mddev *mddev, struct md_rdev *rdev)
  */
 static int super_load(struct md_rdev *rdev, struct md_rdev *refdev)
 {
-	int ret;
+	int r;
 	struct dm_raid_superblock *sb;
 	struct dm_raid_superblock *refsb;
 	uint64_t events_sb, events_refsb;
@@ -860,9 +860,9 @@ static int super_load(struct md_rdev *rdev, struct md_rdev *refdev)
 		return -EINVAL;
 	}
 
-	ret = read_disk_sb(rdev, rdev->sb_size);
-	if (ret)
-		return ret;
+	r = read_disk_sb(rdev, rdev->sb_size);
+	if (r)
+		return r;
 
 	sb = page_address(rdev->sb_page);
 
@@ -1067,7 +1067,7 @@ static int super_validate(struct raid_set *rs, struct md_rdev *rdev)
  */
 static int analyse_superblocks(struct dm_target *ti, struct raid_set *rs)
 {
-	int ret;
+	int r;
 	struct raid_dev *dev;
 	struct md_rdev *rdev, *tmp, *freshest;
 	struct mddev *mddev = &rs->md;
@@ -1092,9 +1092,9 @@ static int analyse_superblocks(struct dm_target *ti, struct raid_set *rs)
 		if (!rdev->meta_bdev)
 			continue;
 
-		ret = super_load(rdev, freshest);
+		r = super_load(rdev, freshest);
 
-		switch (ret) {
+		switch (r) {
 		case 1:
 			freshest = rdev;
 			break;
@@ -1202,17 +1202,21 @@ static void configure_discard_support(struct dm_target *ti, struct raid_set *rs)
 }
 
 /*
- * Construct a RAID4/5/6 mapping:
+ * Construct a RAID0/1/10/4/5/6 mapping:
  * Args:
- *	<raid_type> <#raid_params> <raid_params>		\
- *	<#raid_devs> { <meta_dev1> <dev1> .. <meta_devN> <devN> }
+ *      <raid_type> <#raid_params> <raid_params>{0,}    \
+ *      <#raid_devs> [<meta_dev1> <dev1>]{1,}
  *
  * <raid_params> varies by <raid_type>.  See 'parse_raid_params' for
  * details on possible <raid_params>.
+ *
+ * Userspace is free to initialize the metadata devices, hence the superblocks to
+ * enforce recreation based on the passed in table parameters.
+ *
  */
 static int raid_ctr(struct dm_target *ti, unsigned argc, char **argv)
 {
-	int ret;
+	int r;
 	struct raid_type *rt;
 	unsigned long num_raid_params, num_raid_devs;
 	struct raid_set *rs = NULL;
@@ -1262,19 +1266,19 @@ static int raid_ctr(struct dm_target *ti, unsigned argc, char **argv)
 	if (IS_ERR(rs))
 		return PTR_ERR(rs);
 
-	ret = parse_raid_params(rs, argv, (unsigned)num_raid_params);
-	if (ret)
+	r = parse_raid_params(rs, argv, (unsigned)num_raid_params);
+	if (r)
 		goto bad;
 
 	argv += num_raid_params + 1;
 
-	ret = dev_parms(rs, argv);
-	if (ret)
+	r = dev_parms(rs, argv);
+	if (r)
 		goto bad;
 
 	rs->md.sync_super = super_sync;
-	ret = analyse_superblocks(ti, rs);
-	if (ret)
+	r = analyse_superblocks(ti, rs);
+	if (r)
 		goto bad;
 
 	INIT_WORK(&rs->md.event_work, do_table_event);
@@ -1288,18 +1292,18 @@ static int raid_ctr(struct dm_target *ti, unsigned argc, char **argv)
 
 	/* Has to be held on running the array */
 	mddev_lock_nointr(&rs->md);
-	ret = md_run(&rs->md);
+	r = md_run(&rs->md);
 	rs->md.in_sync = 0; /* Assume already marked dirty */
 	mddev_unlock(&rs->md);
 
-	if (ret) {
+	if (r) {
 		ti->error = "Fail to run raid array";
 		goto bad;
 	}
 
 	if (ti->len != rs->md.array_sectors) {
 		ti->error = "Array size does not match requested target length";
-		ret = -EINVAL;
+		r = -EINVAL;
 		goto size_mismatch;
 	}
 	rs->callbacks.congested_fn = raid_is_congested;
@@ -1313,7 +1317,7 @@ size_mismatch:
 bad:
 	context_free(rs);
 
-	return ret;
+	return r;
 }
 
 static void raid_dtr(struct dm_target *ti)
@@ -1598,17 +1602,17 @@ static int raid_iterate_devices(struct dm_target *ti,
 {
 	struct raid_set *rs = ti->private;
 	unsigned i;
-	int ret = 0;
+	int r = 0;
 
-	for (i = 0; !ret && i < rs->md.raid_disks; i++)
+	for (i = 0; !r && i < rs->md.raid_disks; i++)
 		if (rs->dev[i].data_dev)
-			ret = fn(ti,
+			r = fn(ti,
 				 rs->dev[i].data_dev,
 				 0, /* No offset on data devs */
 				 rs->md.dev_sectors,
 				 data);
 
-	return ret;
+	return r;
 }
 
 static void raid_io_hints(struct dm_target *ti, struct queue_limits *limits)
-- 
2.5.5

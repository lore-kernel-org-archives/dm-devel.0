Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D70B7168BD
	for <dm-devel@lists.linux.dev>; Wed, 25 Oct 2023 07:23:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="usVEbZXV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7700EC433C8;
	Wed, 25 Oct 2023 07:23:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1698218614;
	bh=oGqg9BVT44XIhyxecxIRfnZo6S12Yozdd/uBNLw+ch0=;
	h=From:To:Cc:Subject:Date:From;
	b=usVEbZXVzAztDd5sa3EPZZeWafHdPV27qY2qanZdGYCuNMHwJ547ue1WAQ72qPAj7
	 N3SAB4/ZkKBoz417JvIw6nuP8GkLf37vREQejLq+MDxvda2KbiOyHvpxFjZ85bt8CX
	 1CRfWE4aW48luNhZWzicPo23VSE/GANKKk0LocYjOoqMTagRHFISOd2EjH0gCAD+hY
	 vCKi84mDtuJ78lCzp8uSjcw/cBmXAfpgaYbyG9mHbQuJuMl73RI4Mutf3wpQ6d8hPz
	 FmrhugqHy+LK0zWTdIjr0hM8Ex/zlGWyJztEyQTMcYk+vk0JgQYf1h/U62GF5iqzXL
	 2WdBGLI3Tbhvw==
From: Damien Le Moal <dlemoal@kernel.org>
To: dm-devel@lists.linux.dev,
	Mike Snitzer <snitzer@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>,
	Naohiro Aota <naohiro.aota@wdc.com>
Subject: [PATCH v2] dm: error: Add support for zoned block devices
Date: Wed, 25 Oct 2023 16:23:32 +0900
Message-ID: <20231025072332.465595-1-dlemoal@kernel.org>
X-Mailer: git-send-email 2.41.0
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

dm-error is used in several test cases in the xfstests test suite to
check the handling of IO errors in file systems. However, with several
file systems getting native support for zoned block devices (e.g. btrfs
and f2fs), dm-error lack of zoned block device support creates problems
as the file system attempt executing zone commands (e.g. a zone append
operation) against a dm-error non-zoned block device, which causes
various issues in the block layer (e.g. WARN_ON triggers).

This patch adds supports for zoned block devices to dm-error, allowing
an error table to be exposed as a zoned block device. This is done by
relying on the first argument passed to dmsetup when creating the device
table: if that first argument is a path to a backing block device, the
dm-error device is created by copying the limits of the backing device,
thus also copying its zone model. This is consistent with how xfstests
creates dm-error devices (always passing the path to the backing device
as the first argument).

The zone support for dm-error requires the definition of the
report_zones target type method, which is done by introducing the
function io_err_report_zones(). Given that this function fails report
zones operations (similarly to any other command issued to the dm-error
device), dm_set_zones_restrictions() is tweaked to do nothing for a
wildcard target to avoid failing zone revalidation. As the dm-error
target does not implement the iterate_devices method,
dm_table_supports_zoned_model() is also changed to return true.

Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Tested-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
---
Changes from v1:
 - Improved comment in io_err_ctr() about error from dm_get_device()
   being ignored
 - Fixed typos in the commit message
 - Added review and tested-by tags

 drivers/md/dm-table.c  |  3 +++
 drivers/md/dm-target.c | 45 ++++++++++++++++++++++++++++++++++++++++--
 drivers/md/dm-zone.c   |  9 +++++++++
 3 files changed, 55 insertions(+), 2 deletions(-)

diff --git a/drivers/md/dm-table.c b/drivers/md/dm-table.c
index 37b48f63ae6a..5e4d887063d3 100644
--- a/drivers/md/dm-table.c
+++ b/drivers/md/dm-table.c
@@ -1600,6 +1600,9 @@ static bool dm_table_supports_zoned_model(struct dm_table *t,
 	for (unsigned int i = 0; i < t->num_targets; i++) {
 		struct dm_target *ti = dm_table_get_target(t, i);
 
+		if (dm_target_is_wildcard(ti->type))
+			continue;
+
 		if (dm_target_supports_zoned_hm(ti->type)) {
 			if (!ti->type->iterate_devices ||
 			    ti->type->iterate_devices(ti, device_not_zoned_model,
diff --git a/drivers/md/dm-target.c b/drivers/md/dm-target.c
index 27e2992ff249..fcb2ba2bffa2 100644
--- a/drivers/md/dm-target.c
+++ b/drivers/md/dm-target.c
@@ -118,6 +118,24 @@ EXPORT_SYMBOL(dm_unregister_target);
  */
 static int io_err_ctr(struct dm_target *tt, unsigned int argc, char **args)
 {
+	struct dm_dev *ddev;
+	int ret;
+
+	/*
+	 * If we have an argument, assume it is the path to the backing
+	 * block device that we are replacing. In this case, get the device
+	 * so that we can copy its limits in io_err_io_hints(). If getting the
+	 * device fails (e.g. because the user did not specify a device file
+	 * path), ignore the error to be compatible with the normal use case
+	 * without any argument specified.
+	 */
+	if (argc) {
+		ret = dm_get_device(tt, args[0], dm_table_get_mode(tt->table),
+				    &ddev);
+		if (ret == 0)
+			tt->private = ddev;
+	}
+
 	/*
 	 * Return error for discards instead of -EOPNOTSUPP
 	 */
@@ -129,7 +147,10 @@ static int io_err_ctr(struct dm_target *tt, unsigned int argc, char **args)
 
 static void io_err_dtr(struct dm_target *tt)
 {
-	/* empty */
+	struct dm_dev *ddev = tt->private;
+
+	if (ddev)
+		dm_put_device(tt, ddev);
 }
 
 static int io_err_map(struct dm_target *tt, struct bio *bio)
@@ -149,8 +170,27 @@ static void io_err_release_clone_rq(struct request *clone,
 {
 }
 
+#ifdef CONFIG_BLK_DEV_ZONED
+static int io_err_report_zones(struct dm_target *ti,
+		struct dm_report_zones_args *args, unsigned int nr_zones)
+{
+	return -EIO;
+}
+#else
+#define io_err_report_zones NULL
+#endif
+
 static void io_err_io_hints(struct dm_target *ti, struct queue_limits *limits)
 {
+	struct dm_dev *ddev = ti->private;
+
+	/* If we have a target device, copy its limits */
+	if (ddev) {
+		struct request_queue *q = bdev_get_queue(ddev->bdev);
+
+		memcpy(limits, &q->limits, sizeof(*limits));
+	}
+
 	limits->max_discard_sectors = UINT_MAX;
 	limits->max_hw_discard_sectors = UINT_MAX;
 	limits->discard_granularity = 512;
@@ -166,7 +206,7 @@ static long io_err_dax_direct_access(struct dm_target *ti, pgoff_t pgoff,
 static struct target_type error_target = {
 	.name = "error",
 	.version = {1, 6, 0},
-	.features = DM_TARGET_WILDCARD,
+	.features = DM_TARGET_WILDCARD | DM_TARGET_ZONED_HM,
 	.ctr  = io_err_ctr,
 	.dtr  = io_err_dtr,
 	.map  = io_err_map,
@@ -174,6 +214,7 @@ static struct target_type error_target = {
 	.release_clone_rq = io_err_release_clone_rq,
 	.io_hints = io_err_io_hints,
 	.direct_access = io_err_dax_direct_access,
+	.report_zones = io_err_report_zones,
 };
 
 int __init dm_target_init(void)
diff --git a/drivers/md/dm-zone.c b/drivers/md/dm-zone.c
index eb9832b22b14..9b77ee05e8dd 100644
--- a/drivers/md/dm-zone.c
+++ b/drivers/md/dm-zone.c
@@ -297,6 +297,15 @@ int dm_set_zones_restrictions(struct dm_table *t, struct request_queue *q)
 	WARN_ON_ONCE(queue_is_mq(q));
 	md->disk->nr_zones = bdev_nr_zones(md->disk->part0);
 
+	/*
+	 * With dm-error (wildcard target), report zones will fail, so do
+	 * nothing. dm-error will copy the zones limits itself.
+	 */
+	if (dm_table_get_wildcard_target(t)) {
+		md->nr_zones = md->disk->nr_zones;
+		return 0;
+	}
+
 	/* Check if zone append is natively supported */
 	if (dm_table_supports_zone_append(t)) {
 		clear_bit(DMF_EMULATE_ZONE_APPEND, &md->flags);
-- 
2.41.0


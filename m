Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60FD7C131
	for <dm-devel@lists.linux.dev>; Thu, 26 Oct 2023 05:12:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="N98oAl0e"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A110C433C7;
	Thu, 26 Oct 2023 05:12:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1698297127;
	bh=ian9xHkswZ1cWVN38+Tbv81IuS/aA1ErSRe/WX2bqsg=;
	h=From:To:Cc:Subject:Date:From;
	b=N98oAl0eFffyoTV5XmfjVSrsKzM9B2d7gadNtvbVmSYmmm49pBbDkUIuqFbOrclyI
	 bEA4LleWSBulTzS9xBbOzJXrRHoexo1WS4NzzsddgEOywsLpZvFrQcJhbslsh6D8YO
	 IUSWtVI1uK24UOCPR6SK/486gzS/GzRk4tqZzC7ZaACALNx0q7xTWv148hKz9x9O/4
	 k81Df9jt2SdOSl3HEEoBF8ADJ2Qc8wfgNQh9vteWhtIteUdUxCHhqNX/OqJPLuGHQy
	 6pvx+NmI5sxeuHGT9EP6wS6p/nC0MAvOngz63cF+Pld5Ml3UyAgkYT8cZqPiOtzoCT
	 TEwbvJZGdq5RA==
From: Damien Le Moal <dlemoal@kernel.org>
To: dm-devel@lists.linux.dev,
	Mike Snitzer <snitzer@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>,
	Naohiro Aota <naohiro.aota@wdc.com>
Subject: [PATCH v3] dm: error: Add support for zoned block devices
Date: Thu, 26 Oct 2023 14:12:05 +0900
Message-ID: <20231026051205.95209-1-dlemoal@kernel.org>
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
an md device table containing an error target to be exposed as a zoned
block device (if all targets have a compatible zoned model support and
mapping). This is done as follows:
1) Allow passing 2 arguments to an error target, similarly to dm-linear:
   a backing device and a start sector. These arguments are optional and
   dm-error retains its characteristics if the arguments are not
   specified.
2) Implement the iterate_devices method so that dm-core can normally
   check the zone support and restrictions (e.g. zone alignment of the
   targets). When the backing device arguments are not specified, the
   iterate_devices method never calls the fn() argument.
When no backing device is specified, as before, we assume that the DM
device is not zoned. When the backing devie arguments are specified, the
zoned model of the DM device will depend on the backing device type:
 - If the backing device is zoned and its model and mapping is
   compatible with other targets of the device, the resulting device
   will be zoned, with the dm-error mapped portion always returning
   errors (similarly to the default non-zoned case).
 - If the backing devie is not zoned, then the DM device will not be
   either.

This zone support for dm-error requires the definition of a functional
report_zones operation so that dm_revalidate_zones() can operate
correctly and resources for emulating zone append operations
initialized. This is necessary for cases where dm-error is used to
partially map a device and have an overall correct handling of zone
append. This means that dm-error does not fail report zones operations.

Two changes that are not obvious are included to avoid issues:
1) dm_table_supports_zoned_model() is changed to directly check if
   the backing device of a wildcard target (= dm-error target) is zoned.
   Otherwise, when the invalid setup of dm-error being set without a
   backing device (non zoned case) and combined with zoned targets
   cannot be cought.
2) dm_table_supports_dax() is modified to return false if the wildcard
   target is found. Otherwise, when dm-error is set without a backing
   device, we end up with a NULL pointer dereference in
   set_dax_synchronous dax_dev is NULL. This is consistent with the
   current behavior because dm_table_supports_dax() always returned fals
   for targets that do not define the iterate_devices method.

Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
---
 drivers/md/dm-table.c  |  23 ++++++++-
 drivers/md/dm-target.c | 104 ++++++++++++++++++++++++++++++++++++++++-
 2 files changed, 124 insertions(+), 3 deletions(-)

diff --git a/drivers/md/dm-table.c b/drivers/md/dm-table.c
index 37b48f63ae6a..9836c8ada9b8 100644
--- a/drivers/md/dm-table.c
+++ b/drivers/md/dm-table.c
@@ -844,7 +844,8 @@ static bool dm_table_supports_dax(struct dm_table *t,
 		if (!ti->type->direct_access)
 			return false;
 
-		if (!ti->type->iterate_devices ||
+		if (dm_target_is_wildcard(ti->type) ||
+		    !ti->type->iterate_devices ||
 		    ti->type->iterate_devices(ti, iterate_fn, NULL))
 			return false;
 	}
@@ -1587,6 +1588,14 @@ static int device_not_zoned_model(struct dm_target *ti, struct dm_dev *dev,
 	return blk_queue_zoned_model(q) != *zoned_model;
 }
 
+static int device_is_zoned_model(struct dm_target *ti, struct dm_dev *dev,
+				 sector_t start, sector_t len, void *data)
+{
+	struct request_queue *q = bdev_get_queue(dev->bdev);
+
+	return blk_queue_zoned_model(q) != BLK_ZONED_NONE;
+}
+
 /*
  * Check the device zoned model based on the target feature flag. If the target
  * has the DM_TARGET_ZONED_HM feature flag set, host-managed zoned devices are
@@ -1600,6 +1609,18 @@ static bool dm_table_supports_zoned_model(struct dm_table *t,
 	for (unsigned int i = 0; i < t->num_targets; i++) {
 		struct dm_target *ti = dm_table_get_target(t, i);
 
+		/*
+		 * For the wildcard target (dm-error), if we do not have a
+		 * backing device, we must always return false. If we have a
+		 * backing device, the result must depend on tcking device zoned
+		 * model, like for any other target. So for this, check directly
+		 * if the target backing device is zoned as we get "false" when
+		 * dm-error was set without a backing device.
+		 */
+		if (dm_target_is_wildcard(ti->type) &&
+		    !ti->type->iterate_devices(ti, device_is_zoned_model, NULL))
+			return false;
+
 		if (dm_target_supports_zoned_hm(ti->type)) {
 			if (!ti->type->iterate_devices ||
 			    ti->type->iterate_devices(ti, device_not_zoned_model,
diff --git a/drivers/md/dm-target.c b/drivers/md/dm-target.c
index 27e2992ff249..560ade7d3318 100644
--- a/drivers/md/dm-target.c
+++ b/drivers/md/dm-target.c
@@ -116,8 +116,62 @@ EXPORT_SYMBOL(dm_unregister_target);
  * io-err: always fails an io, useful for bringing
  * up LVs that have holes in them.
  */
+struct io_err_c {
+	struct dm_dev *dev;
+	sector_t start;
+};
+
+static int io_err_get_args(struct dm_target *tt, unsigned int argc, char **args)
+{
+	unsigned long long start;
+	struct io_err_c *ioec;
+	char dummy;
+	int ret;
+
+	ioec = kmalloc(sizeof(*ioec), GFP_KERNEL);
+	if (!ioec) {
+		tt->error = "Cannot allocate io_err context";
+		return -ENOMEM;
+	}
+
+	ret = -EINVAL;
+	if (sscanf(args[1], "%llu%c", &start, &dummy) != 1 ||
+	    start != (sector_t)start) {
+		tt->error = "Invalid device sector";
+		goto bad;
+	}
+	ioec->start = start;
+
+	ret = dm_get_device(tt, args[0], dm_table_get_mode(tt->table), &ioec->dev);
+	if (ret) {
+		tt->error = "Device lookup failed";
+		goto bad;
+	}
+
+	tt->private = ioec;
+
+	return 0;
+
+bad:
+	kfree(ioec);
+
+	return ret;
+}
+
 static int io_err_ctr(struct dm_target *tt, unsigned int argc, char **args)
 {
+	/*
+	 * If we have arguments, assume it is the path to the backing
+	 * block device and its mapping start sector (same as dm-linear).
+	 * In this case, get the device so that we can get its limits.
+	 */
+	if (argc == 2) {
+		int ret = io_err_get_args(tt, argc, args);
+
+		if (ret)
+			return ret;
+	}
+
 	/*
 	 * Return error for discards instead of -EOPNOTSUPP
 	 */
@@ -129,7 +183,12 @@ static int io_err_ctr(struct dm_target *tt, unsigned int argc, char **args)
 
 static void io_err_dtr(struct dm_target *tt)
 {
-	/* empty */
+	struct io_err_c *ioec = tt->private;
+
+	if (ioec) {
+		dm_put_device(tt, ioec->dev);
+		kfree(ioec);
+	}
 }
 
 static int io_err_map(struct dm_target *tt, struct bio *bio)
@@ -149,6 +208,45 @@ static void io_err_release_clone_rq(struct request *clone,
 {
 }
 
+#ifdef CONFIG_BLK_DEV_ZONED
+static sector_t io_err_map_sector(struct dm_target *ti, sector_t bi_sector)
+{
+	struct io_err_c *ioec = ti->private;
+
+	return ioec->start + dm_target_offset(ti, bi_sector);
+}
+
+static int io_err_report_zones(struct dm_target *ti,
+		struct dm_report_zones_args *args, unsigned int nr_zones)
+{
+	struct io_err_c *ioec = ti->private;
+
+	/*
+	 * This should never be called when we do not have a backing device
+	 * as that mean the target is not a zoned one.
+	 */
+	if (WARN_ON_ONCE(!ioec))
+		return -EIO;
+
+	return dm_report_zones(ioec->dev->bdev, ioec->start,
+			       io_err_map_sector(ti, args->next_sector),
+			       args, nr_zones);
+}
+#else
+#define io_err_report_zones NULL
+#endif
+
+static int io_err_iterate_devices(struct dm_target *ti,
+				  iterate_devices_callout_fn fn, void *data)
+{
+	struct io_err_c *ioec = ti->private;
+
+	if (!ioec)
+		return 0;
+
+	return fn(ti, ioec->dev, ioec->start, ti->len, data);
+}
+
 static void io_err_io_hints(struct dm_target *ti, struct queue_limits *limits)
 {
 	limits->max_discard_sectors = UINT_MAX;
@@ -166,14 +264,16 @@ static long io_err_dax_direct_access(struct dm_target *ti, pgoff_t pgoff,
 static struct target_type error_target = {
 	.name = "error",
 	.version = {1, 6, 0},
-	.features = DM_TARGET_WILDCARD,
+	.features = DM_TARGET_WILDCARD | DM_TARGET_ZONED_HM,
 	.ctr  = io_err_ctr,
 	.dtr  = io_err_dtr,
 	.map  = io_err_map,
 	.clone_and_map_rq = io_err_clone_and_map_rq,
 	.release_clone_rq = io_err_release_clone_rq,
+	.iterate_devices = io_err_iterate_devices,
 	.io_hints = io_err_io_hints,
 	.direct_access = io_err_dax_direct_access,
+	.report_zones = io_err_report_zones,
 };
 
 int __init dm_target_init(void)
-- 
2.41.0


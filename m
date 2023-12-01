Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D449C17CF
	for <dm-devel@lists.linux.dev>; Fri,  1 Dec 2023 02:03:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="odgzA57X"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 11E81C433C8;
	Fri,  1 Dec 2023 02:03:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1701396212;
	bh=bCzSLVhkBJWwSKsZ0nT1dDKE3mFd0ANfKI6RYi+QuxE=;
	h=From:To:Cc:Subject:Date:From;
	b=odgzA57Xcz1b/t9dRzZFVlKa+sSE2sCr/8GutF/If3sDjOYLk/n8Q5ffdnjb3cUuF
	 WffNO78qYgbMqrRpiKCclzTmLHfxbGp66o2GVUIPAd2KxIyIE0WQUd7ecbPDtknLJQ
	 deDKhAhMCceaV3c1rsm6XDQZNfNCcWDJF90v6EasidUUkwha3Dk07mU0+OOjksMYMp
	 MIi2/xok28mvzfB4N7uFA3j6nD2NkNe/82TZeCK1E15khfO+uOVCpUVvOP0j6sVj57
	 lka7l7FpvAqk/TtPHHe6NpPTXv6qtFD4QIodxMzbkUUy0I62OlVj20JygfJ/CqjTUK
	 FQShXaeqCQbFg==
From: Damien Le Moal <dlemoal@kernel.org>
To: dm-devel@lists.linux.dev,
	Mike Snitzer <snitzer@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>,
	Naohiro Aota <naohiro.aota@wdc.com>
Subject: [PATCH] dm: Validate zoned model of devices built with zoned targets
Date: Fri,  1 Dec 2023 11:03:29 +0900
Message-ID: <20231201020329.273592-1-dlemoal@kernel.org>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Using dm-linear or dm-error, a user can craft a DM device using
host-managed SMR disks by mapping only conventional zones. Currently,
such DM device will be reported also as being host-managed, despite the
fact that this zoned model mandated sequential-write-required zone are
not present. This breaks the host-managed model and may confuse some
applications, potentially resulting in unexpected behavior or bugs.

A simple solution for such case is to expose a DM device built only
using an SMR host managed disk conventional zones as a regular device.
This is acceptable and possible because read and write accesses to
conventional zones do not have any restrictions and can cross zone
boundaries.

This commit introduces the function dm_validate_zoned_model() to detect
if a zoned DM device contains only conventional zones. If it does, this
function calls disk_set_zoned() to change the DM device queue zoned
model to BLK_ZONED_NONE, clearing in the process also the queue limits
associated with zoned block devices (e.g. chunk_sectors for the zone
size, number of zones, etc). dm_validate_zoned_model() is called from
dm_table_set_restrictions() when the DM device request queue is set up.

With this change, dm-linear and dm-error devices built using
conventional zones are now exposed as regular block devices.

Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
---
 drivers/md/dm-table.c | 13 +++++++++
 drivers/md/dm-zone.c  | 63 +++++++++++++++++++++++++++++++++++++++++++
 drivers/md/dm.h       |  1 +
 3 files changed, 77 insertions(+)

diff --git a/drivers/md/dm-table.c b/drivers/md/dm-table.c
index 198d38b53322..9c7547da6171 100644
--- a/drivers/md/dm-table.c
+++ b/drivers/md/dm-table.c
@@ -2034,6 +2034,19 @@ int dm_table_set_restrictions(struct dm_table *t, struct request_queue *q,
 	    dm_table_any_dev_attr(t, device_is_not_random, NULL))
 		blk_queue_flag_clear(QUEUE_FLAG_ADD_RANDOM, q);
 
+	/*
+	 * A zoned target may contain only conventional zones, in which case
+	 * we must set the device queue zoned model to BLK_ZONED_NONE to
+	 * expose the target as a regular block device, and thus avoiding
+	 * breaking the host-managed zoned model as it mandates the presence
+	 * of sequential write required zones.
+	 */
+	if (blk_queue_is_zoned(q)) {
+		r = dm_validate_zoned_model(t, q);
+		if (r)
+			return r;
+	}
+
 	/*
 	 * For a zoned target, setup the zones related queue attributes
 	 * and resources necessary for zone append emulation if necessary.
diff --git a/drivers/md/dm-zone.c b/drivers/md/dm-zone.c
index eb9832b22b14..452a59bfdc10 100644
--- a/drivers/md/dm-zone.c
+++ b/drivers/md/dm-zone.c
@@ -174,6 +174,69 @@ static unsigned int dm_get_zone_wp_offset(struct blk_zone *zone)
 	}
 }
 
+struct dm_zone_count {
+	unsigned long nr_conv;
+	unsigned long nr_seq;
+};
+
+static int dm_validate_zoned_model_cb(struct blk_zone *zone, unsigned int idx,
+				      void *data)
+{
+	struct dm_zone_count *zc = data;
+
+	switch (zone->type) {
+	case BLK_ZONE_TYPE_CONVENTIONAL:
+		zc->nr_conv++;
+		break;
+	case BLK_ZONE_TYPE_SEQWRITE_REQ:
+	case BLK_ZONE_TYPE_SEQWRITE_PREF:
+		zc->nr_seq++;
+		break;
+	default:
+		DMERR("Invalid zone type 0x%x at sectors %llu",
+		      (int)zone->type, zone->start);
+		return -ENODEV;
+	}
+
+	return 0;
+}
+
+/*
+ * Validate the queue zoned model by counting the conventional and
+ * sequential zones of the target. If no sequential zones are present, modify
+ * the device queue to expose it as a regular block device.
+ */
+int dm_validate_zoned_model(struct dm_table *t, struct request_queue *q)
+{
+	struct mapped_device *md = t->md;
+	struct gendisk *disk = md->disk;
+	unsigned int nr_zones = bdev_nr_zones(disk->part0);
+	struct dm_zone_count zc = { };
+	unsigned int noio_flag;
+	int ret;
+
+	/* Count conventional and sequential zones */
+	noio_flag = memalloc_noio_save();
+	ret = dm_blk_do_report_zones(md, t, 0, nr_zones,
+				     dm_validate_zoned_model_cb, &zc);
+	memalloc_noio_restore(noio_flag);
+	if (ret != nr_zones ||
+	    zc.nr_conv + zc.nr_seq != nr_zones)
+		ret = -EIO;
+	if (ret < 0)
+		goto err;
+
+	if (!zc.nr_seq)
+		disk_set_zoned(disk, BLK_ZONED_NONE);
+
+	return 0;
+
+err:
+	DMERR("Validate zoned model failed %d", ret);
+	dm_cleanup_zoned_dev(md);
+	return ret;
+}
+
 static int dm_zone_revalidate_cb(struct blk_zone *zone, unsigned int idx,
 				 void *data)
 {
diff --git a/drivers/md/dm.h b/drivers/md/dm.h
index 7f1acbf6bd9e..c3e6afed3910 100644
--- a/drivers/md/dm.h
+++ b/drivers/md/dm.h
@@ -101,6 +101,7 @@ int dm_setup_md_queue(struct mapped_device *md, struct dm_table *t);
 /*
  * Zoned targets related functions.
  */
+int dm_validate_zoned_model(struct dm_table *t, struct request_queue *q);
 int dm_set_zones_restrictions(struct dm_table *t, struct request_queue *q);
 void dm_zone_endio(struct dm_io *io, struct bio *clone);
 #ifdef CONFIG_BLK_DEV_ZONED
-- 
2.43.0


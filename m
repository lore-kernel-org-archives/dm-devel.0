From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [PATCH v3 00/10] dm: zoned block device support
Date: Thu, 25 May 2017 22:12:12 -0400
Message-ID: <20170526021211.GA33284@redhat.com>
References: <20170508234052.32375-1-bart.vanassche@sandisk.com>
	<20170516200356.GA17063@redhat.com>
	<20170517185434.GC21862@redhat.com>
	<22BA92ED-D53B-4206-9DF3-BDFBB6F3E1DB@hgst.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <22BA92ED-D53B-4206-9DF3-BDFBB6F3E1DB@hgst.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Damien Le Moal <Damien.LeMoal@wdc.com>
Cc: Bart Van Assche <Bart.VanAssche@sandisk.com>, "dm-devel@redhat.com" <dm-devel@redhat.com>, Christoph Hellwig <hch@lst.de>, Alasdair Kergon <agk@redhat.com>
List-Id: dm-devel.ids

On Wed, May 17 2017 at  9:55P -0400,
Damien Le Moal <Damien.LeMoal@wdc.com> wrote:

> Mike,
> 
> (resending using outlook as I am still having troubles reaching
> @redhat.com email domain with any other email client. My apologies
> if multiple copies of this email show up)
> 
> On 5/18/17 03:54, Mike Snitzer wrote:
> > On Tue, May 16 2017 at  4:03pm -0400,
> > Mike Snitzer <snitzer@redhat.com> wrote:
> >
> >> I see quite a few issues with this patchset (only gotten through patches
> >> 1 - 6).  I'll work through it in more detail and share my
> >> feedback/revisions tomorrow.  Mostly just cleanups, renames, etc.  But
> >> "the fun" is obviously once I get to the last patch.
> >
> > FYI, couldn't get to this like I planned.  And I'm taking some time off,
> > won't get back to this until next Tuesday (5/23).  To be clear, the
> > things I noticed in the preliminary patches were very benign, but do
> > need cleaning up.
> 
> Thank you for the review. Let me know the changes you would like to see
> and I will send an updated series.
> 
> > I have every intention of getting this reviewed and staged for 4.13.
> 
> That's great. Thanks.
> 
> > But would be useful to understand:
> > 1) who will be regression testing this target once it is merged?
> 
> Myself, Bart, and all other members of my team will be involved in
> maintaining and testing this. It is critical for us as an SMR disk
> vendor that those disks are supported correctly in Linux. So we will
> maintain and regression test all aspects of the zoned block device
> support constantly.
> 
> > 2) what is needed to test it? (I assume SMR drives?)
> 
> Yes, SMR drives, but not necessarily physical ones. We are working on
> adding ZBC support to the SCSI target (that is missing). With that, we
> are planning to create a tcm (or tcmu) driver to emulate a host-aware or
> host-managed disk for testing, with a regular disk or file as back-end
> storage. This was also requested by file system maintainers (BtrFS) to
> allow testing of zoned block device support even without physical SMR
> disks available.
> 
> Since zoned block device support spans the entire block I/O stack (from
> block layer API down to LLD, with device mapper and SCSI/libata in the
> middle) we are also starting to design new test cases for the newly
> released blktests infrastructure. This will allow automated testing,
> including device mapper targets that supports zoned block devices.
> 
> Ideally, we will try to release everything for inclusion in 4.13,
> together with the device mapper support. But all the test parts may get
> spread over one or two release cycles. But again, the goal is to have a
> comprehensive automated test suite for zoned block device, similar to
> what is available for regular block devices.

Thanks for all that context, much appreciated.

I'd like to get your thoughts on replacing the first 3 patches with
something like the following patch (_not_ compile tested).

Basically I'm not interested in training DM for hypothetical zoned block
device configurations.  I only want the bare minimum that is needed to
support the dm-zoned target at this point.  The fact that dm-zoned is
"drive managed" makes for a much more narrow validation (AFAICT anyway).
I dropped the zone_sectors validation -- we can backfill it if you feel
it important but I wanted to float this simplified patch as is:

diff --git a/drivers/md/dm-table.c b/drivers/md/dm-table.c
index 5f5eae4..0e4407e 100644
--- a/drivers/md/dm-table.c
+++ b/drivers/md/dm-table.c
@@ -340,6 +340,30 @@ static int device_area_is_invalid(struct dm_target *ti, struct dm_dev *dev,
 		return 1;
 	}
 
+	/*
+	 * If the target is mapped to zoned block device(s), check
+	 * that the zones are not partially mapped.
+	 */
+	if (bdev_zoned_model(bdev) != BLK_ZONED_NONE) {
+		unsigned int zone_sectors = bdev_zone_sectors(bdev);
+
+		if (start & (zone_sectors - 1)) {
+			DMWARN("%s: start=%llu not aligned to h/w zone size %u of %s",
+			       dm_device_name(ti->table->md),
+			       (unsigned long long)start,
+			       zone_sectors, bdevname(bdev, b));
+			return 1;
+		}
+
+		if (len & (zone_sectors - 1)) {
+			DMWARN("%s: len=%llu not aligned to h/w zone size %u of %s",
+			       dm_device_name(ti->table->md),
+			       (unsigned long long)len,
+			       zone_sectors, bdevname(bdev, b));
+			return 1;
+		}
+	}
+
 	return 0;
 }
 
@@ -456,6 +480,8 @@ static int dm_set_device_limits(struct dm_target *ti, struct dm_dev *dev,
 		       q->limits.alignment_offset,
 		       (unsigned long long) start << SECTOR_SHIFT);
 
+	limits->zoned = blk_queue_zoned_model(q);
+
 	return 0;
 }
 
@@ -1346,6 +1372,36 @@ bool dm_table_has_no_data_devices(struct dm_table *table)
 	return true;
 }
 
+static int device_is_zoned_model(struct dm_target *ti, struct dm_dev *dev,
+				 sector_t start, sector_t len, void *data)
+{
+	struct request_queue *q = bdev_get_queue(dev->bdev);
+	enum blk_zoned_model zoned_model = *data;
+
+	return q && blk_queue_zoned_model(q) == zoned_model;
+}
+
+static bool dm_table_supports_zoned_model(struct dm_table *t,
+					  enum blk_zoned_model zoned_model)
+{
+	struct dm_target *ti;
+	unsigned i;
+
+	for (i = 0; i < dm_table_get_num_targets(t); i++) {
+		ti = dm_table_get_target(t, i);
+
+		if (zoned_model == BLK_ZONED_HM &&
+		    !dm_target_supports_zoned_hm(ti->type))
+			return false;
+
+		if (!ti->type->iterate_devices ||
+		    !ti->type->iterate_devices(ti, device_is_zoned_model, &zoned_model))
+			return false;
+	}
+
+	return true;
+}
+
 /*
  * Establish the new table's queue_limits and validate them.
  */
@@ -1355,6 +1411,7 @@ int dm_calculate_queue_limits(struct dm_table *table,
 	struct dm_target *ti;
 	struct queue_limits ti_limits;
 	unsigned i;
+	enum blk_zoned_model zoned_model = BLK_ZONED_NONE;
 
 	blk_set_stacking_limits(limits);
 
@@ -1372,6 +1429,14 @@ int dm_calculate_queue_limits(struct dm_table *table,
 		ti->type->iterate_devices(ti, dm_set_device_limits,
 					  &ti_limits);
 
+		if (zoned_model == BLK_ZONED_NONE && ti_limits.zoned != BLK_ZONED_NONE) {
+			/*
+			 * After stacking all limits, validate all devices
+			 * in table support this zoned model.
+			 */
+			zoned_model = ti_limits.zoned;
+		}
+
 		/* Set I/O hints portion of queue limits */
 		if (ti->type->io_hints)
 			ti->type->io_hints(ti, &ti_limits);
@@ -1398,6 +1463,19 @@ int dm_calculate_queue_limits(struct dm_table *table,
 			       (unsigned long long) ti->len);
 	}
 
+	/*
+	 * Verify that the zoned model, as determined before any .io_hints
+	 * override, is the same across all devices in the table.
+	 * - but if limits->zoned is not BLK_ZONED_NONE validate match for it
+	 */
+	if (limits->zoned != BLK_ZONED_NONE)
+		zoned_model = limits->zoned;
+	if (!dm_table_supports_zoned_model(table, zoned_model)) {
+		DMERR("%s: zoned model is inconsistent across all devices"
+		      dm_device_name(table->md));
+		return -EINVAL;
+	}
+
 	return validate_hardware_logical_block_alignment(table, limits);
 }
 
diff --git a/include/linux/device-mapper.h b/include/linux/device-mapper.h
index f4c639c..d13fcd2 100644
--- a/include/linux/device-mapper.h
+++ b/include/linux/device-mapper.h
@@ -237,6 +237,12 @@ typedef unsigned (*dm_num_write_bios_fn) (struct dm_target *ti, struct bio *bio)
 #define DM_TARGET_PASSES_INTEGRITY	0x00000020
 #define dm_target_passes_integrity(type) ((type)->features & DM_TARGET_PASSES_INTEGRITY)
 
+/*
+ * Indicates that a target supports host-managed zoned block devices.
+ */
+#define DM_TARGET_ZONED_HM		0x00000040
+#define dm_target_supports_zoned_hm(type) ((type)->features & DM_TARGET_ZONED_HM)
+
 struct dm_target {
 	struct dm_table *table;
 	struct target_type *type;

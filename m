From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [PATCH v3 00/10] dm: zoned block device support
Date: Fri, 26 May 2017 10:27:41 -0400
Message-ID: <20170526142740.GA34211@redhat.com>
References: <20170508234052.32375-1-bart.vanassche@sandisk.com>
	<20170516200356.GA17063@redhat.com>
	<20170517185434.GC21862@redhat.com>
	<22BA92ED-D53B-4206-9DF3-BDFBB6F3E1DB@hgst.com>
	<20170526021211.GA33284@redhat.com>
	<7e0a0545-ee54-e367-5ea4-8b30e03cc10d@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <7e0a0545-ee54-e367-5ea4-8b30e03cc10d@wdc.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Damien Le Moal <damien.lemoal@wdc.com>
Cc: Bart Van Assche <Bart.VanAssche@sandisk.com>, "dm-devel@redhat.com" <dm-devel@redhat.com>, Christoph Hellwig <hch@lst.de>, Alasdair Kergon <agk@redhat.com>
List-Id: dm-devel.ids

On Fri, May 26 2017 at  5:10am -0400,
Damien Le Moal <damien.lemoal@wdc.com> wrote:

> Mike,
> 
> On 5/26/17 11:12, Mike Snitzer wrote:
> > I'd like to get your thoughts on replacing the first 3 patches with
> > something like the following patch (_not_ compile tested).
> > 
> > Basically I'm not interested in training DM for hypothetical zoned block
> > device configurations.  I only want the bare minimum that is needed to
> > support the dm-zoned target at this point.  The fact that dm-zoned is
> > "drive managed" makes for a much more narrow validation (AFAICT anyway).
> 
> Indeed, it does. And in fact, no patches to the current dm code is
> necessary for dm-zoned to compile and run. So the bare minimum for
> dm-zoned is itself. This comes from the fact that dm-zoned will not
> accept a target that is not an entire zoned block device, and only a
> single target is allowed per dm-zoned instance. And since the queue
> limit defaults currently to the NONE zone model, everything nicely fit
> with the characteristics of the disk that dm-zoned exposes.
> 
> dm-zoned was coded this way for simplicity. Otherwise, the scattering of
> conventional zones across different targets would have complicated
> things quite a bit with metadata and would also potentially have
> generated nasty performance characteristics.
> 
> In the series, patches 1-9 are solely for supporting zoned block devices
> in a clean manner, and in particular dm-flakey, for testing file systems
> with native zoned block device support, and dm-linear, because it is
> easy and allows separating conventional and sequential zones into
> different drives, with the conventional zones block device becoming a
> normal disk (we have quite a few customers wanting to use SMR drives in
> this manner).
> 
> > I dropped the zone_sectors validation -- we can backfill it if you feel
> > it important but I wanted to float this simplified patch as is:
> 
> I think it is. The constraints imposed on zoned block devices in Linux
> that are not mandated by the standards are that all zones of the device
> must be the same size and the size must be a power of 2 number of LBAs.
> Without validating that all devices of a target have an equal zone size,
> a device created with dm-linear for instance would end up exposing
> different zone sizes on the same block device. That would break the
> block layer handling of zones through chunk_sectors.
> 
> That said, the patch below looks very good, much cleaner than what I had
> done. Let me test it and I will report back.

OK, please apply this incremental patch that adds in zone_sectors
validation, thanks:

diff --git a/drivers/md/dm-table.c b/drivers/md/dm-table.c
index 0e4407e..53c794a 100644
--- a/drivers/md/dm-table.c
+++ b/drivers/md/dm-table.c
@@ -1402,6 +1402,41 @@ static bool dm_table_supports_zoned_model(struct dm_table *t,
 	return true;
 }
 
+static int device_matches_zone_sectors(struct dm_target *ti, struct dm_dev *dev,
+				       sector_t start, sector_t len, void *data)
+{
+	struct request_queue *q = bdev_get_queue(dev->bdev);
+	unsigned int zone_sectors = *data;
+
+	return q && blk_queue_zone_sectors(q) == zone_sectors;
+}
+
+static int validate_hardware_zoned_model(struct dm_table *table,
+					 enum blk_zoned_model zoned_model,
+					 unsigned int zone_sectors)
+{
+	if (!dm_table_supports_zoned_model(table, zoned_model)) {
+		DMERR("%s: zoned model is inconsistent across all devices",
+		      dm_device_name(table->md));
+		return -EINVAL;
+	}
+
+	if (zoned_model != BLK_ZONED_NONE) {
+		/* Check zone size validity and compatibility */
+		if (!zone_sectors || !is_power_of_2(zone_sectors))
+			return -EINVAL;
+
+		if (!ti->type->iterate_devices ||
+		    !ti->type->iterate_devices(ti, device_matches_zone_sectors, &zone_sectors)) {
+			DMERR("%s: zone sectors is inconsistent across all devices",
+			      dm_device_name(table->md));
+			return -EINVAL;
+		}
+	}
+
+	return 0;
+}
+
 /*
  * Establish the new table's queue_limits and validate them.
  */
@@ -1412,6 +1447,7 @@ int dm_calculate_queue_limits(struct dm_table *table,
 	struct queue_limits ti_limits;
 	unsigned i;
 	enum blk_zoned_model zoned_model = BLK_ZONED_NONE;
+	unsigned int zone_sectors;
 
 	blk_set_stacking_limits(limits);
 
@@ -1432,9 +1468,10 @@ int dm_calculate_queue_limits(struct dm_table *table,
 		if (zoned_model == BLK_ZONED_NONE && ti_limits.zoned != BLK_ZONED_NONE) {
 			/*
 			 * After stacking all limits, validate all devices
-			 * in table support this zoned model.
+			 * in table support this zoned model and zone sectors.
 			 */
 			zoned_model = ti_limits.zoned;
+			zone_sectors = ti_limits.chunk_sectors;
 		}
 
 		/* Set I/O hints portion of queue limits */
@@ -1464,17 +1501,18 @@ int dm_calculate_queue_limits(struct dm_table *table,
 	}
 
 	/*
-	 * Verify that the zoned model, as determined before any .io_hints
-	 * override, is the same across all devices in the table.
+	 * Verify that the zoned model and zone sectors, as determined before
+	 * any .io_hints override, are the same across all devices in the table.
 	 * - but if limits->zoned is not BLK_ZONED_NONE validate match for it
+	 * - simillarly, check all devices conform to limits->chunk_sectors if
+	 *   .io_hints altered them
 	 */
 	if (limits->zoned != BLK_ZONED_NONE)
 		zoned_model = limits->zoned;
-	if (!dm_table_supports_zoned_model(table, zoned_model)) {
-		DMERR("%s: zoned model is inconsistent across all devices"
-		      dm_device_name(table->md));
+	if (limits->chunk_sectors != zone_sectors)
+		zone_sectors = limits->chunk_sectors;
+	if (validate_hardware_zoned_model(table, zoned_model, zone_sectors))
 		return -EINVAL;
-	}
 
 	return validate_hardware_logical_block_alignment(table, limits);
 }

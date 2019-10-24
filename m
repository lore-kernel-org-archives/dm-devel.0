From: Damien Le Moal <damien.lemoal@wdc.com>
Subject: [PATCH 3/4] block: Introduce report zones queue limits
Date: Thu, 24 Oct 2019 15:50:05 +0900
Message-ID: <20191024065006.8684-4-damien.lemoal@wdc.com>
References: <20191024065006.8684-1-damien.lemoal@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20191024065006.8684-1-damien.lemoal@wdc.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: linux-block@vger.kernel.org, Jens Axboe <axboe@kernel.dk>, linux-scsi@vger.kernel.org, "Martin K . Petersen" <martin.petersen@oracle.com>, dm-devel@redhat.com, Mike Snitzer <snitzer@redhat.com>
List-Id: dm-devel.ids

In preparation for a generic report zones command buffer allocation to
the block layer, introduce three new request queue limits describing the
device zone descriptor size (zone_descriptor_size limit), the needed
granularity of the report zones command buffer size
(zones_report_granularity limit) and the maximum size of a report zone
command (max_zones_report_size limit).

For scsi, set these values respectively to 64 bytes, SECTOR_SIZE and
the maximum transfer size used for regular read/write commands limited
by the maximum number of pages (segments) that the hardware can map.
This removes the need for the "magic" limit implemented with the macro
SD_ZBC_REPORT_MAX_ZONES.

For the null_blk driver and dm targets, the default value of 0 is used
for these limits, indicating that these zoned devices do not need a
buffer for the execution of report zones.

Signed-off-by: Damien Le Moal <damien.lemoal@wdc.com>
---
 block/blk-settings.c   |  3 +++
 drivers/scsi/sd_zbc.c  | 48 +++++++++++++++++++++---------------------
 include/linux/blkdev.h |  4 ++++
 3 files changed, 31 insertions(+), 24 deletions(-)

diff --git a/block/blk-settings.c b/block/blk-settings.c
index 5f6dcc7a47bd..674cfc428334 100644
--- a/block/blk-settings.c
+++ b/block/blk-settings.c
@@ -53,6 +53,9 @@ void blk_set_default_limits(struct queue_limits *lim)
 	lim->discard_granularity = 0;
 	lim->discard_alignment = 0;
 	lim->discard_misaligned = 0;
+	lim->zone_descriptor_size = 0;
+	lim->zones_report_granularity = 0;
+	lim->max_zones_report_size = 0;
 	lim->logical_block_size = lim->physical_block_size = lim->io_min = 512;
 	lim->bounce_pfn = (unsigned long)(BLK_BOUNCE_ANY >> PAGE_SHIFT);
 	lim->alignment_offset = 0;
diff --git a/drivers/scsi/sd_zbc.c b/drivers/scsi/sd_zbc.c
index fbec99db6124..8dc96f4ea920 100644
--- a/drivers/scsi/sd_zbc.c
+++ b/drivers/scsi/sd_zbc.c
@@ -104,11 +104,6 @@ static int sd_zbc_do_report_zones(struct scsi_disk *sdkp, unsigned char *buf,
 	return 0;
 }
 
-/*
- * Maximum number of zones to get with one report zones command.
- */
-#define SD_ZBC_REPORT_MAX_ZONES		8192U
-
 /**
  * Allocate a buffer for report zones reply.
  * @sdkp: The target disk
@@ -129,21 +124,8 @@ static void *sd_zbc_alloc_report_buffer(struct scsi_disk *sdkp,
 	size_t bufsize;
 	void *buf;
 
-	/*
-	 * Report zone buffer size should be at most 64B times the number of
-	 * zones requested plus the 64B reply header, but should be at least
-	 * SECTOR_SIZE for ATA devices.
-	 * Make sure that this size does not exceed the hardware capabilities.
-	 * Furthermore, since the report zone command cannot be split, make
-	 * sure that the allocated buffer can always be mapped by limiting the
-	 * number of pages allocated to the HBA max segments limit.
-	 */
-	nr_zones = min(nr_zones, SD_ZBC_REPORT_MAX_ZONES);
-	bufsize = roundup((nr_zones + 1) * 64, 512);
-	bufsize = min_t(size_t, bufsize,
-			queue_max_hw_sectors(q) << SECTOR_SHIFT);
-	bufsize = min_t(size_t, bufsize, queue_max_segments(q) << PAGE_SHIFT);
-
+	bufsize = min_t(size_t, roundup(nr_zones * 64, SECTOR_SIZE),
+			q->limits.max_zones_report_size);
 	buf = vzalloc(bufsize);
 	if (buf)
 		*buflen = bufsize;
@@ -398,6 +380,8 @@ static int sd_zbc_check_zones(struct scsi_disk *sdkp, unsigned char *buf,
 int sd_zbc_read_zones(struct scsi_disk *sdkp, unsigned char *buf)
 {
 	struct gendisk *disk = sdkp->disk;
+	struct request_queue *q = disk->queue;
+	unsigned int max_zones_report_size;
 	unsigned int nr_zones;
 	u32 zone_blocks = 0;
 	int ret;
@@ -423,13 +407,29 @@ int sd_zbc_read_zones(struct scsi_disk *sdkp, unsigned char *buf)
 		goto err;
 
 	/* The drive satisfies the kernel restrictions: set it up */
-	blk_queue_chunk_sectors(sdkp->disk->queue,
+	blk_queue_chunk_sectors(q,
 			logical_to_sectors(sdkp->device, zone_blocks));
-	blk_queue_flag_set(QUEUE_FLAG_ZONE_RESETALL, sdkp->disk->queue);
-	blk_queue_required_elevator_features(sdkp->disk->queue,
-					     ELEVATOR_F_ZBD_SEQ_WRITE);
+	blk_queue_flag_set(QUEUE_FLAG_ZONE_RESETALL, q);
+	blk_queue_required_elevator_features(q, ELEVATOR_F_ZBD_SEQ_WRITE);
 	nr_zones = round_up(sdkp->capacity, zone_blocks) >> ilog2(zone_blocks);
 
+	/*
+	 * Zone descriptors are 64 bytes. A report zone buffer size should be
+	 * at most 64B times the number of zones of the device plus a 64B reply
+	 * header and should be at least be SECTOR_SIZE bytes for ATA devices.
+	 * Make sure that this maximum buffer size does not exceed the hardware
+	 * capabilities in terms of maximum data transfer size. Furthermore,
+	 * make sure that the allocated buffer can always be mapped by limiting
+	 * the number of pages of the buffer to the device max segments limit.
+	 */
+	q->limits.zone_descriptor_size = 64;
+	q->limits.zones_report_granularity = SECTOR_SIZE;
+	max_zones_report_size = min(roundup((nr_zones + 1) * 64, SECTOR_SIZE),
+				    queue_max_hw_sectors(q) << SECTOR_SHIFT);
+	q->limits.max_zones_report_size =
+		min(max_zones_report_size,
+		    (unsigned int)queue_max_segments(q) << PAGE_SHIFT);
+
 	/* READ16/WRITE16 is mandatory for ZBC disks */
 	sdkp->device->use_16_for_rw = 1;
 	sdkp->device->use_10_for_rw = 0;
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index f3ea78b0c91c..1c76d71fc232 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -338,6 +338,10 @@ struct queue_limits {
 	unsigned int		discard_granularity;
 	unsigned int		discard_alignment;
 
+	unsigned int		zone_descriptor_size;
+	unsigned int		zones_report_granularity;
+	unsigned int		max_zones_report_size;
+
 	unsigned short		logical_block_size;
 	unsigned short		max_segments;
 	unsigned short		max_integrity_segments;
-- 
2.21.0

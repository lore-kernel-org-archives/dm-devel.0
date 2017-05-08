From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: [PATCH v3 08/10] dm-linear: Add support for zoned block
	devices
Date: Mon, 8 May 2017 16:40:50 -0700
Message-ID: <20170508234052.32375-9-bart.vanassche@sandisk.com>
References: <20170508234052.32375-1-bart.vanassche@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20170508234052.32375-1-bart.vanassche@sandisk.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com, Mike Snitzer <snitzer@redhat.com>, Alasdair Kergon <agk@redhat.com>
Cc: Bart Van Assche <bart.vanassche@sandisk.com>, Damien Le Moal <damien.lemoal@wdc.com>, Christoph Hellwig <hch@lst.de>
List-Id: dm-devel.ids

From: Damien Le Moal <damien.lemoal@wdc.com>

Add support for zoned block devices by allowing host-managed zoned block
device mapped targets, the remapping of REQ_OP_ZONE_RESET and the post
processing (reply remapping) of REQ_OP_ZONE_REPORT.

Signed-off-by: Damien Le Moal <damien.lemoal@wdc.com>
Reviewed-by: Hannes Reinecke <hare@suse.com>
Reviewed-by: Bart Van Assche <bart.vanassche@sandisk.com>
---
 drivers/md/dm-linear.c | 15 +++++++++++++--
 1 file changed, 13 insertions(+), 2 deletions(-)

diff --git a/drivers/md/dm-linear.c b/drivers/md/dm-linear.c
index 7d42a9d..794519b 100644
--- a/drivers/md/dm-linear.c
+++ b/drivers/md/dm-linear.c
@@ -89,7 +89,7 @@ static void linear_map_bio(struct dm_target *ti, struct bio *bio)
 	struct linear_c *lc = ti->private;
 
 	bio->bi_bdev = lc->dev->bdev;
-	if (bio_sectors(bio))
+	if (bio_sectors(bio) || bio_op(bio) == REQ_OP_ZONE_RESET)
 		bio->bi_iter.bi_sector =
 			linear_map_sector(ti, bio->bi_iter.bi_sector);
 }
@@ -101,6 +101,16 @@ static int linear_map(struct dm_target *ti, struct bio *bio)
 	return DM_MAPIO_REMAPPED;
 }
 
+static int linear_end_io(struct dm_target *ti, struct bio *bio, int error)
+{
+	struct linear_c *lc = ti->private;
+
+	if (!error && bio_op(bio) == REQ_OP_ZONE_REPORT)
+		dm_remap_zone_report(ti, bio, lc->start);
+
+	return error;
+}
+
 static void linear_status(struct dm_target *ti, status_type_t type,
 			  unsigned status_flags, char *result, unsigned maxlen)
 {
@@ -162,11 +172,12 @@ static long linear_dax_direct_access(struct dm_target *ti, pgoff_t pgoff,
 static struct target_type linear_target = {
 	.name   = "linear",
 	.version = {1, 3, 0},
-	.features = DM_TARGET_PASSES_INTEGRITY,
+	.features = DM_TARGET_PASSES_INTEGRITY | DM_TARGET_ZONED_HM,
 	.module = THIS_MODULE,
 	.ctr    = linear_ctr,
 	.dtr    = linear_dtr,
 	.map    = linear_map,
+	.end_io = linear_end_io,
 	.status = linear_status,
 	.prepare_ioctl = linear_prepare_ioctl,
 	.iterate_devices = linear_iterate_devices,
-- 
2.9.3

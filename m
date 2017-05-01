From: damien.lemoal@wdc.com
Subject: [PATCH v2 08/10] dm-linear: Add support for zoned block devices
Date: Tue,  2 May 2017 02:53:12 +0900
Message-ID: <20170501175314.10922-9-damien.lemoal@wdc.com>
References: <20170501175314.10922-1-damien.lemoal@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20170501175314.10922-1-damien.lemoal@wdc.com>
Sender: linux-block-owner@vger.kernel.org
To: dm-devel@redhat.com, Mike Snitzer <snitzer@redhat.com>, Alasdair Kergon <agk@redhat.com>
Cc: Hannes Reinecke <hare@suse.de>, Christoph Hellwig <hch@lst.de>, Bart Van Assche <Bart.VanAssche@sandisk.com>, linux-block@vger.kernel.org, Damien Le Moal <damien.lemoal@wdc.com>
List-Id: dm-devel.ids

From: Damien Le Moal <damien.lemoal@wdc.com>

Add support for zoned block devices by allowing host-managed zoned block
device mapped targets, the remapping of REQ_OP_ZONE_RESET and the post
processing (reply remapping) of REQ_OP_ZONE_REPORT.

Signed-off-by: Damien Le Moal <damien.lemoal@wdc.com>
Reviewed-by: Hannes Reinecke <hare@suse.com>
---
 drivers/md/dm-linear.c | 14 +++++++++++++-
 1 file changed, 13 insertions(+), 1 deletion(-)

diff --git a/drivers/md/dm-linear.c b/drivers/md/dm-linear.c
index 4788b0b..9c4debd 100644
--- a/drivers/md/dm-linear.c
+++ b/drivers/md/dm-linear.c
@@ -87,7 +87,7 @@ static void linear_map_bio(struct dm_target *ti, struct bio *bio)
 	struct linear_c *lc = ti->private;
 
 	bio->bi_bdev = lc->dev->bdev;
-	if (bio_sectors(bio))
+	if (bio_sectors(bio) || bio_op(bio) == REQ_OP_ZONE_RESET)
 		bio->bi_iter.bi_sector =
 			linear_map_sector(ti, bio->bi_iter.bi_sector);
 }
@@ -99,6 +99,16 @@ static int linear_map(struct dm_target *ti, struct bio *bio)
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
@@ -162,10 +172,12 @@ static long linear_direct_access(struct dm_target *ti, sector_t sector,
 static struct target_type linear_target = {
 	.name   = "linear",
 	.version = {1, 3, 0},
+	.features = DM_TARGET_ZONED_HM,
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

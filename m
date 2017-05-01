From: damien.lemoal@wdc.com
Subject: [PATCH v2 07/10] dm-flakey: Add support for zoned block devices
Date: Tue,  2 May 2017 02:53:11 +0900
Message-ID: <20170501175314.10922-8-damien.lemoal@wdc.com>
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

With the development of file system support for zoned block devices
(e.g. f2fs), having dm-flakey support for these devices is interesting
to improve testing.

This patch adds support for zoned block devices in dm-flakey, both
host-aware and host-managed. The target type feature is set to
DM_TARGET_ZONED_HM indicate support for host-managed models. The
remaining of the support adds hooks for remapping of REQ_OP_ZONE_RESET
and REQ_OP_ZONE_REPORT bios. Additionally, in the bio completion path,
(backward) remapping of a zone report reply is also added.

Signed-off-by: Damien Le Moal <damien.lemoal@wdc.com>
Reviewed-by: Hannes Reinecke <hare@suse.com>
---
 drivers/md/dm-flakey.c | 21 ++++++++++++++++++++-
 1 file changed, 20 insertions(+), 1 deletion(-)

diff --git a/drivers/md/dm-flakey.c b/drivers/md/dm-flakey.c
index 13305a1..b419c85 100644
--- a/drivers/md/dm-flakey.c
+++ b/drivers/md/dm-flakey.c
@@ -251,6 +251,8 @@ static int flakey_ctr(struct dm_target *ti, unsigned int argc, char **argv)
 	return 0;
 
 bad:
+	if (fc->dev)
+		dm_put_device(ti, fc->dev);
 	kfree(fc);
 	return r;
 }
@@ -275,7 +277,7 @@ static void flakey_map_bio(struct dm_target *ti, struct bio *bio)
 	struct flakey_c *fc = ti->private;
 
 	bio->bi_bdev = fc->dev->bdev;
-	if (bio_sectors(bio))
+	if (bio_sectors(bio) || bio_op(bio) == REQ_OP_ZONE_RESET)
 		bio->bi_iter.bi_sector =
 			flakey_map_sector(ti, bio->bi_iter.bi_sector);
 }
@@ -306,6 +308,14 @@ static int flakey_map(struct dm_target *ti, struct bio *bio)
 	struct per_bio_data *pb = dm_per_bio_data(bio, sizeof(struct per_bio_data));
 	pb->bio_submitted = false;
 
+	/* Do not fail reset zone */
+	if (bio_op(bio) == REQ_OP_ZONE_RESET)
+		goto map_bio;
+
+	/* We need to remap reported zones, so remember the BIO iter */
+	if (bio_op(bio) == REQ_OP_ZONE_REPORT)
+		goto map_bio;
+
 	/* Are we alive ? */
 	elapsed = (jiffies - fc->start_time) / HZ;
 	if (elapsed % (fc->up_interval + fc->down_interval) >= fc->up_interval) {
@@ -363,6 +373,14 @@ static int flakey_end_io(struct dm_target *ti, struct bio *bio, int error)
 	struct flakey_c *fc = ti->private;
 	struct per_bio_data *pb = dm_per_bio_data(bio, sizeof(struct per_bio_data));
 
+	if (bio_op(bio) == REQ_OP_ZONE_RESET)
+		return error;
+
+	if (bio_op(bio) == REQ_OP_ZONE_REPORT) {
+		dm_remap_zone_report(ti, bio, fc->start);
+		return error;
+	}
+
 	if (!error && pb->bio_submitted && (bio_data_dir(bio) == READ)) {
 		if (fc->corrupt_bio_byte && (fc->corrupt_bio_rw == READ) &&
 		    all_corrupt_bio_flags_match(bio, fc)) {
@@ -446,6 +464,7 @@ static int flakey_iterate_devices(struct dm_target *ti, iterate_devices_callout_
 static struct target_type flakey_target = {
 	.name   = "flakey",
 	.version = {1, 4, 0},
+	.features = DM_TARGET_ZONED_HM,
 	.module = THIS_MODULE,
 	.ctr    = flakey_ctr,
 	.dtr    = flakey_dtr,
-- 
2.9.3

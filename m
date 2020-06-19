From: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Subject: [PATCH 1/2] dm: update original bio sector on Zone Append
Date: Fri, 19 Jun 2020 15:59:04 +0900
Message-ID: <20200619065905.22228-2-johannes.thumshirn@wdc.com>
References: <20200619065905.22228-1-johannes.thumshirn@wdc.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20200619065905.22228-1-johannes.thumshirn@wdc.com>
Sender: linux-block-owner@vger.kernel.org
To: Mike Snitzer <snitzer@redhat.com>
Cc: dm-devel@redhat.com, linux-block@vger.kernel.org, Damien Le Moal <Damien.LeMoal@wdc.com>, Naohiro Aota <Naohiro.Aota@wdc.com>, Johannes Thumshirn <johannes.thumshirn@wdc.com>
List-Id: dm-devel.ids

Naohiro reported that issuing zone-append bios to a zoned block device
underneath a dm-linear device does not work as expected.

This because we forgot to reverse-map the sector the device wrote to the
original bio.

For zone-append bios, get the offset in the zone of the written sector
from the clone bio and add that to the original bio's sector position.

Reported-by: Naohiro Aota <Naohiro.Aota@wdc.com>
Fixes: 0512a75b98f8 ("block: Introduce REQ_OP_ZONE_APPEND")
Signed-off-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
---
 drivers/md/dm.c | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index 109e81f33edb..058c34abe9d1 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -1009,6 +1009,7 @@ static void clone_endio(struct bio *bio)
 	struct dm_io *io = tio->io;
 	struct mapped_device *md = tio->io->md;
 	dm_endio_fn endio = tio->ti->type->end_io;
+	struct bio *orig_bio = io->orig_bio;
 
 	if (unlikely(error == BLK_STS_TARGET) && md->type != DM_TYPE_NVME_BIO_BASED) {
 		if (bio_op(bio) == REQ_OP_DISCARD &&
@@ -1022,6 +1023,18 @@ static void clone_endio(struct bio *bio)
 			disable_write_zeroes(md);
 	}
 
+	/*
+	 * for zone-append bios get offset in zone of the written sector and add
+	 * that to the original bio sector pos.
+	 */
+	if (bio_op(orig_bio) == REQ_OP_ZONE_APPEND) {
+		sector_t written_sector = bio->bi_iter.bi_sector;
+		struct request_queue *q = orig_bio->bi_disk->queue;
+		u64 mask = (u64)blk_queue_zone_sectors(q) - 1;
+
+		orig_bio->bi_iter.bi_sector += written_sector & mask;
+	}
+
 	if (endio) {
 		int r = endio(tio->ti, bio, &error);
 		switch (r) {
-- 
2.26.2

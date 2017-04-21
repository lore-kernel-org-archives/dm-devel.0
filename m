From: damien.lemoal@wdc.com
Subject: [PATCH 05/10] dm: Fix REQ_OP_ZONE_REPORT bio handling
Date: Fri, 21 Apr 2017 12:55:53 +0900
Message-ID: <20170421035558.2657-6-damien.lemoal@wdc.com>
References: <20170421035558.2657-1-damien.lemoal@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20170421035558.2657-1-damien.lemoal@wdc.com>
Sender: linux-block-owner@vger.kernel.org
To: dm-devel@redhat.com, Mike Snitzer <snitzer@redhat.com>, Alasdair Kergon <agk@redhat.com>
Cc: Hannes Reinecke <hare@suse.de>, Christoph Hellwig <hch@lst.de>, Bart Van Assche <Bart.VanAssche@sandisk.com>, linux-block@vger.kernel.org, Damien Le Moal <damien.lemoal@wdc.com>
List-Id: dm-devel.ids

From: Damien Le Moal <damien.lemoal@wdc.com>

A REQ_OP_ZONE_REPORT bio is not a medium access command. Its number of
sectors indicates the maximum size allowed for the report reply size
and not an amount of sectors accessed from the device.
REQ_OP_ZONE_REPORT bios should thus not be split depending on the
target device maximum I/O length but passed as is. Note that it is the
responsability of the target to remap and format the report reply.

Signed-off-by: Damien Le Moal <damien.lemoal@wdc.com>
---
 drivers/md/dm.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index 1d98035..cd44928 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -1098,7 +1098,8 @@ static int clone_bio(struct dm_target_io *tio, struct bio *bio,
 			return r;
 	}
 
-	bio_advance(clone, to_bytes(sector - clone->bi_iter.bi_sector));
+	if (bio_op(bio) != REQ_OP_ZONE_REPORT)
+		bio_advance(clone, to_bytes(sector - clone->bi_iter.bi_sector));
 	clone->bi_iter.bi_size = to_bytes(len);
 
 	if (bio_integrity(bio))
@@ -1275,7 +1276,11 @@ static int __split_and_process_non_flush(struct clone_info *ci)
 	if (!dm_target_is_valid(ti))
 		return -EIO;
 
-	len = min_t(sector_t, max_io_len(ci->sector, ti), ci->sector_count);
+	if (bio_op(bio) == REQ_OP_ZONE_REPORT)
+		len = ci->sector_count;
+	else
+		len = min_t(sector_t, max_io_len(ci->sector, ti),
+			    ci->sector_count);
 
 	r = __clone_and_map_data_bio(ci, ti, ci->sector, &len);
 	if (r < 0)
-- 
2.9.3

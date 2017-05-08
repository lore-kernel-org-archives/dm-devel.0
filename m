From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: [PATCH v3 05/10] dm: Fix REQ_OP_ZONE_REPORT bio handling
Date: Mon, 8 May 2017 16:40:47 -0700
Message-ID: <20170508234052.32375-6-bart.vanassche@sandisk.com>
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

A REQ_OP_ZONE_REPORT bio is not a medium access command. Its number of
sectors indicates the maximum size allowed for the report reply size
and not an amount of sectors accessed from the device.
REQ_OP_ZONE_REPORT bios should thus not be split depending on the
target device maximum I/O length but passed as is. Note that it is the
responsability of the target to remap and format the report reply.

Signed-off-by: Damien Le Moal <damien.lemoal@wdc.com>
Reviewed-by: Hannes Reinecke <hare@suse.com>
Reviewed-by: Bart Van Assche <bart.vanassche@sandisk.com>
---
 drivers/md/dm.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index 51425c7..023bbc0 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -1142,7 +1142,8 @@ static int clone_bio(struct dm_target_io *tio, struct bio *bio,
 			return r;
 	}
 
-	bio_advance(clone, to_bytes(sector - clone->bi_iter.bi_sector));
+	if (bio_op(bio) != REQ_OP_ZONE_REPORT)
+		bio_advance(clone, to_bytes(sector - clone->bi_iter.bi_sector));
 	clone->bi_iter.bi_size = to_bytes(len);
 
 	if (unlikely(bio_integrity(bio) != NULL))
@@ -1331,7 +1332,11 @@ static int __split_and_process_non_flush(struct clone_info *ci)
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

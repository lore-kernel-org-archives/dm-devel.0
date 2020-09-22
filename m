From: Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH v3 6/6] dm: change max_io_len() to use blk_max_size_offset()
Date: Mon, 21 Sep 2020 22:32:51 -0400
Message-ID: <20200922023251.47712-7-snitzer@redhat.com>
References: <20200922023251.47712-1-snitzer@redhat.com>
Return-path: <linux-block-owner@vger.kernel.org>
Sender: Mike Snitzer <snitzer@gmail.com>
In-Reply-To: <20200922023251.47712-1-snitzer@redhat.com>
To: Jens Axboe <axboe@kernel.dk>
Cc: Ming Lei <ming.lei@redhat.com>, Vijayendra Suman <vijayendra.suman@oracle.com>, dm-devel@redhat.com, linux-block@vger.kernel.org
List-Id: dm-devel.ids

Using blk_max_size_offset() enables DM core's splitting to impose
ti->max_io_len (via q->limits.chunk_sectors) and also fallback to
respecting q->limits.max_sectors if chunk_sectors isn't set.

Signed-off-by: Mike Snitzer <snitzer@redhat.com>
---
 drivers/md/dm.c | 20 ++++++++------------
 1 file changed, 8 insertions(+), 12 deletions(-)

diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index 6ed05ca65a0f..3982012b1309 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -1051,22 +1051,18 @@ static sector_t max_io_len_target_boundary(sector_t sector, struct dm_target *ti
 static sector_t max_io_len(sector_t sector, struct dm_target *ti)
 {
 	sector_t len = max_io_len_target_boundary(sector, ti);
-	sector_t offset, max_len;
+	sector_t max_len;
 
 	/*
 	 * Does the target need to split even further?
+	 * - q->limits.chunk_sectors reflects ti->max_io_len so
+	 *   blk_max_size_offset() provides required splitting.
+	 * - blk_max_size_offset() also respects q->limits.max_sectors
 	 */
-	if (ti->max_io_len) {
-		offset = dm_target_offset(ti, sector);
-		if (unlikely(ti->max_io_len & (ti->max_io_len - 1)))
-			max_len = sector_div(offset, ti->max_io_len);
-		else
-			max_len = offset & (ti->max_io_len - 1);
-		max_len = ti->max_io_len - max_len;
-
-		if (len > max_len)
-			len = max_len;
-	}
+	max_len = blk_max_size_offset(dm_table_get_md(ti->table)->queue,
+				      dm_target_offset(ti, sector));
+	if (len > max_len)
+		len = max_len;
 
 	return len;
 }
-- 
2.15.0

From: Jaegeuk Kim <jaegeuk@kernel.org>
Subject: [PATCH] dm: give req_size precisely given by user
Date: Tue, 18 Dec 2018 09:25:37 -0800
Message-ID: <20181218172537.12300-1-jaegeuk@kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <stable-owner@vger.kernel.org>
Sender: stable-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net
Cc: Jaegeuk Kim <jaegeuk@kernel.org>, stable@vger.kernel.org, Jens Axboe <axboe@kernel.dk>, Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@redhat.com>, dm-devel@redhat.com
List-Id: dm-devel.ids

This patch makes dm be aware of io_pages to assign sane req_size for reads.

Cc: stable@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Alasdair Kergon <agk@redhat.com>
Cc: Mike Snitzer <snitzer@redhat.com>
Cc: dm-devel@redhat.com
Fixes: 9491ae4a ("mm: don't cap request size based on read-ahead setting")
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
---
 drivers/md/dm-table.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/md/dm-table.c b/drivers/md/dm-table.c
index 9038c302d5c2..886790428241 100644
--- a/drivers/md/dm-table.c
+++ b/drivers/md/dm-table.c
@@ -1927,6 +1927,9 @@ void dm_table_set_restrictions(struct dm_table *t, struct request_queue *q,
 	 */
 	if (blk_queue_is_zoned(q))
 		blk_revalidate_disk_zones(t->md->disk);
+
+	/* io_pages is used for readahead */
+	q->backing_dev_info->io_pages = limits->max_sectors >> (PAGE_SHIFT - 9);
 }
 
 unsigned int dm_table_get_num_targets(struct dm_table *t)
-- 
2.19.0.605.g01d371f741-goog

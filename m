From: Zhen Lei <thunder.leizhen@huawei.com>
Subject: [PATCH 4/4] mtd: eliminate SECTOR related magic numbers
Date: Tue, 5 May 2020 19:55:43 +0800
Message-ID: <20200505115543.1660-5-thunder.leizhen@huawei.com>
References: <20200505115543.1660-1-thunder.leizhen@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20200505115543.1660-1-thunder.leizhen@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Minchan Kim <minchan@kernel.org>, Nitin Gupta <ngupta@vflare.org>, Sergey Senozhatsky <sergey.senozhatsky.work@gmail.com>, Jens Axboe <axboe@kernel.dk>, linux-block <linux-block@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>, linux-mm <linux-mm@kvack.org>, Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@redhat.com>, dm-devel <dm-devel@redhat.com>, Song Liu <song@kernel.org>, linux-raid <linux-raid@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>
Cc: Zhen Lei <thunder.leizhen@huawei.com>
List-Id: dm-devel.ids

1. Replace "1 << (PAGE_SHIFT - 9)" or similar with SECTORS_PER_PAGE
2. Replace "PAGE_SHIFT - 9" with SECTORS_PER_PAGE_SHIFT
3. Replace "9" with SECTOR_SHIFT
4. Replace "512" with SECTOR_SIZE

Signed-off-by: Zhen Lei <thunder.leizhen@huawei.com>
---
 drivers/md/dm-table.c    |  2 +-
 drivers/md/raid1.c       |  4 ++--
 drivers/md/raid10.c      | 10 +++++-----
 drivers/md/raid5-cache.c | 10 +++++-----
 4 files changed, 13 insertions(+), 13 deletions(-)

diff --git a/drivers/md/dm-table.c b/drivers/md/dm-table.c
index 0a2cc197f62b..cf9d85ec66fd 100644
--- a/drivers/md/dm-table.c
+++ b/drivers/md/dm-table.c
@@ -1964,7 +1964,7 @@ void dm_table_set_restrictions(struct dm_table *t, struct request_queue *q,
 #endif
 
 	/* Allow reads to exceed readahead limits */
-	q->backing_dev_info->io_pages = limits->max_sectors >> (PAGE_SHIFT - 9);
+	q->backing_dev_info->io_pages = limits->max_sectors >> SECTORS_PER_PAGE_SHIFT;
 }
 
 unsigned int dm_table_get_num_targets(struct dm_table *t)
diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index cd810e195086..35d3fa22dd54 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -2129,7 +2129,7 @@ static void process_checks(struct r1bio *r1_bio)
 	int vcnt;
 
 	/* Fix variable parts of all bios */
-	vcnt = (r1_bio->sectors + PAGE_SIZE / 512 - 1) >> (PAGE_SHIFT - 9);
+	vcnt = (r1_bio->sectors + SECTORS_PER_PAGE - 1) >> SECTORS_PER_PAGE_SHIFT;
 	for (i = 0; i < conf->raid_disks * 2; i++) {
 		blk_status_t status;
 		struct bio *b = r1_bio->bios[i];
@@ -2148,7 +2148,7 @@ static void process_checks(struct r1bio *r1_bio)
 		b->bi_private = rp;
 
 		/* initialize bvec table again */
-		md_bio_reset_resync_pages(b, rp, r1_bio->sectors << 9);
+		md_bio_reset_resync_pages(b, rp, r1_bio->sectors << SECTOR_SHIFT);
 	}
 	for (primary = 0; primary < conf->raid_disks * 2; primary++)
 		if (r1_bio->bios[primary]->bi_end_io == end_sync_read &&
diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index ec136e44aef7..3202953a800d 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -2025,11 +2025,11 @@ static void sync_request_write(struct mddev *mddev, struct r10bio *r10_bio)
 
 	first = i;
 	fbio = r10_bio->devs[i].bio;
-	fbio->bi_iter.bi_size = r10_bio->sectors << 9;
+	fbio->bi_iter.bi_size = r10_bio->sectors << SECTOR_SHIFT;
 	fbio->bi_iter.bi_idx = 0;
 	fpages = get_resync_pages(fbio)->pages;
 
-	vcnt = (r10_bio->sectors + (PAGE_SIZE >> 9) - 1) >> (PAGE_SHIFT - 9);
+	vcnt = (r10_bio->sectors + SECTORS_PER_PAGE - 1) >> SECTORS_PER_PAGE_SHIFT;
 	/* now find blocks with errors */
 	for (i=0 ; i < conf->copies ; i++) {
 		int  j, d;
@@ -2054,13 +2054,13 @@ static void sync_request_write(struct mddev *mddev, struct r10bio *r10_bio)
 			int sectors = r10_bio->sectors;
 			for (j = 0; j < vcnt; j++) {
 				int len = PAGE_SIZE;
-				if (sectors < (len / 512))
-					len = sectors * 512;
+				if (sectors < (len / SECTOR_SIZE))
+					len = sectors * SECTOR_SIZE;
 				if (memcmp(page_address(fpages[j]),
 					   page_address(tpages[j]),
 					   len))
 					break;
-				sectors -= len/512;
+				sectors -= len / SECTOR_SIZE;
 			}
 			if (j == vcnt)
 				continue;
diff --git a/drivers/md/raid5-cache.c b/drivers/md/raid5-cache.c
index 9b6da759dca2..5bd8e2b51341 100644
--- a/drivers/md/raid5-cache.c
+++ b/drivers/md/raid5-cache.c
@@ -833,7 +833,7 @@ static void r5l_append_payload_meta(struct r5l_log *log, u16 type,
 	payload->header.type = cpu_to_le16(type);
 	payload->header.flags = cpu_to_le16(0);
 	payload->size = cpu_to_le32((1 + !!checksum2_valid) <<
-				    (PAGE_SHIFT - 9));
+				    SECTORS_PER_PAGE_SHIFT);
 	payload->location = cpu_to_le64(location);
 	payload->checksum[0] = cpu_to_le32(checksum1);
 	if (checksum2_valid)
@@ -1042,7 +1042,7 @@ int r5l_write_stripe(struct r5l_log *log, struct stripe_head *sh)
 
 	mutex_lock(&log->io_mutex);
 	/* meta + data */
-	reserve = (1 + write_disks) << (PAGE_SHIFT - 9);
+	reserve = (1 + write_disks) << SECTORS_PER_PAGE_SHIFT;
 
 	if (log->r5c_journal_mode == R5C_JOURNAL_MODE_WRITE_THROUGH) {
 		if (!r5l_has_free_space(log, reserve)) {
@@ -2053,7 +2053,7 @@ r5l_recovery_verify_data_checksum_for_mb(struct r5l_log *log,
 						  le32_to_cpu(payload->size));
 			mb_offset += sizeof(struct r5l_payload_data_parity) +
 				sizeof(__le32) *
-				(le32_to_cpu(payload->size) >> (PAGE_SHIFT - 9));
+				(le32_to_cpu(payload->size) >> SECTORS_PER_PAGE_SHIFT);
 		}
 
 	}
@@ -2199,7 +2199,7 @@ r5c_recovery_analyze_meta_block(struct r5l_log *log,
 
 		mb_offset += sizeof(struct r5l_payload_data_parity) +
 			sizeof(__le32) *
-			(le32_to_cpu(payload->size) >> (PAGE_SHIFT - 9));
+			(le32_to_cpu(payload->size) >> SECTORS_PER_PAGE_SHIFT);
 	}
 
 	return 0;
@@ -2916,7 +2916,7 @@ int r5c_cache_data(struct r5l_log *log, struct stripe_head *sh)
 
 	mutex_lock(&log->io_mutex);
 	/* meta + data */
-	reserve = (1 + pages) << (PAGE_SHIFT - 9);
+	reserve = (1 + pages) << SECTORS_PER_PAGE_SHIFT;
 
 	if (test_bit(R5C_LOG_CRITICAL, &conf->cache_state) &&
 	    sh->log_start == MaxSector)
-- 
2.26.0.106.g9fadedd

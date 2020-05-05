From: Zhen Lei <thunder.leizhen@huawei.com>
Subject: [PATCH 3/4] block: use SECTORS_PER_PAGE_SHIFT and SECTORS_PER_PAGE to clean up code
Date: Tue, 5 May 2020 19:55:42 +0800
Message-ID: <20200505115543.1660-4-thunder.leizhen@huawei.com>
References: <20200505115543.1660-1-thunder.leizhen@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20200505115543.1660-1-thunder.leizhen@huawei.com>
Sender: linux-block-owner@vger.kernel.org
To: Minchan Kim <minchan@kernel.org>, Nitin Gupta <ngupta@vflare.org>, Sergey Senozhatsky <sergey.senozhatsky.work@gmail.com>, Jens Axboe <axboe@kernel.dk>, linux-block <linux-block@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>, linux-mm <linux-mm@kvack.org>, Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@redhat.com>, dm-devel <dm-devel@redhat.com>, Song Liu <song@kernel.org>, linux-raid <linux-raid@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>
Cc: Zhen Lei <thunder.leizhen@huawei.com>
List-Id: dm-devel.ids

1. Replace "1 << (PAGE_SHIFT - 9)" with SECTORS_PER_PAGE
2. Replace "PAGE_SHIFT - 9" with SECTORS_PER_PAGE_SHIFT
3. Replace "9" with SECTOR_SHIFT

Signed-off-by: Zhen Lei <thunder.leizhen@huawei.com>
---
 block/blk-settings.c    | 8 ++++----
 block/partitions/core.c | 4 ++--
 2 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/block/blk-settings.c b/block/blk-settings.c
index 14397b4c4b53..a62037a7ff0f 100644
--- a/block/blk-settings.c
+++ b/block/blk-settings.c
@@ -149,8 +149,8 @@ void blk_queue_max_hw_sectors(struct request_queue *q, unsigned int max_hw_secto
 	struct queue_limits *limits = &q->limits;
 	unsigned int max_sectors;
 
-	if ((max_hw_sectors << 9) < PAGE_SIZE) {
-		max_hw_sectors = 1 << (PAGE_SHIFT - 9);
+	if ((max_hw_sectors << SECTOR_SHIFT) < PAGE_SIZE) {
+		max_hw_sectors = SECTORS_PER_PAGE;
 		printk(KERN_INFO "%s: set to minimum %d\n",
 		       __func__, max_hw_sectors);
 	}
@@ -159,7 +159,7 @@ void blk_queue_max_hw_sectors(struct request_queue *q, unsigned int max_hw_secto
 	max_sectors = min_not_zero(max_hw_sectors, limits->max_dev_sectors);
 	max_sectors = min_t(unsigned int, max_sectors, BLK_DEF_MAX_SECTORS);
 	limits->max_sectors = max_sectors;
-	q->backing_dev_info->io_pages = max_sectors >> (PAGE_SHIFT - 9);
+	q->backing_dev_info->io_pages = max_sectors >> SECTORS_PER_PAGE_SHIFT;
 }
 EXPORT_SYMBOL(blk_queue_max_hw_sectors);
 
@@ -630,7 +630,7 @@ void disk_stack_limits(struct gendisk *disk, struct block_device *bdev,
 	}
 
 	t->backing_dev_info->io_pages =
-		t->limits.max_sectors >> (PAGE_SHIFT - 9);
+		t->limits.max_sectors >> SECTORS_PER_PAGE_SHIFT;
 }
 EXPORT_SYMBOL(disk_stack_limits);
 
diff --git a/block/partitions/core.c b/block/partitions/core.c
index 9ef48a8cff86..6e44ac840ca0 100644
--- a/block/partitions/core.c
+++ b/block/partitions/core.c
@@ -641,7 +641,7 @@ void *read_part_sector(struct parsed_partitions *state, sector_t n, Sector *p)
 	}
 
 	page = read_mapping_page(mapping,
-			(pgoff_t)(n >> (PAGE_SHIFT - 9)), NULL);
+			(pgoff_t)(n >> SECTORS_PER_PAGE_SHIFT), NULL);
 	if (IS_ERR(page))
 		goto out;
 	if (PageError(page))
@@ -649,7 +649,7 @@ void *read_part_sector(struct parsed_partitions *state, sector_t n, Sector *p)
 
 	p->v = page;
 	return (unsigned char *)page_address(page) +
-			((n & ((1 << (PAGE_SHIFT - 9)) - 1)) << SECTOR_SHIFT);
+			((n & (SECTORS_PER_PAGE - 1)) << SECTOR_SHIFT);
 out_put_page:
 	put_page(page);
 out:
-- 
2.26.0.106.g9fadedd

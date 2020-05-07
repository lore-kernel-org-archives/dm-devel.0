From: Zhen Lei <thunder.leizhen@huawei.com>
Subject: [PATCH v2 02/10] zram: abolish macro SECTORS_PER_PAGE
Date: Thu, 7 May 2020 15:50:52 +0800
Message-ID: <20200507075100.1779-3-thunder.leizhen@huawei.com>
References: <20200507075100.1779-1-thunder.leizhen@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20200507075100.1779-1-thunder.leizhen@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Minchan Kim <minchan@kernel.org>, Nitin Gupta <ngupta@vflare.org>, Sergey Senozhatsky <sergey.senozhatsky.work@gmail.com>, Matthew Wilcox <willy@infradead.org>, Jens Axboe <axboe@kernel.dk>, Coly Li <colyli@suse.de>, Kent Overstreet <kent.overstreet@gmail.com>, Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@redhat.com>, linux-block <linux-block@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>, linux-mm <linux-mm@kvack.org>, dm-devel <dm-devel@redhat.com>, Song Liu <song@kernel.org>, linux-raid <linux-raid@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>
Cc: Zhen Lei <thunder.leizhen@huawei.com>
List-Id: dm-devel.ids

SECTORS_PER_PAGE is equivalent to PAGE_SECTORS.

Although I prefer SECTORS_PER_PAGE better than PAGE_SECTORS, the former
is more clearer, I think. But the latter was defined in
<linux/device-mapper.h> before, rename it may impact users.

Signed-off-by: Zhen Lei <thunder.leizhen@huawei.com>
---
 drivers/block/zram/zram_drv.c | 4 ++--
 drivers/block/zram/zram_drv.h | 1 -
 2 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/block/zram/zram_drv.c b/drivers/block/zram/zram_drv.c
index ebb234f36909..e2fbf7a847e7 100644
--- a/drivers/block/zram/zram_drv.c
+++ b/drivers/block/zram/zram_drv.c
@@ -1551,7 +1551,7 @@ static void __zram_make_request(struct zram *zram, struct bio *bio)
 
 	index = bio->bi_iter.bi_sector >> SECTORS_PER_PAGE_SHIFT;
 	offset = (bio->bi_iter.bi_sector &
-		  (SECTORS_PER_PAGE - 1)) << SECTOR_SHIFT;
+		  (PAGE_SECTORS - 1)) << SECTOR_SHIFT;
 
 	switch (bio_op(bio)) {
 	case REQ_OP_DISCARD:
@@ -1645,7 +1645,7 @@ static int zram_rw_page(struct block_device *bdev, sector_t sector,
 	}
 
 	index = sector >> SECTORS_PER_PAGE_SHIFT;
-	offset = (sector & (SECTORS_PER_PAGE - 1)) << SECTOR_SHIFT;
+	offset = (sector & (PAGE_SECTORS - 1)) << SECTOR_SHIFT;
 
 	bv.bv_page = page;
 	bv.bv_len = PAGE_SIZE;
diff --git a/drivers/block/zram/zram_drv.h b/drivers/block/zram/zram_drv.h
index f2fd46daa760..10fdf413dd6e 100644
--- a/drivers/block/zram/zram_drv.h
+++ b/drivers/block/zram/zram_drv.h
@@ -22,7 +22,6 @@
 #include "zcomp.h"
 
 #define SECTORS_PER_PAGE_SHIFT	(PAGE_SHIFT - SECTOR_SHIFT)
-#define SECTORS_PER_PAGE	(1 << SECTORS_PER_PAGE_SHIFT)
 #define ZRAM_LOGICAL_BLOCK_SHIFT 12
 #define ZRAM_LOGICAL_BLOCK_SIZE	(1 << ZRAM_LOGICAL_BLOCK_SHIFT)
 #define ZRAM_SECTOR_PER_LOGICAL_BLOCK	\
-- 
2.26.0.106.g9fadedd

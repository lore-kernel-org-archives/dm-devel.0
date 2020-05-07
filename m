From: Zhen Lei <thunder.leizhen@huawei.com>
Subject: [PATCH v2 01/10] block: move PAGE_SECTORS definition into <linux/blkdev.h>
Date: Thu, 7 May 2020 15:50:51 +0800
Message-ID: <20200507075100.1779-2-thunder.leizhen@huawei.com>
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

Too many duplicated PAGE_SECTORS definitions, eliminate it.

Signed-off-by: Zhen Lei <thunder.leizhen@huawei.com>
---
 drivers/block/brd.c           | 1 -
 drivers/block/null_blk_main.c | 1 -
 drivers/md/bcache/util.h      | 2 --
 include/linux/blkdev.h        | 5 +++--
 include/linux/device-mapper.h | 1 -
 5 files changed, 3 insertions(+), 7 deletions(-)

diff --git a/drivers/block/brd.c b/drivers/block/brd.c
index 2fb25c348d53..30df6daa9dbc 100644
--- a/drivers/block/brd.c
+++ b/drivers/block/brd.c
@@ -26,7 +26,6 @@
 #include <linux/uaccess.h>
 
 #define PAGE_SECTORS_SHIFT	(PAGE_SHIFT - SECTOR_SHIFT)
-#define PAGE_SECTORS		(1 << PAGE_SECTORS_SHIFT)
 
 /*
  * Each block ramdisk device has a radix_tree brd_pages of pages that stores
diff --git a/drivers/block/null_blk_main.c b/drivers/block/null_blk_main.c
index 8efd8778e209..25048ff15858 100644
--- a/drivers/block/null_blk_main.c
+++ b/drivers/block/null_blk_main.c
@@ -12,7 +12,6 @@
 #include "null_blk.h"
 
 #define PAGE_SECTORS_SHIFT	(PAGE_SHIFT - SECTOR_SHIFT)
-#define PAGE_SECTORS		(1 << PAGE_SECTORS_SHIFT)
 #define SECTOR_MASK		(PAGE_SECTORS - 1)
 
 #define FREE_BATCH		16
diff --git a/drivers/md/bcache/util.h b/drivers/md/bcache/util.h
index c029f7443190..55196e0f37c3 100644
--- a/drivers/md/bcache/util.h
+++ b/drivers/md/bcache/util.h
@@ -15,8 +15,6 @@
 
 #include "closure.h"
 
-#define PAGE_SECTORS		(PAGE_SIZE / 512)
-
 struct closure;
 
 #ifdef CONFIG_BCACHE_DEBUG
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 32868fbedc9e..934f31fc15cd 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -904,11 +904,12 @@ static inline struct request_queue *bdev_get_queue(struct block_device *bdev)
  * multiple of 512 bytes. Hence these two constants.
  */
 #ifndef SECTOR_SHIFT
-#define SECTOR_SHIFT 9
+#define SECTOR_SHIFT		9
 #endif
 #ifndef SECTOR_SIZE
-#define SECTOR_SIZE (1 << SECTOR_SHIFT)
+#define SECTOR_SIZE		(1 << SECTOR_SHIFT)
 #endif
+#define PAGE_SECTORS		(PAGE_SIZE / SECTOR_SIZE)
 
 /*
  * blk_rq_pos()			: the current sector
diff --git a/include/linux/device-mapper.h b/include/linux/device-mapper.h
index af48d9da3916..83e018ed8c21 100644
--- a/include/linux/device-mapper.h
+++ b/include/linux/device-mapper.h
@@ -143,7 +143,6 @@ typedef size_t (*dm_dax_copy_iter_fn)(struct dm_target *ti, pgoff_t pgoff,
 		void *addr, size_t bytes, struct iov_iter *i);
 typedef int (*dm_dax_zero_page_range_fn)(struct dm_target *ti, pgoff_t pgoff,
 		size_t nr_pages);
-#define PAGE_SECTORS (PAGE_SIZE / 512)
 
 void dm_error(const char *message);
 
-- 
2.26.0.106.g9fadedd

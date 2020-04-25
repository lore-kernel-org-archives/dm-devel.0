From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 1/3] bcache: remove a duplicate ->make_request_fn assignment
Date: Sat, 25 Apr 2020 09:53:34 +0200
Message-ID: <20200425075336.721021-2-hch@lst.de>
References: <20200425075336.721021-1-hch@lst.de>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20200425075336.721021-1-hch@lst.de>
Sender: linux-block-owner@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>
Cc: dm-devel@redhat.com, linux-bcache@vger.kernel.org, linux-block@vger.kernel.org
List-Id: dm-devel.ids

The make_request_fn pointer should only be assigned by blk_alloc_queue.
Fix a left over manual initialization.

Fixes: ff27668ce809 ("bcache: pass the make_request methods to blk_queue_make_request")
Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/md/bcache/request.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/md/bcache/request.c b/drivers/md/bcache/request.c
index 71a90fbec314b..77d1a26975174 100644
--- a/drivers/md/bcache/request.c
+++ b/drivers/md/bcache/request.c
@@ -1372,7 +1372,6 @@ void bch_flash_dev_request_init(struct bcache_device *d)
 {
 	struct gendisk *g = d->disk;
 
-	g->queue->make_request_fn		= flash_dev_make_request;
 	g->queue->backing_dev_info->congested_fn = flash_dev_congested;
 	d->cache_miss				= flash_dev_cache_miss;
 	d->ioctl				= flash_dev_ioctl;
-- 
2.26.1

From: Huaisheng Ye <yehs2007@zoho.com>
Subject: [PATCH v2 3/4] dm writecache: remove unused member page_offset in writeback_struct
Date: Thu, 25 Apr 2019 21:31:19 +0800
Message-ID: <20190425133120.13088-4-yehs2007@zoho.com>
References: <20190425133120.13088-1-yehs2007@zoho.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190425133120.13088-1-yehs2007@zoho.com>
Sender: linux-kernel-owner@vger.kernel.org
To: mpatocka@redhat.com, snitzer@redhat.com, agk@redhat.com
Cc: prarit@redhat.com, chengnt@lenovo.com, dm-devel@redhat.com, linux-kernel@vger.kernel.org, Huaisheng Ye <yehs1@lenovo.com>
List-Id: dm-devel.ids

From: Huaisheng Ye <yehs1@lenovo.com>

The stucture member page_offset in writeback_struct never has been
used actually. Remove it.

Signed-off-by: Huaisheng Ye <yehs1@lenovo.com>
Acked-by: Mikulas Patocka <mpatocka@redhat.com>
---
 drivers/md/dm-writecache.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/md/dm-writecache.c b/drivers/md/dm-writecache.c
index cfbbfbc..ddf1732 100644
--- a/drivers/md/dm-writecache.c
+++ b/drivers/md/dm-writecache.c
@@ -190,7 +190,6 @@ struct writeback_struct {
 	struct dm_writecache *wc;
 	struct wc_entry **wc_list;
 	unsigned wc_list_n;
-	unsigned page_offset;
 	struct page *page;
 	struct wc_entry *wc_list_inline[WB_LIST_INLINE];
 	struct bio bio;
@@ -1481,7 +1480,6 @@ static void __writecache_writeback_pmem(struct dm_writecache *wc, struct writeba
 		bio->bi_end_io = writecache_writeback_endio;
 		bio_set_dev(bio, wc->dev->bdev);
 		bio->bi_iter.bi_sector = read_original_sector(wc, e);
-		wb->page_offset = PAGE_SIZE;
 		if (max_pages <= WB_LIST_INLINE ||
 		    unlikely(!(wb->wc_list = kmalloc_array(max_pages, sizeof(struct wc_entry *),
 							   GFP_NOIO | __GFP_NORETRY |
-- 
1.8.3.1

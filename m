From: Huaisheng Ye <yehs2007@zoho.com>
Subject: [PATCH v2 1/4] dm writecache: remove needless dereferences in __writecache_writeback_pmem()
Date: Thu, 25 Apr 2019 21:31:17 +0800
Message-ID: <20190425133120.13088-2-yehs2007@zoho.com>
References: <20190425133120.13088-1-yehs2007@zoho.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190425133120.13088-1-yehs2007@zoho.com>
Sender: linux-kernel-owner@vger.kernel.org
To: mpatocka@redhat.com, snitzer@redhat.com, agk@redhat.com
Cc: prarit@redhat.com, chengnt@lenovo.com, dm-devel@redhat.com, linux-kernel@vger.kernel.org, Huaisheng Ye <yehs1@lenovo.com>
List-Id: dm-devel.ids

From: Huaisheng Ye <yehs1@lenovo.com>

bio is already available so there is no need to access it in terms of
the wb pointer.

Signed-off-by: Huaisheng Ye <yehs1@lenovo.com>
Signed-off-by: Mike Snitzer <snitzer@redhat.com>
---
 drivers/md/dm-writecache.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/md/dm-writecache.c b/drivers/md/dm-writecache.c
index f782287..5b4d1c1 100644
--- a/drivers/md/dm-writecache.c
+++ b/drivers/md/dm-writecache.c
@@ -1478,9 +1478,9 @@ static void __writecache_writeback_pmem(struct dm_writecache *wc, struct writeba
 		bio = bio_alloc_bioset(GFP_NOIO, max_pages, &wc->bio_set);
 		wb = container_of(bio, struct writeback_struct, bio);
 		wb->wc = wc;
-		wb->bio.bi_end_io = writecache_writeback_endio;
-		bio_set_dev(&wb->bio, wc->dev->bdev);
-		wb->bio.bi_iter.bi_sector = read_original_sector(wc, e);
+		bio->bi_end_io = writecache_writeback_endio;
+		bio_set_dev(bio, wc->dev->bdev);
+		bio->bi_iter.bi_sector = read_original_sector(wc, e);
 		wb->page_offset = PAGE_SIZE;
 		if (max_pages <= WB_LIST_INLINE ||
 		    unlikely(!(wb->wc_list = kmalloc_array(max_pages, sizeof(struct wc_entry *),
@@ -1507,12 +1507,12 @@ static void __writecache_writeback_pmem(struct dm_writecache *wc, struct writeba
 			wb->wc_list[wb->wc_list_n++] = f;
 			e = f;
 		}
-		bio_set_op_attrs(&wb->bio, REQ_OP_WRITE, WC_MODE_FUA(wc) * REQ_FUA);
+		bio_set_op_attrs(bio, REQ_OP_WRITE, WC_MODE_FUA(wc) * REQ_FUA);
 		if (writecache_has_error(wc)) {
 			bio->bi_status = BLK_STS_IOERR;
-			bio_endio(&wb->bio);
+			bio_endio(bio);
 		} else {
-			submit_bio(&wb->bio);
+			submit_bio(bio);
 		}
 
 		__writeback_throttle(wc, wbl);
-- 
1.8.3.1

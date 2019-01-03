From: Huaisheng Ye <yehs2007@zoho.com>
Subject: [PATCH 2/2] dm-writecache: get rid of memory_data flush to writecache_flush_entry
Date: Thu,  3 Jan 2019 16:34:20 +0800
Message-ID: <20190103083420.8444-1-yehs2007@zoho.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: snitzer@redhat.com
Cc: agk@redhat.com, hch@lst.de, dm-devel@redhat.com, linux-kernel@vger.kernel.org, chengnt@lenovo.com, Huaisheng Ye <yehs1@lenovo.com>
List-Id: dm-devel.ids

From: Huaisheng Ye <yehs1@lenovo.com>

writecache_flush_region only works when SSD mode.
If wc->pmem_mode sets, writecache_flush_region doesn't need to be called in
writecache_flush_entry.

Signed-off-by: Huaisheng Ye <yehs1@lenovo.com>
---
 drivers/md/dm-writecache.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/md/dm-writecache.c b/drivers/md/dm-writecache.c
index 2d8e0c0..c69317c 100644
--- a/drivers/md/dm-writecache.c
+++ b/drivers/md/dm-writecache.c
@@ -688,8 +688,6 @@ static void writecache_poison_lists(struct dm_writecache *wc)
 static void writecache_flush_entry(struct dm_writecache *wc, struct wc_entry *e)
 {
 	writecache_flush_region(wc, memory_entry(wc, e));
-	if (WC_MODE_PMEM(wc))
-		writecache_flush_region(wc, memory_data(wc, e));
 }
 
 static bool writecache_entry_is_committed(struct dm_writecache *wc, struct wc_entry *e)
-- 
1.8.3.1

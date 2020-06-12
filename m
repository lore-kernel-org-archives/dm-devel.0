From: Huaisheng Ye <yehs2007@zoho.com>
Subject: [PATCH] dm writecache: skip writecache_wait when using pmem mode
Date: Fri, 12 Jun 2020 23:55:44 +0800
Message-ID: <20200612155544.90348-1-yehs2007@zoho.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: mpatocka@redhat.com, snitzer@redhat.com, agk@redhat.com
Cc: dm-devel@redhat.com, linux-kernel@vger.kernel.org, Huaisheng Ye <yehs1@lenovo.com>
List-Id: dm-devel.ids

From: Huaisheng Ye <yehs1@lenovo.com>

The array bio_in_progress is only used with ssd mode. So skip
writecache_wait_for_ios in writecache_discard when pmem mode.

Signed-off-by: Huaisheng Ye <yehs1@lenovo.com>
---
 drivers/md/dm-writecache.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/md/dm-writecache.c b/drivers/md/dm-writecache.c
index 66f3a3b..4367cc7 100644
--- a/drivers/md/dm-writecache.c
+++ b/drivers/md/dm-writecache.c
@@ -849,8 +849,10 @@ static void writecache_discard(struct dm_writecache *wc, sector_t start, sector_
 
 		if (likely(!e->write_in_progress)) {
 			if (!discarded_something) {
-				writecache_wait_for_ios(wc, READ);
-				writecache_wait_for_ios(wc, WRITE);
+				if (!WC_MODE_PMEM(wc)) {
+					writecache_wait_for_ios(wc, READ);
+					writecache_wait_for_ios(wc, WRITE);
+				}
 				discarded_something = true;
 			}
 			writecache_free_entry(wc, e);
-- 
1.8.3.1

From: Huaisheng Ye <yehs2007@zoho.com>
Subject: [PATCH 2/3] dm writecache: add unlikely for getting two block with same LBA
Date: Sun, 25 Aug 2019 15:24:32 +0800
Message-ID: <20190825072433.2628-3-yehs2007@zoho.com>
References: <20190825072433.2628-1-yehs2007@zoho.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190825072433.2628-1-yehs2007@zoho.com>
Sender: linux-kernel-owner@vger.kernel.org
To: mpatocka@redhat.com, snitzer@redhat.com, agk@redhat.com
Cc: prarit@redhat.com, tyu1@lenovo.com, dm-devel@redhat.com, linux-kernel@vger.kernel.org, Huaisheng Ye <yehs1@lenovo.com>
List-Id: dm-devel.ids

From: Huaisheng Ye <yehs1@lenovo.com>

In function writecache_writeback, entries g and f has same original
sector only happens at entry f has been committed, but entry g has
NOT yet.

The probability of this happening is very low in the following
256 blocks at most of entry e.

Signed-off-by: Huaisheng Ye <yehs1@lenovo.com>
Acked-by: Mikulas Patocka <mpatocka@redhat.com>
---
 drivers/md/dm-writecache.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/md/dm-writecache.c b/drivers/md/dm-writecache.c
index 5c7009d..3643084 100644
--- a/drivers/md/dm-writecache.c
+++ b/drivers/md/dm-writecache.c
@@ -1628,8 +1628,8 @@ static void writecache_writeback(struct work_struct *work)
 			if (unlikely(!next_node))
 				break;
 			g = container_of(next_node, struct wc_entry, rb_node);
-			if (read_original_sector(wc, g) ==
-			    read_original_sector(wc, f)) {
+			if (unlikely(read_original_sector(wc, g) ==
+			    read_original_sector(wc, f))) {
 				f = g;
 				continue;
 			}
-- 
1.8.3.1

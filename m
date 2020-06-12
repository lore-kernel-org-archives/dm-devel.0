From: Huaisheng Ye <yehs2007@zoho.com>
Subject: [PATCH] dm writecache: correct uncommitted_block when discarding uncommitted entry
Date: Fri, 12 Jun 2020 23:59:11 +0800
Message-ID: <20200612155911.96528-1-yehs2007@zoho.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: mpatocka@redhat.com, snitzer@redhat.com, agk@redhat.com
Cc: dm-devel@redhat.com, linux-kernel@vger.kernel.org, Huaisheng Ye <yehs1@lenovo.com>
List-Id: dm-devel.ids

From: Huaisheng Ye <yehs1@lenovo.com>

When uncommitted entry has been discarded, correct wc->uncommitted_block
for getting the exact number.

Signed-off-by: Huaisheng Ye <yehs1@lenovo.com>
---
 drivers/md/dm-writecache.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/md/dm-writecache.c b/drivers/md/dm-writecache.c
index 4367cc7..64b4527 100644
--- a/drivers/md/dm-writecache.c
+++ b/drivers/md/dm-writecache.c
@@ -855,6 +855,8 @@ static void writecache_discard(struct dm_writecache *wc, sector_t start, sector_
 				}
 				discarded_something = true;
 			}
+			if (!writecache_entry_is_committed(wc, e))
+				wc->uncommitted_blocks--;
 			writecache_free_entry(wc, e);
 		}
 
-- 
1.8.3.1

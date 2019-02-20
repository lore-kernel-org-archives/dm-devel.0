From: Huaisheng Ye <yehs2007@zoho.com>
Subject: [PATCH] dm-writecache: fix typo when alloc workqueue for writeback_wq
Date: Thu, 21 Feb 2019 00:34:47 +0800
Message-ID: <20190220163447.9652-1-yehs2007@zoho.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: mpatocka@redhat.com, snitzer@redhat.com, agk@redhat.com
Cc: chengnt@lenovo.com, dm-devel@redhat.com, linux-kernel@vger.kernel.org, Huaisheng Ye <yehs1@lenovo.com>
List-Id: dm-devel.ids

From: Huaisheng Ye <yehs1@lenovo.com>

The workqueue's name should be "writecache-writeback" instead of "writecache-writeabck".

Signed-off-by: Huaisheng Ye <yehs1@lenovo.com>
---
 drivers/md/dm-writecache.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/md/dm-writecache.c b/drivers/md/dm-writecache.c
index 2b8cee3..f782287 100644
--- a/drivers/md/dm-writecache.c
+++ b/drivers/md/dm-writecache.c
@@ -1859,7 +1859,7 @@ static int writecache_ctr(struct dm_target *ti, unsigned argc, char **argv)
 		goto bad;
 	}
 
-	wc->writeback_wq = alloc_workqueue("writecache-writeabck", WQ_MEM_RECLAIM, 1);
+	wc->writeback_wq = alloc_workqueue("writecache-writeback", WQ_MEM_RECLAIM, 1);
 	if (!wc->writeback_wq) {
 		r = -ENOMEM;
 		ti->error = "Could not allocate writeback workqueue";
-- 
1.8.3.1

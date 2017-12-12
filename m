From: Ma Shimiao <mashimiao.fnst@cn.fujitsu.com>
Subject: [PATCH] drviers/md: fix max dup length for kstrndup
Date: Tue, 12 Dec 2017 17:39:10 +0800
Message-ID: <20171212093910.21743-1-mashimiao.fnst@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: agk@redhat.com, snitzer@redhat.com, dm-devel@redhat.com
Cc: linux-kernel@vger.kernel.org, Ma Shimiao <mashimiao.fnst@cn.fujitsu.com>
List-Id: dm-devel.ids

If source string longer than max, kstrndup will alloc max+1 space.
So, we should make sure the result will not over limit.

Signed-off-by: Ma Shimiao <mashimiao.fnst@cn.fujitsu.com>
---
 drivers/md/dm-log-writes.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/md/dm-log-writes.c b/drivers/md/dm-log-writes.c
index 189badbeddaf..3362d866793b 100644
--- a/drivers/md/dm-log-writes.c
+++ b/drivers/md/dm-log-writes.c
@@ -594,7 +594,7 @@ static int log_mark(struct log_writes_c *lc, char *data)
 		return -ENOMEM;
 	}
 
-	block->data = kstrndup(data, maxsize, GFP_KERNEL);
+	block->data = kstrndup(data, maxsize - 1, GFP_KERNEL);
 	if (!block->data) {
 		DMERR("Error copying mark data");
 		kfree(block);
-- 
2.13.6

From: Nikolay Borisov <kernel@kyup.com>
Subject: [PATCH] dm-thin: Fix race condition when destroying thin pool
Date: Thu, 17 Dec 2015 18:03:35 +0200
Message-ID: <1450368215-3351-1-git-send-email-kernel@kyup.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: snitzer@redhat.com
Cc: agk@redhat.com, dm-devel@redhat.com, operations@siteground.com, linux-kernel@vger.kernel.org, ejt@redhat.com, tj@kernel.org, stable@vger.kernel.org
List-Id: dm-devel.ids

When a thin pool is being destroyed delayed work items are
canceled using cancel_delayed_work item, which doesn't
guarantee that on return the delayed item wasn't running. This
can cause the workitem to requeue itself on an already destroyed
workqueue. Fix this by using cancel_delayed_work item which
guarantees that on return the workitem is not running anymore.

Fixes: 905e51b39a555 ("dm thin: commit outstanding data every second")
Fixes: 85ad643b7e7e52 ("dm thin: add timeout to stop out-of-data-space 
mode holding IO forever")
Signed-off-by: Nikolay Borisov <kernel@kyup.com>
Cc: <stable@vger.kernel.org>

---
 drivers/md/dm-thin.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/md/dm-thin.c b/drivers/md/dm-thin.c
index 63903a5a5d9e..a1cc797fe88f 100644
--- a/drivers/md/dm-thin.c
+++ b/drivers/md/dm-thin.c
@@ -3453,8 +3453,8 @@ static void pool_postsuspend(struct dm_target *ti)
 	struct pool_c *pt = ti->private;
 	struct pool *pool = pt->pool;
 
-	cancel_delayed_work(&pool->waker);
-	cancel_delayed_work(&pool->no_space_timeout);
+	cancel_delayed_work_sync(&pool->waker);
+	cancel_delayed_work_sync(&pool->no_space_timeout);
 	flush_workqueue(pool->wq);
 	(void) commit(pool);
 }
-- 
2.5.0

From: Mike Snitzer <snitzer@redhat.com>
Subject: [for-4.16 PATCH v4 2/4] block: use queue_lock when clearing QUEUE_FLAG_REGISTERED in blk_unregister_queue
Date: Thu, 11 Jan 2018 15:14:15 -0500
Message-ID: <20180111201417.2042-3-snitzer@redhat.com>
References: <20180111201417.2042-1-snitzer@redhat.com>
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20180111201417.2042-1-snitzer@redhat.com>
Sender: linux-block-owner@vger.kernel.org
To: axboe@kernel.dk
Cc: Ming Lei <tom.leiming@gmail.com>, hare@suse.de, Bart.VanAssche@wdc.com, dm-devel@redhat.com, linux-block@vger.kernel.org
List-Id: dm-devel.ids

blk_unregister_queue() must protect against any modifications of
q->queue_flags (not just those performed in blk-sysfs.c).  Therefore
q->queue_lock needs to be used rather than q->sysfs_lock.

Fixes: e9a823fb34a8b ("block: fix warning when I/O elevator is changed as request_queue is being removed")
Cc: stable@vger.kernel.org # 4.14+
Reported-by: Bart Van Assche <Bart.VanAssche@wdc.com>
Signed-off-by: Mike Snitzer <snitzer@redhat.com>
---
 block/blk-sysfs.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/block/blk-sysfs.c b/block/blk-sysfs.c
index 870484eaed1f..52f57539f1c7 100644
--- a/block/blk-sysfs.c
+++ b/block/blk-sysfs.c
@@ -929,9 +929,9 @@ void blk_unregister_queue(struct gendisk *disk)
 	if (WARN_ON(!q))
 		return;
 
-	mutex_lock(&q->sysfs_lock);
+	spin_lock_irq(q->queue_lock);
 	queue_flag_clear_unlocked(QUEUE_FLAG_REGISTERED, q);
-	mutex_unlock(&q->sysfs_lock);
+	spin_unlock_irq(q->queue_lock);
 
 	wbt_exit(q);
 
-- 
2.15.0

From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: [PATCH 7/9] dm: Mark block layer queue dead before
 destroying the dm device
Date: Wed, 31 Aug 2016 15:17:49 -0700
Message-ID: <8c4894ad-cc0d-f530-bcb1-d5da0c89968b@sandisk.com>
References: <18db2396-cd4f-1d52-1ffa-21b9b512eaf4@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <18db2396-cd4f-1d52-1ffa-21b9b512eaf4@sandisk.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Mike Snitzer <snitzer@redhat.com>
Cc: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

This avoids that new requests are queued while __dm_destroy() is in
progress.

Signed-off-by: Bart Van Assche <bart.vanassche@sandisk.com>
---
 drivers/md/dm.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index 0775411..4aa7030 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -1875,6 +1875,7 @@ EXPORT_SYMBOL_GPL(dm_device_name);
 
 static void __dm_destroy(struct mapped_device *md, bool wait)
 {
+	struct request_queue *q = dm_get_md_queue(md);
 	struct dm_table *map;
 	int srcu_idx;
 
@@ -1885,6 +1886,10 @@ static void __dm_destroy(struct mapped_device *md, bool wait)
 	set_bit(DMF_FREEING, &md->flags);
 	spin_unlock(&_minor_lock);
 
+	spin_lock_irq(q->queue_lock);
+	queue_flag_set(QUEUE_FLAG_DYING, q);
+	spin_unlock_irq(q->queue_lock);
+
 	if (dm_request_based(md) && md->kworker_task)
 		flush_kthread_worker(&md->kworker);
 
-- 
2.9.3

From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Subject: [PATCH] dm rq: remove BUG_ON(!irqs_disabled) check
Date: Tue, 27 Mar 2018 16:42:38 +0200
Message-ID: <20180327144238.12529-1-bigeasy@linutronix.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com
Cc: Keith Busch <keith.busch@intel.com>, tglx@linutronix.de, Sebastian Andrzej Siewior <bigeasy@linutronix.de>, Mike Snitzer <snitzer@redhat.com>, Alasdair Kergon <agk@redhat.com>
List-Id: dm-devel.ids

In commit 052189a2ec95 ("dm: remove superfluous irq disablement in
dm_request_fn") the spin_lock_irq() was replaced with spin_lock() + a
check for disabled interrupts. Later the locking part was removed in
commit 2eb6e1e3aa87 ("dm: submit stacked requests in irq enabled
context") but the BUG_ON() check remained.

Since the original purpose for the "are-irqs-off" check is gone (the
->queue_lock has been removed) I am removing the BUG_ON() check.

Cc: Keith Busch <keith.busch@intel.com>
Cc: Mike Snitzer <snitzer@redhat.com>
Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
---
 drivers/md/dm-rq.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/md/dm-rq.c b/drivers/md/dm-rq.c
index bf0b840645cc..1a524f992f72 100644
--- a/drivers/md/dm-rq.c
+++ b/drivers/md/dm-rq.c
@@ -688,7 +688,6 @@ static void dm_old_request_fn(struct request_queue *q)
 		/* Establish tio->ti before queuing work (map_tio_request) */
 		tio->ti = ti;
 		kthread_queue_work(&md->kworker, &tio->work);
-		BUG_ON(!irqs_disabled());
 	}
 }
 
-- 
2.16.3

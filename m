From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Subject: [PATCH] dm rq: replace BUG_ON(!irqs_disabled) with
 lockdep's lock annotation
Date: Mon, 14 May 2018 18:24:07 +0200
Message-ID: <20180514162407.rigrq3enfic3i7xw@linutronix.de>
References: <20180504143639.5300-1-bigeasy@linutronix.de>
	<20180504155311.GA4787@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20180504155311.GA4787@redhat.com>
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
Cc: Keith Busch <keith.busch@intel.com>, dm-devel@redhat.com, Thomas Gleixner <tglx@linutronix.de>, Alasdair Kergon <agk@redhat.com>
List-Id: dm-devel.ids

In commit 052189a2ec95 ("dm: remove superfluous irq disablement in
dm_request_fn") the spin_lock_irq() was replaced with spin_lock() + a
check for disabled interrupts. Later the locking part was removed in
commit 2eb6e1e3aa87 ("dm: submit stacked requests in irq enabled
context") but the BUG_ON() check remained.
Mike Snitzer explained that:
|the queue_lock hasn't been removed for the old .request_fn path in block
|core -- which dm_old_request_fn is providing the hook for.
|
|This BUG_ON() documents that reality.

The BUG_ON() statement checks for disabled interrupts. The better check
would to let lockdep check if the required lock (queue_lock) is held.
Lockdep will then validate that the lock is held an complain if this is
not the case. Since lockdep will see this lock held in IRQ-context it
will also complain should the interrupts be enabled while lock still
held or acquired with enabled interrupts. So this !irq_disabled() is not
required.
This change helps to avoid the BUG_ON() statement on preempt-rt where
the lock is a sleeping lock and interrupts are never really disabled.

Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
---
 drivers/md/dm-rq.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/md/dm-rq.c b/drivers/md/dm-rq.c
index bf0b840645cc..78a44bb7537f 100644
--- a/drivers/md/dm-rq.c
+++ b/drivers/md/dm-rq.c
@@ -688,7 +688,7 @@ static void dm_old_request_fn(struct request_queue *q)
 		/* Establish tio->ti before queuing work (map_tio_request) */
 		tio->ti = ti;
 		kthread_queue_work(&md->kworker, &tio->work);
-		BUG_ON(!irqs_disabled());
+		lockdep_assert_held(q->queue_lock);
 	}
 }
 
-- 
2.17.0

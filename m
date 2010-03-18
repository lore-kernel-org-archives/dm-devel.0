From: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Subject: [PATCH] rqdm: remove superfluous irq disablement
Date: Thu, 18 Mar 2010 20:07:36 +0900
Message-ID: <4BA20978.7090601@ct.jp.nec.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
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
To: Alasdair Kergon <agk@redhat.com>
Cc: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

Hi Alasdair,

This patch changes spin_lock_irq() to spin_lock() in dm_request_fn().
This patch is just a clean-up and no functional change.
Made for 2.6.34-rc1.
Please review and apply.

The spin_lock_irq() was leftover from the early request-based dm code,
where map_request() used to enable interrupts.
Since current map_request() never enable interrupts, we can change it
to spin_lock() so to match with the prior spin_unlock().

Auditing through the dm and block-layer code called from
map_request(), I confirmed all functions save/restore interrupt
status, so no function returning with interrupts enabled.
Also I haven't observed any problem on my test environment which
uses scsi and lpfc driver after heavy I/O testing with occasional
path down/up.

Added BUG_ON() to detect breakage in future.

Signed-off-by: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Signed-off-by: Jun'ichi Nomura <j-nomura@ce.jp.nec.com>
Cc: Alasdair G Kergon <agk@redhat.com>
---
 drivers/md/dm.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

Index: 2.6.34-rc1/drivers/md/dm.c
===================================================================
--- 2.6.34-rc1.orig/drivers/md/dm.c
+++ 2.6.34-rc1/drivers/md/dm.c
@@ -1688,13 +1688,15 @@ static void dm_request_fn(struct request
 		if (map_request(ti, clone, md))
 			goto requeued;
 
-		spin_lock_irq(q->queue_lock);
+		BUG_ON(!irqs_disabled());
+		spin_lock(q->queue_lock);
 	}
 
 	goto out;
 
 requeued:
-	spin_lock_irq(q->queue_lock);
+	BUG_ON(!irqs_disabled());
+	spin_lock(q->queue_lock);
 
 plug_and_out:
 	if (!elv_queue_empty(q))

From: Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH v2] dm: remove superfluous irq disablement in
	dm_request_fn
Date: Fri,  7 Jan 2011 14:22:36 -0500
Message-ID: <1294428156-5791-1-git-send-email-snitzer@redhat.com>
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
To: dm-devel@redhat.com
Cc: Jun'ichi Nomura <j-nomura@ce.jp.nec.com>, Kiyoshi Ueda <k-ueda@ct.jp.nec.com>, Mike Snitzer <snitzer@redhat.com>
List-Id: dm-devel.ids

From: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>

This patch changes spin_lock_irq() to spin_lock() in dm_request_fn().
This patch is just a clean-up and no functional change.

The spin_lock_irq() was leftover from the early request-based dm code,
where map_request() used to enable interrupts.
Since current map_request() never enables interrupts, we can change it
to spin_lock() to match the prior spin_unlock().

Auditing through the dm and block-layer code called from
map_request(), I confirmed all functions save/restore interrupt
status, so no function returning with interrupts enabled.
Also I haven't observed any problem on my test environment which
uses scsi and lpfc driver after heavy I/O testing with occasional
path down/up.

Added BUG_ON() to detect breakage in future.

Signed-off-by: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Signed-off-by: Jun'ichi Nomura <j-nomura@ce.jp.nec.com>
Signed-off-by: Mike Snitzer <snitzer@redhat.com>
---
 drivers/md/dm.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

v2: just refreshed to avoid offset and made slight changes to patch header
    - v1 is here: https://patchwork.kernel.org/patch/86694/
Index: linux-2.6/drivers/md/dm.c
===================================================================
--- linux-2.6.orig/drivers/md/dm.c
+++ linux-2.6/drivers/md/dm.c
@@ -1637,13 +1637,15 @@ static void dm_request_fn(struct request
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

From: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Subject: [PATCH] rqdm: fix stall when ->map_rq returns
	DM_MAPIO_REQUEUE
Date: Wed, 03 Feb 2010 16:03:11 +0900
Message-ID: <4B691FAF.6030509@ct.jp.nec.com>
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

This patch fixes the problem that system may stall if target's ->map_rq
returns DM_MAPIO_REQUEUE in map_request().
E.g. stall happens on 1 CPU box when a dm-mpath device with queue_if_no_path
     bounces between all-paths-down and paths-up on I/O load.

It is for 2.6.33-rc6, and no dependency on your editing patches.
Please review and apply.

When target's ->map_rq returns DM_MAPIO_REQUEUE, map_request() requeues
the request and returns to dm_request_fn().  Then, dm_request_fn()
doesn't exit the I/O dispatching loop and continues processing
the requeued request again.
This map and requeue loop can be done with interrupt disabled,
so 1 CPU system can be stalled if this situation happens.

For example, commands below can stall my 1 CPU box within 1 minute or so:
  # dmsetup table mp
  mp: 0 2097152 multipath 1 queue_if_no_path 0 1 1 service-time 0 1 2 8:144 1 1
  # while true; do dd if=/dev/mapper/mp of=/dev/null bs=1M count=100; done &
  # while true; do \
  > dmsetup message mp 0 "fail_path 8:144" \
  > dmsetup suspend --noflush mp \
  > dmsetup resume mp \
  > dmsetup message mp 0 "reinstate_path 8:144" \
  > done

To fix the problem above, this patch changes dm_request_fn() to exit
the I/O dispatching loop once if a request is requeued in map_request().

Signed-off-by: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Signed-off-by: Jun'ichi Nomura <j-nomura@ce.jp.nec.com>
Cc: Alasdair G Kergon <agk@redhat.com>
---
 drivers/md/dm.c |   21 +++++++++++++++++----
 1 file changed, 17 insertions(+), 4 deletions(-)

Index: 2.6.33-rc6/drivers/md/dm.c
===================================================================
--- 2.6.33-rc6.orig/drivers/md/dm.c
+++ 2.6.33-rc6/drivers/md/dm.c
@@ -1595,10 +1595,15 @@ static int dm_prep_fn(struct request_que
 	return BLKPREP_OK;
 }
 
-static void map_request(struct dm_target *ti, struct request *clone,
-			struct mapped_device *md)
+/*
+ * Returns:
+ * 0  : the request has been processed (not requeued)
+ * !0 : the request has been requeued
+ */
+static int map_request(struct dm_target *ti, struct request *clone,
+		       struct mapped_device *md)
 {
-	int r;
+	int r, requeued = 0;
 	struct dm_rq_target_io *tio = clone->end_io_data;
 
 	/*
@@ -1625,6 +1630,7 @@ static void map_request(struct dm_target
 	case DM_MAPIO_REQUEUE:
 		/* The target wants to requeue the I/O */
 		dm_requeue_unmapped_request(clone);
+		requeued = 1;
 		break;
 	default:
 		if (r > 0) {
@@ -1636,6 +1642,8 @@ static void map_request(struct dm_target
 		dm_kill_unmapped_request(clone, r);
 		break;
 	}
+
+	return requeued;
 }
 
 /*
@@ -1677,12 +1685,17 @@ static void dm_request_fn(struct request
 		atomic_inc(&md->pending[rq_data_dir(clone)]);
 
 		spin_unlock(q->queue_lock);
-		map_request(ti, clone, md);
+		if (map_request(ti, clone, md))
+			goto requeued;
+
 		spin_lock_irq(q->queue_lock);
 	}
 
 	goto out;
 
+requeued:
+	spin_lock_irq(q->queue_lock);
+
 plug_and_out:
 	if (!elv_queue_empty(q))
 		/* Some requests still remain, retry later */

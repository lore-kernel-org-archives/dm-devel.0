From: Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH] dm mpath: disable call to blk_abort_queue and
	related code
Date: Thu, 18 Nov 2010 16:48:16 -0500
Message-ID: <1290116896-18209-1-git-send-email-snitzer@redhat.com>
References: <20101118201841.GE30435@agk-dp.fab.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20101118201841.GE30435@agk-dp.fab.redhat.com>
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
Cc: Mike Christie <michaelc@cs.wisc.edu>, Mike Anderson <andmike@linux.vnet.ibm.com>
List-Id: dm-devel.ids

Multipath was previously made to use blk_abort_queue() to allow for
lower latency path deactivation (commit 224cb3e9).  The call to
blk_abort_queue has proven to be unsafe due to a race (between
blk_abort_queue and scsi_request_fn) that can lead to list corruption,
from: https://www.redhat.com/archives/dm-devel/2010-November/msg00085.html

"the cmd gets blk_abort_queued/timedout run on it and the scsi eh
somehow is able to complete and run scsi_queue_insert while
scsi_request_fn is still trying to process the request."

It is hoped that this race will be fixed soon so it makes little sense
to remove all associated code at this point.

Signed-off-by: Mike Snitzer <snitzer@redhat.com>
Cc: Mike Anderson <andmike@linux.vnet.ibm.com>
Cc: Mike Christie <michaelc@cs.wisc.edu>
---
 drivers/md/dm-mpath.c |   13 +++++++++++++
 1 files changed, 13 insertions(+), 0 deletions(-)

diff --git a/drivers/md/dm-mpath.c b/drivers/md/dm-mpath.c
index 487ecda..6292e41 100644
--- a/drivers/md/dm-mpath.c
+++ b/drivers/md/dm-mpath.c
@@ -24,6 +24,9 @@
 #define DM_MSG_PREFIX "multipath"
 #define MESG_STR(x) x, sizeof(x)
 
+/* Avoid calling blk_abort_queue until race with scsi_request_fn is fixed */
+#define MPATH_CALL_BLK_ABORT_QUEUE 0
+
 /* Path properties */
 struct pgpath {
 	struct list_head list;
@@ -33,7 +36,9 @@ struct pgpath {
 	unsigned fail_count;		/* Cumulative failure count */
 
 	struct dm_path path;
+#if MPATH_CALL_BLK_ABORT_QUEUE
 	struct work_struct deactivate_path;
+#endif
 	struct work_struct activate_path;
 };
 
@@ -116,7 +121,9 @@ static struct workqueue_struct *kmultipathd, *kmpath_handlerd;
 static void process_queued_ios(struct work_struct *work);
 static void trigger_event(struct work_struct *work);
 static void activate_path(struct work_struct *work);
+#if MPATH_CALL_BLK_ABORT_QUEUE
 static void deactivate_path(struct work_struct *work);
+#endif
 
 
 /*-----------------------------------------------
@@ -129,7 +136,9 @@ static struct pgpath *alloc_pgpath(void)
 
 	if (pgpath) {
 		pgpath->is_active = 1;
+#if MPATH_CALL_BLK_ABORT_QUEUE
 		INIT_WORK(&pgpath->deactivate_path, deactivate_path);
+#endif
 		INIT_WORK(&pgpath->activate_path, activate_path);
 	}
 
@@ -141,6 +150,7 @@ static void free_pgpath(struct pgpath *pgpath)
 	kfree(pgpath);
 }
 
+#if MPATH_CALL_BLK_ABORT_QUEUE
 static void deactivate_path(struct work_struct *work)
 {
 	struct pgpath *pgpath =
@@ -148,6 +158,7 @@ static void deactivate_path(struct work_struct *work)
 
 	blk_abort_queue(pgpath->path.dev->bdev->bd_disk->queue);
 }
+#endif
 
 static struct priority_group *alloc_priority_group(void)
 {
@@ -995,7 +1006,9 @@ static int fail_path(struct pgpath *pgpath)
 		      pgpath->path.dev->name, m->nr_valid_paths);
 
 	schedule_work(&m->trigger_event);
+#if MPATH_CALL_BLK_ABORT_QUEUE
 	queue_work(kmultipathd, &pgpath->deactivate_path);
+#endif
 
 out:
 	spin_unlock_irqrestore(&m->lock, flags);

From: Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH v2] dm mpath: revert "dm: Call blk_abort_queue on
 failed paths"
Date: Mon, 22 Nov 2010 20:00:25 -0500
Message-ID: <20101123010025.GA18584@redhat.com>
References: <20101118201841.GE30435@agk-dp.fab.redhat.com>
	<1290116896-18209-1-git-send-email-snitzer@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <1290116896-18209-1-git-send-email-snitzer@redhat.com>
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

This reverts commit 224cb3e981f1b2f9f93dbd49eaef505d17d894c2.

Multipath was previously made to use blk_abort_queue() to allow for
lower latency path deactivation.  The call to blk_abort_queue has proven
to be unsafe due to a race (between blk_abort_queue and scsi_request_fn)
that can lead to list corruption, from:
https://www.redhat.com/archives/dm-devel/2010-November/msg00085.html

"the cmd gets blk_abort_queued/timedout run on it and the scsi eh
somehow is able to complete and run scsi_queue_insert while
scsi_request_fn is still trying to process the request."

Signed-off-by: Mike Snitzer <snitzer@redhat.com>
Cc: Mike Anderson <andmike@linux.vnet.ibm.com>
Cc: Mike Christie <michaelc@cs.wisc.edu>
---
 drivers/md/dm-mpath.c |   12 ------------
 1 file changed, 12 deletions(-)

v2: revert commit rather than #if 0 the code in question

Index: linux-2.6/drivers/md/dm-mpath.c
===================================================================
--- linux-2.6.orig/drivers/md/dm-mpath.c
+++ linux-2.6/drivers/md/dm-mpath.c
@@ -33,7 +33,6 @@ struct pgpath {
 	unsigned fail_count;		/* Cumulative failure count */
 
 	struct dm_path path;
-	struct work_struct deactivate_path;
 	struct work_struct activate_path;
 };
 
@@ -116,7 +115,6 @@ static struct workqueue_struct *kmultipa
 static void process_queued_ios(struct work_struct *work);
 static void trigger_event(struct work_struct *work);
 static void activate_path(struct work_struct *work);
-static void deactivate_path(struct work_struct *work);
 
 
 /*-----------------------------------------------
@@ -129,7 +127,6 @@ static struct pgpath *alloc_pgpath(void)
 
 	if (pgpath) {
 		pgpath->is_active = 1;
-		INIT_WORK(&pgpath->deactivate_path, deactivate_path);
 		INIT_WORK(&pgpath->activate_path, activate_path);
 	}
 
@@ -141,14 +138,6 @@ static void free_pgpath(struct pgpath *p
 	kfree(pgpath);
 }
 
-static void deactivate_path(struct work_struct *work)
-{
-	struct pgpath *pgpath =
-		container_of(work, struct pgpath, deactivate_path);
-
-	blk_abort_queue(pgpath->path.dev->bdev->bd_disk->queue);
-}
-
 static struct priority_group *alloc_priority_group(void)
 {
 	struct priority_group *pg;
@@ -995,7 +984,6 @@ static int fail_path(struct pgpath *pgpa
 		      pgpath->path.dev->name, m->nr_valid_paths);
 
 	schedule_work(&m->trigger_event);
-	queue_work(kmultipathd, &pgpath->deactivate_path);
 
 out:
 	spin_unlock_irqrestore(&m->lock, flags);

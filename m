From: Mike Anderson <andmike@linux.vnet.ibm.com>
Subject: [PATCH 4/9] blk: Call unprep_fn from elv_abort_queue is available
Date: Mon,  3 May 2010 20:37:03 -0700
Message-ID: <1272944228-30511-5-git-send-email-andmike@linux.vnet.ibm.com>
References: <1272944228-30511-1-git-send-email-andmike@linux.vnet.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
In-Reply-To: <1272944228-30511-1-git-send-email-andmike@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Jens Axobe <jens.axboe@oracle.com>, James Bottomley <James.Bottomley@suse.de>, dm-devel@redhat.com
List-Id: dm-devel.ids

Call the unprep_fn for the queue if it has been set for requests that have
been prepped indicated by REQ_DONTPREP being set.

Signed-off-by: Mike Anderson <andmike@linux.vnet.ibm.com>
Cc: Jens Axobe <jens.axboe@oracle.com>
---
 block/elevator.c |    8 ++++++--
 1 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/block/elevator.c b/block/elevator.c
index ac98008..1f1e942 100644
--- a/block/elevator.c
+++ b/block/elevator.c
@@ -817,8 +817,12 @@ void elv_abort_queue(struct request_queue *q)
 	list_splice_init(&q->queue_head, &list);
 
 	list_for_each_entry_safe(rq, tmp, &list, queuelist) {
-		if (rq->cmd_flags & REQ_DONTPREP)
-			continue;
+		if (rq->cmd_flags & REQ_DONTPREP) {
+			if (q->unprep_rq_fn)
+				q->unprep_rq_fn(q, rq);
+			else
+				continue;
+		}
 		rq->cmd_flags |= REQ_QUIET;
 		trace_block_rq_abort(q, rq);
 		/*
-- 
1.6.6.1


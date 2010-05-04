From: Mike Anderson <andmike@linux.vnet.ibm.com>
Subject: [PATCH 9/9] scsi: Add blk_request_aborted check
Date: Mon,  3 May 2010 20:37:08 -0700
Message-ID: <1272944228-30511-10-git-send-email-andmike@linux.vnet.ibm.com>
References: <1272944228-30511-1-git-send-email-andmike@linux.vnet.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
In-Reply-To: <1272944228-30511-1-git-send-email-andmike@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Jens Axobe <jens.axboe@oracle.com>, James Bottomley <James.Bottomley@suse.de>, dm-devel@redhat.com
List-Id: dm-devel.ids

Add a blk_request_aborted check to scsi_requeue_request. This allows for a
single check in a common requeue function to determine if a request has been
aborted.

Signed-off-by: Mike Anderson <andmike@linux.vnet.ibm.com>
Cc: James Bottomley <James.Bottomley@suse.de>
---
 drivers/scsi/scsi_lib.c |    8 ++++++++
 1 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 73182db..68e4bd7 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -121,11 +121,19 @@ static void scsi_requeue_request(struct request_queue *q, struct request *req,
 	unsigned long flags;
 
 	spin_lock_irqsave(q->queue_lock, flags);
+	if (blk_request_aborted(req)) {
+		spin_unlock_irqrestore(q->queue_lock, flags);
+		scsi_unprep_fn(q, req);
+		blk_end_request_all(req, -EIO);
+		goto out;
+	}
+
 	if (unprep)
 		scsi_unprep_request(req);
 	blk_requeue_request(q, req);
 	spin_unlock_irqrestore(q->queue_lock, flags);
 
+out:
 	scsi_run_queue(q);
 }
 
-- 
1.6.6.1


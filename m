From: Mike Anderson <andmike@linux.vnet.ibm.com>
Subject: [PATCH 5/9] scsi: Add a scsi_unprep_fn
Date: Mon,  3 May 2010 20:37:04 -0700
Message-ID: <1272944228-30511-6-git-send-email-andmike@linux.vnet.ibm.com>
References: <1272944228-30511-1-git-send-email-andmike@linux.vnet.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
In-Reply-To: <1272944228-30511-1-git-send-email-andmike@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Jens Axobe <jens.axboe@oracle.com>, James Bottomley <James.Bottomley@suse.de>, dm-devel@redhat.com
List-Id: dm-devel.ids

Add scsi_unprep_fn and set this function as the unprep_rq_fn for the scsi
queue. This will allow SCSI resources to be released if the block layer
unpreps a request.

Signed-off-by: Mike Anderson <andmike@linux.vnet.ibm.com>
Cc: James Bottomley <James.Bottomley@suse.de>
---
 drivers/scsi/scsi_lib.c |   12 ++++++++++++
 1 files changed, 12 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 1646fe7..1685d35 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -91,6 +91,17 @@ static void scsi_unprep_request(struct request *req)
 	scsi_put_command(cmd);
 }
 
+static void scsi_unprep_fn(struct request_queue *q, struct request *req)
+{
+	struct scsi_cmnd *cmd = req->special;
+
+	if (cmd) {
+		scsi_release_buffers(cmd);
+		scsi_unprep_request(req);
+	}
+}
+
+
 /**
  * __scsi_queue_insert - private queue insertion
  * @cmd: The SCSI command being requeued
@@ -1664,6 +1675,7 @@ struct request_queue *scsi_alloc_queue(struct scsi_device *sdev)
 		return NULL;
 
 	blk_queue_prep_rq(q, scsi_prep_fn);
+	blk_queue_unprep_rq(q, scsi_unprep_fn);
 	blk_queue_softirq_done(q, scsi_softirq_done);
 	blk_queue_rq_timed_out(q, scsi_times_out);
 	blk_queue_lld_busy(q, scsi_lld_busy);
-- 
1.6.6.1


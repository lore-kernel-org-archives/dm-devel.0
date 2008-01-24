From: Chandra Seetharaman <sekharan@us.ibm.com>
Subject: [PATCH 2/9] scsi_dh: change sd_prep_fn to call common code
Date: Wed, 23 Jan 2008 16:30:42 -0800
Message-ID: <20080124003042.18871.69006.sendpatchset@localhost.localdomain>
References: <20080124003010.18871.84095.sendpatchset@localhost.localdomain>
Return-path: <linux-scsi-owner@vger.kernel.org>
In-Reply-To: <20080124003010.18871.84095.sendpatchset@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
To: dm-devel@redhat.com, linux-scsi@vger.kernel.org
Cc: andmike@us.ibm.com, michaelc@cs.wisc.edu, Chandra Seetharaman <sekharan@us.ibm.com>, jens.axboe@oracle.com
List-Id: dm-devel.ids

Subject: scsi_dh: change sd_prep_fn to call common code

From: Mike Anderson <andmike@linux.vnet.ibm.com>

Have sd_prep_fn call common code if not REQ_TYPE_FS.

Signed-off-by: Mike Anderson <andmike@linux.vnet.ibm.com>
Signed-off-by: Chandra Seetharaman <sekharan@us.ibm.com>
---

 drivers/scsi/scsi_lib.c    |    1 	1 +	0 -	0 !
 drivers/scsi/sd.c          |    9 	2 +	7 -	0 !
 include/scsi/scsi_driver.h |    1 	1 +	0 -	0 !
 3 files changed, 4 insertions(+), 7 deletions(-)

Index: linux-2.6.24-rc8/drivers/scsi/scsi_lib.c
===================================================================
--- linux-2.6.24-rc8.orig/drivers/scsi/scsi_lib.c
+++ linux-2.6.24-rc8/drivers/scsi/scsi_lib.c
@@ -1334,6 +1334,7 @@ int scsi_prep_fn(struct request_queue *q
 		ret = scsi_setup_blk_pc_cmnd(sdev, req);
 	return scsi_prep_return(q, req, ret);
 }
+EXPORT_SYMBOL(scsi_prep_fn);
 
 /*
  * scsi_dev_queue_ready: if we can send requests to sdev, return 1 else
Index: linux-2.6.24-rc8/drivers/scsi/sd.c
===================================================================
--- linux-2.6.24-rc8.orig/drivers/scsi/sd.c
+++ linux-2.6.24-rc8/drivers/scsi/sd.c
@@ -354,13 +354,8 @@ static int sd_prep_fn(struct request_que
 	unsigned int timeout = sdp->timeout;
 	int ret;
 
-	if (rq->cmd_type == REQ_TYPE_BLOCK_PC) {
-		ret = scsi_setup_blk_pc_cmnd(sdp, rq);
-		goto out;
-	} else if (rq->cmd_type != REQ_TYPE_FS) {
-		ret = BLKPREP_KILL;
-		goto out;
-	}
+	if (rq->cmd_type != REQ_TYPE_FS)
+		return scsi_prep_fn(q, rq);
 	ret = scsi_setup_fs_cmnd(sdp, rq);
 	if (ret != BLKPREP_OK)
 		goto out;
Index: linux-2.6.24-rc8/include/scsi/scsi_driver.h
===================================================================
--- linux-2.6.24-rc8.orig/include/scsi/scsi_driver.h
+++ linux-2.6.24-rc8/include/scsi/scsi_driver.h
@@ -32,5 +32,6 @@ int scsi_setup_blk_pc_cmnd(struct scsi_d
 int scsi_setup_fs_cmnd(struct scsi_device *sdev, struct request *req);
 int scsi_prep_state_check(struct scsi_device *sdev, struct request *req);
 int scsi_prep_return(struct request_queue *q, struct request *req, int ret);
+int scsi_prep_fn(struct request_queue *q, struct request *req);
 
 #endif /* _SCSI_SCSI_DRIVER_H */

-- 

----------------------------------------------------------------------
    Chandra Seetharaman               | Be careful what you choose....
              - sekharan@us.ibm.com   |      .......you may get it.
----------------------------------------------------------------------

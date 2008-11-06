From: Chandra Seetharaman <sekharan@us.ibm.com>
Subject: [PATCH] Retry mode select in rdac device handler
Date: Wed, 05 Nov 2008 20:06:37 -0800
Message-ID: <1225944397.14830.1111.camel@chandra-ubuntu>
Reply-To: sekharan@us.ibm.com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Sender: linux-scsi-owner@vger.kernel.org
To: Linux SCSI Mailing list <linux-scsi@vger.kernel.org>
Cc: dm-devel <dm-devel@redhat.com>
List-Id: dm-devel.ids

When the mode select sent to the controller fails with the retryable
error, it is better to retry the mode_select from the hardware handler
itself, instead of propagating the failure to dm-multipath.

Signed-off-by: Chandra Seetharaman <sekharan@us.ibm.com>
---
Index: linux-2.6.28-rc3/drivers/scsi/device_handler/scsi_dh_rdac.c
===================================================================
--- linux-2.6.28-rc3.orig/drivers/scsi/device_handler/scsi_dh_rdac.c
+++ linux-2.6.28-rc3/drivers/scsi/device_handler/scsi_dh_rdac.c
@@ -24,6 +24,7 @@
 #include <scsi/scsi_dh.h>
 
 #define RDAC_NAME "rdac"
+#define RDAC_RETRY_COUNT 5
 
 /*
  * LSI mode page stuff
@@ -477,21 +478,27 @@ static int send_mode_select(struct scsi_
 {
 	struct request *rq;
 	struct request_queue *q = sdev->request_queue;
-	int err = SCSI_DH_RES_TEMP_UNAVAIL;
+	int err, retry_cnt = RDAC_RETRY_COUNT;
 
+retry:
+	err = SCSI_DH_RES_TEMP_UNAVAIL;
 	rq = rdac_failover_get(sdev, h);
 	if (!rq)
 		goto done;
 
-	sdev_printk(KERN_INFO, sdev, "queueing MODE_SELECT command.\n");
+	sdev_printk(KERN_INFO, sdev, "%s MODE_SELECT command.\n",
+		(retry_cnt == RDAC_RETRY_COUNT) ? "queueing" : "retrying");
 
 	err = blk_execute_rq(q, NULL, rq, 1);
-	if (err != SCSI_DH_OK)
+	blk_put_request(rq);
+	if (err != SCSI_DH_OK) {
 		err = mode_select_handle_sense(sdev, h->sense);
+		if (err == SCSI_DH_RETRY && retry_cnt--)
+			goto retry;
+	}
 	if (err == SCSI_DH_OK)
 		h->state = RDAC_STATE_ACTIVE;
 
-	blk_put_request(rq);
 done:
 	return err;
 }



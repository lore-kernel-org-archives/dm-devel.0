From: Chandra Seetharaman <sekharan@us.ibm.com>
Subject: [PATCH 3/4] scsi_dh: rdac handler: Make hp hardware handler async
Date: Tue, 29 Sep 2009 19:08:29 -0700
Message-ID: <20090930020829.11455.35613.sendpatchset@chandra-ubuntu>
References: <20090930020811.11455.59565.sendpatchset@chandra-ubuntu>
Return-path: <linux-scsi-owner@vger.kernel.org>
In-Reply-To: <20090930020811.11455.59565.sendpatchset@chandra-ubuntu>
Sender: linux-scsi-owner@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: dm-devel@redhat.com, babu.moger@lsi.com, michaelc@cs.wisc.edu, Benoit_Arthur@emc.com, Eddie.Williams@steeleye.com, berthiaume_wayne@emc.com, Chandra Seetharaman <sekharan@us.ibm.com>
List-Id: dm-devel.ids

Make the activate function asynchronous by using blk_execute_rq_nowait()

Signed-off-by: Chandra Seetharaman <sekharan@us.ibm.com>
---
 drivers/scsi/device_handler/scsi_dh_hp_sw.c |   87 +++++++++++++++++-----------
 1 file changed, 54 insertions(+), 33 deletions(-)

Index: linux-2.6.31/drivers/scsi/device_handler/scsi_dh_hp_sw.c
===================================================================
--- linux-2.6.31.orig/drivers/scsi/device_handler/scsi_dh_hp_sw.c
+++ linux-2.6.31/drivers/scsi/device_handler/scsi_dh_hp_sw.c
@@ -39,8 +39,14 @@ struct hp_sw_dh_data {
 	unsigned char sense[SCSI_SENSE_BUFFERSIZE];
 	int path_state;
 	int retries;
+	int retry_cnt;
+	struct scsi_device *sdev;
+	activate_complete	callback_fn;
+	void			*callback_data;
 };
 
+static int hp_sw_start_stop(struct hp_sw_dh_data *);
+
 static inline struct hp_sw_dh_data *get_hp_sw_data(struct scsi_device *sdev)
 {
 	struct scsi_dh_data *scsi_dh_data = sdev->scsi_dh_data;
@@ -191,19 +197,53 @@ static int start_done(struct scsi_device
 	return rc;
 }
 
+static void start_stop_endio(struct request *req, int error)
+{
+	struct hp_sw_dh_data *h = req->end_io_data;
+	unsigned err = SCSI_DH_OK;
+
+	if (error || host_byte(req->errors) != DID_OK ||
+			msg_byte(req->errors) != COMMAND_COMPLETE) {
+		sdev_printk(KERN_WARNING, h->sdev,
+			    "%s: sending start_stop_unit failed with %x\n",
+			    HP_SW_NAME, req->errors);
+		err = SCSI_DH_IO;
+		goto done;
+	}
+
+	if (req->sense_len > 0) {
+		err = start_done(h->sdev, h->sense);
+		if (err == SCSI_DH_RETRY) {
+			err = SCSI_DH_IO;
+			if (--h->retry_cnt) {
+				blk_put_request(req);
+				err = hp_sw_start_stop(h);
+				if (err == SCSI_DH_OK)
+					return;
+			}
+		}
+	}
+done:
+	blk_put_request(req);
+	if (h->callback_fn) {
+		h->callback_fn(h->callback_data, err);
+		h->callback_fn = h->callback_data = NULL;
+	}
+	return;
+
+}
+
 /*
  * hp_sw_start_stop - Send START STOP UNIT command
  * @sdev: sdev command should be sent to
  *
  * Sending START STOP UNIT activates the SP.
  */
-static int hp_sw_start_stop(struct scsi_device *sdev, struct hp_sw_dh_data *h)
+static int hp_sw_start_stop(struct hp_sw_dh_data *h)
 {
 	struct request *req;
-	int ret, retry;
 
-retry:
-	req = blk_get_request(sdev->request_queue, WRITE, GFP_NOIO);
+	req = blk_get_request(h->sdev->request_queue, WRITE, GFP_ATOMIC);
 	if (!req)
 		return SCSI_DH_RES_TEMP_UNAVAIL;
 
@@ -217,32 +257,10 @@ retry:
 	req->sense = h->sense;
 	memset(req->sense, 0, SCSI_SENSE_BUFFERSIZE);
 	req->sense_len = 0;
-	retry = h->retries;
+	req->end_io_data = h;
 
-	ret = blk_execute_rq(req->q, NULL, req, 1);
-	if (ret == -EIO) {
-		if (req->sense_len > 0) {
-			ret = start_done(sdev, h->sense);
-		} else {
-			sdev_printk(KERN_WARNING, sdev,
-				    "%s: sending start_stop_unit failed with %x\n",
-				    HP_SW_NAME, req->errors);
-			ret = SCSI_DH_IO;
-		}
-	} else
-		ret = SCSI_DH_OK;
-
-	if (ret == SCSI_DH_RETRY) {
-		if (--retry) {
-			blk_put_request(req);
-			goto retry;
-		}
-		ret = SCSI_DH_IO;
-	}
-
-	blk_put_request(req);
-
-	return ret;
+	blk_execute_rq_nowait(req->q, NULL, req, 1, start_stop_endio);
+	return SCSI_DH_OK;
 }
 
 static int hp_sw_prep_fn(struct scsi_device *sdev, struct request *req)
@@ -276,11 +294,13 @@ static int hp_sw_activate(struct scsi_de
 	ret = hp_sw_tur(sdev, h);
 
 	if (ret == SCSI_DH_OK && h->path_state == HP_SW_PATH_PASSIVE) {
-		ret = hp_sw_start_stop(sdev, h);
+		h->retry_cnt = h->retries;
+		h->callback_fn = fn;
+		h->callback_data = data;
+		ret = hp_sw_start_stop(h);
 		if (ret == SCSI_DH_OK)
-			sdev_printk(KERN_INFO, sdev,
-				    "%s: activated path\n",
-				    HP_SW_NAME);
+			return 0;
+		h->callback_fn = h->callback_data = NULL;
 	}
 
 	if (fn)
@@ -328,6 +348,7 @@ static int hp_sw_bus_attach(struct scsi_
 	h = (struct hp_sw_dh_data *) scsi_dh_data->buf;
 	h->path_state = HP_SW_PATH_UNINITIALIZED;
 	h->retries = HP_SW_RETRIES;
+	h->sdev = sdev;
 
 	ret = hp_sw_tur(sdev, h);
 	if (ret != SCSI_DH_OK || h->path_state == HP_SW_PATH_UNINITIALIZED)

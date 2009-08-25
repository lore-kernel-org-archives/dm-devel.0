From: Charlie Brady <charlieb-dm-devel@budge.apana.org.au>
Subject: Re: Sun StorageTek 2530 and dm?
Date: Tue, 25 Aug 2009 15:21:58 -0400 (EDT)
Message-ID: <Pine.LNX.4.64.0908251421010.21130@e-smith.charlieb.ott.istop.com>
References: <20090823210536.4730636d@nb-jsosic>
	<20090823213448.154d6cff@nb-jsosic>
	<Pine.LNX.4.64.0908241128370.27199@e-smith.charlieb.ott.istop.com>
	<20090824202915.27815959@pc-jsosic.srce.hr>
	<1251139716.24406.4.camel@chandra-ubuntu>
	<20090824205933.4b4c8456@pc-jsosic.srce.hr>
	<1251145497.24406.18.camel@chandra-ubuntu>
	<20090824223627.6e1a918c@pc-jsosic.srce.hr>
	<1251147451.24406.28.camel@chandra-ubuntu>
	<20090824231416.598ecc11@pc-jsosic.srce.hr>
	<1251150116.24406.37.camel@chandra-ubuntu>
	<20090824235347.4b8cbd8a@pc-jsosic.srce.hr>
	<1251155242.24406.57.camel@chandra-ubuntu>
	<20090825011340.423e3cf6@pc-jsosic.srce.hr>
	<1251159536.2166.3.camel@chandra-ubuntu>
	<Pine.LNX.4.64.0908242335310.1267@e-smith.charlieb.ott.istop.com>
	<1251223635.2166.7.camel@chandra-ubuntu>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1251223635.2166.7.camel@chandra-ubuntu>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: sekharan@linux.vnet.ibm.com, device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids


On Tue, 25 Aug 2009, Chandra Seetharaman wrote:

> Hopefully not :)... it has been fixed for a while.
>
> Jacov, Can you send me the scsi_dh_rdac.c file. I want to make sure you
> are running the latest code.

Jacov told us that he was running 2.6.18-128.4.1.el5xen, which certainly 
isn't the latest code. It's the latest Red Hat RHEL5 code (or rather, was 
until yesterday).

Below are the diffs from linus's git repo. I'd guess that there would be 
minor changes needed before the current code would compile and run with 
the RHEL5 kernel.

Chandra, can you spot any one or two patches that would be most important 
to back-port to RHEL5?

--- kernel-2.6.18/linux-2.6.18.i386/drivers/scsi/device_handler/scsi_dh_rdac.c	2009-08-25 15:00:38.745457000 -0400
+++ /home/speech/bradyc/scsi_dh_rdac.c	2009-08-25 15:10:42.922477000 
-0400
@@ -19,14 +19,12 @@
   * Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
   *
   */
-#include <linux/list.h>
  #include <scsi/scsi.h>
  #include <scsi/scsi_eh.h>
-#include <scsi/scsi_cmnd.h>
  #include <scsi/scsi_dh.h>
-#include "../scsi_priv.h"

  #define RDAC_NAME "rdac"
+#define RDAC_RETRY_COUNT 5

  /*
   * LSI mode page stuff
@@ -202,7 +200,7 @@

  static inline struct rdac_dh_data *get_rdac_data(struct scsi_device *sdev)
  {
-	struct scsi_dh_data *scsi_dh_data = retrieve_scsi_dh_data(sdev);
+	struct scsi_dh_data *scsi_dh_data = sdev->scsi_dh_data;
  	BUG_ON(scsi_dh_data == NULL);
  	return ((struct rdac_dh_data *) scsi_dh_data->buf);
  }
@@ -228,10 +226,9 @@
  		return NULL;
  	}

-	memset(rq->cmd, 0, BLK_MAX_CDB);
-
-	rq->flags |= REQ_FAILFAST_DEV | REQ_FAILFAST_TRANSPORT |
-			REQ_FAILFAST_DRIVER | REQ_NOMERGE | REQ_BLOCK_PC;
+	rq->cmd_type = REQ_TYPE_BLOCK_PC;
+	rq->cmd_flags |= REQ_FAILFAST_DEV | REQ_FAILFAST_TRANSPORT |
+			 REQ_FAILFAST_DRIVER;
  	rq->retries = RDAC_RETRIES;
  	rq->timeout = RDAC_TIMEOUT;

@@ -390,6 +387,7 @@
  	struct c9_inquiry *inqp;

  	h->lun_state = RDAC_LUN_UNOWNED;
+	h->state = RDAC_STATE_ACTIVE;
  	err = submit_inquiry(sdev, 0xC9, sizeof(struct c9_inquiry), h);
  	if (err == SCSI_DH_OK) {
  		inqp = &h->inq.c9;
@@ -407,6 +405,7 @@

  	if (h->lun_state == RDAC_LUN_UNOWNED)
  		h->state = RDAC_STATE_PASSIVE;
+
  	return err;
  }

@@ -450,28 +449,40 @@
  				    unsigned char *sensebuf)
  {
  	struct scsi_sense_hdr sense_hdr;
-	int sense, err = SCSI_DH_IO, ret;
+	int err = SCSI_DH_IO, ret;

  	ret = scsi_normalize_sense(sensebuf, SCSI_SENSE_BUFFERSIZE, &sense_hdr);
  	if (!ret)
  		goto done;

  	err = SCSI_DH_OK;
-	sense = (sense_hdr.sense_key << 16) | (sense_hdr.asc << 8) |
-			sense_hdr.ascq;
-	/* If it is retryable failure, submit the c9 inquiry again */
-	if (sense == 0x59136 || sense == 0x68b02 || sense == 0xb8b02 ||
-			    sense == 0x62900) {
-		/* 0x59136    - Command lock contention
-		 * 0x[6b]8b02 - Quiesense in progress or achieved
-		 * 0x62900    - Power On, Reset, or Bus Device Reset
-		 */
+
+	switch (sense_hdr.sense_key) {
+	case NO_SENSE:
+	case ABORTED_COMMAND:
+	case UNIT_ATTENTION:
  		err = SCSI_DH_RETRY;
+		break;
+	case NOT_READY:
+		if (sense_hdr.asc == 0x04 && sense_hdr.ascq == 0x01)
+			/* LUN Not Ready and is in the Process of Becoming
+			 * Ready
+			 */
+			err = SCSI_DH_RETRY;
+		break;
+	case ILLEGAL_REQUEST:
+		if (sense_hdr.asc == 0x91 && sense_hdr.ascq == 0x36)
+			/*
+			 * Command Lock contention
+			 */
+			err = SCSI_DH_RETRY;
+		break;
+	default:
+		sdev_printk(KERN_INFO, sdev,
+			    "MODE_SELECT failed with sense %02x/%02x/%02x.\n",
+			    sense_hdr.sense_key, sense_hdr.asc, sense_hdr.ascq);
  	}

-	if (sense)
-		sdev_printk(KERN_INFO, sdev,
-			"MODE_SELECT failed with sense 0x%x.\n", sense);
  done:
  	return err;
  }
@@ -480,21 +491,27 @@
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
@@ -532,7 +549,7 @@

  	if (h->state != RDAC_STATE_ACTIVE) {
  		ret = BLKPREP_KILL;
-		req->flags |= REQ_QUIET;
+		req->cmd_flags |= REQ_QUIET;
  	}
  	return ret;

@@ -544,19 +561,31 @@
  	struct rdac_dh_data *h = get_rdac_data(sdev);
  	switch (sense_hdr->sense_key) {
  	case NOT_READY:
+		if (sense_hdr->asc == 0x04 && sense_hdr->ascq == 0x01)
+			/* LUN Not Ready - Logical Unit Not Ready and is in
+			* the process of becoming ready
+			* Just retry.
+			*/
+			return ADD_TO_MLQUEUE;
  		if (sense_hdr->asc == 0x04 && sense_hdr->ascq == 0x81)
  			/* LUN Not Ready - Storage firmware incompatible
  			 * Manual code synchonisation required.
  			 *
  			 * Nothing we can do here. Try to bypass the path.
  			 */
-			return SCSI_MLQUEUE_DIS_FINISH;
+			return SUCCESS;
  		if (sense_hdr->asc == 0x04 && sense_hdr->ascq == 0xA1)
  			/* LUN Not Ready - Quiescense in progress
  			 *
  			 * Just retry and wait.
  			 */
-			return SCSI_MLQUEUE_IMM_RETRY;
+			return ADD_TO_MLQUEUE;
+		if (sense_hdr->asc == 0xA1  && sense_hdr->ascq == 0x02)
+			/* LUN Not Ready - Quiescense in progress
+			 * or has been achieved
+			 * Just retry.
+			 */
+			return ADD_TO_MLQUEUE;
  		break;
  	case ILLEGAL_REQUEST:
  		if (sense_hdr->asc == 0x94 && sense_hdr->ascq == 0x01) {
@@ -565,7 +594,7 @@
  			 * Fail the path, so that the other path be used.
  			 */
  			h->state = RDAC_STATE_PASSIVE;
-			return SCSI_MLQUEUE_DIS_FINISH;
+			return SUCCESS;
  		}
  		break;
  	case UNIT_ATTENTION:
@@ -573,14 +602,19 @@
  			/*
  			 * Power On, Reset, or Bus Device Reset, just retry.
  			 */
-			return SCSI_MLQUEUE_IMM_RETRY;
+			return ADD_TO_MLQUEUE;
+		if (sense_hdr->asc == 0x8b && sense_hdr->ascq == 0x02)
+			/*
+			 * Quiescence in progress , just retry.
+			 */
+			return ADD_TO_MLQUEUE;
  		break;
  	}
  	/* success just means we do not care what scsi-ml does */
-	return 0;
+	return SCSI_RETURN_NOT_HANDLED;
  }

-const struct scsi_dh_devlist rdac_dev_list[] = {
+static const struct scsi_dh_devlist rdac_dev_list[] = {
  	{"IBM", "1722"},
  	{"IBM", "1724"},
  	{"IBM", "1726"},
@@ -595,6 +629,10 @@
  	{"STK", "OPENstorage D280"},
  	{"SUN", "CSM200_R"},
  	{"SUN", "LCSM100_F"},
+	{"DELL", "MD3000"},
+	{"DELL", "MD3000i"},
+	{"LSI", "INF-01-00"},
+	{"ENGENIO", "INF-01-00"},
  	{NULL, NULL},
  };

@@ -612,9 +650,6 @@
  	.activate = rdac_activate,
  };

-/*
- * TODO: need some interface so we can set trespass values
- */
  static int rdac_bus_attach(struct scsi_device *sdev)
  {
  	struct scsi_dh_data *scsi_dh_data;
@@ -623,10 +658,11 @@
  	int err;

  	scsi_dh_data = kzalloc(sizeof(struct scsi_device_handler *)
-				+ sizeof(*h) , GFP_KERNEL);
+			       + sizeof(*h) , GFP_KERNEL);
  	if (!scsi_dh_data) {
-		sdev_printk(KERN_ERR, sdev, "%s: Attach failed\n", RDAC_NAME);
-		return -ENOMEM;
+		sdev_printk(KERN_ERR, sdev, "%s: Attach failed\n",
+			    RDAC_NAME);
+		return 0;
  	}

  	scsi_dh_data->scsi_dh = &rdac_dh;
@@ -646,28 +682,31 @@
  		goto failed;

  	spin_lock_irqsave(sdev->request_queue->queue_lock, flags);
-	store_scsi_dh_data(sdev, scsi_dh_data);
+	sdev->scsi_dh_data = scsi_dh_data;
  	spin_unlock_irqrestore(sdev->request_queue->queue_lock, flags);

-	sdev_printk(KERN_NOTICE, sdev, "%s: LUN %d (%s)\n",
-			RDAC_NAME, h->lun, lun_state[(int)h->lun_state]);
+	sdev_printk(KERN_NOTICE, sdev,
+		    "%s: LUN %d (%s)\n",
+		    RDAC_NAME, h->lun, lun_state[(int)h->lun_state]);
+
  	return 0;

  failed:
  	kfree(scsi_dh_data);
-	sdev_printk(KERN_ERR, sdev, "%s: not attached\n", RDAC_NAME);
+	sdev_printk(KERN_ERR, sdev, "%s: not attached\n",
+		    RDAC_NAME);
  	return -EINVAL;
  }

-static void rdac_bus_detach(struct scsi_device *sdev)
+static void rdac_bus_detach( struct scsi_device *sdev )
  {
  	struct scsi_dh_data *scsi_dh_data;
  	struct rdac_dh_data *h;
  	unsigned long flags;

  	spin_lock_irqsave(sdev->request_queue->queue_lock, flags);
-	scsi_dh_data = retrieve_scsi_dh_data(sdev);
-	store_scsi_dh_data(sdev, NULL);
+	scsi_dh_data = sdev->scsi_dh_data;
+	sdev->scsi_dh_data = NULL;
  	spin_unlock_irqrestore(sdev->request_queue->queue_lock, flags);

  	h = (struct rdac_dh_data *) scsi_dh_data->buf;
@@ -675,9 +714,11 @@
  		kref_put(&h->ctlr->kref, release_controller);
  	kfree(scsi_dh_data);
  	module_put(THIS_MODULE);
-	sdev_printk(KERN_NOTICE, sdev, "%s Dettached\n", RDAC_NAME);
+	sdev_printk(KERN_NOTICE, sdev, "%s: Detached\n", RDAC_NAME);
  }

+
+
  static int __init rdac_init(void)
  {
  	int r;

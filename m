Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D0FF9C433F5
	for <dm-devel@archiver.kernel.org>; Thu, 24 Mar 2022 15:34:57 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-511-ZUegDGRfNCOw3DSYEYo0kw-1; Thu, 24 Mar 2022 11:34:48 -0400
X-MC-Unique: ZUegDGRfNCOw3DSYEYo0kw-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id BB87C3C02B80;
	Thu, 24 Mar 2022 15:34:46 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id A7A4A492D46;
	Thu, 24 Mar 2022 15:34:46 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id C2C20194036E;
	Thu, 24 Mar 2022 15:34:45 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com
 [10.11.54.2])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 218641947BBC
 for <dm-devel@listman.corp.redhat.com>; Tue, 22 Mar 2022 11:06:17 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id E466A40D2823; Tue, 22 Mar 2022 11:06:16 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id DFB2240D2822
 for <dm-devel@redhat.com>; Tue, 22 Mar 2022 11:06:16 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 961DB185A794
 for <dm-devel@redhat.com>; Tue, 22 Mar 2022 11:06:16 +0000 (UTC)
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com
 [185.176.79.56]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-407-VjaoODyxPJeO0W_188yCjw-1; Tue, 22 Mar 2022 07:06:15 -0400
X-MC-Unique: VjaoODyxPJeO0W_188yCjw-1
Received: from fraeml701-chm.china.huawei.com (unknown [172.18.147.207])
 by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4KN7R337J0z6800j;
 Tue, 22 Mar 2022 18:44:47 +0800 (CST)
Received: from lhreml724-chm.china.huawei.com (10.201.108.75) by
 fraeml701-chm.china.huawei.com (10.206.15.50) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2375.24; Tue, 22 Mar 2022 11:45:51 +0100
Received: from localhost.localdomain (10.69.192.58) by
 lhreml724-chm.china.huawei.com (10.201.108.75) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Tue, 22 Mar 2022 10:45:47 +0000
From: John Garry <john.garry@huawei.com>
To: <axboe@kernel.dk>, <damien.lemoal@opensource.wdc.com>,
 <bvanassche@acm.org>, <jejb@linux.ibm.com>, <martin.petersen@oracle.com>,
 <hch@lst.de>, <ming.lei@redhat.com>, <hare@suse.de>
Date: Tue, 22 Mar 2022 18:39:37 +0800
Message-ID: <1647945585-197349-4-git-send-email-john.garry@huawei.com>
In-Reply-To: <1647945585-197349-1-git-send-email-john.garry@huawei.com>
References: <1647945585-197349-1-git-send-email-john.garry@huawei.com>
MIME-Version: 1.0
X-Originating-IP: [10.69.192.58]
X-ClientProxiedBy: dggems702-chm.china.huawei.com (10.3.19.179) To
 lhreml724-chm.china.huawei.com (10.201.108.75)
X-CFilter-Loop: Reflected
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.2
X-Mailman-Approved-At: Thu, 24 Mar 2022 15:34:42 +0000
Subject: [dm-devel] [PATCH 03/11] libata: Send internal commands through the
 block layer
X-BeenThere: dm-devel@redhat.com
X-Mailman-Version: 2.1.29
Precedence: list
List-Id: device-mapper development <dm-devel.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/dm-devel>,
 <mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <http://listman.redhat.com/archives/dm-devel/>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/dm-devel>,
 <mailto:dm-devel-request@redhat.com?subject=subscribe>
Cc: linux-scsi@vger.kernel.org, chenxiang66@hisilicon.com,
 John Garry <john.garry@huawei.com>, linux-kernel@vger.kernel.org,
 linux-block@vger.kernel.org, linux-ide@vger.kernel.org, dm-devel@redhat.com,
 beanhuo@micron.com
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.9
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

When SCSI HBA device drivers are required to process an ATA internal
command they still need a tag for the IO. This often requires the driver
to set aside a set of tags for these sorts of IOs and manage the tags
themselves.

If we associate a SCSI command (and request) with an ATA internal command
then the tag is already provided, so introduce the change to send ATA
internal commands through the block layer with a set of custom blk-mq ops.

note: I think that the timeout handling needs to be fixed up.

Signed-off-by: John Garry <john.garry@huawei.com>
---
 drivers/ata/libata-core.c | 121 ++++++++++++++++++++++++++++----------
 1 file changed, 89 insertions(+), 32 deletions(-)

diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
index 67f88027680a..9db0428d0511 100644
--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -1438,6 +1438,59 @@ static void ata_qc_complete_internal(struct ata_queued_cmd *qc)
 	complete(waiting);
 }
 
+struct ata_internal_sg_data {
+	struct completion wait;
+
+	unsigned int preempted_tag;
+	u32 preempted_sactive;
+	u64 preempted_qc_active;
+	int preempted_nr_active_links;
+};
+
+static blk_status_t ata_exec_internal_sg_queue_rq(struct blk_mq_hw_ctx *hctx,
+		const struct blk_mq_queue_data *bd)
+{
+	struct request *rq = bd->rq;
+	struct scsi_cmnd *scmd = blk_mq_rq_to_pdu(rq);
+	struct ata_queued_cmd *qc = (struct ata_queued_cmd *)scmd->host_scribble;
+	struct ata_internal_sg_data *data;
+	struct ata_device *dev = qc->dev;
+	struct ata_port *ap = qc->ap;
+	struct ata_link *link = dev->link;
+	unsigned long flags;
+
+	data = container_of(qc->private_data, struct ata_internal_sg_data, wait);
+
+	blk_mq_start_request(bd->rq);
+
+	spin_lock_irqsave(ap->lock, flags);
+
+	/* no internal command while frozen */
+	if (ap->pflags & ATA_PFLAG_FROZEN) {
+		spin_unlock_irqrestore(ap->lock, flags);
+		return BLK_STS_TARGET;
+	}
+
+	data->preempted_tag = link->active_tag;
+	data->preempted_sactive = link->sactive;
+	data->preempted_qc_active = ap->qc_active;
+	data->preempted_nr_active_links = ap->nr_active_links;
+	link->active_tag = ATA_TAG_POISON;
+	link->sactive = 0;
+	ap->qc_active = 0;
+	ap->nr_active_links = 0;
+
+	ata_qc_issue(qc);
+
+	spin_unlock_irqrestore(ap->lock, flags);
+
+	return BLK_STS_OK;
+}
+
+static const struct blk_mq_ops ata_exec_internal_sg_mq_ops = {
+	.queue_rq	= ata_exec_internal_sg_queue_rq,
+};
+
 /**
  *	ata_exec_internal_sg - execute libata internal command
  *	@dev: Device to which the command is sent
@@ -1467,45 +1520,46 @@ unsigned ata_exec_internal_sg(struct ata_device *dev,
 {
 	struct ata_link *link = dev->link;
 	struct ata_port *ap = link->ap;
+	struct Scsi_Host *scsi_host = ap->scsi_host;
+	struct request_queue *request_queue;
 	u8 command = tf->command;
-	int auto_timeout = 0;
 	struct ata_queued_cmd *qc;
-	unsigned int preempted_tag;
-	u32 preempted_sactive;
-	u64 preempted_qc_active;
-	int preempted_nr_active_links;
-	DECLARE_COMPLETION_ONSTACK(wait);
-	unsigned long flags;
+	struct scsi_cmnd *scmd;
 	unsigned int err_mask;
-	int rc;
+	unsigned long flags;
+	struct request *rq;
+	int rc, auto_timeout = 0;
+	struct ata_internal_sg_data data = {
+		.wait = COMPLETION_INITIALIZER_ONSTACK(data.wait),
+	};
+	unsigned int op;
 
-	spin_lock_irqsave(ap->lock, flags);
+	op = (dma_dir == DMA_TO_DEVICE) ? REQ_OP_DRV_OUT : REQ_OP_DRV_IN;
 
-	/* no internal command while frozen */
-	if (ap->pflags & ATA_PFLAG_FROZEN) {
-		spin_unlock_irqrestore(ap->lock, flags);
-		return AC_ERR_SYSTEM;
+	request_queue = blk_mq_init_queue_ops(&scsi_host->tag_set,
+					      &ata_exec_internal_sg_mq_ops);
+	if (!request_queue)
+		return AC_ERR_OTHER;
+
+	rq = scsi_alloc_request(request_queue, op, 0);
+	if (IS_ERR(rq)) {
+		err_mask = AC_ERR_OTHER;
+		goto out;
 	}
 
+	scmd = blk_mq_rq_to_pdu(rq);
+	scmd->submitter = SUBMITTED_BY_SCSI_CUSTOM_OPS;
+
 	/* initialize internal qc */
 	qc = __ata_qc_from_tag(ap, ATA_TAG_INTERNAL);
 
 	qc->tag = ATA_TAG_INTERNAL;
 	qc->hw_tag = 0;
-	qc->scsicmd = NULL;
+	qc->scsicmd = scmd;
 	qc->ap = ap;
 	qc->dev = dev;
 	ata_qc_reinit(qc);
 
-	preempted_tag = link->active_tag;
-	preempted_sactive = link->sactive;
-	preempted_qc_active = ap->qc_active;
-	preempted_nr_active_links = ap->nr_active_links;
-	link->active_tag = ATA_TAG_POISON;
-	link->sactive = 0;
-	ap->qc_active = 0;
-	ap->nr_active_links = 0;
-
 	/* prepare & issue qc */
 	qc->tf = *tf;
 	if (cdb)
@@ -1529,12 +1583,11 @@ unsigned ata_exec_internal_sg(struct ata_device *dev,
 		qc->nbytes = buflen;
 	}
 
-	qc->private_data = &wait;
+	qc->private_data = &data.wait;
 	qc->complete_fn = ata_qc_complete_internal;
 
-	ata_qc_issue(qc);
-
-	spin_unlock_irqrestore(ap->lock, flags);
+	scmd->host_scribble = (unsigned char *)qc;
+	blk_execute_rq_nowait(rq, true, NULL);
 
 	if (!timeout) {
 		if (ata_probe_timeout)
@@ -1548,7 +1601,7 @@ unsigned ata_exec_internal_sg(struct ata_device *dev,
 	if (ap->ops->error_handler)
 		ata_eh_release(ap);
 
-	rc = wait_for_completion_timeout(&wait, msecs_to_jiffies(timeout));
+	rc = wait_for_completion_timeout(&data.wait, msecs_to_jiffies(timeout));
 
 	if (ap->ops->error_handler)
 		ata_eh_acquire(ap);
@@ -1603,16 +1656,20 @@ unsigned ata_exec_internal_sg(struct ata_device *dev,
 	err_mask = qc->err_mask;
 
 	ata_qc_free(qc);
-	link->active_tag = preempted_tag;
-	link->sactive = preempted_sactive;
-	ap->qc_active = preempted_qc_active;
-	ap->nr_active_links = preempted_nr_active_links;
+	link->active_tag = data.preempted_tag;
+	link->sactive = data.preempted_sactive;
+	ap->qc_active = data.preempted_qc_active;
+	ap->nr_active_links = data.preempted_nr_active_links;
 
 	spin_unlock_irqrestore(ap->lock, flags);
 
 	if ((err_mask & AC_ERR_TIMEOUT) && auto_timeout)
 		ata_internal_cmd_timed_out(dev, command);
 
+	__blk_mq_end_request(rq, BLK_STS_OK);
+
+out:
+	blk_cleanup_queue(request_queue);
 	return err_mask;
 }
 
-- 
2.26.2

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel


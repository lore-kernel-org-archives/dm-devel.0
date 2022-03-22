Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7B46DC433F5
	for <dm-devel@archiver.kernel.org>; Thu, 24 Mar 2022 15:35:08 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-59-dZGlvnMdOkOPkQ4nEvN99A-1; Thu, 24 Mar 2022 11:35:05 -0400
X-MC-Unique: dZGlvnMdOkOPkQ4nEvN99A-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 35378899EC2;
	Thu, 24 Mar 2022 15:34:56 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 21CD11454557;
	Thu, 24 Mar 2022 15:34:56 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id A60FC194034E;
	Thu, 24 Mar 2022 15:34:55 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com
 [10.11.54.10])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 519101947BBC
 for <dm-devel@listman.corp.redhat.com>; Tue, 22 Mar 2022 11:06:05 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 0419A401E7E; Tue, 22 Mar 2022 11:06:05 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id F4110401E7A
 for <dm-devel@redhat.com>; Tue, 22 Mar 2022 11:06:04 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id DA1C9185A7A4
 for <dm-devel@redhat.com>; Tue, 22 Mar 2022 11:06:04 +0000 (UTC)
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com
 [185.176.79.56]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-569-kvcUvgakOQWtpCzrhkKZuQ-1; Tue, 22 Mar 2022 07:06:03 -0400
X-MC-Unique: kvcUvgakOQWtpCzrhkKZuQ-1
Received: from fraeml741-chm.china.huawei.com (unknown [172.18.147.207])
 by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4KN7Qj1513z67Qtq;
 Tue, 22 Mar 2022 18:44:29 +0800 (CST)
Received: from lhreml724-chm.china.huawei.com (10.201.108.75) by
 fraeml741-chm.china.huawei.com (10.206.15.222) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Tue, 22 Mar 2022 11:46:10 +0100
Received: from localhost.localdomain (10.69.192.58) by
 lhreml724-chm.china.huawei.com (10.201.108.75) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Tue, 22 Mar 2022 10:46:06 +0000
From: John Garry <john.garry@huawei.com>
To: <axboe@kernel.dk>, <damien.lemoal@opensource.wdc.com>,
 <bvanassche@acm.org>, <jejb@linux.ibm.com>, <martin.petersen@oracle.com>,
 <hch@lst.de>, <ming.lei@redhat.com>, <hare@suse.de>
Date: Tue, 22 Mar 2022 18:39:42 +0800
Message-ID: <1647945585-197349-9-git-send-email-john.garry@huawei.com>
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
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.10
X-Mailman-Approved-At: Thu, 24 Mar 2022 15:34:41 +0000
Subject: [dm-devel] [PATCH 08/11] scsi: libsas: Change ATA support to deal
 with each qc having a SCSI command
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
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.7
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Now that each ATA qc has a SCSI command associated, change the qc <->
scsi_cmnd <-> sas_task referencing to deal with this. Essentially
task->uldd_task = scmd always. We need to do this for sas_execute_tmf(),
as those ATA commands have no qc.

TODO: rename ASSIGN_SAS_TASK and TO_SAS_TASK to be more appropriate.

Signed-off-by: John Garry <john.garry@huawei.com>
---
 drivers/scsi/hisi_sas/hisi_sas_main.c  | 11 +----------
 drivers/scsi/hisi_sas/hisi_sas_v2_hw.c |  3 ++-
 drivers/scsi/hisi_sas/hisi_sas_v3_hw.c |  3 ++-
 drivers/scsi/libsas/sas_ata.c          | 11 ++++++-----
 4 files changed, 11 insertions(+), 17 deletions(-)

diff --git a/drivers/scsi/hisi_sas/hisi_sas_main.c b/drivers/scsi/hisi_sas/hisi_sas_main.c
index 461ef8a76c4c..e438c68e249a 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_main.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_main.c
@@ -520,16 +520,7 @@ static int hisi_sas_queue_command(struct sas_task *task, gfp_t gfp_flags)
 				return -ECOMM;
 		}
 
-		if (task->uldd_task) {
-			struct ata_queued_cmd *qc;
-
-			if (dev_is_sata(device)) {
-				qc = task->uldd_task;
-				scmd = qc->scsicmd;
-			} else {
-				scmd = task->uldd_task;
-			}
-		}
+		scmd = task->uldd_task;
 
 		if (scmd) {
 			unsigned int dq_index;
diff --git a/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c b/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c
index 455d49299ddf..d1f2c8fbdc79 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c
@@ -2538,7 +2538,8 @@ static void prep_ata_v2_hw(struct hisi_hba *hisi_hba,
 
 	/* dw2 */
 	if (task->ata_task.use_ncq) {
-		struct ata_queued_cmd *qc = task->uldd_task;
+		struct scsi_cmnd *scmd = task->uldd_task;
+		struct ata_queued_cmd *qc = (struct ata_queued_cmd *)scmd->host_scribble;
 
 		hdr_tag = qc->tag;
 		task->ata_task.fis.sector_count |= (u8) (hdr_tag << 3);
diff --git a/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c b/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
index 79f87d7c3e68..e3e02a24ee76 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
@@ -1421,7 +1421,8 @@ static void prep_ata_v3_hw(struct hisi_hba *hisi_hba,
 
 	/* dw2 */
 	if (task->ata_task.use_ncq) {
-		struct ata_queued_cmd *qc = task->uldd_task;
+		struct scsi_cmnd *scmd = task->uldd_task;
+		struct ata_queued_cmd *qc = (struct ata_queued_cmd *)scmd->host_scribble;
 
 		hdr_tag = qc->tag;
 		task->ata_task.fis.sector_count |= (u8) (hdr_tag << 3);
diff --git a/drivers/scsi/libsas/sas_ata.c b/drivers/scsi/libsas/sas_ata.c
index d34c82e24d9a..4d2b8fb31f30 100644
--- a/drivers/scsi/libsas/sas_ata.c
+++ b/drivers/scsi/libsas/sas_ata.c
@@ -72,7 +72,8 @@ static enum ata_completion_errors sas_to_ata_err(struct task_status_struct *ts)
 
 static void sas_ata_task_done(struct sas_task *task)
 {
-	struct ata_queued_cmd *qc = task->uldd_task;
+	struct scsi_cmnd *scmd = task->uldd_task;
+	struct ata_queued_cmd *qc = TO_SAS_TASK(scmd);
 	struct domain_device *dev = task->dev;
 	struct task_status_struct *stat = &task->task_status;
 	struct ata_task_resp *resp = (struct ata_task_resp *)stat->buf;
@@ -184,7 +185,7 @@ static unsigned int sas_ata_qc_issue(struct ata_queued_cmd *qc)
 		qc->tf.nsect = 0;
 
 	ata_tf_to_fis(&qc->tf, qc->dev->link->pmp, 1, (u8 *)&task->ata_task.fis);
-	task->uldd_task = qc;
+	task->uldd_task = qc->scsicmd;
 	if (ata_is_atapi(qc->tf.protocol)) {
 		memcpy(task->ata_task.atapi_packet, qc->cdb, qc->dev->cdb_len);
 		task->total_xfer_len = qc->nbytes;
@@ -207,8 +208,7 @@ static unsigned int sas_ata_qc_issue(struct ata_queued_cmd *qc)
 	task->ata_task.use_ncq = ata_is_ncq(qc->tf.protocol);
 	task->ata_task.dma_xfer = ata_is_dma(qc->tf.protocol);
 
-	if (qc->scsicmd)
-		ASSIGN_SAS_TASK(qc->scsicmd, task);
+	ASSIGN_SAS_TASK(qc->scsicmd, qc);
 
 	ret = i->dft->lldd_execute_task(task, GFP_ATOMIC);
 	if (ret) {
@@ -583,7 +583,8 @@ int sas_ata_init(struct domain_device *found_dev)
 
 void sas_ata_task_abort(struct sas_task *task)
 {
-	struct ata_queued_cmd *qc = task->uldd_task;
+	struct scsi_cmnd *scmd = task->uldd_task;
+	struct ata_queued_cmd *qc = TO_SAS_TASK(scmd);
 	struct completion *waiting;
 
 	/* Bounce SCSI-initiated commands to the SCSI EH */
-- 
2.26.2

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel


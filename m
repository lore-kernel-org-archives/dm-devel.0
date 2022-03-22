Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 65B65C433EF
	for <dm-devel@archiver.kernel.org>; Thu, 24 Mar 2022 15:34:52 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-668-oza2uQXVODqiWBEmfYYm_A-1; Thu, 24 Mar 2022 11:34:47 -0400
X-MC-Unique: oza2uQXVODqiWBEmfYYm_A-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 278F7899EC2;
	Thu, 24 Mar 2022 15:34:45 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 02FEA401475;
	Thu, 24 Mar 2022 15:34:45 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 7F599194034F;
	Thu, 24 Mar 2022 15:34:44 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com
 [10.11.54.8])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 5641A1940340
 for <dm-devel@listman.corp.redhat.com>; Tue, 22 Mar 2022 11:06:05 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id DE3CAC27D86; Tue, 22 Mar 2022 11:06:04 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id D9F22C26E9A
 for <dm-devel@redhat.com>; Tue, 22 Mar 2022 11:06:04 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id C06AD85A5BC
 for <dm-devel@redhat.com>; Tue, 22 Mar 2022 11:06:04 +0000 (UTC)
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com
 [185.176.79.56]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-567-LKTD1BlVMi6fks-uBY9C6w-1; Tue, 22 Mar 2022 07:06:03 -0400
X-MC-Unique: LKTD1BlVMi6fks-uBY9C6w-1
Received: from fraeml745-chm.china.huawei.com (unknown [172.18.147.226])
 by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4KN7QQ0YRSz67m9x;
 Tue, 22 Mar 2022 18:44:14 +0800 (CST)
Received: from lhreml724-chm.china.huawei.com (10.201.108.75) by
 fraeml745-chm.china.huawei.com (10.206.15.226) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Tue, 22 Mar 2022 11:45:55 +0100
Received: from localhost.localdomain (10.69.192.58) by
 lhreml724-chm.china.huawei.com (10.201.108.75) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Tue, 22 Mar 2022 10:45:51 +0000
From: John Garry <john.garry@huawei.com>
To: <axboe@kernel.dk>, <damien.lemoal@opensource.wdc.com>,
 <bvanassche@acm.org>, <jejb@linux.ibm.com>, <martin.petersen@oracle.com>,
 <hch@lst.de>, <ming.lei@redhat.com>, <hare@suse.de>
Date: Tue, 22 Mar 2022 18:39:38 +0800
Message-ID: <1647945585-197349-5-git-send-email-john.garry@huawei.com>
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
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.8
X-Mailman-Approved-At: Thu, 24 Mar 2022 15:34:41 +0000
Subject: [dm-devel] [PATCH 04/11] scsi: libsas: Send SMP commands through
 the block layer
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
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.10
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Send SMP commands through the block layer so that each command gets a
unique tag associated.

We can now also take advantage of the block layer request timeout handling.

Signed-off-by: John Garry <john.garry@huawei.com>
---
 drivers/scsi/libsas/sas_expander.c  | 38 +++++++++++++++------
 drivers/scsi/libsas/sas_internal.h  |  1 +
 drivers/scsi/libsas/sas_scsi_host.c | 53 +++++++++++++++++++++++++++++
 3 files changed, 81 insertions(+), 11 deletions(-)

diff --git a/drivers/scsi/libsas/sas_expander.c b/drivers/scsi/libsas/sas_expander.c
index 260e735d06fa..bd25b00912ac 100644
--- a/drivers/scsi/libsas/sas_expander.c
+++ b/drivers/scsi/libsas/sas_expander.c
@@ -39,10 +39,19 @@ static int smp_execute_task_sg(struct domain_device *dev,
 	struct sas_internal *i =
 		to_sas_internal(dev->port->ha->core.shost->transportt);
 	struct sas_ha_struct *ha = dev->port->ha;
+	struct Scsi_Host *shost = ha->core.shost;
+	struct request_queue *request_queue;
+	struct request *rq;
+
+	request_queue = sas_alloc_request_queue(shost);
+	if (IS_ERR(request_queue))
+		return PTR_ERR(request_queue);
 
 	pm_runtime_get_sync(ha->dev);
 	mutex_lock(&dev->ex_dev.cmd_mutex);
 	for (retry = 0; retry < 3; retry++) {
+		struct scsi_cmnd *scmd;
+
 		if (test_bit(SAS_DEV_GONE, &dev->state)) {
 			res = -ECOMM;
 			break;
@@ -53,26 +62,30 @@ static int smp_execute_task_sg(struct domain_device *dev,
 			res = -ENOMEM;
 			break;
 		}
+
+		rq = scsi_alloc_request(request_queue, REQ_OP_DRV_IN, 0);
+		if (IS_ERR(rq)) {
+			res = PTR_ERR(rq);
+			break;
+		}
+
+		scmd = blk_mq_rq_to_pdu(rq);
+		scmd->submitter = SUBMITTED_BY_SCSI_CUSTOM_OPS;
+		ASSIGN_SAS_TASK(scmd, task);
+
 		task->dev = dev;
+		task->uldd_task = scmd;
 		task->task_proto = dev->tproto;
 		task->smp_task.smp_req = *req;
 		task->smp_task.smp_resp = *resp;
-
 		task->task_done = sas_task_internal_done;
 
-		task->slow_task->timer.function = sas_task_internal_timedout;
-		task->slow_task->timer.expires = jiffies + SMP_TIMEOUT*HZ;
-		add_timer(&task->slow_task->timer);
+		rq->timeout = SMP_TIMEOUT*HZ;
 
-		res = i->dft->lldd_execute_task(task, GFP_KERNEL);
-
-		if (res) {
-			del_timer(&task->slow_task->timer);
-			pr_notice("executing SMP task failed:%d\n", res);
-			break;
-		}
+		blk_execute_rq_nowait(rq, true, NULL);
 
 		wait_for_completion(&task->slow_task->completion);
+		__blk_mq_end_request(rq, BLK_STS_OK);
 		res = -ECOMM;
 		if ((task->task_state_flags & SAS_TASK_STATE_ABORTED)) {
 			pr_notice("smp task timed out or aborted\n");
@@ -117,6 +130,9 @@ static int smp_execute_task_sg(struct domain_device *dev,
 
 	BUG_ON(retry == 3 && task != NULL);
 	sas_free_task(task);
+
+	blk_cleanup_queue(request_queue);
+
 	return res;
 }
 
diff --git a/drivers/scsi/libsas/sas_internal.h b/drivers/scsi/libsas/sas_internal.h
index 13d0ffaada93..ca2bace16953 100644
--- a/drivers/scsi/libsas/sas_internal.h
+++ b/drivers/scsi/libsas/sas_internal.h
@@ -95,6 +95,7 @@ extern const work_func_t sas_port_event_fns[PORT_NUM_EVENTS];
 
 void sas_task_internal_done(struct sas_task *task);
 void sas_task_internal_timedout(struct timer_list *t);
+struct request_queue *sas_alloc_request_queue(struct Scsi_Host *shost);
 int sas_execute_tmf(struct domain_device *device, void *parameter,
 		    int para_len, int force_phy_id,
 		    struct sas_tmf_task *tmf);
diff --git a/drivers/scsi/libsas/sas_scsi_host.c b/drivers/scsi/libsas/sas_scsi_host.c
index 9c82e5dc4fcc..91133ad37ae8 100644
--- a/drivers/scsi/libsas/sas_scsi_host.c
+++ b/drivers/scsi/libsas/sas_scsi_host.c
@@ -920,6 +920,59 @@ void sas_task_internal_timedout(struct timer_list *t)
 #define TASK_TIMEOUT			(20 * HZ)
 #define TASK_RETRY			3
 
+static enum blk_eh_timer_return sas_task_timedout(struct request *rq, bool resv)
+{
+	struct scsi_cmnd *scmd = blk_mq_rq_to_pdu(rq);
+	struct sas_task *task = TO_SAS_TASK(scmd);
+	bool is_completed = true;
+	unsigned long flags;
+
+	spin_lock_irqsave(&task->task_state_lock, flags);
+	if (!(task->task_state_flags & SAS_TASK_STATE_DONE)) {
+		task->task_state_flags |= SAS_TASK_STATE_ABORTED;
+		is_completed = false;
+	}
+	spin_unlock_irqrestore(&task->task_state_lock, flags);
+
+	if (!is_completed)
+		complete(&task->slow_task->completion);
+	return BLK_EH_DONE;
+}
+
+static blk_status_t sas_exec_rq(struct blk_mq_hw_ctx *hctx,
+				const struct blk_mq_queue_data *bd)
+{
+	struct request *rq = bd->rq;
+	struct scsi_cmnd *scmd = blk_mq_rq_to_pdu(rq);
+	struct sas_task *task = (struct sas_task *)scmd->host_scribble;
+	struct domain_device *device = task->dev;
+	struct sas_ha_struct *ha = device->port->ha;
+	struct sas_internal *i = to_sas_internal(ha->core.shost->transportt);
+	int res;
+
+	blk_mq_start_request(bd->rq);
+
+	res = i->dft->lldd_execute_task(task, GFP_KERNEL);
+	if (res) {
+		pr_notice("executing task proto 0x%x failed:%d\n", task->task_proto, res);
+		task->task_status.resp = SAS_TASK_UNDELIVERED;
+		task->task_status.stat = SAS_DEVICE_UNKNOWN;
+		complete(&task->slow_task->completion);
+	}
+
+	return BLK_STS_OK;
+}
+
+static const struct blk_mq_ops sas_blk_mq_ops = {
+	.queue_rq	= sas_exec_rq,
+	.timeout	= sas_task_timedout,
+};
+
+struct request_queue *sas_alloc_request_queue(struct Scsi_Host *shost)
+{
+	return blk_mq_init_queue_ops(&shost->tag_set, &sas_blk_mq_ops);
+}
+
 static int sas_execute_internal_abort(struct domain_device *device,
 				      enum sas_internal_abort type, u16 tag,
 				      unsigned int qid, void *data)
-- 
2.26.2

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel


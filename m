Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 75582C433FE
	for <dm-devel@archiver.kernel.org>; Thu, 24 Mar 2022 15:35:09 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-54-bcWbFuiFNCOSlEzYZg7whQ-1; Thu, 24 Mar 2022 11:35:05 -0400
X-MC-Unique: bcWbFuiFNCOSlEzYZg7whQ-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 8C8F9380451B;
	Thu, 24 Mar 2022 15:34:56 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 7756240F165;
	Thu, 24 Mar 2022 15:34:56 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 01D4F1940367;
	Thu, 24 Mar 2022 15:34:56 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com
 [10.11.54.7])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id C11551947BBC
 for <dm-devel@listman.corp.redhat.com>; Tue, 22 Mar 2022 11:06:16 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id B39E8145455F; Tue, 22 Mar 2022 11:06:16 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id AFA4A1454557
 for <dm-devel@redhat.com>; Tue, 22 Mar 2022 11:06:16 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 97102811E83
 for <dm-devel@redhat.com>; Tue, 22 Mar 2022 11:06:16 +0000 (UTC)
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com
 [185.176.79.56]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-30-qyvcDfg3Nba_nKW8HLvTFg-1; Tue, 22 Mar 2022 07:06:15 -0400
X-MC-Unique: qyvcDfg3Nba_nKW8HLvTFg-1
Received: from fraeml742-chm.china.huawei.com (unknown [172.18.147.200])
 by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4KN7RL1hjGz67PTQ;
 Tue, 22 Mar 2022 18:45:02 +0800 (CST)
Received: from lhreml724-chm.china.huawei.com (10.201.108.75) by
 fraeml742-chm.china.huawei.com (10.206.15.223) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Tue, 22 Mar 2022 11:46:06 +0100
Received: from localhost.localdomain (10.69.192.58) by
 lhreml724-chm.china.huawei.com (10.201.108.75) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Tue, 22 Mar 2022 10:46:02 +0000
From: John Garry <john.garry@huawei.com>
To: <axboe@kernel.dk>, <damien.lemoal@opensource.wdc.com>,
 <bvanassche@acm.org>, <jejb@linux.ibm.com>, <martin.petersen@oracle.com>,
 <hch@lst.de>, <ming.lei@redhat.com>, <hare@suse.de>
Date: Tue, 22 Mar 2022 18:39:41 +0800
Message-ID: <1647945585-197349-8-git-send-email-john.garry@huawei.com>
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
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.7
X-Mailman-Approved-At: Thu, 24 Mar 2022 15:34:41 +0000
Subject: [dm-devel] [PATCH 07/11] scsi: libsas: Send internal abort commands
 through the block layer
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

Like what we did for SMP commands, send internal abort commands through
the block layer.

At this point no code in libsas relies on the sas_slow_task.timer;
unfortunately we can't delete it as some LLDDs (pm8001) still rely on it -
let's try to remove them in future.

But we can delete the legacy timeout handler, sas_task_internal_timedout().

Signed-off-by: John Garry <john.garry@huawei.com>
---
 drivers/scsi/libsas/sas_scsi_host.c | 59 +++++++++++++++--------------
 1 file changed, 31 insertions(+), 28 deletions(-)

diff --git a/drivers/scsi/libsas/sas_scsi_host.c b/drivers/scsi/libsas/sas_scsi_host.c
index 04c6298d1340..f139977098c2 100644
--- a/drivers/scsi/libsas/sas_scsi_host.c
+++ b/drivers/scsi/libsas/sas_scsi_host.c
@@ -899,24 +899,6 @@ void sas_task_internal_done(struct sas_task *task)
 	complete(&task->slow_task->completion);
 }
 
-void sas_task_internal_timedout(struct timer_list *t)
-{
-	struct sas_task_slow *slow = from_timer(slow, t, timer);
-	struct sas_task *task = slow->task;
-	bool is_completed = true;
-	unsigned long flags;
-
-	spin_lock_irqsave(&task->task_state_lock, flags);
-	if (!(task->task_state_flags & SAS_TASK_STATE_DONE)) {
-		task->task_state_flags |= SAS_TASK_STATE_ABORTED;
-		is_completed = false;
-	}
-	spin_unlock_irqrestore(&task->task_state_lock, flags);
-
-	if (!is_completed)
-		complete(&task->slow_task->completion);
-}
-
 #define TASK_TIMEOUT			(20 * HZ)
 #define TASK_RETRY			3
 
@@ -979,35 +961,52 @@ static int sas_execute_internal_abort(struct domain_device *device,
 {
 	struct sas_ha_struct *ha = device->port->ha;
 	struct sas_internal *i = to_sas_internal(ha->core.shost->transportt);
+	struct Scsi_Host *shost = ha->core.shost;
 	struct sas_task *task = NULL;
 	int res, retry;
+	struct request_queue *request_queue;
+	struct request *rq;
+
+	request_queue = sas_alloc_request_queue(shost);
+	if (IS_ERR(request_queue))
+		return PTR_ERR(request_queue);
 
 	for (retry = 0; retry < TASK_RETRY; retry++) {
+		struct scsi_cmnd *scmd;
+
 		task = sas_alloc_slow_task(GFP_KERNEL);
-		if (!task)
-			return -ENOMEM;
+		if (!task) {
+			res = -ENOMEM;
+			break;
+		}
 
 		task->dev = device;
 		task->task_proto = SAS_PROTOCOL_INTERNAL_ABORT;
 		task->task_done = sas_task_internal_done;
-		task->slow_task->timer.function = sas_task_internal_timedout;
-		task->slow_task->timer.expires = jiffies + TASK_TIMEOUT;
-		add_timer(&task->slow_task->timer);
 
 		task->abort_task.tag = tag;
 		task->abort_task.type = type;
 		task->abort_task.qid = qid;
 
-		res = i->dft->lldd_execute_task(task, GFP_KERNEL);
-		if (res) {
-			del_timer_sync(&task->slow_task->timer);
-			pr_err("Executing internal abort failed %016llx (%d)\n",
-			       SAS_ADDR(device->sas_addr), res);
+		rq = scsi_alloc_request_hwq(request_queue, REQ_OP_DRV_IN, BLK_MQ_REQ_NOWAIT, qid);
+		if (!rq) {
+			res = PTR_ERR(rq);
 			break;
 		}
 
+		scmd = blk_mq_rq_to_pdu(rq);
+		scmd->submitter = SUBMITTED_BY_SCSI_CUSTOM_OPS;
+		ASSIGN_SAS_TASK(scmd, task);
+
+		task->uldd_task = scmd;
+
+		rq->timeout = TASK_TIMEOUT;
+
+		blk_execute_rq_nowait(rq, true, NULL);
+
 		wait_for_completion(&task->slow_task->completion);
 		res = TMF_RESP_FUNC_FAILED;
+		__blk_mq_end_request(rq, BLK_STS_OK);
 
 		/* Even if the internal abort timed out, return direct. */
 		if (task->task_state_flags & SAS_TASK_STATE_ABORTED) {
@@ -1042,7 +1041,11 @@ static int sas_execute_internal_abort(struct domain_device *device,
 		task = NULL;
 	}
 	BUG_ON(retry == TASK_RETRY && task != NULL);
+
 	sas_free_task(task);
+
+	blk_cleanup_queue(request_queue);
+
 	return res;
 }
 
-- 
2.26.2

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel


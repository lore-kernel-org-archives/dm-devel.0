Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D5DA1C4167B
	for <dm-devel@archiver.kernel.org>; Thu, 24 Mar 2022 15:34:58 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-217-nt_0tA9BMYmBZadIjuxMzg-1; Thu, 24 Mar 2022 11:34:49 -0400
X-MC-Unique: nt_0tA9BMYmBZadIjuxMzg-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 685243804513;
	Thu, 24 Mar 2022 15:34:47 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 55A07401476;
	Thu, 24 Mar 2022 15:34:47 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 03F7A194034F;
	Thu, 24 Mar 2022 15:34:46 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com
 [10.11.54.9])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id D268F1947BBC
 for <dm-devel@listman.corp.redhat.com>; Tue, 22 Mar 2022 11:06:20 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id B235D54EC61; Tue, 22 Mar 2022 11:06:20 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id AE41F4B6959
 for <dm-devel@redhat.com>; Tue, 22 Mar 2022 11:06:20 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 5774A899EC2
 for <dm-devel@redhat.com>; Tue, 22 Mar 2022 11:06:20 +0000 (UTC)
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com
 [185.176.79.56]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-153-DSDnnvpyODqRgi3Mc0GXow-1; Tue, 22 Mar 2022 07:06:18 -0400
X-MC-Unique: DSDnnvpyODqRgi3Mc0GXow-1
Received: from fraeml740-chm.china.huawei.com (unknown [172.18.147.206])
 by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4KN7QJ0GhKz67Xmk;
 Tue, 22 Mar 2022 18:44:08 +0800 (CST)
Received: from lhreml724-chm.china.huawei.com (10.201.108.75) by
 fraeml740-chm.china.huawei.com (10.206.15.221) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Tue, 22 Mar 2022 11:46:18 +0100
Received: from localhost.localdomain (10.69.192.58) by
 lhreml724-chm.china.huawei.com (10.201.108.75) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Tue, 22 Mar 2022 10:46:14 +0000
From: John Garry <john.garry@huawei.com>
To: <axboe@kernel.dk>, <damien.lemoal@opensource.wdc.com>,
 <bvanassche@acm.org>, <jejb@linux.ibm.com>, <martin.petersen@oracle.com>,
 <hch@lst.de>, <ming.lei@redhat.com>, <hare@suse.de>
Date: Tue, 22 Mar 2022 18:39:44 +0800
Message-ID: <1647945585-197349-11-git-send-email-john.garry@huawei.com>
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
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.9
X-Mailman-Approved-At: Thu, 24 Mar 2022 15:34:42 +0000
Subject: [dm-devel] [PATCH 10/11] scsi: libsas: Add sas_task_to_hwq()
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

Add a function to get the hw queue index from a sas_task.

Signed-off-by: John Garry <john.garry@huawei.com>
---
 drivers/scsi/hisi_sas/hisi_sas_main.c | 20 ++------------------
 drivers/scsi/libsas/sas_scsi_host.c   |  9 ++++++++-
 include/scsi/libsas.h                 |  2 +-
 3 files changed, 11 insertions(+), 20 deletions(-)

diff --git a/drivers/scsi/hisi_sas/hisi_sas_main.c b/drivers/scsi/hisi_sas/hisi_sas_main.c
index f6b64c789335..b3e03c229cb5 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_main.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_main.c
@@ -461,7 +461,6 @@ static int hisi_sas_queue_command(struct sas_task *task, gfp_t gfp_flags)
 	struct asd_sas_port *sas_port = device->port;
 	struct hisi_sas_device *sas_dev = device->lldd_dev;
 	bool internal_abort = sas_is_internal_abort(task);
-	struct scsi_cmnd *scmd = NULL;
 	struct hisi_sas_dq *dq = NULL;
 	struct hisi_sas_port *port;
 	struct hisi_hba *hisi_hba;
@@ -486,6 +485,8 @@ static int hisi_sas_queue_command(struct sas_task *task, gfp_t gfp_flags)
 	hisi_hba = dev_to_hisi_hba(device);
 	dev = hisi_hba->dev;
 
+	dq = &hisi_hba->dq[sas_task_to_hwq(task)];
+
 	switch (task->task_proto) {
 	case SAS_PROTOCOL_SSP:
 	case SAS_PROTOCOL_SMP:
@@ -520,22 +521,6 @@ static int hisi_sas_queue_command(struct sas_task *task, gfp_t gfp_flags)
 				return -ECOMM;
 		}
 
-		scmd = task->uldd_task;
-
-		if (scmd) {
-			unsigned int dq_index;
-			u32 blk_tag;
-
-			blk_tag = blk_mq_unique_tag(scsi_cmd_to_rq(scmd));
-			dq_index = blk_mq_unique_tag_to_hwq(blk_tag);
-			dq = &hisi_hba->dq[dq_index];
-		} else {
-			struct Scsi_Host *shost = hisi_hba->shost;
-			struct blk_mq_queue_map *qmap = &shost->tag_set.map[HCTX_TYPE_DEFAULT];
-			int queue = qmap->mq_map[raw_smp_processor_id()];
-
-			dq = &hisi_hba->dq[queue];
-		}
 		break;
 	case SAS_PROTOCOL_INTERNAL_ABORT:
 		if (!hisi_hba->hw->prep_abort)
@@ -550,7 +535,6 @@ static int hisi_sas_queue_command(struct sas_task *task, gfp_t gfp_flags)
 			return -EINVAL;
 
 		port = to_hisi_sas_port(sas_port);
-		dq = &hisi_hba->dq[task->abort_task.qid];
 		break;
 	default:
 		dev_err(hisi_hba->dev, "task prep: unknown/unsupported proto (0x%x)\n",
diff --git a/drivers/scsi/libsas/sas_scsi_host.c b/drivers/scsi/libsas/sas_scsi_host.c
index 425904fa4cc7..b808b23e265e 100644
--- a/drivers/scsi/libsas/sas_scsi_host.c
+++ b/drivers/scsi/libsas/sas_scsi_host.c
@@ -986,7 +986,6 @@ static int sas_execute_internal_abort(struct domain_device *device,
 
 		task->abort_task.tag = tag;
 		task->abort_task.type = type;
-		task->abort_task.qid = qid;
 
 		rq = scsi_alloc_request_hwq(request_queue, REQ_OP_DRV_IN, BLK_MQ_REQ_NOWAIT, qid);
 		if (!rq) {
@@ -1079,6 +1078,14 @@ unsigned int sas_task_to_unique_tag(struct sas_task *task)
 }
 EXPORT_SYMBOL_GPL(sas_task_to_unique_tag);
 
+unsigned int sas_task_to_hwq(struct sas_task *task)
+{
+	u32 unique = sas_task_to_rq_unique_tag(task);
+
+	return blk_mq_unique_tag_to_hwq(unique);
+}
+EXPORT_SYMBOL_GPL(sas_task_to_hwq);
+
 int sas_execute_tmf(struct domain_device *device, void *parameter,
 		    int para_len, int force_phy_id,
 		    struct sas_tmf_task *tmf)
diff --git a/include/scsi/libsas.h b/include/scsi/libsas.h
index 3d9ef4c2c889..368c45016af0 100644
--- a/include/scsi/libsas.h
+++ b/include/scsi/libsas.h
@@ -565,7 +565,6 @@ enum sas_internal_abort {
 
 struct sas_internal_abort_task {
 	enum sas_internal_abort type;
-	unsigned int qid;
 	u16 tag;
 };
 
@@ -626,6 +625,7 @@ struct sas_task {
 };
 
 unsigned int sas_task_to_unique_tag(struct sas_task *task);
+unsigned int sas_task_to_hwq(struct sas_task *task);
 
 struct sas_task_slow {
 	/* standard/extra infrastructure for slow path commands (SMP and
-- 
2.26.2

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel


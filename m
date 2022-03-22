Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0FA94C433EF
	for <dm-devel@archiver.kernel.org>; Thu, 24 Mar 2022 15:35:07 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-7-xGisGd3RM1OJFLGZDXiO8g-1; Thu, 24 Mar 2022 11:35:02 -0400
X-MC-Unique: xGisGd3RM1OJFLGZDXiO8g-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 5B8292999B41;
	Thu, 24 Mar 2022 15:34:57 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 447F4111F3C7;
	Thu, 24 Mar 2022 15:34:57 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 52089194035F;
	Thu, 24 Mar 2022 15:34:56 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com
 [10.11.54.8])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 814F91947BBC
 for <dm-devel@listman.corp.redhat.com>; Tue, 22 Mar 2022 11:06:20 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 6C42BC26EA9; Tue, 22 Mar 2022 11:06:20 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 6828CC26E9A
 for <dm-devel@redhat.com>; Tue, 22 Mar 2022 11:06:20 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 4F4A1811E75
 for <dm-devel@redhat.com>; Tue, 22 Mar 2022 11:06:20 +0000 (UTC)
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com
 [185.176.79.56]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-12-MmbMEXpBPB6rneW7zfpXCA-1; Tue, 22 Mar 2022 07:06:18 -0400
X-MC-Unique: MmbMEXpBPB6rneW7zfpXCA-1
Received: from fraeml739-chm.china.huawei.com (unknown [172.18.147.226])
 by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4KN7QC5qZ7z683yD;
 Tue, 22 Mar 2022 18:44:03 +0800 (CST)
Received: from lhreml724-chm.china.huawei.com (10.201.108.75) by
 fraeml739-chm.china.huawei.com (10.206.15.220) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Tue, 22 Mar 2022 11:46:14 +0100
Received: from localhost.localdomain (10.69.192.58) by
 lhreml724-chm.china.huawei.com (10.201.108.75) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Tue, 22 Mar 2022 10:46:10 +0000
From: John Garry <john.garry@huawei.com>
To: <axboe@kernel.dk>, <damien.lemoal@opensource.wdc.com>,
 <bvanassche@acm.org>, <jejb@linux.ibm.com>, <martin.petersen@oracle.com>,
 <hch@lst.de>, <ming.lei@redhat.com>, <hare@suse.de>
Date: Tue, 22 Mar 2022 18:39:43 +0800
Message-ID: <1647945585-197349-10-git-send-email-john.garry@huawei.com>
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
X-Mailman-Approved-At: Thu, 24 Mar 2022 15:34:42 +0000
Subject: [dm-devel] [PATCH 09/11] scsi: libsas: Add sas_task_to_unique_tag()
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
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.3
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Add a function to get the unique request tag from a sas_task.

Signed-off-by: John Garry <john.garry@huawei.com>
---
 drivers/scsi/hisi_sas/hisi_sas_main.c |  8 ++++----
 drivers/scsi/libsas/sas_scsi_host.c   | 14 ++++++++++++++
 include/scsi/libsas.h                 |  2 ++
 3 files changed, 20 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/hisi_sas/hisi_sas_main.c b/drivers/scsi/hisi_sas/hisi_sas_main.c
index e438c68e249a..f6b64c789335 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_main.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_main.c
@@ -177,13 +177,13 @@ static void hisi_sas_slot_index_set(struct hisi_hba *hisi_hba, int slot_idx)
 }
 
 static int hisi_sas_slot_index_alloc(struct hisi_hba *hisi_hba,
-				     struct scsi_cmnd *scsi_cmnd)
+				     struct sas_task *task)
 {
 	int index;
 	void *bitmap = hisi_hba->slot_index_tags;
 
-	if (scsi_cmnd)
-		return scsi_cmd_to_rq(scsi_cmnd)->tag;
+	if (task)
+		return sas_task_to_unique_tag(task);
 
 	spin_lock(&hisi_hba->lock);
 	index = find_next_zero_bit(bitmap, hisi_hba->slot_index_count,
@@ -572,7 +572,7 @@ static int hisi_sas_queue_command(struct sas_task *task, gfp_t gfp_flags)
 	if (!internal_abort && hisi_hba->hw->slot_index_alloc)
 		rc = hisi_hba->hw->slot_index_alloc(hisi_hba, device);
 	else
-		rc = hisi_sas_slot_index_alloc(hisi_hba, scmd);
+		rc = hisi_sas_slot_index_alloc(hisi_hba, task);
 
 	if (rc < 0)
 		goto err_out_dif_dma_unmap;
diff --git a/drivers/scsi/libsas/sas_scsi_host.c b/drivers/scsi/libsas/sas_scsi_host.c
index f139977098c2..425904fa4cc7 100644
--- a/drivers/scsi/libsas/sas_scsi_host.c
+++ b/drivers/scsi/libsas/sas_scsi_host.c
@@ -1065,6 +1065,20 @@ int sas_execute_internal_abort_dev(struct domain_device *device,
 }
 EXPORT_SYMBOL_GPL(sas_execute_internal_abort_dev);
 
+static u32 sas_task_to_rq_unique_tag(struct sas_task *task)
+{
+	return blk_mq_unique_tag(scsi_cmd_to_rq(task->uldd_task));
+}
+
+unsigned int sas_task_to_unique_tag(struct sas_task *task)
+{
+	u32 unique = sas_task_to_rq_unique_tag(task);
+
+	return blk_mq_unique_tag_to_tag(unique);
+
+}
+EXPORT_SYMBOL_GPL(sas_task_to_unique_tag);
+
 int sas_execute_tmf(struct domain_device *device, void *parameter,
 		    int para_len, int force_phy_id,
 		    struct sas_tmf_task *tmf)
diff --git a/include/scsi/libsas.h b/include/scsi/libsas.h
index ff04eb6d250b..3d9ef4c2c889 100644
--- a/include/scsi/libsas.h
+++ b/include/scsi/libsas.h
@@ -625,6 +625,8 @@ struct sas_task {
 	struct sas_tmf_task *tmf;
 };
 
+unsigned int sas_task_to_unique_tag(struct sas_task *task);
+
 struct sas_task_slow {
 	/* standard/extra infrastructure for slow path commands (SMP and
 	 * internal lldd commands
-- 
2.26.2

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel


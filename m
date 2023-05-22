Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B4B76C7EE23
	for <dm-devel@archiver.kernel.org>; Mon, 22 May 2023 18:39:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1684780773;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=MxA9qscUc2AdozDGNKtvTRnDQN99a9fYIxj4aQt5ZeE=;
	b=fhwoCVM83pGycPphhOavJp5Vunj0QSFJJgis6vM2dp3ehwlJZzlsSv7wMJhhjUxLCGlpXv
	54zQvE3yudGXmgrPbthOSfM6W3WtKBMtn2tymqjQdQThBpgvVEJTgoxTCq3hqltc3FhMzJ
	jZ/shAaw20UE22QC738Ytx7Cb/KdZ4Y=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-544-5_F2ih4tN6yRVLrTWdUW3A-1; Mon, 22 May 2023 14:39:30 -0400
X-MC-Unique: 5_F2ih4tN6yRVLrTWdUW3A-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 25749101A55C;
	Mon, 22 May 2023 18:39:28 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 138A81121314;
	Mon, 22 May 2023 18:39:28 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id E0F5719465A0;
	Mon, 22 May 2023 18:39:27 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com
 [10.11.54.1])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 3F3031946595
 for <dm-devel@listman.corp.redhat.com>; Mon, 22 May 2023 18:39:26 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 2427040561AC; Mon, 22 May 2023 18:39:26 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 1AAC140561B9
 for <dm-devel@redhat.com>; Mon, 22 May 2023 18:39:26 +0000 (UTC)
Received: from us-smtp-inbound-1.mimecast.com (us-smtp-2.mimecast.com
 [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id EE2AF85A5BD
 for <dm-devel@redhat.com>; Mon, 22 May 2023 18:39:25 +0000 (UTC)
Received: from mail-pj1-f52.google.com (mail-pj1-f52.google.com
 [209.85.216.52]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-441-_P5T_tl7PQe4b9pJLkgdcQ-1; Mon, 22 May 2023 14:39:20 -0400
X-MC-Unique: _P5T_tl7PQe4b9pJLkgdcQ-1
Received: by mail-pj1-f52.google.com with SMTP id
 98e67ed59e1d1-2554696544cso1495584a91.2; 
 Mon, 22 May 2023 11:39:19 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20221208; t=1684780758; x=1687372758;
 h=content-transfer-encoding:mime-version:references:in-reply-to
 :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
 :subject:date:message-id:reply-to;
 bh=35F09AJ7lieqG7FdP2TPETn09Ir0CPtxDtFHxJV+8CU=;
 b=D8SdPkTJO/nuEc/NsqLU+8nAwl7cRxbupe+X/4BZpZ5TDsCtnxennu0JCXCrsVAaUN
 byFJYL9rRlmiF3EPvrsDsDMBbhwy/1HaqWA+EtQkqw+43W4Dl9uJOofgcPAOj0Df6GQe
 doT5Ez1zmYKUzsLhlJxgnip1Ox7Wzny3ud0YMYxWhtyowKREXqEbpccPRLolcuA4tOJn
 DUF9dzmxSmb6koA7sf9/CZrmt+02UibfCrvAjYCYNr/s1uj23qTgTtUdKzToFobcIGn3
 VwI67U+DtP+zFmokcwwU0paN2xKLbqRCo4k/U1Jij4GPlvnMzg82pJZxJvcTPs3iyX6x
 FSVw==
X-Gm-Message-State: AC+VfDz4IxnADYs4qadgt2i7/sycZmFIvugdqNTu8uPIQ1dSN1b63dfR
 WmIadP4ofvPWaYh/T5Q34hc=
X-Google-Smtp-Source: ACHHUZ518l3UAli/oocMq898ICvsDOQGjpJWy3aDaqkg5AbTHsejbNIpFxbn6p4oxlNkTF5Tp1KDVg==
X-Received: by 2002:a17:90a:14e4:b0:246:c097:6a17 with SMTP id
 k91-20020a17090a14e400b00246c0976a17mr10346610pja.24.1684780758449; 
 Mon, 22 May 2023 11:39:18 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com
 ([2620:15c:211:201:642f:e57f:85fb:3794])
 by smtp.gmail.com with ESMTPSA id
 d61-20020a17090a6f4300b0024dfbac9e2fsm6710335pjk.21.2023.05.22.11.39.16
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Mon, 22 May 2023 11:39:18 -0700 (PDT)
From: Bart Van Assche <bvanassche@acm.org>
To: Jens Axboe <axboe@kernel.dk>
Date: Mon, 22 May 2023 11:38:42 -0700
Message-ID: <20230522183845.354920-8-bvanassche@acm.org>
In-Reply-To: <20230522183845.354920-1-bvanassche@acm.org>
References: <20230522183845.354920-1-bvanassche@acm.org>
MIME-Version: 1.0
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.1
Subject: [dm-devel] [PATCH v3 7/7] block: Inline blk_mq_{,
 delay_}kick_requeue_list()
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
Cc: Juergen Gross <jgross@suse.com>,
 Stefano Stabellini <sstabellini@kernel.org>,
 Bart Van Assche <bvanassche@acm.org>, Vasily Gorbik <gor@linux.ibm.com>,
 Heiko Carstens <hca@linux.ibm.com>, Mike Snitzer <snitzer@kernel.org>,
 Ming Lei <ming.lei@redhat.com>, linux-block@vger.kernel.org,
 Sagi Grimberg <sagi@grimberg.me>, dm-devel@redhat.com,
 Damien Le Moal <dlemoal@kernel.org>, Vineeth Vijayan <vneethv@linux.ibm.com>,
 "Martin K. Petersen" <martin.petersen@oracle.com>,
 Keith Busch <kbusch@kernel.org>, Jaegeuk Kim <jaegeuk@kernel.org>,
 Alexander Gordeev <agordeev@linux.ibm.com>,
 "James E.J. Bottomley" <jejb@linux.ibm.com>, Christoph Hellwig <hch@lst.de>,
 Alasdair Kergon <agk@redhat.com>,
 =?UTF-8?q?Roger=20Pau=20Monn=C3=A9?= <roger.pau@citrix.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: acm.org
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Patch "block: Preserve the order of requeued requests" changed
blk_mq_kick_requeue_list() and blk_mq_delay_kick_requeue_list() into
blk_mq_run_hw_queues() and blk_mq_delay_run_hw_queues() calls
respectively. Inline blk_mq_{,delay_}kick_requeue_list() because these
functions are now too short to keep these as separate functions.

Cc: Christoph Hellwig <hch@lst.de>
Cc: Damien Le Moal <dlemoal@kernel.org>
Cc: Ming Lei <ming.lei@redhat.com>
Cc: Mike Snitzer <snitzer@kernel.org>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 block/blk-flush.c            |  4 ++--
 block/blk-mq-debugfs.c       |  2 +-
 block/blk-mq.c               | 16 +---------------
 drivers/block/ublk_drv.c     |  6 +++---
 drivers/block/xen-blkfront.c |  1 -
 drivers/md/dm-rq.c           |  6 +++---
 drivers/nvme/host/core.c     |  2 +-
 drivers/s390/block/scm_blk.c |  2 +-
 drivers/scsi/scsi_lib.c      |  2 +-
 include/linux/blk-mq.h       |  2 --
 10 files changed, 13 insertions(+), 30 deletions(-)

diff --git a/block/blk-flush.c b/block/blk-flush.c
index dba392cf22be..22170036ddcb 100644
--- a/block/blk-flush.c
+++ b/block/blk-flush.c
@@ -191,7 +191,7 @@ static void blk_flush_complete_seq(struct request *rq,
 		spin_lock(&q->requeue_lock);
 		list_add_tail(&rq->queuelist, &q->flush_list);
 		spin_unlock(&q->requeue_lock);
-		blk_mq_kick_requeue_list(q);
+		blk_mq_run_hw_queues(q, true);
 		break;
 
 	case REQ_FSEQ_DONE:
@@ -352,7 +352,7 @@ static void blk_kick_flush(struct request_queue *q, struct blk_flush_queue *fq,
 	list_add_tail(&flush_rq->queuelist, &q->flush_list);
 	spin_unlock(&q->requeue_lock);
 
-	blk_mq_kick_requeue_list(q);
+	blk_mq_run_hw_queues(q, true);
 }
 
 static enum rq_end_io_ret mq_flush_data_end_io(struct request *rq,
diff --git a/block/blk-mq-debugfs.c b/block/blk-mq-debugfs.c
index 68165a50951b..869cc62ed50f 100644
--- a/block/blk-mq-debugfs.c
+++ b/block/blk-mq-debugfs.c
@@ -145,7 +145,7 @@ static ssize_t queue_state_write(void *data, const char __user *buf,
 	} else if (strcmp(op, "start") == 0) {
 		blk_mq_start_stopped_hw_queues(q, true);
 	} else if (strcmp(op, "kick") == 0) {
-		blk_mq_kick_requeue_list(q);
+		blk_mq_run_hw_queues(q, true);
 	} else {
 		pr_err("%s: unsupported operation '%s'\n", __func__, op);
 inval:
diff --git a/block/blk-mq.c b/block/blk-mq.c
index 52dffdc70480..34dcfc84d902 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -1430,7 +1430,7 @@ void blk_mq_requeue_request(struct request *rq, bool kick_requeue_list)
 	spin_unlock_irqrestore(&q->requeue_lock, flags);
 
 	if (kick_requeue_list)
-		blk_mq_kick_requeue_list(q);
+		blk_mq_run_hw_queues(q, true);
 }
 EXPORT_SYMBOL(blk_mq_requeue_request);
 
@@ -1470,19 +1470,6 @@ static void blk_mq_process_requeue_list(struct blk_mq_hw_ctx *hctx)
 		blk_mq_insert_request(rq, 0);
 }
 
-void blk_mq_kick_requeue_list(struct request_queue *q)
-{
-	blk_mq_run_hw_queues(q, true);
-}
-EXPORT_SYMBOL(blk_mq_kick_requeue_list);
-
-void blk_mq_delay_kick_requeue_list(struct request_queue *q,
-				    unsigned long msecs)
-{
-	blk_mq_delay_run_hw_queues(q, msecs);
-}
-EXPORT_SYMBOL(blk_mq_delay_kick_requeue_list);
-
 static bool blk_mq_rq_inflight(struct request *rq, void *priv)
 {
 	/*
@@ -3537,7 +3524,6 @@ static int blk_mq_hctx_notify_dead(unsigned int cpu, struct hlist_node *node)
 
 	list_for_each_entry_safe(rq, next, &tmp, queuelist)
 		blk_mq_requeue_request(rq, false);
-	blk_mq_kick_requeue_list(hctx->queue);
 
 	blk_mq_run_hw_queue(hctx, true);
 	return 0;
diff --git a/drivers/block/ublk_drv.c b/drivers/block/ublk_drv.c
index 539eada32861..4a3d579a25b5 100644
--- a/drivers/block/ublk_drv.c
+++ b/drivers/block/ublk_drv.c
@@ -900,7 +900,7 @@ static inline void __ublk_rq_task_work(struct request *req,
 		 */
 		if (unlikely(!mapped_bytes)) {
 			blk_mq_requeue_request(req, false);
-			blk_mq_delay_kick_requeue_list(req->q,
+			blk_mq_delay_run_hw_queues(req->q,
 					UBLK_REQUEUE_DELAY_MS);
 			return;
 		}
@@ -1290,7 +1290,7 @@ static void ublk_unquiesce_dev(struct ublk_device *ub)
 
 	blk_mq_unquiesce_queue(ub->ub_disk->queue);
 	/* We may have requeued some rqs in ublk_quiesce_queue() */
-	blk_mq_kick_requeue_list(ub->ub_disk->queue);
+	blk_mq_run_hw_queues(ub->ub_disk->queue, true);
 }
 
 static void ublk_stop_dev(struct ublk_device *ub)
@@ -2334,7 +2334,7 @@ static int ublk_ctrl_end_recovery(struct ublk_device *ub,
 	blk_mq_unquiesce_queue(ub->ub_disk->queue);
 	pr_devel("%s: queue unquiesced, dev id %d.\n",
 			__func__, header->dev_id);
-	blk_mq_kick_requeue_list(ub->ub_disk->queue);
+	blk_mq_run_hw_queues(ub->ub_disk->queue, true);
 	ub->dev_info.state = UBLK_S_DEV_LIVE;
 	schedule_delayed_work(&ub->monitor_work, UBLK_DAEMON_MONITOR_PERIOD);
 	ret = 0;
diff --git a/drivers/block/xen-blkfront.c b/drivers/block/xen-blkfront.c
index 23ed258b57f0..6b37a134dd3a 100644
--- a/drivers/block/xen-blkfront.c
+++ b/drivers/block/xen-blkfront.c
@@ -2040,7 +2040,6 @@ static int blkif_recover(struct blkfront_info *info)
 		blk_mq_requeue_request(req, false);
 	}
 	blk_mq_start_stopped_hw_queues(info->rq, true);
-	blk_mq_kick_requeue_list(info->rq);
 
 	while ((bio = bio_list_pop(&info->bio_list)) != NULL) {
 		/* Traverse the list of pending bios and re-queue them */
diff --git a/drivers/md/dm-rq.c b/drivers/md/dm-rq.c
index bbe1e2ea0aa4..6421cc2c9852 100644
--- a/drivers/md/dm-rq.c
+++ b/drivers/md/dm-rq.c
@@ -64,7 +64,7 @@ int dm_request_based(struct mapped_device *md)
 void dm_start_queue(struct request_queue *q)
 {
 	blk_mq_unquiesce_queue(q);
-	blk_mq_kick_requeue_list(q);
+	blk_mq_run_hw_queues(q, true);
 }
 
 void dm_stop_queue(struct request_queue *q)
@@ -170,14 +170,14 @@ static void dm_end_request(struct request *clone, blk_status_t error)
 
 void dm_mq_kick_requeue_list(struct mapped_device *md)
 {
-	blk_mq_kick_requeue_list(md->queue);
+	blk_mq_run_hw_queues(md->queue, true);
 }
 EXPORT_SYMBOL(dm_mq_kick_requeue_list);
 
 static void dm_mq_delay_requeue_request(struct request *rq, unsigned long msecs)
 {
 	blk_mq_requeue_request(rq, false);
-	blk_mq_delay_kick_requeue_list(rq->q, msecs);
+	blk_mq_delay_run_hw_queues(rq->q, msecs);
 }
 
 static void dm_requeue_original_request(struct dm_rq_target_io *tio, bool delay_requeue)
diff --git a/drivers/nvme/host/core.c b/drivers/nvme/host/core.c
index ccb6eb1282f8..9d3e4de23787 100644
--- a/drivers/nvme/host/core.c
+++ b/drivers/nvme/host/core.c
@@ -303,7 +303,7 @@ static void nvme_retry_req(struct request *req)
 
 	nvme_req(req)->retries++;
 	blk_mq_requeue_request(req, false);
-	blk_mq_delay_kick_requeue_list(req->q, delay);
+	blk_mq_delay_run_hw_queues(req->q, delay);
 }
 
 static void nvme_log_error(struct request *req)
diff --git a/drivers/s390/block/scm_blk.c b/drivers/s390/block/scm_blk.c
index 0c1df1d5f1ac..fe5937d28fdc 100644
--- a/drivers/s390/block/scm_blk.c
+++ b/drivers/s390/block/scm_blk.c
@@ -243,7 +243,7 @@ static void scm_request_requeue(struct scm_request *scmrq)
 
 	atomic_dec(&bdev->queued_reqs);
 	scm_request_done(scmrq);
-	blk_mq_kick_requeue_list(bdev->rq);
+	blk_mq_run_hw_queues(bdev->rq, true);
 }
 
 static void scm_request_finish(struct scm_request *scmrq)
diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index b7c569a42aa4..d74903221638 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -124,7 +124,7 @@ static void scsi_mq_requeue_cmd(struct scsi_cmnd *cmd, unsigned long msecs)
 
 	if (msecs) {
 		blk_mq_requeue_request(rq, false);
-		blk_mq_delay_kick_requeue_list(rq->q, msecs);
+		blk_mq_delay_run_hw_queues(rq->q, msecs);
 	} else
 		blk_mq_requeue_request(rq, true);
 }
diff --git a/include/linux/blk-mq.h b/include/linux/blk-mq.h
index 363894aea0e8..79b67664ace7 100644
--- a/include/linux/blk-mq.h
+++ b/include/linux/blk-mq.h
@@ -867,8 +867,6 @@ static inline bool blk_mq_add_to_batch(struct request *req,
 }
 
 void blk_mq_requeue_request(struct request *rq, bool kick_requeue_list);
-void blk_mq_kick_requeue_list(struct request_queue *q);
-void blk_mq_delay_kick_requeue_list(struct request_queue *q, unsigned long msecs);
 void blk_mq_complete_request(struct request *rq);
 bool blk_mq_complete_request_remote(struct request *rq);
 void blk_mq_stop_hw_queue(struct blk_mq_hw_ctx *hctx);

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel


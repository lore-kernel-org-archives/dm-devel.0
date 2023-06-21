Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9C958EB64D7
	for <dm-devel@archiver.kernel.org>; Wed, 21 Jun 2023 20:13:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1687378422;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=nbK+17o3YNfIU+zHnzT3oti9bgAebtdpnscsltjSAzI=;
	b=iYcatEa5NTc7qNI9Ka2m9SjHyEQb6b2BgVz1r1+GAq6T9BT12+o8aT4+EuIUkMAUvdGjA6
	UJt8i0s7gh04QEndo2LZjDULQ6fnyn4xdWhumO4xm8cLvC3fllJQ47L/Fe52EIlGXqGRA7
	cHPGWHtszbgZxejGM9ui8TZhy401/mo=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-46-0OAMCDwFMvm4FPaYJIjtuA-1; Wed, 21 Jun 2023 16:13:30 -0400
X-MC-Unique: 0OAMCDwFMvm4FPaYJIjtuA-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id EE84A3C11A06;
	Wed, 21 Jun 2023 20:13:02 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 10A492166B32;
	Wed, 21 Jun 2023 20:13:00 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id D64271946588;
	Wed, 21 Jun 2023 20:12:59 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com
 [10.11.54.7])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 5C7331946586
 for <dm-devel@listman.corp.redhat.com>; Wed, 21 Jun 2023 20:12:59 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 3EB8E14682F9; Wed, 21 Jun 2023 20:12:59 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 35C0D14682F8
 for <dm-devel@redhat.com>; Wed, 21 Jun 2023 20:12:59 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D20628AB380
 for <dm-devel@redhat.com>; Wed, 21 Jun 2023 20:12:58 +0000 (UTC)
Received: from mail-pf1-f174.google.com (mail-pf1-f174.google.com
 [209.85.210.174]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-42-Zi_zVQzdNMaZBaWHaX7YDg-1; Wed, 21 Jun 2023 16:12:56 -0400
X-MC-Unique: Zi_zVQzdNMaZBaWHaX7YDg-1
Received: by mail-pf1-f174.google.com with SMTP id
 d2e1a72fcca58-6687466137bso2422962b3a.0; 
 Wed, 21 Jun 2023 13:12:53 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20221208; t=1687378372; x=1689970372;
 h=content-transfer-encoding:mime-version:references:in-reply-to
 :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
 :subject:date:message-id:reply-to;
 bh=VlNqtMA/NLqFLwOLH5w19sbFOyjaSkPm1pgBbFRwCwo=;
 b=T/0A0lrMGY+wtfY17CmaZWll6UtlKdk9WYt0irUyQ4NFMtWmYhbg1cDBHpgRYGW1I2
 pe1ukkOkd1VWN53Lg3zH9s7e+8Yncmcz8qKKVe5CdMdleh8xbfOujUBU14J9HSHII0Hu
 X24hDfhfli9ntismd2ronsBAhMMDxXGgHRpdjqLhadj837wuFF3mKqMpczHMkr7iRgjI
 croAgCfAktyvozIOLQQPGDvuCWsmBw2WLsa1FYQ1slhBGivCwaeaTlek2IsHRwsARKJV
 Y54fJDAsh1XqKrJXPCwBauWZhwQU3x3TvmSTbt2C0C716I4jKH5/hcGeEr7hRDM8T5y0
 ss7w==
X-Gm-Message-State: AC+VfDwI+c4qlFnZPtrAjC/QH+JOQ3u4duWC8pzw4sYJ/U+BSsCAIC/9
 5CgRrX1CVCg+BfZE3sAVO+E=
X-Google-Smtp-Source: ACHHUZ5ScI1xhmFseEuHks0MXawYs1iBXGYhYjiJDkfmZjrFYb/s5rvVMocvDowZDgPcgNEkU0kTIQ==
X-Received: by 2002:a05:6a00:2daa:b0:668:71a1:2e85 with SMTP id
 fb42-20020a056a002daa00b0066871a12e85mr9217574pfb.8.1687378372212; 
 Wed, 21 Jun 2023 13:12:52 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com
 ([2620:15c:211:201:c0b7:6a6f:751b:b854])
 by smtp.gmail.com with ESMTPSA id
 h8-20020a63df48000000b00548fb73874asm3522983pgj.37.2023.06.21.13.12.50
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Wed, 21 Jun 2023 13:12:51 -0700 (PDT)
From: Bart Van Assche <bvanassche@acm.org>
To: Jens Axboe <axboe@kernel.dk>
Date: Wed, 21 Jun 2023 13:12:34 -0700
Message-ID: <20230621201237.796902-8-bvanassche@acm.org>
In-Reply-To: <20230621201237.796902-1-bvanassche@acm.org>
References: <20230621201237.796902-1-bvanassche@acm.org>
MIME-Version: 1.0
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.7
Subject: [dm-devel] [PATCH v4 7/7] block: Inline blk_mq_{,
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
 Keith Busch <kbusch@kernel.org>, Alexander Gordeev <agordeev@linux.ibm.com>,
 "James E.J. Bottomley" <jejb@linux.ibm.com>, Christoph Hellwig <hch@lst.de>,
 Alasdair Kergon <agk@redhat.com>,
 =?UTF-8?q?Roger=20Pau=20Monn=C3=A9?= <roger.pau@citrix.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.6
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: acm.org
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Patch "block: Preserve the order of requeued requests" changed
blk_mq_kick_requeue_list() and blk_mq_delay_kick_requeue_list() into
blk_mq_run_hw_queues() and blk_mq_delay_run_hw_queues() calls
respectively. Inline blk_mq_{,delay_}kick_requeue_list() because these
functions are now too short to keep these as separate functions.

Acked-by: Vineeth Vijayan <vneethv@linux.ibm.com> [ for the s390 changes ]
Cc: Christoph Hellwig <hch@lst.de>
Cc: Damien Le Moal <dlemoal@kernel.org>
Cc: Ming Lei <ming.lei@redhat.com>
Cc: Mike Snitzer <snitzer@kernel.org>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 block/blk-flush.c            |  4 ++--
 block/blk-mq-debugfs.c       |  2 +-
 block/blk-mq.c               | 15 +--------------
 drivers/block/ublk_drv.c     |  6 +++---
 drivers/block/xen-blkfront.c |  1 -
 drivers/md/dm-rq.c           |  6 +++---
 drivers/nvme/host/core.c     |  2 +-
 drivers/s390/block/scm_blk.c |  2 +-
 drivers/scsi/scsi_lib.c      |  2 +-
 include/linux/blk-mq.h       |  2 --
 10 files changed, 13 insertions(+), 29 deletions(-)

diff --git a/block/blk-flush.c b/block/blk-flush.c
index 4bfb92f58aa9..157b86fd9ccb 100644
--- a/block/blk-flush.c
+++ b/block/blk-flush.c
@@ -192,7 +192,7 @@ static void blk_flush_complete_seq(struct request *rq,
 		spin_lock(&hctx->requeue_lock);
 		list_add_tail(&rq->queuelist, &hctx->flush_list);
 		spin_unlock(&hctx->requeue_lock);
-		blk_mq_kick_requeue_list(q);
+		blk_mq_run_hw_queues(q, true);
 		break;
 
 	case REQ_FSEQ_DONE:
@@ -354,7 +354,7 @@ static void blk_kick_flush(struct blk_mq_hw_ctx *hctx,
 	list_add_tail(&flush_rq->queuelist, &hctx->flush_list);
 	spin_unlock(&hctx->requeue_lock);
 
-	blk_mq_kick_requeue_list(q);
+	blk_mq_run_hw_queues(q, true);
 }
 
 static enum rq_end_io_ret mq_flush_data_end_io(struct request *rq,
diff --git a/block/blk-mq-debugfs.c b/block/blk-mq-debugfs.c
index 787bdff3cc64..76792ebab935 100644
--- a/block/blk-mq-debugfs.c
+++ b/block/blk-mq-debugfs.c
@@ -114,7 +114,7 @@ static ssize_t queue_state_write(void *data, const char __user *buf,
 	} else if (strcmp(op, "start") == 0) {
 		blk_mq_start_stopped_hw_queues(q, true);
 	} else if (strcmp(op, "kick") == 0) {
-		blk_mq_kick_requeue_list(q);
+		blk_mq_run_hw_queues(q, true);
 	} else {
 		pr_err("%s: unsupported operation '%s'\n", __func__, op);
 inval:
diff --git a/block/blk-mq.c b/block/blk-mq.c
index de39984d17c4..12fd8b65b930 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -1436,7 +1436,7 @@ void blk_mq_requeue_request(struct request *rq, bool kick_requeue_list)
 	spin_unlock_irqrestore(&hctx->requeue_lock, flags);
 
 	if (kick_requeue_list)
-		blk_mq_kick_requeue_list(q);
+		blk_mq_run_hw_queues(q, true);
 }
 EXPORT_SYMBOL(blk_mq_requeue_request);
 
@@ -1473,19 +1473,6 @@ static void blk_mq_process_requeue_list(struct blk_mq_hw_ctx *hctx)
 	}
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
diff --git a/drivers/block/ublk_drv.c b/drivers/block/ublk_drv.c
index 1c823750c95a..cddbbdc9b199 100644
--- a/drivers/block/ublk_drv.c
+++ b/drivers/block/ublk_drv.c
@@ -902,7 +902,7 @@ static inline void __ublk_rq_task_work(struct request *req,
 		 */
 		if (unlikely(!mapped_bytes)) {
 			blk_mq_requeue_request(req, false);
-			blk_mq_delay_kick_requeue_list(req->q,
+			blk_mq_delay_run_hw_queues(req->q,
 					UBLK_REQUEUE_DELAY_MS);
 			return;
 		}
@@ -1297,7 +1297,7 @@ static void ublk_unquiesce_dev(struct ublk_device *ub)
 
 	blk_mq_unquiesce_queue(ub->ub_disk->queue);
 	/* We may have requeued some rqs in ublk_quiesce_queue() */
-	blk_mq_kick_requeue_list(ub->ub_disk->queue);
+	blk_mq_run_hw_queues(ub->ub_disk->queue, true);
 }
 
 static void ublk_stop_dev(struct ublk_device *ub)
@@ -2341,7 +2341,7 @@ static int ublk_ctrl_end_recovery(struct ublk_device *ub,
 	blk_mq_unquiesce_queue(ub->ub_disk->queue);
 	pr_devel("%s: queue unquiesced, dev id %d.\n",
 			__func__, header->dev_id);
-	blk_mq_kick_requeue_list(ub->ub_disk->queue);
+	blk_mq_run_hw_queues(ub->ub_disk->queue, true);
 	ub->dev_info.state = UBLK_S_DEV_LIVE;
 	schedule_delayed_work(&ub->monitor_work, UBLK_DAEMON_MONITOR_PERIOD);
 	ret = 0;
diff --git a/drivers/block/xen-blkfront.c b/drivers/block/xen-blkfront.c
index 52e74adbaad6..b8ac217c92b6 100644
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
index f5dd6d8c7e1d..9b923d52e41c 100644
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
index 0226c9279cef..2aa3c147e12f 100644
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
index b919de53dc28..80761e7c4ea5 100644
--- a/include/linux/blk-mq.h
+++ b/include/linux/blk-mq.h
@@ -871,8 +871,6 @@ static inline bool blk_mq_add_to_batch(struct request *req,
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


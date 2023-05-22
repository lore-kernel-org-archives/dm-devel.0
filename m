Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5BF54C7EE2A
	for <dm-devel@archiver.kernel.org>; Mon, 22 May 2023 18:39:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1684780770;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=PGXzxAoiby3176lSlRrJ1BB5G1/h4KEPuDs3+k7wD6A=;
	b=XV2hF3Xm0E88Zs0tUZbZNH5nAP1+K5nPKDPmX7RXpd0y/3NcK2oxzdELyn4lruSbwlK+lc
	VQ65oOKm8yVPDdAjUEMsP0ZYLOKUj3nB2rG1+ZZghAsLYV5nh9LF1Q1DfyRLr4TgsCzOQq
	lVh0oiyMeYn8sfio7KWq4fbXAywSfMg=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-13-VkE1OYRXN7aGDsqA05TvYw-1; Mon, 22 May 2023 14:39:27 -0400
X-MC-Unique: VkE1OYRXN7aGDsqA05TvYw-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 5BFF5801224;
	Mon, 22 May 2023 18:39:23 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 9DAFD2166B25;
	Mon, 22 May 2023 18:39:22 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 4912019465A8;
	Mon, 22 May 2023 18:39:22 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com
 [10.11.54.1])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id C5DF01946595
 for <dm-devel@listman.corp.redhat.com>; Mon, 22 May 2023 18:39:20 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id A8CFB405D4AC; Mon, 22 May 2023 18:39:20 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast07.extmail.prod.ext.rdu2.redhat.com [10.11.55.23])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 9D31F405D4A5
 for <dm-devel@redhat.com>; Mon, 22 May 2023 18:39:20 +0000 (UTC)
Received: from us-smtp-inbound-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 797DA3C02B7D
 for <dm-devel@redhat.com>; Mon, 22 May 2023 18:39:20 +0000 (UTC)
Received: from mail-pj1-f41.google.com (mail-pj1-f41.google.com
 [209.85.216.41]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-274-m_H2f02NNTqWUJWPNzDkrQ-1; Mon, 22 May 2023 14:39:18 -0400
X-MC-Unique: m_H2f02NNTqWUJWPNzDkrQ-1
Received: by mail-pj1-f41.google.com with SMTP id
 98e67ed59e1d1-25355609a04so4855399a91.0; 
 Mon, 22 May 2023 11:39:17 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20221208; t=1684780756; x=1687372756;
 h=content-transfer-encoding:mime-version:references:in-reply-to
 :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
 :subject:date:message-id:reply-to;
 bh=eWxgWNnKgm5KG0jN8kGjy/OofTMJ6svxGrxL31gZyHs=;
 b=lwHRAMIosGx6p1+0NB79sFk3Nw44PCN5qESt2glbLnQfDyBO0OfVUtlhKiTNXFnpmu
 atwVf96swGue4BTBnQDvmqaXdibRgILk+owl/c/n62dW2UNsGRHDhEkZDQjK9G21pFly
 IIYlxroWP8WoY04DPVWeBpcxyUbHMb9+MKwTjn7QmvaFekTMIfMFvejVqIS8NhKS+jGS
 iSTupoEVzTtNcmcISKVfp+YQehwRM8H41KKjr4fLD4i+aKgSgJmytCHOZ4WJZ/7fxKkM
 reB6uyQ1XYuPTmORFvy0XS+QTNwNZfLFFqTVA81AHPThZ6FM1CrGgJweYjYDFNyc0qyI
 aWdA==
X-Gm-Message-State: AC+VfDxPzWzvrpzXd3vOPVTFsshBWeBh2jolI5zSprImbAqQ67vy4/SR
 B7FXQEbEBxqb0y4lPRKEl78=
X-Google-Smtp-Source: ACHHUZ6z/g9p0NV520TyAsWdJ9HWycolZkWSEwE/RpWObBsF2OG2R2mR47ItJvW8y966M50G7eZyaA==
X-Received: by 2002:a17:90a:440f:b0:24e:5a5a:1050 with SMTP id
 s15-20020a17090a440f00b0024e5a5a1050mr10647892pjg.24.1684780756033; 
 Mon, 22 May 2023 11:39:16 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com
 ([2620:15c:211:201:642f:e57f:85fb:3794])
 by smtp.gmail.com with ESMTPSA id
 d61-20020a17090a6f4300b0024dfbac9e2fsm6710335pjk.21.2023.05.22.11.39.15
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Mon, 22 May 2023 11:39:15 -0700 (PDT)
From: Bart Van Assche <bvanassche@acm.org>
To: Jens Axboe <axboe@kernel.dk>
Date: Mon, 22 May 2023 11:38:41 -0700
Message-ID: <20230522183845.354920-7-bvanassche@acm.org>
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
Subject: [dm-devel] [PATCH v3 6/7] dm: Inline __dm_mq_kick_requeue_list()
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
Cc: Bart Van Assche <bvanassche@acm.org>, Mike Snitzer <snitzer@kernel.org>,
 Ming Lei <ming.lei@redhat.com>, linux-block@vger.kernel.org,
 dm-devel@redhat.com, Damien Le Moal <dlemoal@kernel.org>,
 Jaegeuk Kim <jaegeuk@kernel.org>, Christoph Hellwig <hch@lst.de>,
 Alasdair Kergon <agk@redhat.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.6
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: acm.org
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Since commit 52d7f1b5c2f3 ("blk-mq: Avoid that requeueing starts stopped
queues") the function __dm_mq_kick_requeue_list() is too short to keep it
as a separate function. Hence, inline this function.

Cc: Christoph Hellwig <hch@lst.de>
Cc: Damien Le Moal <dlemoal@kernel.org>
Cc: Ming Lei <ming.lei@redhat.com>
Cc: Mike Snitzer <snitzer@kernel.org>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/md/dm-rq.c | 9 ++-------
 1 file changed, 2 insertions(+), 7 deletions(-)

diff --git a/drivers/md/dm-rq.c b/drivers/md/dm-rq.c
index f7e9a3632eb3..bbe1e2ea0aa4 100644
--- a/drivers/md/dm-rq.c
+++ b/drivers/md/dm-rq.c
@@ -168,21 +168,16 @@ static void dm_end_request(struct request *clone, blk_status_t error)
 	rq_completed(md);
 }
 
-static void __dm_mq_kick_requeue_list(struct request_queue *q, unsigned long msecs)
-{
-	blk_mq_delay_kick_requeue_list(q, msecs);
-}
-
 void dm_mq_kick_requeue_list(struct mapped_device *md)
 {
-	__dm_mq_kick_requeue_list(md->queue, 0);
+	blk_mq_kick_requeue_list(md->queue);
 }
 EXPORT_SYMBOL(dm_mq_kick_requeue_list);
 
 static void dm_mq_delay_requeue_request(struct request *rq, unsigned long msecs)
 {
 	blk_mq_requeue_request(rq, false);
-	__dm_mq_kick_requeue_list(rq->q, msecs);
+	blk_mq_delay_kick_requeue_list(rq->q, msecs);
 }
 
 static void dm_requeue_original_request(struct dm_rq_target_io *tio, bool delay_requeue)

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel


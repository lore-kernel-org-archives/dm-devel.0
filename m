Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2D266EB64D7
	for <dm-devel@archiver.kernel.org>; Wed, 21 Jun 2023 20:14:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1687378440;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=BWo1jlb8VpfAWYYFLk6iAyA3X41KcZpgIex/7Sn1Fuo=;
	b=DWS6DCQiqJQoA+ZevpsKHaFGkW2Rv/FRfp5qUK2NRoTYXbVbbIrb4Zc25MqE76IRddfa3g
	CDbpWFiNzcTDyjw04hqXvys7pj3gm0EUCZFETvF27jSGG5PnEUmRxHbFL4Ryqms4b9jXfl
	mPuoAu+25eI+3MBsdJiJ5lA7nEmO0E8=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-654-BblN3rx2PWOODxsAIeY-SQ-1; Wed, 21 Jun 2023 16:13:51 -0400
X-MC-Unique: BblN3rx2PWOODxsAIeY-SQ-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id E5F4A3C11A03;
	Wed, 21 Jun 2023 20:13:02 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id D03AF1400C34;
	Wed, 21 Jun 2023 20:12:58 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id AD8B41946587;
	Wed, 21 Jun 2023 20:12:58 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
 [10.11.54.4])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id EDB881946586
 for <dm-devel@listman.corp.redhat.com>; Wed, 21 Jun 2023 20:12:57 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 98E64200C0DA; Wed, 21 Jun 2023 20:12:57 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 90DD0200BA8B
 for <dm-devel@redhat.com>; Wed, 21 Jun 2023 20:12:57 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 579FC1008133
 for <dm-devel@redhat.com>; Wed, 21 Jun 2023 20:12:57 +0000 (UTC)
Received: from mail-pf1-f174.google.com (mail-pf1-f174.google.com
 [209.85.210.174]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-471-qggLWgAYNHyENqxRHcCyfQ-1; Wed, 21 Jun 2023 16:12:53 -0400
X-MC-Unique: qggLWgAYNHyENqxRHcCyfQ-1
Received: by mail-pf1-f174.google.com with SMTP id
 d2e1a72fcca58-6685421cdb3so3123565b3a.1; 
 Wed, 21 Jun 2023 13:12:51 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20221208; t=1687378370; x=1689970370;
 h=content-transfer-encoding:mime-version:references:in-reply-to
 :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
 :subject:date:message-id:reply-to;
 bh=9egdE7ADXBdyCn1MfDmsbP3NYuKmHDjGrIkLbUr7D9s=;
 b=AwTy9jsISaq6vzlzl/ZNWOlAen1UsniWHNO/aHgEClHHm0ulFhtuKwNxQkvm2rPgGj
 hGHfsdDf5sPvPS2CWZM5uenuPAYGKrjdjPBt/HY1qD8XcG1ZaGwtr00r5S7J6yVPqfl9
 bbOiYUqDsAiLCjkvlqkY1q/1IeHJYFgi79AuRWgWzyUcn8Z0LxtJpi5WfxsdWXK41aUu
 fmx7qw/9GNYhvN4zJ7HCe8EDIQ6RIPU4Y7CdLw7r5c0a1s9Xg3pes78qTe6qxrJO45fC
 9Qq/5p9BdbvNfe3vq9jcM6Nt4IyYiKvFcJYQ6qxNlvNr2V0Ku+GKNG9CKjo5OmIiIu7C
 lOFA==
X-Gm-Message-State: AC+VfDystZu2I2jhemy2o/OfclD1Z6nPDZItS7JjzIjqAqdi+zG3Y9T1
 DXUQJs8QGKRSA0Y8iv7NGlA=
X-Google-Smtp-Source: ACHHUZ58VIv6oBQpGHfPwpjGWHF1tvERBQ1O8qQ5/vYjZaNgGqT1B3VswMLwPnWzNnEr+t5Rm8SaIg==
X-Received: by 2002:a05:6a20:1585:b0:122:470:377c with SMTP id
 h5-20020a056a20158500b001220470377cmr11764933pzj.2.1687378370050; 
 Wed, 21 Jun 2023 13:12:50 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com
 ([2620:15c:211:201:c0b7:6a6f:751b:b854])
 by smtp.gmail.com with ESMTPSA id
 h8-20020a63df48000000b00548fb73874asm3522983pgj.37.2023.06.21.13.12.49
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Wed, 21 Jun 2023 13:12:49 -0700 (PDT)
From: Bart Van Assche <bvanassche@acm.org>
To: Jens Axboe <axboe@kernel.dk>
Date: Wed, 21 Jun 2023 13:12:33 -0700
Message-ID: <20230621201237.796902-7-bvanassche@acm.org>
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
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.4
Subject: [dm-devel] [PATCH v4 6/7] dm: Inline __dm_mq_kick_requeue_list()
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
 Christoph Hellwig <hch@lst.de>, Alasdair Kergon <agk@redhat.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.7
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: acm.org
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Since commit 52d7f1b5c2f3 ("blk-mq: Avoid that requeueing starts stopped
queues") the function __dm_mq_kick_requeue_list() is too short to keep it
as a separate function. Hence, inline this function.

Reviewed-by: Christoph Hellwig <hch@lst.de>
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


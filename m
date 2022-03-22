Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 661DEC433FE
	for <dm-devel@archiver.kernel.org>; Tue, 22 Mar 2022 19:49:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1647978583;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=b/U+0ppxZk6cxNs8AgCdBq+BZWiVQz564thf7cjevsc=;
	b=Irpgc+AGZ7nqjNOM5TMHjF0nPM6q31C3ai2zRsD6hxudXDmjwuw2d1cKw4Ovdbm/eGDG7T
	XoUcGH/uZOWwVUmsb0MtFEz1a5xQ5i2hw2KsQpZwAkTofCLYqI3BdjmRCmJ5+KhiVXIG69
	tMNQki99Sf3m9afJro5xpoOSp1Z2lSo=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-629-17zFzUuxM1K4kfZjVrHlGA-1; Tue, 22 Mar 2022 15:49:39 -0400
X-MC-Unique: 17zFzUuxM1K4kfZjVrHlGA-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 6A1A53C18526;
	Tue, 22 Mar 2022 19:49:37 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 57FA31121330;
	Tue, 22 Mar 2022 19:49:37 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id DF8251940340;
	Tue, 22 Mar 2022 19:49:36 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com
 [10.11.54.7])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 193201949762
 for <dm-devel@listman.corp.redhat.com>; Tue, 22 Mar 2022 19:49:34 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id E618A140241B; Tue, 22 Mar 2022 19:49:33 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast08.extmail.prod.ext.rdu2.redhat.com [10.11.55.24])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id E2A3C141ADA5
 for <dm-devel@redhat.com>; Tue, 22 Mar 2022 19:49:33 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id CAF5C3820540
 for <dm-devel@redhat.com>; Tue, 22 Mar 2022 19:49:33 +0000 (UTC)
Received: from mail-qv1-f72.google.com (mail-qv1-f72.google.com
 [209.85.219.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-32-B985ArgfN-6Yu7_VG4nu0g-1; Tue, 22 Mar 2022 15:49:32 -0400
X-MC-Unique: B985ArgfN-6Yu7_VG4nu0g-1
Received: by mail-qv1-f72.google.com with SMTP id
 33-20020a0c8024000000b0043d17ffb0bdso14504229qva.18
 for <dm-devel@redhat.com>; Tue, 22 Mar 2022 12:49:32 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
 :in-reply-to:references;
 bh=3cVB5xGp5SZscTV0JpNErHCNRhdsu/xqDSO16/65Gk4=;
 b=mGo1fSpzKNRmP7a2xoPEffK/e/U3QxlR1GPR1f9Wq0XpUHJxpzyA06qqCx/Sh5lp5y
 VU5mA+xiUSUjnJtEyDYV3ojSimVN/NFYUWE6KpSvP36DlE+X+mN5HeryBmf94ja+OVWg
 imUatazNVbSIbzK3C0u4xHV0eH0BbMyfiD4tkQwR57oRIMVgTzP4VgrsPltLaviIKCo9
 qn7ji6gyD83A6p5uWIMYvZfo7FdbyNuGOKWKgg9sAj3Psvde8lW32mnhZY7+O+1ESFfP
 dqWlIOLBWzAlt0NqBG+kDSZHyXtBoO9JJAYWIIrcLfwUdCPs8GQZsKm6UP1Dx3uLujlR
 tpXQ==
X-Gm-Message-State: AOAM532qRuLhxIvtcsa+PpaentTX6s5aIFxcxZUnyh1FkgCf7T7OMDB2
 L9T5qMMi10RWGfoAI8zqhfOpTDR4rNZjbovIa4umJXig7RXq2E25PHVW6LerLSW9iAyhhqmZV9l
 ZIsqgzLgBgJlwpA==
X-Received: by 2002:a05:622a:134d:b0:2e2:2802:15ff with SMTP id
 w13-20020a05622a134d00b002e2280215ffmr2455238qtk.413.1647978571823; 
 Tue, 22 Mar 2022 12:49:31 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwC2IsFjp8HuwBZ0PkPpIAKSGVFZvigvzaUsqvzvIqB26eoTOji40/Opg7gasAyW4DiZ743TQ==
X-Received: by 2002:a05:622a:134d:b0:2e2:2802:15ff with SMTP id
 w13-20020a05622a134d00b002e2280215ffmr2455228qtk.413.1647978571575; 
 Tue, 22 Mar 2022 12:49:31 -0700 (PDT)
Received: from localhost (pool-68-160-176-52.bstnma.fios.verizon.net.
 [68.160.176.52]) by smtp.gmail.com with ESMTPSA id
 w1-20020ac857c1000000b002e1e899badesm14497446qta.72.2022.03.22.12.49.30
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Tue, 22 Mar 2022 12:49:31 -0700 (PDT)
From: Mike Snitzer <snitzer@redhat.com>
X-Google-Original-From: Mike Snitzer <snitzer@kernel.org>
To: axboe@kernel.dk
Date: Tue, 22 Mar 2022 15:49:26 -0400
Message-Id: <20220322194927.42778-3-snitzer@kernel.org>
In-Reply-To: <20220322194927.42778-1-snitzer@kernel.org>
References: <20220322194927.42778-1-snitzer@kernel.org>
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.7
Subject: [dm-devel] [PATCH 2/3] dm: enable BIOSET_PERCPU_CACHE for dm_io
 bioset
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
Cc: linux-block@vger.kernel.org, dm-devel@redhat.com, hch@lst.de,
 ming.lei@redhat.com
MIME-Version: 1.0
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.3
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Also change dm_io_complete() to use bio_clear_polled() so that it
clears both REQ_POLLED and BIO_PERCPU_CACHE if the bio is requeued due
to BLK_STS_DM_REQUEUE.

Only io_uring benefits from using BIOSET_PERCPU_CACHE, it is only safe
to use in non-interrupt context but io_uring's completions are all in
process context.

This change improves DM's hipri bio polling performance by ~7%.

Signed-off-by: Mike Snitzer <snitzer@kernel.org>
---
 drivers/md/dm.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index a2e80c376827..06f3720a190b 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -899,9 +899,9 @@ static void dm_io_complete(struct dm_io *io)
 		/*
 		 * Upper layer won't help us poll split bio, io->orig_bio
 		 * may only reflect a subset of the pre-split original,
-		 * so clear REQ_POLLED in case of requeue
+		 * so clear REQ_POLLED and BIO_PERCPU_CACHE on requeue.
 		 */
-		bio->bi_opf &= ~REQ_POLLED;
+		bio_clear_polled(bio);
 		return;
 	}
 
@@ -3014,7 +3014,7 @@ struct dm_md_mempools *dm_alloc_md_mempools(struct mapped_device *md, enum dm_qu
 		pool_size = max(dm_get_reserved_bio_based_ios(), min_pool_size);
 		front_pad = roundup(per_io_data_size, __alignof__(struct dm_target_io)) + DM_TARGET_IO_BIO_OFFSET;
 		io_front_pad = roundup(per_io_data_size,  __alignof__(struct dm_io)) + DM_IO_BIO_OFFSET;
-		ret = bioset_init(&pools->io_bs, pool_size, io_front_pad, 0);
+		ret = bioset_init(&pools->io_bs, pool_size, io_front_pad, BIOSET_PERCPU_CACHE);
 		if (ret)
 			goto out;
 		if (integrity && bioset_integrity_create(&pools->io_bs, pool_size))
-- 
2.15.0

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel


Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7ED4DC43217
	for <dm-devel@archiver.kernel.org>; Wed, 23 Mar 2022 19:45:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1648064738;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=sMZvs+OFnQm0I5u4UQDD9LkSF5cS3O3CCJCl0QVIgCk=;
	b=V37MXshR2wfMLz5820CZ2Z2my1yWMkjsjTpPYZ64lbmEEWIY9L5Bt7M1oOEzFyluwJdqnK
	f/56dddESAVYqwbIz/XX10DosU7vwV3GtC/wHzBgXaXXximNu0JCwkV0INw7ijxtv2GWsX
	6HxkrzdFiEWhb9u6mt7UieHMmFSIXz4=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-275-eVhtYLIbN8aU8VHjpE0LSw-1; Wed, 23 Mar 2022 15:45:37 -0400
X-MC-Unique: eVhtYLIbN8aU8VHjpE0LSw-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 95EE938025F4;
	Wed, 23 Mar 2022 19:45:34 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 8404440CFD06;
	Wed, 23 Mar 2022 19:45:34 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 515DF194035C;
	Wed, 23 Mar 2022 19:45:34 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com
 [10.11.54.10])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 4F9311949763
 for <dm-devel@listman.corp.redhat.com>; Wed, 23 Mar 2022 19:45:33 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 14FF7401E7B; Wed, 23 Mar 2022 19:45:33 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast08.extmail.prod.ext.rdu2.redhat.com [10.11.55.24])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 10429401E4E
 for <dm-devel@redhat.com>; Wed, 23 Mar 2022 19:45:33 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D2E4B38025FD
 for <dm-devel@redhat.com>; Wed, 23 Mar 2022 19:45:32 +0000 (UTC)
Received: from mail-qv1-f69.google.com (mail-qv1-f69.google.com
 [209.85.219.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-68-fPYdTaxWNq6JQJp6ccpfTw-1; Wed, 23 Mar 2022 15:45:31 -0400
X-MC-Unique: fPYdTaxWNq6JQJp6ccpfTw-1
Received: by mail-qv1-f69.google.com with SMTP id
 33-20020a0c8024000000b0043d17ffb0bdso1998269qva.18
 for <dm-devel@redhat.com>; Wed, 23 Mar 2022 12:45:31 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
 :in-reply-to:references;
 bh=tfNH+5/HwjgUfw+cvmAnjvE/JE7439RWvRdUdw80No0=;
 b=aKoy57/XWp4+dCgyirU1WYuNCZ0AVrEM5NL65uQO7YdMsIS3toyfwB1ywcafdVFRXL
 93FanOvrr+aBvnK6TPCvzgYg66QMCQxYF+l5IvFyiCrsggAiAuk/J24f7jRUYHXhwmOI
 BEW6NSAXj0BKC4lN4uvo9GlUjrdQ2maQHfwiCpKDVMWE3h4d5girofSt37MdRQw9AmX2
 q6L0vE8gXE+DYmaNl9T3aTpiRKpH3R6O7+W4i1UHqvjMhFywj+IHX1yoY4C2peeoNCw0
 eQB9kOMFONlLoJsHqA4UhBdYrAOPJdUj8IstK2pEWQda5quOs42xyUh5Y20dxYd1jvV8
 u4ow==
X-Gm-Message-State: AOAM532l2KLJljKjzB4JABX5Brkgs9gC0bP4WKGaNRsRZYfkqiRxRRRL
 pVA98F5B8RNt4pHr3VgbqZ6bOn7WseDPQ4+RPEJRkcAGbl20G1ODJoyzF5sPYSvRctVgBhjGh1h
 Zqz4QsCYziLxhCg==
X-Received: by 2002:a37:64a:0:b0:67d:430e:2a20 with SMTP id
 71-20020a37064a000000b0067d430e2a20mr1067536qkg.265.1648064730572; 
 Wed, 23 Mar 2022 12:45:30 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzkwWOh6Well00wZWN3Pa0vtdo4r0dGuz4vGTky++LCnVcOeEJg91pOXt2yuaRFGau8p357xw==
X-Received: by 2002:a37:64a:0:b0:67d:430e:2a20 with SMTP id
 71-20020a37064a000000b0067d430e2a20mr1067522qkg.265.1648064730301; 
 Wed, 23 Mar 2022 12:45:30 -0700 (PDT)
Received: from localhost (pool-68-160-176-52.bstnma.fios.verizon.net.
 [68.160.176.52]) by smtp.gmail.com with ESMTPSA id
 o4-20020a05620a22c400b0067e02a697e0sm481848qki.33.2022.03.23.12.45.29
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Wed, 23 Mar 2022 12:45:29 -0700 (PDT)
From: Mike Snitzer <snitzer@redhat.com>
X-Google-Original-From: Mike Snitzer <snitzer@kernel.org>
To: axboe@kernel.dk
Date: Wed, 23 Mar 2022 15:45:23 -0400
Message-Id: <20220323194524.5900-4-snitzer@kernel.org>
In-Reply-To: <20220323194524.5900-1-snitzer@kernel.org>
References: <20220323194524.5900-1-snitzer@kernel.org>
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.10
Subject: [dm-devel] [PATCH v2 3/4] dm: enable BIOSET_PERCPU_CACHE for dm_io
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
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.1
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Also change dm_io_complete() to use bio_clear_polled() so that it
properly clears all associated bio state (REQ_POLLED, BIO_PERCPU_CACHE,
etc).

This commit improves DM's hipri bio polling (REQ_POLLED) perf by ~7%.

Signed-off-by: Mike Snitzer <snitzer@kernel.org>
---
 drivers/md/dm.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index 1c4d1e12d74b..b3cb2c1aea2a 100644
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
 
@@ -3016,7 +3016,7 @@ struct dm_md_mempools *dm_alloc_md_mempools(struct mapped_device *md, enum dm_qu
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


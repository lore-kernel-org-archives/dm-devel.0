Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3A2BBC433F5
	for <dm-devel@archiver.kernel.org>; Fri, 25 Mar 2022 07:27:29 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-152-0xVyJAnPPW6XZ71LN9G3Qw-1; Fri, 25 Mar 2022 03:27:24 -0400
X-MC-Unique: 0xVyJAnPPW6XZ71LN9G3Qw-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 55A6F899EC5;
	Fri, 25 Mar 2022 07:27:22 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 73264C27D8F;
	Fri, 25 Mar 2022 07:27:21 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 93258194035A;
	Fri, 25 Mar 2022 07:27:20 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com
 [10.11.54.8])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id E6DF0194034B
 for <dm-devel@listman.corp.redhat.com>; Thu, 24 Mar 2022 20:35:32 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id D7AEAC27D8D; Thu, 24 Mar 2022 20:35:32 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast08.extmail.prod.ext.rdu2.redhat.com [10.11.55.24])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id D4021C27D8A
 for <dm-devel@redhat.com>; Thu, 24 Mar 2022 20:35:32 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id B8C293802AD2
 for <dm-devel@redhat.com>; Thu, 24 Mar 2022 20:35:32 +0000 (UTC)
Received: from mail-qt1-f176.google.com (mail-qt1-f176.google.com
 [209.85.160.176]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-613-LxTx66YUMl-cOGymbT_lWQ-1; Thu, 24 Mar 2022 16:35:31 -0400
X-MC-Unique: LxTx66YUMl-cOGymbT_lWQ-1
Received: by mail-qt1-f176.google.com with SMTP id t19so4945833qtc.4
 for <dm-devel@redhat.com>; Thu, 24 Mar 2022 13:35:31 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
 :references;
 bh=dtKGQivDhkGsgWB7I0CubwUBOrK/SvKeob7r58iokR8=;
 b=y5mgU5QKdy16IGJmJcS8D+ZM6ts+zSb/0w9439WjKKNSBtttoapiErUyNV+og21UoF
 yokhOTi9W8BhReeW3+ok4BcJcTM5YCgEYsJc9uFe8rQcj8ZWew9dsgBuvRFsRw8tg9kx
 XbTyJM8NTrbNybx5pmFhndJRvhvFiK2L8Q7RtDGw0x5sGcBShJKAEp/DBVNLA2UnwOy5
 WiB092rtX0TlVweG4XOUtTI1Arb6EaLYei/YgWds8K32JGhR/v7gmCZZtd9EktqBynFT
 Xd00cZ1r7rpKuXNQqn7ual/xHLjFzkLL6BdFMMIjHf4h0O9JyoJovHvG2MGn175EHX51
 T/Fw==
X-Gm-Message-State: AOAM531HjHCX5gqPsVMoHrnmrs16OM8vvnKcyMgcCMhHdehxmHB/9sOj
 Krvlxsaik7bZFMERCXhE1vX1Mdz8tXeOKMo=
X-Google-Smtp-Source: ABdhPJzQ9W1d7krZRbk35jIeuKkkOV5bjpJV2+501iJSjml1aPEcHX8qWgNTa4kTu18M39ra1BzSXw==
X-Received: by 2002:ac8:5e13:0:b0:2e1:cd7e:a29e with SMTP id
 h19-20020ac85e13000000b002e1cd7ea29emr6090711qtx.31.1648154130521; 
 Thu, 24 Mar 2022 13:35:30 -0700 (PDT)
Received: from localhost (pool-68-160-176-52.bstnma.fios.verizon.net.
 [68.160.176.52]) by smtp.gmail.com with ESMTPSA id
 s21-20020a05620a16b500b0067b1205878esm2005527qkj.7.2022.03.24.13.35.29
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Thu, 24 Mar 2022 13:35:30 -0700 (PDT)
From: Mike Snitzer <snitzer@kernel.org>
To: axboe@kernel.dk
Date: Thu, 24 Mar 2022 16:35:25 -0400
Message-Id: <20220324203526.62306-3-snitzer@kernel.org>
In-Reply-To: <20220324203526.62306-1-snitzer@kernel.org>
References: <20220324203526.62306-1-snitzer@kernel.org>
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.8
X-Mailman-Approved-At: Fri, 25 Mar 2022 07:27:19 +0000
Subject: [dm-devel] [PATCH v3 2/3] block: allow use of per-cpu bio alloc
 cache by block drivers
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
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.8
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Refine per-cpu bio alloc cache interfaces so that DM and other block
drivers can properly create and use the cache:

DM uses bioset_init_from_src() to do its final bioset initialization,
so must update bioset_init_from_src() to set BIOSET_PERCPU_CACHE if
%src bioset has a cache.

Also move bio_clear_polled() to include/linux/bio.h to allow users
outside of block core.

Signed-off-by: Mike Snitzer <snitzer@kernel.org>
---
 block/bio.c         | 2 ++
 block/blk.h         | 6 ------
 include/linux/bio.h | 6 ++++++
 3 files changed, 8 insertions(+), 6 deletions(-)

diff --git a/block/bio.c b/block/bio.c
index 09b714469b06..859f728e42dc 100644
--- a/block/bio.c
+++ b/block/bio.c
@@ -1769,6 +1769,8 @@ int bioset_init_from_src(struct bio_set *bs, struct bio_set *src)
 		flags |= BIOSET_NEED_BVECS;
 	if (src->rescue_workqueue)
 		flags |= BIOSET_NEED_RESCUER;
+	if (src->cache)
+		flags |= BIOSET_PERCPU_CACHE;
 
 	return bioset_init(bs, src->bio_pool.min_nr, src->front_pad, flags);
 }
diff --git a/block/blk.h b/block/blk.h
index 9cb04f24ba8a..4f6b172c3342 100644
--- a/block/blk.h
+++ b/block/blk.h
@@ -451,12 +451,6 @@ extern struct device_attribute dev_attr_events;
 extern struct device_attribute dev_attr_events_async;
 extern struct device_attribute dev_attr_events_poll_msecs;
 
-static inline void bio_clear_polled(struct bio *bio)
-{
-	/* can't support alloc cache if we turn off polling */
-	bio->bi_opf &= ~(REQ_POLLED | REQ_ALLOC_CACHE);
-}
-
 long blkdev_ioctl(struct file *file, unsigned cmd, unsigned long arg);
 long compat_blkdev_ioctl(struct file *file, unsigned cmd, unsigned long arg);
 
diff --git a/include/linux/bio.h b/include/linux/bio.h
index 10406f57d339..a40a4ba2771f 100644
--- a/include/linux/bio.h
+++ b/include/linux/bio.h
@@ -783,6 +783,12 @@ static inline void bio_set_polled(struct bio *bio, struct kiocb *kiocb)
 		bio->bi_opf |= REQ_NOWAIT;
 }
 
+static inline void bio_clear_polled(struct bio *bio)
+{
+	/* can't support alloc cache if we turn off polling */
+	bio->bi_opf &= ~(REQ_POLLED | REQ_ALLOC_CACHE);
+}
+
 struct bio *blk_next_bio(struct bio *bio, struct block_device *bdev,
 		unsigned int nr_pages, unsigned int opf, gfp_t gfp);
 
-- 
2.15.0

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel


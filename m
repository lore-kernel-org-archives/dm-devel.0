Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5DC7EC433F5
	for <dm-devel@archiver.kernel.org>; Tue, 22 Mar 2022 19:49:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1647978583;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=7aSb5UdZT14jder4H7DeW9Aga4yEpxgkn1CRem7iqAA=;
	b=M392y73mXHCFe17+butxsMmh9hvq32WuKPtjr4EXZB9kGg7hFXI7+Ff62mS3RHxYH/eVe3
	glM2C0hjpfc5bOUT4JUEFjcho/Tj84DvXu9Y9ZgG/XPIu/KFRr1/HQeXNOS0lyh6uM6GBm
	AdvKW4dZ4N0zkCpLrnnEFwPT95nXAz8=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-665-RPNP4BvLPLW22ImfyQXvTg-1; Tue, 22 Mar 2022 15:49:39 -0400
X-MC-Unique: RPNP4BvLPLW22ImfyQXvTg-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 85363866DF4;
	Tue, 22 Mar 2022 19:49:36 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 0BA082166B2D;
	Tue, 22 Mar 2022 19:49:35 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id A5C851940340;
	Tue, 22 Mar 2022 19:49:34 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com
 [10.11.54.7])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 474D51949762
 for <dm-devel@listman.corp.redhat.com>; Tue, 22 Mar 2022 19:49:33 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 34B13141ADA5; Tue, 22 Mar 2022 19:49:33 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 30F601417201
 for <dm-devel@redhat.com>; Tue, 22 Mar 2022 19:49:33 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id CADF5811E75
 for <dm-devel@redhat.com>; Tue, 22 Mar 2022 19:49:32 +0000 (UTC)
Received: from mail-qv1-f71.google.com (mail-qv1-f71.google.com
 [209.85.219.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-157-_2c1HxeqNAO31k7qguGxsw-1; Tue, 22 Mar 2022 15:49:31 -0400
X-MC-Unique: _2c1HxeqNAO31k7qguGxsw-1
Received: by mail-qv1-f71.google.com with SMTP id
 x16-20020a0ce250000000b00432ec6eaf85so14506700qvl.15
 for <dm-devel@redhat.com>; Tue, 22 Mar 2022 12:49:31 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
 :in-reply-to:references;
 bh=1NTHYZkzBmaMh1ItKjSkJntcIn8iIb3p4X2tzJvZIko=;
 b=DY6UojIcwPyHIIyNzMJiMZ9hkggDB1Iyq5tjC2nfqJinW9nzzX6yxr4A1ROMWlXPg4
 KZ9uFjA4AR4LzanraOd38T0Dp272HWopfjAQAxJxmKVsBpxtLLaHzYM+N+/+1YYPfQEg
 /5l//eE6BEIPqrWQZNY4C4Ezk8fqankO1GaoJvWzJj3pDPsvO+TdGKozE5f8HQJOAVYN
 Nyi8kcOJ7MxyQsAE6uqgCqN6x7dDmjxJ1nvFuEvltwRZE2Rt5hLCd100wC1LQ4vnotyH
 R3+a4x90RlANODsL14THkCXo7ptf+jfG4xoeCCwQ/0Fcns5Rcv+bZnwFLCssOiTYAmpY
 3GDw==
X-Gm-Message-State: AOAM530olE62oR7dgR3kUwH1v5nQXSRZo7QR/GvKlPRBhFPWs2EORCh/
 eddVD0Hw4andXZXq0spskHO1ugUOmLTM2ZAlSakL1fX53HrxbW29FQxR98MwFDNJn94rjeCi28l
 NOpMWKWZxHNxYnw==
X-Received: by 2002:a37:a842:0:b0:67b:305c:6c8a with SMTP id
 r63-20020a37a842000000b0067b305c6c8amr16313061qke.225.1647978570440; 
 Tue, 22 Mar 2022 12:49:30 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzvYHkXfWn6Fvg9HfMKpOQHdAfRhM9jz9XzPB3xppVu7owmXOq3fC0UGbNmng59cIfiD90P1A==
X-Received: by 2002:a37:a842:0:b0:67b:305c:6c8a with SMTP id
 r63-20020a37a842000000b0067b305c6c8amr16313048qke.225.1647978570122; 
 Tue, 22 Mar 2022 12:49:30 -0700 (PDT)
Received: from localhost (pool-68-160-176-52.bstnma.fios.verizon.net.
 [68.160.176.52]) by smtp.gmail.com with ESMTPSA id
 q8-20020a05622a030800b002e1c9304db8sm14480140qtw.38.2022.03.22.12.49.29
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Tue, 22 Mar 2022 12:49:29 -0700 (PDT)
From: Mike Snitzer <snitzer@redhat.com>
X-Google-Original-From: Mike Snitzer <snitzer@kernel.org>
To: axboe@kernel.dk
Date: Tue, 22 Mar 2022 15:49:25 -0400
Message-Id: <20220322194927.42778-2-snitzer@kernel.org>
In-Reply-To: <20220322194927.42778-1-snitzer@kernel.org>
References: <20220322194927.42778-1-snitzer@kernel.org>
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.7
Subject: [dm-devel] [PATCH 1/3] block: allow BIOSET_PERCPU_CACHE use from
 bio_alloc_clone
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
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.6
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

These changes allow DM core to make full use of BIOSET_PERCPU_CACHE:

Factor out bio_alloc_percpu_cache() from bio_alloc_kiocb() to allow
use by bio_alloc_clone() too.

Update bioset_init_from_src() to set BIOSET_PERCPU_CACHE if
bio_src->cache is not NULL.

Move bio_clear_polled() to include/linux/bio.h to allow users outside
of block core.

Signed-off-by: Mike Snitzer <snitzer@kernel.org>
---
 block/bio.c         | 56 +++++++++++++++++++++++++++++++++--------------------
 block/blk.h         |  7 -------
 include/linux/bio.h |  7 +++++++
 3 files changed, 42 insertions(+), 28 deletions(-)

diff --git a/block/bio.c b/block/bio.c
index b15f5466ce08..2c3a1f678461 100644
--- a/block/bio.c
+++ b/block/bio.c
@@ -728,6 +728,33 @@ void bio_put(struct bio *bio)
 }
 EXPORT_SYMBOL(bio_put);
 
+static struct bio *bio_alloc_percpu_cache(struct block_device *bdev,
+		unsigned short nr_vecs, unsigned int opf, gfp_t gfp,
+		struct bio_set *bs)
+{
+	struct bio_alloc_cache *cache;
+	struct bio *bio;
+
+	cache = per_cpu_ptr(bs->cache, get_cpu());
+	if (cache->free_list) {
+		bio = cache->free_list;
+		cache->free_list = bio->bi_next;
+		cache->nr--;
+		put_cpu();
+		bio_init(bio, bdev, nr_vecs ? bio->bi_inline_vecs : NULL,
+			 nr_vecs, opf);
+		bio->bi_pool = bs;
+		bio_set_flag(bio, BIO_PERCPU_CACHE);
+		return bio;
+	}
+	put_cpu();
+	bio = bio_alloc_bioset(bdev, nr_vecs, opf, gfp, bs);
+	if (!bio)
+		return NULL;
+	bio_set_flag(bio, BIO_PERCPU_CACHE);
+	return bio;
+}
+
 static int __bio_clone(struct bio *bio, struct bio *bio_src, gfp_t gfp)
 {
 	bio_set_flag(bio, BIO_CLONED);
@@ -768,7 +795,10 @@ struct bio *bio_alloc_clone(struct block_device *bdev, struct bio *bio_src,
 {
 	struct bio *bio;
 
-	bio = bio_alloc_bioset(bdev, 0, bio_src->bi_opf, gfp, bs);
+	if (bs->cache && bio_src->bi_opf & REQ_POLLED)
+		bio = bio_alloc_percpu_cache(bdev, 0, bio_src->bi_opf, gfp, bs);
+	else
+		bio = bio_alloc_bioset(bdev, 0, bio_src->bi_opf, gfp, bs);
 	if (!bio)
 		return NULL;
 
@@ -1736,6 +1766,8 @@ int bioset_init_from_src(struct bio_set *bs, struct bio_set *src)
 		flags |= BIOSET_NEED_BVECS;
 	if (src->rescue_workqueue)
 		flags |= BIOSET_NEED_RESCUER;
+	if (src->cache)
+		flags |= BIOSET_PERCPU_CACHE;
 
 	return bioset_init(bs, src->bio_pool.min_nr, src->front_pad, flags);
 }
@@ -1753,35 +1785,17 @@ EXPORT_SYMBOL(bioset_init_from_src);
  *    Like @bio_alloc_bioset, but pass in the kiocb. The kiocb is only
  *    used to check if we should dip into the per-cpu bio_set allocation
  *    cache. The allocation uses GFP_KERNEL internally. On return, the
- *    bio is marked BIO_PERCPU_CACHEABLE, and the final put of the bio
+ *    bio is marked BIO_PERCPU_CACHE, and the final put of the bio
  *    MUST be done from process context, not hard/soft IRQ.
  *
  */
 struct bio *bio_alloc_kiocb(struct kiocb *kiocb, struct block_device *bdev,
 		unsigned short nr_vecs, unsigned int opf, struct bio_set *bs)
 {
-	struct bio_alloc_cache *cache;
-	struct bio *bio;
-
 	if (!(kiocb->ki_flags & IOCB_ALLOC_CACHE) || nr_vecs > BIO_INLINE_VECS)
 		return bio_alloc_bioset(bdev, nr_vecs, opf, GFP_KERNEL, bs);
 
-	cache = per_cpu_ptr(bs->cache, get_cpu());
-	if (cache->free_list) {
-		bio = cache->free_list;
-		cache->free_list = bio->bi_next;
-		cache->nr--;
-		put_cpu();
-		bio_init(bio, bdev, nr_vecs ? bio->bi_inline_vecs : NULL,
-			 nr_vecs, opf);
-		bio->bi_pool = bs;
-		bio_set_flag(bio, BIO_PERCPU_CACHE);
-		return bio;
-	}
-	put_cpu();
-	bio = bio_alloc_bioset(bdev, nr_vecs, opf, GFP_KERNEL, bs);
-	bio_set_flag(bio, BIO_PERCPU_CACHE);
-	return bio;
+	return bio_alloc_percpu_cache(bdev, nr_vecs, opf, GFP_KERNEL, bs);
 }
 EXPORT_SYMBOL_GPL(bio_alloc_kiocb);
 
diff --git a/block/blk.h b/block/blk.h
index ebaa59ca46ca..8e338e76d303 100644
--- a/block/blk.h
+++ b/block/blk.h
@@ -451,13 +451,6 @@ extern struct device_attribute dev_attr_events;
 extern struct device_attribute dev_attr_events_async;
 extern struct device_attribute dev_attr_events_poll_msecs;
 
-static inline void bio_clear_polled(struct bio *bio)
-{
-	/* can't support alloc cache if we turn off polling */
-	bio_clear_flag(bio, BIO_PERCPU_CACHE);
-	bio->bi_opf &= ~REQ_POLLED;
-}
-
 long blkdev_ioctl(struct file *file, unsigned cmd, unsigned long arg);
 long compat_blkdev_ioctl(struct file *file, unsigned cmd, unsigned long arg);
 
diff --git a/include/linux/bio.h b/include/linux/bio.h
index 7523aba4ddf7..709663ae757a 100644
--- a/include/linux/bio.h
+++ b/include/linux/bio.h
@@ -787,6 +787,13 @@ static inline void bio_set_polled(struct bio *bio, struct kiocb *kiocb)
 		bio->bi_opf |= REQ_NOWAIT;
 }
 
+static inline void bio_clear_polled(struct bio *bio)
+{
+	/* can't support alloc cache if we turn off polling */
+	bio_clear_flag(bio, BIO_PERCPU_CACHE);
+	bio->bi_opf &= ~REQ_POLLED;
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


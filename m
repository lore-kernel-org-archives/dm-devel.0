Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CC61AC433F5
	for <dm-devel@archiver.kernel.org>; Wed, 23 Mar 2022 19:45:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1648064737;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=dBDXL6EoW//Q4JJ5QU19xDRe+K4qLmsxIV2pEtzSGnw=;
	b=HfRRVluRZ3A9nwREQpZNVAHkmG+zEaSlIf3PZhl9wehclzvqDDUEr09a7fpn0XNrpnTWee
	ela5nbB72TIA7GlHJsm9oCphTIldSzUkmKaYpYu0WFvyEaMFa7effi3fUwhpUnuEmuVfVN
	Mp+E/zkQN5zCchNGgmV+t4cWOJU+5QM=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-214-P5YlSLNIMT6AdjIgrsOiJg-1; Wed, 23 Mar 2022 15:45:34 -0400
X-MC-Unique: P5YlSLNIMT6AdjIgrsOiJg-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 4C9FA299E74B;
	Wed, 23 Mar 2022 19:45:32 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 3AFB85721A1;
	Wed, 23 Mar 2022 19:45:32 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 056C61940347;
	Wed, 23 Mar 2022 19:45:32 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com
 [10.11.54.2])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 185541949763
 for <dm-devel@listman.corp.redhat.com>; Wed, 23 Mar 2022 19:45:31 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 059634010A01; Wed, 23 Mar 2022 19:45:31 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 0079D400E420
 for <dm-devel@redhat.com>; Wed, 23 Mar 2022 19:45:30 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id DA94C811E76
 for <dm-devel@redhat.com>; Wed, 23 Mar 2022 19:45:30 +0000 (UTC)
Received: from mail-qk1-f199.google.com (mail-qk1-f199.google.com
 [209.85.222.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-668-xwOwnngeMkiVazTmWlGcgg-1; Wed, 23 Mar 2022 15:45:29 -0400
X-MC-Unique: xwOwnngeMkiVazTmWlGcgg-1
Received: by mail-qk1-f199.google.com with SMTP id
 w200-20020a3762d1000000b0067d2149318dso1702068qkb.1
 for <dm-devel@redhat.com>; Wed, 23 Mar 2022 12:45:29 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
 :in-reply-to:references;
 bh=ewXCoGrLUptePB/yghi1giztCZDIQfZAZPwz3EjuzAI=;
 b=wzIfwnLQBgLdSLDOadXSBTcc2bb2EjN+PWH21MbWsFpTmviHAEVdmRoBGrfEHTdtyb
 TXI/nQn+ndx4oICESsyEOZVmjbwJDkY77ExntDcsM4BvU+S4AGpFu7pnKhb8dckvy/XF
 aL0xkAlt+KULsDvwlrS/d58CWzEzuV3ovLfdjT2667NgLQUQe2Glf6+Ry5oILZtxaeXh
 p9PxqneEYAjbDNKB6tA0R8zHyt5MHE+mzEyy+MbcAOTX9qXfx1k2Owhikrh6lYT3Xa1R
 uktdAHS/E5PqFyJxWiBQrsEzekUysURILQOe2QXv/vE/sAzWcOXeZyxdwkSa8PaDbN/i
 7s4Q==
X-Gm-Message-State: AOAM531Fy26TXd+/+0+QzcmOsUmsMZll7Ckd0/WCMql4XP9PfqSLNiJ2
 1csTuwtGT0p5ysymAjRj65tR4wRfWzZ1gNtJFHiQDSvIOGdMMVmmgwOJ/BT/pNsStXYEYgzWyB+
 6TRuO2wgjQzNBhg==
X-Received: by 2002:ac8:7fcc:0:b0:2e0:684e:42cc with SMTP id
 b12-20020ac87fcc000000b002e0684e42ccmr1353712qtk.35.1648064729117; 
 Wed, 23 Mar 2022 12:45:29 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzRo/E6Via9iAEdkuG26l/B0IpzCO611anBQnTlTq6VFsvjqWDfBgpNUyUNJkJuIgGuIsZXHA==
X-Received: by 2002:ac8:7fcc:0:b0:2e0:684e:42cc with SMTP id
 b12-20020ac87fcc000000b002e0684e42ccmr1353698qtk.35.1648064728862; 
 Wed, 23 Mar 2022 12:45:28 -0700 (PDT)
Received: from localhost (pool-68-160-176-52.bstnma.fios.verizon.net.
 [68.160.176.52]) by smtp.gmail.com with ESMTPSA id
 h62-20020a37b741000000b0067da4164f8fsm425972qkf.126.2022.03.23.12.45.27
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Wed, 23 Mar 2022 12:45:28 -0700 (PDT)
From: Mike Snitzer <snitzer@redhat.com>
X-Google-Original-From: Mike Snitzer <snitzer@kernel.org>
To: axboe@kernel.dk
Date: Wed, 23 Mar 2022 15:45:22 -0400
Message-Id: <20220323194524.5900-3-snitzer@kernel.org>
In-Reply-To: <20220323194524.5900-1-snitzer@kernel.org>
References: <20220323194524.5900-1-snitzer@kernel.org>
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.2
Subject: [dm-devel] [PATCH v2 2/4] block: allow BIOSET_PERCPU_CACHE use from
 bio_alloc_bioset
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
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.9
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Add REQ_ALLOC_CACHE and set it in %opf passed to bio_alloc_bioset to
inform bio_alloc_bioset (and any stacked block drivers) that bio should
be allocated from respective bioset's per-cpu alloc cache if possible.

This decouples access control to the alloc cache (via REQ_ALLOC_CACHE)
from actual participation in a specific alloc cache (BIO_PERCPU_CACHE).
Otherwise an upper layer's bioset may not have an alloc cache, in which
case the bio issued to underlying device(s) wouldn't reflect that
allocating from an alloc cache warranted (if possible).

Signed-off-by: Mike Snitzer <snitzer@kernel.org>
---
 block/bio.c               | 33 ++++++++++++++++++++-------------
 include/linux/bio.h       |  4 +++-
 include/linux/blk_types.h |  4 +++-
 3 files changed, 26 insertions(+), 15 deletions(-)

diff --git a/block/bio.c b/block/bio.c
index a7633aa82d7d..0b65ea241f54 100644
--- a/block/bio.c
+++ b/block/bio.c
@@ -440,11 +440,7 @@ static struct bio *bio_alloc_percpu_cache(struct block_device *bdev,
 		return bio;
 	}
 	put_cpu();
-	bio = bio_alloc_bioset(bdev, nr_vecs, opf, gfp, bs);
-	if (!bio)
-		return NULL;
-	bio_set_flag(bio, BIO_PERCPU_CACHE);
-	return bio;
+	return NULL;
 }
 
 /**
@@ -488,11 +484,24 @@ struct bio *bio_alloc_bioset(struct block_device *bdev, unsigned short nr_vecs,
 	gfp_t saved_gfp = gfp_mask;
 	struct bio *bio;
 	void *p;
+	bool use_alloc_cache;
 
 	/* should not use nobvec bioset for nr_vecs > 0 */
 	if (WARN_ON_ONCE(!mempool_initialized(&bs->bvec_pool) && nr_vecs > 0))
 		return NULL;
 
+	use_alloc_cache = (bs->cache && (opf & REQ_ALLOC_CACHE) &&
+			   nr_vecs <= BIO_INLINE_VECS);
+	if (use_alloc_cache) {
+		bio = bio_alloc_percpu_cache(bdev, nr_vecs, opf, gfp_mask, bs);
+		if (bio)
+			return bio;
+		/*
+		 * No cached bio available, mark bio returned below to
+		 * particpate in per-cpu alloc cache.
+		 */
+	}
+
 	/*
 	 * submit_bio_noacct() converts recursion to iteration; this means if
 	 * we're running beneath it, any bios we allocate and submit will not be
@@ -546,6 +555,8 @@ struct bio *bio_alloc_bioset(struct block_device *bdev, unsigned short nr_vecs,
 		bio_init(bio, bdev, NULL, 0, opf);
 	}
 
+	if (use_alloc_cache)
+		bio_set_flag(bio, BIO_PERCPU_CACHE);
 	bio->bi_pool = bs;
 	return bio;
 
@@ -795,10 +806,7 @@ struct bio *bio_alloc_clone(struct block_device *bdev, struct bio *bio_src,
 {
 	struct bio *bio;
 
-	if (bs->cache && bio_src->bi_opf & REQ_POLLED)
-		bio = bio_alloc_percpu_cache(bdev, 0, bio_src->bi_opf, gfp, bs);
-	else
-		bio = bio_alloc_bioset(bdev, 0, bio_src->bi_opf, gfp, bs);
+	bio = bio_alloc_bioset(bdev, 0, bio_src->bi_opf, gfp, bs);
 	if (!bio)
 		return NULL;
 
@@ -1792,10 +1800,9 @@ EXPORT_SYMBOL(bioset_init_from_src);
 struct bio *bio_alloc_kiocb(struct kiocb *kiocb, struct block_device *bdev,
 		unsigned short nr_vecs, unsigned int opf, struct bio_set *bs)
 {
-	if (!(kiocb->ki_flags & IOCB_ALLOC_CACHE) || nr_vecs > BIO_INLINE_VECS)
-		return bio_alloc_bioset(bdev, nr_vecs, opf, GFP_KERNEL, bs);
-
-	return bio_alloc_percpu_cache(bdev, nr_vecs, opf, GFP_KERNEL, bs);
+	if (kiocb->ki_flags & IOCB_ALLOC_CACHE)
+		opf |= REQ_ALLOC_CACHE;
+	return bio_alloc_bioset(bdev, nr_vecs, opf, GFP_KERNEL, bs);
 }
 EXPORT_SYMBOL_GPL(bio_alloc_kiocb);
 
diff --git a/include/linux/bio.h b/include/linux/bio.h
index 709663ae757a..1be27e87a1f4 100644
--- a/include/linux/bio.h
+++ b/include/linux/bio.h
@@ -783,6 +783,8 @@ static inline int bio_integrity_add_page(struct bio *bio, struct page *page,
 static inline void bio_set_polled(struct bio *bio, struct kiocb *kiocb)
 {
 	bio->bi_opf |= REQ_POLLED;
+	if (kiocb->ki_flags & IOCB_ALLOC_CACHE)
+		bio->bi_opf |= REQ_ALLOC_CACHE;
 	if (!is_sync_kiocb(kiocb))
 		bio->bi_opf |= REQ_NOWAIT;
 }
@@ -791,7 +793,7 @@ static inline void bio_clear_polled(struct bio *bio)
 {
 	/* can't support alloc cache if we turn off polling */
 	bio_clear_flag(bio, BIO_PERCPU_CACHE);
-	bio->bi_opf &= ~REQ_POLLED;
+	bio->bi_opf &= ~(REQ_POLLED | REQ_ALLOC_CACHE);
 }
 
 struct bio *blk_next_bio(struct bio *bio, struct block_device *bdev,
diff --git a/include/linux/blk_types.h b/include/linux/blk_types.h
index 5561e58d158a..5f9a0c39d4c5 100644
--- a/include/linux/blk_types.h
+++ b/include/linux/blk_types.h
@@ -327,7 +327,7 @@ enum {
 	BIO_TRACKED,		/* set if bio goes through the rq_qos path */
 	BIO_REMAPPED,
 	BIO_ZONE_WRITE_LOCKED,	/* Owns a zoned device zone write lock */
-	BIO_PERCPU_CACHE,	/* can participate in per-cpu alloc cache */
+	BIO_PERCPU_CACHE,	/* participates in per-cpu alloc cache */
 	BIO_FLAG_LAST
 };
 
@@ -414,6 +414,7 @@ enum req_flag_bits {
 	__REQ_NOUNMAP,		/* do not free blocks when zeroing */
 
 	__REQ_POLLED,		/* caller polls for completion using bio_poll */
+	__REQ_ALLOC_CACHE,	/* allocate IO from cache if available */
 
 	/* for driver use */
 	__REQ_DRV,
@@ -439,6 +440,7 @@ enum req_flag_bits {
 
 #define REQ_NOUNMAP		(1ULL << __REQ_NOUNMAP)
 #define REQ_POLLED		(1ULL << __REQ_POLLED)
+#define REQ_ALLOC_CACHE		(1ULL << __REQ_ALLOC_CACHE)
 
 #define REQ_DRV			(1ULL << __REQ_DRV)
 #define REQ_SWAP		(1ULL << __REQ_SWAP)
-- 
2.15.0

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel


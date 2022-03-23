Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4A6D3C433FE
	for <dm-devel@archiver.kernel.org>; Wed, 23 Mar 2022 19:45:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1648064740;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=6Ni4pXHQ9ZAzduCpIg0bAVA8u384qCaa23qmj/rkF88=;
	b=JpYmAR+FUR6dG6MuGFvYHSceFoHyQpDGCm3FPm2UNK7FRh4l3Dlq0teZUrlESlZ63b0ufK
	hwuDN9KC3dqFEw64pKcS7Ur4j6fJklfqZDHVYoPCk0R7pbng3Tp4JP5gZ9Mg4sDfdwfglJ
	zusakAIpLTng5ozAMHtK3oz4Fjci2xs=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-654-Kwl6oUs0PBGi-8LLJjW19w-1; Wed, 23 Mar 2022 15:45:36 -0400
X-MC-Unique: Kwl6oUs0PBGi-8LLJjW19w-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 57F5D1044563;
	Wed, 23 Mar 2022 19:45:34 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 45C11400E420;
	Wed, 23 Mar 2022 19:45:34 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id D20331940347;
	Wed, 23 Mar 2022 19:45:33 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com
 [10.11.54.9])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 1AA951940352
 for <dm-devel@listman.corp.redhat.com>; Wed, 23 Mar 2022 19:45:32 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id EED7C46A38A; Wed, 23 Mar 2022 19:45:31 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id EB1F958BAC8
 for <dm-devel@redhat.com>; Wed, 23 Mar 2022 19:45:31 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 574DA83395F
 for <dm-devel@redhat.com>; Wed, 23 Mar 2022 19:45:31 +0000 (UTC)
Received: from mail-qt1-f197.google.com (mail-qt1-f197.google.com
 [209.85.160.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-251-zHx5jnEzMnClkeTQv55wEg-1; Wed, 23 Mar 2022 15:45:28 -0400
X-MC-Unique: zHx5jnEzMnClkeTQv55wEg-1
Received: by mail-qt1-f197.google.com with SMTP id
 z18-20020ac84552000000b002e201c79cd4so2019716qtn.2
 for <dm-devel@redhat.com>; Wed, 23 Mar 2022 12:45:28 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
 :in-reply-to:references;
 bh=AKeDBg4ZdHttOQXh6zOoYZL7eiQ4d/9ADfn1bk7vgsI=;
 b=P/gmCuZV7m6R5cCu+2Udx4uSoBJ+sXPwrsN5nHkIZbcPR5+Sav+IHhZKkUn5a2lDrS
 fKAYRgSvCigZLPkhkSk72XWg+5h341pn5rRrpm8xkwWMm5zXWmLw9ws88ByJbOyVpwOK
 h6R/wv1kOMro5O+/Fvxal4Jk80rMU1ioo5VJ3tj/MDDzssICOc/VyLJfzXByYi/BuCF+
 7NOa1M1VtZZKfu6+IQUiHLUicvDh0Tq6mFjEZktUOXFtTnKblOd1xvgxPaeCzkJ4yy8t
 d8TJQy4VBFsOEif90KmWG8oUpE3x6UoCwF4+zwJA9PhenQNdeYx2E7LB4S1QcY/5rXdK
 LMRQ==
X-Gm-Message-State: AOAM532tqkeUog9XCBj/BEXyh6WwuOZzs82wpiSXZCk9+6gsZto5BR5u
 4yngR7B/oK2ncJW172JeZNOEO9QvFLz99uXo+9pzmAVwp6oVLneUXCPoMELhjuIM+5IWS0rltTd
 nnamX8PbRRe3olQ==
X-Received: by 2002:ad4:5aa9:0:b0:441:3a0a:1aba with SMTP id
 u9-20020ad45aa9000000b004413a0a1abamr1463208qvg.20.1648064727288; 
 Wed, 23 Mar 2022 12:45:27 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJx14W12RoUy94PnscHvKvwxWAan+U2UFinhkJZ0fo2szicnnDf5lrhasgjpruR6xvmPU2ZYlw==
X-Received: by 2002:ad4:5aa9:0:b0:441:3a0a:1aba with SMTP id
 u9-20020ad45aa9000000b004413a0a1abamr1463195qvg.20.1648064727094; 
 Wed, 23 Mar 2022 12:45:27 -0700 (PDT)
Received: from localhost (pool-68-160-176-52.bstnma.fios.verizon.net.
 [68.160.176.52]) by smtp.gmail.com with ESMTPSA id
 u129-20020a376087000000b0067e401d7177sm512410qkb.3.2022.03.23.12.45.26
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Wed, 23 Mar 2022 12:45:26 -0700 (PDT)
From: Mike Snitzer <snitzer@redhat.com>
X-Google-Original-From: Mike Snitzer <snitzer@kernel.org>
To: axboe@kernel.dk
Date: Wed, 23 Mar 2022 15:45:21 -0400
Message-Id: <20220323194524.5900-2-snitzer@kernel.org>
In-Reply-To: <20220323194524.5900-1-snitzer@kernel.org>
References: <20220323194524.5900-1-snitzer@kernel.org>
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.9
Subject: [dm-devel] [PATCH v2 1/4] block: allow BIOSET_PERCPU_CACHE use from
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
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.2
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

These changes allow DM core to make full use of BIOSET_PERCPU_CACHE for
REQ_POLLED bios:

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
index b15f5466ce08..a7633aa82d7d 100644
--- a/block/bio.c
+++ b/block/bio.c
@@ -420,6 +420,33 @@ static void punt_bios_to_rescuer(struct bio_set *bs)
 	queue_work(bs->rescue_workqueue, &bs->rescue_work);
 }
 
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
 /**
  * bio_alloc_bioset - allocate a bio for I/O
  * @bdev:	block device to allocate the bio for (can be %NULL)
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


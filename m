Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C25E3C43334
	for <dm-devel@archiver.kernel.org>; Wed,  8 Jun 2022 07:16:01 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-434-c5IYmNBrOMqKQ35OLczjLg-1; Wed, 08 Jun 2022 03:15:57 -0400
X-MC-Unique: c5IYmNBrOMqKQ35OLczjLg-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id F181B3C0CD3A;
	Wed,  8 Jun 2022 07:15:55 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id A223DC4C7A0;
	Wed,  8 Jun 2022 07:15:55 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 79633194704C;
	Wed,  8 Jun 2022 07:15:55 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com
 [10.11.54.10])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 058BB1947042
 for <dm-devel@listman.corp.redhat.com>; Wed,  8 Jun 2022 07:15:54 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id D684B492C3B; Wed,  8 Jun 2022 07:15:53 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id D2AD0456CD9
 for <dm-devel@redhat.com>; Wed,  8 Jun 2022 07:15:53 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id BAF47811E80
 for <dm-devel@redhat.com>; Wed,  8 Jun 2022 07:15:53 +0000 (UTC)
Received: from bombadil.infradead.org (bombadil.infradead.org
 [198.137.202.133]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-383-roGtN5I5MEmlt0uQGBwp6g-1; Wed, 08 Jun 2022 03:15:51 -0400
X-MC-Unique: roGtN5I5MEmlt0uQGBwp6g-1
Received: from [2001:4bb8:190:726c:66c4:f635:4b37:bdda] (helo=localhost)
 by bombadil.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
 id 1nypGj-00BJTz-Jv; Wed, 08 Jun 2022 06:34:18 +0000
From: Christoph Hellwig <hch@lst.de>
To: Mike Snitzer <snitzer@kernel.org>
Date: Wed,  8 Jun 2022 08:34:07 +0200
Message-Id: <20220608063409.1280968-3-hch@lst.de>
In-Reply-To: <20220608063409.1280968-1-hch@lst.de>
References: <20220608063409.1280968-1-hch@lst.de>
MIME-Version: 1.0
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by
 bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.10
Subject: [dm-devel] [PATCH 2/4] block: remove bioset_init_from_src
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
Cc: Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org,
 dm-devel@redhat.com
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.8
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Unused now, and the interface never really made a whole lot of sense to
start with.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 block/bio.c         | 20 --------------------
 include/linux/bio.h |  1 -
 2 files changed, 21 deletions(-)

diff --git a/block/bio.c b/block/bio.c
index be3937b84e68a..f3cce7f267a98 100644
--- a/block/bio.c
+++ b/block/bio.c
@@ -1745,26 +1745,6 @@ int bioset_init(struct bio_set *bs,
 }
 EXPORT_SYMBOL(bioset_init);
 
-/*
- * Initialize and setup a new bio_set, based on the settings from
- * another bio_set.
- */
-int bioset_init_from_src(struct bio_set *bs, struct bio_set *src)
-{
-	int flags;
-
-	flags = 0;
-	if (src->bvec_pool.min_nr)
-		flags |= BIOSET_NEED_BVECS;
-	if (src->rescue_workqueue)
-		flags |= BIOSET_NEED_RESCUER;
-	if (src->cache)
-		flags |= BIOSET_PERCPU_CACHE;
-
-	return bioset_init(bs, src->bio_pool.min_nr, src->front_pad, flags);
-}
-EXPORT_SYMBOL(bioset_init_from_src);
-
 static int __init init_bio(void)
 {
 	int i;
diff --git a/include/linux/bio.h b/include/linux/bio.h
index 1cf3738ef1ea6..992ee987f2738 100644
--- a/include/linux/bio.h
+++ b/include/linux/bio.h
@@ -403,7 +403,6 @@ enum {
 extern int bioset_init(struct bio_set *, unsigned int, unsigned int, int flags);
 extern void bioset_exit(struct bio_set *);
 extern int biovec_init_pool(mempool_t *pool, int pool_entries);
-extern int bioset_init_from_src(struct bio_set *bs, struct bio_set *src);
 
 struct bio *bio_alloc_bioset(struct block_device *bdev, unsigned short nr_vecs,
 			     unsigned int opf, gfp_t gfp_mask,
-- 
2.30.2

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel


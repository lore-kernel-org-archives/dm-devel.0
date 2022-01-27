Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C1C2AC433EF
	for <dm-devel@archiver.kernel.org>; Thu, 27 Jan 2022 07:11:28 +0000 (UTC)
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-377-vvr1A07XP0SxZpevSqGWlw-1; Thu, 27 Jan 2022 02:11:24 -0500
X-MC-Unique: vvr1A07XP0SxZpevSqGWlw-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 173D31006AA5;
	Thu, 27 Jan 2022 07:11:20 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id DDB1D795A3;
	Thu, 27 Jan 2022 07:11:19 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id A04C64A7C8;
	Thu, 27 Jan 2022 07:11:19 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
	[10.11.54.6])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 20R7BIRa002834 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 27 Jan 2022 02:11:18 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 9AC022166B41; Thu, 27 Jan 2022 07:11:18 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 96CFB2166B3F
	for <dm-devel@redhat.com>; Thu, 27 Jan 2022 07:11:15 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[207.211.31.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 0466A185A79C
	for <dm-devel@redhat.com>; Thu, 27 Jan 2022 07:11:15 +0000 (UTC)
Received: from bombadil.infradead.org (bombadil.infradead.org
	[198.137.202.133]) by relay.mimecast.com with ESMTP with STARTTLS
	(version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-317-9zCNhFlLMICNV8BkZ4L-Tg-1; Thu, 27 Jan 2022 02:11:13 -0500
X-MC-Unique: 9zCNhFlLMICNV8BkZ4L-Tg-1
Received: from 213-225-10-69.nat.highway.a1.net ([213.225.10.69]
	helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
	id 1nCyOZ-00EYGy-Gs; Thu, 27 Jan 2022 06:36:36 +0000
From: Christoph Hellwig <hch@lst.de>
To: Jens Axboe <axboe@kernel.dk>
Date: Thu, 27 Jan 2022 07:35:45 +0100
Message-Id: <20220127063546.1314111-14-hch@lst.de>
In-Reply-To: <20220127063546.1314111-1-hch@lst.de>
References: <20220127063546.1314111-1-hch@lst.de>
MIME-Version: 1.0
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by
	bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.6
X-loop: dm-devel@redhat.com
Cc: Mike Snitzer <snitzer@redhat.com>,
	Philipp Reisner <philipp.reisner@linbit.com>,
	linux-block@vger.kernel.org, dm-devel@redhat.com,
	Lars Ellenberg <lars.ellenberg@linbit.com>,
	Pavel Begunkov <asml.silence@gmail.com>, drbd-dev@lists.linbit.com
Subject: [dm-devel] [PATCH 13/14] block: initialize the target bio in
	__bio_clone_fast
X-BeenThere: dm-devel@redhat.com
X-Mailman-Version: 2.1.12
Precedence: junk
List-Id: device-mapper development <dm-devel.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

All callers of __bio_clone_fast initialize the bio first.  Move that
initialization into __bio_clone_fast instead.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 block/bio.c                 | 75 ++++++++++++++++++++-----------------
 drivers/md/bcache/request.c |  1 -
 drivers/md/dm.c             |  5 +--
 drivers/md/md-multipath.c   |  1 -
 4 files changed, 41 insertions(+), 41 deletions(-)

diff --git a/block/bio.c b/block/bio.c
index 60f79b33a49af..eae1deba18962 100644
--- a/block/bio.c
+++ b/block/bio.c
@@ -726,37 +726,16 @@ void bio_put(struct bio *bio)
 }
 EXPORT_SYMBOL(bio_put);
 
-/**
- * 	__bio_clone_fast - clone a bio that shares the original bio's biovec
- * 	@bio: destination bio
- * 	@bio_src: bio to clone
- *	@gfp: allocation flags
- *
- *	Clone a &bio. Caller will own the returned bio, but not
- *	the actual data it points to. Reference count of returned
- * 	bio will be one.
- *
- * 	Caller must ensure that @bio_src is not freed before @bio.
- */
-int __bio_clone_fast(struct bio *bio, struct bio *bio_src, gfp_t gfp)
+static int __bio_clone(struct bio *bio, struct bio *bio_src, gfp_t gfp)
 {
-	WARN_ON_ONCE(bio->bi_pool && bio->bi_max_vecs);
-
-	/*
-	 * most users will be overriding ->bi_bdev with a new target,
-	 * so we don't set nor calculate new physical/hw segment counts here
-	 */
-	bio->bi_bdev = bio_src->bi_bdev;
 	bio_set_flag(bio, BIO_CLONED);
 	if (bio_flagged(bio_src, BIO_THROTTLED))
 		bio_set_flag(bio, BIO_THROTTLED);
 	if (bio_flagged(bio_src, BIO_REMAPPED))
 		bio_set_flag(bio, BIO_REMAPPED);
-	bio->bi_opf = bio_src->bi_opf;
 	bio->bi_ioprio = bio_src->bi_ioprio;
 	bio->bi_write_hint = bio_src->bi_write_hint;
 	bio->bi_iter = bio_src->bi_iter;
-	bio->bi_io_vec = bio_src->bi_io_vec;
 
 	bio_clone_blkg_association(bio, bio_src);
 	blkcg_bio_issue_init(bio);
@@ -768,33 +747,59 @@ int __bio_clone_fast(struct bio *bio, struct bio *bio_src, gfp_t gfp)
 		return -ENOMEM;
 	return 0;
 }
-EXPORT_SYMBOL(__bio_clone_fast);
 
 /**
- *	bio_clone_fast - clone a bio that shares the original bio's biovec
- *	@bio: bio to clone
- *	@gfp_mask: allocation priority
- *	@bs: bio_set to allocate from
+ * bio_clone_fast - clone a bio that shares the original bio's biovec
+ * @bio_src: bio to clone from
+ * @gfp: allocation priority
+ * @bs: bio_set to allocate from
+ *
+ * Allocate a new bio that is a clone of @bio_src. The caller owns the returned
+ * bio, but not the actual data it points to.
  *
- * 	Like __bio_clone_fast, only also allocates the returned bio
+ * The caller must ensure that the return bio is not freed before @bio_src.
  */
-struct bio *bio_clone_fast(struct bio *bio, gfp_t gfp_mask, struct bio_set *bs)
+struct bio *bio_clone_fast(struct bio *bio_src, gfp_t gfp, struct bio_set *bs)
 {
-	struct bio *b;
+	struct bio *bio;
 
-	b = bio_alloc_bioset(NULL, 0, 0, gfp_mask, bs);
-	if (!b)
+	bio = bio_alloc_bioset(bio_src->bi_bdev, 0, bio_src->bi_opf, gfp, bs);
+	if (!bio)
 		return NULL;
 
-	if (__bio_clone_fast(b, bio, gfp_mask < 0)) {
-		bio_put(b);
+	if (__bio_clone(bio, bio_src, gfp) < 0) {
+		bio_put(bio);
 		return NULL;
 	}
+	bio->bi_io_vec = bio_src->bi_io_vec;
 
-	return b;
+	return bio;
 }
 EXPORT_SYMBOL(bio_clone_fast);
 
+/**
+ * __bio_clone_fast - clone a bio that shares the original bio's biovec
+ * @bio: bio to clone into
+ * @bio_src: bio to clone from
+ * @gfp: allocation priority
+ *
+ * Initialize a new bio in caller provided memory that is a clone of @bio_src.
+ * The caller owns the returned bio, but not the actual data it points to.
+ *
+ * The caller must ensure that @bio_src is not freed before @bio.
+ */
+int __bio_clone_fast(struct bio *bio, struct bio *bio_src, gfp_t gfp)
+{
+	int ret;
+
+	bio_init(bio, bio_src->bi_bdev, bio_src->bi_io_vec, 0, bio_src->bi_opf);
+	ret = __bio_clone(bio, bio_src, gfp);
+	if (ret)
+		bio_uninit(bio);
+	return ret;
+}
+EXPORT_SYMBOL(__bio_clone_fast);
+
 const char *bio_devname(struct bio *bio, char *buf)
 {
 	return bdevname(bio->bi_bdev, buf);
diff --git a/drivers/md/bcache/request.c b/drivers/md/bcache/request.c
index 574b02b94f1a4..d2cb853bf9173 100644
--- a/drivers/md/bcache/request.c
+++ b/drivers/md/bcache/request.c
@@ -685,7 +685,6 @@ static void do_bio_hook(struct search *s,
 {
 	struct bio *bio = &s->bio.bio;
 
-	bio_init(bio, NULL, NULL, 0, 0);
 	__bio_clone_fast(bio, orig_bio, GFP_NOIO);
 	/*
 	 * bi_end_io can be set separately somewhere else, e.g. the
diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index 984ccafb11ea8..b08e0732f71d7 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -552,11 +552,8 @@ static struct bio *alloc_tio(struct clone_info *ci, struct dm_target *ti,
 	if (!ci->io->tio.io) {
 		/* the dm_target_io embedded in ci->io is available */
 		tio = &ci->io->tio;
-		bio_init(&tio->clone, NULL, NULL, 0, 0);
-		if (__bio_clone_fast(&tio->clone, ci->bio, gfp_mask) < 0) {
-			bio_uninit(&tio->clone);
+		if (__bio_clone_fast(&tio->clone, ci->bio, gfp_mask) < 0)
 			return NULL;
-		}
 	} else {
 		struct bio *clone = bio_clone_fast(ci->bio, gfp_mask,
 						   &ci->io->md->bs);
diff --git a/drivers/md/md-multipath.c b/drivers/md/md-multipath.c
index 010c759c741ad..483a5500f83cd 100644
--- a/drivers/md/md-multipath.c
+++ b/drivers/md/md-multipath.c
@@ -121,7 +121,6 @@ static bool multipath_make_request(struct mddev *mddev, struct bio * bio)
 	}
 	multipath = conf->multipaths + mp_bh->path;
 
-	bio_init(&mp_bh->bio, NULL, NULL, 0, 0);
 	__bio_clone_fast(&mp_bh->bio, bio, GFP_NOIO);
 
 	mp_bh->bio.bi_iter.bi_sector += multipath->rdev->data_offset;
-- 
2.30.2

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel


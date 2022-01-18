Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 721E4C4167E
	for <dm-devel@archiver.kernel.org>; Tue, 18 Jan 2022 07:20:48 +0000 (UTC)
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-50-qy7zsVlUPJuB0tGV2zl-Fg-1; Tue, 18 Jan 2022 02:20:42 -0500
X-MC-Unique: qy7zsVlUPJuB0tGV2zl-Fg-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D692F101F02C;
	Tue, 18 Jan 2022 07:20:27 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id AD565108B6;
	Tue, 18 Jan 2022 07:20:27 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 7EB024A7CA;
	Tue, 18 Jan 2022 07:20:27 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com
	[10.11.54.2])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 20I7KIoA012938 for <dm-devel@listman.util.phx.redhat.com>;
	Tue, 18 Jan 2022 02:20:18 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 7171E400E10D; Tue, 18 Jan 2022 07:20:18 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast09.extmail.prod.ext.rdu2.redhat.com [10.11.55.25])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 6D8A240D1B9E
	for <dm-devel@redhat.com>; Tue, 18 Jan 2022 07:20:18 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[207.211.31.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 565732A7A518
	for <dm-devel@redhat.com>; Tue, 18 Jan 2022 07:20:18 +0000 (UTC)
Received: from bombadil.infradead.org (bombadil.infradead.org
	[198.137.202.133]) by relay.mimecast.com with ESMTP with STARTTLS
	(version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-151-74IXOaHPPhGmYd51zdrV8g-1; Tue, 18 Jan 2022 02:20:16 -0500
X-MC-Unique: 74IXOaHPPhGmYd51zdrV8g-1
Received: from [2001:4bb8:184:72a4:a4a9:19c0:5242:7768] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
	id 1n9imm-000ZQV-P6; Tue, 18 Jan 2022 07:20:09 +0000
From: Christoph Hellwig <hch@lst.de>
To: Jens Axboe <axboe@kernel.dk>
Date: Tue, 18 Jan 2022 08:19:38 +0100
Message-Id: <20220118071952.1243143-6-hch@lst.de>
In-Reply-To: <20220118071952.1243143-1-hch@lst.de>
References: <20220118071952.1243143-1-hch@lst.de>
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
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.2
X-loop: dm-devel@redhat.com
Cc: linux-block@vger.kernel.org, linux-nfs@vger.kernel.org,
	linux-nilfs@vger.kernel.org, Mike Snitzer <snitzer@redhat.com>,
	Philipp Reisner <philipp.reisner@linbit.com>,
	Ryusuke Konishi <konishi.ryusuke@gmail.com>,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
	=?UTF-8?q?Roger=20Pau=20Monn=C3=A9?= <roger.pau@citrix.co>,
	dm-devel@redhat.com, "Md . Haris Iqbal " <haris.iqbal@ionos.com>,
	Lars Ellenberg <lars.ellenberg@linbit.com>,
	linux-fsdevel@vger.kernel.org, xen-devel@lists.xenproject.org,
	Andrew Morton <akpm@linux-foundation.org>, ntfs3@lists.linux.dev,
	Jack Wang <jinpu.wang@ionos.com>, Pavel Begunkov <asml.silence@gmail.com>,
	drbd-dev@lists.linbit.com
Subject: [dm-devel] [PATCH 05/19] dm: bio_alloc can't fail if it is allowed
	to sleep
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
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Remove handling of NULL returns from sleeping bio_alloc calls given that
those can't fail.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/md/dm-crypt.c          |  5 +----
 drivers/md/dm-log-writes.c     | 18 ------------------
 drivers/md/dm-thin.c           | 25 +++++++++----------------
 drivers/md/dm-zoned-metadata.c | 11 -----------
 drivers/md/dm.c                |  2 --
 5 files changed, 10 insertions(+), 51 deletions(-)

diff --git a/drivers/md/dm-crypt.c b/drivers/md/dm-crypt.c
index d4ae31558826a..20abe3486aba1 100644
--- a/drivers/md/dm-crypt.c
+++ b/drivers/md/dm-crypt.c
@@ -1673,9 +1673,6 @@ static struct bio *crypt_alloc_buffer(struct dm_crypt_io *io, unsigned size)
 		mutex_lock(&cc->bio_alloc_lock);
 
 	clone = bio_alloc_bioset(GFP_NOIO, nr_iovecs, &cc->bs);
-	if (!clone)
-		goto out;
-
 	clone_init(io, clone);
 
 	remaining_size = size;
@@ -1702,7 +1699,7 @@ static struct bio *crypt_alloc_buffer(struct dm_crypt_io *io, unsigned size)
 		bio_put(clone);
 		clone = NULL;
 	}
-out:
+
 	if (unlikely(gfp_mask & __GFP_DIRECT_RECLAIM))
 		mutex_unlock(&cc->bio_alloc_lock);
 
diff --git a/drivers/md/dm-log-writes.c b/drivers/md/dm-log-writes.c
index 139b09b06eda9..25f5e8d2d417b 100644
--- a/drivers/md/dm-log-writes.c
+++ b/drivers/md/dm-log-writes.c
@@ -218,10 +218,6 @@ static int write_metadata(struct log_writes_c *lc, void *entry,
 	size_t ret;
 
 	bio = bio_alloc(GFP_KERNEL, 1);
-	if (!bio) {
-		DMERR("Couldn't alloc log bio");
-		goto error;
-	}
 	bio->bi_iter.bi_size = 0;
 	bio->bi_iter.bi_sector = sector;
 	bio_set_dev(bio, lc->logdev->bdev);
@@ -276,11 +272,6 @@ static int write_inline_data(struct log_writes_c *lc, void *entry,
 		atomic_inc(&lc->io_blocks);
 
 		bio = bio_alloc(GFP_KERNEL, bio_pages);
-		if (!bio) {
-			DMERR("Couldn't alloc inline data bio");
-			goto error;
-		}
-
 		bio->bi_iter.bi_size = 0;
 		bio->bi_iter.bi_sector = sector;
 		bio_set_dev(bio, lc->logdev->bdev);
@@ -322,7 +313,6 @@ static int write_inline_data(struct log_writes_c *lc, void *entry,
 error_bio:
 	bio_free_pages(bio);
 	bio_put(bio);
-error:
 	put_io_block(lc);
 	return -1;
 }
@@ -364,10 +354,6 @@ static int log_one_block(struct log_writes_c *lc,
 
 	atomic_inc(&lc->io_blocks);
 	bio = bio_alloc(GFP_KERNEL, bio_max_segs(block->vec_cnt));
-	if (!bio) {
-		DMERR("Couldn't alloc log bio");
-		goto error;
-	}
 	bio->bi_iter.bi_size = 0;
 	bio->bi_iter.bi_sector = sector;
 	bio_set_dev(bio, lc->logdev->bdev);
@@ -387,10 +373,6 @@ static int log_one_block(struct log_writes_c *lc,
 			submit_bio(bio);
 			bio = bio_alloc(GFP_KERNEL,
 					bio_max_segs(block->vec_cnt - i));
-			if (!bio) {
-				DMERR("Couldn't alloc log bio");
-				goto error;
-			}
 			bio->bi_iter.bi_size = 0;
 			bio->bi_iter.bi_sector = sector;
 			bio_set_dev(bio, lc->logdev->bdev);
diff --git a/drivers/md/dm-thin.c b/drivers/md/dm-thin.c
index ec119d2422d5d..76a9c2e9aeeea 100644
--- a/drivers/md/dm-thin.c
+++ b/drivers/md/dm-thin.c
@@ -1180,24 +1180,17 @@ static void process_prepared_discard_passdown_pt1(struct dm_thin_new_mapping *m)
 	}
 
 	discard_parent = bio_alloc(GFP_NOIO, 1);
-	if (!discard_parent) {
-		DMWARN("%s: unable to allocate top level discard bio for passdown. Skipping passdown.",
-		       dm_device_name(tc->pool->pool_md));
-		queue_passdown_pt2(m);
+	discard_parent->bi_end_io = passdown_endio;
+	discard_parent->bi_private = m;
 
-	} else {
-		discard_parent->bi_end_io = passdown_endio;
-		discard_parent->bi_private = m;
-
-		if (m->maybe_shared)
-			passdown_double_checking_shared_status(m, discard_parent);
-		else {
-			struct discard_op op;
+	if (m->maybe_shared)
+		passdown_double_checking_shared_status(m, discard_parent);
+	else {
+		struct discard_op op;
 
-			begin_discard(&op, tc, discard_parent);
-			r = issue_discard(&op, m->data_block, data_end);
-			end_discard(&op, r);
-		}
+		begin_discard(&op, tc, discard_parent);
+		r = issue_discard(&op, m->data_block, data_end);
+		end_discard(&op, r);
 	}
 }
 
diff --git a/drivers/md/dm-zoned-metadata.c b/drivers/md/dm-zoned-metadata.c
index ee4626d085574..5718b83cc7182 100644
--- a/drivers/md/dm-zoned-metadata.c
+++ b/drivers/md/dm-zoned-metadata.c
@@ -551,10 +551,6 @@ static struct dmz_mblock *dmz_get_mblock_slow(struct dmz_metadata *zmd,
 		return ERR_PTR(-ENOMEM);
 
 	bio = bio_alloc(GFP_NOIO, 1);
-	if (!bio) {
-		dmz_free_mblock(zmd, mblk);
-		return ERR_PTR(-ENOMEM);
-	}
 
 	spin_lock(&zmd->mblk_lock);
 
@@ -726,10 +722,6 @@ static int dmz_write_mblock(struct dmz_metadata *zmd, struct dmz_mblock *mblk,
 		return -EIO;
 
 	bio = bio_alloc(GFP_NOIO, 1);
-	if (!bio) {
-		set_bit(DMZ_META_ERROR, &mblk->state);
-		return -ENOMEM;
-	}
 
 	set_bit(DMZ_META_WRITING, &mblk->state);
 
@@ -760,9 +752,6 @@ static int dmz_rdwr_block(struct dmz_dev *dev, int op,
 		return -EIO;
 
 	bio = bio_alloc(GFP_NOIO, 1);
-	if (!bio)
-		return -ENOMEM;
-
 	bio->bi_iter.bi_sector = dmz_blk2sect(block);
 	bio_set_dev(bio, dev->bdev);
 	bio_set_op_attrs(bio, op, REQ_SYNC | REQ_META | REQ_PRIO);
diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index c0ae8087c6027..81449cbdafa81 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -520,8 +520,6 @@ static struct dm_io *alloc_io(struct mapped_device *md, struct bio *bio)
 	struct bio *clone;
 
 	clone = bio_alloc_bioset(GFP_NOIO, 0, &md->io_bs);
-	if (!clone)
-		return NULL;
 
 	tio = container_of(clone, struct dm_target_io, clone);
 	tio->inside_dm_io = true;
-- 
2.30.2

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel


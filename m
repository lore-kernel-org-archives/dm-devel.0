Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CE8DAC352A1
	for <dm-devel@archiver.kernel.org>; Tue,  6 Dec 2022 15:10:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1670339442;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=NPaBvOF132UrrXy7vVoDtIxYLt09fDa2nkqa606doQ8=;
	b=OqO5VOJTauh7HwVQ7kjxkvTT4ISbXASMJBLoM1js6CspnXCUxGE6+oC5qhVQDqOlSr+FQ9
	unhNfLRxYV80ScLHWWC4ZM1HiuojBGg+0Mw6Kgcdw1BFjn6nZNbIUasq59zTqb7zP7Kpvn
	8fRjbUoHoG20Lb16ss5g+J+BomSKVRg=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-608-bsSarFHHNGqdn_Q4JvCmbQ-1; Tue, 06 Dec 2022 10:10:41 -0500
X-MC-Unique: bsSarFHHNGqdn_Q4JvCmbQ-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 08C7E86EB66;
	Tue,  6 Dec 2022 15:10:40 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id A886D4A9256;
	Tue,  6 Dec 2022 15:10:37 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 7983B1946589;
	Tue,  6 Dec 2022 15:10:37 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com
 [10.11.54.10])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id E5F6E1946586
 for <dm-devel@listman.corp.redhat.com>; Tue,  6 Dec 2022 15:10:36 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id B6869492B07; Tue,  6 Dec 2022 15:10:36 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id AF1B4492B04
 for <dm-devel@redhat.com>; Tue,  6 Dec 2022 15:10:36 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 90532185A78F
 for <dm-devel@redhat.com>; Tue,  6 Dec 2022 15:10:36 +0000 (UTC)
Received: from bombadil.infradead.org (bombadil.infradead.org
 [198.137.202.133]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-546--NwTjfwCM-6ctUDvvBls0A-1; Tue, 06 Dec 2022 10:10:34 -0500
X-MC-Unique: -NwTjfwCM-6ctUDvvBls0A-1
Received: from [2001:4bb8:19a:6deb:96e2:518:dd92:8fb1] (helo=localhost)
 by bombadil.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
 id 1p2Z7z-00BJhE-SS; Tue, 06 Dec 2022 14:41:00 +0000
From: Christoph Hellwig <hch@lst.de>
To: axboe@kernel.dk,
	snitzer@kernel.org
Date: Tue,  6 Dec 2022 15:40:57 +0100
Message-Id: <20221206144057.720846-1-hch@lst.de>
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
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.10
Subject: [dm-devel] [PATCH] block: remove bio_set_op_attrs
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
Cc: linux-raid@vger.kernel.org, dm-devel@redhat.com, colyli@suse.de,
 linux-block@vger.kernel.org, song@kernel.org, linux-bcache@vger.kernel.org
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.9
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

This macro is obsolete, so replace the last few uses with open coded
bi_opf assignments.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/md/bcache/movinggc.c  |  2 +-
 drivers/md/bcache/request.c   |  2 +-
 drivers/md/bcache/writeback.c |  4 ++--
 drivers/md/dm-thin.c          |  2 +-
 drivers/md/raid1.c            | 12 ++++++------
 drivers/md/raid10.c           | 18 +++++++++---------
 include/linux/blk_types.h     |  7 -------
 7 files changed, 20 insertions(+), 27 deletions(-)

diff --git a/drivers/md/bcache/movinggc.c b/drivers/md/bcache/movinggc.c
index 99499d1f6e6666..9f32901fdad102 100644
--- a/drivers/md/bcache/movinggc.c
+++ b/drivers/md/bcache/movinggc.c
@@ -160,7 +160,7 @@ static void read_moving(struct cache_set *c)
 		moving_init(io);
 		bio = &io->bio.bio;
 
-		bio_set_op_attrs(bio, REQ_OP_READ, 0);
+		bio->bi_opf = REQ_OP_READ;
 		bio->bi_end_io	= read_moving_endio;
 
 		if (bch_bio_alloc_pages(bio, GFP_KERNEL))
diff --git a/drivers/md/bcache/request.c b/drivers/md/bcache/request.c
index 3427555b0ccae4..39c7b607f8aad8 100644
--- a/drivers/md/bcache/request.c
+++ b/drivers/md/bcache/request.c
@@ -244,7 +244,7 @@ static void bch_data_insert_start(struct closure *cl)
 		trace_bcache_cache_insert(k);
 		bch_keylist_push(&op->insert_keys);
 
-		bio_set_op_attrs(n, REQ_OP_WRITE, 0);
+		n->bi_opf = REQ_OP_WRITE;
 		bch_submit_bbio(n, op->c, k, 0);
 	} while (n != bio);
 
diff --git a/drivers/md/bcache/writeback.c b/drivers/md/bcache/writeback.c
index 0285b676e9834a..d4a5fc0650bb29 100644
--- a/drivers/md/bcache/writeback.c
+++ b/drivers/md/bcache/writeback.c
@@ -434,7 +434,7 @@ static void write_dirty(struct closure *cl)
 	 */
 	if (KEY_DIRTY(&w->key)) {
 		dirty_init(w);
-		bio_set_op_attrs(&io->bio, REQ_OP_WRITE, 0);
+		io->bio.bi_opf = REQ_OP_WRITE;
 		io->bio.bi_iter.bi_sector = KEY_START(&w->key);
 		bio_set_dev(&io->bio, io->dc->bdev);
 		io->bio.bi_end_io	= dirty_endio;
@@ -547,7 +547,7 @@ static void read_dirty(struct cached_dev *dc)
 			io->sequence    = sequence++;
 
 			dirty_init(w);
-			bio_set_op_attrs(&io->bio, REQ_OP_READ, 0);
+			io->bio.bi_opf = REQ_OP_READ;
 			io->bio.bi_iter.bi_sector = PTR_OFFSET(&w->key, 0);
 			bio_set_dev(&io->bio, dc->disk.c->cache->bdev);
 			io->bio.bi_end_io	= read_dirty_endio;
diff --git a/drivers/md/dm-thin.c b/drivers/md/dm-thin.c
index e76c96c760a9b5..c2b5a537f5b8ad 100644
--- a/drivers/md/dm-thin.c
+++ b/drivers/md/dm-thin.c
@@ -410,7 +410,7 @@ static void end_discard(struct discard_op *op, int r)
 		 * need to wait for the chain to complete.
 		 */
 		bio_chain(op->bio, op->parent_bio);
-		bio_set_op_attrs(op->bio, REQ_OP_DISCARD, 0);
+		op->bio->bi_opf = REQ_OP_DISCARD;
 		submit_bio(op->bio);
 	}
 
diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index 58f705f4294801..68a9e2d9985b2f 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -1321,7 +1321,7 @@ static void raid1_read_request(struct mddev *mddev, struct bio *bio,
 	read_bio->bi_iter.bi_sector = r1_bio->sector +
 		mirror->rdev->data_offset;
 	read_bio->bi_end_io = raid1_end_read_request;
-	bio_set_op_attrs(read_bio, op, do_sync);
+	read_bio->bi_opf = op | do_sync;
 	if (test_bit(FailFast, &mirror->rdev->flags) &&
 	    test_bit(R1BIO_FailFast, &r1_bio->state))
 	        read_bio->bi_opf |= MD_FAILFAST;
@@ -2254,7 +2254,7 @@ static void sync_request_write(struct mddev *mddev, struct r1bio *r1_bio)
 			continue;
 		}
 
-		bio_set_op_attrs(wbio, REQ_OP_WRITE, 0);
+		wbio->bi_opf = REQ_OP_WRITE;
 		if (test_bit(FailFast, &conf->mirrors[i].rdev->flags))
 			wbio->bi_opf |= MD_FAILFAST;
 
@@ -2419,7 +2419,7 @@ static int narrow_write_error(struct r1bio *r1_bio, int i)
 					       GFP_NOIO, &mddev->bio_set);
 		}
 
-		bio_set_op_attrs(wbio, REQ_OP_WRITE, 0);
+		wbio->bi_opf = REQ_OP_WRITE;
 		wbio->bi_iter.bi_sector = r1_bio->sector;
 		wbio->bi_iter.bi_size = r1_bio->sectors << 9;
 
@@ -2770,7 +2770,7 @@ static sector_t raid1_sync_request(struct mddev *mddev, sector_t sector_nr,
 			if (i < conf->raid_disks)
 				still_degraded = 1;
 		} else if (!test_bit(In_sync, &rdev->flags)) {
-			bio_set_op_attrs(bio, REQ_OP_WRITE, 0);
+			bio->bi_opf = REQ_OP_WRITE;
 			bio->bi_end_io = end_sync_write;
 			write_targets ++;
 		} else {
@@ -2797,7 +2797,7 @@ static sector_t raid1_sync_request(struct mddev *mddev, sector_t sector_nr,
 					if (disk < 0)
 						disk = i;
 				}
-				bio_set_op_attrs(bio, REQ_OP_READ, 0);
+				bio->bi_opf = REQ_OP_READ;
 				bio->bi_end_io = end_sync_read;
 				read_targets++;
 			} else if (!test_bit(WriteErrorSeen, &rdev->flags) &&
@@ -2809,7 +2809,7 @@ static sector_t raid1_sync_request(struct mddev *mddev, sector_t sector_nr,
 				 * if we are doing resync or repair. Otherwise, leave
 				 * this device alone for this sync request.
 				 */
-				bio_set_op_attrs(bio, REQ_OP_WRITE, 0);
+				bio->bi_opf = REQ_OP_WRITE;
 				bio->bi_end_io = end_sync_write;
 				write_targets++;
 			}
diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index 9a6503f5cb982e..6c66357f92f559 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -1254,7 +1254,7 @@ static void raid10_read_request(struct mddev *mddev, struct bio *bio,
 	read_bio->bi_iter.bi_sector = r10_bio->devs[slot].addr +
 		choose_data_offset(r10_bio, rdev);
 	read_bio->bi_end_io = raid10_end_read_request;
-	bio_set_op_attrs(read_bio, op, do_sync);
+	read_bio->bi_opf = op | do_sync;
 	if (test_bit(FailFast, &rdev->flags) &&
 	    test_bit(R10BIO_FailFast, &r10_bio->state))
 	        read_bio->bi_opf |= MD_FAILFAST;
@@ -1301,7 +1301,7 @@ static void raid10_write_one_disk(struct mddev *mddev, struct r10bio *r10_bio,
 	mbio->bi_iter.bi_sector	= (r10_bio->devs[n_copy].addr +
 				   choose_data_offset(r10_bio, rdev));
 	mbio->bi_end_io	= raid10_end_write_request;
-	bio_set_op_attrs(mbio, op, do_sync | do_fua);
+	mbio->bi_opf = op | do_sync | do_fua;
 	if (!replacement && test_bit(FailFast,
 				     &conf->mirrors[devnum].rdev->flags)
 			 && enough(conf, devnum))
@@ -2933,7 +2933,7 @@ static int narrow_write_error(struct r10bio *r10_bio, int i)
 		wsector = r10_bio->devs[i].addr + (sector - r10_bio->sector);
 		wbio->bi_iter.bi_sector = wsector +
 				   choose_data_offset(r10_bio, rdev);
-		bio_set_op_attrs(wbio, REQ_OP_WRITE, 0);
+		wbio->bi_opf = REQ_OP_WRITE;
 
 		if (submit_bio_wait(wbio) < 0)
 			/* Failure! */
@@ -3542,7 +3542,7 @@ static sector_t raid10_sync_request(struct mddev *mddev, sector_t sector_nr,
 				bio->bi_next = biolist;
 				biolist = bio;
 				bio->bi_end_io = end_sync_read;
-				bio_set_op_attrs(bio, REQ_OP_READ, 0);
+				bio->bi_opf = REQ_OP_READ;
 				if (test_bit(FailFast, &rdev->flags))
 					bio->bi_opf |= MD_FAILFAST;
 				from_addr = r10_bio->devs[j].addr;
@@ -3567,7 +3567,7 @@ static sector_t raid10_sync_request(struct mddev *mddev, sector_t sector_nr,
 					bio->bi_next = biolist;
 					biolist = bio;
 					bio->bi_end_io = end_sync_write;
-					bio_set_op_attrs(bio, REQ_OP_WRITE, 0);
+					bio->bi_opf = REQ_OP_WRITE;
 					bio->bi_iter.bi_sector = to_addr
 						+ mrdev->data_offset;
 					bio_set_dev(bio, mrdev->bdev);
@@ -3588,7 +3588,7 @@ static sector_t raid10_sync_request(struct mddev *mddev, sector_t sector_nr,
 				bio->bi_next = biolist;
 				biolist = bio;
 				bio->bi_end_io = end_sync_write;
-				bio_set_op_attrs(bio, REQ_OP_WRITE, 0);
+				bio->bi_opf = REQ_OP_WRITE;
 				bio->bi_iter.bi_sector = to_addr +
 					mreplace->data_offset;
 				bio_set_dev(bio, mreplace->bdev);
@@ -3742,7 +3742,7 @@ static sector_t raid10_sync_request(struct mddev *mddev, sector_t sector_nr,
 			bio->bi_next = biolist;
 			biolist = bio;
 			bio->bi_end_io = end_sync_read;
-			bio_set_op_attrs(bio, REQ_OP_READ, 0);
+			bio->bi_opf = REQ_OP_READ;
 			if (test_bit(FailFast, &rdev->flags))
 				bio->bi_opf |= MD_FAILFAST;
 			bio->bi_iter.bi_sector = sector + rdev->data_offset;
@@ -3764,7 +3764,7 @@ static sector_t raid10_sync_request(struct mddev *mddev, sector_t sector_nr,
 			bio->bi_next = biolist;
 			biolist = bio;
 			bio->bi_end_io = end_sync_write;
-			bio_set_op_attrs(bio, REQ_OP_WRITE, 0);
+			bio->bi_opf = REQ_OP_WRITE;
 			if (test_bit(FailFast, &rdev->flags))
 				bio->bi_opf |= MD_FAILFAST;
 			bio->bi_iter.bi_sector = sector + rdev->data_offset;
@@ -4970,7 +4970,7 @@ static sector_t reshape_request(struct mddev *mddev, sector_t sector_nr,
 		b->bi_iter.bi_sector = r10_bio->devs[s/2].addr +
 			rdev2->new_data_offset;
 		b->bi_end_io = end_reshape_write;
-		bio_set_op_attrs(b, REQ_OP_WRITE, 0);
+		b->bi_opf = REQ_OP_WRITE;
 		b->bi_next = blist;
 		blist = b;
 	}
diff --git a/include/linux/blk_types.h b/include/linux/blk_types.h
index e0b098089ef2b7..99be590f952f6e 100644
--- a/include/linux/blk_types.h
+++ b/include/linux/blk_types.h
@@ -472,13 +472,6 @@ static inline enum req_op bio_op(const struct bio *bio)
 	return bio->bi_opf & REQ_OP_MASK;
 }
 
-/* obsolete, don't use in new code */
-static inline void bio_set_op_attrs(struct bio *bio, enum req_op op,
-				    blk_opf_t op_flags)
-{
-	bio->bi_opf = op | op_flags;
-}
-
 static inline bool op_is_write(blk_opf_t op)
 {
 	return !!(op & (__force blk_opf_t)1);
-- 
2.35.1

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel


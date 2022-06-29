Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A36ADC43334
	for <dm-devel@archiver.kernel.org>; Wed, 29 Jun 2022 22:09:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1656540593;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=ym/yJVf5SdEnu4qV2PO980rXOOLjZZejvM0OHeZBLJk=;
	b=f78GDbSNeW5GWcoi5ueq5j2rQIpJ6KNe7QuNQtAyvf28kK44YK+f2zifsZHqpDySfqjNrd
	78RPKHHEtUqYvLUQocKocxcOBN1SkB7zhSpzvUxqfEgPLt7ASBWe+Rcs/HuhsA9SV2C9BV
	rfSw+t4jinROILSjMbGgo+Ju0Sjkjj8=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-442-VY3e3wMAMAyC6j464LqEug-1; Wed, 29 Jun 2022 18:09:50 -0400
X-MC-Unique: VY3e3wMAMAyC6j464LqEug-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D92823C025AF;
	Wed, 29 Jun 2022 22:09:48 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id A350B2166B26;
	Wed, 29 Jun 2022 22:09:47 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 6BF9A194705D;
	Wed, 29 Jun 2022 22:09:47 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com
 [10.11.54.9])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id A130C1947058
 for <dm-devel@listman.corp.redhat.com>; Wed, 29 Jun 2022 21:55:20 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 92802492CA3; Wed, 29 Jun 2022 21:55:20 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 8E9EC492C3B
 for <dm-devel@redhat.com>; Wed, 29 Jun 2022 21:55:20 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 7431885A581
 for <dm-devel@redhat.com>; Wed, 29 Jun 2022 21:55:20 +0000 (UTC)
Received: from mail-qv1-f48.google.com (mail-qv1-f48.google.com
 [209.85.219.48]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-651-akJtult3M1C9b400GFaurQ-1; Wed, 29 Jun 2022 17:55:18 -0400
X-MC-Unique: akJtult3M1C9b400GFaurQ-1
Received: by mail-qv1-f48.google.com with SMTP id 2so12017220qvc.0
 for <dm-devel@redhat.com>; Wed, 29 Jun 2022 14:55:17 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
 :references;
 bh=V4WIFv6/9QXGVzve1iZ5cllAkxMnd3EqiiDqn4ywaWQ=;
 b=0fx6J5EzTO0xOdTr51ZNForn2lERJwHMgprTxWVzHd9W0pscCPyTOokw1a8+KFTP+S
 aEBQr6Yt/LMkzrjJAyr5PJtEwhQdBJKH59LqMr0KRnKBYybvp/ufxYBfYPtc+n+om4sZ
 /YPLYZs6iBkBimx75RtDHQ128wE1r0qObwgTKrRzSYBVbpLRTeBRYbleQMZZDMEETiN5
 7YzYmzqtM2J1rCb9ljj4PI8V78eV1nFUHDApgO/2YN1D5bNOrqb3fu0HL6CWXdq9OXLV
 /BMf4RmKEJlcFLPCuo2Y0TV6Wk2HjJoN1WvIQV4bwB1qQVGBmODuhNcW5O9U7xp8D3dy
 lF5w==
X-Gm-Message-State: AJIora9MhxH2YeNl+9nIMtUbK0hQr69zsOviekWHsa0En4nQz9wIV3+w
 b1ueHFgH8GwUUx7SFbHO0U7dgMw=
X-Google-Smtp-Source: AGRyM1vGP9ahroRWPNKQa7zd/OIuNTTAvBPPSN2YXnBSN34bn4JkRZL5yT1XQccXSE5zVzjuDecwkg==
X-Received: by 2002:ad4:5aad:0:b0:472:7486:31ac with SMTP id
 u13-20020ad45aad000000b00472748631acmr9924010qvg.75.1656539717461; 
 Wed, 29 Jun 2022 14:55:17 -0700 (PDT)
Received: from localhost (pool-68-160-176-52.bstnma.fios.verizon.net.
 [68.160.176.52]) by smtp.gmail.com with ESMTPSA id
 u4-20020a05620a430400b006a6d7c3a82esm13743481qko.15.2022.06.29.14.55.16
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Wed, 29 Jun 2022 14:55:17 -0700 (PDT)
From: Mike Snitzer <snitzer@kernel.org>
To: Jens Axboe <axboe@kernel.dk>,
	Ming Lei <ming.lei@redhat.com>
Date: Wed, 29 Jun 2022 17:55:12 -0400
Message-Id: <20220629215513.37860-3-snitzer@kernel.org>
In-Reply-To: <20220629215513.37860-1-snitzer@kernel.org>
References: <20220629215513.37860-1-snitzer@kernel.org>
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.9
Subject: [dm-devel] [PATCH 5.20 v2 2/3] block: add bio_rewind() API
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
Cc: linux-block@vger.kernel.org, dm-devel@redhat.com,
 Kent Overstreet <kent.overstreet@gmail.com>,
 "Martin K . Petersen" <martin.petersen@oracle.com>,
 Eric Biggers <ebiggers@google.com>
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

From: Ming Lei <ming.lei@redhat.com>

Commit 7759eb23fd98 ("block: remove bio_rewind_iter()") removes
the similar API because the following reasons:

    ```
    It is pointed that bio_rewind_iter() is one very bad API[1]:

    1) bio size may not be restored after rewinding

    2) it causes some bogus change, such as 5151842b9d8732 (block: reset
    bi_iter.bi_done after splitting bio)

    3) rewinding really makes things complicated wrt. bio splitting

    4) unnecessary updating of .bi_done in fast path

    [1] https://marc.info/?t=153549924200005&r=1&w=2

    So this patch takes Kent's suggestion to restore one bio into its original
    state via saving bio iterator(struct bvec_iter) in bio_integrity_prep(),
    given now bio_rewind_iter() is only used by bio integrity code.
    ```

However, saving off a copy of the 32 bytes bio->bi_iter in case rewind
needed isn't efficient because it bloats per-bio-data for what is an
unlikely case. That suggestion also ignores the need to restore
crypto and integrity info.

Add bio_rewind() API for a specific use-case that is much more narrow
than the previous more generic rewind code that was reverted:

1) most bios have a fixed end sector since bio split is done from front
   of the bio, if driver just records how many sectors between current
   bio's start sector and the original bio's end sector, the original
   position can be restored. Keeping the original bio's end sector
   fixed is a _hard_ requirement for this bio_rewind() interface!

2) if a bio's end sector won't change (usually bio_trim() isn't
   called, or in the case of DM it preserves original bio), user can
   restore original position by the storing sector offset from the
   current ->bi_iter.bi_sector to bio's end sector; together with
   saving bio size, only 8 bytes is needed to restore to original
   bio.

3) DM's requeue use case: when BLK_STS_DM_REQUEUE happens, DM core
   needs to restore to an "original bio" which represents the current
   dm_io to be requeued (which may be a subset of the original bio).
   By storing the sector offset from the original bio's end sector and
   dm_io's size, bio_rewind() can restore such original bio. See
   commit 7dd76d1feec7 ("dm: improve bio splitting and associated IO
   accounting") for more details on how DM does this. Leveraging this,
   allows DM core to shift the need for bio cloning from bio-split
   time (during IO submission) to the less likely BLK_STS_DM_REQUEUE
   handling (after IO completes with that error).

4) Unlike the original rewind API, bio_rewind() doesn't add .bi_done
   to bvec_iter and there is no effect on the fast path.

Implement bio_wind() by factoring out clear helpers that it calls:
bio_integrity_rewind, bio_crypt_rewind and bio_rewind_iter.

Signed-off-by: Ming Lei <ming.lei@redhat.com>
Signed-off-by: Mike Snitzer <snitzer@kernel.org>
---
 block/bio-integrity.c       | 19 +++++++++++++++++++
 block/bio.c                 | 20 ++++++++++++++++++++
 block/blk-crypto-internal.h |  7 +++++++
 block/blk-crypto.c          | 25 +++++++++++++++++++++++++
 include/linux/bio.h         | 21 +++++++++++++++++++++
 include/linux/bvec.h        | 33 +++++++++++++++++++++++++++++++++
 6 files changed, 125 insertions(+)

diff --git a/block/bio-integrity.c b/block/bio-integrity.c
index 32929c89ba8a..06c2fe81fdf2 100644
--- a/block/bio-integrity.c
+++ b/block/bio-integrity.c
@@ -378,6 +378,25 @@ void bio_integrity_advance(struct bio *bio, unsigned int bytes_done)
 	bvec_iter_advance(bip->bip_vec, &bip->bip_iter, bytes);
 }
 
+/**
+ * bio_integrity_rewind - Rewind integrity vector
+ * @bio:	bio whose integrity vector to update
+ * @bytes_done:	number of data bytes to rewind
+ *
+ * Description: This function calculates how many integrity bytes the
+ * number of completed data bytes correspond to and rewind the
+ * integrity vector accordingly.
+ */
+void bio_integrity_rewind(struct bio *bio, unsigned int bytes_done)
+{
+	struct bio_integrity_payload *bip = bio_integrity(bio);
+	struct blk_integrity *bi = blk_get_integrity(bio->bi_bdev->bd_disk);
+	unsigned bytes = bio_integrity_bytes(bi, bytes_done >> 9);
+
+	bip->bip_iter.bi_sector -= bio_integrity_intervals(bi, bytes_done >> 9);
+	bvec_iter_rewind(bip->bip_vec, &bip->bip_iter, bytes);
+}
+
 /**
  * bio_integrity_trim - Trim integrity vector
  * @bio:	bio whose integrity vector to update
diff --git a/block/bio.c b/block/bio.c
index 933ea3210954..38a4ad757777 100644
--- a/block/bio.c
+++ b/block/bio.c
@@ -1348,6 +1348,26 @@ void __bio_advance(struct bio *bio, unsigned bytes)
 }
 EXPORT_SYMBOL(__bio_advance);
 
+/**
+ * bio_rewind - update ->bi_iter of @bio by rewinding @bytes.
+ * @bio: bio to rewind
+ * @bytes: how many bytes to rewind
+ *
+ * WARNING:
+ * Caller must ensure that @bio has a fixed end sector, to allow
+ * rewinding from end of bio and restoring its original position.
+ * Caller is also responsibile for restoring bio's size.
+ */
+void bio_rewind(struct bio *bio, unsigned bytes)
+{
+	if (bio_integrity(bio))
+		bio_integrity_rewind(bio, bytes);
+
+	bio_crypt_rewind(bio, bytes);
+	bio_rewind_iter(bio, &bio->bi_iter, bytes);
+}
+EXPORT_SYMBOL(bio_rewind);
+
 void bio_copy_data_iter(struct bio *dst, struct bvec_iter *dst_iter,
 			struct bio *src, struct bvec_iter *src_iter)
 {
diff --git a/block/blk-crypto-internal.h b/block/blk-crypto-internal.h
index e6818ffaddbf..b723599bbf99 100644
--- a/block/blk-crypto-internal.h
+++ b/block/blk-crypto-internal.h
@@ -114,6 +114,13 @@ static inline void bio_crypt_advance(struct bio *bio, unsigned int bytes)
 		__bio_crypt_advance(bio, bytes);
 }
 
+void __bio_crypt_rewind(struct bio *bio, unsigned int bytes);
+static inline void bio_crypt_rewind(struct bio *bio, unsigned int bytes)
+{
+	if (bio_has_crypt_ctx(bio))
+		__bio_crypt_rewind(bio, bytes);
+}
+
 void __bio_crypt_free_ctx(struct bio *bio);
 static inline void bio_crypt_free_ctx(struct bio *bio)
 {
diff --git a/block/blk-crypto.c b/block/blk-crypto.c
index a496aaef85ba..e3584b5a6822 100644
--- a/block/blk-crypto.c
+++ b/block/blk-crypto.c
@@ -134,6 +134,23 @@ void bio_crypt_dun_increment(u64 dun[BLK_CRYPTO_DUN_ARRAY_SIZE],
 	}
 }
 
+/* Decrements @dun by @dec, treating @dun as a multi-limb integer. */
+void bio_crypt_dun_decrement(u64 dun[BLK_CRYPTO_DUN_ARRAY_SIZE],
+			     unsigned int dec)
+{
+	int i;
+
+	for (i = 0; dec && i < BLK_CRYPTO_DUN_ARRAY_SIZE; i++) {
+		u64 prev = dun[i];
+
+		dun[i] -= dec;
+		if (dun[i] > prev)
+			dec = 1;
+		else
+			dec = 0;
+	}
+}
+
 void __bio_crypt_advance(struct bio *bio, unsigned int bytes)
 {
 	struct bio_crypt_ctx *bc = bio->bi_crypt_context;
@@ -142,6 +159,14 @@ void __bio_crypt_advance(struct bio *bio, unsigned int bytes)
 				bytes >> bc->bc_key->data_unit_size_bits);
 }
 
+void __bio_crypt_rewind(struct bio *bio, unsigned int bytes)
+{
+	struct bio_crypt_ctx *bc = bio->bi_crypt_context;
+
+	bio_crypt_dun_decrement(bc->bc_dun,
+				bytes >> bc->bc_key->data_unit_size_bits);
+}
+
 /*
  * Returns true if @bc->bc_dun plus @bytes converted to data units is equal to
  * @next_dun, treating the DUNs as multi-limb integers.
diff --git a/include/linux/bio.h b/include/linux/bio.h
index 992ee987f273..4e6674f232b4 100644
--- a/include/linux/bio.h
+++ b/include/linux/bio.h
@@ -105,6 +105,19 @@ static inline void bio_advance_iter(const struct bio *bio,
 		/* TODO: It is reasonable to complete bio with error here. */
 }
 
+static inline void bio_rewind_iter(const struct bio *bio,
+				    struct bvec_iter *iter, unsigned int bytes)
+{
+	iter->bi_sector -= bytes >> 9;
+
+	/* No advance means no rewind */
+	if (bio_no_advance_iter(bio))
+		iter->bi_size += bytes;
+	else
+		bvec_iter_rewind(bio->bi_io_vec, iter, bytes);
+		/* TODO: It is reasonable to complete bio with error here. */
+}
+
 /* @bytes should be less or equal to bvec[i->bi_idx].bv_len */
 static inline void bio_advance_iter_single(const struct bio *bio,
 					   struct bvec_iter *iter,
@@ -119,6 +132,7 @@ static inline void bio_advance_iter_single(const struct bio *bio,
 }
 
 void __bio_advance(struct bio *, unsigned bytes);
+void bio_rewind(struct bio *, unsigned bytes);
 
 /**
  * bio_advance - increment/complete a bio by some number of bytes
@@ -699,6 +713,7 @@ extern struct bio_integrity_payload *bio_integrity_alloc(struct bio *, gfp_t, un
 extern int bio_integrity_add_page(struct bio *, struct page *, unsigned int, unsigned int);
 extern bool bio_integrity_prep(struct bio *);
 extern void bio_integrity_advance(struct bio *, unsigned int);
+extern void bio_integrity_rewind(struct bio *, unsigned int);
 extern void bio_integrity_trim(struct bio *);
 extern int bio_integrity_clone(struct bio *, struct bio *, gfp_t);
 extern int bioset_integrity_create(struct bio_set *, int);
@@ -739,6 +754,12 @@ static inline void bio_integrity_advance(struct bio *bio,
 	return;
 }
 
+static inline void bio_integrity_rewind(struct bio *bio,
+					 unsigned int bytes_done)
+{
+	return;
+}
+
 static inline void bio_integrity_trim(struct bio *bio)
 {
 	return;
diff --git a/include/linux/bvec.h b/include/linux/bvec.h
index 35c25dff651a..b56d92e939c1 100644
--- a/include/linux/bvec.h
+++ b/include/linux/bvec.h
@@ -122,6 +122,39 @@ static inline bool bvec_iter_advance(const struct bio_vec *bv,
 	return true;
 }
 
+static inline bool bvec_iter_rewind(const struct bio_vec *bv,
+				     struct bvec_iter *iter,
+				     unsigned int bytes)
+{
+	int idx;
+
+	iter->bi_size += bytes;
+	if (bytes <= iter->bi_bvec_done) {
+		iter->bi_bvec_done -= bytes;
+		return true;
+	}
+
+	bytes -= iter->bi_bvec_done;
+	idx = iter->bi_idx - 1;
+
+	while (idx >= 0 && bytes && bytes > bv[idx].bv_len) {
+		bytes -= bv[idx].bv_len;
+		idx--;
+	}
+
+	if (WARN_ONCE(idx < 0 && bytes,
+		      "Attempted to rewind iter beyond bvec's boundaries\n")) {
+		iter->bi_size -= bytes;
+		iter->bi_bvec_done = 0;
+		iter->bi_idx = 0;
+		return false;
+	}
+
+	iter->bi_idx = idx;
+	iter->bi_bvec_done = bv[idx].bv_len - bytes;
+	return true;
+}
+
 /*
  * A simpler version of bvec_iter_advance(), @bytes should not span
  * across multiple bvec entries, i.e. bytes <= bv[i->bi_idx].bv_len
-- 
2.15.0

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel


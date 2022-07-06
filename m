Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BC7D8C43334
	for <dm-devel@archiver.kernel.org>; Wed,  6 Jul 2022 17:44:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1657129462;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=MfMTMbNousWk3HLksHM4k9OXTOjZSVgTKXBaKeMdJo8=;
	b=ba177UoeSEfhSDNyClfmQ06/NP0leQCWUXZkrQMbxz5UJeDxt3GmPckWG+UxeBRcHoSGtw
	2jS6yonZuAS+1Yqod0Tn9hRFsoa/kvS6jcoLPV5g8OldqTt+hp3WVHYTD3ibBJ00yoHY/q
	GhGq2DfSrohdStfGG3ZdQMAqhd8fVVQ=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-556-hE2G8D9FNi2tFJBGw_11BQ-1; Wed, 06 Jul 2022 13:44:13 -0400
X-MC-Unique: hE2G8D9FNi2tFJBGw_11BQ-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 12FFF18A6586;
	Wed,  6 Jul 2022 17:44:12 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 06E3B40CF8E7;
	Wed,  6 Jul 2022 17:44:10 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 684BB194706E;
	Wed,  6 Jul 2022 17:44:09 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
 [10.11.54.3])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 8A0F7194704E
 for <dm-devel@listman.corp.redhat.com>; Wed,  6 Jul 2022 17:44:08 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 6B7FC1121320; Wed,  6 Jul 2022 17:44:08 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 670A51121315
 for <dm-devel@redhat.com>; Wed,  6 Jul 2022 17:44:08 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 4B7C28339A4
 for <dm-devel@redhat.com>; Wed,  6 Jul 2022 17:44:08 +0000 (UTC)
Received: from mail-qk1-f178.google.com (mail-qk1-f178.google.com
 [209.85.222.178]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-407-MySDNq2bN_epbM0DjiAO4Q-1; Wed, 06 Jul 2022 13:44:06 -0400
X-MC-Unique: MySDNq2bN_epbM0DjiAO4Q-1
Received: by mail-qk1-f178.google.com with SMTP id k20so11615260qkj.1
 for <dm-devel@redhat.com>; Wed, 06 Jul 2022 10:44:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
 :references;
 bh=4aJPJnUyGDLhuRd915bE7Ld6etx47YZKGWzxEZhIh5M=;
 b=65ZhkaEL0iwOSZsADqk/dXB+8khdcn5FPJYwwYQXzx5l6wkOf4iMXcmtsz96gQWwFt
 riAZhGtkFE4izTd5syV4ug5KJX+h0hwKpHLztI2JFbwPsVL5Iijk4TKzeWGvu/+HSgAQ
 sQmpFuA1ErvxLPCh1QYWQsb2sZeVL0ScPMJeVbv3q5Z3DSKI3ds7quTjyRxjSvk0CFGx
 dWyYDrzTNANv30LXhWDj2drOodBPTbStvh0UqNNnGmSUGvl4OV0FMl0v7rnOCXfqvXRd
 oP3CM4NSQbW3iXJe2e/m4ge2vlhH6I2Aqeh74Mh1QjlsjyeYjt+Z/1cHXwdc+LPs/fTt
 nOmQ==
X-Gm-Message-State: AJIora+DIDDgzz8Yqd7aVltqNAo1tv/G9GExDqKiVJ/gECcNKUX11z6I
 wZc5G3t9vj6gk3M6yPhJbiNn+7ZmFWeTnKlCCQOeLE/rN7zr/d82ghEIA3sSbx1wcTDrxh8d8N0
 XWX6dv3b84vZwxw5h/AXfXe+0essTA7fJ91W3B0pzSkRf1mCU113uYoKlLdSlgkgEmr8=
X-Google-Smtp-Source: AGRyM1uNrZrO9fQAI5ero6hmTyHbveGcNBnBKZdnYsoKgRJr7AFVvhpM5mCo6xPw1XfK9W6fjYP5uQ==
X-Received: by 2002:a05:620a:4548:b0:6af:5a0:fa34 with SMTP id
 u8-20020a05620a454800b006af05a0fa34mr28424240qkp.29.1657129445996; 
 Wed, 06 Jul 2022 10:44:05 -0700 (PDT)
Received: from localhost (pool-68-160-176-52.bstnma.fios.verizon.net.
 [68.160.176.52]) by smtp.gmail.com with ESMTPSA id
 c190-20020ae9edc7000000b006a743b360bcsm28929053qkg.136.2022.07.06.10.44.05
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Wed, 06 Jul 2022 10:44:05 -0700 (PDT)
From: Mike Snitzer <snitzer@kernel.org>
To: dm-devel@redhat.com
Date: Wed,  6 Jul 2022 13:44:02 -0400
Message-Id: <20220706174403.79317-2-snitzer@kernel.org>
In-Reply-To: <20220706174403.79317-1-snitzer@kernel.org>
References: <20220706174403.79317-1-snitzer@kernel.org>
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.3
Subject: [dm-devel] [5.20 PATCH v3 1/2] dm: add bio_rewind() API to DM core
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
Cc: linux-block@vger.kernel.org
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

From: Ming Lei <ming.lei@redhat.com>

Commit 7759eb23fd98 ("block: remove bio_rewind_iter()") removed
a similar API for the following reasons:
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
   restore the original position by storing sector offset from the
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

Implement bio_rewind() by factoring out clear helpers that it calls:
bio_integrity_rewind, bio_crypt_rewind and bio_rewind_iter.

DM is able to ensure that bio_rewind() is used safely but, given the
constraint that the bio's end must never change, other hypothetical
future callers may not take the same care. So make bio_rewind() and
all supporting code local to DM to avoid risk of hypothetical abuse.

Suggested-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Ming Lei <ming.lei@redhat.com>
Signed-off-by: Mike Snitzer <snitzer@kernel.org>
---
 drivers/md/Makefile       |   2 +-
 drivers/md/dm-core.h      |   2 +
 drivers/md/dm-io-rewind.c | 143 ++++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 146 insertions(+), 1 deletion(-)
 create mode 100644 drivers/md/dm-io-rewind.c

diff --git a/drivers/md/Makefile b/drivers/md/Makefile
index 0454b0885b01..270f694850ec 100644
--- a/drivers/md/Makefile
+++ b/drivers/md/Makefile
@@ -5,7 +5,7 @@
 
 dm-mod-y	+= dm.o dm-table.o dm-target.o dm-linear.o dm-stripe.o \
 		   dm-ioctl.o dm-io.o dm-kcopyd.o dm-sysfs.o dm-stats.o \
-		   dm-rq.o
+		   dm-rq.o dm-io-rewind.o
 dm-multipath-y	+= dm-path-selector.o dm-mpath.o
 dm-historical-service-time-y += dm-ps-historical-service-time.o
 dm-io-affinity-y += dm-ps-io-affinity.o
diff --git a/drivers/md/dm-core.h b/drivers/md/dm-core.h
index 5d9afca0d105..5793a27b2118 100644
--- a/drivers/md/dm-core.h
+++ b/drivers/md/dm-core.h
@@ -319,4 +319,6 @@ extern atomic_t dm_global_event_nr;
 extern wait_queue_head_t dm_global_eventq;
 void dm_issue_global_event(void);
 
+void bio_rewind(struct bio *bio, unsigned bytes);
+
 #endif
diff --git a/drivers/md/dm-io-rewind.c b/drivers/md/dm-io-rewind.c
new file mode 100644
index 000000000000..fbeaa8a342ed
--- /dev/null
+++ b/drivers/md/dm-io-rewind.c
@@ -0,0 +1,143 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*
+ * Copyright 2022 Red Hat, Inc.
+ */
+
+#include <linux/bio.h>
+#include <linux/blk-crypto.h>
+#include <linux/blk-integrity.h>
+
+#include "dm-core.h"
+
+static inline bool bvec_iter_rewind(const struct bio_vec *bv,
+				    struct bvec_iter *iter,
+				    unsigned int bytes)
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
+#if defined(CONFIG_BLK_DEV_INTEGRITY)
+
+/**
+ * bio_integrity_rewind - Rewind integrity vector
+ * @bio:	bio whose integrity vector to update
+ * @bytes_done:	number of data bytes to rewind
+ *
+ * Description: This function calculates how many integrity bytes the
+ * number of completed data bytes correspond to and rewind the
+ * integrity vector accordingly.
+ */
+static void bio_integrity_rewind(struct bio *bio, unsigned int bytes_done)
+{
+	struct bio_integrity_payload *bip = bio_integrity(bio);
+	struct blk_integrity *bi = blk_get_integrity(bio->bi_bdev->bd_disk);
+	unsigned bytes = bio_integrity_bytes(bi, bytes_done >> 9);
+
+	bip->bip_iter.bi_sector -= bio_integrity_intervals(bi, bytes_done >> 9);
+	bvec_iter_rewind(bip->bip_vec, &bip->bip_iter, bytes);
+}
+
+#else /* CONFIG_BLK_DEV_INTEGRITY */
+
+static inline void bio_integrity_rewind(struct bio *bio,
+					unsigned int bytes_done)
+{
+	return;
+}
+
+#endif
+
+#if defined(CONFIG_BLK_INLINE_ENCRYPTION)
+
+/* Decrements @dun by @dec, treating @dun as a multi-limb integer. */
+static void bio_crypt_dun_decrement(u64 dun[BLK_CRYPTO_DUN_ARRAY_SIZE],
+				    unsigned int dec)
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
+static void bio_crypt_rewind(struct bio *bio, unsigned int bytes)
+{
+	struct bio_crypt_ctx *bc = bio->bi_crypt_context;
+
+	bio_crypt_dun_decrement(bc->bc_dun,
+				bytes >> bc->bc_key->data_unit_size_bits);
+}
+
+#else /* CONFIG_BLK_INLINE_ENCRYPTION */
+
+static inline void bio_crypt_rewind(struct bio *bio, unsigned int bytes)
+{
+	return;
+}
+
+#endif
+
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
+}
+
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
+	if (bio_has_crypt_ctx(bio))
+		bio_crypt_rewind(bio, bytes);
+
+	bio_rewind_iter(bio, &bio->bi_iter, bytes);
+}
-- 
2.15.0

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel


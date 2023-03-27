Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9641BC77B61
	for <dm-devel@archiver.kernel.org>; Mon, 27 Mar 2023 20:14:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1679948057;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=pyjwQH4wcZf8TFfktbWNPIS/X/s3JrFpOT5DpQqAMHk=;
	b=TVOwKOEj7hiDzEy+4JrI2bUzAtZ5/oaf/lSKReEdkzR9wet3wyQzKFsuPSJKhqPDOXeTRA
	tF21XW9b8RDMvKzK10dRGfp5udfEvDmCxAau7OYB5+4t0tS9PR5nsq9fId+U5H+ZV/ACWq
	6cvAzchYksYSJxhlL5YrGNE0rmoN2GM=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-570-r1XiNvFzNumrN02vE2gnvA-1; Mon, 27 Mar 2023 16:14:14 -0400
X-MC-Unique: r1XiNvFzNumrN02vE2gnvA-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id DFEE81C068DB;
	Mon, 27 Mar 2023 20:14:11 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id CF36AC33187;
	Mon, 27 Mar 2023 20:14:11 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 916411949742;
	Mon, 27 Mar 2023 20:13:56 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com
 [10.11.54.7])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 722B11946A6A
 for <dm-devel@listman.corp.redhat.com>; Mon, 27 Mar 2023 20:13:42 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 48AFC1415139; Mon, 27 Mar 2023 20:13:42 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 40F22140E96A
 for <dm-devel@redhat.com>; Mon, 27 Mar 2023 20:13:34 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 2C9B28828C5
 for <dm-devel@redhat.com>; Mon, 27 Mar 2023 20:13:34 +0000 (UTC)
Received: from mail-qt1-f169.google.com (mail-qt1-f169.google.com
 [209.85.160.169]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-656-WneT3H_5O4OSyrug76feqg-3; Mon, 27 Mar 2023 16:13:32 -0400
X-MC-Unique: WneT3H_5O4OSyrug76feqg-3
Received: by mail-qt1-f169.google.com with SMTP id p2so4726246qtw.13
 for <dm-devel@redhat.com>; Mon, 27 Mar 2023 13:13:32 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112; t=1679948012;
 h=content-transfer-encoding:mime-version:references:in-reply-to
 :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
 :subject:date:message-id:reply-to;
 bh=SBN3e8d5Qq0hFXuPFkD52ybusL049Itzx+LBtkZ2VOM=;
 b=MerJQ+yJW6XgdwWJC4GQ+lPsD98nrP9m7ONxWHyaCMaHvfe5M80ymxh4xcUrA9gDyU
 2fucGPNrYqMjm9YzL4H5PVjln2fdt+tU+B/qCPnpPkJ64WWTB7rE6b0fS2leNEGKHVzT
 U6TrHz883tP92bsK2kMsnNmJW3PdD2sPOgxg3o8T4oJWkzrsYWfyiWQuwtx9lba8wgdh
 KzKyo76K7e6OHlXrjicQS7GHheKjl/GV0YoIbeZ9sLRreQsK4y3dnU9zfku7WktWfmxQ
 fwTlOtCnOX/RPwTyJTFEldEWd3YaQknyqfQ1nmm1R/7Dk1ySXB+imCCkHnkwSvGXozcz
 g4Vw==
X-Gm-Message-State: AO0yUKXTuNJF1cQscMBLCBxo7Ucd43VHtBut7IwlhuyvYx+RJOyvP0m8
 Stp+Z2u0VbsDRVDW7Cb5k+MK/XEAwJWxbzzI1PmfgyfEwn4PIaIQ5OsKckc4UnSn6V7yxCEqVYb
 bSLRim++OQEOKr7RwSfM8J+FXHcYGsrOhtc3DC1zjUj/56wYnutP5AQeWDeLTv0C2Qkulpdu9Gx
 o=
X-Google-Smtp-Source: AK7set/KcR8zPzvyZmCoD66iZdu4uOgZL06cjihbV5XKhpEFExLT5A/6x5Rr5XaBiwEgxAgiHfTc4g==
X-Received: by 2002:ac8:58c6:0:b0:3e3:9199:d27 with SMTP id
 u6-20020ac858c6000000b003e391990d27mr22314214qta.53.1679948012077; 
 Mon, 27 Mar 2023 13:13:32 -0700 (PDT)
Received: from localhost (pool-68-160-166-30.bstnma.fios.verizon.net.
 [68.160.166.30]) by smtp.gmail.com with ESMTPSA id
 b126-20020ae9eb84000000b007468b183a65sm11345416qkg.30.2023.03.27.13.13.31
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Mon, 27 Mar 2023 13:13:31 -0700 (PDT)
From: Mike Snitzer <snitzer@kernel.org>
To: dm-devel@redhat.com
Date: Mon, 27 Mar 2023 16:11:38 -0400
Message-Id: <20230327201143.51026-16-snitzer@kernel.org>
In-Reply-To: <20230327201143.51026-1-snitzer@kernel.org>
References: <20230327201143.51026-1-snitzer@kernel.org>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.7
Subject: [dm-devel] [dm-6.4 PATCH v3 15/20] dm bio prison v1: add
 dm_cell_key_has_valid_range
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
Cc: axboe@kernel.dk, ebiggers@kernel.org, keescook@chromium.org,
 heinzm@redhat.com, Mike Snitzer <snitzer@kernel.org>, nhuck@google.com,
 linux-block@vger.kernel.org, ejt@redhat.com, mpatocka@redhat.com,
 luomeng12@huawei.com
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: kernel.org
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Don't have bio_detain() BUG_ON if a dm_cell_key is beyond
BIO_PRISON_MAX_RANGE or spans a boundary.

Update dm-thin.c:build_key() to use dm_cell_key_has_valid_range() which
will do this checking without using BUG_ON. Also update
process_discard_bio() to check the discard bio that DM core passes in
(having first imposed max_discard_granularity based splitting).

dm_cell_key_has_valid_range() will merely WARN_ON_ONCE if it returns
false because if it does: it is programmer error that should be caught
with proper testing. So relax the BUG_ONs to be WARN_ON_ONCE.

Signed-off-by: Mike Snitzer <snitzer@kernel.org>
---
 drivers/md/dm-bio-prison-v1.c | 14 +++++++++-----
 drivers/md/dm-bio-prison-v1.h |  5 +++++
 drivers/md/dm-thin.c          | 21 +++++++++++++++------
 3 files changed, 29 insertions(+), 11 deletions(-)

diff --git a/drivers/md/dm-bio-prison-v1.c b/drivers/md/dm-bio-prison-v1.c
index 2b8af861e5f6..78bb559b521c 100644
--- a/drivers/md/dm-bio-prison-v1.c
+++ b/drivers/md/dm-bio-prison-v1.c
@@ -120,12 +120,17 @@ static unsigned lock_nr(struct dm_cell_key *key)
 	return (key->block_begin >> BIO_PRISON_MAX_RANGE_SHIFT) & LOCK_MASK;
 }
 
-static void check_range(struct dm_cell_key *key)
+bool dm_cell_key_has_valid_range(struct dm_cell_key *key)
 {
-	BUG_ON(key->block_end - key->block_begin > BIO_PRISON_MAX_RANGE);
-	BUG_ON((key->block_begin >> BIO_PRISON_MAX_RANGE_SHIFT) !=
-	       ((key->block_end - 1) >> BIO_PRISON_MAX_RANGE_SHIFT));
+	if (WARN_ON_ONCE(key->block_end - key->block_begin > BIO_PRISON_MAX_RANGE))
+		return false;
+	if (WARN_ON_ONCE((key->block_begin >> BIO_PRISON_MAX_RANGE_SHIFT) !=
+			 (key->block_end - 1) >> BIO_PRISON_MAX_RANGE_SHIFT))
+		return false;
+
+	return true;
 }
+EXPORT_SYMBOL(dm_cell_key_has_valid_range);
 
 static int __bio_detain(struct rb_root *root,
 			struct dm_cell_key *key,
@@ -172,7 +177,6 @@ static int bio_detain(struct dm_bio_prison *prison,
 {
 	int r;
 	unsigned l = lock_nr(key);
-	check_range(key);
 
 	spin_lock_irq(&prison->regions[l].lock);
 	r = __bio_detain(&prison->regions[l].cell, key, inmate, cell_prealloc, cell_result);
diff --git a/drivers/md/dm-bio-prison-v1.h b/drivers/md/dm-bio-prison-v1.h
index 0b8acd6708fb..2a097ed0d85e 100644
--- a/drivers/md/dm-bio-prison-v1.h
+++ b/drivers/md/dm-bio-prison-v1.h
@@ -83,6 +83,11 @@ int dm_get_cell(struct dm_bio_prison *prison,
 		struct dm_bio_prison_cell *cell_prealloc,
 		struct dm_bio_prison_cell **cell_result);
 
+/*
+ * Returns false if key is beyond BIO_PRISON_MAX_RANGE or spans a boundary.
+ */
+bool dm_cell_key_has_valid_range(struct dm_cell_key *key);
+
 /*
  * An atomic op that combines retrieving or creating a cell, and adding a
  * bio to it.
diff --git a/drivers/md/dm-thin.c b/drivers/md/dm-thin.c
index 33ad5695f959..2b13c949bd72 100644
--- a/drivers/md/dm-thin.c
+++ b/drivers/md/dm-thin.c
@@ -118,25 +118,27 @@ enum lock_space {
 	PHYSICAL
 };
 
-static void build_key(struct dm_thin_device *td, enum lock_space ls,
+static bool build_key(struct dm_thin_device *td, enum lock_space ls,
 		      dm_block_t b, dm_block_t e, struct dm_cell_key *key)
 {
 	key->virtual = (ls == VIRTUAL);
 	key->dev = dm_thin_dev_id(td);
 	key->block_begin = b;
 	key->block_end = e;
+
+	return dm_cell_key_has_valid_range(key);
 }
 
 static void build_data_key(struct dm_thin_device *td, dm_block_t b,
 			   struct dm_cell_key *key)
 {
-	build_key(td, PHYSICAL, b, b + 1llu, key);
+	(void) build_key(td, PHYSICAL, b, b + 1llu, key);
 }
 
 static void build_virtual_key(struct dm_thin_device *td, dm_block_t b,
 			      struct dm_cell_key *key)
 {
-	build_key(td, VIRTUAL, b, b + 1llu, key);
+	(void) build_key(td, VIRTUAL, b, b + 1llu, key);
 }
 
 /*----------------------------------------------------------------*/
@@ -1702,7 +1704,8 @@ static void break_up_discard_bio(struct thin_c *tc, dm_block_t begin, dm_block_t
 				<< BIO_PRISON_MAX_RANGE_SHIFT;
 			len = min_t(sector_t, data_end - data_begin, next_boundary - data_begin);
 
-			build_key(tc->td, PHYSICAL, data_begin, data_begin + len, &data_key);
+			/* This key is certainly within range given the above splitting */
+			(void) build_key(tc->td, PHYSICAL, data_begin, data_begin + len, &data_key);
 			if (bio_detain(tc->pool, &data_key, NULL, &data_cell)) {
 				/* contention, we'll give up with this range */
 				data_begin += len;
@@ -1778,8 +1781,13 @@ static void process_discard_bio(struct thin_c *tc, struct bio *bio)
 		return;
 	}
 
-	build_key(tc->td, VIRTUAL, begin, end, &virt_key);
-	if (bio_detain(tc->pool, &virt_key, bio, &virt_cell))
+	if (unlikely(!build_key(tc->td, VIRTUAL, begin, end, &virt_key))) {
+		DMERR_LIMIT("Discard doesn't respect bio prison limits");
+		bio_endio(bio);
+		return;
+	}
+
+	if (bio_detain(tc->pool, &virt_key, bio, &virt_cell)) {
 		/*
 		 * Potential starvation issue: We're relying on the
 		 * fs/application being well behaved, and not trying to
@@ -1788,6 +1796,7 @@ static void process_discard_bio(struct thin_c *tc, struct bio *bio)
 		 * cell will never be granted.
 		 */
 		return;
+	}
 
 	tc->pool->process_discard_cell(tc, virt_cell);
 }
-- 
2.40.0

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel


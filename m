Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 18704C433FE
	for <dm-devel@archiver.kernel.org>; Fri,  4 Nov 2022 05:47:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1667540822;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=c6cnCQM22dHNSFeeJMyvMltbVznf9+ixU5gN9VEjmsY=;
	b=QbQnNZe/qkSV+yieGeQwYmDHCwb5lnDmlB/b1vtmv8R6P3iXcQGfM4xyItSTT8gNEPQJcr
	r3Eh1wlGI2qNITqLxM45A4cG/AsW8whH8c2qvn7k4vhvqr+k723cr7F1Rajc4SYgHathfa
	IoIHIx0wRLzVmkqFNmPKCyMbueOrLYs=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-497-_pjEdjJeOZaZyBkCcHp2VA-1; Fri, 04 Nov 2022 01:46:38 -0400
X-MC-Unique: _pjEdjJeOZaZyBkCcHp2VA-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 2088B85A5A6;
	Fri,  4 Nov 2022 05:46:36 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 108D02166B48;
	Fri,  4 Nov 2022 05:46:36 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id E65561946A63;
	Fri,  4 Nov 2022 05:46:35 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com
 [10.11.54.9])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 05C731946594
 for <dm-devel@listman.corp.redhat.com>; Fri,  4 Nov 2022 05:46:35 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id EEE2D4A927B; Fri,  4 Nov 2022 05:46:34 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id E6ECE4A927A
 for <dm-devel@redhat.com>; Fri,  4 Nov 2022 05:46:34 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id CC69385A59D
 for <dm-devel@redhat.com>; Fri,  4 Nov 2022 05:46:34 +0000 (UTC)
Received: from bombadil.infradead.org (bombadil.infradead.org
 [198.137.202.133]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-136-GgivugtoOaqRQC8yfOqBmA-1; Fri, 04 Nov 2022 01:46:33 -0400
X-MC-Unique: GgivugtoOaqRQC8yfOqBmA-1
Received: from [2001:4bb8:182:29ca:9be5:7ea:ab68:47c9] (helo=localhost)
 by bombadil.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
 id 1oqpXB-002S1h-1r; Fri, 04 Nov 2022 05:46:29 +0000
From: Christoph Hellwig <hch@lst.de>
To: Jens Axboe <axboe@kernel.dk>
Date: Fri,  4 Nov 2022 06:46:21 +0100
Message-Id: <20221104054621.628369-3-hch@lst.de>
In-Reply-To: <20221104054621.628369-1-hch@lst.de>
References: <20221104054621.628369-1-hch@lst.de>
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
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.9
Subject: [dm-devel] [PATCH 2/2] blk-crypto: add a blk_crypto_cfg_supported
 helper
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
Cc: linux-block@vger.kernel.org, "Theodore Y. Ts'o" <tytso@mit.edu>,
 Mike Snitzer <snitzer@kernel.org>, linux-fscrypt@vger.kernel.org,
 Eric Biggers <ebiggers@kernel.org>, dm-devel@redhat.com,
 Jaegeuk Kim <jaegeuk@kernel.org>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.6
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Add a blk_crypto_cfg_supported helper that wraps
__blk_crypto_cfg_supported to retreive the crypto_profile from the
request queue.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 block/blk-crypto-profile.c         |  7 +++++++
 block/blk-crypto.c                 | 13 ++++---------
 fs/crypto/inline_crypt.c           |  4 +---
 include/linux/blk-crypto-profile.h |  2 ++
 4 files changed, 14 insertions(+), 12 deletions(-)

diff --git a/block/blk-crypto-profile.c b/block/blk-crypto-profile.c
index 96c511967386d..e8a0a3457fa29 100644
--- a/block/blk-crypto-profile.c
+++ b/block/blk-crypto-profile.c
@@ -353,6 +353,13 @@ bool __blk_crypto_cfg_supported(struct blk_crypto_profile *profile,
 	return true;
 }
 
+bool blk_crypto_cfg_supported(struct block_device *bdev,
+			      const struct blk_crypto_config *cfg)
+{
+	return __blk_crypto_cfg_supported(bdev_get_queue(bdev)->crypto_profile,
+					  cfg);
+}
+
 /**
  * __blk_crypto_evict_key() - Evict a key from a device.
  * @profile: the crypto profile of the device
diff --git a/block/blk-crypto.c b/block/blk-crypto.c
index 0e0c2fc56c428..b4597d0e87546 100644
--- a/block/blk-crypto.c
+++ b/block/blk-crypto.c
@@ -267,7 +267,6 @@ bool __blk_crypto_bio_prep(struct bio **bio_ptr)
 {
 	struct bio *bio = *bio_ptr;
 	const struct blk_crypto_key *bc_key = bio->bi_crypt_context->bc_key;
-	struct blk_crypto_profile *profile;
 
 	/* Error if bio has no data. */
 	if (WARN_ON_ONCE(!bio_has_data(bio))) {
@@ -284,10 +283,8 @@ bool __blk_crypto_bio_prep(struct bio **bio_ptr)
 	 * Success if device supports the encryption context, or if we succeeded
 	 * in falling back to the crypto API.
 	 */
-	profile = bdev_get_queue(bio->bi_bdev)->crypto_profile;
-	if (__blk_crypto_cfg_supported(profile, &bc_key->crypto_cfg))
+	if (blk_crypto_cfg_supported(bio->bi_bdev, &bc_key->crypto_cfg))
 		return true;
-
 	if (blk_crypto_fallback_bio_prep(bio_ptr))
 		return true;
 fail:
@@ -361,8 +358,7 @@ bool blk_crypto_config_supported(struct block_device *bdev,
 				 const struct blk_crypto_config *cfg)
 {
 	return IS_ENABLED(CONFIG_BLK_INLINE_ENCRYPTION_FALLBACK) ||
-	       __blk_crypto_cfg_supported(bdev_get_queue(bdev)->crypto_profile,
-	       				  cfg);
+	       blk_crypto_cfg_supported(bdev, cfg);
 }
 
 /**
@@ -383,8 +379,7 @@ bool blk_crypto_config_supported(struct block_device *bdev,
 int blk_crypto_start_using_key(struct block_device *bdev,
 			       const struct blk_crypto_key *key)
 {
-	if (__blk_crypto_cfg_supported(bdev_get_queue(bdev)->crypto_profile,
-			&key->crypto_cfg))
+	if (blk_crypto_cfg_supported(bdev, &key->crypto_cfg))
 		return 0;
 	return blk_crypto_fallback_start_using_mode(key->crypto_cfg.crypto_mode);
 }
@@ -407,7 +402,7 @@ int blk_crypto_evict_key(struct block_device *bdev,
 {
 	struct request_queue *q = bdev_get_queue(bdev);
 
-	if (__blk_crypto_cfg_supported(q->crypto_profile, &key->crypto_cfg))
+	if (blk_crypto_cfg_supported(bdev, &key->crypto_cfg))
 		return __blk_crypto_evict_key(q->crypto_profile, key);
 
 	/*
diff --git a/fs/crypto/inline_crypt.c b/fs/crypto/inline_crypt.c
index 55c4d8c23d30d..4034908743453 100644
--- a/fs/crypto/inline_crypt.c
+++ b/fs/crypto/inline_crypt.c
@@ -77,10 +77,8 @@ static void fscrypt_log_blk_crypto_impl(struct fscrypt_mode *mode,
 	unsigned int i;
 
 	for (i = 0; i < num_devs; i++) {
-		struct request_queue *q = bdev_get_queue(devs[i]);
-
 		if (!IS_ENABLED(CONFIG_BLK_INLINE_ENCRYPTION_FALLBACK) ||
-		    __blk_crypto_cfg_supported(q->crypto_profile, cfg)) {
+		    blk_crypto_cfg_supported(devs[i], cfg)) {
 			if (!xchg(&mode->logged_blk_crypto_native, 1))
 				pr_info("fscrypt: %s using blk-crypto (native)\n",
 					mode->friendly_name);
diff --git a/include/linux/blk-crypto-profile.h b/include/linux/blk-crypto-profile.h
index bbab65bd54288..a9ddf543c8a97 100644
--- a/include/linux/blk-crypto-profile.h
+++ b/include/linux/blk-crypto-profile.h
@@ -144,6 +144,8 @@ blk_status_t blk_crypto_get_keyslot(struct blk_crypto_profile *profile,
 
 void blk_crypto_put_keyslot(struct blk_crypto_keyslot *slot);
 
+bool blk_crypto_cfg_supported(struct block_device *bdev,
+			      const struct blk_crypto_config *cfg);
 bool __blk_crypto_cfg_supported(struct blk_crypto_profile *profile,
 				const struct blk_crypto_config *cfg);
 
-- 
2.30.2

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel


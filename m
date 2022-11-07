Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 38C85C4332F
	for <dm-devel@archiver.kernel.org>; Mon,  7 Nov 2022 15:15:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1667834132;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=4OCdxQbg7do5gXxH9AFpvtlYGSYQn45o5+nDdbMuUS4=;
	b=IFKQ/bnEaoP1x6b02QhP3H86U/HAZycywThFi0vUqwyZ74vNc9o/TFpmShWoYMpc/T3+eI
	dGwZ7YrA+CxnHJN87pA+m6vrjf5e6tw0nFg037tzhL0NHFtxwbyRYyVPsNXkqi3Nj+lvAu
	wPOr07PP9w3AvmiyMz3nLjvN/5muVvc=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-172-eEkmLZmgPAW0KtIEx04WdQ-1; Mon, 07 Nov 2022 10:15:30 -0500
X-MC-Unique: eEkmLZmgPAW0KtIEx04WdQ-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D43D685A5A6;
	Mon,  7 Nov 2022 15:15:27 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id E687A40C6DC7;
	Mon,  7 Nov 2022 15:15:25 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 65CA41946588;
	Mon,  7 Nov 2022 15:15:10 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com
 [10.11.54.2])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 188BF1946588
 for <dm-devel@listman.corp.redhat.com>; Mon,  7 Nov 2022 15:15:09 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 0ADB640C6DC7; Mon,  7 Nov 2022 15:15:09 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast09.extmail.prod.ext.rdu2.redhat.com [10.11.55.25])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 0348240C958D
 for <dm-devel@redhat.com>; Mon,  7 Nov 2022 15:15:08 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id DB5B42A59560
 for <dm-devel@redhat.com>; Mon,  7 Nov 2022 15:15:08 +0000 (UTC)
Received: from bombadil.infradead.org (bombadil.infradead.org
 [198.137.202.133]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-29-U1uGHAAuN7GNw6Atjbpk2A-1; Mon, 07 Nov 2022 10:15:06 -0500
X-MC-Unique: U1uGHAAuN7GNw6Atjbpk2A-1
Received: from [2001:4bb8:191:2450:bd6a:c86c:b287:8b99] (helo=localhost)
 by bombadil.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
 id 1os3Kf-00FJaj-Dg; Mon, 07 Nov 2022 14:42:37 +0000
From: Christoph Hellwig <hch@lst.de>
To: Jens Axboe <axboe@kernel.dk>
Date: Mon,  7 Nov 2022 15:42:28 +0100
Message-Id: <20221107144229.1547370-3-hch@lst.de>
In-Reply-To: <20221107144229.1547370-1-hch@lst.de>
References: <20221107144229.1547370-1-hch@lst.de>
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
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
Subject: [dm-devel] [PATCH 2/3] blk-crypto: add a
 blk_crypto_config_supported_natively helper
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
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Add a blk_crypto_cfg_supported helper that wraps
__blk_crypto_cfg_supported to retreive the crypto_profile from the
request queue.  With this fscrypt can stop including
blk-crypto-profile.h and rely on the public consumer interface in
blk-crypto.h.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 block/blk-crypto.c         | 21 ++++++++++++---------
 fs/crypto/inline_crypt.c   |  6 ++----
 include/linux/blk-crypto.h |  2 ++
 3 files changed, 16 insertions(+), 13 deletions(-)

diff --git a/block/blk-crypto.c b/block/blk-crypto.c
index 0e0c2fc56c428..ceb5a4c8f0306 100644
--- a/block/blk-crypto.c
+++ b/block/blk-crypto.c
@@ -267,7 +267,6 @@ bool __blk_crypto_bio_prep(struct bio **bio_ptr)
 {
 	struct bio *bio = *bio_ptr;
 	const struct blk_crypto_key *bc_key = bio->bi_crypt_context->bc_key;
-	struct blk_crypto_profile *profile;
 
 	/* Error if bio has no data. */
 	if (WARN_ON_ONCE(!bio_has_data(bio))) {
@@ -284,10 +283,9 @@ bool __blk_crypto_bio_prep(struct bio **bio_ptr)
 	 * Success if device supports the encryption context, or if we succeeded
 	 * in falling back to the crypto API.
 	 */
-	profile = bdev_get_queue(bio->bi_bdev)->crypto_profile;
-	if (__blk_crypto_cfg_supported(profile, &bc_key->crypto_cfg))
+	if (blk_crypto_config_supported_natively(bio->bi_bdev,
+						 &bc_key->crypto_cfg))
 		return true;
-
 	if (blk_crypto_fallback_bio_prep(bio_ptr))
 		return true;
 fail:
@@ -352,6 +350,13 @@ int blk_crypto_init_key(struct blk_crypto_key *blk_key, const u8 *raw_key,
 	return 0;
 }
 
+bool blk_crypto_config_supported_natively(struct block_device *bdev,
+					  const struct blk_crypto_config *cfg)
+{
+	return __blk_crypto_cfg_supported(bdev_get_queue(bdev)->crypto_profile,
+					  cfg);
+}
+
 /*
  * Check if bios with @cfg can be en/decrypted by blk-crypto (i.e. either the
  * request queue it's submitted to supports inline crypto, or the
@@ -361,8 +366,7 @@ bool blk_crypto_config_supported(struct block_device *bdev,
 				 const struct blk_crypto_config *cfg)
 {
 	return IS_ENABLED(CONFIG_BLK_INLINE_ENCRYPTION_FALLBACK) ||
-	       __blk_crypto_cfg_supported(bdev_get_queue(bdev)->crypto_profile,
-	       				  cfg);
+	       blk_crypto_config_supported_natively(bdev, cfg);
 }
 
 /**
@@ -383,8 +387,7 @@ bool blk_crypto_config_supported(struct block_device *bdev,
 int blk_crypto_start_using_key(struct block_device *bdev,
 			       const struct blk_crypto_key *key)
 {
-	if (__blk_crypto_cfg_supported(bdev_get_queue(bdev)->crypto_profile,
-			&key->crypto_cfg))
+	if (blk_crypto_config_supported_natively(bdev, &key->crypto_cfg))
 		return 0;
 	return blk_crypto_fallback_start_using_mode(key->crypto_cfg.crypto_mode);
 }
@@ -407,7 +410,7 @@ int blk_crypto_evict_key(struct block_device *bdev,
 {
 	struct request_queue *q = bdev_get_queue(bdev);
 
-	if (__blk_crypto_cfg_supported(q->crypto_profile, &key->crypto_cfg))
+	if (blk_crypto_config_supported_natively(bdev, &key->crypto_cfg))
 		return __blk_crypto_evict_key(q->crypto_profile, key);
 
 	/*
diff --git a/fs/crypto/inline_crypt.c b/fs/crypto/inline_crypt.c
index 55c4d8c23d30d..8bfb3ce864766 100644
--- a/fs/crypto/inline_crypt.c
+++ b/fs/crypto/inline_crypt.c
@@ -12,7 +12,7 @@
  * provides the key and IV to use.
  */
 
-#include <linux/blk-crypto-profile.h>
+#include <linux/blk-crypto.h>
 #include <linux/blkdev.h>
 #include <linux/buffer_head.h>
 #include <linux/sched/mm.h>
@@ -77,10 +77,8 @@ static void fscrypt_log_blk_crypto_impl(struct fscrypt_mode *mode,
 	unsigned int i;
 
 	for (i = 0; i < num_devs; i++) {
-		struct request_queue *q = bdev_get_queue(devs[i]);
-
 		if (!IS_ENABLED(CONFIG_BLK_INLINE_ENCRYPTION_FALLBACK) ||
-		    __blk_crypto_cfg_supported(q->crypto_profile, cfg)) {
+		    blk_crypto_config_supported_natively(devs[i], cfg)) {
 			if (!xchg(&mode->logged_blk_crypto_native, 1))
 				pr_info("fscrypt: %s using blk-crypto (native)\n",
 					mode->friendly_name);
diff --git a/include/linux/blk-crypto.h b/include/linux/blk-crypto.h
index b314e2febcaf5..1271ff39ab162 100644
--- a/include/linux/blk-crypto.h
+++ b/include/linux/blk-crypto.h
@@ -100,6 +100,8 @@ int blk_crypto_start_using_key(struct block_device *bdev,
 int blk_crypto_evict_key(struct block_device *bdev,
 			 const struct blk_crypto_key *key);
 
+bool blk_crypto_config_supported_natively(struct block_device *bdev,
+					  const struct blk_crypto_config *cfg);
 bool blk_crypto_config_supported(struct block_device *bdev,
 				 const struct blk_crypto_config *cfg);
 
-- 
2.30.2

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel


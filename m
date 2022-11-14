Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CFE9BC433FE
	for <dm-devel@archiver.kernel.org>; Mon, 14 Nov 2022 05:23:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1668403393;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=1OtQGIq+yXEXjKlv234zFZ7QXlAaaqHALHiy2D8avCk=;
	b=b8UrZ2bKgLu5xjYGE2XKHbHuPgAvhEdZp/Np1//lX7oXeecYsx6o2WVQTF0fqTK7K1LaX9
	1EPDRhuySTQQQaqOoHbO0bSPF6abHeJJtNIqme8V0ASNHob8NUy4XWcdFMPYaRZRG32/Iz
	8QXOTOtARNIzz0lp6qVrz5XOiRYGFNk=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-153-Lxg4MPesNcmbqfHynB0ngw-1; Mon, 14 Nov 2022 00:23:10 -0500
X-MC-Unique: Lxg4MPesNcmbqfHynB0ngw-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 35F373C0E454;
	Mon, 14 Nov 2022 05:23:08 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id B7065200AD6E;
	Mon, 14 Nov 2022 05:23:04 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 8688E1946589;
	Mon, 14 Nov 2022 05:23:04 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
 [10.11.54.6])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 847511946586
 for <dm-devel@listman.corp.redhat.com>; Mon, 14 Nov 2022 05:22:59 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 662A12166B2C; Mon, 14 Nov 2022 05:22:59 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 59D482166B2B
 for <dm-devel@redhat.com>; Mon, 14 Nov 2022 05:22:59 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 29001857AA0
 for <dm-devel@redhat.com>; Mon, 14 Nov 2022 05:22:59 +0000 (UTC)
Received: from bombadil.infradead.org (bombadil.infradead.org
 [198.137.202.133]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-532-QAyhxv41Mc26PJhekEP-cQ-1; Mon, 14 Nov 2022 00:22:56 -0500
X-MC-Unique: QAyhxv41Mc26PJhekEP-cQ-1
Received: from [2001:4bb8:191:2606:c70:4a89:bc61:2] (helo=localhost)
 by bombadil.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
 id 1ouR6Y-00FvUd-2s; Mon, 14 Nov 2022 04:29:54 +0000
From: Christoph Hellwig <hch@lst.de>
To: Jens Axboe <axboe@kernel.dk>
Date: Mon, 14 Nov 2022 05:29:44 +0100
Message-Id: <20221114042944.1009870-4-hch@lst.de>
In-Reply-To: <20221114042944.1009870-1-hch@lst.de>
References: <20221114042944.1009870-1-hch@lst.de>
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
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.6
Subject: [dm-devel] [PATCH 3/3] blk-crypto: move internal only declarations
 to blk-crypto-internal.h
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
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.4
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

 blk_crypto_get_keyslot, blk_crypto_put_keyslot, __blk_crypto_evict_key
and __blk_crypto_cfg_supported are only used internally by the
blk-crypto code, so move the out of blk-crypto-profile.h, which is
included by drivers that supply blk-crypto functionality.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 block/blk-crypto-internal.h        | 12 ++++++++++++
 include/linux/blk-crypto-profile.h | 12 ------------
 2 files changed, 12 insertions(+), 12 deletions(-)

diff --git a/block/blk-crypto-internal.h b/block/blk-crypto-internal.h
index e6818ffaddbf8..d31fa80454e49 100644
--- a/block/blk-crypto-internal.h
+++ b/block/blk-crypto-internal.h
@@ -65,6 +65,18 @@ static inline bool blk_crypto_rq_is_encrypted(struct request *rq)
 	return rq->crypt_ctx;
 }
 
+blk_status_t blk_crypto_get_keyslot(struct blk_crypto_profile *profile,
+				    const struct blk_crypto_key *key,
+				    struct blk_crypto_keyslot **slot_ptr);
+
+void blk_crypto_put_keyslot(struct blk_crypto_keyslot *slot);
+
+int __blk_crypto_evict_key(struct blk_crypto_profile *profile,
+			   const struct blk_crypto_key *key);
+
+bool __blk_crypto_cfg_supported(struct blk_crypto_profile *profile,
+				const struct blk_crypto_config *cfg);
+
 #else /* CONFIG_BLK_INLINE_ENCRYPTION */
 
 static inline int blk_crypto_sysfs_register(struct request_queue *q)
diff --git a/include/linux/blk-crypto-profile.h b/include/linux/blk-crypto-profile.h
index bbab65bd54288..e6802b69cdd64 100644
--- a/include/linux/blk-crypto-profile.h
+++ b/include/linux/blk-crypto-profile.h
@@ -138,18 +138,6 @@ int devm_blk_crypto_profile_init(struct device *dev,
 
 unsigned int blk_crypto_keyslot_index(struct blk_crypto_keyslot *slot);
 
-blk_status_t blk_crypto_get_keyslot(struct blk_crypto_profile *profile,
-				    const struct blk_crypto_key *key,
-				    struct blk_crypto_keyslot **slot_ptr);
-
-void blk_crypto_put_keyslot(struct blk_crypto_keyslot *slot);
-
-bool __blk_crypto_cfg_supported(struct blk_crypto_profile *profile,
-				const struct blk_crypto_config *cfg);
-
-int __blk_crypto_evict_key(struct blk_crypto_profile *profile,
-			   const struct blk_crypto_key *key);
-
 void blk_crypto_reprogram_all_keys(struct blk_crypto_profile *profile);
 
 void blk_crypto_profile_destroy(struct blk_crypto_profile *profile);
-- 
2.30.2

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel


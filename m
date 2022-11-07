Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C1840C433FE
	for <dm-devel@archiver.kernel.org>; Mon,  7 Nov 2022 15:15:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1667834134;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=Q03k8XtdbW6DdS6IA66BhlKSfx2QCPMMB8O53bJ7HEw=;
	b=LdRq3kt4eJqk9AzBKQL9ZWbSeJ4WzeVNNN/CkQho9FUmZye3apvmE/l232/W43GiKoK6Zz
	4kCAagyiMeXVm/9MYodWMg/3ZMXKzDyq9xn2jEVe6a50xOnxPn04uHWcVbAahOwfDAV6hQ
	9Aoqt03jmRIY+dlut48gHmPjJDDUifo=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-342-ZK0XW6dgOXiSHWOsnf2qow-1; Mon, 07 Nov 2022 10:15:31 -0500
X-MC-Unique: ZK0XW6dgOXiSHWOsnf2qow-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 0BEB71C06ED8;
	Mon,  7 Nov 2022 15:15:29 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id EFBFE40C6FA1;
	Mon,  7 Nov 2022 15:15:28 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id DE578194658C;
	Mon,  7 Nov 2022 15:15:23 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com
 [10.11.54.9])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id A812A1946587
 for <dm-devel@listman.corp.redhat.com>; Mon,  7 Nov 2022 15:15:23 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 8E7404B3FC8; Mon,  7 Nov 2022 15:15:23 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast09.extmail.prod.ext.rdu2.redhat.com [10.11.55.25])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 86F8A4B3FC6
 for <dm-devel@redhat.com>; Mon,  7 Nov 2022 15:15:23 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 6B34F2932485
 for <dm-devel@redhat.com>; Mon,  7 Nov 2022 15:15:23 +0000 (UTC)
Received: from bombadil.infradead.org (bombadil.infradead.org
 [198.137.202.133]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-39-xV9iqSfXPfqtPUo2VeyxZQ-1; Mon, 07 Nov 2022 10:15:21 -0500
X-MC-Unique: xV9iqSfXPfqtPUo2VeyxZQ-1
Received: from [2001:4bb8:191:2450:bd6a:c86c:b287:8b99] (helo=localhost)
 by bombadil.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
 id 1os3Ki-00FJc7-5v; Mon, 07 Nov 2022 14:42:40 +0000
From: Christoph Hellwig <hch@lst.de>
To: Jens Axboe <axboe@kernel.dk>
Date: Mon,  7 Nov 2022 15:42:29 +0100
Message-Id: <20221107144229.1547370-4-hch@lst.de>
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
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.9
Subject: [dm-devel] [PATCH 3/3] blk-crypto: move __blk_crypto_cfg_supported
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
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

__blk_crypto_cfg_supported is only used internally by the blk-crypto
code now, so move it out of the public header.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 block/blk-crypto-internal.h        | 3 +++
 include/linux/blk-crypto-profile.h | 3 ---
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/block/blk-crypto-internal.h b/block/blk-crypto-internal.h
index e6818ffaddbf8..c587b3e1886c9 100644
--- a/block/blk-crypto-internal.h
+++ b/block/blk-crypto-internal.h
@@ -19,6 +19,9 @@ struct blk_crypto_mode {
 
 extern const struct blk_crypto_mode blk_crypto_modes[];
 
+bool __blk_crypto_cfg_supported(struct blk_crypto_profile *profile,
+				const struct blk_crypto_config *cfg);
+
 #ifdef CONFIG_BLK_INLINE_ENCRYPTION
 
 int blk_crypto_sysfs_register(struct request_queue *q);
diff --git a/include/linux/blk-crypto-profile.h b/include/linux/blk-crypto-profile.h
index bbab65bd54288..e990ec9b32aa4 100644
--- a/include/linux/blk-crypto-profile.h
+++ b/include/linux/blk-crypto-profile.h
@@ -144,9 +144,6 @@ blk_status_t blk_crypto_get_keyslot(struct blk_crypto_profile *profile,
 
 void blk_crypto_put_keyslot(struct blk_crypto_keyslot *slot);
 
-bool __blk_crypto_cfg_supported(struct blk_crypto_profile *profile,
-				const struct blk_crypto_config *cfg);
-
 int __blk_crypto_evict_key(struct blk_crypto_profile *profile,
 			   const struct blk_crypto_key *key);
 
-- 
2.30.2

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel


Return-Path: <SRS0=CL6l=HT=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F03E9C433E6
	for <dm-devel@archiver.kernel.org>; Wed, 17 Feb 2021 15:39:57 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [63.128.21.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 8383A64DA1
	for <dm-devel@archiver.kernel.org>; Wed, 17 Feb 2021 15:39:57 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 8383A64DA1
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linutronix.de
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-436-D0-_QVe1OtCGhhO1nP8u5Q-1; Wed, 17 Feb 2021 10:39:54 -0500
X-MC-Unique: D0-_QVe1OtCGhhO1nP8u5Q-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 1D87B79ED1;
	Wed, 17 Feb 2021 15:39:50 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id F272C60C62;
	Wed, 17 Feb 2021 15:39:49 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id BDE081809C90;
	Wed, 17 Feb 2021 15:39:49 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
	[10.11.54.5])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 11DBLsMn030520 for <dm-devel@listman.util.phx.redhat.com>;
	Sat, 13 Feb 2021 06:21:54 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 4EB11FDCCA; Sat, 13 Feb 2021 11:21:54 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 49C10F9AD5
	for <dm-devel@redhat.com>; Sat, 13 Feb 2021 11:21:51 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [207.211.31.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 689EC101A53A
	for <dm-devel@redhat.com>; Sat, 13 Feb 2021 11:21:51 +0000 (UTC)
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
	(Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-19-IyKB3X6sOPObJ4-jKS3N7g-1; Sat, 13 Feb 2021 06:21:47 -0500
X-MC-Unique: IyKB3X6sOPObJ4-jKS3N7g-1
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: dm-devel@redhat.com
Date: Sat, 13 Feb 2021 12:11:46 +0100
Message-Id: <20210213111146.3080152-7-bigeasy@linutronix.de>
In-Reply-To: <20210213111146.3080152-1-bigeasy@linutronix.de>
References: <20210213111146.3080152-1-bigeasy@linutronix.de>
MIME-Version: 1.0
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.79 on 10.11.54.5
X-MIME-Autoconverted: from quoted-printable to 8bit by
	lists01.pubmisc.prod.ext.phx2.redhat.com id 11DBLsMn030520
X-loop: dm-devel@redhat.com
X-Mailman-Approved-At: Wed, 17 Feb 2021 10:31:26 -0500
Cc: Thomas Gleixner <tglx@linutronix.de>,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	Mike Snitzer <snitzer@redhat.com>, Alasdair Kergon <agk@redhat.com>,
	Ignat Korchagin <ignat@cloudflare.com>
Subject: [dm-devel] [PATCH 6/6] dm crypt: Use `atomic' argument for memory
	allocation.
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

crypt_alloc_req_*() is using in_interrupt() to figure out the correct
gfp_t mask for memory allocation.

The usage of in_interrupt() in non-core code is phased out. Ideally the
information of the calling context should be passed by the callers or the
functions be split as appropriate.

The top-most caller has already an `atomic' argument which is true if invoked
from an atomic context.

Use the `atomic' argument to create an allocation mask and pass it down
to crypt_alloc_req_*().

Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
---
 drivers/md/dm-crypt.c | 18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/md/dm-crypt.c b/drivers/md/dm-crypt.c
index 0cdfee10d5a23..40c35efb9e929 100644
--- a/drivers/md/dm-crypt.c
+++ b/drivers/md/dm-crypt.c
@@ -1456,12 +1456,12 @@ static void kcryptd_async_done(struct crypto_async_request *async_req,
 			       int error);
 
 static int crypt_alloc_req_skcipher(struct crypt_config *cc,
-				     struct convert_context *ctx)
+				    struct convert_context *ctx, gfp_t gfp)
 {
 	unsigned key_index = ctx->cc_sector & (cc->tfms_count - 1);
 
 	if (!ctx->r.req) {
-		ctx->r.req = mempool_alloc(&cc->req_pool, in_interrupt() ? GFP_ATOMIC : GFP_NOIO);
+		ctx->r.req = mempool_alloc(&cc->req_pool, gfp);
 		if (!ctx->r.req)
 			return -ENOMEM;
 	}
@@ -1480,10 +1480,10 @@ static int crypt_alloc_req_skcipher(struct crypt_config *cc,
 }
 
 static int crypt_alloc_req_aead(struct crypt_config *cc,
-				 struct convert_context *ctx)
+				struct convert_context *ctx, gfp_t gfp)
 {
 	if (!ctx->r.req_aead) {
-		ctx->r.req_aead = mempool_alloc(&cc->req_pool, in_interrupt() ? GFP_ATOMIC : GFP_NOIO);
+		ctx->r.req_aead = mempool_alloc(&cc->req_pool, gfp);
 		if (!ctx->r.req_aead)
 			return -ENOMEM;
 	}
@@ -1501,13 +1501,13 @@ static int crypt_alloc_req_aead(struct crypt_config *cc,
 	return 0;
 }
 
-static int crypt_alloc_req(struct crypt_config *cc,
-			    struct convert_context *ctx)
+static int crypt_alloc_req(struct crypt_config *cc, struct convert_context *ctx,
+			   gfp_t gfp)
 {
 	if (crypt_integrity_aead(cc))
-		return crypt_alloc_req_aead(cc, ctx);
+		return crypt_alloc_req_aead(cc, ctx, gfp);
 	else
-		return crypt_alloc_req_skcipher(cc, ctx);
+		return crypt_alloc_req_skcipher(cc, ctx, gfp);
 }
 
 static void crypt_free_req_skcipher(struct crypt_config *cc,
@@ -1556,7 +1556,7 @@ static blk_status_t crypt_convert(struct crypt_config *cc,
 
 	while (ctx->iter_in.bi_size && ctx->iter_out.bi_size) {
 
-		r = crypt_alloc_req(cc, ctx);
+		r = crypt_alloc_req(cc, ctx, atomic ? GFP_ATOMIC : GFP_NOIO);
 		if (r) {
 			complete(&ctx->restart);
 			return BLK_STS_DEV_RESOURCE;
-- 
2.30.0


--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel


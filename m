Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DDF3DC433EF
	for <dm-devel@archiver.kernel.org>; Tue, 19 Jul 2022 05:52:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1658209963;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=GJNu+Nm+/sBd/9ftj5qHIVafBcwuwgytQAN+bIw8bnE=;
	b=X4Iqpn/FS8G5D740Qst5e/8NI3Gk9EKaOhgATpLd8YyY7mAI+fXTrsn+1YEllCeh/0vTcD
	f18193mnGemvwnQUAC8C460tr0IfCaUxeFVX5mQgc0pIpIj1aHy5i3DHpUfgLdY9CwP05o
	UcHvO4qfbEQPFcE+iMzRoaa0dl7o7e0=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-515-Tcq_5M1XN5-GpTo0pOMhJg-1; Tue, 19 Jul 2022 01:52:40 -0400
X-MC-Unique: Tcq_5M1XN5-GpTo0pOMhJg-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 845F6101A589;
	Tue, 19 Jul 2022 05:52:38 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 47BF640CF8E5;
	Tue, 19 Jul 2022 05:52:36 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id DF414194B94A;
	Tue, 19 Jul 2022 05:52:34 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com
 [10.11.54.1])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id E191C194707F
 for <dm-devel@listman.corp.redhat.com>; Mon, 18 Jul 2022 21:13:14 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id B7EA740CFD0B; Mon, 18 Jul 2022 21:13:14 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id B406B40CFD0A
 for <dm-devel@redhat.com>; Mon, 18 Jul 2022 21:13:14 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 9682D101A586
 for <dm-devel@redhat.com>; Mon, 18 Jul 2022 21:13:14 +0000 (UTC)
Received: from mail-pf1-f170.google.com (mail-pf1-f170.google.com
 [209.85.210.170]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-385-4AuW36T0NUyvfj3VEF6tew-1; Mon, 18 Jul 2022 17:13:03 -0400
X-MC-Unique: 4AuW36T0NUyvfj3VEF6tew-1
Received: by mail-pf1-f170.google.com with SMTP id y9so11756568pff.12
 for <dm-devel@redhat.com>; Mon, 18 Jul 2022 14:13:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
 :references:mime-version:content-transfer-encoding;
 bh=QWJ5QeiPjtbCRgoRk+ubXff2AujiLVH4AasYR9bygac=;
 b=kEkb19/bFodrE39yoo+2UT60DfXtNE+Co8POvSxXw6JFbLTdTKoxdo3pQItyT0N0wx
 4yf/J2hXHjhxSAKqBePBfjH0qIJV5pIqccX597mAAlGTFt1dZ0lup/6GaZLKrCHydZj3
 8XPWiuwJp71U0FiPCGQ8DWn5O0AhH/H32jvsanJZorOmnVjiuzHlxFCVMKkn4TJn3zZE
 uvZ0yJE2Urdqt+tbN+KL1hl/QPZTT6FlWhVRtDbA35eRMnzliLrF5Wl5jrH/Vskuafdu
 /zBSO1ldqrto+Ke9xtTF2fc6Fy7vLXqqf/3nFaIFyZmUfKDdwAKpCi+L1Yf/y15kncK0
 k1Xw==
X-Gm-Message-State: AJIora+aWXDEC9xUNenRryK9Si78T3XUyEZpZPpo50r5hOIemvfPvwit
 fC9F0gdM8EMAvrF4E5T1UFVSLPUvGIPMcA==
X-Google-Smtp-Source: AGRyM1sdjI8kqsIllwaX0LhjyyYfpduS2Xt4ucZ1qr4Wz+ymQBNsu+CXjfUU7JImFul/sxFNIhBGrQ==
X-Received: by 2002:a63:4d0e:0:b0:412:1877:9820 with SMTP id
 a14-20020a634d0e000000b0041218779820mr26345153pgb.177.1658178780601; 
 Mon, 18 Jul 2022 14:13:00 -0700 (PDT)
Received: from desktop.hsd1.or.comcast.net
 ([2601:1c0:4c00:ad20:feaa:14ff:fe3a:b225])
 by smtp.gmail.com with ESMTPSA id
 c7-20020a17090a020700b001ef59378951sm11918134pjc.13.2022.07.18.14.12.59
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Mon, 18 Jul 2022 14:13:00 -0700 (PDT)
From: Tadeusz Struk <tadeusz.struk@linaro.org>
To: stable@vger.kernel.org
Date: Mon, 18 Jul 2022 14:12:26 -0700
Message-Id: <20220718211226.506362-2-tadeusz.struk@linaro.org>
In-Reply-To: <20220718211226.506362-1-tadeusz.struk@linaro.org>
References: <20220718211226.506362-1-tadeusz.struk@linaro.org>
MIME-Version: 1.0
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.1
X-Mailman-Approved-At: Tue, 19 Jul 2022 05:52:33 +0000
Subject: [dm-devel] [PATCH 5.10 2/2] block: fix bounce_clone_bio for
 passthrough bios
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
Cc: Jens Axboe <axboe@kernel.dk>,
 Chaitanya Kulkarni <Chaitanya.Kulkarni@wdc.com>, linux-block@vger.kernel.org,
 dm-devel@redhat.com, syzbot+4f441e6ca0fcad141421@syzkaller.appspotmail.com,
 Tadeusz Struk <tadeusz.struk@linaro.org>, Christoph Hellwig <hch@lst.de>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.1
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

From: Christoph Hellwig <hch@lst.de>

From: Christoph Hellwig <hch@lst.de>

Upstream commit: b90994c6ab62 ("block: fix bounce_clone_bio for passthrough bios")

This is backport to stable 5.10. It fixes an issue reported by syzbot.
Link: https://syzkaller.appspot.com/bug?id=a3416231e37024a75f2b95bd95db0d8ce8132a84

Now that bio_alloc_bioset does not fall back to kmalloc for a NULL
bio_set, handle that case explicitly and simplify the calling
conventions.

Based on an earlier patch from Chaitanya Kulkarni.

Fixes: 3175199ab0ac ("block: split bio_kmalloc from bio_alloc_bioset")
Reported-by: syzbot+4f441e6ca0fcad141421@syzkaller.appspotmail.com
Reported-by: Chaitanya Kulkarni <Chaitanya.Kulkarni@wdc.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Tadeusz Struk <tadeusz.struk@linaro.org>
---
 block/bounce.c | 17 +++++++++--------
 1 file changed, 9 insertions(+), 8 deletions(-)

diff --git a/block/bounce.c b/block/bounce.c
index 162a6eee8999..4da429de78a2 100644
--- a/block/bounce.c
+++ b/block/bounce.c
@@ -214,8 +214,7 @@ static void bounce_end_io_read_isa(struct bio *bio)
 	__bounce_end_io_read(bio, &isa_page_pool);
 }
 
-static struct bio *bounce_clone_bio(struct bio *bio_src, gfp_t gfp_mask,
-		struct bio_set *bs)
+static struct bio *bounce_clone_bio(struct bio *bio_src, gfp_t gfp_mask)
 {
 	struct bvec_iter iter;
 	struct bio_vec bv;
@@ -242,8 +241,11 @@ static struct bio *bounce_clone_bio(struct bio *bio_src, gfp_t gfp_mask,
 	 *    asking for trouble and would force extra work on
 	 *    __bio_clone_fast() anyways.
 	 */
-
-	bio = bio_alloc_bioset(gfp_mask, bio_segments(bio_src), bs);
+	if (bio_is_passthrough(bio_src))
+		bio = bio_kmalloc(gfp_mask, bio_segments(bio_src));
+	else
+		bio = bio_alloc_bioset(gfp_mask, bio_segments(bio_src),
+				       &bounce_bio_set);
 	if (!bio)
 		return NULL;
 	bio->bi_disk		= bio_src->bi_disk;
@@ -294,7 +296,6 @@ static void __blk_queue_bounce(struct request_queue *q, struct bio **bio_orig,
 	unsigned i = 0;
 	bool bounce = false;
 	int sectors = 0;
-	bool passthrough = bio_is_passthrough(*bio_orig);
 
 	bio_for_each_segment(from, *bio_orig, iter) {
 		if (i++ < BIO_MAX_PAGES)
@@ -305,14 +306,14 @@ static void __blk_queue_bounce(struct request_queue *q, struct bio **bio_orig,
 	if (!bounce)
 		return;
 
-	if (!passthrough && sectors < bio_sectors(*bio_orig)) {
+	if (!bio_is_passthrough(*bio_orig) &&
+	    sectors < bio_sectors(*bio_orig)) {
 		bio = bio_split(*bio_orig, sectors, GFP_NOIO, &bounce_bio_split);
 		bio_chain(bio, *bio_orig);
 		submit_bio_noacct(*bio_orig);
 		*bio_orig = bio;
 	}
-	bio = bounce_clone_bio(*bio_orig, GFP_NOIO, passthrough ? NULL :
-			&bounce_bio_set);
+	bio = bounce_clone_bio(*bio_orig, GFP_NOIO);
 
 	/*
 	 * Bvec table can't be updated by bio_for_each_segment_all(),
-- 
2.36.1

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel


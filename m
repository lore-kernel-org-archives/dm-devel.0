Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3C897C7EE23
	for <dm-devel@archiver.kernel.org>; Thu,  1 Jun 2023 07:52:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1685605939;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=9aXF6rS5FU5yPTDD6bQafmSjWglhxDifLMMgGCVQ9tk=;
	b=GIXYaR4dRFDpDc8okiuykQUNynW+7wtNubsm1/MosMZ6/4T2lWfx+kwVkgU4gFdq2XzVjg
	JKgSQgvaoGx3qFc14vnQ/JkcX60QbWdv0ghQxK4QHFryOzSTnnB/VfRivDGzXfaNH3FYFq
	XLaHJMJ1kTNU48+hJ220InS7/Ln1tD4=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-299-iFCP7f5ePyKU9J9IbwZsFA-1; Thu, 01 Jun 2023 03:52:18 -0400
X-MC-Unique: iFCP7f5ePyKU9J9IbwZsFA-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 5A3871C05143;
	Thu,  1 Jun 2023 07:52:16 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 47071112132D;
	Thu,  1 Jun 2023 07:52:16 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 16C47194343B;
	Thu,  1 Jun 2023 07:52:16 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
 [10.11.54.3])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 5A78719451E5
 for <dm-devel@listman.corp.redhat.com>; Thu,  1 Jun 2023 07:52:15 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 37B0B112132D; Thu,  1 Jun 2023 07:52:15 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 30B23112132C
 for <dm-devel@redhat.com>; Thu,  1 Jun 2023 07:52:15 +0000 (UTC)
Received: from us-smtp-inbound-1.mimecast.com (us-smtp-2.mimecast.com
 [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 12C1A8028B1
 for <dm-devel@redhat.com>; Thu,  1 Jun 2023 07:52:15 +0000 (UTC)
Received: from bombadil.infradead.org (bombadil.infradead.org
 [198.137.202.133]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-463-uLrfr5O2OlqkGMjphSrlqQ-1; Thu, 01 Jun 2023 03:52:13 -0400
X-MC-Unique: uLrfr5O2OlqkGMjphSrlqQ-1
Received: from [2001:4bb8:182:6d06:35f3:1da0:1cc3:d86d] (helo=localhost)
 by bombadil.infradead.org with esmtpsa (Exim 4.96 #2 (Red Hat Linux))
 id 1q4cjk-002MMU-1I; Thu, 01 Jun 2023 07:28:44 +0000
From: Christoph Hellwig <hch@lst.de>
To: Jens Axboe <axboe@kernel.dk>
Date: Thu,  1 Jun 2023 09:28:29 +0200
Message-Id: <20230601072829.1258286-4-hch@lst.de>
In-Reply-To: <20230601072829.1258286-1-hch@lst.de>
References: <20230601072829.1258286-1-hch@lst.de>
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
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
Subject: [dm-devel] [PATCH 3/3] block: fail writes to read-only devices
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
Cc: linux-block@vger.kernel.org, Mike Snitzer <snitzer@kernel.org>,
 dm-devel@redhat.com, Linus Torvalds <torvalds@linux-foundation.org>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: lst.de
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Currently callers can happily submit writes to block devices that are
marked read-only, including to drivers that don't even support writes
and will crash when fed such bios.

While bio submitter should check for read-only devices, that's not a
very robust way of dealing with this.

Note that the last attempt to do this got reverted by Linus in commit
a32e236eb93e ("Partially revert "block: fail op_is_write() requests to
read-only partitions") because device mapper relyied on not enforcing
the read-only state when used together with older lvm-tools.

The lvm side got fixed in:

    https://sourceware.org/git/?p=lvm2.git;a=commit;h=a6fdb9d9d70f51c49ad11a87ab4243344e6701a3

but if people still have older lvm2 tools in use we probably need
to find a workaround for this in device mapper rather than lacking
the core block layer checks.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 block/blk-core.c | 19 ++++++++-----------
 1 file changed, 8 insertions(+), 11 deletions(-)

diff --git a/block/blk-core.c b/block/blk-core.c
index 4ba243968e41eb..ef41816bd0eade 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -492,16 +492,6 @@ static int __init fail_make_request_debugfs(void)
 late_initcall(fail_make_request_debugfs);
 #endif /* CONFIG_FAIL_MAKE_REQUEST */
 
-static inline void bio_check_ro(struct bio *bio)
-{
-	if (op_is_write(bio_op(bio)) && bio_sectors(bio) &&
-	    bdev_read_only(bio->bi_bdev)) {
-		pr_warn("Trying to write to read-only block-device %pg\n",
-			bio->bi_bdev);
-		/* Older lvm-tools actually trigger this */
-	}
-}
-
 static noinline int should_fail_bio(struct bio *bio)
 {
 	if (should_fail_request(bdev_whole(bio->bi_bdev), bio->bi_iter.bi_size))
@@ -735,7 +725,14 @@ void submit_bio_noacct(struct bio *bio)
 
 	if (should_fail_bio(bio))
 		goto end_io;
-	bio_check_ro(bio);
+
+	if (op_is_write(bio_op(bio)) && bio_sectors(bio) &&
+	    bdev_read_only(bdev)) {
+		pr_warn("Trying to write to read-only block-device %pg\n",
+			bdev);
+		goto end_io;
+	}
+
 	if (!bio_flagged(bio, BIO_REMAPPED)) {
 		if (unlikely(bio_check_eod(bio)))
 			goto end_io;
-- 
2.39.2

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel


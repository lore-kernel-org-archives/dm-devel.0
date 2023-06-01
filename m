Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 23496C77B7E
	for <dm-devel@archiver.kernel.org>; Thu,  1 Jun 2023 07:52:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1685605949;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=cmnH/qYVRY8iaMPz1jrt3kK517h5Cc0aI0zlLU1LsF4=;
	b=ZP2e/pHUoZBCxXoit5USua4ebhiEbxlUmHxtant3XiE0VTakzXQyvygxV7OcN+wLarnB1k
	Mi+yNgNtGZ5wbJnUZzoieP8A9sIvBf4AVzoHbY2oZOqMuivcgahfy8RFaNr1pjxPQ6Laju
	ZAF9nH/3Eqwo3Oi+ny9XfcjHlbONsP0=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-28-II9s9oefMfi0SOvCcD-UXg-1; Thu, 01 Jun 2023 03:52:27 -0400
X-MC-Unique: II9s9oefMfi0SOvCcD-UXg-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 6F3843C17C64;
	Thu,  1 Jun 2023 07:52:25 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 5A451C154D7;
	Thu,  1 Jun 2023 07:52:25 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 3D12F1949F03;
	Thu,  1 Jun 2023 07:52:25 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
 [10.11.54.3])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id F1DCE19451E5
 for <dm-devel@listman.corp.redhat.com>; Thu,  1 Jun 2023 07:52:23 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id D2512112132D; Thu,  1 Jun 2023 07:52:23 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id CB2F9112132C
 for <dm-devel@redhat.com>; Thu,  1 Jun 2023 07:52:23 +0000 (UTC)
Received: from us-smtp-inbound-1.mimecast.com (us-smtp-2.mimecast.com
 [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id B1511801224
 for <dm-devel@redhat.com>; Thu,  1 Jun 2023 07:52:23 +0000 (UTC)
Received: from bombadil.infradead.org (bombadil.infradead.org
 [198.137.202.133]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-607-t0OU1uuvN_O8KK4O9Fp-FQ-1; Thu, 01 Jun 2023 03:52:22 -0400
X-MC-Unique: t0OU1uuvN_O8KK4O9Fp-FQ-1
Received: from [2001:4bb8:182:6d06:35f3:1da0:1cc3:d86d] (helo=localhost)
 by bombadil.infradead.org with esmtpsa (Exim 4.96 #2 (Red Hat Linux))
 id 1q4cjg-002MLn-2W; Thu, 01 Jun 2023 07:28:41 +0000
From: Christoph Hellwig <hch@lst.de>
To: Jens Axboe <axboe@kernel.dk>
Date: Thu,  1 Jun 2023 09:28:28 +0200
Message-Id: <20230601072829.1258286-3-hch@lst.de>
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
Subject: [dm-devel] [PATCH 2/3] block: simplify the check for flushes in
 bio_check_ro
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
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: lst.de
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

The only writes without no sectors are pure flush requests, so drop
the extra op_is_flush check.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 block/blk-core.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/block/blk-core.c b/block/blk-core.c
index 2ae22bebeb3ee1..4ba243968e41eb 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -494,9 +494,8 @@ late_initcall(fail_make_request_debugfs);
 
 static inline void bio_check_ro(struct bio *bio)
 {
-	if (op_is_write(bio_op(bio)) && bdev_read_only(bio->bi_bdev)) {
-		if (op_is_flush(bio->bi_opf) && !bio_sectors(bio))
-			return;
+	if (op_is_write(bio_op(bio)) && bio_sectors(bio) &&
+	    bdev_read_only(bio->bi_bdev)) {
 		pr_warn("Trying to write to read-only block-device %pg\n",
 			bio->bi_bdev);
 		/* Older lvm-tools actually trigger this */
-- 
2.39.2

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel


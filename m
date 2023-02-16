Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 18B0EC61DA4
	for <dm-devel@archiver.kernel.org>; Thu, 16 Feb 2023 21:22:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1676582573;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=9SPp3TK1o14GlUKXrk5AVZcROVxvJrekzMdT37ZGPec=;
	b=d4qfxwaU3vEIBeVBjY09PT4+WZu/M8xduCDULzyDcFYc1mYuTZ4PWqxS1p5/ccyezGZLdL
	AIm5IY4owFEXGk/gelLx0tGys4HsEDpNK6k/oAzuUOpQn6zhfkB/1l38GiS6huwvD0Jpe6
	UofpsC7/+BsO8uNMKt/LDZGTPqgvJWU=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-442-upAUDVRYMa6DsIWJUEARhw-1; Thu, 16 Feb 2023 16:22:50 -0500
X-MC-Unique: upAUDVRYMa6DsIWJUEARhw-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id E48133C0DDCF;
	Thu, 16 Feb 2023 21:22:48 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id D1E2E40B40C9;
	Thu, 16 Feb 2023 21:22:48 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 97E941946589;
	Thu, 16 Feb 2023 21:22:48 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com
 [10.11.54.1])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id F16281946588
 for <dm-devel@listman.corp.redhat.com>; Thu, 16 Feb 2023 21:22:46 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 988FC40B3FE1; Thu, 16 Feb 2023 21:22:46 +0000 (UTC)
Received: from file01.intranet.prod.int.rdu2.redhat.com
 (file01.intranet.prod.int.rdu2.redhat.com [10.11.5.7])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 86A0440CF8E4;
 Thu, 16 Feb 2023 21:22:46 +0000 (UTC)
Received: from file01.intranet.prod.int.rdu2.redhat.com (localhost [127.0.0.1])
 by file01.intranet.prod.int.rdu2.redhat.com (8.14.4/8.14.4) with ESMTP id
 31GLMkxg007334; Thu, 16 Feb 2023 16:22:46 -0500
Received: from localhost (mpatocka@localhost)
 by file01.intranet.prod.int.rdu2.redhat.com (8.14.4/8.14.4/Submit) with ESMTP
 id 31GLMksq007330; Thu, 16 Feb 2023 16:22:46 -0500
X-Authentication-Warning: file01.intranet.prod.int.rdu2.redhat.com: mpatocka
 owned process doing -bs
Date: Thu, 16 Feb 2023 16:22:46 -0500 (EST)
From: Mikulas Patocka <mpatocka@redhat.com>
X-X-Sender: mpatocka@file01.intranet.prod.int.rdu2.redhat.com
To: Matthew Wilcox <willy@infradead.org>
Message-ID: <alpine.LRH.2.21.2302161619430.5436@file01.intranet.prod.int.rdu2.redhat.com>
User-Agent: Alpine 2.21 (LRH 202 2017-01-01)
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.1
Subject: [dm-devel] [PATCH v2] dm-crypt: allocate compound pages if possible
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
Cc: Yang Shi <shy828301@gmail.com>, snitzer@kernel.org,
 linux-kernel@vger.kernel.org, linux-block@vger.kernel.org, linux-mm@kvack.org,
 dm-devel@redhat.com, akpm@linux-foundation.org, mgorman@techsingularity.net,
 agk@redhat.com
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.1
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

It was reported that allocating pages for the write buffer in dm-crypt
causes measurable overhead [1].

This patch changes dm-crypt to allocate compound pages if they are
available. If not, we fall back to the mempool.

[1] https://listman.redhat.com/archives/dm-devel/2023-February/053284.html

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>

---
 drivers/md/dm-crypt.c |   48 +++++++++++++++++++++++++++++++++---------------
 1 file changed, 33 insertions(+), 15 deletions(-)

Index: linux-2.6/drivers/md/dm-crypt.c
===================================================================
--- linux-2.6.orig/drivers/md/dm-crypt.c	2023-02-16 20:40:15.000000000 +0100
+++ linux-2.6/drivers/md/dm-crypt.c	2023-02-16 21:56:34.000000000 +0100
@@ -1657,6 +1657,9 @@ static void crypt_free_buffer_pages(stru
  * In order to not degrade performance with excessive locking, we try
  * non-blocking allocations without a mutex first but on failure we fallback
  * to blocking allocations with a mutex.
+ *
+ * In order to reduce allocation overhead, we try to allocate compound pages in
+ * the first pass. If they are not available, we fall back to the mempool.
  */
 static struct bio *crypt_alloc_buffer(struct dm_crypt_io *io, unsigned size)
 {
@@ -1664,8 +1667,8 @@ static struct bio *crypt_alloc_buffer(st
 	struct bio *clone;
 	unsigned int nr_iovecs = (size + PAGE_SIZE - 1) >> PAGE_SHIFT;
 	gfp_t gfp_mask = GFP_NOWAIT | __GFP_HIGHMEM;
-	unsigned i, len, remaining_size;
-	struct page *page;
+	unsigned remaining_size;
+	unsigned order = MAX_ORDER - 1;
 
 retry:
 	if (unlikely(gfp_mask & __GFP_DIRECT_RECLAIM))
@@ -1678,20 +1681,34 @@ retry:
 
 	remaining_size = size;
 
-	for (i = 0; i < nr_iovecs; i++) {
-		page = mempool_alloc(&cc->page_pool, gfp_mask);
-		if (!page) {
+	while (remaining_size) {
+		struct page *pages;
+		unsigned size_to_add;
+		unsigned remaining_order = __fls((remaining_size + PAGE_SIZE - 1) >> PAGE_SHIFT);
+		order = min(order, remaining_order);
+
+		while (order > 0) {
+			pages = alloc_pages(gfp_mask
+				| __GFP_NOMEMALLOC | __GFP_NORETRY | __GFP_NOWARN | __GFP_COMP,
+				order);
+			if (likely(pages != NULL))
+				goto have_pages;
+			order--;
+		}
+
+		pages = mempool_alloc(&cc->page_pool, gfp_mask);
+		if (!pages) {
 			crypt_free_buffer_pages(cc, clone);
 			bio_put(clone);
 			gfp_mask |= __GFP_DIRECT_RECLAIM;
+			order = 0;
 			goto retry;
 		}
 
-		len = (remaining_size > PAGE_SIZE) ? PAGE_SIZE : remaining_size;
-
-		bio_add_page(clone, page, len, 0);
-
-		remaining_size -= len;
+have_pages:
+		size_to_add = min((unsigned)PAGE_SIZE << order, remaining_size);
+		bio_add_page(clone, pages, size_to_add, 0);
+		remaining_size -= size_to_add;
 	}
 
 	/* Allocate space for integrity tags */
@@ -1709,12 +1726,13 @@ retry:
 
 static void crypt_free_buffer_pages(struct crypt_config *cc, struct bio *clone)
 {
-	struct bio_vec *bv;
-	struct bvec_iter_all iter_all;
+	struct folio_iter fi;
 
-	bio_for_each_segment_all(bv, clone, iter_all) {
-		BUG_ON(!bv->bv_page);
-		mempool_free(bv->bv_page, &cc->page_pool);
+	bio_for_each_folio_all(fi, clone) {
+		if (folio_test_large(fi.folio))
+			folio_put(fi.folio);
+		else
+			mempool_free(&fi.folio->page, &cc->page_pool);
 	}
 }
 

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel


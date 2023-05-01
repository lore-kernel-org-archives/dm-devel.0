Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B3593C77B61
	for <dm-devel@archiver.kernel.org>; Mon,  1 May 2023 13:19:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1682947164;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=KXIDMxkde2C9smMesK0jgfXOrCiHSyNhN+8LR7SB9GQ=;
	b=K1GsQwNiiK2Bp9xO+OuH2I6w/a1OStZFuCSbG6x/IVZ2Y1J05jy++A0Xq9Re8e/0J8TVUG
	orwkgNzSF86ji+KUTMnk8pvGe82wQYus/q67WK/krnJrXTpFu00JcJdSIUsxjOKlLX5j8+
	YZhXE7TUif71Jih8RXiY0EFZTvbM3g0=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-557-PUQifW7lOkeT74Ch5AS8sg-1; Mon, 01 May 2023 09:19:23 -0400
X-MC-Unique: PUQifW7lOkeT74Ch5AS8sg-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 6B752A0F396;
	Mon,  1 May 2023 13:19:21 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 89444492C14;
	Mon,  1 May 2023 13:19:18 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 4D1EE19465B3;
	Mon,  1 May 2023 13:19:18 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
 [10.11.54.5])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id E54B81946587
 for <dm-devel@listman.corp.redhat.com>; Mon,  1 May 2023 13:19:17 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 934AD63F40; Mon,  1 May 2023 13:19:17 +0000 (UTC)
Received: from file01.intranet.prod.int.rdu2.redhat.com
 (file01.intranet.prod.int.rdu2.redhat.com [10.11.5.7])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 8398D63F2D;
 Mon,  1 May 2023 13:19:17 +0000 (UTC)
Received: from file01.intranet.prod.int.rdu2.redhat.com (localhost [127.0.0.1])
 by file01.intranet.prod.int.rdu2.redhat.com (8.14.4/8.14.4) with ESMTP id
 341DJHNX009163; Mon, 1 May 2023 09:19:17 -0400
Received: from localhost (mpatocka@localhost)
 by file01.intranet.prod.int.rdu2.redhat.com (8.14.4/8.14.4/Submit) with ESMTP
 id 341DJHHZ009160; Mon, 1 May 2023 09:19:17 -0400
X-Authentication-Warning: file01.intranet.prod.int.rdu2.redhat.com: mpatocka
 owned process doing -bs
Date: Mon, 1 May 2023 09:19:17 -0400 (EDT)
From: Mikulas Patocka <mpatocka@redhat.com>
X-X-Sender: mpatocka@file01.intranet.prod.int.rdu2.redhat.com
To: Mike Snitzer <msnitzer@redhat.com>
In-Reply-To: <alpine.LRH.2.21.2305010909100.8207@file01.intranet.prod.int.rdu2.redhat.com>
Message-ID: <alpine.LRH.2.21.2305010918400.8207@file01.intranet.prod.int.rdu2.redhat.com>
References: <alpine.LRH.2.21.2305010909100.8207@file01.intranet.prod.int.rdu2.redhat.com>
User-Agent: Alpine 2.21 (LRH 202 2017-01-01)
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
Subject: [dm-devel] [PATCH 1/3] dm-crypt: allocate compound pages if possible
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
Cc: dm-devel@redhat.com
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.9
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
 drivers/md/dm-crypt.c |   50 +++++++++++++++++++++++++++++++++++---------------
 1 file changed, 35 insertions(+), 15 deletions(-)

Index: linux-2.6/drivers/md/dm-crypt.c
===================================================================
--- linux-2.6.orig/drivers/md/dm-crypt.c
+++ linux-2.6/drivers/md/dm-crypt.c
@@ -1661,6 +1661,9 @@ static void crypt_free_buffer_pages(stru
  * In order to not degrade performance with excessive locking, we try
  * non-blocking allocations without a mutex first but on failure we fallback
  * to blocking allocations with a mutex.
+ *
+ * In order to reduce allocation overhead, we try to allocate compound pages in
+ * the first pass. If they are not available, we fall back to the mempool.
  */
 static struct bio *crypt_alloc_buffer(struct dm_crypt_io *io, unsigned int size)
 {
@@ -1668,8 +1671,8 @@ static struct bio *crypt_alloc_buffer(st
 	struct bio *clone;
 	unsigned int nr_iovecs = (size + PAGE_SIZE - 1) >> PAGE_SHIFT;
 	gfp_t gfp_mask = GFP_NOWAIT | __GFP_HIGHMEM;
-	unsigned int i, len, remaining_size;
-	struct page *page;
+	unsigned int remaining_size;
+	unsigned int order = MAX_ORDER - 1;
 
 retry:
 	if (unlikely(gfp_mask & __GFP_DIRECT_RECLAIM))
@@ -1682,20 +1685,34 @@ retry:
 
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
@@ -1713,12 +1730,15 @@ retry:
 
 static void crypt_free_buffer_pages(struct crypt_config *cc, struct bio *clone)
 {
-	struct bio_vec *bv;
-	struct bvec_iter_all iter_all;
+	struct folio_iter fi;
 
-	bio_for_each_segment_all(bv, clone, iter_all) {
-		BUG_ON(!bv->bv_page);
-		mempool_free(bv->bv_page, &cc->page_pool);
+	if (clone->bi_vcnt > 0) { /* bio_for_each_folio_all crashes with an empty bio */
+		bio_for_each_folio_all(fi, clone) {
+			if (folio_test_large(fi.folio))
+				folio_put(fi.folio);
+			else
+				mempool_free(&fi.folio->page, &cc->page_pool);
+		}
 	}
 }
 

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel


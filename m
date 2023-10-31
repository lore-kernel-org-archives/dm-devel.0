Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D5FD1DFDC
	for <dm-devel@lists.linux.dev>; Tue, 31 Oct 2023 18:12:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="hOKVQjAb"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1698775976;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type;
	bh=dKp/Qea9uD2Xcyf33Af5TQsUqVH+C6XlZjlmhm+jfdM=;
	b=hOKVQjAbkeUyyHOmNUuKL8qil3IdQkaIqqGkf1Zn2gQJonamsiuGnIU4tzC5+7FiikHOor
	pVhz3waZwgsHPBgVgwrI1HfgOgH0UgxTU5bHMSbWx/r0KkrVClo0z6ah9zAKuq5LEwiH9S
	WDZy1DrEBLhlZNV7MirJ2+IFrHUzWwU=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-158-OOZIvI00NmuyKXMV1KEErg-1; Tue,
 31 Oct 2023 14:12:54 -0400
X-MC-Unique: OOZIvI00NmuyKXMV1KEErg-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 675261C06E20
	for <dm-devel@lists.linux.dev>; Tue, 31 Oct 2023 18:12:54 +0000 (UTC)
Received: from file1-rdu.file-001.prod.rdu2.dc.redhat.com (unknown [10.11.5.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 626DB2166B26;
	Tue, 31 Oct 2023 18:12:54 +0000 (UTC)
Received: by file1-rdu.file-001.prod.rdu2.dc.redhat.com (Postfix, from userid 12668)
	id 4FB6C30C2A86; Tue, 31 Oct 2023 18:12:54 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by file1-rdu.file-001.prod.rdu2.dc.redhat.com (Postfix) with ESMTP id 4BFF93FB77;
	Tue, 31 Oct 2023 19:12:54 +0100 (CET)
Date: Tue, 31 Oct 2023 19:12:54 +0100 (CET)
From: Mikulas Patocka <mpatocka@redhat.com>
To: Mike Snitzer <msnitzer@redhat.com>
cc: dm-devel@lists.linux.dev
Subject: [PATCH] dm-crypt: account large pages in cc->n_allocated_pages
Message-ID: <fc522632-407a-a515-cb69-c2db2dfc51da@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.6
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=US-ASCII

The commit 5054e778fcd9c changed dm-crypt to use compound pages to improve
performance. Unfortunatelly, there was an oversight - normal pages are
accounted in a percpu counter cc->n_allocated_pages and dm-crypt is
limited to allocate at most 2% of memory. Compound pages were not
accounted at all. So, dm-crypt could allocate memory over the limit.

This patch adds the accounting of compound pages, so that memory
consumption of dm-crypt is properly limited.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Cc: stable@vger.kernel.org	# v6.5
Fixes: 5054e778fcd9c ("dm crypt: allocate compound pages if possible")

---
 drivers/md/dm-crypt.c |   15 ++++++++++++---
 1 file changed, 12 insertions(+), 3 deletions(-)

Index: linux-stable/drivers/md/dm-crypt.c
===================================================================
--- linux-stable.orig/drivers/md/dm-crypt.c	2023-10-31 19:11:25.000000000 +0100
+++ linux-stable/drivers/md/dm-crypt.c	2023-10-31 19:11:46.000000000 +0100
@@ -1700,11 +1700,17 @@ retry:
 		order = min(order, remaining_order);
 
 		while (order > 0) {
+			if (unlikely(percpu_counter_read_positive(&cc->n_allocated_pages) +
+					(1 << order) > dm_crypt_pages_per_client))
+				goto decrease_order;
 			pages = alloc_pages(gfp_mask
 				| __GFP_NOMEMALLOC | __GFP_NORETRY | __GFP_NOWARN | __GFP_COMP,
 				order);
-			if (likely(pages != NULL))
+			if (likely(pages != NULL)) {
+				percpu_counter_add(&cc->n_allocated_pages, 1 << order);
 				goto have_pages;
+			}
+decrease_order:
 			order--;
 		}
 
@@ -1742,10 +1748,13 @@ static void crypt_free_buffer_pages(stru
 
 	if (clone->bi_vcnt > 0) { /* bio_for_each_folio_all crashes with an empty bio */
 		bio_for_each_folio_all(fi, clone) {
-			if (folio_test_large(fi.folio))
+			if (folio_test_large(fi.folio)) {
+				percpu_counter_sub(&cc->n_allocated_pages,
+						1 << folio_order(fi.folio));
 				folio_put(fi.folio);
-			else
+			} else {
 				mempool_free(&fi.folio->page, &cc->page_pool);
+			}
 		}
 	}
 }


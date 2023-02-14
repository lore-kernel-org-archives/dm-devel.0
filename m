Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9FC5AC64ED8
	for <dm-devel@archiver.kernel.org>; Wed, 15 Feb 2023 09:33:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1676453629;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=9L8a2BusHC8DvQEd4GxIm0PW3W535B5dtcHw1mYFt+I=;
	b=c89xPkoF2th5GWtLWyKQsl8OC9t3boKNL2s9tsKgtvaKExaD7XCRBT31ts14p+KkAVq4gP
	c/4dw1slpFOqhQaj6qnyCVkiWQIlAVOjJaHIfreyfIT2Mm9NUi0DvRzK6GWbpP4xmSyOCC
	LzxCiM6QKUBXpH4aF+Pxz8jE0jjajVA=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-573-umBFRZYWMiKZIRmDmX9K6w-1; Wed, 15 Feb 2023 04:33:46 -0500
X-MC-Unique: umBFRZYWMiKZIRmDmX9K6w-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 99225857F61;
	Wed, 15 Feb 2023 09:33:43 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 644314010E82;
	Wed, 15 Feb 2023 09:33:41 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 8CBDC1946A4C;
	Wed, 15 Feb 2023 09:33:39 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com
 [10.11.54.8])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 70BB41946586
 for <dm-devel@listman.corp.redhat.com>; Tue, 14 Feb 2023 19:02:47 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 59C69C15BAE; Tue, 14 Feb 2023 19:02:42 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast07.extmail.prod.ext.rdu2.redhat.com [10.11.55.23])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 52031C15BA0
 for <dm-devel@redhat.com>; Tue, 14 Feb 2023 19:02:42 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 35EC63C0F660
 for <dm-devel@redhat.com>; Tue, 14 Feb 2023 19:02:42 +0000 (UTC)
Received: from mail-il1-f170.google.com (mail-il1-f170.google.com
 [209.85.166.170]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-509-2eq2V9A_OGaLPSINTu7c2Q-1; Tue, 14 Feb 2023 14:02:38 -0500
X-MC-Unique: 2eq2V9A_OGaLPSINTu7c2Q-1
Received: by mail-il1-f170.google.com with SMTP id t7so4983496ilq.2;
 Tue, 14 Feb 2023 11:02:37 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=content-transfer-encoding:mime-version:references:in-reply-to
 :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
 :subject:date:message-id:reply-to;
 bh=gBFO9aqhV38THoX2Fo6HR6/ykmrwIoxryt9YcUaBQeE=;
 b=BSQevkhFAYH9e4D0KxMCq91odKxbJpdNTeISdN5ul82zeEFUNTxJABMTAZVfSMNhYu
 tn3WBeVUyNl8vW4mh2jAM8wqpBYB//f842oGuR1o1Da9BVdfQ0cT/3OzRjCcmZ7wDjYL
 ljlA0+Mm0wao1BcRQS3O5Wt14vzH211ZEBaoG/UXosdDzmn9KwI3rbEeU9fnFgXINDTJ
 jV48aWXiNcbKePpyKVeiRD31UhhvSWY7Sr/RV548Izw01MNfl8JJuCR9tBW3Jxwm1hWu
 dZWrNv0o9VUB8XrVmRi3ncH/lTfWy02XjQVCHan31kKpxIvZMczf+MewWgMTDborVpAf
 qJ1Q==
X-Gm-Message-State: AO0yUKVAclfXBCVN/MLtnknrrC7q6HtEnuNW6mekeMecuhKI3YV+/RVh
 tQJPcDEtfemQHsXYoCSQgXI=
X-Google-Smtp-Source: AK7set9u6j7La87WkLYk/UYILiOBFdY1iKGZoRD/y8K4y4KxyNTy+Te/VhP83riNGGKX7PeiklCynQ==
X-Received: by 2002:a05:6e02:12ed:b0:315:55cc:ff07 with SMTP id
 l13-20020a056e0212ed00b0031555ccff07mr3475691iln.4.1676401357094; 
 Tue, 14 Feb 2023 11:02:37 -0800 (PST)
Received: from localhost.localdomain (c-67-174-241-145.hsd1.ca.comcast.net.
 [67.174.241.145]) by smtp.gmail.com with ESMTPSA id
 r11-20020a056e0219cb00b0030c27c9eea4sm3608770ill.33.2023.02.14.11.02.36
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Tue, 14 Feb 2023 11:02:36 -0800 (PST)
From: Yang Shi <shy828301@gmail.com>
To: mgorman@techsingularity.net, agk@redhat.com, snitzer@kernel.org,
 dm-devel@redhat.com, akpm@linux-foundation.org
Date: Tue, 14 Feb 2023 11:02:17 -0800
Message-Id: <20230214190221.1156876-2-shy828301@gmail.com>
In-Reply-To: <20230214190221.1156876-1-shy828301@gmail.com>
References: <20230214190221.1156876-1-shy828301@gmail.com>
MIME-Version: 1.0
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
X-Mailman-Approved-At: Wed, 15 Feb 2023 09:33:38 +0000
Subject: [dm-devel] [v2 PATCH 1/5] mm: page_alloc: add API for bulk
 allocator with callback
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
Cc: linux-block@vger.kernel.org, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.1
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Currently the bulk allocator support to pass pages via list or array,
but neither is suitable for some usecases, for example, dm-crypt, which
doesn't need a list, but array may be too big to fit on stack.  So
adding a new bulk allocator API, which passes in a callback function
that deal with the allocated pages.

The API defined in this patch will be used by the following patches.

Signed-off-by: Yang Shi <shy828301@gmail.com>
---
 include/linux/gfp.h | 21 +++++++++++++++++----
 mm/mempolicy.c      | 12 +++++++-----
 mm/page_alloc.c     | 21 +++++++++++++++------
 3 files changed, 39 insertions(+), 15 deletions(-)

diff --git a/include/linux/gfp.h b/include/linux/gfp.h
index 65a78773dcca..265c19b4822f 100644
--- a/include/linux/gfp.h
+++ b/include/linux/gfp.h
@@ -182,7 +182,9 @@ struct folio *__folio_alloc(gfp_t gfp, unsigned int order, int preferred_nid,
 unsigned long __alloc_pages_bulk(gfp_t gfp, int preferred_nid,
 				nodemask_t *nodemask, int nr_pages,
 				struct list_head *page_list,
-				struct page **page_array);
+				struct page **page_array,
+				void (*cb)(struct page *, void *),
+				void *data);
 
 unsigned long alloc_pages_bulk_array_mempolicy(gfp_t gfp,
 				unsigned long nr_pages,
@@ -192,13 +194,15 @@ unsigned long alloc_pages_bulk_array_mempolicy(gfp_t gfp,
 static inline unsigned long
 alloc_pages_bulk_list(gfp_t gfp, unsigned long nr_pages, struct list_head *list)
 {
-	return __alloc_pages_bulk(gfp, numa_mem_id(), NULL, nr_pages, list, NULL);
+	return __alloc_pages_bulk(gfp, numa_mem_id(), NULL, nr_pages, list, NULL,
+				  NULL, NULL);
 }
 
 static inline unsigned long
 alloc_pages_bulk_array(gfp_t gfp, unsigned long nr_pages, struct page **page_array)
 {
-	return __alloc_pages_bulk(gfp, numa_mem_id(), NULL, nr_pages, NULL, page_array);
+	return __alloc_pages_bulk(gfp, numa_mem_id(), NULL, nr_pages, NULL, page_array,
+				  NULL, NULL);
 }
 
 static inline unsigned long
@@ -207,7 +211,16 @@ alloc_pages_bulk_array_node(gfp_t gfp, int nid, unsigned long nr_pages, struct p
 	if (nid == NUMA_NO_NODE)
 		nid = numa_mem_id();
 
-	return __alloc_pages_bulk(gfp, nid, NULL, nr_pages, NULL, page_array);
+	return __alloc_pages_bulk(gfp, nid, NULL, nr_pages, NULL, page_array,
+				  NULL, NULL);
+}
+
+static inline unsigned long
+alloc_pages_bulk_cb(gfp_t gfp, unsigned long nr_pages,
+		    void (*cb)(struct page *page, void *data), void *data)
+{
+	return __alloc_pages_bulk(gfp, numa_mem_id(), NULL, nr_pages, NULL, NULL,
+				  cb, data);
 }
 
 static inline void warn_if_node_offline(int this_node, gfp_t gfp_mask)
diff --git a/mm/mempolicy.c b/mm/mempolicy.c
index 0919c7a719d4..00b2d5341790 100644
--- a/mm/mempolicy.c
+++ b/mm/mempolicy.c
@@ -2318,12 +2318,13 @@ static unsigned long alloc_pages_bulk_array_interleave(gfp_t gfp,
 			nr_allocated = __alloc_pages_bulk(gfp,
 					interleave_nodes(pol), NULL,
 					nr_pages_per_node + 1, NULL,
-					page_array);
+					page_array, NULL, NULL);
 			delta--;
 		} else {
 			nr_allocated = __alloc_pages_bulk(gfp,
 					interleave_nodes(pol), NULL,
-					nr_pages_per_node, NULL, page_array);
+					nr_pages_per_node, NULL, page_array,
+					NULL, NULL);
 		}
 
 		page_array += nr_allocated;
@@ -2344,12 +2345,13 @@ static unsigned long alloc_pages_bulk_array_preferred_many(gfp_t gfp, int nid,
 	preferred_gfp &= ~(__GFP_DIRECT_RECLAIM | __GFP_NOFAIL);
 
 	nr_allocated  = __alloc_pages_bulk(preferred_gfp, nid, &pol->nodes,
-					   nr_pages, NULL, page_array);
+					   nr_pages, NULL, page_array,
+					   NULL, NULL);
 
 	if (nr_allocated < nr_pages)
 		nr_allocated += __alloc_pages_bulk(gfp, numa_node_id(), NULL,
 				nr_pages - nr_allocated, NULL,
-				page_array + nr_allocated);
+				page_array + nr_allocated, NULL, NULL);
 	return nr_allocated;
 }
 
@@ -2377,7 +2379,7 @@ unsigned long alloc_pages_bulk_array_mempolicy(gfp_t gfp,
 
 	return __alloc_pages_bulk(gfp, policy_node(gfp, pol, numa_node_id()),
 				  policy_nodemask(gfp, pol), nr_pages, NULL,
-				  page_array);
+				  page_array, NULL, NULL);
 }
 
 int vma_dup_policy(struct vm_area_struct *src, struct vm_area_struct *dst)
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 1113483fa6c5..d23b8e49a8cd 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -5402,22 +5402,27 @@ static inline bool prepare_alloc_pages(gfp_t gfp_mask, unsigned int order,
  * @nr_pages: The number of pages desired on the list or array
  * @page_list: Optional list to store the allocated pages
  * @page_array: Optional array to store the pages
+ * @cb: Optional callback to handle the page
+ * @data: The parameter passed in by the callback
  *
  * This is a batched version of the page allocator that attempts to
  * allocate nr_pages quickly. Pages are added to page_list if page_list
- * is not NULL, otherwise it is assumed that the page_array is valid.
+ * is not NULL, or it is assumed if the page_array is valid, or it is
+ * passed to a callback if cb is valid.
  *
- * For lists, nr_pages is the number of pages that should be allocated.
+ * For lists and cb, nr_pages is the number of pages that should be allocated.
  *
  * For arrays, only NULL elements are populated with pages and nr_pages
  * is the maximum number of pages that will be stored in the array.
  *
- * Returns the number of pages on the list or array.
+ * Returns the number of pages on the list or array or consumed by cb.
  */
 unsigned long __alloc_pages_bulk(gfp_t gfp, int preferred_nid,
 			nodemask_t *nodemask, int nr_pages,
 			struct list_head *page_list,
-			struct page **page_array)
+			struct page **page_array,
+			void (*cb)(struct page *, void *),
+			void *data)
 {
 	struct page *page;
 	unsigned long __maybe_unused UP_flags;
@@ -5532,8 +5537,10 @@ unsigned long __alloc_pages_bulk(gfp_t gfp, int preferred_nid,
 		prep_new_page(page, 0, gfp, 0);
 		if (page_list)
 			list_add(&page->lru, page_list);
-		else
+		else if (page_array)
 			page_array[nr_populated] = page;
+		else
+			cb(page, data);
 		nr_populated++;
 	}
 
@@ -5554,8 +5561,10 @@ unsigned long __alloc_pages_bulk(gfp_t gfp, int preferred_nid,
 	if (page) {
 		if (page_list)
 			list_add(&page->lru, page_list);
-		else
+		else if (page_array)
 			page_array[nr_populated] = page;
+		else
+			cb(page, data);
 		nr_populated++;
 	}
 
-- 
2.39.0

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel


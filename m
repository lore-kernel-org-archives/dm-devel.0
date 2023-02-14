Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 18005C6379F
	for <dm-devel@archiver.kernel.org>; Wed, 15 Feb 2023 09:33:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1676453629;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=K3LsAzxtqZa+ivkh1ytH7rriRqUnqvshZmtcWnktufw=;
	b=Paast4V4fEnxZSP52jXvD5G4vsKEg3jo1jgWxEnxHgj5HumKCrcWQp/txUBkUTbi7yHNuU
	pphshD6Jci4wdVHqaX/NTWI4/bUyd5UOEoDIyB9DBu4zHehfuzBs9F1sXjTRJFrQyEkG2S
	GON6JO1cbdYTScVtZo8+UDPZX3VrwXU=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-395-UHMYxwDcMnuNisBFDq-ogQ-1; Wed, 15 Feb 2023 04:33:47 -0500
X-MC-Unique: UHMYxwDcMnuNisBFDq-ogQ-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 9B85388436C;
	Wed, 15 Feb 2023 09:33:43 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 635B518EC1;
	Wed, 15 Feb 2023 09:33:40 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 3689819465B9;
	Wed, 15 Feb 2023 09:33:39 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com
 [10.11.54.10])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 2BEAB1946586
 for <dm-devel@listman.corp.redhat.com>; Tue, 14 Feb 2023 19:02:43 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 0BFC0492B16; Tue, 14 Feb 2023 19:02:43 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast09.extmail.prod.ext.rdu2.redhat.com [10.11.55.25])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 04931492B15
 for <dm-devel@redhat.com>; Tue, 14 Feb 2023 19:02:42 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D8F4A29ABA07
 for <dm-devel@redhat.com>; Tue, 14 Feb 2023 19:02:42 +0000 (UTC)
Received: from mail-il1-f182.google.com (mail-il1-f182.google.com
 [209.85.166.182]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-625-loJfmJhTMey1Wkg6GfZMmQ-1; Tue, 14 Feb 2023 14:02:41 -0500
X-MC-Unique: loJfmJhTMey1Wkg6GfZMmQ-1
Received: by mail-il1-f182.google.com with SMTP id h4so3234141ile.5;
 Tue, 14 Feb 2023 11:02:40 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=content-transfer-encoding:mime-version:references:in-reply-to
 :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
 :subject:date:message-id:reply-to;
 bh=XqvEeGV6oh0EWfoDksrWyy2/Blf2fwRqNf/jz7ukuRw=;
 b=uQBjkoxCTuXZulID2fqvhXbTN5xF8Gg6mMWQ5p+qkApVzbkzTp6dB7FlzuAvHwMyQ8
 Hv0bu63+pu/fl/g2A1EzJwzWzBML6ykZYNaR6kNxGGhVZ0TQcL3ejDUsrrLvxKl55m7a
 kHRAOWltxv1GxyM5OVx4qZ46JxLK1/udLrFs5y8spCZwck2otxUt9K60jwtpGMhDpPk7
 G+MdR+1EVP9C06L+EfdZGU/X8sBcTs7Uqhqv8S91mxcqsYPqPq1laIeqDwilmFdbc2Ks
 6crffo/zkuR8mRnECICRNhSuJM2qIfivH2xXsKsyUy8Cwi12jVt+F1L1KtrAZtcBBWhw
 0C4g==
X-Gm-Message-State: AO0yUKWGXQgzwRRFE50aC5RQL/lstyboXE2OLHL4hWSJSJ7CuvAQXxYY
 +8uTYKNJEhrrqp7yaHpomDs=
X-Google-Smtp-Source: AK7set9w7As1PUAlwdFW1t3QYCy1I6uoqWw2i5qBHiV+D4qRRjOPuzWXvnCCj9OvgR5i77kopvWOXg==
X-Received: by 2002:a05:6e02:1a43:b0:310:ae72:32a0 with SMTP id
 u3-20020a056e021a4300b00310ae7232a0mr4441998ilv.21.1676401359609; 
 Tue, 14 Feb 2023 11:02:39 -0800 (PST)
Received: from localhost.localdomain (c-67-174-241-145.hsd1.ca.comcast.net.
 [67.174.241.145]) by smtp.gmail.com with ESMTPSA id
 r11-20020a056e0219cb00b0030c27c9eea4sm3608770ill.33.2023.02.14.11.02.38
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Tue, 14 Feb 2023 11:02:39 -0800 (PST)
From: Yang Shi <shy828301@gmail.com>
To: mgorman@techsingularity.net, agk@redhat.com, snitzer@kernel.org,
 dm-devel@redhat.com, akpm@linux-foundation.org
Date: Tue, 14 Feb 2023 11:02:19 -0800
Message-Id: <20230214190221.1156876-4-shy828301@gmail.com>
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
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.10
X-Mailman-Approved-At: Wed, 15 Feb 2023 09:33:38 +0000
Subject: [dm-devel] [v2 PATCH 3/5] mm: mempool: introduce page bulk allocator
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
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Since v5.13 the page bulk allocator was introduced to allocate order-0
pages in bulk.  There are a few mempool allocator callers which does
order-0 page allocation in a loop, for example, dm-crypt, f2fs compress,
etc.  A mempool page bulk allocator seems useful.  So introduce the
mempool page bulk allocator.

It introduces the below APIs:
  - mempool_init_pages_bulk()
  - mempool_create_pages_bulk()
They initialize the mempool for page bulk allocator.  The pool is filled
by alloc_page() in a loop.

  - mempool_alloc_pages_bulk_array()
  - mempool_alloc_pages_bulk_cb()
They do bulk allocation from mempool.
They do the below conceptually:
  1. Call bulk page allocator
  2. If the allocation is fulfilled then return otherwise try to
     allocate the remaining pages from the mempool
  3. If it is fulfilled then return otherwise retry from #1 with sleepable
     gfp
  4. If it is still failed, sleep for a while to wait for the mempool is
     refilled, then retry from #1
The populated pages will stay on the array until the callers consume them
or free them, or are consumed by the callback immediately.

Since mempool allocator is guaranteed to success in the sleepable context,
so the two APIs return true for success or false for fail.  It is the
caller's responsibility to handle failure case (partial allocation), just
like the page bulk allocator.

The mempool typically is an object agnostic allocator, but bulk allocation
is only supported by pages, so the mempool bulk allocator is for page
allocation only as well.

Signed-off-by: Yang Shi <shy828301@gmail.com>
---
 include/linux/mempool.h |  21 +++++
 mm/mempool.c            | 177 ++++++++++++++++++++++++++++++++++++----
 2 files changed, 181 insertions(+), 17 deletions(-)

diff --git a/include/linux/mempool.h b/include/linux/mempool.h
index 4aae6c06c5f2..1907395b2ef5 100644
--- a/include/linux/mempool.h
+++ b/include/linux/mempool.h
@@ -13,6 +13,12 @@ struct kmem_cache;
 typedef void * (mempool_alloc_t)(gfp_t gfp_mask, void *pool_data);
 typedef void (mempool_free_t)(void *element, void *pool_data);
 
+typedef unsigned int (mempool_alloc_pages_bulk_t)(gfp_t gfp_mask,
+					unsigned int nr, void *pool_data,
+					struct page **page_array,
+					void (*cb)(struct page *, void *),
+					void *data);
+
 typedef struct mempool_s {
 	spinlock_t lock;
 	int min_nr;		/* nr of elements at *elements */
@@ -22,6 +28,7 @@ typedef struct mempool_s {
 	void *pool_data;
 	mempool_alloc_t *alloc;
 	mempool_free_t *free;
+	mempool_alloc_pages_bulk_t *alloc_pages_bulk;
 	wait_queue_head_t wait;
 } mempool_t;
 
@@ -41,18 +48,32 @@ int mempool_init_node(mempool_t *pool, int min_nr, mempool_alloc_t *alloc_fn,
 		      gfp_t gfp_mask, int node_id);
 int mempool_init(mempool_t *pool, int min_nr, mempool_alloc_t *alloc_fn,
 		 mempool_free_t *free_fn, void *pool_data);
+int mempool_init_pages_bulk(mempool_t *pool, int min_nr,
+			    mempool_alloc_pages_bulk_t *alloc_pages_bulk_fn,
+			    mempool_free_t *free_fn, void *pool_data);
 
 extern mempool_t *mempool_create(int min_nr, mempool_alloc_t *alloc_fn,
 			mempool_free_t *free_fn, void *pool_data);
 extern mempool_t *mempool_create_node(int min_nr, mempool_alloc_t *alloc_fn,
 			mempool_free_t *free_fn, void *pool_data,
 			gfp_t gfp_mask, int nid);
+extern mempool_t *mempool_create_pages_bulk(int min_nr,
+			mempool_alloc_pages_bulk_t *alloc_pages_bulk_fn,
+			mempool_free_t *free_fn, void *pool_data);
 
 extern int mempool_resize(mempool_t *pool, int new_min_nr);
 extern void mempool_destroy(mempool_t *pool);
 extern void *mempool_alloc(mempool_t *pool, gfp_t gfp_mask) __malloc;
 extern void mempool_free(void *element, mempool_t *pool);
 
+extern bool mempool_alloc_pages_bulk_array(mempool_t *pool, gfp_t gfp_mask,
+					   unsigned int nr,
+					   struct page **page_array);
+extern bool mempool_alloc_pages_bulk_cb(mempool_t *pool, gfp_t gfp_mask,
+					unsigned int nr,
+					void (*cb)(struct page *, void *),
+					void *data);
+
 /*
  * A mempool_alloc_t and mempool_free_t that get the memory from
  * a slab cache that is passed in through pool_data.
diff --git a/mm/mempool.c b/mm/mempool.c
index 975c9d1491b6..dddcd847d765 100644
--- a/mm/mempool.c
+++ b/mm/mempool.c
@@ -183,6 +183,7 @@ void mempool_destroy(mempool_t *pool)
 EXPORT_SYMBOL(mempool_destroy);
 
 static inline int __mempool_init(mempool_t *pool, int min_nr,
+				 mempool_alloc_pages_bulk_t *alloc_pages_bulk_fn,
 				 mempool_alloc_t *alloc_fn,
 				 mempool_free_t *free_fn, void *pool_data,
 				 gfp_t gfp_mask, int node_id)
@@ -192,8 +193,11 @@ static inline int __mempool_init(mempool_t *pool, int min_nr,
 	pool->pool_data = pool_data;
 	pool->alloc	= alloc_fn;
 	pool->free	= free_fn;
+	pool->alloc_pages_bulk = alloc_pages_bulk_fn;
 	init_waitqueue_head(&pool->wait);
 
+	WARN_ON_ONCE(alloc_pages_bulk_fn && alloc_fn);
+
 	pool->elements = kmalloc_array_node(min_nr, sizeof(void *),
 					    gfp_mask, node_id);
 	if (!pool->elements)
@@ -205,7 +209,10 @@ static inline int __mempool_init(mempool_t *pool, int min_nr,
 	while (pool->curr_nr < pool->min_nr) {
 		void *element;
 
-		element = pool->alloc(gfp_mask, pool->pool_data);
+		if (pool->alloc_pages_bulk)
+			element = alloc_page(gfp_mask);
+		else
+			element = pool->alloc(gfp_mask, pool->pool_data);
 		if (unlikely(!element)) {
 			mempool_exit(pool);
 			return -ENOMEM;
@@ -220,7 +227,7 @@ int mempool_init_node(mempool_t *pool, int min_nr, mempool_alloc_t *alloc_fn,
 		      mempool_free_t *free_fn, void *pool_data,
 		      gfp_t gfp_mask, int node_id)
 {
-	return __mempool_init(pool, min_nr, alloc_fn, free_fn, pool_data,
+	return __mempool_init(pool, min_nr, NULL, alloc_fn, free_fn, pool_data,
 			      gfp_mask, node_id);
 }
 EXPORT_SYMBOL(mempool_init_node);
@@ -242,14 +249,39 @@ EXPORT_SYMBOL(mempool_init_node);
 int mempool_init(mempool_t *pool, int min_nr, mempool_alloc_t *alloc_fn,
 		 mempool_free_t *free_fn, void *pool_data)
 {
-	return __mempool_init(pool, min_nr, alloc_fn, free_fn,
+	return __mempool_init(pool, min_nr, NULL, alloc_fn, free_fn,
 			      pool_data, GFP_KERNEL, NUMA_NO_NODE);
 }
 EXPORT_SYMBOL(mempool_init);
 
-static mempool_t *__mempool_create(int min_nr, mempool_alloc_t *alloc_fn,
-				   mempool_free_t *free_fn, void *pool_data,
-				   gfp_t gfp_mask, int node_id)
+/**
+ * mempool_init_pages_bulk - initialize a pages pool for bulk allocator
+ * @pool: pointer to the memory pool that should be initialized
+ * @min_nr: the minimum number of elements guaranteed to be
+ *          allocated for this pool.
+ * @alloc_pages_bulk_fn: user-defined pages bulk allocation function.
+ * @free_fn: user-defined element-freeing function.
+ * @pool_data: optional private data available to the user-defined functions.
+ *
+ * Like mempool_create(), but initializes the pool in (i.e. embedded in another
+ * structure).
+ *
+ * Return: %0 on success, negative error code otherwise.
+ */
+int mempool_init_pages_bulk(mempool_t *pool, int min_nr,
+			    mempool_alloc_pages_bulk_t *alloc_pages_bulk_fn,
+			    mempool_free_t *free_fn, void *pool_data)
+{
+	return __mempool_init(pool, min_nr, alloc_pages_bulk_fn, NULL,
+			      free_fn, pool_data, GFP_KERNEL, NUMA_NO_NODE);
+}
+EXPORT_SYMBOL(mempool_init_pages_bulk);
+
+static mempool_t *__mempool_create(int min_nr,
+			mempool_alloc_pages_bulk_t *alloc_pages_bulk_fn,
+			mempool_alloc_t *alloc_fn,
+			mempool_free_t *free_fn, void *pool_data,
+			gfp_t gfp_mask, int node_id)
 {
 	mempool_t *pool;
 
@@ -257,8 +289,8 @@ static mempool_t *__mempool_create(int min_nr, mempool_alloc_t *alloc_fn,
 	if (!pool)
 		return NULL;
 
-	if (__mempool_init(pool, min_nr, alloc_fn, free_fn, pool_data,
-			   gfp_mask, node_id)) {
+	if (__mempool_init(pool, min_nr, alloc_pages_bulk_fn, alloc_fn,
+			   free_fn, pool_data, gfp_mask, node_id)) {
 		kfree(pool);
 		return NULL;
 	}
@@ -285,7 +317,7 @@ static mempool_t *__mempool_create(int min_nr, mempool_alloc_t *alloc_fn,
 mempool_t *mempool_create(int min_nr, mempool_alloc_t *alloc_fn,
 				mempool_free_t *free_fn, void *pool_data)
 {
-	return __mempool_create(min_nr, alloc_fn, free_fn, pool_data,
+	return __mempool_create(min_nr, NULL, alloc_fn, free_fn, pool_data,
 				GFP_KERNEL, NUMA_NO_NODE);
 }
 EXPORT_SYMBOL(mempool_create);
@@ -294,11 +326,21 @@ mempool_t *mempool_create_node(int min_nr, mempool_alloc_t *alloc_fn,
 			       mempool_free_t *free_fn, void *pool_data,
 			       gfp_t gfp_mask, int node_id)
 {
-	return __mempool_create(min_nr, alloc_fn, free_fn, pool_data,
+	return __mempool_create(min_nr, NULL, alloc_fn, free_fn, pool_data,
 				gfp_mask, node_id);
 }
 EXPORT_SYMBOL(mempool_create_node);
 
+mempool_t* mempool_create_pages_bulk(int min_nr,
+			mempool_alloc_pages_bulk_t *alloc_pages_bulk_fn,
+			mempool_free_t *free_fn, void *pool_data)
+{
+	return __mempool_create(min_nr, alloc_pages_bulk_fn, NULL,
+				free_fn, pool_data, GFP_KERNEL,
+				NUMA_NO_NODE);
+}
+EXPORT_SYMBOL(mempool_create_pages_bulk);
+
 /**
  * mempool_resize - resize an existing memory pool
  * @pool:       pointer to the memory pool which was allocated via
@@ -379,12 +421,23 @@ int mempool_resize(mempool_t *pool, int new_min_nr)
 }
 EXPORT_SYMBOL(mempool_resize);
 
-static void *__mempool_alloc(mempool_t *pool, gfp_t gfp_mask)
+#define MEMPOOL_BULK_SUCCESS_PTR	((void *)16)
+
+static void * __mempool_alloc(mempool_t *pool, gfp_t gfp_mask, unsigned int nr,
+			      struct page **page_array,
+			      void (*cb)(struct page *, void *),
+			      void *data)
 {
 	void *element;
 	unsigned long flags;
 	wait_queue_entry_t wait;
 	gfp_t gfp_temp;
+	int i;
+	unsigned int ret, nr_remaining;
+	struct page *page;
+	bool bulk_page_alloc = true;
+
+	ret = nr_remaining = 0;
 
 	VM_WARN_ON_ONCE(gfp_mask & __GFP_ZERO);
 	might_alloc(gfp_mask);
@@ -395,14 +448,27 @@ static void *__mempool_alloc(mempool_t *pool, gfp_t gfp_mask)
 
 	gfp_temp = gfp_mask & ~(__GFP_DIRECT_RECLAIM|__GFP_IO);
 
+	if ((nr == 1) && (!page_array && !cb && !data))
+		bulk_page_alloc = false;
+
 repeat_alloc:
+	i = 0;
+
+	if (bulk_page_alloc) {
+		ret = pool->alloc_pages_bulk(gfp_temp, nr, pool->pool_data,
+					     page_array, cb, data);
+		if (ret == nr)
+			return MEMPOOL_BULK_SUCCESS_PTR;
+	} else {
+		element = pool->alloc(gfp_temp, pool->pool_data);
+		if (likely(element != NULL))
+			return element;
+	}
 
-	element = pool->alloc(gfp_temp, pool->pool_data);
-	if (likely(element != NULL))
-		return element;
+	nr_remaining = nr - ret;
 
 	spin_lock_irqsave(&pool->lock, flags);
-	if (likely(pool->curr_nr)) {
+	while (pool->curr_nr && (nr_remaining > 0)) {
 		element = remove_element(pool);
 		spin_unlock_irqrestore(&pool->lock, flags);
 		/* paired with rmb in mempool_free(), read comment there */
@@ -412,9 +478,34 @@ static void *__mempool_alloc(mempool_t *pool, gfp_t gfp_mask)
 		 * for debugging.
 		 */
 		kmemleak_update_trace(element);
-		return element;
+
+		if (!bulk_page_alloc)
+			return element;
+
+		page = (struct page *)element;
+		if (page_array)
+			page_array[ret + i] = page;
+		else
+			cb(page, data);
+
+		i++;
+		nr_remaining--;
+
+		spin_lock_irqsave(&pool->lock, flags);
+	}
+
+	if (bulk_page_alloc && !nr_remaining) {
+		spin_unlock_irqrestore(&pool->lock, flags);
+		return MEMPOOL_BULK_SUCCESS_PTR;
 	}
 
+	/*
+	 * The bulk allocator counts in the populated pages for array,
+	 * but don't do it for the callback version.
+	 */
+	if (bulk_page_alloc && !page_array)
+		nr = nr_remaining;
+
 	/*
 	 * We use gfp mask w/o direct reclaim or IO for the first round.  If
 	 * alloc failed with that and @pool was empty, retry immediately.
@@ -463,10 +554,62 @@ static void *__mempool_alloc(mempool_t *pool, gfp_t gfp_mask)
  */
 void *mempool_alloc(mempool_t *pool, gfp_t gfp_mask)
 {
-	return __mempool_alloc(pool, gfp_mask);
+	return __mempool_alloc(pool, gfp_mask, 1, NULL, NULL, NULL);
 }
 EXPORT_SYMBOL(mempool_alloc);
 
+/**
+ * mempool_alloc_pages_bulk - allocate a bulk of pagesfrom a specific
+ *                           memory pool
+ * @pool:       pointer to the memory pool which was allocated via
+ *              mempool_create().
+ * @gfp_mask:   the usual allocation bitmask.
+ * @nr:         the number of requested pages.
+ * @page_array: the array the pages will be added to.
+ * @cb:		the callback function that will handle the page.
+ * @data:	the parameter used by the callback
+ *
+ * this function only sleeps if the alloc_pages_bulk_fn() function sleeps
+ * or the allocation can not be satisfied even though the mempool is depleted.
+ * Note that due to preallocation, this function *never* fails when called
+ * from process contexts. (it might fail if called from an IRQ context.)
+ * Note: using __GFP_ZERO is not supported.  And the caller should not pass
+ * in both valid page_array and callback.
+ *
+ * Return: true when nr pages are allocated or false if not.  It is the
+ *         caller's responsibility to free the partial allocated pages.
+ */
+static bool mempool_alloc_pages_bulk(mempool_t *pool, gfp_t gfp_mask,
+				     unsigned int nr,
+				     struct page **page_array,
+				     void (*cb)(struct page *, void *),
+				     void *data)
+{
+	if(!__mempool_alloc(pool, gfp_mask, nr, page_array, cb, data))
+		return false;
+
+	return true;
+}
+
+bool mempool_alloc_pages_bulk_array(mempool_t *pool, gfp_t gfp_mask,
+				    unsigned int nr,
+				    struct page **page_array)
+{
+	return mempool_alloc_pages_bulk(pool, gfp_mask, nr, page_array,
+					NULL, NULL);
+}
+EXPORT_SYMBOL(mempool_alloc_pages_bulk_array);
+
+bool mempool_alloc_pages_bulk_cb(mempool_t *pool, gfp_t gfp_mask,
+				 unsigned int nr,
+				 void (*cb)(struct page *, void *),
+				 void *data)
+{
+	return mempool_alloc_pages_bulk(pool, gfp_mask, nr, NULL,
+					cb, data);
+}
+EXPORT_SYMBOL(mempool_alloc_pages_bulk_cb);
+
 /**
  * mempool_free - return an element to the pool.
  * @element:   pool element pointer.
-- 
2.39.0

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel


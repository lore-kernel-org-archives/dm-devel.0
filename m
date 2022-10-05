Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 46912C433FE
	for <dm-devel@archiver.kernel.org>; Thu,  6 Oct 2022 07:13:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1665040419;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=rfe6XxGkz9ufU4OYiGL7AOaC7eUKMdMLMl+R6PHMh4k=;
	b=Qp9Ow6ZluQu1xThqlAMTHWyvxvlGxEzdAopa7UsYLCkPLO4DWViedtjjMZLJt2oMXvgMPX
	PRGVr+0WUGhE2J8mSPh1XSomtqh6goMRzVespGFDvVlU9qwPzO1wsHaPZot4qAQIOyhaYB
	WTXuCq1zqqudQEoM5AeNsP8GeeucWUs=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-611-qdzICnzNOw2nGxThOiFrSQ-1; Thu, 06 Oct 2022 03:13:36 -0400
X-MC-Unique: qdzICnzNOw2nGxThOiFrSQ-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id E7D1E29324A1;
	Thu,  6 Oct 2022 07:13:33 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id D0675492B15;
	Thu,  6 Oct 2022 07:13:33 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 005191947B8C;
	Thu,  6 Oct 2022 07:13:33 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
 [10.11.54.5])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id AA6501946A4E
 for <dm-devel@listman.corp.redhat.com>; Wed,  5 Oct 2022 18:04:07 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 9BE7039DB3; Wed,  5 Oct 2022 18:04:07 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 9428F18EB4
 for <dm-devel@redhat.com>; Wed,  5 Oct 2022 18:04:07 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 737E88828D7
 for <dm-devel@redhat.com>; Wed,  5 Oct 2022 18:04:07 +0000 (UTC)
Received: from mail-pj1-f48.google.com (mail-pj1-f48.google.com
 [209.85.216.48]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-93-sBM03bhaPbm-jqDq3M6kgA-1; Wed, 05 Oct 2022 14:03:55 -0400
X-MC-Unique: sBM03bhaPbm-jqDq3M6kgA-1
Received: by mail-pj1-f48.google.com with SMTP id fw14so9160184pjb.3;
 Wed, 05 Oct 2022 11:03:55 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=content-transfer-encoding:mime-version:references:in-reply-to
 :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
 :subject:date:message-id:reply-to;
 bh=iroUAKdZ7R5Gx/z/KE5xhjM/Ew8lqKEyV5onJIu1MHY=;
 b=q2HXM3wHzB2Qhgq8zQQLyCJUrUYNWrlR2Iytlba5/0kfBRSBNvLkY/agEzRLj7OUlH
 23h/64WgSGM2S78EChIpZe1xpjxMLqRpN+gLz1t2Gv6QRoIsOT/CvawDJzV4vYk9P/ZO
 RZ+QIVOdgxZf6rLswWwlAPCTXeZv958G9SqH54ttDHphXhqxDEbRZMHfs3bgbyRwawWo
 UlbH7dIDs1nWzaPx7/fdmsvruZnFdbK2G183Ub+bclKEHoRLFgVXo+p6x97lkn5CY+Jz
 DqGNQp/4yaR0RrVBLarq2bFDI0dv70PbFG1MfkfJb8+uvrAS1YIqM7ZYNk89GEX0KrN5
 TEmw==
X-Gm-Message-State: ACrzQf3O39pln5/5UNHg7gIK2ielPn5XH9AJvOUbl+9xZH8CD8EpNDDu
 4q3iEWDEOU/Pk6/y21b1RrQ=
X-Google-Smtp-Source: AMsMyM7sKKoKZPF7OajApXBcH9gnY/xelKkIALaQi5/UQI5v92qoBDhlVKNCJ1myXqDizlCR9tzFmw==
X-Received: by 2002:a17:90b:38cb:b0:203:100:bb53 with SMTP id
 nn11-20020a17090b38cb00b002030100bb53mr944531pjb.107.1664993034172; 
 Wed, 05 Oct 2022 11:03:54 -0700 (PDT)
Received: from localhost.localdomain (c-67-174-241-145.hsd1.ca.comcast.net.
 [67.174.241.145]) by smtp.gmail.com with ESMTPSA id
 y17-20020a170903011100b001788494b764sm10674639plc.231.2022.10.05.11.03.52
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Wed, 05 Oct 2022 11:03:53 -0700 (PDT)
From: Yang Shi <shy828301@gmail.com>
To: mgorman@techsingularity.net, agk@redhat.com, snitzer@kernel.org,
 dm-devel@redhat.com, akpm@linux-foundation.org
Date: Wed,  5 Oct 2022 11:03:38 -0700
Message-Id: <20221005180341.1738796-2-shy828301@gmail.com>
In-Reply-To: <20221005180341.1738796-1-shy828301@gmail.com>
References: <20221005180341.1738796-1-shy828301@gmail.com>
MIME-Version: 1.0
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
X-Mailman-Approved-At: Thu, 06 Oct 2022 07:13:31 +0000
Subject: [dm-devel] [PATCH 1/4] mm: mempool: extract common initialization
 code
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
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.10
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Extract the common initialization code to __mempool_init() and
__mempool_create().  This will make adding mempool bulk init
code easier.

Signed-off-by: Yang Shi <shy828301@gmail.com>
---
 mm/mempool.c | 57 ++++++++++++++++++++++++++++++++++------------------
 1 file changed, 37 insertions(+), 20 deletions(-)

diff --git a/mm/mempool.c b/mm/mempool.c
index 96488b13a1ef..ba32151f3843 100644
--- a/mm/mempool.c
+++ b/mm/mempool.c
@@ -176,9 +176,10 @@ void mempool_destroy(mempool_t *pool)
 }
 EXPORT_SYMBOL(mempool_destroy);
 
-int mempool_init_node(mempool_t *pool, int min_nr, mempool_alloc_t *alloc_fn,
-		      mempool_free_t *free_fn, void *pool_data,
-		      gfp_t gfp_mask, int node_id)
+static inline int __mempool_init(mempool_t *pool, int min_nr,
+				 mempool_alloc_t *alloc_fn,
+				 mempool_free_t *free_fn, void *pool_data,
+				 gfp_t gfp_mask, int node_id)
 {
 	spin_lock_init(&pool->lock);
 	pool->min_nr	= min_nr;
@@ -208,6 +209,14 @@ int mempool_init_node(mempool_t *pool, int min_nr, mempool_alloc_t *alloc_fn,
 
 	return 0;
 }
+
+int mempool_init_node(mempool_t *pool, int min_nr, mempool_alloc_t *alloc_fn,
+		      mempool_free_t *free_fn, void *pool_data,
+		      gfp_t gfp_mask, int node_id)
+{
+	return __mempool_init(pool, min_nr, alloc_fn, free_fn, pool_data,
+			      gfp_mask, node_id);
+}
 EXPORT_SYMBOL(mempool_init_node);
 
 /**
@@ -227,12 +236,31 @@ EXPORT_SYMBOL(mempool_init_node);
 int mempool_init(mempool_t *pool, int min_nr, mempool_alloc_t *alloc_fn,
 		 mempool_free_t *free_fn, void *pool_data)
 {
-	return mempool_init_node(pool, min_nr, alloc_fn, free_fn,
-				 pool_data, GFP_KERNEL, NUMA_NO_NODE);
+	return __mempool_init(pool, min_nr, alloc_fn, free_fn,
+			      pool_data, GFP_KERNEL, NUMA_NO_NODE);
 
 }
 EXPORT_SYMBOL(mempool_init);
 
+static mempool_t *__mempool_create(int min_nr, mempool_alloc_t *alloc_fn,
+				   mempool_free_t *free_fn, void *pool_data,
+				   gfp_t gfp_mask, int node_id)
+{
+	mempool_t *pool;
+
+	pool = kzalloc_node(sizeof(*pool), gfp_mask, node_id);
+	if (!pool)
+		return NULL;
+
+	if (__mempool_init(pool, min_nr, alloc_fn, free_fn, pool_data,
+			   gfp_mask, node_id)) {
+		kfree(pool);
+		return NULL;
+	}
+
+	return pool;
+}
+
 /**
  * mempool_create - create a memory pool
  * @min_nr:    the minimum number of elements guaranteed to be
@@ -252,8 +280,8 @@ EXPORT_SYMBOL(mempool_init);
 mempool_t *mempool_create(int min_nr, mempool_alloc_t *alloc_fn,
 				mempool_free_t *free_fn, void *pool_data)
 {
-	return mempool_create_node(min_nr, alloc_fn, free_fn, pool_data,
-				   GFP_KERNEL, NUMA_NO_NODE);
+	return __mempool_create(min_nr, alloc_fn, free_fn, pool_data,
+				GFP_KERNEL, NUMA_NO_NODE);
 }
 EXPORT_SYMBOL(mempool_create);
 
@@ -261,19 +289,8 @@ mempool_t *mempool_create_node(int min_nr, mempool_alloc_t *alloc_fn,
 			       mempool_free_t *free_fn, void *pool_data,
 			       gfp_t gfp_mask, int node_id)
 {
-	mempool_t *pool;
-
-	pool = kzalloc_node(sizeof(*pool), gfp_mask, node_id);
-	if (!pool)
-		return NULL;
-
-	if (mempool_init_node(pool, min_nr, alloc_fn, free_fn, pool_data,
-			      gfp_mask, node_id)) {
-		kfree(pool);
-		return NULL;
-	}
-
-	return pool;
+	return __mempool_create(min_nr, alloc_fn, free_fn, pool_data,
+				gfp_mask, node_id);
 }
 EXPORT_SYMBOL(mempool_create_node);
 
-- 
2.26.3

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel


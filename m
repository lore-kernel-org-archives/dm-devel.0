Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B7135C636D4
	for <dm-devel@archiver.kernel.org>; Wed, 15 Feb 2023 09:33:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1676453627;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=tu6veuckJd/UZJog02mZ0YtAMU8YN6RuOx4pZEmGOGY=;
	b=OcHDohxRYUSm7qufLwv0vp4ljgh13QIt7pfKmlFklBPL6/I/RosOUYNtleOFWMrpZnTsUR
	OU+l8RUmvVq/it35W1o+yFuBAADq1r9F4ssH8pWdrfyj+4XW6OIXBsGl4O4p5UQalPkMJ0
	qnf4fq17v/GK4dpFbJhKtGLReOimLG8=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-653-4jHy0dR8OMKXwnhQM0C7vg-1; Wed, 15 Feb 2023 04:33:46 -0500
X-MC-Unique: 4jHy0dR8OMKXwnhQM0C7vg-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 99480884369;
	Wed, 15 Feb 2023 09:33:43 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id E8B8D112131E;
	Wed, 15 Feb 2023 09:33:42 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id E2C481946A70;
	Wed, 15 Feb 2023 09:33:39 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
 [10.11.54.6])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 041681946595
 for <dm-devel@listman.corp.redhat.com>; Tue, 14 Feb 2023 19:02:47 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id E26F32166B29; Tue, 14 Feb 2023 19:02:41 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id DAEC12166B26
 for <dm-devel@redhat.com>; Tue, 14 Feb 2023 19:02:41 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id BB02585A5A3
 for <dm-devel@redhat.com>; Tue, 14 Feb 2023 19:02:41 +0000 (UTC)
Received: from mail-il1-f175.google.com (mail-il1-f175.google.com
 [209.85.166.175]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-393-KXtNtueGPT24IhXRGHAJ8g-1; Tue, 14 Feb 2023 14:02:39 -0500
X-MC-Unique: KXtNtueGPT24IhXRGHAJ8g-1
Received: by mail-il1-f175.google.com with SMTP id i26so265418ila.11;
 Tue, 14 Feb 2023 11:02:38 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=content-transfer-encoding:mime-version:references:in-reply-to
 :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
 :subject:date:message-id:reply-to;
 bh=MPPamIyRpbGBQ5ryZF3ausqPZtq/gq8Gwr+ekJX0vLw=;
 b=4sJDZbbX3+yQa1q/GuQCqyLXdDDUy5T/CurcRWK1wgeaizEAWPMxsN3ik9HEdQEf3h
 yj8QkCKLNY7spIKw18g5iHdTuWPHsPPpBmuVhI7dkp9jNBWxLfaU4Wlx5J49NvRDYugk
 ji2VJNJ1ZlklA+KeGX9uRSgynAP589jLYkP3U2HTYrwJK42+UHLp4SJKLFGbxNSrXkoP
 V87CjRQc2YZPRYWwGrl+BLnZQuoIx7wDLFhY6nup6BAXMot7H0fxT3EkPDtOiRExVLgE
 HDn5LBc0Nb9t0yRpSJfF3eMjr6y11yJwcM/f+EohRtETwyVLc1jNtOR73xlXLNcaLkAv
 YbKA==
X-Gm-Message-State: AO0yUKX2Yb+fETKS+VmwrELkSGCbxmGZ3pDGxggUpM+GeCnlylSe9OVt
 wnjoSBXayK9QdtQb1A8EZQqjWpkUfKSVaA==
X-Google-Smtp-Source: AK7set+eY5XAwZXkOnW0qFOv85zlppyeV5NeG8+1WBt2UYlWnui6VEDbC+TuErm7ZvFyUGKQs5ccQQ==
X-Received: by 2002:a92:c241:0:b0:310:fa45:ac78 with SMTP id
 k1-20020a92c241000000b00310fa45ac78mr2181236ilo.29.1676401358385; 
 Tue, 14 Feb 2023 11:02:38 -0800 (PST)
Received: from localhost.localdomain (c-67-174-241-145.hsd1.ca.comcast.net.
 [67.174.241.145]) by smtp.gmail.com with ESMTPSA id
 r11-20020a056e0219cb00b0030c27c9eea4sm3608770ill.33.2023.02.14.11.02.37
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Tue, 14 Feb 2023 11:02:38 -0800 (PST)
From: Yang Shi <shy828301@gmail.com>
To: mgorman@techsingularity.net, agk@redhat.com, snitzer@kernel.org,
 dm-devel@redhat.com, akpm@linux-foundation.org
Date: Tue, 14 Feb 2023 11:02:18 -0800
Message-Id: <20230214190221.1156876-3-shy828301@gmail.com>
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
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.6
X-Mailman-Approved-At: Wed, 15 Feb 2023 09:33:38 +0000
Subject: [dm-devel] [v2 PATCH 2/5] mm: mempool: extract the common
 initialization and alloc code
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
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Extract the common initialization code to __mempool_init() and
__mempool_create().  And extract the common alloc code into an internal
function.  This will make the following patch easier and avoid duplicate
code.

Signed-off-by: Yang Shi <shy828301@gmail.com>
---
 mm/mempool.c | 93 ++++++++++++++++++++++++++++++++--------------------
 1 file changed, 57 insertions(+), 36 deletions(-)

diff --git a/mm/mempool.c b/mm/mempool.c
index 734bcf5afbb7..975c9d1491b6 100644
--- a/mm/mempool.c
+++ b/mm/mempool.c
@@ -182,9 +182,10 @@ void mempool_destroy(mempool_t *pool)
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
@@ -214,6 +215,14 @@ int mempool_init_node(mempool_t *pool, int min_nr, mempool_alloc_t *alloc_fn,
 
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
@@ -233,12 +242,30 @@ EXPORT_SYMBOL(mempool_init_node);
 int mempool_init(mempool_t *pool, int min_nr, mempool_alloc_t *alloc_fn,
 		 mempool_free_t *free_fn, void *pool_data)
 {
-	return mempool_init_node(pool, min_nr, alloc_fn, free_fn,
-				 pool_data, GFP_KERNEL, NUMA_NO_NODE);
-
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
@@ -258,8 +285,8 @@ EXPORT_SYMBOL(mempool_init);
 mempool_t *mempool_create(int min_nr, mempool_alloc_t *alloc_fn,
 				mempool_free_t *free_fn, void *pool_data)
 {
-	return mempool_create_node(min_nr, alloc_fn, free_fn, pool_data,
-				   GFP_KERNEL, NUMA_NO_NODE);
+	return __mempool_create(min_nr, alloc_fn, free_fn, pool_data,
+				GFP_KERNEL, NUMA_NO_NODE);
 }
 EXPORT_SYMBOL(mempool_create);
 
@@ -267,19 +294,8 @@ mempool_t *mempool_create_node(int min_nr, mempool_alloc_t *alloc_fn,
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
 
@@ -363,21 +379,7 @@ int mempool_resize(mempool_t *pool, int new_min_nr)
 }
 EXPORT_SYMBOL(mempool_resize);
 
-/**
- * mempool_alloc - allocate an element from a specific memory pool
- * @pool:      pointer to the memory pool which was allocated via
- *             mempool_create().
- * @gfp_mask:  the usual allocation bitmask.
- *
- * this function only sleeps if the alloc_fn() function sleeps or
- * returns NULL. Note that due to preallocation, this function
- * *never* fails when called from process contexts. (it might
- * fail if called from an IRQ context.)
- * Note: using __GFP_ZERO is not supported.
- *
- * Return: pointer to the allocated element or %NULL on error.
- */
-void *mempool_alloc(mempool_t *pool, gfp_t gfp_mask)
+static void *__mempool_alloc(mempool_t *pool, gfp_t gfp_mask)
 {
 	void *element;
 	unsigned long flags;
@@ -444,6 +446,25 @@ void *mempool_alloc(mempool_t *pool, gfp_t gfp_mask)
 	finish_wait(&pool->wait, &wait);
 	goto repeat_alloc;
 }
+
+/**
+ * mempool_alloc - allocate an element from a specific memory pool
+ * @pool:      pointer to the memory pool which was allocated via
+ *             mempool_create().
+ * @gfp_mask:  the usual allocation bitmask.
+ *
+ * this function only sleeps if the alloc_fn() function sleeps or
+ * returns NULL. Note that due to preallocation, this function
+ * *never* fails when called from process contexts. (it might
+ * fail if called from an IRQ context.)
+ * Note: using __GFP_ZERO is not supported.
+ *
+ * Return: pointer to the allocated element or %NULL on error.
+ */
+void *mempool_alloc(mempool_t *pool, gfp_t gfp_mask)
+{
+	return __mempool_alloc(pool, gfp_mask);
+}
 EXPORT_SYMBOL(mempool_alloc);
 
 /**
-- 
2.39.0

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel


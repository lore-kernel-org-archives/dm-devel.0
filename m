Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B21E5C6FD1D
	for <dm-devel@archiver.kernel.org>; Mon, 27 Mar 2023 20:14:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1679948051;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=86a2SALdDWd24N+uGx7da6g6m2QDS1d4RPFBCKqeWLQ=;
	b=SCl9XRt1BpPumTSJsWjW1eylvGd3LwH39AY5U7dJhaJpN44zFSXwNbQT0aGUWfbhF2RPbP
	wnU+NziDG5+8DjZVqCcQibFEu8KSg1pmF2BomLnFRqjcfQSwvUUh+VXpVCfgdddnctGenl
	wae29khC6mnhyEtHbUzF1qJKP7qQrg0=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-113-FdqPkG28OwyWAp_boeI-LQ-1; Mon, 27 Mar 2023 16:14:09 -0400
X-MC-Unique: FdqPkG28OwyWAp_boeI-LQ-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 7D9A4101A551;
	Mon, 27 Mar 2023 20:14:07 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 6B347C15BA0;
	Mon, 27 Mar 2023 20:14:07 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id D4E7219472D5;
	Mon, 27 Mar 2023 20:13:52 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
 [10.11.54.6])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 84CBE19465A2
 for <dm-devel@listman.corp.redhat.com>; Mon, 27 Mar 2023 20:13:39 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 6A8292166B2A; Mon, 27 Mar 2023 20:13:39 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast09.extmail.prod.ext.rdu2.redhat.com [10.11.55.25])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 62CF52166B26
 for <dm-devel@redhat.com>; Mon, 27 Mar 2023 20:13:39 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 433CC281294D
 for <dm-devel@redhat.com>; Mon, 27 Mar 2023 20:13:39 +0000 (UTC)
Received: from mail-qv1-f50.google.com (mail-qv1-f50.google.com
 [209.85.219.50]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-9-hHoJ6uetPrWl9oLnOgGL-w-4; Mon, 27 Mar 2023 16:13:35 -0400
X-MC-Unique: hHoJ6uetPrWl9oLnOgGL-w-4
Received: by mail-qv1-f50.google.com with SMTP id qh28so7640857qvb.7
 for <dm-devel@redhat.com>; Mon, 27 Mar 2023 13:13:35 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112; t=1679948015;
 h=content-transfer-encoding:mime-version:references:in-reply-to
 :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
 :subject:date:message-id:reply-to;
 bh=Xis1PZIHxgZc33JUTcnyVvy12Vhl77i8OslXpZXLdgA=;
 b=yvn2rkTo0Gv9hXhCbUuF0eBQzyjwW08LuTUiMWz87mZ3CgXolBt3ftB5RoHjkMDuSx
 JXWpjUrk3HeYEMJdIhiSoGsfb0BYBUt+I4kbVkipAIceLPe6GWTphUO9m4D5Qb0LRtlF
 KnY4Ae/4MwQy0U+/h9GNaYD0uYkFSKqDDySMSjISYTSBcvIjGFDouXBuCNLihMVV5YoS
 rckRqekJOuygc/NpgHq4PRcSRlIP7gDSazugtX4nkK9UVZdSneM+QYGw1KFpWglHCMn7
 iqwz4Fmmk5tpDhWoKCXitPpf507oO54k4bGog9WprE1su7Dc7fl+l0z4llSW+WjDCeiT
 OjzQ==
X-Gm-Message-State: AAQBX9dRvYqfzmf1ihI/2tn1RwGBK0H+8PipyOQjIQ7kzq9IwRq9W4TF
 kTp5TukqzvfWgekbTS+9weD+dDpy2ZY5lYZ1oWxFKCLL9q/fNXF2oD5J6TKeF3VQUfGJbwJGkHb
 67hvB33XMRzvE6vkbcmkro/QwHOaP+/329L6PvYqeQhsaaUSRwoFruqDBuLk7xta0z/ISVXUcg+
 8=
X-Google-Smtp-Source: AKy350bdI7fPLiZRLW4GPQlt6CDNO3b2uDbMBtu6JVcWz3roMzyEeTD8mnUG2okibZRJCTBwmlMNmw==
X-Received: by 2002:a05:6214:27c6:b0:56b:fb18:adcd with SMTP id
 ge6-20020a05621427c600b0056bfb18adcdmr19738100qvb.8.1679948015146; 
 Mon, 27 Mar 2023 13:13:35 -0700 (PDT)
Received: from localhost (pool-68-160-166-30.bstnma.fios.verizon.net.
 [68.160.166.30]) by smtp.gmail.com with ESMTPSA id
 cw2-20020ad44dc2000000b005dd8b9345aesm3214903qvb.70.2023.03.27.13.13.34
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Mon, 27 Mar 2023 13:13:34 -0700 (PDT)
From: Mike Snitzer <snitzer@kernel.org>
To: dm-devel@redhat.com
Date: Mon, 27 Mar 2023 16:11:40 -0400
Message-Id: <20230327201143.51026-18-snitzer@kernel.org>
In-Reply-To: <20230327201143.51026-1-snitzer@kernel.org>
References: <20230327201143.51026-1-snitzer@kernel.org>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.6
Subject: [dm-devel] [dm-6.4 PATCH v3 17/20] dm bufio: prepare to
 intelligently size dm_buffer_cache's buffer_trees
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
Cc: axboe@kernel.dk, ebiggers@kernel.org, keescook@chromium.org,
 heinzm@redhat.com, Mike Snitzer <snitzer@kernel.org>, nhuck@google.com,
 linux-block@vger.kernel.org, ejt@redhat.com, mpatocka@redhat.com,
 luomeng12@huawei.com
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: kernel.org
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Add num_locks member to dm_buffer_cache struct and use it rather than
the NR_LOCKS magic value (64).

Next commit will size the dm_buffer_cache's buffer_trees according to
dm_num_sharded_locks().

Signed-off-by: Mike Snitzer <snitzer@kernel.org>
---
 drivers/md/dm-bufio.c | 48 +++++++++++++++++++++++--------------------
 1 file changed, 26 insertions(+), 22 deletions(-)

diff --git a/drivers/md/dm-bufio.c b/drivers/md/dm-bufio.c
index ae552644a0b4..2250799a70e4 100644
--- a/drivers/md/dm-bufio.c
+++ b/drivers/md/dm-bufio.c
@@ -380,7 +380,6 @@ struct dm_buffer {
  */
 
 #define NR_LOCKS 64
-#define LOCKS_MASK (NR_LOCKS - 1)
 
 struct buffer_tree {
 	struct rw_semaphore lock;
@@ -388,37 +387,38 @@ struct buffer_tree {
 } ____cacheline_aligned_in_smp;
 
 struct dm_buffer_cache {
+	struct lru lru[LIST_SIZE];
 	/*
 	 * We spread entries across multiple trees to reduce contention
 	 * on the locks.
 	 */
+	unsigned int num_locks;
 	struct buffer_tree trees[NR_LOCKS];
-	struct lru lru[LIST_SIZE];
 };
 
-static inline unsigned int cache_index(sector_t block)
+static inline unsigned int cache_index(sector_t block, unsigned int num_locks)
 {
-	return block & LOCKS_MASK;
+	return block & (num_locks - 1);
 }
 
 static inline void cache_read_lock(struct dm_buffer_cache *bc, sector_t block)
 {
-	down_read(&bc->trees[cache_index(block)].lock);
+	down_read(&bc->trees[cache_index(block, bc->num_locks)].lock);
 }
 
 static inline void cache_read_unlock(struct dm_buffer_cache *bc, sector_t block)
 {
-	up_read(&bc->trees[cache_index(block)].lock);
+	up_read(&bc->trees[cache_index(block, bc->num_locks)].lock);
 }
 
 static inline void cache_write_lock(struct dm_buffer_cache *bc, sector_t block)
 {
-	down_write(&bc->trees[cache_index(block)].lock);
+	down_write(&bc->trees[cache_index(block, bc->num_locks)].lock);
 }
 
 static inline void cache_write_unlock(struct dm_buffer_cache *bc, sector_t block)
 {
-	up_write(&bc->trees[cache_index(block)].lock);
+	up_write(&bc->trees[cache_index(block, bc->num_locks)].lock);
 }
 
 /*
@@ -429,13 +429,15 @@ struct lock_history {
 	struct dm_buffer_cache *cache;
 	bool write;
 	unsigned int previous;
+	unsigned int no_previous;
 };
 
 static void lh_init(struct lock_history *lh, struct dm_buffer_cache *cache, bool write)
 {
 	lh->cache = cache;
 	lh->write = write;
-	lh->previous = NR_LOCKS;  /* indicates no previous */
+	lh->no_previous = cache->num_locks;
+	lh->previous = lh->no_previous;
 }
 
 static void __lh_lock(struct lock_history *lh, unsigned int index)
@@ -459,9 +461,9 @@ static void __lh_unlock(struct lock_history *lh, unsigned int index)
  */
 static void lh_exit(struct lock_history *lh)
 {
-	if (lh->previous != NR_LOCKS) {
+	if (lh->previous != lh->no_previous) {
 		__lh_unlock(lh, lh->previous);
-		lh->previous = NR_LOCKS;
+		lh->previous = lh->no_previous;
 	}
 }
 
@@ -471,9 +473,9 @@ static void lh_exit(struct lock_history *lh)
  */
 static void lh_next(struct lock_history *lh, sector_t b)
 {
-	unsigned int index = cache_index(b);
+	unsigned int index = cache_index(b, lh->no_previous); /* no_previous is num_locks */
 
-	if (lh->previous != NR_LOCKS) {
+	if (lh->previous != lh->no_previous) {
 		if (lh->previous != index) {
 			__lh_unlock(lh, lh->previous);
 			__lh_lock(lh, index);
@@ -500,11 +502,13 @@ static struct dm_buffer *list_to_buffer(struct list_head *l)
 	return le_to_buffer(le);
 }
 
-static void cache_init(struct dm_buffer_cache *bc)
+static void cache_init(struct dm_buffer_cache *bc, unsigned int num_locks)
 {
 	unsigned int i;
 
-	for (i = 0; i < NR_LOCKS; i++) {
+	bc->num_locks = num_locks;
+
+	for (i = 0; i < bc->num_locks; i++) {
 		init_rwsem(&bc->trees[i].lock);
 		bc->trees[i].root = RB_ROOT;
 	}
@@ -517,7 +521,7 @@ static void cache_destroy(struct dm_buffer_cache *bc)
 {
 	unsigned int i;
 
-	for (i = 0; i < NR_LOCKS; i++)
+	for (i = 0; i < bc->num_locks; i++)
 		WARN_ON_ONCE(!RB_EMPTY_ROOT(&bc->trees[i].root));
 
 	lru_destroy(&bc->lru[LIST_CLEAN]);
@@ -576,7 +580,7 @@ static struct dm_buffer *cache_get(struct dm_buffer_cache *bc, sector_t block)
 	struct dm_buffer *b;
 
 	cache_read_lock(bc, block);
-	b = __cache_get(&bc->trees[cache_index(block)].root, block);
+	b = __cache_get(&bc->trees[cache_index(block, bc->num_locks)].root, block);
 	if (b) {
 		lru_reference(&b->lru);
 		__cache_inc_buffer(b);
@@ -650,7 +654,7 @@ static struct dm_buffer *__cache_evict(struct dm_buffer_cache *bc, int list_mode
 
 	b = le_to_buffer(le);
 	/* __evict_pred will have locked the appropriate tree. */
-	rb_erase(&b->node, &bc->trees[cache_index(b->block)].root);
+	rb_erase(&b->node, &bc->trees[cache_index(b->block, bc->num_locks)].root);
 
 	return b;
 }
@@ -816,7 +820,7 @@ static bool cache_insert(struct dm_buffer_cache *bc, struct dm_buffer *b)
 
 	cache_write_lock(bc, b->block);
 	BUG_ON(atomic_read(&b->hold_count) != 1);
-	r = __cache_insert(&bc->trees[cache_index(b->block)].root, b);
+	r = __cache_insert(&bc->trees[cache_index(b->block, bc->num_locks)].root, b);
 	if (r)
 		lru_insert(&bc->lru[b->list_mode], &b->lru);
 	cache_write_unlock(bc, b->block);
@@ -842,7 +846,7 @@ static bool cache_remove(struct dm_buffer_cache *bc, struct dm_buffer *b)
 		r = false;
 	} else {
 		r = true;
-		rb_erase(&b->node, &bc->trees[cache_index(b->block)].root);
+		rb_erase(&b->node, &bc->trees[cache_index(b->block, bc->num_locks)].root);
 		lru_remove(&bc->lru[b->list_mode], &b->lru);
 	}
 
@@ -911,7 +915,7 @@ static void cache_remove_range(struct dm_buffer_cache *bc,
 {
 	unsigned int i;
 
-	for (i = 0; i < NR_LOCKS; i++) {
+	for (i = 0; i < bc->num_locks; i++) {
 		down_write(&bc->trees[i].lock);
 		__remove_range(bc, &bc->trees[i].root, begin, end, pred, release);
 		up_write(&bc->trees[i].lock);
@@ -2432,7 +2436,7 @@ struct dm_bufio_client *dm_bufio_client_create(struct block_device *bdev, unsign
 		r = -ENOMEM;
 		goto bad_client;
 	}
-	cache_init(&c->cache);
+	cache_init(&c->cache, NR_LOCKS);
 
 	c->bdev = bdev;
 	c->block_size = block_size;
-- 
2.40.0

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel


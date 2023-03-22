Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C770FC6FD1C
	for <dm-devel@archiver.kernel.org>; Wed, 22 Mar 2023 18:20:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1679509203;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=NJL8EajJDtcOLzxnG3mWS9BJwA2ThNRIK12ZV/Cx1Co=;
	b=ZdeoJsY5IJrjjXfV94vSxovZE8CYenjSW1ykURqOxds+/OtUaCamqW4RUBASQJ5Z9FU7A2
	CPAHhZm4jY0EMgYGUqvbBLqMJsDY1mL3w0aUngnA7aiIp63ZgNiWfDGPe4QTzQnLTyE/FE
	6k7uU4Q/iCesKgtX9K9ozTo8UdzRlHw=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-623-yLGfa9ieNiGM7xwiUM5t-g-1; Wed, 22 Mar 2023 14:20:00 -0400
X-MC-Unique: yLGfa9ieNiGM7xwiUM5t-g-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 24A36801206;
	Wed, 22 Mar 2023 18:19:57 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 10E6D492C13;
	Wed, 22 Mar 2023 18:19:57 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 501FC1946A47;
	Wed, 22 Mar 2023 18:19:36 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com
 [10.11.54.2])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id B79701946A6A
 for <dm-devel@listman.corp.redhat.com>; Wed, 22 Mar 2023 18:19:34 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 9D3C540C6E68; Wed, 22 Mar 2023 18:19:34 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast08.extmail.prod.ext.rdu2.redhat.com [10.11.55.24])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 958D240C6E67
 for <dm-devel@redhat.com>; Wed, 22 Mar 2023 18:19:34 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 7A63A38123D2
 for <dm-devel@redhat.com>; Wed, 22 Mar 2023 18:19:34 +0000 (UTC)
Received: from mail-qt1-f171.google.com (mail-qt1-f171.google.com
 [209.85.160.171]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-131-yA8hkPxLNhqq_n7eMpY17A-4; Wed, 22 Mar 2023 14:19:33 -0400
X-MC-Unique: yA8hkPxLNhqq_n7eMpY17A-4
Received: by mail-qt1-f171.google.com with SMTP id c10so12598896qtj.10
 for <dm-devel@redhat.com>; Wed, 22 Mar 2023 11:19:32 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112; t=1679509172;
 h=content-transfer-encoding:mime-version:references:in-reply-to
 :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
 :subject:date:message-id:reply-to;
 bh=atD89yr5/OSdVgb0JbDcT1cuwNr6C42XiKnbfRVm5g8=;
 b=krR+Ool4jCbHKR5cAgm54RNwuEidoBlhk/dEKDNMVe0fgYZpbweMsfI9zxSsUy+09E
 EsZSITuEXVkw+MValuQYHxSmUaEVVbKYiKlDMYsmhD1AZ/tZxjuoAz8TKFFV4bP9guvz
 2V0c7+iZc6n+2KRbAroz1ggdHkPJEGEHfPYjmFWAJpY5fsC2bzfVyPZ/s1CojpdWRuQP
 6DCZ9Bk6QKyEtq+CoeUyA5+rEzUfmghp3u2s+ZKOITbe+FOrFN8W4IEYSO+YwefujsYs
 3MhV88b8uAEXYfkmxPYwcKIqtlMJa4DLEsmf3ZL5F3FYhN3YHtEyB/CqYfLJ/iLgLAs+
 XKvQ==
X-Gm-Message-State: AO0yUKVEO+L6OvJlkRwEo4DskXCpHA4xIDND8XOtCmzsB/osOXFNBZF2
 AFzDfJGnk8kHA6gGEM2J7+DH1+M2SJnH4KrcLU5LRK9+Hv8Dc1IKcqSbdj7xtJqcYOCX5yToyme
 cq1OAwQhH7bnsOdQ5wDLILACTbdTSl4FSOl5F6JZQTV3CvTlhYjxfJWuM6if+PaWjO4rDVG2Z57
 s=
X-Google-Smtp-Source: AK7set9v7Lk6e/dy2TUa1U68x0X1ogOn82gP26n8T4ljrBbMOJ15B3AYMGgy04AubZSY2I/8eRfu0g==
X-Received: by 2002:ac8:580d:0:b0:3b9:bc8c:c216 with SMTP id
 g13-20020ac8580d000000b003b9bc8cc216mr5356869qtg.33.1679509172133; 
 Wed, 22 Mar 2023 11:19:32 -0700 (PDT)
Received: from localhost (pool-68-160-166-30.bstnma.fios.verizon.net.
 [68.160.166.30]) by smtp.gmail.com with ESMTPSA id
 v6-20020ac87486000000b003bffe7fdc38sm6661799qtq.9.2023.03.22.11.19.31
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Wed, 22 Mar 2023 11:19:31 -0700 (PDT)
From: Mike Snitzer <snitzer@kernel.org>
To: dm-devel@redhat.com
Date: Wed, 22 Mar 2023 14:18:44 -0400
Message-Id: <20230322181845.29848-8-snitzer@kernel.org>
In-Reply-To: <20230322181845.29848-1-snitzer@kernel.org>
References: <20230322181845.29848-1-snitzer@kernel.org>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
Subject: [dm-devel] [dm-6.4 PATCH 7/8] dm bufio: rename buffer_cache struct
 to dm_buffer_cache
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
Cc: keescook@chromium.org, heinzm@redhat.com, Mike Snitzer <snitzer@kernel.org>,
 nhuck@google.com, ebiggers@kernel.org, ejt@redhat.com, mpatocka@redhat.com,
 luomeng12@huawei.com
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.9
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Signed-off-by: Mike Snitzer <snitzer@kernel.org>
---
 drivers/md/dm-bufio.c | 52 +++++++++++++++++++++----------------------
 1 file changed, 26 insertions(+), 26 deletions(-)

diff --git a/drivers/md/dm-bufio.c b/drivers/md/dm-bufio.c
index b418ee8e3853..e7b901baa878 100644
--- a/drivers/md/dm-bufio.c
+++ b/drivers/md/dm-bufio.c
@@ -327,7 +327,7 @@ enum data_mode {
 };
 
 struct dm_buffer {
-	/* protected by the locks in buffer_cache */
+	/* protected by the locks in dm_buffer_cache */
 	struct rb_node node;
 
 	/* immutable, so don't need protecting */
@@ -393,7 +393,7 @@ struct tree_lock {
 	struct rw_semaphore lock;
 } ____cacheline_aligned_in_smp;
 
-struct buffer_cache {
+struct dm_buffer_cache {
 	/*
 	 * We spread entries across multiple trees to reduce contention
 	 * on the locks.
@@ -414,22 +414,22 @@ static inline unsigned int cache_index(sector_t block)
 	return block & LOCKS_MASK;
 }
 
-static inline void cache_read_lock(struct buffer_cache *bc, sector_t block)
+static inline void cache_read_lock(struct dm_buffer_cache *bc, sector_t block)
 {
 	down_read(&bc->locks[cache_index(block)].lock);
 }
 
-static inline void cache_read_unlock(struct buffer_cache *bc, sector_t block)
+static inline void cache_read_unlock(struct dm_buffer_cache *bc, sector_t block)
 {
 	up_read(&bc->locks[cache_index(block)].lock);
 }
 
-static inline void cache_write_lock(struct buffer_cache *bc, sector_t block)
+static inline void cache_write_lock(struct dm_buffer_cache *bc, sector_t block)
 {
 	down_write(&bc->locks[cache_index(block)].lock);
 }
 
-static inline void cache_write_unlock(struct buffer_cache *bc, sector_t block)
+static inline void cache_write_unlock(struct dm_buffer_cache *bc, sector_t block)
 {
 	up_write(&bc->locks[cache_index(block)].lock);
 }
@@ -439,12 +439,12 @@ static inline void cache_write_unlock(struct buffer_cache *bc, sector_t block)
  * This struct helps avoid redundant drop and gets of the same lock.
  */
 struct lock_history {
-	struct buffer_cache *cache;
+	struct dm_buffer_cache *cache;
 	bool write;
 	unsigned int previous;
 };
 
-static void lh_init(struct lock_history *lh, struct buffer_cache *cache, bool write)
+static void lh_init(struct lock_history *lh, struct dm_buffer_cache *cache, bool write)
 {
 	lh->cache = cache;
 	lh->write = write;
@@ -513,7 +513,7 @@ static struct dm_buffer *list_to_buffer(struct list_head *l)
 	return le_to_buffer(le);
 }
 
-static void cache_init(struct buffer_cache *bc)
+static void cache_init(struct dm_buffer_cache *bc)
 {
 	unsigned int i;
 
@@ -526,7 +526,7 @@ static void cache_init(struct buffer_cache *bc)
 	lru_init(&bc->lru[LIST_DIRTY]);
 }
 
-static void cache_destroy(struct buffer_cache *bc)
+static void cache_destroy(struct dm_buffer_cache *bc)
 {
 	unsigned int i;
 
@@ -540,7 +540,7 @@ static void cache_destroy(struct buffer_cache *bc)
 /*
  * not threadsafe, or racey depending how you look at it
  */
-static unsigned long cache_count(struct buffer_cache *bc, int list_mode)
+static unsigned long cache_count(struct dm_buffer_cache *bc, int list_mode)
 {
 	return lru_count(&bc->lru[list_mode]);
 }
@@ -550,7 +550,7 @@ static unsigned long cache_count(struct buffer_cache *bc, int list_mode)
 /*
  * not threadsafe
  */
-static unsigned long cache_total(struct buffer_cache *bc)
+static unsigned long cache_total(struct dm_buffer_cache *bc)
 {
 	return lru_count(&bc->lru[LIST_CLEAN]) +
 		lru_count(&bc->lru[LIST_DIRTY]);
@@ -588,7 +588,7 @@ static void __cache_inc_buffer(struct dm_buffer *b)
 	WRITE_ONCE(b->last_accessed, jiffies);
 }
 
-static struct dm_buffer *cache_get(struct buffer_cache *bc, sector_t block)
+static struct dm_buffer *cache_get(struct dm_buffer_cache *bc, sector_t block)
 {
 	struct dm_buffer *b;
 
@@ -609,7 +609,7 @@ static struct dm_buffer *cache_get(struct buffer_cache *bc, sector_t block)
  * Returns true if the hold count hits zero.
  * threadsafe
  */
-static bool cache_put(struct buffer_cache *bc, struct dm_buffer *b)
+static bool cache_put(struct dm_buffer_cache *bc, struct dm_buffer *b)
 {
 	bool r;
 
@@ -653,7 +653,7 @@ static enum evict_result __evict_pred(struct lru_entry *le, void *context)
 	return w->pred(b, w->context);
 }
 
-static struct dm_buffer *__cache_evict(struct buffer_cache *bc, int list_mode,
+static struct dm_buffer *__cache_evict(struct dm_buffer_cache *bc, int list_mode,
 				       b_predicate pred, void *context,
 				       struct lock_history *lh)
 {
@@ -672,7 +672,7 @@ static struct dm_buffer *__cache_evict(struct buffer_cache *bc, int list_mode,
 	return b;
 }
 
-static struct dm_buffer *cache_evict(struct buffer_cache *bc, int list_mode,
+static struct dm_buffer *cache_evict(struct dm_buffer_cache *bc, int list_mode,
 				     b_predicate pred, void *context)
 {
 	struct dm_buffer *b;
@@ -690,7 +690,7 @@ static struct dm_buffer *cache_evict(struct buffer_cache *bc, int list_mode,
 /*
  * Mark a buffer as clean or dirty. Not threadsafe.
  */
-static void cache_mark(struct buffer_cache *bc, struct dm_buffer *b, int list_mode)
+static void cache_mark(struct dm_buffer_cache *bc, struct dm_buffer *b, int list_mode)
 {
 	cache_write_lock(bc, b->block);
 	if (list_mode != b->list_mode) {
@@ -707,7 +707,7 @@ static void cache_mark(struct buffer_cache *bc, struct dm_buffer *b, int list_mo
  * Runs through the lru associated with 'old_mode', if the predicate matches then
  * it moves them to 'new_mode'.  Not threadsafe.
  */
-static void __cache_mark_many(struct buffer_cache *bc, int old_mode, int new_mode,
+static void __cache_mark_many(struct dm_buffer_cache *bc, int old_mode, int new_mode,
 			      b_predicate pred, void *context, struct lock_history *lh)
 {
 	struct lru_entry *le;
@@ -725,7 +725,7 @@ static void __cache_mark_many(struct buffer_cache *bc, int old_mode, int new_mod
 	}
 }
 
-static void cache_mark_many(struct buffer_cache *bc, int old_mode, int new_mode,
+static void cache_mark_many(struct dm_buffer_cache *bc, int old_mode, int new_mode,
 			    b_predicate pred, void *context)
 {
 	struct lock_history lh;
@@ -753,7 +753,7 @@ enum it_action {
 
 typedef enum it_action (*iter_fn)(struct dm_buffer *b, void *context);
 
-static void __cache_iterate(struct buffer_cache *bc, int list_mode,
+static void __cache_iterate(struct dm_buffer_cache *bc, int list_mode,
 			    iter_fn fn, void *context, struct lock_history *lh)
 {
 	struct lru *lru = &bc->lru[list_mode];
@@ -781,7 +781,7 @@ static void __cache_iterate(struct buffer_cache *bc, int list_mode,
 	} while (le != first);
 }
 
-static void cache_iterate(struct buffer_cache *bc, int list_mode,
+static void cache_iterate(struct dm_buffer_cache *bc, int list_mode,
 			  iter_fn fn, void *context)
 {
 	struct lock_history lh;
@@ -824,7 +824,7 @@ static bool __cache_insert(struct rb_root *root, struct dm_buffer *b)
 	return true;
 }
 
-static bool cache_insert(struct buffer_cache *bc, struct dm_buffer *b)
+static bool cache_insert(struct dm_buffer_cache *bc, struct dm_buffer *b)
 {
 	bool r;
 
@@ -848,7 +848,7 @@ static bool cache_insert(struct buffer_cache *bc, struct dm_buffer *b)
  *
  * Not threadsafe.
  */
-static bool cache_remove(struct buffer_cache *bc, struct dm_buffer *b)
+static bool cache_remove(struct dm_buffer_cache *bc, struct dm_buffer *b)
 {
 	bool r;
 
@@ -894,7 +894,7 @@ static struct dm_buffer *__find_next(struct rb_root *root, sector_t block)
 	return best;
 }
 
-static void __remove_range(struct buffer_cache *bc,
+static void __remove_range(struct dm_buffer_cache *bc,
 			   struct rb_root *root,
 			   sector_t begin, sector_t end,
 			   b_predicate pred, b_release release)
@@ -921,7 +921,7 @@ static void __remove_range(struct buffer_cache *bc,
 	}
 }
 
-static void cache_remove_range(struct buffer_cache *bc,
+static void cache_remove_range(struct dm_buffer_cache *bc,
 			       sector_t begin, sector_t end,
 			       b_predicate pred, b_release release)
 {
@@ -988,7 +988,7 @@ struct dm_bufio_client {
 	 */
 	unsigned long oldest_buffer;
 
-	struct buffer_cache cache;
+	struct dm_buffer_cache cache;
 };
 
 static DEFINE_STATIC_KEY_FALSE(no_sleep_enabled);
-- 
2.40.0

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel


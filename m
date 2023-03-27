Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E9671C6FD1D
	for <dm-devel@archiver.kernel.org>; Mon, 27 Mar 2023 20:13:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1679948023;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=BQPdaaQhBtSmvqtgiOfR6OvIQrmPD03uBolZsD26X1c=;
	b=b/5vXgUOiF18KAfmPbkX7uBOmfKiSKUJrTEaF8yZfUIbrwXY6zLDTQuVcNbQWxcNRygZUo
	rUJKiUIaTeRrsnKq6MH0Le8IIw3G7Pk0DmI3YPf6UpMuDkexkVfnl5VgdWUx60idjPqLH3
	99poBoc9ydHv/6ZkmjUE3vw8au/mvLI=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-368-ENX4aV8aOAGaxghHfhmRNQ-1; Mon, 27 Mar 2023 16:13:39 -0400
X-MC-Unique: ENX4aV8aOAGaxghHfhmRNQ-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 3878F8828CF;
	Mon, 27 Mar 2023 20:13:37 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 250CB44037;
	Mon, 27 Mar 2023 20:13:37 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 3AEAD1946A78;
	Mon, 27 Mar 2023 20:13:24 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
 [10.11.54.4])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 6CE2B1946A78
 for <dm-devel@listman.corp.redhat.com>; Mon, 27 Mar 2023 20:13:23 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 5FB69202701F; Mon, 27 Mar 2023 20:13:23 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast07.extmail.prod.ext.rdu2.redhat.com [10.11.55.23])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 58066202701E
 for <dm-devel@redhat.com>; Mon, 27 Mar 2023 20:13:23 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 383B33C0E451
 for <dm-devel@redhat.com>; Mon, 27 Mar 2023 20:13:23 +0000 (UTC)
Received: from mail-qt1-f174.google.com (mail-qt1-f174.google.com
 [209.85.160.174]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-517-pTsjNDYdMFSwTp89o2jsTg-2; Mon, 27 Mar 2023 16:13:20 -0400
X-MC-Unique: pTsjNDYdMFSwTp89o2jsTg-2
Received: by mail-qt1-f174.google.com with SMTP id cj15so2316212qtb.5
 for <dm-devel@redhat.com>; Mon, 27 Mar 2023 13:13:20 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112; t=1679948000;
 h=content-transfer-encoding:mime-version:references:in-reply-to
 :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
 :subject:date:message-id:reply-to;
 bh=dgaYGvMwSGrKRZ2WwE4xFce2cAfLE729BA8da+BNlMU=;
 b=2TnP6p1tIbm7HUU+8oGbdphwoUVcfiFCZvNBxLZFTCqwzs6mA9WoVUxvTmYRxqMPF1
 32oGEjuojqkYRc5yv/j4ZBzuC/j6i7GxuarH71iaffYkW8iFgo+SnUwa2/zvhHIom29W
 NoNJHjc3hvDPTU5iqUaOz5fkKSRPBuryfvwUgRAQpgKzy4+TKfbKtwIo+SzrmGLrTZSW
 vR0EKN6LMTFpyg1YkdcQNx1Ic6f400jOzKOmT6ZbOj077uc6rVXpyqBxqkffe6VyNIvB
 TdKBvZNEU6TFlaDnHqg3DGWceVk8le4vQjl+aSQrb9XaBZWw2lVgvGlEOWgUSUoqZUYn
 K2xw==
X-Gm-Message-State: AO0yUKXSSWVAGsTxEvjCIJ1CCs/9kMzhe+Isou0wEoVg6YusAZN+l7si
 tjIWIajktz5u/W2ubbUnJdTlhSkNxiaggNi40zQ1SQJhzNfLFLfHiRoHGMXFYDV+0tdp9GE3IMv
 7Za+5HlgYcPT+gVfxjIKID8daCYMYsxzGLa0uB3cSScMrOlV167JH1YNpNbvIX3M0wncT3W+Jzs
 Y=
X-Google-Smtp-Source: AK7set9AVHWFXkb3npjJh0xtSby8NWtVc9+BAEPPLkZMxF17dzC/dc7TdH75nxfrpPvYHfLhi0sMtQ==
X-Received: by 2002:a05:622a:198b:b0:3e2:6a40:5631 with SMTP id
 u11-20020a05622a198b00b003e26a405631mr22093845qtc.10.1679948000120; 
 Mon, 27 Mar 2023 13:13:20 -0700 (PDT)
Received: from localhost (pool-68-160-166-30.bstnma.fios.verizon.net.
 [68.160.166.30]) by smtp.gmail.com with ESMTPSA id
 t23-20020ac865d7000000b003b635a5d56csm15119212qto.30.2023.03.27.13.13.19
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Mon, 27 Mar 2023 13:13:19 -0700 (PDT)
From: Mike Snitzer <snitzer@kernel.org>
To: dm-devel@redhat.com
Date: Mon, 27 Mar 2023 16:11:31 -0400
Message-Id: <20230327201143.51026-9-snitzer@kernel.org>
In-Reply-To: <20230327201143.51026-1-snitzer@kernel.org>
References: <20230327201143.51026-1-snitzer@kernel.org>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.4
Subject: [dm-devel] [dm-6.4 PATCH v3 08/20] dm bufio: add lock_history
 optimization for cache iterators
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
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: kernel.org
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

From: Joe Thornber <ejt@redhat.com>

Sometimes it is beneficial to repeatedly get and drop locks as part of
an iteration.  Introduce lock_history struct to help avoid redundant
drop and gets of the same lock.

Optimizes cache_iterate, cache_mark_many and cache_evict.

Signed-off-by: Joe Thornber <ejt@redhat.com>
Signed-off-by: Mike Snitzer <snitzer@kernel.org>
---
 drivers/md/dm-bufio.c | 119 +++++++++++++++++++++++++++++++++++++++---
 1 file changed, 111 insertions(+), 8 deletions(-)

diff --git a/drivers/md/dm-bufio.c b/drivers/md/dm-bufio.c
index 1e000ec73bd6..9ac50024006d 100644
--- a/drivers/md/dm-bufio.c
+++ b/drivers/md/dm-bufio.c
@@ -421,6 +421,70 @@ static inline void cache_write_unlock(struct dm_buffer_cache *bc, sector_t block
 	up_write(&bc->trees[cache_index(block)].lock);
 }
 
+/*
+ * Sometimes we want to repeatedly get and drop locks as part of an iteration.
+ * This struct helps avoid redundant drop and gets of the same lock.
+ */
+struct lock_history {
+	struct dm_buffer_cache *cache;
+	bool write;
+	unsigned int previous;
+};
+
+static void lh_init(struct lock_history *lh, struct dm_buffer_cache *cache, bool write)
+{
+	lh->cache = cache;
+	lh->write = write;
+	lh->previous = NR_LOCKS;  /* indicates no previous */
+}
+
+static void __lh_lock(struct lock_history *lh, unsigned int index)
+{
+	if (lh->write)
+		down_write(&lh->cache->trees[index].lock);
+	else
+		down_read(&lh->cache->trees[index].lock);
+}
+
+static void __lh_unlock(struct lock_history *lh, unsigned int index)
+{
+	if (lh->write)
+		up_write(&lh->cache->trees[index].lock);
+	else
+		up_read(&lh->cache->trees[index].lock);
+}
+
+/*
+ * Make sure you call this since it will unlock the final lock.
+ */
+static void lh_exit(struct lock_history *lh)
+{
+	if (lh->previous != NR_LOCKS) {
+		__lh_unlock(lh, lh->previous);
+		lh->previous = NR_LOCKS;
+	}
+}
+
+/*
+ * Named 'next' because there is no corresponding
+ * 'up/unlock' call since it's done automatically.
+ */
+static void lh_next(struct lock_history *lh, sector_t b)
+{
+	unsigned int index = cache_index(b);
+
+	if (lh->previous != NR_LOCKS) {
+		if (lh->previous != index) {
+			__lh_unlock(lh, lh->previous);
+			__lh_lock(lh, index);
+			lh->previous = index;
+		}
+	} else {
+		__lh_lock(lh, index);
+		lh->previous = index;
+	}
+}
+
 static inline struct dm_buffer *le_to_buffer(struct lru_entry *le)
 {
 	return container_of(le, struct dm_buffer, lru);
@@ -550,6 +614,7 @@ typedef enum evict_result (*b_predicate)(struct dm_buffer *, void *);
  * predicate the hold_count of the selected buffer will be zero.
  */
 struct evict_wrapper {
+	struct lock_history *lh;
 	b_predicate pred;
 	void *context;
 };
@@ -563,16 +628,19 @@ static enum evict_result __evict_pred(struct lru_entry *le, void *context)
 	struct evict_wrapper *w = context;
 	struct dm_buffer *b = le_to_buffer(le);
 
+	lh_next(w->lh, b->block);
+
 	if (atomic_read(&b->hold_count))
 		return ER_DONT_EVICT;
 
 	return w->pred(b, w->context);
 }
 
-static struct dm_buffer *cache_evict(struct dm_buffer_cache *bc, int list_mode,
-				     b_predicate pred, void *context)
+static struct dm_buffer *__cache_evict(struct dm_buffer_cache *bc, int list_mode,
+				       b_predicate pred, void *context,
+				       struct lock_history *lh)
 {
-	struct evict_wrapper w = {.pred = pred, .context = context};
+	struct evict_wrapper w = {.lh = lh, .pred = pred, .context = context};
 	struct lru_entry *le;
 	struct dm_buffer *b;
 
@@ -587,6 +655,19 @@ static struct dm_buffer *cache_evict(struct dm_buffer_cache *bc, int list_mode,
 	return b;
 }
 
+static struct dm_buffer *cache_evict(struct dm_buffer_cache *bc, int list_mode,
+				     b_predicate pred, void *context)
+{
+	struct dm_buffer *b;
+	struct lock_history lh;
+
+	lh_init(&lh, bc, true);
+	b = __cache_evict(bc, list_mode, pred, context, &lh);
+	lh_exit(&lh);
+
+	return b;
+}
+
 /*--------------*/
 
 /*
@@ -609,12 +690,12 @@ static void cache_mark(struct dm_buffer_cache *bc, struct dm_buffer *b, int list
  * Runs through the lru associated with 'old_mode', if the predicate matches then
  * it moves them to 'new_mode'.  Not threadsafe.
  */
-static void cache_mark_many(struct dm_buffer_cache *bc, int old_mode, int new_mode,
-			    b_predicate pred, void *context)
+static void __cache_mark_many(struct dm_buffer_cache *bc, int old_mode, int new_mode,
+			      b_predicate pred, void *context, struct lock_history *lh)
 {
 	struct lru_entry *le;
 	struct dm_buffer *b;
-	struct evict_wrapper w = {.pred = pred, .context = context};
+	struct evict_wrapper w = {.lh = lh, .pred = pred, .context = context};
 
 	while (true) {
 		le = lru_evict(&bc->lru[old_mode], __evict_pred, &w);
@@ -627,6 +708,16 @@ static void cache_mark_many(struct dm_buffer_cache *bc, int old_mode, int new_mo
 	}
 }
 
+static void cache_mark_many(struct dm_buffer_cache *bc, int old_mode, int new_mode,
+			    b_predicate pred, void *context)
+{
+	struct lock_history lh;
+
+	lh_init(&lh, bc, true);
+	__cache_mark_many(bc, old_mode, new_mode, pred, context, &lh);
+	lh_exit(&lh);
+}
+
 /*--------------*/
 
 /*
@@ -645,8 +736,8 @@ enum it_action {
 
 typedef enum it_action (*iter_fn)(struct dm_buffer *b, void *context);
 
-static void cache_iterate(struct dm_buffer_cache *bc, int list_mode,
-			  iter_fn fn, void *context)
+static void __cache_iterate(struct dm_buffer_cache *bc, int list_mode,
+			    iter_fn fn, void *context, struct lock_history *lh)
 {
 	struct lru *lru = &bc->lru[list_mode];
 	struct lru_entry *le, *first;
@@ -658,6 +749,8 @@ static void cache_iterate(struct dm_buffer_cache *bc, int list_mode,
 	do {
 		struct dm_buffer *b = le_to_buffer(le);
 
+		lh_next(lh, b->block);
+
 		switch (fn(b, context)) {
 		case IT_NEXT:
 			break;
@@ -671,6 +764,16 @@ static void cache_iterate(struct dm_buffer_cache *bc, int list_mode,
 	} while (le != first);
 }
 
+static void cache_iterate(struct dm_buffer_cache *bc, int list_mode,
+			  iter_fn fn, void *context)
+{
+	struct lock_history lh;
+
+	lh_init(&lh, bc, false);
+	__cache_iterate(bc, list_mode, fn, context, &lh);
+	lh_exit(&lh);
+}
+
 /*--------------*/
 
 /*
-- 
2.40.0

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel


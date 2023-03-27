Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AE90BC761A6
	for <dm-devel@archiver.kernel.org>; Mon, 27 Mar 2023 20:13:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1679948026;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=Pe3huYU8CBCw8mEjSdVedVB4BOjOZQ9cV7IVW+4Ok4g=;
	b=D6ltb97orbLcJ0tNYVUkDPMiccUfhIQiNUlkpA7ky8yTqlg1XgJFznM9oWIMN0npCWfSyj
	mk0wzOaKJdxz1LvzK29+cxN0ehcRZccdMA5o6IOf3n/Wpo7CK3sO66BIPTO9PyYBHPUHIf
	iqBJWnTjbX2xG/SBtTy4IcIbAEwzDOA=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-341-qI82hxGXO7KefZcX1XlRdA-1; Mon, 27 Mar 2023 16:13:43 -0400
X-MC-Unique: qI82hxGXO7KefZcX1XlRdA-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id A763D2812956;
	Mon, 27 Mar 2023 20:13:41 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 955E82027040;
	Mon, 27 Mar 2023 20:13:41 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id E5B0D19472D3;
	Mon, 27 Mar 2023 20:13:22 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com
 [10.11.54.8])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id AD2AE19472C9
 for <dm-devel@listman.corp.redhat.com>; Mon, 27 Mar 2023 20:13:22 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 903B7C15BB8; Mon, 27 Mar 2023 20:13:17 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 884CCC15BA0
 for <dm-devel@redhat.com>; Mon, 27 Mar 2023 20:13:17 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 6BC12185A7A9
 for <dm-devel@redhat.com>; Mon, 27 Mar 2023 20:13:17 +0000 (UTC)
Received: from mail-qv1-f47.google.com (mail-qv1-f47.google.com
 [209.85.219.47]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-539-kCyN3A3zP3CFhZqeTDlNLw-1; Mon, 27 Mar 2023 16:13:15 -0400
X-MC-Unique: kCyN3A3zP3CFhZqeTDlNLw-1
Received: by mail-qv1-f47.google.com with SMTP id l7so7669137qvh.5
 for <dm-devel@redhat.com>; Mon, 27 Mar 2023 13:13:15 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112; t=1679947994;
 h=content-transfer-encoding:mime-version:references:in-reply-to
 :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
 :subject:date:message-id:reply-to;
 bh=HnRXjPFL8ryVwQIZKj/idU8AtLLYydcfQZ5/bZxBP7E=;
 b=m/U0m251NvjAqlellM3VGlA57gwQM+iKimgCQlRiQaYpBpkF1fbtbpMYBhVBp+jtZO
 odyZ3+OhC1aX9PzV6eV4eV3OJCaleKymAqSitpGTyxxGvtHl4kCKzQBDs0WSlvgHOKgd
 D+MGFC+5rnF9hABqJOXvOZ+Vy2ZPqmJoV/ARj5w3/qqBqLd3hX7P4EY+14/RBfOhi3JB
 P76XxrUFOVVTysPzI1VA/4WxcCCoXbUDRkcDt9IkFc0rhC51p7f11ER8jCxJG9Yx1jgX
 jpEnOIBIGooXiZoqxo88ptiGeNGhHCVK18AZlHm9LMsZU9I/bl/BvsxKtyoJA7xq2K70
 Vj1g==
X-Gm-Message-State: AAQBX9c7ZyTySYI08vyHn2KDC0wpe6JnMvIbNa8+aBnu70LaBrUA5tkX
 IStPSeIe7EGweGpJoyVPrnf3aU8h9uzwT10Q6eHTv9quZ9LWoG2Ju1xDsvqgR8aWRshOBP1H52g
 aAn42SILlYFDnJb5VlDe8oGyqUXAIS2NsQ8aCZsE93gLJnDAu6D38QsGbOgp2mxHqpW77y3i9ro
 s=
X-Google-Smtp-Source: AKy350aV2shDFEGq+y0+P6CuzF0QHTPYTOXNK5SCBfMQ/nybOe1LXkh957qYAcLDjaI6537aBHt8UA==
X-Received: by 2002:ad4:5dec:0:b0:5ad:5698:848e with SMTP id
 jn12-20020ad45dec000000b005ad5698848emr19825525qvb.48.1679947994512; 
 Mon, 27 Mar 2023 13:13:14 -0700 (PDT)
Received: from localhost (pool-68-160-166-30.bstnma.fios.verizon.net.
 [68.160.166.30]) by smtp.gmail.com with ESMTPSA id
 d13-20020a0cf6cd000000b005dd8b9345d3sm3161240qvo.107.2023.03.27.13.13.13
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Mon, 27 Mar 2023 13:13:14 -0700 (PDT)
From: Mike Snitzer <snitzer@kernel.org>
To: dm-devel@redhat.com
Date: Mon, 27 Mar 2023 16:11:28 -0400
Message-Id: <20230327201143.51026-6-snitzer@kernel.org>
In-Reply-To: <20230327201143.51026-1-snitzer@kernel.org>
References: <20230327201143.51026-1-snitzer@kernel.org>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
Subject: [dm-devel] [dm-6.4 PATCH v3 05/20] dm bufio: add LRU abstraction
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
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.4
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: kernel.org
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

From: Joe Thornber <ejt@redhat.com>

A CLOCK algorithm is used in this LRU abstraction.  This avoids
relinking list nodes, which would require a write lock protecting it.

None of the LRU methods are threadsafe; locking must be done at a
higher level.

Code that uses this new LRU will be introduced in the next 2 commits.

As such, this commit will cause "defined but not used" compiler warnings
that will be resolved by the next 2 commits.

Signed-off-by: Joe Thornber <ejt@redhat.com>
Signed-off-by: Mike Snitzer <snitzer@kernel.org>
---
 drivers/md/dm-bufio.c | 235 ++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 235 insertions(+)

diff --git a/drivers/md/dm-bufio.c b/drivers/md/dm-bufio.c
index 64fb5fd39bd9..a0bb0de0d4e7 100644
--- a/drivers/md/dm-bufio.c
+++ b/drivers/md/dm-bufio.c
@@ -66,6 +66,241 @@
 #define LIST_DIRTY	1
 #define LIST_SIZE	2
 
+/*--------------------------------------------------------------*/
+
+/*
+ * Rather than use an LRU list, we use a clock algorithm where entries
+ * are held in a circular list.  When an entry is 'hit' a reference bit
+ * is set.  The least recently used entry is approximated by running a
+ * cursor around the list selecting unreferenced entries. Referenced
+ * entries have their reference bit cleared as the cursor passes them.
+ */
+struct lru_entry {
+	struct list_head list;
+	atomic_t referenced;
+};
+
+struct lru_iter {
+	struct lru *lru;
+	struct list_head list;
+	struct lru_entry *stop;
+	struct lru_entry *e;
+};
+
+struct lru {
+	struct list_head *cursor;
+	unsigned long count;
+
+	struct list_head iterators;
+};
+
+/*--------------*/
+
+static void lru_init(struct lru *lru)
+{
+	lru->cursor = NULL;
+	lru->count = 0;
+	INIT_LIST_HEAD(&lru->iterators);
+}
+
+static void lru_destroy(struct lru *lru)
+{
+	WARN_ON_ONCE(lru->cursor);
+	WARN_ON_ONCE(!list_empty(&lru->iterators));
+}
+
+/*
+ * Insert a new entry into the lru.
+ */
+static void lru_insert(struct lru *lru, struct lru_entry *le)
+{
+	/*
+	 * Don't be tempted to set to 1, makes the lru aspect
+	 * perform poorly.
+	 */
+	atomic_set(&le->referenced, 0);
+
+	if (lru->cursor) {
+		list_add_tail(&le->list, lru->cursor);
+	} else {
+		INIT_LIST_HEAD(&le->list);
+		lru->cursor = &le->list;
+	}
+	lru->count++;
+}
+
+/*--------------*/
+
+/*
+ * Convert a list_head pointer to an lru_entry pointer.
+ */
+static inline struct lru_entry *to_le(struct list_head *l)
+{
+	return container_of(l, struct lru_entry, list);
+}
+
+/*
+ * Initialize an lru_iter and add it to the list of cursors in the lru.
+ */
+static void lru_iter_begin(struct lru *lru, struct lru_iter *it)
+{
+	it->lru = lru;
+	it->stop = lru->cursor ? to_le(lru->cursor->prev) : NULL;
+	it->e = lru->cursor ? to_le(lru->cursor) : NULL;
+	list_add(&it->list, &lru->iterators);
+}
+
+/*
+ * Remove an lru_iter from the list of cursors in the lru.
+ */
+static inline void lru_iter_end(struct lru_iter *it)
+{
+	list_del(&it->list);
+}
+
+/* Predicate function type to be used with lru_iter_next */
+typedef bool (*iter_predicate)(struct lru_entry *le, void *context);
+
+/*
+ * Advance the cursor to the next entry that passes the
+ * predicate, and return that entry.  Returns NULL if the
+ * iteration is complete.
+ */
+static struct lru_entry *lru_iter_next(struct lru_iter *it,
+				       iter_predicate pred, void *context)
+{
+	struct lru_entry *e;
+
+	while (it->e) {
+		e = it->e;
+
+		/* advance the cursor */
+		if (it->e == it->stop)
+			it->e = NULL;
+		else
+			it->e = to_le(it->e->list.next);
+
+		if (pred(e, context))
+			return e;
+	}
+
+	return NULL;
+}
+
+/*
+ * Invalidate a specific lru_entry and update all cursors in
+ * the lru accordingly.
+ */
+static void lru_iter_invalidate(struct lru *lru, struct lru_entry *e)
+{
+	struct lru_iter *it;
+
+	list_for_each_entry(it, &lru->iterators, list) {
+		/* Move c->e forwards if necc. */
+		if (it->e == e) {
+			it->e = to_le(it->e->list.next);
+			if (it->e == e)
+				it->e = NULL;
+		}
+
+		/* Move it->stop backwards if necc. */
+		if (it->stop == e) {
+			it->stop = to_le(it->stop->list.prev);
+			if (it->stop == e)
+				it->stop = NULL;
+		}
+	}
+}
+
+/*--------------*/
+
+/*
+ * Remove a specific entry from the lru.
+ */
+static void lru_remove(struct lru *lru, struct lru_entry *le)
+{
+	lru_iter_invalidate(lru, le);
+	if (lru->count == 1) {
+		lru->cursor = NULL;
+	} else {
+		if (lru->cursor == &le->list)
+			lru->cursor = lru->cursor->next;
+		list_del(&le->list);
+	}
+	lru->count--;
+}
+
+/*
+ * Mark as referenced.
+ */
+static inline void lru_reference(struct lru_entry *le)
+{
+	atomic_set(&le->referenced, 1);
+}
+
+/*--------------*/
+
+/*
+ * Remove the least recently used entry (approx), that passes the predicate.
+ * Returns NULL on failure.
+ */
+enum evict_result {
+	ER_EVICT,
+	ER_DONT_EVICT,
+	ER_STOP, /* stop looking for something to evict */
+};
+
+typedef enum evict_result (*le_predicate)(struct lru_entry *le, void *context);
+
+static struct lru_entry *lru_evict(struct lru *lru, le_predicate pred, void *context)
+{
+	unsigned long tested = 0;
+	struct list_head *h = lru->cursor;
+	struct lru_entry *le;
+
+	if (!h)
+		return NULL;
+	/*
+	 * In the worst case we have to loop around twice. Once to clear
+	 * the reference flags, and then again to discover the predicate
+	 * fails for all entries.
+	 */
+	while (tested < lru->count) {
+		le = container_of(h, struct lru_entry, list);
+
+		if (atomic_read(&le->referenced)) {
+			atomic_set(&le->referenced, 0);
+		} else {
+			tested++;
+			switch (pred(le, context)) {
+			case ER_EVICT:
+				/*
+				 * Adjust the cursor, so we start the next
+				 * search from here.
+				 */
+				lru->cursor = le->list.next;
+				lru_remove(lru, le);
+				return le;
+
+			case ER_DONT_EVICT:
+				break;
+
+			case ER_STOP:
+				lru->cursor = le->list.next;
+				return NULL;
+			}
+		}
+
+		h = h->next;
+
+		cond_resched();
+	}
+
+	return NULL;
+}
+
+/*--------------------------------------------------------------*/
+
 /*
  * Linking of buffers:
  *	All buffers are linked to buffer_tree with their node field.
-- 
2.40.0

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel


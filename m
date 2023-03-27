Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C2906C76195
	for <dm-devel@archiver.kernel.org>; Mon, 27 Mar 2023 20:13:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1679948038;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=vdWE55nQbwbRw/CMHvMl6f05SIsVDe3XReENiPyA8pY=;
	b=IP1oEIrss8ZgXwbpiV7e9QHiKwN5+q/fqLEb2mZMNkAm0UtOzaAkwa2AwyQBkme02Sb7P3
	yDjP/kR9dwHUKTcN1fxX2HFcCyuLHH1V1HdhG7qBPttmNlL/KhLqF83TfUdOYoqMwfhEkL
	1R6ULJvWG3qJhmscBhPvjNtSEC5+cDE=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-616-8CNxD95UNdu-ATJ7gBJUkA-1; Mon, 27 Mar 2023 16:13:55 -0400
X-MC-Unique: 8CNxD95UNdu-ATJ7gBJUkA-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 4A7F6858297;
	Mon, 27 Mar 2023 20:13:53 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 37ABE14171C6;
	Mon, 27 Mar 2023 20:13:53 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id E45D819472D2;
	Mon, 27 Mar 2023 20:13:36 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com
 [10.11.54.1])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 3FB711946A50
 for <dm-devel@listman.corp.redhat.com>; Mon, 27 Mar 2023 20:13:33 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 2630840B3EDA; Mon, 27 Mar 2023 20:13:33 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 1E0E240B3ED9
 for <dm-devel@redhat.com>; Mon, 27 Mar 2023 20:13:33 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id F1E82185A790
 for <dm-devel@redhat.com>; Mon, 27 Mar 2023 20:13:32 +0000 (UTC)
Received: from mail-qt1-f178.google.com (mail-qt1-f178.google.com
 [209.85.160.178]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-292-ly6G0KNxMSmVFWCKczhcHw-4; Mon, 27 Mar 2023 16:13:31 -0400
X-MC-Unique: ly6G0KNxMSmVFWCKczhcHw-4
Received: by mail-qt1-f178.google.com with SMTP id s12so6189326qtx.11
 for <dm-devel@redhat.com>; Mon, 27 Mar 2023 13:13:31 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112; t=1679948011;
 h=content-transfer-encoding:mime-version:references:in-reply-to
 :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
 :subject:date:message-id:reply-to;
 bh=VKZdoNXFigBuaARZaAptCA6/0fq1wlNkMtf1bLoETbM=;
 b=0u0e4JHNyggokcsoSB2pTytke49xjFmuVI9lZDq9KdXJL0jtCjcxbOoBAgnHPCnKH1
 c6eClkSBeQWFiXzQ+a7xhkAdvzMZXdamDH/x6wKoSgZ1MHENrFkXdNnR9mKHnlQoyIRk
 Zfm8AALcHMVTLRmWRQ9kimEW8V6yYm82duo20wTiqNPjOHIpySkgfclSfcwLz/yI844g
 JIo0hdyvozkRuBM+FA42yasoWDQj53CcuLW2BnjsQqp95/jkGIJyLkAI3hQ65lUauryi
 8svITwBK/Yw+x3I+DsARP0tBxallaor6SLSR837McQi1iylKwkSBMZyEIBhdT4jliG75
 rNMA==
X-Gm-Message-State: AO0yUKUymRk+8VLWKYhoXuT6avNQUkptCAEH6TyU/9Rf+wGFAu6uQ9IF
 CEUaOyvVO7buCbWNkc3KTjT4xl1J1+tCAsS3BKjuYoqXjLOQ9+G0ADLHS8QXnDrsjUf2ylhHZQ+
 Z7eNtwBnswikLY1PILd7B8pGo0I5uvMgsg7mfk9FSKBjRs64YO/BnDGI5m38s08pNpFtr7UkCtG
 g=
X-Google-Smtp-Source: AK7set9KXUMs1rqs7kAqxN9Yk6OnkJzXX9Ry0bTCMOPwZUEbPgMi3QtSYmMLZ60y5R3fllURrlRHWA==
X-Received: by 2002:a05:622a:647:b0:3bf:d9ee:882d with SMTP id
 a7-20020a05622a064700b003bfd9ee882dmr22445529qtb.40.1679948010612; 
 Mon, 27 Mar 2023 13:13:30 -0700 (PDT)
Received: from localhost (pool-68-160-166-30.bstnma.fios.verizon.net.
 [68.160.166.30]) by smtp.gmail.com with ESMTPSA id
 j9-20020a05620a288900b0070648cf78bdsm16879656qkp.54.2023.03.27.13.13.29
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Mon, 27 Mar 2023 13:13:30 -0700 (PDT)
From: Mike Snitzer <snitzer@kernel.org>
To: dm-devel@redhat.com
Date: Mon, 27 Mar 2023 16:11:37 -0400
Message-Id: <20230327201143.51026-15-snitzer@kernel.org>
In-Reply-To: <20230327201143.51026-1-snitzer@kernel.org>
References: <20230327201143.51026-1-snitzer@kernel.org>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.1
Subject: [dm-devel] [dm-6.4 PATCH v3 14/20] dm bio prison v1: improve
 concurrent IO performance
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
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.7
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: kernel.org
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

From: Joe Thornber <ejt@redhat.com>

Split the bio prison into multiple regions, with a separate rbtree and
associated lock for each region.

To get fast bio prison locking and not damage the performance of
discards too much the bio-prison now stipulates that discards should
not cross a BIO_PRISON_MAX_RANGE boundary.

Because the range of a key (block_end - block_begin) must not exceed
BIO_PRISON_MAX_RANGE: break_up_discard_bio() now ensures the data
range reflected in PHYSICAL key doesn't exceed BIO_PRISON_MAX_RANGE.
And splitting the thin target's discards (handled with VIRTUAL key) is
achieved by updating dm-thin.c to set limits->max_discard_sectors in
terms of BIO_PRISON_MAX_RANGE _and_ setting the thin and thin-pool
targets' max_discard_granularity to true.

Signed-off-by: Joe Thornber <ejt@redhat.com>
Signed-off-by: Mike Snitzer <snitzer@kernel.org>
---
 drivers/md/dm-bio-prison-v1.c | 87 +++++++++++++++++++++------------
 drivers/md/dm-bio-prison-v1.h | 10 ++++
 drivers/md/dm-thin.c          | 92 ++++++++++++++++++++---------------
 3 files changed, 121 insertions(+), 68 deletions(-)

diff --git a/drivers/md/dm-bio-prison-v1.c b/drivers/md/dm-bio-prison-v1.c
index c4c05d5d8909..2b8af861e5f6 100644
--- a/drivers/md/dm-bio-prison-v1.c
+++ b/drivers/md/dm-bio-prison-v1.c
@@ -16,11 +16,17 @@
 
 /*----------------------------------------------------------------*/
 
+#define NR_LOCKS 64
+#define LOCK_MASK (NR_LOCKS - 1)
 #define MIN_CELLS 1024
 
+struct prison_region {
+	spinlock_t lock;
+	struct rb_root cell;
+} ____cacheline_aligned_in_smp;
+
 struct dm_bio_prison {
-	spinlock_t lock;
-	struct rb_root cells;
+	struct prison_region regions[NR_LOCKS];
 	mempool_t cell_pool;
 };
 
@@ -34,13 +40,17 @@ static struct kmem_cache *_cell_cache;
  */
 struct dm_bio_prison *dm_bio_prison_create(void)
 {
-	struct dm_bio_prison *prison = kzalloc(sizeof(*prison), GFP_KERNEL);
 	int ret;
+	unsigned i;
+	struct dm_bio_prison *prison = kzalloc(sizeof(*prison), GFP_KERNEL);
 
 	if (!prison)
 		return NULL;
 
-	spin_lock_init(&prison->lock);
+	for (i = 0; i < NR_LOCKS; i++) {
+		spin_lock_init(&prison->regions[i].lock);
+		prison->regions[i].cell = RB_ROOT;
+	}
 
 	ret = mempool_init_slab_pool(&prison->cell_pool, MIN_CELLS, _cell_cache);
 	if (ret) {
@@ -48,8 +58,6 @@ struct dm_bio_prison *dm_bio_prison_create(void)
 		return NULL;
 	}
 
-	prison->cells = RB_ROOT;
-
 	return prison;
 }
 EXPORT_SYMBOL_GPL(dm_bio_prison_create);
@@ -107,14 +115,26 @@ static int cmp_keys(struct dm_cell_key *lhs,
 	return 0;
 }
 
-static int __bio_detain(struct dm_bio_prison *prison,
+static unsigned lock_nr(struct dm_cell_key *key)
+{
+	return (key->block_begin >> BIO_PRISON_MAX_RANGE_SHIFT) & LOCK_MASK;
+}
+
+static void check_range(struct dm_cell_key *key)
+{
+	BUG_ON(key->block_end - key->block_begin > BIO_PRISON_MAX_RANGE);
+	BUG_ON((key->block_begin >> BIO_PRISON_MAX_RANGE_SHIFT) !=
+	       ((key->block_end - 1) >> BIO_PRISON_MAX_RANGE_SHIFT));
+}
+
+static int __bio_detain(struct rb_root *root,
 			struct dm_cell_key *key,
 			struct bio *inmate,
 			struct dm_bio_prison_cell *cell_prealloc,
 			struct dm_bio_prison_cell **cell_result)
 {
 	int r;
-	struct rb_node **new = &prison->cells.rb_node, *parent = NULL;
+	struct rb_node **new = &root->rb_node, *parent = NULL;
 
 	while (*new) {
 		struct dm_bio_prison_cell *cell =
@@ -139,7 +159,7 @@ static int __bio_detain(struct dm_bio_prison *prison,
 	*cell_result = cell_prealloc;
 
 	rb_link_node(&cell_prealloc->node, parent, new);
-	rb_insert_color(&cell_prealloc->node, &prison->cells);
+	rb_insert_color(&cell_prealloc->node, root);
 
 	return 0;
 }
@@ -151,10 +171,12 @@ static int bio_detain(struct dm_bio_prison *prison,
 		      struct dm_bio_prison_cell **cell_result)
 {
 	int r;
+	unsigned l = lock_nr(key);
+	check_range(key);
 
-	spin_lock_irq(&prison->lock);
-	r = __bio_detain(prison, key, inmate, cell_prealloc, cell_result);
-	spin_unlock_irq(&prison->lock);
+	spin_lock_irq(&prison->regions[l].lock);
+	r = __bio_detain(&prison->regions[l].cell, key, inmate, cell_prealloc, cell_result);
+	spin_unlock_irq(&prison->regions[l].lock);
 
 	return r;
 }
@@ -181,11 +203,11 @@ EXPORT_SYMBOL_GPL(dm_get_cell);
 /*
  * @inmates must have been initialised prior to this call
  */
-static void __cell_release(struct dm_bio_prison *prison,
+static void __cell_release(struct rb_root *root,
 			   struct dm_bio_prison_cell *cell,
 			   struct bio_list *inmates)
 {
-	rb_erase(&cell->node, &prison->cells);
+	rb_erase(&cell->node, root);
 
 	if (inmates) {
 		if (cell->holder)
@@ -198,20 +220,22 @@ void dm_cell_release(struct dm_bio_prison *prison,
 		     struct dm_bio_prison_cell *cell,
 		     struct bio_list *bios)
 {
-	spin_lock_irq(&prison->lock);
-	__cell_release(prison, cell, bios);
-	spin_unlock_irq(&prison->lock);
+	unsigned l = lock_nr(&cell->key);
+
+	spin_lock_irq(&prison->regions[l].lock);
+	__cell_release(&prison->regions[l].cell, cell, bios);
+	spin_unlock_irq(&prison->regions[l].lock);
 }
 EXPORT_SYMBOL_GPL(dm_cell_release);
 
 /*
  * Sometimes we don't want the holder, just the additional bios.
  */
-static void __cell_release_no_holder(struct dm_bio_prison *prison,
+static void __cell_release_no_holder(struct rb_root *root,
 				     struct dm_bio_prison_cell *cell,
 				     struct bio_list *inmates)
 {
-	rb_erase(&cell->node, &prison->cells);
+	rb_erase(&cell->node, root);
 	bio_list_merge(inmates, &cell->bios);
 }
 
@@ -219,11 +243,12 @@ void dm_cell_release_no_holder(struct dm_bio_prison *prison,
 			       struct dm_bio_prison_cell *cell,
 			       struct bio_list *inmates)
 {
+	unsigned l = lock_nr(&cell->key);
 	unsigned long flags;
 
-	spin_lock_irqsave(&prison->lock, flags);
-	__cell_release_no_holder(prison, cell, inmates);
-	spin_unlock_irqrestore(&prison->lock, flags);
+	spin_lock_irqsave(&prison->regions[l].lock, flags);
+	__cell_release_no_holder(&prison->regions[l].cell, cell, inmates);
+	spin_unlock_irqrestore(&prison->regions[l].lock, flags);
 }
 EXPORT_SYMBOL_GPL(dm_cell_release_no_holder);
 
@@ -248,18 +273,19 @@ void dm_cell_visit_release(struct dm_bio_prison *prison,
 			   void *context,
 			   struct dm_bio_prison_cell *cell)
 {
-	spin_lock_irq(&prison->lock);
+	unsigned l = lock_nr(&cell->key);
+	spin_lock_irq(&prison->regions[l].lock);
 	visit_fn(context, cell);
-	rb_erase(&cell->node, &prison->cells);
-	spin_unlock_irq(&prison->lock);
+	rb_erase(&cell->node, &prison->regions[l].cell);
+	spin_unlock_irq(&prison->regions[l].lock);
 }
 EXPORT_SYMBOL_GPL(dm_cell_visit_release);
 
-static int __promote_or_release(struct dm_bio_prison *prison,
+static int __promote_or_release(struct rb_root *root,
 				struct dm_bio_prison_cell *cell)
 {
 	if (bio_list_empty(&cell->bios)) {
-		rb_erase(&cell->node, &prison->cells);
+		rb_erase(&cell->node, root);
 		return 1;
 	}
 
@@ -271,10 +297,11 @@ int dm_cell_promote_or_release(struct dm_bio_prison *prison,
 			       struct dm_bio_prison_cell *cell)
 {
 	int r;
+	unsigned l = lock_nr(&cell->key);
 
-	spin_lock_irq(&prison->lock);
-	r = __promote_or_release(prison, cell);
-	spin_unlock_irq(&prison->lock);
+	spin_lock_irq(&prison->regions[l].lock);
+	r = __promote_or_release(&prison->regions[l].cell, cell);
+	spin_unlock_irq(&prison->regions[l].lock);
 
 	return r;
 }
diff --git a/drivers/md/dm-bio-prison-v1.h b/drivers/md/dm-bio-prison-v1.h
index dfbf1e94cb75..0b8acd6708fb 100644
--- a/drivers/md/dm-bio-prison-v1.h
+++ b/drivers/md/dm-bio-prison-v1.h
@@ -34,6 +34,16 @@ struct dm_cell_key {
 	dm_block_t block_begin, block_end;
 };
 
+/*
+ * The range of a key (block_end - block_begin) must not
+ * exceed BIO_PRISON_MAX_RANGE.  Also the range must not
+ * cross a similarly sized boundary.
+ *
+ * Must be a power of 2.
+ */
+#define BIO_PRISON_MAX_RANGE 1024
+#define BIO_PRISON_MAX_RANGE_SHIFT 10
+
 /*
  * Treat this as opaque, only in header so callers can manage allocation
  * themselves.
diff --git a/drivers/md/dm-thin.c b/drivers/md/dm-thin.c
index 00323428919e..33ad5695f959 100644
--- a/drivers/md/dm-thin.c
+++ b/drivers/md/dm-thin.c
@@ -1674,54 +1674,69 @@ static void break_up_discard_bio(struct thin_c *tc, dm_block_t begin, dm_block_t
 	struct dm_cell_key data_key;
 	struct dm_bio_prison_cell *data_cell;
 	struct dm_thin_new_mapping *m;
-	dm_block_t virt_begin, virt_end, data_begin;
+	dm_block_t virt_begin, virt_end, data_begin, data_end;
+	dm_block_t len, next_boundary;
 
 	while (begin != end) {
-		r = ensure_next_mapping(pool);
-		if (r)
-			/* we did our best */
-			return;
-
 		r = dm_thin_find_mapped_range(tc->td, begin, end, &virt_begin, &virt_end,
 					      &data_begin, &maybe_shared);
-		if (r)
+		if (r) {
 			/*
 			 * Silently fail, letting any mappings we've
 			 * created complete.
 			 */
 			break;
-
-		build_key(tc->td, PHYSICAL, data_begin, data_begin + (virt_end - virt_begin), &data_key);
-		if (bio_detain(tc->pool, &data_key, NULL, &data_cell)) {
-			/* contention, we'll give up with this range */
-			begin = virt_end;
-			continue;
 		}
 
-		/*
-		 * IO may still be going to the destination block.  We must
-		 * quiesce before we can do the removal.
-		 */
-		m = get_next_mapping(pool);
-		m->tc = tc;
-		m->maybe_shared = maybe_shared;
-		m->virt_begin = virt_begin;
-		m->virt_end = virt_end;
-		m->data_block = data_begin;
-		m->cell = data_cell;
-		m->bio = bio;
+		data_end = data_begin + (virt_end - virt_begin);
 
 		/*
-		 * The parent bio must not complete before sub discard bios are
-		 * chained to it (see end_discard's bio_chain)!
-		 *
-		 * This per-mapping bi_remaining increment is paired with
-		 * the implicit decrement that occurs via bio_endio() in
-		 * end_discard().
+		 * Make sure the data region obeys the bio prison restrictions.
 		 */
-		bio_inc_remaining(bio);
-		if (!dm_deferred_set_add_work(pool->all_io_ds, &m->list))
-			pool->process_prepared_discard(m);
+		while (data_begin < data_end) {
+			r = ensure_next_mapping(pool);
+			if (r)
+				return; /* we did our best */
+
+			next_boundary = ((data_begin >> BIO_PRISON_MAX_RANGE_SHIFT) + 1)
+				<< BIO_PRISON_MAX_RANGE_SHIFT;
+			len = min_t(sector_t, data_end - data_begin, next_boundary - data_begin);
+
+			build_key(tc->td, PHYSICAL, data_begin, data_begin + len, &data_key);
+			if (bio_detain(tc->pool, &data_key, NULL, &data_cell)) {
+				/* contention, we'll give up with this range */
+				data_begin += len;
+				continue;
+			}
+
+			/*
+			 * IO may still be going to the destination block.  We must
+			 * quiesce before we can do the removal.
+			 */
+			m = get_next_mapping(pool);
+			m->tc = tc;
+			m->maybe_shared = maybe_shared;
+			m->virt_begin = virt_begin;
+			m->virt_end = virt_begin + len;
+			m->data_block = data_begin;
+			m->cell = data_cell;
+			m->bio = bio;
+
+			/*
+			 * The parent bio must not complete before sub discard bios are
+			 * chained to it (see end_discard's bio_chain)!
+			 *
+			 * This per-mapping bi_remaining increment is paired with
+			 * the implicit decrement that occurs via bio_endio() in
+			 * end_discard().
+			 */
+			bio_inc_remaining(bio);
+			if (!dm_deferred_set_add_work(pool->all_io_ds, &m->list))
+				pool->process_prepared_discard(m);
+
+			virt_begin += len;
+			data_begin += len;
+		}
 
 		begin = virt_end;
 	}
@@ -3380,13 +3395,13 @@ static int pool_ctr(struct dm_target *ti, unsigned int argc, char **argv)
 	 */
 	if (pf.discard_enabled && pf.discard_passdown) {
 		ti->num_discard_bios = 1;
-
 		/*
 		 * Setting 'discards_supported' circumvents the normal
 		 * stacking of discard limits (this keeps the pool and
 		 * thin devices' discard limits consistent).
 		 */
 		ti->discards_supported = true;
+		ti->max_discard_granularity = true;
 	}
 	ti->private = pt;
 
@@ -4096,7 +4111,7 @@ static struct target_type pool_target = {
 	.name = "thin-pool",
 	.features = DM_TARGET_SINGLETON | DM_TARGET_ALWAYS_WRITEABLE |
 		    DM_TARGET_IMMUTABLE,
-	.version = {1, 22, 0},
+	.version = {1, 23, 0},
 	.module = THIS_MODULE,
 	.ctr = pool_ctr,
 	.dtr = pool_dtr,
@@ -4261,6 +4276,7 @@ static int thin_ctr(struct dm_target *ti, unsigned int argc, char **argv)
 	if (tc->pool->pf.discard_enabled) {
 		ti->discards_supported = true;
 		ti->num_discard_bios = 1;
+		ti->max_discard_granularity = true;
 	}
 
 	mutex_unlock(&dm_thin_pool_table.mutex);
@@ -4476,12 +4492,12 @@ static void thin_io_hints(struct dm_target *ti, struct queue_limits *limits)
 		return;
 
 	limits->discard_granularity = pool->sectors_per_block << SECTOR_SHIFT;
-	limits->max_discard_sectors = 2048 * 1024 * 16; /* 16G */
+	limits->max_discard_sectors = pool->sectors_per_block * BIO_PRISON_MAX_RANGE;
 }
 
 static struct target_type thin_target = {
 	.name = "thin",
-	.version = {1, 22, 0},
+	.version = {1, 23, 0},
 	.module	= THIS_MODULE,
 	.ctr = thin_ctr,
 	.dtr = thin_dtr,
-- 
2.40.0

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel


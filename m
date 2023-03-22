Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AF722C6FD1C
	for <dm-devel@archiver.kernel.org>; Wed, 22 Mar 2023 18:19:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1679509175;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=FdSOzFjq9Qj/vhO6cAo2toyBlQIoLRAdy+J1QesDl9I=;
	b=NtYx/1uLBUh7s+KttAG5xU9Fht6NtNykXx3tWlbOskXtgXNsRrsZUlpGbUPnlYNYK2ri1H
	NEQZ9notX0UAKnPj7Yn6WphcA3ss14lg576JqWR/lnZSpjMdLsskqwhAlsTPBcUqe8VVlX
	XgDn/co/QDeHHNn3gLRiSVcwR7oD4oA=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-120-30bBCfczMhWYIGIPeKU_8w-1; Wed, 22 Mar 2023 14:19:34 -0400
X-MC-Unique: 30bBCfczMhWYIGIPeKU_8w-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 6AC1F101A54F;
	Wed, 22 Mar 2023 18:19:32 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 1DC70140EBF4;
	Wed, 22 Mar 2023 18:19:29 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id BF91F1946587;
	Wed, 22 Mar 2023 18:19:28 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com
 [10.11.54.10])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 8A1CC1946586
 for <dm-devel@listman.corp.redhat.com>; Wed, 22 Mar 2023 18:19:27 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 7B0BF483EC4; Wed, 22 Mar 2023 18:19:27 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 72A454619F5
 for <dm-devel@redhat.com>; Wed, 22 Mar 2023 18:19:27 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 520C785A588
 for <dm-devel@redhat.com>; Wed, 22 Mar 2023 18:19:27 +0000 (UTC)
Received: from mail-qt1-f174.google.com (mail-qt1-f174.google.com
 [209.85.160.174]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-443-kjvxHqeDNjWTJEnDvpaPBg-1; Wed, 22 Mar 2023 14:19:25 -0400
X-MC-Unique: kjvxHqeDNjWTJEnDvpaPBg-1
Received: by mail-qt1-f174.google.com with SMTP id r16so23787537qtx.9
 for <dm-devel@redhat.com>; Wed, 22 Mar 2023 11:19:25 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112; t=1679509165;
 h=content-transfer-encoding:mime-version:references:in-reply-to
 :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
 :subject:date:message-id:reply-to;
 bh=+PqWsorCIJf7wQCg4kx6uClJHSIeyct9JYqAFu+RKoU=;
 b=uKZtWL3uRWqpTrQ3KOtz3OheEYmA8qC8CPgdJzEOtFo1VabhxglcsgtKZv3Maq762p
 Cvt6VcQ/bKeZYupuUhKM/f6cPOM6I7u9Ro+jd6L9Y7Y4KOgJIk795N7iuCSQ4FaLTMXM
 PFa/5+5SEHi0WqXq586Lx6LIAEkihDWm+pdjPwWl+01V1RAvAAISVfx/Gt33kqui5ZhG
 vrT0hMDsBqD5FynY7ikdMxV4nlm0ylfXRTRJ1OO9xyq2HDnrzRxMZ0WIGOReWnZAzgDb
 b439wxNcGTh2wH8/9ALQt/mvXItfYuBWKr/T3j9FjF2ZUah8VWmgjc0uAcjJMI8/jiNh
 njHA==
X-Gm-Message-State: AO0yUKXygtQ1+GdYBifXTqhrmWGVDZCygJWC7sY/l+YWLnMmKmlMLv/e
 ckNeBclaFkRSQYkB+eMb4Xjsj1wzpdLZ8TfNR7YlAIuhSlHsmECQGqNhu8vMxDHMarD7Sb+nHbl
 QqkgvHdZHLBTfHLoqPQn5w8awzUqSIdoz103c0q90FSBTn/m2D4YykG9477ixO5Px02ieOHasgt
 Y=
X-Google-Smtp-Source: AK7set8SFuipuDEqwCfwCHIPLVg6m9CP05+YXL9fTb0Y0XSZA3riI5C+hI45x5WDxvsJ5gpgoB4P1Q==
X-Received: by 2002:a05:622a:215:b0:3b6:33c6:c5ac with SMTP id
 b21-20020a05622a021500b003b633c6c5acmr8163429qtx.4.1679509164690; 
 Wed, 22 Mar 2023 11:19:24 -0700 (PDT)
Received: from localhost (pool-68-160-166-30.bstnma.fios.verizon.net.
 [68.160.166.30]) by smtp.gmail.com with ESMTPSA id
 186-20020a3708c3000000b007467f7536d0sm106550qki.99.2023.03.22.11.19.24
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Wed, 22 Mar 2023 11:19:24 -0700 (PDT)
From: Mike Snitzer <snitzer@kernel.org>
To: dm-devel@redhat.com
Date: Wed, 22 Mar 2023 14:18:39 -0400
Message-Id: <20230322181845.29848-3-snitzer@kernel.org>
In-Reply-To: <20230322181845.29848-1-snitzer@kernel.org>
References: <20230322181845.29848-1-snitzer@kernel.org>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.10
Subject: [dm-devel] [dm-6.4 PATCH 2/8] dm bio prison v1: improve concurrent
 IO performance
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
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.7
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

From: Joe Thornber <ejt@redhat.com>

Split the bio prison into multiple regions, with a separate rbtree and
associated lock for each region.

The range of a key (block_end - block_begin) must not exceed
BIO_PRISON_MAX_RANGE.

To get fast bio prison locking and not damage the performance of
discards too much the bio-prison must stipulate that discards should
not cross a BIO_PRISON_MAX_RANGE boundary. This is achieved by
updating dm-thin.c to set limits->max_discard_sectors in terms of
BIO_PRISON_MAX_RANGE _and_ setting the thin and thin-pool targets'
max_discard_granularity to true.

Signed-off-by: Joe Thornber <ejt@redhat.com>
Signed-off-by: Mike Snitzer <snitzer@kernel.org>
---
 drivers/md/dm-bio-prison-v1.c | 87 +++++++++++++++++++++++------------
 drivers/md/dm-bio-prison-v1.h | 10 ++++
 drivers/md/dm-thin.c          |  9 ++--
 3 files changed, 72 insertions(+), 34 deletions(-)

diff --git a/drivers/md/dm-bio-prison-v1.c b/drivers/md/dm-bio-prison-v1.c
index c4c05d5d8909..e35ed236e0dc 100644
--- a/drivers/md/dm-bio-prison-v1.c
+++ b/drivers/md/dm-bio-prison-v1.c
@@ -16,11 +16,17 @@
 
 /*----------------------------------------------------------------*/
 
+#define NR_LOCKS 64
+#define LOCK_MASK (NR_LOCKS - 1)
 #define MIN_CELLS 1024
 
+struct lock {
+	spinlock_t lock;
+} ____cacheline_aligned_in_smp;
+
 struct dm_bio_prison {
-	spinlock_t lock;
-	struct rb_root cells;
+	struct lock lock[NR_LOCKS];
+	struct rb_root cells[NR_LOCKS];
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
+		spin_lock_init(&prison->lock[i].lock);
+		prison->cells[i] = RB_ROOT;
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
+	spin_lock_irq(&prison->lock[l].lock);
+	r = __bio_detain(&prison->cells[l], key, inmate, cell_prealloc, cell_result);
+	spin_unlock_irq(&prison->lock[l].lock);
 
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
+	spin_lock_irq(&prison->lock[l].lock);
+	__cell_release(&prison->cells[l], cell, bios);
+	spin_unlock_irq(&prison->lock[l].lock);
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
+	spin_lock_irqsave(&prison->lock[l].lock, flags);
+	__cell_release_no_holder(&prison->cells[l], cell, inmates);
+	spin_unlock_irqrestore(&prison->lock[l].lock, flags);
 }
 EXPORT_SYMBOL_GPL(dm_cell_release_no_holder);
 
@@ -248,18 +273,19 @@ void dm_cell_visit_release(struct dm_bio_prison *prison,
 			   void *context,
 			   struct dm_bio_prison_cell *cell)
 {
-	spin_lock_irq(&prison->lock);
+	unsigned l = lock_nr(&cell->key);
+	spin_lock_irq(&prison->lock[l].lock);
 	visit_fn(context, cell);
-	rb_erase(&cell->node, &prison->cells);
-	spin_unlock_irq(&prison->lock);
+	rb_erase(&cell->node, &prison->cells[l]);
+	spin_unlock_irq(&prison->lock[l].lock);
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
+	spin_lock_irq(&prison->lock[l].lock);
+	r = __promote_or_release(&prison->cells[l], cell);
+	spin_unlock_irq(&prison->lock[l].lock);
 
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
index 13d4677baafd..286e4d9e45c8 100644
--- a/drivers/md/dm-thin.c
+++ b/drivers/md/dm-thin.c
@@ -3378,13 +3378,13 @@ static int pool_ctr(struct dm_target *ti, unsigned int argc, char **argv)
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
 
@@ -4094,7 +4094,7 @@ static struct target_type pool_target = {
 	.name = "thin-pool",
 	.features = DM_TARGET_SINGLETON | DM_TARGET_ALWAYS_WRITEABLE |
 		    DM_TARGET_IMMUTABLE,
-	.version = {1, 22, 0},
+	.version = {1, 23, 0},
 	.module = THIS_MODULE,
 	.ctr = pool_ctr,
 	.dtr = pool_dtr,
@@ -4259,6 +4259,7 @@ static int thin_ctr(struct dm_target *ti, unsigned int argc, char **argv)
 	if (tc->pool->pf.discard_enabled) {
 		ti->discards_supported = true;
 		ti->num_discard_bios = 1;
+		ti->max_discard_granularity = true;
 	}
 
 	mutex_unlock(&dm_thin_pool_table.mutex);
@@ -4474,12 +4475,12 @@ static void thin_io_hints(struct dm_target *ti, struct queue_limits *limits)
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


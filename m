Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E78A7E94139
	for <dm-devel@archiver.kernel.org>; Sat,  7 Oct 2023 01:33:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1696642417;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=/Pzk0ctB50pw36VpBzLGnggzkfODpDOJrGKe23nNR+I=;
	b=XIHBz/edX3xp0E+41NS6f5vsJobbYKzJF8sgOENio6ywSMx19J1ZBBQ+BWAxrA3LMdOPBQ
	wfytj+GqmMQjyFDG0aqpxaseNQXH91AIkS8oodZdXt0JIK7VUnunebrcRA5Abb8SRzTjnr
	EUWXcQItzaCW0ItZskYM3Be+pCC4FCc=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-563-K5mYx_jCM0-09Zx2IayWQg-1; Fri, 06 Oct 2023 21:33:24 -0400
X-MC-Unique: K5mYx_jCM0-09Zx2IayWQg-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D98FD8001EA;
	Sat,  7 Oct 2023 01:33:22 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id C357640C6EA8;
	Sat,  7 Oct 2023 01:33:22 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 6577C1946589;
	Sat,  7 Oct 2023 01:33:22 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
 [10.11.54.5])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id B2FA51946588
 for <dm-devel@listman.corp.redhat.com>; Sat,  7 Oct 2023 01:33:21 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 9918E5CC01; Sat,  7 Oct 2023 01:33:21 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 91960170E9
 for <dm-devel@redhat.com>; Sat,  7 Oct 2023 01:33:21 +0000 (UTC)
Received: from us-smtp-inbound-delivery-1.mimecast.com
 (us-smtp-inbound-delivery-1.mimecast.com [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 6EB5E185A78E
 for <dm-devel@redhat.com>; Sat,  7 Oct 2023 01:33:21 +0000 (UTC)
Received: from mail-pl1-f175.google.com (mail-pl1-f175.google.com
 [209.85.214.175]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-675-vB9WJe7ENouST0H32rVi9Q-1; Fri, 06 Oct 2023 21:33:19 -0400
X-MC-Unique: vB9WJe7ENouST0H32rVi9Q-1
Received: by mail-pl1-f175.google.com with SMTP id
 d9443c01a7336-1c737d61a00so21938715ad.3
 for <dm-devel@redhat.com>; Fri, 06 Oct 2023 18:33:19 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20230601; t=1696642398; x=1697247198;
 h=content-transfer-encoding:mime-version:message-id:date:subject:cc
 :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
 :reply-to;
 bh=bw0i5BjLD5HynkaIMHaDuDywPDJie/n4JgfUzvkLhH0=;
 b=Y8zs5lUcN4yQXZdBN3C1AM2xPeBMgFyRQVVcwPK+vtSNljIqsl2jtBq39UjXg/N1O0
 QMCcPG7Rsx+MRTmE89HRGpsp1X9QJSJg4sO1fr4KReSiMF6jf0xe+09O4MWkqgkQbhfm
 s2rbK7Vt8x4NJVqamyAZZTWBPsfilgUiA1k+v9CMTSqSH18iGjgIhOY6omx1FwdR9DJF
 KVbuhx7QYYr3b9fdbiuvTwgFkDTX5aXrXg1SOPjaH3i0fdJ1in60WJeTp9Ol1tDMu+9e
 +R+vEu5vJv5MN3xdKjQilcS6vHm4Rlq1x5l+953rB6kU83ENl6gGRopI714yKxqkOKYe
 /u8w==
X-Gm-Message-State: AOJu0YxpQMXqUt/BvhuVGvWpqJI7zQM/Caqy3oDcS5cjafLY7wQd4Lx4
 wbdnNKoG5ih7PXFmN+iPUb4N45Xvlr4BedfSq2o=
X-Google-Smtp-Source: AGHT+IGgiVE2knzBQevrIgQbdtL+0MzY7MwORkEoTxB4XYaM0iaoUXW5Ll8AxYMc4d8Fn2LTbmKHtg==
X-Received: by 2002:a17:902:ced2:b0:1be:f45c:bc38 with SMTP id
 d18-20020a170902ced200b001bef45cbc38mr11726592plg.2.1696642397723; 
 Fri, 06 Oct 2023 18:33:17 -0700 (PDT)
Received: from localhost ([2620:15c:9d:2:138c:8976:eb4a:a91c])
 by smtp.gmail.com with UTF8SMTPSA id
 iz2-20020a170902ef8200b001c71ec1866fsm4600121plb.258.2023.10.06.18.33.16
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Fri, 06 Oct 2023 18:33:17 -0700 (PDT)
From: Sarthak Kukreti <sarthakkukreti@chromium.org>
To: dm-devel@redhat.com,
	linux-kernel@vger.kernel.org
Date: Fri,  6 Oct 2023 18:33:14 -0700
Message-ID: <20231007013314.3055426-1-sarthakkukreti@chromium.org>
MIME-Version: 1.0
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
Subject: [dm-devel] [PATCH RFC] dm thin: Add support for online trim to
 dm-thinpool
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
Cc: Mike Snitzer <snitzer@kernel.org>,
 Sarthak Kukreti <sarthakkukreti@chromium.org>,
 Alasdair Kergon <agk@redhat.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: chromium.org
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Currently, dm-thinpool only supports offline trim: there is
a userspace tool called `thin_trim` (part of `thin-provisioning-tools`),
that will look up all the unmapped regions within the thinpool
and issue discards to these regions. However, this can take up a lot of
time, specially on larger storage devices.

This patch augments dm-thinpool's no passdown mode with a message
mechanism that allows userspace to issue 'trim' messages to regions
of the thinpool. In turn, dm-thinpool re-uses the existing discard
mechanism to issue a discard bio to only send discards to regions in
the data device that are currently not mapped on other dm-thin devices.

This patch is intended as an RFC with the following open questions
(assuming that the approach is even viable):

- Most of the patch is modifying current discard functions to work
  without an attached dm-thin context (tc). Would it be preferrable to
  keep this path independent of the thin volume discard path?

- Current RFC patch doesn't protect against userspace attempting to
  discard large ranges of extents in the thinpool (which puts the
  thinpool in read-only mode). What would the optimal way to prevent
  trim from locking up the space in the thinpool (chunking requests?)?

- The patch currently only sets up the 'trim' capability if no passdown
  is enabled: the reasoning behind that is if passdown is enabled,
  thin_trim doesn't necessarily need the trim capability iff all the
  dm-thin devices can passdown requests from the filesystem already.
  Would it be preferrable to have this capability across all discard
  modes?

Signed-off-by: Sarthak Kukreti <sarthakkukreti@chromium.org>
---
 drivers/md/dm-thin.c | 156 +++++++++++++++++++++++++++++++++----------
 1 file changed, 121 insertions(+), 35 deletions(-)

diff --git a/drivers/md/dm-thin.c b/drivers/md/dm-thin.c
index 07c7f9795b10..9a8eeebd9f49 100644
--- a/drivers/md/dm-thin.c
+++ b/drivers/md/dm-thin.c
@@ -280,6 +280,7 @@ struct pool {
 
 	process_mapping_fn process_prepared_mapping;
 	process_mapping_fn process_prepared_discard;
+	process_mapping_fn process_prepared_trim;
 	process_mapping_fn process_prepared_discard_pt2;
 
 	struct dm_bio_prison_cell **cell_sort_array;
@@ -379,17 +380,17 @@ static sector_t block_to_sectors(struct pool *pool, dm_block_t b)
 /*----------------------------------------------------------------*/
 
 struct discard_op {
-	struct thin_c *tc;
+	struct pool *pool;
 	struct blk_plug plug;
 	struct bio *parent_bio;
 	struct bio *bio;
 };
 
-static void begin_discard(struct discard_op *op, struct thin_c *tc, struct bio *parent)
+static void begin_discard(struct discard_op *op, struct pool *pool, struct bio *parent)
 {
 	BUG_ON(!parent);
 
-	op->tc = tc;
+	op->pool = pool;
 	blk_start_plug(&op->plug);
 	op->parent_bio = parent;
 	op->bio = NULL;
@@ -397,11 +398,11 @@ static void begin_discard(struct discard_op *op, struct thin_c *tc, struct bio *
 
 static int issue_discard(struct discard_op *op, dm_block_t data_b, dm_block_t data_e)
 {
-	struct thin_c *tc = op->tc;
-	sector_t s = block_to_sectors(tc->pool, data_b);
-	sector_t len = block_to_sectors(tc->pool, data_e - data_b);
+	struct pool *pool = op->pool;
+	sector_t s = block_to_sectors(pool, data_b);
+	sector_t len = block_to_sectors(pool, data_e - data_b);
 
-	return __blkdev_issue_discard(tc->pool_dev->bdev, s, len, GFP_NOIO, &op->bio);
+	return __blkdev_issue_discard(pool->data_dev, s, len, GFP_NOIO, &op->bio);
 }
 
 static void end_discard(struct discard_op *op, int r)
@@ -813,6 +814,7 @@ struct dm_thin_new_mapping {
 
 	blk_status_t status;
 	struct thin_c *tc;
+	struct pool *pool;
 	dm_block_t virt_begin, virt_end;
 	dm_block_t data_block;
 	struct dm_bio_prison_cell *cell;
@@ -829,7 +831,7 @@ struct dm_thin_new_mapping {
 
 static void __complete_mapping_preparation(struct dm_thin_new_mapping *m)
 {
-	struct pool *pool = m->tc->pool;
+	struct pool *pool = m->pool;
 
 	if (atomic_dec_and_test(&m->prepare_actions)) {
 		list_add_tail(&m->list, &pool->prepared_mappings);
@@ -840,7 +842,7 @@ static void __complete_mapping_preparation(struct dm_thin_new_mapping *m)
 static void complete_mapping_preparation(struct dm_thin_new_mapping *m)
 {
 	unsigned long flags;
-	struct pool *pool = m->tc->pool;
+	struct pool *pool = m->pool;
 
 	spin_lock_irqsave(&pool->lock, flags);
 	__complete_mapping_preparation(m);
@@ -955,9 +957,9 @@ static void inc_remap_and_issue_cell(struct thin_c *tc,
 
 static void process_prepared_mapping_fail(struct dm_thin_new_mapping *m)
 {
-	cell_error(m->tc->pool, m->cell);
+	cell_error(m->pool, m->cell);
 	list_del(&m->list);
-	mempool_free(m, &m->tc->pool->mapping_pool);
+	mempool_free(m, &m->pool->mapping_pool);
 }
 
 static void complete_overwrite_bio(struct thin_c *tc, struct bio *bio)
@@ -995,7 +997,7 @@ static void complete_overwrite_bio(struct thin_c *tc, struct bio *bio)
 static void process_prepared_mapping(struct dm_thin_new_mapping *m)
 {
 	struct thin_c *tc = m->tc;
-	struct pool *pool = tc->pool;
+	struct pool *pool = m->pool;
 	struct bio *bio = m->bio;
 	int r;
 
@@ -1041,10 +1043,11 @@ static void process_prepared_mapping(struct dm_thin_new_mapping *m)
 static void free_discard_mapping(struct dm_thin_new_mapping *m)
 {
 	struct thin_c *tc = m->tc;
+	struct pool *pool = m->pool;
 
-	if (m->cell)
+	if (m->cell && tc)
 		cell_defer_no_holder(tc, m->cell);
-	mempool_free(m, &tc->pool->mapping_pool);
+	mempool_free(m, &pool->mapping_pool);
 }
 
 static void process_prepared_discard_fail(struct dm_thin_new_mapping *m)
@@ -1066,13 +1069,13 @@ static void process_prepared_discard_no_passdown(struct dm_thin_new_mapping *m)
 
 	r = dm_thin_remove_range(tc->td, m->cell->key.block_begin, m->cell->key.block_end);
 	if (r) {
-		metadata_operation_failed(tc->pool, "dm_thin_remove_range", r);
+		metadata_operation_failed(m->pool, "dm_thin_remove_range", r);
 		bio_io_error(m->bio);
 	} else
 		bio_endio(m->bio);
 
 	cell_defer_no_holder(tc, m->cell);
-	mempool_free(m, &tc->pool->mapping_pool);
+	mempool_free(m, &m->pool->mapping_pool);
 }
 
 /*----------------------------------------------------------------*/
@@ -1086,12 +1089,11 @@ static void passdown_double_checking_shared_status(struct dm_thin_new_mapping *m
 	 */
 	int r = 0;
 	bool shared = true;
-	struct thin_c *tc = m->tc;
-	struct pool *pool = tc->pool;
+	struct pool *pool = m->pool;
 	dm_block_t b = m->data_block, e, end = m->data_block + m->virt_end - m->virt_begin;
 	struct discard_op op;
 
-	begin_discard(&op, tc, discard_parent);
+	begin_discard(&op, pool, discard_parent);
 	while (b != end) {
 		/* find start of unmapped run */
 		for (; b < end; b++) {
@@ -1129,7 +1131,7 @@ static void passdown_double_checking_shared_status(struct dm_thin_new_mapping *m
 static void queue_passdown_pt2(struct dm_thin_new_mapping *m)
 {
 	unsigned long flags;
-	struct pool *pool = m->tc->pool;
+	struct pool *pool = m->pool;
 
 	spin_lock_irqsave(&pool->lock, flags);
 	list_add_tail(&m->list, &pool->prepared_discards_pt2);
@@ -1151,7 +1153,7 @@ static void process_prepared_discard_passdown_pt1(struct dm_thin_new_mapping *m)
 {
 	int r;
 	struct thin_c *tc = m->tc;
-	struct pool *pool = tc->pool;
+	struct pool *pool = m->pool;
 	struct bio *discard_parent;
 	dm_block_t data_end = m->data_block + (m->virt_end - m->virt_begin);
 
@@ -1160,13 +1162,15 @@ static void process_prepared_discard_passdown_pt1(struct dm_thin_new_mapping *m)
 	 * newly unmapped blocks will not be allocated before the end of
 	 * the function.
 	 */
-	r = dm_thin_remove_range(tc->td, m->virt_begin, m->virt_end);
-	if (r) {
-		metadata_operation_failed(pool, "dm_thin_remove_range", r);
-		bio_io_error(m->bio);
-		cell_defer_no_holder(tc, m->cell);
-		mempool_free(m, &pool->mapping_pool);
-		return;
+	if (tc) {
+		r = dm_thin_remove_range(tc->td, m->virt_begin, m->virt_end);
+		if (r) {
+			metadata_operation_failed(pool, "dm_thin_remove_range", r);
+			bio_io_error(m->bio);
+			cell_defer_no_holder(tc, m->cell);
+			mempool_free(m, &pool->mapping_pool);
+			return;
+		}
 	}
 
 	/*
@@ -1176,8 +1180,10 @@ static void process_prepared_discard_passdown_pt1(struct dm_thin_new_mapping *m)
 	r = dm_pool_inc_data_range(pool->pmd, m->data_block, data_end);
 	if (r) {
 		metadata_operation_failed(pool, "dm_pool_inc_data_range", r);
-		bio_io_error(m->bio);
-		cell_defer_no_holder(tc, m->cell);
+		if (m->bio)
+			bio_io_error(m->bio);
+		if (tc)
+			cell_defer_no_holder(tc, m->cell);
 		mempool_free(m, &pool->mapping_pool);
 		return;
 	}
@@ -1190,7 +1196,7 @@ static void process_prepared_discard_passdown_pt1(struct dm_thin_new_mapping *m)
 	else {
 		struct discard_op op;
 
-		begin_discard(&op, tc, discard_parent);
+		begin_discard(&op, pool, discard_parent);
 		r = issue_discard(&op, m->data_block, data_end);
 		end_discard(&op, r);
 	}
@@ -1200,7 +1206,7 @@ static void process_prepared_discard_passdown_pt2(struct dm_thin_new_mapping *m)
 {
 	int r;
 	struct thin_c *tc = m->tc;
-	struct pool *pool = tc->pool;
+	struct pool *pool = m->pool;
 
 	/*
 	 * The passdown has completed, so now we can decrement all those
@@ -1210,11 +1216,14 @@ static void process_prepared_discard_passdown_pt2(struct dm_thin_new_mapping *m)
 				   m->data_block + (m->virt_end - m->virt_begin));
 	if (r) {
 		metadata_operation_failed(pool, "dm_pool_dec_data_range", r);
-		bio_io_error(m->bio);
+		if (m->bio)
+			bio_io_error(m->bio);
 	} else
-		bio_endio(m->bio);
+		if (m->bio)
+			bio_endio(m->bio);
 
-	cell_defer_no_holder(tc, m->cell);
+	if (tc)
+		cell_defer_no_holder(tc, m->cell);
 	mempool_free(m, &pool->mapping_pool);
 }
 
@@ -1319,6 +1328,7 @@ static void schedule_copy(struct thin_c *tc, dm_block_t virt_block,
 	struct dm_thin_new_mapping *m = get_next_mapping(pool);
 
 	m->tc = tc;
+	m->pool = pool;
 	m->virt_begin = virt_block;
 	m->virt_end = virt_block + 1u;
 	m->data_block = data_dest;
@@ -1388,6 +1398,7 @@ static void schedule_zero(struct thin_c *tc, dm_block_t virt_block,
 
 	atomic_set(&m->prepare_actions, 1); /* no need to quiesce */
 	m->tc = tc;
+	m->pool = pool;
 	m->virt_begin = virt_block;
 	m->virt_end = virt_block + 1u;
 	m->data_block = data_block;
@@ -1656,6 +1667,7 @@ static void process_discard_cell_no_passdown(struct thin_c *tc,
 	 * passdown.  We only lock data blocks for allocation and breaking sharing.
 	 */
 	m->tc = tc;
+	m->pool = pool;
 	m->virt_begin = virt_cell->key.block_begin;
 	m->virt_end = virt_cell->key.block_end;
 	m->cell = virt_cell;
@@ -1717,6 +1729,7 @@ static void break_up_discard_bio(struct thin_c *tc, dm_block_t begin, dm_block_t
 			 */
 			m = get_next_mapping(pool);
 			m->tc = tc;
+			m->pool = pool;
 			m->maybe_shared = maybe_shared;
 			m->virt_begin = virt_begin;
 			m->virt_end = virt_begin + len;
@@ -1828,6 +1841,27 @@ static void break_sharing(struct thin_c *tc, struct bio *bio, dm_block_t block,
 	}
 }
 
+static void process_trim(struct pool *pool, dm_block_t begin, dm_block_t end)
+{
+	int r;
+	struct dm_thin_new_mapping *m;
+
+
+	r = ensure_next_mapping(pool);
+	if (r)
+		return;
+
+	m = get_next_mapping(pool);
+
+	m->pool = pool;
+	m->maybe_shared = true;
+	m->virt_begin = 0;
+	m->virt_end = end;
+	m->data_block = begin;
+
+	pool->process_prepared_trim(m);
+}
+
 static void __remap_and_issue_shared_cell(void *context,
 					  struct dm_bio_prison_cell *cell)
 {
@@ -2538,6 +2572,8 @@ static void set_discard_callbacks(struct pool *pool)
 	} else {
 		pool->process_discard_cell = process_discard_cell_no_passdown;
 		pool->process_prepared_discard = process_prepared_discard_no_passdown;
+		pool->process_prepared_trim = process_prepared_discard_passdown_pt1;
+		pool->process_prepared_discard_pt2 = process_prepared_discard_passdown_pt2;
 	}
 }
 
@@ -2577,6 +2613,7 @@ static void set_pool_mode(struct pool *pool, enum pool_mode new_mode)
 		pool->process_discard_cell = process_cell_fail;
 		pool->process_prepared_mapping = process_prepared_mapping_fail;
 		pool->process_prepared_discard = process_prepared_discard_fail;
+		pool->process_prepared_trim = process_prepared_discard_fail;
 
 		error_retry_list(pool);
 		break;
@@ -2590,6 +2627,7 @@ static void set_pool_mode(struct pool *pool, enum pool_mode new_mode)
 		pool->process_discard_cell = process_cell_success;
 		pool->process_prepared_mapping = process_prepared_mapping_fail;
 		pool->process_prepared_discard = process_prepared_discard_success;
+		pool->process_prepared_trim = process_prepared_discard_success;
 
 		error_retry_list(pool);
 		break;
@@ -3834,6 +3872,50 @@ static int process_release_metadata_snap_mesg(unsigned int argc, char **argv, st
 	return r;
 }
 
+static int process_trim_mesg(unsigned int argc, char **argv, struct pool *pool)
+{
+	uint64_t begin, end;
+	int r;
+
+	/* Allow trim only in no_passdown mode */
+	if (!pool->pf.discard_enabled || pool->pf.discard_passdown)
+		return -EINVAL;
+
+	r = check_arg_count(argc, 3);
+	if (r)
+		return r;
+
+	if (kstrtoull(argv[1], 10, (unsigned long long *)&begin)) {
+		DMWARN("trim message: invalid 'begin' %s", argv[1]);
+		return -EINVAL;
+	}
+
+	if (kstrtoull(argv[2], 10, (unsigned long long *)&end)) {
+		DMWARN("trim message: invalid 'end' %s", argv[2]);
+		return -EINVAL;
+	}
+
+	sector_t b = begin >> SECTOR_SHIFT;
+	sector_t e = end >> SECTOR_SHIFT;
+
+	b += pool->sectors_per_block - 1ull; /* so we round up */
+
+	if (block_size_is_power_of_two(pool)) {
+		b >>= pool->sectors_per_block_shift;
+		e >>= pool->sectors_per_block_shift;
+	} else {
+		(void) sector_div(b, pool->sectors_per_block);
+		(void) sector_div(e, pool->sectors_per_block);
+	}
+
+	if (e < b)
+		e = b;
+
+	process_trim(pool, b, e);
+
+	return 0;
+}
+
 /*
  * Messages supported:
  *   create_thin	<dev_id>
@@ -3842,6 +3924,7 @@ static int process_release_metadata_snap_mesg(unsigned int argc, char **argv, st
  *   set_transaction_id <current_trans_id> <new_trans_id>
  *   reserve_metadata_snap
  *   release_metadata_snap
+ *   trim <start> <end>
  */
 static int pool_message(struct dm_target *ti, unsigned int argc, char **argv,
 			char *result, unsigned int maxlen)
@@ -3874,6 +3957,9 @@ static int pool_message(struct dm_target *ti, unsigned int argc, char **argv,
 	else if (!strcasecmp(argv[0], "release_metadata_snap"))
 		r = process_release_metadata_snap_mesg(argc, argv, pool);
 
+	else if (!strcasecmp(argv[0], "trim"))
+		r = process_trim_mesg(argc, argv, pool);
+
 	else
 		DMWARN("Unrecognised thin pool target message received: %s", argv[0]);
 
-- 
2.42.0.609.gbb76f46606-goog

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel


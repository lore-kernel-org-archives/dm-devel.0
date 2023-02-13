Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 96229C636D4
	for <dm-devel@archiver.kernel.org>; Mon, 13 Feb 2023 20:15:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1676319333;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=+49TLgzSs1W5BWxv1vRvRAwxdbkDCnhcfQHRC8VABhA=;
	b=LOBIkoSGYcspFEGBK1aearHWFJwVRxDU3nnr4lo+z1PeaNqxE8WkLQbKt7AKAg7OKk7k81
	bj4ENnt3VP8Ql33MQK2c9nhph/l0YH0jwWj3hjygfUdmucE7ffmQg9SHj5WhIyfqO0lb/4
	f2nGmqk7ajrqKArBzM2Boz8j9PTMSyE=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-350-Rgs1b0mgM_icl46XP1d8QA-1; Mon, 13 Feb 2023 15:15:31 -0500
X-MC-Unique: Rgs1b0mgM_icl46XP1d8QA-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id CBB5F1C0754F;
	Mon, 13 Feb 2023 20:15:19 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id B681BC16022;
	Mon, 13 Feb 2023 20:15:19 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id A8EC01946588;
	Mon, 13 Feb 2023 20:15:19 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com
 [10.11.54.2])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id D662E1946586
 for <dm-devel@listman.corp.redhat.com>; Mon, 13 Feb 2023 20:15:17 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id CAA48403D0C1; Mon, 13 Feb 2023 20:15:17 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id C2714403D0D1
 for <dm-devel@redhat.com>; Mon, 13 Feb 2023 20:15:17 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D3EB288B7CF
 for <dm-devel@redhat.com>; Mon, 13 Feb 2023 20:15:15 +0000 (UTC)
Received: from mail-qt1-f182.google.com (mail-qt1-f182.google.com
 [209.85.160.182]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-659-q1b475YJNxSscFiiinKCkA-2; Mon, 13 Feb 2023 15:15:07 -0500
X-MC-Unique: q1b475YJNxSscFiiinKCkA-2
Received: by mail-qt1-f182.google.com with SMTP id h24so15268583qtr.0
 for <dm-devel@redhat.com>; Mon, 13 Feb 2023 12:15:00 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=content-transfer-encoding:mime-version:references:in-reply-to
 :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
 :subject:date:message-id:reply-to;
 bh=zKden4wixtSr9xSf7iwp+wJr0FITtKg9qG5SJqiQtMQ=;
 b=FOwDlOrq9SVCcQFzgfBeJuI+uI2RViHvXTwCpeP9c+xCnpCVbgr0Ma7Kb0TrO3JBRk
 xKjHOOeVzTqxdW0Q+1/OfSqCjNbNalscQ9JvNMdXOpbqqD1t7VjjmnXJy3AOOT5SwkTB
 wH/HdW1fvJ15+Y8USgajlD9gYlJnRuY6x3o/M6h8OM2KY6Hw5fnPxfomm9RB6p5fYI39
 aWS3/zkd2XS6abFLX36AdMR5/jL3Kuep6BZXriK5FurZa6X2E4PvNzqvk0dOf7J6IYzv
 I89WcvdxvLvH/Ux2h/o8AdjNpqMDpF6HiURYgWx+qJhIR58SSMREFtKbwMPDNgdA8ypO
 IZzA==
X-Gm-Message-State: AO0yUKU+FTyter9qNJhIogJa7BcqPGLaEBqzwjbNRt/CLJ774H1WFH2V
 MT5LDuLB5K1nr4dr05HWzReAz1aOKWzwgbU2MH3i/DjbE4VY0G8IXQT5GAYrjelY5GwegFP2fyO
 TJeg8SbEgDMZsVEfxKzhm6juuv8NGH6ZAc2oAzDqbSHXr2awwwC7yqi+mMNHBJRDkkyEyfw==
X-Google-Smtp-Source: AK7set9QCzDq3Kwnx52KMiqeIwfZqjzXxudeo8+BcN2N14YIiHSBq7FwEwnY8MaHK7dTtmeLvioMOw==
X-Received: by 2002:a05:622a:413:b0:3b9:b57d:4646 with SMTP id
 n19-20020a05622a041300b003b9b57d4646mr46342322qtx.18.1676319297851; 
 Mon, 13 Feb 2023 12:14:57 -0800 (PST)
Received: from localhost (pool-68-160-166-30.bstnma.fios.verizon.net.
 [68.160.166.30]) by smtp.gmail.com with ESMTPSA id
 21-20020ac856f5000000b003a6a19ee4f0sm9858713qtu.33.2023.02.13.12.14.56
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Mon, 13 Feb 2023 12:14:57 -0800 (PST)
From: Mike Snitzer <snitzer@kernel.org>
To: dm-devel@redhat.com
Date: Mon, 13 Feb 2023 15:13:40 -0500
Message-Id: <20230213201401.45973-19-snitzer@kernel.org>
In-Reply-To: <20230213201401.45973-1-snitzer@kernel.org>
References: <20230213201401.45973-1-snitzer@kernel.org>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
Subject: [dm-devel] [PATCH 18/39] dm: remove unnecessary braces from single
 statement blocks
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
Cc: ebiggers@kernel.org, Heinz Mauelshagen <heinzm@redhat.com>,
 Mike Snitzer <snitzer@kernel.org>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

From: Heinz Mauelshagen <heinzm@redhat.com>

Signed-off-by: Heinz Mauelshagen <heinzm@redhat.com>
Signed-off-by: Mike Snitzer <snitzer@kernel.org>
---
 drivers/md/dm-integrity.c                     | 48 ++++++++-----------
 drivers/md/dm-stats.c                         |  9 ++--
 drivers/md/dm-stripe.c                        | 10 ++--
 drivers/md/dm-thin-metadata.c                 |  4 +-
 drivers/md/dm-writecache.c                    |  7 ++-
 drivers/md/persistent-data/dm-btree-spine.c   |  6 +--
 .../md/persistent-data/dm-space-map-disk.c    |  9 ++--
 7 files changed, 37 insertions(+), 56 deletions(-)

diff --git a/drivers/md/dm-integrity.c b/drivers/md/dm-integrity.c
index 6a9c11abc5e3..76a518f54bd2 100644
--- a/drivers/md/dm-integrity.c
+++ b/drivers/md/dm-integrity.c
@@ -630,11 +630,10 @@ static bool block_bitmap_op(struct dm_integrity_c *ic, struct page_list *bitmap,
 	end_bit %= PAGE_SIZE * 8;
 
 repeat:
-	if (page < end_page) {
+	if (page < end_page)
 		this_end_bit = PAGE_SIZE * 8 - 1;
-	} else {
+	else
 		this_end_bit = end_bit;
-	}
 
 	data = lowmem_page_address(bitmap[page].page);
 
@@ -1251,13 +1250,12 @@ static bool add_new_range(struct dm_integrity_c *ic, struct dm_integrity_range *
 		struct dm_integrity_range *range = container_of(*n, struct dm_integrity_range, node);
 
 		parent = *n;
-		if (new_range->logical_sector + new_range->n_sectors <= range->logical_sector) {
+		if (new_range->logical_sector + new_range->n_sectors <= range->logical_sector)
 			n = &range->node.rb_left;
-		} else if (new_range->logical_sector >= range->logical_sector + range->n_sectors) {
+		else if (new_range->logical_sector >= range->logical_sector + range->n_sectors)
 			n = &range->node.rb_right;
-		} else {
+		else
 			return false;
-		}
 	}
 
 	rb_link_node(&new_range->node, parent, n);
@@ -1364,15 +1362,14 @@ static unsigned int find_journal_node(struct dm_integrity_c *ic, sector_t sector
 	while (n) {
 		struct journal_node *j = container_of(n, struct journal_node, node);
 
-		if (sector == j->sector) {
+		if (sector == j->sector)
 			found = j - ic->journal_tree;
-		}
+
 		if (sector < j->sector) {
 			*next_sector = j->sector;
 			n = j->node.rb_left;
-		} else {
+		} else
 			n = j->node.rb_right;
-		}
 	}
 
 	return found;
@@ -1501,9 +1498,8 @@ static int dm_integrity_rw_tag(struct dm_integrity_c *ic, unsigned char *tag, se
 			*metadata_offset = 0;
 		}
 
-		if (unlikely(!is_power_of_2(ic->tag_size))) {
+		if (unlikely(!is_power_of_2(ic->tag_size)))
 			hash_offset = (hash_offset + to_copy) % ic->tag_size;
-		}
 
 		total_size -= to_copy;
 	} while (unlikely(total_size));
@@ -2104,14 +2100,12 @@ static bool __journal_read_write(struct dm_integrity_io *dio, struct bio *bio,
 		smp_mb();
 		if (unlikely(waitqueue_active(&ic->copy_to_journal_wait)))
 			wake_up(&ic->copy_to_journal_wait);
-		if (READ_ONCE(ic->free_sectors) <= ic->free_sectors_threshold) {
+		if (READ_ONCE(ic->free_sectors) <= ic->free_sectors_threshold)
 			queue_work(ic->commit_wq, &ic->commit_work);
-		} else {
+		else
 			schedule_autocommit(ic);
-		}
-	} else {
+	} else
 		remove_range(ic, &dio->range);
-	}
 
 	if (unlikely(bio->bi_iter.bi_size)) {
 		sector_t area, offset;
@@ -2569,9 +2563,8 @@ static void do_journal_write(struct dm_integrity_c *ic, unsigned int write_start
 					mempool_free(io, &ic->journal_io_mempool);
 					goto skip_io;
 				}
-				for (l = j; l < k; l++) {
+				for (l = j; l < k; l++)
 					remove_journal_node(ic, &section_node[l]);
-				}
 			}
 			spin_unlock_irq(&ic->endio_wait.lock);
 
@@ -2598,9 +2591,8 @@ static void do_journal_write(struct dm_integrity_c *ic, unsigned int write_start
 				journal_entry_set_unused(je2);
 				r = dm_integrity_rw_tag(ic, journal_entry_tag(ic, je2), &metadata_block, &metadata_offset,
 							ic->tag_size, TAG_WRITE);
-				if (unlikely(r)) {
+				if (unlikely(r))
 					dm_integrity_io_error(ic, "reading tags", r);
-				}
 			}
 
 			atomic_inc(&comp.in_flight);
@@ -2711,9 +2703,9 @@ static void integrity_recalc(struct work_struct *w)
 	n_sectors = range.n_sectors;
 
 	if (ic->mode == 'B') {
-		if (block_bitmap_op(ic, ic->recalc_bitmap, logical_sector, n_sectors, BITMAP_OP_TEST_ALL_CLEAR)) {
+		if (block_bitmap_op(ic, ic->recalc_bitmap, logical_sector, n_sectors, BITMAP_OP_TEST_ALL_CLEAR))
 			goto advance_and_next;
-		}
+
 		while (block_bitmap_op(ic, ic->recalc_bitmap, logical_sector,
 				       ic->sectors_per_block, BITMAP_OP_TEST_ALL_CLEAR)) {
 			logical_sector += ic->sectors_per_block;
@@ -2732,9 +2724,9 @@ static void integrity_recalc(struct work_struct *w)
 
 	if (unlikely(++super_counter == RECALC_WRITE_SUPER)) {
 		recalc_write_super(ic);
-		if (ic->mode == 'B') {
+		if (ic->mode == 'B')
 			queue_delayed_work(ic->commit_wq, &ic->bitmap_flush_work, ic->bitmap_flush_interval);
-		}
+
 		super_counter = 0;
 	}
 
@@ -4417,9 +4409,9 @@ static int dm_integrity_ctr(struct dm_target *ti, unsigned int argc, char **argv
 
 	log2_blocks_per_bitmap_bit = log2_sectors_per_bitmap_bit - ic->sb->log2_sectors_per_block;
 	ic->log2_blocks_per_bitmap_bit = log2_blocks_per_bitmap_bit;
-	if (should_write_sb) {
+	if (should_write_sb)
 		ic->sb->log2_blocks_per_bitmap_bit = log2_blocks_per_bitmap_bit;
-	}
+
 	n_bitmap_bits = ((ic->provided_data_sectors >> ic->sb->log2_sectors_per_block)
 				+ (((sector_t)1 << log2_blocks_per_bitmap_bit) - 1)) >> log2_blocks_per_bitmap_bit;
 	ic->n_bitmap_blocks = DIV_ROUND_UP(n_bitmap_bits, BITMAP_BLOCK_SIZE * 8);
diff --git a/drivers/md/dm-stats.c b/drivers/md/dm-stats.c
index 8937bfbdcdc1..12d17b1a83a9 100644
--- a/drivers/md/dm-stats.c
+++ b/drivers/md/dm-stats.c
@@ -601,12 +601,10 @@ static void dm_stat_for_entry(struct dm_stat *s, size_t entry,
 			while (lo + 1 < hi) {
 				unsigned int mid = (lo + hi) / 2;
 
-				if (s->histogram_boundaries[mid - 1] > duration) {
+				if (s->histogram_boundaries[mid - 1] > duration)
 					hi = mid;
-				} else {
+				else
 					lo = mid;
-				}
-
 			}
 			p->histogram[lo]++;
 		}
@@ -900,9 +898,8 @@ static int dm_stats_print(struct dm_stats *stats, int id,
 		if (s->n_histogram_entries) {
 			unsigned int i;
 
-			for (i = 0; i < s->n_histogram_entries + 1; i++) {
+			for (i = 0; i < s->n_histogram_entries + 1; i++)
 				DMEMIT("%s%llu", !i ? " " : ":", shared->tmp.histogram[i]);
-			}
 		}
 		DMEMIT("\n");
 
diff --git a/drivers/md/dm-stripe.c b/drivers/md/dm-stripe.c
index caa1565e6143..e4eb729ee71a 100644
--- a/drivers/md/dm-stripe.c
+++ b/drivers/md/dm-stripe.c
@@ -369,14 +369,12 @@ static void stripe_status(struct dm_target *ti, status_type_t type,
 	switch (type) {
 	case STATUSTYPE_INFO:
 		DMEMIT("%d ", sc->stripes);
-		for (i = 0; i < sc->stripes; i++)  {
+		for (i = 0; i < sc->stripes; i++)
 			DMEMIT("%s ", sc->stripe[i].dev->name);
-		}
+
 		DMEMIT("1 ");
-		for (i = 0; i < sc->stripes; i++) {
-			DMEMIT("%c", atomic_read(&(sc->stripe[i].error_count)) ?
-			       'D' : 'A');
-		}
+		for (i = 0; i < sc->stripes; i++)
+			DMEMIT("%c", atomic_read(&(sc->stripe[i].error_count)) ?  'D' : 'A');
 		break;
 
 	case STATUSTYPE_TABLE:
diff --git a/drivers/md/dm-thin-metadata.c b/drivers/md/dm-thin-metadata.c
index 93a0ce0cfc2a..71720c8712f6 100644
--- a/drivers/md/dm-thin-metadata.c
+++ b/drivers/md/dm-thin-metadata.c
@@ -1536,9 +1536,9 @@ static int __find_block(struct dm_thin_device *td, dm_block_t block,
 	dm_block_t keys[2] = { td->id, block };
 	struct dm_btree_info *info;
 
-	if (can_issue_io) {
+	if (can_issue_io)
 		info = &pmd->info;
-	} else
+	else
 		info = &pmd->nb_info;
 
 	r = dm_btree_lookup(info, pmd->root, keys, &value);
diff --git a/drivers/md/dm-writecache.c b/drivers/md/dm-writecache.c
index 3b012dbfb069..0c89b884fe54 100644
--- a/drivers/md/dm-writecache.c
+++ b/drivers/md/dm-writecache.c
@@ -1984,9 +1984,8 @@ static void writecache_writeback(struct work_struct *work)
 			goto restart;
 	}
 
-	if (wc->overwrote_committed) {
+	if (wc->overwrote_committed)
 		writecache_wait_for_ios(wc, WRITE);
-	}
 
 	n_walked = 0;
 	INIT_LIST_HEAD(&skipped);
@@ -2015,9 +2014,9 @@ static void writecache_writeback(struct work_struct *work)
 		} else
 			e = container_of(wc->lru.prev, struct wc_entry, lru);
 		BUG_ON(e->write_in_progress);
-		if (unlikely(!writecache_entry_is_committed(wc, e))) {
+		if (unlikely(!writecache_entry_is_committed(wc, e)))
 			writecache_flush(wc);
-		}
+
 		node = rb_prev(&e->rb_node);
 		if (node) {
 			f = container_of(node, struct wc_entry, rb_node);
diff --git a/drivers/md/persistent-data/dm-btree-spine.c b/drivers/md/persistent-data/dm-btree-spine.c
index be1792d85041..f44bf974f5a5 100644
--- a/drivers/md/persistent-data/dm-btree-spine.c
+++ b/drivers/md/persistent-data/dm-btree-spine.c
@@ -133,9 +133,8 @@ void exit_ro_spine(struct ro_spine *s)
 {
 	int i;
 
-	for (i = 0; i < s->count; i++) {
+	for (i = 0; i < s->count; i++)
 		unlock_block(s->info, s->nodes[i]);
-	}
 }
 
 int ro_step(struct ro_spine *s, dm_block_t new_child)
@@ -184,9 +183,8 @@ void exit_shadow_spine(struct shadow_spine *s)
 {
 	int i;
 
-	for (i = 0; i < s->count; i++) {
+	for (i = 0; i < s->count; i++)
 		unlock_block(s->info, s->nodes[i]);
-	}
 }
 
 int shadow_step(struct shadow_spine *s, dm_block_t b,
diff --git a/drivers/md/persistent-data/dm-space-map-disk.c b/drivers/md/persistent-data/dm-space-map-disk.c
index c06d9070267f..2938080697c8 100644
--- a/drivers/md/persistent-data/dm-space-map-disk.c
+++ b/drivers/md/persistent-data/dm-space-map-disk.c
@@ -95,9 +95,8 @@ static int sm_disk_set_count(struct dm_space_map *sm, dm_block_t b,
 	struct sm_disk *smd = container_of(sm, struct sm_disk, sm);
 
 	r = sm_ll_insert(&smd->ll, b, count, &nr_allocations);
-	if (!r) {
+	if (!r)
 		smd->nr_allocated_this_transaction += nr_allocations;
-	}
 
 	return r;
 }
@@ -138,22 +137,20 @@ static int sm_disk_new_block(struct dm_space_map *sm, dm_block_t *b)
 	 * Any block we allocate has to be free in both the old and current ll.
 	 */
 	r = sm_ll_find_common_free_block(&smd->old_ll, &smd->ll, smd->begin, smd->ll.nr_blocks, b);
-	if (r == -ENOSPC) {
+	if (r == -ENOSPC)
 		/*
 		 * There's no free block between smd->begin and the end of the metadata device.
 		 * We search before smd->begin in case something has been freed.
 		 */
 		r = sm_ll_find_common_free_block(&smd->old_ll, &smd->ll, 0, smd->begin, b);
-	}
 
 	if (r)
 		return r;
 
 	smd->begin = *b + 1;
 	r = sm_ll_inc(&smd->ll, *b, *b + 1, &nr_allocations);
-	if (!r) {
+	if (!r)
 		smd->nr_allocated_this_transaction += nr_allocations;
-	}
 
 	return r;
 }
-- 
2.37.0 (Apple Git-136)

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel


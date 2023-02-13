Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2F57CC636CC
	for <dm-devel@archiver.kernel.org>; Mon, 13 Feb 2023 20:15:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1676319329;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=5LhZghOOHcrQ2et/NHIvFMHmfpTBFIXPtvMWISBpjzQ=;
	b=IUnh59jXYx7zdP/s9zKhKcBnpj12OL7X0z5FHDqexY3nLZU8b61GOnq8yxd83SYmiMoZTM
	IJ5lqRbIxN+VmLfiRixOKGBWSG7PCJnVWAmLV6mZrJdpKhB3p5BvGBplYyRudtskZ10Fun
	rxD5hmVdpMLmw8BRW5ToMl7RUK7zTjo=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-136-PFoomKTIO_uB_8U6xr4HJw-1; Mon, 13 Feb 2023 15:15:26 -0500
X-MC-Unique: PFoomKTIO_uB_8U6xr4HJw-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 5817387B2AC;
	Mon, 13 Feb 2023 20:14:58 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 100422166B29;
	Mon, 13 Feb 2023 20:14:58 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id BD7F8194658C;
	Mon, 13 Feb 2023 20:14:57 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
 [10.11.54.6])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 46A991946586
 for <dm-devel@listman.corp.redhat.com>; Mon, 13 Feb 2023 20:14:57 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 3B1E62166B29; Mon, 13 Feb 2023 20:14:57 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 33FE42166B26
 for <dm-devel@redhat.com>; Mon, 13 Feb 2023 20:14:57 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 122E61871D9F
 for <dm-devel@redhat.com>; Mon, 13 Feb 2023 20:14:57 +0000 (UTC)
Received: from mail-qv1-f52.google.com (mail-qv1-f52.google.com
 [209.85.219.52]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-508-IqJ9ZSPDM-SDxgHakWdAUA-2; Mon, 13 Feb 2023 15:14:48 -0500
X-MC-Unique: IqJ9ZSPDM-SDxgHakWdAUA-2
Received: by mail-qv1-f52.google.com with SMTP id l4so2200750qvh.11
 for <dm-devel@redhat.com>; Mon, 13 Feb 2023 12:14:48 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=content-transfer-encoding:mime-version:references:in-reply-to
 :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
 :subject:date:message-id:reply-to;
 bh=eWz+WJS38BlBvDmeLeGJ9vRyWThL5kFqCSJGOEV/H+I=;
 b=zWC2/0yGFgXaSrY9Hsnvr7sEmgBdUOVA4P9Sg6EDEPX2wAlwEtQtyiuCmKKvpVN4eM
 0f5+bkgIjRUuF9T22VUQqZi8syVtgd2RVwr9iTNGqfR7WyIpV5GKEe4PYb/pOJPTvHdu
 SxojDWdPoU5KSs/c+bT87fxbXjxPyqLETR6LLF464JlE8vfEgAUQ/Cyts1TLCXgkTN5H
 kE797IfHBlyezqRbT+bcCuHCLoFiYc4Hjc9NTpZCCsnhgVQdwgWafslFmN2AdJSubevo
 o5ToqI8r/wx6CNV5RFfBZRvHKGgODU/XO3m8m7gdomCkpCYdNvEETnByJLU3OarF7ZQP
 WHOQ==
X-Gm-Message-State: AO0yUKV53TXOcgiRuitfMDnClcHCGsx+vNjT7vpVvPTTCfda7jii7WXc
 E9vWU8HHf0pMYSPsKOFcebNKk0TzaDP5hiqzY3BCAxOglGmFDKc7mvfUz5pVmQgjH/gDA4Hzcj3
 kKW3/lnzqKJZMUDKLDxhoZjEeZ/EY45z7KXGQ0It9znbirDKkX4gFpA2yst0IX2IAc+pOaQ==
X-Google-Smtp-Source: AK7set/N/QXx0Q+G2+jAP9hdK5lTEsF11vXJYNc5Um1dyzilWC3xtc2gjHxXJ3A9j8ZW4FoG4T0MQg==
X-Received: by 2002:a05:6214:20c6:b0:56b:f6c2:48e8 with SMTP id
 6-20020a05621420c600b0056bf6c248e8mr420335qve.17.1676319287386; 
 Mon, 13 Feb 2023 12:14:47 -0800 (PST)
Received: from localhost (pool-68-160-166-30.bstnma.fios.verizon.net.
 [68.160.166.30]) by smtp.gmail.com with ESMTPSA id
 17-20020a370311000000b00706c1fc62desm10406296qkd.112.2023.02.13.12.14.46
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Mon, 13 Feb 2023 12:14:46 -0800 (PST)
From: Mike Snitzer <snitzer@kernel.org>
To: dm-devel@redhat.com
Date: Mon, 13 Feb 2023 15:13:34 -0500
Message-Id: <20230213201401.45973-13-snitzer@kernel.org>
In-Reply-To: <20230213201401.45973-1-snitzer@kernel.org>
References: <20230213201401.45973-1-snitzer@kernel.org>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.6
Subject: [dm-devel] [PATCH 12/39] dm: fix trailing statements
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
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.6
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

From: Heinz Mauelshagen <heinzm@redhat.com>

Signed-off-by: Heinz Mauelshagen <heinzm@redhat.com>
Signed-off-by: Mike Snitzer <snitzer@kernel.org>
---
 drivers/md/dm-flakey.c          |  3 +-
 drivers/md/dm-integrity.c       | 54 +++++++++++++++++----------------
 drivers/md/dm-io.c              | 26 ++++++++--------
 drivers/md/dm-snap-persistent.c | 20 ++++++------
 drivers/md/dm-snap.c            |  3 +-
 drivers/md/dm-table.c           |  3 +-
 drivers/md/dm-verity-target.c   |  6 ++--
 drivers/md/dm-writecache.c      | 12 +++++---
 8 files changed, 66 insertions(+), 61 deletions(-)

diff --git a/drivers/md/dm-flakey.c b/drivers/md/dm-flakey.c
index e4464b37732a..26ef181ac4dd 100644
--- a/drivers/md/dm-flakey.c
+++ b/drivers/md/dm-flakey.c
@@ -357,8 +357,7 @@ static int flakey_map(struct dm_target *ti, struct bio *bio)
 		if (test_bit(DROP_WRITES, &fc->flags)) {
 			bio_endio(bio);
 			return DM_MAPIO_SUBMITTED;
-		}
-		else if (test_bit(ERROR_WRITES, &fc->flags)) {
+		} else if (test_bit(ERROR_WRITES, &fc->flags)) {
 			bio_io_error(bio);
 			return DM_MAPIO_SUBMITTED;
 		}
diff --git a/drivers/md/dm-integrity.c b/drivers/md/dm-integrity.c
index ed6515411e85..f650e540a09e 100644
--- a/drivers/md/dm-integrity.c
+++ b/drivers/md/dm-integrity.c
@@ -679,16 +679,18 @@ static bool block_bitmap_op(struct dm_integrity_c *ic, struct page_list *bitmap,
 	} else if (mode == BITMAP_OP_CLEAR) {
 		if (!bit && this_end_bit == PAGE_SIZE * 8 - 1)
 			clear_page(data);
-		else while (bit <= this_end_bit) {
-			if (!(bit % BITS_PER_LONG) && this_end_bit >= bit + BITS_PER_LONG - 1) {
-				do {
-					data[bit / BITS_PER_LONG] = 0;
-					bit += BITS_PER_LONG;
-				} while (this_end_bit >= bit + BITS_PER_LONG - 1);
-				continue;
+		else {
+			while (bit <= this_end_bit) {
+				if (!(bit % BITS_PER_LONG) && this_end_bit >= bit + BITS_PER_LONG - 1) {
+					do {
+						data[bit / BITS_PER_LONG] = 0;
+						bit += BITS_PER_LONG;
+					} while (this_end_bit >= bit + BITS_PER_LONG - 1);
+					continue;
+				}
+				__clear_bit(bit, data);
+				bit++;
 			}
-			__clear_bit(bit, data);
-			bit++;
 		}
 	} else {
 		BUG();
@@ -2010,23 +2012,23 @@ static bool __journal_read_write(struct dm_integrity_io *dio, struct bio *bio,
 				unsigned int tag_todo = ic->tag_size;
 				char *tag_ptr = journal_entry_tag(ic, je);
 
-				if (bip) do {
-					struct bio_vec biv = bvec_iter_bvec(bip->bip_vec, bip->bip_iter);
-					unsigned int tag_now = min(biv.bv_len, tag_todo);
-					char *tag_addr;
-					BUG_ON(PageHighMem(biv.bv_page));
-					tag_addr = bvec_virt(&biv);
-					if (likely(dio->op == REQ_OP_WRITE))
-						memcpy(tag_ptr, tag_addr, tag_now);
-					else
-						memcpy(tag_addr, tag_ptr, tag_now);
-					bvec_iter_advance(bip->bip_vec, &bip->bip_iter, tag_now);
-					tag_ptr += tag_now;
-					tag_todo -= tag_now;
-				} while (unlikely(tag_todo)); else {
-					if (likely(dio->op == REQ_OP_WRITE))
-						memset(tag_ptr, 0, tag_todo);
-				}
+				if (bip) {
+					do {
+						struct bio_vec biv = bvec_iter_bvec(bip->bip_vec, bip->bip_iter);
+						unsigned int tag_now = min(biv.bv_len, tag_todo);
+						char *tag_addr;
+						BUG_ON(PageHighMem(biv.bv_page));
+						tag_addr = bvec_virt(&biv);
+						if (likely(dio->op == REQ_OP_WRITE))
+							memcpy(tag_ptr, tag_addr, tag_now);
+						else
+							memcpy(tag_addr, tag_ptr, tag_now);
+						bvec_iter_advance(bip->bip_vec, &bip->bip_iter, tag_now);
+						tag_ptr += tag_now;
+						tag_todo -= tag_now;
+					} while (unlikely(tag_todo));
+				} else if (likely(dio->op == REQ_OP_WRITE))
+					memset(tag_ptr, 0, tag_todo);
 			}
 
 			if (likely(dio->op == REQ_OP_WRITE)) {
diff --git a/drivers/md/dm-io.c b/drivers/md/dm-io.c
index 9e0ef8bbd7e9..1c04cc9787d1 100644
--- a/drivers/md/dm-io.c
+++ b/drivers/md/dm-io.c
@@ -359,18 +359,20 @@ static void do_region(const blk_opf_t opf, unsigned int region,
 			num_sectors = min_t(sector_t, special_cmd_max_sectors, remaining);
 			bio->bi_iter.bi_size = num_sectors << SECTOR_SHIFT;
 			remaining -= num_sectors;
-		} else while (remaining) {
-			/*
-			 * Try and add as many pages as possible.
-			 */
-			dp->get_page(dp, &page, &len, &offset);
-			len = min(len, to_bytes(remaining));
-			if (!bio_add_page(bio, page, len, offset))
-				break;
-
-			offset = 0;
-			remaining -= to_sector(len);
-			dp->next_page(dp);
+		} else {
+			while (remaining) {
+				/*
+				 * Try and add as many pages as possible.
+				 */
+				dp->get_page(dp, &page, &len, &offset);
+				len = min(len, to_bytes(remaining));
+				if (!bio_add_page(bio, page, len, offset))
+					break;
+
+				offset = 0;
+				remaining -= to_sector(len);
+				dp->next_page(dp);
+			}
 		}
 
 		atomic_inc(&io->count);
diff --git a/drivers/md/dm-snap-persistent.c b/drivers/md/dm-snap-persistent.c
index c05e398d43d7..0877285a0514 100644
--- a/drivers/md/dm-snap-persistent.c
+++ b/drivers/md/dm-snap-persistent.c
@@ -518,15 +518,17 @@ static int read_exceptions(struct pstore *ps,
 		if (unlikely(prefetch_area < ps->current_area))
 			prefetch_area = ps->current_area;
 
-		if (DM_PREFETCH_CHUNKS) do {
-			chunk_t pf_chunk = area_location(ps, prefetch_area);
-			if (unlikely(pf_chunk >= dm_bufio_get_device_size(client)))
-				break;
-			dm_bufio_prefetch(client, pf_chunk, 1);
-			prefetch_area++;
-			if (unlikely(!prefetch_area))
-				break;
-		} while (prefetch_area <= ps->current_area + DM_PREFETCH_CHUNKS);
+		if (DM_PREFETCH_CHUNKS) {
+			do {
+				chunk_t pf_chunk = area_location(ps, prefetch_area);
+				if (unlikely(pf_chunk >= dm_bufio_get_device_size(client)))
+					break;
+				dm_bufio_prefetch(client, pf_chunk, 1);
+				prefetch_area++;
+				if (unlikely(!prefetch_area))
+					break;
+			} while (prefetch_area <= ps->current_area + DM_PREFETCH_CHUNKS);
+		}
 
 		chunk = area_location(ps, ps->current_area);
 
diff --git a/drivers/md/dm-snap.c b/drivers/md/dm-snap.c
index 35c648ef2162..3357731c9db8 100644
--- a/drivers/md/dm-snap.c
+++ b/drivers/md/dm-snap.c
@@ -2345,8 +2345,7 @@ static void snapshot_status(struct dm_target *ti, status_type_t type,
 				       (unsigned long long)sectors_allocated,
 				       (unsigned long long)total_sectors,
 				       (unsigned long long)metadata_sectors);
-			}
-			else
+			} else
 				DMEMIT("Unknown");
 		}
 
diff --git a/drivers/md/dm-table.c b/drivers/md/dm-table.c
index 6cb7c2afd2d3..58b9198b1c78 100644
--- a/drivers/md/dm-table.c
+++ b/drivers/md/dm-table.c
@@ -1974,8 +1974,7 @@ int dm_table_set_restrictions(struct dm_table *t, struct request_queue *q,
 		blk_queue_flag_set(QUEUE_FLAG_DAX, q);
 		if (dm_table_supports_dax(t, device_not_dax_synchronous_capable))
 			set_dax_synchronous(t->md->dax_dev);
-	}
-	else
+	} else
 		blk_queue_flag_clear(QUEUE_FLAG_DAX, q);
 
 	if (dm_table_any_dev_attr(t, device_dax_write_cache_enabled, NULL))
diff --git a/drivers/md/dm-verity-target.c b/drivers/md/dm-verity-target.c
index c9d937053910..99a5b0dc99af 100644
--- a/drivers/md/dm-verity-target.c
+++ b/drivers/md/dm-verity-target.c
@@ -332,10 +332,8 @@ static int verity_verify_level(struct dm_verity *v, struct dm_verity_io *io,
 			 */
 			r = -EAGAIN;
 			goto release_ret_r;
-		}
-		else if (verity_fec_decode(v, io,
-					   DM_VERITY_BLOCK_TYPE_METADATA,
-					   hash_block, data, NULL) == 0)
+		} else if (verity_fec_decode(v, io, DM_VERITY_BLOCK_TYPE_METADATA,
+					     hash_block, data, NULL) == 0)
 			aux->hash_verified = 1;
 		else if (verity_handle_err(v,
 					   DM_VERITY_BLOCK_TYPE_METADATA,
diff --git a/drivers/md/dm-writecache.c b/drivers/md/dm-writecache.c
index 78c55fbb660f..973e0464fc67 100644
--- a/drivers/md/dm-writecache.c
+++ b/drivers/md/dm-writecache.c
@@ -941,7 +941,8 @@ static void writecache_suspend(struct dm_target *ti)
 	wc_lock(wc);
 	if (flush_on_suspend)
 		wc->writeback_all--;
-	while (writecache_wait_for_writeback(wc));
+	while (writecache_wait_for_writeback(wc))
+		;
 
 	if (WC_MODE_PMEM(wc))
 		persistent_memory_flush_cache(wc->memory_map, wc->memory_map_size);
@@ -2090,7 +2091,8 @@ static void writecache_writeback(struct work_struct *work)
 
 	if (unlikely(wc->writeback_all)) {
 		wc_lock(wc);
-		while (writecache_wait_for_writeback(wc));
+		while (writecache_wait_for_writeback(wc))
+			;
 		wc_unlock(wc);
 	}
 }
@@ -2448,12 +2450,14 @@ static int writecache_ctr(struct dm_target *ti, unsigned int argc, char **argv)
 			if (WC_MODE_PMEM(wc)) {
 				wc->writeback_fua = true;
 				wc->writeback_fua_set = true;
-			} else goto invalid_optional;
+			} else
+				goto invalid_optional;
 		} else if (!strcasecmp(string, "nofua")) {
 			if (WC_MODE_PMEM(wc)) {
 				wc->writeback_fua = false;
 				wc->writeback_fua_set = true;
-			} else goto invalid_optional;
+			} else
+				goto invalid_optional;
 		} else if (!strcasecmp(string, "metadata_only")) {
 			wc->metadata_only = true;
 		} else if (!strcasecmp(string, "pause_writeback") && opt_params >= 1) {
-- 
2.37.0 (Apple Git-136)

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel


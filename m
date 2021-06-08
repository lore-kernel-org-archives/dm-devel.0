Return-Path: <SRS0=BzfN=LC=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1192DC4743D
	for <dm-devel@archiver.kernel.org>; Tue,  8 Jun 2021 19:05:19 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id A47B761352
	for <dm-devel@archiver.kernel.org>; Tue,  8 Jun 2021 19:05:18 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org A47B761352
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1623179117;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=rgDNlSKF3GYtNgMbqnw5+P5g/zj5/R8Pqf6t9AJBN9U=;
	b=eR/losW5Mu1sAfpeZrrOcUT17elmmRuTbo7AiftDJoG6AxL7eX09sDwVWygagzmAB37WTm
	/Tf9rhRthCm+gken+Myz82cHcC/72nVXHzW3B2BMfR9UzETvoqiZsSR2ZKUN4dgk6Gt1sM
	UEYDeb74WHYuA2rMrE97YzCTadxHqmU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-239-g3pQU5_lMPWtTY9SY_pOHQ-1; Tue, 08 Jun 2021 15:05:15 -0400
X-MC-Unique: g3pQU5_lMPWtTY9SY_pOHQ-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 5042E107ACC7;
	Tue,  8 Jun 2021 19:05:10 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id EDCF31002EF0;
	Tue,  8 Jun 2021 19:05:09 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 32A3C44A59;
	Tue,  8 Jun 2021 19:05:09 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com
	[10.5.11.12])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 158J58CR002671 for <dm-devel@listman.util.phx.redhat.com>;
	Tue, 8 Jun 2021 15:05:08 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 8F0C960CC6; Tue,  8 Jun 2021 19:05:08 +0000 (UTC)
Received: from file01.intranet.prod.int.rdu2.redhat.com
	(file01.intranet.prod.int.rdu2.redhat.com [10.11.5.7])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 266BE60C04;
	Tue,  8 Jun 2021 19:05:05 +0000 (UTC)
Received: from file01.intranet.prod.int.rdu2.redhat.com (localhost [127.0.0.1])
	by file01.intranet.prod.int.rdu2.redhat.com (8.14.4/8.14.4) with ESMTP
	id 158J54Bj018361; Tue, 8 Jun 2021 15:05:04 -0400
Received: from localhost (mpatocka@localhost)
	by file01.intranet.prod.int.rdu2.redhat.com (8.14.4/8.14.4/Submit) with
	ESMTP id 158J54QR018357; Tue, 8 Jun 2021 15:05:04 -0400
X-Authentication-Warning: file01.intranet.prod.int.rdu2.redhat.com: mpatocka
	owned process doing -bs
Date: Tue, 8 Jun 2021 15:05:04 -0400 (EDT)
From: Mikulas Patocka <mpatocka@redhat.com>
X-X-Sender: mpatocka@file01.intranet.prod.int.rdu2.redhat.com
To: Mike Snitzer <msnitzer@redhat.com>, Joe Thornber <thornber@redhat.com>
Message-ID: <alpine.LRH.2.02.2106081252030.5119@file01.intranet.prod.int.rdu2.redhat.com>
User-Agent: Alpine 2.02 (LRH 1266 2009-07-14)
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
X-loop: dm-devel@redhat.com
Cc: dm-devel@redhat.com
Subject: [dm-devel] [PATCH] dm-writecache: avoid kcopyd and use open-coded
 variant instead
X-BeenThere: dm-devel@redhat.com
X-Mailman-Version: 2.1.12
Precedence: junk
List-Id: device-mapper development <dm-devel.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Hi

This is a patch that removes kcopyd usage from dm-writecache and replaces 
it with open-coded implementation.

On my system (SATA300 disk + ssd), it is slower than the explicit kcopyd 
support. Test it, if it helps on your system with NVME ssd.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>

Index: linux-2.6/drivers/md/dm-writecache.c
===================================================================
--- linux-2.6.orig/drivers/md/dm-writecache.c
+++ linux-2.6/drivers/md/dm-writecache.c
@@ -11,7 +11,6 @@
 #include <linux/vmalloc.h>
 #include <linux/kthread.h>
 #include <linux/dm-io.h>
-#include <linux/dm-kcopyd.h>
 #include <linux/dax.h>
 #include <linux/pfn_t.h>
 #include <linux/libnvdimm.h>
@@ -181,6 +180,7 @@ struct dm_writecache {
 	struct workqueue_struct *writeback_wq;
 	struct work_struct writeback_work;
 	struct work_struct flush_work;
+	struct workqueue_struct *copy_wq;
 
 	struct dm_io_client *dm_io;
 
@@ -191,12 +191,11 @@ struct dm_writecache {
 	struct task_struct *flush_thread;
 	struct bio_list flush_list;
 
-	struct dm_kcopyd_client *dm_kcopyd;
 	unsigned long *dirty_bitmap;
 	unsigned dirty_bitmap_size;
 
 	struct bio_set bio_set;
-	mempool_t copy_pool;
+	mempool_t page_pool;
 };
 
 #define WB_LIST_INLINE		16
@@ -214,13 +213,11 @@ struct copy_struct {
 	struct list_head endio_entry;
 	struct dm_writecache *wc;
 	struct wc_entry *e;
-	unsigned n_entries;
-	int error;
+	unsigned bytes;
+	struct work_struct copy_work;
+	struct bio bio;
 };
 
-DECLARE_DM_KCOPYD_THROTTLE_WITH_MODULE_PARM(dm_writecache_throttle,
-					    "A percentage of time allocated for data copying");
-
 static void wc_lock(struct dm_writecache *wc)
 {
 	mutex_lock(&wc->lock);
@@ -1530,20 +1527,6 @@ static void writecache_writeback_endio(s
 	raw_spin_unlock_irqrestore(&wc->endio_list_lock, flags);
 }
 
-static void writecache_copy_endio(int read_err, unsigned long write_err, void *ptr)
-{
-	struct copy_struct *c = ptr;
-	struct dm_writecache *wc = c->wc;
-
-	c->error = likely(!(read_err | write_err)) ? 0 : -EIO;
-
-	raw_spin_lock_irq(&wc->endio_list_lock);
-	if (unlikely(list_empty(&wc->endio_list)))
-		wake_up_process(wc->endio_thread);
-	list_add_tail(&c->endio_entry, &wc->endio_list);
-	raw_spin_unlock_irq(&wc->endio_list_lock);
-}
-
 static void __writecache_endio_pmem(struct dm_writecache *wc, struct list_head *list)
 {
 	unsigned i;
@@ -1585,17 +1568,16 @@ static void __writecache_endio_pmem(stru
 
 static void __writecache_endio_ssd(struct dm_writecache *wc, struct list_head *list)
 {
-	struct copy_struct *c;
-	struct wc_entry *e;
-
 	do {
-		c = list_entry(list->next, struct copy_struct, endio_entry);
-		list_del(&c->endio_entry);
+		struct copy_struct *cs;
+		struct wc_entry *e;
+		struct bio *bio;
+		unsigned idx;
 
-		if (unlikely(c->error))
-			writecache_error(wc, c->error, "copy error");
+		cs = list_entry(list->next, struct copy_struct, endio_entry);
+		list_del(&cs->endio_entry);
 
-		e = c->e;
+		e = cs->e;
 		do {
 			BUG_ON(!e->write_in_progress);
 			e->write_in_progress = false;
@@ -1606,8 +1588,14 @@ static void __writecache_endio_ssd(struc
 			BUG_ON(!wc->writeback_size);
 			wc->writeback_size--;
 			e++;
-		} while (--c->n_entries);
-		mempool_free(c, &wc->copy_pool);
+		} while (cs->bytes -= wc->block_size);
+		bio = &cs->bio;
+		for (idx = 0; idx < bio->bi_vcnt; idx++) {
+			unsigned p;
+			for (p = 0; p < bio->bi_io_vec[idx].bv_len >> PAGE_SHIFT; p++)
+				mempool_free(bio->bi_io_vec[idx].bv_page + p, &wc->page_pool);
+		}
+		bio_put(bio);
 	} while (!list_empty(list));
 }
 
@@ -1752,34 +1740,89 @@ static void __writecache_writeback_pmem(
 	}
 }
 
+static void writecache_write_endio(struct bio *bio)
+{
+	struct copy_struct *cs = container_of(bio, struct copy_struct, bio);
+	struct dm_writecache *wc = cs->wc;
+	unsigned long flags;
+
+	if (unlikely(bio->bi_status != BLK_STS_OK))
+		writecache_error(wc, blk_status_to_errno(bio->bi_status),
+				"write error %d", bio->bi_status);
+
+	raw_spin_lock_irqsave(&wc->endio_list_lock, flags);
+	if (unlikely(list_empty(&wc->endio_list)))
+		wake_up_process(wc->endio_thread);
+	list_add_tail(&cs->endio_entry, &wc->endio_list);
+	raw_spin_unlock_irqrestore(&wc->endio_list_lock, flags);
+}
+
+static void writecache_copy_write(struct work_struct *copy)
+{
+	struct copy_struct *cs = container_of(copy, struct copy_struct, copy_work);
+	struct bio *bio = &cs->bio;
+	struct dm_writecache *wc = cs->wc;
+	unsigned vcnt;
+	if (unlikely(bio->bi_status != BLK_STS_OK)) {
+		writecache_error(wc, blk_status_to_errno(bio->bi_status),
+				"read error %d", bio->bi_status);
+		bio->bi_status = BLK_STS_OK;
+		writecache_write_endio(bio);
+		return;
+	}
+	vcnt = bio->bi_vcnt;
+	bio_reset(bio);
+	bio->bi_vcnt = vcnt;
+	bio->bi_end_io = writecache_write_endio;
+	bio_set_dev(bio, wc->dev->bdev);
+	bio->bi_iter.bi_sector = read_original_sector(wc, cs->e);
+	bio->bi_iter.bi_size = cs->bytes;
+	bio_set_op_attrs(bio, REQ_OP_WRITE, WC_MODE_FUA(wc) * REQ_FUA);
+	submit_bio(bio);
+}
+
+static void writecache_read_endio(struct bio *bio)
+{
+	struct copy_struct *cs = container_of(bio, struct copy_struct, bio);
+	struct dm_writecache *wc = cs->wc;
+	queue_work(wc->copy_wq, &cs->copy_work);
+}
+
 static void __writecache_writeback_ssd(struct dm_writecache *wc, struct writeback_list *wbl)
 {
 	struct wc_entry *e, *f;
-	struct dm_io_region from, to;
-	struct copy_struct *c;
+	struct bio *bio;
+	struct copy_struct *cs;
 
 	while (wbl->size) {
-		unsigned n_sectors;
+		unsigned n_bytes, n_pages, i;
 
 		wbl->size--;
 		e = container_of(wbl->list.prev, struct wc_entry, lru);
 		list_del(&e->lru);
 
-		n_sectors = e->wc_list_contiguous << (wc->block_size_bits - SECTOR_SHIFT);
+		n_bytes = e->wc_list_contiguous << wc->block_size_bits;
+		n_pages = (n_bytes + PAGE_SIZE - 1) >> PAGE_SHIFT;
 
-		from.bdev = wc->ssd_dev->bdev;
-		from.sector = cache_sector(wc, e);
-		from.count = n_sectors;
-		to.bdev = wc->dev->bdev;
-		to.sector = read_original_sector(wc, e);
-		to.count = n_sectors;
-
-		c = mempool_alloc(&wc->copy_pool, GFP_NOIO);
-		c->wc = wc;
-		c->e = e;
-		c->n_entries = e->wc_list_contiguous;
+		bio = bio_alloc_bioset(GFP_NOIO, n_pages, &wc->bio_set);
+		cs = container_of(bio, struct copy_struct, bio);
+		cs->wc = wc;
+		cs->e = e;
+		cs->bytes = n_bytes;
+		INIT_WORK(&cs->copy_work, writecache_copy_write);
+		bio->bi_end_io = writecache_read_endio;
+		bio_set_dev(bio, wc->ssd_dev->bdev);
+		bio->bi_iter.bi_sector = cache_sector(wc, e);
+
+		for (i = 0; i < n_bytes; i += PAGE_SIZE) {
+			struct page *p;
+			unsigned len;
+			p = mempool_alloc(&wc->page_pool, GFP_NOIO);
+			len = min((unsigned)PAGE_SIZE, n_bytes - i);
+			bio_add_page(bio, p, len, 0);
+		}
 
-		while ((n_sectors -= wc->block_size >> SECTOR_SHIFT)) {
+		while ((n_bytes -= wc->block_size)) {
 			wbl->size--;
 			f = container_of(wbl->list.prev, struct wc_entry, lru);
 			BUG_ON(f != e + 1);
@@ -1787,15 +1830,8 @@ static void __writecache_writeback_ssd(s
 			e = f;
 		}
 
-		if (unlikely(to.sector + to.count > wc->data_device_sectors)) {
-			if (to.sector >= wc->data_device_sectors) {
-				writecache_copy_endio(0, 0, c);
-				continue;
-			}
-			from.count = to.count = wc->data_device_sectors - to.sector;
-		}
-
-		dm_kcopyd_copy(wc->dm_kcopyd, &from, 1, &to, 0, writecache_copy_endio, c);
+		bio_set_op_attrs(bio, REQ_OP_READ, 0);
+		submit_bio(bio);
 
 		__writeback_throttle(wc, wbl);
 	}
@@ -1811,8 +1847,7 @@ static void writecache_writeback(struct
 	struct writeback_list wbl;
 	unsigned long n_walked;
 
-	if (!WC_MODE_PMEM(wc))
-		dm_kcopyd_wait_if_busy(wc->dm_kcopyd);
+	//flush_workqueue(wc->copy_wq);
 
 	wc_lock(wc);
 restart:
@@ -2040,11 +2075,14 @@ static void writecache_dtr(struct dm_tar
 
 	bioset_exit(&wc->bio_set);
 
-	mempool_exit(&wc->copy_pool);
+	mempool_exit(&wc->page_pool);
 
 	if (wc->writeback_wq)
 		destroy_workqueue(wc->writeback_wq);
 
+	if (wc->copy_wq)
+		destroy_workqueue(wc->copy_wq);
+
 	if (wc->dev)
 		dm_put_device(ti, wc->dev);
 
@@ -2060,9 +2098,6 @@ static void writecache_dtr(struct dm_tar
 			vfree(wc->memory_map);
 	}
 
-	if (wc->dm_kcopyd)
-		dm_kcopyd_client_destroy(wc->dm_kcopyd);
-
 	if (wc->dm_io)
 		dm_io_client_destroy(wc->dm_io);
 
@@ -2168,20 +2203,12 @@ static int writecache_ctr(struct dm_targ
 		goto bad_arguments;
 	}
 
-	if (WC_MODE_PMEM(wc)) {
-		r = bioset_init(&wc->bio_set, BIO_POOL_SIZE,
-				offsetof(struct writeback_struct, bio),
-				BIOSET_NEED_BVECS);
-		if (r) {
-			ti->error = "Could not allocate bio set";
-			goto bad;
-		}
-	} else {
-		r = mempool_init_kmalloc_pool(&wc->copy_pool, 1, sizeof(struct copy_struct));
-		if (r) {
-			ti->error = "Could not allocate mempool";
-			goto bad;
-		}
+	r = bioset_init(&wc->bio_set, BIO_POOL_SIZE,
+			offsetof(struct writeback_struct, bio),
+			BIOSET_NEED_BVECS);
+	if (r) {
+		ti->error = "Could not allocate bio set";
+		goto bad;
 	}
 
 	/*
@@ -2343,6 +2370,19 @@ invalid_optional:
 		size_t n_blocks, n_metadata_blocks;
 		uint64_t n_bitmap_bits;
 
+		r = mempool_init_page_pool(&wc->page_pool, (wc->block_size * BIO_MAX_VECS + PAGE_SIZE - 1) >> PAGE_SHIFT, 0);
+		if (r) {
+			ti->error = "Unable to allocate mempool";
+			goto bad;
+		}
+
+		wc->copy_wq = alloc_workqueue("writecache-copy", WQ_MEM_RECLAIM, 1);
+		if (!wc->copy_wq) {
+			r = -ENOMEM;
+			ti->error = "Could not allocate copy workqueue";
+			goto bad;
+		}
+
 		wc->memory_map_size -= (uint64_t)wc->start_sector << SECTOR_SHIFT;
 
 		bio_list_init(&wc->flush_list);
@@ -2378,14 +2418,6 @@ invalid_optional:
 			goto bad;
 		}
 
-		wc->dm_kcopyd = dm_kcopyd_client_create(&dm_kcopyd_throttle);
-		if (IS_ERR(wc->dm_kcopyd)) {
-			r = PTR_ERR(wc->dm_kcopyd);
-			ti->error = "Unable to allocate dm-kcopyd client";
-			wc->dm_kcopyd = NULL;
-			goto bad;
-		}
-
 		wc->metadata_sectors = n_metadata_blocks << (wc->block_size_bits - SECTOR_SHIFT);
 		wc->dirty_bitmap_size = (n_bitmap_bits + BITS_PER_LONG - 1) /
 			BITS_PER_LONG * sizeof(unsigned long);

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel


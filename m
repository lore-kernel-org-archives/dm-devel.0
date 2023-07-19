Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B26E0C0015E
	for <dm-devel@archiver.kernel.org>; Wed, 19 Jul 2023 20:20:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1689798023;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=q/ToTBUf+t6tnnAbSNjMB4dckEqDqCYSL8gcp2XbbpI=;
	b=iwboRw8CGQxQ7HqxN6PXeULwvI+Bfr3jp+1Q2rHpA2jJ8Yl+plsiHwNbes+V9SHWz0Ea+S
	pQG4t0oLTq/qUx+dakrYr9UogfMy5pHHLG6EXprVA1RCNFi6j2jENXyXmYn53TrczyTxLq
	TBE3wdNxe6Z3VKssTR+Ph15h3bb1VYA=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-442-8Q8nwYQFMe2JCdRvqeT4YA-1; Wed, 19 Jul 2023 16:20:22 -0400
X-MC-Unique: 8Q8nwYQFMe2JCdRvqeT4YA-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 307998F1843;
	Wed, 19 Jul 2023 20:20:19 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 1E8E51121314;
	Wed, 19 Jul 2023 20:20:19 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id CD74719465B9;
	Wed, 19 Jul 2023 20:20:18 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
 [10.11.54.6])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 249F619465A4
 for <dm-devel@listman.corp.redhat.com>; Wed, 19 Jul 2023 20:20:18 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 0F8B72166B27; Wed, 19 Jul 2023 20:20:18 +0000 (UTC)
Received: from file1-rdu.file-001.prod.rdu2.dc.redhat.com (unknown
 [10.11.5.21])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id EB1CA2166B25;
 Wed, 19 Jul 2023 20:20:17 +0000 (UTC)
Received: by file1-rdu.file-001.prod.rdu2.dc.redhat.com (Postfix,
 from userid 12668)
 id E503A3096A42; Wed, 19 Jul 2023 20:20:17 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
 by file1-rdu.file-001.prod.rdu2.dc.redhat.com (Postfix) with ESMTP id
 E416C3F7CF; Wed, 19 Jul 2023 22:20:17 +0200 (CEST)
Date: Wed, 19 Jul 2023 22:20:17 +0200 (CEST)
From: Mikulas Patocka <mpatocka@redhat.com>
To: Jens Axboe <axboe@kernel.dk>
Message-ID: <3fcf222-4894-992-ae81-c72ca983d82@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.6
Subject: [dm-devel] [PATCH 2/3] brd: enable discard
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
Cc: Christoph Hellwig <hch@infradead.org>, Li Nan <linan666@huaweicloud.com>,
 dm-devel@redhat.com, linux-block@vger.kernel.org,
 Zdenek Kabelac <zkabelac@redhat.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

This patch implements discard in the brd driver. We use RCU to free the
page, so that if there are any concurrent readers or writes, they won't
touch the page after it is freed.

Note that we replace "BUG_ON(!page);" with "if (page) ..." in copy_to_brd
- the page can't be NULL under normal circumstances, it can only be NULL
if REQ_OP_WRITE races with REQ_OP_DISCARD. If these two bios race with
each other on the same page, the result is undefined, so we can handle
this race condition just by skipping the copying.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>

---
 drivers/block/brd.c |   85 +++++++++++++++++++++++++++++++++++++++++++++-------
 1 file changed, 74 insertions(+), 11 deletions(-)

Index: linux-2.6/drivers/block/brd.c
===================================================================
--- linux-2.6.orig/drivers/block/brd.c
+++ linux-2.6/drivers/block/brd.c
@@ -46,6 +46,8 @@ struct brd_device {
 	u64			brd_nr_pages;
 };
 
+static bool discard;
+
 /*
  * Look up and return a brd's page for a given sector.
  */
@@ -100,6 +102,26 @@ static int brd_insert_page(struct brd_de
 	return ret;
 }
 
+static void brd_free_page_rcu(struct rcu_head *head)
+{
+	struct page *page = container_of(head, struct page, rcu_head);
+	__free_page(page);
+}
+
+static void brd_free_page(struct brd_device *brd, sector_t sector)
+{
+	struct page *page;
+	pgoff_t idx;
+
+	idx = sector >> PAGE_SECTORS_SHIFT;
+	page = xa_erase(&brd->brd_pages, idx);
+
+	if (page) {
+		BUG_ON(page->index != idx);
+		call_rcu(&page->rcu_head, brd_free_page_rcu);
+	}
+}
+
 /*
  * Free all backing store pages and xarray. This must only be called when
  * there are no other users of the device.
@@ -152,11 +174,11 @@ static void copy_to_brd(struct brd_devic
 	copy = min_t(size_t, n, PAGE_SIZE - offset);
 	rcu_read_lock();
 	page = brd_lookup_page(brd, sector);
-	BUG_ON(!page);
-
-	dst = kmap_atomic(page);
-	memcpy(dst + offset, src, copy);
-	kunmap_atomic(dst);
+	if (page) {
+		dst = kmap_atomic(page);
+		memcpy(dst + offset, src, copy);
+		kunmap_atomic(dst);
+	}
 	rcu_read_unlock();
 
 	if (copy < n) {
@@ -165,11 +187,11 @@ static void copy_to_brd(struct brd_devic
 		copy = n - copy;
 		rcu_read_lock();
 		page = brd_lookup_page(brd, sector);
-		BUG_ON(!page);
-
-		dst = kmap_atomic(page);
-		memcpy(dst, src, copy);
-		kunmap_atomic(dst);
+		if (page) {
+			dst = kmap_atomic(page);
+			memcpy(dst, src, copy);
+			kunmap_atomic(dst);
+		}
 		rcu_read_unlock();
 	}
 }
@@ -248,13 +270,44 @@ out:
 	return err;
 }
 
+void brd_do_discard(struct brd_device *brd, struct bio *bio)
+{
+	sector_t sector, len, front_pad;
+
+	if (unlikely(!discard)) {
+		bio->bi_status = BLK_STS_NOTSUPP;
+		return;
+	}
+
+	sector = bio->bi_iter.bi_sector;
+	len = bio_sectors(bio);
+	front_pad = -sector & (PAGE_SECTORS - 1);
+	sector += front_pad;
+	if (unlikely(len <= front_pad))
+		return;
+	len -= front_pad;
+	len = round_down(len, PAGE_SECTORS);
+	while (len) {
+		brd_free_page(brd, sector);
+		sector += PAGE_SECTORS;
+		len -= PAGE_SECTORS;
+		cond_resched();
+	}
+}
+
 static void brd_submit_bio(struct bio *bio)
 {
 	struct brd_device *brd = bio->bi_bdev->bd_disk->private_data;
-	sector_t sector = bio->bi_iter.bi_sector;
+	sector_t sector;
 	struct bio_vec bvec;
 	struct bvec_iter iter;
 
+	if (bio_op(bio) == REQ_OP_DISCARD) {
+		brd_do_discard(brd, bio);
+		goto endio;
+	}
+
+	sector = bio->bi_iter.bi_sector;
 	bio_for_each_segment(bvec, bio, iter) {
 		unsigned int len = bvec.bv_len;
 		int err;
@@ -276,6 +329,7 @@ static void brd_submit_bio(struct bio *b
 		sector += len >> SECTOR_SHIFT;
 	}
 
+endio:
 	bio_endio(bio);
 }
 
@@ -299,6 +353,10 @@ static int max_part = 1;
 module_param(max_part, int, 0444);
 MODULE_PARM_DESC(max_part, "Num Minors to reserve between devices");
 
+static bool discard = false;
+module_param(discard, bool, 0444);
+MODULE_PARM_DESC(discard, "Support discard");
+
 MODULE_LICENSE("GPL");
 MODULE_ALIAS_BLOCKDEV_MAJOR(RAMDISK_MAJOR);
 MODULE_ALIAS("rd");
@@ -364,6 +422,11 @@ static int brd_alloc(int i)
 	 */
 	blk_queue_physical_block_size(disk->queue, PAGE_SIZE);
 
+	if (discard) {
+		disk->queue->limits.discard_granularity = PAGE_SIZE;
+		blk_queue_max_discard_sectors(disk->queue, round_down(UINT_MAX, PAGE_SECTORS));
+	}
+
 	/* Tell the block layer that this is not a rotational device */
 	blk_queue_flag_set(QUEUE_FLAG_NONROT, disk->queue);
 	blk_queue_flag_set(QUEUE_FLAG_SYNCHRONOUS, disk->queue);
--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel


Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CE504C0015E
	for <dm-devel@archiver.kernel.org>; Fri, 21 Jul 2023 13:50:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1689947441;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=iMkncd3vbrj3s4kZrnu6cwaqcLszVrFuTvht2zo+1HU=;
	b=X0kG9q8G6J780/0ezoREC6vEvkoTXwG21pKyPkvr394ngASJEHy4XGRacZTFPsIAnvf6/w
	tTjjXmgPGbA0p7PoXtxIboZzg4FLT4JQLwCanKs1FaUKG5Z1cKTNRDvDPnwMIXdtgYMRT5
	NLis8kuiJw5Pb6hCOsdYq9SOpzCUP2o=
Received: from mimecast-mx02.redhat.com (66.187.233.73 [66.187.233.73]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-84-lvaMa4YyO6aoS93x-eB57w-1; Fri, 21 Jul 2023 09:50:40 -0400
X-MC-Unique: lvaMa4YyO6aoS93x-eB57w-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 0985C1C0434C;
	Fri, 21 Jul 2023 13:50:38 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id EBFC8C57969;
	Fri, 21 Jul 2023 13:50:37 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id B306E1946A43;
	Fri, 21 Jul 2023 13:50:37 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com
 [10.11.54.9])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id AE6BB1946586
 for <dm-devel@listman.corp.redhat.com>; Fri, 21 Jul 2023 13:50:35 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 9C8FA492CAC; Fri, 21 Jul 2023 13:50:35 +0000 (UTC)
Received: from file1-rdu.file-001.prod.rdu2.dc.redhat.com (unknown
 [10.11.5.21])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 896A7492B02;
 Fri, 21 Jul 2023 13:50:35 +0000 (UTC)
Received: by file1-rdu.file-001.prod.rdu2.dc.redhat.com (Postfix,
 from userid 12668)
 id 327CD30C0457; Fri, 21 Jul 2023 13:50:11 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
 by file1-rdu.file-001.prod.rdu2.dc.redhat.com (Postfix) with ESMTP id
 319AE3FB76; Fri, 21 Jul 2023 15:50:11 +0200 (CEST)
Date: Fri, 21 Jul 2023 15:50:11 +0200 (CEST)
From: Mikulas Patocka <mpatocka@redhat.com>
To: Jens Axboe <axboe@kernel.dk>
Message-ID: <5ae07138-8840-26b1-12a3-bab2ad57c558@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.9
Subject: [dm-devel] [PATCH v2 2/3] brd: enable discard
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
Cc: linux-block@vger.kernel.org, Chaitanya Kulkarni <chaitanyak@nvidia.com>,
 Christoph Hellwig <hch@infradead.org>, Li Nan <linan666@huaweicloud.com>,
 dm-devel@redhat.com, Zdenek Kabelac <zkabelac@redhat.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

This patch implements discard in the brd driver. We use RCU to free the
page, so that if there are any concurrent readers or writes, they won't
touch the page after it is freed.

Calling "call_rcu" for each page is inefficient, so we attempt to batch
multiple pages to a single "call_rcu" call.

Note that we replace "BUG_ON(!page);" with "if (page) ..." in copy_to_brd
- the page can't be NULL under normal circumstances, it can only be NULL
if REQ_OP_WRITE races with REQ_OP_DISCARD. If these two bios race with
each other on the same page, the result is undefined, so we can handle
this race condition just by skipping the copying.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>

---
 drivers/block/brd.c |  150 +++++++++++++++++++++++++++++++++++++++++++++++-----
 1 file changed, 136 insertions(+), 14 deletions(-)

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
@@ -100,6 +102,54 @@ static int brd_insert_page(struct brd_de
 	return ret;
 }
 
+struct free_page_batch {
+	struct rcu_head rcu;
+	struct list_head list;
+};
+
+static void brd_free_page_rcu(struct rcu_head *head)
+{
+	__free_page(container_of(head, struct page, rcu_head));
+}
+
+static void brd_free_pages_rcu(struct rcu_head *head)
+{
+	struct free_page_batch *batch = container_of(head, struct free_page_batch, rcu);
+
+	while (!list_empty(&batch->list)) {
+		struct page *page = list_entry(batch->list.prev, struct page, lru);
+
+		list_del(&page->lru);
+
+		__free_page(page);
+	}
+
+	kfree(batch);
+}
+
+static void brd_free_page(struct brd_device *brd, sector_t sector,
+			  struct free_page_batch **batch)
+{
+	struct page *page;
+	pgoff_t idx;
+
+	idx = sector >> PAGE_SECTORS_SHIFT;
+	page = xa_erase(&brd->brd_pages, idx);
+
+	if (page) {
+		BUG_ON(page->index != idx);
+		if (!*batch) {
+			*batch = kmalloc(sizeof(struct free_page_batch), GFP_NOIO);
+			if (unlikely(!*batch)) {
+				call_rcu(&page->rcu_head, brd_free_page_rcu);
+				return;
+			} 
+			INIT_LIST_HEAD(&(*batch)->list);
+		}
+		list_add(&page->lru, &(*batch)->list);
+	}
+}
+
 /*
  * Free all backing store pages and xarray. This must only be called when
  * there are no other users of the device.
@@ -152,11 +202,11 @@ static void copy_to_brd(struct brd_devic
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
@@ -165,11 +215,11 @@ static void copy_to_brd(struct brd_devic
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
@@ -248,13 +298,47 @@ out:
 	return err;
 }
 
+void brd_do_discard(struct brd_device *brd, struct bio *bio)
+{
+	struct free_page_batch *batch = NULL;
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
+		brd_free_page(brd, sector, &batch);
+		sector += PAGE_SECTORS;
+		len -= PAGE_SECTORS;
+		cond_resched();
+	}
+	if (batch)
+		call_rcu(&batch->rcu, brd_free_pages_rcu);
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
@@ -276,6 +360,7 @@ static void brd_submit_bio(struct bio *b
 		sector += len >> SECTOR_SHIFT;
 	}
 
+endio:
 	bio_endio(bio);
 }
 
@@ -284,6 +369,40 @@ static const struct block_device_operati
 	.submit_bio =		brd_submit_bio,
 };
 
+static LIST_HEAD(brd_devices);
+static struct dentry *brd_debugfs_dir;
+
+static void brd_set_discard_limits(struct brd_device *brd)
+{
+	struct request_queue *queue = brd->brd_disk->queue;
+	if (discard) {
+		queue->limits.discard_granularity = PAGE_SIZE;
+		blk_queue_max_discard_sectors(queue, round_down(UINT_MAX, PAGE_SECTORS));
+	} else {
+		queue->limits.discard_granularity = 0;
+		blk_queue_max_discard_sectors(queue, 0);
+	}
+}
+
+static int discard_set_bool(const char *val, const struct kernel_param *kp)
+{
+	struct brd_device *brd;
+
+	int r = param_set_bool(val, kp);
+	if (r)
+		return r;
+
+	list_for_each_entry(brd, &brd_devices, brd_list)
+		brd_set_discard_limits(brd);
+
+	return 0;
+}
+
+static const struct kernel_param_ops discard_ops = {
+	.set = discard_set_bool,
+	.get = param_get_bool,
+};
+
 /*
  * And now the modules code and kernel interface.
  */
@@ -299,6 +418,10 @@ static int max_part = 1;
 module_param(max_part, int, 0444);
 MODULE_PARM_DESC(max_part, "Num Minors to reserve between devices");
 
+static bool discard = false;
+module_param_cb(discard, &discard_ops, &discard, 0644);
+MODULE_PARM_DESC(discard, "Support discard");
+
 MODULE_LICENSE("GPL");
 MODULE_ALIAS_BLOCKDEV_MAJOR(RAMDISK_MAJOR);
 MODULE_ALIAS("rd");
@@ -317,9 +440,6 @@ __setup("ramdisk_size=", ramdisk_size);
  * The device scheme is derived from loop.c. Keep them in synch where possible
  * (should share code eventually).
  */
-static LIST_HEAD(brd_devices);
-static struct dentry *brd_debugfs_dir;
-
 static int brd_alloc(int i)
 {
 	struct brd_device *brd;
@@ -364,6 +484,8 @@ static int brd_alloc(int i)
 	 */
 	blk_queue_physical_block_size(disk->queue, PAGE_SIZE);
 
+	brd_set_discard_limits(brd);
+
 	/* Tell the block layer that this is not a rotational device */
 	blk_queue_flag_set(QUEUE_FLAG_NONROT, disk->queue);
 	blk_queue_flag_set(QUEUE_FLAG_SYNCHRONOUS, disk->queue);
--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel


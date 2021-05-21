Return-Path: <SRS0=AQTU=KQ=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1A777C433ED
	for <dm-devel@archiver.kernel.org>; Fri, 21 May 2021 06:03:57 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id ACF6F61057
	for <dm-devel@archiver.kernel.org>; Fri, 21 May 2021 06:03:56 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org ACF6F61057
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-528-JfdYBJCIOcu2B1F-KWz4Qg-1; Fri, 21 May 2021 02:03:53 -0400
X-MC-Unique: JfdYBJCIOcu2B1F-KWz4Qg-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E6C56107ACC7;
	Fri, 21 May 2021 06:03:48 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 9E65669108;
	Fri, 21 May 2021 06:03:48 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 7746B1800BB4;
	Fri, 21 May 2021 06:03:48 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
	[10.11.54.3])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 14L63lhF028150 for <dm-devel@listman.util.phx.redhat.com>;
	Fri, 21 May 2021 02:03:47 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 0B0CA10A144D; Fri, 21 May 2021 06:03:47 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 06CFB10A7E27
	for <dm-devel@redhat.com>; Fri, 21 May 2021 06:03:44 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[207.211.31.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 6DB038007AC
	for <dm-devel@redhat.com>; Fri, 21 May 2021 06:03:44 +0000 (UTC)
Received: from bombadil.infradead.org (bombadil.infradead.org
	[198.137.202.133]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-583-w9H2C4YbOF6iokcMQW3E-Q-1; Fri, 21 May 2021 02:03:42 -0400
X-MC-Unique: w9H2C4YbOF6iokcMQW3E-Q-1
Received: from [2001:4bb8:180:5add:4fd7:4137:d2f2:46e6] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.94 #2 (Red Hat Linux))
	id 1ljy4Q-00GpyP-7l; Fri, 21 May 2021 05:51:38 +0000
From: Christoph Hellwig <hch@lst.de>
To: Jens Axboe <axboe@kernel.dk>, Geert Uytterhoeven <geert@linux-m68k.org>,
	Chris Zankel <chris@zankel.net>, Max Filippov <jcmvbkbc@gmail.com>,
	Philipp Reisner <philipp.reisner@linbit.com>,
	Lars Ellenberg <lars.ellenberg@linbit.com>, Jim Paris <jim@jtan.com>,
	Joshua Morris <josh.h.morris@us.ibm.com>,
	Philip Kelleher <pjk1939@linux.ibm.com>,
	Minchan Kim <minchan@kernel.org>, Nitin Gupta <ngupta@vflare.org>,
	Matias Bjorling <mb@lightnvm.io>, Coly Li <colyli@suse.de>,
	Mike Snitzer <snitzer@redhat.com>, Song Liu <song@kernel.org>,
	Maxim Levitsky <maximlevitsky@gmail.com>, Alex Dubov <oakad@yahoo.com>, 
	Ulf Hansson <ulf.hansson@linaro.org>,
	Dan Williams <dan.j.williams@intel.com>,
	Vishal Verma <vishal.l.verma@intel.com>,
	Dave Jiang <dave.jiang@intel.com>, Heiko Carstens <hca@linux.ibm.com>, 
	Vasily Gorbik <gor@linux.ibm.com>,
	Christian Borntraeger <borntraeger@de.ibm.com>
Date: Fri, 21 May 2021 07:50:56 +0200
Message-Id: <20210521055116.1053587-7-hch@lst.de>
In-Reply-To: <20210521055116.1053587-1-hch@lst.de>
References: <20210521055116.1053587-1-hch@lst.de>
MIME-Version: 1.0
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by
	bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.3
X-loop: dm-devel@redhat.com
Cc: linux-xtensa@linux-xtensa.org, linux-m68k@vger.kernel.org,
	linux-raid@vger.kernel.org, nvdimm@lists.linux.dev,
	linux-s390@vger.kernel.org, linux-mmc@vger.kernel.org,
	linux-bcache@vger.kernel.org, linux-nvme@lists.infradead.org,
	linux-block@vger.kernel.org, dm-devel@redhat.com,
	drbd-dev@tron.linbit.com, linuxppc-dev@lists.ozlabs.org
Subject: [dm-devel] [PATCH 06/26] brd: convert to
	blk_alloc_disk/blk_cleanup_disk
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Convert the brd driver to use the blk_alloc_disk and blk_cleanup_disk
helpers to simplify gendisk and request_queue allocation.  This also
allows to remove the request_queue pointer in struct request_queue,
and to simplify the initialization as blk_cleanup_disk can be called
on any disk returned from blk_alloc_disk.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/block/brd.c | 94 ++++++++++++++++-----------------------------
 1 file changed, 33 insertions(+), 61 deletions(-)

diff --git a/drivers/block/brd.c b/drivers/block/brd.c
index 7562cf30b14e..95694113e38e 100644
--- a/drivers/block/brd.c
+++ b/drivers/block/brd.c
@@ -38,9 +38,7 @@
  * device).
  */
 struct brd_device {
-	int		brd_number;
-
-	struct request_queue	*brd_queue;
+	int			brd_number;
 	struct gendisk		*brd_disk;
 	struct list_head	brd_list;
 
@@ -372,7 +370,7 @@ static LIST_HEAD(brd_devices);
 static DEFINE_MUTEX(brd_devices_mutex);
 static struct dentry *brd_debugfs_dir;
 
-static struct brd_device *brd_alloc(int i)
+static int brd_alloc(int i)
 {
 	struct brd_device *brd;
 	struct gendisk *disk;
@@ -380,64 +378,55 @@ static struct brd_device *brd_alloc(int i)
 
 	brd = kzalloc(sizeof(*brd), GFP_KERNEL);
 	if (!brd)
-		goto out;
+		return -ENOMEM;
 	brd->brd_number		= i;
 	spin_lock_init(&brd->brd_lock);
 	INIT_RADIX_TREE(&brd->brd_pages, GFP_ATOMIC);
 
-	brd->brd_queue = blk_alloc_queue(NUMA_NO_NODE);
-	if (!brd->brd_queue)
-		goto out_free_dev;
-
 	snprintf(buf, DISK_NAME_LEN, "ram%d", i);
 	if (!IS_ERR_OR_NULL(brd_debugfs_dir))
 		debugfs_create_u64(buf, 0444, brd_debugfs_dir,
 				&brd->brd_nr_pages);
 
-	/* This is so fdisk will align partitions on 4k, because of
-	 * direct_access API needing 4k alignment, returning a PFN
-	 * (This is only a problem on very small devices <= 4M,
-	 *  otherwise fdisk will align on 1M. Regardless this call
-	 *  is harmless)
-	 */
-	blk_queue_physical_block_size(brd->brd_queue, PAGE_SIZE);
-	disk = brd->brd_disk = alloc_disk(max_part);
+	disk = brd->brd_disk = blk_alloc_disk(NUMA_NO_NODE);
 	if (!disk)
-		goto out_free_queue;
+		goto out_free_dev;
+
 	disk->major		= RAMDISK_MAJOR;
 	disk->first_minor	= i * max_part;
+	disk->minors		= max_part;
 	disk->fops		= &brd_fops;
 	disk->private_data	= brd;
 	disk->flags		= GENHD_FL_EXT_DEVT;
 	strlcpy(disk->disk_name, buf, DISK_NAME_LEN);
 	set_capacity(disk, rd_size * 2);
+	
+	/*
+	 * This is so fdisk will align partitions on 4k, because of
+	 * direct_access API needing 4k alignment, returning a PFN
+	 * (This is only a problem on very small devices <= 4M,
+	 *  otherwise fdisk will align on 1M. Regardless this call
+	 *  is harmless)
+	 */
+	blk_queue_physical_block_size(disk->queue, PAGE_SIZE);
 
 	/* Tell the block layer that this is not a rotational device */
-	blk_queue_flag_set(QUEUE_FLAG_NONROT, brd->brd_queue);
-	blk_queue_flag_clear(QUEUE_FLAG_ADD_RANDOM, brd->brd_queue);
+	blk_queue_flag_set(QUEUE_FLAG_NONROT, disk->queue);
+	blk_queue_flag_clear(QUEUE_FLAG_ADD_RANDOM, disk->queue);
+	add_disk(disk);
+	list_add_tail(&brd->brd_list, &brd_devices);
 
-	return brd;
+	return 0;
 
-out_free_queue:
-	blk_cleanup_queue(brd->brd_queue);
 out_free_dev:
 	kfree(brd);
-out:
-	return NULL;
-}
-
-static void brd_free(struct brd_device *brd)
-{
-	put_disk(brd->brd_disk);
-	blk_cleanup_queue(brd->brd_queue);
-	brd_free_pages(brd);
-	kfree(brd);
+	return -ENOMEM;
 }
 
 static void brd_probe(dev_t dev)
 {
-	struct brd_device *brd;
 	int i = MINOR(dev) / max_part;
+	struct brd_device *brd;
 
 	mutex_lock(&brd_devices_mutex);
 	list_for_each_entry(brd, &brd_devices, brd_list) {
@@ -445,13 +434,7 @@ static void brd_probe(dev_t dev)
 			goto out_unlock;
 	}
 
-	brd = brd_alloc(i);
-	if (brd) {
-		brd->brd_disk->queue = brd->brd_queue;
-		add_disk(brd->brd_disk);
-		list_add_tail(&brd->brd_list, &brd_devices);
-	}
-
+	brd_alloc(i);
 out_unlock:
 	mutex_unlock(&brd_devices_mutex);
 }
@@ -460,7 +443,9 @@ static void brd_del_one(struct brd_device *brd)
 {
 	list_del(&brd->brd_list);
 	del_gendisk(brd->brd_disk);
-	brd_free(brd);
+	blk_cleanup_disk(brd->brd_disk);
+	brd_free_pages(brd);
+	kfree(brd);
 }
 
 static inline void brd_check_and_reset_par(void)
@@ -485,7 +470,7 @@ static inline void brd_check_and_reset_par(void)
 static int __init brd_init(void)
 {
 	struct brd_device *brd, *next;
-	int i;
+	int err, i;
 
 	/*
 	 * brd module now has a feature to instantiate underlying device
@@ -511,22 +496,11 @@ static int __init brd_init(void)
 
 	mutex_lock(&brd_devices_mutex);
 	for (i = 0; i < rd_nr; i++) {
-		brd = brd_alloc(i);
-		if (!brd)
+		err = brd_alloc(i);
+		if (err)
 			goto out_free;
-		list_add_tail(&brd->brd_list, &brd_devices);
 	}
 
-	/* point of no return */
-
-	list_for_each_entry(brd, &brd_devices, brd_list) {
-		/*
-		 * associate with queue just before adding disk for
-		 * avoiding to mess up failure path
-		 */
-		brd->brd_disk->queue = brd->brd_queue;
-		add_disk(brd->brd_disk);
-	}
 	mutex_unlock(&brd_devices_mutex);
 
 	pr_info("brd: module loaded\n");
@@ -535,15 +509,13 @@ static int __init brd_init(void)
 out_free:
 	debugfs_remove_recursive(brd_debugfs_dir);
 
-	list_for_each_entry_safe(brd, next, &brd_devices, brd_list) {
-		list_del(&brd->brd_list);
-		brd_free(brd);
-	}
+	list_for_each_entry_safe(brd, next, &brd_devices, brd_list)
+		brd_del_one(brd);
 	mutex_unlock(&brd_devices_mutex);
 	unregister_blkdev(RAMDISK_MAJOR, "ramdisk");
 
 	pr_info("brd: module NOT loaded !!!\n");
-	return -ENOMEM;
+	return err;
 }
 
 static void __exit brd_exit(void)
-- 
2.30.2

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel


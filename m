Return-Path: <SRS0=AQTU=KQ=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5F088C433ED
	for <dm-devel@archiver.kernel.org>; Fri, 21 May 2021 06:04:13 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id E5A6B60FEF
	for <dm-devel@archiver.kernel.org>; Fri, 21 May 2021 06:04:12 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org E5A6B60FEF
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-247-xc6NHCaDO4qwF-IqBa_HUw-1; Fri, 21 May 2021 02:04:07 -0400
X-MC-Unique: xc6NHCaDO4qwF-IqBa_HUw-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 1DD67501E1;
	Fri, 21 May 2021 06:04:02 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 0706A39A72;
	Fri, 21 May 2021 06:04:02 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id D5C73180C69B;
	Fri, 21 May 2021 06:04:01 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
	[10.11.54.4])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 14L63xeH028188 for <dm-devel@listman.util.phx.redhat.com>;
	Fri, 21 May 2021 02:04:00 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id D18F3212AA9E; Fri, 21 May 2021 06:03:59 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id CD2C0212AA9C
	for <dm-devel@redhat.com>; Fri, 21 May 2021 06:03:59 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[205.139.110.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id B552980D0E7
	for <dm-devel@redhat.com>; Fri, 21 May 2021 06:03:59 +0000 (UTC)
Received: from bombadil.infradead.org (bombadil.infradead.org
	[198.137.202.133]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-320-1h3DSZmpPgSxu1YjXQq8CQ-1; Fri, 21 May 2021 02:03:57 -0400
X-MC-Unique: 1h3DSZmpPgSxu1YjXQq8CQ-1
Received: from [2001:4bb8:180:5add:4fd7:4137:d2f2:46e6] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.94 #2 (Red Hat Linux))
	id 1ljy4A-00Gpwn-Ii; Fri, 21 May 2021 05:51:23 +0000
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
Date: Fri, 21 May 2021 07:50:51 +0200
Message-Id: <20210521055116.1053587-2-hch@lst.de>
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
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.4
X-loop: dm-devel@redhat.com
Cc: linux-xtensa@linux-xtensa.org, linux-m68k@vger.kernel.org,
	linux-raid@vger.kernel.org, nvdimm@lists.linux.dev,
	linux-s390@vger.kernel.org, linux-mmc@vger.kernel.org,
	linux-bcache@vger.kernel.org, linux-nvme@lists.infradead.org,
	linux-block@vger.kernel.org, dm-devel@redhat.com,
	drbd-dev@tron.linbit.com, linuxppc-dev@lists.ozlabs.org
Subject: [dm-devel] [PATCH 01/26] block: refactor device number setup in
	__device_add_disk
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

Untangle the mess around blk_alloc_devt by moving the check for
the used allocation scheme into the callers.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 block/blk.h             |  4 +-
 block/genhd.c           | 96 ++++++++++++++++-------------------------
 block/partitions/core.c | 15 +++++--
 3 files changed, 49 insertions(+), 66 deletions(-)

diff --git a/block/blk.h b/block/blk.h
index 8b3591aee0a5..cba3a94aabfa 100644
--- a/block/blk.h
+++ b/block/blk.h
@@ -343,8 +343,8 @@ static inline void blk_queue_free_zone_bitmaps(struct request_queue *q) {}
 static inline void blk_queue_clear_zone_settings(struct request_queue *q) {}
 #endif
 
-int blk_alloc_devt(struct block_device *part, dev_t *devt);
-void blk_free_devt(dev_t devt);
+int blk_alloc_ext_minor(void);
+void blk_free_ext_minor(unsigned int minor);
 char *disk_name(struct gendisk *hd, int partno, char *buf);
 #define ADDPART_FLAG_NONE	0
 #define ADDPART_FLAG_RAID	1
diff --git a/block/genhd.c b/block/genhd.c
index 39ca97b0edc6..2c00bc3261d9 100644
--- a/block/genhd.c
+++ b/block/genhd.c
@@ -335,52 +335,22 @@ static int blk_mangle_minor(int minor)
 	return minor;
 }
 
-/**
- * blk_alloc_devt - allocate a dev_t for a block device
- * @bdev: block device to allocate dev_t for
- * @devt: out parameter for resulting dev_t
- *
- * Allocate a dev_t for block device.
- *
- * RETURNS:
- * 0 on success, allocated dev_t is returned in *@devt.  -errno on
- * failure.
- *
- * CONTEXT:
- * Might sleep.
- */
-int blk_alloc_devt(struct block_device *bdev, dev_t *devt)
+int blk_alloc_ext_minor(void)
 {
-	struct gendisk *disk = bdev->bd_disk;
 	int idx;
 
-	/* in consecutive minor range? */
-	if (bdev->bd_partno < disk->minors) {
-		*devt = MKDEV(disk->major, disk->first_minor + bdev->bd_partno);
-		return 0;
-	}
-
 	idx = ida_alloc_range(&ext_devt_ida, 0, NR_EXT_DEVT, GFP_KERNEL);
-	if (idx < 0)
-		return idx == -ENOSPC ? -EBUSY : idx;
-
-	*devt = MKDEV(BLOCK_EXT_MAJOR, blk_mangle_minor(idx));
-	return 0;
+	if (idx < 0) {
+		if (idx == -ENOSPC)
+			return -EBUSY;
+		return idx;
+	}
+	return blk_mangle_minor(idx);
 }
 
-/**
- * blk_free_devt - free a dev_t
- * @devt: dev_t to free
- *
- * Free @devt which was allocated using blk_alloc_devt().
- *
- * CONTEXT:
- * Might sleep.
- */
-void blk_free_devt(dev_t devt)
+void blk_free_ext_minor(unsigned int minor)
 {
-	if (MAJOR(devt) == BLOCK_EXT_MAJOR)
-		ida_free(&ext_devt_ida, blk_mangle_minor(MINOR(devt)));
+	ida_free(&ext_devt_ida, blk_mangle_minor(minor));
 }
 
 static char *bdevt_str(dev_t devt, char *buf)
@@ -501,8 +471,7 @@ static void __device_add_disk(struct device *parent, struct gendisk *disk,
 			      const struct attribute_group **groups,
 			      bool register_queue)
 {
-	dev_t devt;
-	int retval;
+	int ret;
 
 	/*
 	 * The disk queue should now be all set with enough information about
@@ -513,23 +482,29 @@ static void __device_add_disk(struct device *parent, struct gendisk *disk,
 	if (register_queue)
 		elevator_init_mq(disk->queue);
 
-	/* minors == 0 indicates to use ext devt from part0 and should
-	 * be accompanied with EXT_DEVT flag.  Make sure all
-	 * parameters make sense.
+	/*
+	 * If the driver provides an explicit major number it also must provide
+	 * the number of minors numbers supported, and those will be used to
+	 * setup the gendisk.
+	 * Otherwise just allocate the device numbers for both the whole device
+	 * and all partitions from the extended dev_t space.
 	 */
-	WARN_ON(disk->minors && !(disk->major || disk->first_minor));
-	WARN_ON(!disk->minors &&
-		!(disk->flags & (GENHD_FL_EXT_DEVT | GENHD_FL_HIDDEN)));
-
-	disk->flags |= GENHD_FL_UP;
+	if (disk->major) {
+		WARN_ON(!disk->minors);
+	} else {
+		WARN_ON(disk->minors);
+		WARN_ON(!(disk->flags & (GENHD_FL_EXT_DEVT | GENHD_FL_HIDDEN)));
 
-	retval = blk_alloc_devt(disk->part0, &devt);
-	if (retval) {
-		WARN_ON(1);
-		return;
+		ret = blk_alloc_ext_minor();
+		if (ret < 0) {
+			WARN_ON(1);
+			return;
+		}
+		disk->major = BLOCK_EXT_MAJOR;
+		disk->first_minor = MINOR(ret);
 	}
-	disk->major = MAJOR(devt);
-	disk->first_minor = MINOR(devt);
+
+	disk->flags |= GENHD_FL_UP;
 
 	disk_alloc_events(disk);
 
@@ -543,14 +518,14 @@ static void __device_add_disk(struct device *parent, struct gendisk *disk,
 	} else {
 		struct backing_dev_info *bdi = disk->queue->backing_dev_info;
 		struct device *dev = disk_to_dev(disk);
-		int ret;
 
 		/* Register BDI before referencing it from bdev */
-		dev->devt = devt;
-		ret = bdi_register(bdi, "%u:%u", MAJOR(devt), MINOR(devt));
+		dev->devt = MKDEV(disk->major, disk->first_minor);
+		ret = bdi_register(bdi, "%u:%u",
+				   disk->major, disk->first_minor);
 		WARN_ON(ret);
 		bdi_set_owner(bdi, dev);
-		bdev_add(disk->part0, devt);
+		bdev_add(disk->part0, dev->devt);
 	}
 	register_disk(parent, disk, groups);
 	if (register_queue)
@@ -1129,7 +1104,8 @@ static void disk_release(struct device *dev)
 
 	might_sleep();
 
-	blk_free_devt(dev->devt);
+	if (MAJOR(dev->devt) == BLOCK_EXT_MAJOR)
+		blk_free_ext_minor(MINOR(dev->devt));
 	disk_release_events(disk);
 	kfree(disk->random);
 	xa_destroy(&disk->part_tbl);
diff --git a/block/partitions/core.c b/block/partitions/core.c
index dc60ecf46fe6..504297bdc8bf 100644
--- a/block/partitions/core.c
+++ b/block/partitions/core.c
@@ -260,7 +260,8 @@ static const struct attribute_group *part_attr_groups[] = {
 
 static void part_release(struct device *dev)
 {
-	blk_free_devt(dev->devt);
+	if (MAJOR(dev->devt) == BLOCK_EXT_MAJOR)
+		blk_free_ext_minor(MINOR(dev->devt));
 	bdput(dev_to_bdev(dev));
 }
 
@@ -379,9 +380,15 @@ static struct block_device *add_partition(struct gendisk *disk, int partno,
 	pdev->type = &part_type;
 	pdev->parent = ddev;
 
-	err = blk_alloc_devt(bdev, &devt);
-	if (err)
-		goto out_put;
+	/* in consecutive minor range? */
+	if (bdev->bd_partno < disk->minors) {
+		devt = MKDEV(disk->major, disk->first_minor + bdev->bd_partno);
+	} else {
+		err = blk_alloc_ext_minor();
+		if (err < 0)
+			goto out_put;
+		devt = MKDEV(BLOCK_EXT_MAJOR, err);
+	}
 	pdev->devt = devt;
 
 	/* delay uevent until 'holders' subdir is created */
-- 
2.30.2

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel


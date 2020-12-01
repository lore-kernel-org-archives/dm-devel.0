Return-Path: <SRS0=byOr=FF=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3F44DC64E7A
	for <dm-devel@archiver.kernel.org>; Tue,  1 Dec 2020 17:04:35 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 5AEB5206B7
	for <dm-devel@archiver.kernel.org>; Tue,  1 Dec 2020 17:04:33 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 5AEB5206B7
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-259-Aq01-CbdN2q_UwZs_V9V3g-1; Tue, 01 Dec 2020 12:04:29 -0500
X-MC-Unique: Aq01-CbdN2q_UwZs_V9V3g-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 5E8A718C8C00;
	Tue,  1 Dec 2020 17:04:24 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 1D64460C0F;
	Tue,  1 Dec 2020 17:04:24 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id E5287180954D;
	Tue,  1 Dec 2020 17:04:23 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
	[10.11.54.5])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 0B1H4MwX032644 for <dm-devel@listman.util.phx.redhat.com>;
	Tue, 1 Dec 2020 12:04:22 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id B7A7B9457F; Tue,  1 Dec 2020 17:04:22 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id B1BC994596
	for <dm-devel@redhat.com>; Tue,  1 Dec 2020 17:04:20 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[207.211.31.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 443DD811E85
	for <dm-devel@redhat.com>; Tue,  1 Dec 2020 17:04:20 +0000 (UTC)
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-315-0Oi0dPilNyu8AoVTl_p8GQ-1; Tue, 01 Dec 2020 12:04:18 -0500
X-MC-Unique: 0Oi0dPilNyu8AoVTl_p8GQ-1
Received: from [2001:4bb8:184:6389:bbd8:a1c2:99e0:f58a] (helo=localhost)
	by casper.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
	id 1kk8vC-0005Zm-Ud; Tue, 01 Dec 2020 16:54:35 +0000
From: Christoph Hellwig <hch@lst.de>
To: Jens Axboe <axboe@kernel.dk>
Date: Tue,  1 Dec 2020 17:54:22 +0100
Message-Id: <20201201165424.2030647-8-hch@lst.de>
In-Reply-To: <20201201165424.2030647-1-hch@lst.de>
References: <20201201165424.2030647-1-hch@lst.de>
MIME-Version: 1.0
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by
	casper.infradead.org. See http://www.infradead.org/rpr.html
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.79 on 10.11.54.5
X-loop: dm-devel@redhat.com
Cc: linux-s390@vger.kernel.org, linux-bcache@vger.kernel.org,
	Coly Li <colyli@suse.de>, linux-raid@vger.kernel.org,
	Song Liu <song@kernel.org>, dm-devel@redhat.com,
	linux-block@vger.kernel.org, Tejun Heo <tj@kernel.org>
Subject: [dm-devel] [PATCH 7/9] block: add a disk_uevent helper
X-BeenThere: dm-devel@redhat.com
X-Mailman-Version: 2.1.12
Precedence: junk
List-Id: device-mapper development <dm-devel.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Add a helper to call kobject_uevent for the disk and all partitions, and
unexport the disk_part_iter_* helpers that are now only used in the core
block code.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 block/genhd.c             | 27 ++++++++++++++-------------
 drivers/s390/block/dasd.c | 26 +++++---------------------
 include/linux/genhd.h     |  2 ++
 3 files changed, 21 insertions(+), 34 deletions(-)

diff --git a/block/genhd.c b/block/genhd.c
index 3b9cd766d95228..65dba32df5474f 100644
--- a/block/genhd.c
+++ b/block/genhd.c
@@ -201,7 +201,6 @@ void disk_part_iter_init(struct disk_part_iter *piter, struct gendisk *disk,
 
 	rcu_read_unlock();
 }
-EXPORT_SYMBOL_GPL(disk_part_iter_init);
 
 /**
  * disk_part_iter_next - proceed iterator to the next partition and return it
@@ -261,7 +260,6 @@ struct block_device *disk_part_iter_next(struct disk_part_iter *piter)
 
 	return piter->part;
 }
-EXPORT_SYMBOL_GPL(disk_part_iter_next);
 
 /**
  * disk_part_iter_exit - finish up partition iteration
@@ -278,7 +276,6 @@ void disk_part_iter_exit(struct disk_part_iter *piter)
 		bdput(piter->part);
 	piter->part = NULL;
 }
-EXPORT_SYMBOL_GPL(disk_part_iter_exit);
 
 /**
  * disk_has_partitions
@@ -550,6 +547,18 @@ static char *bdevt_str(dev_t devt, char *buf)
 	return buf;
 }
 
+void disk_uevent(struct gendisk *disk, enum kobject_action action)
+{
+	struct disk_part_iter piter;
+	struct block_device *part;
+
+	disk_part_iter_init(&piter, disk, DISK_PITER_INCL_PART0);
+	while ((part = disk_part_iter_next(&piter)))
+		kobject_uevent(bdev_kobj(part), action);
+	disk_part_iter_exit(&piter);
+}
+EXPORT_SYMBOL_GPL(disk_uevent);
+
 static void disk_scan_partitions(struct gendisk *disk)
 {
 	struct block_device *bdev;
@@ -567,8 +576,6 @@ static void register_disk(struct device *parent, struct gendisk *disk,
 			  const struct attribute_group **groups)
 {
 	struct device *ddev = disk_to_dev(disk);
-	struct disk_part_iter piter;
-	struct block_device *part;
 	int err;
 
 	ddev->parent = parent;
@@ -611,15 +618,9 @@ static void register_disk(struct device *parent, struct gendisk *disk,
 
 	disk_scan_partitions(disk);
 
-	/* announce disk after possible partitions are created */
+	/* announce the disk and partitions after all partitions are created */
 	dev_set_uevent_suppress(ddev, 0);
-	kobject_uevent(&ddev->kobj, KOBJ_ADD);
-
-	/* announce possible partitions */
-	disk_part_iter_init(&piter, disk, 0);
-	while ((part = disk_part_iter_next(&piter)))
-		kobject_uevent(bdev_kobj(part), KOBJ_ADD);
-	disk_part_iter_exit(&piter);
+	disk_uevent(disk, KOBJ_ADD);
 
 	if (disk->queue->backing_dev_info->dev) {
 		err = sysfs_create_link(&ddev->kobj,
diff --git a/drivers/s390/block/dasd.c b/drivers/s390/block/dasd.c
index 1825fa8d05a780..bb0c63fbdabc01 100644
--- a/drivers/s390/block/dasd.c
+++ b/drivers/s390/block/dasd.c
@@ -430,23 +430,15 @@ static int dasd_state_unfmt_to_basic(struct dasd_device *device)
 static int
 dasd_state_ready_to_online(struct dasd_device * device)
 {
-	struct gendisk *disk;
-	struct disk_part_iter piter;
-	struct block_device *part;
-
 	device->state = DASD_STATE_ONLINE;
 	if (device->block) {
 		dasd_schedule_block_bh(device->block);
 		if ((device->features & DASD_FEATURE_USERAW)) {
-			disk = device->block->gdp;
-			kobject_uevent(&disk_to_dev(disk)->kobj, KOBJ_CHANGE);
+			kobject_uevent(&disk_to_dev(device->block->gdp)->kobj,
+					KOBJ_CHANGE);
 			return 0;
 		}
-		disk = device->block->bdev->bd_disk;
-		disk_part_iter_init(&piter, disk, DISK_PITER_INCL_PART0);
-		while ((part = disk_part_iter_next(&piter)))
-			kobject_uevent(bdev_kobj(part), KOBJ_CHANGE);
-		disk_part_iter_exit(&piter);
+		disk_uevent(device->block->bdev->bd_disk, KOBJ_CHANGE);
 	}
 	return 0;
 }
@@ -457,9 +449,6 @@ dasd_state_ready_to_online(struct dasd_device * device)
 static int dasd_state_online_to_ready(struct dasd_device *device)
 {
 	int rc;
-	struct gendisk *disk;
-	struct disk_part_iter piter;
-	struct block_device *part;
 
 	if (device->discipline->online_to_ready) {
 		rc = device->discipline->online_to_ready(device);
@@ -468,13 +457,8 @@ static int dasd_state_online_to_ready(struct dasd_device *device)
 	}
 
 	device->state = DASD_STATE_READY;
-	if (device->block && !(device->features & DASD_FEATURE_USERAW)) {
-		disk = device->block->bdev->bd_disk;
-		disk_part_iter_init(&piter, disk, DISK_PITER_INCL_PART0);
-		while ((part = disk_part_iter_next(&piter)))
-			kobject_uevent(bdev_kobj(part), KOBJ_CHANGE);
-		disk_part_iter_exit(&piter);
-	}
+	if (device->block && !(device->features & DASD_FEATURE_USERAW))
+		disk_uevent(device->block->bdev->bd_disk, KOBJ_CHANGE);
 	return 0;
 }
 
diff --git a/include/linux/genhd.h b/include/linux/genhd.h
index 809aaa32d53cba..191f5e4ae4e93b 100644
--- a/include/linux/genhd.h
+++ b/include/linux/genhd.h
@@ -212,6 +212,8 @@ static inline dev_t disk_devt(struct gendisk *disk)
 	return MKDEV(disk->major, disk->first_minor);
 }
 
+void disk_uevent(struct gendisk *disk, enum kobject_action action);
+
 /*
  * Smarter partition iterator without context limits.
  */
-- 
2.29.2

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel


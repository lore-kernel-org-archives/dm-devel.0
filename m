Return-Path: <SRS0=Qr9I=M3=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2A07EC4338F
	for <dm-devel@archiver.kernel.org>; Wed,  4 Aug 2021 09:48:17 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id C24E960FC4
	for <dm-devel@archiver.kernel.org>; Wed,  4 Aug 2021 09:48:16 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org C24E960FC4
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-144-2wAO8ShlNCW97vwEZkRkUA-1; Wed, 04 Aug 2021 05:48:13 -0400
X-MC-Unique: 2wAO8ShlNCW97vwEZkRkUA-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 546168C60D8;
	Wed,  4 Aug 2021 09:48:04 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 2BDE26A8E4;
	Wed,  4 Aug 2021 09:48:04 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id F1B9C181A3E9;
	Wed,  4 Aug 2021 09:48:03 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
	[10.11.54.6])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 1749m27B006392 for <dm-devel@listman.util.phx.redhat.com>;
	Wed, 4 Aug 2021 05:48:02 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 99E30212420F; Wed,  4 Aug 2021 09:48:02 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 949912124212
	for <dm-devel@redhat.com>; Wed,  4 Aug 2021 09:47:56 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[205.139.110.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 49D02106655D
	for <dm-devel@redhat.com>; Wed,  4 Aug 2021 09:47:56 +0000 (UTC)
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-512-Z8W77s2rOvG81BT2K664NA-1; Wed, 04 Aug 2021 05:47:52 -0400
X-MC-Unique: Z8W77s2rOvG81BT2K664NA-1
Received: from [2a02:1205:5023:1f80:c068:bd3d:78b3:7d37] (helo=localhost)
	by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
	id 1mBDUi-005eJm-Mb; Wed, 04 Aug 2021 09:47:34 +0000
From: Christoph Hellwig <hch@lst.de>
To: Jens Axboe <axboe@kernel.dk>, Mike Snitzer <snitzer@redhat.com>
Date: Wed,  4 Aug 2021 11:41:47 +0200
Message-Id: <20210804094147.459763-9-hch@lst.de>
In-Reply-To: <20210804094147.459763-1-hch@lst.de>
References: <20210804094147.459763-1-hch@lst.de>
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
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.6
X-loop: dm-devel@redhat.com
Cc: linux-block@vger.kernel.org, dm-devel@redhat.com
Subject: [dm-devel] [PATCH 8/8] block: remove support for delayed queue
	registrations
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Now that device mapper has been changed to register the disk once
it is fully ready all this code is unused.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Mike Snitzer <snitzer@redhat.com>
---
 block/elevator.c      |  1 -
 block/genhd.c         | 29 +++++++----------------------
 include/linux/genhd.h |  6 ------
 3 files changed, 7 insertions(+), 29 deletions(-)

diff --git a/block/elevator.c b/block/elevator.c
index 52ada14cfe45..706d5a64508d 100644
--- a/block/elevator.c
+++ b/block/elevator.c
@@ -702,7 +702,6 @@ void elevator_init_mq(struct request_queue *q)
 		elevator_put(e);
 	}
 }
-EXPORT_SYMBOL_GPL(elevator_init_mq); /* only for dm-rq */
 
 /*
  * switch to new_e io scheduler. be careful not to introduce deadlocks -
diff --git a/block/genhd.c b/block/genhd.c
index db916f779077..b0b6e0caa389 100644
--- a/block/genhd.c
+++ b/block/genhd.c
@@ -475,20 +475,20 @@ static void register_disk(struct device *parent, struct gendisk *disk,
 }
 
 /**
- * __device_add_disk - add disk information to kernel list
+ * device_add_disk - add disk information to kernel list
  * @parent: parent device for the disk
  * @disk: per-device partitioning information
  * @groups: Additional per-device sysfs groups
- * @register_queue: register the queue if set to true
  *
  * This function registers the partitioning information in @disk
  * with the kernel.
  *
  * FIXME: error handling
  */
-static void __device_add_disk(struct device *parent, struct gendisk *disk,
-			      const struct attribute_group **groups,
-			      bool register_queue)
+
+void device_add_disk(struct device *parent, struct gendisk *disk,
+		     const struct attribute_group **groups)
+
 {
 	int ret;
 
@@ -498,8 +498,7 @@ static void __device_add_disk(struct device *parent, struct gendisk *disk,
 	 * elevator if one is needed, that is, for devices requesting queue
 	 * registration.
 	 */
-	if (register_queue)
-		elevator_init_mq(disk->queue);
+	elevator_init_mq(disk->queue);
 
 	/*
 	 * If the driver provides an explicit major number it also must provide
@@ -553,8 +552,7 @@ static void __device_add_disk(struct device *parent, struct gendisk *disk,
 		bdev_add(disk->part0, dev->devt);
 	}
 	register_disk(parent, disk, groups);
-	if (register_queue)
-		blk_register_queue(disk);
+	blk_register_queue(disk);
 
 	/*
 	 * Take an extra ref on queue which will be put on disk_release()
@@ -568,21 +566,8 @@ static void __device_add_disk(struct device *parent, struct gendisk *disk,
 	disk_add_events(disk);
 	blk_integrity_add(disk);
 }
-
-void device_add_disk(struct device *parent, struct gendisk *disk,
-		     const struct attribute_group **groups)
-
-{
-	__device_add_disk(parent, disk, groups, true);
-}
 EXPORT_SYMBOL(device_add_disk);
 
-void device_add_disk_no_queue_reg(struct device *parent, struct gendisk *disk)
-{
-	__device_add_disk(parent, disk, NULL, false);
-}
-EXPORT_SYMBOL(device_add_disk_no_queue_reg);
-
 /**
  * del_gendisk - remove the gendisk
  * @disk: the struct gendisk to remove
diff --git a/include/linux/genhd.h b/include/linux/genhd.h
index 80952f038d79..473d93c6ebda 100644
--- a/include/linux/genhd.h
+++ b/include/linux/genhd.h
@@ -219,12 +219,6 @@ static inline void add_disk(struct gendisk *disk)
 {
 	device_add_disk(NULL, disk, NULL);
 }
-extern void device_add_disk_no_queue_reg(struct device *parent, struct gendisk *disk);
-static inline void add_disk_no_queue_reg(struct gendisk *disk)
-{
-	device_add_disk_no_queue_reg(NULL, disk);
-}
-
 extern void del_gendisk(struct gendisk *gp);
 
 void set_disk_ro(struct gendisk *disk, bool read_only);
-- 
2.30.2

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel


Return-Path: <SRS0=a9Kz=KO=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AA2A0C433B4
	for <dm-devel@archiver.kernel.org>; Wed, 19 May 2021 03:00:56 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 3E3996124C
	for <dm-devel@archiver.kernel.org>; Wed, 19 May 2021 03:00:56 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 3E3996124C
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=wdc.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-157-bz6Yug4bPqamPWQ-mfBkJA-1; Tue, 18 May 2021 23:00:53 -0400
X-MC-Unique: bz6Yug4bPqamPWQ-mfBkJA-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 48F2C107ACCD;
	Wed, 19 May 2021 03:00:48 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 24DE110027A5;
	Wed, 19 May 2021 03:00:48 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id EC29F1801028;
	Wed, 19 May 2021 03:00:47 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
	[10.11.54.4])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 14J2tbM8029423 for <dm-devel@listman.util.phx.redhat.com>;
	Tue, 18 May 2021 22:55:37 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 79C822077FB8; Wed, 19 May 2021 02:55:37 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 739B1208BDD1
	for <dm-devel@redhat.com>; Wed, 19 May 2021 02:55:37 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [205.139.110.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 5CAAA833969
	for <dm-devel@redhat.com>; Wed, 19 May 2021 02:55:37 +0000 (UTC)
Received: from esa6.hgst.iphmx.com (esa6.hgst.iphmx.com [216.71.154.45])
	(Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-472-hX7UFpoMNPO9x_27KtlbBA-2; Tue, 18 May 2021 22:55:33 -0400
X-MC-Unique: hX7UFpoMNPO9x_27KtlbBA-2
IronPort-SDR: W3xLmwm8XY5O7xlh/nXoz58HhcftiWnfuO+MGRr7uv2qhgWiVdyH4y9+lGVWQoeicUYahjShNg
	d/qOeB4ZpABUkoNgQ7O22jV5ovQn9PT6z5qTUtduVm6VKIWBo9rYdVxNTnyq+vZV6To7ZV5HbF
	8S6ib0kwzrUN38+2LDYM0x6t44K8QMyTYQ1racEWf/syIGyX3dLCFJQApy+MSDurWN1aPIFIUr
	ENETiC88FNeRKVO6w1RzgEwt5h0AFVgseoRiiiRno4beoxyPJ7Sult3TEYhyXutc1hrCoC0BCd
	ZD0=
X-IronPort-AV: E=Sophos;i="5.82,311,1613404800"; d="scan'208";a="169197398"
Received: from uls-op-cesaip02.wdc.com (HELO uls-op-cesaep02.wdc.com)
	([199.255.45.15])
	by ob1.hgst.iphmx.com with ESMTP; 19 May 2021 10:55:32 +0800
IronPort-SDR: trqjIMlnEhPhcyq6QVY+saSDBoUMyLCRZwCfrfkDeDd1WRaIejFfN+kUaFgzJvasYFaK8GV4RK
	zlfljaZCcuMig1dxiutBEVcpog5+HOcvvw4pU/8mnvX64QqdWjZpHAqUV6JQAvR8rm0ogOqp2m
	aGqn6EBtAjU/IctoM2q8CRj0TLGW16MZKEEvCCOTXEXkcyCgJx8wguwERxdGbLu2RSYD5nmT4L
	vTiKStkEucyNQ+abY/DnwUjw+Hb2SqEGEBkAH32PU89z1nOJnBnLsL2LWuJiX/LiTzcRUi6bUL
	pEI/9K7nvqtNa5nmIPuJ2K5P
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
	by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384;
	18 May 2021 19:33:57 -0700
IronPort-SDR: 8SITTY2jLm6Fku0BO26dPB5D0WnriCNYdIYT8ZXHe8re3QsH8BAOrFlQ+CNb8+1DiXBOcdqD1i
	ISsrtcorNNZU2yzzXt7lQOshFPllOB/3RcJ11aCAWqHpDACxVooqn27VUXAsq2HPds0S4SmdeA
	Sm4n8Skv8GvPGv7VMt6Y8qU4bvoGz8Ffh0b2Vydaug7JJymxtC0znOJraFZqnX9xfrdTD9UDeG
	40ikyspNgP3X/D+REMGGsUCsXRtTNP9CF277qvXAlwwY2seFQlAzWKfER3VCtg3/+VXAl0NzfM
	+8Q=
WDCIronportException: Internal
Received: from washi.fujisawa.hgst.com ([10.149.53.254])
	by uls-op-cesaip02.wdc.com with ESMTP; 18 May 2021 19:55:31 -0700
From: Damien Le Moal <damien.lemoal@wdc.com>
To: dm-devel@redhat.com, Mike Snitzer <snitzer@redhat.com>,
	linux-block@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Date: Wed, 19 May 2021 11:55:19 +0900
Message-Id: <20210519025529.707897-2-damien.lemoal@wdc.com>
In-Reply-To: <20210519025529.707897-1-damien.lemoal@wdc.com>
References: <20210519025529.707897-1-damien.lemoal@wdc.com>
MIME-Version: 1.0
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
Subject: [dm-devel] [PATCH 01/11] block: improve handling of all zones reset
	operation
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

SCSI, ZNS and null_blk zoned devices support resetting all zones using
a single command (REQ_OP_ZONE_RESET_ALL), as indicated using the device
request queue flag QUEUE_FLAG_ZONE_RESETALL. This flag is not set for
device mapper targets creating zoned devices. In this case, a user
request for resetting all zones of a device is processed in
blkdev_zone_mgmt() by issuing a REQ_OP_ZONE_RESET operation for each
zone of the device. This leads to different behaviors of the
BLKRESETZONE ioctl() depending on the target device support for the
reset all operation. E.g.

blkzone reset /dev/sdX

will reset all zones of a SCSI device using a single command that will
ignore conventional, read-only or offline zones.

But a dm-linear device including conventional, read-only or offline
zones cannot be reset in the same manner as some of the single zone
reset operations issued by blkdev_zone_mgmt() will fail. E.g.:

blkzone reset /dev/dm-Y
blkzone: /dev/dm-0: BLKRESETZONE ioctl failed: Remote I/O error

To simplify applications and tools development, unify the behavior of
an all-zone reset operation by modifying blkdev_zone_mgmt() to not
issue a zone reset operation for conventional, read-only and offline
zones, thus mimicking what an actual reset-all device command does on a
device supporting REQ_OP_ZONE_RESET_ALL. The zones needing a reset are
identified using a bitmap that is initialized using a zone report.
Since empty zones do not need a reset, also ignore these zones.

Signed-off-by: Damien Le Moal <damien.lemoal@wdc.com>
---
 block/blk-zoned.c | 87 ++++++++++++++++++++++++++++++++++-------------
 1 file changed, 63 insertions(+), 24 deletions(-)

diff --git a/block/blk-zoned.c b/block/blk-zoned.c
index 250cb76ee615..13f053c06d9e 100644
--- a/block/blk-zoned.c
+++ b/block/blk-zoned.c
@@ -161,18 +161,30 @@ int blkdev_report_zones(struct block_device *bdev, sector_t sector,
 }
 EXPORT_SYMBOL_GPL(blkdev_report_zones);
 
-static inline bool blkdev_allow_reset_all_zones(struct block_device *bdev,
-						sector_t sector,
-						sector_t nr_sectors)
+static inline unsigned long *blk_alloc_zone_bitmap(int node,
+						   unsigned int nr_zones)
 {
-	if (!blk_queue_zone_resetall(bdev_get_queue(bdev)))
-		return false;
+	return kcalloc_node(BITS_TO_LONGS(nr_zones), sizeof(unsigned long),
+			    GFP_NOIO, node);
+}
 
+static int blk_zone_need_reset_cb(struct blk_zone *zone, unsigned int idx,
+				  void *data)
+{
 	/*
-	 * REQ_OP_ZONE_RESET_ALL can be executed only if the number of sectors
-	 * of the applicable zone range is the entire disk.
+	 * For an all-zones reset, ignore conventional, empty, read-only
+	 * and offline zones.
 	 */
-	return !sector && nr_sectors == get_capacity(bdev->bd_disk);
+	switch (zone->cond) {
+	case BLK_ZONE_COND_NOT_WP:
+	case BLK_ZONE_COND_EMPTY:
+	case BLK_ZONE_COND_READONLY:
+	case BLK_ZONE_COND_OFFLINE:
+		return 0;
+	default:
+		set_bit(idx, (unsigned long *)data);
+		return 0;
+	}
 }
 
 /**
@@ -199,8 +211,10 @@ int blkdev_zone_mgmt(struct block_device *bdev, enum req_opf op,
 	sector_t zone_sectors = blk_queue_zone_sectors(q);
 	sector_t capacity = get_capacity(bdev->bd_disk);
 	sector_t end_sector = sector + nr_sectors;
+	unsigned long *need_reset = NULL;
 	struct bio *bio = NULL;
-	int ret;
+	bool reset_all;
+	int ret = 0;
 
 	if (!blk_queue_is_zoned(q))
 		return -EOPNOTSUPP;
@@ -222,16 +236,44 @@ int blkdev_zone_mgmt(struct block_device *bdev, enum req_opf op,
 	if ((nr_sectors & (zone_sectors - 1)) && end_sector != capacity)
 		return -EINVAL;
 
+	/*
+	 * In the case of a zone reset operation over all zones,
+	 * REQ_OP_ZONE_RESET_ALL can be used with devices supporting this
+	 * command. For other devices, we emulate this command behavior by
+	 * identifying the zones needing a reset.
+	 */
+	reset_all = op == REQ_OP_ZONE_RESET &&
+		!sector && nr_sectors == capacity;
+	if (reset_all && !blk_queue_zone_resetall(q)) {
+		need_reset = blk_alloc_zone_bitmap(q->node, q->nr_zones);
+		if (!need_reset)
+			return -ENOMEM;
+		ret = bdev->bd_disk->fops->report_zones(bdev->bd_disk, 0,
+					q->nr_zones, blk_zone_need_reset_cb,
+					need_reset);
+		if (ret < 0)
+			return ret;
+		ret = 0;
+	}
+
 	while (sector < end_sector) {
-		bio = blk_next_bio(bio, 0, gfp_mask);
-		bio_set_dev(bio, bdev);
 
 		/*
-		 * Special case for the zone reset operation that reset all
-		 * zones, this is useful for applications like mkfs.
+		 * For an all zone reset operation, if the device does not
+		 + support REQ_OP_ZONE_RESET_ALL, skip zones that do not
+		 * need a reset.
 		 */
-		if (op == REQ_OP_ZONE_RESET &&
-		    blkdev_allow_reset_all_zones(bdev, sector, nr_sectors)) {
+		if (reset_all && !blk_queue_zone_resetall(q) &&
+		    !test_bit(blk_queue_zone_no(q, sector), need_reset)) {
+			sector += zone_sectors;
+			continue;
+		}
+
+		bio = blk_next_bio(bio, 0, gfp_mask);
+		bio_set_dev(bio, bdev);
+
+		if (reset_all && blk_queue_zone_resetall(q)) {
+			/* The device supports REQ_OP_ZONE_RESET_ALL */
 			bio->bi_opf = REQ_OP_ZONE_RESET_ALL | REQ_SYNC;
 			break;
 		}
@@ -244,8 +286,12 @@ int blkdev_zone_mgmt(struct block_device *bdev, enum req_opf op,
 		cond_resched();
 	}
 
-	ret = submit_bio_wait(bio);
-	bio_put(bio);
+	if (bio) {
+		ret = submit_bio_wait(bio);
+		bio_put(bio);
+	}
+
+	kfree(need_reset);
 
 	return ret;
 }
@@ -396,13 +442,6 @@ int blkdev_zone_mgmt_ioctl(struct block_device *bdev, fmode_t mode,
 	return ret;
 }
 
-static inline unsigned long *blk_alloc_zone_bitmap(int node,
-						   unsigned int nr_zones)
-{
-	return kcalloc_node(BITS_TO_LONGS(nr_zones), sizeof(unsigned long),
-			    GFP_NOIO, node);
-}
-
 void blk_queue_free_zone_bitmaps(struct request_queue *q)
 {
 	kfree(q->conv_zones_bitmap);
-- 
2.31.1

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel


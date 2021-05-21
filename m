Return-Path: <SRS0=AQTU=KQ=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D4445C433ED
	for <dm-devel@archiver.kernel.org>; Fri, 21 May 2021 03:02:27 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 594A16128A
	for <dm-devel@archiver.kernel.org>; Fri, 21 May 2021 03:02:24 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 594A16128A
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=wdc.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-601-83qA2Q2nMimd8cVVZZ_KoA-1; Thu, 20 May 2021 23:02:20 -0400
X-MC-Unique: 83qA2Q2nMimd8cVVZZ_KoA-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 9923980362B;
	Fri, 21 May 2021 03:02:14 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 7D7C85C5AE;
	Fri, 21 May 2021 03:02:14 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 575FB180B7A2;
	Fri, 21 May 2021 03:02:14 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
	[10.11.54.5])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 14L31Xjp013431 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 20 May 2021 23:01:34 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 6BF9D163D15; Fri, 21 May 2021 03:01:33 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 63190163D1B
	for <dm-devel@redhat.com>; Fri, 21 May 2021 03:01:28 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 0EE101857F1E
	for <dm-devel@redhat.com>; Fri, 21 May 2021 03:01:28 +0000 (UTC)
Received: from esa2.hgst.iphmx.com (esa2.hgst.iphmx.com [68.232.143.124])
	(Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-338-dPpMwaSxM6i8xTMat-r_Dw-2; Thu, 20 May 2021 23:01:23 -0400
X-MC-Unique: dPpMwaSxM6i8xTMat-r_Dw-2
IronPort-SDR: CUv/Y4mgsZLcNBBt/JGI+nayL1WHuWa2Upk6OvijeFWzPkZRP3FwAaL1ECMBiJFlH4duT0zHBi
	I1enEP6Ntk20HXvQb1ZdO4Wtzp+WATrw3sezzaOa5fuV26JSmnupi/Xn59/5Rzjs9a1krX1zyG
	TjtbsD2Q8zuzK/WzUupXnwLq5cuUGmYvx/sdexmXubyj1qOQCDQK3bV1tfjqFwjGrN+91I+3rJ
	kC70Gq7vgllBYHVSs5WS3gGL39PsAOJOUU6tic82ss/mNlCT8d1OEZ8eaCra8ea+sFqJNknTth
	saA=
X-IronPort-AV: E=Sophos;i="5.82,313,1613404800"; d="scan'208";a="272871475"
Received: from h199-255-45-14.hgst.com (HELO uls-op-cesaep01.wdc.com)
	([199.255.45.14])
	by ob1.hgst.iphmx.com with ESMTP; 21 May 2021 11:01:23 +0800
IronPort-SDR: mfLGy4KFFkaaG++suvM5sjDYTfSla5zalUjEt18PoYrsMk0BWmXF3UVi9zC5mr+mRTGRdS6YN3
	10MzJl60f3/1i+2LITAO/JwV+Q9Cq95j6RAeB4AweUgNTOQ0n2TIllX5qosWq0J+95nlE0LiwK
	ixAxaitlz8R/Kru5CJyMMzx7NgJrgBbHfvtNfVCngk0YWFe80MByxOZL7yddUxFN6p0jwrTNnL
	YPk8vrfVp/sqha70grhLKjVjhRu48cPIDwt3Kfz/Hz5KGZFdk4LXRrhapg5UMhszcOdwaH+Y5l
	Zyeza+0qYMYyXyRZ5FZhiISF
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
	by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384;
	20 May 2021 19:40:58 -0700
IronPort-SDR: mnB/sYa1djSEQS5pmeI1BfkDsJcYpPdnCvkoppqs6mf4LTYCml8iapj0VkDg2rvD2lsIzlmcIY
	umuAukiYrBTPhLn+28h5r6pV8tEsmaggluGFmSGgHBw5ZrOULlCF6qGkdXXgfOFxQN1yIVWDtD
	k8oX31NuZHXii4myQy5mSX7THgcVBm7m5pAxfhOlN0KyW0mdSDvyeVZ5Wx5hG/yCoemRKJ2PGU
	2HQYIyCB8/cRvzw7rKRuMX5U2XWh0oirpWFZB/2yLSV0FlFtweYZr9YyEY3b21wPMxpYTrshyU
	9+s=
WDCIronportException: Internal
Received: from washi.fujisawa.hgst.com ([10.149.53.254])
	by uls-op-cesaip02.wdc.com with ESMTP; 20 May 2021 20:01:22 -0700
From: Damien Le Moal <damien.lemoal@wdc.com>
To: dm-devel@redhat.com, Mike Snitzer <snitzer@redhat.com>,
	linux-block@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Date: Fri, 21 May 2021 12:01:09 +0900
Message-Id: <20210521030119.1209035-2-damien.lemoal@wdc.com>
In-Reply-To: <20210521030119.1209035-1-damien.lemoal@wdc.com>
References: <20210521030119.1209035-1-damien.lemoal@wdc.com>
MIME-Version: 1.0
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
Subject: [dm-devel] [PATCH v3 01/11] block: improve handling of all zones
	reset operation
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
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
the all-zone reset operation by modifying blkdev_zone_mgmt() to not
issue a zone reset operation for conventional, read-only and offline
zones, thus mimicking what an actual reset-all device command does on a
device supporting REQ_OP_ZONE_RESET_ALL. This emulation is done using
the new function blkdev_zone_reset_all_emulated(). The zones needing a
reset are identified using a bitmap that is initialized using a zone
report. Since empty zones do not need a reset, also ignore these zones.
The function blkdev_zone_reset_all() is introduced for block devices
natively supporting reset all operations. blkdev_zone_mgmt() is modified
to call either function to execute an all zone reset request.

Signed-off-by: Damien Le Moal <damien.lemoal@wdc.com>
[hch: split into multiple functions]
Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Hannes Reinecke <hare@suse.de>
---
 block/blk-zoned.c | 117 +++++++++++++++++++++++++++++++++++-----------
 1 file changed, 90 insertions(+), 27 deletions(-)

diff --git a/block/blk-zoned.c b/block/blk-zoned.c
index 250cb76ee615..0ded16b0f713 100644
--- a/block/blk-zoned.c
+++ b/block/blk-zoned.c
@@ -161,18 +161,87 @@ int blkdev_report_zones(struct block_device *bdev, sector_t sector,
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
+}
+
+static int blkdev_zone_reset_all_emulated(struct block_device *bdev,
+					  gfp_t gfp_mask)
+{
+	struct request_queue *q = bdev_get_queue(bdev);
+	sector_t capacity = get_capacity(bdev->bd_disk);
+	sector_t zone_sectors = blk_queue_zone_sectors(q);
+	unsigned long *need_reset;
+	struct bio *bio = NULL;
+	sector_t sector;
+	int ret;
+
+	need_reset = blk_alloc_zone_bitmap(q->node, q->nr_zones);
+	if (!need_reset)
+		return -ENOMEM;
+
+	ret = bdev->bd_disk->fops->report_zones(bdev->bd_disk, 0,
+				q->nr_zones, blk_zone_need_reset_cb,
+				need_reset);
+	if (ret < 0)
+		goto out_free_need_reset;
+
+	ret = 0;
+	while (sector < capacity) {
+		if (!test_bit(blk_queue_zone_no(q, sector), need_reset)) {
+			sector += zone_sectors;
+			continue;
+		}
+		bio = blk_next_bio(bio, 0, gfp_mask);
+		bio_set_dev(bio, bdev);
+		bio->bi_opf = REQ_OP_ZONE_RESET | REQ_SYNC;
+		bio->bi_iter.bi_sector = sector;
+		sector += zone_sectors;
+
+		/* This may take a while, so be nice to others */
+		cond_resched();
+	}
+
+	if (bio) {
+		ret = submit_bio_wait(bio);
+		bio_put(bio);
+	}
+
+out_free_need_reset:
+	kfree(need_reset);
+	return ret;
+}
+
+static int blkdev_zone_reset_all(struct block_device *bdev, gfp_t gfp_mask)
+{
+	struct bio bio;
+
+	bio_init(&bio, NULL, 0);
+	bio_set_dev(&bio, bdev);
+	bio.bi_opf = REQ_OP_ZONE_RESET_ALL | REQ_SYNC;
+	return submit_bio_wait(&bio);
 }
 
 /**
@@ -200,7 +269,7 @@ int blkdev_zone_mgmt(struct block_device *bdev, enum req_opf op,
 	sector_t capacity = get_capacity(bdev->bd_disk);
 	sector_t end_sector = sector + nr_sectors;
 	struct bio *bio = NULL;
-	int ret;
+	int ret = 0;
 
 	if (!blk_queue_is_zoned(q))
 		return -EOPNOTSUPP;
@@ -222,20 +291,21 @@ int blkdev_zone_mgmt(struct block_device *bdev, enum req_opf op,
 	if ((nr_sectors & (zone_sectors - 1)) && end_sector != capacity)
 		return -EINVAL;
 
+	/*
+	 * In the case of a zone reset operation over all zones,
+	 * REQ_OP_ZONE_RESET_ALL can be used with devices supporting this
+	 * command. For other devices, we emulate this command behavior by
+	 * identifying the zones needing a reset.
+	 */
+	if (op == REQ_OP_ZONE_RESET && sector == 0 && nr_sectors == capacity) {
+		if (!blk_queue_zone_resetall(q))
+			return blkdev_zone_reset_all_emulated(bdev, gfp_mask);
+		return blkdev_zone_reset_all(bdev, gfp_mask);
+	}
+
 	while (sector < end_sector) {
 		bio = blk_next_bio(bio, 0, gfp_mask);
 		bio_set_dev(bio, bdev);
-
-		/*
-		 * Special case for the zone reset operation that reset all
-		 * zones, this is useful for applications like mkfs.
-		 */
-		if (op == REQ_OP_ZONE_RESET &&
-		    blkdev_allow_reset_all_zones(bdev, sector, nr_sectors)) {
-			bio->bi_opf = REQ_OP_ZONE_RESET_ALL | REQ_SYNC;
-			break;
-		}
-
 		bio->bi_opf = op | REQ_SYNC;
 		bio->bi_iter.bi_sector = sector;
 		sector += zone_sectors;
@@ -396,13 +466,6 @@ int blkdev_zone_mgmt_ioctl(struct block_device *bdev, fmode_t mode,
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


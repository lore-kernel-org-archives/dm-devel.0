Return-Path: <SRS0=AQTU=KQ=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 73B63C433ED
	for <dm-devel@archiver.kernel.org>; Fri, 21 May 2021 06:04:52 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 02AEE613B4
	for <dm-devel@archiver.kernel.org>; Fri, 21 May 2021 06:04:51 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 02AEE613B4
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-329-x_7D5pkFMWKwpGhkv7wFsg-1; Fri, 21 May 2021 02:04:49 -0400
X-MC-Unique: x_7D5pkFMWKwpGhkv7wFsg-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 687D5801106;
	Fri, 21 May 2021 06:04:44 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 46E815C3DF;
	Fri, 21 May 2021 06:04:44 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 1ECB5180B464;
	Fri, 21 May 2021 06:04:44 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
	[10.11.54.5])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 14L64h53028436 for <dm-devel@listman.util.phx.redhat.com>;
	Fri, 21 May 2021 02:04:43 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id DD39B1649D2; Fri, 21 May 2021 06:04:42 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id D7F7630BA4
	for <dm-devel@redhat.com>; Fri, 21 May 2021 06:04:42 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id C0678185A79C
	for <dm-devel@redhat.com>; Fri, 21 May 2021 06:04:42 +0000 (UTC)
Received: from bombadil.infradead.org (bombadil.infradead.org
	[198.137.202.133]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-330-REm5RFSlNOaBuBOkBCuNnw-1; Fri, 21 May 2021 02:04:40 -0400
X-MC-Unique: REm5RFSlNOaBuBOkBCuNnw-1
Received: from [2001:4bb8:180:5add:4fd7:4137:d2f2:46e6] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.94 #2 (Red Hat Linux))
	id 1ljy4Y-00GpzX-VL; Fri, 21 May 2021 05:51:47 +0000
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
Date: Fri, 21 May 2021 07:50:59 +0200
Message-Id: <20210521055116.1053587-10-hch@lst.de>
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
X-Scanned-By: MIMEDefang 2.79 on 10.11.54.5
X-loop: dm-devel@redhat.com
Cc: linux-xtensa@linux-xtensa.org, linux-m68k@vger.kernel.org,
	linux-raid@vger.kernel.org, nvdimm@lists.linux.dev,
	linux-s390@vger.kernel.org, linux-mmc@vger.kernel.org,
	linux-bcache@vger.kernel.org, linux-nvme@lists.infradead.org,
	linux-block@vger.kernel.org, dm-devel@redhat.com,
	drbd-dev@tron.linbit.com, linuxppc-dev@lists.ozlabs.org
Subject: [dm-devel] [PATCH 09/26] rsxx: convert to
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Convert the rsxx driver to use the blk_alloc_disk and blk_cleanup_disk
helpers to simplify gendisk and request_queue allocation.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/block/rsxx/dev.c       | 39 +++++++++++++---------------------
 drivers/block/rsxx/rsxx_priv.h |  1 -
 2 files changed, 15 insertions(+), 25 deletions(-)

diff --git a/drivers/block/rsxx/dev.c b/drivers/block/rsxx/dev.c
index 9a28322a8cd8..1cc40b0ea761 100644
--- a/drivers/block/rsxx/dev.c
+++ b/drivers/block/rsxx/dev.c
@@ -236,47 +236,40 @@ int rsxx_setup_dev(struct rsxx_cardinfo *card)
 		return -ENOMEM;
 	}
 
-	card->queue = blk_alloc_queue(NUMA_NO_NODE);
-	if (!card->queue) {
-		dev_err(CARD_TO_DEV(card), "Failed queue alloc\n");
-		unregister_blkdev(card->major, DRIVER_NAME);
-		return -ENOMEM;
-	}
-
-	card->gendisk = alloc_disk(blkdev_minors);
+	card->gendisk = blk_alloc_disk(blkdev_minors);
 	if (!card->gendisk) {
 		dev_err(CARD_TO_DEV(card), "Failed disk alloc\n");
-		blk_cleanup_queue(card->queue);
 		unregister_blkdev(card->major, DRIVER_NAME);
 		return -ENOMEM;
 	}
 
 	if (card->config_valid) {
 		blk_size = card->config.data.block_size;
-		blk_queue_dma_alignment(card->queue, blk_size - 1);
-		blk_queue_logical_block_size(card->queue, blk_size);
+		blk_queue_dma_alignment(card->gendisk->queue, blk_size - 1);
+		blk_queue_logical_block_size(card->gendisk->queue, blk_size);
 	}
 
-	blk_queue_max_hw_sectors(card->queue, blkdev_max_hw_sectors);
-	blk_queue_physical_block_size(card->queue, RSXX_HW_BLK_SIZE);
+	blk_queue_max_hw_sectors(card->gendisk->queue, blkdev_max_hw_sectors);
+	blk_queue_physical_block_size(card->gendisk->queue, RSXX_HW_BLK_SIZE);
 
-	blk_queue_flag_set(QUEUE_FLAG_NONROT, card->queue);
-	blk_queue_flag_clear(QUEUE_FLAG_ADD_RANDOM, card->queue);
+	blk_queue_flag_set(QUEUE_FLAG_NONROT, card->gendisk->queue);
+	blk_queue_flag_clear(QUEUE_FLAG_ADD_RANDOM, card->gendisk->queue);
 	if (rsxx_discard_supported(card)) {
-		blk_queue_flag_set(QUEUE_FLAG_DISCARD, card->queue);
-		blk_queue_max_discard_sectors(card->queue,
+		blk_queue_flag_set(QUEUE_FLAG_DISCARD, card->gendisk->queue);
+		blk_queue_max_discard_sectors(card->gendisk->queue,
 						RSXX_HW_BLK_SIZE >> 9);
-		card->queue->limits.discard_granularity = RSXX_HW_BLK_SIZE;
-		card->queue->limits.discard_alignment   = RSXX_HW_BLK_SIZE;
+		card->gendisk->queue->limits.discard_granularity =
+			RSXX_HW_BLK_SIZE;
+		card->gendisk->queue->limits.discard_alignment =
+			RSXX_HW_BLK_SIZE;
 	}
 
 	snprintf(card->gendisk->disk_name, sizeof(card->gendisk->disk_name),
 		 "rsxx%d", card->disk_id);
 	card->gendisk->major = card->major;
-	card->gendisk->first_minor = 0;
+	card->gendisk->minors = blkdev_minors;
 	card->gendisk->fops = &rsxx_fops;
 	card->gendisk->private_data = card;
-	card->gendisk->queue = card->queue;
 
 	return 0;
 }
@@ -286,10 +279,8 @@ void rsxx_destroy_dev(struct rsxx_cardinfo *card)
 	if (!enable_blkdev)
 		return;
 
-	put_disk(card->gendisk);
+	blk_cleanup_disk(card->gendisk);
 	card->gendisk = NULL;
-
-	blk_cleanup_queue(card->queue);
 	unregister_blkdev(card->major, DRIVER_NAME);
 }
 
diff --git a/drivers/block/rsxx/rsxx_priv.h b/drivers/block/rsxx/rsxx_priv.h
index 6147977994ff..26c320c0d924 100644
--- a/drivers/block/rsxx/rsxx_priv.h
+++ b/drivers/block/rsxx/rsxx_priv.h
@@ -154,7 +154,6 @@ struct rsxx_cardinfo {
 	bool			bdev_attached;
 	int			disk_id;
 	int			major;
-	struct request_queue	*queue;
 	struct gendisk		*gendisk;
 	struct {
 		/* Used to convert a byte address to a device address. */
-- 
2.30.2

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel


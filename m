Return-Path: <SRS0=56gb=K4=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 95CB4C47093
	for <dm-devel@archiver.kernel.org>; Wed,  2 Jun 2021 06:56:22 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 37105613AD
	for <dm-devel@archiver.kernel.org>; Wed,  2 Jun 2021 06:56:22 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 37105613AD
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-443-EXMGOl9lNt67ToSvXKFMyg-1; Wed, 02 Jun 2021 02:56:19 -0400
X-MC-Unique: EXMGOl9lNt67ToSvXKFMyg-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 30075100945E;
	Wed,  2 Jun 2021 06:56:14 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 0AA69131D9;
	Wed,  2 Jun 2021 06:56:14 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id CF3781813CA7;
	Wed,  2 Jun 2021 06:56:13 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
	[10.11.54.5])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 1526uCwb017097 for <dm-devel@listman.util.phx.redhat.com>;
	Wed, 2 Jun 2021 02:56:12 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id AB875F41DB; Wed,  2 Jun 2021 06:56:12 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id A0C03F5669
	for <dm-devel@redhat.com>; Wed,  2 Jun 2021 06:56:07 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[207.211.31.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 38AC7100E646
	for <dm-devel@redhat.com>; Wed,  2 Jun 2021 06:56:07 +0000 (UTC)
Received: from bombadil.infradead.org (bombadil.infradead.org
	[198.137.202.133]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-483-G2NP5OjiPgevbtVjww4WfQ-1; Wed, 02 Jun 2021 02:56:04 -0400
X-MC-Unique: G2NP5OjiPgevbtVjww4WfQ-1
Received: from shol69.static.otenet.gr ([83.235.170.67] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
	id 1loKnA-0026PT-6J; Wed, 02 Jun 2021 06:55:53 +0000
From: Christoph Hellwig <hch@lst.de>
To: Jens Axboe <axboe@kernel.dk>
Date: Wed,  2 Jun 2021 09:53:41 +0300
Message-Id: <20210602065345.355274-27-hch@lst.de>
In-Reply-To: <20210602065345.355274-1-hch@lst.de>
References: <20210602065345.355274-1-hch@lst.de>
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
Cc: Justin Sanders <justin@coraid.com>, Vignesh Raghavendra <vigneshr@ti.com>,
	Mike Snitzer <snitzer@redhat.com>, "Michael S. Tsirkin" <mst@redhat.com>,
	Jason Wang <jasowang@redhat.com>,
	virtualization@lists.linux-foundation.org, dm-devel@redhat.com,
	"Md. Haris Iqbal" <haris.iqbal@ionos.com>,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	Jack Wang <jinpu.wang@ionos.com>, Tim Waugh <tim@cyberelk.net>,
	linux-s390@vger.kernel.org, Alex Dubov <oakad@yahoo.com>,
	Richard Weinberger <richard@nod.at>,
	Christian Borntraeger <borntraeger@de.ibm.com>,
	xen-devel@lists.xenproject.org, Ilya Dryomov <idryomov@gmail.com>,
	Vasily Gorbik <gor@linux.ibm.com>,
	Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
	Heiko Carstens <hca@linux.ibm.com>, Josef Bacik <josef@toxicpanda.com>,
	Denis Efremov <efremov@linux.com>, nbd@other.debian.org,
	linux-block@vger.kernel.org, ceph-devel@vger.kernel.org,
	Maxim Levitsky <maximlevitsky@gmail.com>,
	Geoff Levand <geoff@infradead.org>, linux-mmc@vger.kernel.org,
	linux-mtd@lists.infradead.org, linuxppc-dev@lists.ozlabs.org,
	=?UTF-8?q?Roger=20Pau=20Monn=C3=A9?= <roger.pau@citrix.com>
Subject: [dm-devel] [PATCH 26/30] ubi: use blk_mq_alloc_disk and
	blk_cleanup_disk
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
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Use blk_mq_alloc_disk and blk_cleanup_disk to simplify the gendisk and
request_queue allocation.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/mtd/ubi/block.c | 68 ++++++++++++++++++-----------------------
 1 file changed, 29 insertions(+), 39 deletions(-)

diff --git a/drivers/mtd/ubi/block.c b/drivers/mtd/ubi/block.c
index e1a2ae21dfd3..e003b4b44ffa 100644
--- a/drivers/mtd/ubi/block.c
+++ b/drivers/mtd/ubi/block.c
@@ -394,53 +394,46 @@ int ubiblock_create(struct ubi_volume_info *vi)
 	dev->vol_id = vi->vol_id;
 	dev->leb_size = vi->usable_leb_size;
 
+	dev->tag_set.ops = &ubiblock_mq_ops;
+	dev->tag_set.queue_depth = 64;
+	dev->tag_set.numa_node = NUMA_NO_NODE;
+	dev->tag_set.flags = BLK_MQ_F_SHOULD_MERGE;
+	dev->tag_set.cmd_size = sizeof(struct ubiblock_pdu);
+	dev->tag_set.driver_data = dev;
+	dev->tag_set.nr_hw_queues = 1;
+
+	ret = blk_mq_alloc_tag_set(&dev->tag_set);
+	if (ret) {
+		dev_err(disk_to_dev(dev->gd), "blk_mq_alloc_tag_set failed");
+		goto out_free_dev;;
+	}
+
+
 	/* Initialize the gendisk of this ubiblock device */
-	gd = alloc_disk(1);
-	if (!gd) {
-		pr_err("UBI: block: alloc_disk failed\n");
-		ret = -ENODEV;
-		goto out_free_dev;
+	gd = blk_mq_alloc_disk(&dev->tag_set, dev);
+	if (IS_ERR(gd)) {
+		ret = PTR_ERR(gd);
+		goto out_free_tags;
 	}
 
 	gd->fops = &ubiblock_ops;
 	gd->major = ubiblock_major;
+	gd->minors = 1;
 	gd->first_minor = idr_alloc(&ubiblock_minor_idr, dev, 0, 0, GFP_KERNEL);
 	if (gd->first_minor < 0) {
 		dev_err(disk_to_dev(gd),
 			"block: dynamic minor allocation failed");
 		ret = -ENODEV;
-		goto out_put_disk;
+		goto out_cleanup_disk;
 	}
 	gd->private_data = dev;
 	sprintf(gd->disk_name, "ubiblock%d_%d", dev->ubi_num, dev->vol_id);
 	set_capacity(gd, disk_capacity);
 	dev->gd = gd;
 
-	dev->tag_set.ops = &ubiblock_mq_ops;
-	dev->tag_set.queue_depth = 64;
-	dev->tag_set.numa_node = NUMA_NO_NODE;
-	dev->tag_set.flags = BLK_MQ_F_SHOULD_MERGE;
-	dev->tag_set.cmd_size = sizeof(struct ubiblock_pdu);
-	dev->tag_set.driver_data = dev;
-	dev->tag_set.nr_hw_queues = 1;
-
-	ret = blk_mq_alloc_tag_set(&dev->tag_set);
-	if (ret) {
-		dev_err(disk_to_dev(dev->gd), "blk_mq_alloc_tag_set failed");
-		goto out_remove_minor;
-	}
-
-	dev->rq = blk_mq_init_queue(&dev->tag_set);
-	if (IS_ERR(dev->rq)) {
-		dev_err(disk_to_dev(gd), "blk_mq_init_queue failed");
-		ret = PTR_ERR(dev->rq);
-		goto out_free_tags;
-	}
+	dev->rq = gd->queue;
 	blk_queue_max_segments(dev->rq, UBI_MAX_SG_COUNT);
 
-	dev->rq->queuedata = dev;
-	dev->gd->queue = dev->rq;
-
 	/*
 	 * Create one workqueue per volume (per registered block device).
 	 * Rembember workqueues are cheap, they're not threads.
@@ -448,7 +441,7 @@ int ubiblock_create(struct ubi_volume_info *vi)
 	dev->wq = alloc_workqueue("%s", 0, 0, gd->disk_name);
 	if (!dev->wq) {
 		ret = -ENOMEM;
-		goto out_free_queue;
+		goto out_remove_minor;
 	}
 
 	list_add_tail(&dev->list, &ubiblock_devices);
@@ -460,14 +453,12 @@ int ubiblock_create(struct ubi_volume_info *vi)
 	mutex_unlock(&devices_mutex);
 	return 0;
 
-out_free_queue:
-	blk_cleanup_queue(dev->rq);
-out_free_tags:
-	blk_mq_free_tag_set(&dev->tag_set);
 out_remove_minor:
 	idr_remove(&ubiblock_minor_idr, gd->first_minor);
-out_put_disk:
-	put_disk(dev->gd);
+out_cleanup_disk:
+	blk_cleanup_disk(dev->gd);
+out_free_tags:
+	blk_mq_free_tag_set(&dev->tag_set);
 out_free_dev:
 	kfree(dev);
 out_unlock:
@@ -483,11 +474,10 @@ static void ubiblock_cleanup(struct ubiblock *dev)
 	/* Flush pending work */
 	destroy_workqueue(dev->wq);
 	/* Finally destroy the blk queue */
-	blk_cleanup_queue(dev->rq);
-	blk_mq_free_tag_set(&dev->tag_set);
 	dev_info(disk_to_dev(dev->gd), "released");
+	blk_cleanup_disk(dev->gd);
+	blk_mq_free_tag_set(&dev->tag_set);
 	idr_remove(&ubiblock_minor_idr, dev->gd->first_minor);
-	put_disk(dev->gd);
 }
 
 int ubiblock_remove(struct ubi_volume_info *vi)
-- 
2.30.2

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel


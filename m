Return-Path: <SRS0=56gb=K4=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8441BC4708F
	for <dm-devel@archiver.kernel.org>; Wed,  2 Jun 2021 07:33:42 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 177626138C
	for <dm-devel@archiver.kernel.org>; Wed,  2 Jun 2021 07:33:41 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 177626138C
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-561-yYmCXPovOJuDkECNStIDKA-1; Wed, 02 Jun 2021 03:33:39 -0400
X-MC-Unique: yYmCXPovOJuDkECNStIDKA-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 3BC09106BB3A;
	Wed,  2 Jun 2021 07:33:34 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id DAF3169FB2;
	Wed,  2 Jun 2021 07:33:33 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 3742B4ED79;
	Wed,  2 Jun 2021 07:33:33 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
	[10.11.54.6])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 1527XUSW020502 for <dm-devel@listman.util.phx.redhat.com>;
	Wed, 2 Jun 2021 03:33:30 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id BA7AD21623A9; Wed,  2 Jun 2021 07:33:30 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id B647A21623A6
	for <dm-devel@redhat.com>; Wed,  2 Jun 2021 07:33:27 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 82E0280D0E1
	for <dm-devel@redhat.com>; Wed,  2 Jun 2021 07:33:27 +0000 (UTC)
Received: from bombadil.infradead.org (bombadil.infradead.org
	[198.137.202.133]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-216-tdKiDsRBNDqtBSC6qxSq5Q-1; Wed, 02 Jun 2021 03:33:23 -0400
X-MC-Unique: tdKiDsRBNDqtBSC6qxSq5Q-1
Received: from shol69.static.otenet.gr ([83.235.170.67] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
	id 1loKm2-0025WN-Lj; Wed, 02 Jun 2021 06:54:43 +0000
From: Christoph Hellwig <hch@lst.de>
To: Jens Axboe <axboe@kernel.dk>
Date: Wed,  2 Jun 2021 09:53:25 +0300
Message-Id: <20210602065345.355274-11-hch@lst.de>
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
X-Mimecast-Spam-Signature: yes
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.6
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
Subject: [dm-devel] [PATCH 10/30] ps3disk: use blk_mq_alloc_disk
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

Use the blk_mq_alloc_disk API to simplify the gendisk and request_queue
allocation.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/block/ps3disk.c | 36 ++++++++++++++----------------------
 1 file changed, 14 insertions(+), 22 deletions(-)

diff --git a/drivers/block/ps3disk.c b/drivers/block/ps3disk.c
index ba3ece56cbb3..f374ea2c67ce 100644
--- a/drivers/block/ps3disk.c
+++ b/drivers/block/ps3disk.c
@@ -29,7 +29,6 @@
 
 struct ps3disk_private {
 	spinlock_t lock;		/* Request queue spinlock */
-	struct request_queue *queue;
 	struct blk_mq_tag_set tag_set;
 	struct gendisk *gendisk;
 	unsigned int blocking_factor;
@@ -267,7 +266,7 @@ static irqreturn_t ps3disk_interrupt(int irq, void *data)
 	blk_mq_end_request(req, error);
 	spin_unlock(&priv->lock);
 
-	blk_mq_run_hw_queues(priv->queue, true);
+	blk_mq_run_hw_queues(priv->gendisk->queue, true);
 	return IRQ_HANDLED;
 }
 
@@ -441,17 +440,20 @@ static int ps3disk_probe(struct ps3_system_bus_device *_dev)
 
 	ps3disk_identify(dev);
 
-	queue = blk_mq_init_sq_queue(&priv->tag_set, &ps3disk_mq_ops, 1,
+	error = blk_mq_alloc_sq_tag_set(&priv->tag_set, &ps3disk_mq_ops, 1,
 					BLK_MQ_F_SHOULD_MERGE);
-	if (IS_ERR(queue)) {
-		dev_err(&dev->sbd.core, "%s:%u: blk_mq_init_queue failed\n",
-			__func__, __LINE__);
-		error = PTR_ERR(queue);
+	if (error)
 		goto fail_teardown;
+
+	gendisk = blk_mq_alloc_disk(&priv->tag_set, dev);
+	if (IS_ERR(gendisk)) {
+		dev_err(&dev->sbd.core, "%s:%u: blk_mq_alloc_disk failed\n",
+			__func__, __LINE__);
+		error = PTR_ERR(gendisk);
+		goto fail_free_tag_set;
 	}
 
-	priv->queue = queue;
-	queue->queuedata = dev;
+	queue = gendisk->queue;
 
 	blk_queue_max_hw_sectors(queue, dev->bounce_size >> 9);
 	blk_queue_dma_alignment(queue, dev->blk_size-1);
@@ -462,19 +464,11 @@ static int ps3disk_probe(struct ps3_system_bus_device *_dev)
 	blk_queue_max_segments(queue, -1);
 	blk_queue_max_segment_size(queue, dev->bounce_size);
 
-	gendisk = alloc_disk(PS3DISK_MINORS);
-	if (!gendisk) {
-		dev_err(&dev->sbd.core, "%s:%u: alloc_disk failed\n", __func__,
-			__LINE__);
-		error = -ENOMEM;
-		goto fail_cleanup_queue;
-	}
-
 	priv->gendisk = gendisk;
 	gendisk->major = ps3disk_major;
 	gendisk->first_minor = devidx * PS3DISK_MINORS;
+	gendisk->minors = PS3DISK_MINORS;
 	gendisk->fops = &ps3disk_fops;
-	gendisk->queue = queue;
 	gendisk->private_data = dev;
 	snprintf(gendisk->disk_name, sizeof(gendisk->disk_name), PS3DISK_NAME,
 		 devidx+'a');
@@ -490,8 +484,7 @@ static int ps3disk_probe(struct ps3_system_bus_device *_dev)
 	device_add_disk(&dev->sbd.core, gendisk, NULL);
 	return 0;
 
-fail_cleanup_queue:
-	blk_cleanup_queue(queue);
+fail_free_tag_set:
 	blk_mq_free_tag_set(&priv->tag_set);
 fail_teardown:
 	ps3stor_teardown(dev);
@@ -517,9 +510,8 @@ static void ps3disk_remove(struct ps3_system_bus_device *_dev)
 		    &ps3disk_mask);
 	mutex_unlock(&ps3disk_mask_mutex);
 	del_gendisk(priv->gendisk);
-	blk_cleanup_queue(priv->queue);
+	blk_cleanup_disk(priv->gendisk);
 	blk_mq_free_tag_set(&priv->tag_set);
-	put_disk(priv->gendisk);
 	dev_notice(&dev->sbd.core, "Synchronizing disk cache\n");
 	ps3disk_sync_cache(dev);
 	ps3stor_teardown(dev);
-- 
2.30.2

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel


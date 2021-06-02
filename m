Return-Path: <SRS0=56gb=K4=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B594CC47083
	for <dm-devel@archiver.kernel.org>; Wed,  2 Jun 2021 06:56:10 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 5C13E61359
	for <dm-devel@archiver.kernel.org>; Wed,  2 Jun 2021 06:56:10 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 5C13E61359
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-512-4lYzahmIMV2nphhwHyrjJA-1; Wed, 02 Jun 2021 02:56:07 -0400
X-MC-Unique: 4lYzahmIMV2nphhwHyrjJA-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 8F9E4180FD66;
	Wed,  2 Jun 2021 06:56:03 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 6F3E061140;
	Wed,  2 Jun 2021 06:56:03 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 37D451801267;
	Wed,  2 Jun 2021 06:56:03 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
	[10.11.54.6])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 1526u08l016888 for <dm-devel@listman.util.phx.redhat.com>;
	Wed, 2 Jun 2021 02:56:00 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 6310821CAC63; Wed,  2 Jun 2021 06:56:00 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 5E9D321CAC64
	for <dm-devel@redhat.com>; Wed,  2 Jun 2021 06:55:58 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 26C18857AA4
	for <dm-devel@redhat.com>; Wed,  2 Jun 2021 06:55:58 +0000 (UTC)
Received: from bombadil.infradead.org (bombadil.infradead.org
	[198.137.202.133]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-408-_tRCF9JEO5OzQoEDydaqtQ-1; Wed, 02 Jun 2021 02:55:53 -0400
X-MC-Unique: _tRCF9JEO5OzQoEDydaqtQ-1
Received: from shol69.static.otenet.gr ([83.235.170.67] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
	id 1loKmx-0026Co-6G; Wed, 02 Jun 2021 06:55:40 +0000
From: Christoph Hellwig <hch@lst.de>
To: Jens Axboe <axboe@kernel.dk>
Date: Wed,  2 Jun 2021 09:53:38 +0300
Message-Id: <20210602065345.355274-24-hch@lst.de>
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
Subject: [dm-devel] [PATCH 23/30] rnbd: use blk_mq_alloc_disk and
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
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
 drivers/block/rnbd/rnbd-clt.c | 35 ++++++++---------------------------
 1 file changed, 8 insertions(+), 27 deletions(-)

diff --git a/drivers/block/rnbd/rnbd-clt.c b/drivers/block/rnbd/rnbd-clt.c
index c604a402cd5c..f4fa45d24c0b 100644
--- a/drivers/block/rnbd/rnbd-clt.c
+++ b/drivers/block/rnbd/rnbd-clt.c
@@ -1353,18 +1353,6 @@ static void rnbd_init_mq_hw_queues(struct rnbd_clt_dev *dev)
 	}
 }
 
-static int setup_mq_dev(struct rnbd_clt_dev *dev)
-{
-	dev->queue = blk_mq_init_queue(&dev->sess->tag_set);
-	if (IS_ERR(dev->queue)) {
-		rnbd_clt_err(dev, "Initializing multiqueue queue failed, err: %ld\n",
-			      PTR_ERR(dev->queue));
-		return PTR_ERR(dev->queue);
-	}
-	rnbd_init_mq_hw_queues(dev);
-	return 0;
-}
-
 static void setup_request_queue(struct rnbd_clt_dev *dev)
 {
 	blk_queue_logical_block_size(dev->queue, dev->logical_block_size);
@@ -1393,13 +1381,13 @@ static void setup_request_queue(struct rnbd_clt_dev *dev)
 	blk_queue_io_opt(dev->queue, dev->sess->max_io_size);
 	blk_queue_virt_boundary(dev->queue, SZ_4K - 1);
 	blk_queue_write_cache(dev->queue, dev->wc, dev->fua);
-	dev->queue->queuedata = dev;
 }
 
 static void rnbd_clt_setup_gen_disk(struct rnbd_clt_dev *dev, int idx)
 {
 	dev->gd->major		= rnbd_client_major;
 	dev->gd->first_minor	= idx << RNBD_PART_BITS;
+	dev->gd->minors		= 1 << RNBD_PART_BITS;
 	dev->gd->fops		= &rnbd_client_ops;
 	dev->gd->queue		= dev->queue;
 	dev->gd->private_data	= dev;
@@ -1426,24 +1414,18 @@ static void rnbd_clt_setup_gen_disk(struct rnbd_clt_dev *dev, int idx)
 
 static int rnbd_client_setup_device(struct rnbd_clt_dev *dev)
 {
-	int err, idx = dev->clt_device_id;
+	int idx = dev->clt_device_id;
 
 	dev->size = dev->nsectors * dev->logical_block_size;
 
-	err = setup_mq_dev(dev);
-	if (err)
-		return err;
+	dev->gd = blk_mq_alloc_disk(&dev->sess->tag_set, dev);
+	if (IS_ERR(dev->gd))
+		return PTR_ERR(dev->gd);
+	dev->queue = dev->gd->queue;
+	rnbd_init_mq_hw_queues(dev);
 
 	setup_request_queue(dev);
-
-	dev->gd = alloc_disk_node(1 << RNBD_PART_BITS,	NUMA_NO_NODE);
-	if (!dev->gd) {
-		blk_cleanup_queue(dev->queue);
-		return -ENOMEM;
-	}
-
 	rnbd_clt_setup_gen_disk(dev, idx);
-
 	return 0;
 }
 
@@ -1650,8 +1632,7 @@ struct rnbd_clt_dev *rnbd_clt_map_device(const char *sessname,
 static void destroy_gen_disk(struct rnbd_clt_dev *dev)
 {
 	del_gendisk(dev->gd);
-	blk_cleanup_queue(dev->queue);
-	put_disk(dev->gd);
+	blk_cleanup_disk(dev->gd);
 }
 
 static void destroy_sysfs(struct rnbd_clt_dev *dev,
-- 
2.30.2

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel


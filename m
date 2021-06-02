Return-Path: <SRS0=56gb=K4=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 436D7C4708F
	for <dm-devel@archiver.kernel.org>; Wed,  2 Jun 2021 07:14:15 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 9C0DB61376
	for <dm-devel@archiver.kernel.org>; Wed,  2 Jun 2021 07:14:14 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 9C0DB61376
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-143-tfK3_GG6MFKfh61qq4A04w-1; Wed, 02 Jun 2021 03:14:11 -0400
X-MC-Unique: tfK3_GG6MFKfh61qq4A04w-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A48048015F5;
	Wed,  2 Jun 2021 07:14:06 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 78BBA10013D6;
	Wed,  2 Jun 2021 07:14:06 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id EAF2C1801264;
	Wed,  2 Jun 2021 07:14:05 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
	[10.11.54.3])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 1527E3Fj019130 for <dm-devel@listman.util.phx.redhat.com>;
	Wed, 2 Jun 2021 03:14:04 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id D960C112CA3A; Wed,  2 Jun 2021 07:14:03 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id D4AC3112CA38
	for <dm-devel@redhat.com>; Wed,  2 Jun 2021 07:13:58 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[207.211.31.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 7E2BA80D0E0
	for <dm-devel@redhat.com>; Wed,  2 Jun 2021 07:13:58 +0000 (UTC)
Received: from bombadil.infradead.org (bombadil.infradead.org
	[198.137.202.133]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-381-Nwx94wF3Mh26Cy1XlTEldA-1; Wed, 02 Jun 2021 03:13:56 -0400
X-MC-Unique: Nwx94wF3Mh26Cy1XlTEldA-1
Received: from shol69.static.otenet.gr ([83.235.170.67] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
	id 1loKly-0025TX-SP; Wed, 02 Jun 2021 06:54:39 +0000
From: Christoph Hellwig <hch@lst.de>
To: Jens Axboe <axboe@kernel.dk>
Date: Wed,  2 Jun 2021 09:53:24 +0300
Message-Id: <20210602065345.355274-10-hch@lst.de>
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
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.3
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
Subject: [dm-devel] [PATCH 09/30] mtd_blkdevs: use blk_mq_alloc_disk
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

Use the blk_mq_alloc_disk API to simplify the gendisk and request_queue
allocation.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/mtd/mtd_blkdevs.c | 48 ++++++++++++++++++---------------------
 1 file changed, 22 insertions(+), 26 deletions(-)

diff --git a/drivers/mtd/mtd_blkdevs.c b/drivers/mtd/mtd_blkdevs.c
index fb8e12d590a1..5dc4c966ea73 100644
--- a/drivers/mtd/mtd_blkdevs.c
+++ b/drivers/mtd/mtd_blkdevs.c
@@ -30,11 +30,9 @@ static void blktrans_dev_release(struct kref *kref)
 	struct mtd_blktrans_dev *dev =
 		container_of(kref, struct mtd_blktrans_dev, ref);
 
-	dev->disk->private_data = NULL;
-	blk_cleanup_queue(dev->rq);
+	blk_cleanup_disk(dev->disk);
 	blk_mq_free_tag_set(dev->tag_set);
 	kfree(dev->tag_set);
-	put_disk(dev->disk);
 	list_del(&dev->list);
 	kfree(dev);
 }
@@ -354,7 +352,7 @@ int add_mtd_blktrans_dev(struct mtd_blktrans_dev *new)
 	if (new->devnum > (MINORMASK >> tr->part_bits) ||
 	    (tr->part_bits && new->devnum >= 27 * 26)) {
 		mutex_unlock(&blktrans_ref_mutex);
-		goto error1;
+		return ret;
 	}
 
 	list_add_tail(&new->list, &tr->devs);
@@ -366,17 +364,28 @@ int add_mtd_blktrans_dev(struct mtd_blktrans_dev *new)
 	if (!tr->writesect)
 		new->readonly = 1;
 
-	/* Create gendisk */
 	ret = -ENOMEM;
-	gd = alloc_disk(1 << tr->part_bits);
+	new->tag_set = kzalloc(sizeof(*new->tag_set), GFP_KERNEL);
+	if (!new->tag_set)
+		goto out_list_del;
 
-	if (!gd)
-		goto error2;
+	ret = blk_mq_alloc_sq_tag_set(new->tag_set, &mtd_mq_ops, 2,
+			BLK_MQ_F_SHOULD_MERGE | BLK_MQ_F_BLOCKING);
+	if (ret)
+		goto out_kfree_tag_set;
+
+	/* Create gendisk */
+	gd = blk_mq_alloc_disk(new->tag_set, new);
+	if (IS_ERR(gd)) {
+		ret = PTR_ERR(gd);
+		goto out_free_tag_set;
+	}
 
 	new->disk = gd;
 	gd->private_data = new;
 	gd->major = tr->major;
 	gd->first_minor = (new->devnum) << tr->part_bits;
+	gd->minors = 1 << tr->part_bits;
 	gd->fops = &mtd_block_ops;
 
 	if (tr->part_bits)
@@ -398,22 +407,9 @@ int add_mtd_blktrans_dev(struct mtd_blktrans_dev *new)
 	spin_lock_init(&new->queue_lock);
 	INIT_LIST_HEAD(&new->rq_list);
 
-	new->tag_set = kzalloc(sizeof(*new->tag_set), GFP_KERNEL);
-	if (!new->tag_set)
-		goto error3;
-
-	new->rq = blk_mq_init_sq_queue(new->tag_set, &mtd_mq_ops, 2,
-				BLK_MQ_F_SHOULD_MERGE | BLK_MQ_F_BLOCKING);
-	if (IS_ERR(new->rq)) {
-		ret = PTR_ERR(new->rq);
-		new->rq = NULL;
-		goto error4;
-	}
-
 	if (tr->flush)
 		blk_queue_write_cache(new->rq, true, false);
 
-	new->rq->queuedata = new;
 	blk_queue_logical_block_size(new->rq, tr->blksize);
 
 	blk_queue_flag_set(QUEUE_FLAG_NONROT, new->rq);
@@ -437,13 +433,13 @@ int add_mtd_blktrans_dev(struct mtd_blktrans_dev *new)
 		WARN_ON(ret);
 	}
 	return 0;
-error4:
+
+out_free_tag_set:
+	blk_mq_free_tag_set(new->tag_set);
+out_kfree_tag_set:
 	kfree(new->tag_set);
-error3:
-	put_disk(new->disk);
-error2:
+out_list_del:
 	list_del(&new->list);
-error1:
 	return ret;
 }
 
-- 
2.30.2

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel


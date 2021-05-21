Return-Path: <SRS0=AQTU=KQ=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A2DD1C43461
	for <dm-devel@archiver.kernel.org>; Fri, 21 May 2021 05:53:09 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 3DC2F613B6
	for <dm-devel@archiver.kernel.org>; Fri, 21 May 2021 05:53:09 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 3DC2F613B6
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-348-3-Sf17VmMWKHzNPUJfGXYw-1; Fri, 21 May 2021 01:53:06 -0400
X-MC-Unique: 3-Sf17VmMWKHzNPUJfGXYw-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 22BF5802939;
	Fri, 21 May 2021 05:53:03 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 954DA1009962;
	Fri, 21 May 2021 05:53:02 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 6D06F180B464;
	Fri, 21 May 2021 05:53:02 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
	[10.11.54.3])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 14L5r1CQ027329 for <dm-devel@listman.util.phx.redhat.com>;
	Fri, 21 May 2021 01:53:01 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 2DD6B10031EF; Fri, 21 May 2021 05:53:01 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 280E0107CCE4
	for <dm-devel@redhat.com>; Fri, 21 May 2021 05:52:58 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 90D2B80122D
	for <dm-devel@redhat.com>; Fri, 21 May 2021 05:52:58 +0000 (UTC)
Received: from bombadil.infradead.org (bombadil.infradead.org
	[198.137.202.133]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-240-UtbT4eL8OlypnBqbxMFoyw-1; Fri, 21 May 2021 01:52:56 -0400
X-MC-Unique: UtbT4eL8OlypnBqbxMFoyw-1
Received: from [2001:4bb8:180:5add:4fd7:4137:d2f2:46e6] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.94 #2 (Red Hat Linux))
	id 1ljy5S-00GqGW-Ms; Fri, 21 May 2021 05:52:43 +0000
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
Date: Fri, 21 May 2021 07:51:15 +0200
Message-Id: <20210521055116.1053587-26-hch@lst.de>
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
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.3
X-loop: dm-devel@redhat.com
Cc: linux-xtensa@linux-xtensa.org, linux-m68k@vger.kernel.org,
	linux-raid@vger.kernel.org, nvdimm@lists.linux.dev,
	linux-s390@vger.kernel.org, linux-mmc@vger.kernel.org,
	linux-bcache@vger.kernel.org, linux-nvme@lists.infradead.org,
	linux-block@vger.kernel.org, dm-devel@redhat.com,
	drbd-dev@tron.linbit.com, linuxppc-dev@lists.ozlabs.org
Subject: [dm-devel] [PATCH 25/26] null_blk: convert to
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
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Convert the null_blk driver to use the blk_alloc_disk and blk_cleanup_disk
helpers to simplify gendisk and request_queue allocation.  Note that the
blk-mq mode is left with its own allocations scheme, to be handled later.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/block/null_blk/main.c | 38 +++++++++++++++++------------------
 1 file changed, 19 insertions(+), 19 deletions(-)

diff --git a/drivers/block/null_blk/main.c b/drivers/block/null_blk/main.c
index 5f006d9e1472..d8e098f1e5b5 100644
--- a/drivers/block/null_blk/main.c
+++ b/drivers/block/null_blk/main.c
@@ -1597,11 +1597,10 @@ static void null_del_dev(struct nullb *nullb)
 		null_restart_queue_async(nullb);
 	}
 
-	blk_cleanup_queue(nullb->q);
+	blk_cleanup_disk(nullb->disk);
 	if (dev->queue_mode == NULL_Q_MQ &&
 	    nullb->tag_set == &nullb->__tag_set)
 		blk_mq_free_tag_set(nullb->tag_set);
-	put_disk(nullb->disk);
 	cleanup_queues(nullb);
 	if (null_cache_active(nullb))
 		null_free_device_storage(nullb->dev, true);
@@ -1700,22 +1699,19 @@ static int init_driver_queues(struct nullb *nullb)
 static int null_gendisk_register(struct nullb *nullb)
 {
 	sector_t size = ((sector_t)nullb->dev->size * SZ_1M) >> SECTOR_SHIFT;
-	struct gendisk *disk;
+	struct gendisk *disk = nullb->disk;
 
-	disk = nullb->disk = alloc_disk_node(1, nullb->dev->home_node);
-	if (!disk)
-		return -ENOMEM;
 	set_capacity(disk, size);
 
 	disk->flags |= GENHD_FL_EXT_DEVT | GENHD_FL_SUPPRESS_PARTITION_INFO;
 	disk->major		= null_major;
 	disk->first_minor	= nullb->index;
+	disk->minors		= 1;
 	if (queue_is_mq(nullb->q))
 		disk->fops		= &null_rq_ops;
 	else
 		disk->fops		= &null_bio_ops;
 	disk->private_data	= nullb;
-	disk->queue		= nullb->q;
 	strncpy(disk->disk_name, nullb->disk_name, DISK_NAME_LEN);
 
 	if (nullb->dev->zoned) {
@@ -1851,23 +1847,27 @@ static int null_add_dev(struct nullb_device *dev)
 			goto out_cleanup_queues;
 
 		if (!null_setup_fault())
-			goto out_cleanup_queues;
+			goto out_cleanup_tags;
 
+		rv = -ENOMEM;
 		nullb->tag_set->timeout = 5 * HZ;
 		nullb->q = blk_mq_init_queue_data(nullb->tag_set, nullb);
-		if (IS_ERR(nullb->q)) {
-			rv = -ENOMEM;
+		if (IS_ERR(nullb->q))
 			goto out_cleanup_tags;
-		}
+		nullb->disk = alloc_disk_node(1, nullb->dev->home_node);
+		if (!nullb->disk)
+			goto out_cleanup_disk;
+		nullb->disk->queue = nullb->q;
 	} else if (dev->queue_mode == NULL_Q_BIO) {
-		nullb->q = blk_alloc_queue(dev->home_node);
-		if (!nullb->q) {
-			rv = -ENOMEM;
+		rv = -ENOMEM;
+		nullb->disk = blk_alloc_disk(nullb->dev->home_node);
+		if (!nullb->disk)
 			goto out_cleanup_queues;
-		}
+
+		nullb->q = nullb->disk->queue;
 		rv = init_driver_queues(nullb);
 		if (rv)
-			goto out_cleanup_blk_queue;
+			goto out_cleanup_disk;
 	}
 
 	if (dev->mbps) {
@@ -1883,7 +1883,7 @@ static int null_add_dev(struct nullb_device *dev)
 	if (dev->zoned) {
 		rv = null_init_zoned_dev(dev, nullb->q);
 		if (rv)
-			goto out_cleanup_blk_queue;
+			goto out_cleanup_disk;
 	}
 
 	nullb->q->queuedata = nullb;
@@ -1921,8 +1921,8 @@ static int null_add_dev(struct nullb_device *dev)
 	return 0;
 out_cleanup_zone:
 	null_free_zoned_dev(dev);
-out_cleanup_blk_queue:
-	blk_cleanup_queue(nullb->q);
+out_cleanup_disk:
+	blk_cleanup_disk(nullb->disk);
 out_cleanup_tags:
 	if (dev->queue_mode == NULL_Q_MQ && nullb->tag_set == &nullb->__tag_set)
 		blk_mq_free_tag_set(nullb->tag_set);
-- 
2.30.2

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel


Return-Path: <SRS0=AQTU=KQ=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 68DACC43462
	for <dm-devel@archiver.kernel.org>; Fri, 21 May 2021 05:52:59 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id F18BA6128A
	for <dm-devel@archiver.kernel.org>; Fri, 21 May 2021 05:52:58 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org F18BA6128A
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-44-DHg815PmOo6Zjnmbja0_RA-1; Fri, 21 May 2021 01:52:55 -0400
X-MC-Unique: DHg815PmOo6Zjnmbja0_RA-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 3403780293B;
	Fri, 21 May 2021 05:52:52 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 185C060C4A;
	Fri, 21 May 2021 05:52:52 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id DF3E344A5C;
	Fri, 21 May 2021 05:52:51 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
	[10.11.54.3])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 14L5qnKJ027281 for <dm-devel@listman.util.phx.redhat.com>;
	Fri, 21 May 2021 01:52:50 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id D89741084486; Fri, 21 May 2021 05:52:49 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id D427D107CCE4
	for <dm-devel@redhat.com>; Fri, 21 May 2021 05:52:49 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[207.211.31.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id BC17F80D0E0
	for <dm-devel@redhat.com>; Fri, 21 May 2021 05:52:49 +0000 (UTC)
Received: from bombadil.infradead.org (bombadil.infradead.org
	[198.137.202.133]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-333-Da4-94KyMK2czAiTA4HVng-1; Fri, 21 May 2021 01:52:47 -0400
X-MC-Unique: Da4-94KyMK2czAiTA4HVng-1
Received: from [2001:4bb8:180:5add:4fd7:4137:d2f2:46e6] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.94 #2 (Red Hat Linux))
	id 1ljy5H-00GqDA-1a; Fri, 21 May 2021 05:52:31 +0000
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
Date: Fri, 21 May 2021 07:51:12 +0200
Message-Id: <20210521055116.1053587-23-hch@lst.de>
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
Subject: [dm-devel] [PATCH 22/26] ps3vram: convert to
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Convert the ps3vram driver to use the blk_alloc_disk and blk_cleanup_disk
helpers to simplify gendisk and request_queue allocation.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/block/ps3vram.c | 31 ++++++++-----------------------
 1 file changed, 8 insertions(+), 23 deletions(-)

diff --git a/drivers/block/ps3vram.c b/drivers/block/ps3vram.c
index 1d738999fb69..7fbf469651c4 100644
--- a/drivers/block/ps3vram.c
+++ b/drivers/block/ps3vram.c
@@ -67,7 +67,6 @@ struct ps3vram_cache {
 };
 
 struct ps3vram_priv {
-	struct request_queue *queue;
 	struct gendisk *gendisk;
 
 	u64 size;
@@ -613,7 +612,6 @@ static int ps3vram_probe(struct ps3_system_bus_device *dev)
 {
 	struct ps3vram_priv *priv;
 	int error, status;
-	struct request_queue *queue;
 	struct gendisk *gendisk;
 	u64 ddr_size, ddr_lpar, ctrl_lpar, info_lpar, reports_lpar,
 	    reports_size, xdr_lpar;
@@ -736,33 +734,23 @@ static int ps3vram_probe(struct ps3_system_bus_device *dev)
 
 	ps3vram_proc_init(dev);
 
-	queue = blk_alloc_queue(NUMA_NO_NODE);
-	if (!queue) {
-		dev_err(&dev->core, "blk_alloc_queue failed\n");
-		error = -ENOMEM;
-		goto out_cache_cleanup;
-	}
-
-	priv->queue = queue;
-	blk_queue_max_segments(queue, BLK_MAX_SEGMENTS);
-	blk_queue_max_segment_size(queue, BLK_MAX_SEGMENT_SIZE);
-	blk_queue_max_hw_sectors(queue, BLK_SAFE_MAX_SECTORS);
-
-	gendisk = alloc_disk(1);
+	gendisk = blk_alloc_disk(NUMA_NO_NODE);
 	if (!gendisk) {
-		dev_err(&dev->core, "alloc_disk failed\n");
+		dev_err(&dev->core, "blk_alloc_disk failed\n");
 		error = -ENOMEM;
-		goto fail_cleanup_queue;
+		goto out_cache_cleanup;
 	}
 
 	priv->gendisk = gendisk;
 	gendisk->major = ps3vram_major;
-	gendisk->first_minor = 0;
+	gendisk->minors = 1;
 	gendisk->fops = &ps3vram_fops;
-	gendisk->queue = queue;
 	gendisk->private_data = dev;
 	strlcpy(gendisk->disk_name, DEVICE_NAME, sizeof(gendisk->disk_name));
 	set_capacity(gendisk, priv->size >> 9);
+	blk_queue_max_segments(gendisk->queue, BLK_MAX_SEGMENTS);
+	blk_queue_max_segment_size(gendisk->queue, BLK_MAX_SEGMENT_SIZE);
+	blk_queue_max_hw_sectors(gendisk->queue, BLK_SAFE_MAX_SECTORS);
 
 	dev_info(&dev->core, "%s: Using %llu MiB of GPU memory\n",
 		 gendisk->disk_name, get_capacity(gendisk) >> 11);
@@ -770,8 +758,6 @@ static int ps3vram_probe(struct ps3_system_bus_device *dev)
 	device_add_disk(&dev->core, gendisk, NULL);
 	return 0;
 
-fail_cleanup_queue:
-	blk_cleanup_queue(queue);
 out_cache_cleanup:
 	remove_proc_entry(DEVICE_NAME, NULL);
 	ps3vram_cache_cleanup(dev);
@@ -802,8 +788,7 @@ static void ps3vram_remove(struct ps3_system_bus_device *dev)
 	struct ps3vram_priv *priv = ps3_system_bus_get_drvdata(dev);
 
 	del_gendisk(priv->gendisk);
-	put_disk(priv->gendisk);
-	blk_cleanup_queue(priv->queue);
+	blk_cleanup_disk(priv->gendisk);
 	remove_proc_entry(DEVICE_NAME, NULL);
 	ps3vram_cache_cleanup(dev);
 	iounmap(priv->reports);
-- 
2.30.2

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel


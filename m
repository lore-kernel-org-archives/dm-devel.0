Return-Path: <SRS0=AQTU=KQ=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 36D97C43460
	for <dm-devel@archiver.kernel.org>; Fri, 21 May 2021 05:53:09 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id ADD97613B4
	for <dm-devel@archiver.kernel.org>; Fri, 21 May 2021 05:53:08 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org ADD97613B4
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-21-9SSKCWfIO_if1nBPEU72gA-1; Fri, 21 May 2021 01:53:06 -0400
X-MC-Unique: 9SSKCWfIO_if1nBPEU72gA-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 3CFBB107ACE4;
	Fri, 21 May 2021 05:53:01 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 1BD9B9473;
	Fri, 21 May 2021 05:53:01 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id E1DFB44A5C;
	Fri, 21 May 2021 05:53:00 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
	[10.11.54.5])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 14L5qxb8027311 for <dm-devel@listman.util.phx.redhat.com>;
	Fri, 21 May 2021 01:52:59 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 5438A1649D3; Fri, 21 May 2021 05:52:59 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 4CD951649D8
	for <dm-devel@redhat.com>; Fri, 21 May 2021 05:52:52 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[207.211.31.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id AF4EF800B31
	for <dm-devel@redhat.com>; Fri, 21 May 2021 05:52:52 +0000 (UTC)
Received: from bombadil.infradead.org (bombadil.infradead.org
	[198.137.202.133]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-441-lEx9mSjDM0q2AD17MyoDwA-1; Fri, 21 May 2021 01:52:49 -0400
X-MC-Unique: lEx9mSjDM0q2AD17MyoDwA-1
Received: from [2001:4bb8:180:5add:4fd7:4137:d2f2:46e6] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.94 #2 (Red Hat Linux))
	id 1ljy5K-00GqDg-T5; Fri, 21 May 2021 05:52:35 +0000
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
Date: Fri, 21 May 2021 07:51:13 +0200
Message-Id: <20210521055116.1053587-24-hch@lst.de>
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
Subject: [dm-devel] [PATCH 23/26] dcssblk: convert to
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
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Convert the dcssblk driver to use the blk_alloc_disk and blk_cleanup_disk
helpers to simplify gendisk and request_queue allocation.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/s390/block/dcssblk.c | 26 ++++++++------------------
 1 file changed, 8 insertions(+), 18 deletions(-)

diff --git a/drivers/s390/block/dcssblk.c b/drivers/s390/block/dcssblk.c
index da33cb4cba28..7faa56399999 100644
--- a/drivers/s390/block/dcssblk.c
+++ b/drivers/s390/block/dcssblk.c
@@ -90,7 +90,6 @@ struct dcssblk_dev_info {
 	int segment_type;
 	unsigned char save_pending;
 	unsigned char is_shared;
-	struct request_queue *dcssblk_queue;
 	int num_of_segments;
 	struct list_head seg_list;
 	struct dax_device *dax_dev;
@@ -429,9 +428,7 @@ dcssblk_shared_store(struct device *dev, struct device_attribute *attr, const ch
 	kill_dax(dev_info->dax_dev);
 	put_dax(dev_info->dax_dev);
 	del_gendisk(dev_info->gd);
-	blk_cleanup_queue(dev_info->dcssblk_queue);
-	dev_info->gd->queue = NULL;
-	put_disk(dev_info->gd);
+	blk_cleanup_disk(dev_info->gd);
 	up_write(&dcssblk_devices_sem);
 
 	if (device_remove_file_self(dev, attr)) {
@@ -644,18 +641,17 @@ dcssblk_add_store(struct device *dev, struct device_attribute *attr, const char
 	dev_info->dev.release = dcssblk_release_segment;
 	dev_info->dev.groups = dcssblk_dev_attr_groups;
 	INIT_LIST_HEAD(&dev_info->lh);
-	dev_info->gd = alloc_disk(DCSSBLK_MINORS_PER_DISK);
+	dev_info->gd = blk_alloc_disk(NUMA_NO_NODE);
 	if (dev_info->gd == NULL) {
 		rc = -ENOMEM;
 		goto seg_list_del;
 	}
 	dev_info->gd->major = dcssblk_major;
+	dev_info->gd->minors = DCSSBLK_MINORS_PER_DISK;
 	dev_info->gd->fops = &dcssblk_devops;
-	dev_info->dcssblk_queue = blk_alloc_queue(NUMA_NO_NODE);
-	dev_info->gd->queue = dev_info->dcssblk_queue;
 	dev_info->gd->private_data = dev_info;
-	blk_queue_logical_block_size(dev_info->dcssblk_queue, 4096);
-	blk_queue_flag_set(QUEUE_FLAG_DAX, dev_info->dcssblk_queue);
+	blk_queue_logical_block_size(dev_info->gd->queue, 4096);
+	blk_queue_flag_set(QUEUE_FLAG_DAX, dev_info->gd->queue);
 
 	seg_byte_size = (dev_info->end - dev_info->start + 1);
 	set_capacity(dev_info->gd, seg_byte_size >> 9); // size in sectors
@@ -719,9 +715,7 @@ dcssblk_add_store(struct device *dev, struct device_attribute *attr, const char
 
 put_dev:
 	list_del(&dev_info->lh);
-	blk_cleanup_queue(dev_info->dcssblk_queue);
-	dev_info->gd->queue = NULL;
-	put_disk(dev_info->gd);
+	blk_cleanup_disk(dev_info->gd);
 	list_for_each_entry(seg_info, &dev_info->seg_list, lh) {
 		segment_unload(seg_info->segment_name);
 	}
@@ -731,9 +725,7 @@ dcssblk_add_store(struct device *dev, struct device_attribute *attr, const char
 dev_list_del:
 	list_del(&dev_info->lh);
 release_gd:
-	blk_cleanup_queue(dev_info->dcssblk_queue);
-	dev_info->gd->queue = NULL;
-	put_disk(dev_info->gd);
+	blk_cleanup_disk(dev_info->gd);
 	up_write(&dcssblk_devices_sem);
 seg_list_del:
 	if (dev_info == NULL)
@@ -801,9 +793,7 @@ dcssblk_remove_store(struct device *dev, struct device_attribute *attr, const ch
 	kill_dax(dev_info->dax_dev);
 	put_dax(dev_info->dax_dev);
 	del_gendisk(dev_info->gd);
-	blk_cleanup_queue(dev_info->dcssblk_queue);
-	dev_info->gd->queue = NULL;
-	put_disk(dev_info->gd);
+	blk_cleanup_disk(dev_info->gd);
 
 	/* unload all related segments */
 	list_for_each_entry(entry, &dev_info->seg_list, lh)
-- 
2.30.2

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel


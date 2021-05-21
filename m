Return-Path: <SRS0=AQTU=KQ=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2D433C43461
	for <dm-devel@archiver.kernel.org>; Fri, 21 May 2021 05:52:49 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id B11A66128A
	for <dm-devel@archiver.kernel.org>; Fri, 21 May 2021 05:52:48 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org B11A66128A
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-312-ZHHL_yjPPGK_FoLFZPTFMQ-1; Fri, 21 May 2021 01:52:44 -0400
X-MC-Unique: ZHHL_yjPPGK_FoLFZPTFMQ-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 9B2151883521;
	Fri, 21 May 2021 05:52:40 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 6A37A10016FF;
	Fri, 21 May 2021 05:52:40 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 8B62D1800BB8;
	Fri, 21 May 2021 05:52:39 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
	[10.11.54.6])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 14L5qZFi027226 for <dm-devel@listman.util.phx.redhat.com>;
	Fri, 21 May 2021 01:52:35 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id F16A320951BB; Fri, 21 May 2021 05:52:34 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id ECC4A20951B8
	for <dm-devel@redhat.com>; Fri, 21 May 2021 05:52:31 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [205.139.110.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 4A8A0858F0D
	for <dm-devel@redhat.com>; Fri, 21 May 2021 05:52:31 +0000 (UTC)
Received: from bombadil.infradead.org (bombadil.infradead.org
	[198.137.202.133]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-592-xsB_0zyiNpGhDt9SW2r8pQ-1; Fri, 21 May 2021 01:52:28 -0400
X-MC-Unique: xsB_0zyiNpGhDt9SW2r8pQ-1
Received: from [2001:4bb8:180:5add:4fd7:4137:d2f2:46e6] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.94 #2 (Red Hat Linux))
	id 1ljy4x-00Gq6W-0f; Fri, 21 May 2021 05:52:11 +0000
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
Date: Fri, 21 May 2021 07:51:07 +0200
Message-Id: <20210521055116.1053587-18-hch@lst.de>
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
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.6
X-loop: dm-devel@redhat.com
Cc: linux-xtensa@linux-xtensa.org, linux-m68k@vger.kernel.org,
	linux-raid@vger.kernel.org, nvdimm@lists.linux.dev,
	linux-s390@vger.kernel.org, linux-mmc@vger.kernel.org,
	linux-bcache@vger.kernel.org, linux-nvme@lists.infradead.org,
	linux-block@vger.kernel.org, dm-devel@redhat.com,
	drbd-dev@tron.linbit.com, linuxppc-dev@lists.ozlabs.org
Subject: [dm-devel] [PATCH 17/26] nvdimm-pmem: convert to
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

Convert the nvdimm-pmem driver to use the blk_alloc_disk and
blk_cleanup_disk helpers to simplify gendisk and request_queue
allocation.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/nvdimm/pmem.c | 15 +++++----------
 1 file changed, 5 insertions(+), 10 deletions(-)

diff --git a/drivers/nvdimm/pmem.c b/drivers/nvdimm/pmem.c
index 968b8483c763..9fcd05084564 100644
--- a/drivers/nvdimm/pmem.c
+++ b/drivers/nvdimm/pmem.c
@@ -338,7 +338,7 @@ static void pmem_pagemap_cleanup(struct dev_pagemap *pgmap)
 	struct request_queue *q =
 		container_of(pgmap->ref, struct request_queue, q_usage_counter);
 
-	blk_cleanup_queue(q);
+	blk_cleanup_disk(queue_to_disk(q));
 }
 
 static void pmem_release_queue(void *pgmap)
@@ -361,7 +361,6 @@ static void pmem_release_disk(void *__pmem)
 	kill_dax(pmem->dax_dev);
 	put_dax(pmem->dax_dev);
 	del_gendisk(pmem->disk);
-	put_disk(pmem->disk);
 }
 
 static const struct dev_pagemap_ops fsdax_pagemap_ops = {
@@ -422,10 +421,12 @@ static int pmem_attach_disk(struct device *dev,
 		return -EBUSY;
 	}
 
-	q = blk_alloc_queue(dev_to_node(dev));
-	if (!q)
+	disk = blk_alloc_disk(nid);
+	if (!disk)
 		return -ENOMEM;
+	q = disk->queue;
 
+	pmem->disk = disk;
 	pmem->pfn_flags = PFN_DEV;
 	pmem->pgmap.ref = &q->q_usage_counter;
 	if (is_nd_pfn(dev)) {
@@ -470,11 +471,6 @@ static int pmem_attach_disk(struct device *dev,
 	if (pmem->pfn_flags & PFN_MAP)
 		blk_queue_flag_set(QUEUE_FLAG_DAX, q);
 
-	disk = alloc_disk_node(0, nid);
-	if (!disk)
-		return -ENOMEM;
-	pmem->disk = disk;
-
 	disk->fops		= &pmem_fops;
 	disk->queue		= q;
 	disk->private_data	= pmem;
@@ -490,7 +486,6 @@ static int pmem_attach_disk(struct device *dev,
 		flags = DAXDEV_F_SYNC;
 	dax_dev = alloc_dax(pmem, disk->disk_name, &pmem_dax_ops, flags);
 	if (IS_ERR(dax_dev)) {
-		put_disk(disk);
 		return PTR_ERR(dax_dev);
 	}
 	dax_write_cache(dax_dev, nvdimm_has_cache(nd_region));
-- 
2.30.2

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel


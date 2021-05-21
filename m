Return-Path: <SRS0=AQTU=KQ=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F1254C433B4
	for <dm-devel@archiver.kernel.org>; Fri, 21 May 2021 06:03:58 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 4F13260FEF
	for <dm-devel@archiver.kernel.org>; Fri, 21 May 2021 06:03:58 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 4F13260FEF
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-256-J7Nj9LG4NOCbIbSoTFiElQ-1; Fri, 21 May 2021 02:03:55 -0400
X-MC-Unique: J7Nj9LG4NOCbIbSoTFiElQ-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id ADB77501E1;
	Fri, 21 May 2021 06:03:51 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 9291060C4A;
	Fri, 21 May 2021 06:03:51 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 6CCD4180B464;
	Fri, 21 May 2021 06:03:51 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
	[10.11.54.4])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 14L63nvA028162 for <dm-devel@listman.util.phx.redhat.com>;
	Fri, 21 May 2021 02:03:49 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 0A714212AA99; Fri, 21 May 2021 06:03:49 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 04423212AA9E
	for <dm-devel@redhat.com>; Fri, 21 May 2021 06:03:49 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[207.211.31.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id E10F8100DE80
	for <dm-devel@redhat.com>; Fri, 21 May 2021 06:03:48 +0000 (UTC)
Received: from bombadil.infradead.org (bombadil.infradead.org
	[198.137.202.133]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-219-H2TQfYlbPX-7IHT7XqBRhw-1; Fri, 21 May 2021 02:03:47 -0400
X-MC-Unique: H2TQfYlbPX-7IHT7XqBRhw-1
Received: from [2001:4bb8:180:5add:4fd7:4137:d2f2:46e6] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.94 #2 (Red Hat Linux))
	id 1ljy4G-00GpxC-Qo; Fri, 21 May 2021 05:51:29 +0000
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
Date: Fri, 21 May 2021 07:50:53 +0200
Message-Id: <20210521055116.1053587-4-hch@lst.de>
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
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.4
X-loop: dm-devel@redhat.com
Cc: linux-xtensa@linux-xtensa.org, linux-m68k@vger.kernel.org,
	linux-raid@vger.kernel.org, nvdimm@lists.linux.dev,
	linux-s390@vger.kernel.org, linux-mmc@vger.kernel.org,
	linux-bcache@vger.kernel.org, linux-nvme@lists.infradead.org,
	linux-block@vger.kernel.org, dm-devel@redhat.com,
	drbd-dev@tron.linbit.com, linuxppc-dev@lists.ozlabs.org
Subject: [dm-devel] [PATCH 03/26] block: automatically enable
	GENHD_FL_EXT_DEVT
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

Automatically set the GENHD_FL_EXT_DEVT flag for all disks allocated
without an explicit number of minors.  This is what all new block
drivers should do, so make sure it is the default without boilerplate
code.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 block/genhd.c                    | 2 +-
 block/partitions/core.c          | 4 ----
 drivers/block/n64cart.c          | 2 +-
 drivers/lightnvm/core.c          | 1 -
 drivers/memstick/core/ms_block.c | 1 -
 drivers/nvdimm/blk.c             | 1 -
 drivers/nvdimm/btt.c             | 1 -
 drivers/nvdimm/pmem.c            | 1 -
 drivers/nvme/host/core.c         | 1 -
 drivers/nvme/host/multipath.c    | 1 -
 10 files changed, 2 insertions(+), 13 deletions(-)

diff --git a/block/genhd.c b/block/genhd.c
index 7f9beaeede11..eec266c9318d 100644
--- a/block/genhd.c
+++ b/block/genhd.c
@@ -499,7 +499,6 @@ static void __device_add_disk(struct device *parent, struct gendisk *disk,
 		}
 	} else {
 		WARN_ON(disk->minors);
-		WARN_ON(!(disk->flags & (GENHD_FL_EXT_DEVT | GENHD_FL_HIDDEN)));
 
 		ret = blk_alloc_ext_minor();
 		if (ret < 0) {
@@ -508,6 +507,7 @@ static void __device_add_disk(struct device *parent, struct gendisk *disk,
 		}
 		disk->major = BLOCK_EXT_MAJOR;
 		disk->first_minor = MINOR(ret);
+		disk->flags |= GENHD_FL_EXT_DEVT;
 	}
 
 	disk->flags |= GENHD_FL_UP;
diff --git a/block/partitions/core.c b/block/partitions/core.c
index 504297bdc8bf..ada3e1e66989 100644
--- a/block/partitions/core.c
+++ b/block/partitions/core.c
@@ -326,10 +326,6 @@ static struct block_device *add_partition(struct gendisk *disk, int partno,
 	const char *dname;
 	int err;
 
-	/*
-	 * disk_max_parts() won't be zero, either GENHD_FL_EXT_DEVT is set
-	 * or 'minors' is passed to alloc_disk().
-	 */
 	if (partno >= disk_max_parts(disk))
 		return ERR_PTR(-EINVAL);
 
diff --git a/drivers/block/n64cart.c b/drivers/block/n64cart.c
index 47bdf324e962..3dae4b631dea 100644
--- a/drivers/block/n64cart.c
+++ b/drivers/block/n64cart.c
@@ -141,7 +141,7 @@ static int __init n64cart_probe(struct platform_device *pdev)
 		return -ENOMEM;
 
 	disk->first_minor = 0;
-	disk->flags = GENHD_FL_NO_PART_SCAN | GENHD_FL_EXT_DEVT;
+	disk->flags = GENHD_FL_NO_PART_SCAN;
 	disk->fops = &n64cart_fops;
 	disk->private_data = &pdev->dev;
 	strcpy(disk->disk_name, "n64cart");
diff --git a/drivers/lightnvm/core.c b/drivers/lightnvm/core.c
index 40a948c08a0b..e7dc539fc0ac 100644
--- a/drivers/lightnvm/core.c
+++ b/drivers/lightnvm/core.c
@@ -383,7 +383,6 @@ static int nvm_create_tgt(struct nvm_dev *dev, struct nvm_ioctl_create *create)
 	}
 
 	strlcpy(tdisk->disk_name, create->tgtname, sizeof(tdisk->disk_name));
-	tdisk->flags = GENHD_FL_EXT_DEVT;
 	tdisk->major = 0;
 	tdisk->first_minor = 0;
 	tdisk->fops = tt->bops;
diff --git a/drivers/memstick/core/ms_block.c b/drivers/memstick/core/ms_block.c
index 8004dd64d09a..0bacf4268f83 100644
--- a/drivers/memstick/core/ms_block.c
+++ b/drivers/memstick/core/ms_block.c
@@ -2136,7 +2136,6 @@ static int msb_init_disk(struct memstick_dev *card)
 	msb->disk->fops = &msb_bdops;
 	msb->disk->private_data = msb;
 	msb->disk->queue = msb->queue;
-	msb->disk->flags |= GENHD_FL_EXT_DEVT;
 
 	capacity = msb->pages_in_block * msb->logical_block_count;
 	capacity *= (msb->page_size / 512);
diff --git a/drivers/nvdimm/blk.c b/drivers/nvdimm/blk.c
index 7b9556291eb1..7ba446d224fb 100644
--- a/drivers/nvdimm/blk.c
+++ b/drivers/nvdimm/blk.c
@@ -267,7 +267,6 @@ static int nsblk_attach_disk(struct nd_namespace_blk *nsblk)
 	disk->first_minor	= 0;
 	disk->fops		= &nd_blk_fops;
 	disk->queue		= q;
-	disk->flags		= GENHD_FL_EXT_DEVT;
 	disk->private_data	= nsblk;
 	nvdimm_namespace_disk_name(&nsblk->common, disk->disk_name);
 
diff --git a/drivers/nvdimm/btt.c b/drivers/nvdimm/btt.c
index 18a267d5073f..1741a7b0b30f 100644
--- a/drivers/nvdimm/btt.c
+++ b/drivers/nvdimm/btt.c
@@ -1537,7 +1537,6 @@ static int btt_blk_init(struct btt *btt)
 	btt->btt_disk->fops = &btt_fops;
 	btt->btt_disk->private_data = btt;
 	btt->btt_disk->queue = btt->btt_queue;
-	btt->btt_disk->flags = GENHD_FL_EXT_DEVT;
 
 	blk_queue_logical_block_size(btt->btt_queue, btt->sector_size);
 	blk_queue_max_hw_sectors(btt->btt_queue, UINT_MAX);
diff --git a/drivers/nvdimm/pmem.c b/drivers/nvdimm/pmem.c
index ed10a8b66068..968b8483c763 100644
--- a/drivers/nvdimm/pmem.c
+++ b/drivers/nvdimm/pmem.c
@@ -477,7 +477,6 @@ static int pmem_attach_disk(struct device *dev,
 
 	disk->fops		= &pmem_fops;
 	disk->queue		= q;
-	disk->flags		= GENHD_FL_EXT_DEVT;
 	disk->private_data	= pmem;
 	nvdimm_namespace_disk_name(ndns, disk->disk_name);
 	set_capacity(disk, (pmem->size - pmem->pfn_pad - pmem->data_offset)
diff --git a/drivers/nvme/host/core.c b/drivers/nvme/host/core.c
index 762125f2905f..24bcae88587a 100644
--- a/drivers/nvme/host/core.c
+++ b/drivers/nvme/host/core.c
@@ -3699,7 +3699,6 @@ static void nvme_alloc_ns(struct nvme_ctrl *ctrl, unsigned nsid,
 	disk->fops = &nvme_bdev_ops;
 	disk->private_data = ns;
 	disk->queue = ns->queue;
-	disk->flags = GENHD_FL_EXT_DEVT;
 	/*
 	 * Without the multipath code enabled, multiple controller per
 	 * subsystems are visible as devices and thus we cannot use the
diff --git a/drivers/nvme/host/multipath.c b/drivers/nvme/host/multipath.c
index f81871c7128a..a5d02f236cca 100644
--- a/drivers/nvme/host/multipath.c
+++ b/drivers/nvme/host/multipath.c
@@ -462,7 +462,6 @@ int nvme_mpath_alloc_disk(struct nvme_ctrl *ctrl, struct nvme_ns_head *head)
 	head->disk->fops = &nvme_ns_head_ops;
 	head->disk->private_data = head;
 	head->disk->queue = q;
-	head->disk->flags = GENHD_FL_EXT_DEVT;
 	sprintf(head->disk->disk_name, "nvme%dn%d",
 			ctrl->subsys->instance, head->instance);
 	return 0;
-- 
2.30.2

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel


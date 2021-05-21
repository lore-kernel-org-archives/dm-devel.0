Return-Path: <SRS0=AQTU=KQ=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 401BEC433B4
	for <dm-devel@archiver.kernel.org>; Fri, 21 May 2021 05:52:48 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id CA4E66128A
	for <dm-devel@archiver.kernel.org>; Fri, 21 May 2021 05:52:47 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org CA4E66128A
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-538-DCW1pl9gPZSrKPNl8pZUGg-1; Fri, 21 May 2021 01:52:44 -0400
X-MC-Unique: DCW1pl9gPZSrKPNl8pZUGg-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C92AC802939;
	Fri, 21 May 2021 05:52:40 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id A82E310074E0;
	Fri, 21 May 2021 05:52:40 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id F3C9A180B463;
	Fri, 21 May 2021 05:52:38 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
	[10.11.54.3])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 14L5qZUd027227 for <dm-devel@listman.util.phx.redhat.com>;
	Fri, 21 May 2021 01:52:35 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 38568107CCE4; Fri, 21 May 2021 05:52:35 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 341031084486
	for <dm-devel@redhat.com>; Fri, 21 May 2021 05:52:35 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [207.211.31.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
	bits)) (No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 1BC6380D0E2
	for <dm-devel@redhat.com>; Fri, 21 May 2021 05:52:35 +0000 (UTC)
Received: from bombadil.infradead.org (bombadil.infradead.org
	[198.137.202.133]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-105-nk58SSNhP_qBcTc2UoxGOA-1; Fri, 21 May 2021 01:52:29 -0400
X-MC-Unique: nk58SSNhP_qBcTc2UoxGOA-1
Received: from [2001:4bb8:180:5add:4fd7:4137:d2f2:46e6] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.94 #2 (Red Hat Linux))
	id 1ljy50-00Gq7o-Ng; Fri, 21 May 2021 05:52:15 +0000
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
Date: Fri, 21 May 2021 07:51:08 +0200
Message-Id: <20210521055116.1053587-19-hch@lst.de>
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
Subject: [dm-devel] [PATCH 18/26] nvme-multipath: convert to
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

Convert the nvme-multipath driver to use the blk_alloc_disk and
blk_cleanup_disk helpers to simplify gendisk and request_queue
allocation.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/nvdimm/pmem.c         |  1 -
 drivers/nvme/host/multipath.c | 45 ++++++++++-------------------------
 2 files changed, 13 insertions(+), 33 deletions(-)

diff --git a/drivers/nvdimm/pmem.c b/drivers/nvdimm/pmem.c
index 9fcd05084564..31f3c4bd6f72 100644
--- a/drivers/nvdimm/pmem.c
+++ b/drivers/nvdimm/pmem.c
@@ -472,7 +472,6 @@ static int pmem_attach_disk(struct device *dev,
 		blk_queue_flag_set(QUEUE_FLAG_DAX, q);
 
 	disk->fops		= &pmem_fops;
-	disk->queue		= q;
 	disk->private_data	= pmem;
 	nvdimm_namespace_disk_name(ndns, disk->disk_name);
 	set_capacity(disk, (pmem->size - pmem->pfn_pad - pmem->data_offset)
diff --git a/drivers/nvme/host/multipath.c b/drivers/nvme/host/multipath.c
index a5d02f236cca..b5fbdb416022 100644
--- a/drivers/nvme/host/multipath.c
+++ b/drivers/nvme/host/multipath.c
@@ -427,7 +427,6 @@ static void nvme_requeue_work(struct work_struct *work)
 
 int nvme_mpath_alloc_disk(struct nvme_ctrl *ctrl, struct nvme_ns_head *head)
 {
-	struct request_queue *q;
 	bool vwc = false;
 
 	mutex_init(&head->lock);
@@ -443,33 +442,24 @@ int nvme_mpath_alloc_disk(struct nvme_ctrl *ctrl, struct nvme_ns_head *head)
 	if (!(ctrl->subsys->cmic & NVME_CTRL_CMIC_MULTI_CTRL) || !multipath)
 		return 0;
 
-	q = blk_alloc_queue(ctrl->numa_node);
-	if (!q)
-		goto out;
-	blk_queue_flag_set(QUEUE_FLAG_NONROT, q);
-	/* set to a default value for 512 until disk is validated */
-	blk_queue_logical_block_size(q, 512);
-	blk_set_stacking_limits(&q->limits);
-
-	/* we need to propagate up the VMC settings */
-	if (ctrl->vwc & NVME_CTRL_VWC_PRESENT)
-		vwc = true;
-	blk_queue_write_cache(q, vwc, vwc);
-
-	head->disk = alloc_disk(0);
+	head->disk = blk_alloc_disk(ctrl->numa_node);
 	if (!head->disk)
-		goto out_cleanup_queue;
+		return -ENOMEM;
 	head->disk->fops = &nvme_ns_head_ops;
 	head->disk->private_data = head;
-	head->disk->queue = q;
 	sprintf(head->disk->disk_name, "nvme%dn%d",
 			ctrl->subsys->instance, head->instance);
-	return 0;
 
-out_cleanup_queue:
-	blk_cleanup_queue(q);
-out:
-	return -ENOMEM;
+	blk_queue_flag_set(QUEUE_FLAG_NONROT, head->disk->queue);
+	/* set to a default value of 512 until the disk is validated */
+	blk_queue_logical_block_size(head->disk->queue, 512);
+	blk_set_stacking_limits(&head->disk->queue->limits);
+
+	/* we need to propagate up the VMC settings */
+	if (ctrl->vwc & NVME_CTRL_VWC_PRESENT)
+		vwc = true;
+	blk_queue_write_cache(head->disk->queue, vwc, vwc);
+	return 0;
 }
 
 static void nvme_mpath_set_live(struct nvme_ns *ns)
@@ -768,16 +758,7 @@ void nvme_mpath_remove_disk(struct nvme_ns_head *head)
 	/* make sure all pending bios are cleaned up */
 	kblockd_schedule_work(&head->requeue_work);
 	flush_work(&head->requeue_work);
-	blk_cleanup_queue(head->disk->queue);
-	if (!test_bit(NVME_NSHEAD_DISK_LIVE, &head->flags)) {
-		/*
-		 * if device_add_disk wasn't called, prevent
-		 * disk release to put a bogus reference on the
-		 * request queue
-		 */
-		head->disk->queue = NULL;
-	}
-	put_disk(head->disk);
+	blk_cleanup_disk(head->disk);
 }
 
 void nvme_mpath_init_ctrl(struct nvme_ctrl *ctrl)
-- 
2.30.2

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel


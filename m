Return-Path: <SRS0=AQTU=KQ=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 51BF2C433ED
	for <dm-devel@archiver.kernel.org>; Fri, 21 May 2021 06:04:47 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id CAD5D613B4
	for <dm-devel@archiver.kernel.org>; Fri, 21 May 2021 06:04:46 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org CAD5D613B4
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-339-sCDjxB80M-ahbYIwv2zJPg-1; Fri, 21 May 2021 02:04:43 -0400
X-MC-Unique: sCDjxB80M-ahbYIwv2zJPg-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 194088049D6;
	Fri, 21 May 2021 06:04:39 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id DD6F35D764;
	Fri, 21 May 2021 06:04:38 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id B7BFF1801263;
	Fri, 21 May 2021 06:04:38 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
	[10.11.54.5])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 14L64bWQ028395 for <dm-devel@listman.util.phx.redhat.com>;
	Fri, 21 May 2021 02:04:38 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id CAE021649D8; Fri, 21 May 2021 06:04:37 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id C57EF30BA4
	for <dm-devel@redhat.com>; Fri, 21 May 2021 06:04:34 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[207.211.31.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id B2B6895F343
	for <dm-devel@redhat.com>; Fri, 21 May 2021 06:04:34 +0000 (UTC)
Received: from bombadil.infradead.org (bombadil.infradead.org
	[198.137.202.133]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-369-y9q4mmWcNb2FGNryRMb3Dg-1; Fri, 21 May 2021 02:04:32 -0400
X-MC-Unique: y9q4mmWcNb2FGNryRMb3Dg-1
Received: from [2001:4bb8:180:5add:4fd7:4137:d2f2:46e6] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.94 #2 (Red Hat Linux))
	id 1ljy4u-00Gq5s-1t; Fri, 21 May 2021 05:52:08 +0000
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
Date: Fri, 21 May 2021 07:51:06 +0200
Message-Id: <20210521055116.1053587-17-hch@lst.de>
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
Subject: [dm-devel] [PATCH 16/26] nvdimm-btt: convert to
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Convert the nvdimm-btt driver to use the blk_alloc_disk and
blk_cleanup_disk helpers to simplify gendisk and request_queue
allocation.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/nvdimm/btt.c | 24 +++++++-----------------
 drivers/nvdimm/btt.h |  2 --
 2 files changed, 7 insertions(+), 19 deletions(-)

diff --git a/drivers/nvdimm/btt.c b/drivers/nvdimm/btt.c
index 1741a7b0b30f..92dec4952297 100644
--- a/drivers/nvdimm/btt.c
+++ b/drivers/nvdimm/btt.c
@@ -1521,34 +1521,25 @@ static int btt_blk_init(struct btt *btt)
 	struct nd_btt *nd_btt = btt->nd_btt;
 	struct nd_namespace_common *ndns = nd_btt->ndns;
 
-	/* create a new disk and request queue for btt */
-	btt->btt_queue = blk_alloc_queue(NUMA_NO_NODE);
-	if (!btt->btt_queue)
+	btt->btt_disk = blk_alloc_disk(NUMA_NO_NODE);
+	if (!btt->btt_disk)
 		return -ENOMEM;
 
-	btt->btt_disk = alloc_disk(0);
-	if (!btt->btt_disk) {
-		blk_cleanup_queue(btt->btt_queue);
-		return -ENOMEM;
-	}
-
 	nvdimm_namespace_disk_name(ndns, btt->btt_disk->disk_name);
 	btt->btt_disk->first_minor = 0;
 	btt->btt_disk->fops = &btt_fops;
 	btt->btt_disk->private_data = btt;
-	btt->btt_disk->queue = btt->btt_queue;
 
-	blk_queue_logical_block_size(btt->btt_queue, btt->sector_size);
-	blk_queue_max_hw_sectors(btt->btt_queue, UINT_MAX);
-	blk_queue_flag_set(QUEUE_FLAG_NONROT, btt->btt_queue);
+	blk_queue_logical_block_size(btt->btt_disk->queue, btt->sector_size);
+	blk_queue_max_hw_sectors(btt->btt_disk->queue, UINT_MAX);
+	blk_queue_flag_set(QUEUE_FLAG_NONROT, btt->btt_disk->queue);
 
 	if (btt_meta_size(btt)) {
 		int rc = nd_integrity_init(btt->btt_disk, btt_meta_size(btt));
 
 		if (rc) {
 			del_gendisk(btt->btt_disk);
-			put_disk(btt->btt_disk);
-			blk_cleanup_queue(btt->btt_queue);
+			blk_cleanup_disk(btt->btt_disk);
 			return rc;
 		}
 	}
@@ -1563,8 +1554,7 @@ static int btt_blk_init(struct btt *btt)
 static void btt_blk_cleanup(struct btt *btt)
 {
 	del_gendisk(btt->btt_disk);
-	put_disk(btt->btt_disk);
-	blk_cleanup_queue(btt->btt_queue);
+	blk_cleanup_disk(btt->btt_disk);
 }
 
 /**
diff --git a/drivers/nvdimm/btt.h b/drivers/nvdimm/btt.h
index aa53e0b769bd..0c76c0333f6e 100644
--- a/drivers/nvdimm/btt.h
+++ b/drivers/nvdimm/btt.h
@@ -201,7 +201,6 @@ struct badblocks;
 /**
  * struct btt - handle for a BTT instance
  * @btt_disk:		Pointer to the gendisk for BTT device
- * @btt_queue:		Pointer to the request queue for the BTT device
  * @arena_list:		Head of the list of arenas
  * @debugfs_dir:	Debugfs dentry
  * @nd_btt:		Parent nd_btt struct
@@ -219,7 +218,6 @@ struct badblocks;
  */
 struct btt {
 	struct gendisk *btt_disk;
-	struct request_queue *btt_queue;
 	struct list_head arena_list;
 	struct dentry *debugfs_dir;
 	struct nd_btt *nd_btt;
-- 
2.30.2

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel


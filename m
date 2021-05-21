Return-Path: <SRS0=AQTU=KQ=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9B214C4363F
	for <dm-devel@archiver.kernel.org>; Fri, 21 May 2021 05:52:58 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 176686128A
	for <dm-devel@archiver.kernel.org>; Fri, 21 May 2021 05:52:57 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 176686128A
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-309-O4gk55g1PxePypO1CMDw-g-1; Fri, 21 May 2021 01:52:55 -0400
X-MC-Unique: O4gk55g1PxePypO1CMDw-g-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 05E29102CB6B;
	Fri, 21 May 2021 05:52:50 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id DDE8160C4A;
	Fri, 21 May 2021 05:52:49 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id B7050180B464;
	Fri, 21 May 2021 05:52:49 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
	[10.11.54.3])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 14L5qkEY027265 for <dm-devel@listman.util.phx.redhat.com>;
	Fri, 21 May 2021 01:52:47 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 2AA94107CCE4; Fri, 21 May 2021 05:52:46 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 26AD810031EF
	for <dm-devel@redhat.com>; Fri, 21 May 2021 05:52:46 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[207.211.31.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 0F73180D0E2
	for <dm-devel@redhat.com>; Fri, 21 May 2021 05:52:46 +0000 (UTC)
Received: from bombadil.infradead.org (bombadil.infradead.org
	[198.137.202.133]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-467-IPyY5gJDOKy-ZbSuDD1pNw-1; Fri, 21 May 2021 01:52:43 -0400
X-MC-Unique: IPyY5gJDOKy-ZbSuDD1pNw-1
Received: from [2001:4bb8:180:5add:4fd7:4137:d2f2:46e6] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.94 #2 (Red Hat Linux))
	id 1ljy58-00GqAV-Tf; Fri, 21 May 2021 05:52:23 +0000
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
Date: Fri, 21 May 2021 07:51:10 +0200
Message-Id: <20210521055116.1053587-21-hch@lst.de>
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
Subject: [dm-devel] [PATCH 20/26] simdisk: convert to
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

Convert the simdisk driver to use the blk_alloc_disk and blk_cleanup_disk
helpers to simplify gendisk and request_queue allocation.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 arch/xtensa/platforms/iss/simdisk.c | 29 +++++++----------------------
 1 file changed, 7 insertions(+), 22 deletions(-)

diff --git a/arch/xtensa/platforms/iss/simdisk.c b/arch/xtensa/platforms/iss/simdisk.c
index fc09be7b1347..3cdfa00738e0 100644
--- a/arch/xtensa/platforms/iss/simdisk.c
+++ b/arch/xtensa/platforms/iss/simdisk.c
@@ -27,7 +27,6 @@
 struct simdisk {
 	const char *filename;
 	spinlock_t lock;
-	struct request_queue *queue;
 	struct gendisk *gd;
 	struct proc_dir_entry *procfile;
 	int users;
@@ -266,21 +265,13 @@ static int __init simdisk_setup(struct simdisk *dev, int which,
 	spin_lock_init(&dev->lock);
 	dev->users = 0;
 
-	dev->queue = blk_alloc_queue(NUMA_NO_NODE);
-	if (dev->queue == NULL) {
-		pr_err("blk_alloc_queue failed\n");
-		goto out_alloc_queue;
-	}
-
-	dev->gd = alloc_disk(SIMDISK_MINORS);
-	if (dev->gd == NULL) {
-		pr_err("alloc_disk failed\n");
-		goto out_alloc_disk;
-	}
+	dev->gd = blk_alloc_disk(NUMA_NO_NODE);
+	if (!dev->gd)
+		return -ENOMEM;
 	dev->gd->major = simdisk_major;
 	dev->gd->first_minor = which;
+	dev->gd->minors = SIMDISK_MINORS;
 	dev->gd->fops = &simdisk_ops;
-	dev->gd->queue = dev->queue;
 	dev->gd->private_data = dev;
 	snprintf(dev->gd->disk_name, 32, "simdisk%d", which);
 	set_capacity(dev->gd, 0);
@@ -288,12 +279,6 @@ static int __init simdisk_setup(struct simdisk *dev, int which,
 
 	dev->procfile = proc_create_data(tmp, 0644, procdir, &simdisk_proc_ops, dev);
 	return 0;
-
-out_alloc_disk:
-	blk_cleanup_queue(dev->queue);
-	dev->queue = NULL;
-out_alloc_queue:
-	return -ENOMEM;
 }
 
 static int __init simdisk_init(void)
@@ -343,10 +328,10 @@ static void simdisk_teardown(struct simdisk *dev, int which,
 	char tmp[2] = { '0' + which, 0 };
 
 	simdisk_detach(dev);
-	if (dev->gd)
+	if (dev->gd) {
 		del_gendisk(dev->gd);
-	if (dev->queue)
-		blk_cleanup_queue(dev->queue);
+		blk_cleanup_disk(dev->gd);
+	}
 	remove_proc_entry(tmp, procdir);
 }
 
-- 
2.30.2

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel


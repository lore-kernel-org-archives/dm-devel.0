Return-Path: <SRS0=dJ+f=FC=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 73A52C64E7A
	for <dm-devel@archiver.kernel.org>; Sat, 28 Nov 2020 16:22:50 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [63.128.21.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id F2E60246C3
	for <dm-devel@archiver.kernel.org>; Sat, 28 Nov 2020 16:22:49 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org F2E60246C3
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-528-cCnpjxmgMHmgOSAduf3tfw-1; Sat, 28 Nov 2020 11:22:47 -0500
X-MC-Unique: cCnpjxmgMHmgOSAduf3tfw-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D0C3B80EF9E;
	Sat, 28 Nov 2020 16:22:42 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id B414560862;
	Sat, 28 Nov 2020 16:22:42 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 88B575002F;
	Sat, 28 Nov 2020 16:22:42 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
	[10.11.54.5])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 0ASGMfAA023481 for <dm-devel@listman.util.phx.redhat.com>;
	Sat, 28 Nov 2020 11:22:41 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 788C147CE1; Sat, 28 Nov 2020 16:22:41 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 7367447CDC
	for <dm-devel@redhat.com>; Sat, 28 Nov 2020 16:22:39 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [207.211.31.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 24840185A794
	for <dm-devel@redhat.com>; Sat, 28 Nov 2020 16:22:39 +0000 (UTC)
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-235-0NEP6rX0PGeC1-XCnbFGuQ-1; Sat, 28 Nov 2020 11:22:36 -0500
X-MC-Unique: 0NEP6rX0PGeC1-XCnbFGuQ-1
Received: from [2001:4bb8:18c:1dd6:48f3:741a:602e:7fdd] (helo=localhost)
	by casper.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
	id 1kj2sY-0000D0-Px; Sat, 28 Nov 2020 16:15:19 +0000
From: Christoph Hellwig <hch@lst.de>
To: Jens Axboe <axboe@kernel.dk>
Date: Sat, 28 Nov 2020 17:14:30 +0100
Message-Id: <20201128161510.347752-6-hch@lst.de>
In-Reply-To: <20201128161510.347752-1-hch@lst.de>
References: <20201128161510.347752-1-hch@lst.de>
MIME-Version: 1.0
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by
	casper.infradead.org. See http://www.infradead.org/rpr.html
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
Cc: linux-bcache@vger.kernel.org, Jan Kara <jack@suse.cz>,
	Mike Snitzer <snitzer@redhat.com>, linux-mm@kvack.org,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Jan Kara <jack@suse.com>, Josef Bacik <josef@toxicpanda.com>,
	Coly Li <colyli@suse.de>, linux-block@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, dm-devel@redhat.com,
	linux-mtd@lists.infradead.org,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>, Tejun Heo <tj@kernel.org>
Subject: [dm-devel] [PATCH 05/45] mtip32xx: remove the call to fsync_bdev on
	removal
X-BeenThere: dm-devel@redhat.com
X-Mailman-Version: 2.1.12
Precedence: junk
List-Id: device-mapper development <dm-devel.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

del_gendisk already calls fsync_bdev for every partition, no need
to do this twice.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Jan Kara <jack@suse.cz>
---
 drivers/block/mtip32xx/mtip32xx.c | 15 ---------------
 drivers/block/mtip32xx/mtip32xx.h |  2 --
 2 files changed, 17 deletions(-)

diff --git a/drivers/block/mtip32xx/mtip32xx.c b/drivers/block/mtip32xx/mtip32xx.c
index 153e2cdecb4d40..53ac59d19ae530 100644
--- a/drivers/block/mtip32xx/mtip32xx.c
+++ b/drivers/block/mtip32xx/mtip32xx.c
@@ -3687,7 +3687,6 @@ static int mtip_block_initialize(struct driver_data *dd)
 	/* Enable the block device and add it to /dev */
 	device_add_disk(&dd->pdev->dev, dd->disk, NULL);
 
-	dd->bdev = bdget_disk(dd->disk, 0);
 	/*
 	 * Now that the disk is active, initialize any sysfs attributes
 	 * managed by the protocol layer.
@@ -3721,9 +3720,6 @@ static int mtip_block_initialize(struct driver_data *dd)
 	return rv;
 
 kthread_run_error:
-	bdput(dd->bdev);
-	dd->bdev = NULL;
-
 	/* Delete our gendisk. This also removes the device from /dev */
 	del_gendisk(dd->disk);
 
@@ -3804,14 +3800,6 @@ static int mtip_block_remove(struct driver_data *dd)
 	blk_mq_tagset_busy_iter(&dd->tags, mtip_no_dev_cleanup, dd);
 	blk_mq_unquiesce_queue(dd->queue);
 
-	/*
-	 * Delete our gendisk structure. This also removes the device
-	 * from /dev
-	 */
-	if (dd->bdev) {
-		bdput(dd->bdev);
-		dd->bdev = NULL;
-	}
 	if (dd->disk) {
 		if (test_bit(MTIP_DDF_INIT_DONE_BIT, &dd->dd_flag))
 			del_gendisk(dd->disk);
@@ -4206,9 +4194,6 @@ static void mtip_pci_remove(struct pci_dev *pdev)
 	} while (atomic_read(&dd->irq_workers_active) != 0 &&
 		time_before(jiffies, to));
 
-	if (!dd->sr)
-		fsync_bdev(dd->bdev);
-
 	if (atomic_read(&dd->irq_workers_active) != 0) {
 		dev_warn(&dd->pdev->dev,
 			"Completion workers still active!\n");
diff --git a/drivers/block/mtip32xx/mtip32xx.h b/drivers/block/mtip32xx/mtip32xx.h
index e22a7f0523bf30..88f4206310e4c8 100644
--- a/drivers/block/mtip32xx/mtip32xx.h
+++ b/drivers/block/mtip32xx/mtip32xx.h
@@ -463,8 +463,6 @@ struct driver_data {
 
 	int isr_binding;
 
-	struct block_device *bdev;
-
 	struct list_head online_list; /* linkage for online list */
 
 	struct list_head remove_list; /* linkage for removing list */
-- 
2.29.2

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel


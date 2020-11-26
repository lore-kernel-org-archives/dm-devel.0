Return-Path: <SRS0=cgFg=FA=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E9AF8C63777
	for <dm-devel@archiver.kernel.org>; Thu, 26 Nov 2020 13:32:45 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [63.128.21.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 4D52C206F7
	for <dm-devel@archiver.kernel.org>; Thu, 26 Nov 2020 13:32:45 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 4D52C206F7
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-422-17upseX0N62WF1aLnYkcsw-1; Thu, 26 Nov 2020 08:32:42 -0500
X-MC-Unique: 17upseX0N62WF1aLnYkcsw-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 0F3D61006C9A;
	Thu, 26 Nov 2020 13:32:38 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id E322863BA7;
	Thu, 26 Nov 2020 13:32:37 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id B3A951809CA2;
	Thu, 26 Nov 2020 13:32:37 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
	[10.11.54.4])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 0AQDWaoW005796 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 26 Nov 2020 08:32:36 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 1CFE12026D38; Thu, 26 Nov 2020 13:32:36 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 188A42026D47
	for <dm-devel@redhat.com>; Thu, 26 Nov 2020 13:32:36 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [207.211.31.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 04E8C800889
	for <dm-devel@redhat.com>; Thu, 26 Nov 2020 13:32:36 +0000 (UTC)
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-483-WEpNxXsrMkKKZuA3R3V57Q-1; Thu, 26 Nov 2020 08:32:34 -0500
X-MC-Unique: WEpNxXsrMkKKZuA3R3V57Q-1
Received: from [2001:4bb8:18c:1dd6:27b8:b8a1:c13e:ceb1] (helo=localhost)
	by casper.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
	id 1kiGyv-0003wd-3V; Thu, 26 Nov 2020 13:06:41 +0000
From: Christoph Hellwig <hch@lst.de>
To: Jens Axboe <axboe@kernel.dk>
Date: Thu, 26 Nov 2020 14:03:43 +0100
Message-Id: <20201126130422.92945-6-hch@lst.de>
In-Reply-To: <20201126130422.92945-1-hch@lst.de>
References: <20201126130422.92945-1-hch@lst.de>
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
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.4
X-loop: dm-devel@redhat.com
Cc: linux-bcache@vger.kernel.org, Jan Kara <jack@suse.cz>,
	Mike Snitzer <snitzer@redhat.com>, linux-mm@kvack.org,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Jan Kara <jack@suse.com>, Josef Bacik <josef@toxicpanda.com>,
	Coly Li <colyli@suse.de>, linux-block@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, dm-devel@redhat.com,
	linux-mtd@lists.infradead.org,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>, Tejun Heo <tj@kernel.org>
Subject: [dm-devel] [PATCH 05/44] mtip32xx: remove the call to fsync_bdev on
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
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


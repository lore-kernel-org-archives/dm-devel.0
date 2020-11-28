Return-Path: <SRS0=dJ+f=FC=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 37578C63777
	for <dm-devel@archiver.kernel.org>; Sat, 28 Nov 2020 16:24:06 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [63.128.21.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id BA445246C3
	for <dm-devel@archiver.kernel.org>; Sat, 28 Nov 2020 16:24:05 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org BA445246C3
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-190-8cJZkjzMMHKlC-oLns0I7A-1; Sat, 28 Nov 2020 11:24:02 -0500
X-MC-Unique: 8cJZkjzMMHKlC-oLns0I7A-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id AB0CF2FD14;
	Sat, 28 Nov 2020 16:23:57 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 8BC515D71D;
	Sat, 28 Nov 2020 16:23:57 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 6789B1809CA1;
	Sat, 28 Nov 2020 16:23:57 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
	[10.11.54.4])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 0ASGMAgY023293 for <dm-devel@listman.util.phx.redhat.com>;
	Sat, 28 Nov 2020 11:22:10 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 399D5202717D; Sat, 28 Nov 2020 16:22:10 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 348CF2027EAD
	for <dm-devel@redhat.com>; Sat, 28 Nov 2020 16:22:10 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[205.139.110.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 1EE5F858EEC
	for <dm-devel@redhat.com>; Sat, 28 Nov 2020 16:22:10 +0000 (UTC)
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-350-GdrJXEspNF2HrE1xYge8uw-1; Sat, 28 Nov 2020 11:22:07 -0500
X-MC-Unique: GdrJXEspNF2HrE1xYge8uw-1
Received: from [2001:4bb8:18c:1dd6:48f3:741a:602e:7fdd] (helo=localhost)
	by casper.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
	id 1kj2sa-0000D7-4t; Sat, 28 Nov 2020 16:15:22 +0000
From: Christoph Hellwig <hch@lst.de>
To: Jens Axboe <axboe@kernel.dk>
Date: Sat, 28 Nov 2020 17:14:31 +0100
Message-Id: <20201128161510.347752-7-hch@lst.de>
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
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.4
X-loop: dm-devel@redhat.com
Cc: linux-bcache@vger.kernel.org, Jan Kara <jack@suse.cz>,
	Mike Snitzer <snitzer@redhat.com>, linux-mm@kvack.org,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Jan Kara <jack@suse.com>, Josef Bacik <josef@toxicpanda.com>,
	Coly Li <colyli@suse.de>, linux-block@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, dm-devel@redhat.com,
	linux-mtd@lists.infradead.org,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>,
	Tejun Heo <tj@kernel.org>, Minchan Kim <minchan@kernel.org>
Subject: [dm-devel] [PATCH 06/45] zram: do not call set_blocksize
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

set_blocksize is used by file systems to use their preferred buffer cache
block size.  Block drivers should not set it.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Acked-by: Minchan Kim <minchan@kernel.org>
---
 drivers/block/zram/zram_drv.c | 11 +----------
 drivers/block/zram/zram_drv.h |  1 -
 2 files changed, 1 insertion(+), 11 deletions(-)

diff --git a/drivers/block/zram/zram_drv.c b/drivers/block/zram/zram_drv.c
index 6d15d51cee2b7e..b5f68951c9d280 100644
--- a/drivers/block/zram/zram_drv.c
+++ b/drivers/block/zram/zram_drv.c
@@ -403,13 +403,10 @@ static void reset_bdev(struct zram *zram)
 		return;
 
 	bdev = zram->bdev;
-	if (zram->old_block_size)
-		set_blocksize(bdev, zram->old_block_size);
 	blkdev_put(bdev, FMODE_READ|FMODE_WRITE|FMODE_EXCL);
 	/* hope filp_close flush all of IO */
 	filp_close(zram->backing_dev, NULL);
 	zram->backing_dev = NULL;
-	zram->old_block_size = 0;
 	zram->bdev = NULL;
 	zram->disk->fops = &zram_devops;
 	kvfree(zram->bitmap);
@@ -454,7 +451,7 @@ static ssize_t backing_dev_store(struct device *dev,
 	struct file *backing_dev = NULL;
 	struct inode *inode;
 	struct address_space *mapping;
-	unsigned int bitmap_sz, old_block_size = 0;
+	unsigned int bitmap_sz;
 	unsigned long nr_pages, *bitmap = NULL;
 	struct block_device *bdev = NULL;
 	int err;
@@ -509,14 +506,8 @@ static ssize_t backing_dev_store(struct device *dev,
 		goto out;
 	}
 
-	old_block_size = block_size(bdev);
-	err = set_blocksize(bdev, PAGE_SIZE);
-	if (err)
-		goto out;
-
 	reset_bdev(zram);
 
-	zram->old_block_size = old_block_size;
 	zram->bdev = bdev;
 	zram->backing_dev = backing_dev;
 	zram->bitmap = bitmap;
diff --git a/drivers/block/zram/zram_drv.h b/drivers/block/zram/zram_drv.h
index f2fd46daa76045..712354a4207c77 100644
--- a/drivers/block/zram/zram_drv.h
+++ b/drivers/block/zram/zram_drv.h
@@ -118,7 +118,6 @@ struct zram {
 	bool wb_limit_enable;
 	u64 bd_wb_limit;
 	struct block_device *bdev;
-	unsigned int old_block_size;
 	unsigned long *bitmap;
 	unsigned long nr_pages;
 #endif
-- 
2.29.2

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel


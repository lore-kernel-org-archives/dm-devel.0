Return-Path: <SRS0=MhoS=E6=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D2658C825AC
	for <dm-devel@archiver.kernel.org>; Tue, 24 Nov 2020 13:29:52 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 3CE85206F9
	for <dm-devel@archiver.kernel.org>; Tue, 24 Nov 2020 13:29:51 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 3CE85206F9
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-297-1fqmymL9MC2DnhpCX4MIkg-1; Tue, 24 Nov 2020 08:29:47 -0500
X-MC-Unique: 1fqmymL9MC2DnhpCX4MIkg-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id F0334835DE6;
	Tue, 24 Nov 2020 13:29:41 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id CAD9B19C46;
	Tue, 24 Nov 2020 13:29:41 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 961A81809CA5;
	Tue, 24 Nov 2020 13:29:41 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
	[10.11.54.6])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 0AODTL4v018243 for <dm-devel@listman.util.phx.redhat.com>;
	Tue, 24 Nov 2020 08:29:21 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 7B3952166B2B; Tue, 24 Nov 2020 13:29:21 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 768682166B27
	for <dm-devel@redhat.com>; Tue, 24 Nov 2020 13:29:21 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[205.139.110.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 5DBAB800296
	for <dm-devel@redhat.com>; Tue, 24 Nov 2020 13:29:21 +0000 (UTC)
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-566-Y_P4Ul6wNNCrBlN08pv7ZA-1; Tue, 24 Nov 2020 08:29:18 -0500
X-MC-Unique: Y_P4Ul6wNNCrBlN08pv7ZA-1
Received: from [2001:4bb8:180:5443:c70:4a89:bc61:3] (helo=localhost)
	by casper.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
	id 1khYNb-0006jz-99; Tue, 24 Nov 2020 13:29:11 +0000
From: Christoph Hellwig <hch@lst.de>
To: Jens Axboe <axboe@kernel.dk>
Date: Tue, 24 Nov 2020 14:27:51 +0100
Message-Id: <20201124132751.3747337-46-hch@lst.de>
In-Reply-To: <20201124132751.3747337-1-hch@lst.de>
References: <20201124132751.3747337-1-hch@lst.de>
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
X-Mimecast-Bulk-Signature: yes
X-Mimecast-Spam-Signature: bulk
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.6
X-loop: dm-devel@redhat.com
Cc: linux-bcache@vger.kernel.org, Jan Kara <jack@suse.cz>,
	linux-fsdevel@vger.kernel.org, Mike Snitzer <snitzer@redhat.com>,
	Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Jan Kara <jack@suse.com>, Josef Bacik <josef@toxicpanda.com>,
	Coly Li <colyli@suse.de>, linux-block@vger.kernel.org,
	Richard Weinberger <richard@nod.at>, dm-devel@redhat.com,
	linux-mtd@lists.infradead.org,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>,
	Tejun Heo <tj@kernel.org>, xen-devel@lists.xenproject.org,
	linux-mm@kvack.org
Subject: [dm-devel] [PATCH 45/45] block: stop using bdget_disk for partition
	0
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
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

We can just dereference the point in struct gendisk instead.  Also
remove the now unused export.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Reviewed-by: Jan Kara <jack@suse.cz>
---
 block/genhd.c                   |  1 -
 drivers/block/nbd.c             |  4 +---
 drivers/block/xen-blkfront.c    | 20 +++++---------------
 drivers/block/zram/zram_drv.c   | 18 +++---------------
 drivers/md/dm.c                 | 16 ++--------------
 drivers/s390/block/dasd_ioctl.c |  5 ++---
 6 files changed, 13 insertions(+), 51 deletions(-)

diff --git a/block/genhd.c b/block/genhd.c
index e1f67b9951f0ec..9a3ad1895888c6 100644
--- a/block/genhd.c
+++ b/block/genhd.c
@@ -912,7 +912,6 @@ struct block_device *bdget_disk(struct gendisk *disk, int partno)
 
 	return bdev;
 }
-EXPORT_SYMBOL(bdget_disk);
 
 /*
  * print a full list of all partitions - intended for places where the root
diff --git a/drivers/block/nbd.c b/drivers/block/nbd.c
index 014683968ce174..92f84ed0ba9eb6 100644
--- a/drivers/block/nbd.c
+++ b/drivers/block/nbd.c
@@ -1488,12 +1488,10 @@ static int nbd_open(struct block_device *bdev, fmode_t mode)
 static void nbd_release(struct gendisk *disk, fmode_t mode)
 {
 	struct nbd_device *nbd = disk->private_data;
-	struct block_device *bdev = bdget_disk(disk, 0);
 
 	if (test_bit(NBD_RT_DISCONNECT_ON_CLOSE, &nbd->config->runtime_flags) &&
-			bdev->bd_openers == 0)
+			disk->part0->bd_openers == 0)
 		nbd_disconnect_and_put(nbd);
-	bdput(bdev);
 
 	nbd_config_put(nbd);
 	nbd_put(nbd);
diff --git a/drivers/block/xen-blkfront.c b/drivers/block/xen-blkfront.c
index 79521e33d30ed5..188e0b47534bcf 100644
--- a/drivers/block/xen-blkfront.c
+++ b/drivers/block/xen-blkfront.c
@@ -2153,7 +2153,7 @@ static void blkfront_closing(struct blkfront_info *info)
 	}
 
 	if (info->gd)
-		bdev = bdget_disk(info->gd, 0);
+		bdev = bdgrab(info->gd->part0);
 
 	mutex_unlock(&info->mutex);
 
@@ -2518,7 +2518,7 @@ static int blkfront_remove(struct xenbus_device *xbdev)
 
 	disk = info->gd;
 	if (disk)
-		bdev = bdget_disk(disk, 0);
+		bdev = bdgrab(disk->part0);
 
 	info->xbdev = NULL;
 	mutex_unlock(&info->mutex);
@@ -2595,19 +2595,11 @@ static int blkif_open(struct block_device *bdev, fmode_t mode)
 static void blkif_release(struct gendisk *disk, fmode_t mode)
 {
 	struct blkfront_info *info = disk->private_data;
-	struct block_device *bdev;
 	struct xenbus_device *xbdev;
 
 	mutex_lock(&blkfront_mutex);
-
-	bdev = bdget_disk(disk, 0);
-
-	if (!bdev) {
-		WARN(1, "Block device %s yanked out from us!\n", disk->disk_name);
+	if (disk->part0->bd_openers)
 		goto out_mutex;
-	}
-	if (bdev->bd_openers)
-		goto out;
 
 	/*
 	 * Check if we have been instructed to close. We will have
@@ -2619,7 +2611,7 @@ static void blkif_release(struct gendisk *disk, fmode_t mode)
 
 	if (xbdev && xbdev->state == XenbusStateClosing) {
 		/* pending switch to state closed */
-		dev_info(disk_to_dev(bdev->bd_disk), "releasing disk\n");
+		dev_info(disk_to_dev(disk), "releasing disk\n");
 		xlvbd_release_gendisk(info);
 		xenbus_frontend_closed(info->xbdev);
  	}
@@ -2628,14 +2620,12 @@ static void blkif_release(struct gendisk *disk, fmode_t mode)
 
 	if (!xbdev) {
 		/* sudden device removal */
-		dev_info(disk_to_dev(bdev->bd_disk), "releasing disk\n");
+		dev_info(disk_to_dev(disk), "releasing disk\n");
 		xlvbd_release_gendisk(info);
 		disk->private_data = NULL;
 		free_info(info);
 	}
 
-out:
-	bdput(bdev);
 out_mutex:
 	mutex_unlock(&blkfront_mutex);
 }
diff --git a/drivers/block/zram/zram_drv.c b/drivers/block/zram/zram_drv.c
index 01757f9578dcb8..56024905bd242c 100644
--- a/drivers/block/zram/zram_drv.c
+++ b/drivers/block/zram/zram_drv.c
@@ -1748,7 +1748,7 @@ static ssize_t reset_store(struct device *dev,
 		struct device_attribute *attr, const char *buf, size_t len)
 {
 	struct zram *zram = dev_to_zram(dev);
-	struct block_device *bdev;
+	struct block_device *bdev = zram->disk->part0;
 	unsigned short do_reset;
 	int ret = 0;
 
@@ -1758,17 +1758,12 @@ static ssize_t reset_store(struct device *dev,
 	if (!do_reset)
 		return -EINVAL;
 
-	bdev = bdget_disk(zram->disk, 0);
-	if (!bdev)
-		return -ENOMEM;
-
 	mutex_lock(&bdev->bd_mutex);
 	if (bdev->bd_openers)
 		ret = -EBUSY;
 	else
 		zram_reset_device(zram);
 	mutex_unlock(&bdev->bd_mutex);
-	bdput(bdev);
 
 	return ret ? ret : len;
 }
@@ -1933,15 +1928,8 @@ static int zram_add(void)
 
 static int zram_remove(struct zram *zram)
 {
-	struct block_device *bdev = bdget_disk(zram->disk, 0);
-
-	if (bdev) {
-		if (bdev->bd_openers) {
-			bdput(bdev);
-			return -EBUSY;
-		}
-		bdput(bdev);
-	}
+	if (zram->disk->part0->bd_openers)
+		return -EBUSY;
 
 	del_gendisk(zram->disk);
 	zram_debugfs_unregister(zram);
diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index 176adcff56b380..ed7e836efbcdbc 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -2375,16 +2375,11 @@ struct dm_table *dm_swap_table(struct mapped_device *md, struct dm_table *table)
  */
 static int lock_fs(struct mapped_device *md)
 {
-	struct block_device *bdev;
 	int r;
 
 	WARN_ON(test_bit(DMF_FROZEN, &md->flags));
 
-	bdev = bdget_disk(md->disk, 0);
-	if (!bdev)
-		return -ENOMEM;
-	r = freeze_bdev(bdev);
-	bdput(bdev);
+	r = freeze_bdev(md->disk->part0);
 	if (!r)
 		set_bit(DMF_FROZEN, &md->flags);
 	return r;
@@ -2392,16 +2387,9 @@ static int lock_fs(struct mapped_device *md)
 
 static void unlock_fs(struct mapped_device *md)
 {
-	struct block_device *bdev;
-
 	if (!test_bit(DMF_FROZEN, &md->flags))
 		return;
-
-	bdev = bdget_disk(md->disk, 0);
-	if (!bdev)
-		return;
-	thaw_bdev(bdev);
-	bdput(bdev);
+	thaw_bdev(md->disk->part0);
 	clear_bit(DMF_FROZEN, &md->flags);
 }
 
diff --git a/drivers/s390/block/dasd_ioctl.c b/drivers/s390/block/dasd_ioctl.c
index 304eba1acf163c..9f642440894655 100644
--- a/drivers/s390/block/dasd_ioctl.c
+++ b/drivers/s390/block/dasd_ioctl.c
@@ -220,9 +220,8 @@ dasd_format(struct dasd_block *block, struct format_data_t *fdata)
 	 * enabling the device later.
 	 */
 	if (fdata->start_unit == 0) {
-		struct block_device *bdev = bdget_disk(block->gdp, 0);
-		bdev->bd_inode->i_blkbits = blksize_bits(fdata->blksize);
-		bdput(bdev);
+		block->gdp->part0->bd_inode->i_blkbits =
+			blksize_bits(fdata->blksize);
 	}
 
 	rc = base->discipline->format_device(base, fdata, 1);
-- 
2.29.2

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel


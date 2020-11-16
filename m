Return-Path: <SRS0=UzxB=EW=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 28364C82558
	for <dm-devel@archiver.kernel.org>; Mon, 16 Nov 2020 15:00:49 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id ADA2422263
	for <dm-devel@archiver.kernel.org>; Mon, 16 Nov 2020 15:00:45 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org ADA2422263
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-331-y_V8guUrPQuDGmdFQbhnBg-1; Mon, 16 Nov 2020 10:00:40 -0500
X-MC-Unique: y_V8guUrPQuDGmdFQbhnBg-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 9089AD8ED8;
	Mon, 16 Nov 2020 15:00:14 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 6EC5E50B44;
	Mon, 16 Nov 2020 15:00:14 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 3B9C45812B;
	Mon, 16 Nov 2020 15:00:14 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
	[10.11.54.4])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 0AGF0BTi015866 for <dm-devel@listman.util.phx.redhat.com>;
	Mon, 16 Nov 2020 10:00:11 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 54D4020182A5; Mon, 16 Nov 2020 15:00:11 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 507222011553
	for <dm-devel@redhat.com>; Mon, 16 Nov 2020 15:00:11 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [207.211.31.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 388CB801184
	for <dm-devel@redhat.com>; Mon, 16 Nov 2020 15:00:11 +0000 (UTC)
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-203-UY_82t0wO5eoWa9PwaaZ-Q-1; Mon, 16 Nov 2020 10:00:03 -0500
X-MC-Unique: UY_82t0wO5eoWa9PwaaZ-Q-1
Received: from [2001:4bb8:180:6600:255b:7def:a93:4a09] (helo=localhost)
	by casper.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
	id 1kefz4-0004J1-6I; Mon, 16 Nov 2020 14:59:58 +0000
From: Christoph Hellwig <hch@lst.de>
To: Jens Axboe <axboe@kernel.dk>
Date: Mon, 16 Nov 2020 15:58:06 +0100
Message-Id: <20201116145809.410558-76-hch@lst.de>
In-Reply-To: <20201116145809.410558-1-hch@lst.de>
References: <20201116145809.410558-1-hch@lst.de>
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
Cc: Justin Sanders <justin@coraid.com>, Mike Snitzer <snitzer@redhat.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Jason Wang <jasowang@redhat.com>, linux-nvme@lists.infradead.org,
	Song Liu <song@kernel.org>, dm-devel@redhat.com,
	linux-scsi@vger.kernel.org, xen-devel@lists.xenproject.org,
	Ilya Dryomov <idryomov@gmail.com>, Jack Wang <jinpu.wang@cloud.ionos.com>,
	Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
	Josef Bacik <josef@toxicpanda.com>, nbd@other.debian.org,
	linux-raid@vger.kernel.org,
	Stefan Hajnoczi <stefanha@redhat.com>, drbd-dev@tron.linbit.com,
	ceph-devel@vger.kernel.org, linux-block@vger.kernel.org,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Minchan Kim <minchan@kernel.org>, linux-fsdevel@vger.kernel.org,
	Paolo Bonzini <pbonzini@redhat.com>,
	=?UTF-8?q?Roger=20Pau=20Monn=C3=A9?= <roger.pau@citrix.com>
Subject: [dm-devel] [PATCH 75/78] block: stop using bdget_disk for partition
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

We can just dereference the point in struct gendisk instead.  Also
remove the now unused export.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 block/genhd.c                   |  1 -
 drivers/block/nbd.c             |  4 +---
 drivers/block/xen-blkfront.c    | 20 +++++---------------
 drivers/block/zram/zram_drv.c   | 25 ++-----------------------
 drivers/md/dm.c                 | 13 ++-----------
 drivers/s390/block/dasd_ioctl.c |  5 ++---
 6 files changed, 12 insertions(+), 56 deletions(-)

diff --git a/block/genhd.c b/block/genhd.c
index 5dcb8b8902daae..b2a4e68171519a 100644
--- a/block/genhd.c
+++ b/block/genhd.c
@@ -904,7 +904,6 @@ struct block_device *bdget_disk(struct gendisk *disk, int partno)
 
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
index 5b1f99ca77b734..c2721ec73d7291 100644
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
index e765765263495f..e7a23638e2f181 100644
--- a/drivers/block/zram/zram_drv.c
+++ b/drivers/block/zram/zram_drv.c
@@ -1748,7 +1748,6 @@ static ssize_t reset_store(struct device *dev,
 		struct device_attribute *attr, const char *buf, size_t len)
 {
 	struct zram *zram = dev_to_zram(dev);
-	struct block_device *bdev;
 	unsigned short do_reset;
 	int ret = 0;
 
@@ -1758,17 +1757,12 @@ static ssize_t reset_store(struct device *dev,
 	if (!do_reset)
 		return -EINVAL;
 
-	bdev = bdget_disk(zram->disk, 0);
-	if (!bdev)
-		return -ENOMEM;
-
 	mutex_lock(&zram->disk->mutex);
-	if (bdev->bd_openers)
+	if (zram->disk->part0->bd_openers)
 		ret = -EBUSY;
 	else
 		zram_reset_device(zram);
 	mutex_unlock(&zram->disk->mutex);
-	bdput(bdev);
 
 	return ret ? ret : len;
 }
@@ -1931,24 +1925,9 @@ static int zram_add(void)
 	return ret;
 }
 
-static bool zram_busy(struct zram *zram)
-{
-	struct block_device *bdev;
-	bool busy = false;
-
-	bdev = bdget_disk(zram->disk, 0);
-	if (bdev) {
-		if (bdev->bd_openers)
-			busy = true;
-		bdput(bdev);
-	}
-
-	return busy;
-}
-
 static int zram_remove(struct zram *zram)
 {
-	if (zram_busy(zram))
+	if (zram->disk->part0->bd_openers)
 		return -EBUSY;
 
 	del_gendisk(zram->disk);
diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index ac46f6e41279cc..ec48ccae50dd53 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -2375,17 +2375,12 @@ struct dm_table *dm_swap_table(struct mapped_device *md, struct dm_table *table)
  */
 static int lock_fs(struct mapped_device *md)
 {
-	struct block_device *bdev;
 	int r;
 
 	WARN_ON(md->frozen_sb);
 
-	bdev = bdget_disk(md->disk, 0);
-	if (!bdev)
-		return -ENOMEM;
-	md->frozen_sb = freeze_bdev(bdev);
+	md->frozen_sb = freeze_bdev(md->disk->part0);
 	if (IS_ERR(md->frozen_sb)) {
-		bdput(bdev);
 		r = PTR_ERR(md->frozen_sb);
 		md->frozen_sb = NULL;
 		return r;
@@ -2398,14 +2393,10 @@ static int lock_fs(struct mapped_device *md)
 
 static void unlock_fs(struct mapped_device *md)
 {
-	struct block_device *bdev;
-
 	if (!test_bit(DMF_FROZEN, &md->flags))
 		return;
 
-	bdev = md->frozen_sb->s_bdev;
-	thaw_bdev(bdev, md->frozen_sb);
-	bdput(bdev);
+	thaw_bdev(md->frozen_sb->s_bdev, md->frozen_sb);
 	md->frozen_sb = NULL;
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


Return-Path: <SRS0=UzxB=EW=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9EA06C8254D
	for <dm-devel@archiver.kernel.org>; Mon, 16 Nov 2020 15:00:47 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [63.128.21.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 2B12C2462E
	for <dm-devel@archiver.kernel.org>; Mon, 16 Nov 2020 15:00:47 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 2B12C2462E
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-250-cXAyiwisOZqqcl1lDx0mdw-1; Mon, 16 Nov 2020 10:00:42 -0500
X-MC-Unique: cXAyiwisOZqqcl1lDx0mdw-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 8A0D1107B768;
	Mon, 16 Nov 2020 15:00:06 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 5D58B196FD;
	Mon, 16 Nov 2020 15:00:06 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id D7ACC58128;
	Mon, 16 Nov 2020 15:00:05 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
	[10.11.54.5])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 0AGF032b015797 for <dm-devel@listman.util.phx.redhat.com>;
	Mon, 16 Nov 2020 10:00:04 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id CCA476FA72; Mon, 16 Nov 2020 15:00:03 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id C6D7F6FA76
	for <dm-devel@redhat.com>; Mon, 16 Nov 2020 15:00:03 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [205.139.110.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id AA682801184
	for <dm-devel@redhat.com>; Mon, 16 Nov 2020 15:00:03 +0000 (UTC)
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-534-xGyAFmvEMwue4C_APPbR0A-1; Mon, 16 Nov 2020 09:59:57 -0500
X-MC-Unique: xGyAFmvEMwue4C_APPbR0A-1
Received: from [2001:4bb8:180:6600:255b:7def:a93:4a09] (helo=localhost)
	by casper.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
	id 1kefyx-0004Gy-FJ; Mon, 16 Nov 2020 14:59:51 +0000
From: Christoph Hellwig <hch@lst.de>
To: Jens Axboe <axboe@kernel.dk>
Date: Mon, 16 Nov 2020 15:58:01 +0100
Message-Id: <20201116145809.410558-71-hch@lst.de>
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
X-Scanned-By: MIMEDefang 2.79 on 10.11.54.5
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
Subject: [dm-devel] [PATCH 70/78] block: replace bd_mutex with a per-gendisk
	mutex
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

bd_mutex is primarily used for synchronizing the block device open and
release path, which recurses from partitions to the whole disk device.
The fact that we have two locks makes life unnecessarily complex due
to lock order constrains.  Replace the two levels of locking with a
single mutex in the gendisk structure.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 block/genhd.c                   |  7 ++--
 block/ioctl.c                   |  4 +-
 block/partitions/core.c         | 22 +++++-----
 drivers/block/loop.c            | 14 +++----
 drivers/block/xen-blkfront.c    |  8 ++--
 drivers/block/zram/zram_drv.c   |  4 +-
 drivers/block/zram/zram_drv.h   |  2 +-
 drivers/md/md.h                 |  7 +---
 drivers/s390/block/dasd_genhd.c |  8 ++--
 drivers/scsi/sd.c               |  4 +-
 fs/block_dev.c                  | 71 +++++++++++++++++----------------
 fs/btrfs/volumes.c              |  2 +-
 fs/super.c                      |  8 ++--
 include/linux/blk_types.h       |  1 -
 include/linux/genhd.h           |  1 +
 15 files changed, 80 insertions(+), 83 deletions(-)

diff --git a/block/genhd.c b/block/genhd.c
index 7832968ce3fbb7..999f7142b04e7d 100644
--- a/block/genhd.c
+++ b/block/genhd.c
@@ -1350,7 +1350,7 @@ static const struct attribute_group *disk_attr_groups[] = {
  * original ptbl is freed using RCU callback.
  *
  * LOCKING:
- * Matching bd_mutex locked or the caller is the only user of @disk.
+ * disk->mutex locked or the caller is the only user of @disk.
  */
 static void disk_replace_part_tbl(struct gendisk *disk,
 				  struct disk_part_tbl *new_ptbl)
@@ -1375,7 +1375,7 @@ static void disk_replace_part_tbl(struct gendisk *disk,
  * uses RCU to allow unlocked dereferencing for stats and other stuff.
  *
  * LOCKING:
- * Matching bd_mutex locked or the caller is the only user of @disk.
+ * disk->mutex locked or the caller is the only user of @disk.
  * Might sleep.
  *
  * RETURNS:
@@ -1616,6 +1616,7 @@ struct gendisk *__alloc_disk_node(int minors, int node_id)
 	if (!disk->part0.dkstats)
 		goto out_bdput;
 
+	mutex_init(&disk->mutex);
 	init_rwsem(&disk->lookup_sem);
 	disk->node_id = node_id;
 	if (disk_expand_part_tbl(disk, 0)) {
@@ -1842,7 +1843,7 @@ void disk_unblock_events(struct gendisk *disk)
  * doesn't clear the events from @disk->ev.
  *
  * CONTEXT:
- * If @mask is non-zero must be called with bdev->bd_mutex held.
+ * If @mask is non-zero must be called with disk->mutex held.
  */
 void disk_flush_events(struct gendisk *disk, unsigned int mask)
 {
diff --git a/block/ioctl.c b/block/ioctl.c
index 22f394d118c302..18adf9b16a30f6 100644
--- a/block/ioctl.c
+++ b/block/ioctl.c
@@ -99,9 +99,9 @@ static int blkdev_reread_part(struct block_device *bdev)
 	if (!capable(CAP_SYS_ADMIN))
 		return -EACCES;
 
-	mutex_lock(&bdev->bd_mutex);
+	mutex_lock(&bdev->bd_disk->mutex);
 	ret = bdev_disk_changed(bdev, false);
-	mutex_unlock(&bdev->bd_mutex);
+	mutex_unlock(&bdev->bd_disk->mutex);
 
 	return ret;
 }
diff --git a/block/partitions/core.c b/block/partitions/core.c
index 573ef5a03fc104..e50b5ca17df550 100644
--- a/block/partitions/core.c
+++ b/block/partitions/core.c
@@ -328,7 +328,7 @@ int hd_ref_init(struct hd_struct *part)
 }
 
 /*
- * Must be called either with bd_mutex held, before a disk can be opened or
+ * Must be called either with disk->mutex held, before a disk can be opened or
  * after all disk users are gone.
  */
 void delete_partition(struct hd_struct *part)
@@ -363,7 +363,7 @@ static ssize_t whole_disk_show(struct device *dev,
 static DEVICE_ATTR(whole_disk, 0444, whole_disk_show, NULL);
 
 /*
- * Must be called either with bd_mutex held, before a disk can be opened or
+ * Must be called either with disk->mutex held, before a disk can be opened or
  * after all disk users are gone.
  */
 static struct hd_struct *add_partition(struct gendisk *disk, int partno,
@@ -530,15 +530,15 @@ int bdev_add_partition(struct block_device *bdev, int partno,
 {
 	struct hd_struct *part;
 
-	mutex_lock(&bdev->bd_mutex);
+	mutex_lock(&bdev->bd_disk->mutex);
 	if (partition_overlaps(bdev->bd_disk, start, length, -1)) {
-		mutex_unlock(&bdev->bd_mutex);
+		mutex_unlock(&bdev->bd_disk->mutex);
 		return -EBUSY;
 	}
 
 	part = add_partition(bdev->bd_disk, partno, start, length,
 			ADDPART_FLAG_NONE, NULL);
-	mutex_unlock(&bdev->bd_mutex);
+	mutex_unlock(&bdev->bd_disk->mutex);
 	return PTR_ERR_OR_ZERO(part);
 }
 
@@ -552,8 +552,7 @@ int bdev_del_partition(struct block_device *bdev, int partno)
 	if (!bdevp)
 		return -ENXIO;
 
-	mutex_lock(&bdevp->bd_mutex);
-	mutex_lock_nested(&bdev->bd_mutex, 1);
+	mutex_lock(&bdev->bd_disk->mutex);
 
 	ret = -ENXIO;
 	part = disk_get_part(bdev->bd_disk, partno);
@@ -570,8 +569,7 @@ int bdev_del_partition(struct block_device *bdev, int partno)
 	delete_partition(part);
 	ret = 0;
 out_unlock:
-	mutex_unlock(&bdev->bd_mutex);
-	mutex_unlock(&bdevp->bd_mutex);
+	mutex_unlock(&bdev->bd_disk->mutex);
 	bdput(bdevp);
 	if (part)
 		disk_put_part(part);
@@ -594,8 +592,7 @@ int bdev_resize_partition(struct block_device *bdev, int partno,
 	if (!bdevp)
 		goto out_put_part;
 
-	mutex_lock(&bdevp->bd_mutex);
-	mutex_lock_nested(&bdev->bd_mutex, 1);
+	mutex_lock(&bdev->bd_disk->mutex);
 
 	ret = -EINVAL;
 	if (start != part->start_sect)
@@ -609,8 +606,7 @@ int bdev_resize_partition(struct block_device *bdev, int partno,
 
 	ret = 0;
 out_unlock:
-	mutex_unlock(&bdevp->bd_mutex);
-	mutex_unlock(&bdev->bd_mutex);
+	mutex_unlock(&bdev->bd_disk->mutex);
 	bdput(bdevp);
 out_put_part:
 	disk_put_part(part);
diff --git a/drivers/block/loop.c b/drivers/block/loop.c
index 9d2587f6167cd8..91e47c5b52f1cb 100644
--- a/drivers/block/loop.c
+++ b/drivers/block/loop.c
@@ -651,9 +651,9 @@ static void loop_reread_partitions(struct loop_device *lo,
 {
 	int rc;
 
-	mutex_lock(&bdev->bd_mutex);
+	mutex_lock(&bdev->bd_disk->mutex);
 	rc = bdev_disk_changed(bdev, false);
-	mutex_unlock(&bdev->bd_mutex);
+	mutex_unlock(&bdev->bd_disk->mutex);
 	if (rc)
 		pr_warn("%s: partition scan of loop%d (%s) failed (rc=%d)\n",
 			__func__, lo->lo_number, lo->lo_file_name, rc);
@@ -746,7 +746,7 @@ static int loop_change_fd(struct loop_device *lo, struct block_device *bdev,
 	mutex_unlock(&loop_ctl_mutex);
 	/*
 	 * We must drop file reference outside of loop_ctl_mutex as dropping
-	 * the file ref can take bd_mutex which creates circular locking
+	 * the file ref can take disk->mutex which creates circular locking
 	 * dependency.
 	 */
 	fput(old_file);
@@ -1258,7 +1258,7 @@ static int __loop_clr_fd(struct loop_device *lo, bool release)
 	mutex_unlock(&loop_ctl_mutex);
 	if (partscan) {
 		/*
-		 * bd_mutex has been held already in release path, so don't
+		 * disk->mutex has been held already in release path, so don't
 		 * acquire it if this function is called in such case.
 		 *
 		 * If the reread partition isn't from release path, lo_refcnt
@@ -1266,10 +1266,10 @@ static int __loop_clr_fd(struct loop_device *lo, bool release)
 		 * current holder is released.
 		 */
 		if (!release)
-			mutex_lock(&bdev->bd_mutex);
+			mutex_lock(&bdev->bd_disk->mutex);
 		err = bdev_disk_changed(bdev, false);
 		if (!release)
-			mutex_unlock(&bdev->bd_mutex);
+			mutex_unlock(&bdev->bd_disk->mutex);
 		if (err)
 			pr_warn("%s: partition scan of loop%d failed (rc=%d)\n",
 				__func__, lo_number, err);
@@ -1297,7 +1297,7 @@ static int __loop_clr_fd(struct loop_device *lo, bool release)
 	 * Need not hold loop_ctl_mutex to fput backing file.
 	 * Calling fput holding loop_ctl_mutex triggers a circular
 	 * lock dependency possibility warning as fput can take
-	 * bd_mutex which is usually taken before loop_ctl_mutex.
+	 * disk->mutex which is usually taken before loop_ctl_mutex.
 	 */
 	if (filp)
 		fput(filp);
diff --git a/drivers/block/xen-blkfront.c b/drivers/block/xen-blkfront.c
index 79521e33d30ed5..5b1f99ca77b734 100644
--- a/drivers/block/xen-blkfront.c
+++ b/drivers/block/xen-blkfront.c
@@ -2162,7 +2162,7 @@ static void blkfront_closing(struct blkfront_info *info)
 		return;
 	}
 
-	mutex_lock(&bdev->bd_mutex);
+	mutex_lock(&info->gd->mutex);
 
 	if (bdev->bd_openers) {
 		xenbus_dev_error(xbdev, -EBUSY,
@@ -2173,7 +2173,7 @@ static void blkfront_closing(struct blkfront_info *info)
 		xenbus_frontend_closed(xbdev);
 	}
 
-	mutex_unlock(&bdev->bd_mutex);
+	mutex_unlock(&info->gd->mutex);
 	bdput(bdev);
 }
 
@@ -2536,7 +2536,7 @@ static int blkfront_remove(struct xenbus_device *xbdev)
 	 * isn't closed yet, we let release take care of it.
 	 */
 
-	mutex_lock(&bdev->bd_mutex);
+	mutex_lock(&info->gd->mutex);
 	info = disk->private_data;
 
 	dev_warn(disk_to_dev(disk),
@@ -2551,7 +2551,7 @@ static int blkfront_remove(struct xenbus_device *xbdev)
 		mutex_unlock(&blkfront_mutex);
 	}
 
-	mutex_unlock(&bdev->bd_mutex);
+	mutex_unlock(&info->gd->mutex);
 	bdput(bdev);
 
 	return 0;
diff --git a/drivers/block/zram/zram_drv.c b/drivers/block/zram/zram_drv.c
index d00b5761ec0b21..0b156f09e208df 100644
--- a/drivers/block/zram/zram_drv.c
+++ b/drivers/block/zram/zram_drv.c
@@ -1762,12 +1762,12 @@ static ssize_t reset_store(struct device *dev,
 	if (!bdev)
 		return -ENOMEM;
 
-	mutex_lock(&bdev->bd_mutex);
+	mutex_lock(&zram->disk->mutex);
 	if (bdev->bd_openers)
 		ret = -EBUSY;
 	else
 		zram_reset_device(zram);
-	mutex_unlock(&bdev->bd_mutex);
+	mutex_unlock(&zram->disk->mutex);
 	bdput(bdev);
 
 	return ret ? ret : len;
diff --git a/drivers/block/zram/zram_drv.h b/drivers/block/zram/zram_drv.h
index 712354a4207c77..b300632c17c172 100644
--- a/drivers/block/zram/zram_drv.h
+++ b/drivers/block/zram/zram_drv.h
@@ -111,7 +111,7 @@ struct zram {
 	/*
 	 * zram is claimed so open request will be failed
 	 */
-	bool claim; /* Protected by bdev->bd_mutex */
+	bool claim; /* Protected by bdev->bd_disk->mutex */
 	struct file *backing_dev;
 #ifdef CONFIG_ZRAM_WRITEBACK
 	spinlock_t wb_limit_lock;
diff --git a/drivers/md/md.h b/drivers/md/md.h
index ccfb69868c2ec9..28712d3498de2c 100644
--- a/drivers/md/md.h
+++ b/drivers/md/md.h
@@ -394,11 +394,8 @@ struct mddev {
 	/* 'open_mutex' avoids races between 'md_open' and 'do_md_stop', so
 	 * that we are never stopping an array while it is open.
 	 * 'reconfig_mutex' protects all other reconfiguration.
-	 * These locks are separate due to conflicting interactions
-	 * with bdev->bd_mutex.
-	 * Lock ordering is:
-	 *  reconfig_mutex -> bd_mutex
-	 *  bd_mutex -> open_mutex:  e.g. __blkdev_get -> md_open
+	 * These locks are separate due to historically conflicting
+	 * interactions with block layer locks.
 	 */
 	struct mutex			open_mutex;
 	struct mutex			reconfig_mutex;
diff --git a/drivers/s390/block/dasd_genhd.c b/drivers/s390/block/dasd_genhd.c
index a9698fba9b76ce..7b5f475b500e8c 100644
--- a/drivers/s390/block/dasd_genhd.c
+++ b/drivers/s390/block/dasd_genhd.c
@@ -109,9 +109,9 @@ int dasd_scan_partitions(struct dasd_block *block)
 		return -ENODEV;
 	}
 
-	mutex_lock(&bdev->bd_mutex);
+	mutex_lock(&bdev->bd_disk->mutex);
 	rc = bdev_disk_changed(bdev, false);
-	mutex_unlock(&bdev->bd_mutex);
+	mutex_unlock(&bdev->bd_disk->mutex);
 	if (rc)
 		DBF_DEV_EVENT(DBF_ERR, block->base,
 				"scan partitions error, rc %d", rc);
@@ -145,9 +145,9 @@ void dasd_destroy_partitions(struct dasd_block *block)
 	bdev = block->bdev;
 	block->bdev = NULL;
 
-	mutex_lock(&bdev->bd_mutex);
+	mutex_lock(&bdev->bd_disk->mutex);
 	blk_drop_partitions(bdev);
-	mutex_unlock(&bdev->bd_mutex);
+	mutex_unlock(&bdev->bd_disk->mutex);
 
 	/* Matching blkdev_put to the blkdev_get in dasd_scan_partitions. */
 	blkdev_put(bdev, FMODE_READ);
diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 679c2c02504763..68c752ef3ed575 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -1398,7 +1398,7 @@ static void sd_uninit_command(struct scsi_cmnd *SCpnt)
  *	In the latter case @inode and @filp carry an abridged amount
  *	of information as noted above.
  *
- *	Locking: called with bdev->bd_mutex held.
+ *	Locking: called with bdev->bd_disk->mutex held.
  **/
 static int sd_open(struct block_device *bdev, fmode_t mode)
 {
@@ -1474,7 +1474,7 @@ static int sd_open(struct block_device *bdev, fmode_t mode)
  *	Note: may block (uninterruptible) if error recovery is underway
  *	on this disk.
  *
- *	Locking: called with bdev->bd_mutex held.
+ *	Locking: called with bdev->bd_disk->mutex held.
  **/
 static void sd_release(struct gendisk *disk, fmode_t mode)
 {
diff --git a/fs/block_dev.c b/fs/block_dev.c
index 14b6dbfa9dda2a..4b59ace9632f65 100644
--- a/fs/block_dev.c
+++ b/fs/block_dev.c
@@ -803,7 +803,6 @@ static void init_once(void *foo)
 	struct block_device *bdev = &ei->bdev;
 
 	memset(bdev, 0, sizeof(*bdev));
-	mutex_init(&bdev->bd_mutex);
 #ifdef CONFIG_SYSFS
 	INIT_LIST_HEAD(&bdev->bd_holder_disks);
 #endif
@@ -1204,7 +1203,7 @@ int bd_link_disk_holder(struct block_device *bdev, struct gendisk *disk)
 	struct bd_holder_disk *holder;
 	int ret = 0;
 
-	mutex_lock(&bdev->bd_mutex);
+	mutex_lock(&bdev->bd_disk->mutex);
 
 	WARN_ON_ONCE(!bdev->bd_holder);
 
@@ -1249,7 +1248,7 @@ int bd_link_disk_holder(struct block_device *bdev, struct gendisk *disk)
 out_free:
 	kfree(holder);
 out_unlock:
-	mutex_unlock(&bdev->bd_mutex);
+	mutex_unlock(&bdev->bd_disk->mutex);
 	return ret;
 }
 EXPORT_SYMBOL_GPL(bd_link_disk_holder);
@@ -1268,7 +1267,7 @@ void bd_unlink_disk_holder(struct block_device *bdev, struct gendisk *disk)
 {
 	struct bd_holder_disk *holder;
 
-	mutex_lock(&bdev->bd_mutex);
+	mutex_lock(&bdev->bd_disk->mutex);
 
 	holder = bd_find_holder_disk(bdev, disk);
 
@@ -1281,7 +1280,7 @@ void bd_unlink_disk_holder(struct block_device *bdev, struct gendisk *disk)
 		kfree(holder);
 	}
 
-	mutex_unlock(&bdev->bd_mutex);
+	mutex_unlock(&bdev->bd_disk->mutex);
 }
 EXPORT_SYMBOL_GPL(bd_unlink_disk_holder);
 #endif
@@ -1293,7 +1292,7 @@ int bdev_disk_changed(struct block_device *bdev, bool invalidate)
 	struct gendisk *disk = bdev->bd_disk;
 	int ret;
 
-	lockdep_assert_held(&bdev->bd_mutex);
+	lockdep_assert_held(&bdev->bd_disk->mutex);
 
 	clear_bit(GD_NEED_PART_SCAN, &bdev->bd_disk->state);
 
@@ -1357,13 +1356,6 @@ static int bdev_get_gendisk(struct gendisk *disk)
 	return -ENXIO;
 }
 
-/*
- * bd_mutex locking:
- *
- *  mutex_lock(part->bd_mutex)
- *    mutex_lock_nested(whole->bd_mutex, 1)
- */
-
 static int __blkdev_get(struct block_device *bdev, fmode_t mode, void *holder,
 		int for_part)
 {
@@ -1377,15 +1369,18 @@ static int __blkdev_get(struct block_device *bdev, fmode_t mode, void *holder,
 	if (ret)
 		goto out;
 
-	if (!for_part && (mode & FMODE_EXCL)) {
-		WARN_ON_ONCE(!holder);
-		ret = bd_prepare_to_claim(bdev, holder);
-		if (ret)
-			goto out_put_disk;
+	if (!for_part) {
+		if (mode & FMODE_EXCL) {
+			WARN_ON_ONCE(!holder);
+			ret = bd_prepare_to_claim(bdev, holder);
+			if (ret)
+				goto out_put_disk;
+		}
+
+		disk_block_events(disk);
+		mutex_lock(&disk->mutex);
 	}
 
-	disk_block_events(disk);
-	mutex_lock_nested(&bdev->bd_mutex, for_part);
 	if (!bdev->bd_openers) {
 		first_open = true;
 
@@ -1470,10 +1465,14 @@ static int __blkdev_get(struct block_device *bdev, fmode_t mode, void *holder,
 			unblock_events = false;
 		}
 	}
-	mutex_unlock(&bdev->bd_mutex);
 
-	if (unblock_events)
-		disk_unblock_events(disk);
+	if (!for_part) {
+		mutex_unlock(&disk->mutex);
+
+		if (unblock_events)
+			disk_unblock_events(disk);
+	}
+
 
 	/* only one opener holds the module reference */
 	if (!first_open)
@@ -1486,10 +1485,12 @@ static int __blkdev_get(struct block_device *bdev, fmode_t mode, void *holder,
 	if (bdev_is_partition(bdev))
 		__blkdev_put(bdev_whole(bdev), mode, 1);
  out_unlock_bdev:
-	if (!for_part && (mode & FMODE_EXCL))
-		bd_abort_claiming(bdev, holder);
-	mutex_unlock(&bdev->bd_mutex);
-	disk_unblock_events(disk);
+	if (!for_part) {
+		if (mode & FMODE_EXCL)
+			bd_abort_claiming(bdev, holder);
+		mutex_unlock(&disk->mutex);
+		disk_unblock_events(disk);
+	}
  out_put_disk:
 	module_put(disk->fops->owner);
 	if (need_restart)
@@ -1668,9 +1669,10 @@ static void __blkdev_put(struct block_device *bdev, fmode_t mode, int for_part)
 	if (bdev->bd_openers == 1)
 		sync_blockdev(bdev);
 
-	mutex_lock_nested(&bdev->bd_mutex, for_part);
 	if (for_part)
 		bdev->bd_part_count--;
+	else
+		mutex_lock(&disk->mutex);
 
 	if (!--bdev->bd_openers) {
 		WARN_ON_ONCE(bdev->bd_holders);
@@ -1691,7 +1693,8 @@ static void __blkdev_put(struct block_device *bdev, fmode_t mode, int for_part)
 
 		module_put(disk->fops->owner);
 	}
-	mutex_unlock(&bdev->bd_mutex);
+	if (!for_part)
+		mutex_unlock(&disk->mutex);
 	bdput(bdev);
 	if (victim)
 		__blkdev_put(victim, mode, 1);
@@ -1699,7 +1702,7 @@ static void __blkdev_put(struct block_device *bdev, fmode_t mode, int for_part)
 
 void blkdev_put(struct block_device *bdev, fmode_t mode)
 {
-	mutex_lock(&bdev->bd_mutex);
+	mutex_lock(&bdev->bd_disk->mutex);
 
 	if (mode & FMODE_EXCL) {
 		struct block_device *whole = bdev_whole(bdev);
@@ -1707,7 +1710,7 @@ void blkdev_put(struct block_device *bdev, fmode_t mode)
 
 		/*
 		 * Release a claim on the device.  The holder fields
-		 * are protected with bdev_lock.  bd_mutex is to
+		 * are protected with bdev_lock.  disk->mutex is to
 		 * synchronize disk_holder unlinking.
 		 */
 		spin_lock(&bdev_lock);
@@ -1739,7 +1742,7 @@ void blkdev_put(struct block_device *bdev, fmode_t mode)
 	 */
 	disk_flush_events(bdev->bd_disk, DISK_EVENT_MEDIA_CHANGE);
 
-	mutex_unlock(&bdev->bd_mutex);
+	mutex_unlock(&bdev->bd_disk->mutex);
 
 	__blkdev_put(bdev, mode, 0);
 }
@@ -2039,10 +2042,10 @@ void iterate_bdevs(void (*func)(struct block_device *, void *), void *arg)
 		old_inode = inode;
 		bdev = I_BDEV(inode);
 
-		mutex_lock(&bdev->bd_mutex);
+		mutex_lock(&bdev->bd_disk->mutex);
 		if (bdev->bd_openers)
 			func(bdev, arg);
-		mutex_unlock(&bdev->bd_mutex);
+		mutex_unlock(&bdev->bd_disk->mutex);
 
 		spin_lock(&blockdev_superblock->s_inode_list_lock);
 	}
diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index a6406b3b8c2b4f..ce43732f945f45 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -1237,7 +1237,7 @@ int btrfs_open_devices(struct btrfs_fs_devices *fs_devices,
 	lockdep_assert_held(&uuid_mutex);
 	/*
 	 * The device_list_mutex cannot be taken here in case opening the
-	 * underlying device takes further locks like bd_mutex.
+	 * underlying device takes further locks like disk->mutex.
 	 *
 	 * We also don't need the lock here as this is called during mount and
 	 * exclusion is provided by uuid_mutex
diff --git a/fs/super.c b/fs/super.c
index 98bb0629ee108e..b327a82bc1946b 100644
--- a/fs/super.c
+++ b/fs/super.c
@@ -1328,9 +1328,9 @@ int get_tree_bdev(struct fs_context *fc,
 		}
 
 		/*
-		 * s_umount nests inside bd_mutex during
+		 * s_umount nests inside disk->mutex during
 		 * __invalidate_device().  blkdev_put() acquires
-		 * bd_mutex and can't be called under s_umount.  Drop
+		 * disk->mutex and can't be called under s_umount.  Drop
 		 * s_umount temporarily.  This is safe as we're
 		 * holding an active reference.
 		 */
@@ -1403,9 +1403,9 @@ struct dentry *mount_bdev(struct file_system_type *fs_type,
 		}
 
 		/*
-		 * s_umount nests inside bd_mutex during
+		 * s_umount nests inside disk->mutex during
 		 * __invalidate_device().  blkdev_put() acquires
-		 * bd_mutex and can't be called under s_umount.  Drop
+		 * disk->mutex and can't be called under s_umount.  Drop
 		 * s_umount temporarily.  This is safe as we're
 		 * holding an active reference.
 		 */
diff --git a/include/linux/blk_types.h b/include/linux/blk_types.h
index 041caca25fc787..0735e335ca6c0a 100644
--- a/include/linux/blk_types.h
+++ b/include/linux/blk_types.h
@@ -24,7 +24,6 @@ struct block_device {
 	int			bd_openers;
 	struct inode *		bd_inode;	/* will die */
 	struct super_block *	bd_super;
-	struct mutex		bd_mutex;	/* open/close mutex */
 	void *			bd_claiming;
 	void *			bd_holder;
 	int			bd_holders;
diff --git a/include/linux/genhd.h b/include/linux/genhd.h
index e01618dfafc05c..bc0469cc8fb0dc 100644
--- a/include/linux/genhd.h
+++ b/include/linux/genhd.h
@@ -186,6 +186,7 @@ struct gendisk {
 	unsigned long state;
 #define GD_NEED_PART_SCAN		0
 	struct rw_semaphore lookup_sem;
+	struct mutex mutex;		/* open/close mutex */
 	struct kobject *slave_dir;
 
 	struct timer_rand_state *random;
-- 
2.29.2

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel


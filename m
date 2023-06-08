Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 37CA0C7EE29
	for <dm-devel@archiver.kernel.org>; Thu,  8 Jun 2023 11:52:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1686225148;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=SvK0TlcFZGu1zxPu4SIm7X0voCbIpNEUZZVt9LwVKYM=;
	b=S87AxTieA1oSRBk/0NG4oa97qgrUuwcIN823iUu+WUGGBx31rFEQDiOKoG69XZ+b430avh
	l6WOR1Nt8x2a82eb7QBS68zpIGPDe4/2MI44Uqk2dGG44A0apxFFssJf+BCaqgg6azT+2c
	PkFEptkan3pVDRqMWJyQMYfoBOM9QDg=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-113-gkztCbJsP1SV5a0AQLJKCg-1; Thu, 08 Jun 2023 07:52:26 -0400
X-MC-Unique: gkztCbJsP1SV5a0AQLJKCg-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id EC57B811E78;
	Thu,  8 Jun 2023 11:52:24 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id D59E81121314;
	Thu,  8 Jun 2023 11:52:24 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id B6C3019452D3;
	Thu,  8 Jun 2023 11:52:24 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
 [10.11.54.6])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 1FD82194658C
 for <dm-devel@listman.corp.redhat.com>; Thu,  8 Jun 2023 11:52:24 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id F166F2166B26; Thu,  8 Jun 2023 11:52:23 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast08.extmail.prod.ext.rdu2.redhat.com [10.11.55.24])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id E97E12166B25
 for <dm-devel@redhat.com>; Thu,  8 Jun 2023 11:52:23 +0000 (UTC)
Received: from us-smtp-inbound-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id C9D5D3828893
 for <dm-devel@redhat.com>; Thu,  8 Jun 2023 11:52:23 +0000 (UTC)
Received: from bombadil.infradead.org (bombadil.infradead.org
 [198.137.202.133]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-16-l8JXcVXpMdy9OwZ1J5A63Q-1; Thu, 08 Jun 2023 07:52:21 -0400
X-MC-Unique: l8JXcVXpMdy9OwZ1J5A63Q-1
Received: from
 2a02-8389-2341-5b80-39d3-4735-9a3c-88d8.cable.dynamic.v6.surfer.at
 ([2a02:8389:2341:5b80:39d3:4735:9a3c:88d8] helo=localhost)
 by bombadil.infradead.org with esmtpsa (Exim 4.96 #2 (Red Hat Linux))
 id 1q7DQH-0091oC-1M; Thu, 08 Jun 2023 11:03:21 +0000
From: Christoph Hellwig <hch@lst.de>
To: Jens Axboe <axboe@kernel.dk>
Date: Thu,  8 Jun 2023 13:02:35 +0200
Message-Id: <20230608110258.189493-8-hch@lst.de>
In-Reply-To: <20230608110258.189493-1-hch@lst.de>
References: <20230608110258.189493-1-hch@lst.de>
MIME-Version: 1.0
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by
 bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.6
Subject: [dm-devel] [PATCH 07/30] block: pass a gendisk on
 bdev_check_media_change
X-BeenThere: dm-devel@redhat.com
X-Mailman-Version: 2.1.29
Precedence: list
List-Id: device-mapper development <dm-devel.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/dm-devel>,
 <mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <http://listman.redhat.com/archives/dm-devel/>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/dm-devel>,
 <mailto:dm-devel-request@redhat.com?subject=subscribe>
Cc: Vignesh Raghavendra <vigneshr@ti.com>,
 "Rafael J. Wysocki" <rafael@kernel.org>, linux-nvme@lists.infradead.org,
 Phillip Potter <phil@philpotter.co.uk>, Chris Mason <clm@fb.com>,
 dm-devel@redhat.com, "Md. Haris Iqbal" <haris.iqbal@ionos.com>,
 Pavel Machek <pavel@ucw.cz>, Miquel Raynal <miquel.raynal@bootlin.com>,
 Jack Wang <jinpu.wang@ionos.com>, linux-nilfs@vger.kernel.org,
 linux-scsi@vger.kernel.org, Richard Weinberger <richard@nod.at>,
 linux-pm@vger.kernel.org, linux-um@lists.infradead.org,
 Josef Bacik <josef@toxicpanda.com>, Coly Li <colyli@suse.de>,
 linux-block@vger.kernel.org, linux-bcache@vger.kernel.org,
 Alexander Viro <viro@zeniv.linux.org.uk>, David Sterba <dsterba@suse.com>,
 Christian Brauner <brauner@kernel.org>,
 "Martin K. Petersen" <martin.petersen@oracle.com>,
 linux-f2fs-devel@lists.sourceforge.net, linux-fsdevel@vger.kernel.org,
 linux-mtd@lists.infradead.org, linux-btrfs@vger.kernel.org
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: lst.de
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

bdev_check_media_change should only ever be called for the whole device.
Pass a gendisk to make that explicit and rename the function to
disk_check_media_change.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Hannes Reinecke <hare@suse.de>
Acked-by: Christian Brauner <brauner@kernel.org>
---
 block/disk-events.c     | 18 +++++++++---------
 drivers/block/amiflop.c |  2 +-
 drivers/block/ataflop.c |  6 +++---
 drivers/block/floppy.c  | 16 ++++++++--------
 drivers/block/swim.c    |  2 +-
 drivers/block/swim3.c   |  2 +-
 drivers/cdrom/gdrom.c   |  2 +-
 drivers/md/md.c         |  2 +-
 drivers/scsi/sd.c       |  9 ++++-----
 drivers/scsi/sr.c       |  2 +-
 include/linux/blkdev.h  |  2 +-
 11 files changed, 31 insertions(+), 32 deletions(-)

diff --git a/block/disk-events.c b/block/disk-events.c
index aee25a7e1ab7de..8b1b63225738f8 100644
--- a/block/disk-events.c
+++ b/block/disk-events.c
@@ -263,31 +263,31 @@ static unsigned int disk_clear_events(struct gendisk *disk, unsigned int mask)
 }
 
 /**
- * bdev_check_media_change - check if a removable media has been changed
- * @bdev: block device to check
+ * disk_check_media_change - check if a removable media has been changed
+ * @disk: gendisk to check
  *
  * Check whether a removable media has been changed, and attempt to free all
  * dentries and inodes and invalidates all block device page cache entries in
  * that case.
  *
- * Returns %true if the block device changed, or %false if not.
+ * Returns %true if the media has changed, or %false if not.
  */
-bool bdev_check_media_change(struct block_device *bdev)
+bool disk_check_media_change(struct gendisk *disk)
 {
 	unsigned int events;
 
-	events = disk_clear_events(bdev->bd_disk, DISK_EVENT_MEDIA_CHANGE |
+	events = disk_clear_events(disk, DISK_EVENT_MEDIA_CHANGE |
 				   DISK_EVENT_EJECT_REQUEST);
 	if (!(events & DISK_EVENT_MEDIA_CHANGE))
 		return false;
 
-	if (__invalidate_device(bdev, true))
+	if (__invalidate_device(disk->part0, true))
 		pr_warn("VFS: busy inodes on changed media %s\n",
-			bdev->bd_disk->disk_name);
-	set_bit(GD_NEED_PART_SCAN, &bdev->bd_disk->state);
+			disk->disk_name);
+	set_bit(GD_NEED_PART_SCAN, &disk->state);
 	return true;
 }
-EXPORT_SYMBOL(bdev_check_media_change);
+EXPORT_SYMBOL(disk_check_media_change);
 
 /**
  * disk_force_media_change - force a media change event
diff --git a/drivers/block/amiflop.c b/drivers/block/amiflop.c
index 4c8b2ba579ee6d..6de12b311749a1 100644
--- a/drivers/block/amiflop.c
+++ b/drivers/block/amiflop.c
@@ -1675,7 +1675,7 @@ static int floppy_open(struct block_device *bdev, fmode_t mode)
 	}
 
 	if (mode & (FMODE_READ|FMODE_WRITE)) {
-		bdev_check_media_change(bdev);
+		disk_check_media_change(bdev->bd_disk);
 		if (mode & FMODE_WRITE) {
 			int wrprot;
 
diff --git a/drivers/block/ataflop.c b/drivers/block/ataflop.c
index 9deb4df6bdb8b2..da481ddbca90db 100644
--- a/drivers/block/ataflop.c
+++ b/drivers/block/ataflop.c
@@ -1760,8 +1760,8 @@ static int fd_locked_ioctl(struct block_device *bdev, fmode_t mode,
 		/* invalidate the buffer track to force a reread */
 		BufferDrive = -1;
 		set_bit(drive, &fake_change);
-		if (bdev_check_media_change(bdev))
-			floppy_revalidate(bdev->bd_disk);
+		if (disk_check_media_change(disk))
+			floppy_revalidate(disk);
 		return 0;
 	default:
 		return -EINVAL;
@@ -1938,7 +1938,7 @@ static int floppy_open(struct block_device *bdev, fmode_t mode)
 		return 0;
 
 	if (mode & (FMODE_READ|FMODE_WRITE)) {
-		if (bdev_check_media_change(bdev))
+		if (disk_check_media_change(bdev->bd_disk))
 			floppy_revalidate(bdev->bd_disk);
 		if (mode & FMODE_WRITE) {
 			if (p->wpstat) {
diff --git a/drivers/block/floppy.c b/drivers/block/floppy.c
index 28ec6b442e9c58..3accafcbc95c85 100644
--- a/drivers/block/floppy.c
+++ b/drivers/block/floppy.c
@@ -3210,13 +3210,13 @@ static int floppy_raw_cmd_ioctl(int type, int drive, int cmd,
 
 #endif
 
-static int invalidate_drive(struct block_device *bdev)
+static int invalidate_drive(struct gendisk *disk)
 {
 	/* invalidate the buffer track to force a reread */
-	set_bit((long)bdev->bd_disk->private_data, &fake_change);
+	set_bit((long)disk->private_data, &fake_change);
 	process_fd_request();
-	if (bdev_check_media_change(bdev))
-		floppy_revalidate(bdev->bd_disk);
+	if (disk_check_media_change(disk))
+		floppy_revalidate(disk);
 	return 0;
 }
 
@@ -3287,7 +3287,7 @@ static int set_geometry(unsigned int cmd, struct floppy_struct *g,
 		    drive_state[current_drive].maxtrack ||
 		    ((user_params[drive].sect ^ oldStretch) &
 		     (FD_SWAPSIDES | FD_SECTBASEMASK)))
-			invalidate_drive(bdev);
+			invalidate_drive(bdev->bd_disk);
 		else
 			process_fd_request();
 	}
@@ -3464,7 +3464,7 @@ static int fd_locked_ioctl(struct block_device *bdev, fmode_t mode, unsigned int
 		current_type[drive] = NULL;
 		floppy_sizes[drive] = MAX_DISK_SIZE << 1;
 		drive_state[drive].keep_data = 0;
-		return invalidate_drive(bdev);
+		return invalidate_drive(bdev->bd_disk);
 	case FDSETPRM:
 	case FDDEFPRM:
 		return set_geometry(cmd, &inparam.g, drive, type, bdev);
@@ -3503,7 +3503,7 @@ static int fd_locked_ioctl(struct block_device *bdev, fmode_t mode, unsigned int
 	case FDFLUSH:
 		if (lock_fdc(drive))
 			return -EINTR;
-		return invalidate_drive(bdev);
+		return invalidate_drive(bdev->bd_disk);
 	case FDSETEMSGTRESH:
 		drive_params[drive].max_errors.reporting = (unsigned short)(param & 0x0f);
 		return 0;
@@ -4054,7 +4054,7 @@ static int floppy_open(struct block_device *bdev, fmode_t mode)
 			drive_state[drive].last_checked = 0;
 			clear_bit(FD_OPEN_SHOULD_FAIL_BIT,
 				  &drive_state[drive].flags);
-			if (bdev_check_media_change(bdev))
+			if (disk_check_media_change(bdev->bd_disk))
 				floppy_revalidate(bdev->bd_disk);
 			if (test_bit(FD_DISK_CHANGED_BIT, &drive_state[drive].flags))
 				goto out;
diff --git a/drivers/block/swim.c b/drivers/block/swim.c
index 42b4b682869096..105bc5fd1b8c62 100644
--- a/drivers/block/swim.c
+++ b/drivers/block/swim.c
@@ -640,7 +640,7 @@ static int floppy_open(struct block_device *bdev, fmode_t mode)
 		return 0;
 
 	if (mode & (FMODE_READ|FMODE_WRITE)) {
-		if (bdev_check_media_change(bdev) && fs->disk_in)
+		if (disk_check_media_change(bdev->bd_disk) && fs->disk_in)
 			fs->ejected = 0;
 		if ((mode & FMODE_WRITE) && fs->write_protected) {
 			err = -EROFS;
diff --git a/drivers/block/swim3.c b/drivers/block/swim3.c
index da811a7da03f3d..3d689ba312f568 100644
--- a/drivers/block/swim3.c
+++ b/drivers/block/swim3.c
@@ -963,7 +963,7 @@ static int floppy_open(struct block_device *bdev, fmode_t mode)
 
 	if (err == 0 && (mode & FMODE_NDELAY) == 0
 	    && (mode & (FMODE_READ|FMODE_WRITE))) {
-		if (bdev_check_media_change(bdev))
+		if (disk_check_media_change(bdev->bd_disk))
 			floppy_revalidate(bdev->bd_disk);
 		if (fs->ejected)
 			err = -ENXIO;
diff --git a/drivers/cdrom/gdrom.c b/drivers/cdrom/gdrom.c
index a401dc4218a998..3cb92df38ebeb8 100644
--- a/drivers/cdrom/gdrom.c
+++ b/drivers/cdrom/gdrom.c
@@ -478,7 +478,7 @@ static int gdrom_bdops_open(struct block_device *bdev, fmode_t mode)
 {
 	int ret;
 
-	bdev_check_media_change(bdev);
+	disk_check_media_change(bdev->bd_disk);
 
 	mutex_lock(&gdrom_mutex);
 	ret = cdrom_open(gd.cd_info);
diff --git a/drivers/md/md.c b/drivers/md/md.c
index fabf9c543735b6..77046c91bea439 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -7789,7 +7789,7 @@ static int md_open(struct block_device *bdev, fmode_t mode)
 	atomic_inc(&mddev->openers);
 	mutex_unlock(&mddev->open_mutex);
 
-	bdev_check_media_change(bdev);
+	disk_check_media_change(bdev->bd_disk);
 	return 0;
 
 out_unlock:
diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 1624d528aa1f9c..aab649d5bad3f8 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -1280,11 +1280,10 @@ static void sd_uninit_command(struct scsi_cmnd *SCpnt)
 		mempool_free(rq->special_vec.bv_page, sd_page_pool);
 }
 
-static bool sd_need_revalidate(struct block_device *bdev,
-		struct scsi_disk *sdkp)
+static bool sd_need_revalidate(struct gendisk *disk, struct scsi_disk *sdkp)
 {
 	if (sdkp->device->removable || sdkp->write_prot) {
-		if (bdev_check_media_change(bdev))
+		if (disk_check_media_change(disk))
 			return true;
 	}
 
@@ -1293,7 +1292,7 @@ static bool sd_need_revalidate(struct block_device *bdev,
 	 * nothing to do with partitions, BLKRRPART is used to force a full
 	 * revalidate after things like a format for historical reasons.
 	 */
-	return test_bit(GD_NEED_PART_SCAN, &bdev->bd_disk->state);
+	return test_bit(GD_NEED_PART_SCAN, &disk->state);
 }
 
 /**
@@ -1330,7 +1329,7 @@ static int sd_open(struct block_device *bdev, fmode_t mode)
 	if (!scsi_block_when_processing_errors(sdev))
 		goto error_out;
 
-	if (sd_need_revalidate(bdev, sdkp))
+	if (sd_need_revalidate(bdev->bd_disk, sdkp))
 		sd_revalidate_disk(bdev->bd_disk);
 
 	/*
diff --git a/drivers/scsi/sr.c b/drivers/scsi/sr.c
index 6d33120ee5ba85..1592e6e10c7452 100644
--- a/drivers/scsi/sr.c
+++ b/drivers/scsi/sr.c
@@ -494,7 +494,7 @@ static int sr_block_open(struct block_device *bdev, fmode_t mode)
 		return -ENXIO;
 
 	scsi_autopm_get_device(sdev);
-	if (bdev_check_media_change(bdev))
+	if (disk_check_media_change(bdev->bd_disk))
 		sr_revalidate_disk(cd);
 
 	mutex_lock(&cd->lock);
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index f4c339d9dd03de..a1688eba7e5e9a 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -817,7 +817,7 @@ int __register_blkdev(unsigned int major, const char *name,
 	__register_blkdev(major, name, NULL)
 void unregister_blkdev(unsigned int major, const char *name);
 
-bool bdev_check_media_change(struct block_device *bdev);
+bool disk_check_media_change(struct gendisk *disk);
 int __invalidate_device(struct block_device *bdev, bool kill_dirty);
 void set_capacity(struct gendisk *disk, sector_t size);
 
-- 
2.39.2

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel


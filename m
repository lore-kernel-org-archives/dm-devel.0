Return-Path: <SRS0=dJ+f=FC=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2F994C63697
	for <dm-devel@archiver.kernel.org>; Sat, 28 Nov 2020 16:23:14 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id AA04C246C3
	for <dm-devel@archiver.kernel.org>; Sat, 28 Nov 2020 16:23:13 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org AA04C246C3
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-163-XbKJ253yMCOTnIm6ONcL4A-1; Sat, 28 Nov 2020 11:23:10 -0500
X-MC-Unique: XbKJ253yMCOTnIm6ONcL4A-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 0DA051842143;
	Sat, 28 Nov 2020 16:23:06 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id E7BDE5D9D3;
	Sat, 28 Nov 2020 16:23:05 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id BEAE250033;
	Sat, 28 Nov 2020 16:23:05 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
	[10.11.54.3])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 0ASGN3TB023641 for <dm-devel@listman.util.phx.redhat.com>;
	Sat, 28 Nov 2020 11:23:03 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id E8A4F110FBEE; Sat, 28 Nov 2020 16:23:02 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id E47E71003207
	for <dm-devel@redhat.com>; Sat, 28 Nov 2020 16:23:02 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D1F0A185A794
	for <dm-devel@redhat.com>; Sat, 28 Nov 2020 16:23:02 +0000 (UTC)
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-434-6DLzCONgPwGhbfHHJKZtLg-1; Sat, 28 Nov 2020 11:23:00 -0500
X-MC-Unique: 6DLzCONgPwGhbfHHJKZtLg-1
Received: from [2001:4bb8:18c:1dd6:48f3:741a:602e:7fdd] (helo=localhost)
	by casper.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
	id 1kj2sX-0000Cp-F8; Sat, 28 Nov 2020 16:15:17 +0000
From: Christoph Hellwig <hch@lst.de>
To: Jens Axboe <axboe@kernel.dk>
Date: Sat, 28 Nov 2020 17:14:29 +0100
Message-Id: <20201128161510.347752-5-hch@lst.de>
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
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.3
X-loop: dm-devel@redhat.com
Cc: linux-bcache@vger.kernel.org, Chao Yu <yuchao0@huawei.com>,
	Jan Kara <jack@suse.cz>, Mike Snitzer <snitzer@redhat.com>,
	linux-mm@kvack.org, Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Jan Kara <jack@suse.com>, Josef Bacik <josef@toxicpanda.com>,
	Coly Li <colyli@suse.de>, linux-block@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, dm-devel@redhat.com,
	linux-mtd@lists.infradead.org,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>, Tejun Heo <tj@kernel.org>
Subject: [dm-devel] [PATCH 04/45] fs: simplify freeze_bdev/thaw_bdev
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Store the frozen superblock in struct block_device to avoid the awkward
interface that can return a sb only used a cookie, an ERR_PTR or NULL.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Jan Kara <jack@suse.cz>
Acked-by: Chao Yu <yuchao0@huawei.com>		[f2fs]
---
 drivers/md/dm-core.h      |  5 -----
 drivers/md/dm.c           | 20 ++++++--------------
 fs/block_dev.c            | 37 +++++++++++++++----------------------
 fs/buffer.c               |  2 +-
 fs/ext4/ioctl.c           |  2 +-
 fs/f2fs/file.c            | 14 +++++---------
 fs/xfs/xfs_fsops.c        |  7 ++-----
 include/linux/blk_types.h |  1 +
 include/linux/blkdev.h    |  4 ++--
 9 files changed, 33 insertions(+), 59 deletions(-)

diff --git a/drivers/md/dm-core.h b/drivers/md/dm-core.h
index d522093cb39dda..aace147effcacb 100644
--- a/drivers/md/dm-core.h
+++ b/drivers/md/dm-core.h
@@ -96,11 +96,6 @@ struct mapped_device {
 	 */
 	struct workqueue_struct *wq;
 
-	/*
-	 * freeze/thaw support require holding onto a super block
-	 */
-	struct super_block *frozen_sb;
-
 	/* forced geometry settings */
 	struct hd_geometry geometry;
 
diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index 54739f1b579bc8..50541d336c719b 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -2392,27 +2392,19 @@ static int lock_fs(struct mapped_device *md)
 {
 	int r;
 
-	WARN_ON(md->frozen_sb);
+	WARN_ON(test_bit(DMF_FROZEN, &md->flags));
 
-	md->frozen_sb = freeze_bdev(md->bdev);
-	if (IS_ERR(md->frozen_sb)) {
-		r = PTR_ERR(md->frozen_sb);
-		md->frozen_sb = NULL;
-		return r;
-	}
-
-	set_bit(DMF_FROZEN, &md->flags);
-
-	return 0;
+	r = freeze_bdev(md->bdev);
+	if (!r)
+		set_bit(DMF_FROZEN, &md->flags);
+	return r;
 }
 
 static void unlock_fs(struct mapped_device *md)
 {
 	if (!test_bit(DMF_FROZEN, &md->flags))
 		return;
-
-	thaw_bdev(md->bdev, md->frozen_sb);
-	md->frozen_sb = NULL;
+	thaw_bdev(md->bdev);
 	clear_bit(DMF_FROZEN, &md->flags);
 }
 
diff --git a/fs/block_dev.c b/fs/block_dev.c
index d8664f5c1ff669..33c29106c98907 100644
--- a/fs/block_dev.c
+++ b/fs/block_dev.c
@@ -548,55 +548,47 @@ EXPORT_SYMBOL(fsync_bdev);
  * count down in thaw_bdev(). When it becomes 0, thaw_bdev() will unfreeze
  * actually.
  */
-struct super_block *freeze_bdev(struct block_device *bdev)
+int freeze_bdev(struct block_device *bdev)
 {
 	struct super_block *sb;
 	int error = 0;
 
 	mutex_lock(&bdev->bd_fsfreeze_mutex);
-	if (++bdev->bd_fsfreeze_count > 1) {
-		/*
-		 * We don't even need to grab a reference - the first call
-		 * to freeze_bdev grab an active reference and only the last
-		 * thaw_bdev drops it.
-		 */
-		sb = get_super(bdev);
-		if (sb)
-			drop_super(sb);
-		mutex_unlock(&bdev->bd_fsfreeze_mutex);
-		return sb;
-	}
+	if (++bdev->bd_fsfreeze_count > 1)
+		goto done;
 
 	sb = get_active_super(bdev);
 	if (!sb)
-		goto out;
+		goto sync;
 	if (sb->s_op->freeze_super)
 		error = sb->s_op->freeze_super(sb);
 	else
 		error = freeze_super(sb);
+	deactivate_super(sb);
+
 	if (error) {
-		deactivate_super(sb);
 		bdev->bd_fsfreeze_count--;
-		mutex_unlock(&bdev->bd_fsfreeze_mutex);
-		return ERR_PTR(error);
+		goto done;
 	}
-	deactivate_super(sb);
- out:
+	bdev->bd_fsfreeze_sb = sb;
+
+sync:
 	sync_blockdev(bdev);
+done:
 	mutex_unlock(&bdev->bd_fsfreeze_mutex);
-	return sb;	/* thaw_bdev releases s->s_umount */
+	return error;
 }
 EXPORT_SYMBOL(freeze_bdev);
 
 /**
  * thaw_bdev  -- unlock filesystem
  * @bdev:	blockdevice to unlock
- * @sb:		associated superblock
  *
  * Unlocks the filesystem and marks it writeable again after freeze_bdev().
  */
-int thaw_bdev(struct block_device *bdev, struct super_block *sb)
+int thaw_bdev(struct block_device *bdev)
 {
+	struct super_block *sb;
 	int error = -EINVAL;
 
 	mutex_lock(&bdev->bd_fsfreeze_mutex);
@@ -607,6 +599,7 @@ int thaw_bdev(struct block_device *bdev, struct super_block *sb)
 	if (--bdev->bd_fsfreeze_count > 0)
 		goto out;
 
+	sb = bdev->bd_fsfreeze_sb;
 	if (!sb)
 		goto out;
 
diff --git a/fs/buffer.c b/fs/buffer.c
index 23f645657488ba..a7595ada9400ff 100644
--- a/fs/buffer.c
+++ b/fs/buffer.c
@@ -523,7 +523,7 @@ static int osync_buffers_list(spinlock_t *lock, struct list_head *list)
 
 void emergency_thaw_bdev(struct super_block *sb)
 {
-	while (sb->s_bdev && !thaw_bdev(sb->s_bdev, sb))
+	while (sb->s_bdev && !thaw_bdev(sb->s_bdev))
 		printk(KERN_WARNING "Emergency Thaw on %pg\n", sb->s_bdev);
 }
 
diff --git a/fs/ext4/ioctl.c b/fs/ext4/ioctl.c
index f0381876a7e5b0..524e134324475e 100644
--- a/fs/ext4/ioctl.c
+++ b/fs/ext4/ioctl.c
@@ -624,7 +624,7 @@ static int ext4_shutdown(struct super_block *sb, unsigned long arg)
 	case EXT4_GOING_FLAGS_DEFAULT:
 		freeze_bdev(sb->s_bdev);
 		set_bit(EXT4_FLAGS_SHUTDOWN, &sbi->s_ext4_flags);
-		thaw_bdev(sb->s_bdev, sb);
+		thaw_bdev(sb->s_bdev);
 		break;
 	case EXT4_GOING_FLAGS_LOGFLUSH:
 		set_bit(EXT4_FLAGS_SHUTDOWN, &sbi->s_ext4_flags);
diff --git a/fs/f2fs/file.c b/fs/f2fs/file.c
index ee861c6d9ff026..a9fc482a0e60a5 100644
--- a/fs/f2fs/file.c
+++ b/fs/f2fs/file.c
@@ -2230,16 +2230,12 @@ static int f2fs_ioc_shutdown(struct file *filp, unsigned long arg)
 
 	switch (in) {
 	case F2FS_GOING_DOWN_FULLSYNC:
-		sb = freeze_bdev(sb->s_bdev);
-		if (IS_ERR(sb)) {
-			ret = PTR_ERR(sb);
+		ret = freeze_bdev(sb->s_bdev);
+		if (ret)
 			goto out;
-		}
-		if (sb) {
-			f2fs_stop_checkpoint(sbi, false);
-			set_sbi_flag(sbi, SBI_IS_SHUTDOWN);
-			thaw_bdev(sb->s_bdev, sb);
-		}
+		f2fs_stop_checkpoint(sbi, false);
+		set_sbi_flag(sbi, SBI_IS_SHUTDOWN);
+		thaw_bdev(sb->s_bdev);
 		break;
 	case F2FS_GOING_DOWN_METASYNC:
 		/* do checkpoint only */
diff --git a/fs/xfs/xfs_fsops.c b/fs/xfs/xfs_fsops.c
index ef1d5bb88b93ab..b7c5783a031c69 100644
--- a/fs/xfs/xfs_fsops.c
+++ b/fs/xfs/xfs_fsops.c
@@ -433,13 +433,10 @@ xfs_fs_goingdown(
 {
 	switch (inflags) {
 	case XFS_FSOP_GOING_FLAGS_DEFAULT: {
-		struct super_block *sb = freeze_bdev(mp->m_super->s_bdev);
-
-		if (sb && !IS_ERR(sb)) {
+		if (!freeze_bdev(mp->m_super->s_bdev)) {
 			xfs_force_shutdown(mp, SHUTDOWN_FORCE_UMOUNT);
-			thaw_bdev(sb->s_bdev, sb);
+			thaw_bdev(mp->m_super->s_bdev);
 		}
-
 		break;
 	}
 	case XFS_FSOP_GOING_FLAGS_LOGFLUSH:
diff --git a/include/linux/blk_types.h b/include/linux/blk_types.h
index d9b69bbde5cc54..ebfb4e7c1fd125 100644
--- a/include/linux/blk_types.h
+++ b/include/linux/blk_types.h
@@ -46,6 +46,7 @@ struct block_device {
 	int			bd_fsfreeze_count;
 	/* Mutex for freeze */
 	struct mutex		bd_fsfreeze_mutex;
+	struct super_block	*bd_fsfreeze_sb;
 } __randomize_layout;
 
 /*
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 05b346a68c2eee..12810a19edebc4 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -2020,7 +2020,7 @@ static inline int sync_blockdev(struct block_device *bdev)
 #endif
 int fsync_bdev(struct block_device *bdev);
 
-struct super_block *freeze_bdev(struct block_device *bdev);
-int thaw_bdev(struct block_device *bdev, struct super_block *sb);
+int freeze_bdev(struct block_device *bdev);
+int thaw_bdev(struct block_device *bdev);
 
 #endif /* _LINUX_BLKDEV_H */
-- 
2.29.2

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel


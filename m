Return-Path: <SRS0=TigA=PD=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 00B67C433EF
	for <dm-devel@archiver.kernel.org>; Fri, 15 Oct 2021 13:58:57 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 93DFB61090
	for <dm-devel@archiver.kernel.org>; Fri, 15 Oct 2021 13:58:56 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 93DFB61090
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-12-11nGg5m7NBe6_7osPEBVDA-1; Fri, 15 Oct 2021 09:58:52 -0400
X-MC-Unique: 11nGg5m7NBe6_7osPEBVDA-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 9D49E801ADB;
	Fri, 15 Oct 2021 13:58:47 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 7F5D410074E1;
	Fri, 15 Oct 2021 13:58:47 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 4F6374EA31;
	Fri, 15 Oct 2021 13:58:47 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com
	[10.11.54.1])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 19FDwfcl025996 for <dm-devel@listman.util.phx.redhat.com>;
	Fri, 15 Oct 2021 09:58:42 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id B9ED740CFD11; Fri, 15 Oct 2021 13:58:41 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id B566740CFD0D
	for <dm-devel@redhat.com>; Fri, 15 Oct 2021 13:58:41 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[205.139.110.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 9E99A1066687
	for <dm-devel@redhat.com>; Fri, 15 Oct 2021 13:58:41 +0000 (UTC)
Received: from bombadil.infradead.org (bombadil.infradead.org
	[198.137.202.133]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-152-0OKkXY59O3SfM8tYqqjGQQ-1; Fri, 15 Oct 2021 09:58:38 -0400
X-MC-Unique: 0OKkXY59O3SfM8tYqqjGQQ-1
Received: from [2001:4bb8:199:73c5:ddfe:9587:819b:83b0] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
	id 1mbNEz-007D1k-7p; Fri, 15 Oct 2021 13:27:17 +0000
From: Christoph Hellwig <hch@lst.de>
To: Jens Axboe <axboe@kernel.dk>
Date: Fri, 15 Oct 2021 15:26:25 +0200
Message-Id: <20211015132643.1621913-13-hch@lst.de>
In-Reply-To: <20211015132643.1621913-1-hch@lst.de>
References: <20211015132643.1621913-1-hch@lst.de>
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
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.1
X-loop: dm-devel@redhat.com
Cc: Dave Kleikamp <shaggy@kernel.org>, jfs-discussion@lists.sourceforge.net,
	Mike Snitzer <snitzer@redhat.com>, linux-nvme@lists.infradead.org,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
	Song Liu <song@kernel.org>, dm-devel@redhat.com,
	target-devel@vger.kernel.org, reiserfs-devel@vger.kernel.org,
	drbd-dev@lists.linbit.com, linux-nilfs@vger.kernel.org,
	linux-scsi@vger.kernel.org, OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
	linux-ext4@vger.kernel.org, Chaitanya Kulkarni <kch@nvidia.com>,
	Kees Cook <keescook@chromium.org>,
	Josef Bacik <josef@toxicpanda.com>, Coly Li <colyli@suse.de>,
	linux-raid@vger.kernel.org, linux-bcache@vger.kernel.org,
	David Sterba <dsterba@suse.com>,
	Ryusuke Konishi <konishi.ryusuke@gmail.com>,
	Anton Altaparmakov <anton@tuxera.com>,
	linux-block@vger.kernel.org, linux-nfs@vger.kernel.org,
	Theodore Ts'o <tytso@mit.edu>, linux-ntfs-dev@lists.sourceforge.net,
	Anand Jain <anand.jain@oracle.com>, Jan Kara <jack@suse.com>,
	linux-fsdevel@vger.kernel.org,
	Phillip Lougher <phillip@squashfs.org.uk>, ntfs3@lists.linux.dev,
	linux-btrfs@vger.kernel.org
Subject: [dm-devel] [PATCH 12/30] btrfs: use bdev_nr_bytes instead of open
	coding it
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
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Use the proper helper to read the block device size.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Anand Jain <anand.jain@oracle.com>
Reviewed-by: Chaitanya Kulkarni <kch@nvidia.com>
---
 fs/btrfs/dev-replace.c | 3 +--
 fs/btrfs/disk-io.c     | 2 +-
 fs/btrfs/ioctl.c       | 4 ++--
 fs/btrfs/volumes.c     | 8 ++++----
 4 files changed, 8 insertions(+), 9 deletions(-)

diff --git a/fs/btrfs/dev-replace.c b/fs/btrfs/dev-replace.c
index d029be40ea6f0..fbb8b4457a721 100644
--- a/fs/btrfs/dev-replace.c
+++ b/fs/btrfs/dev-replace.c
@@ -283,8 +283,7 @@ static int btrfs_init_dev_replace_tgtdev(struct btrfs_fs_info *fs_info,
 	}
 
 
-	if (i_size_read(bdev->bd_inode) <
-	    btrfs_device_get_total_bytes(srcdev)) {
+	if (bdev_nr_bytes(bdev) < btrfs_device_get_total_bytes(srcdev)) {
 		btrfs_err(fs_info,
 			  "target device is smaller than source device!");
 		ret = -EINVAL;
diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 355ea88d5c5f7..29e7598584c4c 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -3740,7 +3740,7 @@ struct btrfs_super_block *btrfs_read_dev_one_super(struct block_device *bdev,
 	else if (ret)
 		return ERR_PTR(ret);
 
-	if (bytenr + BTRFS_SUPER_INFO_SIZE >= i_size_read(bdev->bd_inode))
+	if (bytenr + BTRFS_SUPER_INFO_SIZE >= bdev_nr_bytes(bdev))
 		return ERR_PTR(-EINVAL);
 
 	page = read_cache_page_gfp(mapping, bytenr >> PAGE_SHIFT, GFP_NOFS);
diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index cc61813213d83..36ff713da1b12 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -1730,7 +1730,7 @@ static noinline int btrfs_ioctl_resize(struct file *file,
 	}
 
 	if (!strcmp(sizestr, "max"))
-		new_size = device->bdev->bd_inode->i_size;
+		new_size = bdev_nr_bytes(device->bdev);
 	else {
 		if (sizestr[0] == '-') {
 			mod = -1;
@@ -1771,7 +1771,7 @@ static noinline int btrfs_ioctl_resize(struct file *file,
 		ret = -EINVAL;
 		goto out_finish;
 	}
-	if (new_size > device->bdev->bd_inode->i_size) {
+	if (new_size > bdev_nr_bytes(device->bdev)) {
 		ret = -EFBIG;
 		goto out_finish;
 	}
diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 2ec3b8ac8fa35..676c7c4e6e59d 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -1286,7 +1286,7 @@ static struct btrfs_super_block *btrfs_read_disk_super(struct block_device *bdev
 	pgoff_t index;
 
 	/* make sure our super fits in the device */
-	if (bytenr + PAGE_SIZE >= i_size_read(bdev->bd_inode))
+	if (bytenr + PAGE_SIZE >= bdev_nr_bytes(bdev))
 		return ERR_PTR(-EINVAL);
 
 	/* make sure our super fits in the page */
@@ -2610,8 +2610,8 @@ int btrfs_init_new_device(struct btrfs_fs_info *fs_info, const char *device_path
 	device->io_width = fs_info->sectorsize;
 	device->io_align = fs_info->sectorsize;
 	device->sector_size = fs_info->sectorsize;
-	device->total_bytes = round_down(i_size_read(bdev->bd_inode),
-					 fs_info->sectorsize);
+	device->total_bytes =
+		round_down(bdev_nr_bytes(bdev), fs_info->sectorsize);
 	device->disk_total_bytes = device->total_bytes;
 	device->commit_total_bytes = device->total_bytes;
 	set_bit(BTRFS_DEV_STATE_IN_FS_METADATA, &device->dev_state);
@@ -7236,7 +7236,7 @@ static int read_one_dev(struct extent_buffer *leaf,
 
 	fill_device_from_item(leaf, dev_item, device);
 	if (device->bdev) {
-		u64 max_total_bytes = i_size_read(device->bdev->bd_inode);
+		u64 max_total_bytes = bdev_nr_bytes(device->bdev);
 
 		if (device->total_bytes > max_total_bytes) {
 			btrfs_err(fs_info,
-- 
2.30.2

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel


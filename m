Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 355D9C7EE23
	for <dm-devel@archiver.kernel.org>; Thu,  8 Jun 2023 11:54:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1686225250;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=aSPOnUOWSCb8DsmQ+5n4m4WF5+scPiXvfxmDBdrC/28=;
	b=iZcOZGyBSwMjKZf0kWFGXB2BA2LQHu79gpx8fFijpsusgq7C8C1qivuHuO62jDeOjIpJwr
	RH72id+d/yQG17juMQzatGoiGPeDAeG8rslI09hU6Ap6aXI7Jr3K41VNCKKL3X0B6gxjJI
	BXboLr0ID4ZDul1qtYojY1L4ELGAWrI=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-659-NT5x-a-2PR-vd5e31_WYuA-1; Thu, 08 Jun 2023 07:54:07 -0400
X-MC-Unique: NT5x-a-2PR-vd5e31_WYuA-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 974BC85A5BA;
	Thu,  8 Jun 2023 11:54:05 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 8767E492B0A;
	Thu,  8 Jun 2023 11:54:05 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 790F419451C0;
	Thu,  8 Jun 2023 11:54:05 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
 [10.11.54.4])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 9BEE219452D3
 for <dm-devel@listman.corp.redhat.com>; Thu,  8 Jun 2023 11:54:04 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 8E2AA2026D49; Thu,  8 Jun 2023 11:54:04 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 86E032026D6A
 for <dm-devel@redhat.com>; Thu,  8 Jun 2023 11:54:04 +0000 (UTC)
Received: from us-smtp-inbound-1.mimecast.com (us-smtp-1.mimecast.com
 [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 6813A8028B2
 for <dm-devel@redhat.com>; Thu,  8 Jun 2023 11:54:04 +0000 (UTC)
Received: from bombadil.infradead.org (bombadil.infradead.org
 [198.137.202.133]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-395-LlcsSup2P--gup9BdYKNog-1; Thu, 08 Jun 2023 07:54:02 -0400
X-MC-Unique: LlcsSup2P--gup9BdYKNog-1
Received: from
 2a02-8389-2341-5b80-39d3-4735-9a3c-88d8.cable.dynamic.v6.surfer.at
 ([2a02:8389:2341:5b80:39d3:4735:9a3c:88d8] helo=localhost)
 by bombadil.infradead.org with esmtpsa (Exim 4.96 #2 (Red Hat Linux))
 id 1q7DQY-0092CW-2p; Thu, 08 Jun 2023 11:03:39 +0000
From: Christoph Hellwig <hch@lst.de>
To: Jens Axboe <axboe@kernel.dk>
Date: Thu,  8 Jun 2023 13:02:42 +0200
Message-Id: <20230608110258.189493-15-hch@lst.de>
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
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.4
Subject: [dm-devel] [PATCH 14/30] btrfs: don't pass a holder for
 non-exclusive blkdev_get_by_path
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
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.10
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: lst.de
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Passing a holder to blkdev_get_by_path when FMODE_EXCL isn't set doesn't
make sense, so pass NULL instead and remove the holder argument from the
call chains the only end up in non-FMODE_EXCL blkdev_get_by_path calls.

Exclusive mode for device scanning is not used since commit 50d281fc434c
("btrfs: scan device in non-exclusive mode")".

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Hannes Reinecke <hare@suse.de>
Acked-by: Christian Brauner <brauner@kernel.org>
Acked-by: David Sterba <dsterba@suse.com>
---
 fs/btrfs/super.c   | 16 ++++++----------
 fs/btrfs/volumes.c | 17 ++++++++---------
 fs/btrfs/volumes.h |  3 +--
 3 files changed, 15 insertions(+), 21 deletions(-)

diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index ec18e22106023b..1a2ee9407f5414 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -849,8 +849,7 @@ int btrfs_parse_options(struct btrfs_fs_info *info, char *options,
  * All other options will be parsed on much later in the mount process and
  * only when we need to allocate a new super block.
  */
-static int btrfs_parse_device_options(const char *options, fmode_t flags,
-				      void *holder)
+static int btrfs_parse_device_options(const char *options, fmode_t flags)
 {
 	substring_t args[MAX_OPT_ARGS];
 	char *device_name, *opts, *orig, *p;
@@ -884,8 +883,7 @@ static int btrfs_parse_device_options(const char *options, fmode_t flags,
 				error = -ENOMEM;
 				goto out;
 			}
-			device = btrfs_scan_one_device(device_name, flags,
-					holder);
+			device = btrfs_scan_one_device(device_name, flags);
 			kfree(device_name);
 			if (IS_ERR(device)) {
 				error = PTR_ERR(device);
@@ -1477,13 +1475,13 @@ static struct dentry *btrfs_mount_root(struct file_system_type *fs_type,
 	}
 
 	mutex_lock(&uuid_mutex);
-	error = btrfs_parse_device_options(data, mode, fs_type);
+	error = btrfs_parse_device_options(data, mode);
 	if (error) {
 		mutex_unlock(&uuid_mutex);
 		goto error_fs_info;
 	}
 
-	device = btrfs_scan_one_device(device_name, mode, fs_type);
+	device = btrfs_scan_one_device(device_name, mode);
 	if (IS_ERR(device)) {
 		mutex_unlock(&uuid_mutex);
 		error = PTR_ERR(device);
@@ -2190,8 +2188,7 @@ static long btrfs_control_ioctl(struct file *file, unsigned int cmd,
 	switch (cmd) {
 	case BTRFS_IOC_SCAN_DEV:
 		mutex_lock(&uuid_mutex);
-		device = btrfs_scan_one_device(vol->name, FMODE_READ,
-					       &btrfs_root_fs_type);
+		device = btrfs_scan_one_device(vol->name, FMODE_READ);
 		ret = PTR_ERR_OR_ZERO(device);
 		mutex_unlock(&uuid_mutex);
 		break;
@@ -2205,8 +2202,7 @@ static long btrfs_control_ioctl(struct file *file, unsigned int cmd,
 		break;
 	case BTRFS_IOC_DEVICES_READY:
 		mutex_lock(&uuid_mutex);
-		device = btrfs_scan_one_device(vol->name, FMODE_READ,
-					       &btrfs_root_fs_type);
+		device = btrfs_scan_one_device(vol->name, FMODE_READ);
 		if (IS_ERR(device)) {
 			mutex_unlock(&uuid_mutex);
 			ret = PTR_ERR(device);
diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 784ccc8f6c69c1..035868cee3ddc3 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -1348,8 +1348,7 @@ int btrfs_forget_devices(dev_t devt)
  * and we are not allowed to call set_blocksize during the scan. The superblock
  * is read via pagecache
  */
-struct btrfs_device *btrfs_scan_one_device(const char *path, fmode_t flags,
-					   void *holder)
+struct btrfs_device *btrfs_scan_one_device(const char *path, fmode_t flags)
 {
 	struct btrfs_super_block *disk_super;
 	bool new_device_added = false;
@@ -1368,16 +1367,16 @@ struct btrfs_device *btrfs_scan_one_device(const char *path, fmode_t flags,
 	 */
 
 	/*
-	 * Avoid using flag |= FMODE_EXCL here, as the systemd-udev may
-	 * initiate the device scan which may race with the user's mount
-	 * or mkfs command, resulting in failure.
-	 * Since the device scan is solely for reading purposes, there is
-	 * no need for FMODE_EXCL. Additionally, the devices are read again
+	 * Avoid an exclusive open here, as the systemd-udev may initiate the
+	 * device scan which may race with the user's mount or mkfs command,
+	 * resulting in failure.
+	 * Since the device scan is solely for reading purposes, there is no
+	 * need for an exclusive open. Additionally, the devices are read again
 	 * during the mount process. It is ok to get some inconsistent
 	 * values temporarily, as the device paths of the fsid are the only
 	 * required information for assembling the volume.
 	 */
-	bdev = blkdev_get_by_path(path, flags, holder, NULL);
+	bdev = blkdev_get_by_path(path, flags, NULL, NULL);
 	if (IS_ERR(bdev))
 		return ERR_CAST(bdev);
 
@@ -2381,7 +2380,7 @@ int btrfs_get_dev_args_from_path(struct btrfs_fs_info *fs_info,
 		return -ENOMEM;
 	}
 
-	ret = btrfs_get_bdev_and_sb(path, FMODE_READ, fs_info->bdev_holder, 0,
+	ret = btrfs_get_bdev_and_sb(path, FMODE_READ, NULL, 0,
 				    &bdev, &disk_super);
 	if (ret) {
 		btrfs_put_dev_args_from_path(args);
diff --git a/fs/btrfs/volumes.h b/fs/btrfs/volumes.h
index bf47a1a70813ba..eb97a397b3c3fb 100644
--- a/fs/btrfs/volumes.h
+++ b/fs/btrfs/volumes.h
@@ -600,8 +600,7 @@ struct btrfs_block_group *btrfs_create_chunk(struct btrfs_trans_handle *trans,
 void btrfs_mapping_tree_free(struct extent_map_tree *tree);
 int btrfs_open_devices(struct btrfs_fs_devices *fs_devices,
 		       fmode_t flags, void *holder);
-struct btrfs_device *btrfs_scan_one_device(const char *path,
-					   fmode_t flags, void *holder);
+struct btrfs_device *btrfs_scan_one_device(const char *path, fmode_t flags);
 int btrfs_forget_devices(dev_t devt);
 void btrfs_close_devices(struct btrfs_fs_devices *fs_devices);
 void btrfs_free_extra_devids(struct btrfs_fs_devices *fs_devices);
-- 
2.39.2

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel


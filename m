Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0502AC7EE23
	for <dm-devel@archiver.kernel.org>; Thu,  8 Jun 2023 11:58:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1686225486;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=uZr4Te1A2n54uKnWq3N3l54WyL0h/iZHXAcb4U9n2CQ=;
	b=LR6WRu9DTxUm5PtGxmg4ZwTG6wlO8tBrnjSrS2rrwjpdS6bQ3AMECpa9eU80UbUWIQP3c5
	TtpTucmsPzmvy5BdWMHVCAl1rjGsQwXJRDoDopFeY0LIaYmx8ZEGifF+G6lFjfSYuvD5ef
	oreCik4reaz/zcnkd/vrwLmMkB0Pl/g=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-628-LOoJUMGFN1yvtKctKPB-6Q-1; Thu, 08 Jun 2023 07:58:03 -0400
X-MC-Unique: LOoJUMGFN1yvtKctKPB-6Q-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D5B0C38294A4;
	Thu,  8 Jun 2023 11:58:01 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id C4B27492B0A;
	Thu,  8 Jun 2023 11:58:01 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 5808819452D3;
	Thu,  8 Jun 2023 11:58:01 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
 [10.11.54.5])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 64299194658C
 for <dm-devel@listman.corp.redhat.com>; Thu,  8 Jun 2023 11:58:00 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 57A509E8B; Thu,  8 Jun 2023 11:58:00 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 4FE969E9C
 for <dm-devel@redhat.com>; Thu,  8 Jun 2023 11:58:00 +0000 (UTC)
Received: from us-smtp-inbound-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 2E9CC185A795
 for <dm-devel@redhat.com>; Thu,  8 Jun 2023 11:58:00 +0000 (UTC)
Received: from bombadil.infradead.org (bombadil.infradead.org
 [198.137.202.133]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-543-w460V8NvOdqWIzCsNDUYzQ-1; Thu, 08 Jun 2023 07:57:58 -0400
X-MC-Unique: w460V8NvOdqWIzCsNDUYzQ-1
Received: from
 2a02-8389-2341-5b80-39d3-4735-9a3c-88d8.cable.dynamic.v6.surfer.at
 ([2a02:8389:2341:5b80:39d3:4735:9a3c:88d8] helo=localhost)
 by bombadil.infradead.org with esmtpsa (Exim 4.96 #2 (Red Hat Linux))
 id 1q7DQh-0092Ka-0N; Thu, 08 Jun 2023 11:03:47 +0000
From: Christoph Hellwig <hch@lst.de>
To: Jens Axboe <axboe@kernel.dk>
Date: Thu,  8 Jun 2023 13:02:45 +0200
Message-Id: <20230608110258.189493-18-hch@lst.de>
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
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
Subject: [dm-devel] [PATCH 17/30] fs: remove sb->s_mode
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

There is no real need to store the open mode in the super_block now.
It is only used by f2fs, which can easily recalculate it.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Hannes Reinecke <hare@suse.de>
Acked-by: Christian Brauner <brauner@kernel.org>
---
 fs/f2fs/super.c    | 10 ++++++----
 fs/nilfs2/super.c  |  1 -
 fs/super.c         |  2 --
 include/linux/fs.h |  1 -
 4 files changed, 6 insertions(+), 8 deletions(-)

diff --git a/fs/f2fs/super.c b/fs/f2fs/super.c
index a5adb1d316e331..5a764fecd1c7ef 100644
--- a/fs/f2fs/super.c
+++ b/fs/f2fs/super.c
@@ -3993,6 +3993,7 @@ static int f2fs_scan_devices(struct f2fs_sb_info *sbi)
 	struct f2fs_super_block *raw_super = F2FS_RAW_SUPER(sbi);
 	unsigned int max_devices = MAX_DEVICES;
 	unsigned int logical_blksize;
+	fmode_t mode = sb_open_mode(sbi->sb->s_flags);
 	int i;
 
 	/* Initialize single device information */
@@ -4024,8 +4025,8 @@ static int f2fs_scan_devices(struct f2fs_sb_info *sbi)
 		if (max_devices == 1) {
 			/* Single zoned block device mount */
 			FDEV(0).bdev =
-				blkdev_get_by_dev(sbi->sb->s_bdev->bd_dev,
-					sbi->sb->s_mode, sbi->sb->s_type, NULL);
+				blkdev_get_by_dev(sbi->sb->s_bdev->bd_dev, mode,
+						  sbi->sb->s_type, NULL);
 		} else {
 			/* Multi-device mount */
 			memcpy(FDEV(i).path, RDEV(i).path, MAX_PATH_LEN);
@@ -4043,8 +4044,9 @@ static int f2fs_scan_devices(struct f2fs_sb_info *sbi)
 					(FDEV(i).total_segments <<
 					sbi->log_blocks_per_seg) - 1;
 			}
-			FDEV(i).bdev = blkdev_get_by_path(FDEV(i).path,
-					sbi->sb->s_mode, sbi->sb->s_type, NULL);
+			FDEV(i).bdev = blkdev_get_by_path(FDEV(i).path, mode,
+							  sbi->sb->s_type,
+							  NULL);
 		}
 		if (IS_ERR(FDEV(i).bdev))
 			return PTR_ERR(FDEV(i).bdev);
diff --git a/fs/nilfs2/super.c b/fs/nilfs2/super.c
index a41fd84d4e28ab..15a5a1099427d8 100644
--- a/fs/nilfs2/super.c
+++ b/fs/nilfs2/super.c
@@ -1316,7 +1316,6 @@ nilfs_mount(struct file_system_type *fs_type, int flags,
 		s_new = true;
 
 		/* New superblock instance created */
-		s->s_mode = mode;
 		snprintf(s->s_id, sizeof(s->s_id), "%pg", sd.bdev);
 		sb_set_blocksize(s, block_size(sd.bdev));
 
diff --git a/fs/super.c b/fs/super.c
index dc7f328398339d..86f40f8981989d 100644
--- a/fs/super.c
+++ b/fs/super.c
@@ -1308,7 +1308,6 @@ int get_tree_bdev(struct fs_context *fc,
 		blkdev_put(bdev, fc->fs_type);
 		down_write(&s->s_umount);
 	} else {
-		s->s_mode = mode;
 		snprintf(s->s_id, sizeof(s->s_id), "%pg", bdev);
 		shrinker_debugfs_rename(&s->s_shrink, "sb-%s:%s",
 					fc->fs_type->name, s->s_id);
@@ -1382,7 +1381,6 @@ struct dentry *mount_bdev(struct file_system_type *fs_type,
 		blkdev_put(bdev, fs_type);
 		down_write(&s->s_umount);
 	} else {
-		s->s_mode = mode;
 		snprintf(s->s_id, sizeof(s->s_id), "%pg", bdev);
 		shrinker_debugfs_rename(&s->s_shrink, "sb-%s:%s",
 					fs_type->name, s->s_id);
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 7b2053649820cc..ad1d2c9afb3fa4 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -1215,7 +1215,6 @@ struct super_block {
 	uuid_t			s_uuid;		/* UUID */
 
 	unsigned int		s_max_links;
-	fmode_t			s_mode;
 
 	/*
 	 * The next field is for VFS *only*. No filesystems have any business
-- 
2.39.2

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel


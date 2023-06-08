Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5C053C8300C
	for <dm-devel@archiver.kernel.org>; Thu,  8 Jun 2023 11:04:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1686222293;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=FQ6kKiSI/5nNTpSfCFgsZk6TQMqvjEm9vGduMd5MDg8=;
	b=GVPcone9x52zr3+wmgHdD9FAg8KDWsKPOq9MPf/4yDhzTHi4sK/IwmCJYmTf9r65j59m7N
	+KRklEhUHFRONtW0BhOzdRSkzwFn/j8icVSSb37dEfPCvF0aD82Ne6Q1ThDiC+J2jfdjLf
	v63/u6aeRcr+VRvzsC4+kcVMDkDtO9M=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-269-5QSm8X-eP5aLiuIkkTDJ5A-1; Thu, 08 Jun 2023 07:04:52 -0400
X-MC-Unique: 5QSm8X-eP5aLiuIkkTDJ5A-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 7EAD3811E78;
	Thu,  8 Jun 2023 11:04:50 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 6EB101121314;
	Thu,  8 Jun 2023 11:04:50 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 5362F19451C8;
	Thu,  8 Jun 2023 11:04:50 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
 [10.11.54.6])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id CA84D194658C
 for <dm-devel@listman.corp.redhat.com>; Thu,  8 Jun 2023 11:04:44 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id AA2642166B27; Thu,  8 Jun 2023 11:04:44 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id A167B2166B25
 for <dm-devel@redhat.com>; Thu,  8 Jun 2023 11:04:44 +0000 (UTC)
Received: from us-smtp-inbound-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 65431803DBF
 for <dm-devel@redhat.com>; Thu,  8 Jun 2023 11:04:44 +0000 (UTC)
Received: from bombadil.infradead.org (bombadil.infradead.org
 [198.137.202.133]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-392-slsXMUk-MBmUZOl94wUNBw-1; Thu, 08 Jun 2023 07:04:42 -0400
X-MC-Unique: slsXMUk-MBmUZOl94wUNBw-1
Received: from
 2a02-8389-2341-5b80-39d3-4735-9a3c-88d8.cable.dynamic.v6.surfer.at
 ([2a02:8389:2341:5b80:39d3:4735:9a3c:88d8] helo=localhost)
 by bombadil.infradead.org with esmtpsa (Exim 4.96 #2 (Red Hat Linux))
 id 1q7DRA-0092pp-0o; Thu, 08 Jun 2023 11:04:16 +0000
From: Christoph Hellwig <hch@lst.de>
To: Jens Axboe <axboe@kernel.dk>
Date: Thu,  8 Jun 2023 13:02:54 +0200
Message-Id: <20230608110258.189493-27-hch@lst.de>
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
Subject: [dm-devel] [PATCH 26/30] block: remove unused fmode_t arguments
 from ioctl handlers
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

A few ioctl handlers have fmode_t arguments that are entirely unused,
remove them.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Acked-by: Christian Brauner <brauner@kernel.org>
Reviewed-by: Hannes Reinecke <hare@suse.de>
---
 block/blk-zoned.c |  4 ++--
 block/blk.h       |  6 +++---
 block/ioctl.c     | 14 +++++++-------
 3 files changed, 12 insertions(+), 12 deletions(-)

diff --git a/block/blk-zoned.c b/block/blk-zoned.c
index 096b6b47561f83..02cc2c629ac9be 100644
--- a/block/blk-zoned.c
+++ b/block/blk-zoned.c
@@ -323,8 +323,8 @@ static int blkdev_copy_zone_to_user(struct blk_zone *zone, unsigned int idx,
  * BLKREPORTZONE ioctl processing.
  * Called from blkdev_ioctl.
  */
-int blkdev_report_zones_ioctl(struct block_device *bdev, fmode_t mode,
-			      unsigned int cmd, unsigned long arg)
+int blkdev_report_zones_ioctl(struct block_device *bdev, unsigned int cmd,
+		unsigned long arg)
 {
 	void __user *argp = (void __user *)arg;
 	struct zone_report_args args;
diff --git a/block/blk.h b/block/blk.h
index 6910220aa030f1..e28d5d67d31a28 100644
--- a/block/blk.h
+++ b/block/blk.h
@@ -394,15 +394,15 @@ static inline struct bio *blk_queue_bounce(struct bio *bio,
 #ifdef CONFIG_BLK_DEV_ZONED
 void disk_free_zone_bitmaps(struct gendisk *disk);
 void disk_clear_zone_settings(struct gendisk *disk);
-int blkdev_report_zones_ioctl(struct block_device *bdev, fmode_t mode,
-		unsigned int cmd, unsigned long arg);
+int blkdev_report_zones_ioctl(struct block_device *bdev, unsigned int cmd,
+		unsigned long arg);
 int blkdev_zone_mgmt_ioctl(struct block_device *bdev, fmode_t mode,
 		unsigned int cmd, unsigned long arg);
 #else /* CONFIG_BLK_DEV_ZONED */
 static inline void disk_free_zone_bitmaps(struct gendisk *disk) {}
 static inline void disk_clear_zone_settings(struct gendisk *disk) {}
 static inline int blkdev_report_zones_ioctl(struct block_device *bdev,
-		fmode_t mode, unsigned int cmd, unsigned long arg)
+		unsigned int cmd, unsigned long arg)
 {
 	return -ENOTTY;
 }
diff --git a/block/ioctl.c b/block/ioctl.c
index b39bd5b41ee492..3a10c34b8ef6d3 100644
--- a/block/ioctl.c
+++ b/block/ioctl.c
@@ -344,8 +344,8 @@ static int blkdev_pr_clear(struct block_device *bdev,
 	return ops->pr_clear(bdev, c.key);
 }
 
-static int blkdev_flushbuf(struct block_device *bdev, fmode_t mode,
-		unsigned cmd, unsigned long arg)
+static int blkdev_flushbuf(struct block_device *bdev, unsigned cmd,
+		unsigned long arg)
 {
 	if (!capable(CAP_SYS_ADMIN))
 		return -EACCES;
@@ -354,8 +354,8 @@ static int blkdev_flushbuf(struct block_device *bdev, fmode_t mode,
 	return 0;
 }
 
-static int blkdev_roset(struct block_device *bdev, fmode_t mode,
-		unsigned cmd, unsigned long arg)
+static int blkdev_roset(struct block_device *bdev, unsigned cmd,
+		unsigned long arg)
 {
 	int ret, n;
 
@@ -475,9 +475,9 @@ static int blkdev_common_ioctl(struct block_device *bdev, fmode_t mode,
 
 	switch (cmd) {
 	case BLKFLSBUF:
-		return blkdev_flushbuf(bdev, mode, cmd, arg);
+		return blkdev_flushbuf(bdev, cmd, arg);
 	case BLKROSET:
-		return blkdev_roset(bdev, mode, cmd, arg);
+		return blkdev_roset(bdev, cmd, arg);
 	case BLKDISCARD:
 		return blk_ioctl_discard(bdev, mode, arg);
 	case BLKSECDISCARD:
@@ -487,7 +487,7 @@ static int blkdev_common_ioctl(struct block_device *bdev, fmode_t mode,
 	case BLKGETDISKSEQ:
 		return put_u64(argp, bdev->bd_disk->diskseq);
 	case BLKREPORTZONE:
-		return blkdev_report_zones_ioctl(bdev, mode, cmd, arg);
+		return blkdev_report_zones_ioctl(bdev, cmd, arg);
 	case BLKRESETZONE:
 	case BLKOPENZONE:
 	case BLKCLOSEZONE:
-- 
2.39.2

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel


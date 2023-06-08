Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E7B13C7EE29
	for <dm-devel@archiver.kernel.org>; Thu,  8 Jun 2023 11:52:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1686225153;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=1D1yBDrHkmza1YAq8uu7YRPxpUi59KNjEIZc7VofZlo=;
	b=gsQLWG2TDRJJX60RnbXpO47xvbyzxWuMqwFSNwxXvup8REsu8JmlS/2vaopilzl3Nsrs/l
	juLq/gfggzOjhxklInBevm7tajSF/q9leE/oN456xxYhxrLECt/7NxBXWRYO3ZHJr0QAWf
	FKYVtisT6eUICTeI1D5pJnvv1oKRdfY=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-599-oYmU0k08P-GOq0UI8P7v1A-1; Thu, 08 Jun 2023 07:52:29 -0400
X-MC-Unique: oYmU0k08P-GOq0UI8P7v1A-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 2D48C382888E;
	Thu,  8 Jun 2023 11:52:28 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 1AD7A4021AA;
	Thu,  8 Jun 2023 11:52:28 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id E432919452D3;
	Thu,  8 Jun 2023 11:52:27 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com
 [10.11.54.2])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 20D96194658C
 for <dm-devel@listman.corp.redhat.com>; Thu,  8 Jun 2023 11:52:25 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 0338140D1B69; Thu,  8 Jun 2023 11:52:25 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast10.extmail.prod.ext.rdu2.redhat.com [10.11.55.26])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id F040340D1B68
 for <dm-devel@redhat.com>; Thu,  8 Jun 2023 11:52:24 +0000 (UTC)
Received: from us-smtp-inbound-1.mimecast.com (us-smtp-2.mimecast.com
 [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D1C651C05EA7
 for <dm-devel@redhat.com>; Thu,  8 Jun 2023 11:52:24 +0000 (UTC)
Received: from bombadil.infradead.org (bombadil.infradead.org
 [198.137.202.133]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-221-YBlvjO73MaOVHYWmztwDOQ-1; Thu, 08 Jun 2023 07:52:23 -0400
X-MC-Unique: YBlvjO73MaOVHYWmztwDOQ-1
Received: from
 2a02-8389-2341-5b80-39d3-4735-9a3c-88d8.cable.dynamic.v6.surfer.at
 ([2a02:8389:2341:5b80:39d3:4735:9a3c:88d8] helo=localhost)
 by bombadil.infradead.org with esmtpsa (Exim 4.96 #2 (Red Hat Linux))
 id 1q7DPz-0091cl-2t; Thu, 08 Jun 2023 11:03:04 +0000
From: Christoph Hellwig <hch@lst.de>
To: Jens Axboe <axboe@kernel.dk>
Date: Thu,  8 Jun 2023 13:02:29 +0200
Message-Id: <20230608110258.189493-2-hch@lst.de>
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
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
Subject: [dm-devel] [PATCH 01/30] block: also call ->open for incremental
 partition opens
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
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.9
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: lst.de
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

For whole devices ->open is called for each open, but for partitions it
is only called on the first open of a partition, e.g.:

  open("/dev/vdb", ...)
  open("/dev/vdb", ...)
    - 2 call to ->open

  open("/dev/vdb1", ...)
  open("/dev/vdb", ...)
    - 2 call to ->open

  open("/dev/vdb", ...)
  open("/dev/vdb", ...)
    - just open call to ->open

This is problematic as various block drivers look at open flags and
might not do all the required setup if the earlier open was with an
odd flag like O_NDELAY or the magic 3 ioctl-only open mode.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Phillip Potter <phil@philpotter.co.uk>
Reviewed-by: Hannes Reinecke <hare@suse.de>
Acked-by: Christian Brauner <brauner@kernel.org>
---
 block/bdev.c | 18 ++++++++----------
 1 file changed, 8 insertions(+), 10 deletions(-)

diff --git a/block/bdev.c b/block/bdev.c
index 5c46ff10770638..981f6135795138 100644
--- a/block/bdev.c
+++ b/block/bdev.c
@@ -683,9 +683,6 @@ static int blkdev_get_part(struct block_device *part, fmode_t mode)
 	struct gendisk *disk = part->bd_disk;
 	int ret;
 
-	if (atomic_read(&part->bd_openers))
-		goto done;
-
 	ret = blkdev_get_whole(bdev_whole(part), mode);
 	if (ret)
 		return ret;
@@ -694,9 +691,10 @@ static int blkdev_get_part(struct block_device *part, fmode_t mode)
 	if (!bdev_nr_sectors(part))
 		goto out_blkdev_put;
 
-	disk->open_partitions++;
-	set_init_blocksize(part);
-done:
+	if (!atomic_read(&part->bd_openers)) {
+		disk->open_partitions++;
+		set_init_blocksize(part);
+	}
 	atomic_inc(&part->bd_openers);
 	return 0;
 
@@ -709,10 +707,10 @@ static void blkdev_put_part(struct block_device *part, fmode_t mode)
 {
 	struct block_device *whole = bdev_whole(part);
 
-	if (!atomic_dec_and_test(&part->bd_openers))
-		return;
-	blkdev_flush_mapping(part);
-	whole->bd_disk->open_partitions--;
+	if (atomic_dec_and_test(&part->bd_openers)) {
+		blkdev_flush_mapping(part);
+		whole->bd_disk->open_partitions--;
+	}
 	blkdev_put_whole(whole, mode);
 }
 
-- 
2.39.2

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel


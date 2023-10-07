Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ACE33E9413D
	for <dm-devel@archiver.kernel.org>; Sat,  7 Oct 2023 01:29:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1696642139;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=x0yu8TQdNa4fhYJxL/qfqCgLBb4zJ6lVau5K3ZaVtF0=;
	b=gMkLgiDm3kZ4kFnnOE3b3d+MI97kubbprU5mJXB5ToAL6R2lW1Hy8JFHsW3TlE+Sj5kbBU
	HF0e2w9eSl+fLuCLVbSpkgLvZNIktOX18mYKCDJRhj5lpE7kgU8GZvnWFaXHQXLlbn6jzN
	LPQy/95k/bJ0fzk3IAwp6FZ4xF/ao3w=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-125-TVC3JHYJMKOQTbqhhqL1aw-1; Fri, 06 Oct 2023 21:28:56 -0400
X-MC-Unique: TVC3JHYJMKOQTbqhhqL1aw-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 165D1101A53B;
	Sat,  7 Oct 2023 01:28:55 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 059671005E27;
	Sat,  7 Oct 2023 01:28:55 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id E9FE31946589;
	Sat,  7 Oct 2023 01:28:54 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
 [10.11.54.6])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 032BD1946589
 for <dm-devel@listman.corp.redhat.com>; Sat,  7 Oct 2023 01:28:53 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id EA9F72156711; Sat,  7 Oct 2023 01:28:52 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id E3B5A215670B
 for <dm-devel@redhat.com>; Sat,  7 Oct 2023 01:28:52 +0000 (UTC)
Received: from us-smtp-inbound-delivery-1.mimecast.com (us-smtp-1.mimecast.com
 [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id C5ACF101AA6E
 for <dm-devel@redhat.com>; Sat,  7 Oct 2023 01:28:52 +0000 (UTC)
Received: from mail-ot1-f54.google.com (mail-ot1-f54.google.com
 [209.85.210.54]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-597-4fiLMvRCM4KDiuJ50NTVyg-1; Fri, 06 Oct 2023 21:28:38 -0400
X-MC-Unique: 4fiLMvRCM4KDiuJ50NTVyg-1
Received: by mail-ot1-f54.google.com with SMTP id
 46e09a7af769-6bf58009a8dso1799904a34.1
 for <dm-devel@redhat.com>; Fri, 06 Oct 2023 18:28:37 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20230601; t=1696642115; x=1697246915;
 h=content-transfer-encoding:mime-version:references:in-reply-to
 :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
 :subject:date:message-id:reply-to;
 bh=rVF8rK/kC1UjwzLMGR23sx6dhVRDno9128uSIr9eCP0=;
 b=iGvTBfCxKHLpX8hgfqO4bJNeniAN3NSdGQ0+BS4cDVvoY0iKWt0EdwUPtLNZu+9J/c
 o3bBJrzSyd7M46LHK+18Xukud/JstHQe+1l9aN08efMHgTBjTagGhVebQKM6+/iMDJwc
 bTy0CglA1TjEJ88eZSF2O/YZ1lo8ZkZISWPdBaspdTlGscbOdfJgAvZ3AHKbnYTyKDVI
 iWmR4gzkUgDNFgiUoOftp5+HI0YDQp2+mvK7HkBGNmASNoEH8JYKzHAWLhSqrpUWkHhY
 7Dkl7XMZJ7SR6gGT6wPaNBJarmNuUd7EIig5tEc7oRoM2teRo8CDPiDwn68PRJWy31lC
 QeLg==
X-Gm-Message-State: AOJu0YzLu9E5rXPNUWqdaqpl6pcHphnDz9+PmVVYwvfsE/y0OCUhz1/h
 67TDYXMrSzJiSYXDKKhDIhj+cNsC1ZdgNfZ8Aqo=
X-Google-Smtp-Source: AGHT+IH2NlEgTF700gNIZ6cKPt2q6/f6H70TDkXk3G6q0Gl7oflk7/S43yTcoNGZnNyMpgrw6cyE+g==
X-Received: by 2002:a05:6830:1bf2:b0:6bb:1036:46de with SMTP id
 k18-20020a0568301bf200b006bb103646demr10472104otb.30.1696642115522; 
 Fri, 06 Oct 2023 18:28:35 -0700 (PDT)
Received: from localhost ([2620:15c:9d:2:138c:8976:eb4a:a91c])
 by smtp.gmail.com with UTF8SMTPSA id
 w25-20020a639359000000b00553dcfc2179sm4002014pgm.52.2023.10.06.18.28.34
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Fri, 06 Oct 2023 18:28:35 -0700 (PDT)
From: Sarthak Kukreti <sarthakkukreti@chromium.org>
To: dm-devel@redhat.com, linux-block@vger.kernel.org,
 linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-fsdevel@vger.kernel.org
Date: Fri,  6 Oct 2023 18:28:17 -0700
Message-ID: <20231007012817.3052558-6-sarthakkukreti@chromium.org>
In-Reply-To: <20231007012817.3052558-1-sarthakkukreti@chromium.org>
References: <20231007012817.3052558-1-sarthakkukreti@chromium.org>
MIME-Version: 1.0
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.6
Subject: [dm-devel] [PATCH v8 5/5] block: Pass unshare intent via
 REQ_OP_PROVISION
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
Cc: Jens Axboe <axboe@kernel.dk>, Dave Chinner <david@fromorbit.com>,
 Theodore Ts'o <tytso@mit.edu>, "Darrick J. Wong" <djwong@kernel.org>,
 Brian Foster <bfoster@redhat.com>, Bart Van Assche <bvanassche@google.com>,
 Mike Snitzer <snitzer@kernel.org>, Christoph Hellwig <hch@infradead.org>,
 Andreas Dilger <adilger.kernel@dilger.ca>,
 Sarthak Kukreti <sarthakkukreti@chromium.org>,
 Alasdair Kergon <agk@redhat.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: chromium.org
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Allow REQ_OP_PROVISION to pass in an extra REQ_UNSHARE bit to
annotate unshare requests to underlying layers. Layers that support
FALLOC_FL_UNSHARE will be able to use this as an indicator of which
fallocate() mode to use.

Suggested-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Sarthak Kukreti <sarthakkukreti@chromium.org>
---
 block/blk-lib.c           |  6 +++++-
 block/fops.c              |  6 ++++--
 drivers/block/loop.c      | 35 +++++++++++++++++++++++++++++------
 include/linux/blk_types.h |  3 +++
 include/linux/blkdev.h    |  3 ++-
 5 files changed, 43 insertions(+), 10 deletions(-)

diff --git a/block/blk-lib.c b/block/blk-lib.c
index b1f720e198cd..d6cf572605f5 100644
--- a/block/blk-lib.c
+++ b/block/blk-lib.c
@@ -350,6 +350,7 @@ EXPORT_SYMBOL(blkdev_issue_secure_erase);
  * @sector:	start sector
  * @nr_sects:	number of sectors to provision
  * @gfp_mask:	memory allocation flags (for bio_alloc)
+ * @flags:	controls detailed behavior
  *
  * Description:
  *  Issues a provision request to the block device for the range of sectors.
@@ -357,7 +358,7 @@ EXPORT_SYMBOL(blkdev_issue_secure_erase);
  *  underlying storage pool to allocate space for this block range.
  */
 int blkdev_issue_provision(struct block_device *bdev, sector_t sector,
-		sector_t nr_sects, gfp_t gfp)
+		sector_t nr_sects, gfp_t gfp, unsigned flags)
 {
 	sector_t bs_mask = (bdev_logical_block_size(bdev) >> 9) - 1;
 	unsigned int max_sectors = bdev_max_provision_sectors(bdev);
@@ -380,6 +381,9 @@ int blkdev_issue_provision(struct block_device *bdev, sector_t sector,
 		bio->bi_iter.bi_sector = sector;
 		bio->bi_iter.bi_size = req_sects << SECTOR_SHIFT;
 
+		if (flags & BLKDEV_PROVISION_UNSHARE_RANGE)
+			bio->bi_opf |= REQ_UNSHARE;
+
 		sector += req_sects;
 		nr_sects -= req_sects;
 		if (!nr_sects) {
diff --git a/block/fops.c b/block/fops.c
index 99b24bd9d461..dd442b6f0486 100644
--- a/block/fops.c
+++ b/block/fops.c
@@ -782,8 +782,10 @@ static long blkdev_fallocate(struct file *file, int mode, loff_t start,
 	case FALLOC_FL_UNSHARE_RANGE:
 	case FALLOC_FL_KEEP_SIZE:
 	case FALLOC_FL_UNSHARE_RANGE | FALLOC_FL_KEEP_SIZE:
-		error = blkdev_issue_provision(bdev, start >> SECTOR_SHIFT,
-					       len >> SECTOR_SHIFT, GFP_KERNEL);
+		error = blkdev_issue_provision(
+				bdev, start >> SECTOR_SHIFT, len >> SECTOR_SHIFT, GFP_KERNEL,
+				(mode & FALLOC_FL_UNSHARE_RANGE) ?
+					BLKDEV_PROVISION_UNSHARE_RANGE : 0);
 		break;
 	case FALLOC_FL_ZERO_RANGE:
 	case FALLOC_FL_ZERO_RANGE | FALLOC_FL_KEEP_SIZE:
diff --git a/drivers/block/loop.c b/drivers/block/loop.c
index abb4dddbd4fd..f30479deb615 100644
--- a/drivers/block/loop.c
+++ b/drivers/block/loop.c
@@ -306,6 +306,30 @@ static int lo_read_simple(struct loop_device *lo, struct request *rq,
 	return 0;
 }
 
+static bool validate_fallocate_mode(struct loop_device *lo, int mode)
+{
+	bool ret = true;
+
+	switch (mode) {
+	case FALLOC_FL_PUNCH_HOLE:
+	case FALLOC_FL_ZERO_RANGE:
+		if (!bdev_max_discard_sectors(lo->lo_device))
+			ret = false;
+		break;
+	case 0:
+	case FALLOC_FL_UNSHARE_RANGE:
+		if (!bdev_max_provision_sectors(lo->lo_device))
+			ret = false;
+		break;
+
+	default:
+		ret = false;
+	}
+
+	return ret;
+}
+
+
 static int lo_fallocate(struct loop_device *lo, struct request *rq, loff_t pos,
 			int mode)
 {
@@ -316,11 +340,7 @@ static int lo_fallocate(struct loop_device *lo, struct request *rq, loff_t pos,
 	struct file *file = lo->lo_backing_file;
 	int ret;
 
-	if (mode & (FALLOC_FL_PUNCH_HOLE | FALLOC_FL_ZERO_RANGE) &&
-	    !bdev_max_discard_sectors(lo->lo_device))
-		return -EOPNOTSUPP;
-
-	if (mode == 0 && !bdev_max_provision_sectors(lo->lo_device))
+	if (!validate_fallocate_mode(lo, mode))
 		return -EOPNOTSUPP;
 
 	mode |= FALLOC_FL_KEEP_SIZE;
@@ -493,7 +513,10 @@ static int do_req_filebacked(struct loop_device *lo, struct request *rq)
 	case REQ_OP_DISCARD:
 		return lo_fallocate(lo, rq, pos, FALLOC_FL_PUNCH_HOLE);
 	case REQ_OP_PROVISION:
-		return lo_fallocate(lo, rq, pos, 0);
+		return lo_fallocate(lo, rq, pos,
+				    (rq->cmd_flags & REQ_UNSHARE) ?
+					    FALLOC_FL_UNSHARE_RANGE :
+					    0);
 	case REQ_OP_WRITE:
 		if (cmd->use_aio)
 			return lo_rw_aio(lo, cmd, pos, ITER_SOURCE);
diff --git a/include/linux/blk_types.h b/include/linux/blk_types.h
index e55828ddfafe..f16187ae4c4a 100644
--- a/include/linux/blk_types.h
+++ b/include/linux/blk_types.h
@@ -430,6 +430,8 @@ enum req_flag_bits {
 	 */
 	/* for REQ_OP_WRITE_ZEROES: */
 	__REQ_NOUNMAP,		/* do not free blocks when zeroing */
+	/* for REQ_OP_PROVISION: */
+	__REQ_UNSHARE,		/* unshare blocks */
 
 	__REQ_NR_BITS,		/* stops here */
 };
@@ -458,6 +460,7 @@ enum req_flag_bits {
 #define REQ_FS_PRIVATE	(__force blk_opf_t)(1ULL << __REQ_FS_PRIVATE)
 
 #define REQ_NOUNMAP	(__force blk_opf_t)(1ULL << __REQ_NOUNMAP)
+#define REQ_UNSHARE	(__force blk_opf_t)(1ULL << __REQ_UNSHARE)
 
 #define REQ_FAILFAST_MASK \
 	(REQ_FAILFAST_DEV | REQ_FAILFAST_TRANSPORT | REQ_FAILFAST_DRIVER)
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index dcae5538f99a..0f88ccbde12f 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -1042,10 +1042,11 @@ int blkdev_issue_secure_erase(struct block_device *bdev, sector_t sector,
 		sector_t nr_sects, gfp_t gfp);
 
 extern int blkdev_issue_provision(struct block_device *bdev, sector_t sector,
-		sector_t nr_sects, gfp_t gfp_mask);
+		sector_t nr_sects, gfp_t gfp_mask, unsigned int flags);
 
 #define BLKDEV_ZERO_NOUNMAP	(1 << 0)  /* do not free blocks */
 #define BLKDEV_ZERO_NOFALLBACK	(1 << 1)  /* don't write explicit zeroes */
+#define BLKDEV_PROVISION_UNSHARE_RANGE	(1 << 2)  /* unshare range on provision */
 
 extern int __blkdev_issue_zeroout(struct block_device *bdev, sector_t sector,
 		sector_t nr_sects, gfp_t gfp_mask, struct bio **biop,
-- 
2.42.0.609.gbb76f46606-goog

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel


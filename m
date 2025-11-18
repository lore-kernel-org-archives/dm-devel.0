Received: from mail-pj1-f49.google.com (mail-pj1-f49.google.com [209.85.216.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E83812FD1B9
	for <dm-devel@lists.linux.dev>; Tue, 18 Nov 2025 07:42:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763451770; cv=none; b=Z16DNVOSXROgJ3r1SSmREKCLzzRUIsoGqPPK8ZnZiWxIDk9PBTAU7EYQm1l8TIoGOSvRWDGzsG6BeaRpy5Ex4vU9B7IPHVlOr1Bh7NbhM6G7ZqDR8i/K40JtVfhIXLhwuVVg8hrQwTYSag4gFIYzOKYYc0WI+t/Tq18cM0ICyxU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763451770; c=relaxed/simple;
	bh=3y+14w/RWgc7QectdYOrrunQMgiyUfFCpyaPphbOlAI=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=IUp5w0zLEwNkKD8iNVhvD+OKXmGsNjd0jk7rZsC4R4IFlKhjRtQ4xBtfmGbunWtYvRRXegf4qFfMkP8eZq04JbamjCZf4vt1P0UWC2E9f1WkG5o1e5VuayXNxKTxKotAM9n0b573Efr3CO69GlQ/EH5WiUpM0UjmOoLqflIq9HQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=LcGuA99d; arc=none smtp.client-ip=209.85.216.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="LcGuA99d"
Received: by mail-pj1-f49.google.com with SMTP id 98e67ed59e1d1-3434700be69so6959538a91.1
        for <dm-devel@lists.linux.dev>; Mon, 17 Nov 2025 23:42:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1763451768; x=1764056568; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=NxywsA1nA8TGs2RT9uGSCEgSdjJBrPjC0KiHZ/jaP8E=;
        b=LcGuA99dNh6lO6F1uq/0Hwc+tJbfn7T/yuwrYHMA3fqf9ZIp6h+aRMbA7YHGm1R8cA
         5/G+pB44KlGOgkFGymtUI97UFLFl3olLelAsJBwPFuSWx7Jm92WjEFMP6q31kDUzJYoB
         L77ofdU3tUkWyqOEPKJWKpYktA4TkSdbwnap7VMEJH3OKLxAk/sNzqumRPki9AOVJm8e
         GYuxY0NCokEb7Uoa1ATnDTD3qAauZ6d+lQ1ZBkzBc0qLNAOCeDDEzCv5E7lCdEDPgUJv
         kpLmhv8ViOleyjlmpfeQXv/oSF50Yy+BI0kLkj+VRiyncEUN5GoL5wn+Mb8+zct2/N7X
         QdRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763451768; x=1764056568;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=NxywsA1nA8TGs2RT9uGSCEgSdjJBrPjC0KiHZ/jaP8E=;
        b=YGo8aGESJZt7K15ij7nLJ+0IoJjdVedmH1hkklDulu8uw0YeLMbadh32i+kohwhW5Q
         Cj9ikUEk5Op3A21BHcdywq8FE2Jq4zwNrHe5tGymcDhSygGwN7uYhs4pSDzMDF5BDhzB
         Ij24gmjDwtOi61uOwpDV+gbY3hI4zcUee4+2r2snAPjS7wmW4vggFeY19wnUor911eEL
         kSOxgZ0O8jQceoSmpzz9FMSY5e/5Nyaw4qK1Lv+8D4RoNPvEhxeBAv3MOtdpCRhHTJwX
         Jx+LctJnin0oUOEh7fcUEjSCyS36ENb1otqA7MutLZk/gDdayMktXtKAkLRYPpFCBXhL
         tA8g==
X-Forwarded-Encrypted: i=1; AJvYcCXnqnD+94grNMJgsyd4ABzsM4fS/FgxAqeym1w9ixHeuHlHVx7wGQYCUEpbbW5ZK4QataP7MNopTw==@lists.linux.dev
X-Gm-Message-State: AOJu0YyNT4KJsP7tEPTPw8Ak+Q/yeajGh9tti7koAu7YuQdGsq7RgWyP
	7JPGnjtAG1kkt0JS7EU98N/29+nXhoGtsg8DhoEipbUyGidBu8qa+VBT
X-Gm-Gg: ASbGncuhh4+B/NOB7QF21dpde6jYtkwl6+PxuWCClDsdLV2wJMUv4H529Vw5khji/AY
	Axux89YJPq3KLaKB5qfuVOsL2mi2/FC8I2WlzNYBKqwM/yf6m5G02eh0DNBoZdnlfLIwVx1X27K
	3Mvf6PRYc36mwJYzoYCQkl89k42xgtAhlxYdofyRMQjQ4MdLRRhkXbBpfvILP66vsIuo2YcnOuu
	dhQeroJxg/ioOQ6cxIiEF4+asypchwphCj80DbbU16KN2jo+B4YLV71/oCAaANlmrGLKZgdhTYm
	NnEKIYTB3f7LhSNij71PiO8090aOTIfgAy9vA2c2eAGgtTsLJoJKTsSl0O9U9RzkH3erHZd1n/t
	gGengAWRIq3e4VbxxQC+nl3VF5P/bIbisQczUbgvCIdyAdnxANUDZHee2q9CYy51W6uf5Q6PoIa
	O6bRFRX5PrSPOpDI3SbVvZic3TCC1/8hz7D177um30K4XxqGmDKiJ0YwHnVg==
X-Google-Smtp-Source: AGHT+IEP4Fiq1WYi0fQwUxT7w8CcXRrYGmKQQRpSmtx18AEGOxK4QGIRV7JKkjFv4nGOrRKeWjhvWA==
X-Received: by 2002:a05:7022:69aa:b0:11b:3742:1257 with SMTP id a92af1059eb24-11b4120ca2amr9929883c88.34.1763451767829;
        Mon, 17 Nov 2025 23:42:47 -0800 (PST)
Received: from localhost (ip70-175-132-216.oc.oc.cox.net. [70.175.132.216])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-11b06088625sm58814092c88.8.2025.11.17.23.42.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Nov 2025 23:42:47 -0800 (PST)
From: Chaitanya Kulkarni <ckulkarnilinux@gmail.com>
To: linux-block@vger.kernel.org,
	dm-devel@lists.linux.dev,
	linux-raid@vger.kernel.org,
	linux-nvme@lists.infradead.org,
	linux-f2fs-devel@lists.sourceforge.net,
	linux-xfs@vger.kernel.org
Cc: axboe@kernel.dk,
	agk@redhat.com,
	snitzer@kernel.org,
	mpatocka@redhat.com,
	song@kernel.org,
	yukuai3@huawei.com,
	hch@lst.de,
	sagi@grimberg.me,
	kch@nvidia.com,
	jaegeuk@kernel.org,
	chao@kernel.org,
	cem@kernel.org,
	Chaitanya Kulkarni <ckulkarnilinux@gmail.com>
Subject: [RFC PATCH] block: change __blkdev_issue_discard() return type to void
Date: Mon, 17 Nov 2025 23:42:43 -0800
Message-Id: <20251118074243.636812-1-ckulkarnilinux@gmail.com>
X-Mailer: git-send-email 2.40.0
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

__blkdev_issue_discard() always returns 0, making all error checking
at call sites dead code. The function simply stops allocating bios 
and returns 0.

Discard operations are advisory/optimization, not critical. Some callers
have dead error checking code expecting wrong return codes such as
-ENOTSUPP when 0 is only returned. 

This patch changes __blkdev_issue_discard() return type to void and
removes dead error checking code from all call sites:

* Block layer:
  blk-lib.c: Remove return value, update blkdev_issue_discard() caller

* Device mapper:
  dm-thin.c: Change issue_discard() to void, update both callers
  md.c: Simplify conditional to just check for NULL bio

* NVMe target:
  io-cmd-bdev.c: Remove dead error handling and error_slba assignment

* Filesystems:
  f2fs/segment.c: Preserve fault injection
  xfs/xfs_discard.c: Update both xfs_discard_extents() and
  xfs_discard_rtdev_extents() to remove dead error checks

Signed-off-by: Chaitanya Kulkarni <ckulkarnilinux@gmail.com>
---
Hi,

Due to involvement of all the subsystem making it as an RFC, ideally
it shuoldn't be an RFC.

-ck
---
 block/blk-lib.c                   |  7 +++----
 drivers/md/dm-thin.c              | 12 +++++-------
 drivers/md/md.c                   |  4 ++--
 drivers/nvme/target/io-cmd-bdev.c |  7 +------
 fs/f2fs/segment.c                 |  2 +-
 fs/xfs/xfs_discard.c              | 17 +++--------------
 include/linux/blkdev.h            |  2 +-
 7 files changed, 16 insertions(+), 35 deletions(-)

diff --git a/block/blk-lib.c b/block/blk-lib.c
index 3030a772d3aa..ca78ec6b5326 100644
--- a/block/blk-lib.c
+++ b/block/blk-lib.c
@@ -60,7 +60,7 @@ struct bio *blk_alloc_discard_bio(struct block_device *bdev,
 	return bio;
 }
 
-int __blkdev_issue_discard(struct block_device *bdev, sector_t sector,
+void __blkdev_issue_discard(struct block_device *bdev, sector_t sector,
 		sector_t nr_sects, gfp_t gfp_mask, struct bio **biop)
 {
 	struct bio *bio;
@@ -68,7 +68,6 @@ int __blkdev_issue_discard(struct block_device *bdev, sector_t sector,
 	while ((bio = blk_alloc_discard_bio(bdev, &sector, &nr_sects,
 			gfp_mask)))
 		*biop = bio_chain_and_submit(*biop, bio);
-	return 0;
 }
 EXPORT_SYMBOL(__blkdev_issue_discard);
 
@@ -90,8 +89,8 @@ int blkdev_issue_discard(struct block_device *bdev, sector_t sector,
 	int ret;
 
 	blk_start_plug(&plug);
-	ret = __blkdev_issue_discard(bdev, sector, nr_sects, gfp_mask, &bio);
-	if (!ret && bio) {
+	__blkdev_issue_discard(bdev, sector, nr_sects, gfp_mask, &bio);
+	if (bio) {
 		ret = submit_bio_wait(bio);
 		if (ret == -EOPNOTSUPP)
 			ret = 0;
diff --git a/drivers/md/dm-thin.c b/drivers/md/dm-thin.c
index c84149ba4e38..77c76f75c85f 100644
--- a/drivers/md/dm-thin.c
+++ b/drivers/md/dm-thin.c
@@ -395,13 +395,13 @@ static void begin_discard(struct discard_op *op, struct thin_c *tc, struct bio *
 	op->bio = NULL;
 }
 
-static int issue_discard(struct discard_op *op, dm_block_t data_b, dm_block_t data_e)
+static void issue_discard(struct discard_op *op, dm_block_t data_b, dm_block_t data_e)
 {
 	struct thin_c *tc = op->tc;
 	sector_t s = block_to_sectors(tc->pool, data_b);
 	sector_t len = block_to_sectors(tc->pool, data_e - data_b);
 
-	return __blkdev_issue_discard(tc->pool_dev->bdev, s, len, GFP_NOIO, &op->bio);
+	__blkdev_issue_discard(tc->pool_dev->bdev, s, len, GFP_NOIO, &op->bio);
 }
 
 static void end_discard(struct discard_op *op, int r)
@@ -1113,9 +1113,7 @@ static void passdown_double_checking_shared_status(struct dm_thin_new_mapping *m
 				break;
 		}
 
-		r = issue_discard(&op, b, e);
-		if (r)
-			goto out;
+		issue_discard(&op, b, e);
 
 		b = e;
 	}
@@ -1188,8 +1186,8 @@ static void process_prepared_discard_passdown_pt1(struct dm_thin_new_mapping *m)
 		struct discard_op op;
 
 		begin_discard(&op, tc, discard_parent);
-		r = issue_discard(&op, m->data_block, data_end);
-		end_discard(&op, r);
+		issue_discard(&op, m->data_block, data_end);
+		end_discard(&op, 0);
 	}
 }
 
diff --git a/drivers/md/md.c b/drivers/md/md.c
index 41c476b40c7a..7fc0bb7a3814 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -9041,8 +9041,8 @@ void md_submit_discard_bio(struct mddev *mddev, struct md_rdev *rdev,
 {
 	struct bio *discard_bio = NULL;
 
-	if (__blkdev_issue_discard(rdev->bdev, start, size, GFP_NOIO,
-			&discard_bio) || !discard_bio)
+	__blkdev_issue_discard(rdev->bdev, start, size, GFP_NOIO, &discard_bio);
+	if (!discard_bio)
 		return;
 
 	bio_chain(discard_bio, bio);
diff --git a/drivers/nvme/target/io-cmd-bdev.c b/drivers/nvme/target/io-cmd-bdev.c
index 8d246b8ca604..f26010c46c33 100644
--- a/drivers/nvme/target/io-cmd-bdev.c
+++ b/drivers/nvme/target/io-cmd-bdev.c
@@ -366,16 +366,11 @@ static u16 nvmet_bdev_discard_range(struct nvmet_req *req,
 		struct nvme_dsm_range *range, struct bio **bio)
 {
 	struct nvmet_ns *ns = req->ns;
-	int ret;
 
-	ret = __blkdev_issue_discard(ns->bdev,
+	__blkdev_issue_discard(ns->bdev,
 			nvmet_lba_to_sect(ns, range->slba),
 			le32_to_cpu(range->nlb) << (ns->blksize_shift - 9),
 			GFP_KERNEL, bio);
-	if (ret && ret != -EOPNOTSUPP) {
-		req->error_slba = le64_to_cpu(range->slba);
-		return errno_to_nvme_status(req, ret);
-	}
 	return NVME_SC_SUCCESS;
 }
 
diff --git a/fs/f2fs/segment.c b/fs/f2fs/segment.c
index b45eace879d7..e6078176f733 100644
--- a/fs/f2fs/segment.c
+++ b/fs/f2fs/segment.c
@@ -1346,7 +1346,7 @@ static int __submit_discard_cmd(struct f2fs_sb_info *sbi,
 		if (time_to_inject(sbi, FAULT_DISCARD)) {
 			err = -EIO;
 		} else {
-			err = __blkdev_issue_discard(bdev,
+			__blkdev_issue_discard(bdev,
 					SECTOR_FROM_BLOCK(start),
 					SECTOR_FROM_BLOCK(len),
 					GFP_NOFS, &bio);
diff --git a/fs/xfs/xfs_discard.c b/fs/xfs/xfs_discard.c
index ee49f20875af..f82cc07806df 100644
--- a/fs/xfs/xfs_discard.c
+++ b/fs/xfs/xfs_discard.c
@@ -116,7 +116,6 @@ xfs_discard_extents(
 	struct xfs_extent_busy	*busyp;
 	struct bio		*bio = NULL;
 	struct blk_plug		plug;
-	int			error = 0;
 
 	blk_start_plug(&plug);
 	list_for_each_entry(busyp, &extents->extent_list, list) {
@@ -126,18 +125,10 @@ xfs_discard_extents(
 
 		trace_xfs_discard_extent(xg, busyp->bno, busyp->length);
 
-		error = __blkdev_issue_discard(btp->bt_bdev,
+		__blkdev_issue_discard(btp->bt_bdev,
 				xfs_gbno_to_daddr(xg, busyp->bno),
 				XFS_FSB_TO_BB(mp, busyp->length),
 				GFP_KERNEL, &bio);
-		if (error && error != -EOPNOTSUPP) {
-			xfs_info(mp,
-	 "discard failed for extent [0x%llx,%u], error %d",
-				 (unsigned long long)busyp->bno,
-				 busyp->length,
-				 error);
-			break;
-		}
 	}
 
 	if (bio) {
@@ -149,7 +140,7 @@ xfs_discard_extents(
 	}
 	blk_finish_plug(&plug);
 
-	return error;
+	return 0;
 }
 
 /*
@@ -496,12 +487,10 @@ xfs_discard_rtdev_extents(
 
 		trace_xfs_discard_rtextent(mp, busyp->bno, busyp->length);
 
-		error = __blkdev_issue_discard(bdev,
+		__blkdev_issue_discard(bdev,
 				xfs_rtb_to_daddr(mp, busyp->bno),
 				XFS_FSB_TO_BB(mp, busyp->length),
 				GFP_NOFS, &bio);
-		if (error)
-			break;
 	}
 	xfs_discard_free_rtdev_extents(tr);
 
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index f0ab02e0a673..b05c37d20b09 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -1258,7 +1258,7 @@ extern void blk_io_schedule(void);
 
 int blkdev_issue_discard(struct block_device *bdev, sector_t sector,
 		sector_t nr_sects, gfp_t gfp_mask);
-int __blkdev_issue_discard(struct block_device *bdev, sector_t sector,
+void __blkdev_issue_discard(struct block_device *bdev, sector_t sector,
 		sector_t nr_sects, gfp_t gfp_mask, struct bio **biop);
 int blkdev_issue_secure_erase(struct block_device *bdev, sector_t sector,
 		sector_t nr_sects, gfp_t gfp);
-- 
2.40.0


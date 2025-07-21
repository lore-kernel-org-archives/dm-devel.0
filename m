Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0DD32135AC;
	Mon, 21 Jul 2025 17:16:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753118200; cv=none; b=f6Vm1KVppZAgk9//RcccHQhRJxBhyiz6Mhw87W90tAuT8oN+zGk1IGMzozCNeIWFsUK2PNIwzfEa6HRdzy4UDduVcjiX9brs5O3ySmgIrbHKlum9B9tCO0TeHphzxiQ5H6tvsqV0aWpN+prVxHA3Nljr03Bjv4oOiVv3ofshZ24=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753118200; c=relaxed/simple;
	bh=En3ihaBodhFJ35cJ1OcfmZv7wX0XskKJ0hlF/ALsRI4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sO6J0X2PZZpPMxQtVB5EMRAX2ASoHfFHXsyr9UZ8Oq2RpcxaSerWKuNNQUPjboOaSk5jXnntqF9Ngdf+R4Zw4xehz3o/gy/j2Vr9RAR4AwaOhPAsMKQGtoTrV/QgWH5g6T8HmywaSD9gGA6uP1ABTWO5fKyDSvHfeRajN0LpdXU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=J1LlB7o9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="J1LlB7o9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C24B1C4CEED;
	Mon, 21 Jul 2025 17:16:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1753118199;
	bh=En3ihaBodhFJ35cJ1OcfmZv7wX0XskKJ0hlF/ALsRI4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=J1LlB7o9rQ+0mD/plHFrQJ/q/c3S+LtigYGASTpxtvkmrHZ7epM/T2YkMGfoIpEGW
	 6mSrINZqHZhG4MtCjzSuvRgNbuCVYgsCzk/qlGWtu32PdN/SsDrdsWKkU3c6DDT/cb
	 ksGph3ldrxuuInXrJnvPb0yuRKOaevpUYhnkZ4PahNjCi1OVodplzPsjy4dR4nPj6H
	 w/uVr/km3c2YlmXKJewmxzcJXoHs/EzTPrd740j9BLw7TXQacvJvDLBBvSXc5g9v4N
	 kEs4XcXbtqpiqbIw9NrRNQhmJ+6yLJkdRIyfAK0bipRyh/0zLlK70Rria/6EqCwFeX
	 KqvZr/Gf0TWpA==
From: Yu Kuai <yukuai@kernel.org>
To: corbet@lwn.net,
	agk@redhat.co,
	snitzer@kernel.org,
	mpatocka@redhat.com,
	hch@lst.de,
	song@kernel.org,
	hare@suse.de
Cc: linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	dm-devel@lists.linux.dev,
	linux-raid@vger.kernel.org,
	yukuai3@huawei.com,
	yangerkun@huawei.com,
	yi.zhang@huawei.com,
	johnny.chenyi@huawei.com,
	Xiao Ni <xni@redhat.com>
Subject: [PATCH v4 01/11] md: add a new parameter 'offset' to md_super_write()
Date: Tue, 22 Jul 2025 01:15:47 +0800
Message-ID: <20250721171557.34587-2-yukuai@kernel.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250721171557.34587-1-yukuai@kernel.org>
References: <20250721171557.34587-1-yukuai@kernel.org>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Yu Kuai <yukuai3@huawei.com>

The parameter is always set to 0 for now, following patches will use
this helper to write llbitmap to underlying disks, allow writing
dirty sectors instead of the whole page.

Also rename md_super_write to md_write_metadata since there is nothing
super-block specific.

Signed-off-by: Yu Kuai <yukuai3@huawei.com>
Reviewed-by: Xiao Ni <xni@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Hannes Reinecke <hare@suse.de>
---
 drivers/md/md-bitmap.c |  3 ++-
 drivers/md/md.c        | 52 +++++++++++++++++++++++++-----------------
 drivers/md/md.h        |  5 ++--
 3 files changed, 36 insertions(+), 24 deletions(-)

diff --git a/drivers/md/md-bitmap.c b/drivers/md/md-bitmap.c
index 28dd66ab8df9..3c8b8ecf0695 100644
--- a/drivers/md/md-bitmap.c
+++ b/drivers/md/md-bitmap.c
@@ -485,7 +485,8 @@ static int __write_sb_page(struct md_rdev *rdev, struct bitmap *bitmap,
 			return -EINVAL;
 	}
 
-	md_super_write(mddev, rdev, sboff + ps, (int)min(size, bitmap_limit), page);
+	md_write_metadata(mddev, rdev, sboff + ps, (int)min(size, bitmap_limit),
+			  page, 0);
 	return 0;
 }
 
diff --git a/drivers/md/md.c b/drivers/md/md.c
index f0420d2bce1f..c4ef23ade9e2 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -1028,15 +1028,26 @@ static void super_written(struct bio *bio)
 		wake_up(&mddev->sb_wait);
 }
 
-void md_super_write(struct mddev *mddev, struct md_rdev *rdev,
-		   sector_t sector, int size, struct page *page)
-{
-	/* write first size bytes of page to sector of rdev
-	 * Increment mddev->pending_writes before returning
-	 * and decrement it on completion, waking up sb_wait
-	 * if zero is reached.
-	 * If an error occurred, call md_error
-	 */
+/**
+ * md_write_metadata - write metadata to underlying disk, including
+ * array superblock, badblocks, bitmap superblock and bitmap bits.
+ * @mddev:	the array to write
+ * @rdev:	the underlying disk to write
+ * @sector:	the offset to @rdev
+ * @size:	the length of the metadata
+ * @page:	the metadata
+ * @offset:	the offset to @page
+ *
+ * Write @size bytes of @page start from @offset, to @sector of @rdev, Increment
+ * mddev->pending_writes before returning, and decrement it on completion,
+ * waking up sb_wait. Caller must call md_super_wait() after issuing io to all
+ * rdev. If an error occurred, md_error() will be called, and the @rdev will be
+ * kicked out from @mddev.
+ */
+void md_write_metadata(struct mddev *mddev, struct md_rdev *rdev,
+		       sector_t sector, int size, struct page *page,
+		       unsigned int offset)
+{
 	struct bio *bio;
 
 	if (!page)
@@ -1054,7 +1065,7 @@ void md_super_write(struct mddev *mddev, struct md_rdev *rdev,
 	atomic_inc(&rdev->nr_pending);
 
 	bio->bi_iter.bi_sector = sector;
-	__bio_add_page(bio, page, size, 0);
+	__bio_add_page(bio, page, size, offset);
 	bio->bi_private = rdev;
 	bio->bi_end_io = super_written;
 
@@ -1664,8 +1675,8 @@ super_90_rdev_size_change(struct md_rdev *rdev, sector_t num_sectors)
 	if ((u64)num_sectors >= (2ULL << 32) && rdev->mddev->level >= 1)
 		num_sectors = (sector_t)(2ULL << 32) - 2;
 	do {
-		md_super_write(rdev->mddev, rdev, rdev->sb_start, rdev->sb_size,
-		       rdev->sb_page);
+		md_write_metadata(rdev->mddev, rdev, rdev->sb_start,
+				  rdev->sb_size, rdev->sb_page, 0);
 	} while (md_super_wait(rdev->mddev) < 0);
 	return num_sectors;
 }
@@ -2313,8 +2324,8 @@ super_1_rdev_size_change(struct md_rdev *rdev, sector_t num_sectors)
 	sb->super_offset = cpu_to_le64(rdev->sb_start);
 	sb->sb_csum = calc_sb_1_csum(sb);
 	do {
-		md_super_write(rdev->mddev, rdev, rdev->sb_start, rdev->sb_size,
-			       rdev->sb_page);
+		md_write_metadata(rdev->mddev, rdev, rdev->sb_start,
+				  rdev->sb_size, rdev->sb_page, 0);
 	} while (md_super_wait(rdev->mddev) < 0);
 	return num_sectors;
 
@@ -2823,18 +2834,17 @@ void md_update_sb(struct mddev *mddev, int force_change)
 			continue; /* no noise on spare devices */
 
 		if (!test_bit(Faulty, &rdev->flags)) {
-			md_super_write(mddev,rdev,
-				       rdev->sb_start, rdev->sb_size,
-				       rdev->sb_page);
+			md_write_metadata(mddev, rdev, rdev->sb_start,
+					  rdev->sb_size, rdev->sb_page, 0);
 			pr_debug("md: (write) %pg's sb offset: %llu\n",
 				 rdev->bdev,
 				 (unsigned long long)rdev->sb_start);
 			rdev->sb_events = mddev->events;
 			if (rdev->badblocks.size) {
-				md_super_write(mddev, rdev,
-					       rdev->badblocks.sector,
-					       rdev->badblocks.size << 9,
-					       rdev->bb_page);
+				md_write_metadata(mddev, rdev,
+						  rdev->badblocks.sector,
+						  rdev->badblocks.size << 9,
+						  rdev->bb_page, 0);
 				rdev->badblocks.size = 0;
 			}
 
diff --git a/drivers/md/md.h b/drivers/md/md.h
index b7dc8253efd8..9e37c6c18722 100644
--- a/drivers/md/md.h
+++ b/drivers/md/md.h
@@ -908,8 +908,9 @@ void md_account_bio(struct mddev *mddev, struct bio **bio);
 void md_free_cloned_bio(struct bio *bio);
 
 extern bool __must_check md_flush_request(struct mddev *mddev, struct bio *bio);
-extern void md_super_write(struct mddev *mddev, struct md_rdev *rdev,
-			   sector_t sector, int size, struct page *page);
+void md_write_metadata(struct mddev *mddev, struct md_rdev *rdev,
+		       sector_t sector, int size, struct page *page,
+		       unsigned int offset);
 extern int md_super_wait(struct mddev *mddev);
 extern int sync_page_io(struct md_rdev *rdev, sector_t sector, int size,
 		struct page *page, blk_opf_t opf, bool metadata_op);
-- 
2.43.0


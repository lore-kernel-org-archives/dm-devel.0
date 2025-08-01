Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EFA501F4C8C
	for <dm-devel@lists.linux.dev>; Fri,  1 Aug 2025 07:10:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754032253; cv=none; b=hX39HaUkJE3hyBpMqFXL+FdsxT6N4qVFmwwCxeNDBkRsN0azKFULo0DJ1BMpvCGnQurBhbWLuyCWJGGDc9Xkmm0Ac55bdvMugSBN40/h0j/MrP83E7FylKx+O4SOfx11APSv5ndE2PN93cQz0wUzeUTYE4/bsduvQI7ted2KfCM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754032253; c=relaxed/simple;
	bh=l3tiJkdUxmYMrZkEQxQZ8ZyHe1v4m8i6MnpBnBoOPF8=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=R7rdIXDn5SGiAHsnIHONBj57hr/BAqtaIl9loTTN4Nn/zRVTpqxLIC4DkiXLJKGokpv5XpNBZFZCza5f6+Hif565rpHOn8I437JQ95OXQHWrsEYEuRKnIgnpG9wqVJxBXYNHGcXobL2n5oBPfPwIpkPCRnBXALxZtfuiNMrSUKQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=none smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.216])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTPS id 4btcYN0dYdzKHMmy
	for <dm-devel@lists.linux.dev>; Fri,  1 Aug 2025 15:10:48 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 08D001A019B
	for <dm-devel@lists.linux.dev>; Fri,  1 Aug 2025 15:10:47 +0800 (CST)
Received: from huaweicloud.com (unknown [10.175.104.67])
	by APP4 (Coremail) with SMTP id gCh0CgDHjxByaIxoqAzACA--.18978S5;
	Fri, 01 Aug 2025 15:10:46 +0800 (CST)
From: Yu Kuai <yukuai1@huaweicloud.com>
To: hch@lst.de,
	corbet@lwn.net,
	song@kernel.org,
	yukuai3@huawei.com,
	agk@redhat.com,
	snitzer@kernel.org,
	mpatocka@redhat.com,
	linan122@huawei.com,
	xni@redhat.com,
	hare@suse.de
Cc: linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-raid@vger.kernel.org,
	dm-devel@lists.linux.dev,
	yukuai1@huaweicloud.com,
	yi.zhang@huawei.com,
	yangerkun@huawei.com,
	johnny.chenyi@huawei.com
Subject: [PATCH v5 01/11] md: add a new parameter 'offset' to md_super_write()
Date: Fri,  1 Aug 2025 15:03:36 +0800
Message-Id: <20250801070346.4127558-2-yukuai1@huaweicloud.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20250801070346.4127558-1-yukuai1@huaweicloud.com>
References: <20250801070346.4127558-1-yukuai1@huaweicloud.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgDHjxByaIxoqAzACA--.18978S5
X-Coremail-Antispam: 1UD129KBjvJXoW3Jr4kXF1DAFWDKr43KrWxZwb_yoW7CF4Dpa
	yIvFyfJrWayrWaqw17JFWDua4Fq34DKrZrtry7C34xu3W7KrykKF15XFy8Xr98uF9xCrs8
	Xw4jkFW7uw1IgrJanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUmvb4IE77IF4wAFF20E14v26rWj6s0DM7CY07I20VC2zVCF04k2
	6cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28IrcIa0xkI8VA2jI8067AKxVWUGw
	A2048vs2IY020Ec7CjxVAFwI0_Gr0_Xr1l8cAvFVAK0II2c7xJM28CjxkF64kEwVA0rcxS
	w2x7M28EF7xvwVC0I7IYx2IY67AKxVWDJVCq3wA2z4x0Y4vE2Ix0cI8IcVCY1x0267AKxV
	W8Jr0_Cr1UM28EF7xvwVC2z280aVAFwI0_GcCE3s1l84ACjcxK6I8E87Iv6xkF7I0E14v2
	6rxl6s0DM2AIxVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4xI64kE6c02F40Ex7xfMc
	Ij6xIIjxv20xvE14v26r1j6r18McIj6I8E87Iv67AKxVWUJVW8JwAm72CE4IkC6x0Yz7v_
	Jr0_Gr1lF7xvr2IYc2Ij64vIr41lF7I21c0EjII2zVCS5cI20VAGYxC7M4IIrI8v6xkF7I
	0E8cxan2IY04v7MxkF7I0En4kS14v26r4a6rW5MxAIw28IcxkI7VAKI48JMxC20s026xCa
	FVCjc4AY6r1j6r4UMI8I3I0E5I8CrVAFwI0_Jr0_Jr4lx2IqxVCjr7xvwVAFwI0_JrI_Jr
	Wlx4CE17CEb7AF67AKxVW8ZVWrXwCIc40Y0x0EwIxGrwCI42IY6xIIjxv20xvE14v26r1j
	6r1xMIIF0xvE2Ix0cI8IcVCY1x0267AKxVW8JVWxJwCI42IY6xAIw20EY4v20xvaj40_Jr
	0_JF4lIxAIcVC2z280aVAFwI0_Jr0_Gr1lIxAIcVC2z280aVCY1x0267AKxVW8JVW8JrUv
	cSsGvfC2KfnxnUUI43ZEXa7sRMv31JUUUUU==
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/

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
Reviewed-by: Li Nan <linan122@huawei.com>
---
 drivers/md/md-bitmap.c |  3 ++-
 drivers/md/md.c        | 52 +++++++++++++++++++++++++-----------------
 drivers/md/md.h        |  5 ++--
 3 files changed, 36 insertions(+), 24 deletions(-)

diff --git a/drivers/md/md-bitmap.c b/drivers/md/md-bitmap.c
index 5f62f2fd8f3f..b157119de123 100644
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
index d80c98b22696..c1c623fe92bb 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -1034,15 +1034,26 @@ static void super_written(struct bio *bio)
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
@@ -1060,7 +1071,7 @@ void md_super_write(struct mddev *mddev, struct md_rdev *rdev,
 	atomic_inc(&rdev->nr_pending);
 
 	bio->bi_iter.bi_sector = sector;
-	__bio_add_page(bio, page, size, 0);
+	__bio_add_page(bio, page, size, offset);
 	bio->bi_private = rdev;
 	bio->bi_end_io = super_written;
 
@@ -1670,8 +1681,8 @@ super_90_rdev_size_change(struct md_rdev *rdev, sector_t num_sectors)
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
@@ -2319,8 +2330,8 @@ super_1_rdev_size_change(struct md_rdev *rdev, sector_t num_sectors)
 	sb->super_offset = cpu_to_le64(rdev->sb_start);
 	sb->sb_csum = calc_sb_1_csum(sb);
 	do {
-		md_super_write(rdev->mddev, rdev, rdev->sb_start, rdev->sb_size,
-			       rdev->sb_page);
+		md_write_metadata(rdev->mddev, rdev, rdev->sb_start,
+				  rdev->sb_size, rdev->sb_page, 0);
 	} while (md_super_wait(rdev->mddev) < 0);
 	return num_sectors;
 
@@ -2829,18 +2840,17 @@ void md_update_sb(struct mddev *mddev, int force_change)
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
index 081152c8de1f..cadd9bc99938 100644
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
2.39.2


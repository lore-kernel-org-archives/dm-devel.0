Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9B451E2845
	for <dm-devel@lists.linux.dev>; Mon, 12 May 2025 01:28:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747013290; cv=none; b=bkF8ekyiZEXYwul257x4RfIIevWn1N2Jote/WYI0XBIkDmQgkiFu+P1ww0xoyr5eE5ZlP2JyoIep3+iEc0MkyZSyuK9LgFya6uz9iCaoZbX9Z8u8Rl18Hu9P4GgXTz0Xu3080HN4lt/3A2GM84d0efcUcfABtKJwQDLFylLgRyw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747013290; c=relaxed/simple;
	bh=QXGN9hhB73knjaQTWE5Iqt0nAmmYfZwfgur7moic1PY=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=nR9hxN8q0wCsAW6b3YSp6fGXvfGCy1Cfwfa2P4K/DsT+37ztPoIUNFCGCi9h0P9TNQOnYxW+iZy7T2HQUSNS78wj+iubDpkPFlun464kzo34Fyg6iyuI/9xe43rwXOF0d/IzvBmelavG2T64nL4QtYnTCXfThSQPG9HRfwUkG9U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.235])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTPS id 4ZwhnL5w1TzKHMmx
	for <dm-devel@lists.linux.dev>; Mon, 12 May 2025 09:28:06 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 818191A0FE6
	for <dm-devel@lists.linux.dev>; Mon, 12 May 2025 09:28:05 +0800 (CST)
Received: from huaweicloud.com (unknown [10.175.104.67])
	by APP4 (Coremail) with SMTP id gCh0CgCnC2CdTiFoNFCWMA--.55093S10;
	Mon, 12 May 2025 09:28:05 +0800 (CST)
From: Yu Kuai <yukuai1@huaweicloud.com>
To: hch@lst.de,
	xni@redhat.com,
	colyli@kernel.org,
	agk@redhat.com,
	snitzer@kernel.org,
	mpatocka@redhat.com,
	song@kernel.org,
	yukuai3@huawei.com
Cc: linux-kernel@vger.kernel.org,
	dm-devel@lists.linux.dev,
	linux-raid@vger.kernel.org,
	yukuai1@huaweicloud.com,
	yi.zhang@huawei.com,
	yangerkun@huawei.com,
	johnny.chenyi@huawei.com
Subject: [PATCH RFC md-6.16 v3 06/19] md: add a new parameter 'offset' to md_super_write()
Date: Mon, 12 May 2025 09:19:14 +0800
Message-Id: <20250512011927.2809400-7-yukuai1@huaweicloud.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20250512011927.2809400-1-yukuai1@huaweicloud.com>
References: <20250512011927.2809400-1-yukuai1@huaweicloud.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgCnC2CdTiFoNFCWMA--.55093S10
X-Coremail-Antispam: 1UD129KBjvJXoWxur47urW5urWkJrW3Ar1DWrg_yoW5Kw4fpa
	yjvFyfJ3y3JrWjqw1UJFZ7Ca4Fq34DKrZ7KryfC34fua43tryDKF15JFy8Xr98uF9xCrsI
	qw4UtFW7uw1xWr7anT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUmS14x267AKxVWrJVCq3wAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2048vs2IY020E87I2jVAFwI0_JF0E3s1l82xGYI
	kIc2x26xkF7I0E14v26ryj6s0DM28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48ve4kI8wA2
	z4x0Y4vE2Ix0cI8IcVAFwI0_Ar0_tr1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI0_Gr1j6F
	4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x0267AKxVW0oVCq
	3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0I7
	IYx2IY67AKxVWUJVWUGwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFVCjc4AY6r1j6r4U
	M4x0Y48IcxkI7VAKI48JM4x0x7Aq67IIx4CEVc8vx2IErcIFxwACI402YVCY1x02628vn2
	kIc2xKxwCY1x0262kKe7AKxVWUtVW8ZwCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7xkE
	bVWUJVW8JwC20s026c02F40E14v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67
	AF67kF1VAFwI0_Jw0_GFylIxkGc2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWUCVW8JwCI
	42IY6xIIjxv20xvEc7CjxVAFwI0_Gr1j6F4UJwCI42IY6xAIw20EY4v20xvaj40_Jr0_JF
	4lIxAIcVC2z280aVAFwI0_Jr0_Gr1lIxAIcVC2z280aVCY1x0267AKxVW8Jr0_Cr1UYxBI
	daVFxhVjvjDU0xZFpf9x0JUQFxUUUUUU=
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/

From: Yu Kuai <yukuai3@huawei.com>

The parameter is always set to 0 for now, following patches will use
this helper to write llbitmap to underlying disks, allow writing
dirty sectors instead of the whole page.

Signed-off-by: Yu Kuai <yukuai3@huawei.com>
---
 drivers/md/md-bitmap.c |  3 ++-
 drivers/md/md.c        | 13 +++++++------
 drivers/md/md.h        |  3 ++-
 3 files changed, 11 insertions(+), 8 deletions(-)

diff --git a/drivers/md/md-bitmap.c b/drivers/md/md-bitmap.c
index 4c5067783b7a..a5602cb5d756 100644
--- a/drivers/md/md-bitmap.c
+++ b/drivers/md/md-bitmap.c
@@ -468,7 +468,8 @@ static int __write_sb_page(struct md_rdev *rdev, struct bitmap *bitmap,
 			return -EINVAL;
 	}
 
-	md_super_write(mddev, rdev, sboff + ps, (int)min(size, bitmap_limit), page);
+	md_super_write(mddev, rdev, sboff + ps, (int)min(size, bitmap_limit),
+		       page, 0);
 	return 0;
 }
 
diff --git a/drivers/md/md.c b/drivers/md/md.c
index ba2b981b017c..4329ecfbe8ff 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -1037,7 +1037,8 @@ static void super_written(struct bio *bio)
 }
 
 void md_super_write(struct mddev *mddev, struct md_rdev *rdev,
-		   sector_t sector, int size, struct page *page)
+		   sector_t sector, int size, struct page *page,
+		   unsigned int offset)
 {
 	/* write first size bytes of page to sector of rdev
 	 * Increment mddev->pending_writes before returning
@@ -1062,7 +1063,7 @@ void md_super_write(struct mddev *mddev, struct md_rdev *rdev,
 	atomic_inc(&rdev->nr_pending);
 
 	bio->bi_iter.bi_sector = sector;
-	__bio_add_page(bio, page, size, 0);
+	__bio_add_page(bio, page, size, offset);
 	bio->bi_private = rdev;
 	bio->bi_end_io = super_written;
 
@@ -1673,7 +1674,7 @@ super_90_rdev_size_change(struct md_rdev *rdev, sector_t num_sectors)
 		num_sectors = (sector_t)(2ULL << 32) - 2;
 	do {
 		md_super_write(rdev->mddev, rdev, rdev->sb_start, rdev->sb_size,
-		       rdev->sb_page);
+			       rdev->sb_page, 0);
 	} while (md_super_wait(rdev->mddev) < 0);
 	return num_sectors;
 }
@@ -2322,7 +2323,7 @@ super_1_rdev_size_change(struct md_rdev *rdev, sector_t num_sectors)
 	sb->sb_csum = calc_sb_1_csum(sb);
 	do {
 		md_super_write(rdev->mddev, rdev, rdev->sb_start, rdev->sb_size,
-			       rdev->sb_page);
+			       rdev->sb_page, 0);
 	} while (md_super_wait(rdev->mddev) < 0);
 	return num_sectors;
 
@@ -2833,7 +2834,7 @@ void md_update_sb(struct mddev *mddev, int force_change)
 		if (!test_bit(Faulty, &rdev->flags)) {
 			md_super_write(mddev,rdev,
 				       rdev->sb_start, rdev->sb_size,
-				       rdev->sb_page);
+				       rdev->sb_page, 0);
 			pr_debug("md: (write) %pg's sb offset: %llu\n",
 				 rdev->bdev,
 				 (unsigned long long)rdev->sb_start);
@@ -2842,7 +2843,7 @@ void md_update_sb(struct mddev *mddev, int force_change)
 				md_super_write(mddev, rdev,
 					       rdev->badblocks.sector,
 					       rdev->badblocks.size << 9,
-					       rdev->bb_page);
+					       rdev->bb_page, 0);
 				rdev->badblocks.size = 0;
 			}
 
diff --git a/drivers/md/md.h b/drivers/md/md.h
index 135d95ba1ebb..99f6c7a92b48 100644
--- a/drivers/md/md.h
+++ b/drivers/md/md.h
@@ -890,7 +890,8 @@ void md_free_cloned_bio(struct bio *bio);
 
 extern bool __must_check md_flush_request(struct mddev *mddev, struct bio *bio);
 extern void md_super_write(struct mddev *mddev, struct md_rdev *rdev,
-			   sector_t sector, int size, struct page *page);
+			   sector_t sector, int size, struct page *page,
+			   unsigned int offset);
 extern int md_super_wait(struct mddev *mddev);
 extern int sync_page_io(struct md_rdev *rdev, sector_t sector, int size,
 		struct page *page, blk_opf_t opf, bool metadata_op);
-- 
2.39.2


Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6CA478F37
	for <dm-devel@lists.linux.dev>; Fri, 18 Apr 2025 01:16:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744939016; cv=none; b=lKtgnLcVu1JV7bZ5wPl5OvdtJGciyNsQ3IYwj0ZYw+MqKWdPMNH/oJUH3HGDDYIiiBMG8wR1sMvQuSMeqa2jaiwyc+KsylQVEpO1/T1BsdIIkETcJDTBdPIYSi6mfMJfca5VJSIlMH2Xu/VTIDbA6BWbAXqCIxEc3ubmSTmVUhQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744939016; c=relaxed/simple;
	bh=J5DTBmaMUMn88myuXmQXHIFEYhw/gvxfPajXf5dOIWk=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Xmld5EaQtHNAT6xF1XbkWgEQUFjbTpwsNGcL+Ynm5u+kr4C1m269+oViucpzPAPUQDfh1tB7J4eBM+G1aPon2+5b6TcysuDFQkAd4N0vbl4oPsxWBac57oT4zSLppt859oTnRaKybzdXl1fFxW/CHD2n376XhqUorPIKKGJcrQc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.216])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTP id 4Zdxfx2zlDz4f3m7J
	for <dm-devel@lists.linux.dev>; Fri, 18 Apr 2025 09:16:25 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id AEC081A19BF
	for <dm-devel@lists.linux.dev>; Fri, 18 Apr 2025 09:16:50 +0800 (CST)
Received: from huaweicloud.com (unknown [10.175.104.67])
	by APP4 (Coremail) with SMTP id gCh0CgDHK2D8pwFoK5w2Jw--.18201S9;
	Fri, 18 Apr 2025 09:16:50 +0800 (CST)
From: Yu Kuai <yukuai1@huaweicloud.com>
To: axboe@kernel.dk,
	xni@redhat.com,
	agk@redhat.com,
	snitzer@kernel.org,
	mpatocka@redhat.com,
	song@kernel.org,
	yukuai3@huawei.com,
	viro@zeniv.linux.org.uk,
	akpm@linux-foundation.org,
	nadav.amit@gmail.com,
	ubizjak@gmail.com,
	cl@linux.com
Cc: linux-block@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	dm-devel@lists.linux.dev,
	linux-raid@vger.kernel.org,
	yukuai1@huaweicloud.com,
	yi.zhang@huawei.com,
	yangerkun@huawei.com,
	johnny.chenyi@huawei.com
Subject: [PATCH v2 5/5] md: cleanup accounting for issued sync IO
Date: Fri, 18 Apr 2025 09:09:41 +0800
Message-Id: <20250418010941.667138-6-yukuai1@huaweicloud.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20250418010941.667138-1-yukuai1@huaweicloud.com>
References: <20250418010941.667138-1-yukuai1@huaweicloud.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgDHK2D8pwFoK5w2Jw--.18201S9
X-Coremail-Antispam: 1UD129KBjvJXoW3Ww13JrWrJF4fKFy8uw18uFg_yoW7Zw1Upa
	9xXa4xAFWUGrWF93WDJrWqk3ZY9347KrW7ArW7u393u3WFyryDZF1UJFWYqF98AFy5urW5
	Xa4kGan8CFs7tFUanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUmS14x267AKxVWrJVCq3wAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2048vs2IY020E87I2jVAFwI0_JF0E3s1l82xGYI
	kIc2x26xkF7I0E14v26ryj6s0DM28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48ve4kI8wA2
	z4x0Y4vE2Ix0cI8IcVAFwI0_tr0E3s1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI0_Gr1j6F
	4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x0267AKxVW0oVCq
	3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0I7
	IYx2IY67AKxVWUJVWUGwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFVCjc4AY6r1j6r4U
	M4x0Y48IcxkI7VAKI48JM4x0x7Aq67IIx4CEVc8vx2IErcIFxwACI402YVCY1x02628vn2
	kIc2xKxwCY1x0262kKe7AKxVW8ZVWrXwCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7xkE
	bVWUJVW8JwC20s026c02F40E14v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67
	AF67kF1VAFwI0_GFv_WrylIxkGc2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWUCVW8JwCI
	42IY6xIIjxv20xvEc7CjxVAFwI0_Gr1j6F4UJwCI42IY6xAIw20EY4v20xvaj40_Jr0_JF
	4lIxAIcVC2z280aVAFwI0_Jr0_Gr1lIxAIcVC2z280aVCY1x0267AKxVW8Jr0_Cr1UYxBI
	daVFxhVjvjDU0xZFpf9x0pRQJ5wUUUUU=
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/

From: Yu Kuai <yukuai3@huawei.com>

It's no longer used and can be removed, also remove the field
'gendisk->sync_io'.

Signed-off-by: Yu Kuai <yukuai3@huawei.com>
---
 drivers/md/md.h        | 11 -----------
 drivers/md/raid1.c     |  3 ---
 drivers/md/raid10.c    |  9 ---------
 drivers/md/raid5.c     |  8 --------
 include/linux/blkdev.h |  1 -
 5 files changed, 32 deletions(-)

diff --git a/drivers/md/md.h b/drivers/md/md.h
index 1d51c2405d3d..07b40a55ed5f 100644
--- a/drivers/md/md.h
+++ b/drivers/md/md.h
@@ -717,17 +717,6 @@ static inline int mddev_trylock(struct mddev *mddev)
 }
 extern void mddev_unlock(struct mddev *mddev);
 
-static inline void md_sync_acct(struct block_device *bdev, unsigned long nr_sectors)
-{
-	if (blk_queue_io_stat(bdev->bd_disk->queue))
-		atomic_add(nr_sectors, &bdev->bd_disk->sync_io);
-}
-
-static inline void md_sync_acct_bio(struct bio *bio, unsigned long nr_sectors)
-{
-	md_sync_acct(bio->bi_bdev, nr_sectors);
-}
-
 struct md_personality
 {
 	struct md_submodule_head head;
diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index de9bccbe7337..657d481525be 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -2382,7 +2382,6 @@ static void sync_request_write(struct mddev *mddev, struct r1bio *r1_bio)
 
 		wbio->bi_end_io = end_sync_write;
 		atomic_inc(&r1_bio->remaining);
-		md_sync_acct(conf->mirrors[i].rdev->bdev, bio_sectors(wbio));
 
 		submit_bio_noacct(wbio);
 	}
@@ -3055,7 +3054,6 @@ static sector_t raid1_sync_request(struct mddev *mddev, sector_t sector_nr,
 			bio = r1_bio->bios[i];
 			if (bio->bi_end_io == end_sync_read) {
 				read_targets--;
-				md_sync_acct_bio(bio, nr_sectors);
 				if (read_targets == 1)
 					bio->bi_opf &= ~MD_FAILFAST;
 				submit_bio_noacct(bio);
@@ -3064,7 +3062,6 @@ static sector_t raid1_sync_request(struct mddev *mddev, sector_t sector_nr,
 	} else {
 		atomic_set(&r1_bio->remaining, 1);
 		bio = r1_bio->bios[r1_bio->read_disk];
-		md_sync_acct_bio(bio, nr_sectors);
 		if (read_targets == 1)
 			bio->bi_opf &= ~MD_FAILFAST;
 		submit_bio_noacct(bio);
diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index ba32bac975b8..dce06bf65016 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -2426,7 +2426,6 @@ static void sync_request_write(struct mddev *mddev, struct r10bio *r10_bio)
 
 		atomic_inc(&conf->mirrors[d].rdev->nr_pending);
 		atomic_inc(&r10_bio->remaining);
-		md_sync_acct(conf->mirrors[d].rdev->bdev, bio_sectors(tbio));
 
 		if (test_bit(FailFast, &conf->mirrors[d].rdev->flags))
 			tbio->bi_opf |= MD_FAILFAST;
@@ -2448,8 +2447,6 @@ static void sync_request_write(struct mddev *mddev, struct r10bio *r10_bio)
 			bio_copy_data(tbio, fbio);
 		d = r10_bio->devs[i].devnum;
 		atomic_inc(&r10_bio->remaining);
-		md_sync_acct(conf->mirrors[d].replacement->bdev,
-			     bio_sectors(tbio));
 		submit_bio_noacct(tbio);
 	}
 
@@ -2583,13 +2580,10 @@ static void recovery_request_write(struct mddev *mddev, struct r10bio *r10_bio)
 	d = r10_bio->devs[1].devnum;
 	if (wbio->bi_end_io) {
 		atomic_inc(&conf->mirrors[d].rdev->nr_pending);
-		md_sync_acct(conf->mirrors[d].rdev->bdev, bio_sectors(wbio));
 		submit_bio_noacct(wbio);
 	}
 	if (wbio2) {
 		atomic_inc(&conf->mirrors[d].replacement->nr_pending);
-		md_sync_acct(conf->mirrors[d].replacement->bdev,
-			     bio_sectors(wbio2));
 		submit_bio_noacct(wbio2);
 	}
 }
@@ -3757,7 +3751,6 @@ static sector_t raid10_sync_request(struct mddev *mddev, sector_t sector_nr,
 		r10_bio->sectors = nr_sectors;
 
 		if (bio->bi_end_io == end_sync_read) {
-			md_sync_acct_bio(bio, nr_sectors);
 			bio->bi_status = 0;
 			submit_bio_noacct(bio);
 		}
@@ -4880,7 +4873,6 @@ static sector_t reshape_request(struct mddev *mddev, sector_t sector_nr,
 	r10_bio->sectors = nr_sectors;
 
 	/* Now submit the read */
-	md_sync_acct_bio(read_bio, r10_bio->sectors);
 	atomic_inc(&r10_bio->remaining);
 	read_bio->bi_next = NULL;
 	submit_bio_noacct(read_bio);
@@ -4940,7 +4932,6 @@ static void reshape_request_write(struct mddev *mddev, struct r10bio *r10_bio)
 			continue;
 
 		atomic_inc(&rdev->nr_pending);
-		md_sync_acct_bio(b, r10_bio->sectors);
 		atomic_inc(&r10_bio->remaining);
 		b->bi_next = NULL;
 		submit_bio_noacct(b);
diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index 6389383166c0..ca5b0e8ba707 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -1240,10 +1240,6 @@ static void ops_run_io(struct stripe_head *sh, struct stripe_head_state *s)
 		}
 
 		if (rdev) {
-			if (s->syncing || s->expanding || s->expanded
-			    || s->replacing)
-				md_sync_acct(rdev->bdev, RAID5_STRIPE_SECTORS(conf));
-
 			set_bit(STRIPE_IO_STARTED, &sh->state);
 
 			bio_init(bi, rdev->bdev, &dev->vec, 1, op | op_flags);
@@ -1300,10 +1296,6 @@ static void ops_run_io(struct stripe_head *sh, struct stripe_head_state *s)
 				submit_bio_noacct(bi);
 		}
 		if (rrdev) {
-			if (s->syncing || s->expanding || s->expanded
-			    || s->replacing)
-				md_sync_acct(rrdev->bdev, RAID5_STRIPE_SECTORS(conf));
-
 			set_bit(STRIPE_IO_STARTED, &sh->state);
 
 			bio_init(rbi, rrdev->bdev, &dev->rvec, 1, op | op_flags);
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index e39c45bc0a97..f3a625b00734 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -182,7 +182,6 @@ struct gendisk {
 	struct list_head slave_bdevs;
 #endif
 	struct timer_rand_state *random;
-	atomic_t sync_io;		/* RAID */
 	struct disk_events *ev;
 
 #ifdef CONFIG_BLK_DEV_ZONED
-- 
2.39.2


Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EFA9728135A
	for <dm-devel@lists.linux.dev>; Tue,  6 May 2025 12:57:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746536246; cv=none; b=XBwG2ZqGXMfIQsfQKqeV9rCzRL7gx+s2Wu4389Qw/vcs1dKS0AtqrBkmweoFIk52F8H6GoohENorMsbt1docYL90PgnknUkycU4OrPan8SB529CQ1QXV1xuos128vK+2sIZ9bLEYj+c0viNBBpFQ7ZJSJOhNW+GSH4gqamm0Yjk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746536246; c=relaxed/simple;
	bh=291YgrRrDX2L7RnUzNvKg6qJD/12zkD8b7D7rol9xPI=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=CwbbWpkNaXfZf/WXdCOEeS6T+RLyy7bz5b02Y84rg8u05iexKO6Ifx6fxQItLccoMy4Y/p94qwzX1rYfmr0FhAoOi0itz5jEfuULwvIHBZEpCgSHeOr2mS91U+eILj5wDazwq4aEGPgdKMfGt+BXisEMdbvP4KJcg/BlYwtKiis=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.93.142])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTPS id 4ZsJMP4Dn9zYQtLh
	for <dm-devel@lists.linux.dev>; Tue,  6 May 2025 20:57:21 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id EF82C1A0359
	for <dm-devel@lists.linux.dev>; Tue,  6 May 2025 20:57:20 +0800 (CST)
Received: from huaweicloud.com (unknown [10.175.104.67])
	by APP4 (Coremail) with SMTP id gCh0CgDXOl8pBxpoilNvLg--.37994S13;
	Tue, 06 May 2025 20:57:20 +0800 (CST)
From: Yu Kuai <yukuai1@huaweicloud.com>
To: axboe@kernel.dk,
	agk@redhat.com,
	song@kernel.org,
	hch@lst.de,
	john.g.garry@oracle.com,
	hare@suse.de,
	xni@redhat.com,
	pmenzel@molgen.mpg.de
Cc: linux-block@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	dm-devel@lists.linux.dev,
	linux-raid@vger.kernel.org,
	yukuai3@huawei.com,
	yukuai1@huaweicloud.com,
	yi.zhang@huawei.com,
	yangerkun@huawei.com,
	johnny.chenyi@huawei.com
Subject: [PATCH v3 9/9] md: clean up accounting for issued sync IO
Date: Tue,  6 May 2025 20:49:03 +0800
Message-Id: <20250506124903.2540268-10-yukuai1@huaweicloud.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20250506124903.2540268-1-yukuai1@huaweicloud.com>
References: <20250506124658.2537886-1-yukuai1@huaweicloud.com>
 <20250506124903.2540268-1-yukuai1@huaweicloud.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgDXOl8pBxpoilNvLg--.37994S13
X-Coremail-Antispam: 1UD129KBjvJXoW3Ww13JrWrJF4fKFW5AFyfXrb_yoW7ur47pa
	9xXa4xAFWUGrWF93WDJrWqk3ZY9347KrW7ArW7u393u3WFyryDZF1UJFWYqF98AFW5urW5
	Xa4kGan8CFZ7tFUanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUmS14x267AKxVWrJVCq3wAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2048vs2IY020E87I2jVAFwI0_JF0E3s1l82xGYI
	kIc2x26xkF7I0E14v26ryj6s0DM28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48ve4kI8wA2
	z4x0Y4vE2Ix0cI8IcVAFwI0_tr0E3s1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI0_Gr1j6F
	4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x0267AKxVW0oVCq
	3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0I7
	IYx2IY67AKxVWUGVWUXwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFVCjc4AY6r1j6r4U
	M4x0Y48IcxkI7VAKI48JM4x0x7Aq67IIx4CEVc8vx2IErcIFxwACI402YVCY1x02628vn2
	kIc2xKxwCY1x0262kKe7AKxVW8ZVWrXwCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7xkE
	bVWUJVW8JwC20s026c02F40E14v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67
	AF67kF1VAFwI0_GFv_WrylIxkGc2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVW8JVW5JwCI
	42IY6xIIjxv20xvEc7CjxVAFwI0_Gr1j6F4UJwCI42IY6xAIw20EY4v20xvaj40_Jr0_JF
	4lIxAIcVC2z280aVAFwI0_Gr0_Cr1lIxAIcVC2z280aVCY1x0267AKxVW8Jr0_Cr1UYxBI
	daVFxhVjvjDU0xZFpf9x0pRiF4iUUUUU=
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/

From: Yu Kuai <yukuai3@huawei.com>

It's no longer used and can be removed, also remove the field
'gendisk->sync_io'.

Signed-off-by: Yu Kuai <yukuai3@huawei.com>
Reviewed-by: Xiao Ni <xni@redhat.com>
---
 drivers/md/md.h        | 11 -----------
 drivers/md/raid1.c     |  3 ---
 drivers/md/raid10.c    |  9 ---------
 drivers/md/raid5.c     |  8 --------
 include/linux/blkdev.h |  1 -
 5 files changed, 32 deletions(-)

diff --git a/drivers/md/md.h b/drivers/md/md.h
index 1982f1f18627..d45a9e6ead80 100644
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
index 5ccb961ee2ae..d3fab37e4daa 100644
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


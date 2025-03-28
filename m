Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4914120E003
	for <dm-devel@lists.linux.dev>; Fri, 28 Mar 2025 06:14:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743142492; cv=none; b=nxt6NVt4pd6bFlewNjILqMqnq/IMkcGrzb5T/i6v6CjrlK3CAJeb7DMabMTV8gsMb2pjWVTGBAUTd57Z2Q6cRZwJxZDyPa4uBZZQ5WLYH9lbofLnGB3Sdfvej+mjteyjZMBKrPrR68wrCzWAyJcOebq2dL4KpAsu+Po45KUGVoo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743142492; c=relaxed/simple;
	bh=jElH2bACmPSv90mwLTKp6H7DfGNNfSvZhc4GzNHroqA=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=dh2gUzN2cd+04J5rndxuL5COws2W1ZU4c9edH4BN3sm0KsmSfzaXybNHCIbYyeQASvQPGYgCfs+FvRFbE4rxnBZ2YA7sm23TLg2xrN8kMDR/vx8AGSso7JOUpjSUtSeQyIeX9uVLI6kpCyD88s+m3S12cP3MIDgf7+bmYYTI7+Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=none smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.216])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTP id 4ZP9GY5mBdz4f3jkw
	for <dm-devel@lists.linux.dev>; Fri, 28 Mar 2025 14:14:29 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 6AA601A1343
	for <dm-devel@lists.linux.dev>; Fri, 28 Mar 2025 14:14:47 +0800 (CST)
Received: from huaweicloud.com (unknown [10.175.104.67])
	by APP4 (Coremail) with SMTP id gCh0CgDHK2BSPuZnfAUtHw--.25875S6;
	Fri, 28 Mar 2025 14:14:47 +0800 (CST)
From: Yu Kuai <yukuai1@huaweicloud.com>
To: hch@lst.de,
	xni@redhat.com,
	colyli@kernel.org,
	axboe@kernel.dk,
	agk@redhat.com,
	snitzer@kernel.org,
	mpatocka@redhat.com,
	song@kernel.org,
	yukuai3@huawei.com
Cc: linux-block@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	dm-devel@lists.linux.dev,
	linux-raid@vger.kernel.org,
	yukuai1@huaweicloud.com,
	yi.zhang@huawei.com,
	yangerkun@huawei.com
Subject: [PATCH RFC v2 02/14] md/md-bitmap: pass discard information to bitmap_{start, end}write
Date: Fri, 28 Mar 2025 14:08:41 +0800
Message-Id: <20250328060853.4124527-3-yukuai1@huaweicloud.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20250328060853.4124527-1-yukuai1@huaweicloud.com>
References: <20250328060853.4124527-1-yukuai1@huaweicloud.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgDHK2BSPuZnfAUtHw--.25875S6
X-Coremail-Antispam: 1UD129KBjvJXoWxCr1xAF4DKryfCFWkJr4DXFb_yoW5ZF45pF
	s2qFy3A3y3XFWYga47Z34q9Fyrt3srtrZrtFyxW3yrWFyrur98WF4rWa4jvF1DCFy3CFnI
	vw1YkryUuFy8trJanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUm014x267AKxVWrJVCq3wAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2048vs2IY020E87I2jVAFwI0_Jryl82xGYIkIc2
	x26xkF7I0E14v26ryj6s0DM28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48ve4kI8wA2z4x0
	Y4vE2Ix0cI8IcVAFwI0_tr0E3s1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI0_Gr1j6F4UJw
	A2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x0267AKxVW0oVCq3wAS
	0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0I7IYx2
	IY67AKxVWUJVWUGwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFVCjc4AY6r1j6r4UM4x0
	Y48IcxkI7VAKI48JM4x0x7Aq67IIx4CEVc8vx2IErcIFxwACI402YVCY1x02628vn2kIc2
	xKxwCY1x0262kKe7AKxVWUtVW8ZwCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7xkEbVWU
	JVW8JwC20s026c02F40E14v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67AF67
	kF1VAFwI0_GFv_WrylIxkGc2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWUJVWUCwCI42IY
	6xIIjxv20xvEc7CjxVAFwI0_Gr0_Cr1lIxAIcVCF04k26cxKx2IYs7xG6r1j6r1xMIIF0x
	vEx4A2jsIE14v26r1j6r4UMIIF0xvEx4A2jsIEc7CjxVAFwI0_Gr0_Gr1UYxBIdaVFxhVj
	vjDU0xZFpf9x0JUQXo7UUUUU=
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/

From: Yu Kuai <yukuai3@huawei.com>

It's not used for now, and prepare to handle discard for llbitmap in
following patches.

Signed-off-by: Yu Kuai <yukuai3@huawei.com>
---
 drivers/md/md-bitmap.c |  4 ++--
 drivers/md/md-bitmap.h |  4 ++--
 drivers/md/md.c        | 10 ++++++++--
 drivers/md/md.h        |  1 +
 4 files changed, 13 insertions(+), 6 deletions(-)

diff --git a/drivers/md/md-bitmap.c b/drivers/md/md-bitmap.c
index 733fbb886f67..0cef5c199d32 100644
--- a/drivers/md/md-bitmap.c
+++ b/drivers/md/md-bitmap.c
@@ -1667,7 +1667,7 @@ __acquires(bitmap->lock)
 }
 
 static int bitmap_startwrite(struct mddev *mddev, sector_t offset,
-			     unsigned long sectors)
+			     unsigned long sectors, bool is_discard)
 {
 	struct bitmap *bitmap = mddev->bitmap;
 
@@ -1722,7 +1722,7 @@ static int bitmap_startwrite(struct mddev *mddev, sector_t offset,
 }
 
 static void bitmap_endwrite(struct mddev *mddev, sector_t offset,
-			    unsigned long sectors)
+			    unsigned long sectors, bool is_discard)
 {
 	struct bitmap *bitmap = mddev->bitmap;
 
diff --git a/drivers/md/md-bitmap.h b/drivers/md/md-bitmap.h
index d3d50629af91..504d33d4980b 100644
--- a/drivers/md/md-bitmap.h
+++ b/drivers/md/md-bitmap.h
@@ -91,9 +91,9 @@ struct bitmap_operations {
 	void (*wait_behind_writes)(struct mddev *mddev);
 
 	int (*startwrite)(struct mddev *mddev, sector_t offset,
-			  unsigned long sectors);
+			  unsigned long sectors, bool is_discard);
 	void (*endwrite)(struct mddev *mddev, sector_t offset,
-			 unsigned long sectors);
+			 unsigned long sectors, bool is_discard);
 	bool (*start_sync)(struct mddev *mddev, sector_t offset,
 			   sector_t *blocks, bool degraded);
 	void (*end_sync)(struct mddev *mddev, sector_t offset, sector_t *blocks);
diff --git a/drivers/md/md.c b/drivers/md/md.c
index 4a9aa6879e98..c06c41e39609 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -8805,13 +8805,15 @@ static void md_bitmap_start(struct mddev *mddev,
 					   &md_io_clone->sectors);
 
 	mddev->bitmap_ops->startwrite(mddev, md_io_clone->offset,
-				      md_io_clone->sectors);
+				      md_io_clone->sectors,
+				      md_io_clone->is_discard);
 }
 
 static void md_bitmap_end(struct mddev *mddev, struct md_io_clone *md_io_clone)
 {
 	mddev->bitmap_ops->endwrite(mddev, md_io_clone->offset,
-				    md_io_clone->sectors);
+				    md_io_clone->sectors,
+				    md_io_clone->is_discard);
 }
 
 static void md_end_clone_io(struct bio *bio)
@@ -8850,6 +8852,10 @@ static void md_clone_bio(struct mddev *mddev, struct bio **bio)
 	if (bio_data_dir(*bio) == WRITE && md_bitmap_enabled(mddev)) {
 		md_io_clone->offset = (*bio)->bi_iter.bi_sector;
 		md_io_clone->sectors = bio_sectors(*bio);
+		if (unlikely(bio_op(*bio) == REQ_OP_DISCARD))
+			md_io_clone->is_discard = true;
+		else
+			md_io_clone->is_discard = false;
 		md_bitmap_start(mddev, md_io_clone);
 	}
 
diff --git a/drivers/md/md.h b/drivers/md/md.h
index 254bbab6f443..ad18ef9b5061 100644
--- a/drivers/md/md.h
+++ b/drivers/md/md.h
@@ -858,6 +858,7 @@ struct md_io_clone {
 	unsigned long	start_time;
 	sector_t	offset;
 	unsigned long	sectors;
+	bool		is_discard;
 	struct bio	bio_clone;
 };
 
-- 
2.39.2


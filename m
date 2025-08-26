Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8A022FC86C
	for <dm-devel@lists.linux.dev>; Tue, 26 Aug 2025 09:00:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756198843; cv=none; b=oPRN8RDzpz59/0+mA6KtlBqRxgRk5WhSaY7HxSaM0ycO5EYPI/oi7lrIdIomWaEdzaZxkUctIHIR34sZ0RvX1FbqgxRhta09oMEYef9LFTv7+luKthINkKiNX9ZSzA2zCd1UCvtxPcwk2c4J1Y7JEGFBBGPCCH1uIUWvpJLCnBY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756198843; c=relaxed/simple;
	bh=Nh8gEAZxuqapWVUC+DMBGPvwali2OBcjWkq0Rd4735w=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=WSeepZ2EXorU2uQoNd+TPgAX/Z7jepYRBuLGnH5NEKDeDTTFjrTYTlpWgPmw9f/4FZOyJNP3QvtgKMQ+P131GhayhfHEBom57MHeZpKs56eeaby/AYx27SneFPCHisRN9ycr7VN6eRtVvJ5Ijm2WHWvfSnwDoid+qbZ36uDBYjo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.93.142])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTPS id 4cB1pc6DjszYQv6w
	for <dm-devel@lists.linux.dev>; Tue, 26 Aug 2025 17:00:40 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 653731A12E6
	for <dm-devel@lists.linux.dev>; Tue, 26 Aug 2025 17:00:39 +0800 (CST)
Received: from huaweicloud.com (unknown [10.175.104.67])
	by APP4 (Coremail) with SMTP id gCh0CgAncIyyd61oPOlgAQ--.7793S7;
	Tue, 26 Aug 2025 17:00:39 +0800 (CST)
From: Yu Kuai <yukuai1@huaweicloud.com>
To: hch@infradead.org,
	corbet@lwn.net,
	agk@redhat.com,
	snitzer@kernel.org,
	mpatocka@redhat.com,
	song@kernel.org,
	xni@redhat.com,
	hare@suse.de,
	linan122@huawei.com,
	colyli@kernel.org
Cc: linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	dm-devel@lists.linux.dev,
	linux-raid@vger.kernel.org,
	yukuai3@huawei.com,
	yukuai1@huaweicloud.com,
	yi.zhang@huawei.com,
	yangerkun@huawei.com,
	johnny.chenyi@huawei.com
Subject: [PATCH v6 md-6.18 03/11] md/md-bitmap: support discard for bitmap ops
Date: Tue, 26 Aug 2025 16:51:57 +0800
Message-Id: <20250826085205.1061353-4-yukuai1@huaweicloud.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20250826085205.1061353-1-yukuai1@huaweicloud.com>
References: <20250826085205.1061353-1-yukuai1@huaweicloud.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgAncIyyd61oPOlgAQ--.7793S7
X-Coremail-Antispam: 1UD129KBjvJXoWxXrWfXryxuw13Gr17Ar45GFg_yoWrWw48pF
	ZFqFy3GrW5XF4Yga47Aa4q9Fyrt34ktrZrtFW7W345WFyIkF9xCF4Fg3Wqyw1DGFy3uFsx
	Zw4Fkr15Cr18XrJanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUmF14x267AKxVWrJVCq3wAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2048vs2IY020E87I2jVAFwI0_JrWl82xGYIkIc2
	x26xkF7I0E14v26ryj6s0DM28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48ve4kI8wA2z4x0
	Y4vE2Ix0cI8IcVAFwI0_tr0E3s1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI0_Gr1j6F4UJw
	A2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x0267AKxVW0oVCq3wAS
	0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0I7IYx2
	IY67AKxVWUGVWUXwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFVCjc4AY6r1j6r4UM4x0
	Y48IcxkI7VAKI48JM4x0x7Aq67IIx4CEVc8vx2IErcIFxwACI402YVCY1x02628vn2kIc2
	xKxwCY1x0262kKe7AKxVW8ZVWrXwCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7xkEbVWU
	JVW8JwC20s026c02F40E14v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67AF67
	kF1VAFwI0_GFv_WrylIxkGc2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWUJVWUCwCI42IY
	6xIIjxv20xvEc7CjxVAFwI0_Cr0_Gr1UMIIF0xvE42xK8VAvwI8IcIk0rVWUJVWUCwCI42
	IY6I8E87Iv67AKxVW8JVWxJwCI42IY6I8E87Iv6xkF7I0E14v26r4UJVWxJrUvcSsGvfC2
	KfnxnUUI43ZEXa7VUUbAw7UUUUU==
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/

From: Yu Kuai <yukuai3@huawei.com>

Use two new methods {start, end}_discard in bitmap_ops and a new field 'rw'
in struct md_io_clone to handle discard IO, prepare to support new md
bitmap.

Since all bitmap functions to handle write IO are the same, also add
typedef to make code cleaner.

Signed-off-by: Yu Kuai <yukuai3@huawei.com>
Reviewed-by: Xiao Ni <xni@redhat.com>
Reviewed-by: Hannes Reinecke <hare@suse.de>
Reviewed-by: Li Nan <linan122@huawei.com>
---
 drivers/md/md-bitmap.c |  3 +++
 drivers/md/md-bitmap.h | 12 ++++++++----
 drivers/md/md.c        | 15 +++++++++++----
 drivers/md/md.h        |  1 +
 4 files changed, 23 insertions(+), 8 deletions(-)

diff --git a/drivers/md/md-bitmap.c b/drivers/md/md-bitmap.c
index b157119de123..dc050ff94d5b 100644
--- a/drivers/md/md-bitmap.c
+++ b/drivers/md/md-bitmap.c
@@ -3005,6 +3005,9 @@ static struct bitmap_operations bitmap_ops = {
 
 	.start_write		= bitmap_start_write,
 	.end_write		= bitmap_end_write,
+	.start_discard		= bitmap_start_write,
+	.end_discard		= bitmap_end_write,
+
 	.start_sync		= bitmap_start_sync,
 	.end_sync		= bitmap_end_sync,
 	.cond_end_sync		= bitmap_cond_end_sync,
diff --git a/drivers/md/md-bitmap.h b/drivers/md/md-bitmap.h
index 42f91755a341..8616ced49077 100644
--- a/drivers/md/md-bitmap.h
+++ b/drivers/md/md-bitmap.h
@@ -61,6 +61,9 @@ struct md_bitmap_stats {
 	struct file	*file;
 };
 
+typedef void (md_bitmap_fn)(struct mddev *mddev, sector_t offset,
+			    unsigned long sectors);
+
 struct bitmap_operations {
 	struct md_submodule_head head;
 
@@ -81,10 +84,11 @@ struct bitmap_operations {
 	void (*end_behind_write)(struct mddev *mddev);
 	void (*wait_behind_writes)(struct mddev *mddev);
 
-	void (*start_write)(struct mddev *mddev, sector_t offset,
-			    unsigned long sectors);
-	void (*end_write)(struct mddev *mddev, sector_t offset,
-			  unsigned long sectors);
+	md_bitmap_fn *start_write;
+	md_bitmap_fn *end_write;
+	md_bitmap_fn *start_discard;
+	md_bitmap_fn *end_discard;
+
 	bool (*start_sync)(struct mddev *mddev, sector_t offset,
 			   sector_t *blocks, bool degraded);
 	void (*end_sync)(struct mddev *mddev, sector_t offset, sector_t *blocks);
diff --git a/drivers/md/md.c b/drivers/md/md.c
index 86cf97c0a77b..2e088196d42c 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -8933,18 +8933,24 @@ EXPORT_SYMBOL_GPL(md_submit_discard_bio);
 static void md_bitmap_start(struct mddev *mddev,
 			    struct md_io_clone *md_io_clone)
 {
+	md_bitmap_fn *fn = unlikely(md_io_clone->rw == STAT_DISCARD) ?
+			   mddev->bitmap_ops->start_discard :
+			   mddev->bitmap_ops->start_write;
+
 	if (mddev->pers->bitmap_sector)
 		mddev->pers->bitmap_sector(mddev, &md_io_clone->offset,
 					   &md_io_clone->sectors);
 
-	mddev->bitmap_ops->start_write(mddev, md_io_clone->offset,
-				       md_io_clone->sectors);
+	fn(mddev, md_io_clone->offset, md_io_clone->sectors);
 }
 
 static void md_bitmap_end(struct mddev *mddev, struct md_io_clone *md_io_clone)
 {
-	mddev->bitmap_ops->end_write(mddev, md_io_clone->offset,
-				     md_io_clone->sectors);
+	md_bitmap_fn *fn = unlikely(md_io_clone->rw == STAT_DISCARD) ?
+			   mddev->bitmap_ops->end_discard :
+			   mddev->bitmap_ops->end_write;
+
+	fn(mddev, md_io_clone->offset, md_io_clone->sectors);
 }
 
 static void md_end_clone_io(struct bio *bio)
@@ -8983,6 +8989,7 @@ static void md_clone_bio(struct mddev *mddev, struct bio **bio)
 	if (bio_data_dir(*bio) == WRITE && md_bitmap_enabled(mddev, false)) {
 		md_io_clone->offset = (*bio)->bi_iter.bi_sector;
 		md_io_clone->sectors = bio_sectors(*bio);
+		md_io_clone->rw = op_stat_group(bio_op(*bio));
 		md_bitmap_start(mddev, md_io_clone);
 	}
 
diff --git a/drivers/md/md.h b/drivers/md/md.h
index 5ef73109d14d..1b767b5320cf 100644
--- a/drivers/md/md.h
+++ b/drivers/md/md.h
@@ -872,6 +872,7 @@ struct md_io_clone {
 	unsigned long	start_time;
 	sector_t	offset;
 	unsigned long	sectors;
+	enum stat_group	rw;
 	struct bio	bio_clone;
 };
 
-- 
2.39.2


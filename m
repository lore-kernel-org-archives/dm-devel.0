Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6BB222156C
	for <dm-devel@lists.linux.dev>; Mon,  7 Jul 2025 01:32:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751851974; cv=none; b=cUAW5gvjcx8nkRa/scxYW+7dqftYYwBnjcmqeYpqgXf3KuiseVSiiYUo6+MLHUAS3PpU75KOO1s7cOLnacrLKlzwfCrp5ZkMT85Spt6SdZ6EBKio5DYjMd2tihCF90HB6hyKHVTmHuANaw05Qiy1hgiWgvOzou11H9I9oiivCtU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751851974; c=relaxed/simple;
	bh=Sdiy6j0WC+m4Q6ASAdQP14zPihhovqD7Xz7GFbD7pq8=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=YETsEgnY5lAULu6+Mg2Az9XqVRq4F2WMZkArSVQPfTv/nt73rX7A8jOepFSR6Qzw3U9x8GLAxivIVUVfX5DvsixVo6XCGcYvwgPU6Fb5UyB+pveSv2lacsNrH30n3Y93VprTGLU47hRsLP2YPqEBCd/gjB4fYdfpTEhmkCbJ5JQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.235])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTPS id 4bb6Dt5SfPzKHMk7
	for <dm-devel@lists.linux.dev>; Mon,  7 Jul 2025 09:32:46 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.252])
	by mail.maildlp.com (Postfix) with ESMTP id 392F31A0FED
	for <dm-devel@lists.linux.dev>; Mon,  7 Jul 2025 09:32:45 +0800 (CST)
Received: from huaweicloud.com (unknown [10.175.104.67])
	by APP3 (Coremail) with SMTP id _Ch0CgDnSCazI2to_nSRAw--.35890S18;
	Mon, 07 Jul 2025 09:32:45 +0800 (CST)
From: Yu Kuai <yukuai1@huaweicloud.com>
To: agk@redhat.com,
	snitzer@kernel.org,
	mpatocka@redhat.com,
	song@kernel.org,
	yukuai3@huawei.com
Cc: dm-devel@lists.linux.dev,
	linux-raid@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	yukuai1@huaweicloud.com,
	yi.zhang@huawei.com,
	yangerkun@huawei.com,
	johnny.chenyi@huawei.com
Subject: [PATCH v5 14/15] md: check before referencing mddev->bitmap_ops
Date: Mon,  7 Jul 2025 09:27:10 +0800
Message-Id: <20250707012711.376844-15-yukuai1@huaweicloud.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20250707012711.376844-1-yukuai1@huaweicloud.com>
References: <20250707012711.376844-1-yukuai1@huaweicloud.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:_Ch0CgDnSCazI2to_nSRAw--.35890S18
X-Coremail-Antispam: 1UD129KBjvJXoW3Jr4DGryUXFyUWw4xKw4Durg_yoW3AFWfp3
	yxt3Z8KrW5XrWfWw47AFyv9F1rXwn7tr9rtryxXw13Gr1rJrnxWF4rWFy8tr15C348AFn8
	Zw4rta1rCr17WF7anT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUmS14x267AKxVWrJVCq3wAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2048vs2IY020E87I2jVAFwI0_JF0E3s1l82xGYI
	kIc2x26xkF7I0E14v26ryj6s0DM28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48ve4kI8wA2
	z4x0Y4vE2Ix0cI8IcVAFwI0_tr0E3s1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI0_Gr1j6F
	4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x0267AKxVW0oVCq
	3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0I7
	IYx2IY67AKxVWUJVWUGwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFVCjc4AY6r1j6r4U
	M4x0Y48IcxkI7VAKI48JM4x0x7Aq67IIx4CEVc8vx2IErcIFxwACI402YVCY1x02628vn2
	kIc2xKxwCY1x0262kKe7AKxVWUtVW8ZwCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7xkE
	bVWUJVW8JwC20s026c02F40E14v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67
	AF67kF1VAFwI0_Jw0_GFylIxkGc2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVW8JVW5JwCI
	42IY6xIIjxv20xvEc7CjxVAFwI0_Gr1j6F4UJwCI42IY6xAIw20EY4v20xvaj40_Jr0_JF
	4lIxAIcVC2z280aVAFwI0_Gr0_Cr1lIxAIcVC2z280aVCY1x0267AKxVW8Jr0_Cr1UYxBI
	daVFxhVjvjDU0xZFpf9x0JUQFxUUUUUU=
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/

From: Yu Kuai <yukuai3@huawei.com>

Prepare to introduce CONFIG_MD_BITMAP.

Signed-off-by: Yu Kuai <yukuai3@huawei.com>
---
 drivers/md/md.c | 68 ++++++++++++++++++++++++++++++++++---------------
 1 file changed, 48 insertions(+), 20 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 7ed95e5e43fc..2f7e8d77e7ef 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -1346,6 +1346,9 @@ static u64 md_bitmap_events_cleared(struct mddev *mddev)
 	struct md_bitmap_stats stats;
 	int err;
 
+	if (!md_bitmap_enabled(mddev, false))
+		return 0;
+
 	err = mddev->bitmap_ops->get_stats(mddev->bitmap, &stats);
 	if (err)
 		return 0;
@@ -2303,13 +2306,15 @@ static int
 super_1_allow_new_offset(struct md_rdev *rdev,
 			 unsigned long long new_offset)
 {
+	struct mddev *mddev = rdev->mddev;
+
 	/* All necessary checks on new >= old have been done */
 	if (new_offset >= rdev->data_offset)
 		return 1;
 
 	/* with 1.0 metadata, there is no metadata to tread on
 	 * so we can always move back */
-	if (rdev->mddev->minor_version == 0)
+	if (mddev->minor_version == 0)
 		return 1;
 
 	/* otherwise we must be sure not to step on
@@ -2321,8 +2326,7 @@ super_1_allow_new_offset(struct md_rdev *rdev,
 	if (rdev->sb_start + (32+4)*2 > new_offset)
 		return 0;
 
-	if (!rdev->mddev->bitmap_info.file) {
-		struct mddev *mddev = rdev->mddev;
+	if (md_bitmap_registered(mddev) && !mddev->bitmap_info.file) {
 		struct md_bitmap_stats stats;
 		int err;
 
@@ -2794,7 +2798,8 @@ void md_update_sb(struct mddev *mddev, int force_change)
 
 	mddev_add_trace_msg(mddev, "md md_update_sb");
 rewrite:
-	mddev->bitmap_ops->update_sb(mddev->bitmap);
+	if (md_bitmap_enabled(mddev, false))
+		mddev->bitmap_ops->update_sb(mddev->bitmap);
 	rdev_for_each(rdev, mddev) {
 		if (rdev->sb_loaded != 1)
 			continue; /* no noise on spare devices */
@@ -4670,6 +4675,9 @@ bitmap_store(struct mddev *mddev, const char *buf, size_t len)
 	unsigned long chunk, end_chunk;
 	int err;
 
+	if (!md_bitmap_enabled(mddev, false))
+		return len;
+
 	err = mddev_lock(mddev);
 	if (err)
 		return err;
@@ -5995,7 +6003,7 @@ struct mddev *md_alloc(dev_t dev, char *name)
 		return ERR_PTR(error);
 	}
 
-	if (mddev->bitmap_ops && mddev->bitmap_ops->group)
+	if (md_bitmap_registered(mddev) && mddev->bitmap_ops->group)
 		if (sysfs_create_group(&mddev->kobj, mddev->bitmap_ops->group))
 			pr_warn("md: cannot register extra bitmap attributes for %s\n",
 				mdname(mddev));
@@ -6239,7 +6247,7 @@ int md_run(struct mddev *mddev)
 			(unsigned long long)pers->size(mddev, 0, 0) / 2);
 		err = -EINVAL;
 	}
-	if (err == 0 && pers->sync_request &&
+	if (err == 0 && pers->sync_request && md_bitmap_registered(mddev) &&
 	    (mddev->bitmap_info.file || mddev->bitmap_info.offset)) {
 		err = mddev->bitmap_ops->create(mddev);
 		if (err)
@@ -6314,7 +6322,8 @@ int md_run(struct mddev *mddev)
 		pers->free(mddev, mddev->private);
 	mddev->private = NULL;
 	put_pers(pers);
-	mddev->bitmap_ops->destroy(mddev);
+	if (md_bitmap_registered(mddev))
+		mddev->bitmap_ops->destroy(mddev);
 abort:
 	bioset_exit(&mddev->io_clone_set);
 exit_sync_set:
@@ -6334,10 +6343,12 @@ int do_md_run(struct mddev *mddev)
 	if (err)
 		goto out;
 
-	err = mddev->bitmap_ops->load(mddev);
-	if (err) {
-		mddev->bitmap_ops->destroy(mddev);
-		goto out;
+	if (md_bitmap_registered(mddev)) {
+		err = mddev->bitmap_ops->load(mddev);
+		if (err) {
+			mddev->bitmap_ops->destroy(mddev);
+			goto out;
+		}
 	}
 
 	if (mddev_is_clustered(mddev))
@@ -6476,7 +6487,8 @@ static void __md_stop_writes(struct mddev *mddev)
 		mddev->pers->quiesce(mddev, 0);
 	}
 
-	mddev->bitmap_ops->flush(mddev);
+	if (md_bitmap_enabled(mddev, true))
+		mddev->bitmap_ops->flush(mddev);
 
 	if (md_is_rdwr(mddev) &&
 	    ((!mddev->in_sync && !mddev_is_clustered(mddev)) ||
@@ -6503,7 +6515,8 @@ EXPORT_SYMBOL_GPL(md_stop_writes);
 
 static void mddev_detach(struct mddev *mddev)
 {
-	mddev->bitmap_ops->wait_behind_writes(mddev);
+	if (md_bitmap_enabled(mddev, false))
+		mddev->bitmap_ops->wait_behind_writes(mddev);
 	if (mddev->pers && mddev->pers->quiesce && !is_md_suspended(mddev)) {
 		mddev->pers->quiesce(mddev, 1);
 		mddev->pers->quiesce(mddev, 0);
@@ -6519,7 +6532,8 @@ static void __md_stop(struct mddev *mddev)
 {
 	struct md_personality *pers = mddev->pers;
 
-	mddev->bitmap_ops->destroy(mddev);
+	if (md_bitmap_registered(mddev))
+		mddev->bitmap_ops->destroy(mddev);
 	mddev_detach(mddev);
 	spin_lock(&mddev->lock);
 	mddev->pers = NULL;
@@ -7236,6 +7250,9 @@ static int set_bitmap_file(struct mddev *mddev, int fd)
 {
 	int err = 0;
 
+	if (!md_bitmap_registered(mddev))
+		return -EINVAL;
+
 	if (mddev->pers) {
 		if (!mddev->pers->quiesce || !mddev->thread)
 			return -EBUSY;
@@ -7586,6 +7603,14 @@ static int update_array_info(struct mddev *mddev, mdu_array_info_t *info)
 		rv = update_raid_disks(mddev, info->raid_disks);
 
 	if ((state ^ info->state) & (1<<MD_SB_BITMAP_PRESENT)) {
+		/*
+		 * Metadata says bitmap existed, however kernel can't find
+		 * registered bitmap.
+		 */
+		if (WARN_ON_ONCE(!md_bitmap_registered(mddev))) {
+			rv = -EINVAL;
+			goto err;
+		}
 		if (mddev->pers->quiesce == NULL || mddev->thread == NULL) {
 			rv = -EINVAL;
 			goto err;
@@ -8420,6 +8445,9 @@ static void md_bitmap_status(struct seq_file *seq, struct mddev *mddev)
 	unsigned long chunk_kb;
 	int err;
 
+	if (!md_bitmap_enabled(mddev, false))
+		return;
+
 	err = mddev->bitmap_ops->get_stats(mddev->bitmap, &stats);
 	if (err)
 		return;
@@ -8822,7 +8850,7 @@ static void md_end_clone_io(struct bio *bio)
 	struct bio *orig_bio = md_io_clone->orig_bio;
 	struct mddev *mddev = md_io_clone->mddev;
 
-	if (bio_data_dir(orig_bio) == WRITE && mddev->bitmap)
+	if (bio_data_dir(orig_bio) == WRITE && md_bitmap_enabled(mddev, false))
 		md_bitmap_end(mddev, md_io_clone);
 
 	if (bio->bi_status && !orig_bio->bi_status)
@@ -8849,7 +8877,7 @@ static void md_clone_bio(struct mddev *mddev, struct bio **bio)
 	if (blk_queue_io_stat(bdev->bd_disk->queue))
 		md_io_clone->start_time = bio_start_io_acct(*bio);
 
-	if (bio_data_dir(*bio) == WRITE && mddev->bitmap) {
+	if (bio_data_dir(*bio) == WRITE && md_bitmap_enabled(mddev, false)) {
 		md_io_clone->offset = (*bio)->bi_iter.bi_sector;
 		md_io_clone->sectors = bio_sectors(*bio);
 		md_bitmap_start(mddev, md_io_clone);
@@ -8873,7 +8901,7 @@ void md_free_cloned_bio(struct bio *bio)
 	struct bio *orig_bio = md_io_clone->orig_bio;
 	struct mddev *mddev = md_io_clone->mddev;
 
-	if (bio_data_dir(orig_bio) == WRITE && mddev->bitmap)
+	if (bio_data_dir(orig_bio) == WRITE && md_bitmap_enabled(mddev, false))
 		md_bitmap_end(mddev, md_io_clone);
 
 	if (bio->bi_status && !orig_bio->bi_status)
@@ -9598,7 +9626,7 @@ static void md_start_sync(struct work_struct *ws)
 	 * We are adding a device or devices to an array which has the bitmap
 	 * stored on all devices. So make sure all bitmap pages get written.
 	 */
-	if (spares)
+	if (spares && md_bitmap_enabled(mddev, true))
 		mddev->bitmap_ops->write_all(mddev);
 
 	name = test_bit(MD_RECOVERY_RESHAPE, &mddev->recovery) ?
@@ -9686,7 +9714,7 @@ static void unregister_sync_thread(struct mddev *mddev)
  */
 void md_check_recovery(struct mddev *mddev)
 {
-	if (mddev->bitmap)
+	if (md_bitmap_enabled(mddev, false))
 		mddev->bitmap_ops->daemon_work(mddev);
 
 	if (signal_pending(current)) {
@@ -10066,7 +10094,7 @@ static void check_sb_changes(struct mddev *mddev, struct md_rdev *rdev)
 		ret = mddev->pers->resize(mddev, le64_to_cpu(sb->size));
 		if (ret)
 			pr_info("md-cluster: resize failed\n");
-		else
+		else if (md_bitmap_enabled(mddev, false))
 			mddev->bitmap_ops->update_sb(mddev->bitmap);
 	}
 
-- 
2.39.2


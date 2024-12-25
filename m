Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C90B1BD51B
	for <dm-devel@lists.linux.dev>; Wed, 25 Dec 2024 11:20:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735125602; cv=none; b=OA4QfoFDnlFcyzdvcpNBuYx+IiSpNktGqy5l7N9ege2Z6oXmI3ouVsNa5X+cwAx5WLIRmGaembrB+opRMSg0PRWXYhSEuTfVt3sAJNGGbVYaG6I4rvMFQwHVLE/UkLy+jLfJlidvZVGSOi9HQgCxvxGG9IjWnFqpFUv26uVjL14=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735125602; c=relaxed/simple;
	bh=gefci5RUbhyRQdMQtAwbzsb57VS7SAIMTvF2DwlLAK0=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=aIdyPfIyHT0x551ClO+ylLRuHTgDRHG+VbYscSyoSUUiuOaCCH7klDRRRGv89sW+CYLPpCnezxDIsjw7Ey4PhZjDcOFsCEMxPpsFIsWuKNMrP66LDAIOCg6cfQUit67IKgwkRW6HrBeDZKS8PI73NBC70IpPGck8F6x84Mchgg4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.93.142])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTP id 4YJ8RX1pbjz4f3kvt
	for <dm-devel@lists.linux.dev>; Wed, 25 Dec 2024 19:19:36 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 116CC1A0359
	for <dm-devel@lists.linux.dev>; Wed, 25 Dec 2024 19:19:57 +0800 (CST)
Received: from huaweicloud.com (unknown [10.175.104.67])
	by APP4 (Coremail) with SMTP id gCh0CgAnT4NV6mtntXlgFg--.39006S15;
	Wed, 25 Dec 2024 19:19:56 +0800 (CST)
From: Yu Kuai <yukuai1@huaweicloud.com>
To: xni@redhat.com,
	agk@redhat.com,
	snitzer@kernel.org,
	mpatocka@redhat.com,
	song@kernel.org,
	yukuai3@huawei.com
Cc: dm-devel@lists.linux.dev,
	linux-raid@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	yukuai1@huaweicloud.com,
	yi.zhang@huawei.com,
	yangerkun@huawei.com
Subject: [PATCH md-6.14 11/13] md: check before deferencing mddev->bitmap_ops
Date: Wed, 25 Dec 2024 19:15:44 +0800
Message-Id: <20241225111546.1833250-12-yukuai1@huaweicloud.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20241225111546.1833250-1-yukuai1@huaweicloud.com>
References: <20241225111546.1833250-1-yukuai1@huaweicloud.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgAnT4NV6mtntXlgFg--.39006S15
X-Coremail-Antispam: 1UD129KBjvJXoW3Jr4DGr4DJw18AFW8XF4xJFb_yoW3AryDp3
	yxtas5KrW5XrWfWw47ZFyv9F1rXwn7tr97tryxXr13Grn5JrnxWF4rWFy5t345C348CFs8
	Zw4rta15Gr17WF7anT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
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
	AF67kF1VAFwI0_Jw0_GFylIxkGc2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVW8JVW5JwCI
	42IY6xIIjxv20xvEc7CjxVAFwI0_Gr1j6F4UJwCI42IY6xAIw20EY4v20xvaj40_Jr0_JF
	4lIxAIcVC2z280aVAFwI0_Gr0_Cr1lIxAIcVC2z280aVCY1x0267AKxVW8Jr0_Cr1UYxBI
	daVFxhVjvjDU0xZFpf9x0JUQFxUUUUUU=
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/

From: Yu Kuai <yukuai3@huawei.com>

Prepare to support building bitmap as kernel module.

Signed-off-by: Yu Kuai <yukuai3@huawei.com>
---
 drivers/md/md.c | 68 ++++++++++++++++++++++++++++++++++---------------
 1 file changed, 48 insertions(+), 20 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index b3a9f749366b..4170ef31a273 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -1292,6 +1292,9 @@ static u64 md_bitmap_events_cleared(struct mddev *mddev)
 	struct md_bitmap_stats stats;
 	int err;
 
+	if (!md_bitmap_enabled(mddev))
+		return 0;
+
 	err = mddev->bitmap_ops->get_stats(mddev->bitmap, &stats);
 	if (err)
 		return 0;
@@ -2249,13 +2252,15 @@ static int
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
@@ -2267,8 +2272,7 @@ super_1_allow_new_offset(struct md_rdev *rdev,
 	if (rdev->sb_start + (32+4)*2 > new_offset)
 		return 0;
 
-	if (!rdev->mddev->bitmap_info.file) {
-		struct mddev *mddev = rdev->mddev;
+	if (md_bitmap_registered(mddev) && !mddev->bitmap_info.file) {
 		struct md_bitmap_stats stats;
 		int err;
 
@@ -2753,7 +2757,8 @@ void md_update_sb(struct mddev *mddev, int force_change)
 
 	mddev_add_trace_msg(mddev, "md md_update_sb");
 rewrite:
-	mddev->bitmap_ops->update_sb(mddev->bitmap);
+	if (md_bitmap_enabled(mddev))
+		mddev->bitmap_ops->update_sb(mddev->bitmap);
 	rdev_for_each(rdev, mddev) {
 		if (rdev->sb_loaded != 1)
 			continue; /* no noise on spare devices */
@@ -4633,6 +4638,9 @@ bitmap_store(struct mddev *mddev, const char *buf, size_t len)
 	unsigned long chunk, end_chunk;
 	int err;
 
+	if (!md_bitmap_enabled(mddev))
+		return len;
+
 	err = mddev_lock(mddev);
 	if (err)
 		return err;
@@ -5923,7 +5931,7 @@ struct mddev *md_alloc(dev_t dev, char *name)
 		return ERR_PTR(error);
 	}
 
-	if (mddev->bitmap_ops && mddev->bitmap_ops->group)
+	if (md_bitmap_registered(mddev) && mddev->bitmap_ops->group)
 		if (sysfs_create_group(&mddev->kobj, mddev->bitmap_ops->group))
 			pr_warn("md: cannot register extra bitmap attributes for %s\n",
 				mdname(mddev));
@@ -6176,7 +6184,7 @@ int md_run(struct mddev *mddev)
 			(unsigned long long)pers->size(mddev, 0, 0) / 2);
 		err = -EINVAL;
 	}
-	if (err == 0 && pers->sync_request &&
+	if (err == 0 && pers->sync_request && md_bitmap_registered(mddev) &&
 	    (mddev->bitmap_info.file || mddev->bitmap_info.offset)) {
 		err = mddev->bitmap_ops->create(mddev, -1);
 		if (err)
@@ -6251,7 +6259,8 @@ int md_run(struct mddev *mddev)
 		pers->free(mddev, mddev->private);
 	mddev->private = NULL;
 	module_put(pers->owner);
-	mddev->bitmap_ops->destroy(mddev);
+	if (md_bitmap_registered(mddev))
+		mddev->bitmap_ops->destroy(mddev);
 abort:
 	bioset_exit(&mddev->io_clone_set);
 exit_sync_set:
@@ -6271,10 +6280,12 @@ int do_md_run(struct mddev *mddev)
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
@@ -6418,7 +6429,8 @@ static void __md_stop_writes(struct mddev *mddev)
 		mddev->pers->quiesce(mddev, 0);
 	}
 
-	mddev->bitmap_ops->flush(mddev);
+	if (md_bitmap_enabled(mddev))
+		mddev->bitmap_ops->flush(mddev);
 
 	if (md_is_rdwr(mddev) &&
 	    ((!mddev->in_sync && !mddev_is_clustered(mddev)) ||
@@ -6445,7 +6457,8 @@ EXPORT_SYMBOL_GPL(md_stop_writes);
 
 static void mddev_detach(struct mddev *mddev)
 {
-	mddev->bitmap_ops->wait_behind_writes(mddev);
+	if (md_bitmap_enabled(mddev))
+		mddev->bitmap_ops->wait_behind_writes(mddev);
 	if (mddev->pers && mddev->pers->quiesce && !is_md_suspended(mddev)) {
 		mddev->pers->quiesce(mddev, 1);
 		mddev->pers->quiesce(mddev, 0);
@@ -6461,7 +6474,8 @@ static void __md_stop(struct mddev *mddev)
 {
 	struct md_personality *pers = mddev->pers;
 
-	mddev->bitmap_ops->destroy(mddev);
+	if (md_bitmap_registered(mddev))
+		mddev->bitmap_ops->destroy(mddev);
 	mddev_detach(mddev);
 	spin_lock(&mddev->lock);
 	mddev->pers = NULL;
@@ -7183,6 +7197,9 @@ static int set_bitmap_file(struct mddev *mddev, int fd)
 {
 	int err = 0;
 
+	if (!md_bitmap_registered(mddev))
+		return -EINVAL;
+
 	if (mddev->pers) {
 		if (!mddev->pers->quiesce || !mddev->thread)
 			return -EBUSY;
@@ -7511,6 +7528,14 @@ static int update_array_info(struct mddev *mddev, mdu_array_info_t *info)
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
@@ -8342,6 +8367,9 @@ static void md_bitmap_status(struct seq_file *seq, struct mddev *mddev)
 	unsigned long chunk_kb;
 	int err;
 
+	if (!md_bitmap_enabled(mddev))
+		return;
+
 	err = mddev->bitmap_ops->get_stats(mddev->bitmap, &stats);
 	if (err)
 		return;
@@ -8772,7 +8800,7 @@ static void md_end_clone_io(struct bio *bio)
 	struct bio *orig_bio = md_io_clone->orig_bio;
 	struct mddev *mddev = md_io_clone->mddev;
 
-	if (bio_data_dir(orig_bio) == WRITE && mddev->bitmap)
+	if (bio_data_dir(orig_bio) == WRITE && md_bitmap_enabled(mddev))
 		md_bitmap_end(mddev, md_io_clone);
 
 	if (bio->bi_status && !orig_bio->bi_status)
@@ -8799,7 +8827,7 @@ static void md_clone_bio(struct mddev *mddev, struct bio **bio)
 	if (blk_queue_io_stat(bdev->bd_disk->queue))
 		md_io_clone->start_time = bio_start_io_acct(*bio);
 
-	if (bio_data_dir(*bio) == WRITE && mddev->bitmap) {
+	if (bio_data_dir(*bio) == WRITE && md_bitmap_enabled(mddev)) {
 		md_io_clone->offset = (*bio)->bi_iter.bi_sector;
 		md_io_clone->sectors = bio_sectors(*bio);
 		md_bitmap_start(mddev, md_io_clone);
@@ -8823,7 +8851,7 @@ void md_free_cloned_bio(struct bio *bio)
 	struct bio *orig_bio = md_io_clone->orig_bio;
 	struct mddev *mddev = md_io_clone->mddev;
 
-	if (bio_data_dir(orig_bio) == WRITE && mddev->bitmap)
+	if (bio_data_dir(orig_bio) == WRITE && md_bitmap_enabled(mddev))
 		md_bitmap_end(mddev, md_io_clone);
 
 	if (bio->bi_status && !orig_bio->bi_status)
@@ -9530,7 +9558,7 @@ static void md_start_sync(struct work_struct *ws)
 	 * We are adding a device or devices to an array which has the bitmap
 	 * stored on all devices. So make sure all bitmap pages get written.
 	 */
-	if (spares)
+	if (spares && md_bitmap_enabled(mddev))
 		mddev->bitmap_ops->write_all(mddev);
 
 	name = test_bit(MD_RECOVERY_RESHAPE, &mddev->recovery) ?
@@ -9618,7 +9646,7 @@ static void unregister_sync_thread(struct mddev *mddev)
  */
 void md_check_recovery(struct mddev *mddev)
 {
-	if (mddev->bitmap)
+	if (md_bitmap_enabled(mddev))
 		mddev->bitmap_ops->daemon_work(mddev);
 
 	if (signal_pending(current)) {
@@ -9998,7 +10026,7 @@ static void check_sb_changes(struct mddev *mddev, struct md_rdev *rdev)
 		ret = mddev->pers->resize(mddev, le64_to_cpu(sb->size));
 		if (ret)
 			pr_info("md-cluster: resize failed\n");
-		else
+		else if (md_bitmap_enabled(mddev))
 			mddev->bitmap_ops->update_sb(mddev->bitmap);
 	}
 
-- 
2.39.2


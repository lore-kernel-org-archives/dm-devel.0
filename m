Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05CD53009CD
	for <dm-devel@lists.linux.dev>; Tue, 26 Aug 2025 09:00:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756198849; cv=none; b=hKWqzSr4Qy6k20XYP5w6mlb9qLIS/fOFf2KkuJB+sqsT6m9F+37pKtEb7/NIBFaPQRMvHn1Q/CeikS5pqUgUbsX4BzQ+UEu+a/qQ4A/X8NStdparfoTZemqy+TDhDf+m3Z47WISAoSYXsRft9VnEEtLeBPE9WBPXKFlfXTK1ezE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756198849; c=relaxed/simple;
	bh=xZZnpBSVoXz+dHyRlLf67QhW0eoF9zkzKtaJSK7ZTGk=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Y/Jax2hckVnrl7kVxxHuK/Likg9C2xUQ+PsFCWNN7vNJZBcfR32Pj84zPn7D+tbsoi4yCmby6iN1LxNZYtDa8t6kBtqy4B1UIG502FHeRFOEwjerWM826CzdfaJrQzK6irHnou7G9Md4qxFpZ6vtSa7XVTBz2v2ZCxXGngNLsYs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.235])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTPS id 4cB1pf6qBvzYQv8p
	for <dm-devel@lists.linux.dev>; Tue, 26 Aug 2025 17:00:42 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 7948A1A0D57
	for <dm-devel@lists.linux.dev>; Tue, 26 Aug 2025 17:00:41 +0800 (CST)
Received: from huaweicloud.com (unknown [10.175.104.67])
	by APP4 (Coremail) with SMTP id gCh0CgAncIyyd61oPOlgAQ--.7793S10;
	Tue, 26 Aug 2025 17:00:41 +0800 (CST)
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
Subject: [PATCH v6 md-6.18 06/11] md/md-bitmap: delay registration of bitmap_ops until creating bitmap
Date: Tue, 26 Aug 2025 16:52:00 +0800
Message-Id: <20250826085205.1061353-7-yukuai1@huaweicloud.com>
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
X-CM-TRANSID:gCh0CgAncIyyd61oPOlgAQ--.7793S10
X-Coremail-Antispam: 1UD129KBjvJXoW3Xw1fAr4xJr17Jw4UCw4Uurg_yoW3WFy5p3
	yft3Z5Kr4rJrZIgw47XFyv9F1rXFn7tr9xtryxXw15Grn7JrnxXa1rWF1Utw18Ga48ZFs8
	Zw45tr48Gr13uF7anT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
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
	AF67kF1VAFwI0_GFv_WrylIxkGc2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWUCVW8JwCI
	42IY6xIIjxv20xvEc7CjxVAFwI0_Gr1j6F4UJwCI42IY6xAIw20EY4v20xvaj40_Jr0_JF
	4lIxAIcVC2z280aVAFwI0_Gr0_Cr1lIxAIcVC2z280aVCY1x0267AKxVW8Jr0_Cr1UYxBI
	daVFxhVjvjDU0xZFpf9x0pRiF4iUUUUU=
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/

From: Yu Kuai <yukuai3@huawei.com>

Currently bitmap_ops is registered while allocating mddev, this is fine
when there is only one bitmap_ops.

Delay setting bitmap_ops until creating bitmap, so that user can choose
which bitmap to use before running the array.

Link: https://lore.kernel.org/linux-raid/20250721171557.34587-7-yukuai@kernel.org
Signed-off-by: Yu Kuai <yukuai3@huawei.com>
Reviewed-by: Hannes Reinecke <hare@suse.de>
Reviewed-by: Li Nan <linan122@huawei.com>
Reviewed-by: Xiao Ni <xni@redhat.com>
---
 Documentation/admin-guide/md.rst |  3 ++
 drivers/md/md.c                  | 90 +++++++++++++++++++-------------
 2 files changed, 56 insertions(+), 37 deletions(-)

diff --git a/Documentation/admin-guide/md.rst b/Documentation/admin-guide/md.rst
index 356d2a344f08..001363f81850 100644
--- a/Documentation/admin-guide/md.rst
+++ b/Documentation/admin-guide/md.rst
@@ -388,6 +388,9 @@ All md devices contain:
      bitmap
          The default internal bitmap
 
+If bitmap_type is not none, then additional bitmap attributes bitmap/xxx or
+llbitmap/xxx will be created after md device KOBJ_CHANGE event.
+
 If bitmap_type is bitmap, then the md device will also contain:
 
   bitmap/location
diff --git a/drivers/md/md.c b/drivers/md/md.c
index aeae0d4854dc..6560bd89d0a2 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -678,9 +678,11 @@ static void no_op(struct percpu_ref *r) {}
 
 static bool mddev_set_bitmap_ops(struct mddev *mddev)
 {
+	struct bitmap_operations *old = mddev->bitmap_ops;
 	struct md_submodule_head *head;
 
-	if (mddev->bitmap_id == ID_BITMAP_NONE)
+	if (mddev->bitmap_id == ID_BITMAP_NONE ||
+	    (old && old->head.id == mddev->bitmap_id))
 		return true;
 
 	xa_lock(&md_submodule);
@@ -698,6 +700,18 @@ static bool mddev_set_bitmap_ops(struct mddev *mddev)
 
 	mddev->bitmap_ops = (void *)head;
 	xa_unlock(&md_submodule);
+
+	if (!mddev_is_dm(mddev) && mddev->bitmap_ops->group) {
+		if (sysfs_create_group(&mddev->kobj, mddev->bitmap_ops->group))
+			pr_warn("md: cannot register extra bitmap attributes for %s\n",
+				mdname(mddev));
+		else
+			/*
+			 * Inform user with KOBJ_CHANGE about new bitmap
+			 * attributes.
+			 */
+			kobject_uevent(&mddev->kobj, KOBJ_CHANGE);
+	}
 	return true;
 
 err:
@@ -707,28 +721,26 @@ static bool mddev_set_bitmap_ops(struct mddev *mddev)
 
 static void mddev_clear_bitmap_ops(struct mddev *mddev)
 {
+	if (!mddev_is_dm(mddev) && mddev->bitmap_ops &&
+	    mddev->bitmap_ops->group)
+		sysfs_remove_group(&mddev->kobj, mddev->bitmap_ops->group);
+
 	mddev->bitmap_ops = NULL;
 }
 
 int mddev_init(struct mddev *mddev)
 {
-	if (!IS_ENABLED(CONFIG_MD_BITMAP)) {
+	if (!IS_ENABLED(CONFIG_MD_BITMAP))
 		mddev->bitmap_id = ID_BITMAP_NONE;
-	} else {
+	else
 		mddev->bitmap_id = ID_BITMAP;
-		if (!mddev_set_bitmap_ops(mddev))
-			return -EINVAL;
-	}
 
 	if (percpu_ref_init(&mddev->active_io, active_io_release,
-			    PERCPU_REF_ALLOW_REINIT, GFP_KERNEL)) {
-		mddev_clear_bitmap_ops(mddev);
+			    PERCPU_REF_ALLOW_REINIT, GFP_KERNEL))
 		return -ENOMEM;
-	}
 
 	if (percpu_ref_init(&mddev->writes_pending, no_op,
 			    PERCPU_REF_ALLOW_REINIT, GFP_KERNEL)) {
-		mddev_clear_bitmap_ops(mddev);
 		percpu_ref_exit(&mddev->active_io);
 		return -ENOMEM;
 	}
@@ -766,7 +778,6 @@ EXPORT_SYMBOL_GPL(mddev_init);
 
 void mddev_destroy(struct mddev *mddev)
 {
-	mddev_clear_bitmap_ops(mddev);
 	percpu_ref_exit(&mddev->active_io);
 	percpu_ref_exit(&mddev->writes_pending);
 }
@@ -6196,11 +6207,6 @@ struct mddev *md_alloc(dev_t dev, char *name)
 		return ERR_PTR(error);
 	}
 
-	if (md_bitmap_registered(mddev) && mddev->bitmap_ops->group)
-		if (sysfs_create_group(&mddev->kobj, mddev->bitmap_ops->group))
-			pr_warn("md: cannot register extra bitmap attributes for %s\n",
-				mdname(mddev));
-
 	kobject_uevent(&mddev->kobj, KOBJ_ADD);
 	mddev->sysfs_state = sysfs_get_dirent_safe(mddev->kobj.sd, "array_state");
 	mddev->sysfs_level = sysfs_get_dirent_safe(mddev->kobj.sd, "level");
@@ -6279,6 +6285,26 @@ static void md_safemode_timeout(struct timer_list *t)
 
 static int start_dirty_degraded;
 
+static int md_bitmap_create(struct mddev *mddev)
+{
+	if (mddev->bitmap_id == ID_BITMAP_NONE)
+		return -EINVAL;
+
+	if (!mddev_set_bitmap_ops(mddev))
+		return -ENOENT;
+
+	return mddev->bitmap_ops->create(mddev);
+}
+
+static void md_bitmap_destroy(struct mddev *mddev)
+{
+	if (!md_bitmap_registered(mddev))
+		return;
+
+	mddev->bitmap_ops->destroy(mddev);
+	mddev_clear_bitmap_ops(mddev);
+}
+
 int md_run(struct mddev *mddev)
 {
 	int err;
@@ -6443,9 +6469,9 @@ int md_run(struct mddev *mddev)
 			(unsigned long long)pers->size(mddev, 0, 0) / 2);
 		err = -EINVAL;
 	}
-	if (err == 0 && pers->sync_request && md_bitmap_registered(mddev) &&
+	if (err == 0 && pers->sync_request &&
 	    (mddev->bitmap_info.file || mddev->bitmap_info.offset)) {
-		err = mddev->bitmap_ops->create(mddev);
+		err = md_bitmap_create(mddev);
 		if (err)
 			pr_warn("%s: failed to create bitmap (%d)\n",
 				mdname(mddev), err);
@@ -6518,8 +6544,7 @@ int md_run(struct mddev *mddev)
 		pers->free(mddev, mddev->private);
 	mddev->private = NULL;
 	put_pers(pers);
-	if (md_bitmap_registered(mddev))
-		mddev->bitmap_ops->destroy(mddev);
+	md_bitmap_destroy(mddev);
 abort:
 	bioset_exit(&mddev->io_clone_set);
 exit_sync_set:
@@ -6542,7 +6567,7 @@ int do_md_run(struct mddev *mddev)
 	if (md_bitmap_registered(mddev)) {
 		err = mddev->bitmap_ops->load(mddev);
 		if (err) {
-			mddev->bitmap_ops->destroy(mddev);
+			md_bitmap_destroy(mddev);
 			goto out;
 		}
 	}
@@ -6740,8 +6765,7 @@ static void __md_stop(struct mddev *mddev)
 {
 	struct md_personality *pers = mddev->pers;
 
-	if (md_bitmap_registered(mddev))
-		mddev->bitmap_ops->destroy(mddev);
+	md_bitmap_destroy(mddev);
 	mddev_detach(mddev);
 	spin_lock(&mddev->lock);
 	mddev->pers = NULL;
@@ -7518,16 +7542,16 @@ static int set_bitmap_file(struct mddev *mddev, int fd)
 	err = 0;
 	if (mddev->pers) {
 		if (fd >= 0) {
-			err = mddev->bitmap_ops->create(mddev);
+			err = md_bitmap_create(mddev);
 			if (!err)
 				err = mddev->bitmap_ops->load(mddev);
 
 			if (err) {
-				mddev->bitmap_ops->destroy(mddev);
+				md_bitmap_destroy(mddev);
 				fd = -1;
 			}
 		} else if (fd < 0) {
-			mddev->bitmap_ops->destroy(mddev);
+			md_bitmap_destroy(mddev);
 		}
 	}
 
@@ -7812,14 +7836,6 @@ static int update_array_info(struct mddev *mddev, mdu_array_info_t *info)
 		rv = update_raid_disks(mddev, info->raid_disks);
 
 	if ((state ^ info->state) & (1<<MD_SB_BITMAP_PRESENT)) {
-		/*
-		 * Metadata says bitmap existed, however kernel can't find
-		 * registered bitmap.
-		 */
-		if (WARN_ON_ONCE(!md_bitmap_registered(mddev))) {
-			rv = -EINVAL;
-			goto err;
-		}
 		if (mddev->pers->quiesce == NULL || mddev->thread == NULL) {
 			rv = -EINVAL;
 			goto err;
@@ -7842,12 +7858,12 @@ static int update_array_info(struct mddev *mddev, mdu_array_info_t *info)
 				mddev->bitmap_info.default_offset;
 			mddev->bitmap_info.space =
 				mddev->bitmap_info.default_space;
-			rv = mddev->bitmap_ops->create(mddev);
+			rv = md_bitmap_create(mddev);
 			if (!rv)
 				rv = mddev->bitmap_ops->load(mddev);
 
 			if (rv)
-				mddev->bitmap_ops->destroy(mddev);
+				md_bitmap_destroy(mddev);
 		} else {
 			struct md_bitmap_stats stats;
 
@@ -7873,7 +7889,7 @@ static int update_array_info(struct mddev *mddev, mdu_array_info_t *info)
 				put_cluster_ops(mddev);
 				mddev->safemode_delay = DEFAULT_SAFEMODE_DELAY;
 			}
-			mddev->bitmap_ops->destroy(mddev);
+			md_bitmap_destroy(mddev);
 			mddev->bitmap_info.offset = 0;
 		}
 	}
-- 
2.39.2


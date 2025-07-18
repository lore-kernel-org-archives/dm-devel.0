Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D0912BD59E
	for <dm-devel@lists.linux.dev>; Fri, 18 Jul 2025 09:29:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752831000; cv=none; b=JbXNEwgRiE3RRZZ0+nu5Aw3eAtRGcCwic6GG3AZM62Ou/FgHANjmT/plgNNQnNul6FBTFvH1L5VjQMZSH418aZkvZJmyfzdGuWTQRBy9sOAziuqOoTqJlVJEgdY+GXtbPz2P1uU3ygKEM0oakvaqbuifHAsJikfblSUB8AbenYA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752831000; c=relaxed/simple;
	bh=zNqojyHXo83jLdbixIOYLX0Z6GWjIBReDtrkNJrvKhg=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=MrOVKmXPuk83sGAf1k2mXd03c+esSJbb4Mab/tJ+i7YGdpX4+aHaw9aC02dUeNK3NPrlkNd8EmGDhJG2JbhtGja+MbzERxc32uunutmQNEN8CCwZa1yP1dtebhjxTJyzg3YkaN/4qOf4RyYyyx8btXMmHc7OaWPRM7WUL33VY1Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.235])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTPS id 4bk4JH2MjczYQvMT
	for <dm-devel@lists.linux.dev>; Fri, 18 Jul 2025 17:29:51 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 14FC81A08AC
	for <dm-devel@lists.linux.dev>; Fri, 18 Jul 2025 17:29:50 +0800 (CST)
Received: from huaweicloud.com (unknown [10.175.104.67])
	by APP4 (Coremail) with SMTP id gCh0CgDXUxQGFHpoDl6qAg--.5172S10;
	Fri, 18 Jul 2025 17:29:49 +0800 (CST)
From: Yu Kuai <yukuai1@huaweicloud.com>
To: corbet@lwn.net,
	agk@redhat.com,
	snitzer@kernel.org,
	mpatocka@redhat.com,
	song@kernel.org,
	yukuai3@huawei.com,
	hare@suse.de
Cc: linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	dm-devel@lists.linux.dev,
	linux-raid@vger.kernel.org,
	yukuai1@huaweicloud.com,
	yi.zhang@huawei.com,
	yangerkun@huawei.com,
	johnny.chenyi@huawei.com
Subject: [PATCH v3 06/11] md/md-bitmap: delay registration of bitmap_ops until creating bitmap
Date: Fri, 18 Jul 2025 17:23:31 +0800
Message-Id: <20250718092336.3346644-7-yukuai1@huaweicloud.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20250718092336.3346644-1-yukuai1@huaweicloud.com>
References: <20250718092336.3346644-1-yukuai1@huaweicloud.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgDXUxQGFHpoDl6qAg--.5172S10
X-Coremail-Antispam: 1UD129KBjvJXoW3Xr4xGF1xKFyUJF1Dtr47Jwb_yoWxKF1xp3
	yft3Z5Kr4rJrZIgr47XFyv9F1rXrn7JrZxtryxXw15Grn3JrnxWF4rWF1Dtr18Ga4xZFs8
	Zw45tr4rCr17uF7anT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
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
	AF67kF1VAFwI0_Jw0_GFylIxkGc2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWUCVW8JwCI
	42IY6xIIjxv20xvEc7CjxVAFwI0_Gr1j6F4UJwCI42IY6xAIw20EY4v20xvaj40_Jr0_JF
	4lIxAIcVC2z280aVAFwI0_Jr0_Gr1lIxAIcVC2z280aVCY1x0267AKxVW8Jr0_Cr1UYxBI
	daVFxhVjvjDU0xZFpf9x0JUQFxUUUUUU=
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/

From: Yu Kuai <yukuai3@huawei.com>

Currently bitmap_ops is registered while allocating mddev, this is fine
when there is only one bitmap_ops.

Delay setting bitmap_ops until creating bitmap, so that user can choose
which bitmap to use before running the array.

Signed-off-by: Yu Kuai <yukuai3@huawei.com>
---
 Documentation/admin-guide/md.rst |  3 ++
 drivers/md/md.c                  | 82 +++++++++++++++++++++-----------
 2 files changed, 56 insertions(+), 29 deletions(-)

diff --git a/Documentation/admin-guide/md.rst b/Documentation/admin-guide/md.rst
index 356d2a344f08..03a9f5025f99 100644
--- a/Documentation/admin-guide/md.rst
+++ b/Documentation/admin-guide/md.rst
@@ -388,6 +388,9 @@ All md devices contain:
      bitmap
          The default internal bitmap
 
+If bitmap_type is not none, then additional bitmap attributes will be
+created after md device KOBJ_CHANGE event.
+
 If bitmap_type is bitmap, then the md device will also contain:
 
   bitmap/location
diff --git a/drivers/md/md.c b/drivers/md/md.c
index d8b0dfdb4bfc..639b0143cbb1 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -674,9 +674,11 @@ static void no_op(struct percpu_ref *r) {}
 
 static bool mddev_set_bitmap_ops(struct mddev *mddev)
 {
+	struct bitmap_operations *old = mddev->bitmap_ops;
 	struct md_submodule_head *head;
 
-	if (mddev->bitmap_id == ID_BITMAP_NONE)
+	if (mddev->bitmap_id == ID_BITMAP_NONE ||
+	    (old && old->head.id == mddev->bitmap_id))
 		return true;
 
 	xa_lock(&md_submodule);
@@ -694,6 +696,18 @@ static bool mddev_set_bitmap_ops(struct mddev *mddev)
 
 	mddev->bitmap_ops = (void *)head;
 	xa_unlock(&md_submodule);
+
+	if (mddev->bitmap_ops->group) {
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
@@ -703,28 +717,25 @@ static bool mddev_set_bitmap_ops(struct mddev *mddev)
 
 static void mddev_clear_bitmap_ops(struct mddev *mddev)
 {
+	if (mddev->bitmap_ops && mddev->bitmap_ops->group)
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
@@ -752,6 +763,7 @@ int mddev_init(struct mddev *mddev)
 	mddev->resync_min = 0;
 	mddev->resync_max = MaxSector;
 	mddev->level = LEVEL_NONE;
+	mddev->bitmap_id = ID_BITMAP;
 
 	INIT_WORK(&mddev->sync_work, md_start_sync);
 	INIT_WORK(&mddev->del_work, mddev_delayed_delete);
@@ -762,7 +774,6 @@ EXPORT_SYMBOL_GPL(mddev_init);
 
 void mddev_destroy(struct mddev *mddev)
 {
-	mddev_clear_bitmap_ops(mddev);
 	percpu_ref_exit(&mddev->active_io);
 	percpu_ref_exit(&mddev->writes_pending);
 }
@@ -6125,11 +6136,6 @@ struct mddev *md_alloc(dev_t dev, char *name)
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
@@ -6205,6 +6211,26 @@ static void md_safemode_timeout(struct timer_list *t)
 
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
@@ -6369,9 +6395,9 @@ int md_run(struct mddev *mddev)
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
@@ -6444,8 +6470,7 @@ int md_run(struct mddev *mddev)
 		pers->free(mddev, mddev->private);
 	mddev->private = NULL;
 	put_pers(pers);
-	if (md_bitmap_registered(mddev))
-		mddev->bitmap_ops->destroy(mddev);
+	md_bitmap_destroy(mddev);
 abort:
 	bioset_exit(&mddev->io_clone_set);
 exit_sync_set:
@@ -6468,7 +6493,7 @@ int do_md_run(struct mddev *mddev)
 	if (md_bitmap_registered(mddev)) {
 		err = mddev->bitmap_ops->load(mddev);
 		if (err) {
-			mddev->bitmap_ops->destroy(mddev);
+			md_bitmap_destroy(mddev);
 			goto out;
 		}
 	}
@@ -6659,8 +6684,7 @@ static void __md_stop(struct mddev *mddev)
 {
 	struct md_personality *pers = mddev->pers;
 
-	if (md_bitmap_registered(mddev))
-		mddev->bitmap_ops->destroy(mddev);
+	md_bitmap_destroy(mddev);
 	mddev_detach(mddev);
 	spin_lock(&mddev->lock);
 	mddev->pers = NULL;
@@ -7440,16 +7464,16 @@ static int set_bitmap_file(struct mddev *mddev, int fd)
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
 
@@ -7764,12 +7788,12 @@ static int update_array_info(struct mddev *mddev, mdu_array_info_t *info)
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
 
@@ -7795,7 +7819,7 @@ static int update_array_info(struct mddev *mddev, mdu_array_info_t *info)
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


Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BFB711E2852
	for <dm-devel@lists.linux.dev>; Mon, 12 May 2025 01:28:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747013292; cv=none; b=Ryd3YOZxuuAfBEC72qEj8W9IkwNwZMG47ju34IXR6r+fIpjM52eG2uZaAxlUxlydDQGEymeaLuSNFU12MpPtF8jEAxs25Xn130BBqJya8+rLA6LoqvBDPsdwrGp5qlcg8ZH7pxqoha3zUQWW3yRDABqNSVbIQwdXoHaeAbMV9NM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747013292; c=relaxed/simple;
	bh=hvJUrahqvjuj8N5ONM8vvvnyCTEB2I3TA8aumyVlSHk=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=CDSeuk3QXJHmZB56gN0n7yZxq/UVm0DAGsHNBIL5/Zmy7xrz2bUgkj5NuT0amNKssNfAUsng6p6aV104aV0inaKd5Cumj8J6oCHIDa+BkiZ5ONqZf0yaMJBbCl2vjNEy8zSKFcoPp3M6Y+9NvUXiN4Jm81cLmv8b3zahRkZYYaU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=none smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.216])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTP id 4Zwhmp5bKcz4f3lDN
	for <dm-devel@lists.linux.dev>; Mon, 12 May 2025 09:27:38 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id E7D181A1B99
	for <dm-devel@lists.linux.dev>; Mon, 12 May 2025 09:28:04 +0800 (CST)
Received: from huaweicloud.com (unknown [10.175.104.67])
	by APP4 (Coremail) with SMTP id gCh0CgCnC2CdTiFoNFCWMA--.55093S9;
	Mon, 12 May 2025 09:28:04 +0800 (CST)
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
Subject: [PATCH RFC md-6.16 v3 05/19] md: delay registration of bitmap_ops until creating bitmap
Date: Mon, 12 May 2025 09:19:13 +0800
Message-Id: <20250512011927.2809400-6-yukuai1@huaweicloud.com>
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
X-CM-TRANSID:gCh0CgCnC2CdTiFoNFCWMA--.55093S9
X-Coremail-Antispam: 1UD129KBjvJXoWxKF47Gw45Xr1DAFW3Cw17KFg_yoWxAFWrp3
	yft3Z8Kr4rJrZIgw47JFyq9F1rXrn7tr9xtryxXw15Grn3JrnxXF4rWF1Utr18J348AFs8
	Zw45Jr4rGr13uF7anT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUmI14x267AKxVWrJVCq3wAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
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
	42IY6xIIjxv20xvEc7CjxVAFwI0_Cr0_Gr1UMIIF0xvE42xK8VAvwI8IcIk0rVWUJVWUCw
	CI42IY6I8E87Iv67AKxVWUJVW8JwCI42IY6I8E87Iv6xkF7I0E14v26r4j6r4UJbIYCTnI
	WIevJa73UjIFyTuYvjfUOyIUUUUUU
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/

From: Yu Kuai <yukuai3@huawei.com>

Currently bitmap_ops is registered while allocating mddev, this is fine
when there is only one bitmap_ops, however, after introduing a new
bitmap_ops, user space need a time window to choose which bitmap_ops to
use while creating new array.

Signed-off-by: Yu Kuai <yukuai3@huawei.com>
---
 drivers/md/md.c | 85 ++++++++++++++++++++++++++++++++-----------------
 1 file changed, 56 insertions(+), 29 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index e16d3b4033d5..ba2b981b017c 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -674,32 +674,47 @@ static void no_op(struct percpu_ref *r) {}
 
 static void mddev_set_bitmap_ops(struct mddev *mddev)
 {
+	struct bitmap_operations *old = mddev->bitmap_ops;
+	struct md_submodule_head *head;
+
+	if (mddev->bitmap_id == ID_BITMAP_NONE ||
+	    (old && old->head.id == mddev->bitmap_id))
+		return;
+
 	xa_lock(&md_submodule);
-	mddev->bitmap_ops = xa_load(&md_submodule, mddev->bitmap_id);
+	head = xa_load(&md_submodule, mddev->bitmap_id);
 	xa_unlock(&md_submodule);
-	if (!mddev->bitmap_ops)
-		pr_warn_once("md: can't find bitmap id %d\n", mddev->bitmap_id);
+
+	if (WARN_ON_ONCE(!head || head->type != MD_BITMAP)) {
+		pr_err("md: can't find bitmap id %d\n", mddev->bitmap_id);
+		return;
+	}
+
+	if (old && old->group)
+		sysfs_remove_group(&mddev->kobj, old->group);
+
+	mddev->bitmap_ops = (void *)head;
+	if (mddev->bitmap_ops && mddev->bitmap_ops->group &&
+	    sysfs_create_group(&mddev->kobj, mddev->bitmap_ops->group))
+		pr_warn("md: cannot register extra bitmap attributes for %s\n",
+			mdname(mddev));
 }
 
 static void mddev_clear_bitmap_ops(struct mddev *mddev)
 {
+	if (mddev->bitmap_ops && mddev->bitmap_ops->group)
+		sysfs_remove_group(&mddev->kobj, mddev->bitmap_ops->group);
 	mddev->bitmap_ops = NULL;
 }
 
 int mddev_init(struct mddev *mddev)
 {
-	mddev->bitmap_id = ID_BITMAP;
-	mddev_set_bitmap_ops(mddev);
-
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
@@ -727,6 +742,7 @@ int mddev_init(struct mddev *mddev)
 	mddev->resync_min = 0;
 	mddev->resync_max = MaxSector;
 	mddev->level = LEVEL_NONE;
+	mddev->bitmap_id = ID_BITMAP;
 
 	INIT_WORK(&mddev->sync_work, md_start_sync);
 	INIT_WORK(&mddev->del_work, mddev_delayed_delete);
@@ -737,7 +753,6 @@ EXPORT_SYMBOL_GPL(mddev_init);
 
 void mddev_destroy(struct mddev *mddev)
 {
-	mddev_clear_bitmap_ops(mddev);
 	percpu_ref_exit(&mddev->active_io);
 	percpu_ref_exit(&mddev->writes_pending);
 }
@@ -6086,11 +6101,6 @@ struct mddev *md_alloc(dev_t dev, char *name)
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
@@ -6166,6 +6176,25 @@ static void md_safemode_timeout(struct timer_list *t)
 
 static int start_dirty_degraded;
 
+static int md_bitmap_create(struct mddev *mddev)
+{
+	if (!md_bitmap_registered(mddev))
+		mddev_set_bitmap_ops(mddev);
+	if (!mddev->bitmap_ops)
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
@@ -6330,9 +6359,9 @@ int md_run(struct mddev *mddev)
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
@@ -6405,8 +6434,7 @@ int md_run(struct mddev *mddev)
 		pers->free(mddev, mddev->private);
 	mddev->private = NULL;
 	put_pers(pers);
-	if (md_bitmap_registered(mddev))
-		mddev->bitmap_ops->destroy(mddev);
+	md_bitmap_destroy(mddev);
 abort:
 	bioset_exit(&mddev->io_clone_set);
 exit_sync_set:
@@ -6429,7 +6457,7 @@ int do_md_run(struct mddev *mddev)
 	if (md_bitmap_registered(mddev)) {
 		err = mddev->bitmap_ops->load(mddev);
 		if (err) {
-			mddev->bitmap_ops->destroy(mddev);
+			md_bitmap_destroy(mddev);
 			goto out;
 		}
 	}
@@ -6620,8 +6648,7 @@ static void __md_stop(struct mddev *mddev)
 {
 	struct md_personality *pers = mddev->pers;
 
-	if (md_bitmap_registered(mddev))
-		mddev->bitmap_ops->destroy(mddev);
+	md_bitmap_destroy(mddev);
 	mddev_detach(mddev);
 	spin_lock(&mddev->lock);
 	mddev->pers = NULL;
@@ -7401,16 +7428,16 @@ static int set_bitmap_file(struct mddev *mddev, int fd)
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
 
@@ -7725,12 +7752,12 @@ static int update_array_info(struct mddev *mddev, mdu_array_info_t *info)
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
 
@@ -7756,7 +7783,7 @@ static int update_array_info(struct mddev *mddev, mdu_array_info_t *info)
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


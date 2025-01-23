Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5664013A3F7
	for <dm-devel@lists.linux.dev>; Thu, 23 Jan 2025 02:13:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737598407; cv=none; b=b/DrJfDAOP2WOJmYoDs6/aX0S0DLUYpf/BGzGEgcMWngafGXnpUnRxiNvPkOcJAvTlfiDQpgux2PHNfYQY+RKspgC79+O9ibITUZeMG9mv17j5QTi/qwPv0VAqH3fmdvMy2uZuqNT3b36tBMxFA6pq+rKQtHN120C8lVQHactBs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737598407; c=relaxed/simple;
	bh=cXK63JbLwlqtlSIqlQxs28lAXhYTv6GW9Xyfglxuoj4=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=UB/XYxkCO3BwO5Upkj26dCm4mVSzXb30DZ9NfCMSVSKW+a7vBZJPXhBZP7/d3KTJ/C1gPJSm9+7K0RoEhkh2b9RfO2XHbsqUFrNgjCO7U/DQlRVDUoLcF+z5urijCoPCXY0F9Vjowts3OFTHJW72sC89GzxKAqYwckYOkAOWlCA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.235])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTP id 4YdkxT4zmZz4f3khq
	for <dm-devel@lists.linux.dev>; Thu, 23 Jan 2025 10:13:01 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 5829B1A0AE4
	for <dm-devel@lists.linux.dev>; Thu, 23 Jan 2025 10:13:22 +0800 (CST)
Received: from huaweicloud.com (unknown [10.175.104.67])
	by APP4 (Coremail) with SMTP id gCh0CgA3m1+7pZFno+znBg--.59488S15;
	Thu, 23 Jan 2025 10:13:22 +0800 (CST)
From: Yu Kuai <yukuai1@huaweicloud.com>
To: song@kernel.org,
	yukuai3@huawei.com,
	agk@redhat.com,
	snitzer@kernel.org,
	mpatocka@redhat.com
Cc: linux-raid@vger.kernel.org,
	dm-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	yukuai1@huaweicloud.com,
	yi.zhang@huawei.com,
	yangerkun@huawei.com
Subject: [PATCH v3 md-6.15 11/11] md/md-bitmap: introducet CONFIG_MD_BITMAP
Date: Thu, 23 Jan 2025 10:07:30 +0800
Message-Id: <20250123020730.2003602-12-yukuai1@huaweicloud.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20250123020730.2003602-1-yukuai1@huaweicloud.com>
References: <20250123020730.2003602-1-yukuai1@huaweicloud.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgA3m1+7pZFno+znBg--.59488S15
X-Coremail-Antispam: 1UD129KBjvJXoW3JryUur4fKFyxCw4DZw43KFg_yoWfAryfpF
	WrGa45Gr45JFZxWa1UJa4DuFySgr1ktr9rtryfGwnYkF9rXF9xXF4rWFyUt3s8GFWfXFsx
	Za1rGFWUCr4UXF7anT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
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

Now that all implementations are internal, it's sensible to add a config
option for md-bitmap, and it's a good way for isolation.

Signed-off-by: Yu Kuai <yukuai3@huawei.com>
---
 drivers/md/Kconfig     | 18 ++++++++++
 drivers/md/md-bitmap.c | 21 +++++++++--
 drivers/md/md-bitmap.h | 19 +++++++++-
 drivers/md/md.c        | 82 +++++++++++++++++++++++++++++++++++-------
 drivers/md/md.h        |  1 -
 5 files changed, 125 insertions(+), 16 deletions(-)

diff --git a/drivers/md/Kconfig b/drivers/md/Kconfig
index 0b1870a09e1f..0da07182494c 100644
--- a/drivers/md/Kconfig
+++ b/drivers/md/Kconfig
@@ -37,6 +37,21 @@ config BLK_DEV_MD
 
 	  If unsure, say N.
 
+config MD_BITMAP
+	bool "MD RAID bitmap support"
+	default y
+	depends on BLK_DEV_MD
+	help
+	  If you say Y here, support for the write intent bitmap will be
+	  enabled. The bitmap can be used to optimize resync speed after power
+	  failure or readding a disk, limiting it to recorded dirty sectors in
+	  bitmap.
+
+	  This feature can be added to existing MD array or MD array can be
+	  created with bitmap via mdadm(8).
+
+	  If unsure, say Y.
+
 config MD_AUTODETECT
 	bool "Autodetect RAID arrays during kernel boot"
 	depends on BLK_DEV_MD=y
@@ -54,6 +69,7 @@ config MD_AUTODETECT
 config MD_BITMAP_FILE
 	bool "MD bitmap file support (deprecated)"
 	default y
+	depends on MD_BITMAP
 	help
 	  If you say Y here, support for write intent bitmaps in files on an
 	  external file system is enabled.  This is an alternative to the internal
@@ -174,6 +190,7 @@ config MD_RAID456
 
 config MD_CLUSTER
 	tristate "Cluster Support for MD"
+	select MD_BITMAP
 	depends on BLK_DEV_MD
 	depends on DLM
 	default n
@@ -392,6 +409,7 @@ config DM_RAID
        select MD_RAID1
        select MD_RAID10
        select MD_RAID456
+       select MD_BITMAP
        select BLK_DEV_MD
 	help
 	 A dm target that supports RAID1, RAID10, RAID4, RAID5 and RAID6 mappings
diff --git a/drivers/md/md-bitmap.c b/drivers/md/md-bitmap.c
index 142ba203063a..a1bfb3669f3c 100644
--- a/drivers/md/md-bitmap.c
+++ b/drivers/md/md-bitmap.c
@@ -212,6 +212,8 @@ struct bitmap {
 	int cluster_slot;
 };
 
+static struct workqueue_struct *md_bitmap_wq;
+
 static int __bitmap_resize(struct bitmap *bitmap, sector_t blocks,
 			   int chunksize, bool init);
 
@@ -2960,6 +2962,8 @@ static struct attribute_group md_bitmap_group = {
 };
 
 static struct bitmap_operations bitmap_ops = {
+	.version		= 1,
+
 	.enabled		= bitmap_enabled,
 	.create			= bitmap_create,
 	.resize			= bitmap_resize,
@@ -2994,7 +2998,20 @@ static struct bitmap_operations bitmap_ops = {
 	.group			= &md_bitmap_group,
 };
 
-void mddev_set_bitmap_ops(struct mddev *mddev)
+int md_bitmap_init(void)
+{
+	md_bitmap_wq = alloc_workqueue("md_bitmap", WQ_MEM_RECLAIM | WQ_UNBOUND,
+				       0);
+	if (!md_bitmap_wq)
+		return -ENOMEM;
+
+	INIT_LIST_HEAD(&bitmap_ops.list);
+	register_md_bitmap(&bitmap_ops);
+	return 0;
+}
+
+void md_bitmap_exit(void)
 {
-	mddev->bitmap_ops = &bitmap_ops;
+	destroy_workqueue(md_bitmap_wq);
+	unregister_md_bitmap(&bitmap_ops);
 }
diff --git a/drivers/md/md-bitmap.h b/drivers/md/md-bitmap.h
index fefa00bc438e..1c716b54b4a8 100644
--- a/drivers/md/md-bitmap.h
+++ b/drivers/md/md-bitmap.h
@@ -71,6 +71,9 @@ struct md_bitmap_stats {
 };
 
 struct bitmap_operations {
+	int version;
+	struct list_head list;
+
 	bool (*enabled)(void *data);
 	int (*create)(struct mddev *mddev, int slot);
 	int (*resize)(struct mddev *mddev, sector_t blocks, int chunksize);
@@ -114,7 +117,8 @@ struct bitmap_operations {
 };
 
 /* the bitmap API */
-void mddev_set_bitmap_ops(struct mddev *mddev);
+void register_md_bitmap(struct bitmap_operations *op);
+void unregister_md_bitmap(struct bitmap_operations *op);
 
 static inline bool md_bitmap_registered(struct mddev *mddev)
 {
@@ -156,4 +160,17 @@ static inline void md_bitmap_end_sync(struct mddev *mddev, sector_t offset,
 	mddev->bitmap_ops->end_sync(mddev, offset, blocks);
 }
 
+#ifdef CONFIG_MD_BITMAP
+extern int md_bitmap_init(void);
+extern void md_bitmap_exit(void);
+#else
+static inline int md_bitmap_init(void)
+{
+	return 0;
+}
+static inline void md_bitmap_exit(void)
+{
+}
+#endif
+
 #endif
diff --git a/drivers/md/md.c b/drivers/md/md.c
index 264756a54f59..9451cc5cc574 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -83,6 +83,9 @@ static const char *action_name[NR_SYNC_ACTIONS] = {
 static LIST_HEAD(pers_list);
 static DEFINE_SPINLOCK(pers_lock);
 
+static LIST_HEAD(bitmap_list);
+static DEFINE_SPINLOCK(bitmap_lock);
+
 static const struct kobj_type md_ktype;
 
 const struct md_cluster_operations *md_cluster_ops;
@@ -100,7 +103,6 @@ static struct workqueue_struct *md_wq;
  * workqueue whith reconfig_mutex grabbed.
  */
 static struct workqueue_struct *md_misc_wq;
-struct workqueue_struct *md_bitmap_wq;
 
 static int remove_and_add_spares(struct mddev *mddev,
 				 struct md_rdev *this);
@@ -650,15 +652,73 @@ static void active_io_release(struct percpu_ref *ref)
 
 static void no_op(struct percpu_ref *r) {}
 
+void register_md_bitmap(struct bitmap_operations *op)
+{
+	pr_info("md: bitmap version %d registered\n", op->version);
+
+	spin_lock(&bitmap_lock);
+	list_add_tail(&op->list, &bitmap_list);
+	spin_unlock(&bitmap_lock);
+}
+
+void unregister_md_bitmap(struct bitmap_operations *op)
+{
+	pr_info("md: bitmap version %d unregistered\n", op->version);
+
+	spin_lock(&bitmap_lock);
+	list_del_init(&op->list);
+	spin_unlock(&bitmap_lock);
+}
+
+static struct bitmap_operations *find_bitmap(int version)
+{
+	struct bitmap_operations *op = NULL;
+	struct bitmap_operations *tmp;
+
+	spin_lock(&bitmap_lock);
+	list_for_each_entry(tmp, &bitmap_list, list) {
+		if (tmp->version == version) {
+			op = tmp;
+			break;
+		}
+	}
+	spin_unlock(&bitmap_lock);
+
+	return op;
+}
+
+static void mddev_set_bitmap_ops(struct mddev *mddev, int version)
+{
+	struct bitmap_operations *op = find_bitmap(version);
+
+	if (!op)
+		pr_warn_once("md: can't find version %d bitmap\n", version);
+
+	mddev->bitmap_ops = op;
+}
+
+static void mddev_clear_bitmap_ops(struct mddev *mddev)
+{
+	if (!mddev->bitmap_ops)
+		return;
+
+	mddev->bitmap_ops = NULL;
+}
+
 int mddev_init(struct mddev *mddev)
 {
+	/* TODO: support more versions */
+	mddev_set_bitmap_ops(mddev, 1);
 
 	if (percpu_ref_init(&mddev->active_io, active_io_release,
-			    PERCPU_REF_ALLOW_REINIT, GFP_KERNEL))
+			    PERCPU_REF_ALLOW_REINIT, GFP_KERNEL)) {
+		mddev_clear_bitmap_ops(mddev);
 		return -ENOMEM;
+	}
 
 	if (percpu_ref_init(&mddev->writes_pending, no_op,
 			    PERCPU_REF_ALLOW_REINIT, GFP_KERNEL)) {
+		mddev_clear_bitmap_ops(mddev);
 		percpu_ref_exit(&mddev->active_io);
 		return -ENOMEM;
 	}
@@ -686,7 +746,6 @@ int mddev_init(struct mddev *mddev)
 	mddev->resync_min = 0;
 	mddev->resync_max = MaxSector;
 	mddev->level = LEVEL_NONE;
-	mddev_set_bitmap_ops(mddev);
 
 	INIT_WORK(&mddev->sync_work, md_start_sync);
 	INIT_WORK(&mddev->del_work, mddev_delayed_delete);
@@ -697,6 +756,7 @@ EXPORT_SYMBOL_GPL(mddev_init);
 
 void mddev_destroy(struct mddev *mddev)
 {
+	mddev_clear_bitmap_ops(mddev);
 	percpu_ref_exit(&mddev->active_io);
 	percpu_ref_exit(&mddev->writes_pending);
 }
@@ -9970,8 +10030,12 @@ static void md_geninit(void)
 
 static int __init md_init(void)
 {
-	int ret = -ENOMEM;
+	int ret = md_bitmap_init();
 
+	if (ret)
+		return ret;
+
+	ret = -ENOMEM;
 	md_wq = alloc_workqueue("md", WQ_MEM_RECLAIM, 0);
 	if (!md_wq)
 		goto err_wq;
@@ -9980,11 +10044,6 @@ static int __init md_init(void)
 	if (!md_misc_wq)
 		goto err_misc_wq;
 
-	md_bitmap_wq = alloc_workqueue("md_bitmap", WQ_MEM_RECLAIM | WQ_UNBOUND,
-				       0);
-	if (!md_bitmap_wq)
-		goto err_bitmap_wq;
-
 	ret = __register_blkdev(MD_MAJOR, "md", md_probe);
 	if (ret < 0)
 		goto err_md;
@@ -10003,12 +10062,11 @@ static int __init md_init(void)
 err_mdp:
 	unregister_blkdev(MD_MAJOR, "md");
 err_md:
-	destroy_workqueue(md_bitmap_wq);
-err_bitmap_wq:
 	destroy_workqueue(md_misc_wq);
 err_misc_wq:
 	destroy_workqueue(md_wq);
 err_wq:
+	md_bitmap_exit();
 	return ret;
 }
 
@@ -10311,8 +10369,8 @@ static __exit void md_exit(void)
 	spin_unlock(&all_mddevs_lock);
 
 	destroy_workqueue(md_misc_wq);
-	destroy_workqueue(md_bitmap_wq);
 	destroy_workqueue(md_wq);
+	md_bitmap_exit();
 }
 
 subsys_initcall(md_init);
diff --git a/drivers/md/md.h b/drivers/md/md.h
index 87edf81c25b0..9e35d49f90a2 100644
--- a/drivers/md/md.h
+++ b/drivers/md/md.h
@@ -978,7 +978,6 @@ struct mdu_array_info_s;
 struct mdu_disk_info_s;
 
 extern int mdp_major;
-extern struct workqueue_struct *md_bitmap_wq;
 void md_autostart_arrays(int part);
 int md_set_array_info(struct mddev *mddev, struct mdu_array_info_s *info);
 int md_add_new_disk(struct mddev *mddev, struct mdu_disk_info_s *info);
-- 
2.39.2


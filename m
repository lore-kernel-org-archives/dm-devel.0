Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8C372192F9
	for <dm-devel@lists.linux.dev>; Mon,  7 Jul 2025 01:32:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751851970; cv=none; b=RwjIg7LpHq+RB7Fta5gplANbWwWyJb9yZf1m3wFEQ+pn26KCTCv91t3ITBPsIZ87enzgR/5TuROxYZN80YcWeHqcC1F4Ekt8nLLWZeHzFMR1k8RCk3v7TcTZGwyP3pMuccCL/J5zTNLUMBJ4kr3MbaBjYBWPM7jQ8kztaQqWnH4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751851970; c=relaxed/simple;
	bh=n27BftNqXRM7r3ieQZr04aRkNFf2LZTYJj09JWVEgy8=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=s5CEPZ2uAoRyzMOj/5ZBY9R8ZQkXSD+s7Wm8VNcXOUBQUd8f1+JnWOHEss3EHeV+WPpNQcsB8ZSH8LexhvOIjqHahQCcQ+h/jNSiP21t+1kFQvtWrB5Kt0rirwUrXMhU6AHDZn3TqE2ENYVMIpmgP8Jg4nnX2bQhnTZhWIiLFMo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.235])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTPS id 4bb6Dt6rLBzYQtwV
	for <dm-devel@lists.linux.dev>; Mon,  7 Jul 2025 09:32:46 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.252])
	by mail.maildlp.com (Postfix) with ESMTP id C4F501A0FEC
	for <dm-devel@lists.linux.dev>; Mon,  7 Jul 2025 09:32:45 +0800 (CST)
Received: from huaweicloud.com (unknown [10.175.104.67])
	by APP3 (Coremail) with SMTP id _Ch0CgDnSCazI2to_nSRAw--.35890S19;
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
Subject: [PATCH v5 15/15] md/md-bitmap: introduce CONFIG_MD_BITMAP
Date: Mon,  7 Jul 2025 09:27:11 +0800
Message-Id: <20250707012711.376844-16-yukuai1@huaweicloud.com>
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
X-CM-TRANSID:_Ch0CgDnSCazI2to_nSRAw--.35890S19
X-Coremail-Antispam: 1UD129KBjvJXoWxKF4rWw4fury3CrWrWFWDCFg_yoWfJF1kpF
	WrJF15Cr45JFWaqa17Ja4DuFyYqr1ktr9rtryfGw1rCF9xXr98JF4rWFyUtrykGFyxZFsx
	Za1rGFWUCF1UWr7anT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
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

Now that all implementations are internal, it's sensible to add a config
option for md-bitmap, and it's a good way for isolation.

Signed-off-by: Yu Kuai <yukuai3@huawei.com>
---
 drivers/md/Kconfig     | 18 ++++++++++++++++++
 drivers/md/Makefile    |  3 ++-
 drivers/md/md-bitmap.c | 23 +++++++++++++++++++++--
 drivers/md/md-bitmap.h | 17 +++++++++++++++--
 drivers/md/md.c        | 40 ++++++++++++++++++++++++++++------------
 drivers/md/md.h        |  3 +--
 6 files changed, 85 insertions(+), 19 deletions(-)

diff --git a/drivers/md/Kconfig b/drivers/md/Kconfig
index ddb37f6670de..f913579e731c 100644
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
@@ -393,6 +410,7 @@ config DM_RAID
        select MD_RAID1
        select MD_RAID10
        select MD_RAID456
+       select MD_BITMAP
        select BLK_DEV_MD
 	help
 	 A dm target that supports RAID1, RAID10, RAID4, RAID5 and RAID6 mappings
diff --git a/drivers/md/Makefile b/drivers/md/Makefile
index 87bdfc9fe14c..2e18147a9c40 100644
--- a/drivers/md/Makefile
+++ b/drivers/md/Makefile
@@ -27,7 +27,8 @@ dm-clone-y	+= dm-clone-target.o dm-clone-metadata.o
 dm-verity-y	+= dm-verity-target.o
 dm-zoned-y	+= dm-zoned-target.o dm-zoned-metadata.o dm-zoned-reclaim.o
 
-md-mod-y	+= md.o md-bitmap.o
+md-mod-y	+= md.o
+md-mod-$(CONFIG_MD_BITMAP)	+= md-bitmap.o
 raid456-y	+= raid5.o raid5-cache.o raid5-ppl.o
 linear-y       += md-linear.o
 
diff --git a/drivers/md/md-bitmap.c b/drivers/md/md-bitmap.c
index 5bd75fa6ee1d..28dd66ab8df9 100644
--- a/drivers/md/md-bitmap.c
+++ b/drivers/md/md-bitmap.c
@@ -224,6 +224,8 @@ struct bitmap {
 	int cluster_slot;
 };
 
+static struct workqueue_struct *md_bitmap_wq;
+
 static int __bitmap_resize(struct bitmap *bitmap, sector_t blocks,
 			   int chunksize, bool init);
 
@@ -2980,6 +2982,12 @@ static struct attribute_group md_bitmap_group = {
 };
 
 static struct bitmap_operations bitmap_ops = {
+	.head = {
+		.type	= MD_BITMAP,
+		.id	= ID_BITMAP,
+		.name	= "bitmap",
+	},
+
 	.enabled		= bitmap_enabled,
 	.create			= bitmap_create,
 	.resize			= bitmap_resize,
@@ -3014,7 +3022,18 @@ static struct bitmap_operations bitmap_ops = {
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
+	return register_md_submodule(&bitmap_ops.head);
+}
+
+void md_bitmap_exit(void)
 {
-	mddev->bitmap_ops = &bitmap_ops;
+	destroy_workqueue(md_bitmap_wq);
+	unregister_md_submodule(&bitmap_ops.head);
 }
diff --git a/drivers/md/md-bitmap.h b/drivers/md/md-bitmap.h
index 61cfc650c69c..42f91755a341 100644
--- a/drivers/md/md-bitmap.h
+++ b/drivers/md/md-bitmap.h
@@ -62,6 +62,8 @@ struct md_bitmap_stats {
 };
 
 struct bitmap_operations {
+	struct md_submodule_head head;
+
 	bool (*enabled)(void *data, bool flush);
 	int (*create)(struct mddev *mddev);
 	int (*resize)(struct mddev *mddev, sector_t blocks, int chunksize);
@@ -105,8 +107,6 @@ struct bitmap_operations {
 };
 
 /* the bitmap API */
-void mddev_set_bitmap_ops(struct mddev *mddev);
-
 static inline bool md_bitmap_registered(struct mddev *mddev)
 {
 	return mddev->bitmap_ops != NULL;
@@ -147,4 +147,17 @@ static inline void md_bitmap_end_sync(struct mddev *mddev, sector_t offset,
 	mddev->bitmap_ops->end_sync(mddev, offset, blocks);
 }
 
+#ifdef CONFIG_MD_BITMAP
+int md_bitmap_init(void);
+void md_bitmap_exit(void);
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
index 2f7e8d77e7ef..c2a90d8ec06d 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -94,7 +94,6 @@ static struct workqueue_struct *md_wq;
  * workqueue whith reconfig_mutex grabbed.
  */
 static struct workqueue_struct *md_misc_wq;
-struct workqueue_struct *md_bitmap_wq;
 
 static int remove_and_add_spares(struct mddev *mddev,
 				 struct md_rdev *this);
@@ -670,15 +669,34 @@ static void active_io_release(struct percpu_ref *ref)
 
 static void no_op(struct percpu_ref *r) {}
 
+static void mddev_set_bitmap_ops(struct mddev *mddev, enum md_submodule_id id)
+{
+	xa_lock(&md_submodule);
+	mddev->bitmap_ops = xa_load(&md_submodule, id);
+	xa_unlock(&md_submodule);
+	if (!mddev->bitmap_ops)
+		pr_warn_once("md: can't find bitmap id %d\n", id);
+}
+
+static void mddev_clear_bitmap_ops(struct mddev *mddev)
+{
+	mddev->bitmap_ops = NULL;
+}
+
 int mddev_init(struct mddev *mddev)
 {
+	/* TODO: support more versions */
+	mddev_set_bitmap_ops(mddev, ID_BITMAP);
 
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
@@ -706,7 +724,6 @@ int mddev_init(struct mddev *mddev)
 	mddev->resync_min = 0;
 	mddev->resync_max = MaxSector;
 	mddev->level = LEVEL_NONE;
-	mddev_set_bitmap_ops(mddev);
 
 	INIT_WORK(&mddev->sync_work, md_start_sync);
 	INIT_WORK(&mddev->del_work, mddev_delayed_delete);
@@ -717,6 +734,7 @@ EXPORT_SYMBOL_GPL(mddev_init);
 
 void mddev_destroy(struct mddev *mddev)
 {
+	mddev_clear_bitmap_ops(mddev);
 	percpu_ref_exit(&mddev->active_io);
 	percpu_ref_exit(&mddev->writes_pending);
 }
@@ -10038,8 +10056,12 @@ static void md_geninit(void)
 
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
@@ -10048,11 +10070,6 @@ static int __init md_init(void)
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
@@ -10071,12 +10088,11 @@ static int __init md_init(void)
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
 
@@ -10379,8 +10395,8 @@ static __exit void md_exit(void)
 	spin_unlock(&all_mddevs_lock);
 
 	destroy_workqueue(md_misc_wq);
-	destroy_workqueue(md_bitmap_wq);
 	destroy_workqueue(md_wq);
+	md_bitmap_exit();
 }
 
 subsys_initcall(md_init);
diff --git a/drivers/md/md.h b/drivers/md/md.h
index d6fba4240f97..b7dc8253efd8 100644
--- a/drivers/md/md.h
+++ b/drivers/md/md.h
@@ -38,7 +38,7 @@ enum md_submodule_id {
 	ID_RAID6	= 6,
 	ID_RAID10	= 10,
 	ID_CLUSTER,
-	ID_BITMAP,	/* TODO */
+	ID_BITMAP,
 	ID_LLBITMAP,	/* TODO */
 };
 
@@ -1012,7 +1012,6 @@ struct mdu_array_info_s;
 struct mdu_disk_info_s;
 
 extern int mdp_major;
-extern struct workqueue_struct *md_bitmap_wq;
 void md_autostart_arrays(int part);
 int md_set_array_info(struct mddev *mddev, struct mdu_array_info_s *info);
 int md_add_new_disk(struct mddev *mddev, struct mdu_disk_info_s *info);
-- 
2.39.2


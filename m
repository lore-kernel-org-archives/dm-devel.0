Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 719A21C54A5
	for <dm-devel@lists.linux.dev>; Wed, 25 Dec 2024 11:20:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735125604; cv=none; b=dVZfZ44CfB3OoFfBJ53TEEz3lGZyKyDE3WWyYzBZ+qR0toSvlXxy9+fHD/X6Nl4+NbJwa0yzop3fpbDqOhMNvF3Fyuzi95O/PLqP9MOxT+DD5Dlxt12k8RCL67Apt5lj569ip/ilXwIg0ppHNrPwFL1Sf2v2KhI2RG6d3o3uwpY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735125604; c=relaxed/simple;
	bh=q85cnv721Uh9w7qsfjb4mot0wHaw9LVggWEZTEhjBjI=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=OQBX/9LO+Rzs4cnR6S8fYFlEmWgS3EvHwu03Y9Aj7XjQlRhNIXD75kuwfef+2JfnKk6JU/TQ7kdKYmo20m9fFVg7LjULnffzwRRR96M9hhFSlkBFZDiSFZ9TR83WRUsjrxPJNEUXrM9T4J2ZZ5lbLFHwrsJMDU8WN18TCAQur4M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.93.142])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTP id 4YJ8RY2544z4f3kvp
	for <dm-devel@lists.linux.dev>; Wed, 25 Dec 2024 19:19:37 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 1B23F1A018D
	for <dm-devel@lists.linux.dev>; Wed, 25 Dec 2024 19:19:58 +0800 (CST)
Received: from huaweicloud.com (unknown [10.175.104.67])
	by APP4 (Coremail) with SMTP id gCh0CgAnT4NV6mtntXlgFg--.39006S17;
	Wed, 25 Dec 2024 19:19:57 +0800 (CST)
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
Subject: [PATCH md-6.14 13/13] md/md-bitmap: support to build md-bitmap as kernel module
Date: Wed, 25 Dec 2024 19:15:46 +0800
Message-Id: <20241225111546.1833250-14-yukuai1@huaweicloud.com>
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
X-CM-TRANSID:gCh0CgAnT4NV6mtntXlgFg--.39006S17
X-Coremail-Antispam: 1UD129KBjvJXoWxuw4kWw1rKF1rCry7Cw17KFg_yoWDJrWUpF
	4rX345Cr45Ja9Iqa1UGaykuFySgr1ktrZrtryfGwnYkF9rJr9xXF48WFWUt34DGFWfXFsx
	Zw4rKFWUur4UuF7anT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
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

Now that all implementations are internal, it's sensible to build it as
kernel module now.

Signed-off-by: Yu Kuai <yukuai3@huawei.com>
---
 drivers/md/Kconfig     | 18 ++++++++
 drivers/md/Makefile    |  4 +-
 drivers/md/md-bitmap.c | 28 +++++++++++-
 drivers/md/md-bitmap.h |  7 ++-
 drivers/md/md.c        | 96 +++++++++++++++++++++++++++++++++++++-----
 drivers/md/md.h        |  1 -
 6 files changed, 137 insertions(+), 17 deletions(-)

diff --git a/drivers/md/Kconfig b/drivers/md/Kconfig
index 1e9db8e4acdf..be22ece66919 100644
--- a/drivers/md/Kconfig
+++ b/drivers/md/Kconfig
@@ -37,6 +37,21 @@ config BLK_DEV_MD
 
 	  If unsure, say N.
 
+config MD_BITMAP
+	tristate "MD RAID bitmap support"
+	default y
+	depends on BLK_DEV_MD
+	help
+	  If you say Y or M here, support for the write intent bitmap will be
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
@@ -161,6 +177,7 @@ config MD_RAID456
 
 config MD_CLUSTER
 	tristate "Cluster Support for MD"
+	select MD_BITMAP
 	depends on BLK_DEV_MD
 	depends on DLM
 	default n
@@ -379,6 +396,7 @@ config DM_RAID
        select MD_RAID1
        select MD_RAID10
        select MD_RAID456
+       select MD_BITMAP
        select BLK_DEV_MD
 	help
 	 A dm target that supports RAID1, RAID10, RAID4, RAID5 and RAID6 mappings
diff --git a/drivers/md/Makefile b/drivers/md/Makefile
index 476a214e4bdc..387670f766b7 100644
--- a/drivers/md/Makefile
+++ b/drivers/md/Makefile
@@ -27,14 +27,14 @@ dm-clone-y	+= dm-clone-target.o dm-clone-metadata.o
 dm-verity-y	+= dm-verity-target.o
 dm-zoned-y	+= dm-zoned-target.o dm-zoned-metadata.o dm-zoned-reclaim.o
 
-md-mod-y	+= md.o md-bitmap.o
+md-mod-y	+= md.o
 raid456-y	+= raid5.o raid5-cache.o raid5-ppl.o
 
 # Note: link order is important.  All raid personalities
 # and must come before md.o, as they each initialise
 # themselves, and md.o may use the personalities when it
 # auto-initialised.
-
+obj-$(CONFIG_MD_BITMAP)		+= md-bitmap.o
 obj-$(CONFIG_MD_RAID0)		+= raid0.o
 obj-$(CONFIG_MD_RAID1)		+= raid1.o
 obj-$(CONFIG_MD_RAID10)		+= raid10.o
diff --git a/drivers/md/md-bitmap.c b/drivers/md/md-bitmap.c
index 72cbbe0d3408..097339315517 100644
--- a/drivers/md/md-bitmap.c
+++ b/drivers/md/md-bitmap.c
@@ -212,6 +212,8 @@ struct bitmap {
 	int cluster_slot;
 };
 
+static struct workqueue_struct *md_bitmap_wq;
+
 static int __bitmap_resize(struct bitmap *bitmap, sector_t blocks,
 			   int chunksize, bool init);
 
@@ -2960,6 +2962,9 @@ static struct attribute_group md_bitmap_group = {
 };
 
 static struct bitmap_operations bitmap_ops = {
+	.version		= 1,
+	.owner			= THIS_MODULE,
+
 	.enabled		= bitmap_enabled,
 	.create			= bitmap_create,
 	.resize			= bitmap_resize,
@@ -2994,7 +2999,26 @@ static struct bitmap_operations bitmap_ops = {
 	.group			= &md_bitmap_group,
 };
 
-void mddev_set_bitmap_ops(struct mddev *mddev)
+static int __init bitmap_init(void)
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
+static void __exit bitmap_exit(void)
 {
-	mddev->bitmap_ops = &bitmap_ops;
+	destroy_workqueue(md_bitmap_wq);
+	unregister_md_bitmap(&bitmap_ops);
 }
+
+module_init(bitmap_init);
+module_exit(bitmap_exit);
+
+MODULE_LICENSE("GPL");
+MODULE_DESCRIPTION("Bitmap for MD");
diff --git a/drivers/md/md-bitmap.h b/drivers/md/md-bitmap.h
index fefa00bc438e..afd28d06aae9 100644
--- a/drivers/md/md-bitmap.h
+++ b/drivers/md/md-bitmap.h
@@ -71,6 +71,10 @@ struct md_bitmap_stats {
 };
 
 struct bitmap_operations {
+	int version;
+	struct module *owner;
+	struct list_head list;
+
 	bool (*enabled)(void *data);
 	int (*create)(struct mddev *mddev, int slot);
 	int (*resize)(struct mddev *mddev, sector_t blocks, int chunksize);
@@ -114,7 +118,8 @@ struct bitmap_operations {
 };
 
 /* the bitmap API */
-void mddev_set_bitmap_ops(struct mddev *mddev);
+void register_md_bitmap(struct bitmap_operations *op);
+void unregister_md_bitmap(struct bitmap_operations *op);
 
 static inline bool md_bitmap_registered(struct mddev *mddev)
 {
diff --git a/drivers/md/md.c b/drivers/md/md.c
index f1f70803439d..b1c9c0d4d5e7 100644
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
@@ -652,15 +654,95 @@ static void active_io_release(struct percpu_ref *ref)
 
 static void no_op(struct percpu_ref *r) {}
 
+void register_md_bitmap(struct bitmap_operations *op)
+{
+	pr_info("md: bitmap version %d registered\n", op->version);
+
+	spin_lock(&bitmap_lock);
+	list_add_tail(&op->list, &bitmap_list);
+	spin_unlock(&bitmap_lock);
+}
+EXPORT_SYMBOL_GPL(register_md_bitmap);
+
+void unregister_md_bitmap(struct bitmap_operations *op)
+{
+	pr_info("md: bitmap version %d unregistered\n", op->version);
+
+	spin_lock(&bitmap_lock);
+	list_del_init(&op->list);
+	spin_unlock(&bitmap_lock);
+}
+EXPORT_SYMBOL_GPL(unregister_md_bitmap);
+
+static struct bitmap_operations *__find_bitmap(int version)
+{
+	struct bitmap_operations *op;
+
+	list_for_each_entry(op, &bitmap_list, list)
+		if (op->version == version) {
+			if (try_module_get(op->owner))
+				return op;
+			else
+				return NULL;
+		}
+
+	return NULL;
+}
+
+static struct bitmap_operations *find_bitmap(int version)
+{
+	struct bitmap_operations *op = NULL;
+
+	spin_lock(&bitmap_lock);
+	op = __find_bitmap(version);
+	spin_unlock(&bitmap_lock);
+
+	if (op)
+		return op;
+
+	if (request_module("md-bitmap") != 0)
+		return NULL;
+
+	spin_lock(&bitmap_lock);
+	op = __find_bitmap(version);
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
+	module_put(mddev->bitmap_ops->owner);
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
@@ -688,7 +770,6 @@ int mddev_init(struct mddev *mddev)
 	mddev->resync_min = 0;
 	mddev->resync_max = MaxSector;
 	mddev->level = LEVEL_NONE;
-	mddev_set_bitmap_ops(mddev);
 
 	INIT_WORK(&mddev->sync_work, md_start_sync);
 	INIT_WORK(&mddev->del_work, mddev_delayed_delete);
@@ -699,6 +780,7 @@ EXPORT_SYMBOL_GPL(mddev_init);
 
 void mddev_destroy(struct mddev *mddev)
 {
+	mddev_clear_bitmap_ops(mddev);
 	percpu_ref_exit(&mddev->active_io);
 	percpu_ref_exit(&mddev->writes_pending);
 }
@@ -9977,11 +10059,6 @@ static int __init md_init(void)
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
@@ -10000,8 +10077,6 @@ static int __init md_init(void)
 err_mdp:
 	unregister_blkdev(MD_MAJOR, "md");
 err_md:
-	destroy_workqueue(md_bitmap_wq);
-err_bitmap_wq:
 	destroy_workqueue(md_misc_wq);
 err_misc_wq:
 	destroy_workqueue(md_wq);
@@ -10308,7 +10383,6 @@ static __exit void md_exit(void)
 	spin_unlock(&all_mddevs_lock);
 
 	destroy_workqueue(md_misc_wq);
-	destroy_workqueue(md_bitmap_wq);
 	destroy_workqueue(md_wq);
 }
 
diff --git a/drivers/md/md.h b/drivers/md/md.h
index 7e8276d2dadc..aea9693ff6ef 100644
--- a/drivers/md/md.h
+++ b/drivers/md/md.h
@@ -977,7 +977,6 @@ struct mdu_array_info_s;
 struct mdu_disk_info_s;
 
 extern int mdp_major;
-extern struct workqueue_struct *md_bitmap_wq;
 void md_autostart_arrays(int part);
 int md_set_array_info(struct mddev *mddev, struct mdu_array_info_s *info);
 int md_add_new_disk(struct mddev *mddev, struct mdu_disk_info_s *info);
-- 
2.39.2


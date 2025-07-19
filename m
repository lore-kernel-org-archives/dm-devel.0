Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00CDD21931C
	for <dm-devel@lists.linux.dev>; Sat, 19 Jul 2025 08:51:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.187
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752915121; cv=none; b=pzb+kuDO29e5awdhVLd3QftirDwFbvK9/LhAt166l0f7mneURyIGk8EajnHsDKivxilxnJhlItq5DL0aooGej0a21lRdPojT+G5cfykyauZpJcS7PYtLeDysRb6a9idHmbLKDNighrxmhEwhsNmudRPtxO8bl4QLS9M9NgJE0Xo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752915121; c=relaxed/simple;
	bh=dEHXewK1RjZAahZSQ4R5blOdtQXZizUQp293eJH+Om8=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=hdyzHVA33S0/uUdYV2K5AKKFsY22Q1XGvtIiQsH6Tsx7Bg7A0SyGcZLT34MfmFWFA4TGh8N/187CSbjNJX+FokmVrZvaHpkBlgqOBWawNggDikmms0Y56V+FacgmsR/At07YwXkJpZUJQ3S6AW9SlY5UAqS1FPgYsR30Zdiq3XE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.187
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.163.48])
	by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4bkgJV5MHjz14Lnm;
	Sat, 19 Jul 2025 16:47:06 +0800 (CST)
Received: from kwepemg500017.china.huawei.com (unknown [7.202.181.81])
	by mail.maildlp.com (Postfix) with ESMTPS id D64C918006C;
	Sat, 19 Jul 2025 16:51:54 +0800 (CST)
Received: from huawei.com (10.175.112.188) by kwepemg500017.china.huawei.com
 (7.202.181.81) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Sat, 19 Jul
 2025 16:51:53 +0800
From: Li Lingfeng <lilingfeng3@huawei.com>
To: <dm-devel@lists.linux.dev>
CC: <agk@redhat.com>, <snitzer@kernel.org>, <mpatocka@redhat.com>,
	<colin.i.king@gmail.com>, <linux-kernel@vger.kernel.org>,
	<houtao1@huawei.com>, <yi.zhang@huawei.com>, <yangerkun@huawei.com>,
	<yukuai3@huawei.com>, <chengzhihao1@huawei.com>, <lilingfeng3@huawei.com>,
	<lilingfeng@huaweicloud.com>
Subject: [PATCH] dm: introduce ima_lock to prevent concurrent calls to dm_ima_measure_* functions
Date: Sun, 20 Jul 2025 00:47:01 +0800
Message-ID: <20250719164701.3147592-1-lilingfeng3@huawei.com>
X-Mailer: git-send-email 2.46.1
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: kwepems100001.china.huawei.com (7.221.188.238) To
 kwepemg500017.china.huawei.com (7.202.181.81)

There is a window between freeing md->ima.active_table.hash and setting
md->ima.active_table.hash to NULL in dm_ima_measure_on_device_resume().
If dm_ima_measure_on_device_remove() accesses md->ima.active_table.hash
concurrently during this window, it could lead to a double free or UAF,
as shown below:

BUG: KASAN: slab-use-after-free in dm_ima_measure_on_device_remove...
Read of size 71 at addr ffff88817bb9e220 by task dmsetup/2303

CPU: 2 UID: 0 PID: 2303 Comm: dmsetup Not tainted 6.16.0-rc6-dirty...
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.16.3...
Call Trace:
 <TASK>
 dump_stack_lvl+0x5b/0x80
 print_address_description.constprop.0+0x88/0x310
 print_report+0x12f/0x21d
 kasan_report+0xcc/0x190
 kasan_check_range+0x104/0x1b0
 __asan_memcpy+0x23/0x60
 dm_ima_measure_on_device_remove+0x3fc/0x6c0
 dev_remove+0x123/0x1e0
 ctl_ioctl+0x2a2/0x480
 dm_ctl_ioctl+0xe/0x20
 __x64_sys_ioctl+0xc7/0x110
 do_syscall_64+0x72/0x390
 entry_SYSCALL_64_after_hwframe+0x76/0x7e

To reproduce this issue, add a delay between freeing
md->ima.active_table.hash and setting it to NULL, using the following
steps:
dmsetup create mydevice --table "0 2097152 linear /dev/sda 0"
dmsetup suspend mydevice
dmsetup reload mydevice --table "0 2097152 linear /dev/sdb 0"
dmsetup resume mydevice &
dmsetup remove mydevice

Introduce ima_lock to prevent concurrent calls to dm_ima_measure_*
functions to fix it.

Fixes: 91ccbbac1747 ("dm ima: measure data on table load")
Signed-off-by: Li Lingfeng <lilingfeng3@huawei.com>
---
 drivers/md/dm-core.h |  1 +
 drivers/md/dm-ima.c  | 38 +++++++++++++++++++++++++++++++++-----
 drivers/md/dm-ima.h  |  4 ++++
 drivers/md/dm.c      |  3 ++-
 4 files changed, 40 insertions(+), 6 deletions(-)

diff --git a/drivers/md/dm-core.h b/drivers/md/dm-core.h
index c889332e533b..24f321b2c2c4 100644
--- a/drivers/md/dm-core.h
+++ b/drivers/md/dm-core.h
@@ -145,6 +145,7 @@ struct mapped_device {
 #endif
 
 #ifdef CONFIG_IMA
+	struct mutex ima_lock;
 	struct dm_ima_measurements ima;
 #endif
 };
diff --git a/drivers/md/dm-ima.c b/drivers/md/dm-ima.c
index b90f34259fbb..0fefad6fbb9f 100644
--- a/drivers/md/dm-ima.c
+++ b/drivers/md/dm-ima.c
@@ -164,7 +164,7 @@ static int dm_ima_alloc_and_copy_capacity_str(struct mapped_device *md, char **c
 }
 
 /*
- * Initialize/reset the dm ima related data structure variables.
+ * Reset the dm ima related data structure variables.
  */
 void dm_ima_reset_data(struct mapped_device *md)
 {
@@ -172,6 +172,23 @@ void dm_ima_reset_data(struct mapped_device *md)
 	md->ima.dm_version_str_len = strlen(DM_IMA_VERSION_STR);
 }
 
+/*
+ * Initialize the dm ima.
+ */
+void dm_ima_init(struct mapped_device *md)
+{
+	dm_ima_reset_data(md);
+	mutex_init(&md->ima_lock);
+}
+
+/*
+ * Destroy the dm ima related data structure.
+ */
+void dm_ima_destroy(struct mapped_device *md)
+{
+	mutex_destroy(&md->ima_lock);
+}
+
 /*
  * Build up the IMA data for each target, and finally measure.
  */
@@ -195,9 +212,10 @@ void dm_ima_measure_on_table_load(struct dm_table *table, unsigned int status_fl
 	const size_t hash_alg_prefix_len = strlen(DM_IMA_TABLE_HASH_ALG) + 1;
 	char table_load_event_name[] = "dm_table_load";
 
+	mutex_lock(&table->md->ima_lock);
 	ima_buf = dm_ima_alloc(DM_IMA_MEASUREMENT_BUF_LEN, GFP_KERNEL, noio);
 	if (!ima_buf)
-		return;
+		goto error;
 
 	target_metadata_buf = dm_ima_alloc(DM_IMA_TARGET_METADATA_BUF_LEN, GFP_KERNEL, noio);
 	if (!target_metadata_buf)
@@ -361,6 +379,7 @@ void dm_ima_measure_on_table_load(struct dm_table *table, unsigned int status_fl
 	kfree(ima_buf);
 	kfree(target_metadata_buf);
 	kfree(target_data_buf);
+	mutex_unlock(&table->md->ima_lock);
 }
 
 /*
@@ -376,9 +395,10 @@ void dm_ima_measure_on_device_resume(struct mapped_device *md, bool swap)
 	bool nodata = true;
 	int r;
 
+	mutex_lock(&md->ima_lock);
 	device_table_data = dm_ima_alloc(DM_IMA_DEVICE_BUF_LEN, GFP_KERNEL, noio);
 	if (!device_table_data)
-		return;
+		goto error;
 
 	r = dm_ima_alloc_and_copy_capacity_str(md, &capacity_str, noio);
 	if (r)
@@ -466,6 +486,7 @@ void dm_ima_measure_on_device_resume(struct mapped_device *md, bool swap)
 error:
 	kfree(capacity_str);
 	kfree(device_table_data);
+	mutex_unlock(&md->ima_lock);
 }
 
 /*
@@ -490,6 +511,7 @@ void dm_ima_measure_on_device_remove(struct mapped_device *md, bool remove_all)
 	bool nodata = true;
 	int r;
 
+	mutex_lock(&md->ima_lock);
 	device_table_data = dm_ima_alloc(DM_IMA_DEVICE_BUF_LEN*2, GFP_KERNEL, noio);
 	if (!device_table_data)
 		goto exit;
@@ -597,6 +619,7 @@ void dm_ima_measure_on_device_remove(struct mapped_device *md, bool remove_all)
 
 	kfree(dev_name);
 	kfree(dev_uuid);
+	mutex_unlock(&md->ima_lock);
 }
 
 /*
@@ -612,9 +635,10 @@ void dm_ima_measure_on_table_clear(struct mapped_device *md, bool new_map)
 	bool nodata = true;
 	int r;
 
+	mutex_lock(&md->ima_lock);
 	device_table_data = dm_ima_alloc(DM_IMA_DEVICE_BUF_LEN, GFP_KERNEL, noio);
 	if (!device_table_data)
-		return;
+		goto error;
 
 	r = dm_ima_alloc_and_copy_capacity_str(md, &capacity_str, noio);
 	if (r)
@@ -696,6 +720,8 @@ void dm_ima_measure_on_table_clear(struct mapped_device *md, bool new_map)
 	kfree(capacity_str);
 error1:
 	kfree(device_table_data);
+error:
+	mutex_unlock(&md->ima_lock);
 }
 
 /*
@@ -708,9 +734,10 @@ void dm_ima_measure_on_device_rename(struct mapped_device *md)
 	bool noio = true;
 	int r;
 
+	mutex_lock(&md->ima_lock);
 	if (dm_ima_alloc_and_copy_device_data(md, &new_device_data,
 					      md->ima.active_table.num_targets, noio))
-		return;
+		goto error;
 
 	if (dm_ima_alloc_and_copy_name_uuid(md, &new_dev_name, &new_dev_uuid, noio))
 		goto error;
@@ -745,4 +772,5 @@ void dm_ima_measure_on_device_rename(struct mapped_device *md)
 	kfree(old_device_data);
 	kfree(new_dev_name);
 	kfree(new_dev_uuid);
+	mutex_unlock(&md->ima_lock);
 }
diff --git a/drivers/md/dm-ima.h b/drivers/md/dm-ima.h
index 568870a1a145..36bbcf1b25a0 100644
--- a/drivers/md/dm-ima.h
+++ b/drivers/md/dm-ima.h
@@ -57,6 +57,8 @@ struct dm_ima_measurements {
 };
 
 void dm_ima_reset_data(struct mapped_device *md);
+void dm_ima_init(struct mapped_device *md);
+void dm_ima_destroy(struct mapped_device *md);
 void dm_ima_measure_on_table_load(struct dm_table *table, unsigned int status_flags);
 void dm_ima_measure_on_device_resume(struct mapped_device *md, bool swap);
 void dm_ima_measure_on_device_remove(struct mapped_device *md, bool remove_all);
@@ -66,6 +68,8 @@ void dm_ima_measure_on_device_rename(struct mapped_device *md);
 #else
 
 static inline void dm_ima_reset_data(struct mapped_device *md) {}
+static inline void dm_ima_init(struct mapped_device *md) {}
+static inline void dm_ima_destroy(struct mapped_device *md) {}
 static inline void dm_ima_measure_on_table_load(struct dm_table *table, unsigned int status_flags) {}
 static inline void dm_ima_measure_on_device_resume(struct mapped_device *md, bool swap) {}
 static inline void dm_ima_measure_on_device_remove(struct mapped_device *md, bool remove_all) {}
diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index 1726f0f828cc..b7eab324804c 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -2371,6 +2371,7 @@ static void free_dev(struct mapped_device *md)
 	unlock_fs(md);
 
 	cleanup_mapped_device(md);
+	dm_ima_destroy(md);
 
 	WARN_ON_ONCE(!list_empty(&md->table_devices));
 	dm_stats_cleanup(&md->stats);
@@ -2506,7 +2507,7 @@ int dm_create(int minor, struct mapped_device **result)
 	if (!md)
 		return -ENXIO;
 
-	dm_ima_reset_data(md);
+	dm_ima_init(md);
 
 	*result = md;
 	return 0;
-- 
2.46.1


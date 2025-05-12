Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 267261F0985
	for <dm-devel@lists.linux.dev>; Mon, 12 May 2025 01:28:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747013298; cv=none; b=PDwTllT1PR6YwQ1Qe3P1ZDF2NMhCcmktyHDS/Zio+Fa8tH/5IfvVnRHipl5OS4lSyMe0FxFmlxrLBdlksYLeDAKfw3Xo2tTv4HbkaQZkMN8cWcHsugbJuUULbzO8kn2jUS9lu/FiI+gThEGVLcYltYI/Q/cYILY9Zvm3Ef6FYTY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747013298; c=relaxed/simple;
	bh=3qyIzPyheqrZy522eEuD2AFtuIz3klS4ja7thurjK0o=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=ShI0IuG9mm4Jnz+qciqsowv9l1b6RQCuFQpwkiDZZ9POTvIpw4FKEV8r/3SuEsRseMneZgFmJnl4/aJjVR+UkIoEKeTPmp6ZfWthgZyFjrSPe76d4sSiJvUEVGIMm2jwuXlvzYWhpJ8iv6/NshdQBhEO2mU/ViHRcA9uncTQRXQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.93.142])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTP id 4Zwhn02lNlz4f3jXg
	for <dm-devel@lists.linux.dev>; Mon, 12 May 2025 09:27:48 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 122BD1A0359
	for <dm-devel@lists.linux.dev>; Mon, 12 May 2025 09:28:13 +0800 (CST)
Received: from huaweicloud.com (unknown [10.175.104.67])
	by APP4 (Coremail) with SMTP id gCh0CgCnC2CdTiFoNFCWMA--.55093S23;
	Mon, 12 May 2025 09:28:12 +0800 (CST)
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
Subject: [PATCH RFC md-6.16 v3 19/19] md/md-llbitmap: add Kconfig
Date: Mon, 12 May 2025 09:19:27 +0800
Message-Id: <20250512011927.2809400-20-yukuai1@huaweicloud.com>
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
X-CM-TRANSID:gCh0CgCnC2CdTiFoNFCWMA--.55093S23
X-Coremail-Antispam: 1UD129KBjvJXoWxuFWxKFW5Zr1xZrWxtry7ZFb_yoW7CFWfpF
	WfXry3Cw15tF4xXw15A347uFyrJws3tr9Fvrn3C34ruFyUArZIqr4xKFyUtw1DWrsxJFn8
	J3W5Kr95G3W5XaUanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
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

A new config MD_LLBITMAP is added, user can now using llbitmap to
replace the old bitmap.

Signed-off-by: Yu Kuai <yukuai3@huawei.com>
---
 drivers/md/Kconfig       | 12 ++++++
 drivers/md/Makefile      |  1 +
 drivers/md/md-bitmap.h   | 16 ++++++++
 drivers/md/md-llbitmap.c | 80 ++++++++++++++++++++++++++++++++++++++++
 drivers/md/md.c          |  6 +++
 5 files changed, 115 insertions(+)

diff --git a/drivers/md/Kconfig b/drivers/md/Kconfig
index f913579e731c..655c4e381f7d 100644
--- a/drivers/md/Kconfig
+++ b/drivers/md/Kconfig
@@ -52,6 +52,18 @@ config MD_BITMAP
 
 	  If unsure, say Y.
 
+config MD_LLBITMAP
+	bool "MD RAID lockless bitmap support"
+	default n
+	depends on BLK_DEV_MD
+	help
+	  If you say Y here, support for the lockless write intent bitmap will
+	  be enabled.
+
+	  Note, this is an experimental feature.
+
+	  If unsure, say N.
+
 config MD_AUTODETECT
 	bool "Autodetect RAID arrays during kernel boot"
 	depends on BLK_DEV_MD=y
diff --git a/drivers/md/Makefile b/drivers/md/Makefile
index 811731840a5c..e70e4d3cbe29 100644
--- a/drivers/md/Makefile
+++ b/drivers/md/Makefile
@@ -39,6 +39,7 @@ linear-y       += md-linear.o
 obj-$(CONFIG_MD_LINEAR)		+= linear.o
 obj-$(CONFIG_MD_RAID0)		+= raid0.o
 obj-$(CONFIG_MD_BITMAP)		+= md-bitmap.o
+obj-$(CONFIG_MD_LLBITMAP)	+= md-llbitmap.o
 obj-$(CONFIG_MD_RAID1)		+= raid1.o
 obj-$(CONFIG_MD_RAID10)		+= raid10.o
 obj-$(CONFIG_MD_RAID456)	+= raid456.o
diff --git a/drivers/md/md-bitmap.h b/drivers/md/md-bitmap.h
index 4e27f5f793b7..dd23b6fedb70 100644
--- a/drivers/md/md-bitmap.h
+++ b/drivers/md/md-bitmap.h
@@ -22,6 +22,9 @@ typedef __u16 bitmap_counter_t;
 enum bitmap_state {
 	BITMAP_STALE	   = 1,  /* the bitmap file is out of date or had -EIO */
 	BITMAP_WRITE_ERROR = 2, /* A write error has occurred */
+	BITMAP_FIRST_USE   = 3, /* llbitmap is just created */
+	BITMAP_CLEAN	   = 4, /* llbitmap is created with assume_clean */
+	BITMAP_DAEMON_BUSY = 5, /* llbitmap daemon is not finished after daemon_sleep */
 	BITMAP_HOSTENDIAN  =15,
 };
 
@@ -176,4 +179,17 @@ static inline void md_bitmap_exit(void)
 }
 #endif
 
+#ifdef CONFIG_MD_LLBITMAP
+int md_llbitmap_init(void);
+void md_llbitmap_exit(void);
+#else
+static inline int md_llbitmap_init(void)
+{
+	return 0;
+}
+static inline void md_llbitmap_exit(void)
+{
+}
+#endif
+
 #endif
diff --git a/drivers/md/md-llbitmap.c b/drivers/md/md-llbitmap.c
index 6993be132127..5bb60340c7e2 100644
--- a/drivers/md/md-llbitmap.c
+++ b/drivers/md/md-llbitmap.c
@@ -1383,3 +1383,83 @@ static struct attribute *md_llbitmap_attrs[] = {
 	&llbitmap_daemon_sleep.attr,
 	NULL
 };
+
+static struct attribute_group md_llbitmap_group = {
+	.name = "llbitmap",
+	.attrs = md_llbitmap_attrs,
+};
+
+static struct bitmap_operations llbitmap_ops = {
+	.head = {
+		.type	= MD_BITMAP,
+		.id	= ID_LLBITMAP,
+		.name	= "llbitmap",
+	},
+
+	.enabled		= llbitmap_enabled,
+	.create			= llbitmap_create,
+	.resize			= llbitmap_resize,
+	.load			= llbitmap_load,
+	.destroy		= llbitmap_destroy,
+
+	.startwrite		= llbitmap_startwrite,
+	.endwrite		= llbitmap_endwrite,
+	.start_discard		= llbitmap_start_discard,
+	.end_discard		= llbitmap_end_discard,
+	.unplug			= llbitmap_unplug,
+	.flush			= llbitmap_flush,
+
+	.blocks_synced		= llbitmap_blocks_synced,
+	.skip_sync_blocks	= llbitmap_skip_sync_blocks,
+	.start_sync		= llbitmap_start_sync,
+	.end_sync		= llbitmap_end_sync,
+	.close_sync		= llbitmap_close_sync,
+
+	.update_sb		= llbitmap_update_sb,
+	.get_stats		= llbitmap_get_stats,
+	.dirty_bits		= llbitmap_dirty_bits,
+
+	/* not needed */
+	.write_all		= llbitmap_write_all,
+	.daemon_work		= llbitmap_daemon_work,
+	.cond_end_sync		= llbitmap_cond_end_sync,
+
+	/* not supported */
+	.start_behind_write	= llbitmap_start_behind_write,
+	.end_behind_write	= llbitmap_end_behind_write,
+	.wait_behind_writes	= llbitmap_wait_behind_writes,
+	.sync_with_cluster	= llbitmap_sync_with_cluster,
+	.get_from_slot		= llbitmap_get_from_slot,
+	.copy_from_slot		= llbitmap_copy_from_slot,
+	.set_pages		= llbitmap_set_pages,
+	.free			= llbitmap_free,
+
+	.group			= &md_llbitmap_group,
+};
+
+int md_llbitmap_init(void)
+{
+	md_llbitmap_io_wq = alloc_workqueue("md_llbitmap_io",
+					 WQ_MEM_RECLAIM | WQ_UNBOUND, 0);
+	if (!md_llbitmap_io_wq)
+		return -ENOMEM;
+
+	md_llbitmap_unplug_wq = alloc_workqueue("md_llbitmap_unplug",
+					 WQ_MEM_RECLAIM | WQ_UNBOUND, 0);
+	if (!md_llbitmap_unplug_wq) {
+		destroy_workqueue(md_llbitmap_io_wq);
+		md_llbitmap_io_wq = NULL;
+		return -ENOMEM;
+	}
+
+	return register_md_submodule(&llbitmap_ops.head);
+}
+
+void md_llbitmap_exit(void)
+{
+	destroy_workqueue(md_llbitmap_io_wq);
+	md_llbitmap_io_wq = NULL;
+	destroy_workqueue(md_llbitmap_unplug_wq);
+	md_llbitmap_unplug_wq = NULL;
+	unregister_md_submodule(&llbitmap_ops.head);
+}
diff --git a/drivers/md/md.c b/drivers/md/md.c
index a5dd7a403ea5..6ac5747738dd 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -10191,6 +10191,10 @@ static int __init md_init(void)
 	if (ret)
 		return ret;
 
+	ret = md_llbitmap_init();
+	if (ret)
+		goto err_bitmap;
+
 	ret = -ENOMEM;
 	md_wq = alloc_workqueue("md", WQ_MEM_RECLAIM, 0);
 	if (!md_wq)
@@ -10222,6 +10226,8 @@ static int __init md_init(void)
 err_misc_wq:
 	destroy_workqueue(md_wq);
 err_wq:
+	md_llbitmap_exit();
+err_bitmap:
 	md_bitmap_exit();
 	return ret;
 }
-- 
2.39.2


Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD5402144A5
	for <dm-devel@lists.linux.dev>; Fri, 28 Mar 2025 06:14:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743142500; cv=none; b=r8S24TT1JwY6iQSFJiAoHwKLyK9QHvGWdJMcBacvzcmf0RIlgpTZCHeTXu6Niy3V6gm4ZLr/ZEdVjXXxPRrp75p1fNMSnrWj+eBjN1cGqbGoKQRMtan502cRdqjdN0PVX3W9ll24DoqnUcV/RQ2lw8t5oRgY8Y9lDmF1nbcloBw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743142500; c=relaxed/simple;
	bh=ZtBApdvbCHQMo0CY4GcBbl/RqYZCO4FTf2913i3BV6g=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=fD2xg6kbT7BOw+gJFU/7UP2UtKdU9MyhrwZjLXh1KOvzxY6zOb9Eg2FJIX/GHOfaQuaICLQoSvfT4oOWFg+3MQX/RM57TAkgAMFgAUe0TvXxfy6Qt//QqAsmHlc0ZLIf7FCgOx3dFybFQTDF2ZSgTyy8h8b88zliL/fMeUfKd3E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.93.142])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTP id 4ZP9Gb67JMz4f3jdD
	for <dm-devel@lists.linux.dev>; Fri, 28 Mar 2025 14:14:31 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id D396A1A0F67
	for <dm-devel@lists.linux.dev>; Fri, 28 Mar 2025 14:14:54 +0800 (CST)
Received: from huaweicloud.com (unknown [10.175.104.67])
	by APP4 (Coremail) with SMTP id gCh0CgDHK2BSPuZnfAUtHw--.25875S18;
	Fri, 28 Mar 2025 14:14:54 +0800 (CST)
From: Yu Kuai <yukuai1@huaweicloud.com>
To: hch@lst.de,
	xni@redhat.com,
	colyli@kernel.org,
	axboe@kernel.dk,
	agk@redhat.com,
	snitzer@kernel.org,
	mpatocka@redhat.com,
	song@kernel.org,
	yukuai3@huawei.com
Cc: linux-block@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	dm-devel@lists.linux.dev,
	linux-raid@vger.kernel.org,
	yukuai1@huaweicloud.com,
	yi.zhang@huawei.com,
	yangerkun@huawei.com
Subject: [PATCH RFC v2 14/14] md/md-llbitmap: add Kconfig
Date: Fri, 28 Mar 2025 14:08:53 +0800
Message-Id: <20250328060853.4124527-15-yukuai1@huaweicloud.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20250328060853.4124527-1-yukuai1@huaweicloud.com>
References: <20250328060853.4124527-1-yukuai1@huaweicloud.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgDHK2BSPuZnfAUtHw--.25875S18
X-Coremail-Antispam: 1UD129KBjvJXoWxXF17trW3GFW3trW3Zr4xZwb_yoWrJw1rpF
	Z3Xry5Cr1rtF4xXw13Aa4UuF98Jan7Kr9rurn3u3yruFWDArZ8Jr4xKFyUtw1DWrsxJF9x
	JF1rGa9xG3WYqw7anT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
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
	AF67kF1VAFwI0_GFv_WrylIxkGc2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVW8JVW5JwCI
	42IY6xIIjxv20xvEc7CjxVAFwI0_Gr1j6F4UJwCI42IY6xAIw20EY4v20xvaj40_Jr0_JF
	4lIxAIcVC2z280aVAFwI0_Gr0_Cr1lIxAIcVC2z280aVCY1x0267AKxVW8Jr0_Cr1UYxBI
	daVFxhVjvjDU0xZFpf9x0JUQFxUUUUUU=
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/

From: Yu Kuai <yukuai3@huawei.com>

A new config MD_LLBITMAP is added, user can now using llbitmap to
replace the old bitmap.

Signed-off-by: Yu Kuai <yukuai3@huawei.com>
---
 drivers/md/Kconfig       | 12 ++++++++++++
 drivers/md/Makefile      |  1 +
 drivers/md/md-bitmap.h   | 13 +++++++++++++
 drivers/md/md-llbitmap.c | 27 +++++++++++++++++++++++++++
 drivers/md/md.c          |  7 +++++++
 5 files changed, 60 insertions(+)

diff --git a/drivers/md/Kconfig b/drivers/md/Kconfig
index 0da07182494c..e5dc893ad09a 100644
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
index 7a3cd2f70772..ee0c65e87dba 100644
--- a/drivers/md/md-bitmap.h
+++ b/drivers/md/md-bitmap.h
@@ -171,4 +171,17 @@ static inline void md_bitmap_exit(void)
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
index 88ba29111e13..5e2f89137feb 100644
--- a/drivers/md/md-llbitmap.c
+++ b/drivers/md/md-llbitmap.c
@@ -1381,3 +1381,30 @@ static struct bitmap_operations llbitmap_ops = {
 
 	.group			= &md_llbitmap_group,
 };
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
index c1f13288069a..4d05eae69795 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -10104,6 +10104,10 @@ static int __init md_init(void)
 	if (ret)
 		return ret;
 
+	ret = md_llbitmap_init();
+	if (ret)
+		goto err_bitmap;
+
 	ret = -ENOMEM;
 	md_wq = alloc_workqueue("md", WQ_MEM_RECLAIM, 0);
 	if (!md_wq)
@@ -10135,6 +10139,8 @@ static int __init md_init(void)
 err_misc_wq:
 	destroy_workqueue(md_wq);
 err_wq:
+	md_llbitmap_exit();
+err_bitmap:
 	md_bitmap_exit();
 	return ret;
 }
@@ -10439,6 +10445,7 @@ static __exit void md_exit(void)
 
 	destroy_workqueue(md_misc_wq);
 	destroy_workqueue(md_wq);
+	md_llbitmap_exit();
 	md_bitmap_exit();
 }
 
-- 
2.39.2


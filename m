Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5EB31C54BD
	for <dm-devel@lists.linux.dev>; Wed, 25 Dec 2024 11:20:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735125605; cv=none; b=avON5/9haKGb7IjT4ncXZTpUjx2Sxqfy+88w/kUjFa0VgFPx/QQN1gYWhP27OThTH5GMec0XNxhk9nV5pGxENMUv2Fyv8m1rSnbZqLT9/rJ9CO/oMLbw1l55FNSWA91Beo4CGW0keStLH0l7IizzVGOm2klJnitefYkdux9nqCc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735125605; c=relaxed/simple;
	bh=VZkm9LDTjHchVq5thCpy9wWtKRN6gTJmdmFnwGlF3nc=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=FE8QT31fV8ZdaO3beMKcmLIKkpXS5sprvJhNu0qAEhMSFoUQ4jMYXW9CMRUz4zpo2tbt8O1RC1jONVkNQIA4Sjn4PWB4ad+ggg/3uPKv8PFRuKh+UoEpolY7GX4el58/6xhsagsPtgEVKdm+1kUzOHVHtI5SHolXwAXqMQBWx3I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.216])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTP id 4YJ8RY647qz4f3jsC
	for <dm-devel@lists.linux.dev>; Wed, 25 Dec 2024 19:19:37 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 8ECF11A018C
	for <dm-devel@lists.linux.dev>; Wed, 25 Dec 2024 19:19:57 +0800 (CST)
Received: from huaweicloud.com (unknown [10.175.104.67])
	by APP4 (Coremail) with SMTP id gCh0CgAnT4NV6mtntXlgFg--.39006S16;
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
Subject: [PATCH md-6.14 12/13] md: export some helpers
Date: Wed, 25 Dec 2024 19:15:45 +0800
Message-Id: <20241225111546.1833250-13-yukuai1@huaweicloud.com>
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
X-CM-TRANSID:gCh0CgAnT4NV6mtntXlgFg--.39006S16
X-Coremail-Antispam: 1UD129KBjvJXoWxCF1UJw45trWfCw1rGr13CFg_yoW5tF48pa
	12ya45Gr45XrWYgwsrAF4kua4aqwn7tFZ7try3C34fZFnxKr1DCF1Fq3W5Ar98Ca4fCrnr
	X3W5KFW5uw1xXr7anT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
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

These helpers are used inside md-bitmap.c, prepare to build it as kernel
module first.

Signed-off-by: Yu Kuai <yukuai3@huawei.com>
---
 drivers/md/md.c | 15 ++++++---------
 drivers/md/md.h | 10 +++++++++-
 2 files changed, 15 insertions(+), 10 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 4170ef31a273..f1f70803439d 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -252,6 +252,7 @@ void mddev_create_serial_pool(struct mddev *mddev, struct md_rdev *rdev)
 		}
 	}
 }
+EXPORT_SYMBOL_GPL(mddev_create_serial_pool);
 
 /*
  * Free resource from rdev(s), and destroy serial_info_pool under conditions:
@@ -291,6 +292,7 @@ void mddev_destroy_serial_pool(struct mddev *mddev, struct md_rdev *rdev)
 		}
 	}
 }
+EXPORT_SYMBOL_GPL(mddev_destroy_serial_pool);
 
 static struct ctl_table_header *raid_table_header;
 
@@ -994,15 +996,7 @@ void md_super_write(struct mddev *mddev, struct md_rdev *rdev,
 	atomic_inc(&mddev->pending_writes);
 	submit_bio(bio);
 }
-
-int md_super_wait(struct mddev *mddev)
-{
-	/* wait for all superblock writes that were scheduled to complete */
-	wait_event(mddev->sb_wait, atomic_read(&mddev->pending_writes)==0);
-	if (test_and_clear_bit(MD_SB_NEED_REWRITE, &mddev->sb_flags))
-		return -EAGAIN;
-	return 0;
-}
+EXPORT_SYMBOL_GPL(md_super_write);
 
 int sync_page_io(struct md_rdev *rdev, sector_t sector, int size,
 		 struct page *page, blk_opf_t opf, bool metadata_op)
@@ -3820,6 +3814,7 @@ int strict_strtoul_scaled(const char *cp, unsigned long *res, int scale)
 	*res = result * int_pow(10, scale - decimals);
 	return 0;
 }
+EXPORT_SYMBOL_GPL(strict_strtoul_scaled);
 
 static ssize_t
 safe_delay_show(struct mddev *mddev, char *page)
@@ -8606,6 +8601,7 @@ int md_setup_cluster(struct mddev *mddev, int nodes)
 		mddev->safemode_delay = 0;
 	return ret;
 }
+EXPORT_SYMBOL_GPL(md_setup_cluster);
 
 void md_cluster_stop(struct mddev *mddev)
 {
@@ -8614,6 +8610,7 @@ void md_cluster_stop(struct mddev *mddev)
 	md_cluster_ops->leave(mddev);
 	module_put(md_cluster_mod);
 }
+EXPORT_SYMBOL_GPL(md_cluster_stop);
 
 static int is_mddev_idle(struct mddev *mddev, int init)
 {
diff --git a/drivers/md/md.h b/drivers/md/md.h
index 87edf81c25b0..7e8276d2dadc 100644
--- a/drivers/md/md.h
+++ b/drivers/md/md.h
@@ -874,7 +874,6 @@ void md_free_cloned_bio(struct bio *bio);
 extern bool __must_check md_flush_request(struct mddev *mddev, struct bio *bio);
 extern void md_super_write(struct mddev *mddev, struct md_rdev *rdev,
 			   sector_t sector, int size, struct page *page);
-extern int md_super_wait(struct mddev *mddev);
 extern int sync_page_io(struct md_rdev *rdev, sector_t sector, int size,
 		struct page *page, blk_opf_t opf, bool metadata_op);
 extern void md_do_sync(struct md_thread *thread);
@@ -999,6 +998,15 @@ static inline bool mddev_is_dm(struct mddev *mddev)
 	return !mddev->gendisk;
 }
 
+static inline int md_super_wait(struct mddev *mddev)
+{
+	/* wait for all superblock writes that were scheduled to complete */
+	wait_event(mddev->sb_wait, atomic_read(&mddev->pending_writes) == 0);
+	if (test_and_clear_bit(MD_SB_NEED_REWRITE, &mddev->sb_flags))
+		return -EAGAIN;
+	return 0;
+}
+
 static inline void mddev_trace_remap(struct mddev *mddev, struct bio *bio,
 		sector_t sector)
 {
-- 
2.39.2


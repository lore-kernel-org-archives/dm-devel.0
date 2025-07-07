Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C6351FBEAC
	for <dm-devel@lists.linux.dev>; Mon,  7 Jul 2025 01:32:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751851970; cv=none; b=VOOcSMakoKD+/nZMED+eN2Bxpp4Ptd+lZvrFNxZuAVmKPkQs5J6hjp70PZjcmfgziP8oa4uyOFi9tyAJ8L9JE532s8ewLid60ARKK4/dE7ZzCOe1aCuZnUZutoaG0VH9QDPfUilvIZd0kIJ1Y7xkRGQUrtZijbL7DDyRGDJ8Jl8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751851970; c=relaxed/simple;
	bh=jEQrD3JWf7qasjiLNtGv8jzcAM2d7EwDg8Yr5eQIRow=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=S3qoOAiXJFCBvlBV/FN/LIAcCUpi6qNE4OfWiNclFq80fuvTE9NO1JydXvBhoI69WkTAcZ8wrwJCGOeeUyvarKM54s7z9Dm9//IhedFLUt1xGeZW69KneGD49CH/WKnLRZ8NC6qUuzND6btQSX6P55MGc9qwLTjLAiOLETkl4ok=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.93.142])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTPS id 4bb6Dn2Jz4zKHMZv
	for <dm-devel@lists.linux.dev>; Mon,  7 Jul 2025 09:32:41 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.252])
	by mail.maildlp.com (Postfix) with ESMTP id C21901A1242
	for <dm-devel@lists.linux.dev>; Mon,  7 Jul 2025 09:32:39 +0800 (CST)
Received: from huaweicloud.com (unknown [10.175.104.67])
	by APP3 (Coremail) with SMTP id _Ch0CgDnSCazI2to_nSRAw--.35890S8;
	Mon, 07 Jul 2025 09:32:39 +0800 (CST)
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
Subject: [PATCH v5 04/15] md/md-bitmap: merge md_bitmap_group into bitmap_operations
Date: Mon,  7 Jul 2025 09:27:00 +0800
Message-Id: <20250707012711.376844-5-yukuai1@huaweicloud.com>
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
X-CM-TRANSID:_Ch0CgDnSCazI2to_nSRAw--.35890S8
X-Coremail-Antispam: 1UD129KBjvJXoWxXFy5CFWktFWrtF4UAry7Wrg_yoW5WryDpF
	ZrJ343uw1rJF45Xa17Z34q9a4rW3s7trZrKFWfCw1ruFy7XasxJr48Ca4jywn8WFy3CFsI
	qw1Yyw1Uur18WF7anT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUmI14x267AKxVWrJVCq3wAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2048vs2IY020E87I2jVAFwI0_JF0E3s1l82xGYI
	kIc2x26xkF7I0E14v26ryj6s0DM28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48ve4kI8wA2
	z4x0Y4vE2Ix0cI8IcVAFwI0_tr0E3s1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI0_Gr1j6F
	4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x0267AKxVW0oVCq
	3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0I7
	IYx2IY67AKxVWUJVWUGwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFVCjc4AY6r1j6r4U
	M4x0Y48IcxkI7VAKI48JM4x0x7Aq67IIx4CEVc8vx2IErcIFxwACI402YVCY1x02628vn2
	kIc2xKxwCY1x0262kKe7AKxVWUtVW8ZwCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7xkE
	bVWUJVW8JwC20s026c02F40E14v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67
	AF67kF1VAFwI0_Jw0_GFylIxkGc2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWUJVWUCwCI
	42IY6xIIjxv20xvEc7CjxVAFwI0_Cr0_Gr1UMIIF0xvE42xK8VAvwI8IcIk0rVWUJVWUCw
	CI42IY6I8E87Iv67AKxVWUJVW8JwCI42IY6I8E87Iv6xkF7I0E14v26r4j6r4UJbIYCTnI
	WIevJa73UjIFyTuYvjfUOyIUUUUUU
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/

From: Yu Kuai <yukuai3@huawei.com>

Now that all bitmap implementations are internal, it doesn't make sense
to export md_bitmap_group anymore.

Signed-off-by: Yu Kuai <yukuai3@huawei.com>
---
 drivers/md/md-bitmap.c | 5 ++++-
 drivers/md/md-bitmap.h | 2 ++
 drivers/md/md.c        | 6 +++++-
 drivers/md/md.h        | 1 -
 4 files changed, 11 insertions(+), 3 deletions(-)

diff --git a/drivers/md/md-bitmap.c b/drivers/md/md-bitmap.c
index fc7282304b00..0ba1da35aa84 100644
--- a/drivers/md/md-bitmap.c
+++ b/drivers/md/md-bitmap.c
@@ -2990,7 +2990,8 @@ static struct attribute *md_bitmap_attrs[] = {
 	&max_backlog_used.attr,
 	NULL
 };
-const struct attribute_group md_bitmap_group = {
+
+static struct attribute_group md_bitmap_group = {
 	.name = "bitmap",
 	.attrs = md_bitmap_attrs,
 };
@@ -3026,6 +3027,8 @@ static struct bitmap_operations bitmap_ops = {
 	.copy_from_slot		= bitmap_copy_from_slot,
 	.set_pages		= bitmap_set_pages,
 	.free			= md_bitmap_free,
+
+	.group			= &md_bitmap_group,
 };
 
 void mddev_set_bitmap_ops(struct mddev *mddev)
diff --git a/drivers/md/md-bitmap.h b/drivers/md/md-bitmap.h
index 28c1f1c1cc83..0ceb9e97d21f 100644
--- a/drivers/md/md-bitmap.h
+++ b/drivers/md/md-bitmap.h
@@ -100,6 +100,8 @@ struct bitmap_operations {
 			      sector_t *hi, bool clear_bits);
 	void (*set_pages)(void *data, unsigned long pages);
 	void (*free)(void *data);
+
+	struct attribute_group *group;
 };
 
 /* the bitmap API */
diff --git a/drivers/md/md.c b/drivers/md/md.c
index bda3ef814d97..7ed95e5e43fc 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -5749,7 +5749,6 @@ static const struct attribute_group md_redundancy_group = {
 
 static const struct attribute_group *md_attr_groups[] = {
 	&md_default_group,
-	&md_bitmap_group,
 	NULL,
 };
 
@@ -5996,6 +5995,11 @@ struct mddev *md_alloc(dev_t dev, char *name)
 		return ERR_PTR(error);
 	}
 
+	if (mddev->bitmap_ops && mddev->bitmap_ops->group)
+		if (sysfs_create_group(&mddev->kobj, mddev->bitmap_ops->group))
+			pr_warn("md: cannot register extra bitmap attributes for %s\n",
+				mdname(mddev));
+
 	kobject_uevent(&mddev->kobj, KOBJ_ADD);
 	mddev->sysfs_state = sysfs_get_dirent_safe(mddev->kobj.sd, "array_state");
 	mddev->sysfs_level = sysfs_get_dirent_safe(mddev->kobj.sd, "level");
diff --git a/drivers/md/md.h b/drivers/md/md.h
index 67b365621507..d6fba4240f97 100644
--- a/drivers/md/md.h
+++ b/drivers/md/md.h
@@ -796,7 +796,6 @@ struct md_sysfs_entry {
 	ssize_t (*show)(struct mddev *, char *);
 	ssize_t (*store)(struct mddev *, const char *, size_t);
 };
-extern const struct attribute_group md_bitmap_group;
 
 static inline struct kernfs_node *sysfs_get_dirent_safe(struct kernfs_node *sd, char *name)
 {
-- 
2.39.2


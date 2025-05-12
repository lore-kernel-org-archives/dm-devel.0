Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6CA291E1E1C
	for <dm-devel@lists.linux.dev>; Mon, 12 May 2025 01:28:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747013289; cv=none; b=e/RDjarYovEFw4yx44UApzyITBZZImYuTNjNj2fRnCRWaOpTc/a7TBHqh9eOSunisPn3r2YV0yvjnONItj9BGsmIszTrLqW6GMEJ/5gFwaOry93EVGP4kR3NSrkGIreENlSayueDhH4GWKxQWdygrDhxrXhNnw96A25/0tFqEUM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747013289; c=relaxed/simple;
	bh=+bTjueXGLimEjGnnKu6X/smZI2jnnYnymsrut/5kwh4=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=hcYUSTmtGWcxutKDqfj4kwz2ygNg4eivjtmFXypRgsun413GE+tsQTgCGMUv7M5q1OCUs6ljX/32sFctREhZOPcyhE1jbjFvvFLE5dXnESF+dOokrqvA6ROSKZSn11m9HVdgtFrbULFx4EWYZnYWgxY5/Z3omjyfLekGMnPyZlU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.216])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTP id 4Zwhmp1Cg6z4f3lCf
	for <dm-devel@lists.linux.dev>; Mon, 12 May 2025 09:27:38 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 58CD81A1A95
	for <dm-devel@lists.linux.dev>; Mon, 12 May 2025 09:28:04 +0800 (CST)
Received: from huaweicloud.com (unknown [10.175.104.67])
	by APP4 (Coremail) with SMTP id gCh0CgCnC2CdTiFoNFCWMA--.55093S8;
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
Subject: [PATCH RFC md-6.16 v3 04/19] md: add a new sysfs api bitmap_version
Date: Mon, 12 May 2025 09:19:12 +0800
Message-Id: <20250512011927.2809400-5-yukuai1@huaweicloud.com>
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
X-CM-TRANSID:gCh0CgCnC2CdTiFoNFCWMA--.55093S8
X-Coremail-Antispam: 1UD129KBjvJXoWxWF1xKrW7KF4fXFW3Ww4xCrg_yoWrZFW8pa
	y8tFy3GF4rXFZ2qr4xGasruFnYgw1vya9Fq34ft34rGr13WrsxGFWrK3W5tr1kG3Wxurnx
	uF15JF48WrWUuF7anT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
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
	AF67kF1VAFwI0_Jw0_GFylIxkGc2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWUJVWUCwCI
	42IY6xIIjxv20xvEc7CjxVAFwI0_Cr0_Gr1UMIIF0xvE42xK8VAvwI8IcIk0rVWUJVWUCw
	CI42IY6I8E87Iv67AKxVWUJVW8JwCI42IY6I8E87Iv6xkF7I0E14v26r4j6r4UJbIYCTnI
	WIevJa73UjIFyTuYvjfUOyIUUUUUU
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/

From: Yu Kuai <yukuai3@huawei.com>

The api will be used by mdadm to set bitmap version while creating new
array or assemble array, prepare to add a new bitmap.

Currently available options are:

cat /sys/block/md0/md/bitmap_version
none [bitmap]

Signed-off-by: Yu Kuai <yukuai3@huawei.com>
---
 drivers/md/md.c | 87 ++++++++++++++++++++++++++++++++++++++++++++++---
 drivers/md/md.h |  2 ++
 2 files changed, 84 insertions(+), 5 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index dc2b2b274677..e16d3b4033d5 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -672,13 +672,13 @@ static void active_io_release(struct percpu_ref *ref)
 
 static void no_op(struct percpu_ref *r) {}
 
-static void mddev_set_bitmap_ops(struct mddev *mddev, enum md_submodule_id id)
+static void mddev_set_bitmap_ops(struct mddev *mddev)
 {
 	xa_lock(&md_submodule);
-	mddev->bitmap_ops = xa_load(&md_submodule, id);
+	mddev->bitmap_ops = xa_load(&md_submodule, mddev->bitmap_id);
 	xa_unlock(&md_submodule);
 	if (!mddev->bitmap_ops)
-		pr_warn_once("md: can't find bitmap id %d\n", id);
+		pr_warn_once("md: can't find bitmap id %d\n", mddev->bitmap_id);
 }
 
 static void mddev_clear_bitmap_ops(struct mddev *mddev)
@@ -688,8 +688,8 @@ static void mddev_clear_bitmap_ops(struct mddev *mddev)
 
 int mddev_init(struct mddev *mddev)
 {
-	/* TODO: support more versions */
-	mddev_set_bitmap_ops(mddev, ID_BITMAP);
+	mddev->bitmap_id = ID_BITMAP;
+	mddev_set_bitmap_ops(mddev);
 
 	if (percpu_ref_init(&mddev->active_io, active_io_release,
 			    PERCPU_REF_ALLOW_REINIT, GFP_KERNEL)) {
@@ -4155,6 +4155,82 @@ new_level_store(struct mddev *mddev, const char *buf, size_t len)
 static struct md_sysfs_entry md_new_level =
 __ATTR(new_level, 0664, new_level_show, new_level_store);
 
+static ssize_t
+bitmap_version_show(struct mddev *mddev, char *page)
+{
+	struct md_submodule_head *head;
+	unsigned long i;
+	ssize_t len = 0;
+
+	if (mddev->bitmap_id == ID_BITMAP_NONE)
+		len += sprintf(page + len, "[none] ");
+	else
+		len += sprintf(page + len, "none ");
+
+	xa_lock(&md_submodule);
+	xa_for_each(&md_submodule, i, head) {
+		if (head->type != MD_BITMAP)
+			continue;
+
+		if (mddev->bitmap_id == head->id)
+			len += sprintf(page + len, "[%s] ", head->name);
+		else
+			len += sprintf(page + len, "%s ", head->name);
+	}
+	xa_unlock(&md_submodule);
+
+	len += sprintf(page + len, "\n");
+	return len;
+}
+
+static ssize_t
+bitmap_version_store(struct mddev *mddev, const char *buf, size_t len)
+{
+	struct md_submodule_head *head;
+	enum md_submodule_id id;
+	unsigned long i;
+	int err;
+
+	if (mddev->bitmap_ops)
+		return -EBUSY;
+
+	err = kstrtoint(buf, 10, &id);
+	if (!err) {
+		if (id == ID_BITMAP_NONE) {
+			mddev->bitmap_id = id;
+			return len;
+		}
+
+		xa_lock(&md_submodule);
+		head = xa_load(&md_submodule, id);
+		xa_unlock(&md_submodule);
+
+		if (head && head->type == MD_BITMAP) {
+			mddev->bitmap_id = id;
+			return len;
+		}
+	}
+
+	if (cmd_match(buf, "none")) {
+		mddev->bitmap_id = ID_BITMAP_NONE;
+		return len;
+	}
+
+	xa_lock(&md_submodule);
+	xa_for_each(&md_submodule, i, head) {
+		if (head->type == MD_BITMAP && cmd_match(buf, head->name)) {
+			mddev->bitmap_id = head->id;
+			xa_unlock(&md_submodule);
+			return len;
+		}
+	}
+	xa_unlock(&md_submodule);
+	return -ENOENT;
+}
+
+static struct md_sysfs_entry md_bitmap_version =
+__ATTR(bitmap_version, 0664, bitmap_version_show, bitmap_version_store);
+
 static ssize_t
 layout_show(struct mddev *mddev, char *page)
 {
@@ -5719,6 +5795,7 @@ __ATTR(serialize_policy, S_IRUGO | S_IWUSR, serialize_policy_show,
 static struct attribute *md_default_attrs[] = {
 	&md_level.attr,
 	&md_new_level.attr,
+	&md_bitmap_version.attr,
 	&md_layout.attr,
 	&md_raid_disks.attr,
 	&md_uuid.attr,
diff --git a/drivers/md/md.h b/drivers/md/md.h
index c474bf74c345..135d95ba1ebb 100644
--- a/drivers/md/md.h
+++ b/drivers/md/md.h
@@ -40,6 +40,7 @@ enum md_submodule_id {
 	ID_CLUSTER,
 	ID_BITMAP,
 	ID_LLBITMAP,	/* TODO */
+	ID_BITMAP_NONE,
 };
 
 struct md_submodule_head {
@@ -565,6 +566,7 @@ struct mddev {
 	struct percpu_ref		writes_pending;
 	int				sync_checkers;	/* # of threads checking writes_pending */
 
+	enum md_submodule_id		bitmap_id;
 	void				*bitmap; /* the bitmap for the device */
 	struct bitmap_operations	*bitmap_ops;
 	struct {
-- 
2.39.2


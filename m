Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1246298CC4
	for <dm-devel@lists.linux.dev>; Fri, 29 Aug 2025 08:13:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756455203; cv=none; b=N2TeGjV6j4JUPSXJabcpn+RE2vRqffhXyxI8nqy/yO27yKqjFfrRaTBSexFTvvDaUB1TXFsLNsVxNNe2cTGXO2BzWpKfuUoTdy/UgZ6swkWEVRZokvEzkhJbKzh8YCVpyFDECocUmd+LyZwc+rkDKX4EU98al02VOTbvq9Jz6WM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756455203; c=relaxed/simple;
	bh=ZtzsUkYNyzaXjcn8Y1j15McSVbxGbmH59ttzdQKMFto=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=iQzJyHwpgTm/juHRJaQu2CBFJgYNe+OPX3IuhM5osQlzjMrmfp6wIxtiPGMQLs2zvR0Gda9sYnZP8hxrTnEUnUY/WrnbvbzzbkAcYFIUJ3tRpJTCWI5aPqwdk0ipDznXQshh/AwvNzbjP/Be/RrO25dzmJAU1cerHcQSacJ4l+w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.216])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTPS id 4cCrcV5f7LzYQvXX
	for <dm-devel@lists.linux.dev>; Fri, 29 Aug 2025 16:13:14 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 526E91A1DEB
	for <dm-devel@lists.linux.dev>; Fri, 29 Aug 2025 16:13:13 +0800 (CST)
Received: from huaweicloud.com (unknown [10.175.104.67])
	by APP4 (Coremail) with SMTP id gCh0CgB3wY0RYbFohAO2Ag--.45648S8;
	Fri, 29 Aug 2025 16:13:13 +0800 (CST)
From: Yu Kuai <yukuai1@huaweicloud.com>
To: hch@infradead.org,
	xni@redhat.com,
	colyli@kernel.org,
	linan122@huawei.com,
	corbet@lwn.net,
	agk@redhat.com,
	snitzer@kernel.org,
	mpatocka@redhat.com,
	song@kernel.org,
	yukuai3@huawei.com,
	hare@suse.de
Cc: linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	dm-devel@lists.linux.dev,
	linux-raid@vger.kernel.org,
	yukuai1@huaweicloud.com,
	yi.zhang@huawei.com,
	yangerkun@huawei.com,
	johnny.chenyi@huawei.com,
	hailan@yukuai.org.cn
Subject: [PATCH v7 md-6.18 04/11] md: add a new mddev field 'bitmap_id'
Date: Fri, 29 Aug 2025 16:04:19 +0800
Message-Id: <20250829080426.1441678-5-yukuai1@huaweicloud.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20250829080426.1441678-1-yukuai1@huaweicloud.com>
References: <20250829080426.1441678-1-yukuai1@huaweicloud.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgB3wY0RYbFohAO2Ag--.45648S8
X-Coremail-Antispam: 1UD129KBjvJXoWxuF4rGF1fWFWxGr17Kr18Grg_yoW5Xryfpa
	yxXa4fCFWrXFZ2qw43GasruFnYgwn2yFZFgrWfJ34rWFn8WrZ8WF4Fg3Wjqr1DG3WxXFnr
	u3W5tr48ury8ZF7anT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUma14x267AKxVWrJVCq3wAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2048vs2IY020E87I2jVAFwI0_JF0E3s1l82xGYI
	kIc2x26xkF7I0E14v26ryj6s0DM28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48ve4kI8wA2
	z4x0Y4vE2Ix0cI8IcVAFwI0_tr0E3s1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI0_Gr1j6F
	4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x0267AKxVW0oVCq
	3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0I7
	IYx2IY67AKxVWUJVWUGwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFVCjc4AY6r1j6r4U
	M4x0Y48IcxkI7VAKI48JM4x0x7Aq67IIx4CEVc8vx2IErcIFxwACI402YVCY1x02628vn2
	kIc2xKxwCY1x0262kKe7AKxVW8ZVWrXwCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7xkE
	bVWUJVW8JwC20s026c02F40E14v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67
	AF67kF1VAFwI0_GFv_WrylIxkGc2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWUJVWUCwCI
	42IY6xIIjxv20xvEc7CjxVAFwI0_Cr0_Gr1UMIIF0xvE42xK8VAvwI8IcIk0rVWUJVWUCw
	CI42IY6I8E87Iv67AKxVWUJVW8JwCI42IY6I8E87Iv6xkF7I0E14v26r4UJVWxJrUvcSsG
	vfC2KfnxnUUI43ZEXa7sRiHUDtUUUUU==
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/

From: Yu Kuai <yukuai3@huawei.com>

Prepare to store the bitmap id selected by user, also refactor
mddev_set_bitmap_ops a bit in case the value is invalid.

Signed-off-by: Yu Kuai <yukuai3@huawei.com>
Reviewed-by: Hannes Reinecke <hare@suse.de>
Reviewed-by: Li Nan <linan122@huawei.com>
Reviewed-by: Xiao Ni <xni@redhat.com>
---
 drivers/md/md.c | 37 +++++++++++++++++++++++++++++++------
 drivers/md/md.h |  2 ++
 2 files changed, 33 insertions(+), 6 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 2e088196d42c..82c84bdabe79 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -676,13 +676,33 @@ static void active_io_release(struct percpu_ref *ref)
 
 static void no_op(struct percpu_ref *r) {}
 
-static void mddev_set_bitmap_ops(struct mddev *mddev, enum md_submodule_id id)
+static bool mddev_set_bitmap_ops(struct mddev *mddev)
 {
+	struct md_submodule_head *head;
+
+	if (mddev->bitmap_id == ID_BITMAP_NONE)
+		return true;
+
 	xa_lock(&md_submodule);
-	mddev->bitmap_ops = xa_load(&md_submodule, id);
+	head = xa_load(&md_submodule, mddev->bitmap_id);
+
+	if (!head) {
+		pr_warn("md: can't find bitmap id %d\n", mddev->bitmap_id);
+		goto err;
+	}
+
+	if (head->type != MD_BITMAP) {
+		pr_warn("md: invalid bitmap id %d\n", mddev->bitmap_id);
+		goto err;
+	}
+
+	mddev->bitmap_ops = (void *)head;
 	xa_unlock(&md_submodule);
-	if (!mddev->bitmap_ops)
-		pr_warn_once("md: can't find bitmap id %d\n", id);
+	return true;
+
+err:
+	xa_unlock(&md_submodule);
+	return false;
 }
 
 static void mddev_clear_bitmap_ops(struct mddev *mddev)
@@ -692,8 +712,13 @@ static void mddev_clear_bitmap_ops(struct mddev *mddev)
 
 int mddev_init(struct mddev *mddev)
 {
-	/* TODO: support more versions */
-	mddev_set_bitmap_ops(mddev, ID_BITMAP);
+	if (!IS_ENABLED(CONFIG_MD_BITMAP)) {
+		mddev->bitmap_id = ID_BITMAP_NONE;
+	} else {
+		mddev->bitmap_id = ID_BITMAP;
+		if (!mddev_set_bitmap_ops(mddev))
+			return -EINVAL;
+	}
 
 	if (percpu_ref_init(&mddev->active_io, active_io_release,
 			    PERCPU_REF_ALLOW_REINIT, GFP_KERNEL)) {
diff --git a/drivers/md/md.h b/drivers/md/md.h
index 1b767b5320cf..4fa5a3e68a0c 100644
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


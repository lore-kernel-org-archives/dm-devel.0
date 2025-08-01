Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B461221D9E
	for <dm-devel@lists.linux.dev>; Fri,  1 Aug 2025 07:10:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754032261; cv=none; b=BBG9kZFZwY8kkgfCQ31iMtEDfoss7dCns7dQLsSMm1BXEofAWkkPxabNqrEnS5YdrpyAJwIwYpTZCqRkbpz4Srnjs2+S1j9yn0cO+HsHKgBhyuOT8IB5jeX6sC6FRftbUqr3wDFHwBPchmOEaFf7Tai/uJg8fTFK6tUPcqRquKY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754032261; c=relaxed/simple;
	bh=evEPTbSdNTK4vR/J8r6/Bxq9ypwizvvChPQGCQvyk7g=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=lVf3tHIrAd7zOEiQmPGYYl+J6mhlKSaw/S7mCBV6NHInPVRfc6Yn4iTWx2jEv1VyyGpEZ38i0TyD92roouklWsWqwNjXJ3pZCFnYqOFAMiE5Zcglw3xIQzYnllJkUMupH1l3iRVPBOIJJKDrJYZWGXYBkJxMqjoefQAdlwjzLV8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.93.142])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTPS id 4btcYR19hxzYQv9K
	for <dm-devel@lists.linux.dev>; Fri,  1 Aug 2025 15:10:51 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id CE5031A0EF9
	for <dm-devel@lists.linux.dev>; Fri,  1 Aug 2025 15:10:49 +0800 (CST)
Received: from huaweicloud.com (unknown [10.175.104.67])
	by APP4 (Coremail) with SMTP id gCh0CgDHjxByaIxoqAzACA--.18978S9;
	Fri, 01 Aug 2025 15:10:49 +0800 (CST)
From: Yu Kuai <yukuai1@huaweicloud.com>
To: hch@lst.de,
	corbet@lwn.net,
	song@kernel.org,
	yukuai3@huawei.com,
	agk@redhat.com,
	snitzer@kernel.org,
	mpatocka@redhat.com,
	linan122@huawei.com,
	xni@redhat.com,
	hare@suse.de
Cc: linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-raid@vger.kernel.org,
	dm-devel@lists.linux.dev,
	yukuai1@huaweicloud.com,
	yi.zhang@huawei.com,
	yangerkun@huawei.com,
	johnny.chenyi@huawei.com
Subject: [PATCH v5 05/11] md/md-bitmap: add a new sysfs api bitmap_type
Date: Fri,  1 Aug 2025 15:03:40 +0800
Message-Id: <20250801070346.4127558-6-yukuai1@huaweicloud.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20250801070346.4127558-1-yukuai1@huaweicloud.com>
References: <20250801070346.4127558-1-yukuai1@huaweicloud.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgDHjxByaIxoqAzACA--.18978S9
X-Coremail-Antispam: 1UD129KBjvJXoWxKryDWr1rJr1rAry8Gr1fXrb_yoW7ZFWkpF
	WxKryayrZ5ZrsrXr17J3WDuF1SqrWvy39xt3sa93sYkry5WrnIyFyfK3W5twnrCr95CFsr
	ZFs8JFWUWryjvF7anT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUmS14x267AKxVWrJVCq3wAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2048vs2IY020E87I2jVAFwI0_JF0E3s1l82xGYI
	kIc2x26xkF7I0E14v26ryj6s0DM28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48ve4kI8wA2
	z4x0Y4vE2Ix0cI8IcVAFwI0_tr0E3s1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI0_Gr1j6F
	4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x0267AKxVW0oVCq
	3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0I7
	IYx2IY67AKxVWUJVWUGwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFVCjc4AY6r1j6r4U
	M4x0Y48IcxkI7VAKI48JM4x0x7Aq67IIx4CEVc8vx2IErcIFxwACI402YVCY1x02628vn2
	kIc2xKxwCY1x0262kKe7AKxVW8ZVWrXwCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7xkE
	bVWUJVW8JwC20s026c02F40E14v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67
	AF67kF1VAFwI0_GFv_WrylIxkGc2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWUCVW8JwCI
	42IY6xIIjxv20xvEc7CjxVAFwI0_Gr1j6F4UJwCI42IY6xAIw20EY4v20xvaj40_Jr0_JF
	4lIxAIcVC2z280aVAFwI0_Jr0_Gr1lIxAIcVC2z280aVCY1x0267AKxVW8Jr0_Cr1UYxBI
	daVFxhVjvjDU0xZFpf9x0pRQJ5wUUUUU=
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/

From: Yu Kuai <yukuai3@huawei.com>

The api will be used by mdadm to set bitmap_type while creating new array
or assembling array, prepare to add a new bitmap.

Currently available options are:

cat /sys/block/md0/md/bitmap_type
none [bitmap]

Signed-off-by: Yu Kuai <yukuai3@huawei.com>
Reviewed-by: Hannes Reinecke <hare@suse.de>
Reviewed-by: Xiao Ni <xni@redhat.com>
Reviewed-by: Li Nan <linan122@huawei.com>
---
 Documentation/admin-guide/md.rst | 73 ++++++++++++++++------------
 drivers/md/md.c                  | 81 ++++++++++++++++++++++++++++++++
 2 files changed, 124 insertions(+), 30 deletions(-)

diff --git a/Documentation/admin-guide/md.rst b/Documentation/admin-guide/md.rst
index 4ff2cc291d18..356d2a344f08 100644
--- a/Documentation/admin-guide/md.rst
+++ b/Documentation/admin-guide/md.rst
@@ -347,6 +347,49 @@ All md devices contain:
      active-idle
          like active, but no writes have been seen for a while (safe_mode_delay).
 
+  consistency_policy
+     This indicates how the array maintains consistency in case of unexpected
+     shutdown. It can be:
+
+     none
+       Array has no redundancy information, e.g. raid0, linear.
+
+     resync
+       Full resync is performed and all redundancy is regenerated when the
+       array is started after unclean shutdown.
+
+     bitmap
+       Resync assisted by a write-intent bitmap.
+
+     journal
+       For raid4/5/6, journal device is used to log transactions and replay
+       after unclean shutdown.
+
+     ppl
+       For raid5 only, Partial Parity Log is used to close the write hole and
+       eliminate resync.
+
+     The accepted values when writing to this file are ``ppl`` and ``resync``,
+     used to enable and disable PPL.
+
+  uuid
+     This indicates the UUID of the array in the following format:
+     xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx
+
+  bitmap_type
+     [RW] When read, this file will display the current and available
+     bitmap for this array. The currently active bitmap will be enclosed
+     in [] brackets. Writing an bitmap name or ID to this file will switch
+     control of this array to that new bitmap. Note that writing a new
+     bitmap for created array is forbidden.
+
+     none
+         No bitmap
+     bitmap
+         The default internal bitmap
+
+If bitmap_type is bitmap, then the md device will also contain:
+
   bitmap/location
      This indicates where the write-intent bitmap for the array is
      stored.
@@ -401,36 +444,6 @@ All md devices contain:
      once the array becomes non-degraded, and this fact has been
      recorded in the metadata.
 
-  consistency_policy
-     This indicates how the array maintains consistency in case of unexpected
-     shutdown. It can be:
-
-     none
-       Array has no redundancy information, e.g. raid0, linear.
-
-     resync
-       Full resync is performed and all redundancy is regenerated when the
-       array is started after unclean shutdown.
-
-     bitmap
-       Resync assisted by a write-intent bitmap.
-
-     journal
-       For raid4/5/6, journal device is used to log transactions and replay
-       after unclean shutdown.
-
-     ppl
-       For raid5 only, Partial Parity Log is used to close the write hole and
-       eliminate resync.
-
-     The accepted values when writing to this file are ``ppl`` and ``resync``,
-     used to enable and disable PPL.
-
-  uuid
-     This indicates the UUID of the array in the following format:
-     xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx
-
-
 As component devices are added to an md array, they appear in the ``md``
 directory as new directories named::
 
diff --git a/drivers/md/md.c b/drivers/md/md.c
index 393e6547a086..54a7661bf35c 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -4203,6 +4203,86 @@ new_level_store(struct mddev *mddev, const char *buf, size_t len)
 static struct md_sysfs_entry md_new_level =
 __ATTR(new_level, 0664, new_level_show, new_level_store);
 
+static ssize_t
+bitmap_type_show(struct mddev *mddev, char *page)
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
+bitmap_type_store(struct mddev *mddev, const char *buf, size_t len)
+{
+	struct md_submodule_head *head;
+	enum md_submodule_id id;
+	unsigned long i;
+	int err = 0;
+
+	xa_lock(&md_submodule);
+
+	if (mddev->bitmap_ops) {
+		err = -EBUSY;
+		goto out;
+	}
+
+	if (cmd_match(buf, "none")) {
+		mddev->bitmap_id = ID_BITMAP_NONE;
+		goto out;
+	}
+
+	xa_for_each(&md_submodule, i, head) {
+		if (head->type == MD_BITMAP && cmd_match(buf, head->name)) {
+			mddev->bitmap_id = head->id;
+			goto out;
+		}
+	}
+
+	err = kstrtoint(buf, 10, &id);
+	if (err)
+		goto out;
+
+	if (id == ID_BITMAP_NONE) {
+		mddev->bitmap_id = id;
+		goto out;
+	}
+
+	head = xa_load(&md_submodule, id);
+	if (head && head->type == MD_BITMAP) {
+		mddev->bitmap_id = id;
+		goto out;
+	}
+
+	err = -ENOENT;
+
+out:
+	xa_unlock(&md_submodule);
+	return err ? err : len;
+}
+
+static struct md_sysfs_entry md_bitmap_type =
+__ATTR(bitmap_type, 0664, bitmap_type_show, bitmap_type_store);
+
 static ssize_t
 layout_show(struct mddev *mddev, char *page)
 {
@@ -5767,6 +5847,7 @@ __ATTR(serialize_policy, S_IRUGO | S_IWUSR, serialize_policy_show,
 static struct attribute *md_default_attrs[] = {
 	&md_level.attr,
 	&md_new_level.attr,
+	&md_bitmap_type.attr,
 	&md_layout.attr,
 	&md_raid_disks.attr,
 	&md_uuid.attr,
-- 
2.39.2


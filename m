Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05443214202
	for <dm-devel@lists.linux.dev>; Fri, 28 Mar 2025 06:14:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743142499; cv=none; b=PNNVeHRFa7tg+S0axAB/k2NyX+ZhesIwhXPBVQqGb7bbLuLWHwUSm4pm4kGNCTFaa9J3AFjW0gVBOH6UCHrog6vCSGleQFEGTom63I2gOYGTjpgOiU9rpnRIyFkKhb1cljZzc8ciAellmrILHwvX7d9f2y1JfGxFWMIZ9UGBXBI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743142499; c=relaxed/simple;
	bh=a+73OZyLJCX3+M6xeNO3/44KpdbNxQIuMOOypAwAtF0=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=tIVYOijX/+LZVwb5Sc7P88GKF+yJlHvQGtfvDsaKLLH+qouALQvaeIuTsi2opi9KkiFqzA2zULgVhS2id9iZ60NiHmNYDV3Tlhgho0TSeeJ0/D5ttXDllxkfNXyGPlsCpIgoSm2/RMfXhbBIKuVPYdT5edORBGjcmxONlvYFEM0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.93.142])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTP id 4ZP9Gb1jP1z4f3jY1
	for <dm-devel@lists.linux.dev>; Fri, 28 Mar 2025 14:14:31 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 3C2731A0DDA
	for <dm-devel@lists.linux.dev>; Fri, 28 Mar 2025 14:14:54 +0800 (CST)
Received: from huaweicloud.com (unknown [10.175.104.67])
	by APP4 (Coremail) with SMTP id gCh0CgDHK2BSPuZnfAUtHw--.25875S17;
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
Subject: [PATCH RFC v2 13/14] md/md-llbitmap: implement sysfs APIs
Date: Fri, 28 Mar 2025 14:08:52 +0800
Message-Id: <20250328060853.4124527-14-yukuai1@huaweicloud.com>
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
X-CM-TRANSID:gCh0CgDHK2BSPuZnfAUtHw--.25875S17
X-Coremail-Antispam: 1UD129KBjvJXoWxWF1DWryUCw18JFy3JFW8JFb_yoWrGr4kpa
	yxW345WFW5Jr1xWr13JrZrZFWrWws7Wr9Fqr97Ca4rCF17ArsIgrW8GFyUtw1kWryfCF1D
	Jan0grZ8WF4UXFUanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
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

There are 3 APIs for now:
 - bits: readonly, show status of bitmap bits, the number of each value;
 - metadata: readonly show bitmap metadata, include chunksize, chunkshift,
 chunks, offset and daemon_sleep;
 - daemon_sleep: read-write, default value is 30;

Signed-off-by: Yu Kuai <yukuai3@huawei.com>
---
 drivers/md/md-llbitmap.c | 106 +++++++++++++++++++++++++++++++++++++++
 1 file changed, 106 insertions(+)

diff --git a/drivers/md/md-llbitmap.c b/drivers/md/md-llbitmap.c
index a16bc84d9fa2..88ba29111e13 100644
--- a/drivers/md/md-llbitmap.c
+++ b/drivers/md/md-llbitmap.c
@@ -1234,6 +1234,110 @@ static void llbitmap_free(void *data)
 {
 }
 
+static ssize_t bits_show(struct mddev *mddev, char *page)
+{
+	struct llbitmap *llbitmap;
+	int bits[nr_llbitmap_state] = {0};
+	loff_t start = 0;
+
+	mutex_lock(&mddev->bitmap_info.mutex);
+	llbitmap = mddev->bitmap;
+	if (!llbitmap) {
+		mutex_unlock(&mddev->bitmap_info.mutex);
+		return sprintf(page, "no bitmap\n");
+	}
+
+	if (test_bit(BITMAP_WRITE_ERROR, &llbitmap->flags)) {
+		mutex_unlock(&mddev->bitmap_info.mutex);
+		return sprintf(page, "bitmap io error\n");
+	}
+
+	while (start < llbitmap->chunks) {
+		ssize_t ret;
+		enum llbitmap_state c;
+
+		ret = llbitmap_read(llbitmap, &c, start);
+		if (ret < 0) {
+			set_bit(BITMAP_WRITE_ERROR, &llbitmap->flags);
+			mutex_unlock(&mddev->bitmap_info.mutex);
+			return sprintf(page, "bitmap io error\n");
+		}
+
+		if (c < 0 || c >= nr_llbitmap_state)
+			pr_err("%s: invalid bit %llu state %d\n",
+			       __func__, start, c);
+		else
+			bits[c]++;
+		start++;
+	}
+
+	mutex_unlock(&mddev->bitmap_info.mutex);
+	return sprintf(page, "unwritten %d\nclean %d\ndirty %d\nneed sync %d\nsyncing %d\n",
+		       bits[BitUnwritten], bits[BitClean], bits[BitDirty],
+		       bits[BitNeedSync], bits[BitSyncing]);
+}
+
+static struct md_sysfs_entry llbitmap_bits =
+__ATTR_RO(bits);
+
+static ssize_t metadata_show(struct mddev *mddev, char *page)
+{
+	struct llbitmap *llbitmap;
+	ssize_t ret;
+
+	mutex_lock(&mddev->bitmap_info.mutex);
+	llbitmap = mddev->bitmap;
+	if (!llbitmap) {
+		mutex_unlock(&mddev->bitmap_info.mutex);
+		return sprintf(page, "no bitmap\n");
+	}
+
+	ret =  sprintf(page, "chunksize %lu\nchunkshift %lu\nchunks %lu\noffset %llu\ndaemon_sleep %lu\n",
+		       llbitmap->chunksize, llbitmap->chunkshift,
+		       llbitmap->chunks, mddev->bitmap_info.offset,
+		       llbitmap->mddev->bitmap_info.daemon_sleep);
+	mutex_unlock(&mddev->bitmap_info.mutex);
+
+	return ret;
+}
+
+static struct md_sysfs_entry llbitmap_metadata =
+__ATTR_RO(metadata);
+
+static ssize_t
+daemon_sleep_show(struct mddev *mddev, char *page)
+{
+	return sprintf(page, "%lu\n", mddev->bitmap_info.daemon_sleep);
+}
+
+static ssize_t
+daemon_sleep_store(struct mddev *mddev, const char *buf, size_t len)
+{
+	unsigned long timeout;
+	int rv = kstrtoul(buf, 10, &timeout);
+
+	if (rv)
+		return rv;
+
+	mddev->bitmap_info.daemon_sleep = timeout;
+	return len;
+}
+
+static struct md_sysfs_entry llbitmap_daemon_sleep =
+__ATTR_RW(daemon_sleep);
+
+static struct attribute *md_llbitmap_attrs[] = {
+	&llbitmap_bits.attr,
+	&llbitmap_metadata.attr,
+	&llbitmap_daemon_sleep.attr,
+	NULL
+};
+
+static struct attribute_group md_llbitmap_group = {
+	.name = "llbitmap",
+	.attrs = md_llbitmap_attrs,
+};
+
 static struct bitmap_operations llbitmap_ops = {
 	.head = {
 		.type	= MD_BITMAP,
@@ -1274,4 +1378,6 @@ static struct bitmap_operations llbitmap_ops = {
 	.copy_from_slot		= llbitmap_copy_from_slot,
 	.set_pages		= llbitmap_set_pages,
 	.free			= llbitmap_free,
+
+	.group			= &md_llbitmap_group,
 };
-- 
2.39.2


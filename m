Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66784211A20
	for <dm-devel@lists.linux.dev>; Fri, 28 Mar 2025 06:14:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743142498; cv=none; b=KFFWeC5ePU0OpVKrHDLW/c8ySgSPGIFbiESccvUjfBOxk3hM6hHveKoZAYRvPCzocF4vt+oUYYkyJmuhxhgjWGf9XZ3ed+VL8+1U7VZfByjQvAID1MahJ3syIifoLzzoqW2CPLHuMgaK/GIXWTtjAUCbW2wvLXK3Cmj/T68Q5aE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743142498; c=relaxed/simple;
	bh=sYrS4FD2pFx+ibrE9Zqg5iz6cAK2aw7Rvoh4UyaSB84=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Wy0FG0ki0msz2sXbTXmOp8tLvLpDGSaQlGs/0qD3IwHq+HDGbeTXWuFg4gMCYWNYPTafjV4GBhkXEzDTs35eQ8ifQ4TO0oP33yed63JRb2tiHskHh0Rmq/deFBlBbxn7pOs6wKfBmqYLcfzJluZzieYLI+re6d3D+LBFlZkHXXo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.235])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTP id 4ZP9GY0pmcz4f3m7J
	for <dm-devel@lists.linux.dev>; Fri, 28 Mar 2025 14:14:29 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 986121A0B98
	for <dm-devel@lists.linux.dev>; Fri, 28 Mar 2025 14:14:53 +0800 (CST)
Received: from huaweicloud.com (unknown [10.175.104.67])
	by APP4 (Coremail) with SMTP id gCh0CgDHK2BSPuZnfAUtHw--.25875S16;
	Fri, 28 Mar 2025 14:14:53 +0800 (CST)
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
Subject: [PATCH RFC v2 12/14] md/md-llbitmap: implement all bitmap operations
Date: Fri, 28 Mar 2025 14:08:51 +0800
Message-Id: <20250328060853.4124527-13-yukuai1@huaweicloud.com>
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
X-CM-TRANSID:gCh0CgDHK2BSPuZnfAUtHw--.25875S16
X-Coremail-Antispam: 1UD129KBjvJXoW3Gry5ArWDXr13Cw4xJr4DXFb_yoW7Aw4kpF
	W3XFy5Gr45JFyIgw13Jr9rZF1Syrs7tr9FqrZ7C34rWF15CrZxKF48GFyUJw1DXryfJFn8
	Aw45GF4rC3yrXF7anT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
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

Include following left APIs
 - llbitmap_enabled
 - llbitmap_dirty_bits
 - llbitmap_update_sb

And following APIs that are not needed:
 - llbitmap_write_all, used in old bitmap to mark all pages need
 writeback;
 - llbitmap_daemon_work, used in old bitmap, llbitmap use timer to
   trigger daemon;
 - llbitmap_cond_end_sync, use to end sync for completed sectors(TODO,
   don't affect functionality)

And following APIs that are not supported:
 - llbitmap_start_behind_write
 - llbitmap_end_behind_write
 - llbitmap_wait_behind_writes
 - llbitmap_sync_with_cluster
 - llbitmap_get_from_slot
 - llbitmap_copy_from_slot
 - llbitmap_set_pages
 - llbitmap_free

Signed-off-by: Yu Kuai <yukuai3@huawei.com>
---
 drivers/md/md-llbitmap.c | 144 +++++++++++++++++++++++++++++++++++++++
 1 file changed, 144 insertions(+)

diff --git a/drivers/md/md-llbitmap.c b/drivers/md/md-llbitmap.c
index 1692942942ff..a16bc84d9fa2 100644
--- a/drivers/md/md-llbitmap.c
+++ b/drivers/md/md-llbitmap.c
@@ -1110,6 +1110,130 @@ static void llbitmap_close_sync(struct mddev *mddev)
 	llbitmap_state_machine(llbitmap, 0, llbitmap->chunks - 1, BitmapActionEndsync);
 }
 
+static bool llbitmap_enabled(void *data)
+{
+	struct llbitmap *llbitmap = data;
+
+	return llbitmap && !test_bit(BITMAP_WRITE_ERROR, &llbitmap->flags);
+}
+
+static void llbitmap_dirty_bits(struct mddev *mddev, unsigned long s,
+				unsigned long e)
+{
+	llbitmap_state_machine(mddev->bitmap, s, e, BitmapActionStartwrite);
+}
+
+static void llbitmap_update_sb(void *data)
+{
+	struct llbitmap *llbitmap = data;
+	struct mddev *mddev = llbitmap->mddev;
+	struct page *sb_page;
+	bitmap_super_t *sb;
+
+	if (test_bit(BITMAP_WRITE_ERROR, &llbitmap->flags))
+		return;
+
+	sb_page = read_mapping_page(llbitmap->bitmap_file->f_mapping, 0, NULL);
+	if (IS_ERR(sb_page)) {
+		pr_err("%s: %s: read super block failed", __func__,
+		       mdname(mddev));
+		set_bit(BITMAP_WRITE_ERROR, &llbitmap->flags);
+		return;
+	}
+
+	if (mddev->events < llbitmap->events_cleared)
+		llbitmap->events_cleared = mddev->events;
+
+	sb = kmap_local_page(sb_page);
+	sb->events = cpu_to_le64(mddev->events);
+	sb->state = cpu_to_le32(llbitmap->flags);
+	sb->chunksize = cpu_to_le32(llbitmap->chunksize);
+	sb->sync_size = cpu_to_le64(mddev->resync_max_sectors);
+	sb->events_cleared = cpu_to_le64(llbitmap->events_cleared);
+	sb->sectors_reserved = cpu_to_le32(mddev->bitmap_info.space);
+	sb->daemon_sleep = cpu_to_le32(mddev->bitmap_info.daemon_sleep);
+
+	kunmap_local(sb);
+	set_page_dirty(sb_page);
+	put_page(sb_page);
+
+	if (filemap_write_and_wait_range(llbitmap->bitmap_file->f_mapping, 0,
+					 BITMAP_SB_SIZE) != 0) {
+		pr_err("%s: %s: write super block failed", __func__,
+		       mdname(mddev));
+		set_bit(BITMAP_WRITE_ERROR, &llbitmap->flags);
+	}
+}
+
+static int llbitmap_get_stats(void *data, struct md_bitmap_stats *stats)
+{
+	struct llbitmap *llbitmap = data;
+
+	memset(stats, 0, sizeof(*stats));
+
+	stats->missing_pages = 0;
+	stats->pages = llbitmap->nr_pages;
+	stats->file_pages = llbitmap->nr_pages;
+
+	return 0;
+}
+
+static void llbitmap_write_all(struct mddev *mddev)
+{
+
+}
+
+static void llbitmap_daemon_work(struct mddev *mddev)
+{
+
+}
+
+static void llbitmap_start_behind_write(struct mddev *mddev)
+{
+
+}
+
+static void llbitmap_end_behind_write(struct mddev *mddev)
+{
+
+}
+
+static void llbitmap_wait_behind_writes(struct mddev *mddev)
+{
+
+}
+
+static void llbitmap_cond_end_sync(struct mddev *mddev, sector_t sector,
+				   bool force)
+{
+}
+
+static void llbitmap_sync_with_cluster(struct mddev *mddev,
+				       sector_t old_lo, sector_t old_hi,
+				       sector_t new_lo, sector_t new_hi)
+{
+
+}
+
+static void *llbitmap_get_from_slot(struct mddev *mddev, int slot)
+{
+	return ERR_PTR(-EOPNOTSUPP);
+}
+
+static int llbitmap_copy_from_slot(struct mddev *mddev, int slot, sector_t *low,
+				   sector_t *high, bool clear_bits)
+{
+	return -EOPNOTSUPP;
+}
+
+static void llbitmap_set_pages(void *data, unsigned long pages)
+{
+}
+
+static void llbitmap_free(void *data)
+{
+}
+
 static struct bitmap_operations llbitmap_ops = {
 	.head = {
 		.type	= MD_BITMAP,
@@ -1117,6 +1241,7 @@ static struct bitmap_operations llbitmap_ops = {
 		.name	= "llbitmap",
 	},
 
+	.enabled		= llbitmap_enabled,
 	.create			= llbitmap_create,
 	.resize			= llbitmap_resize,
 	.load			= llbitmap_load,
@@ -1130,4 +1255,23 @@ static struct bitmap_operations llbitmap_ops = {
 	.start_sync		= llbitmap_start_sync,
 	.end_sync		= llbitmap_end_sync,
 	.close_sync		= llbitmap_close_sync,
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
 };
-- 
2.39.2


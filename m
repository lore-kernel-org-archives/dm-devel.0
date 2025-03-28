Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1DEF8212FB4
	for <dm-devel@lists.linux.dev>; Fri, 28 Mar 2025 06:14:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743142497; cv=none; b=TzHaT6xtQhTVzKnGrEZnkVxYGZu8AJ9tl9hYyqFUGN86TA/+/XlRFbFghNnT5IoorgCzsOHwcnjlohh+zsfa80Rx7hI+u0JSlwuKLe74FDyeQR/JKu7VXFoy2mQ33U4pofEncrAT1apH9OyTJL3pLTiVQX3P1mHP3X72djHs2vg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743142497; c=relaxed/simple;
	bh=YsTUHibJzB0YAPhLPMm/21lUnHVQrv3NyQyhKOZA7nQ=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=WjgHtGcDRcHIcwMP13DXSGZWhTmiAQljmWFL9YKMDWAxk4EN09DJRWZ8Sl44lkNMX6U1QsqRhAg0w81OOE08dFm4R1u8d3aZowPrTBT27HIt6L5i0YePBwNUnG6BES6qgv6lhSDGO9ItmBErmOXHu5kkhyAsBxzYjrbdgYTRxaU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.93.142])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTP id 4ZP9GW6CQYz4f3m7L
	for <dm-devel@lists.linux.dev>; Fri, 28 Mar 2025 14:14:27 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 5EB421A0DD6
	for <dm-devel@lists.linux.dev>; Fri, 28 Mar 2025 14:14:52 +0800 (CST)
Received: from huaweicloud.com (unknown [10.175.104.67])
	by APP4 (Coremail) with SMTP id gCh0CgDHK2BSPuZnfAUtHw--.25875S14;
	Fri, 28 Mar 2025 14:14:52 +0800 (CST)
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
Subject: [PATCH RFC v2 10/14] md/md-llbitmap: implement APIs to dirty bits and clear bits
Date: Fri, 28 Mar 2025 14:08:49 +0800
Message-Id: <20250328060853.4124527-11-yukuai1@huaweicloud.com>
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
X-CM-TRANSID:gCh0CgDHK2BSPuZnfAUtHw--.25875S14
X-Coremail-Antispam: 1UD129KBjvJXoW3XrWkCF43XFW3Wr13KF4kWFg_yoWxZFy8pF
	43Xw15Gr45J3yFgryUJr9rAF15tr4ktr9IqF97A34rWw1jyrsIqFW8GFyUAws5Wrn3GFnr
	Aw45Kr95Cw4fZFDanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
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

Include following APIs:
 - llbitmap_startwrite
 - llbitmap_endwrite
 - llbitmap_unplug
 - llbitmap_flush

Signed-off-by: Yu Kuai <yukuai3@huawei.com>
---
 drivers/md/md-bitmap.h   |   1 +
 drivers/md/md-llbitmap.c | 171 +++++++++++++++++++++++++++++++++++++++
 2 files changed, 172 insertions(+)

diff --git a/drivers/md/md-bitmap.h b/drivers/md/md-bitmap.h
index 9e8bc7895751..7a3cd2f70772 100644
--- a/drivers/md/md-bitmap.h
+++ b/drivers/md/md-bitmap.h
@@ -23,6 +23,7 @@ enum bitmap_state {
 	BITMAP_STALE	   = 1,  /* the bitmap file is out of date or had -EIO */
 	BITMAP_WRITE_ERROR = 2, /* A write error has occurred */
 	BITMAP_FIRST_USE   = 3, /* llbtimap is just created */
+	BITMAP_DAEMON_BUSY = 4, /* llbitmap daemon is still not done after daemon_sleep */
 	BITMAP_HOSTENDIAN  =15,
 };
 
diff --git a/drivers/md/md-llbitmap.c b/drivers/md/md-llbitmap.c
index 1452887ffc5d..982ec868ce22 100644
--- a/drivers/md/md-llbitmap.c
+++ b/drivers/md/md-llbitmap.c
@@ -145,6 +145,7 @@ enum llbitmap_action {
 struct llbitmap_barrier {
 	struct percpu_ref active;
 	unsigned long expire;
+	bool flush;
 	wait_queue_head_t wait;
 } ____cacheline_aligned_in_smp;
 
@@ -182,6 +183,12 @@ struct llbitmap_bio {
 	struct bio bio;
 };
 
+struct llbitmap_unplug_work {
+	struct work_struct work;
+	struct llbitmap *llbitmap;
+	struct completion *done;
+};
+
 static struct workqueue_struct *md_llbitmap_io_wq;
 static struct workqueue_struct *md_llbitmap_unplug_wq;
 
@@ -793,6 +800,54 @@ static int llbitmap_read_sb(struct llbitmap *llbitmap)
 	return ret;
 }
 
+static void llbitmap_pending_timer_fn(struct timer_list *t)
+{
+	struct llbitmap *llbitmap = from_timer(llbitmap, t, pending_timer);
+
+	if (work_busy(&llbitmap->daemon_work)) {
+		pr_warn("daemon_work not finished\n");
+		set_bit(BITMAP_DAEMON_BUSY, &llbitmap->flags);
+		return;
+	}
+
+	queue_work(md_llbitmap_io_wq, &llbitmap->daemon_work);
+}
+
+static void md_llbitmap_daemon_fn(struct work_struct *work)
+{
+	struct llbitmap *llbitmap =
+		container_of(work, struct llbitmap, daemon_work);
+	unsigned long start = 0;
+	unsigned long end = min(llbitmap->chunks, PAGE_SIZE - BITMAP_SB_SIZE) - 1;
+	bool restart = false;
+	int page_idx = 0;
+
+	while (page_idx < llbitmap->nr_pages) {
+		struct llbitmap_barrier *barrier = &llbitmap->barrier[page_idx];
+
+		if (page_idx > 0) {
+			start = end + 1;
+			end = min(end + PAGE_SIZE, llbitmap->chunks - 1);
+		}
+
+		if (!barrier->flush && time_before(jiffies, barrier->expire)) {
+			restart = true;
+			page_idx++;
+			continue;
+		}
+
+		llbitmap_suspend(llbitmap, page_idx);
+		llbitmap_state_machine(llbitmap, start, end, BitmapActionDaemon);
+		llbitmap_resume(llbitmap, page_idx);
+
+		page_idx++;
+	}
+
+	if (test_and_clear_bit(BITMAP_DAEMON_BUSY, &llbitmap->flags) || restart)
+		mod_timer(&llbitmap->pending_timer,
+			  jiffies + llbitmap->mddev->bitmap_info.daemon_sleep * HZ);
+}
+
 static int llbitmap_create(struct mddev *mddev)
 {
 	struct llbitmap *llbitmap;
@@ -905,6 +960,117 @@ static void llbitmap_destroy(struct mddev *mddev)
 	mutex_unlock(&mddev->bitmap_info.mutex);
 }
 
+static int llbitmap_startwrite(struct mddev *mddev, sector_t offset,
+			       unsigned long sectors, bool is_discard)
+{
+	struct llbitmap *llbitmap = mddev->bitmap;
+	enum llbitmap_action action;
+	unsigned long start;
+	unsigned long end;
+	int page_start;
+	int page_end;
+
+	if (likely(!is_discard)) {
+		start = offset >> llbitmap->chunkshift;
+		end = (offset + sectors - 1) >> llbitmap->chunkshift;
+		action = BitmapActionStartwrite;
+	} else {
+		/*
+		 * For discard, the bit can be handled only if the discard range
+		 * cover the whole bit, hence round start up, and end down.
+		 */
+		start = DIV_ROUND_UP(offset, llbitmap->chunksize);
+		end = (offset + sectors - 1) >> llbitmap->chunkshift;
+		action = BitmapActionDiscard;
+	}
+
+	llbitmap_state_machine(llbitmap, start, end, action);
+
+	page_start = (start + BITMAP_SB_SIZE) >> PAGE_SHIFT;
+	page_end = (end + BITMAP_SB_SIZE) >> PAGE_SHIFT;
+
+	while (page_start <= page_end) {
+		llbitmap_raise_barrier(llbitmap, page_start);
+		page_start++;
+	}
+
+	return 0;
+}
+
+static void llbitmap_endwrite(struct mddev *mddev, sector_t offset,
+			      unsigned long sectors, bool is_discard)
+{
+	struct llbitmap *llbitmap = mddev->bitmap;
+	unsigned long start;
+	unsigned long end;
+	int page_start;
+	int page_end;
+
+	if (likely(!is_discard)) {
+		start = offset >> llbitmap->chunkshift;
+		end = (offset + sectors - 1) >> llbitmap->chunkshift;
+	} else {
+		/*
+		 * For discard, the bit can be handled only if the discard range
+		 * cover the whole bit, hence round start up, and end down.
+		 */
+		start = DIV_ROUND_UP(offset, llbitmap->chunksize);
+		end = (offset + sectors - 1) >> llbitmap->chunkshift;
+	}
+
+	page_start = (start + BITMAP_SB_SIZE) >> PAGE_SHIFT;
+	page_end = (end + BITMAP_SB_SIZE) >> PAGE_SHIFT;
+
+	while (page_start <= page_end) {
+		llbitmap_release_barrier(llbitmap, page_start);
+		page_start++;
+	}
+}
+
+static void llbitmap_unplug_fn(struct work_struct *work)
+{
+	struct llbitmap_unplug_work *unplug_work =
+		container_of(work, struct llbitmap_unplug_work, work);
+	struct llbitmap *llbitmap = unplug_work->llbitmap;
+
+	filemap_write_and_wait_range(llbitmap->bitmap_file->f_mapping,
+				     BITMAP_SB_SIZE,
+				     BITMAP_SB_SIZE + llbitmap->chunks - 1);
+	complete(unplug_work->done);
+}
+
+static void llbitmap_unplug(struct mddev *mddev, bool sync)
+{
+	DECLARE_COMPLETION_ONSTACK(done);
+	struct llbitmap *llbitmap = mddev->bitmap;
+	struct llbitmap_unplug_work unplug_work = {
+		.llbitmap = llbitmap,
+		.done = &done,
+	};
+
+	if (!mapping_tagged(llbitmap->bitmap_file->f_mapping,
+			    PAGECACHE_TAG_DIRTY))
+		return;
+
+	INIT_WORK_ONSTACK(&unplug_work.work, llbitmap_unplug_fn);
+	queue_work(md_llbitmap_unplug_wq, &unplug_work.work);
+	wait_for_completion(&done);
+	destroy_work_on_stack(&unplug_work.work);
+}
+
+static void llbitmap_flush(struct mddev *mddev)
+{
+	struct llbitmap *llbitmap = mddev->bitmap;
+	int i;
+
+	for (i = 0; i < llbitmap->nr_pages; i++)
+		llbitmap->barrier[i].flush = true;
+
+	del_timer_sync(&llbitmap->pending_timer);
+	queue_work(md_llbitmap_io_wq, &llbitmap->daemon_work);
+	flush_work(&llbitmap->daemon_work);
+}
+
 static struct bitmap_operations llbitmap_ops = {
 	.head = {
 		.type	= MD_BITMAP,
@@ -916,4 +1082,9 @@ static struct bitmap_operations llbitmap_ops = {
 	.resize			= llbitmap_resize,
 	.load			= llbitmap_load,
 	.destroy		= llbitmap_destroy,
+
+	.startwrite		= llbitmap_startwrite,
+	.endwrite		= llbitmap_endwrite,
+	.unplug			= llbitmap_unplug,
+	.flush			= llbitmap_flush,
 };
-- 
2.39.2


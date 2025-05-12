Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B8831E520F
	for <dm-devel@lists.linux.dev>; Mon, 12 May 2025 01:28:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747013296; cv=none; b=KN94ByOdtDmUrOFgstHLgyM3r1DnXh7zQIcvmbpv7+DY6vaqiAqZ8RUPu8gurtJ0lQj9fO7HKNeBAE7JBl60EuHxYjhtRvZiwF6Wh2z5E1/zXQ/hwGl9oJ1yFgYtjPPDV99/WQL1Xxyfa6nJEpS5Evcx81GFNVXIj9RyGYznUHs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747013296; c=relaxed/simple;
	bh=6lQLbigT0kljTaoLCqvvkTdaRkHHixs/2bFGqCRhK40=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=LRHYZ7BVQf8/Vox3F8YR+WcOZF8gXo2FCbVZTdXx1WCpC11QwYkuo9r3mXgYvm8pMOOITmyhNtPrjTtimjdBn+hYGzXYA3Dhhrhz4ZhlDIrxLbwhPYdS8+9ApildVz6j6s3Z0HOOl/Yp9fqgj6n8xecLBOarSucMPVk+8rWcagE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.235])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTP id 4Zwhmw46K8z4f3lV7
	for <dm-devel@lists.linux.dev>; Mon, 12 May 2025 09:27:44 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id B89531A1079
	for <dm-devel@lists.linux.dev>; Mon, 12 May 2025 09:28:10 +0800 (CST)
Received: from huaweicloud.com (unknown [10.175.104.67])
	by APP4 (Coremail) with SMTP id gCh0CgCnC2CdTiFoNFCWMA--.55093S19;
	Mon, 12 May 2025 09:28:10 +0800 (CST)
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
Subject: [PATCH RFC md-6.16 v3 15/19] md/md-llbitmap: implement APIs to dirty bits and clear bits
Date: Mon, 12 May 2025 09:19:23 +0800
Message-Id: <20250512011927.2809400-16-yukuai1@huaweicloud.com>
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
X-CM-TRANSID:gCh0CgCnC2CdTiFoNFCWMA--.55093S19
X-Coremail-Antispam: 1UD129KBjvJXoWxtw1kKw1DCry8Jr45WFW5Awb_yoWxZF43pF
	43Xw15Kr45J34Fq3y7Jr97ZF15tr4kJwnFqF93A34rGr1UArZ8KF48GFy0yw18ur93WFn8
	Aw4Ykry5Cw4fWrDanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
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

Include following APIs:
 - llbitmap_startwrite
 - llbitmap_endwrite
 - llbitmap_start_discard
 - llbitmap_end_discard
 - llbitmap_unplug
 - llbitmap_flush

Signed-off-by: Yu Kuai <yukuai3@huawei.com>
---
 drivers/md/md-llbitmap.c | 206 +++++++++++++++++++++++++++++++++++++++
 1 file changed, 206 insertions(+)

diff --git a/drivers/md/md-llbitmap.c b/drivers/md/md-llbitmap.c
index 4b54aa6fbe40..71234c0ae160 100644
--- a/drivers/md/md-llbitmap.c
+++ b/drivers/md/md-llbitmap.c
@@ -784,6 +784,68 @@ static int llbitmap_read_sb(struct llbitmap *llbitmap)
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
+	unsigned long start;
+	unsigned long end;
+	bool restart;
+	int idx;
+
+	if (llbitmap->mddev->degraded)
+		return;
+
+retry:
+	start = 0;
+	end = min(llbitmap->chunks, PAGE_SIZE - BITMAP_SB_SIZE) - 1;
+	restart = false;
+
+	for (idx = 0; idx < llbitmap->nr_pages; idx++) {
+		struct llbitmap_barrier *barrier = &llbitmap->barrier[idx];
+
+		if (idx > 0) {
+			start = end + 1;
+			end = min(end + PAGE_SIZE, llbitmap->chunks - 1);
+		}
+
+		if (!test_bit(LLPageFlush, &barrier->flags) &&
+		    time_before(jiffies, barrier->expire)) {
+			restart = true;
+			continue;
+		}
+
+		llbitmap_suspend(llbitmap, idx);
+		llbitmap_state_machine(llbitmap, start, end, BitmapActionDaemon);
+		llbitmap_resume(llbitmap, idx);
+	}
+
+	/*
+	 * If the daemon took a long time to finish, retry to prevent missing
+	 * clearing dirty bits.
+	 */
+	if (test_and_clear_bit(BITMAP_DAEMON_BUSY, &llbitmap->flags))
+		goto retry;
+
+	/* If some page is dirty but not expired, setup timer again */
+	if (restart)
+		mod_timer(&llbitmap->pending_timer,
+			  jiffies + llbitmap->mddev->bitmap_info.daemon_sleep * HZ);
+}
+
 static int llbitmap_create(struct mddev *mddev)
 {
 	struct llbitmap *llbitmap;
@@ -870,3 +932,147 @@ static void llbitmap_destroy(struct mddev *mddev)
 	kfree(llbitmap);
 	mutex_unlock(&mddev->bitmap_info.mutex);
 }
+
+static int llbitmap_startwrite(struct mddev *mddev, sector_t offset,
+			       unsigned long sectors)
+{
+	struct llbitmap *llbitmap = mddev->bitmap;
+	unsigned long start = offset >> llbitmap->chunkshift;
+	unsigned long end = (offset + sectors - 1) >> llbitmap->chunkshift;
+	int page_start = (start + BITMAP_SB_SIZE) >> PAGE_SHIFT;
+	int page_end = (end + BITMAP_SB_SIZE) >> PAGE_SHIFT;
+
+	llbitmap_state_machine(llbitmap, start, end, BitmapActionStartwrite);
+
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
+			      unsigned long sectors)
+{
+	struct llbitmap *llbitmap = mddev->bitmap;
+	unsigned long start = offset >> llbitmap->chunkshift;
+	unsigned long end = (offset + sectors - 1) >> llbitmap->chunkshift;
+	int page_start = (start + BITMAP_SB_SIZE) >> PAGE_SHIFT;
+	int page_end = (end + BITMAP_SB_SIZE) >> PAGE_SHIFT;
+
+	while (page_start <= page_end) {
+		llbitmap_release_barrier(llbitmap, page_start);
+		page_start++;
+	}
+}
+
+static int llbitmap_start_discard(struct mddev *mddev, sector_t offset,
+				  unsigned long sectors)
+{
+	struct llbitmap *llbitmap = mddev->bitmap;
+	unsigned long start = DIV_ROUND_UP(offset, llbitmap->chunksize);
+	unsigned long end = (offset + sectors - 1) >> llbitmap->chunkshift;
+	int page_start = (start + BITMAP_SB_SIZE) >> PAGE_SHIFT;
+	int page_end = (end + BITMAP_SB_SIZE) >> PAGE_SHIFT;
+
+	llbitmap_state_machine(llbitmap, start, end, BitmapActionDiscard);
+
+	while (page_start <= page_end) {
+		llbitmap_raise_barrier(llbitmap, page_start);
+		page_start++;
+	}
+
+	return 0;
+}
+
+static void llbitmap_end_discard(struct mddev *mddev, sector_t offset,
+				 unsigned long sectors)
+{
+	struct llbitmap *llbitmap = mddev->bitmap;
+	unsigned long start = DIV_ROUND_UP(offset, llbitmap->chunksize);
+	unsigned long end = (offset + sectors - 1) >> llbitmap->chunkshift;
+	int page_start = (start + BITMAP_SB_SIZE) >> PAGE_SHIFT;
+	int page_end = (end + BITMAP_SB_SIZE) >> PAGE_SHIFT;
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
+	struct blk_plug plug;
+	int i;
+
+	blk_start_plug(&plug);
+
+	for (i = 0; i < llbitmap->nr_pages; i++) {
+		if (!test_bit(LLPageDirty, &llbitmap->barrier[i].flags) ||
+		    !test_and_clear_bit(LLPageDirty, &llbitmap->barrier[i].flags))
+			continue;
+
+		llbitmap_write_page(llbitmap, i);
+	}
+
+	blk_finish_plug(&plug);
+	md_super_wait(llbitmap->mddev);
+	complete(unplug_work->done);
+}
+
+static bool llbitmap_dirty(struct llbitmap *llbitmap)
+{
+	int i;
+
+	for (i = 0; i < llbitmap->nr_pages; i++)
+		if (test_bit(LLPageDirty, &llbitmap->barrier[i].flags))
+			return true;
+
+	return false;
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
+	if (!llbitmap_dirty(llbitmap))
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
+	struct blk_plug plug;
+	int i;
+
+	for (i = 0; i < llbitmap->nr_pages; i++)
+		set_bit(LLPageFlush, &llbitmap->barrier[i].flags);
+
+	timer_delete_sync(&llbitmap->pending_timer);
+	queue_work(md_llbitmap_io_wq, &llbitmap->daemon_work);
+	flush_work(&llbitmap->daemon_work);
+
+	blk_start_plug(&plug);
+	for (i = 0; i < llbitmap->nr_pages; i++) {
+		/* mark all bits as dirty */
+		bitmap_fill(llbitmap->barrier[i].dirty, llbitmap->bits_per_page);
+		llbitmap_write_page(llbitmap, i);
+	}
+	blk_finish_plug(&plug);
+	md_super_wait(llbitmap->mddev);
+}
-- 
2.39.2


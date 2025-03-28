Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1CBC3212B0D
	for <dm-devel@lists.linux.dev>; Fri, 28 Mar 2025 06:14:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743142497; cv=none; b=QIacACaa7z4PikkizzzRHLZBnBcYF4LSWFr3I61y/wu4Nu4VJBy8hfIUjOLy/sq8Y17+8ohyQnu8hZdSBy7+vDAY9RuqmULrt3lX48ieOE4gQjSDB6mdtvTRXCQreKsqxpTvlbCt4eVZIejIQr/kNwb9hkVL8YqP94/+redUoCc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743142497; c=relaxed/simple;
	bh=fpMef2Wjto4vzE9UBqDAsFYzDduBP36pF2FndpsCTmk=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=lJPdGruWTcmU5LbebQi7HK0agYCPFIaHQBOkCBtl21auwdX9cP/9HWE31c/jt9xbpS3nprNrdXd300QTlFFTkmALjZQ0NS22p3Th1SeTkwCSDGse83DyKfPVaHr4TIOXuL4Zn88/Kvv/lmZZ81Cw/UfaYGlmThQxOoWxNT3QL40=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.93.142])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTP id 4ZP9Gd3jfKz4f3jkw
	for <dm-devel@lists.linux.dev>; Fri, 28 Mar 2025 14:14:33 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 241961A13D5
	for <dm-devel@lists.linux.dev>; Fri, 28 Mar 2025 14:14:51 +0800 (CST)
Received: from huaweicloud.com (unknown [10.175.104.67])
	by APP4 (Coremail) with SMTP id gCh0CgDHK2BSPuZnfAUtHw--.25875S12;
	Fri, 28 Mar 2025 14:14:50 +0800 (CST)
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
Subject: [PATCH RFC v2 08/14] md/md-llbitmap: implement APIs for page level dirty bits synchronization
Date: Fri, 28 Mar 2025 14:08:47 +0800
Message-Id: <20250328060853.4124527-9-yukuai1@huaweicloud.com>
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
X-CM-TRANSID:gCh0CgDHK2BSPuZnfAUtHw--.25875S12
X-Coremail-Antispam: 1UD129KBjvJXoWxKF47KryrKF1kKryxJrW5KFg_yoW7GFy5pF
	WxX345GFW5JF1xW3y3JrZrAFyrtr4kt392g3s3C34F9w12krZa9F1xCFyUAws8Wrn3GFnr
	Ars8Kw15G3W8XFUanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
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
	AF67kF1VAFwI0_GFv_WrylIxkGc2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWUCVW8JwCI
	42IY6xIIjxv20xvEc7CjxVAFwI0_Gr1j6F4UJwCI42IY6xAIw20EY4v20xvaj40_Jr0_JF
	4lIxAIcVC2z280aVAFwI0_Jr0_Gr1lIxAIcVC2z280aVCY1x0267AKxVW8Jr0_Cr1UYxBI
	daVFxhVjvjDU0xZFpf9x0JUQFxUUUUUU=
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/

From: Yu Kuai <yukuai3@huawei.com>

IO fast path will set bits to dirty, and those dirty bits must be
cleared after IO is done, to prevent unnecessary data recovery after
power failure.

This patch add a bitmap page level barrier and related APIs,
- llbitmap_{suspend, resume} will be used by daemon from slow path:
 1) suspend new write IO;
 2) wait for inflight write IO to be done;
 3) clear dirty bits;
 4) resume write IO;

- llbitmap_{raise, release}_barrier will be used in IO fast path, the
overhead is just one percpu ref get if the page is not suspended.

Signed-off-by: Yu Kuai <yukuai3@huawei.com>
---
 drivers/md/md-llbitmap.c | 119 +++++++++++++++++++++++++++++++++++++++
 1 file changed, 119 insertions(+)

diff --git a/drivers/md/md-llbitmap.c b/drivers/md/md-llbitmap.c
index bbd8a7c99577..7d4a0e81f8e1 100644
--- a/drivers/md/md-llbitmap.c
+++ b/drivers/md/md-llbitmap.c
@@ -63,12 +63,29 @@
  * llbitmap_add_disk(). And a file is created as well to manage bitmap IO for
  * this disk, see details in llbitmap_open_disk(). Read/write bitmap is
  * converted to buffer IO to this file.
+ *
+ * IO fast path will set bits to dirty, and those dirty bits will be cleared
+ * by daemon after IO is done. llbitmap_barrier is used to syncronize between
+ * IO path and daemon;
+ *
+ * IO patch:
+ *  1) try to grab a reference, if succeed, set expire time after 5s and return;
+ *  2) wait for daemon to finish clearing dirty bits;
+ *
+ * Daemon(Daemon will be wake up every daemon_sleep seconds):
+ * For each page:
+ *  1) check if page expired, if not skip this page; for expired page:
+ *  2) suspend the page and wait for inflight write IO to be done;
+ *  3) change dirty page to clean;
+ *  4) resume the page;
  */
 
 #define BITMAP_MAX_SECTOR (128 * 2)
 #define BITMAP_MAX_PAGES 32
 #define BITMAP_SB_SIZE 1024
 
+#define BARRIER_IDLE 5
+
 enum llbitmap_state {
 	/* No valid data, init state after assemble the array */
 	BitUnwritten = 0,
@@ -115,6 +132,16 @@ enum llbitmap_action {
 	BitmapActionInit,
 };
 
+/*
+ * page level barrier to synchronize between dirty bit by write IO and clean bit
+ * by daemon.
+ */
+struct llbitmap_barrier {
+	struct percpu_ref active;
+	unsigned long expire;
+	wait_queue_head_t wait;
+} ____cacheline_aligned_in_smp;
+
 struct llbitmap {
 	struct mddev *mddev;
 	/* hidden disk to manage bitmap IO */
@@ -123,6 +150,7 @@ struct llbitmap {
 	struct file *bitmap_file;
 	int nr_pages;
 	struct page *pages[BITMAP_MAX_PAGES];
+	struct llbitmap_barrier barrier[BITMAP_MAX_PAGES];
 
 	struct bio_set bio_set;
 	struct bio_list retry_list;
@@ -492,3 +520,94 @@ static void llbitmap_close_disk(struct llbitmap *llbitmap)
 	fput(bitmap_file);
 }
 
+static void llbitmap_free_pages(struct llbitmap *llbitmap)
+{
+	int i;
+
+	for (i = 0; i < BITMAP_MAX_PAGES; i++) {
+		struct page *page = llbitmap->pages[i];
+
+		if (!page)
+			return;
+
+		llbitmap->pages[i] = NULL;
+		put_page(page);
+		percpu_ref_exit(&llbitmap->barrier[i].active);
+	}
+}
+
+static void llbitmap_raise_barrier(struct llbitmap *llbitmap, int page_idx)
+{
+	struct llbitmap_barrier *barrier = &llbitmap->barrier[page_idx];
+
+retry:
+	if (likely(percpu_ref_tryget_live(&barrier->active))) {
+		WRITE_ONCE(barrier->expire, jiffies + BARRIER_IDLE * HZ);
+		return;
+	}
+
+	wait_event(barrier->wait, !percpu_ref_is_dying(&barrier->active));
+	goto retry;
+}
+
+static void llbitmap_release_barrier(struct llbitmap *llbitmap, int page_idx)
+{
+	struct llbitmap_barrier *barrier = &llbitmap->barrier[page_idx];
+
+	percpu_ref_put(&barrier->active);
+}
+
+static void llbitmap_suspend(struct llbitmap *llbitmap, int page_idx)
+{
+	struct llbitmap_barrier *barrier = &llbitmap->barrier[page_idx];
+
+	percpu_ref_kill(&barrier->active);
+	wait_event(barrier->wait, percpu_ref_is_zero(&barrier->active));
+}
+
+static void llbitmap_resume(struct llbitmap *llbitmap, int page_idx)
+{
+	struct llbitmap_barrier *barrier = &llbitmap->barrier[page_idx];
+
+	barrier->expire = LONG_MAX;
+	percpu_ref_resurrect(&barrier->active);
+	wake_up(&barrier->wait);
+}
+
+static void active_release(struct percpu_ref *ref)
+{
+	struct llbitmap_barrier *barrier =
+		container_of(ref, struct llbitmap_barrier, active);
+
+	wake_up(&barrier->wait);
+}
+
+static int llbitmap_cache_pages(struct llbitmap *llbitmap)
+{
+	int nr_pages = (llbitmap->chunks + BITMAP_SB_SIZE + PAGE_SIZE - 1) / PAGE_SIZE;
+	struct page *page;
+	int i = 0;
+
+	llbitmap->nr_pages = nr_pages;
+	while (i < nr_pages) {
+		page = read_mapping_page(llbitmap->bitmap_file->f_mapping, i, NULL);
+		if (IS_ERR(page)) {
+			int ret = PTR_ERR(page);
+
+			llbitmap_free_pages(llbitmap);
+			return ret;
+		}
+
+		if (percpu_ref_init(&llbitmap->barrier[i].active, active_release,
+				    PERCPU_REF_ALLOW_REINIT, GFP_KERNEL)) {
+			put_page(page);
+			return -ENOMEM;
+		}
+
+		init_waitqueue_head(&llbitmap->barrier[i].wait);
+		llbitmap->pages[i++] = page;
+	}
+
+	return 0;
+}
+
-- 
2.39.2


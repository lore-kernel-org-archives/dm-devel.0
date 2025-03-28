Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 746402116F2
	for <dm-devel@lists.linux.dev>; Fri, 28 Mar 2025 06:15:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743142542; cv=none; b=KiIo9B7r1BVXl1sqSODsxNEPABYs5kKEJoo+f+QRtUDwOy9wG8QxIwYh7r35G5zvR8Dac8Xc8+hI4Rn986d7Oj9xiEraWCERWKvap9NXkDB9N/zwMVFYNgynU4zItC2tYEzw5wX4hvgK9BbOWuzp3t3ZepmDwBiNQOsAM6F1EKs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743142542; c=relaxed/simple;
	bh=f0pkztABVxsx1XEA4hoL0l/3Y1SW0SHoMhcrQFK2HK8=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=JsjrV4/pwQwLGiyIsPxtlQ6NpM+vBSGppOtNEAZF/qLcz32HXivfJtH/4viSB3ySwTNgaJLQbSM76EhCd3Vlmf2nPlMJK2jvZjHphcSQyFa2CQjanK86VaX0Wa9pSoul6crj+tQq2U1DWKSqVsJ9/lmsmchZoiV3mMF3DauHorw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.216])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTP id 4ZP9GV6KmFz4f3jdD
	for <dm-devel@lists.linux.dev>; Fri, 28 Mar 2025 14:14:26 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id DACD01A1407
	for <dm-devel@lists.linux.dev>; Fri, 28 Mar 2025 14:14:49 +0800 (CST)
Received: from huaweicloud.com (unknown [10.175.104.67])
	by APP4 (Coremail) with SMTP id gCh0CgDHK2BSPuZnfAUtHw--.25875S10;
	Fri, 28 Mar 2025 14:14:49 +0800 (CST)
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
Subject: [PATCH RFC v2 06/14] md/md-llbitmap: implement bit state machine
Date: Fri, 28 Mar 2025 14:08:45 +0800
Message-Id: <20250328060853.4124527-7-yukuai1@huaweicloud.com>
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
X-CM-TRANSID:gCh0CgDHK2BSPuZnfAUtHw--.25875S10
X-Coremail-Antispam: 1UD129KBjvJXoW3JrWkur43WF15tw43tFWDJwb_yoWfXF4DpF
	sxZrn3GrsYqa1rX347Ja42vF95tr4kJry3tr9rA3sYvw1jyFZI9F1vgFW8J3y7G3yUG3WU
	Xan8Gr95GF45Z3DanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
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

Each bit is one byte and contain 6 different state, and there are total
8 different action can change state, see details in the following form:

|           | Startwrite | Startsync | Endsync | Abortsync| Reload   | Daemon | Discard   | Stale     |
| --------- | ---------- | --------- | ------- | -------  | -------- | ------ | --------- | --------- |
| Unwritten | Dirty      | x         | x       | x        | x        | x      | x         | x         |
| Clean     | Dirty      | x         | x       | x        | x        | x      | Unwritten | NeedSync  |
| Dirty     | x          | x         | x       | x        | NeedSync | Clean  | Unwritten | NeedSync  |
| NeedSync  | x          | Syncing   | x       | x        | x        | x      | Unwritten | x         |
| Syncing   | x          | Syncing   | Dirty   | NeedSync | NeedSync | x      | Unwritten | NeedSync  |

This patch implement the state machine first, and following patches will
use it to implement new llbitmap.

Signed-off-by: Yu Kuai <yukuai3@huawei.com>
---
 drivers/md/md-llbitmap.c | 256 +++++++++++++++++++++++++++++++++++++++
 1 file changed, 256 insertions(+)
 create mode 100644 drivers/md/md-llbitmap.c

diff --git a/drivers/md/md-llbitmap.c b/drivers/md/md-llbitmap.c
new file mode 100644
index 000000000000..1f97b6868279
--- /dev/null
+++ b/drivers/md/md-llbitmap.c
@@ -0,0 +1,256 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+
+#include <linux/blkdev.h>
+#include <linux/module.h>
+#include <linux/errno.h>
+#include <linux/slab.h>
+#include <linux/init.h>
+#include <linux/timer.h>
+#include <linux/sched.h>
+#include <linux/list.h>
+#include <linux/file.h>
+#include <linux/mount.h>
+#include <linux/buffer_head.h>
+#include <linux/seq_file.h>
+#include <trace/events/block.h>
+
+#include "md.h"
+#include "md-bitmap.h"
+
+/*
+ * #### Background
+ *
+ * Redundant data is used to enhance data fault tolerance, and the storage
+ * method for redundant data vary depending on the RAID levels. And it's
+ * important to maintain the consistency of redundant data.
+ *
+ * Bitmap is used to record which data blocks have been synchronized and which
+ * ones need to be resynchronized or recovered. Each bit in the bitmap
+ * represents a segment of data in the array. When a bit is set, it indicates
+ * that the multiple redundant copies of that data segment may not be
+ * consistent. Data synchronization can be performed based on the bitmap after
+ * power failure or readding a disk. If there is no bitmap, a full disk
+ * synchronization is required.
+ *
+ * #### Key Concept
+ *
+ * ##### State Machine
+ *
+ * Each bit is one byte, contain 6 difference state, see llbitmap_state. And
+ * there are total 8 differenct actions, see llbitmap_action, can change state:
+ *
+ * llbitmap state machine: transitions between states
+ *
+ * |           | Startwrite | Startsync | Endsync | Abortsync| Reload   | Daemon | Discard   | Stale     |
+ * | --------- | ---------- | --------- | ------- | -------  | -------- | ------ | --------- | --------- |
+ * | Unwritten | Dirty      | x         | x       | x        | x        | x      | x         | x         |
+ * | Clean     | Dirty      | x         | x       | x        | x        | x      | Unwritten | NeedSync  |
+ * | Dirty     | x          | x         | x       | x        | NeedSync | Clean  | Unwritten | NeedSync  |
+ * | NeedSync  | x          | Syncing   | x       | x        | x        | x      | Unwritten | x         |
+ * | Syncing   | x          | Syncing   | Dirty   | NeedSync | NeedSync | x      | Unwritten | NeedSync  |
+ *
+ * special illustration:
+ * - Unwritten is special state, which means user never write data, hence there
+ *   is no need to resync/recover data. This is safe if user create filesystems
+ *   for the array, filesystem will make sure user will get zero data for
+ *   unwritten blocks.
+ * - After resync is done, change state from Syncing to Dirty first, in case
+ *   Startwrite happen before the state is Clean.
+ */
+
+#define BITMAP_MAX_PAGES 32
+#define BITMAP_SB_SIZE 1024
+
+enum llbitmap_state {
+	/* No valid data, init state after assemble the array */
+	BitUnwritten = 0,
+	/* data is consistent */
+	BitClean,
+	/* data will be consistent after IO is done, set directly for writes */
+	BitDirty,
+	/*
+	 * data need to be resynchronized:
+	 * 1) set directly for writes if array is degraded, prevent full disk
+	 * synchronization after readding a disk;
+	 * 2) reassemble the array after power failure, and dirty bits are
+	 * found after reloading the bitmap;
+	 * */
+	BitNeedSync,
+	/* data is synchronizing */
+	BitSyncing,
+	nr_llbitmap_state,
+	BitNone = 0xff,
+};
+
+enum llbitmap_action {
+	/* User write new data, this is the only acton from IO fast path */
+	BitmapActionStartwrite = 0,
+	/* Start recovery */
+	BitmapActionStartsync,
+	/* Finish recovery */
+	BitmapActionEndsync,
+	/* Failed recovery */
+	BitmapActionAbortsync,
+	/* Reassemble the array */
+	BitmapActionReload,
+	/* Daemon thread is trying to clear dirty bits */
+	BitmapActionDaemon,
+	/* Data is deleted */
+	BitmapActionDiscard,
+	/*
+	 * Bitmap is stale, mark all bits in addition to BitUnwritten to
+	 * BitNeedSync.
+	 */
+	BitmapActionStale,
+	nr_llbitmap_action,
+	/* Init state is BitUnwritten */
+	BitmapActionInit,
+};
+
+struct llbitmap {
+	struct mddev *mddev;
+	/* hidden disk to manage bitmap IO */
+	struct gendisk *bitmap_disk;
+	/* opened hidden disk */
+	struct file *bitmap_file;
+	int nr_pages;
+	struct page *pages[BITMAP_MAX_PAGES];
+
+	struct bio_set bio_set;
+	struct bio_list retry_list;
+	struct work_struct retry_work;
+	spinlock_t retry_lock;
+
+	/* shift of one chunk */
+	unsigned long chunkshift;
+	/* size of one chunk in sector */
+	unsigned long chunksize;
+	/* total number of chunks */
+	unsigned long chunks;
+	/* fires on first BitDirty state */
+	struct timer_list pending_timer;
+	struct work_struct daemon_work;
+
+	unsigned long flags;
+	__u64	events_cleared;
+};
+
+static char state_machine[nr_llbitmap_state][nr_llbitmap_action] = {
+	[BitUnwritten] = {BitDirty, BitNone, BitNone, BitNone, BitNone, BitNone, BitNone, BitNone},
+	[BitClean] = {BitDirty, BitNone, BitNone, BitNone, BitNone, BitNone, BitUnwritten, BitNeedSync},
+	[BitDirty] = {BitNone, BitNone, BitNone, BitNone, BitNeedSync, BitClean, BitUnwritten, BitNeedSync},
+	[BitNeedSync] = {BitNone, BitSyncing, BitNone, BitNone, BitNone, BitNone, BitUnwritten, BitNone},
+	[BitSyncing] = {BitNone, BitSyncing, BitDirty, BitNeedSync, BitNeedSync, BitNone, BitUnwritten, BitNeedSync},
+};
+
+static enum llbitmap_state state_from_page(struct page *page, loff_t pos)
+{
+	u8 *p = kmap_local_page(page);
+	enum llbitmap_state state = p[offset_in_page(pos)];
+
+	kunmap_local(p);
+	return state;
+}
+
+static void state_to_page(struct page *page, enum llbitmap_state state,
+			  loff_t pos)
+{
+	u8 *p = kmap_local_page(page);
+
+	p[offset_in_page(pos)] = state;
+	set_page_dirty(page);
+	kunmap_local(p);
+}
+
+static int llbitmap_read(struct llbitmap *llbitmap, enum llbitmap_state *state,
+			 loff_t pos)
+{
+	pos += BITMAP_SB_SIZE;
+	*state = state_from_page(llbitmap->pages[pos >> PAGE_SHIFT], pos);
+	return 0;
+}
+
+static int llbitmap_write(struct llbitmap *llbitmap, enum llbitmap_state state,
+			  loff_t pos)
+{
+	pos += BITMAP_SB_SIZE;
+	state_to_page(llbitmap->pages[pos >> PAGE_SHIFT], state, pos);
+	return 0;
+}
+
+/* The return value is only used from resync, where @start == @end. */
+static enum llbitmap_state llbitmap_state_machine(struct llbitmap *llbitmap,
+						  unsigned long start,
+						  unsigned long end,
+						  enum llbitmap_action action)
+{
+	struct mddev *mddev = llbitmap->mddev;
+	enum llbitmap_state state = BitNone;
+	bool need_recovery = false;
+
+	if (test_bit(BITMAP_WRITE_ERROR, &llbitmap->flags))
+		return BitNone;
+
+	while (start <= end) {
+		ssize_t ret;
+		enum llbitmap_state c;
+
+		if (action == BitmapActionInit) {
+			state = BitUnwritten;
+			ret = llbitmap_write(llbitmap, state, start);
+			if (ret < 0) {
+				set_bit(BITMAP_WRITE_ERROR, &llbitmap->flags);
+				return BitNone;
+			}
+
+			start++;
+			continue;
+		}
+
+		ret = llbitmap_read(llbitmap, &c, start);
+		if (ret < 0) {
+			set_bit(BITMAP_WRITE_ERROR, &llbitmap->flags);
+			return BitNone;
+		}
+
+		if (c < 0 || c >= nr_llbitmap_state) {
+			pr_err("%s: invalid bit %lu state %d action %d, forcing resync\n",
+			       __func__, start, c, action);
+			c = BitNeedSync;
+			goto write_bitmap;
+		}
+
+		if (c == BitNeedSync)
+			need_recovery = true;
+
+		state = state_machine[c][action];
+		if (state == BitNone) {
+			start++;
+			continue;
+		}
+
+write_bitmap:
+		ret = llbitmap_write(llbitmap, state, start);
+		if (ret < 0) {
+			set_bit(BITMAP_WRITE_ERROR, &llbitmap->flags);
+			return BitNone;
+		}
+
+		if (state == BitNeedSync)
+			need_recovery = true;
+		else if (state == BitDirty &&
+			 !timer_pending(&llbitmap->pending_timer))
+			mod_timer(&llbitmap->pending_timer,
+				  jiffies + mddev->bitmap_info.daemon_sleep * HZ);
+
+		start++;
+	}
+
+	if (need_recovery) {
+		set_bit(MD_RECOVERY_NEEDED, &mddev->recovery);
+		set_bit(MD_RECOVERY_SYNC, &mddev->recovery);
+		md_wakeup_thread(mddev->thread);
+	}
+
+	return state;
+}
-- 
2.39.2


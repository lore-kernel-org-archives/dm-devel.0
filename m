Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D25701E5B9E
	for <dm-devel@lists.linux.dev>; Mon, 12 May 2025 01:28:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747013293; cv=none; b=Fg6ZfgB//4pXt0FWtXk+hAxq5EJ93TZ1UYyjkCf0fnBpkUv6tjLoLlCCKXDxPlJwyyqAwTB8vLYtJDObYCtFJnuEAd72TfglunYgirRQyhbJ9uHZK3N5e0L128H7Ffc6Yn3PE005SZOnimQmfFbLRkcRF3HvzoaPuQ3KMaJ5o5g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747013293; c=relaxed/simple;
	bh=m4pjRq7129TZ6hLY++gKH7ZOY1JonomcS9hFruvGQ9o=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=aqkjK175YBzpwO8GCb9JpBRtj8jJOHHylBykfbkb3QsfyhmshdfrxM6QJHRkYL91nqIW2oOipW52giRic+SDMnIYzyQlI+8ghCa8WcHoNixIzoT73EPbkexbB+z6wa79nNZiB7ea4zJIok/rXnAOQeYFe8kT9+X39ZwDM9dbY3s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=none smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.93.142])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTP id 4Zwhn02bcJz4f3jtJ
	for <dm-devel@lists.linux.dev>; Mon, 12 May 2025 09:27:48 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id CE9201A018D
	for <dm-devel@lists.linux.dev>; Mon, 12 May 2025 09:28:07 +0800 (CST)
Received: from huaweicloud.com (unknown [10.175.104.67])
	by APP4 (Coremail) with SMTP id gCh0CgCnC2CdTiFoNFCWMA--.55093S14;
	Mon, 12 May 2025 09:28:07 +0800 (CST)
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
Subject: [PATCH RFC md-6.16 v3 10/19] md/md-llbitmap: add data structure definition and comments
Date: Mon, 12 May 2025 09:19:18 +0800
Message-Id: <20250512011927.2809400-11-yukuai1@huaweicloud.com>
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
X-CM-TRANSID:gCh0CgCnC2CdTiFoNFCWMA--.55093S14
X-Coremail-Antispam: 1UD129KBjvJXoWxKF15uw43Ww17tryxtF1DWrg_yoWDGryfpF
	W3ZrnxJrs8J3yxK347AFy2qFyftw4kAw13try3A3WF9w1YyF9avF92gFWrW3y7G3y7G3W7
	ZFs8Kr98Ga98ArJanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUmS14x267AKxVWrJVCq3wAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2048vs2IY020E87I2jVAFwI0_JF0E3s1l82xGYI
	kIc2x26xkF7I0E14v26ryj6s0DM28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48ve4kI8wA2
	z4x0Y4vE2Ix0cI8IcVAFwI0_Ar0_tr1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI0_Gr1j6F
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

Signed-off-by: Yu Kuai <yukuai3@huawei.com>
---
 drivers/md/md-llbitmap.c | 281 +++++++++++++++++++++++++++++++++++++++
 1 file changed, 281 insertions(+)
 create mode 100644 drivers/md/md-llbitmap.c

diff --git a/drivers/md/md-llbitmap.c b/drivers/md/md-llbitmap.c
new file mode 100644
index 000000000000..8ab4c77abd32
--- /dev/null
+++ b/drivers/md/md-llbitmap.c
@@ -0,0 +1,281 @@
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
+ * #### Key Features
+ *
+ *  - IO fastpath is lockless, if user issues lots of write IO to the same
+ *  bitmap bit in a short time, only the first write have additional overhead
+ *  to update bitmap bit, no additional overhead for the following writes;
+ *  - support only resync or recover written data, means in the case creating
+ *  new array or replacing with a new disk, there is no need to do a full disk
+ *  resync/recovery;
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
+ * Typical scenarios:
+ *
+ * 1) Create new array
+ * All bits will be set to Unwritten by default, if --assume-clean is set,
+ * All bits will be set to Clean instead.
+ *
+ * 2) write data, raid1/raid10 have full copy of data, while raid456 doesn't and
+ * rely on xor data
+ *
+ * 2.1) write new data to raid1/raid10:
+ * Unwritten --StartWrite--> Dirty
+ *
+ * 2.2) write new data to raid456:
+ * Unwritten --StartWrite--> NeedSync
+ *
+ * Because the initial recover for raid456 is skipped, the xor data is not build
+ * yet, the bit must set to NeedSync first and after lazy initial recover is
+ * finished, the bit will finially set to Dirty(see 4.1 and 4.4);
+ *
+ * 2.3) cover write
+ * Clean --StartWrite--> Dirty
+ *
+ * 3) daemon, if the array is not degraded:
+ * Dirty --Daemon--> Clean
+ *
+ * For degraded array, the Dirty bit will never be cleared, prevent full disk
+ * recovery while readding a removed disk.
+ *
+ * 4) discard
+ * {Clean, Dirty, NeedSync, Syncing} --Discard--> Unwritten
+ *
+ * 5) resync and recover
+ *
+ * 5.1) common process
+ * NeedSync --Startsync--> Syncing --Endsync--> Dirty --Daemon--> Clean
+ *
+ * 5.2) resync after power failure
+ * Dirty --Reload--> NeedSync
+ *
+ * 5.3) recover while replacing with a new disk
+ * By default, the old bitmap framework will recover all data, and llbitmap
+ * implement this by a new helper llbitmap_skip_sync_blocks:
+ *
+ * skip recover for bits other than dirty or clean;
+ *
+ * 5.4) lazy initial recover for raid5:
+ * By default, the old bitmap framework will only allow new recover when there
+ * are spares(new disk), a new recovery flag MD_RECOVERY_LAZY_RECOVER is add
+ * to perform raid456 lazy recover for set bits(from 2.2).
+ *
+ * ##### Bitmap IO
+ *
+ * ##### Chunksize
+ *
+ * The default bitmap size is 128k, incluing 1k bitmap super block, and
+ * the default size of segment of data in the array each bit(chunksize) is 64k,
+ * and chunksize will adjust to twice the old size each time if the total number
+ * bits is not less than 127k.(see llbitmap_init)
+ *
+ * ##### READ
+ *
+ * While creating bitmap, all pages will be allocated and read for llbitmap,
+ * there won't be read afterwards
+ *
+ * ##### WRITE
+ *
+ * WRITE IO is divided into logical_block_size of the array, the dirty state
+ * of each block is tracked independently, for example:
+ *
+ * each page is 4k, contain 8 blocks; each block is 512 bytes contain 512 bit;
+ *
+ * | page0 | page1 | ... | page 31 |
+ * |       |
+ * |        \-----------------------\
+ * |                                |
+ * | block0 | block1 | ... | block 8|
+ * |        |
+ * |         \-----------------\
+ * |                            |
+ * | bit0 | bit1 | ... | bit511 |
+ *
+ * From IO path, if one bit is changed to Dirty or NeedSync, the corresponding
+ * block will be marked dirty, such block must write first before the IO is
+ * issued. This behaviour will affect IO performance, to reduce the impact, if
+ * multiple bits are changed in the same block in a short time, all bits in this
+ * block will be changed to Dirty/NeedSync, so that there won't be any overhead
+ * until daemon clears dirty bits.
+ *
+ * ##### Dirty Bits syncronization
+ *
+ * IO fast path will set bits to dirty, and those dirty bits will be cleared
+ * by daemon after IO is done. llbitmap_barrier is used to synchronize between
+ * IO path and daemon;
+ *
+ * IO path:
+ *  1) try to grab a reference, if succeed, set expire time after 5s and return;
+ *  2) if failed to grab a reference, wait for daemon to finish clearing dirty
+ *  bits;
+ *
+ * Daemon(Daemon will be waken up every daemon_sleep seconds):
+ * For each page:
+ *  1) check if page expired, if not skip this page; for expired page:
+ *  2) suspend the page and wait for inflight write IO to be done;
+ *  3) change dirty page to clean;
+ *  4) resume the page;
+ */
+
+#define LLBITMAP_MAJOR_HI 6
+
+#define BITMAP_MAX_SECTOR (128 * 2)
+#define BITMAP_MAX_PAGES 32
+#define BITMAP_SB_SIZE 1024
+/* 64k is the max IO size of sync IO for raid1/raid10 */
+#define MIN_CHUNK_SIZE (64 * 2)
+
+#define DEFAULT_DAEMON_SLEEP 30
+
+#define BARRIER_IDLE 5
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
+	 */
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
+enum barrier_state {
+	LLPageFlush = 0,
+	LLPageDirty,
+};
+/*
+ * page level barrier to synchronize between dirty bit by write IO and clean bit
+ * by daemon.
+ */
+struct llbitmap_barrier {
+	char *data;
+	struct percpu_ref active;
+	unsigned long expire;
+	unsigned long flags;
+	/* Per block size dirty state, maximum 64k page / 512 sector = 128 */
+	DECLARE_BITMAP(dirty, 128);
+	wait_queue_head_t wait;
+} ____cacheline_aligned_in_smp;
+
+struct llbitmap {
+	struct mddev *mddev;
+	int nr_pages;
+	struct page *pages[BITMAP_MAX_PAGES];
+	struct llbitmap_barrier barrier[BITMAP_MAX_PAGES];
+
+	/* shift of one chunk */
+	unsigned long chunkshift;
+	/* size of one chunk in sector */
+	unsigned long chunksize;
+	/* total number of chunks */
+	unsigned long chunks;
+	int io_size;
+	int bits_per_page;
+	/* fires on first BitDirty state */
+	struct timer_list pending_timer;
+	struct work_struct daemon_work;
+
+	unsigned long flags;
+	__u64	events_cleared;
+};
+
+struct llbitmap_unplug_work {
+	struct work_struct work;
+	struct llbitmap *llbitmap;
+	struct completion *done;
+};
+
+static struct workqueue_struct *md_llbitmap_io_wq;
+static struct workqueue_struct *md_llbitmap_unplug_wq;
+
+static char state_machine[nr_llbitmap_state][nr_llbitmap_action] = {
+	[BitUnwritten] = {BitDirty, BitNone, BitNone, BitNone, BitNone, BitNone, BitNone, BitNone},
+	[BitClean] = {BitDirty, BitNone, BitNone, BitNone, BitNone, BitNone, BitUnwritten, BitNeedSync},
+	[BitDirty] = {BitNone, BitNone, BitNone, BitNone, BitNeedSync, BitClean, BitUnwritten, BitNeedSync},
+	[BitNeedSync] = {BitNone, BitSyncing, BitNone, BitNone, BitNone, BitNone, BitUnwritten, BitNone},
+	[BitSyncing] = {BitNone, BitSyncing, BitDirty, BitNeedSync, BitNeedSync, BitNone, BitUnwritten, BitNeedSync},
+};
-- 
2.39.2


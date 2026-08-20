Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E14C237D101
	for <dm-devel@lists.linux.dev>; Thu, 20 Aug 2026 02:30:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787193023; cv=none; b=gaF0xhIOLG4fVDWTqalOMsRcZ0sjo+vseIbvrQI8yvLavs0uKP7/9IYQngqeYVIA/3NnOkJuT6NiOt28m1SHMUzJ7CK6ovMyBGqakxRa5B3gVkesRAhvraQRmOC3iWNPaaDnEfPUI39D1Td6ixxKoO+3IBtOwVGpPyTMLws6IDo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787193023; c=relaxed/simple;
	bh=FnJ1TE2f68kWSRSTf2FMvWF+Fje27qmUtEjteXX8c4g=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=jWWF3/Otu8BlNBb0tzgad/mhdkq+G+sRE0bksPo4rxgpdZ3JE7UIOuRZioAiAmF4y3+PbGj4v7URirE3etVTlW2bb71iLCjQJPbmMjDSYIJe31InnpOme9f5m8c7IhkyR1+1QyXbhlJ6rokYEMH788UgjkSsrLGl9LTManuH34k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=none smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.177])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTPS id 4hQS8748wjzYQty2
	for <dm-devel@lists.linux.dev>; Thu, 20 Aug 2026 10:29:59 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.75])
	by mail.maildlp.com (Postfix) with ESMTP id 8495C40590
	for <dm-devel@lists.linux.dev>; Thu, 20 Aug 2026 10:30:17 +0800 (CST)
Received: from huaweicloud.com (unknown [10.50.87.132])
	by APP2 (Coremail) with UTF8SMTPSA id Syh0CgB34om4ZoZqkD7rCw--.39952S5;
	Thu, 20 Aug 2026 10:30:17 +0800 (CST)
From: Ye Bin <yebin@huaweicloud.com>
To: agk@redhat.com,
	snitzer@kernel.org,
	mpatocka@redhat.com,
	bmarzins@redhat.com,
	dm-devel@lists.linux.dev
Cc: yebin@huaweicloud.com,
	yebin10@huawei.com
Subject: [PATCH RFC 1/2] dm persistent-data: add btree traversal depth limit to detect metadata corruption
Date: Thu, 20 Aug 2026 10:24:16 +0800
Message-Id: <20260820022417.3841604-2-yebin@huaweicloud.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260820022417.3841604-1-yebin@huaweicloud.com>
References: <20260820022417.3841604-1-yebin@huaweicloud.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:Syh0CgB34om4ZoZqkD7rCw--.39952S5
X-Coremail-Antispam: 1UD129KBjvJXoWxKF13AFyrGrW7Zr15tF48tFb_yoWxCw1kpr
	Z7J3sIkw4ktw47urs0yw40vFyYkw1S9340kasIkas5ury5CFn2yF4YyFWvvr9I9FWxJa4Y
	qr4Ut398ua1UtrUanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUBC14x267AKxVW5JVWrJwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2048vs2IY020E87I2jVAFwI0_Jr4l82xGYIkIc2
	x26xkF7I0E14v26r1I6r4UM28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48ve4kI8wA2z4x0
	Y4vE2Ix0cI8IcVAFwI0_Gr0_Xr1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI0_Gr0_Cr1l84
	ACjcxK6I8E87Iv67AKxVW8Jr0_Cr1UM28EF7xvwVC2z280aVCY1x0267AKxVWxJr0_GcWl
	e2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG64xvF2IEw4CE5I8CrVC2j2WlYx0E2Ix0cI
	8IcVAFwI0_JrI_JrylYx0Ex4A2jsIE14v26r1j6r4UMcvjeVCFs4IE7xkEbVWUJVW8JwAC
	jcxG0xvY0x0EwIxGrwACjI8F5VA0II8E6IAqYI8I648v4I1lc7CjxVAaw2AFwI0_JF0_Jw
	1l42xK82IYc2Ij64vIr41l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1lx2IqxVAqx4xG67AKxVWU
	JVWUGwC20s026x8GjcxK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r126r1DMIIYrxkI7V
	AKI48JMIIF0xvE2Ix0cI8IcVAFwI0_Jr0_JF4lIxAIcVC0I7IYx2IY6xkF7I0E14v26r4j
	6F4UMIIF0xvE42xK8VAvwI8IcIk0rVWUJVWUCwCI42IY6I8E87Iv67AKxVWUJVW8JwCI42
	IY6I8E87Iv6xkF7I0E14v26r4j6r4UJbIYCTnIWIevJa73UjIFyTuYvjfUYyCGUUUUU
X-CM-SenderInfo: p1hex046kxt4xhlfz01xgou0bp/

From: Ye Bin <yebin10@huawei.com>

The btree traversal loops in dm-persistent-data are unbounded do/while
or for(;;) loops.  When metadata is corrupted such that a node's value
points back to an ancestor (or to itself), these loops never terminate,
leaving the kernel hung in an uninterruptible state.

Add a DM_BTREE_MAX_DEPTH (16) counter to all unbounded traversal loops:
  - btree_lookup_raw()             (read path)
  - btree_insert_raw()             (insert path)
  - __btree_get_overwrite_leaf()   (overwrite path)
  - remove_raw()                   (remove path)
  - remove_nearest()               (remove_leaves path)
  - find_key()                     (find_highest/lowest_key path)

When the depth limit is exceeded, return -ELOOP and log a rate-limited
error indicating possible metadata corruption.

The cursor path (find_leaf) is already protected by
DM_BTREE_CURSOR_MAX_DEPTH in push_node().  The dm_btree_del() path is
already protected by MAX_SPINE_DEPTH (64) and __check_holder().

In dm-thin.c, handle -ELOOP from dm_thin_find_block() in all three
call sites (process_cell, __process_bio_read_only, and thin_bio_map) by
calling metadata_operation_failed() to abort the transaction and
downgrade the pool to read-only mode, preventing further writes to the
corrupted metadata.

16 levels can address well over 200^16 entries, far exceeding any
practical thin pool size, so the limit never affects valid metadata.

Signed-off-by: Ye Bin <yebin10@huawei.com>
---
 drivers/md/dm-thin.c                         |  9 +++++++
 drivers/md/persistent-data/dm-btree-remove.c | 14 ++++++++++
 drivers/md/persistent-data/dm-btree.c        | 28 ++++++++++++++++++++
 drivers/md/persistent-data/dm-btree.h        |  8 ++++++
 4 files changed, 59 insertions(+)

diff --git a/drivers/md/dm-thin.c b/drivers/md/dm-thin.c
index 59392de7a477..6492c6c3852d 100644
--- a/drivers/md/dm-thin.c
+++ b/drivers/md/dm-thin.c
@@ -1997,6 +1997,9 @@ static void process_cell(struct thin_c *tc, struct dm_bio_prison_cell *cell)
 	default:
 		DMERR_LIMIT("%s: dm_thin_find_block() failed: error = %d",
 			    __func__, r);
+		if (r == -ELOOP)
+			metadata_operation_failed(pool,
+						  "btree cycle detected", r);
 		cell_defer_no_holder(tc, cell);
 		bio_io_error(bio);
 		break;
@@ -2065,6 +2068,9 @@ static void __process_bio_read_only(struct thin_c *tc, struct bio *bio,
 	default:
 		DMERR_LIMIT("%s: dm_thin_find_block() failed: error = %d",
 			    __func__, r);
+		if (r == -ELOOP)
+			metadata_operation_failed(tc->pool,
+						  "btree cycle detected", r);
 		if (cell)
 			cell_defer_no_holder(tc, cell);
 		bio_io_error(bio);
@@ -2802,6 +2808,9 @@ static int thin_bio_map(struct dm_target *ti, struct bio *bio)
 		 * dm_thin_find_block can fail with -EINVAL if the
 		 * pool is switched to fail-io mode.
 		 */
+		if (r == -ELOOP)
+			metadata_operation_failed(tc->pool,
+						  "btree cycle detected", r);
 		bio_io_error(bio);
 		cell_defer_no_holder(tc, virt_cell);
 		return DM_MAPIO_SUBMITTED;
diff --git a/drivers/md/persistent-data/dm-btree-remove.c b/drivers/md/persistent-data/dm-btree-remove.c
index aeec5b9a1dd5..7e0560f71729 100644
--- a/drivers/md/persistent-data/dm-btree-remove.c
+++ b/drivers/md/persistent-data/dm-btree-remove.c
@@ -555,8 +555,15 @@ static int remove_raw(struct shadow_spine *s, struct dm_btree_info *info,
 {
 	int i = *index, r;
 	struct btree_node *n;
+	unsigned int depth = 0;
 
 	for (;;) {
+		if (depth++ >= DM_BTREE_MAX_DEPTH) {
+			DMERR_LIMIT("%s: exceeded max depth (%u), possible metadata corruption",
+				    __func__, DM_BTREE_MAX_DEPTH);
+			return -ELOOP;
+		}
+
 		r = shadow_step(s, root, vt);
 		if (r < 0)
 			break;
@@ -649,8 +656,15 @@ static int remove_nearest(struct shadow_spine *s, struct dm_btree_info *info,
 {
 	int i = *index, r;
 	struct btree_node *n;
+	unsigned int depth = 0;
 
 	for (;;) {
+		if (depth++ >= DM_BTREE_MAX_DEPTH) {
+			DMERR_LIMIT("%s: exceeded max depth (%u), possible metadata corruption",
+				    __func__, DM_BTREE_MAX_DEPTH);
+			return -ELOOP;
+		}
+
 		r = shadow_step(s, root, vt);
 		if (r < 0)
 			break;
diff --git a/drivers/md/persistent-data/dm-btree.c b/drivers/md/persistent-data/dm-btree.c
index dd02eee4a23c..3004537c75a1 100644
--- a/drivers/md/persistent-data/dm-btree.c
+++ b/drivers/md/persistent-data/dm-btree.c
@@ -346,8 +346,15 @@ static int btree_lookup_raw(struct ro_spine *s, dm_block_t block, uint64_t key,
 {
 	int i, r;
 	uint32_t flags, nr_entries;
+	unsigned int depth = 0;
 
 	do {
+		if (depth++ >= DM_BTREE_MAX_DEPTH) {
+			DMERR_LIMIT("%s: exceeded max depth (%u), possible metadata corruption",
+				    __func__, DM_BTREE_MAX_DEPTH);
+			return -ELOOP;
+		}
+
 		r = ro_step(s, block);
 		if (r < 0)
 			return r;
@@ -1095,8 +1102,15 @@ static int btree_insert_raw(struct shadow_spine *s, dm_block_t root,
 {
 	int r, i = *index, top = 1;
 	struct btree_node *node;
+	unsigned int depth = 0;
 
 	for (;;) {
+		if (depth++ >= DM_BTREE_MAX_DEPTH) {
+			DMERR_LIMIT("%s: exceeded max depth (%u), possible metadata corruption",
+				    __func__, DM_BTREE_MAX_DEPTH);
+			return -ELOOP;
+		}
+
 		r = shadow_step(s, root, vt);
 		if (r < 0)
 			return r;
@@ -1158,9 +1172,16 @@ static int __btree_get_overwrite_leaf(struct shadow_spine *s, dm_block_t root,
 {
 	int r, i = -1;
 	struct btree_node *node;
+	unsigned int depth = 0;
 
 	*index = 0;
 	for (;;) {
+		if (depth++ >= DM_BTREE_MAX_DEPTH) {
+			DMERR_LIMIT("%s: exceeded max depth (%u), possible metadata corruption",
+				    __func__, DM_BTREE_MAX_DEPTH);
+			return -ELOOP;
+		}
+
 		r = shadow_step(s, root, &s->info->value_type);
 		if (r < 0)
 			return r;
@@ -1342,8 +1363,15 @@ static int find_key(struct ro_spine *s, dm_block_t block, bool find_highest,
 {
 	int i, r;
 	uint32_t flags;
+	unsigned int depth = 0;
 
 	do {
+		if (depth++ >= DM_BTREE_MAX_DEPTH) {
+			DMERR_LIMIT("%s: exceeded max depth (%u), possible metadata corruption",
+				    __func__, DM_BTREE_MAX_DEPTH);
+			return -ELOOP;
+		}
+
 		r = ro_step(s, block);
 		if (r < 0)
 			return r;
diff --git a/drivers/md/persistent-data/dm-btree.h b/drivers/md/persistent-data/dm-btree.h
index 1b92acd7823d..617d808ca8dd 100644
--- a/drivers/md/persistent-data/dm-btree.h
+++ b/drivers/md/persistent-data/dm-btree.h
@@ -180,6 +180,14 @@ int dm_btree_walk(struct dm_btree_info *info, dm_block_t root,
 
 /*----------------------------------------------------------------*/
 
+/*
+ * Maximum depth of btree traversal.  Used to detect cycles caused by
+ * metadata corruption (e.g. a node whose value points back to itself).
+ * 16 levels can address well over 200^16 entries, far exceeding any
+ * practical thin pool size.
+ */
+#define DM_BTREE_MAX_DEPTH 16
+
 /*
  * Cursor API.  This does not follow the rolling lock convention.  Since we
  * know the order that values are required we can issue prefetches to speed
-- 
2.34.1


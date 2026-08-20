Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79BC637DEA2
	for <dm-devel@lists.linux.dev>; Thu, 20 Aug 2026 02:30:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787193026; cv=none; b=akax42TvhkWPuywHIdGwIwXVHO2FfH2VTw6GBirNn3I1EavBcMBbqsbeMlPwTJVHG56ucMAfwk89OTgsckdXoS560AAGsQOwHsM/NcIK9HSq1y2FUjLYIeH6y+rUHHw2rdxzuu+otHx/z3+TP4591mfTI2RsssMWJKP/YCDkgTg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787193026; c=relaxed/simple;
	bh=4iJ3OHIV9FIvY7b9+xo8X1ycY8ZmnfWT7bwcaZxln8I=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=LEaLaTDBGoiAN6ZML5KAAgShgAbiOufSAOyiE1ls5UnuO7Ib8EKb5mAQeuM2z3Mo5wyVIDPuSKjzlIX+uRGi3OdOJB0l4WKhICAHA1xmOH87pB6TjcmJpVSgXXW3USnl3sB77NYsJm9xiduFjt/gdiehth4IR5/HKEn3kFRNnd0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=none smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.198])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTPS id 4hQS7v3t7TzKHMRg
	for <dm-devel@lists.linux.dev>; Thu, 20 Aug 2026 10:29:47 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.75])
	by mail.maildlp.com (Postfix) with ESMTP id 9575140A0F
	for <dm-devel@lists.linux.dev>; Thu, 20 Aug 2026 10:30:17 +0800 (CST)
Received: from huaweicloud.com (unknown [10.50.87.132])
	by APP2 (Coremail) with UTF8SMTPSA id Syh0CgB34om4ZoZqkD7rCw--.39952S6;
	Thu, 20 Aug 2026 10:30:17 +0800 (CST)
From: Ye Bin <yebin@huaweicloud.com>
To: agk@redhat.com,
	snitzer@kernel.org,
	mpatocka@redhat.com,
	bmarzins@redhat.com,
	dm-devel@lists.linux.dev
Cc: yebin@huaweicloud.com,
	yebin10@huawei.com
Subject: [PATCH RFC 2/2] dm persistent-data: record space-map errors in transaction manager
Date: Thu, 20 Aug 2026 10:24:17 +0800
Message-Id: <20260820022417.3841604-3-yebin@huaweicloud.com>
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
X-CM-TRANSID:Syh0CgB34om4ZoZqkD7rCw--.39952S6
X-Coremail-Antispam: 1UD129KBjvAXoW3Aw13Wr4fZFW3Gr1xWF13CFg_yoW8JF4rto
	WfWFs0yrW8JF4UGas8Kas5JFyUZw4DKF98Gwn0qwsI93ZrArZ09a1xGw1rXa15Jay3KF9F
	qryxJ3y3tFWxJa9rn29KB7ZKAUJUUUU8529EdanIXcx71UUUUU7v73VFW2AGmfu7bjvjm3
	AaLaJ3UjIYCTnIWjp_UUUYE7AC8VAFwI0_Wr0E3s1l1xkIjI8I6I8E6xAIw20EY4v20xva
	j40_Wr0E3s1l1IIY67AEw4v_Jr0_Jr4l82xGYIkIc2x26280x7IE14v26r15M28IrcIa0x
	kI8VCY1x0267AKxVW8JVW5JwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK021l84AC
	jcxK6xIIjxv20xvE14v26r4j6ryUM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26r4j6F4UM2
	8EF7xvwVC2z280aVAFwI0_Gr1j6F4UJwA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_Cr1j6rxd
	M2AIxVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4xI64kE6c02F40Ex7xfMcIj6xIIjx
	v20xvE14v26r106r15McIj6I8E87Iv67AKxVWUJVW8JwAm72CE4IkC6x0Yz7v_Jr0_Gr1l
	F7xvr2IYc2Ij64vIr41lF7I21c0EjII2zVCS5cI20VAGYxC7MxkF7I0En4kS14v26r126r
	1DMxAIw28IcxkI7VAKI48JMxC20s026xCaFVCjc4AY6r1j6r4UMI8I3I0E5I8CrVAFwI0_
	Jr0_Jr4lx2IqxVCjr7xvwVAFwI0_JrI_JrWlx4CE17CEb7AF67AKxVWUAVWUtwCIc40Y0x
	0EwIxGrwCI42IY6xIIjxv20xvE14v26r1I6r4UMIIF0xvE2Ix0cI8IcVCY1x0267AKxVW8
	JVWxJwCI42IY6xAIw20EY4v20xvaj40_Jr0_JF4lIxAIcVC2z280aVAFwI0_Jr0_Gr1lIx
	AIcVC2z280aVCY1x0267AKxVW8JVW8JrUvcSsGvfC2KfnxnUUI43ZEXa7VUjTmh7UUUUU=
	=
X-CM-SenderInfo: p1hex046kxt4xhlfz01xgou0bp/

From: Ye Bin <yebin10@huawei.com>

dm_tm_inc(), dm_tm_dec(), dm_tm_inc_range(), and dm_tm_dec_range() have
void return types, so when the underlying space-map operations
(dm_sm_inc_block/dec_block/inc_blocks/dec_blocks) fail, the error is
silently swallowed.  The transaction proceeds and may be committed with
inconsistent reference counts, leading to:

  1. data_block_dec failure during device deletion: a data block's
     refcount is not decremented, causing a permanent space leak that
     is silently persisted on commit.

  2. inc_children failure during shadow of a shared node: a child
     node's refcount is not incremented.  When the old shared parent is
     later released, the child's refcount drops to zero prematurely.
     The block allocator can then reuse that child block as a shadow
     copy of the parent (which still contains a pointer to it), creating
     a self-referencing node that causes infinite loops in all btree
     traversal paths (mitigated by the depth-limit patch, but the
     underlying corruption remains).

  3. dm_tm_dec failure during rebalance merge: an internal node is not
     freed, causing a metadata space leak.

Fix this without changing any function signatures:

  - Add a sticky int sm_error field to struct dm_transaction_manager.
    dm_tm_inc/dm_tm_dec/dm_tm_inc_range/dm_tm_dec_range record the first
    error in sm_error.  Since all kernel error return values are
    non-zero, sm_error == 0 unambiguously means "no error".

  - dm_tm_pre_commit() and dm_tm_commit() check sm_error and refuse to
    commit if it is non-zero, returning the recorded error.

  - dm_tm_clear_error() resets sm_error to 0.  Called in
    __begin_transaction() at the start of each new transaction so a
    fresh transaction can proceed after the previous one was aborted.

Similarly, the data space-map operations (data_block_inc/data_block_dec
in dm-thin-metadata.c) call dm_sm_inc_blocks/dm_sm_dec_blocks() directly
via with_runs(), bypassing the transaction manager entirely.  Add a
parallel int data_sm_error field to struct dm_pool_metadata:

  - with_runs() is changed to return int so errors propagate.
  - data_block_inc/data_block_dec record the first error in
    data_sm_error.
  - __commit_transaction() checks data_sm_error and refuses to commit
    if it is non-zero.
  - __begin_transaction() and dm_pool_abort_metadata() clear
    data_sm_error so a fresh transaction can proceed after an abort.

The sm_error and data_sm_error fields are accessed only under
pmd->root_lock (write-locked for commit/abort, read-locked for
inc/dec during metadata operations), so no additional locking is
needed.

Signed-off-by: Ye Bin <yebin10@huawei.com>
---
 drivers/md/dm-thin-metadata.c                 | 65 +++++++++++++---
 .../persistent-data/dm-transaction-manager.c  | 74 ++++++++++++++++++-
 .../persistent-data/dm-transaction-manager.h  |  6 ++
 3 files changed, 132 insertions(+), 13 deletions(-)

diff --git a/drivers/md/dm-thin-metadata.c b/drivers/md/dm-thin-metadata.c
index e60e1326376a..e7e7facc8d89 100644
--- a/drivers/md/dm-thin-metadata.c
+++ b/drivers/md/dm-thin-metadata.c
@@ -227,6 +227,16 @@ struct dm_pool_metadata {
 	 */
 	__u8 data_space_map_root[SPACE_MAP_ROOT_SIZE];
 	__u8 metadata_space_map_root[SPACE_MAP_ROOT_SIZE];
+
+	/*
+	 * Sticky error flag for data space-map operations (inc/dec)
+	 * that were silently swallowed by the void value_type inc/dec
+	 * callbacks.  A non-zero value indicates the data space map is
+	 * inconsistent and the transaction must not be committed.
+	 * Checked in __commit_transaction(); cleared in
+	 * __begin_transaction() and dm_pool_abort_metadata().
+	 */
+	int data_sm_error;
 };
 
 struct dm_thin_device {
@@ -324,12 +334,13 @@ static void unpack_block_time(uint64_t v, dm_block_t *b, uint32_t *t)
  */
 typedef int (*run_fn)(struct dm_space_map *, dm_block_t, dm_block_t);
 
-static void with_runs(struct dm_space_map *sm, const __le64 *value_le, unsigned int count, run_fn fn)
+static int with_runs(struct dm_space_map *sm, const __le64 *value_le, unsigned int count, run_fn fn)
 {
 	uint64_t b, begin, end;
 	uint32_t t;
 	bool in_run = false;
 	unsigned int i;
+	int r = 0;
 
 	for (i = 0; i < count; i++, value_le++) {
 		/* We know value_le is 8 byte aligned */
@@ -339,7 +350,9 @@ static void with_runs(struct dm_space_map *sm, const __le64 *value_le, unsigned
 			if (b == end) {
 				end++;
 			} else {
-				fn(sm, begin, end);
+				r = fn(sm, begin, end);
+				if (r)
+					return r;
 				begin = b;
 				end = b + 1;
 			}
@@ -351,19 +364,35 @@ static void with_runs(struct dm_space_map *sm, const __le64 *value_le, unsigned
 	}
 
 	if (in_run)
-		fn(sm, begin, end);
+		r = fn(sm, begin, end);
+
+	return r;
 }
 
 static void data_block_inc(void *context, const void *value_le, unsigned int count)
 {
-	with_runs((struct dm_space_map *) context,
-		  (const __le64 *) value_le, count, dm_sm_inc_blocks);
+	struct dm_pool_metadata *pmd = context;
+	int r;
+
+	r = with_runs(pmd->data_sm, (const __le64 *) value_le,
+		      count, dm_sm_inc_blocks);
+	if (r && !pmd->data_sm_error) {
+		DMERR_LIMIT("data_block_inc failed: error %d", r);
+		pmd->data_sm_error = r;
+	}
 }
 
 static void data_block_dec(void *context, const void *value_le, unsigned int count)
 {
-	with_runs((struct dm_space_map *) context,
-		  (const __le64 *) value_le, count, dm_sm_dec_blocks);
+	struct dm_pool_metadata *pmd = context;
+	int r;
+
+	r = with_runs(pmd->data_sm, (const __le64 *) value_le,
+		      count, dm_sm_dec_blocks);
+	if (r && !pmd->data_sm_error) {
+		DMERR_LIMIT("data_block_dec failed: error %d", r);
+		pmd->data_sm_error = r;
+	}
 }
 
 static int data_block_equal(void *context, const void *value1_le, const void *value2_le)
@@ -485,7 +514,7 @@ static void __setup_btree_details(struct dm_pool_metadata *pmd)
 {
 	pmd->info.tm = pmd->tm;
 	pmd->info.levels = 2;
-	pmd->info.value_type.context = pmd->data_sm;
+	pmd->info.value_type.context = pmd;
 	pmd->info.value_type.size = sizeof(__le64);
 	pmd->info.value_type.inc = data_block_inc;
 	pmd->info.value_type.dec = data_block_dec;
@@ -504,7 +533,7 @@ static void __setup_btree_details(struct dm_pool_metadata *pmd)
 
 	pmd->bl_info.tm = pmd->tm;
 	pmd->bl_info.levels = 1;
-	pmd->bl_info.value_type.context = pmd->data_sm;
+	pmd->bl_info.value_type.context = pmd;
 	pmd->bl_info.value_type.size = sizeof(__le64);
 	pmd->bl_info.value_type.inc = data_block_inc;
 	pmd->bl_info.value_type.dec = data_block_dec;
@@ -846,6 +875,15 @@ static int __begin_transaction(struct dm_pool_metadata *pmd)
 	pmd->data_block_size = le32_to_cpu(disk_super->data_block_size);
 
 	dm_bm_unlock(sblock);
+
+	/*
+	 * Start the new transaction with a clean error slate.  Any
+	 * space-map errors from the previous (aborted) transaction
+	 * must not carry over.
+	 */
+	dm_tm_clear_error(pmd->tm);
+	pmd->data_sm_error = 0;
+
 	return 0;
 }
 
@@ -899,6 +937,12 @@ static int __commit_transaction(struct dm_pool_metadata *pmd)
 	if (unlikely(!pmd->in_service))
 		return 0;
 
+	if (pmd->data_sm_error) {
+		DMERR("aborting commit due to earlier data space-map error: %d",
+		      pmd->data_sm_error);
+		return pmd->data_sm_error;
+	}
+
 	if (pmd->pre_commit_fn) {
 		r = pmd->pre_commit_fn(pmd->pre_commit_context);
 		if (r < 0) {
@@ -976,6 +1020,7 @@ struct dm_pool_metadata *dm_pool_metadata_open(struct block_device *bdev,
 	pmd->data_block_size = data_block_size;
 	pmd->pre_commit_fn = NULL;
 	pmd->pre_commit_context = NULL;
+	pmd->data_sm_error = 0;
 
 	r = __create_persistent_data_objects(pmd, format_device);
 	if (r) {
@@ -1894,6 +1939,8 @@ int dm_pool_abort_metadata(struct dm_pool_metadata *pmd)
 	r = __open_or_format_metadata(pmd, false);
 	if (r)
 		pmd->fail_io = true;
+	else
+		pmd->data_sm_error = 0;
 	pmd_write_unlock(pmd);
 	return r;
 }
diff --git a/drivers/md/persistent-data/dm-transaction-manager.c b/drivers/md/persistent-data/dm-transaction-manager.c
index 7401add01d12..035b554289cb 100644
--- a/drivers/md/persistent-data/dm-transaction-manager.c
+++ b/drivers/md/persistent-data/dm-transaction-manager.c
@@ -99,6 +99,16 @@ struct dm_transaction_manager {
 	struct rb_root buckets[DM_HASH_SIZE];
 
 	struct prefetch_set prefetches;
+
+	/*
+	 * Sticky error flag for space-map operations (inc/dec) that
+	 * were silently swallowed by the void tm_inc/tm_dec wrappers.
+	 * A non-zero value indicates the transaction is inconsistent
+	 * and must not be committed.  Checked in tm_pre_commit() and
+	 * tm_commit(); cleared by dm_tm_clear_error() at the start of
+	 * each new transaction.
+	 */
+	int sm_error;
 };
 
 /*----------------------------------------------------------------*/
@@ -193,6 +203,7 @@ static struct dm_transaction_manager *dm_tm_create(struct dm_block_manager *bm,
 	tm->real = NULL;
 	tm->bm = bm;
 	tm->sm = sm;
+	tm->sm_error = 0;
 
 	spin_lock_init(&tm->lock);
 	for (i = 0; i < DM_HASH_SIZE; i++)
@@ -236,6 +247,12 @@ int dm_tm_pre_commit(struct dm_transaction_manager *tm)
 	if (tm->is_clone)
 		return -EWOULDBLOCK;
 
+	if (tm->sm_error) {
+		DMERR("aborting pre-commit due to earlier space-map error: %d",
+		      tm->sm_error);
+		return tm->sm_error;
+	}
+
 	r = dm_sm_commit(tm->sm);
 	if (r < 0)
 		return r;
@@ -249,6 +266,13 @@ int dm_tm_commit(struct dm_transaction_manager *tm, struct dm_block *root)
 	if (tm->is_clone)
 		return -EWOULDBLOCK;
 
+	if (tm->sm_error) {
+		DMERR("refusing commit due to earlier space-map error: %d",
+		      tm->sm_error);
+		dm_bm_unlock(root);
+		return tm->sm_error;
+	}
+
 	wipe_shadow_table(tm);
 	dm_bm_unlock(root);
 
@@ -375,45 +399,87 @@ EXPORT_SYMBOL_GPL(dm_tm_unlock);
 
 void dm_tm_inc(struct dm_transaction_manager *tm, dm_block_t b)
 {
+	int r;
+
 	/*
 	 * The non-blocking clone doesn't support this.
 	 */
 	BUG_ON(tm->is_clone);
 
-	dm_sm_inc_block(tm->sm, b);
+	r = dm_sm_inc_block(tm->sm, b);
+	if (r && !tm->sm_error) {
+		DMERR_LIMIT("dm_tm_inc failed for block %llu: error %d",
+			    (unsigned long long)b, r);
+		tm->sm_error = r;
+	}
 }
 EXPORT_SYMBOL_GPL(dm_tm_inc);
 
 void dm_tm_inc_range(struct dm_transaction_manager *tm, dm_block_t b, dm_block_t e)
 {
+	int r;
+
 	/*
 	 * The non-blocking clone doesn't support this.
 	 */
 	BUG_ON(tm->is_clone);
 
-	dm_sm_inc_blocks(tm->sm, b, e);
+	r = dm_sm_inc_blocks(tm->sm, b, e);
+	if (r && !tm->sm_error) {
+		DMERR_LIMIT("dm_tm_inc_range failed for blocks %llu..%llu: error %d",
+			    (unsigned long long)b, (unsigned long long)e, r);
+		tm->sm_error = r;
+	}
 }
 EXPORT_SYMBOL_GPL(dm_tm_inc_range);
 
 void dm_tm_dec(struct dm_transaction_manager *tm, dm_block_t b)
 {
+	int r;
+
 	/*
 	 * The non-blocking clone doesn't support this.
 	 */
 	BUG_ON(tm->is_clone);
 
-	dm_sm_dec_block(tm->sm, b);
+	r = dm_sm_dec_block(tm->sm, b);
+	if (r && !tm->sm_error) {
+		DMERR_LIMIT("dm_tm_dec failed for block %llu: error %d",
+			    (unsigned long long)b, r);
+		tm->sm_error = r;
+	}
 }
 EXPORT_SYMBOL_GPL(dm_tm_dec);
 
+/*
+ * Clear the sticky space-map error flag.  Called at the start of each
+ * new transaction (in __begin_transaction) so that a fresh transaction
+ * can proceed after the previous one was aborted.
+ */
+void dm_tm_clear_error(struct dm_transaction_manager *tm)
+{
+	if (tm->is_clone)
+		return;
+
+	tm->sm_error = 0;
+}
+EXPORT_SYMBOL_GPL(dm_tm_clear_error);
+
 void dm_tm_dec_range(struct dm_transaction_manager *tm, dm_block_t b, dm_block_t e)
 {
+	int r;
+
 	/*
 	 * The non-blocking clone doesn't support this.
 	 */
 	BUG_ON(tm->is_clone);
 
-	dm_sm_dec_blocks(tm->sm, b, e);
+	r = dm_sm_dec_blocks(tm->sm, b, e);
+	if (r && !tm->sm_error) {
+		DMERR_LIMIT("dm_tm_dec_range failed for blocks %llu..%llu: error %d",
+			    (unsigned long long)b, (unsigned long long)e, r);
+		tm->sm_error = r;
+	}
 }
 EXPORT_SYMBOL_GPL(dm_tm_dec_range);
 
diff --git a/drivers/md/persistent-data/dm-transaction-manager.h b/drivers/md/persistent-data/dm-transaction-manager.h
index 61a8d10825ca..f3c50c3f9964 100644
--- a/drivers/md/persistent-data/dm-transaction-manager.h
+++ b/drivers/md/persistent-data/dm-transaction-manager.h
@@ -105,6 +105,12 @@ void dm_tm_inc_range(struct dm_transaction_manager *tm, dm_block_t b, dm_block_t
 void dm_tm_dec(struct dm_transaction_manager *tm, dm_block_t b);
 void dm_tm_dec_range(struct dm_transaction_manager *tm, dm_block_t b, dm_block_t e);
 
+/*
+ * Clear the sticky space-map error flag.  Should be called at the start
+ * of each new transaction.
+ */
+void dm_tm_clear_error(struct dm_transaction_manager *tm);
+
 /*
  * Builds up runs of adjacent blocks, and then calls the given fn
  * (typically dm_tm_inc/dec).  Very useful when you have to perform
-- 
2.34.1


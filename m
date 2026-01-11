Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90D7B1A9F94;
	Sun, 11 Jan 2026 20:27:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768163260; cv=none; b=EHxw5MzD8Xv7hnMaJWTdTuoRIyoTH484GXAzqhURvrBMLD7EomN0t0yWPVEbpKFzhxAzP7m279m0X5DH+pE5lvl6OlHe1uu23kJqOOI3xn6gU4LhH3U8pgGvU6Lv1m1CSDKQBtIEAISb4SX4iWVnkeIvetm7+G7H9p+Np6QPtxo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768163260; c=relaxed/simple;
	bh=BrmmJDsrWWtdOkMkzY2ZboXCZw/NkrY4GGhPYTYQez4=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=bi0SZWKuvSrpUn1McnVEVezyy59EzWukM5jU7yn4EVAbakg4J0GuNZXQmI+q6H0y1m5n70/cX+sj3orzyauk5tcQKF3VaadY5soWAnf9/rjKXbm0QHPOVq+pF3DpgezvJTv9OoB+J08KlF7E1Xqj51mohOMoNwvW40ID+sPUiwY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hWFcBYlP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hWFcBYlP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF7B2C4CEF7;
	Sun, 11 Jan 2026 20:27:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768163260;
	bh=BrmmJDsrWWtdOkMkzY2ZboXCZw/NkrY4GGhPYTYQez4=;
	h=From:To:Cc:Subject:Date:From;
	b=hWFcBYlP/kXXZPbqhCK6T72OOgH56xaBw9QBTOrfPjdcUjtFjS3HKx8IAZZQD8Hm9
	 ZLfOAV5dE/PnThndv2vZEWofwR4s/l6pMvMfHNSBfUSdD1p4pxlY15K37zjXIGc+7k
	 zBkDESAYLYkQGMjO1/8htt9ZyH11PushIz/YHdwzzLLx+NwaLi3H4CkrZRzjUr3xcJ
	 l/so5pI2OwbhA3mUu6GwKE/t7Cd27F5kgvsJzNi7NMAt/cheTLi4iO9/RP0X6fb1Wj
	 6b1VCRlVC2EdrAHTRkEbfjE+qmTx9tdngelhUdqaid3F0Mba5bJpnFu4Dg9099lNKa
	 1AqNK7oRIC9Pw==
From: Eric Biggers <ebiggers@kernel.org>
To: dm-devel@lists.linux.dev,
	Alasdair Kergon <agk@redhat.com>,
	Mike Snitzer <snitzer@kernel.org>,
	Mikulas Patocka <mpatocka@redhat.com>,
	Benjamin Marzinski <bmarzins@redhat.com>
Cc: Sami Tolvanen <samitolvanen@google.com>,
	linux-kernel@vger.kernel.org,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH] dm-verity: fix up various workqueue-related comments
Date: Sun, 11 Jan 2026 12:26:42 -0800
Message-ID: <20260111202642.52850-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.52.0
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Replace obsolete mentions of "tasklets" with "softirq context", and
"workqueue" with "kworker".

This reflects the fact that the implementation of the
"try_verify_in_tasklet" dm-verity option now accesses softirq context
using either the BH workqueue API or inline execution, not the tasklet
API.  The old names conflated the API with the intended execution
context, so they became outdated when the APIs changed.

Signed-off-by: Eric Biggers <ebiggers@kernel.org>
---
 drivers/md/dm-verity-target.c | 20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

diff --git a/drivers/md/dm-verity-target.c b/drivers/md/dm-verity-target.c
index 777a0ebe8536..ff71313750f3 100644
--- a/drivers/md/dm-verity-target.c
+++ b/drivers/md/dm-verity-target.c
@@ -252,13 +252,13 @@ static int verity_verify_level(struct dm_verity *v, struct dm_verity_io *io,
 
 	if (static_branch_unlikely(&use_bh_wq_enabled) && io->in_bh) {
 		data = dm_bufio_get(v->bufio, hash_block, &buf);
 		if (IS_ERR_OR_NULL(data)) {
 			/*
-			 * In tasklet and the hash was not in the bufio cache.
-			 * Return early and resume execution from a work-queue
-			 * to read the hash from disk.
+			 * In softirq and the hash was not in the bufio cache.
+			 * Return early and resume execution from a kworker to
+			 * read the hash from disk.
 			 */
 			return -EAGAIN;
 		}
 	} else {
 		data = dm_bufio_read_with_ioprio(v->bufio, hash_block,
@@ -301,11 +301,11 @@ static int verity_verify_level(struct dm_verity *v, struct dm_verity_io *io,
 				  v->digest_size) == 0))
 			aux->hash_verified = 1;
 		else if (static_branch_unlikely(&use_bh_wq_enabled) && io->in_bh) {
 			/*
 			 * Error handling code (FEC included) cannot be run in a
-			 * tasklet since it may sleep, so fallback to work-queue.
+			 * softirq since it may sleep, so fallback to a kworker.
 			 */
 			r = -EAGAIN;
 			goto release_ret_r;
 		} else if (verity_fec_decode(v, io, DM_VERITY_BLOCK_TYPE_METADATA,
 					     want_digest, hash_block, data) == 0)
@@ -423,12 +423,12 @@ static int verity_handle_data_hash_mismatch(struct dm_verity *v,
 	sector_t blkno = block->blkno;
 	u8 *data = block->data;
 
 	if (static_branch_unlikely(&use_bh_wq_enabled) && io->in_bh) {
 		/*
-		 * Error handling code (FEC included) cannot be run in the
-		 * BH workqueue, so fallback to a standard workqueue.
+		 * Error handling code (FEC included) cannot be run in a
+		 * softirq since it may sleep, so fallback to a kworker.
 		 */
 		return -EAGAIN;
 	}
 	if (verity_recheck(v, io, want_digest, blkno, data) == 0) {
 		if (v->validated_blocks)
@@ -517,12 +517,12 @@ static int verity_verify_io(struct dm_verity_io *io)
 
 	io->num_pending = 0;
 
 	if (static_branch_unlikely(&use_bh_wq_enabled) && io->in_bh) {
 		/*
-		 * Copy the iterator in case we need to restart
-		 * verification in a work-queue.
+		 * Copy the iterator in case we need to restart verification in
+		 * a kworker.
 		 */
 		iter_copy = io->iter;
 		iter = &iter_copy;
 	} else
 		iter = &io->iter;
@@ -655,11 +655,11 @@ static void verity_bh_work(struct work_struct *w)
 	int err;
 
 	io->in_bh = true;
 	err = verity_verify_io(io);
 	if (err == -EAGAIN || err == -ENOMEM) {
-		/* fallback to retrying with work-queue */
+		/* fallback to retrying in a kworker */
 		INIT_WORK(&io->work, verity_work);
 		queue_work(io->v->verify_wq, &io->work);
 		return;
 	}
 
@@ -1642,11 +1642,11 @@ static int verity_ctr(struct dm_target *ti, unsigned int argc, char **argv)
 	/*
 	 * Using WQ_HIGHPRI improves throughput and completion latency by
 	 * reducing wait times when reading from a dm-verity device.
 	 *
 	 * Also as required for the "try_verify_in_tasklet" feature: WQ_HIGHPRI
-	 * allows verify_wq to preempt softirq since verification in BH workqueue
+	 * allows verify_wq to preempt softirq since verification in softirq
 	 * will fall-back to using it for error handling (or if the bufio cache
 	 * doesn't have required hashes).
 	 */
 	v->verify_wq = alloc_workqueue("kverityd", WQ_MEM_RECLAIM | WQ_HIGHPRI, 0);
 	if (!v->verify_wq) {

base-commit: 8fbb8fe75d4cf92eaa7b21828ec39c1bf79a262f
-- 
2.52.0


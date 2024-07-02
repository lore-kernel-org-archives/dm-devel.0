Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B3325C5F3;
	Tue,  2 Jul 2024 06:49:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719902984; cv=none; b=Rb317KDB2+4Zr0L2b7UEDGa2OoVIXjQFubaFlENSbdDcpKeO6iNZQ2iANv/Y2ob7d4t5gEs7SSYThjGsfXKAw88NJGbrPZ6yWCtTVneofV3SGSJnJ4qh+YJT1Ji04RMye6bgxoZg3+8C3/atbJql4vYuzAFaeyIkldkwQRh6tMc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719902984; c=relaxed/simple;
	bh=KKuxmjZHgDTU3MsqwzhYo+9QcXkXm3thNcp3gDEyqPY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HiEreskQkwwMtQTOaig7CGti8SMZn9mKKwdVk6xfJwvMMeBt0kt2iEX9acp4THJEB4n7ZG9TqG3t2SyRAsU3HM2DvGLEnpNbBNJhnM+aRLv1lckowjl5Oo16vjMoC7J3kNX88vs5BfxUzLvDlS1wgmR7vwSfm43p0Mmo2CVM+gU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=XEak9hS+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="XEak9hS+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 683BBC4AF0C;
	Tue,  2 Jul 2024 06:49:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1719902983;
	bh=KKuxmjZHgDTU3MsqwzhYo+9QcXkXm3thNcp3gDEyqPY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XEak9hS+dN/i6UGO79PpQKI03L6asG1tBnZ7Zx+jEld1X0K5RxNseHVY7tmOsDmRj
	 p6RShQo3V+7uM6bzyejIMS7UimrA4AgsnuQcw52aooTwrqKuVMwUaOY5XU2313AzAa
	 EcfdyVrhuLH7qz0zUidBV4qsG+aFc19IlJScWN/vDsYC7yzIuB714vHLjsHgFikEun
	 EjjMYmRo/+yQ2SKhQGhKdfdgFPAtDYcZLHPacWidEC8DjY2fv4b8Km1odZG/mO+Ouj
	 iLgVAOhTjafcu6Te7y8tJTlqkP1VRLUnSfJlI6EwbqNXTuVfw8/Zojk0y90Eadbf64
	 ZKVYg4NPrMb5w==
From: Eric Biggers <ebiggers@kernel.org>
To: dm-devel@lists.linux.dev,
	Alasdair Kergon <agk@redhat.com>,
	Mike Snitzer <snitzer@kernel.org>,
	Mikulas Patocka <mpatocka@redhat.com>
Cc: linux-kernel@vger.kernel.org,
	Ard Biesheuvel <ardb@kernel.org>,
	Sami Tolvanen <samitolvanen@google.com>,
	Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH 2/7] dm-verity: move data hash mismatch handling into its own function
Date: Mon,  1 Jul 2024 23:48:30 -0700
Message-ID: <20240702064835.120541-3-ebiggers@kernel.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240702064835.120541-1-ebiggers@kernel.org>
References: <20240702064835.120541-1-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Eric Biggers <ebiggers@google.com>

Move the code that handles mismatches of data block hashes into its own
function so that it doesn't clutter up verity_verify_io().

Reviewed-by: Sami Tolvanen <samitolvanen@google.com>
Acked-by: Ard Biesheuvel <ardb@kernel.org>
Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 drivers/md/dm-verity-target.c | 64 ++++++++++++++++++++---------------
 1 file changed, 36 insertions(+), 28 deletions(-)

diff --git a/drivers/md/dm-verity-target.c b/drivers/md/dm-verity-target.c
index 88d2a49dca43..796d85526696 100644
--- a/drivers/md/dm-verity-target.c
+++ b/drivers/md/dm-verity-target.c
@@ -540,10 +540,42 @@ static noinline int verity_recheck(struct dm_verity *v, struct dm_verity_io *io,
 	mempool_free(page, &v->recheck_pool);
 
 	return r;
 }
 
+static int verity_handle_data_hash_mismatch(struct dm_verity *v,
+					    struct dm_verity_io *io,
+					    struct bio *bio, sector_t blkno,
+					    struct bvec_iter *start)
+{
+	if (static_branch_unlikely(&use_bh_wq_enabled) && io->in_bh) {
+		/*
+		 * Error handling code (FEC included) cannot be run in the
+		 * BH workqueue, so fallback to a standard workqueue.
+		 */
+		return -EAGAIN;
+	}
+	if (verity_recheck(v, io, *start, blkno) == 0) {
+		if (v->validated_blocks)
+			set_bit(blkno, v->validated_blocks);
+		return 0;
+	}
+#if defined(CONFIG_DM_VERITY_FEC)
+	if (verity_fec_decode(v, io, DM_VERITY_BLOCK_TYPE_DATA, blkno,
+			      NULL, start) == 0)
+		return 0;
+#endif
+	if (bio->bi_status)
+		return -EIO; /* Error correction failed; Just return error */
+
+	if (verity_handle_err(v, DM_VERITY_BLOCK_TYPE_DATA, blkno)) {
+		dm_audit_log_bio(DM_MSG_PREFIX, "verify-data", bio, blkno, 0);
+		return -EIO;
+	}
+	return 0;
+}
+
 static int verity_bv_zero(struct dm_verity *v, struct dm_verity_io *io,
 			  u8 *data, size_t len)
 {
 	memset(data, 0, len);
 	return 0;
@@ -632,39 +664,15 @@ static int verity_verify_io(struct dm_verity_io *io)
 		if (likely(memcmp(verity_io_real_digest(v, io),
 				  verity_io_want_digest(v, io), v->digest_size) == 0)) {
 			if (v->validated_blocks)
 				set_bit(cur_block, v->validated_blocks);
 			continue;
-		} else if (static_branch_unlikely(&use_bh_wq_enabled) && io->in_bh) {
-			/*
-			 * Error handling code (FEC included) cannot be run in a
-			 * tasklet since it may sleep, so fallback to work-queue.
-			 */
-			return -EAGAIN;
-		} else if (verity_recheck(v, io, start, cur_block) == 0) {
-			if (v->validated_blocks)
-				set_bit(cur_block, v->validated_blocks);
-			continue;
-#if defined(CONFIG_DM_VERITY_FEC)
-		} else if (verity_fec_decode(v, io, DM_VERITY_BLOCK_TYPE_DATA,
-					     cur_block, NULL, &start) == 0) {
-			continue;
-#endif
-		} else {
-			if (bio->bi_status) {
-				/*
-				 * Error correction failed; Just return error
-				 */
-				return -EIO;
-			}
-			if (verity_handle_err(v, DM_VERITY_BLOCK_TYPE_DATA,
-					      cur_block)) {
-				dm_audit_log_bio(DM_MSG_PREFIX, "verify-data",
-						 bio, cur_block, 0);
-				return -EIO;
-			}
 		}
+		r = verity_handle_data_hash_mismatch(v, io, bio, cur_block,
+						     &start);
+		if (unlikely(r))
+			return r;
 	}
 
 	return 0;
 }
 
-- 
2.45.2


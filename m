Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17C3034166B;
	Fri,  6 Feb 2026 05:02:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770354121; cv=none; b=AF7XO/5uSfwkhrUhgQabTljCbZxi46qIPzfmRN5L5QgSwoUJLqW+1a+i0i4pPlHDinJP/F7ce/tRfQ0ZZpg5jkokncLFdL1fJbuKnOpo860o0P2BrstT2Resnf/Xc/m3JVgqLcgtx1Kly7kah8QHoJNPUyTw1rISt1TLDNIo13k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770354121; c=relaxed/simple;
	bh=kQGaA79ZZ0qnBy8uSBPsiJSgf6TH8GUt3oPgCulvrtk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nae1gbzMV+CwAwtZ/z55z2v4vMZlRb1GNXbxGlU3XSDg8YdpFK5C1Cn30W+j5ssEmvh1SgEG/dH221jz7PdlqO/Yx97gkg9WrfB2FeE4xA+VlMRqAyTdrqMKXRQKc4hD9fv92t5t1sss90G/uxgMtWylDxU7g5cZWTbGNYIfPhY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=EpFIws9v; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="EpFIws9v"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B17ACC2BC86;
	Fri,  6 Feb 2026 05:02:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770354121;
	bh=kQGaA79ZZ0qnBy8uSBPsiJSgf6TH8GUt3oPgCulvrtk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EpFIws9v8bFGgta8dpR03g5iyKk1ox0oj/EI+pCXpSdhbzxoDsRcBpvu3+mDeAe5m
	 1ob0a+ISfB7nlQkijBnXPAZLLKSbvl6Y4y02YfudxH68Ue8Ka0W0ErwZr0PVdwX9Yj
	 9UoQQfwNOlt9sWcTAIJcNsQNzeJHk2drpPH6rEwUMuVMMOvNdWcHb+oh8NLHXe4fxh
	 mwRPGakvHX/CMQZhNwmmx6tk/tae+/mzw4pxuXkcgq4vJmzPyhhVfikE07JfwkkDxs
	 smJdQZ/sQ1emlJPH4k0RX8YDp09FME0H0pXcYj9fB2ka7o0FpFv65MvO3LEJgzev9z
	 Q9jC3ljiv9Vpg==
From: Eric Biggers <ebiggers@kernel.org>
To: dm-devel@lists.linux.dev,
	Alasdair Kergon <agk@redhat.com>,
	Mike Snitzer <snitzer@kernel.org>,
	Mikulas Patocka <mpatocka@redhat.com>,
	Benjamin Marzinski <bmarzins@redhat.com>
Cc: Sami Tolvanen <samitolvanen@google.com>,
	linux-kernel@vger.kernel.org,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH 17/22] dm-verity-fec: move computation of offset and rsb down a level
Date: Thu,  5 Feb 2026 20:59:36 -0800
Message-ID: <20260206045942.52965-18-ebiggers@kernel.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260206045942.52965-1-ebiggers@kernel.org>
References: <20260206045942.52965-1-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

verity_fec_decode() computes (offset, rsb) from the target block index
and calls fec_decode_rsb() with these parameters.  Move this computation
into fec_decode_rsb(), and rename fec_decode_rsb() to fec_decode().

This ends up being simpler and enables further refactoring, specifically
making use of the quotient from the division more easily.  The function
renaming also eliminates a reference to the ambiguous term "rsb".

This change does mean the same div64_u64_rem() can now be executed twice
per block, since verity_fec_decode() calls fec_decode() up to twice per
block.  However, this cost is negligible compared to the rest of FEC.

Signed-off-by: Eric Biggers <ebiggers@kernel.org>
---
 drivers/md/dm-verity-fec.c | 46 +++++++++++++++-----------------------
 1 file changed, 18 insertions(+), 28 deletions(-)

diff --git a/drivers/md/dm-verity-fec.c b/drivers/md/dm-verity-fec.c
index 51263f2be1350..91670f7d0ea16 100644
--- a/drivers/md/dm-verity-fec.c
+++ b/drivers/md/dm-verity-fec.c
@@ -304,20 +304,30 @@ static void fec_init_bufs(struct dm_verity *v, struct dm_verity_fec_io *fio)
 
 	memset(fio->erasures, 0, sizeof(fio->erasures));
 }
 
 /*
- * Decode all RS blocks in a single data block and return the target block
- * (indicated by @offset) in fio->output. If @use_erasures is non-zero, uses
- * hashes to locate erasures.
+ * Try to correct the message (data or hash) block at index @target_block.
+ *
+ * If @use_erasures is true, use verity hashes to locate erasures.  This makes
+ * the error correction slower but up to twice as capable.
+ *
+ * On success, return 0 and write the corrected block to @fio->output.  0 is
+ * returned only if the digest of the corrected block matches @want_digest; this
+ * is critical to ensure that FEC can't cause dm-verity to return bad data.
  */
-static int fec_decode_rsb(struct dm_verity *v, struct dm_verity_io *io,
-			  struct dm_verity_fec_io *fio, u64 rsb, u64 offset,
-			  const u8 *want_digest, bool use_erasures)
+static int fec_decode(struct dm_verity *v, struct dm_verity_io *io,
+		      struct dm_verity_fec_io *fio, u64 target_block,
+		      const u8 *want_digest, bool use_erasures)
 {
 	int r, neras = 0;
 	unsigned int out_pos;
+	u64 offset = target_block << v->data_dev_block_bits;
+	u64 rsb;
+
+	div64_u64_rem(offset, v->fec->region_blocks << v->data_dev_block_bits,
+		      &rsb);
 
 	for (out_pos = 0; out_pos < v->fec->block_size;) {
 		fec_init_bufs(v, fio);
 
 		r = fec_read_bufs(v, io, rsb, offset, out_pos,
@@ -351,11 +361,10 @@ int verity_fec_decode(struct dm_verity *v, struct dm_verity_io *io,
 		      enum verity_block_type type, const u8 *want_digest,
 		      sector_t block, u8 *dest)
 {
 	int r;
 	struct dm_verity_fec_io *fio;
-	u64 offset, rsb;
 
 	if (!verity_fec_is_enabled(v))
 		return -EOPNOTSUPP;
 
 	fio = io->fec_io;
@@ -368,37 +377,18 @@ int verity_fec_decode(struct dm_verity *v, struct dm_verity_io *io,
 	fio->level++;
 
 	if (type == DM_VERITY_BLOCK_TYPE_METADATA)
 		block = block - v->hash_start + v->data_blocks;
 
-	/*
-	 * For RS(n, k), the continuous FEC data is divided into blocks of k
-	 * bytes. Since block size may not be divisible by k, the last block
-	 * is zero padded when decoding.
-	 *
-	 * Each byte of the block is covered by a different RS(n, k) code,
-	 * and each code is interleaved over k blocks to make it less likely
-	 * that bursty corruption will leave us in unrecoverable state.
-	 */
-
-	offset = block << v->data_dev_block_bits;
-
-	/*
-	 * The base RS block we can feed to the interleaver to find out all
-	 * blocks required for decoding.
-	 */
-	div64_u64_rem(offset, v->fec->region_blocks << v->data_dev_block_bits,
-		      &rsb);
-
 	/*
 	 * Locating erasures is slow, so attempt to recover the block without
 	 * them first. Do a second attempt with erasures if the corruption is
 	 * bad enough.
 	 */
-	r = fec_decode_rsb(v, io, fio, rsb, offset, want_digest, false);
+	r = fec_decode(v, io, fio, block, want_digest, false);
 	if (r < 0) {
-		r = fec_decode_rsb(v, io, fio, rsb, offset, want_digest, true);
+		r = fec_decode(v, io, fio, block, want_digest, true);
 		if (r < 0)
 			goto done;
 	}
 
 	memcpy(dest, fio->output, v->fec->block_size);
-- 
2.52.0


Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AAE11340DA3;
	Fri,  6 Feb 2026 05:02:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770354120; cv=none; b=i8t3C6HZwweDeik2ks4tMHvxWHiEI1i0e94r04XjswYYU1krpZYTSudHEK7ZWWznSKZ3sCBJXuxfp7jLGR5/stJHhmHoO//Hz4MTNWoI6wA5nsxzfJ0JHcGi/nBKMZxieg4/Jqe5D/770d5hPUVO5zUowtO0Qe5PEqH5uW4AjCI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770354120; c=relaxed/simple;
	bh=7YFdj7HGxucUA+eICYH6sRcb993Ixkn68/c5y+lugeU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iq1Bqv0/iPbPuaattwOS6h9wf4MoUpHLWcLtnVU/cRjgSXf/D5eTcJNjGKHW9hOnrRlCbesbnFcp8LLA0puKSSXCpfYC6y9jhJgWyXJe6E63wJ9dee3oJEo8txHDKynMvY6I7ijwqMbljkzR/yWVgxUdeq94MbrZRYNJVrt21x4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=BLrWF0l7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="BLrWF0l7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 511D9C19424;
	Fri,  6 Feb 2026 05:02:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770354120;
	bh=7YFdj7HGxucUA+eICYH6sRcb993Ixkn68/c5y+lugeU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BLrWF0l7rLW5FQ4SQ9witABWfIwFLDN1v/tLphMawII2hy3AZ7O/iDDCcAV9SkGdn
	 bA7pcZ/BIRwRWAPf50Nnx9mkYEyt35FRrfsJA9MmTU8f1yXzT+N81HabOmMSHh4XY6
	 /z/fKviVp32vUWYtP96EZFzWuXJPxyIk0mp7XWI4l4L7uAhJ3U1ubD9y2nI3JOpQ1E
	 coVAjFLFzTMyWUml/wRcl+ghcJfZNMCYr5oh75u6HjIOvGocGM5EOYZUxxgBIifou3
	 RYUfBam31BstTSYuZ1dfgrj0FaIXOJxAMJmwLstqRsDt3SxczzI2Wot3ez2HDlxEus
	 6Ppyo8LeAdpiA==
From: Eric Biggers <ebiggers@kernel.org>
To: dm-devel@lists.linux.dev,
	Alasdair Kergon <agk@redhat.com>,
	Mike Snitzer <snitzer@kernel.org>,
	Mikulas Patocka <mpatocka@redhat.com>,
	Benjamin Marzinski <bmarzins@redhat.com>
Cc: Sami Tolvanen <samitolvanen@google.com>,
	linux-kernel@vger.kernel.org,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH 16/22] dm-verity-fec: rename block_offset to out_pos
Date: Thu,  5 Feb 2026 20:59:35 -0800
Message-ID: <20260206045942.52965-17-ebiggers@kernel.org>
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

The current position in the output block buffer is called 'pos' in
fec_decode_rsb(), and 'block_offset' in fec_read_bufs() and
fec_decode_bufs().  These names aren't very clear, especially
'block_offset' which is easily confused with the offset of a message or
parity block or the position in the current parity block.

Rename it to 'out_pos'.

Signed-off-by: Eric Biggers <ebiggers@kernel.org>
---
 drivers/md/dm-verity-fec.c | 28 +++++++++++++---------------
 1 file changed, 13 insertions(+), 15 deletions(-)

diff --git a/drivers/md/dm-verity-fec.c b/drivers/md/dm-verity-fec.c
index a49c43ca07763..51263f2be1350 100644
--- a/drivers/md/dm-verity-fec.c
+++ b/drivers/md/dm-verity-fec.c
@@ -44,15 +44,15 @@ static inline u8 *fec_buffer_rs_message(struct dm_verity *v,
 	return &fio->bufs[i][j * v->fec->rs_k];
 }
 
 /*
  * Decode all RS codewords whose message bytes were loaded into fio->bufs.  Copy
- * the corrected bytes into fio->output starting from block_offset.
+ * the corrected bytes into fio->output starting from out_pos.
  */
 static int fec_decode_bufs(struct dm_verity *v, struct dm_verity_io *io,
 			   struct dm_verity_fec_io *fio, u64 rsb, int byte_index,
-			   unsigned int block_offset, int neras)
+			   unsigned int out_pos, int neras)
 {
 	int r, corrected = 0, res;
 	struct dm_buffer *buf;
 	unsigned int n, i, j, parity_pos, to_copy;
 	uint16_t par_buf[DM_VERITY_FEC_MAX_ROOTS];
@@ -65,11 +65,11 @@ static int fec_decode_bufs(struct dm_verity *v, struct dm_verity_io *io,
 	 * the starting position in that block.  Then read that block.
 	 *
 	 * block_size is always a power of 2, but roots might not be.  Note that
 	 * when it's not, a codeword's parity bytes can span a block boundary.
 	 */
-	parity_block = (rsb + block_offset) * v->fec->roots;
+	parity_block = (rsb + out_pos) * v->fec->roots;
 	parity_pos = parity_block & (v->fec->block_size - 1);
 	parity_block >>= v->data_dev_block_bits;
 	par = dm_bufio_read_with_ioprio(v->fec->bufio, parity_block, &buf,
 					bio->bi_ioprio);
 	if (IS_ERR(par)) {
@@ -118,14 +118,13 @@ static int fec_decode_bufs(struct dm_verity *v, struct dm_verity_io *io,
 			r = res;
 			goto error;
 		}
 
 		corrected += res;
-		fio->output[block_offset] = msg_buf[byte_index];
+		fio->output[out_pos++] = msg_buf[byte_index];
 
-		block_offset++;
-		if (block_offset >= v->fec->block_size)
+		if (out_pos >= v->fec->block_size)
 			goto done;
 	}
 done:
 	r = corrected;
 error:
@@ -157,12 +156,11 @@ static int fec_is_erasure(struct dm_verity *v, struct dm_verity_io *io,
 /*
  * Read data blocks that are part of the RS block and deinterleave as much as
  * fits into buffers. Check for erasure locations if @neras is non-NULL.
  */
 static int fec_read_bufs(struct dm_verity *v, struct dm_verity_io *io,
-			 u64 rsb, u64 target, unsigned int block_offset,
-			 int *neras)
+			 u64 rsb, u64 target, unsigned int out_pos, int *neras)
 {
 	bool is_zero;
 	int i, j, target_index = -1;
 	struct dm_buffer *buf;
 	struct dm_bufio_client *bufio;
@@ -241,13 +239,13 @@ static int fec_read_bufs(struct dm_verity *v, struct dm_verity_io *io,
 				fio->erasures[(*neras)++] = i;
 		}
 
 		/*
 		 * deinterleave and copy the bytes that fit into bufs,
-		 * starting from block_offset
+		 * starting from out_pos
 		 */
-		src_pos = block_offset;
+		src_pos = out_pos;
 		fec_for_each_buffer_rs_message(fio, n, j) {
 			if (src_pos >= v->fec->block_size)
 				goto done;
 			fec_buffer_rs_message(v, fio, n, j)[i] = bbuf[src_pos++];
 		}
@@ -315,25 +313,25 @@ static void fec_init_bufs(struct dm_verity *v, struct dm_verity_fec_io *fio)
 static int fec_decode_rsb(struct dm_verity *v, struct dm_verity_io *io,
 			  struct dm_verity_fec_io *fio, u64 rsb, u64 offset,
 			  const u8 *want_digest, bool use_erasures)
 {
 	int r, neras = 0;
-	unsigned int pos;
+	unsigned int out_pos;
 
-	for (pos = 0; pos < v->fec->block_size;) {
+	for (out_pos = 0; out_pos < v->fec->block_size;) {
 		fec_init_bufs(v, fio);
 
-		r = fec_read_bufs(v, io, rsb, offset, pos,
+		r = fec_read_bufs(v, io, rsb, offset, out_pos,
 				  use_erasures ? &neras : NULL);
 		if (unlikely(r < 0))
 			return r;
 
-		r = fec_decode_bufs(v, io, fio, rsb, r, pos, neras);
+		r = fec_decode_bufs(v, io, fio, rsb, r, out_pos, neras);
 		if (r < 0)
 			return r;
 
-		pos += fio->nbufs << DM_VERITY_FEC_BUF_RS_BITS;
+		out_pos += fio->nbufs << DM_VERITY_FEC_BUF_RS_BITS;
 	}
 
 	/* Always re-validate the corrected block against the expected hash */
 	r = verity_hash(v, io, fio->output, v->fec->block_size, io->tmp_digest);
 	if (unlikely(r < 0))
-- 
2.52.0


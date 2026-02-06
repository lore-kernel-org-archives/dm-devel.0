Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9E3C34252C;
	Fri,  6 Feb 2026 05:02:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770354121; cv=none; b=QFpzwJV5bzs/CQ94ea56LEfPAQGa4isy58rcKYOO/0X8yzAhLY8LQ8ljYhxe068tTRIMvZygpwsEoTaJE8I+/aeEK9rv4/Bzh+/aQpUNonnDANhUIkuRLSl9AHennB5kOjl52ZWTMv1d4tolUL4f/uiZftg5/1shPn9d2SiY+vA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770354121; c=relaxed/simple;
	bh=JaFArVCeKak5JqJx5bGIqX4e+QcFezwCPEZlB/x+PKY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=K+pWYcJwg7RkBOyqATzIJ85DG4RWja78+BloBlOeOifbDiNbnrce+nP6PNL2QqyN7ZT2PPJF1og+WUN92UKXAdlCcUwNr+UzEmvg9pPGXQdapy58ZTqOw8zjgqUrZO28QMmib9LBSWz//dgS2mJhuok93qPEcEavurYud7s/uCw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=oL/5vUxK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="oL/5vUxK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F58FC4AF0B;
	Fri,  6 Feb 2026 05:02:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770354121;
	bh=JaFArVCeKak5JqJx5bGIqX4e+QcFezwCPEZlB/x+PKY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oL/5vUxKyzfSqqFKddcNTDZT3ArfVJcsOg+xzQ5gF+WJctSlAFTb/rmajQXDKC+OT
	 1RLHYtpyN3xyhzESRChturCmySQDsDCmkgRqm2s4POz168DrP74PH+RxyJKLcTqYB9
	 vq304NUTQIeCC5MH6068dLvlyJabtKaWg7ktD2CnKl8B8kA2+/smvP4vwKd4vjcMyA
	 IZFIVBwMRuzrQYJD8dr4dgx18iBiO7Q2DrASY/Q6Dl75GNPdoziXGQ9OQ98JazwxVx
	 9qUL3HWNaJPI7+cwBtrufaWCUc7LCEHdSYH/4y3ccxsnnewnNLXUH/TlpJasfwH/Ys
	 +QVY2OMZ0Gg3w==
From: Eric Biggers <ebiggers@kernel.org>
To: dm-devel@lists.linux.dev,
	Alasdair Kergon <agk@redhat.com>,
	Mike Snitzer <snitzer@kernel.org>,
	Mikulas Patocka <mpatocka@redhat.com>,
	Benjamin Marzinski <bmarzins@redhat.com>
Cc: Sami Tolvanen <samitolvanen@google.com>,
	linux-kernel@vger.kernel.org,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH 19/22] dm-verity-fec: pass down index_in_region instead of rsb
Date: Thu,  5 Feb 2026 20:59:38 -0800
Message-ID: <20260206045942.52965-20-ebiggers@kernel.org>
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

Replace 'rsb', which is a byte index, with 'index_in_region' which is a
block index.  The block index is slightly easier to compute, it matches
what fec_read_bufs() wants, and it avoids the mismatch between the name
and the units of the variable.  ('rsb' stood for "Reed-Solomon block",
but its units were bytes, not blocks.)

fec_decode_bufs() does want it as a byte index when computing
parity_block, but that's easily handled locally.

As long as the parameters to the log messages are being adjusted, also
eliminate the unnecessary casts to 'unsigned long long'.  %llu is the
correct way to print a u64 in the Linux kernel, as documented in
printk-formats.rst.  There's no PRIu64 macro like there is in userspace.

Signed-off-by: Eric Biggers <ebiggers@kernel.org>
---
 drivers/md/dm-verity-fec.c | 47 +++++++++++++++++++++-----------------
 1 file changed, 26 insertions(+), 21 deletions(-)

diff --git a/drivers/md/dm-verity-fec.c b/drivers/md/dm-verity-fec.c
index 1b5052ba4f5a5..37c4eb6a11dee 100644
--- a/drivers/md/dm-verity-fec.c
+++ b/drivers/md/dm-verity-fec.c
@@ -47,11 +47,11 @@ static inline u8 *fec_buffer_rs_message(struct dm_verity *v,
 /*
  * Decode all RS codewords whose message bytes were loaded into fio->bufs.  Copy
  * the corrected bytes into fio->output starting from out_pos.
  */
 static int fec_decode_bufs(struct dm_verity *v, struct dm_verity_io *io,
-			   struct dm_verity_fec_io *fio, u64 rsb,
+			   struct dm_verity_fec_io *fio, u64 index_in_region,
 			   int target_region, unsigned int out_pos, int neras)
 {
 	int r, corrected = 0, res;
 	struct dm_buffer *buf;
 	unsigned int n, i, j, parity_pos, to_copy;
@@ -65,18 +65,20 @@ static int fec_decode_bufs(struct dm_verity *v, struct dm_verity_io *io,
 	 * the starting position in that block.  Then read that block.
 	 *
 	 * block_size is always a power of 2, but roots might not be.  Note that
 	 * when it's not, a codeword's parity bytes can span a block boundary.
 	 */
-	parity_block = (rsb + out_pos) * v->fec->roots;
+	parity_block = ((index_in_region << v->data_dev_block_bits) + out_pos) *
+		       v->fec->roots;
 	parity_pos = parity_block & (v->fec->block_size - 1);
 	parity_block >>= v->data_dev_block_bits;
 	par = dm_bufio_read_with_ioprio(v->fec->bufio, parity_block, &buf,
 					bio->bi_ioprio);
 	if (IS_ERR(par)) {
 		DMERR("%s: FEC %llu: parity read failed (block %llu): %ld",
-		      v->data_dev->name, rsb, parity_block, PTR_ERR(par));
+		      v->data_dev->name, index_in_region, parity_block,
+		      PTR_ERR(par));
 		return PTR_ERR(par);
 	}
 
 	/*
 	 * Decode the RS codewords whose message bytes are in bufs. Each RS
@@ -101,12 +103,12 @@ static int fec_decode_bufs(struct dm_verity *v, struct dm_verity_io *io,
 			par = dm_bufio_read_with_ioprio(v->fec->bufio,
 							parity_block, &buf,
 							bio->bi_ioprio);
 			if (IS_ERR(par)) {
 				DMERR("%s: FEC %llu: parity read failed (block %llu): %ld",
-				      v->data_dev->name, rsb, parity_block,
-				      PTR_ERR(par));
+				      v->data_dev->name, index_in_region,
+				      parity_block, PTR_ERR(par));
 				return PTR_ERR(par);
 			}
 			for (; j < v->fec->roots; j++)
 				par_buf[j] = par[parity_pos++];
 		}
@@ -130,14 +132,14 @@ static int fec_decode_bufs(struct dm_verity *v, struct dm_verity_io *io,
 error:
 	dm_bufio_release(buf);
 
 	if (r < 0 && neras)
 		DMERR_LIMIT("%s: FEC %llu: failed to correct: %d",
-			    v->data_dev->name, (unsigned long long)rsb, r);
+			    v->data_dev->name, index_in_region, r);
 	else if (r > 0)
 		DMWARN_LIMIT("%s: FEC %llu: corrected %d errors",
-			     v->data_dev->name, (unsigned long long)rsb, r);
+			     v->data_dev->name, index_in_region, r);
 
 	return r;
 }
 
 /*
@@ -156,18 +158,18 @@ static int fec_is_erasure(struct dm_verity *v, struct dm_verity_io *io,
 /*
  * Read data blocks that are part of the RS block and deinterleave as much as
  * fits into buffers. Check for erasure locations if @neras is non-NULL.
  */
 static int fec_read_bufs(struct dm_verity *v, struct dm_verity_io *io,
-			 u64 rsb, unsigned int out_pos, int *neras)
+			 u64 index_in_region, unsigned int out_pos, int *neras)
 {
 	bool is_zero;
 	int i, j;
 	struct dm_buffer *buf;
 	struct dm_bufio_client *bufio;
 	struct dm_verity_fec_io *fio = io->fec_io;
-	u64 block, ileaved;
+	u64 block;
 	u8 *bbuf;
 	u8 want_digest[HASH_MAX_DIGESTSIZE];
 	unsigned int n, src_pos;
 	struct bio *bio = dm_bio_from_per_bio_data(io, v->ti->per_io_data_size);
 
@@ -180,12 +182,11 @@ static int fec_read_bufs(struct dm_verity *v, struct dm_verity_io *io,
 	/*
 	 * read each of the rs_k data blocks that are part of the RS block, and
 	 * interleave contents to available bufs
 	 */
 	for (i = 0; i < v->fec->rs_k; i++) {
-		ileaved = rsb + i * (v->fec->region_blocks << v->data_dev_block_bits);
-		block = ileaved >> v->data_dev_block_bits;
+		block = i * v->fec->region_blocks + index_in_region;
 		bufio = v->fec->data_bufio;
 
 		if (block >= v->data_blocks) {
 			block -= v->data_blocks;
 
@@ -201,13 +202,12 @@ static int fec_read_bufs(struct dm_verity *v, struct dm_verity_io *io,
 		}
 
 		bbuf = dm_bufio_read_with_ioprio(bufio, block, &buf, bio->bi_ioprio);
 		if (IS_ERR(bbuf)) {
 			DMWARN_LIMIT("%s: FEC %llu: read failed (%llu): %ld",
-				     v->data_dev->name,
-				     (unsigned long long)rsb,
-				     (unsigned long long)block, PTR_ERR(bbuf));
+				     v->data_dev->name, index_in_region, block,
+				     PTR_ERR(bbuf));
 
 			/* assume the block is corrupted */
 			if (neras && *neras <= v->fec->roots)
 				fio->erasures[(*neras)++] = i;
 
@@ -310,28 +310,33 @@ static int fec_decode(struct dm_verity *v, struct dm_verity_io *io,
 		      struct dm_verity_fec_io *fio, u64 target_block,
 		      const u8 *want_digest, bool use_erasures)
 {
 	int r, neras = 0;
 	unsigned int target_region, out_pos;
-	u64 rsb;
+	u64 index_in_region;
 
-	target_region = div64_u64_rem(
-		target_block << v->data_dev_block_bits,
-		v->fec->region_blocks << v->data_dev_block_bits, &rsb);
+	/*
+	 * Compute 'target_region', the index of the region the target block is
+	 * in; and 'index_in_region', the index of the target block within its
+	 * region.  The latter value is also the index within its region of each
+	 * message block that shares its RS codewords with the target block.
+	 */
+	target_region = div64_u64_rem(target_block, v->fec->region_blocks,
+				      &index_in_region);
 	if (WARN_ON_ONCE(target_region >= v->fec->rs_k))
 		/* target_block is out-of-bounds.  Should never happen. */
 		return -EIO;
 
 	for (out_pos = 0; out_pos < v->fec->block_size;) {
 		fec_init_bufs(v, fio);
 
-		r = fec_read_bufs(v, io, rsb, out_pos,
+		r = fec_read_bufs(v, io, index_in_region, out_pos,
 				  use_erasures ? &neras : NULL);
 		if (unlikely(r < 0))
 			return r;
 
-		r = fec_decode_bufs(v, io, fio, rsb, target_region,
+		r = fec_decode_bufs(v, io, fio, index_in_region, target_region,
 				    out_pos, neras);
 		if (r < 0)
 			return r;
 
 		out_pos += fio->nbufs << DM_VERITY_FEC_BUF_RS_BITS;
@@ -342,11 +347,11 @@ static int fec_decode(struct dm_verity *v, struct dm_verity_io *io,
 	if (unlikely(r < 0))
 		return r;
 
 	if (memcmp(io->tmp_digest, want_digest, v->digest_size)) {
 		DMERR_LIMIT("%s: FEC %llu: failed to correct (%d erasures)",
-			    v->data_dev->name, (unsigned long long)rsb, neras);
+			    v->data_dev->name, index_in_region, neras);
 		return -EILSEQ;
 	}
 
 	return 0;
 }
-- 
2.52.0


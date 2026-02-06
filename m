Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62AD233B6C2;
	Fri,  6 Feb 2026 05:01:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770354116; cv=none; b=gKVRHXtDs3WQ24zuCUEbfaZr50Amkc1ZJGAonJlvuOab026CbGyQAu66B2rzyPlQ+WQ4G3AyxAS3DNd5uSpAKsLCADL9u7H46fWIgO8JmuFesFTnrIBYNRhZaIRw847203VKUhiBan3n9etWYUzOqZZXlsR+3aD806zBp5N6FD0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770354116; c=relaxed/simple;
	bh=HEihQ3GqjiYSd4FKeWzWwMymUXxpIM+mdkN25ie7fqo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Iy1gYsonltUOJZganfgVzn2rkxucM3IbSlr1ZAcojmuKE7eD1rgvkL2HD+WbSDdJl/m9+e6cdboiV6H1KdASq06dHAJkBzBxTYUDG/rxiom3tXZ7TqEc+Z89BEU9mleA5xlhPEe11ztEX8GnTXOijfnykPkfKvsMi2gnkUZhtEU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=NCYPOJ79; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="NCYPOJ79"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C708BC19425;
	Fri,  6 Feb 2026 05:01:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770354116;
	bh=HEihQ3GqjiYSd4FKeWzWwMymUXxpIM+mdkN25ie7fqo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NCYPOJ79+EvyMnCWZurdXvf0YjW+/7x6MrisLpOZnVpnWDsFsCRgMnWsJCe+z0vjL
	 jeGGclIosizPaXofS0FtEPtEmZZIOeoLZBzHuYJo+mK5jSD9NlKkHlHU4cdCkb31xb
	 nHzAdE0MsQ8yiT77rNkeuoj1vsDc0jb0nUbez0urmASr8hwinnpvzvR1w57ylXytAV
	 /4V+5I75uYtfqvsenCpe6FnpjGTnZjG9xSjxUSZee/Yfh+Z99VCs/s1H9F580byQyy
	 /bmADZ6yYdlKDFz9B0eCj5fEGzKvyV1F925e8JHqNhJqE96IL6oCsIlH7aTn5BXXUc
	 PISVjCdExhksw==
From: Eric Biggers <ebiggers@kernel.org>
To: dm-devel@lists.linux.dev,
	Alasdair Kergon <agk@redhat.com>,
	Mike Snitzer <snitzer@kernel.org>,
	Mikulas Patocka <mpatocka@redhat.com>,
	Benjamin Marzinski <bmarzins@redhat.com>
Cc: Sami Tolvanen <samitolvanen@google.com>,
	linux-kernel@vger.kernel.org,
	Eric Biggers <ebiggers@kernel.org>,
	stable@vger.kernel.org
Subject: [PATCH 05/22] dm-verity-fec: fix reading parity bytes split across blocks (take 3)
Date: Thu,  5 Feb 2026 20:59:24 -0800
Message-ID: <20260206045942.52965-6-ebiggers@kernel.org>
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

fec_decode_bufs() assumes that the parity bytes of the first RS codeword
it decodes are never split across parity blocks.

This assumption is false.  Consider v->fec->block_size == 4096 &&
v->fec->roots == 17 && fio->nbufs == 1, for example.  In that case, each
call to fec_decode_bufs() consumes v->fec->roots * (fio->nbufs <<
DM_VERITY_FEC_BUF_RS_BITS) = 272 parity bytes.

Considering that the parity data for each message block starts on a
block boundary, the byte alignment in the parity data will iterate
through 272*i mod 4096 until the 3 parity blocks have been consumed.  On
the 16th call (i=15), the alignment will be 4080 bytes into the first
block.  Only 16 bytes remain in that block, but 17 parity bytes will be
needed.  The code reads out-of-bounds from the parity block buffer.

Fortunately this doesn't normally happen, since it can occur only for
certain non-default values of fec_roots *and* when the maximum number of
buffers couldn't be allocated due to low memory.  For example with
block_size=4096 only the following cases are affected:

    fec_roots=17: nbufs in [1, 3, 5, 15]
    fec_roots=19: nbufs in [1, 229]
    fec_roots=21: nbufs in [1, 3, 5, 13, 15, 39, 65, 195]
    fec_roots=23: nbufs in [1, 89]

Regardless, fix it by refactoring how the parity blocks are read.

Fixes: 6df90c02bae4 ("dm-verity FEC: Fix RS FEC repair for roots unaligned to block size (take 2)")
Cc: stable@vger.kernel.org
Signed-off-by: Eric Biggers <ebiggers@kernel.org>
---
 drivers/md/dm-verity-fec.c | 100 ++++++++++++++++---------------------
 1 file changed, 44 insertions(+), 56 deletions(-)

diff --git a/drivers/md/dm-verity-fec.c b/drivers/md/dm-verity-fec.c
index d4a9367a2fee6..fcfacaec2989a 100644
--- a/drivers/md/dm-verity-fec.c
+++ b/drivers/md/dm-verity-fec.c
@@ -31,40 +31,10 @@ static inline u64 fec_interleave(struct dm_verity *v, u64 offset)
 
 	mod = do_div(offset, v->fec->rsn);
 	return offset + mod * (v->fec->rounds << v->data_dev_block_bits);
 }
 
-/*
- * Read error-correcting codes for the requested RS block. Returns a pointer
- * to the data block. Caller is responsible for releasing buf.
- */
-static u8 *fec_read_parity(struct dm_verity *v, u64 rsb, int index,
-			   unsigned int *offset, unsigned int par_buf_offset,
-			   struct dm_buffer **buf, unsigned short ioprio)
-{
-	u64 position, block, rem;
-	u8 *res;
-
-	/* We have already part of parity bytes read, skip to the next block */
-	if (par_buf_offset)
-		index++;
-
-	position = (index + rsb) * v->fec->roots;
-	block = div64_u64_rem(position, v->fec->io_size, &rem);
-	*offset = par_buf_offset ? 0 : (unsigned int)rem;
-
-	res = dm_bufio_read_with_ioprio(v->fec->bufio, block, buf, ioprio);
-	if (IS_ERR(res)) {
-		DMERR("%s: FEC %llu: parity read failed (block %llu): %ld",
-		      v->data_dev->name, (unsigned long long)rsb,
-		      (unsigned long long)block, PTR_ERR(res));
-		*buf = NULL;
-	}
-
-	return res;
-}
-
 /* Loop over each allocated buffer. */
 #define fec_for_each_buffer(io, __i) \
 	for (__i = 0; __i < (io)->nbufs; __i++)
 
 /* Loop over each RS block in each allocated buffer. */
@@ -100,28 +70,66 @@ static int fec_decode_bufs(struct dm_verity *v, struct dm_verity_io *io,
 			   struct dm_verity_fec_io *fio, u64 rsb, int byte_index,
 			   unsigned int block_offset, int neras)
 {
 	int r, corrected = 0, res;
 	struct dm_buffer *buf;
-	unsigned int n, i, j, offset, par_buf_offset = 0;
+	unsigned int n, i, j, parity_pos, to_copy;
 	uint16_t par_buf[DM_VERITY_FEC_RSM - DM_VERITY_FEC_MIN_RSN];
 	u8 *par, *block;
+	u64 parity_block;
 	struct bio *bio = dm_bio_from_per_bio_data(io, v->ti->per_io_data_size);
 
-	par = fec_read_parity(v, rsb, block_offset, &offset,
-			      par_buf_offset, &buf, bio->bi_ioprio);
-	if (IS_ERR(par))
+	/*
+	 * Compute the index of the first parity block that will be needed and
+	 * the starting position in that block.  Then read that block.
+	 *
+	 * io_size is always a power of 2, but roots might not be.  Note that
+	 * when it's not, a codeword's parity bytes can span a block boundary.
+	 */
+	parity_block = (rsb + block_offset) * v->fec->roots;
+	parity_pos = parity_block & (v->fec->io_size - 1);
+	parity_block >>= v->data_dev_block_bits;
+	par = dm_bufio_read_with_ioprio(v->fec->bufio, parity_block, &buf,
+					bio->bi_ioprio);
+	if (IS_ERR(par)) {
+		DMERR("%s: FEC %llu: parity read failed (block %llu): %ld",
+		      v->data_dev->name, rsb, parity_block, PTR_ERR(par));
 		return PTR_ERR(par);
+	}
 
 	/*
 	 * Decode the RS blocks we have in bufs. Each RS block results in
 	 * one corrected target byte and consumes fec->roots parity bytes.
 	 */
 	fec_for_each_buffer_rs_block(fio, n, i) {
 		block = fec_buffer_rs_block(v, fio, n, i);
-		for (j = 0; j < v->fec->roots - par_buf_offset; j++)
-			par_buf[par_buf_offset + j] = par[offset + j];
+
+		/*
+		 * Copy the next 'roots' parity bytes to 'par_buf', reading
+		 * another parity block if needed.
+		 */
+		to_copy = min(v->fec->io_size - parity_pos, v->fec->roots);
+		for (j = 0; j < to_copy; j++)
+			par_buf[j] = par[parity_pos++];
+		if (to_copy < v->fec->roots) {
+			parity_block++;
+			parity_pos = 0;
+
+			dm_bufio_release(buf);
+			par = dm_bufio_read_with_ioprio(v->fec->bufio,
+							parity_block, &buf,
+							bio->bi_ioprio);
+			if (IS_ERR(par)) {
+				DMERR("%s: FEC %llu: parity read failed (block %llu): %ld",
+				      v->data_dev->name, rsb, parity_block,
+				      PTR_ERR(par));
+				return PTR_ERR(par);
+			}
+			for (; j < v->fec->roots; j++)
+				par_buf[j] = par[parity_pos++];
+		}
+
 		/* Decode an RS block using Reed-Solomon */
 		res = decode_rs8(fio->rs, block, par_buf, v->fec->rsn,
 				 NULL, neras, fio->erasures, 0, NULL);
 		if (res < 0) {
 			r = res;
@@ -132,30 +140,10 @@ static int fec_decode_bufs(struct dm_verity *v, struct dm_verity_io *io,
 		fio->output[block_offset] = block[byte_index];
 
 		block_offset++;
 		if (block_offset >= 1 << v->data_dev_block_bits)
 			goto done;
-
-		/* Read the next block when we run out of parity bytes */
-		offset += (v->fec->roots - par_buf_offset);
-		/* Check if parity bytes are split between blocks */
-		if (offset < v->fec->io_size && (offset + v->fec->roots) > v->fec->io_size) {
-			par_buf_offset = v->fec->io_size - offset;
-			for (j = 0; j < par_buf_offset; j++)
-				par_buf[j] = par[offset + j];
-			offset += par_buf_offset;
-		} else
-			par_buf_offset = 0;
-
-		if (offset >= v->fec->io_size) {
-			dm_bufio_release(buf);
-
-			par = fec_read_parity(v, rsb, block_offset, &offset,
-					      par_buf_offset, &buf, bio->bi_ioprio);
-			if (IS_ERR(par))
-				return PTR_ERR(par);
-		}
 	}
 done:
 	r = corrected;
 error:
 	dm_bufio_release(buf);
-- 
2.52.0


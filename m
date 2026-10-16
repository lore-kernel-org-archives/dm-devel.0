Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E2B058B6CD;
	Fri, 16 Oct 2026 17:34:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792172046; cv=none; b=d4gOEsimSvR+QTNCxfR1W+eBoqEEnXM4UMPwOHlK2L+0HMgCwL/kphY0Fc7eVivHe4JJFxR1DfnsVMYMnWuuh6ms63xbNfJI+SP2zaoeg0tuLbGnPcIa1Xuo6xjWIgJ0dBJlaL9KYXGtSf7LkFXgDAJ6LQwWbcWK5fmK4Yh4CSU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792172046; c=relaxed/simple;
	bh=rXfr5MYmNmZMZhteW/CjIVtGfK+mWP6aYG9zAvMjp4o=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=OD0fe07c1x0fP3ORfA6bPE33z4pT180MQMN3KkTMUfo7XUzqSjb0VBZpaVrgW1hHDZAlLZQXhmntBQlS0oVDhTxAQcVOTWxcSt0ytuyl614WqSE8pMVPnPHrLpbafFZ/v0+aCJGpdyD7HdR/wKUkjrug0YNt95X2uHB5J4sbDgk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=WDE/MBMb; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WDE/MBMb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 700651F000C5;
	Fri, 16 Oct 2026 17:34:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792172045;
	bh=hUWSs1n8vw5jOviWWRc6vi55yqEa3j0anDbuUMLtqrM=;
	h=From:To:Cc:Subject:Date:Reply-To;
	b=WDE/MBMbwimvWOzo1Ij5TbGd5rnxowWvJ89/RA5uWgvI+Oz3XLggGHOiYHY493t7/
	 1mrUy5iIrqsTE48DdfTuzKozopiIQ5QfJtyvsVhZDzQfsLmdCS/kIm08/vOVIhlSgM
	 nXH81kba5aV9dXBDqNAJG2ybZUTtqaObd3ValD+WppGNWcc5b8IJoLjRgYuTxSIHWE
	 MOB8zKwsOkqjO4vFx30YnBxTfok9Y6XKhPSCIQqMOlEhibhJ158XtuxXz1M4+uwL1O
	 dAqIIEStaotFPT1VL94PJPTU0XGNKKqen1EOSRzvpevsTwrZxWa+F374f01L4iSUAS
	 ELELPBFpTmmVg==
From: Sasha Levin <sashal@kernel.org>
To: stable-commits@vger.kernel.org,
	ebiggers@kernel.org
Cc: Alasdair Kergon <agk@redhat.com>,
	Mike Snitzer <snitzer@kernel.org>,
	dm-devel@lists.linux.dev
Subject: Patch "dm-verity-fec: fix reading parity bytes split across blocks (take 3)" has been added to the 6.6-stable tree
Date: Fri, 16 Oct 2026 13:34:03 -0400
Message-ID: <20261016173403.4019338-1-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
Reply-To: stable@vger.kernel.org
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Patchwork-Hint: ignore
X-stable: review
Content-Transfer-Encoding: 8bit

This is a note to let you know that I've just added the patch titled

    dm-verity-fec: fix reading parity bytes split across blocks (take 3)

to the 6.6-stable tree which can be found at:
    http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary

The filename of the patch is:
     dm-verity-fec-fix-reading-parity-bytes-split-across-.patch
and it can be found in the queue-6.6 subdirectory.

If you, or anyone else, feels it should not be added to the stable tree,
please let <stable@vger.kernel.org> know about it.



commit a8d396362ca89fb6c25e7d68c0d3041d0d703751
Author: Eric Biggers <ebiggers@kernel.org>
Date:   Thu Feb 5 20:59:24 2026 -0800

    dm-verity-fec: fix reading parity bytes split across blocks (take 3)
    
    [ Upstream commit 430a05cb926f6bdf53e81460a2c3a553257f3f61 ]
    
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
    Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
    Signed-off-by: Sasha Levin <sashal@kernel.org>

diff --git a/drivers/md/dm-verity-fec.c b/drivers/md/dm-verity-fec.c
index 5f646c4bb98a6..5073c93cf962c 100644
--- a/drivers/md/dm-verity-fec.c
+++ b/drivers/md/dm-verity-fec.c
@@ -55,36 +55,6 @@ static int fec_decode_rs8(struct dm_verity *v, struct dm_verity_fec_io *fio,
 			  fio->erasures, 0, NULL);
 }
 
-/*
- * Read error-correcting codes for the requested RS block. Returns a pointer
- * to the data block. Caller is responsible for releasing buf.
- */
-static u8 *fec_read_parity(struct dm_verity *v, u64 rsb, int index,
-			   unsigned int *offset, unsigned int par_buf_offset,
-			  struct dm_buffer **buf)
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
-	res = dm_bufio_read(v->fec->bufio, block, buf);
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
 /* Loop over each preallocated buffer slot. */
 #define fec_for_each_prealloc_buffer(__i) \
 	for (__i = 0; __i < DM_VERITY_FEC_BUF_PREALLOC; __i++)
@@ -132,13 +102,27 @@ static int fec_decode_bufs(struct dm_verity *v, struct dm_verity_fec_io *fio,
 {
 	int r, corrected = 0, res;
 	struct dm_buffer *buf;
-	unsigned int n, i, offset, par_buf_offset = 0;
+	unsigned int n, i, parity_pos, to_copy;
 	u8 *par, *block, par_buf[DM_VERITY_FEC_RSM - DM_VERITY_FEC_MIN_RSN];
+	u64 parity_block;
 
-	par = fec_read_parity(v, rsb, block_offset, &offset,
-			      par_buf_offset, &buf);
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
+	par = dm_bufio_read(v->fec->bufio, parity_block, &buf);
+	if (IS_ERR(par)) {
+		DMERR("%s: FEC %llu: parity read failed (block %llu): %ld",
+		      v->data_dev->name, (unsigned long long)rsb,
+		      (unsigned long long)parity_block, PTR_ERR(par));
 		return PTR_ERR(par);
+	}
 
 	/*
 	 * Decode the RS blocks we have in bufs. Each RS block results in
@@ -146,7 +130,31 @@ static int fec_decode_bufs(struct dm_verity *v, struct dm_verity_fec_io *fio,
 	 */
 	fec_for_each_buffer_rs_block(fio, n, i) {
 		block = fec_buffer_rs_block(v, fio, n, i);
-		memcpy(&par_buf[par_buf_offset], &par[offset], v->fec->roots - par_buf_offset);
+
+		/*
+		 * Copy the next 'roots' parity bytes to 'par_buf', reading
+		 * another parity block if needed.
+		 */
+		to_copy = min(v->fec->io_size - parity_pos, v->fec->roots);
+		memcpy(par_buf, &par[parity_pos], to_copy);
+		parity_pos += to_copy;
+		if (to_copy < v->fec->roots) {
+			parity_block++;
+			parity_pos = 0;
+
+			dm_bufio_release(buf);
+			par = dm_bufio_read(v->fec->bufio, parity_block, &buf);
+			if (IS_ERR(par)) {
+				DMERR("%s: FEC %llu: parity read failed (block %llu): %ld",
+				      v->data_dev->name, (unsigned long long)rsb,
+				      (unsigned long long)parity_block,
+				      PTR_ERR(par));
+				return PTR_ERR(par);
+			}
+			memcpy(&par_buf[to_copy], par, v->fec->roots - to_copy);
+			parity_pos = v->fec->roots - to_copy;
+		}
+
 		res = fec_decode_rs8(v, fio, block, par_buf, neras);
 		if (res < 0) {
 			r = res;
@@ -159,25 +167,6 @@ static int fec_decode_bufs(struct dm_verity *v, struct dm_verity_fec_io *fio,
 		block_offset++;
 		if (block_offset >= 1 << v->data_dev_block_bits)
 			goto done;
-
-		/* Read the next block when we run out of parity bytes */
-		offset += (v->fec->roots - par_buf_offset);
-		/* Check if parity bytes are split between blocks */
-		if (offset < v->fec->io_size && (offset + v->fec->roots) > v->fec->io_size) {
-			par_buf_offset = v->fec->io_size - offset;
-			memcpy(par_buf, &par[offset], par_buf_offset);
-			offset += par_buf_offset;
-		} else
-			par_buf_offset = 0;
-
-		if (offset >= v->fec->io_size) {
-			dm_bufio_release(buf);
-
-			par = fec_read_parity(v, rsb, block_offset, &offset,
-					      par_buf_offset, &buf);
-			if (IS_ERR(par))
-				return PTR_ERR(par);
-		}
 	}
 done:
 	r = corrected;

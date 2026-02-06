Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A694833893D;
	Fri,  6 Feb 2026 05:02:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770354122; cv=none; b=p4SbPykY00b9DBOsK3mezzdamBtanurKtbRoTGJBdZDvkrQjautnUDTCXfziXrfkoGQULK3l4sZQbjqLrvBnBoWKyFor/vuSooEdMG8ZPu5TeT6zl/1oEATZpzJM6SOLERgecyE6P7spPvpsh9RDzbRHYBl2hU2ysbFnUD5LUeE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770354122; c=relaxed/simple;
	bh=Jo0yT6tvQafUN2nmhO1lBz5NcR9q25+Kc6/PVRBk1es=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DfkiVlAvh53aBwp/DikdZl8Sd7xuGQq8v8XDaqfrTPcgkrmudzPPaCe/THfrlty0tNeWNO8VAtAgJ3DEmke+/f9ZAwvcrKBJlbgsS4IC1EEjQyH50Yy1HXcalmAYqTxVYXPPv7/uGB8nipn2JFFmhqfDzWOzXZyk2LncaDPNXeA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Gns522oK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Gns522oK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4DA50C19424;
	Fri,  6 Feb 2026 05:02:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770354122;
	bh=Jo0yT6tvQafUN2nmhO1lBz5NcR9q25+Kc6/PVRBk1es=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Gns522oKiZmgOnPDA7XMkCaIgJj0U4H/FteGOB6Sg28PqAIGz6fOnn3bcq3Z77qsx
	 HBXAasZmeNLo3kp/lF9/q7Ee0vxubwFJ1x7kRcsaK5FDUCVdmUrHyhpUkNdCHtRX/K
	 SPLods299jKnhEfkrqtB3Emq5uAi7tCUkwlkheGOMCC9s4hSyugHiL2MOQ/tqp7yYk
	 8jl6Fv8wVBDk0EGgcjsmBlHo/ESMJKAivRJllgVToz+qK3U38NQLZsLABwpaoHvwwh
	 mACt+EsK0aDJRuUIkl4PYi9wGSCeyQi4C0CtEIhuPwf0Mvm8+jrCmjzG46JIG5NHE0
	 VhtjQc6ysEsVg==
From: Eric Biggers <ebiggers@kernel.org>
To: dm-devel@lists.linux.dev,
	Alasdair Kergon <agk@redhat.com>,
	Mike Snitzer <snitzer@kernel.org>,
	Mikulas Patocka <mpatocka@redhat.com>,
	Benjamin Marzinski <bmarzins@redhat.com>
Cc: Sami Tolvanen <samitolvanen@google.com>,
	linux-kernel@vger.kernel.org,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH 21/22] dm-verity-fec: log target_block instead of index_in_region
Date: Thu,  5 Feb 2026 20:59:40 -0800
Message-ID: <20260206045942.52965-22-ebiggers@kernel.org>
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

The log message for a FEC error or correction includes the data device
name and index_in_region as the context.  Although the result of FEC
(for a particular dm-verity instance) is expected to be the same for a
given index_in_region, index_in_region does not uniquely identify the
actual target block that is being corrected.  Since that value
(target_block) is likely more useful, log it instead.

Signed-off-by: Eric Biggers <ebiggers@kernel.org>
---
 drivers/md/dm-verity-fec.c | 26 ++++++++++++++------------
 1 file changed, 14 insertions(+), 12 deletions(-)

diff --git a/drivers/md/dm-verity-fec.c b/drivers/md/dm-verity-fec.c
index 59ff3d58f49df..fbe01f809aca3 100644
--- a/drivers/md/dm-verity-fec.c
+++ b/drivers/md/dm-verity-fec.c
@@ -47,12 +47,13 @@ static inline u8 *fec_buffer_rs_message(struct dm_verity *v,
 /*
  * Decode all RS codewords whose message bytes were loaded into fio->bufs.  Copy
  * the corrected bytes into fio->output starting from out_pos.
  */
 static int fec_decode_bufs(struct dm_verity *v, struct dm_verity_io *io,
-			   struct dm_verity_fec_io *fio, u64 index_in_region,
-			   int target_region, unsigned int out_pos, int neras)
+			   struct dm_verity_fec_io *fio, u64 target_block,
+			   unsigned int target_region, u64 index_in_region,
+			   unsigned int out_pos, int neras)
 {
 	int r = 0, corrected = 0, res;
 	struct dm_buffer *buf;
 	unsigned int n, i, j, parity_pos, to_copy;
 	uint16_t par_buf[DM_VERITY_FEC_MAX_ROOTS];
@@ -73,11 +74,11 @@ static int fec_decode_bufs(struct dm_verity *v, struct dm_verity_io *io,
 	parity_block >>= v->data_dev_block_bits;
 	par = dm_bufio_read_with_ioprio(v->fec->bufio, parity_block, &buf,
 					bio->bi_ioprio);
 	if (IS_ERR(par)) {
 		DMERR("%s: FEC %llu: parity read failed (block %llu): %ld",
-		      v->data_dev->name, index_in_region, parity_block,
+		      v->data_dev->name, target_block, parity_block,
 		      PTR_ERR(par));
 		return PTR_ERR(par);
 	}
 
 	/*
@@ -103,11 +104,11 @@ static int fec_decode_bufs(struct dm_verity *v, struct dm_verity_io *io,
 			par = dm_bufio_read_with_ioprio(v->fec->bufio,
 							parity_block, &buf,
 							bio->bi_ioprio);
 			if (IS_ERR(par)) {
 				DMERR("%s: FEC %llu: parity read failed (block %llu): %ld",
-				      v->data_dev->name, index_in_region,
+				      v->data_dev->name, target_block,
 				      parity_block, PTR_ERR(par));
 				return PTR_ERR(par);
 			}
 			for (; j < v->fec->roots; j++)
 				par_buf[j] = par[parity_pos++];
@@ -129,14 +130,14 @@ static int fec_decode_bufs(struct dm_verity *v, struct dm_verity_io *io,
 done:
 	dm_bufio_release(buf);
 
 	if (r < 0 && neras)
 		DMERR_LIMIT("%s: FEC %llu: failed to correct: %d",
-			    v->data_dev->name, index_in_region, r);
+			    v->data_dev->name, target_block, r);
 	else if (r == 0 && corrected > 0)
 		DMWARN_LIMIT("%s: FEC %llu: corrected %d errors",
-			     v->data_dev->name, index_in_region, corrected);
+			     v->data_dev->name, target_block, corrected);
 
 	return r;
 }
 
 /*
@@ -155,11 +156,12 @@ static int fec_is_erasure(struct dm_verity *v, struct dm_verity_io *io,
 /*
  * Read data blocks that are part of the RS block and deinterleave as much as
  * fits into buffers. Check for erasure locations if @neras is non-NULL.
  */
 static int fec_read_bufs(struct dm_verity *v, struct dm_verity_io *io,
-			 u64 index_in_region, unsigned int out_pos, int *neras)
+			 u64 target_block, u64 index_in_region,
+			 unsigned int out_pos, int *neras)
 {
 	bool is_zero;
 	int i, j;
 	struct dm_buffer *buf;
 	struct dm_bufio_client *bufio;
@@ -199,11 +201,11 @@ static int fec_read_bufs(struct dm_verity *v, struct dm_verity_io *io,
 		}
 
 		bbuf = dm_bufio_read_with_ioprio(bufio, block, &buf, bio->bi_ioprio);
 		if (IS_ERR(bbuf)) {
 			DMWARN_LIMIT("%s: FEC %llu: read failed (%llu): %ld",
-				     v->data_dev->name, index_in_region, block,
+				     v->data_dev->name, target_block, block,
 				     PTR_ERR(bbuf));
 
 			/* assume the block is corrupted */
 			if (neras && *neras <= v->fec->roots)
 				fio->erasures[(*neras)++] = i;
@@ -324,17 +326,17 @@ static int fec_decode(struct dm_verity *v, struct dm_verity_io *io,
 		return -EIO;
 
 	for (out_pos = 0; out_pos < v->fec->block_size;) {
 		fec_init_bufs(v, fio);
 
-		r = fec_read_bufs(v, io, index_in_region, out_pos,
+		r = fec_read_bufs(v, io, target_block, index_in_region, out_pos,
 				  use_erasures ? &neras : NULL);
 		if (unlikely(r < 0))
 			return r;
 
-		r = fec_decode_bufs(v, io, fio, index_in_region, target_region,
-				    out_pos, neras);
+		r = fec_decode_bufs(v, io, fio, target_block, target_region,
+				    index_in_region, out_pos, neras);
 		if (r < 0)
 			return r;
 
 		out_pos += fio->nbufs << DM_VERITY_FEC_BUF_RS_BITS;
 	}
@@ -344,11 +346,11 @@ static int fec_decode(struct dm_verity *v, struct dm_verity_io *io,
 	if (unlikely(r < 0))
 		return r;
 
 	if (memcmp(io->tmp_digest, want_digest, v->digest_size)) {
 		DMERR_LIMIT("%s: FEC %llu: failed to correct (%d erasures)",
-			    v->data_dev->name, index_in_region, neras);
+			    v->data_dev->name, target_block, neras);
 		return -EILSEQ;
 	}
 
 	return 0;
 }
-- 
2.52.0


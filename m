Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13211344053;
	Fri,  6 Feb 2026 05:02:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770354123; cv=none; b=R4k2Ms/5ZXdmfRFYQ8+fQMGfiNQCtXFfKZZn+RHrK0gjqvx4e3vdgkSz1eTFcBX+TOtqplCZYMBvHp7hOAP7ZTKVlm3sirC68iKsvg9AiElZ7vf/6n57cASA47jq8zFW4KBr3IYfwye/uZAy4cOGrA/8Mf5Nt/+D4/FRhaL6WhY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770354123; c=relaxed/simple;
	bh=j7cUUZCXDpGOPnDD6xevilNT4R6dBIcSSIK4b1WnMi4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XRIFraHvU+z7wcUYzXgUGv+Ol6MaJoWbFiCJOJZaieuu25nPwO/LGrWW18e6MC6HWdiTe6MXJS/v05ua5rnUzske4VT97mtCle/cC09a9nvKHpLYDfAgJcB93iLk5gvp2avjcqRzXEVg6NzxR0G5wqvRgyUJF4nFlaW+9Sy27LQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=MrJeie8J; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="MrJeie8J"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD453C19422;
	Fri,  6 Feb 2026 05:02:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770354122;
	bh=j7cUUZCXDpGOPnDD6xevilNT4R6dBIcSSIK4b1WnMi4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MrJeie8JydDPc99h00Or1pVIqsWDekJiW71Kw9Pu+aT1sHlsB9fCLiMe66Yv/GQP1
	 zdWrjPX3eWh71fbTSesgcTwCzwZ/NiBpANXKhDui9uLWn7Bc+DtHJZt971GDOldn6a
	 GNVOePhH/akFTiQmh+VNjInWMA3v3NiPxUjrxtqfxzOHMljilx8t9qYLEcg2+LNmZy
	 tXZeaosab2srQqNLnhSZ0rbmxkbazXCGFN3sNfWJhYWLf3AqWT7cRGfx6d8SZgG6kq
	 X+Ji56aupMdKodOrv0htb50l3il1fkDih62+QGLOSVguvMnjiYj2aw2ArSK7LEEd/5
	 Zf6MTYTVJm21A==
From: Eric Biggers <ebiggers@kernel.org>
To: dm-devel@lists.linux.dev,
	Alasdair Kergon <agk@redhat.com>,
	Mike Snitzer <snitzer@kernel.org>,
	Mikulas Patocka <mpatocka@redhat.com>,
	Benjamin Marzinski <bmarzins@redhat.com>
Cc: Sami Tolvanen <samitolvanen@google.com>,
	linux-kernel@vger.kernel.org,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH 22/22] dm-verity-fec: improve comments for fec_read_bufs()
Date: Thu,  5 Feb 2026 20:59:41 -0800
Message-ID: <20260206045942.52965-23-ebiggers@kernel.org>
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

Update the comments in and above fec_read_bufs() to more clearly
describe what it does.

Signed-off-by: Eric Biggers <ebiggers@kernel.org>
---
 drivers/md/dm-verity-fec.c | 30 ++++++++++++++++++++++--------
 1 file changed, 22 insertions(+), 8 deletions(-)

diff --git a/drivers/md/dm-verity-fec.c b/drivers/md/dm-verity-fec.c
index fbe01f809aca3..70aa4a20891bc 100644
--- a/drivers/md/dm-verity-fec.c
+++ b/drivers/md/dm-verity-fec.c
@@ -152,12 +152,25 @@ static int fec_is_erasure(struct dm_verity *v, struct dm_verity_io *io,
 
 	return memcmp(io->tmp_digest, want_digest, v->digest_size) != 0;
 }
 
 /*
- * Read data blocks that are part of the RS block and deinterleave as much as
- * fits into buffers. Check for erasure locations if @neras is non-NULL.
+ * Read the message block at index @index_in_region within each of the
+ * @v->fec->rs_k regions and deinterleave their contents into @io->fec_io->bufs.
+ *
+ * @target_block gives the index of specific block within this sequence that is
+ * being corrected, relative to the start of all the FEC message blocks.
+ *
+ * @out_pos gives the current output position, i.e. the position in (each) block
+ * from which to start the deinterleaving.  Deinterleaving continues until
+ * either end-of-block is reached or there's no more buffer space.
+ *
+ * If @neras is non-NULL, then also use verity hashes and the presence/absence
+ * of I/O errors to determine which of the message blocks in the sequence are
+ * likely to be incorrect.  Write the number of such blocks to *@neras and the
+ * indices of the corresponding RS message bytes in [0, k - 1] to
+ * @io->fec_io->erasures, up to a limit of @v->fec->roots + 1 such blocks.
  */
 static int fec_read_bufs(struct dm_verity *v, struct dm_verity_io *io,
 			 u64 target_block, u64 index_in_region,
 			 unsigned int out_pos, int *neras)
 {
@@ -176,15 +189,15 @@ static int fec_read_bufs(struct dm_verity *v, struct dm_verity_io *io,
 		*neras = 0;
 
 	if (WARN_ON(v->digest_size > sizeof(want_digest)))
 		return -EINVAL;
 
-	/*
-	 * read each of the rs_k data blocks that are part of the RS block, and
-	 * interleave contents to available bufs
-	 */
 	for (i = 0; i < v->fec->rs_k; i++) {
+		/*
+		 * Read the block from region i.  It contains the i'th message
+		 * byte of the target block's RS codewords.
+		 */
 		block = i * v->fec->region_blocks + index_in_region;
 		bufio = v->fec->data_bufio;
 
 		if (block >= v->data_blocks) {
 			block -= v->data_blocks;
@@ -229,12 +242,13 @@ static int fec_read_bufs(struct dm_verity *v, struct dm_verity_io *io,
 			    fec_is_erasure(v, io, want_digest, bbuf))
 				fio->erasures[(*neras)++] = i;
 		}
 
 		/*
-		 * deinterleave and copy the bytes that fit into bufs,
-		 * starting from out_pos
+		 * Deinterleave the bytes of the block, starting from 'out_pos',
+		 * into the i'th byte of the RS message buffers.  Stop when
+		 * end-of-block is reached or there are no more buffers.
 		 */
 		src_pos = out_pos;
 		fec_for_each_buffer_rs_message(fio, n, j) {
 			if (src_pos >= v->fec->block_size)
 				goto done;
-- 
2.52.0


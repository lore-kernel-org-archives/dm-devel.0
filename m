Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52AD733FE10;
	Tue, 16 Dec 2025 23:06:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765926420; cv=none; b=R1UVruQhNWxslfTi8j0o1L8km+Z+u9Y0mkohSlM7TMpRVEnfEe1ij3JMYGSMvIi2WTCLwsymV4bZeNCTZuS9CRDMBEBe17kVNByzAvkWPOSnGChZGBvI7QiDLhokg3IyHF/GIOso6nP4yL+ElysssP8QIQN/CWdsDS2bxjTpRog=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765926420; c=relaxed/simple;
	bh=UIh2lBlsCpMPvtCjHLE12Rw0UIMIzrvaY3f6XYfUzQQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=taHZNG/3Ynauv7KivxcAcj7urPPLOg8hVhBT2XN0bXwEJsawTkbVWFkehV0V7OlDwG5Tvq/RTMO4xr4JaLtqBwX98hOOJ1SRT1ERU7eVdIV+z1dFKUN8/O1FgXZ35g/sKI0rRrP31ZeM6SRRHUZube2Vnv86rZiB8cwUU9JidWs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=i03WIikQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="i03WIikQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3DA3DC19424;
	Tue, 16 Dec 2025 23:06:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1765926419;
	bh=UIh2lBlsCpMPvtCjHLE12Rw0UIMIzrvaY3f6XYfUzQQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=i03WIikQgmRlD91C0gqlY2p/Tg3h/5o2ssYupnVC10kBfnLD6lWIvtx9zPBwkwcnz
	 9i7apTc7QNkWlIkN9ieHntj+OPrf6ZIyxVbsImu14Ap64Q+tCXmj8UFGxuoMGXOt9v
	 PALa2mFhVH/ibY58qRjZwClkvBuRswN/b1fqywDX23IkIXb0g0GDvoYj1HYvj2bLSA
	 MZBvYvPYY2CbyD/JjZk8E8Bqqx3+FZWmrNTyzJeH4QHL0N9IRo1348XP9QnIL0nW9t
	 0SZxsy53/VwPKCnYDAdPWKTENd9saDsa5FfK2dVEPXndH3xmg4Vh8v0iT4X26GeKoU
	 4NiuR/RXHkstQ==
From: Eric Biggers <ebiggers@kernel.org>
To: dm-devel@lists.linux.dev,
	Alasdair Kergon <agk@redhat.com>,
	Mike Snitzer <snitzer@kernel.org>,
	Mikulas Patocka <mpatocka@redhat.com>,
	Benjamin Marzinski <bmarzins@redhat.com>
Cc: Sami Tolvanen <samitolvanen@google.com>,
	Eran Messeri <eranm@google.com>,
	linux-kernel@vger.kernel.org,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH 2/7] dm-verity: make dm_verity_fec_io::bufs variable-length
Date: Tue, 16 Dec 2025 15:06:09 -0800
Message-ID: <20251216230614.51779-3-ebiggers@kernel.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216230614.51779-1-ebiggers@kernel.org>
References: <20251216230614.51779-1-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

When correcting a data block, the FEC code performs optimally when it
has enough buffers to hold all the needed RS blocks.  That number of
buffers is '1 << (v->data_dev_block_bits - DM_VERITY_FEC_BUF_RS_BITS)'.

However, since v->data_dev_block_bits isn't a compile-time constant, the
code actually used PAGE_SHIFT instead.

With the traditional PAGE_SIZE == data_block_size == 4096, this was
fine.  However, when PAGE_SIZE > data_block_size, this wastes space.
E.g., with data_block_size == 4096 && PAGE_SIZE == 16384, struct
dm_verity_fec_io is 9240 bytes, when in fact only 3096 bytes are needed.

Fix this by making dm_verity_fec_io::bufs a variable-length array.

This makes the macros DM_VERITY_FEC_BUF_MAX and
fec_for_each_extra_buffer() no longer apply, so remove them.  Also
remove the related macro fec_for_each_prealloc_buffer(), since
DM_VERITY_FEC_BUF_PREALLOC is fixed at 1 and was already assumed to be 1
(considering that mempool_alloc() shouldn't be called in a loop).

Signed-off-by: Eric Biggers <ebiggers@kernel.org>
---
 drivers/md/dm-verity-fec.c | 41 ++++++++++++++++++++------------------
 drivers/md/dm-verity-fec.h | 14 ++++++++-----
 2 files changed, 31 insertions(+), 24 deletions(-)

diff --git a/drivers/md/dm-verity-fec.c b/drivers/md/dm-verity-fec.c
index bf533ffa7d56..7574e65c32ae 100644
--- a/drivers/md/dm-verity-fec.c
+++ b/drivers/md/dm-verity-fec.c
@@ -8,10 +8,22 @@
 #include "dm-verity-fec.h"
 #include <linux/math64.h>
 
 #define DM_MSG_PREFIX	"verity-fec"
 
+/*
+ * When correcting a data block, the FEC code performs optimally when it can
+ * collect all the associated RS blocks at the same time.  As each byte is part
+ * of a different RS block, there are '1 << data_dev_block_bits' RS blocks.
+ * There are '1 << DM_VERITY_FEC_BUF_RS_BITS' RS blocks per buffer, so that
+ * gives '1 << (data_dev_block_bits - DM_VERITY_FEC_BUF_RS_BITS)' buffers.
+ */
+static inline unsigned int fec_max_nbufs(struct dm_verity *v)
+{
+	return 1 << (v->data_dev_block_bits - DM_VERITY_FEC_BUF_RS_BITS);
+}
+
 /*
  * If error correction has been configured, returns true.
  */
 bool verity_fec_is_enabled(struct dm_verity *v)
 {
@@ -57,18 +69,10 @@ static u8 *fec_read_parity(struct dm_verity *v, u64 rsb, int index,
 	}
 
 	return res;
 }
 
-/* Loop over each preallocated buffer slot. */
-#define fec_for_each_prealloc_buffer(__i) \
-	for (__i = 0; __i < DM_VERITY_FEC_BUF_PREALLOC; __i++)
-
-/* Loop over each extra buffer slot. */
-#define fec_for_each_extra_buffer(io, __i) \
-	for (__i = DM_VERITY_FEC_BUF_PREALLOC; __i < DM_VERITY_FEC_BUF_MAX; __i++)
-
 /* Loop over each allocated buffer. */
 #define fec_for_each_buffer(io, __i) \
 	for (__i = 0; __i < (io)->nbufs; __i++)
 
 /* Loop over each RS block in each allocated buffer. */
@@ -305,24 +309,23 @@ static int fec_read_bufs(struct dm_verity *v, struct dm_verity_io *io,
  * Additional buffers are also allocated opportunistically to improve error
  * correction performance, but these aren't required to succeed.
  */
 static struct dm_verity_fec_io *fec_alloc_and_init_io(struct dm_verity *v)
 {
+	const unsigned int max_nbufs = fec_max_nbufs(v);
 	struct dm_verity_fec *f = v->fec;
 	struct dm_verity_fec_io *fio;
 	unsigned int n;
 
 	fio = mempool_alloc(&f->fio_pool, GFP_NOIO);
 	fio->rs = mempool_alloc(&f->rs_pool, GFP_NOIO);
 
-	memset(fio->bufs, 0, sizeof(fio->bufs));
-
-	fec_for_each_prealloc_buffer(n)
-		fio->bufs[n] = mempool_alloc(&f->prealloc_pool, GFP_NOIO);
+	static_assert(DM_VERITY_FEC_BUF_PREALLOC == 1);
+	fio->bufs[0] = mempool_alloc(&f->prealloc_pool, GFP_NOIO);
 
 	/* try to allocate the maximum number of buffers */
-	fec_for_each_extra_buffer(fio, n) {
+	for (n = 1; n < max_nbufs; n++) {
 		fio->bufs[n] = kmem_cache_alloc(f->cache, GFP_NOWAIT);
 		/* we can manage with even one buffer if necessary */
 		if (unlikely(!fio->bufs[n]))
 			break;
 	}
@@ -460,16 +463,15 @@ void __verity_fec_finish_io(struct dm_verity_io *io)
 	struct dm_verity_fec *f = io->v->fec;
 	struct dm_verity_fec_io *fio = io->fec_io;
 
 	mempool_free(fio->rs, &f->rs_pool);
 
-	fec_for_each_prealloc_buffer(n)
-		mempool_free(fio->bufs[n], &f->prealloc_pool);
+	static_assert(DM_VERITY_FEC_BUF_PREALLOC == 1);
+	mempool_free(fio->bufs[0], &f->prealloc_pool);
 
-	fec_for_each_extra_buffer(fio, n)
-		if (fio->bufs[n])
-			kmem_cache_free(f->cache, fio->bufs[n]);
+	for (n = 1; n < fio->nbufs; n++)
+		kmem_cache_free(f->cache, fio->bufs[n]);
 
 	mempool_free(fio->output, &f->output_pool);
 
 	mempool_free(fio, &f->fio_pool);
 }
@@ -732,11 +734,12 @@ int verity_fec_ctr(struct dm_verity *v)
 		return -E2BIG;
 	}
 
 	/* Preallocate some dm_verity_fec_io structures */
 	ret = mempool_init_kmalloc_pool(&f->fio_pool, num_online_cpus(),
-					sizeof(struct dm_verity_fec_io));
+					struct_size((struct dm_verity_fec_io *)0,
+						    bufs, fec_max_nbufs(v)));
 	if (ret) {
 		ti->error = "Cannot allocate FEC IO pool";
 		return ret;
 	}
 
diff --git a/drivers/md/dm-verity-fec.h b/drivers/md/dm-verity-fec.h
index b9488d1ddf14..84f8299673ff 100644
--- a/drivers/md/dm-verity-fec.h
+++ b/drivers/md/dm-verity-fec.h
@@ -17,13 +17,10 @@
 #define DM_VERITY_FEC_MIN_RSN		231	/* ~10% space overhead */
 
 /* buffers for deinterleaving and decoding */
 #define DM_VERITY_FEC_BUF_PREALLOC	1	/* buffers to preallocate */
 #define DM_VERITY_FEC_BUF_RS_BITS	4	/* 1 << RS blocks per buffer */
-/* we need buffers for at most 1 << block size RS blocks */
-#define DM_VERITY_FEC_BUF_MAX \
-	(1 << (PAGE_SHIFT - DM_VERITY_FEC_BUF_RS_BITS))
 
 #define DM_VERITY_OPT_FEC_DEV		"use_fec_from_device"
 #define DM_VERITY_OPT_FEC_BLOCKS	"fec_blocks"
 #define DM_VERITY_OPT_FEC_START		"fec_start"
 #define DM_VERITY_OPT_FEC_ROOTS		"fec_roots"
@@ -50,14 +47,21 @@ struct dm_verity_fec {
 
 /* per-bio data */
 struct dm_verity_fec_io {
 	struct rs_control *rs;	/* Reed-Solomon state */
 	int erasures[DM_VERITY_FEC_MAX_RSN];	/* erasures for decode_rs8 */
-	u8 *bufs[DM_VERITY_FEC_BUF_MAX];	/* bufs for deinterleaving */
-	unsigned int nbufs;		/* number of buffers allocated */
 	u8 *output;		/* buffer for corrected output */
 	unsigned int level;		/* recursion level */
+	unsigned int nbufs;		/* number of buffers allocated */
+	/*
+	 * Buffers for deinterleaving RS blocks.  Each buffer has space for
+	 * the data bytes of (1 << DM_VERITY_FEC_BUF_RS_BITS) RS blocks.  The
+	 * array length is fec_max_nbufs(v), and we try to allocate that many
+	 * buffers.  However, in low-memory situations we may be unable to
+	 * allocate all buffers.  'nbufs' holds the number actually allocated.
+	 */
+	u8 *bufs[];
 };
 
 #ifdef CONFIG_DM_VERITY_FEC
 
 /* each feature parameter requires a value */
-- 
2.52.0


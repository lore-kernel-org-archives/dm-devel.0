Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B92DD33EAED;
	Fri, 19 Dec 2025 19:32:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766172741; cv=none; b=P9Vuv1FTYQdoRKjsMFvI7KFC3tln8L/HoAic3W1zxUpfOfOWkje7sN/+YYiVU1NGChf7M7IT9bijOc4msIaK21kXrCl2tlupcc6MlmsBtmaZRt90pc6oaZqhcPZIQl8cM/VxCc4k2EhdHnQAmyZwh8qrkIHIz59UsPdEn9LA2UE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766172741; c=relaxed/simple;
	bh=27WRA6yZr/IoPqa8Uc7rKXp4/CC43O1x1GaZvzI01JA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OsNVJvOIg3KY5fQ5hjCqT0PdmM445ZoHQbzDb2aDU4VDgk841HZuFGD0ZBPgKrlcewDPB1FBvvY4q/cirXfG44IvLqd5mK4yqEzWd93GDlXVIr9xOmbLRDVuungDLgnwYSMq5G8yWFYK/+XOG3fvlTa8XtshCaHD0xqwRPqdS+o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=l4ixIwLM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="l4ixIwLM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8747C19421;
	Fri, 19 Dec 2025 19:32:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1766172740;
	bh=27WRA6yZr/IoPqa8Uc7rKXp4/CC43O1x1GaZvzI01JA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=l4ixIwLMFLip+jnlxxVRwYVm3Q8VlQVKh7PXFvAiI/cRSXHZEJro5Yo2jPo8sZdVJ
	 hLLaECPUipXkbT6l2LcETfBT3co1rbbsfRj4lkq0PguNUQeXd3a38qLa2AIIltupZb
	 dj/aTPHZ95VtyhjY2LFsF0eJ/S3axZHgGKfH0L2hnQCupF65n+QfK3bNdBaKPic8i+
	 R9Pb4m/3ydkowKR6bKApVwk31dvwk2jlCm0PbbpKsnYVIBzl24n6O0PoOLZUSOHHG8
	 vwfByvr8/hmBWHTQ8PHQX7Klqv2lDCofzznfjug08flGnen+0ez7V48z1yJkSGWJIX
	 A9vOKyAu0VDMw==
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
Subject: [PATCH v2 2/7] dm-verity: make dm_verity_fec_io::bufs variable-length
Date: Fri, 19 Dec 2025 11:29:04 -0800
Message-ID: <20251219192909.385494-3-ebiggers@kernel.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251219192909.385494-1-ebiggers@kernel.org>
References: <20251219192909.385494-1-ebiggers@kernel.org>
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
fec_for_each_extra_buffer() no longer apply, so remove them.  For
consistency, and because DM_VERITY_FEC_BUF_PREALLOC is fixed at 1 and
was already assumed to be 1 (considering that mempool_alloc() shouldn't
be called in a loop), also remove the related macros
DM_VERITY_FEC_BUF_PREALLOC and fec_for_each_prealloc_buffer().

Signed-off-by: Eric Biggers <ebiggers@kernel.org>
---
 drivers/md/dm-verity-fec.c | 44 +++++++++++++++++++-------------------
 drivers/md/dm-verity-fec.h | 15 +++++++------
 2 files changed, 31 insertions(+), 28 deletions(-)

diff --git a/drivers/md/dm-verity-fec.c b/drivers/md/dm-verity-fec.c
index 2c1544556a1c..6d0b5b4b2699 100644
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
@@ -305,24 +309,22 @@ static int fec_read_bufs(struct dm_verity *v, struct dm_verity_io *io,
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
+	fio->bufs[0] = mempool_alloc(&f->prealloc_pool, GFP_NOIO);
 
 	/* try to allocate the maximum number of buffers */
-	fec_for_each_extra_buffer(fio, n) {
+	for (n = 1; n < max_nbufs; n++) {
 		fio->bufs[n] = kmem_cache_alloc(f->cache, GFP_NOWAIT);
 		/* we can manage with even one buffer if necessary */
 		if (unlikely(!fio->bufs[n]))
 			break;
 	}
@@ -460,16 +462,14 @@ void __verity_fec_finish_io(struct dm_verity_io *io)
 	struct dm_verity_fec *f = io->v->fec;
 	struct dm_verity_fec_io *fio = io->fec_io;
 
 	mempool_free(fio->rs, &f->rs_pool);
 
-	fec_for_each_prealloc_buffer(n)
-		mempool_free(fio->bufs[n], &f->prealloc_pool);
+	mempool_free(fio->bufs[0], &f->prealloc_pool);
 
-	fec_for_each_extra_buffer(fio, n)
-		if (fio->bufs[n])
-			kmem_cache_free(f->cache, fio->bufs[n]);
+	for (n = 1; n < fio->nbufs; n++)
+		kmem_cache_free(f->cache, fio->bufs[n]);
 
 	mempool_free(fio->output, &f->output_pool);
 
 	mempool_free(fio, &f->fio_pool);
 	io->fec_io = NULL;
@@ -733,11 +733,12 @@ int verity_fec_ctr(struct dm_verity *v)
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
 
@@ -755,13 +756,12 @@ int verity_fec_ctr(struct dm_verity *v)
 	if (!f->cache) {
 		ti->error = "Cannot create FEC buffer cache";
 		return -ENOMEM;
 	}
 
-	/* Preallocate DM_VERITY_FEC_BUF_PREALLOC buffers for each thread */
-	ret = mempool_init_slab_pool(&f->prealloc_pool, num_online_cpus() *
-				     DM_VERITY_FEC_BUF_PREALLOC,
+	/* Preallocate one buffer for each thread */
+	ret = mempool_init_slab_pool(&f->prealloc_pool, num_online_cpus(),
 				     f->cache);
 	if (ret) {
 		ti->error = "Cannot allocate FEC buffer prealloc pool";
 		return ret;
 	}
diff --git a/drivers/md/dm-verity-fec.h b/drivers/md/dm-verity-fec.h
index b9488d1ddf14..571097438311 100644
--- a/drivers/md/dm-verity-fec.h
+++ b/drivers/md/dm-verity-fec.h
@@ -15,15 +15,11 @@
 #define DM_VERITY_FEC_RSM		255
 #define DM_VERITY_FEC_MAX_RSN		253
 #define DM_VERITY_FEC_MIN_RSN		231	/* ~10% space overhead */
 
 /* buffers for deinterleaving and decoding */
-#define DM_VERITY_FEC_BUF_PREALLOC	1	/* buffers to preallocate */
 #define DM_VERITY_FEC_BUF_RS_BITS	4	/* 1 << RS blocks per buffer */
-/* we need buffers for at most 1 << block size RS blocks */
-#define DM_VERITY_FEC_BUF_MAX \
-	(1 << (PAGE_SHIFT - DM_VERITY_FEC_BUF_RS_BITS))
 
 #define DM_VERITY_OPT_FEC_DEV		"use_fec_from_device"
 #define DM_VERITY_OPT_FEC_BLOCKS	"fec_blocks"
 #define DM_VERITY_OPT_FEC_START		"fec_start"
 #define DM_VERITY_OPT_FEC_ROOTS		"fec_roots"
@@ -50,14 +46,21 @@ struct dm_verity_fec {
 
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


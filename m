Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7364F2750E6;
	Tue, 16 Dec 2025 23:06:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765926419; cv=none; b=h+kaBW7pXmUvorMQreJ3kGEBumkG87IZ7t9PSFMvEVIgZu8MXEhKw9XT8pzI2UVatufPvxZ6fDct+D7hCT0iPqXSL8BPtDg/kSmzNdOD0Jz61DS/w8tkWw6o1fpt557UDzl/bVOj0gr/+RtXPupCTf88eEBKO5LTVlL01LqR/Ik=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765926419; c=relaxed/simple;
	bh=v3TmOU2giy1M/3cEnOwsB9EsF/UiB0CAx7I0S8XvV1c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rHgorI/jMZA84D7YWhoprdyBECA+sj2dSwZEvAUrN21riFPAsF5eZwNNK2A4bxGzxwuZRGxKkKTUdG82IZE42IMZwdGDsSQpK60/j1wZR1y0CWXtHDAMszlamBQAudmdZG0N3UiQFVR9f17wHmII8h/4inV7S+jQmKJ6CNCXpLA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=nHtsNufw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="nHtsNufw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE316C4CEF1;
	Tue, 16 Dec 2025 23:06:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1765926419;
	bh=v3TmOU2giy1M/3cEnOwsB9EsF/UiB0CAx7I0S8XvV1c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nHtsNufw8hrIxqB4m99cfb/UrZMtni/q1Y6tKq47eTMHzYhTd6UDEPyXK4ac026ix
	 whFpBUsdPXiQKWANJH3L89QcP8u0+kxUeLSF1BjFogP+zNAUMWyQdc+hiKfTCUUrPq
	 2awhy/i9r8pfxzrOp+Xyq1bZM/JWP+ZOtOKWyDyW60aAQnGiiMnXgT++dc2l1JD5sH
	 iLRU9ZSEmtOt/xDwdfbAmDTNnQsjLzDLZ1RaCLRBvfBv9ZOf47e/RWvcH/zo4pIBpx
	 r+Eyywc3DfLuYG5+IK2NBKFr4+yonrMmmZI9w34IS75Bn7MsJuAVxu7F1ex4QVKTLg
	 7VehyUP9EAxOQ==
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
Subject: [PATCH 1/7] dm-verity: move dm_verity_fec_io to mempool
Date: Tue, 16 Dec 2025 15:06:08 -0800
Message-ID: <20251216230614.51779-2-ebiggers@kernel.org>
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

Currently, struct dm_verity_fec_io is allocated in the front padding of
struct bio using dm_target::per_io_data_size.  Unfortunately, struct
dm_verity_fec_io is very large: 3096 bytes when CONFIG_64BIT=y &&
PAGE_SIZE == 4096, or 9240 bytes when CONFIG_64BIT=y && PAGE_SIZE ==
16384.  This makes the bio size very large.

Moreover, most of dm_verity_fec_io gets iterated over up to three times,
even on I/O requests that don't require any error correction:

1. To zero the memory on allocation, if init_on_alloc=1.  (This happens
   when the bio is allocated, not in dm-verity itself.)

2. To zero the buffers array in verity_fec_init_io().

3. To free the buffers in verity_fec_finish_io().

Fix all of these inefficiencies by moving dm_verity_fec_io to a mempool.
Replace the embedded dm_verity_fec_io with a pointer
dm_verity_io::fec_io.  verity_fec_init_io() initializes it to NULL,
verity_fec_decode() allocates it on the first call, and
verity_fec_finish_io() cleans it up.  The normal case is that the
pointer simply stays NULL, so the overhead becomes negligible.

Signed-off-by: Eric Biggers <ebiggers@kernel.org>
---
 drivers/md/dm-verity-fec.c | 95 +++++++++++++++-----------------------
 drivers/md/dm-verity-fec.h | 14 +++++-
 drivers/md/dm-verity.h     |  4 ++
 3 files changed, 53 insertions(+), 60 deletions(-)

diff --git a/drivers/md/dm-verity-fec.c b/drivers/md/dm-verity-fec.c
index c79de517afee..bf533ffa7d56 100644
--- a/drivers/md/dm-verity-fec.c
+++ b/drivers/md/dm-verity-fec.c
@@ -16,20 +16,10 @@
 bool verity_fec_is_enabled(struct dm_verity *v)
 {
 	return v->fec && v->fec->dev;
 }
 
-/*
- * Return a pointer to dm_verity_fec_io after dm_verity_io and its variable
- * length fields.
- */
-static inline struct dm_verity_fec_io *fec_io(struct dm_verity_io *io)
-{
-	return (struct dm_verity_fec_io *)
-		((char *)io + io->v->ti->per_io_data_size - sizeof(struct dm_verity_fec_io));
-}
-
 /*
  * Return an interleaved offset for a byte in RS block.
  */
 static inline u64 fec_interleave(struct dm_verity *v, u64 offset)
 {
@@ -209,11 +199,11 @@ static int fec_read_bufs(struct dm_verity *v, struct dm_verity_io *io,
 {
 	bool is_zero;
 	int i, j, target_index = -1;
 	struct dm_buffer *buf;
 	struct dm_bufio_client *bufio;
-	struct dm_verity_fec_io *fio = fec_io(io);
+	struct dm_verity_fec_io *fio = io->fec_io;
 	u64 block, ileaved;
 	u8 *bbuf, *rs_block;
 	u8 want_digest[HASH_MAX_DIGESTSIZE];
 	unsigned int n, k;
 	struct bio *bio = dm_bio_from_per_bio_data(io, v->ti->per_io_data_size);
@@ -305,43 +295,44 @@ static int fec_read_bufs(struct dm_verity *v, struct dm_verity_io *io,
 
 	return target_index;
 }
 
 /*
- * Allocate RS control structure and FEC buffers from preallocated mempools,
- * and attempt to allocate as many extra buffers as available.
+ * Allocate and initialize a struct dm_verity_fec_io to use for FEC for a bio.
+ * This runs the first time a block needs to be corrected for a bio.  In the
+ * common case where no block needs to be corrected, this code never runs.
+ *
+ * This always succeeds, as all required allocations are done from mempools.
+ * Additional buffers are also allocated opportunistically to improve error
+ * correction performance, but these aren't required to succeed.
  */
-static int fec_alloc_bufs(struct dm_verity *v, struct dm_verity_fec_io *fio)
+static struct dm_verity_fec_io *fec_alloc_and_init_io(struct dm_verity *v)
 {
+	struct dm_verity_fec *f = v->fec;
+	struct dm_verity_fec_io *fio;
 	unsigned int n;
 
-	if (!fio->rs)
-		fio->rs = mempool_alloc(&v->fec->rs_pool, GFP_NOIO);
+	fio = mempool_alloc(&f->fio_pool, GFP_NOIO);
+	fio->rs = mempool_alloc(&f->rs_pool, GFP_NOIO);
 
-	fec_for_each_prealloc_buffer(n) {
-		if (fio->bufs[n])
-			continue;
+	memset(fio->bufs, 0, sizeof(fio->bufs));
 
-		fio->bufs[n] = mempool_alloc(&v->fec->prealloc_pool, GFP_NOIO);
-	}
+	fec_for_each_prealloc_buffer(n)
+		fio->bufs[n] = mempool_alloc(&f->prealloc_pool, GFP_NOIO);
 
 	/* try to allocate the maximum number of buffers */
 	fec_for_each_extra_buffer(fio, n) {
-		if (fio->bufs[n])
-			continue;
-
-		fio->bufs[n] = kmem_cache_alloc(v->fec->cache, GFP_NOWAIT);
+		fio->bufs[n] = kmem_cache_alloc(f->cache, GFP_NOWAIT);
 		/* we can manage with even one buffer if necessary */
 		if (unlikely(!fio->bufs[n]))
 			break;
 	}
 	fio->nbufs = n;
 
-	if (!fio->output)
-		fio->output = mempool_alloc(&v->fec->output_pool, GFP_NOIO);
-
-	return 0;
+	fio->output = mempool_alloc(&f->output_pool, GFP_NOIO);
+	fio->level = 0;
+	return fio;
 }
 
 /*
  * Initialize buffers and clear erasures. fec_read_bufs() assumes buffers are
  * zeroed before deinterleaving.
@@ -366,14 +357,10 @@ static int fec_decode_rsb(struct dm_verity *v, struct dm_verity_io *io,
 			  const u8 *want_digest, bool use_erasures)
 {
 	int r, neras = 0;
 	unsigned int pos;
 
-	r = fec_alloc_bufs(v, fio);
-	if (unlikely(r < 0))
-		return r;
-
 	for (pos = 0; pos < 1 << v->data_dev_block_bits; ) {
 		fec_init_bufs(v, fio);
 
 		r = fec_read_bufs(v, io, rsb, offset, pos,
 				  use_erasures ? &neras : NULL);
@@ -406,16 +393,20 @@ static int fec_decode_rsb(struct dm_verity *v, struct dm_verity_io *io,
 int verity_fec_decode(struct dm_verity *v, struct dm_verity_io *io,
 		      enum verity_block_type type, const u8 *want_digest,
 		      sector_t block, u8 *dest)
 {
 	int r;
-	struct dm_verity_fec_io *fio = fec_io(io);
+	struct dm_verity_fec_io *fio;
 	u64 offset, res, rsb;
 
 	if (!verity_fec_is_enabled(v))
 		return -EOPNOTSUPP;
 
+	fio = io->fec_io;
+	if (!fio)
+		fio = io->fec_io = fec_alloc_and_init_io(v);
+
 	if (fio->level)
 		return -EIO;
 
 	fio->level++;
 
@@ -461,18 +452,15 @@ int verity_fec_decode(struct dm_verity *v, struct dm_verity_io *io,
 }
 
 /*
  * Clean up per-bio data.
  */
-void verity_fec_finish_io(struct dm_verity_io *io)
+void __verity_fec_finish_io(struct dm_verity_io *io)
 {
 	unsigned int n;
 	struct dm_verity_fec *f = io->v->fec;
-	struct dm_verity_fec_io *fio = fec_io(io);
-
-	if (!verity_fec_is_enabled(io->v))
-		return;
+	struct dm_verity_fec_io *fio = io->fec_io;
 
 	mempool_free(fio->rs, &f->rs_pool);
 
 	fec_for_each_prealloc_buffer(n)
 		mempool_free(fio->bufs[n], &f->prealloc_pool);
@@ -480,27 +468,12 @@ void verity_fec_finish_io(struct dm_verity_io *io)
 	fec_for_each_extra_buffer(fio, n)
 		if (fio->bufs[n])
 			kmem_cache_free(f->cache, fio->bufs[n]);
 
 	mempool_free(fio->output, &f->output_pool);
-}
-
-/*
- * Initialize per-bio data.
- */
-void verity_fec_init_io(struct dm_verity_io *io)
-{
-	struct dm_verity_fec_io *fio = fec_io(io);
-
-	if (!verity_fec_is_enabled(io->v))
-		return;
 
-	fio->rs = NULL;
-	memset(fio->bufs, 0, sizeof(fio->bufs));
-	fio->nbufs = 0;
-	fio->output = NULL;
-	fio->level = 0;
+	mempool_free(fio, &f->fio_pool);
 }
 
 /*
  * Append feature arguments and values to the status table.
  */
@@ -527,10 +500,11 @@ void verity_fec_dtr(struct dm_verity *v)
 	struct dm_verity_fec *f = v->fec;
 
 	if (!verity_fec_is_enabled(v))
 		goto out;
 
+	mempool_exit(&f->fio_pool);
 	mempool_exit(&f->rs_pool);
 	mempool_exit(&f->prealloc_pool);
 	mempool_exit(&f->output_pool);
 	kmem_cache_destroy(f->cache);
 
@@ -756,10 +730,18 @@ int verity_fec_ctr(struct dm_verity *v)
 	if (dm_bufio_get_device_size(f->data_bufio) < v->data_blocks) {
 		ti->error = "Data device is too small";
 		return -E2BIG;
 	}
 
+	/* Preallocate some dm_verity_fec_io structures */
+	ret = mempool_init_kmalloc_pool(&f->fio_pool, num_online_cpus(),
+					sizeof(struct dm_verity_fec_io));
+	if (ret) {
+		ti->error = "Cannot allocate FEC IO pool";
+		return ret;
+	}
+
 	/* Preallocate an rs_control structure for each worker thread */
 	ret = mempool_init(&f->rs_pool, num_online_cpus(), fec_rs_alloc,
 			   fec_rs_free, (void *) v);
 	if (ret) {
 		ti->error = "Cannot allocate RS pool";
@@ -789,10 +771,7 @@ int verity_fec_ctr(struct dm_verity *v)
 	if (ret) {
 		ti->error = "Cannot allocate FEC output pool";
 		return ret;
 	}
 
-	/* Reserve space for our per-bio data */
-	ti->per_io_data_size += sizeof(struct dm_verity_fec_io);
-
 	return 0;
 }
diff --git a/drivers/md/dm-verity-fec.h b/drivers/md/dm-verity-fec.h
index 5fd267873812..b9488d1ddf14 100644
--- a/drivers/md/dm-verity-fec.h
+++ b/drivers/md/dm-verity-fec.h
@@ -38,10 +38,11 @@ struct dm_verity_fec {
 	sector_t blocks;	/* number of blocks covered */
 	sector_t rounds;	/* number of interleaving rounds */
 	sector_t hash_blocks;	/* blocks covered after v->hash_start */
 	unsigned char roots;	/* number of parity bytes, M-N of RS(M, N) */
 	unsigned char rsn;	/* N of RS(M, N) */
+	mempool_t fio_pool;	/* mempool for dm_verity_fec_io */
 	mempool_t rs_pool;	/* mempool for fio->rs */
 	mempool_t prealloc_pool;	/* mempool for preallocated buffers */
 	mempool_t output_pool;	/* mempool for output */
 	struct kmem_cache *cache;	/* cache for buffers */
 	atomic64_t corrected; /* corrected errors */
@@ -69,12 +70,21 @@ extern int verity_fec_decode(struct dm_verity *v, struct dm_verity_io *io,
 			     sector_t block, u8 *dest);
 
 extern unsigned int verity_fec_status_table(struct dm_verity *v, unsigned int sz,
 					char *result, unsigned int maxlen);
 
-extern void verity_fec_finish_io(struct dm_verity_io *io);
-extern void verity_fec_init_io(struct dm_verity_io *io);
+extern void __verity_fec_finish_io(struct dm_verity_io *io);
+static inline void verity_fec_finish_io(struct dm_verity_io *io)
+{
+	if (unlikely(io->fec_io))
+		__verity_fec_finish_io(io);
+}
+
+static inline void verity_fec_init_io(struct dm_verity_io *io)
+{
+	io->fec_io = NULL;
+}
 
 extern bool verity_is_fec_opt_arg(const char *arg_name);
 extern int verity_fec_parse_opt_args(struct dm_arg_set *as,
 				     struct dm_verity *v, unsigned int *argc,
 				     const char *arg_name);
diff --git a/drivers/md/dm-verity.h b/drivers/md/dm-verity.h
index f975a9e5c5d6..4ad7ce3dae0a 100644
--- a/drivers/md/dm-verity.h
+++ b/drivers/md/dm-verity.h
@@ -102,10 +102,14 @@ struct dm_verity_io {
 	sector_t block;
 	unsigned int n_blocks;
 	bool in_bh;
 	bool had_mismatch;
 
+#ifdef CONFIG_DM_VERITY_FEC
+	struct dm_verity_fec_io *fec_io;
+#endif
+
 	struct work_struct work;
 	struct work_struct bh_work;
 
 	u8 tmp_digest[HASH_MAX_DIGESTSIZE];
 
-- 
2.52.0


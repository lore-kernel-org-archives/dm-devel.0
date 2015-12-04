From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [PATCH v2 0/2] dm verity: add support for error correction
Date: Fri, 4 Dec 2015 16:09:35 -0500
Message-ID: <20151204210935.GA63877@redhat.com>
References: <1446688954-29589-1-git-send-email-samitolvanen@google.com>
 <1449152791-33586-1-git-send-email-samitolvanen@google.com>
 <20151203195401.GA5444@redhat.com>
 <20151203230538.GB5444@redhat.com>
 <20151204100305.GA37949@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20151204100305.GA37949@google.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Sami Tolvanen <samitolvanen@google.com>
Cc: Mikulas Patocka <mpatocka@redhat.com>, Mandeep Baines <msb@chromium.org>, Will Drewry <wad@chromium.org>, Alasdair Kergon <agk@redhat.com>, dm-devel@redhat.com, linux-kernel@vger.kernel.org, Kees Cook <keescook@chromium.org>, Mark Salyzyn <salyzyn@google.com>
List-Id: dm-devel.ids

On Fri, Dec 04 2015 at  5:03P -0500,
Sami Tolvanen <samitolvanen@google.com> wrote:

> On Thu, Dec 03, 2015 at 06:05:38PM -0500, Mike Snitzer wrote:
> > If you're OK with those changes I'll fold that commit into your main FEC
> > commit.
> 
> Yes, these changes look fine. Thanks!

OK, I reviewed the FEC code and have staged it in linux-next with the
following fixes/tweaks/nits folded in.  Please let me know if you see
any problems with this (I'm obviously not an 80-columns zealot).

I'm going to carry on reviewing aspects of memory allocations, table
loads via ctr, etc.. but the code I've staged in linux-dm.git's
'for-next' is worth handing off to linux-next to see if it catches
anything, see:
https://git.kernel.org/cgit/linux/kernel/git/device-mapper/linux-dm.git/log/?h=for-next

I'd really appreciate it if you could do some regression testing, etc on
your end to verify I didn't break anything while tweaking things.

Thanks!

From: Mike Snitzer <snitzer@redhat.com>
Date: Fri, 4 Dec 2015 15:49:58 -0500
Subject: [PATCH] dm verity fec: whitespace fixes and other small nits

---
 drivers/md/dm-verity-fec.c | 153 +++++++++++++++++++--------------------------
 1 file changed, 65 insertions(+), 88 deletions(-)

diff --git a/drivers/md/dm-verity-fec.c b/drivers/md/dm-verity-fec.c
index a40ac01..e722ce5 100644
--- a/drivers/md/dm-verity-fec.c
+++ b/drivers/md/dm-verity-fec.c
@@ -69,18 +69,15 @@ static u8 *fec_read_parity(struct dm_verity *v, u64 rsb, int index,
 
 	position = (index + rsb) * v->fec->roots;
 	block = position >> v->data_dev_block_bits;
-
 	*offset = (unsigned)(position - (block << v->data_dev_block_bits));
 
 	res = dm_bufio_read(v->fec->bufio, v->fec->start + block, buf);
-
 	if (unlikely(IS_ERR(res))) {
 		DMERR("%s: FEC %llu: parity read failed (block %llu): %ld",
 		      v->data_dev->name, (unsigned long long)rsb,
 		      (unsigned long long)(v->fec->start + block),
 		      PTR_ERR(res));
 		*buf = NULL;
-		return NULL;
 	}
 
 	return res;
@@ -92,8 +89,7 @@ static u8 *fec_read_parity(struct dm_verity *v, u64 rsb, int index,
 
 /* Loop over each extra buffer slot. */
 #define fec_for_each_extra_buffer(io, __i) \
-	for (__i = DM_VERITY_FEC_BUF_PREALLOC; __i < DM_VERITY_FEC_BUF_MAX; \
-		__i++)
+	for (__i = DM_VERITY_FEC_BUF_PREALLOC; __i < DM_VERITY_FEC_BUF_MAX; __i++)
 
 /* Loop over each allocated buffer. */
 #define fec_for_each_buffer(io, __i) \
@@ -132,14 +128,14 @@ static int fec_decode_bufs(struct dm_verity *v, struct dm_verity_fec_io *fio,
 			   u64 rsb, int byte_index, unsigned block_offset,
 			   int neras)
 {
-	int r = -1, corrected = 0, res;
+	int r, corrected = 0, res;
 	struct dm_buffer *buf;
 	unsigned n, i, offset;
 	u8 *par, *block;
 
 	par = fec_read_parity(v, rsb, block_offset, &offset, &buf);
-	if (unlikely(!par))
-		return r;
+	if (IS_ERR(par))
+		return PTR_ERR(par);
 
 	/*
 	 * Decode the RS blocks we have in bufs. Each RS block results in
@@ -148,9 +144,12 @@ static int fec_decode_bufs(struct dm_verity *v, struct dm_verity_fec_io *fio,
 	fec_for_each_buffer_rs_block(fio, n, i) {
 		block = fec_buffer_rs_block(v, fio, n, i);
 		res = fec_decode_rs8(v, fio, block, &par[offset], neras);
+		if (res < 0) {
+			dm_bufio_release(buf);
 
-		if (res < 0)
+			r = res;
 			goto error;
+		}
 
 		corrected += res;
 		fio->output[block_offset] = block[byte_index];
@@ -164,25 +163,20 @@ static int fec_decode_bufs(struct dm_verity *v, struct dm_verity_fec_io *fio,
 		if (offset >= 1 << v->data_dev_block_bits) {
 			dm_bufio_release(buf);
 
-			par = fec_read_parity(v, rsb, block_offset, &offset,
-					      &buf);
-			if (unlikely(!par))
-				return r;
+			par = fec_read_parity(v, rsb, block_offset, &offset, &buf);
+			if (unlikely(IS_ERR(par)))
+				return PTR_ERR(par);
 		}
 	}
-
 done:
 	r = corrected;
 error:
-	dm_bufio_release(buf);
-
 	if (r < 0 && neras)
 		DMERR_LIMIT("%s: FEC %llu: failed to correct: %d",
 			    v->data_dev->name, (unsigned long long)rsb, r);
 	else if (r > 0)
 		DMWARN_LIMIT("%s: FEC %llu: corrected %d errors",
-			     v->data_dev->name, (unsigned long long)rsb,
-			     r);
+			     v->data_dev->name, (unsigned long long)rsb, r);
 
 	return r;
 }
@@ -204,7 +198,7 @@ static int fec_is_erasure(struct dm_verity *v, struct dm_verity_io *io,
 
 /*
  * Read data blocks that are part of the RS block and deinterleave as much as
- * fits into buffers. Check for erasure locations if neras is non-NULL.
+ * fits into buffers. Check for erasure locations if @neras is non-NULL.
  */
 static int fec_read_bufs(struct dm_verity *v, struct dm_verity_io *io,
 			 u64 rsb, u64 target, unsigned block_offset,
@@ -299,7 +293,6 @@ static int fec_read_bufs(struct dm_verity *v, struct dm_verity_io *io,
 			rs_block = fec_buffer_rs_block(v, fio, n, j);
 			rs_block[i] = bbuf[k];
 		}
-
 done:
 		dm_bufio_release(buf);
 	}
@@ -317,7 +310,6 @@ static int fec_alloc_bufs(struct dm_verity *v, struct dm_verity_fec_io *fio)
 
 	if (!fio->rs) {
 		fio->rs = mempool_alloc(v->fec->rs_pool, 0);
-
 		if (unlikely(!fio->rs)) {
 			DMERR("failed to allocate RS");
 			return -ENOMEM;
@@ -329,7 +321,6 @@ static int fec_alloc_bufs(struct dm_verity *v, struct dm_verity_fec_io *fio)
 			continue;
 
 		fio->bufs[n] = mempool_alloc(v->fec->prealloc_pool, GFP_NOIO);
-
 		if (unlikely(!fio->bufs[n])) {
 			DMERR("failed to allocate FEC buffer");
 			return -ENOMEM;
@@ -342,12 +333,10 @@ static int fec_alloc_bufs(struct dm_verity *v, struct dm_verity_fec_io *fio)
 			continue;
 
 		fio->bufs[n] = mempool_alloc(v->fec->extra_pool, GFP_NOIO);
-
 		/* we can manage with even one buffer if necessary */
 		if (unlikely(!fio->bufs[n]))
 			break;
 	}
-
 	fio->nbufs = n;
 
 	if (!fio->output) {
@@ -363,7 +352,7 @@ static int fec_alloc_bufs(struct dm_verity *v, struct dm_verity_fec_io *fio)
 }
 
 /*
- * Initialize buffers and clear erasures. fec_read_bufs assumes buffers are
+ * Initialize buffers and clear erasures. fec_read_bufs() assumes buffers are
  * zeroed before deinterleaving.
  */
 static void fec_init_bufs(struct dm_verity *v, struct dm_verity_fec_io *fio)
@@ -371,27 +360,26 @@ static void fec_init_bufs(struct dm_verity *v, struct dm_verity_fec_io *fio)
 	unsigned n;
 
 	fec_for_each_buffer(fio, n)
-		memset(fio->bufs[n], 0,
-		       v->fec->rsn << DM_VERITY_FEC_BUF_RS_BITS);
+		memset(fio->bufs[n], 0, v->fec->rsn << DM_VERITY_FEC_BUF_RS_BITS);
 
 	memset(fio->erasures, 0, sizeof(fio->erasures));
 }
 
 /*
  * Decode all RS blocks in a single data block and return the target block
- * (indicated by "offset") in fio->output. If use_erasures is non-zero, uses
+ * (indicated by @offset) in fio->output. If @use_erasures is non-zero, uses
  * hashes to locate erasures.
  */
 static int fec_decode_rsb(struct dm_verity *v, struct dm_verity_io *io,
 			  struct dm_verity_fec_io *fio, u64 rsb, u64 offset,
-			  int use_erasures)
+			  bool use_erasures)
 {
 	int r, neras = 0;
 	unsigned pos;
 
 	r = fec_alloc_bufs(v, fio);
 	if (unlikely(r < 0))
-		return -1;
+		return r;
 
 	for (pos = 0; pos < 1 << v->data_dev_block_bits; ) {
 		fec_init_bufs(v, fio);
@@ -418,9 +406,8 @@ static int fec_decode_rsb(struct dm_verity *v, struct dm_verity_io *io,
 	if (memcmp(verity_io_real_digest(v, io), verity_io_want_digest(v, io),
 		   v->digest_size)) {
 		DMERR_LIMIT("%s: FEC %llu: failed to correct (%d erasures)",
-			    v->data_dev->name, (unsigned long long)rsb,
-			    neras);
-		return -1;
+			    v->data_dev->name, (unsigned long long)rsb, neras);
+		return -EILSEQ;
 	}
 
 	return 0;
@@ -445,12 +432,12 @@ int verity_fec_decode(struct dm_verity *v, struct dm_verity_io *io,
 		      enum verity_block_type type, sector_t block, u8 *dest,
 		      struct bvec_iter *iter)
 {
-	int r = -1;
+	int r;
 	struct dm_verity_fec_io *fio = fec_io(io);
 	u64 offset, res, rsb;
 
 	if (!verity_fec_is_enabled(v))
-		return -1;
+		return -EOPNOTSUPP;
 
 	if (type == DM_VERITY_BLOCK_TYPE_METADATA)
 		block += v->data_blocks;
@@ -481,12 +468,12 @@ int verity_fec_decode(struct dm_verity *v, struct dm_verity_io *io,
 	 * them first. Do a second attempt with erasures if the corruption is
 	 * bad enough.
 	 */
-	r = fec_decode_rsb(v, io, fio, rsb, offset, 0);
-	if (r < 0)
-		r = fec_decode_rsb(v, io, fio, rsb, offset, 1);
-
-	if (r < 0)
-		return r;
+	r = fec_decode_rsb(v, io, fio, rsb, offset, false);
+	if (r < 0) {
+		r = fec_decode_rsb(v, io, fio, rsb, offset, true);
+		if (r < 0)
+			return r;
+	}
 
 	if (dest)
 		memcpy(dest, fio->output, 1 << v->data_dev_block_bits);
@@ -577,7 +564,6 @@ void verity_fec_dtr(struct dm_verity *v)
 
 	if (f->dev)
 		dm_put_device(v->ti, f->dev);
-
 out:
 	kfree(f);
 	v->fec = NULL;
@@ -610,13 +596,14 @@ int verity_fec_parse_opt_args(struct dm_arg_set *as, struct dm_verity *v,
 			      unsigned *argc, const char *arg_name)
 {
 	int r;
+	struct dm_target *ti = v->ti;
 	const char *arg_value;
 	unsigned long long num_ll;
 	unsigned char num_c;
 	char dummy;
 
 	if (!*argc) {
-		v->ti->error = "FEC feature arguments require a value";
+		ti->error = "FEC feature arguments require a value";
 		return -EINVAL;
 	}
 
@@ -624,9 +611,9 @@ int verity_fec_parse_opt_args(struct dm_arg_set *as, struct dm_verity *v,
 	(*argc)--;
 
 	if (!strcasecmp(arg_name, DM_VERITY_OPT_FEC_DEV)) {
-		r = dm_get_device(v->ti, arg_value, FMODE_READ, &v->fec->dev);
+		r = dm_get_device(ti, arg_value, FMODE_READ, &v->fec->dev);
 		if (r) {
-			v->ti->error = "FEC device lookup failed";
+			ti->error = "FEC device lookup failed";
 			return r;
 		}
 
@@ -634,7 +621,7 @@ int verity_fec_parse_opt_args(struct dm_arg_set *as, struct dm_verity *v,
 		if (sscanf(arg_value, "%llu%c", &num_ll, &dummy) != 1 ||
 		    ((sector_t)(num_ll << (v->data_dev_block_bits - SECTOR_SHIFT))
 		     >> (v->data_dev_block_bits - SECTOR_SHIFT) != num_ll)) {
-			v->ti->error = "Invalid " DM_VERITY_OPT_FEC_BLOCKS;
+			ti->error = "Invalid " DM_VERITY_OPT_FEC_BLOCKS;
 			return -EINVAL;
 		}
 		v->fec->blocks = num_ll;
@@ -643,7 +630,7 @@ int verity_fec_parse_opt_args(struct dm_arg_set *as, struct dm_verity *v,
 		if (sscanf(arg_value, "%llu%c", &num_ll, &dummy) != 1 ||
 		    ((sector_t)(num_ll << (v->data_dev_block_bits - SECTOR_SHIFT)) >>
 		     (v->data_dev_block_bits - SECTOR_SHIFT) != num_ll)) {
-			v->ti->error = "Invalid " DM_VERITY_OPT_FEC_START;
+			ti->error = "Invalid " DM_VERITY_OPT_FEC_START;
 			return -EINVAL;
 		}
 		v->fec->start = num_ll;
@@ -652,13 +639,13 @@ int verity_fec_parse_opt_args(struct dm_arg_set *as, struct dm_verity *v,
 		if (sscanf(arg_value, "%hhu%c", &num_c, &dummy) != 1 || !num_c ||
 		    num_c < (DM_VERITY_FEC_RSM - DM_VERITY_FEC_MAX_RSN) ||
 		    num_c > (DM_VERITY_FEC_RSM - DM_VERITY_FEC_MIN_RSN)) {
-			v->ti->error = "Invalid " DM_VERITY_OPT_FEC_ROOTS;
+			ti->error = "Invalid " DM_VERITY_OPT_FEC_ROOTS;
 			return -EINVAL;
 		}
 		v->fec->roots = num_c;
 
 	} else {
-		v->ti->error = "Unrecognized verity FEC feature request";
+		ti->error = "Unrecognized verity FEC feature request";
 		return -EINVAL;
 	}
 
@@ -677,8 +664,8 @@ int verity_fec_ctr_alloc(struct dm_verity *v)
 		v->ti->error = "Cannot allocate FEC structure";
 		return -ENOMEM;
 	}
-
 	v->fec = f;
+
 	return 0;
 }
 
@@ -689,6 +676,7 @@ int verity_fec_ctr_alloc(struct dm_verity *v)
 int verity_fec_ctr(struct dm_verity *v)
 {
 	struct dm_verity_fec *f = v->fec;
+	struct dm_target *ti = v->ti;
 	u64 hash_blocks;
 
 	if (!verity_fec_is_enabled(v)) {
@@ -718,24 +706,22 @@ int verity_fec_ctr(struct dm_verity *v)
 	 * simplicity.
 	 */
 	if (v->data_dev_block_bits != v->hash_dev_block_bits) {
-		v->ti->error = "Block sizes must match to use FEC";
+		ti->error = "Block sizes must match to use FEC";
 		return -EINVAL;
 	}
 
 	if (!f->roots) {
-		v->ti->error = "Missing " DM_VERITY_OPT_FEC_ROOTS;
+		ti->error = "Missing " DM_VERITY_OPT_FEC_ROOTS;
 		return -EINVAL;
 	}
-
 	f->rsn = DM_VERITY_FEC_RSM - f->roots;
 
 	if (!f->blocks) {
-		v->ti->error = "Missing " DM_VERITY_OPT_FEC_BLOCKS;
+		ti->error = "Missing " DM_VERITY_OPT_FEC_BLOCKS;
 		return -EINVAL;
 	}
 
 	f->rounds = f->blocks;
-
 	if (do_div(f->rounds, f->rsn))
 		f->rounds++;
 
@@ -744,7 +730,7 @@ int verity_fec_ctr(struct dm_verity *v)
 	 * data_blocks and hash_blocks combined.
 	 */
 	if (f->blocks < v->data_blocks + hash_blocks || !f->rounds) {
-		v->ti->error = "Invalid " DM_VERITY_OPT_FEC_BLOCKS;
+		ti->error = "Invalid " DM_VERITY_OPT_FEC_BLOCKS;
 		return -EINVAL;
 	}
 
@@ -753,89 +739,80 @@ int verity_fec_ctr(struct dm_verity *v)
 	 * it to be large enough.
 	 */
 	f->hash_blocks = f->blocks - v->data_blocks;
-
 	if (dm_bufio_get_device_size(v->bufio) < f->hash_blocks) {
-		v->ti->error = "Hash device is too small for "
-				DM_VERITY_OPT_FEC_BLOCKS;
+		ti->error = "Hash device is too small for "
+			DM_VERITY_OPT_FEC_BLOCKS;
 		return -E2BIG;
 	}
 
 	f->bufio = dm_bufio_client_create(f->dev->bdev,
-				1 << v->data_dev_block_bits,
-				1, 0, NULL, NULL);
-
+					  1 << v->data_dev_block_bits,
+					  1, 0, NULL, NULL);
 	if (IS_ERR(f->bufio)) {
-		v->ti->error = "Cannot initialize dm-bufio";
+		ti->error = "Cannot initialize FEC bufio client";
 		return PTR_ERR(f->bufio);
 	}
 
 	if (dm_bufio_get_device_size(f->bufio) <
-			(f->start + f->rounds * f->roots)
-				>> v->data_dev_block_bits) {
-		v->ti->error = "FEC device is too small";
+	    ((f->start + f->rounds * f->roots) >> v->data_dev_block_bits)) {
+		ti->error = "FEC device is too small";
 		return -E2BIG;
 	}
 
 	f->data_bufio = dm_bufio_client_create(v->data_dev->bdev,
-				1 << v->data_dev_block_bits,
-				1, 0, NULL, NULL);
-
+					       1 << v->data_dev_block_bits,
+					       1, 0, NULL, NULL);
 	if (IS_ERR(f->data_bufio)) {
-		v->ti->error = "Cannot initialize dm-bufio";
+		ti->error = "Cannot initialize FEC data bufio client";
 		return PTR_ERR(f->data_bufio);
 	}
 
 	if (dm_bufio_get_device_size(f->data_bufio) < v->data_blocks) {
-		v->ti->error = "Data device is too small";
+		ti->error = "Data device is too small";
 		return -E2BIG;
 	}
 
 	/* Preallocate an rs_control structure for each worker thread */
 	f->rs_pool = mempool_create(num_online_cpus(), fec_rs_alloc,
-				fec_rs_free, (void *) v);
-
+				    fec_rs_free, (void *) v);
 	if (!f->rs_pool) {
-		v->ti->error = "Cannot allocate RS pool";
+		ti->error = "Cannot allocate RS pool";
 		return -ENOMEM;
 	}
 
 	f->cache = kmem_cache_create("dm_verity_fec_buffers",
-				f->rsn << DM_VERITY_FEC_BUF_RS_BITS,
-				0, 0, NULL);
-
+				     f->rsn << DM_VERITY_FEC_BUF_RS_BITS,
+				     0, 0, NULL);
 	if (!f->cache) {
-		v->ti->error = "Cannot create FEC buffer cache";
+		ti->error = "Cannot create FEC buffer cache";
 		return -ENOMEM;
 	}
 
 	/* Preallocate DM_VERITY_FEC_BUF_PREALLOC buffers for each thread */
 	f->prealloc_pool = mempool_create_slab_pool(num_online_cpus() *
-						DM_VERITY_FEC_BUF_PREALLOC,
-					f->cache);
-
+						    DM_VERITY_FEC_BUF_PREALLOC,
+						    f->cache);
 	if (!f->prealloc_pool) {
-		v->ti->error = "Cannot allocate FEC buffer prealloc pool";
+		ti->error = "Cannot allocate FEC buffer prealloc pool";
 		return -ENOMEM;
 	}
 
 	f->extra_pool = mempool_create_slab_pool(0, f->cache);
-
 	if (!f->extra_pool) {
-		v->ti->error = "Cannot allocate FEC buffer extra pool";
+		ti->error = "Cannot allocate FEC buffer extra pool";
 		return -ENOMEM;
 	}
 
 	/* Preallocate an output buffer for each thread */
 	f->output_pool = mempool_create_kmalloc_pool(num_online_cpus(),
-					1 << v->data_dev_block_bits);
-
+						     1 << v->data_dev_block_bits);
 	if (!f->output_pool) {
-		v->ti->error = "Cannot allocate FEC output pool";
+		ti->error = "Cannot allocate FEC output pool";
 		return -ENOMEM;
 	}
 
 	/* Reserve space for our per-bio data */
-	v->ti->per_bio_data_size += sizeof(struct dm_verity_fec_io);
+	ti->per_bio_data_size += sizeof(struct dm_verity_fec_io);
 
 	return 0;
 }
-- 
2.4.9 (Apple Git-60)

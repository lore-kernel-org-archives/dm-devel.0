Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795731695;
	b=xGE9VGQXL9sjETA3+8zIyzRmsRtpj9nAm2gO428lqJ5F2K49jiqNfcPLeaN259hWTOeX
	 Epg5o3vU578qTjBLyhwpIHWEbB8o543DwLYm74IyGTzlbERk5+44uGwF9E64H7x0D+Ute
	 E3SmQ/QQVutHZuYPE8nXsLuFi02QPb+EcZGJpzV97clLylGuEIHD3do7Z+rKokj4AAnz+
	 owQCInq4W3BEusGsWvqrfBgBdgQbML9+4LmllIRlXYJ52nVwWiHWF0TpFWtumeKtPiCBb
	 OHzDuSPw1ixymsRmLjXZ3DZLJLrfget3ONLCPx1J5nD3Os/wj/207f2LJvSvDrn6r1A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795731695;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=jUFf7675L+88M5bJsmdukH1q+Bf+r2FveQFgo6l6yZs=;
	b=3W2jjeSX4BR4BfoqzXt6GL4UuqutRF9eYFbKQvLcjKcvMSB7bURIGdH9wslT9RKWa2J4
	 a45JfOON3nkQQbAzpaiypM8HPHJTSHZr9ETkACGhdUk9cQ/x1MQtaqbLlP9WTzLvx0oPW
	 x6QPa3PdLXLu4cawOlMNybsKyR6+3Sm65igQBzvezNlntQO7oia9McU9kWw3r+6ZKSplT
	 SSGpLd0ku9Z7orU2IsGP17h1xUj4J3sa5PLSZCRMrGaORn8p8w3Eqh8DZwBq8f/lPP7C4
	 +/iF2meLQjayYSRoLhcHSAyX37JcNpDOP8qgGCEZ+5pOnkxgwxs11DJarVOS9p0UrYg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=c8hi1PhV;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78E3D606A31E
	for <dm-devel@lists.linux.dev>; Thu, 26 Nov 2026 22:21:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=c8hi1PhV
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9CD781F000C1;
	Thu, 26 Nov 2026 22:21:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795731695;
	bh=jUFf7675L+88M5bJsmdukH1q+Bf+r2FveQFgo6l6yZs=;
	h=From:Subject:Reply-To:To:In-Reply-To:References:Date;
	b=c8hi1PhVtXaIZzjjV6o7YMv/ePplgORE22LtjBU014sLqaH9aH9IdPCFOqwsMKZJT
	 0xte94oojbR408qpPZXqe64MKQaX+ni/UIhptMdeBIyjnbdA3e1G0LfuR8PDvLLi3s
	 XDJDoY8BkQ2Qks9yRblGNTXPw4Adkq2LfXfLXfNAm0EpdttW5fSkRIazLkxiodQHTe
	 LDjk53yfIzL9K7zDlMjFrZVZTQm7cu872zNEIV8NUjVqAFMuvgqg4wWe3Dmt4RcN5L
	 6IUHoaKU0ZertkMrm/TNuCxmoWbSnn0u1hezmM9qfRasIClGO57YXnTHFiiCY+YSQF
	 S+8w8pXotvrIg==
Message-ID: <sashiko-outbox-236293@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2] dm-compress: introduce the dm-compress target
Reply-To: sashiko-reviews@lists.linux.dev
To: "Mikulas Patocka" <mpatocka@redhat.com>, "Alasdair Kergon" <agk@redhat.com>, "Mike
 Snitzer" <snitzer@kernel.org>, "Benjamin Marzinski" <bmarzins@redhat.com>, "Eric
 Biggers" <ebiggers@kernel.org>, "Ming-Hung Tsai" <mtsai@redhat.com>, "Zdenek
 Kabelac" <zkabelac@redhat.com>, "Filip Suba" <fsuba@redhat.com>, dm-devel@lists.linux.dev
In-Reply-To: <275c8a42-b281-8e68-eaef-05a1ea3eba16@redhat.com>
References: <275c8a42-b281-8e68-eaef-05a1ea3eba16@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 26 Nov 2026 22:21:34 +0000
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Post: <mailto:dm-devel@lists.linux.dev>
List-Help: <mailto:dm-devel+help@lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
List-Owner: <mailto:dm-devel+owner@lists.linux.dev>
Precedence: list

Thank you for your contribution! Sashiko AI review found 13 potential
issues to consider:
- [High] dm-compress: bio reordering and blocking in
  dm_compress_pick_dio_for_chunk()
- [High] dm-compress: flush bios collide with chunk 0 in
  dm_compress_setup_flush()
- [Medium] dm-compress: stale c->n_blocks in
  dm_compress_resize_bitmaps() on small resize
- [Medium] dm-compress: missing vmap cache flush and bv_offset in
  cc->bio I/O
- [Medium] dm-compress: uninitialized memory written to disk in split
  sub-blocks
- [Medium] dm-compress: failed or unwritten clean chunks fail waiting
  writes on eviction
- [Medium] dm-compress: serialized cache eviction on c->lru.prev in
  process_chunk()
- [Medium] dm-compress: missing upper bound on n_chunks in
  dm_compress_ctr()
- [Medium] dm-compress: global mutex held across sync I/O in
  dm_compress_process_chunk()
- [Medium] dm-compress: single-CPU pinning on WQ_PERCPU compress_wq and
  extra wakeups
- [Medium] dm-compress: polling sleep in dm_compress_postsuspend() and
  high-order mempool
- [Medium] dm-compress: excessive workspace allocation in
  dm_compress_alloc_cached_chunk()
- [Low] dm-compress: outdated algorithm list and missing commit_time in
  dm-compress.rst
--

commit 5efe61997193e272b0ef53f7013815a0776520a4
Author: Mikulas Patocka <mpatocka@redhat.com>

dm-compress: introduce the dm-compress target

This commit introduces the dm-compress device-mapper target for transparent
block device compression and decompression, along with a
dm_bufio_forget_buffers_forced() helper in dm-bufio.

> diff --git a/Documentation/admin-guide/device-mapper/dm-compress.rst b/Do=
cumentation/admin-guide/device-mapper/dm-compress.rst
> new file mode 100644
> index 0000000000000..606e93cc5b577
> --- /dev/null
> +++ b/Documentation/admin-guide/device-mapper/dm-compress.rst
[ ... ]
> @@ -0,0 +1,61 @@
[ ... ]
> +6. the compression algorithm - the supported algorithms are:
> +   deflate, lzo, 842, lz4, lz4hc, zstd
> +
> +7. the number of additional arguments
> +
> +Additional arguments:
> +
> +meta_device:device
> +	Store metadata on a separate device
> +
> +n_cached_chunks:number (default 128)
> +	The number of cached decompressed chunks that is kept in memory. The
> +	cached chunks are preallocated when the target is loaded. The memory
> +	consumption of the target is n_cached_chunks*chunk_size*3.

[Severity: Low]
dm_compress_algorithms[] only implements lz4, lz4hc, and zstd, so passing
deflate, lzo, or 842 to dm_compress_ctr() fails with -EINVAL.  Also, the
optional commit_time:<msec> argument accepted by dm_compress_ctr() is not
listed under Additional arguments.

> diff --git a/drivers/md/dm-compress/algorithms.c b/drivers/md/dm-compress=
/algorithms.c
> new file mode 100644
> index 0000000000000..5e5758a9cb790
> --- /dev/null
> +++ b/drivers/md/dm-compress/algorithms.c
[ ... ]
> @@ -0,0 +1,130 @@
[ ... ]
> +static void *zstd_allocate_context(gfp_t gfp)
> +{
> +	zstd_parameters params;
> +	size_t wksp_size;
> +	struct zstd_ctx *ctx;
> +
> +	params =3D zstd_get_params(ZSTD_DEF_LEVEL, ZSTD_MAX_SIZE);
> +	wksp_size =3D max(zstd_cstream_workspace_bound(&params.cParams),
> +			zstd_dstream_workspace_bound(ZSTD_MAX_SIZE));

[Severity: Medium]
Should zstd_allocate_context() size the workspace with
zstd_cctx_workspace_bound() and zstd_dctx_workspace_bound() for the
configured chunk size instead of streaming bounds at a hardcoded 256 KiB
ZSTD_MAX_SIZE?

zstd_compress() and zstd_decompress() only use single-pass zstd_init_cctx()
and zstd_init_dctx(), so streaming bounds allocate ~512 KiB of unused
stream buffers per context, while hardcoding ZSTD_MAX_SIZE over-allocates
tables for small chunks and caps windowLog at 256 KiB for 512 KiB and 1 MiB
chunks.  In addition, dm_compress_alloc_cached_chunk() allocates full
workspaces for all three algorithms (~1.9 MiB per cached chunk, or ~243 MiB
for the default 128 chunks) even though compression only uses c->algorithm
and LZ4 decompression does not use a context.

> diff --git a/drivers/md/dm-compress/alloc.c b/drivers/md/dm-compress/allo=
c.c
> new file mode 100644
> index 0000000000000..e68a681be2310
> --- /dev/null
> +++ b/drivers/md/dm-compress/alloc.c
[ ... ]
> @@ -0,0 +1,505 @@
[ ... ]
> +	while (current_size < new_size) {
> +		struct dm_buffer *bp;
> +		size_t group_ptr, dir_ptr;
> +		unsigned dir_offset, bmp_offset;
> +		sector_t dir_block, bmp_block;
> +		struct directory *dir;
> +		__u64 *working_copy, *stable_copy;
> +		unsigned need_sectors;
> +
> +		block_location(c, current_size, &group_ptr, &dir_ptr, &dir_offset, &bm=
p_offset);
> +
> +		need_sectors =3D 0;
> +		if (!bmp_offset && !dir_offset)
> +			need_sectors =3D BUFFER_SECTORS * 2;
> +		else if (!bmp_offset)
> +			need_sectors =3D BUFFER_SECTORS;
> +		if (n_allocated_sectors < need_sectors) {
> +			sector_t existing_size;
> +			if (c->meta_dev) {
> +				dm_compress_error(c, "The metadata device is too small", -ENOSPC);
> +				return -ENOSPC;
> +			}
> +			existing_size =3D current_size;
> +align_allocated:
> +			allocated_sector =3D current_size << c->log2_sectors_per_block;
> +			n_allocated_sectors =3D 0;
> +			if (allocated_sector & (BUFFER_SECTORS - 1)) {
> +				if (current_size >=3D new_size) {
> +					current_size =3D existing_size;
> +					goto finish;
> +				}
> +				current_size++;
> +				goto align_allocated;
> +			}
> +			while (n_allocated_sectors < need_sectors) {
> +				if (current_size >=3D new_size) {
> +					current_size =3D existing_size;
> +					goto finish;
> +				}
> +				current_size++;
> +				n_allocated_sectors +=3D 1 << c->log2_sectors_per_block;
> +			}
> +		}
[ ... ]
> +finish:
> +	if (did_something) {
> +		bool b;
> +		*need_sync =3D true;
> +		b =3D !CC_VALID(c, &sb->n_cc_txc);
> +		if (unlikely(!CC_CURRENT(c, &sb->n_cc_txc))) {
> +			CC_SET_CURRENT(c, &sb->n_cc_txc);
> +			WARN_ON(b !=3D CC_VALID(c, &sb->n_cc_txc));
> +			sb->n_blocks[!b] =3D sb->n_blocks[b];
> +			sb->n_chunks[!b] =3D sb->n_chunks[b];
> +			sb->n_used_metadata_blocks[!b] =3D sb->n_used_metadata_blocks[b];
> +			b =3D !b;
> +		}
> +		sb->n_blocks[b] =3D cpu_to_le64(current_size);
> +		if (c->meta_dev)
> +			sb->n_used_metadata_blocks[b] =3D cpu_to_le64(allocated_sector / BUFF=
ER_SECTORS);
> +		r =3D dm_compress_sync_rw_metadata(c, REQ_OP_WRITE, DM_IO_KMEM, 0, c->=
sb, SB_SECTORS);
> +		if (r) {
> +			dm_compress_error(c, "Error writing superblock", r);
> +			return r;
> +		}
> +		c->n_blocks =3D current_size;
> +	}
> +	return 0;
> +}

[Severity: Medium]
What happens in dm_compress_resize_bitmaps() when a single-device target at
a bitmap boundary is grown by fewer sectors than need_sectors?

The alignment/allocation loop restores current_size =3D existing_size and
jumps to finish with did_something =3D=3D false, leaving c->n_blocks set to
new_size (and c->n_groups sized for new_size).  The subsequent calls in
dm_compress_preresume() to load_bitmap_directories(c, c->n_blocks) and
dm_compress_get_free_space(c) then read the unallocated zero pointer (block
0, the superblock) as a bitmap or directory buffer and fail with -EUCLEAN,
disabling the device.

Separately, in modify_bitmap() and dm_compress_prepare_chunk(),
CC_SET_CURRENT() updates cc_txc before the committed slot is copied into
the backup slot.

> diff --git a/drivers/md/dm-compress/cc.c b/drivers/md/dm-compress/cc.c
> new file mode 100644
> index 0000000000000..4be1c38234877
> --- /dev/null
> +++ b/drivers/md/dm-compress/cc.c
[ ... ]
> @@ -0,0 +1,214 @@
[ ... ]
> +	cc->compressed_data =3D __vmalloc(512UL << c->log2_sectors_per_chunk, G=
FP_KERNEL);
> +	if (!cc->compressed_data)
> +		goto free_fail;
> +
> +	cc->merging_data =3D __vmalloc(512UL << c->log2_sectors_per_chunk, GFP_=
KERNEL);
> +	if (!cc->merging_data)
> +		goto free_fail;
> +
> +	if (is_vmalloc_addr(cc->compressed_data)) {
> +		cc->bio_vectors =3D DIV_ROUND_UP(512UL << c->log2_sectors_per_chunk, P=
AGE_SIZE);
> +		cc->bio =3D bio_kmalloc(cc->bio_vectors, GFP_KERNEL);
> +		if (!cc->bio)
> +			goto free_fail;
> +		bv =3D bio_inline_vecs(cc->bio);
> +		for (v =3D 0; v < cc->bio_vectors; v++) {
> +			bv[v].bv_page =3D vmalloc_to_page(cc->compressed_data + (size_t)v * P=
AGE_SIZE);
> +			bv[v].bv_len =3D PAGE_SIZE;
> +			bv[v].bv_offset =3D 0;
> +		}
> +	} else {
> +		cc->bio_vectors =3D 1;
> +		cc->bio =3D bio_kmalloc(cc->bio_vectors, GFP_KERNEL);
> +		if (!cc->bio)
> +			goto free_fail;
> +		bv =3D bio_inline_vecs(cc->bio);
> +		bv[0].bv_page =3D virt_to_page(cc->compressed_data);
> +		bv[0].bv_len =3D 512UL << c->log2_sectors_per_chunk;
> +		bv[0].bv_offset =3D 0;
> +	}

[Severity: Medium]
Does submitting cc->bio directly on vmalloc-backed cc->compressed_data
pages need flush_kernel_vmap_range() before REQ_OP_WRITE in
dm_compress_allocate_chunk() and invalidate_kernel_vmap_range() before CPU
decompression reads cc->compressed_data?

Without vmap cache maintenance, architectures with virtually indexed caches
that implement ARCH_IMPLEMENTS_FLUSH_KERNEL_VMAP_RANGE can see stale cache
aliases and corrupt compressed data.  Also, in the !is_vmalloc_addr()
branch, hardcoding bv[0].bv_offset =3D 0 instead of
offset_in_page(cc->compressed_data) uses the wrong page offset if a small
chunk allocation is not page-aligned.

[ ... ]

> +void dm_compress_wait_for_cached_chunk(struct dm_compress_io *dio)
> +{
> +	struct dm_compress *c =3D dio->c;
> +	struct rb_node *parent, **node;
> +
> +	list_add(&dio->waiting_list_entry, &c->waiting_bio_lru);
> +
> +	parent =3D NULL;
> +	node =3D &c->waiting_bio_tree.rb_node;
> +
> +	while (*node) {
> +		struct dm_compress_io *tdio =3D container_of(*node, struct dm_compress=
_io, tree_entry);
> +		parent =3D &tdio->tree_entry;
> +		if (tdio->chunk > dio->chunk) {
> +			node =3D &parent->rb_left;
> +		} else {
> +			node =3D &parent->rb_right;
> +		}
> +	}
> +
> +	rb_link_node(&dio->tree_entry, parent, node);
> +	rb_insert_color(&dio->tree_entry, &c->waiting_bio_tree);
> +}
> +
> +struct dm_compress_io *dm_compress_pick_dio_for_chunk(struct dm_compress=
 *c, sector_t chunk)
> +{
> +	struct rb_node *node =3D c->waiting_bio_tree.rb_node;
> +
> +	while (node) {
> +		struct dm_compress_io *tdio =3D container_of(node, struct dm_compress_=
io, tree_entry);
> +		if (tdio->chunk =3D=3D chunk) {
> +			return tdio;
> +		}
> +		if (tdio->chunk > chunk)
> +			node =3D tdio->tree_entry.rb_left;
> +		else
> +			node =3D tdio->tree_entry.rb_right;
> +	}
> +
> +	return NULL;
> +}

[Severity: High]
Can rb-tree rotations on c->waiting_bio_tree cause
dm_compress_pick_dio_for_chunk() to return waiting bios for the same chunk
out of submission order?

dm_compress_wait_for_cached_chunk() inserts duplicate chunk keys down
rb_right, and rb_insert_color() / rb_erase() rotations can move a newer
dio above an older dio with the same chunk key.
dm_compress_pick_dio_for_chunk() returns the highest node matching chunk
rather than the oldest one, so waiting writes and reads on the same chunk
can be reordered and overwrite newer data with older data.

When dm_compress_chunk_decompress() calls
dm_compress_process_bios_on_chunk() while cc->intent is INTENT_WRITE or
INTENT_FREE, picking a waiting write or discard before a waiting read also
causes dm_compress_process_chunk() to return false and break out of the
loop before the read is served, after which the chunk is written out and
evicted.

In addition, dm_compress_chunk_work_2() only calls
dm_compress_process_pending_ios(), which stops immediately if oldest_dio is
still blocked on a different chunk instead of waking bios waiting on
cc->chunk, and the flush guard in dm_compress_process_chunk() only checks
oldest_dio->is_flush, allowing new writes to bypass a queued flush when an
older non-flush bio sits ahead of it in c->waiting_bio_lru.

> diff --git a/drivers/md/dm-compress/chunk.c b/drivers/md/dm-compress/chun=
k.c
> new file mode 100644
> index 0000000000000..c507456558a2b
> --- /dev/null
> +++ b/drivers/md/dm-compress/chunk.c
[ ... ]
> @@ -0,0 +1,440 @@
[ ... ]
> +appended:
> +			sub =3D dm_bufio_new(c->split_bufio, subblk, &bp);
> +			if (IS_ERR(sub)) {
> +				dm_compress_error(c, "Unable to create a new buffer", PTR_ERR(sub));
> +				goto free_ret;
> +			}
> +			this_step =3D min(block_size, len_compressed);
> +			memcpy(sub, src_ptr, this_step);
> +			src_ptr +=3D this_step;
> +			len_compressed -=3D this_step;
> +			dm_bufio_mark_buffer_dirty(bp);
> +			dm_bufio_release(bp);

[Severity: Medium]
When split_space < len_compressed < block_size, does memcpy(sub, src_ptr,
this_step) leave the trailing block_size - this_step bytes of the
dm_bufio_new() buffer uninitialized before writing the full block to disk?

> diff --git a/drivers/md/dm-compress/io.c b/drivers/md/dm-compress/io.c
> new file mode 100644
> index 0000000000000..65ba0fd637a2f
> --- /dev/null
> +++ b/drivers/md/dm-compress/io.c
[ ... ]
> @@ -0,0 +1,640 @@
[ ... ]
> +static void dm_compress_setup_flush(struct dm_compress_io *dio)
> +{
> +	dio->is_flush =3D true;
> +	dio->chunk =3D 0;
> +	dio->offset_in_chunk =3D 0;
> +}

[Severity: High]
Because dm_compress_setup_flush() sets dio->chunk =3D 0 and waiting flush
bios are inserted into c->waiting_bio_tree, won't
dm_compress_pick_dio_for_chunk(c, 0) match waiting REQ_PREFLUSH or REQ_FUA
bios whenever chunk 0 finishes or fails?

If a read or decompression of chunk 0 fails, dm_compress_read_failed() ->
dm_compress_process_bios_on_chunk(c, 0, status) will pick any waiting flush
bio and complete it with chunk 0's read error without syncing the device.
If chunk 0 finishes reading while another chunk is still in progress,
picking the waiting flush bio in dm_compress_process_bios_on_chunk(c, 0,
BLK_STS_OK) returns false from dm_compress_process_chunk() and breaks out
of the loop before waking ready data bios waiting on chunk 0.

[ ... ]

> +static bool dm_compress_process_chunk(struct dm_compress_io *dio)
> +{
> +	struct dm_compress *c =3D dio->c;
> +	struct bio *bio =3D dm_bio_from_per_bio_data(dio, sizeof(struct dm_comp=
ress_io));
> +	struct cached_chunk *cc;
> +	struct chunk_entry *ce;
> +	struct dm_buffer *bp;
> +	struct chunk_ptr *cp;
> +
> +	if (unlikely(c->failed)) {
> +		bio->bi_status =3D errno_to_blk_status(c->failed);
> +		return true;
> +	}
> +
> +	if (unlikely(dio->is_flush)) {
> +		if (dm_compress_is_something_in_progress(c))
> +			return false;
> +		dm_compress_sync(c);
> +		if (unlikely(c->failed))
> +			bio->bi_status =3D errno_to_blk_status(c->failed);
> +		return true;
> +	}
[ ... ]
> +	ce =3D map_chunk(c, dio->chunk, &bp);
> +	if (unlikely(IS_ERR(ce))) {
> +		bio->bi_status =3D errno_to_blk_status(PTR_ERR(ce));
> +		return true;
> +	}
> +	cp =3D &ce->ptr[CC_VALID(c, &ce->cc_txc)];
> +	if (cp->algorithm =3D=3D ALGORITHM_ZERO) {
> +		if (bio_op(bio) =3D=3D REQ_OP_READ) {
> +			dm_bufio_release(bp);
> +			zero_fill_bio(bio);
> +			return true;
> +		}
> +		if (bio_op(bio) =3D=3D REQ_OP_DISCARD) {
> +			dm_bufio_release(bp);
> +			return true;
> +		}
> +	}
> +	dm_bufio_release(bp);

[Severity: Medium]
Does dm_compress_process_chunk() need to call map_chunk() on REQ_OP_WRITE
cache misses, or hold c->mutex across synchronous metadata I/O and
dm_compress_sync()?

On a write cache miss, map_chunk() performs up to two synchronous
dm_bufio_read() calls under c->mutex even though ce and cp are immediately
released without being used.  Holding the global c->mutex across map_chunk()
and dm_compress_sync() blocks all concurrent cache-hit reads, writes, and
worker completions across the device.

> +
> +	cc =3D dm_compress_new_cached_chunk(dio);
> +	if (cc) {
> +		struct cached_chunk *qc =3D dm_compress_find_cached_chunk(c, dio->chun=
k, cc);
> +		if (unlikely(qc !=3D NULL)) {
> +			dm_compress_release_cached_chunk(cc);
> +			cc =3D qc;
> +			goto have_cached_chunk;
> +		}
> +		goto have_cached_chunk;
> +	}
> +
> +	cc =3D list_entry(c->lru.prev, struct cached_chunk, lru_entry);
> +	dm_compress_enqueue_chunk(cc, INTENT_FREE);
> +	return false;
> +}

[Severity: Medium]
Once c->free_chunks is empty, doesn't always picking c->lru.prev serialize
cache eviction on a single chunk?

Until c->lru.prev finishes compression and writeback and
dm_compress_release_cached_chunk() unlinks it from c->lru, every subsequent
cache miss targets the same c->lru.prev entry (where
dm_compress_enqueue_chunk() is a no-op because cc->intent is already
INTENT_FREE) instead of starting eviction on the next LRU chunks or
synchronously reclaiming a clean idle chunk under c->mutex.

> +
> +static void dm_compress_chunk_work(struct work_struct *w)
> +{
> +	struct cached_chunk *cc =3D container_of(w, struct cached_chunk, work);
> +	struct dm_compress *c =3D cc->c;
> +	unsigned len_in, len_out, len_compressed, trailing_space;
> +	int ret;
> +	sector_t preferred_block;
> +	struct dm_buffer *bp;
> +	struct chunk_ptr *cp;
> +	struct chunk_ptr old_cp, new_cp;
> +
> +	init_completion(&cc->completion);
> +
> +	if (memchr(cc->sector_tags, 0, 1U << c->log2_sectors_per_chunk)) {
> +		dm_compress_read_and_decompress(cc);
> +		return;
> +	}
> +
> +	mutex_lock(&c->mutex);
> +	if (cc->intent =3D=3D INTENT_READ) {
> +		cc->intent =3D INTENT_IDLE;
> +		dm_compress_process_bios_on_chunk(c, cc->chunk, BLK_STS_OK);
> +		return;
> +	}
> +	if (!cc->dirty) {
> +		mutex_unlock(&c->mutex);
> +		complete(&cc->completion);
> +		dm_compress_chunk_work_2(&cc->work);
> +		return;
> +	}

[Severity: Medium]
Can a read failure on a chunk cause waiting or subsequent writes to fail?

When an in-flight read fails, dm_compress_read_failed() passes the read
error status to dm_compress_process_bios_on_chunk(), which fails all bios
waiting on that chunk, including waiting REQ_OP_WRITE and REQ_OP_DISCARD
bios that would otherwise clear cc->failed in dm_compress_process_chunk()
and overwrite the chunk.  Moreover, because dm_compress_chunk_work() checks
memchr(cc->sector_tags, 0, ...) before checking !cc->dirty, evicting a
clean chunk that had a prior read failure (leaving sector_tags zeroed)
calls dm_compress_read_and_decompress() -> dm_compress_read_failed() instead
of releasing the clean chunk.

> diff --git a/drivers/md/dm-compress/target.c b/drivers/md/dm-compress/tar=
get.c
> new file mode 100644
> index 0000000000000..95d08a8a92040
> --- /dev/null
> +++ b/drivers/md/dm-compress/target.c
[ ... ]
> @@ -0,0 +1,934 @@
[ ... ]
> +	if (sscanf(argv[4], "%llu%c", &param, &dummy) !=3D 1 || !param || param=
 !=3D (sector_t)param) {
> +		ti->error =3D "Invalid number of chunks";
> +		r =3D -EINVAL;
> +		goto bad;
> +	}
> +	c->n_chunks =3D param;

[Severity: Medium]
Should c->n_chunks be bounded in dm_compress_ctr() the same way c->n_blocks
is?

If c->n_chunks >=3D ULLONG_MAX - CHUNKS_PER_BUFFER + 2,
dm_sector_div_up(c->n_chunks, CHUNKS_PER_BUFFER) in initialize_device()
wraps around 64-bit sector_t to 0 and formats a corrupted superblock with
zero chunk blocks.  On 32-bit architectures with 64-bit sector_t,
block_location() and chunk_location() also truncate 64-bit directory and
group indices into 32-bit size_t output parameters, and the vmalloc_array()
failure paths for block_directories, groups, and chunk_directories return
-ENOMEM without setting ti->error.

[ ... ]

> +	c->compress_wq =3D alloc_workqueue("dm-compress-compress", WQ_PERCPU | =
WQ_MEM_RECLAIM, METADATA_WORKQUEUE_MAX_ACTIVE);
> +	if (unlikely(!c->compress_wq)) {
> +		ti->error =3D "Cannot allocate workqueue";
> +		r =3D -ENOMEM;
> +		goto bad;
> +	}

[Severity: Medium]
Should c->compress_wq use WQ_UNBOUND (or WQ_CPU_INTENSIVE) instead of
WQ_PERCPU?

When dm_compress_is_something_in_progress() runs during flush, autocommit,
or suspend, it queues all dirty cached chunks from a single CPU, so a bound
WQ_PERCPU workqueue pins all CPU-heavy chunk compressions onto that one
core.  In addition, dm_compress_allocate_chunk() and
dm_compress_read_chunk() call queue_work(c->compress_wq, &cc->work) on the
synchronous ALGORITHM_ZERO and ALGORITHM_SPLIT paths from a worker already
running on c->compress_wq, waking a second worker that blocks in
wait_for_completion(&cc->completion).

[ ... ]

> +	r =3D mempool_init_kmalloc_pool(&c->block_io_buffers, 1, 512U << c->log=
2_sectors_per_block);
> +	if (r) {
> +		ti->error =3D "Cannot allocate io buffers";
> +		goto bad;
> +	}
[ ... ]
> +static void dm_compress_postsuspend(struct dm_target *ti)
> +{
> +	struct dm_compress *c =3D ti->private;
> +	int r;
> +
> +check_again:
> +	mutex_lock(&c->mutex);
> +	if (dm_compress_is_something_in_progress(c)) {
> +		mutex_unlock(&c->mutex);\
> +		schedule_timeout_uninterruptible(1);
> +		goto check_again;
> +	}

[Severity: Medium]
Can dm_compress_postsuspend() wait on c->wait_idle (like
dm_compress_autocommit() does) instead of polling with a 1-jiffy sleep in
schedule_timeout_uninterruptible(1)?

Also, c->block_io_buffers is a 1-element kmalloc mempool for block sizes up
to 512 KiB (or 1 MiB per MAX_BLOCK_SIZE), so concurrent split-chunk
workers in map_split_block() and dm_compress_allocate_chunk() either stall
on the single preallocated buffer or trigger order 7-8 GFP_NOIO contiguous
kmalloc allocations.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/275c8a42-b281-8e68-=
eaef-05a1ea3eba16@redhat.com?part=3D1

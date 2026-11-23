Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795469722;
	b=FAak1gnBzrHuP5LymDk9G6kYGTvF60TZLmMLuzOEG8jkQqOw0uGoKQZAMiBNnMxUk7ST
	 LziJIUvp6HVtVGLQb12jLCIT67/fgUISEgKNxpBHulzAVM9I1/gGF8eM2f30vp4s6RRgu
	 SOPJscdWKT9h3a59vVp7h7RKLpDvBxsfVzYm5PlNbiRUkqk2ZBiN8y5IJukUcwAAzWDyI
	 Z1MUC852tqedw3JICbet/fzLUF2JWNZDFBFTpBmy6ktT2Q3XBLRfiGhfdXNzCmjSmbzEg
	 f/YM8g7vtOynMsb4nflvBhmnyFA6R0GOi2r8FizEvOoYE5ERMQTiySmmt9koOZ1pkGg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795469722;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=/Qp86ercmCJr4Ax/wqTrcu5HFB/7Mdd3FmPBV/aEAMA=;
	b=0IqvcRFkODgukYw+j2nNlqGaIB8Fm7uJc7rSYjvSGTX4IiHSzP8Ka54rr6vsWgf+KiqB
	 jb+5OHijBpv/U1hXZ+WmYzuvN+EpZHTdhNR60TnIoh4JBDBC/PnZuhh2D9MtUjqX13YkU
	 jo8PI0JyZi7L1tvCqOye7m/bOGrOmF78xytdQPU58MfdfoTouWRSS3pTz5yDgP6X3O+Ah
	 FOpIFa0bIikmXLM4Xut6/q4n0HDU0bKAh0i0fFJXCVvwOIqZjFucyMB7CW1FQGz9Bj8/A
	 4sgC1XvVq8KtvqoyZlQY90tQazBSAvvI4ulcCRsMEF6iUihuntZwbL1dwErgsxFRUDw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=U0NNKzWZ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA918606A31E
	for <dm-devel@lists.linux.dev>; Mon, 23 Nov 2026 21:35:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=U0NNKzWZ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A6FE1F000C0;
	Mon, 23 Nov 2026 21:35:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795469722;
	bh=/Qp86ercmCJr4Ax/wqTrcu5HFB/7Mdd3FmPBV/aEAMA=;
	h=From:Subject:Reply-To:To:In-Reply-To:References:Date;
	b=U0NNKzWZtfpieABKhycsg9YwjSYFoAUacCGqHthzS0Fzx8DiSbmH5P7diG9bhbezX
	 YKeKpx5/uoelO73YYXFx7+RuYMM02pUfCvYnGLE3N21rbbSqjh9UCc3MlCnMfQaQoS
	 z+sCG8nM8Fne54JZyCWDF5UqYnXLSetNcYhLnT9DNMhIrn8y23ppcrGQD6LbfJacyP
	 0i/2F5JTMy+4XXQwK7AMxopDqOCmkIsBx8NCDI8+mUZEZxhFjxFwE0vpd7FAmfEPkf
	 ojhRQMdjx/JsttdJxEg9Y/zBmMyokaY1HkwX8fqSQ3chS19k9rGOgBzafgQ6JTyaGs
	 uHDhAQ8GNnBfw==
Message-ID: <sashiko-outbox-230088@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] dm-compress: introduce the dm-compress target
Reply-To: sashiko-reviews@lists.linux.dev
To: "Mikulas Patocka" <mpatocka@redhat.com>, "Alasdair Kergon" <agk@redhat.com>, "Mike
 Snitzer" <snitzer@kernel.org>, "Benjamin Marzinski" <bmarzins@redhat.com>, "Ming-Hung
 Tsai" <mtsai@redhat.com>, "Zdenek Kabelac" <zkabelac@redhat.com>, "Filip
 Suba" <fsuba@redhat.com>, dm-devel@lists.linux.dev
In-Reply-To: <d3fbdf3d-c7d8-0e4f-31f4-b187eb52ec30@redhat.com>
References: <d3fbdf3d-c7d8-0e4f-31f4-b187eb52ec30@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 23 Nov 2026 21:35:21 +0000
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Post: <mailto:dm-devel@lists.linux.dev>
List-Help: <mailto:dm-devel+help@lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
List-Owner: <mailto:dm-devel+owner@lists.linux.dev>
Precedence: list

Thank you for your contribution! Sashiko AI review found 11 potential
issues to consider:
- [Critical] dm-compress: uncommitted metadata flushed and sb->cc
  rewound on error
- [High] dm-compress: scomp scratch page overflow via page-split
  scatterlists
- [High] dm-compress: unallocated bitmap in dm_compress_resize_bitmaps()
- [High] dm-compress: stale n_allocated_sectors in
  dm_compress_resize_bitmaps()
- [High] dm-compress: missing cc->failed check in
  dm_compress_chunk_decompress()
- [High] dm-compress: premature chunk release in
  dm_compress_read_failed()
- [High] dm-compress: bio reordering and blocking in
  dm_compress_pick_dio_for_chunk()
- [High] dm-compress: active work_struct re-initialized in
  dm_compress_chunk_work()
- [Medium] dm-compress: prepare_bitmap() dirties bitmaps before
  allocation check
- [Medium] dm-compress: metadata size checked against raw sectors in
  initialize_device()
- [Low] dm-compress: missing index.rst entry and commit_time
  documentation
--

commit aeac9b542cd6769324ef487c13c874a11f0ef7b9
Author: Mikulas Patocka <mpatocka@redhat.com>

dm-compress: introduce the dm-compress target

This commit adds the dm-compress device-mapper target for transparent block
device compression and decompression, along with a forced buffer eviction
helper in dm-bufio.

> diff --git a/Documentation/admin-guide/device-mapper/dm-compress.rst b/Do=
cumentation/admin-guide/device-mapper/dm-compress.rst
> new file mode 100644
> index 0000000000000..606e93cc5b577
> --- /dev/null
> +++ b/Documentation/admin-guide/device-mapper/dm-compress.rst
[ ... ]
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
Should Documentation/admin-guide/device-mapper/dm-compress.rst be added to
Documentation/admin-guide/device-mapper/index.rst to avoid a Sphinx warning
during htmldocs builds, and should the optional commit_time:<msec> argument
parsed in dm_compress_ctr() also be documented here?

> diff --git a/drivers/md/dm-compress/alloc.c b/drivers/md/dm-compress/allo=
c.c
> new file mode 100644
> index 0000000000000..7a990124a3d11
> --- /dev/null
> +++ b/drivers/md/dm-compress/alloc.c
> @@ -0,0 +1,480 @@
[ ... ]
> +static int prepare_bitmap(struct dm_compress *c, sector_t bmp_block, __u=
64 **working_copy, __u64 **stable_copy, struct dm_buffer **bp)
> +{
[ ... ]
> +	idx =3D !CC_VALID(c, &bmp->cc_txc);
> +	if (unlikely(!CC_CURRENT(c, &bmp->cc_txc))) {
> +		CC_SET_CURRENT(c, &bmp->cc_txc);
> +		//WARN_ON(idx !=3D CC_VALID(c, &bmp->cc_txc));
> +		if (!idx)
> +			memcpy(bmp->bmp1, bmp->bmp2, BITS_PER_BITMAP / 8);
> +		else
> +			memcpy(bmp->bmp2, bmp->bmp1, BITS_PER_BITMAP / 8);
> +		idx =3D !idx;
> +		dm_bufio_mark_buffer_dirty(*bp);
> +	}
[ ... ]
> +}
[ ... ]
> +sector_t dm_compress_allocate_space(struct dm_compress *c, sector_t pref=
erred_block, unsigned n_blocks)
> +{
[ ... ]
> +	mutex_lock(&group->mutex);
> +	if (unlikely(prepare_bitmap(c, bmp_block, &working_copy, &stable_copy, =
&bp))) {
> +		mutex_unlock(&group->mutex);
> +		return ALLOCATE_ERROR;
> +	}
> +
> +find_again:
> +	bit =3D find_next_zero_bit_le(working_copy, BITS_PER_BITMAP, bmp_offset=
);
[ ... ]
> +	dm_bufio_release(bp);
> +	mutex_unlock(&group->mutex);
> +
> +	if (++n_retries <=3D c->n_groups) {
> +		preferred_block +=3D BITS_PER_BITMAP;
> +		goto try_next_bitmap;
> +	}

[Severity: Medium]
Does calling prepare_bitmap() before checking whether the bitmap has enough
free bits dirty every bitmap visited during an allocation scan?

When dm_compress_allocate_space() steps past full or fragmented bitmaps,
prepare_bitmap() updates bmp->cc_txc, copies 2040 bytes between bmp1 and
bmp2, and marks the buffer dirty even when no bits are allocated.  In
addition, struct block_group_descriptor has a free field initialized to -1
in dm_compress_ctr() that is never maintained or consulted, so failed
contiguous allocations can linearly scan and dirty every bitmap on the
device before commit.

[ ... ]

> +int dm_compress_resize_bitmaps(struct dm_compress *c, sector_t current_s=
ize, sector_t new_size, bool *need_sync)
> +{
[ ... ]
> +		need_sectors =3D 0;
> +		if (!bmp_offset && !dir_offset)
> +			need_sectors =3D BUFFER_SECTORS * 2;
> +		else if (!bmp_offset)
> +			need_sectors =3D BUFFER_SECTORS;
> +		if (n_allocated_sectors < need_sectors) {
> +			if (c->meta_dev) {
> +				dm_compress_error(c, "The metadata device is too small", -ENOSPC);
> +				return -ENOSPC;
> +			}
> +align_allocated:
> +			allocated_sector =3D current_size << c->log2_sectors_per_block;
> +			if (allocated_sector & (BUFFER_SECTORS - 1)) {
> +				if (current_size >=3D new_size)
> +					goto finish;
> +				current_size++;
> +				goto align_allocated;
> +			}
> +			while (n_allocated_sectors < need_sectors) {
> +				if (current_size >=3D new_size)
> +					goto finish;
> +				current_size++;
> +				n_allocated_sectors +=3D 1 << c->log2_sectors_per_block;
> +			}
> +		}

[Severity: High]
When align_allocated sets a new allocated_sector because
n_allocated_sectors < need_sectors, should n_allocated_sectors be reset to
0?

With !c->meta_dev and a block size larger than BUFFER_SIZE (e.g. 8 KiB
blocks, 16 sectors), reserving one block adds 16 sectors to
n_allocated_sectors while allocating a 4 KiB bitmap consumes 8 sectors,
leaving n_allocated_sectors =3D=3D 8.  Because DIRECTORY_ENTRIES (679) is o=
dd,
reaching a directory boundary requires need_sectors =3D=3D 16 while
n_allocated_sectors is 8.  Jumping to align_allocated moves
allocated_sector to current_size without zeroing n_allocated_sectors, so
the loop only reserves one 8 KiB block instead of two, leaving
allocated_sector pointing at the next block while that block is marked free
in the bitmap and later overwritten by the next metadata bitmap.

> +
> +		did_something =3D true;
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

[Severity: High]
What happens in dm_compress_resize_bitmaps() if current_size reaches
new_size inside the align_allocated or n_allocated_sectors < need_sectors
loops and jumps to finish?

Because current_size is incremented in place before checking whether enough
new blocks exist to satisfy need_sectors, jumping to finish leaves
current_size =3D=3D new_size without allocating the new bitmap or directory.
If did_something is true from an earlier iteration, finish writes
sb->n_blocks[b] =3D new_size to the superblock; if did_something is false,
c->n_blocks still remains at new_size from dm_compress_ctr().  In both
cases dm_compress_preresume() then tries to load or scan the unallocated
bitmap/directory at block 0 (the superblock) and fails with -EUCLEAN.

> diff --git a/drivers/md/dm-compress/cc.c b/drivers/md/dm-compress/cc.c
> new file mode 100644
> index 0000000000000..bf9b940c0178e
> --- /dev/null
> +++ b/drivers/md/dm-compress/cc.c
> @@ -0,0 +1,251 @@
[ ... ]
> +static struct scatterlist *dm_compress_alloc_sglist(void *data, unsigned=
 len, unsigned offset)
> +{
> +	struct scatterlist *sg;
> +	if (!is_vmalloc_addr(data)) {
> +		sg =3D kmalloc(sizeof(struct scatterlist), GFP_KERNEL);
> +		if (!sg)
> +			return NULL;
> +		sg_init_one(sg, data + offset, len - offset);
> +	} else {
> +		unsigned i;
> +		unsigned n_entries =3D DIV_ROUND_UP(len, PAGE_SIZE);
> +		size_t s =3D array_size(sizeof(struct scatterlist), n_entries);
> +		sg =3D kmalloc(s, GFP_KERNEL);
> +		if (!sg)
> +			return NULL;
> +		sg_init_table(sg, n_entries);
> +		for (i =3D 0; i < n_entries; i++) {
> +			struct page *pg =3D vmalloc_to_page(data);
> +			unsigned pg_len =3D min(len, PAGE_SIZE);
> +			sg_set_page(&sg[i], pg, pg_len - offset, offset);
> +			data +=3D PAGE_SIZE;
> +			len -=3D PAGE_SIZE;
> +			offset =3D 0;
> +		}
> +	}
> +	return sg;
> +}

[Severity: High]
Can passing PAGE_SIZE-split scatterlists via acomp_request_set_params()
overflow scomp's order-0 scratch->src page or fail with -ENOSYS?

Four of the six supported algorithms (lzo, 842, lz4, lz4hc) are scomp
algorithms bridged through scomp_acomp_comp_decomp().  When virtual
pointers are not used, scomp_acomp_comp_decomp() requires dlen <=3D
req->dst->length (only the first scatterlist entry, which is PAGE_SIZE - 4
on compress and PAGE_SIZE on decompress) and copies linear source data into
scratch->src allocated as a single order-0 page by scomp_alloc_scratch():

crypto/scompress.c:scomp_acomp_comp_decomp() {
    ...
	if (!dst_isvirt) {
		if (dlen <=3D req->dst->length) {
    ...
		} else
			return -ENOSYS;
	}
	if (src_isvirt || slen <=3D req->src->length) {
    ...
	} else {
		memcpy_from_sglist(scratch->src, req->src, 0, slen);
		src =3D scratch->src;
	}
    ...
}

When chunk_size is 2 * PAGE_SIZE (8192) and block_size is PAGE_SIZE (4096),
len_out is 4092 =3D=3D cc->compressed_sglist[0].length, so the destination
check passes and memcpy_from_sglist() copies slen (8192 bytes) into the
4096-byte scratch->src page, overflowing it by 4096 bytes.  For larger
chunk sizes, compression fails with -ENOSYS and silently falls back to
ALGORITHM_UNCOMPRESSED, and decompression of any scomp-compressed chunk
with chunk_size > PAGE_SIZE fails with -ENOSYS.  Since the buffers come
from __vmalloc(), passing them via acomp_request_set_src_nondma() and
acomp_request_set_dst_nondma() would avoid the scatterlist path entirely.

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
Can inserting duplicate chunk keys into c->waiting_bio_tree reorder or
block waiting bios in dm_compress_pick_dio_for_chunk()?

When multiple bios wait on the same chunk, rb_insert_color() and
rb_erase() rotations can place a newer dio above an older dio with the same
chunk key.  dm_compress_pick_dio_for_chunk() returns the first matching
node closest to the root, so waiting writes to the same chunk can execute
out of FIFO order and overwrite newer data with older data.

In addition, if the topmost node matching chunk cannot run yet (for
example, a write bio when cc->intent >=3D INTENT_WRITE in
dm_compress_chunk_decompress(), or a waiting flush bio which
dm_compress_setup_flush() inserts with fake key dio->chunk =3D 0),
dm_compress_process_bios_on_chunk() stops immediately without serving
runnable read bios for that chunk located lower in the tree.

> diff --git a/drivers/md/dm-compress/io.c b/drivers/md/dm-compress/io.c
> new file mode 100644
> index 0000000000000..64f3e4d58d67e
> --- /dev/null
> +++ b/drivers/md/dm-compress/io.c
> @@ -0,0 +1,652 @@
[ ... ]
> +static void dm_compress_chunk_work(struct work_struct *w)
> +{
[ ... ]
> +	INIT_WORK(&cc->work, dm_compress_chunk_work_2);
> +	if (unlikely(!dm_compress_allocate_chunk(cc, preferred_block, &new_cp))=
) {
> +		complete(&cc->completion);
> +		dm_compress_chunk_work_2(&cc->work);
> +		return;
> +	}
> +
> +	cp =3D dm_compress_prepare_chunk(c, cc->chunk, &bp);
> +	if (unlikely(!cp))
> +		goto cont;
> +
> +	old_cp =3D *cp;
> +	*cp =3D new_cp;
> +
> +	dm_bufio_mark_buffer_dirty(bp);
> +	dm_bufio_release(bp);
> +
> +	dm_compress_release_chunk(c, &old_cp);
> +
> +cont:
> +	complete(&cc->completion);
> +}
> +
> +static void dm_compress_chunk_work_2(struct work_struct *w)
> +{
> +	struct cached_chunk *cc =3D container_of(w, struct cached_chunk, work);
> +	struct dm_compress *c =3D cc->c;
> +
> +	wait_for_completion(&cc->completion);
> +
> +	mutex_lock(&c->mutex);
> +	if (cc->intent >=3D INTENT_FREE) {
> +		dm_compress_release_cached_chunk(cc);
> +	} else {
> +		cc->intent =3D INTENT_IDLE;
> +	}
> +	dm_compress_process_pending_ios(c);
> +}

[Severity: High]
Is it safe to call INIT_WORK(&cc->work, ...) and queue &cc->work while a
work callback on &cc->work is still running?

kworker/0                                kworker/1
process_one_work(&cc->work)
  dm_compress_chunk_work(&cc->work)
    INIT_WORK(&cc->work,
              dm_compress_chunk_work_2)
    dm_compress_allocate_chunk()
      ...
        queue_work(..., &cc->work)
                                         process_one_work(&cc->work)
                                           dm_compress_chunk_work_2()
                                             wait_for_completion()
    dm_compress_prepare_chunk()
    dm_compress_release_chunk()
    complete(&cc->completion)
                                             cc->intent =3D INTENT_IDLE
                                             dm_compress_process_pending_io=
s()
                                               dm_compress_enqueue_chunk()
                                                 INIT_WORK(&cc->work, ...)

Calling INIT_WORK() inside dm_compress_chunk_work() (and similarly in
dm_compress_read_and_decompress() and via dm_compress_enqueue_chunk()
before the worker returns) overwrites cc->work.data and cc->work.lockdep_map
while process_one_work() is still tracking the work item, breaking
workqueue non-reentrancy tracking and allowing concurrent execution on the
same work_struct.

[ ... ]

> +static void dm_compress_read_failed(struct cached_chunk *cc)
> +{
> +	struct dm_compress *c =3D cc->c;
> +	sector_t chunk =3D cc->chunk;
> +	mutex_lock(&c->mutex);
> +	if (unlikely(cc->dirty)) {
> +		cc->dirty =3D false;
> +		dm_compress_error(c, "Could not read a chunk with pending writes", -EI=
O);
> +	}
> +	if (cc->intent >=3D INTENT_FREE) {
> +		dm_compress_release_cached_chunk(cc);
> +	} else {
> +		cc->intent =3D INTENT_IDLE;
> +	}
> +	dm_compress_process_bios_on_chunk(c, chunk);
> +}

[Severity: High]
If cc->intent was upgraded to INTENT_FREE while a read was in flight, does
releasing cc before dm_compress_process_bios_on_chunk() prevent waiting
read bios from seeing cc->failed?

When c->free_chunks is empty, another bio can select cc from c->lru.prev
and upgrade cc->intent from INTENT_READ to INTENT_FREE.  If the read or
decompression then fails, dm_compress_read_failed() calls
dm_compress_release_cached_chunk(cc) before
dm_compress_process_bios_on_chunk(c, chunk), removing cc from c->chunks.
When dm_compress_process_bios_on_chunk() then runs the waiting read bio for
chunk, dm_compress_find_cached_chunk() returns NULL instead of finding
cc->failed, and dm_compress_new_cached_chunk() re-allocates cc with
cc->failed reset to 0, retrying the failed read in an unbounded loop.

> +
> +static void dm_compress_read_and_decompress(struct cached_chunk *cc)
[ ... ]
> +static void dm_compress_chunk_decompress(struct work_struct *w)
> +{
> +	struct cached_chunk *cc =3D container_of(w, struct cached_chunk, work);
> +	struct dm_compress *c =3D cc->c;
> +	unsigned i;
> +	unsigned intent;
> +
> +	if (cc->algorithm =3D=3D ALGORITHM_ZERO) {

[Severity: High]
Should dm_compress_chunk_decompress() check cc->failed at entry before
copying or decompressing cc->compressed_data?

When a non-split read bio fails, dm_compress_read_endio() records the error
in cc->failed via dm_compress_error_chunk() and queues cc->work, which runs
dm_compress_chunk_decompress().  Because dm_compress_chunk_decompress()
does not check cc->failed, it proceeds to copy or decompress stale data
from cc->compressed_data into cc->uncompressed_data, marks all
cc->sector_tags as TAG_VALID, and skips dm_compress_read_failed(cc).  If
cc->dirty was set from an earlier partial write, skipping
dm_compress_read_failed(cc) also skips disabling the device and allows a
subsequent write to reset cc->dirty and cc->sector_tags, silently losing
the earlier write.

> diff --git a/drivers/md/dm-compress/target.c b/drivers/md/dm-compress/tar=
get.c
> new file mode 100644
> index 0000000000000..6f71b41e3e44d
> --- /dev/null
> +++ b/drivers/md/dm-compress/target.c
> @@ -0,0 +1,959 @@
[ ... ]
> +void dm_compress_sync(struct dm_compress *c)
> +{
> +	struct block_device *bdev =3D c->meta_dev ? c->meta_dev->bdev : c->dev-=
>bdev;
> +	__u16 cc;
> +	unsigned granularity;
> +	unsigned offset;
> +	int r;
> +
> +	r =3D dm_bufio_write_dirty_buffers(c->bufio);
> +	if (unlikely(r)) {
> +		dm_compress_error(c, "Error flushing buffers", r);
> +		goto skip_commit;
> +	}
> +
> +	if (unlikely(c->split_bufio_dirty)) {
> +		c->split_bufio_dirty =3D false;
> +		r =3D dm_bufio_write_dirty_buffers(c->split_bufio);
> +		if (unlikely(r)) {
> +			dm_compress_error(c, "Error flushing split chunk buffers", r);
> +			goto skip_commit;
> +		}
> +		goto skip_flush_dev;
> +	}
> +
> +	if (c->meta_dev) {
> +		r =3D blkdev_issue_flush(c->dev->bdev);
> +		if (unlikely(r)) {
> +			dm_compress_error(c, "Error flushing the data device", r);
> +			goto skip_commit;
> +		}
> +	}
> +skip_flush_dev:
> +
> +	if (unlikely(c->failed))
> +		goto skip_commit;

[Severity: Critical]
When c->failed is set, does flushing dirty buffers in dm_compress_sync()
and rewinding c->sb->cc in dm_compress_postsuspend() cause uncommitted
metadata from a failed transaction to be treated as valid on the next
resume?

In dm_compress_preresume(), c->sb->cc is incremented on disk from K to
K + 1 and c->cc_txc is advanced to transaction T + 0x10000, while on-disk
c->cct->entries[K] remains at T until commit.  If a runtime error (such as
-ENOSPC mid-allocation in dm_compress_allocate_chunk() or a write error)
sets c->failed, dirty metadata buffers in c->bufio are already stamped with
(K, T + 0x10000).  When dm_compress_postsuspend() runs:

drivers/md/dm-compress/target.c:dm_compress_postsuspend() {
    ...
	dm_compress_sync(c);
	mutex_unlock(&c->mutex);

	cancel_delayed_work_sync(&c->autocommit_work);

	c->cct->entries[c->cc_txc & 0xffff] =3D cpu_to_le64(le64_to_cpup(&c->cct->=
entries[c->cc_txc & 0xffff]) - 0x10000);
	c->sb->cc =3D cpu_to_le16(le16_to_cpup(&c->sb->cc) - 1);
	c->cc_txc -=3D 0x10000;

	r =3D dm_compress_sync_rw_metadata(c, REQ_OP_WRITE | REQ_SYNC | REQ_PREFLU=
SH | REQ_FUA, DM_IO_KMEM, 0, c->sb, SB_SECTORS);
    ...
}

dm_compress_sync() writes the dirty metadata buffers to disk before
checking c->failed and skipping the c->cct update, and
dm_compress_postsuspend() then unconditionally decrements c->sb->cc back to
K on disk.  On the next resume, dm_compress_preresume() reads sb->cc =3D=3D=
 K
and cct->entries[K] =3D=3D T, starting the new session with the same
(K, T + 0x10000) stamp as the aborted transaction so CC_VALID() treats the
partially updated metadata as committed instead of rolling it back.

[ ... ]

> +static int initialize_device(struct dm_compress *c)
> +{
[ ... ]
> +	meta_size =3D bdev_nr_sectors(c->meta_dev ? c->meta_dev->bdev : c->dev-=
>bdev);
> +	meta_size =3D meta_size >=3D c->start ? meta_size - c->start : 0;
> +	meta_size >>=3D log2_buffer_sectors;
> +
> +	used_meta_size =3D position + n_bitmap_blocks + n_bitmap_directories + =
n_chunk_blocks + n_chunk_directories;
> +	if (c->meta_dev)
> +		sb->n_used_metadata_blocks[0] =3D cpu_to_le64(used_meta_size);
> +	if (used_meta_size > meta_size) {
> +		if (c->meta_dev)
> +			c->ti->error =3D "The metadata device is too small";
> +		else
> +			c->ti->error =3D "The device is too small";
> +		return -ENOSPC;
> +	}
[ ... ]
> +	if (c->log2_sectors_per_block < log2_buffer_sectors)
> +		used_meta_size <<=3D log2_buffer_sectors - c->log2_sectors_per_block;
> +	else if (c->log2_sectors_per_block > log2_buffer_sectors)
> +		used_meta_size =3D dm_sector_div_up(used_meta_size, 1U << (c->log2_sec=
tors_per_block - log2_buffer_sectors));

[Severity: Medium]
When !c->meta_dev, should initialize_device() verify that used_meta_size
(after converting to data blocks) is strictly less than data_blocks?

dm_compress_ctr() computes c->n_blocks (data_blocks) by shifting the device
sector count right by c->log2_sectors_per_block, which truncates any
trailing sectors that do not form a full data block.  Because
initialize_device() checks used_meta_size against meta_size in 4 KiB buffer
units before converting used_meta_size to data block units, a device with
block_size > 4096 and trailing sectors can place metadata buffers in the
partial block at index data_blocks (or format with 0 free data blocks).  If
the device is later grown, dm_compress_resize_bitmaps() clears the bitmap
bit starting at current_size =3D=3D data_blocks, freeing the block holding
those metadata buffers for data allocation.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/d3fbdf3d-c7d8-0e4f-=
31f4-b187eb52ec30@redhat.com?part=3D1

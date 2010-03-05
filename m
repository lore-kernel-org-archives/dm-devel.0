From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [PATCH 03/14] dm-multisnap-mikulas-headers
Date: Fri, 5 Mar 2010 17:46:43 -0500
Message-ID: <20100305224642.GA16425@redhat.com>
References: <1267489438-6271-1-git-send-email-snitzer@redhat.com>
	<1267489438-6271-4-git-send-email-snitzer@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <1267489438-6271-4-git-send-email-snitzer@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com
Cc: Mikulas Patocka <mpatocka@redhat.com>
List-Id: dm-devel.ids

On Mon, Mar 01 2010 at  7:23pm -0500,
Mike Snitzer <snitzer@redhat.com> wrote:

> From: Mikulas Patocka <mpatocka@redhat.com>
> 
> Common header files for the exception store.
> 
> dm-multisnap-mikulas-struct.h contains on-disk structure definitions.
> 
> dm-multisnap-mikulas.h contains in-memory structures and kernel function
> prototypes.
> 
> Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
> ---
>  drivers/md/dm-multisnap-mikulas-struct.h |  380 ++++++++++++++++++++++++++++++
>  drivers/md/dm-multisnap-mikulas.h        |  247 +++++++++++++++++++
>  2 files changed, 627 insertions(+), 0 deletions(-)
>  create mode 100644 drivers/md/dm-multisnap-mikulas-struct.h
>  create mode 100644 drivers/md/dm-multisnap-mikulas.h
> 
> diff --git a/drivers/md/dm-multisnap-mikulas-struct.h b/drivers/md/dm-multisnap-mikulas-struct.h
> new file mode 100644
> index 0000000..39eaa16
> --- /dev/null
> +++ b/drivers/md/dm-multisnap-mikulas-struct.h

<snip>

> +/*
> + *	Description of on-disk format:
> + *
> + * The device is composed of blocks (also called chunks). The block size (also
> + * called chunk size) is specified in the superblock.
> + *
> + * The chunk and block mean the same. "chunk" comes from old snapshots.
> + * "block" comes from filesystems. We tend to use "chunk" in
> + * exception-store-independent code to make it consistent with snapshot
> + * terminology and "block" in exception-store code to make it consistent with
> + * filesystem terminology.
> + *
> + * The minimum block size is 512, the maximum block size is not specified (it is
> + * limited by 32-bit integer size and available memory). All on-disk pointers
> + * are in the units of blocks. The pointers are 48-bit, making this format
> + * capable of handling 2^48 blocks.

Shouldn't we require the chunk size be at least as big as
(and a multiple of) physical_block_size?  E.g. 4096 on a 4K sector
device.

This question applies to non-shared snapshots too.

> + *	Commit blocks
> + *
> + * Chunks 1, 1+cb_stride, 1+2*cb_stride, 1+3*cb_stride, etc. are commit blocks.
> + * Chunks at these locations ((location % cb_stride) == 1) are only used for
> + * commit blocks, they can't be used for anything else. A commit block is
> + * written each time a new state is committed. The snapshot store transitions
> + * from one consistent state to another consistent state by writing a commit
> + * block.
> + *
> + * All commit blocks must be present and initialized (i.e. have valid signature
> + * and sequence number). They are created when the device is initialized or
> + * extended. It is not allowed to have random uninitialized data in any commit
> + * block.
> + *
> + * For correctness, one commit block would be sufficient --- but to improve
> + * performance and minimize seek times, there are multiple commit blocks and
> + * we use the commit block that is near currently written data.
> + *
> + * The current commit block is stored in the super block. However, updates to
> + * the super block would make excessive disk seeks too, so the updates to super
> + * block are skipped if the commit block is written at the currently valid
> + * commit block or at the next location following the currently valid commit
> + * block. The following algorithm is used to find the commit block at mount:
> + *	1. read the commit block multisnap_superblock->commit_block
> + *	2. get its sequence number
> + *	3. read the next commit block
> + *	4. if the sequence number of the next commit block is higher than
> + *	   the sequence number of the previous block, go to step 3. (i.e. read
> + *	   another commit block)
> + *	5. if the sequence number of the next commit block is lower than
> + *	   the sequence number of the previous block, use the previous block
> + *	   as the most recent valid commit block
> + *
> + * Note: because the disks only support atomic writes of 512 bytes, the commit
> + * block has only 512 bytes of valid data. The remaining data in the commit
> + * block up to the chunk size is unused.

Are there other places where you assume 512b is beneficial?  My concern
is: what will happen on 4K devices?

Would making the commit block's size match the physical_block_size give
us any multisnapshot benefit?  At a minimum I see a larger commit block
would allow us to have more remap entries (larger remap
array).. "Remaps" detailed below.  But what does that buy us?

However, and before I get ahead of myself, with blk_stack_limits() we
could have a (DM) device that is composed of 4K and 512b devices; with a
resulting physical_block_size of 4K.  But 4K wouldn't be atomic to the
512b disk.

But what if we were to add a checksum to the commit block?  This could
give us the ability to have a larger commit block regardless of the
physical_block_size. [NOTE: I saw dm_multisnap_commit() is just writing
a fixed CB_SIGNATURE]

And in speaking with Ric Wheeler, using a checksum in the commit block
opens up the possibility for optimizing (reducing) the barrier ops
associated with:
1) before the commit block is written (flushes journal transaction) 
2) and after the commit block is written.

Leaving us with only needing to barrier after the commit block is
written.  But this optimization apparently also requires having a
checksummed journal.  Ext4 offers this (somewhat controversial yet fast)
capability with the 'journal_async_commit' mount option. [NOTE: I'm
largely parroting what I heard from Ric]

[NOTE: I couldn't immediately tell if dm_multisnap_commit() is doing
multiple barriers when writing out the transaction and commit block]

Taking a step back, any reason you elected to not reuse existing kernel
infrastructure (e.g. jbd2) for journaling?  Custom solution needed for
the log-nature of the multisnapshot?  [Excuse my naive question(s), I
see nilfs2 also has its own journaling... I'm just playing devil's
advocate given how important it is that the multisnapshot journal code
be correct]

> + * The pointer to the root node and the depth of the b+tree is stored in the
> + * commit block.

OK.

> + *	Bitmaps
> + *
> + * Free space is managed by bitmaps. Bitmaps are pointed to by a radix-tree.
> + * Each internal node contains 64-bit pointers to subordinate nodes, each leaf
> + * node contains individual bits, '1' meaning allocated and '0' meaning free.
> + * There are no structs defined for the radix tree because the internal node is
> + * just an array of "u64" and the leaf node is just a bit mask.
> + *
> + * The depth of the radix tree is dependent on the device size and chunk size.
> + * The smallest depth that covers the whole device is used. The depth is not
> + * stored on the device, it is calculated with
> + * dm_multisnap_bitmap_depth function.
> + *
> + * The bitmap root is stored in the commit block.
> + * If the depth is 0, this root bitmap contains just individual bits (the device
> + * is so small that its bitmap fits within one chunk), if the depth is 1, the
> + * bitmap root points to a block with 64-bit pointers to individual bitmaps.
> + * If the depth is 2, there are two levels of pointers ... etc.

OK.

> + *
> + *	Remaps
> + *
> + * If we wanted to follow the log-structure principle (writing only to
> + * unallocated parts), we would have to always write a new pathway up to the
> + * b+tree root or bitmap root.
> + *
> + * To avoid these multiple writes, remaps are used. There are limited number
> + * of remap entries in the commit block: 27 entries of commit_block_tmp_remap.
> + * Each entry contains (old, new) pair of chunk numbers.
> + *
> + * When we need to update a b+tree block or a bitmap block, we write the new
> + * block to a new location and store the old block and the new block in the
> + * commit block remap. When reading a block, we check if the number is present
> + * in the remap array --- if it is, we read the new location from the remap
> + * instead.
> + *
> + * This way, if we need to update one bitmap or one b+tree block, we don't have
> + * to write the whole path down from the root. Eventually, the remap entries in
> + * the commit block will be exhausted and if this happens, we must free the
> + * remap entries by writing the path from the root.
> + *
> + * The bitmap_idx field in the remap is the index of the bitmap that the
> + * remapped chunk represents or CB_BITMAP_IDX_NONE if it represents a b+tree
> + * node. It is used to construct the path to the root. Bitmaps don't contain
> + * any other data except the bits, so the path must be constructed using this
> + * index. b+tree nodes contain the entries, so the path can be constructed by
> + * looking at the b+tree entries.
> + *
> + * Example: let's have a b+tree with depth 4 and pointers 10 -> 20 -> 30 -> 40.
> + * Now, if we want to change node 40: so write a new version to a chunk 41 and
> + * store the pair (40, 41) into the commit block.
> + * Now, we want to change this node again: so write a new version to a chunk 42
> + * and store the pair (40, 42) into the commit block.
> + * Now, let's do the same operation for other node --- the remap array in the
> + * commit block eventually fills up. When this happens, we expunge (40, 42) map
> + * by writing the path from the root:
> + * copy node 30 to 43, change the pointer from 40 to 42
> + * copy node 20 to 44, change the pointer from 30 to 43
> + * copy node 10 to 45, change the pointer from 20 to 44
> + * change the root pointer from 10 to 45.
> + * Now, the remap entry (40, 42) can be removed from the remap array.

Above provided, for the benefit of others, to give more context on the
role of remap entries (and the commit block's remap array).

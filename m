From: Mikulas Patocka <mpatocka@redhat.com>
Subject: Re: [PATCH 03/14] dm-multisnap-mikulas-headers
Date: Mon, 8 Mar 2010 22:08:26 -0500 (EST)
Message-ID: <Pine.LNX.4.64.1003082145210.20675@hs20-bc2-1.build.redhat.com>
References: <1267489438-6271-1-git-send-email-snitzer@redhat.com>
	<1267489438-6271-4-git-send-email-snitzer@redhat.com>
	<20100305224642.GA16425@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20100305224642.GA16425@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Mike Snitzer <snitzer@redhat.com>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

> > + * The minimum block size is 512, the maximum block size is not specified (it is
> > + * limited by 32-bit integer size and available memory). All on-disk pointers
> > + * are in the units of blocks. The pointers are 48-bit, making this format
> > + * capable of handling 2^48 blocks.
> 
> Shouldn't we require the chunk size be at least as big as
> (and a multiple of) physical_block_size?  E.g. 4096 on a 4K sector
> device.
> 
> This question applies to non-shared snapshots too.

If the device has a larger physical block size, it will reject smaller 
chunks. The same for non-shared snapshots.

> > + * Note: because the disks only support atomic writes of 512 bytes, the commit
> > + * block has only 512 bytes of valid data. The remaining data in the commit
> > + * block up to the chunk size is unused.
> 
> Are there other places where you assume 512b is beneficial?  My concern
> is: what will happen on 4K devices?

With 4K chunk size, it writes 4K, but assumes that only 512b write is 
atomic. So, if the disk supports atomic write of 4K, it doesn't hurt.

> Would making the commit block's size match the physical_block_size give
> us any multisnapshot benefit?  At a minimum I see a larger commit block
> would allow us to have more remap entries (larger remap
> array)..
>
> "Remaps" detailed below.  But what does that buy us?

They reduce the number of blocks written. Without remaps, you'd have to 
write the path from the root every time.

> However, and before I get ahead of myself, with blk_stack_limits() we
> could have a (DM) device that is composed of 4K and 512b devices; with a
> resulting physical_block_size of 4K.  But 4K wouldn't be atomic to the
> 512b disk.

Yes, that's why I must assume only 512b atomic write.

> But what if we were to add a checksum to the commit block?  This could
> give us the ability to have a larger commit block regardless of the
> physical_block_size. [NOTE: I saw dm_multisnap_commit() is just writing
> a fixed CB_SIGNATURE]

That would have to be cryptographic hash --- simple checksum can be 
fooled.

Even that wouldn't be correct, because if the hash fails, the commit block 
is lost. If you wanted to use full commit blocks, you'd have to:

- divide the commit block to two.
- write these two alternatively (so that at least one is valid)
- hash them or (which is simpler) copy sequence number to each 512b sector 
(so that if some sectors get written and some not, you find it out by 
having different sequence number).

That is possible to do.

> And in speaking with Ric Wheeler, using a checksum in the commit block
> opens up the possibility for optimizing (reducing) the barrier ops
> associated with:
> 1) before the commit block is written (flushes journal transaction) 
> 2) and after the commit block is written.

No, you have to use barriers. If the data before the commit blocks is not 
written and the commit block is written (with matching checksum), then the 
data is corrupted.

Obviously, you can checksum all the data, but SHA1 is slow and it is being 
phased out already and even slower SHA256 is being recommended...

> Leaving us with only needing to barrier after the commit block is
> written.  But this optimization apparently also requires having a
> checksummed journal.  Ext4 offers this (somewhat controversial yet fast)
> capability with the 'journal_async_commit' mount option. [NOTE: I'm
> largely parroting what I heard from Ric]
> 
> [NOTE: I couldn't immediately tell if dm_multisnap_commit() is doing
> multiple barriers when writing out the transaction and commit block]

It calls dm_bufio_write_dirty_buffers twice and 
dm_bufio_write_dirty_buffers submits a zero barrier. (there's no point in 
submitting data-barrier, because that gets split into two zero barriers 
and non-barrier write anyway)

> Taking a step back, any reason you elected to not reuse existing kernel
> infrastructure (e.g. jbd2) for journaling?  Custom solution needed for
> the log-nature of the multisnapshot?  [Excuse my naive question(s), I
> see nilfs2 also has its own journaling... I'm just playing devil's
> advocate given how important it is that the multisnapshot journal code
> be correct]

All the filesystems have their own journaling. jbd is used only by ext3, 
jbd2 only by ext4. Reiserfs has its own, JFS has its own, XFS has its 
own... etc.

I consider the idead of sharing journaling code as inefficient: arguing 
about the interface would take more time than writing it from scratch.

> Above provided, for the benefit of others, to give more context on the
> role of remap entries (and the commit block's remap array).

If there were no remaps, change in any B-tree node would require to 
overwrite all the nodes from the root. Similarly, changing any bitmap 
would require to overwrite the bitmap directory from the root.

With remaps, changes to B-tree nodes or bitmaps write just that one block 
(and commit block, to store the remap). The full write from the root is 
done later, when the remap table fills up.

Mikulas

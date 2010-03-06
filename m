From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [PATCH 03/14] dm-multisnap-mikulas-headers
Date: Fri, 5 Mar 2010 20:54:35 -0500
Message-ID: <20100306015435.GA8244@redhat.com>
References: <1267489438-6271-1-git-send-email-snitzer@redhat.com>
	<1267489438-6271-4-git-send-email-snitzer@redhat.com>
	<20100305224642.GA16425@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
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
To: dm-devel@redhat.com
Cc: Ric Wheeler <rwheeler@redhat.com>, Mikulas Patocka <mpatocka@redhat.com>
List-Id: dm-devel.ids

On Fri, Mar 05 2010 at  5:46pm -0500,
Mike Snitzer <snitzer@redhat.com> wrote:

> On Mon, Mar 01 2010 at  7:23pm -0500,
> Mike Snitzer <snitzer@redhat.com> wrote:
> 
> > From: Mikulas Patocka <mpatocka@redhat.com>
> > 
> > Common header files for the exception store.
> > 
> > dm-multisnap-mikulas-struct.h contains on-disk structure definitions.
> > 
> > dm-multisnap-mikulas.h contains in-memory structures and kernel function
> > prototypes.
> > 
> > Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
> > ---
> >  drivers/md/dm-multisnap-mikulas-struct.h |  380 ++++++++++++++++++++++++++++++
> >  drivers/md/dm-multisnap-mikulas.h        |  247 +++++++++++++++++++
> >  2 files changed, 627 insertions(+), 0 deletions(-)
> >  create mode 100644 drivers/md/dm-multisnap-mikulas-struct.h
> >  create mode 100644 drivers/md/dm-multisnap-mikulas.h
> > 
> > diff --git a/drivers/md/dm-multisnap-mikulas-struct.h b/drivers/md/dm-multisnap-mikulas-struct.h
> > new file mode 100644
> > index 0000000..39eaa16
> > --- /dev/null
> > +++ b/drivers/md/dm-multisnap-mikulas-struct.h
> 
> <snip>
> 
> > +/*
> > + *	Description of on-disk format:
> > + *
> > + * The device is composed of blocks (also called chunks). The block size (also
> > + * called chunk size) is specified in the superblock.
> > + *
> > + * The chunk and block mean the same. "chunk" comes from old snapshots.
> > + * "block" comes from filesystems. We tend to use "chunk" in
> > + * exception-store-independent code to make it consistent with snapshot
> > + * terminology and "block" in exception-store code to make it consistent with
> > + * filesystem terminology.
> > + *
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
> 
> > + *	Commit blocks
> > + *
> > + * Chunks 1, 1+cb_stride, 1+2*cb_stride, 1+3*cb_stride, etc. are commit blocks.
> > + * Chunks at these locations ((location % cb_stride) == 1) are only used for
> > + * commit blocks, they can't be used for anything else. A commit block is
> > + * written each time a new state is committed. The snapshot store transitions
> > + * from one consistent state to another consistent state by writing a commit
> > + * block.
> > + *
> > + * All commit blocks must be present and initialized (i.e. have valid signature
> > + * and sequence number). They are created when the device is initialized or
> > + * extended. It is not allowed to have random uninitialized data in any commit
> > + * block.
> > + *
> > + * For correctness, one commit block would be sufficient --- but to improve
> > + * performance and minimize seek times, there are multiple commit blocks and
> > + * we use the commit block that is near currently written data.
> > + *
> > + * The current commit block is stored in the super block. However, updates to
> > + * the super block would make excessive disk seeks too, so the updates to super
> > + * block are skipped if the commit block is written at the currently valid
> > + * commit block or at the next location following the currently valid commit
> > + * block. The following algorithm is used to find the commit block at mount:
> > + *	1. read the commit block multisnap_superblock->commit_block
> > + *	2. get its sequence number
> > + *	3. read the next commit block
> > + *	4. if the sequence number of the next commit block is higher than
> > + *	   the sequence number of the previous block, go to step 3. (i.e. read
> > + *	   another commit block)
> > + *	5. if the sequence number of the next commit block is lower than
> > + *	   the sequence number of the previous block, use the previous block
> > + *	   as the most recent valid commit block
> > + *
> > + * Note: because the disks only support atomic writes of 512 bytes, the commit
> > + * block has only 512 bytes of valid data. The remaining data in the commit
> > + * block up to the chunk size is unused.
> 
> Are there other places where you assume 512b is beneficial?  My concern
> is: what will happen on 4K devices?
> 
> Would making the commit block's size match the physical_block_size give
> us any multisnapshot benefit?  At a minimum I see a larger commit block
> would allow us to have more remap entries (larger remap
> array).. "Remaps" detailed below.  But what does that buy us?
> 
> However, and before I get ahead of myself, with blk_stack_limits() we
> could have a (DM) device that is composed of 4K and 512b devices; with a
> resulting physical_block_size of 4K.  But 4K wouldn't be atomic to the
> 512b disk.
> 
> But what if we were to add a checksum to the commit block?  This could
> give us the ability to have a larger commit block regardless of the
> physical_block_size. [NOTE: I saw dm_multisnap_commit() is just writing
> a fixed CB_SIGNATURE]
> 
> And in speaking with Ric Wheeler, using a checksum in the commit block
> opens up the possibility for optimizing (reducing) the barrier ops
> associated with:
> 1) before the commit block is written (flushes journal transaction) 
> 2) and after the commit block is written.
> 
> Leaving us with only needing to barrier after the commit block is
> written.  But this optimization apparently also requires having a
> checksummed journal.  Ext4 offers this (somewhat controversial yet fast)
> capability with the 'journal_async_commit' mount option. [NOTE: I'm
> largely parroting what I heard from Ric]
> 
> [NOTE: I couldn't immediately tell if dm_multisnap_commit() is doing
> multiple barriers when writing out the transaction and commit block]
> 
> Taking a step back, any reason you elected to not reuse existing kernel
> infrastructure (e.g. jbd2) for journaling?  Custom solution needed for
> the log-nature of the multisnapshot?  [Excuse my naive question(s), I
> see nilfs2 also has its own journaling... I'm just playing devil's
> advocate given how important it is that the multisnapshot journal code
> be correct]

Here is some additional detail on ext4's 'journal_async_commit':
http://marc.info/?l=linux-ext4&m=125263711211379&w=2
http://marc.info/?l=linux-ext4&m=125267485222449&w=2

Ted Tso acknowledged that the name 'journal_async_commit' is really a
misnomer here (I reference this post last because it contains an early
misunderstanding from Ted, that he corrects in the 1st url I referenced
above):
http://marc.info/?l=linux-ext4&m=125238515130681&w=2

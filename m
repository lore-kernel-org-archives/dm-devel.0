From: Eric Wheeler <dm-devel@lists.ewheeler.net>
Subject: Re: dm-thin: Several Questions on dm-thin performance.
Date: Thu, 5 Dec 2019 23:14:00 +0000 (UTC)
Message-ID: <alpine.LRH.2.11.1912041959250.11561@mx.ewheeler.net>
References: <35cf1ecf-5cd8-604b-ec4e-18c9fd4a4195@linux.alibaba.com>
	<20191122185530.pcrgmb655dkdbdcq@reti>
	<6b12137e-411e-0368-518e-41ae54e138e0@linux.alibaba.com>
	<alpine.LRH.2.11.1912022002210.11561@mx.ewheeler.net>
	<20191203125115.rdc74jgjdz2673ig@reti>
	<20191204121106.lw32xoe7mil274of@reti>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20191204121106.lw32xoe7mil274of@reti>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Joe Thornber <thornber@redhat.com>
Cc: JeffleXu <jefflexu@linux.alibaba.com>, dm-devel@redhat.com
List-Id: dm-devel.ids

Thanks Joe, great writeup.  Maybe this should go in thin-provisioning.txt.

More below:

On Wed, 4 Dec 2019, Joe Thornber wrote:

> (These notes are for my own benefit as much as anything, I haven't
> worked on this for a couple of years and will forget it all completely
> if I don't write it down somewhere).
> 
> Let's start by writing some pseudocode for what the remap function for
> thin provisioning actually does.
> 
> 	----------------------------------------------------------
> 	-- Metadata
> 
> 	newtype ThinId = Int
> 	data Bio = Bio
> 	newtype VBlock = Integer	-- virtual block
> 	newtype DBlock = Integer	-- data block

Can you define virtual block vs data block?  Is this just the thin volume 
offset vs the tdata offset?

> 
> 	data LookupResult =
> 	    Unprovisioned |
> 	    Provisioned { lrDBlock :: DataBlock,
> 	                  lrShared :: Bool
> 	                }

What is "lr"? as in lrDBlock?

> 	metadataLookup :: ThinId -> VBlock -> Task LookupResult
> 	metadataLookup = undefined
> 
> 	metadataInsert :: ThinId -> VBlock -> DBlock -> Task ()
> 	metadataInsert = undefined
> 
> 	metadataRemove :: ThinId -> VBlock -> Task ()
> 	metadataRemove = undefined
> 
> 	-- Blocks all other metadata operations while running
> 	metadataCommit :: Task ()
> 	metadataCommit = undefined
> 
> 	----------------------------------------------------------
> 	-- Tasks
> 
> 	-- Many steps of servicing a bio can block.  eg, taking a lock,
> 	-- reading metadata, updating metadata, zeroing data, copying
> 	-- data ...
> 	-- So we completely side step the issue in this pseudocode by
> 	-- running everything in a magic light weight thread.
> 	spawn :: Task () -> IO ()
> 	spawn = undefined
> 
> 	----------------------------------------------------------
> 	-- Locking
> 
> 	-- These 'with' primitives acquire a lock (can block of course), perform
> 	-- an action, and then automatically release the lock.
> 	 
> 	-- Shared lock can be upgraded, so we need to pass the lock into
> 	-- the action body.
> 	withSharedLock :: ThinId -> VBlock -> (Lock -> Task ()) -> Task ()
> 	withSharedLock thinId vblock actionFn = undefined
> 
> 	withExclusiveLock :: ThinId -> VBlock -> Task () -> Task ()
> 	withExclusiveLock thinId vblock action = undefined
> 
> 	-- This promotes a shared lock to exclusive.
> 	withUpgradedLock :: Lock -> Task () -> Task ()
> 	withUpgradedLock lock action = undefined
> 
> 	-- Data locks are always exclusive
> 	withDataLock :: DBlock -> Task () -> Task ()
> 	withDataLock dblock action = undefined
> 
> 	----------------------------------------------------------
> 
> 	-- Top level remap function.  Kicks off a green thread for each bio.
> 	-- How we handle a bio depends on whether it's a read, write, discard
> 	-- or flush bio.  Whether the block is already provisioned, and if so
> 	-- whether it is shared between snapshots.
> 	remap :: ThinId -> Bio -> IO ()
> 	remap thinId bio = spawn $ remapFn thinId bio vblock
> 	    where
> 	        vblock = virtBlock bio
> 	        remapFn = case classifyBio bio of
> 	            ReadBio -> remapRead
> 	            WriteBio -> remapWrite
> 	            DiscardBio -> remapDiscard
> 	            FlushBio -> remapFlush
> 
> 	----------------------------------------------------------
> 
> 	remapRead :: ThinId -> Bio -> VBlock -> Task ()
> 	remapRead thinId bio vblock = do
> 	    withSharedLock thinId vblock $ \_ -> do
> 	        lr <- metadataLookup thinId vblock
> 	        case lr of
> 	            -- Read, Unprovisioned, Shared/!Shared
> 	            Unprovisioned -> do
> 	                fillWithZeroes bio
> 	                complete bio Success
> 
> 	            -- Read, Provisioned, Shared/!Shared
> 	            (Provisioned dblock _) ->
> 	                remapAndWait bio dblock
> 
> 	----------------------------------------------------------
> 
> 	remapWrite :: ThinId -> Bio -> VBlock -> Task ()
> 	remapWrite thinId bio vblock = do
> 	    withSharedLock thinId vblock $ \lock -> do
> 	        lr <- metadataLookup thinId vblock
> 	        case lr of
> 	            -- Write, Unprovisioned
> 	            Unprovisioned ->
> 	                withUpgradedLock lock $
> 	                    provision thinId bio vblock
> 
> 	            -- Write, Provisioned, !Shared
> 	            (Provisioned dblock False) ->
> 	                remapAndWait bio dblock
> 
> 	            -- Write, Provisioned, Shared
> 	            (Provisioned dblock True) ->
> 	                withUpgradedLock lock $
> 	                    breakSharing thinId bio vblock dblock
> 
> 	breakSharing :: ThinId -> Bio -> VBlock -> DataBlock -> Task ()
> 	breakSharing thinId bio vblock dblockOld = do
> 	    ab <- allocateBlock
> 	   case ab of
> 	       NoDataSpace ->
> 	           complete bio Failure
> 
> 	       (Allocated dblockNew) ->
> 	           withDataLock dblockOld $		-- we grab data locks to avoid races with discard
> 	               withDataLock dblockNew $ do
> 	                   copy dblockOld dblockNew
> 	                   metadataInsert thinId vblock dblockNew
> 	           remapAndWait thinId bio dblockNew
> 
> 	provision :: ThinId -> Bio -> VBlock -> Task ()
> 	provision thinId bio vblock = do
> 	    case allocateBlock of
> 	        NoDataSpace ->
> 	            complete bio Failure
> 
> 	        (Allocated dblock) ->
> 	            withDataLock dblock $ do
> 	                metadataInsert thinId vblock dblock
> 	                remapAndWait thinId bio dblock

Does the allocator block?  If so, it would be neat to pre-allocate some 
number of blocks during metadata idle times.  There could be a hidden thin 
volume (ie, devid #16777215) that blocks are allocated into and then 
stolen from for use elsewhere.  The blocks could be pre-zeroed, too!

> 	            
> 	----------------------------------------------------------
> 
> 	discard :: ThinId -> Bio -> VBlock -> Task ()
> 	discard thinId bio vblock = do
> 	    withExclusiveLock thinId vblock $ do
> 	        lr <- metadataLookup thinId vblock
> 	        case lr of
> 	            -- Discard, Unprovisioned
> 	            Unprovisioned ->
> 	                complete bio Success
> 
> 	            -- Discard, Provisioned, !Shared
> 	            (Provisioned dblock False) ->
> 	                withDataLock dblock $ do
> 	                    remapAndWait bio dblock  		-- passdown
> 	                    metadataRemove thinId dblock
> 
> 	            -- Discard, Provisioned, Shared
> 	           (Provisioned dblock True) ->
> 	               withDataLock dblock $ do
> 	                   metadataRemove thinId dblock
> 	                   complete bio Success
> 
> 	----------------------------------------------------------
> 
> 	flush :: Task ()
> 	flush = metadataCommit
> 	    
> 	----------------------------------------------------------
> 
> 	remapAndWait :: Bio -> DataBlock -> Task ()
> 	remapAndWait bio dblock = do
> 	    remap bio dblock
> 	    issue bio
> 	    wait bio
>    
> The above is a simplification (eg, discards can cover more than a single
> block, the pool has multiple modes like OUT_OF_DATA_SPACE).  But it gives
> a good idea of what the dm target needs to do, and in a succinct manner.
> 
> Now dm-thin.c is anything but succinct, for a couple of reasons:
> 
> - Because of where we are in the IO stack we cannot allocate memory.
>   This means we either use memory preallocated via mempools, or allocate
>   a fixed size block before a bio is processed.
> 
> - We don't have a magic green threads library that hides the numerous
>   blocking operations that we need.  Instead we have low level facilities
>   like workqueues etc.  This tends to have the effect of breaking up the logic
>   and scattering it across lots of little completion functions.
> 
> 
> How we handle blocking, locking, and quiescing IO are all intertwined.
> Which is why switching over to the new bio_prison interface is going to
> involve an awful lot of churn.
> 
> In the upstream code
> ====================
> 
> - Locking
> 
>   The locks provided by bio_prison (v1), are all exclusive locks.  As such
>   we take pains to hold them for as short a period as possible.  This means
>   holding them for the duration of an IO is completely out of the question.
>   Nonetheless, as pointed out in the original post for this thread, this
>   can cause bad lock contention, especially if the data block size is large.
> 
> - Quiescing
> 
>   Because we do not hold locks for the lifetime of the bios, we need
>   another way of tracking IO and quiescing regions.  This is what the
>   deferred_set component does.  Effectively it divides time up into
>   bins, and keeps a reference count of how many IOs are still in flight
>   for each bin.  To quiesce we grab a lock, and then wait for all bins
>   before this lock was acquired to drain.  Advantages of this approach
>   is it uses very little memory (I think we're currently running with
>   64 bins), and consumes v. little cpu.  But we're never specific about

curious, is "v." short for "very" (not "versus")?

>   which region we're waiting to quiesce, instead always waiting for all
>   IO older than a certain point to drain.  So we are certainly introducing
>   more latency here.
> 
> - Blocking
> 
>   A single thread services any operations that could block.
>   When there is work for this thread to perform a work queue item
>   is queued (do_worker()).  This then examines linked lists of work
>   (prepared_mappings, discard_pt1, discard_pt2, prefetches etc), and
>   processes each list as a batch.  Batching like this is a mixed blessing;
>   it allows us to sort incoming bios so we can process bios to the same
>   region at the same time, but it is also v. bad for max latency, as we
>   have no idea which piece of work was there the longest.
> 
> Next iteration of the code
> ========================== 
> 
> - Locking
> 
>   bio_prison (v2) provides shared locks, and custom lock levels.  So,
>   at the expense of memory, we can hold shared locks for long periods
>   that cover the lifetime of the bio.  Acquiring a lock now blocks.
> 
> - Quiescing
> 
>   Because we hold the locks for long periods we can now do away with the
>   deferred set completely.  If you want to quiesce a region, just grab
>   the exclusive lock associated with it, when it's finally granted you
>   know it's also quiesced.
> 

good to know.

> - Blocking
> 
>   I want to move away from the idea of a single worker function that
>   has different categories of work stored for it in different lists.
>   Instead, storing specific work structs on the work queue for each bio.
>   Partly this is to reduce latency by increasing 'fairness'.  But also
>   the fact that acquiring a lock now blocks means there are a lot more
>   block operations to handle, and we'd just end up with a lot of these
>   lists of work.  It would also allow us to have multiple kernel threads
>   servicing the workqueue.
> 
>   If you look at dm-cache-target.c you'll see this has already been
>   done for that target.  We have continuation structs that represent
>   the work to be performed after the current blocking op has completed.
>   dm-cache uses this for migrations, which have a much simpler state model
>   than dm-thin.  Even so there are a lot of these little continuation
>   functions (eg, mg_start, mg_lock_writes, mg_copy, mg_full_copy,
>   mg_upgrade_lock, mg_update_metadata_after_copy, mg_update_metadata,
>   mg_success, mg_complete).
> 
> 
> Where are we now?
> =================
> 
> I did a lot of work on this a couple of years ago.  First I just dove
> in, trying to code things up by hand.  But it quickly devolved into a
> maze of badly named continuation functions, all alike.  It's very hard
> to give these functions meaningful names; go through the pseudocode at
> the top of this email and for each place where we could block, try to
> describe where we are.  The biggest problem is as we introduce more of
> these continuations big picture logic receeds and it becomes v. hard to
> reason about the code.

Event-driven continuation functions seem to pop up frequently in the Linux 
kernel.  It would be neat if there was a framework to write these 
procedurally.  Macros might help, could still be pretty ugly.  Almost 
needs GCC support.
 
> I then experimented with automatically generating all the code from a
> simpler specification (I used a lispy version of the pseudocode above).
> This showed promise and I got it generating kernel code that would
> compile.  I was debugging this when I got dragged onto other work,
> and this has stagnated since.

Do you think this is the best way to proceed?  Someone with Lisp 
background would need to help. It might generate first-pass code but would 
be difficult to maintain as kernel changes patch the auto-generated code.

-Eric

> 
> 
> So that's where we are.
>  
> 
> 
> 
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel
> 
> 

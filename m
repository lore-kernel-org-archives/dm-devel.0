From: Joe Thornber <thornber@redhat.com>
Subject: Re: [PATCHES] convert dm-thin to use dm-bufio
Date: Tue, 16 Aug 2011 10:16:01 +0100
Message-ID: <20110816091600.GA4284@ubuntu>
References: <Pine.LNX.4.64.1108141602440.28009@hs20-bc2-1.build.redhat.com>
	<20110815090416.GE3159@ubuntu>
	<Pine.LNX.4.64.1108151316300.18170@hs20-bc2-1.build.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.1108151316300.18170@hs20-bc2-1.build.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: dm-devel@redhat.com, "Alasdair G. Kergon" <agk@redhat.com>
List-Id: dm-devel.ids

On Mon, Aug 15, 2011 at 02:26:16PM -0400, Mikulas Patocka wrote:
> * Lock the root pointer specially
> 
> Thread 1 is splitting the root node and thread 2 is grabbing a read lock 
> on the root node. Then, when thread 1 unlocks the node, thread 2 locks the 
> node, but the node is no longer a root, so thread 2 sees only part of the 
> tree.

I'm not sure if you're talking about the superblock for the thin
metadata, or the root of any btree.

The lock I was talking about relaxing is the top level rw semaphore in
the the thin-metadata.  The locks on individual _blocks_ will still be
exclusive for writes.  So you can have concurrent lookups and inserts
happening in the btree, but the rolling locks scheme prevents races
(for instance the lookup overtaking the insert and accessing partially
written data).  This is a standard technique for copy-on-write btrees.
 
> Also, 64-bit numbers are not atomic on 32-bit architectures, thus if one 
> thread is splitting the root node and another thread is reading the root 
> block number, it can read garbage.
> 
> * Don't allow concurrent reads while you commit
> 
> * Don't allow concurrent reads when you delete something from the tree
> 
> * Don't allow concurrent reads when you increase reference counts (i.e. 
> cloning existing devices)

See answer above, I wasn't suggesting allowing reading and writing to
the same block concurrently.  So concurrent read with delete or
increasing ref counts is fine.

Concurrent reads with commit is more complicated, but not for the
reasons you give.  In this case we can let the reads run in parallel
with the commit, but we have to be careful to ensure they've completed
before we begin the new transaction to remove the possibility of recycling
one of the blocks that the read is accessing.

> > I admit it's ugly, but it _is_ used.  The need comes about from the
> > metadata device's lifetime being longer than that of the dm table that
> > opens it.  So when a different pool table is loaded we reopen the
> > metadata device and 'rebind' it under the block-manager.
> 
> BTW. what about this --- if function "pool_find" found an existing pool 
> based on equivalent "metadata_dev", instead of "pool_md" as it does now. I 
> think it would solve the rebind problem.

Originally I did bind on the metadata dev - this was the reason for
the extra metadata dev parameter in the thin target lines which was
used as the key to find the pool.

I don't think it gets round the problem that the metadata dev is
initially opened by a pool target that cannot be destroyed (or hence
reloaded) until all the devs it's opened have been closed.  So about a
month ago I was opening the metadata dev directly, rather than using
the dm_open_device thingy, which meant it could hang around longer
than the table.  I do however think the way it is now is cleaner,
because we don't duplicate dm_open_device.

> > This comment in the bufio header worries me:
> > 
> > + * WARNING: to avoid deadlocks, the thread can hold at most one buffer. Multiple
> > + * threads can hold each one buffer simultaneously.
> > 
> That comment is outdated, it currently supports several buffers. But only 
> one thread may hold multiple buffers (except threads that do only 
> dm_bm_read_try_lock).

That sounds perfect (why didn't you say this on the call yesterday
when asked about this?)

For me the main attraction to switching to bufio is you don't use
dm-io.c.

Hopefully Alasdair will allow you to keep the different memory types;
I was allocating the buffers in bm either via kmalloc, or pages
depending on size, but he wanted this changing to a kmem_cache in
order to 'segregate' the memory.

I'm not clear how you ascertain the correct working set size for your
cache, or choose when and how many blocks to flush.  Have you got any
documentation for this?  thinp shouldn't need a big cache and I'm a
bit worried a 'grab another buffer if there's memory available' policy
will make it grow too much.

- Joe

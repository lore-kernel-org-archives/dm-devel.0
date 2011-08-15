From: Mikulas Patocka <mpatocka@redhat.com>
Subject: Re: [PATCHES] convert dm-thin to use dm-bufio
Date: Mon, 15 Aug 2011 14:26:16 -0400 (EDT)
Message-ID: <Pine.LNX.4.64.1108151316300.18170@hs20-bc2-1.build.redhat.com>
References: <Pine.LNX.4.64.1108141602440.28009@hs20-bc2-1.build.redhat.com>
	<20110815090416.GE3159@ubuntu>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20110815090416.GE3159@ubuntu>
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
Cc: dm-devel@redhat.com, "Alasdair G. Kergon" <agk@redhat.com>
List-Id: dm-devel.ids

> > Notes:
> > 
> > * Buffer locking is not supported, I suppose it is not used for anything 
> > anyway. If it is used, tell me, I can add it after reviewing it.
> 
> Locking is used throughout the btree code, and the persistent-data
> library in general.  The only thing stopping us getting the benefit
> specifically in thinp is the big rw lock in dm_thin_metadata.c.  As
> the code matures I plan to relax this lock to allow one writer,
> multiple readers.  We've spoken about this before.

If you want to relax this locking, you need:

* Lock the root pointer specially

Thread 1 is splitting the root node and thread 2 is grabbing a read lock 
on the root node. Then, when thread 1 unlocks the node, thread 2 locks the 
node, but the node is no longer a root, so thread 2 sees only part of the 
tree.

Also, 64-bit numbers are not atomic on 32-bit architectures, thus if one 
thread is splitting the root node and another thread is reading the root 
block number, it can read garbage.

* Don't allow concurrent reads while you commit

* Don't allow concurrent reads when you delete something from the tree

* Don't allow concurrent reads when you increase reference counts (i.e. 
cloning existing devices)

> Aside from that the locking is great for debugging.  I'd have it for
> that alone, and consider turning it off for release builds.
> 
> So, I'm not going to back down on the locking.  If we merge
> block-manager/bufio we need locking in the interface.
> 
> > * dm_bm_rebind_block_device changes the block device, but it is not used 
> > for anything (dm-thinp never changes the device). I think it could be 
> > removed.
> 
> I admit it's ugly, but it _is_ used.  The need comes about from the
> metadata device's lifetime being longer than that of the dm table that
> opens it.  So when a different pool table is loaded we reopen the
> metadata device and 'rebind' it under the block-manager.

BTW. what about this --- if function "pool_find" found an existing pool 
based on equivalent "metadata_dev", instead of "pool_md" as it does now. I 
think it would solve the rebind problem.

> > * Two small bugs in dm-thin are fixed --- not closing the superblock 
> > buffer on exit and improper termination sequence (the block devices were 
> > closed before the buffer interface exited).
> 
> Thx, I'll grab these.
> 
> 
> This comment in the bufio header worries me:
> 
> + * WARNING: to avoid deadlocks, the thread can hold at most one buffer. Multiple
> + * threads can hold each one buffer simultaneously.
> 
> There are many cases where persistent-data holds 2 locks, (eg, rolling
> locks as we update the spine of a btree).  Also the superblock is
> currently held while transactions are open (we can easily change
> this).  Is this limitation easy to get round?

That comment is outdated, it currently supports several buffers. But only 
one thread may hold multiple buffers (except threads that do only 
dm_bm_read_try_lock).

Mikulas

> - Joe
> 

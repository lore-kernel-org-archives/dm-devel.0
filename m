From: Joe Thornber <thornber@redhat.com>
Subject: Re: [PATCHES] convert dm-thin to use dm-bufio
Date: Mon, 15 Aug 2011 10:04:17 +0100
Message-ID: <20110815090416.GE3159@ubuntu>
References: <Pine.LNX.4.64.1108141602440.28009@hs20-bc2-1.build.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.1108141602440.28009@hs20-bc2-1.build.redhat.com>
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

On Sun, Aug 14, 2011 at 04:18:29PM -0400, Mikulas Patocka wrote:
> * It has dynamic cache sizing, cache size can be configured by the user. 
> In case of inactivity over some time (a buffer is unused for a minute), 
> the buffers are freed. The original code had cache size hardcoded and it 
> couldn't be changed.

A big advantage, something that would have to be done for dm-block-manager.c.
 
> * Submit bios directly (if we can) without dm-io layer.

Also good.

> Notes:
> 
> * Buffer locking is not supported, I suppose it is not used for anything 
> anyway. If it is used, tell me, I can add it after reviewing it.

Locking is used throughout the btree code, and the persistent-data
library in general.  The only thing stopping us getting the benefit
specifically in thinp is the big rw lock in dm_thin_metadata.c.  As
the code matures I plan to relax this lock to allow one writer,
multiple readers.  We've spoken about this before.

Aside from that the locking is great for debugging.  I'd have it for
that alone, and consider turning it off for release builds.

So, I'm not going to back down on the locking.  If we merge
block-manager/bufio we need locking in the interface.

> * dm_bm_rebind_block_device changes the block device, but it is not used 
> for anything (dm-thinp never changes the device). I think it could be 
> removed.

I admit it's ugly, but it _is_ used.  The need comes about from the
metadata device's lifetime being longer than that of the dm table that
opens it.  So when a different pool table is loaded we reopen the
metadata device and 'rebind' it under the block-manager.

> * Two small bugs in dm-thin are fixed --- not closing the superblock 
> buffer on exit and improper termination sequence (the block devices were 
> closed before the buffer interface exited).

Thx, I'll grab these.


This comment in the bufio header worries me:

+ * WARNING: to avoid deadlocks, the thread can hold at most one buffer. Multiple
+ * threads can hold each one buffer simultaneously.

There are many cases where persistent-data holds 2 locks, (eg, rolling
locks as we update the spine of a btree).  Also the superblock is
currently held while transactions are open (we can easily change
this).  Is this limitation easy to get round?


- Joe

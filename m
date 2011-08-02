From: Joe Thornber <thornber@redhat.com>
Subject: Re: Review of dm-block-manager.c
Date: Tue, 2 Aug 2011 14:07:55 +0100
Message-ID: <20110802130755.GA26994@ubuntu>
References: <Pine.LNX.4.64.1108011620590.9983@hs20-bc2-1.build.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.1108011620590.9983@hs20-bc2-1.build.redhat.com>
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

Hi Mikulas,

Thanks for taking the time to review.

On Mon, Aug 01, 2011 at 05:00:32PM -0400, Mikulas Patocka wrote:
> Hi
> 
> This is review of dm-block-manager.c:
> 
> 
> char buffer_cache_name[32];
> sprintf(bm->buffer_cache_name, "dm_block_buffer-%d:%d",
> --- it may not fit in 32 bytes.
> 
> 
> __wait_block uses TASK_INTERRUPTIBLE sleep and returns error code 
> -ERESTARTSYS if interrupted by a signal. But this error code is never 
> checked. Consequently, if the process receives a signal, this signal will 
> interrupt waiting, and the rest of the buffer management code will 
> mistakenly think that the event to wait for happened.
> This should be replaced by TASK_UNINTERRUPTIBLE sleep and functions 
> __wait_io, __wait_unlocked, __wait_read_lockable, __wait_all_writes, 
> __wait_all_io, __wait_clean be changed to return void (because their 
> return code is never checked anyway).

ok.  Sounds simple.

> The code uses only a spinlock to protect it state. When the spinlock is 
> dropped (for example during wait), the buffer may have been reused for 
> other purposes, but it is not checked. There is a comment "/* FIXME: Can b 
> have been recycled between io completion and here? */" indicating that Joe 
> is aware of the problem.

Yep.

> b->write_lock_pending++;
> __wait_unlocked(b, &flags);
> b->write_lock_pending--;
> if (b->where != block)
>         goto retry;
> If the buffer was reused while we were waiting, b->write_lock_pending was 
> already reset to zero (in __transition BS_EMPTY). We decrement it to 
> 0xffffffff.

Sounds like the same block recycling issue.

> Error buffers are linked in error_list and this list is only flushed at a 
> specific case (in __wait_flush). If there are many i/o errors (for 
> example, the disk is unplugged) and __wait_flush is not called 
> sufficiently often, all existing buffers will be moved to error_list and 
> then the code deadlocks as there would be no empty or clean buffers.

Ouch.


> The code uses fixed-size cache of 4096 buffers and a single process may 
> hold more than one buffer. This may deadlock in case of massive 
> parallelism --- for example, imagine that 4096 processes come 
> concurrently, each process requesting two buffers --- each process 
> allocates one buffer and then a deadlock happens, each process is waiting 
> for some free buffer that never comes. (this bug existed already the last 
> year when I looked at the code)

There isn't that degree of parallelism.  We can't have multiple
threads pulling the cache in different directions for performance
reasons.  So we have multiple threads that use this in a non-blocking
mode.  ie. they use the try_lock variants, and only get the data if
it's already available in the cache.  If the non-blocking requests
failed then it gets passed across for a worker thread to deal with.
This is the only thread that updates the cache.  There is no issue
here.

Fancy digging through the btree next?  Or submitting patches for the
above?

- Joe

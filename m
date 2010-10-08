From: Daniel Stodden <daniel.stodden@citrix.com>
Subject: Q: Device mapper core and private biosets
Date: Fri, 8 Oct 2010 15:20:39 -0700
Message-ID: <1286576439.16468.71.camel@agari.van.xensource.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: DM-devel <dm-devel@redhat.com>
List-Id: dm-devel.ids


Hi.

I'm presently trying to fix a couple issues in a kernel module which
shares some properties with DM. It's called blktap and used quite
extensively in Xen. It's basically I/O virtualization in userspace, and
so it forwards I/O on block devices to a userspace app. The userspace
part would commonly translate requests to one or a number of disk nodes.

The common base is stacking devices. Without precautions, the result is
a number of deadlock hazards when memory congestion comes into play.

Can maybe someone help me on how this was dealt with in DM? I couldn't
explain a couple things looking at DM code so I'm wondering if maybe
even DM still has a problem. It's mainly about mempools involved. Not
necessarily limited to bio_alloc.

I found a couple DM patch on those matters, eg.

http://www.spinics.net/lists/dm-devel/msg03578.html

So one obvious problem is bio allocation above and below the upper level
request queue. (That's the one addressed above.) If both ends allocate
from the same bio pool, the upper layer exhausts it, and free memory is
short, then the the lower levels will starve, and both get stuck that
way.

The way this is commonly dealt with is to separate biosets between
layers, which ensures that both can always make progress. DM does it, as
does blk-core. Cool.

Now, one potential problem I still see is is the following: Imagine a
large number of dirty pages over a DM node. So some thread starts
queueing those pages. Requests get translated, translated request are
allocated. When allocating from the pooled objects, I can see stuff like
the following happen. All in mempool_alloc.

   1. First iteration is set ~__GFP_WAIT.
   2. Still no memory, so it fails, and falls back to the pool.
   3. pool curr_nr is 0, so we got to sleep on pool->wait.
   4. I/O was in flight, and will complete, so once objects
      get returned, pool->wait wakes us.

   Now the interesting bit:

   5. Next iteration resets __GFP_WAIT to 1.
   6. The mempool retries the (slab) allocator first, not the pool.

Seen on 2.6.32, but I don't think that code moved a lot recently.

So I got two questions:

When retrying, is the __GFP_WAIT being reset even desirable? It means
the calling thread is likely to wait on disk I/O. The pool is known to
have seen a refill through mempool_free, so that waiting pool->alloc can
get much slower than wanted. The pool->alloc itself is fine, it's that
wait bit which scares me.

Second, when waiting, how does DM make sure the private bioset
allocations never block on a page queued on its own device? That would
be a (potential) deadlock scenario again, the most simple case is when
that page entry directly depends on the lower level object to make
progress.

To me this all seems to boil down to that gfp_temp = gfp_mask line in
mempool_alloc.

Any good idea on this would be very much appreciated.

Thanks.

Daniel

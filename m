From: Frank Mayhar <fmayhar@google.com>
Subject: Re: dm: Make MIN_IOS, et al, tunable via sysctl.
Date: Thu, 22 Aug 2013 10:26:49 -0700
Message-ID: <1377192409.24869.116.camel@bobble.lax.corp.google.com>
References: <1376070533.26057.244.camel@bobble.lax.corp.google.com>
	<alpine.LRH.2.02.1308201712090.8826@file01.intranet.prod.int.rdu2.redhat.com>
	<1377034118.24869.48.camel@bobble.lax.corp.google.com>
	<alpine.LRH.2.02.1308201745130.8826@file01.intranet.prod.int.rdu2.redhat.com>
	<1377035833.24869.57.camel@bobble.lax.corp.google.com>
	<20130820222439.GA5883@redhat.com>
	<1377040462.24869.70.camel@bobble.lax.corp.google.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1377040462.24869.70.camel@bobble.lax.corp.google.com>
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
Cc: device-mapper development <dm-devel@redhat.com>, Mikulas Patocka <mpatocka@redhat.com>
List-Id: dm-devel.ids

On Tue, 2013-08-20 at 16:14 -0700, Frank Mayhar wrote:
> On Tue, 2013-08-20 at 18:24 -0400, Mike Snitzer wrote:
> > Mikulas' point is that you cannot reduce the size to smaller than 1.
> > And aside from rq-based DM, 1 is sufficient to allow for forward
> > progress even when memory is completely consumed.
> > 
> > A patch that simply changes them to 1 but makes the rq-based DM
> > mempool's size configurable should actually be fine.
> 
> So you're saying that I should submit a patch to drop the pool size for
> BIO_BASED to 1 and make the pool size for REQUEST_BASED configurable?
> At the moment, in dm.c the former is hardcoded to 16 and the latter is
> set via MIN_IOS (currently 256).  There's also io_pool, a slab pool,
> which is also set via MIN_IOS.
> 
> How does this relate to the rest of the DM modules?  Mpath also sets
> MIN_IOS to 256 and creates a slab pool from that, and there are a number
> of hardcoded constants in dm-io (MIN_IOS and MIN_BIOS), dm-snap
> (MIN_IOS), dm-crypt (MIN_IOS and MIN_POOL_PAGES), dm-bufio
> (DM_BUFIO_HASH_BITS, which is allocated via vmalloc per client) and
> dm-verity (DM_VERITY_MEMPOOL_SIZE, which is allocated per device).
> 
> For the most part I can't imagine that people will want to change these
> from their defaults, but when someone does need to change one of these,
> they need to do so badly and there's currently no good way to do that
> besides hacking the source and building a new kernel.
> 
> By the way, I do appreciate the advice.  I'm just trying to clear up
> confusion on my part, make sure that our needs are met and, while I'm at
> it, make things a bit better for those who come after me.

Ping?  Can one of you guys answer my question, here?  Thanks!
-- 
Frank Mayhar
310-460-4042

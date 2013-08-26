From: Mikulas Patocka <mpatocka@redhat.com>
Subject: Re: dm: Make MIN_IOS, et al, tunable via sysctl.
Date: Mon, 26 Aug 2013 10:28:49 -0400 (EDT)
Message-ID: <alpine.LRH.2.02.1308261012400.12373@file01.intranet.prod.int.rdu2.redhat.com>
References: <1376070533.26057.244.camel@bobble.lax.corp.google.com>  <alpine.LRH.2.02.1308201712090.8826@file01.intranet.prod.int.rdu2.redhat.com>  <1377034118.24869.48.camel@bobble.lax.corp.google.com>  <alpine.LRH.2.02.1308201745130.8826@file01.intranet.prod.int.rdu2.redhat.com>
  <1377035833.24869.57.camel@bobble.lax.corp.google.com>  <20130820222439.GA5883@redhat.com> <1377040462.24869.70.camel@bobble.lax.corp.google.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1377040462.24869.70.camel@bobble.lax.corp.google.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Frank Mayhar <fmayhar@google.com>
Cc: Mike Snitzer <snitzer@redhat.com>, device-mapper development <dm-devel@redhat.com>, linux-kernel@vger.kernel.org
List-Id: dm-devel.ids



On Tue, 20 Aug 2013, Frank Mayhar wrote:

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

In case of request-based io, yes, submit a patch that makes it 
configurable.

Regarding bio-based io - there is:
pools->io_pool = mempool_create_slab_pool(MIN_IOS, cachep); allocating a 
pool of 256 entries. I think it could be reduced to 16 for bio based 
devices, like other pools.

As for reducing 16 further down to 1 - do you have a setup where it really 
helps? Please describe your system - the amount of memory, the number of 
dm devices, and how much memory is saved by reducing the mempools from 16 
to 1.

> How does this relate to the rest of the DM modules?  Mpath also sets
> MIN_IOS to 256 and creates a slab pool from that, and there are a number
> of hardcoded constants in dm-io (MIN_IOS and MIN_BIOS), dm-snap
> (MIN_IOS),

In dm-snap you shouldn't reduce it because it can cause failure.

> dm-crypt (MIN_IOS and MIN_POOL_PAGES), dm-bufio
> (DM_BUFIO_HASH_BITS, which is allocated via vmalloc per client) and

dm-bufio hash could be reduced - one possibility is to auto-tune it based 
on device size, another possibility is to allocate shared hash table for 
all devices.

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
> -- 
> Frank Mayhar
> 310-460-4042

Mikulas

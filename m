From: Mikulas Patocka <mpatocka@redhat.com>
Subject: Re: [PATCH 2/2] dm-writecache
Date: Fri, 22 Dec 2017 15:56:46 -0500 (EST)
Message-ID: <alpine.LRH.2.02.1712221531320.26891@file01.intranet.prod.int.rdu2.redhat.com>
References: <alpine.LRH.2.02.1711222135371.2330@file01.intranet.prod.int.rdu2.redhat.com>
	<CAA9_cmcRe8KXO+jWy8knqg4EMCgBYF1JAdgR=A2qHkVES+i9ZA@mail.gmail.com>
	<alpine.LRH.2.02.1711272238130.9280@file01.intranet.prod.int.rdu2.redhat.com>
	<CAPcyv4jTuSLDiO1TZhCrJGxMWiWK-KNXKPf-DZH1xDeXVAaUgQ@mail.gmail.com>
	<alpine.LRH.2.02.1712050003070.13380@file01.intranet.prod.int.rdu2.redhat.com>
	<CAPcyv4i=XfG-pQYHKLKvwP_SeMxc+PaWOJYSGQ0rsbJ=9GC6iQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <CAPcyv4i=XfG-pQYHKLKvwP_SeMxc+PaWOJYSGQ0rsbJ=9GC6iQ@mail.gmail.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Dan Williams <dan.j.williams@intel.com>
Cc: device-mapper development <dm-devel@redhat.com>, Mike Snitzer <msnitzer@redhat.com>
List-Id: dm-devel.ids



On Fri, 8 Dec 2017, Dan Williams wrote:

> > > What about memcpy_flushcache?
> >
> > but
> >
> > - using memcpy_flushcache is overkill if we need just one or two 8-byte
> > writes to the metadata area. Why not use movnti directly?
> >
> 
> The driver performs so many 8-byte moves that the cost of the
> memcpy_flushcache() function call significantly eats into your
> performance?
>
> > - on some architctures, memcpy_flushcache is just an alias for memcpy, so
> > there will still be some arch-specific ifdefs
> 
> ...but those should all be hidden by arch code, not in drivers.
> 
> > - there is no architecture-neutral way how to guarantee ordering between
> > multiple memcpy_flushcache calls. On x86, we need wmb(), on Power we
> > don't, on ARM64 I don't know (arch_wb_cache_pmem calls dmb(osh),
> > memcpy_flushcache doesn't - I don't know what are the implications of this
> > difference) on other architectures, wmb() is insufficient to guarantee
> > ordering between multiple memcpy_flushcache calls.
> 
> wmb() should always be sufficient to order stores on all architectures.

No, it isn't. See this example:

uint64_t var_a, var_b;

void fn(void)
{
	uint64_t val = 3;
	memcpy_flushcache(&var_a, &val, 8);
	wmb();
	val = 5;
	memcpy_flushcache(&var_b, &val, 8);;
}

On x86-64, memcpy_flushcache is implemented using the movnti instruction 
(that writes the value to the write-combining buffer) and wmb() is 
compiled into the sfence instruction (that flushes the write-combining 
buffer) - so it's OK - it is guaranteed that the variable var_a is written 
to persistent memory before the variable var_b;

However, on i686 (and most other architectures), memcpy_flushcache is just 
an alias for memcpy - see this code in include/linux/string.h:
#ifndef __HAVE_ARCH_MEMCPY_FLUSHCACHE
static inline void memcpy_flushcache(void *dst, const void *src, size_t 
cnt)
{
        memcpy(dst, src, cnt);
}
#endif

So, memcpy_flushcache writes the variable var_a to the cache, wmb() 
flushes the pipeline, but otherwise does nothing (because on i686 all 
writes to the cache are already ordered) and then memcpy_flushcache writes 
the variable var_b to the cache - however, both writes end up in cache and 
wmb() doesn't flush the cache. So wmb() doesn't provide any sort of 
guarantee that var_a is written to persistent memory before var_b. If the 
cache sector containing the variable var_b is more contended than the 
cache sector containg the variable var_a, the CPU will flush cache line 
containing var_b before var_a.

We have the dax_flush() function that (unlike wmb) guarantees that the 
specified range is flushed from the cache and written to persistent 
memory. But dax_flush is very slow on x86-64.

So, we have a situation where wmb() is fast, but it only guarantees 
ordering on x86-64 and dax_flush() that guarantees ordering on all 
architectures, but it is slow on x86-64.

So, my driver uses wmb() on x86-64 and dax_flush() on all the others.

You argue that the driver shouldn't use any per-architecture #ifdefs, but 
there is no other way how to do it - using dax_flush() on x86-64 kills 
performance and using wmb() on all architectures is unreliable because 
wmb() doesn't guarantee cache flushing at all.

> > At least for Broadwell, the write-back memory type on persistent memory
> > has so horrible performance that it not really usable.
> 
> ...and my concern is that you're designing a pmem driver mechanism for
> Broadwell that predates the clwb instruction for efficient pmem
> access.

That's what we have for testing. If I get access to some Skylake server, I 
can test if using write combining is faster than cache flushing.

Mikulas

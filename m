From: Dan Williams <dan.j.williams@intel.com>
Subject: Re: [PATCH 2/2] dm-writecache
Date: Fri, 8 Dec 2017 18:10:07 -0800
Message-ID: <CAPcyv4i=XfG-pQYHKLKvwP_SeMxc+PaWOJYSGQ0rsbJ=9GC6iQ@mail.gmail.com>
References: <alpine.LRH.2.02.1711222135371.2330@file01.intranet.prod.int.rdu2.redhat.com>
	<CAA9_cmcRe8KXO+jWy8knqg4EMCgBYF1JAdgR=A2qHkVES+i9ZA@mail.gmail.com>
	<alpine.LRH.2.02.1711272238130.9280@file01.intranet.prod.int.rdu2.redhat.com>
	<CAPcyv4jTuSLDiO1TZhCrJGxMWiWK-KNXKPf-DZH1xDeXVAaUgQ@mail.gmail.com>
	<alpine.LRH.2.02.1712050003070.13380@file01.intranet.prod.int.rdu2.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <alpine.LRH.2.02.1712050003070.13380@file01.intranet.prod.int.rdu2.redhat.com>
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
Cc: device-mapper development <dm-devel@redhat.com>, Mike Snitzer <msnitzer@redhat.com>
List-Id: dm-devel.ids

On Mon, Dec 4, 2017 at 9:40 PM, Mikulas Patocka <mpatocka@redhat.com> wrote:
> On Mon, 27 Nov 2017, Dan Williams wrote:
[..]
> > > So, according to the document, flushing the cache should be enough for
> > > writes to reach persistent memory.
> >
> > The document assumes ADR is present.
>
> Could there be a case where persistent memory is present, but ADR is not?

No, that's why it was safe to deprecate the pcommit instruction,
software can assume that once writes reach the memory controller they
are persistent and there is no requirement to flush them through the
memory controller to media which is what the pcommit instruction
performed.

> > > > > +#ifdef CONFIG_X86_64
> > > >
> > > > In general something is broken if we end up with per-arch ifdefs like
> > > > this in drivers to handle persistent memory. This should be using the
> > > > pmem api or extensions of it, and we need to settle on a mechanism for
> > > > upper-level drivers to ask if pmem is driving platform protected
> > > > persistent memory.
> > > >
> > > > > +#define NT_STORE(dest, src)    asm ("movnti %1, %0" : "=m"(dest) : "r"(src))
> > > > > +#define FLUSH_RANGE(dax, ptr, size)  do { } while (0)
> > > > > +#define COMMIT_FLUSHED()       wmb()
> > > > > +#else
> > > > > +#define NT_STORE(dest, src)    ACCESS_ONCE(dest) = (src)
> > > > > +#define FLUSH_RANGE            dax_flush
> > > > > +#define COMMIT_FLUSHED()       do { } while (0)
> > > >
> > > > Is this just for test purposes? How does the user discover that they
> > > > are running in a degraded mode as far as persistence guarantees? I
> > > > think we should be falling back DM_WRITECACHE_ONLY_SSD mode if we're
> > > > not on a pmem platform.
> > >
> > > What degraded mode do you mean?
> >
> > Fall back to treating pmem like an SSD / block-device.
>
> If the dm-writecache driver cannot reliably flush cache - then the
> /dev/pmem block device driver couldn't reliably flush cache neither.

Right, but the pmem driver warns when it can't detect that it is
running on a persistent memory enabled platform. I'm saying we should
turn that warning into an api so that in-kernel consumers of pmem can
make the same warning or determination to disable functionality on
non-pmem capable platforms.

> > > According to that document, flushing cache
> > > should be enough. If it is not enough, what else do I need to do to flush
> > > cache?
> >
> > ...ensure that you are on a platform where flushing the cpu cache is enough.
> >
> > > The above code is not for test purposes. It is for performance purposes.
> > >
> > > On dual-socket Broadwell server with persistent memory
> >
> > What platform is this... does it have ADR, does the BIOS produce an NFIT?
>
> I don't know. I already released the machine for someone else. If you
> want, I can try to re-acquire the access to it.

As long as your driver consumes the new/TBD in-kernel api to determine
if the platform is pmem-enabled or not then I think we're good. My
concern is that we're optimizing the kernel interfaces for a platform
that does not support pmem, or requires a pmem support approach that
we would abandon when the clwb instruction can replace clflush usage.

>
> > > when we write to
> > > persistent memory using cached write instructions and use dax_flush
> > > afterwards to flush cache for the affected range, the performance is about
> > > 350MB/s. It is practically unusable - worse than low-end SSDs.
> > >
> > > On the other hand, the movnti instruction can sustain performance of one
> > > 8-byte write per clock cycle. We don't have to flush cache afterwards, the
> > > only thing that must be done is to flush the write-combining buffer with
> > > the sfence instruction. Movnti has much better throughput than dax_flush.
> >
> > What about memcpy_flushcache?
>
> but
>
> - using memcpy_flushcache is overkill if we need just one or two 8-byte
> writes to the metadata area. Why not use movnti directly?
>

The driver performs so many 8-byte moves that the cost of the
memcpy_flushcache() function call significantly eats into your
performance?

> - on some architctures, memcpy_flushcache is just an alias for memcpy, so
> there will still be some arch-specific ifdefs

...but those should all be hidden by arch code, not in drivers.

> - there is no architecture-neutral way how to guarantee ordering between
> multiple memcpy_flushcache calls. On x86, we need wmb(), on Power we
> don't, on ARM64 I don't know (arch_wb_cache_pmem calls dmb(osh),
> memcpy_flushcache doesn't - I don't know what are the implications of this
> difference) on other architectures, wmb() is insufficient to guarantee
> ordering between multiple memcpy_flushcache calls.

wmb() should always be sufficient to order stores on all architectures.

>
> - on Power and ARM64, memcpy_flushcache just does memcpy and flushes the
> cache afterwards. What is better for performance? Is is better to do
> multiple memcpy calls and later multiple dax_flush calls? Or is it better
> to do multiple memcpy_flushcache calls and no dax_flush? On x86, the
> latter is clearly benefical, but I don't know if it would also be
> benefical on ARM64 and Power.
>
> > > You argue that I should use the pmem api, but there is no pmem api
> > > providing the movnti intruction. I have no choice, but coding the
> > > instruction directly in assembler.
> >
> > You have not convinced me that memcpy_flushcache is insufficient, or
> > that the driver is mistakenly assuming guarantees about persistence
> > when it is not running on a persistent memory enabled platform.
>
> See above.
>
> > > If you want to create API, take that "NT_STORE" definition and move it to
> > > some x86-specific include file.
> >
> > I'm asking you to not solve global problems in your local driver. If
> > the pmem api is deficient for your use case then let's work on
> > improving it, but as of now I'm still trying to baseline your
> > assumptions.
>
> I'm thinking that perhaps a proper solution would be to map the persistent
> memory always as write combining - and then we wouldn't have ponder how to
> do write-combining writes into write-back memory type.

Yes, if memcpy_flushcache() really is overkill then it might be better
to just mark the memory write-through for that use. I need to go look
if there is any concerns with use PAT to mark a range WT when the
MTRRs have it marked WB.

Another alternative is to convert this driver to use the same
interfaces that the BTT driver uses. See nvdimm_write_bytes().

> At least for Broadwell, the write-back memory type on persistent memory
> has so horrible performance that it not really usable.

...and my concern is that you're designing a pmem driver mechanism for
Broadwell that predates the clwb instruction for efficient pmem
access.

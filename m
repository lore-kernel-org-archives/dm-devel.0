From: Mikulas Patocka <mpatocka@redhat.com>
Subject: Re: [PATCH 2/2] dm-writecache
Date: Mon, 27 Nov 2017 23:01:43 -0500 (EST)
Message-ID: <alpine.LRH.2.02.1711272238130.9280@file01.intranet.prod.int.rdu2.redhat.com>
References: <alpine.LRH.2.02.1711222135371.2330@file01.intranet.prod.int.rdu2.redhat.com>
	<CAA9_cmcRe8KXO+jWy8knqg4EMCgBYF1JAdgR=A2qHkVES+i9ZA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <CAA9_cmcRe8KXO+jWy8knqg4EMCgBYF1JAdgR=A2qHkVES+i9ZA@mail.gmail.com>
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



On Fri, 24 Nov 2017, Dan Williams wrote:

> On Wed, Nov 22, 2017 at 6:36 PM, Mikulas Patocka <mpatocka@redhat.com> wrote:
> > Hi
> >
> > Here I'm sending slighly update dm-writecache target.
> >
> 
> I would expect some theory of operation documentation in the changelog
> or in Documentation/ for a new driver.

It caches writes for a block device in persistent memory. It doesn't cache 
reads because reads are supposed to be cached in normal ram.

> > Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
> >
> [..]
> > +/*
> > + * The clflushopt instruction is very slow on Broadwell, so we use non-temporal
> > + * stores instead.
> > + */
> 
> The clflushopt instruction's first instantiation in a cpu was after
> Broadwell. Also, the performance of clflushopt does not much matter
> when running on a system without ADR (asynchronous DRAM refresh) where
> flushing the cpu cache can just leave the writes stranded on their way
> to the DIMM. ADR is not available on general purpose servers until
> ACPI 6.x NFIT-defined persistent memory platforms.

There used to be pcommit instruction, but intel abandoned it - see 
https://software.intel.com/en-us/blogs/2016/09/12/deprecate-pcommit-instruction

So, according to the document, flushing the cache should be enough for 
writes to reach persistent memory.

> > +#ifdef CONFIG_X86_64
> 
> In general something is broken if we end up with per-arch ifdefs like
> this in drivers to handle persistent memory. This should be using the
> pmem api or extensions of it, and we need to settle on a mechanism for
> upper-level drivers to ask if pmem is driving platform protected
> persistent memory.
> 
> > +#define NT_STORE(dest, src)    asm ("movnti %1, %0" : "=m"(dest) : "r"(src))
> > +#define FLUSH_RANGE(dax, ptr, size)  do { } while (0)
> > +#define COMMIT_FLUSHED()       wmb()
> > +#else
> > +#define NT_STORE(dest, src)    ACCESS_ONCE(dest) = (src)
> > +#define FLUSH_RANGE            dax_flush
> > +#define COMMIT_FLUSHED()       do { } while (0)
> 
> Is this just for test purposes? How does the user discover that they
> are running in a degraded mode as far as persistence guarantees? I
> think we should be falling back DM_WRITECACHE_ONLY_SSD mode if we're
> not on a pmem platform.

What degraded mode do you mean? According to that document, flushing cache 
should be enough. If it is not enough, what else do I need to do to flush 
cache?


The above code is not for test purposes. It is for performance purposes.

On dual-socket Broadwell server with persistent memory, when we write to 
persistent memory using cached write instructions and use dax_flush 
afterwards to flush cache for the affected range, the performance is about 
350MB/s. It is practically unusable - worse than low-end SSDs.

On the other hand, the movnti instruction can sustain performance of one 
8-byte write per clock cycle. We don't have to flush cache afterwards, the 
only thing that must be done is to flush the write-combining buffer with 
the sfence instruction. Movnti has much better throughput than dax_flush.

You argue that I should use the pmem api, but there is no pmem api 
providing the movnti intruction. I have no choice, but coding the 
instruction directly in assembler.

If you want to create API, take that "NT_STORE" definition and move it to 
some x86-specific include file.

Mikulas

From: Mikulas Patocka <mpatocka@redhat.com>
Subject: Re: [PATCH] memcpy_flushcache: use cache flusing for larger
 lengths
Date: Thu, 9 Apr 2020 10:36:17 -0400 (EDT)
Message-ID: <alpine.LRH.2.02.2004090612320.27517@file01.intranet.prod.int.rdu2.redhat.com>
References: <alpine.LRH.2.02.2004071029270.8662@file01.intranet.prod.int.rdu2.redhat.com> <CAPcyv4goJ2jbXNVZbMUKtRUominhuMhuTKrMh=fnhrfvC4jyjw@mail.gmail.com> <alpine.LRH.2.02.2004081439080.13932@file01.intranet.prod.int.rdu2.redhat.com>
 <CAPcyv4grNHvyYEc4W6PkymhEJvLb17tXbC3JZdqvtFxmMZ8DCQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAPcyv4grNHvyYEc4W6PkymhEJvLb17tXbC3JZdqvtFxmMZ8DCQ@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, "H. Peter Anvin" <hpa@zytor.com>, Peter Zijlstra <peterz@infradead.org>, X86 ML <x86@kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids



On Wed, 8 Apr 2020, Dan Williams wrote:

> On Wed, Apr 8, 2020 at 11:54 AM Mikulas Patocka <mpatocka@redhat.com> wrote:
> >
> >
> >
> > On Tue, 7 Apr 2020, Dan Williams wrote:
> >
> > > On Tue, Apr 7, 2020 at 8:02 AM Mikulas Patocka <mpatocka@redhat.com> wrote:
> > > >
> > > This should use clwb instead of clflushopt, the clwb macri
> > > automatically converts back to clflushopt if clwb is not supported.
> >
> > But we want to invalidate cache, we do not expect CPU to access these data
> > anymore (it will be accessed by a DMA engine during writeback).
> 
> The cluflushopt and clwb instructions should have identical overhead,
> but clwb wins on the rare chance the written data is needed again
> soon. If it is never needed again then the cost of dropping a clean
> cache line is the same as if the line was invalidated in the first
> instance. In both cases (clflushopt and clwb) the snoop traffic
> overhead is still paid whether the written-back line is still present
> in the cache or not.

But my concern is that clflushopt removes the line from the cache and 
makes room for another line (this is desired behavior) - clwb keeps the 
line cached and the line would have to compete with other cache lines in 
the same associative set.

Do you know how does the CPU select the cache line to be replaced?

dm-writecache is intended to be used for workloads like database logs that 
need extra-low commit latency. The committed data is not read back during 
normal workload.

> > > > Other ideas - should we introduce memcpy_to_pmem instead of modifying
> > > > memcpy_flushcache and move this logic there? Or should I modify the
> > > > dm-writecache target directly to use clflushopt with no change to the
> > > > architecture-specific code?
> > >
> > > This also needs to mention your analysis that showed that this can
> > > have negative cache pollution effects [1], so I'm not sure how to
> > > decide when to make the tradeoff. Once we have movdir64b the tradeoff
> > > equation changes yet again:
> > >
> > > [1]: https://lore.kernel.org/linux-nvdimm/alpine.LRH.2.02.2004010941310.23210@file01.intranet.prod.int.rdu2.redhat.com/
> >
> > I analyzed it some more. I have created this program that tests writecache
> > w.r.t. cache pollution:
> >
> > http://people.redhat.com/~mpatocka/testcases/pmem/misc/l1-test-2.c
> >
> > It fills the cache with a chain of random pointers and then walks these
> > pointers to evaluate cache pollution. Between the walks, it writes data to
> > the dm-writecache target.
> >
> > With the original kernel, the result is:
> > 8503 - 11366
> > real    0m7.985s
> > user    0m0.585s
> > sys     0m7.390s
> >
> > With dm-writecache hacked to use cached writes + clflushopt:
> > 8513 - 11379
> > real    0m5.045s
> > user    0m0.670s
> > sys     0m4.365s
> >
> > So, the hacked dm-writecache is significantly faster, while the cache
> > micro-benchmark doesn't show any more cache pollution.
> 
> Nice. These are now the pmem numbers, or dram?

pmem


With dm-writecache on emulated pmem (with the memmap argument), we get

With the original kernel:
8508 - 11378
real    0m4.960s
user    0m0.638s
sys     0m4.312s

With dm-writecache hacked to use cached writes + clflushopt:
8505 - 11378
real    0m4.151s
user    0m0.560s
sys     0m3.582s

So - clflushopt is still slightly better.

> Otherwise, what changed that was making nt-writes on pmem perform better 
> compared to your previous test? I'm just trying to track the results.

I re-ran the previous test 
( http://people.redhat.com/~mpatocka/testcases/pmem/misc/l1-test.c )
and the result is this:

Write + clflushopt:
./l1-test /dev/ram0 f
8502 - 22616
./l1-test /dev/dax3.0 f
8502 - 22902
./l1-test /dev/dax4.0 f
8500 - 11970

Write + clwb:
./l1-test /dev/ram0 w
8502 - 22602
./l1-test /dev/dax3.0 w
8502 - 22454
./l1-test /dev/dax4.0 w
8502 - 11566

Non-temporal stores:
./l1-test /dev/ram0 n
8504 - 22162
./l1-test /dev/dax3.0 n
8502 - 12336
./l1-test /dev/dax4.0 n
8502 - 10662

(/dev/dax3.0 is the real persistent memory, /dev/dax4.0 is pmem emulated 
with the memmap parameter)

"./l1-test /dev/ram0 n" is slower than "./l1-test /dev/dax4.0 n" while 
both of these tests are on RAM. The pmem is mapped with large pages and 
mem map for ramdisk is not - perhaps this is making the difference?

"./l1-test /dev/dax3.0 n" is better than "./l1-test /dev/dax3.0 w" and 
"./l1-test /dev/dax3.0 f" - although the benchmaks done on dm-writecache 
show that cached writes + clflushopt perform better. I don't know why 
there is this disparity.

> > That's for dm-writecache. Are there some other significant users of
> > memcpy_flushcache that need to be checked?
> 
> The only other user is direct and dax-I/O to the pmem driver.

Mikulas

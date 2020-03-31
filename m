From: Mikulas Patocka <mpatocka@redhat.com>
Subject: Re: [PATCH v2] memcpy_flushcache: use cache flusing for
 larger lengths
Date: Tue, 31 Mar 2020 07:58:34 -0400 (EDT)
Message-ID: <alpine.LRH.2.02.2003310709090.2117@file01.intranet.prod.int.rdu2.redhat.com>
References: <alpine.LRH.2.02.2003291625590.32108@file01.intranet.prod.int.rdu2.redhat.com>
	<alpine.LRH.2.02.2003300729320.9938@file01.intranet.prod.int.rdu2.redhat.com>
	<CS1PR8401MB12377197482867F688BF93F7ABC80@CS1PR8401MB1237.NAMPRD84.PROD.OUTLOOK.COM>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <CS1PR8401MB12377197482867F688BF93F7ABC80@CS1PR8401MB1237.NAMPRD84.PROD.OUTLOOK.COM>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: "Elliott, Robert (Servers)" <elliott@hpe.com>
Cc: Mike Snitzer <msnitzer@redhat.com>, Dave Jiang <dave.jiang@intel.com>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, Vishal Verma <vishal.l.verma@intel.com>, "dm-devel@redhat.com" <dm-devel@redhat.com>, Dan Williams <dan.j.williams@intel.com>, Ira Weiny <ira.weiny@intel.com>
List-Id: dm-devel.ids



On Tue, 31 Mar 2020, Elliott, Robert (Servers) wrote:

> 
> 
> > -----Original Message-----
> > From: Mikulas Patocka <mpatocka@redhat.com>
> > Sent: Monday, March 30, 2020 6:32 AM
> > To: Dan Williams <dan.j.williams@intel.com>; Vishal Verma
> > <vishal.l.verma@intel.com>; Dave Jiang <dave.jiang@intel.com>; Ira
> > Weiny <ira.weiny@intel.com>; Mike Snitzer <msnitzer@redhat.com>
> > Cc: linux-nvdimm@lists.01.org; dm-devel@redhat.com
> > Subject: [PATCH v2] memcpy_flushcache: use cache flusing for larger
> > lengths
> > 
> > I tested dm-writecache performance on a machine with Optane nvdimm
> > and it turned out that for larger writes, cached stores + cache
> > flushing perform better than non-temporal stores. This is the
> > throughput of dm- writecache measured with this command:
> > dd if=/dev/zero of=/dev/mapper/wc bs=64 oflag=direct
> > 
> > block size	512		1024		2048		4096
> > movnti	496 MB/s	642 MB/s	725 MB/s	744 MB/s
> > clflushopt	373 MB/s	688 MB/s	1.1 GB/s	1.2 GB/s
> > 
> > We can see that for smaller block, movnti performs better, but for
> > larger blocks, clflushopt has better performance.
> 
> There are other interactions to consider... see threads from the last
> few years on the linux-nvdimm list.

dm-writecache is the only linux driver that uses memcpy_flushcache on 
persistent memory. There is also the btt driver, it uses the "do_io" 
method to write to persistent memory and I don't know where this method 
comes from.

Anyway, if patching memcpy_flushcache conflicts with something else, we 
should introduce memcpy_flushcache_to_pmem.

> For example, software generally expects that read()s take a long time and
> avoids re-reading from disk; the normal pattern is to hold the data in
> memory and read it from there. By using normal stores, CPU caches end up
> holding a bunch of persistent memory data that is probably not going to
> be read again any time soon, bumping out more useful data. In contrast,
> movnti avoids filling the CPU caches.

But if I write one cacheline and flush it immediatelly, it would consume 
just one associative entry in the cache.

> Another option is the AVX vmovntdq instruction (if available), the
> most recent of which does 64-byte (cache line) sized transfers to
> zmm registers. There's a hefty context switching overhead (e.g.,
> 304 clocks), and the CPU often runs AVX instructions at a slower
> clock frequency, so it's hard to judge when it's worthwhile.

The benchmark shows that 64-byte non-temporal avx512 vmovntdq is as good 
as 8, 16 or 32-bytes writes.
                                         ram            nvdimm
sequential write-nt 4 bytes              4.1 GB/s       1.3 GB/s
sequential write-nt 8 bytes              4.1 GB/s       1.3 GB/s
sequential write-nt 16 bytes (sse)       4.1 GB/s       1.3 GB/s
sequential write-nt 32 bytes (avx)       4.2 GB/s       1.3 GB/s
sequential write-nt 64 bytes (avx512)    4.1 GB/s       1.3 GB/s

With cached writes (where each cache line is immediatelly followed by clwb 
or clflushopt), 8, 16 or 32-byte write performs better than non-temporal 
stores and avx512 performs worse.

sequential write 8 + clwb                5.1 GB/s       1.6 GB/s
sequential write 16 (sse) + clwb         5.1 GB/s       1.6 GB/s
sequential write 32 (avx) + clwb         4.4 GB/s       1.5 GB/s
sequential write 64 (avx512) + clwb      1.7 GB/s       0.6 GB/s


> In user space, glibc faces similar choices for its memcpy() functions;
> glibc memcpy() uses non-temporal stores for transfers > 75% of the
> L3 cache size divided by the number of cores. For example, with
> glibc-2.216-16.fc27 (August 2017), on a Broadwell system with
> E5-2699 36 cores 45 MiB L3 cache, non-temporal stores are used
> for memcpy()s over 36 MiB.

BTW. what does glibc do with reads? Does it flush them from the cache 
after they are consumed?

AFAIK glibc doesn't support persistent memory - i.e. there is no function 
that flushes data and the user has to use inline assembly for that.

> It'd be nice if glibc, PMDK, and the kernel used the same algorithms.

Mikulas

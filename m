From: "Elliott, Robert (Servers)" <elliott@hpe.com>
Subject: Re: [PATCH v2] memcpy_flushcache: use cache flusing for
 larger lengths
Date: Tue, 31 Mar 2020 00:28:01 +0000
Message-ID: <CS1PR8401MB12377197482867F688BF93F7ABC80@CS1PR8401MB1237.NAMPRD84.PROD.OUTLOOK.COM>
References: <alpine.LRH.2.02.2003291625590.32108@file01.intranet.prod.int.rdu2.redhat.com>
	<alpine.LRH.2.02.2003300729320.9938@file01.intranet.prod.int.rdu2.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <alpine.LRH.2.02.2003300729320.9938@file01.intranet.prod.int.rdu2.redhat.com>
Content-Language: en-US
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Mikulas Patocka <mpatocka@redhat.com>, Dan Williams <dan.j.williams@intel.com>, Vishal Verma <vishal.l.verma@intel.com>, Dave
	Jiang <dave.jiang@intel.com>, Ira Weiny <ira.weiny@intel.com>, Mike Snitzer <msnitzer@redhat.com>
Cc: "dm-devel@redhat.com" <dm-devel@redhat.com>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-Id: dm-devel.ids



> -----Original Message-----
> From: Mikulas Patocka <mpatocka@redhat.com>
> Sent: Monday, March 30, 2020 6:32 AM
> To: Dan Williams <dan.j.williams@intel.com>; Vishal Verma
> <vishal.l.verma@intel.com>; Dave Jiang <dave.jiang@intel.com>; Ira
> Weiny <ira.weiny@intel.com>; Mike Snitzer <msnitzer@redhat.com>
> Cc: linux-nvdimm@lists.01.org; dm-devel@redhat.com
> Subject: [PATCH v2] memcpy_flushcache: use cache flusing for larger
> lengths
> 
> I tested dm-writecache performance on a machine with Optane nvdimm
> and it turned out that for larger writes, cached stores + cache
> flushing perform better than non-temporal stores. This is the
> throughput of dm- writecache measured with this command:
> dd if=/dev/zero of=/dev/mapper/wc bs=64 oflag=direct
> 
> block size	512		1024		2048		4096
> movnti	496 MB/s	642 MB/s	725 MB/s	744 MB/s
> clflushopt	373 MB/s	688 MB/s	1.1 GB/s	1.2 GB/s
> 
> We can see that for smaller block, movnti performs better, but for
> larger blocks, clflushopt has better performance.

There are other interactions to consider... see threads from the last
few years on the linux-nvdimm list.

For example, software generally expects that read()s take a long time and
avoids re-reading from disk; the normal pattern is to hold the data in
memory and read it from there. By using normal stores, CPU caches end up
holding a bunch of persistent memory data that is probably not going to
be read again any time soon, bumping out more useful data. In contrast,
movnti avoids filling the CPU caches.

Another option is the AVX vmovntdq instruction (if available), the
most recent of which does 64-byte (cache line) sized transfers to
zmm registers. There's a hefty context switching overhead (e.g.,
304 clocks), and the CPU often runs AVX instructions at a slower
clock frequency, so it's hard to judge when it's worthwhile.

In user space, glibc faces similar choices for its memcpy() functions;
glibc memcpy() uses non-temporal stores for transfers > 75% of the
L3 cache size divided by the number of cores. For example, with
glibc-2.216-16.fc27 (August 2017), on a Broadwell system with
E5-2699 36 cores 45 MiB L3 cache, non-temporal stores are used
for memcpy()s over 36 MiB.

It'd be nice if glibc, PMDK, and the kernel used the same algorithms.

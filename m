From: Mikulas Patocka <mpatocka@redhat.com>
Subject: Re: [PATCH] memcpy_flushcache: use cache flusing for
 larger lengths
Date: Thu, 16 Apr 2020 04:24:20 -0400 (EDT)
Message-ID: <alpine.LRH.2.02.2004160411460.7833@file01.intranet.prod.int.rdu2.redhat.com>
References: <alpine.LRH.2.02.2004071029270.8662@file01.intranet.prod.int.rdu2.redhat.com>
	<CAPcyv4goJ2jbXNVZbMUKtRUominhuMhuTKrMh=fnhrfvC4jyjw@mail.gmail.com>
	<alpine.LRH.2.02.2004081439080.13932@file01.intranet.prod.int.rdu2.redhat.com>
	<CAPcyv4grNHvyYEc4W6PkymhEJvLb17tXbC3JZdqvtFxmMZ8DCQ@mail.gmail.com>
	<alpine.LRH.2.02.2004090612320.27517@file01.intranet.prod.int.rdu2.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <alpine.LRH.2.02.2004090612320.27517@file01.intranet.prod.int.rdu2.redhat.com>
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
Cc: Peter Zijlstra <peterz@infradead.org>, X86 ML <x86@kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, device-mapper development <dm-devel@redhat.com>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>
List-Id: dm-devel.ids



On Thu, 9 Apr 2020, Mikulas Patocka wrote:

> With dm-writecache on emulated pmem (with the memmap argument), we get
> 
> With the original kernel:
> 8508 - 11378
> real    0m4.960s
> user    0m0.638s
> sys     0m4.312s
> 
> With dm-writecache hacked to use cached writes + clflushopt:
> 8505 - 11378
> real    0m4.151s
> user    0m0.560s
> sys     0m3.582s

I did some multithreaded tests: 
http://people.redhat.com/~mpatocka/testcases/pmem/microbenchmarks/pmem-multithreaded.txt

And it turns out that for singlethreaded access, write+clwb performs 
better, while for multithreaded access, non-temporal stores perform 
better.

1       sequential write-nt 8 bytes             1.3 GB/s
2       sequential write-nt 8 bytes             2.5 GB/s
3       sequential write-nt 8 bytes             2.8 GB/s
4       sequential write-nt 8 bytes             2.8 GB/s
5       sequential write-nt 8 bytes             2.5 GB/s

1       sequential write 8 bytes + clwb         1.6 GB/s
2       sequential write 8 bytes + clwb         2.4 GB/s
3       sequential write 8 bytes + clwb         1.7 GB/s
4       sequential write 8 bytes + clwb         1.2 GB/s
5       sequential write 8 bytes + clwb         0.8 GB/s

For one thread, we can see that write-nt 8 bytes has 1.3 GB/s and write 
8+clwb has 1.6 GB/s, but for multiple threads, write-nt has better 
throughput.

The dm-writecache target is singlethreaded (all the copying is done while 
holding the writecache lock), so it benefits from clwb.

Should memcpy_flushcache be changed to write+clwb? Or are there some 
multithreaded users of memcpy_flushcache that would be hurt by this 
change?

Mikulas

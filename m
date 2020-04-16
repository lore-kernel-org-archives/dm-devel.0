From: Dan Williams <dan.j.williams@intel.com>
Subject: Re: [PATCH] memcpy_flushcache: use cache flusing for larger lengths
Date: Thu, 16 Apr 2020 11:28:08 -0700
Message-ID: <CAPcyv4gpe8u=zNrRhvd9ioVNGbOJfRUXzFZuV--be6Hbj0xXtQ@mail.gmail.com>
References: <alpine.LRH.2.02.2004071029270.8662@file01.intranet.prod.int.rdu2.redhat.com>
 <CAPcyv4goJ2jbXNVZbMUKtRUominhuMhuTKrMh=fnhrfvC4jyjw@mail.gmail.com>
 <alpine.LRH.2.02.2004081439080.13932@file01.intranet.prod.int.rdu2.redhat.com>
 <CAPcyv4grNHvyYEc4W6PkymhEJvLb17tXbC3JZdqvtFxmMZ8DCQ@mail.gmail.com>
 <alpine.LRH.2.02.2004090612320.27517@file01.intranet.prod.int.rdu2.redhat.com>
 <alpine.LRH.2.02.2004160411460.7833@file01.intranet.prod.int.rdu2.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <alpine.LRH.2.02.2004160411460.7833@file01.intranet.prod.int.rdu2.redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, "H. Peter Anvin" <hpa@zytor.com>, Peter Zijlstra <peterz@infradead.org>, X86 ML <x86@kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

On Thu, Apr 16, 2020 at 1:24 AM Mikulas Patocka <mpatocka@redhat.com> wrote:
>
>
>
> On Thu, 9 Apr 2020, Mikulas Patocka wrote:
>
> > With dm-writecache on emulated pmem (with the memmap argument), we get
> >
> > With the original kernel:
> > 8508 - 11378
> > real    0m4.960s
> > user    0m0.638s
> > sys     0m4.312s
> >
> > With dm-writecache hacked to use cached writes + clflushopt:
> > 8505 - 11378
> > real    0m4.151s
> > user    0m0.560s
> > sys     0m3.582s
>
> I did some multithreaded tests:
> http://people.redhat.com/~mpatocka/testcases/pmem/microbenchmarks/pmem-multithreaded.txt
>
> And it turns out that for singlethreaded access, write+clwb performs
> better, while for multithreaded access, non-temporal stores perform
> better.
>
> 1       sequential write-nt 8 bytes             1.3 GB/s
> 2       sequential write-nt 8 bytes             2.5 GB/s
> 3       sequential write-nt 8 bytes             2.8 GB/s
> 4       sequential write-nt 8 bytes             2.8 GB/s
> 5       sequential write-nt 8 bytes             2.5 GB/s
>
> 1       sequential write 8 bytes + clwb         1.6 GB/s
> 2       sequential write 8 bytes + clwb         2.4 GB/s
> 3       sequential write 8 bytes + clwb         1.7 GB/s
> 4       sequential write 8 bytes + clwb         1.2 GB/s
> 5       sequential write 8 bytes + clwb         0.8 GB/s
>
> For one thread, we can see that write-nt 8 bytes has 1.3 GB/s and write
> 8+clwb has 1.6 GB/s, but for multiple threads, write-nt has better
> throughput.
>
> The dm-writecache target is singlethreaded (all the copying is done while
> holding the writecache lock), so it benefits from clwb.
>
> Should memcpy_flushcache be changed to write+clwb? Or are there some
> multithreaded users of memcpy_flushcache that would be hurt by this
> change?

Maybe this is asking for a specific memcpy_flushcache_inatomic()
implementation for your use case, but leave nt-writes for the general
case?

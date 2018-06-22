From: Mikulas Patocka <mpatocka@redhat.com>
Subject: Re: [PATCH v2 RESEND] x86: optimize memcpy_flushcache
Date: Thu, 21 Jun 2018 21:19:27 -0400 (EDT)
Message-ID: <alpine.LRH.2.02.1806211224470.19940@file01.intranet.prod.int.rdu2.redhat.com>
References: <20180519052503.325953342@debian.vm>
	<20180519052631.730455475@debian.vm>
	<CAPcyv4jpY0x7kZtT+afAKnHKy8Uy1AC_N_QM7RrELSj_0iNrRw@mail.gmail.com>
	<20180524182013.GA59755@redhat.com>
	<20180618132306.GA25431@redhat.com>
	<20180621143140.GA14095@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20180621143140.GA14095@gmail.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Ingo Molnar <mingo@kernel.org>
Cc: Mike Snitzer <snitzer@redhat.com>, X86 ML <x86@kernel.org>, linux-kernel@vger.kernel.org, device-mapper development <dm-devel@redhat.com>, Thomas Gleixner <tglx@linutronix.de>, Dan Williams <dan.j.williams@intel.com>
List-Id: dm-devel.ids



On Thu, 21 Jun 2018, Ingo Molnar wrote:

> 
> * Mike Snitzer <snitzer@redhat.com> wrote:
> 
> > From: Mikulas Patocka <mpatocka@redhat.com>
> > Subject: [PATCH v2] x86: optimize memcpy_flushcache
> > 
> > In the context of constant short length stores to persistent memory,
> > memcpy_flushcache suffers from a 2% performance degradation compared to
> > explicitly using the "movnti" instruction.
> > 
> > Optimize 4, 8, and 16 byte memcpy_flushcache calls to explicitly use the
> > movnti instruction with inline assembler.
> 
> Linus requested asm optimizations to include actual benchmarks, so it would be 
> nice to describe how this was tested, on what hardware, and what the before/after 
> numbers are.
> 
> Thanks,
> 
> 	Ingo

It was tested on 4-core skylake machine with persistent memory being 
emulated using the memmap kernel option. The dm-writecache target used the 
emulated persistent memory as a cache and sata SSD as a backing device. 
The patch results in 2% improved throughput when writing data using dd.

I don't have access to the machine anymore.

Mikulas

From: Ingo Molnar <mingo@kernel.org>
Subject: Re: [PATCH v2 RESEND] x86: optimize memcpy_flushcache
Date: Fri, 22 Jun 2018 03:30:49 +0200
Message-ID: <20180622013049.GA12505@gmail.com>
References: <20180519052503.325953342@debian.vm>
 <20180519052631.730455475@debian.vm>
 <CAPcyv4jpY0x7kZtT+afAKnHKy8Uy1AC_N_QM7RrELSj_0iNrRw@mail.gmail.com>
 <20180524182013.GA59755@redhat.com>
 <20180618132306.GA25431@redhat.com>
 <20180621143140.GA14095@gmail.com>
 <alpine.LRH.2.02.1806211224470.19940@file01.intranet.prod.int.rdu2.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <alpine.LRH.2.02.1806211224470.19940@file01.intranet.prod.int.rdu2.redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: Mike Snitzer <snitzer@redhat.com>, Thomas Gleixner <tglx@linutronix.de>, Dan Williams <dan.j.williams@intel.com>, device-mapper development <dm-devel@redhat.com>, X86 ML <x86@kernel.org>, linux-kernel@vger.kernel.org
List-Id: dm-devel.ids


* Mikulas Patocka <mpatocka@redhat.com> wrote:

> On Thu, 21 Jun 2018, Ingo Molnar wrote:
> 
> > 
> > * Mike Snitzer <snitzer@redhat.com> wrote:
> > 
> > > From: Mikulas Patocka <mpatocka@redhat.com>
> > > Subject: [PATCH v2] x86: optimize memcpy_flushcache
> > > 
> > > In the context of constant short length stores to persistent memory,
> > > memcpy_flushcache suffers from a 2% performance degradation compared to
> > > explicitly using the "movnti" instruction.
> > > 
> > > Optimize 4, 8, and 16 byte memcpy_flushcache calls to explicitly use the
> > > movnti instruction with inline assembler.
> > 
> > Linus requested asm optimizations to include actual benchmarks, so it would be 
> > nice to describe how this was tested, on what hardware, and what the before/after 
> > numbers are.
> > 
> > Thanks,
> > 
> > 	Ingo
> 
> It was tested on 4-core skylake machine with persistent memory being 
> emulated using the memmap kernel option. The dm-writecache target used the 
> emulated persistent memory as a cache and sata SSD as a backing device. 
> The patch results in 2% improved throughput when writing data using dd.
> 
> I don't have access to the machine anymore.

I think this information is enough, but do we know how well memmap emulation 
represents true persistent memory speed and cache management characteristics?
It might be representative - but I don't know for sure, nor probably most
readers of the changelog.

So could you please put all this into an updated changelog, and also add a short 
description that outlines exactly which codepaths end up using this method in a 
typical persistent memory setup? All filesystem ops - or only reads, etc?

Thanks,

	Ingo

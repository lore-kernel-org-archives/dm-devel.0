From: Ingo Molnar <mingo@kernel.org>
Subject: Re: [PATCH v3 RESEND] x86: optimize memcpy_flushcache
Date: Mon, 10 Sep 2018 15:18:00 +0200
Message-ID: <20180910131800.GA41487@gmail.com>
References: <20180519052503.325953342@debian.vm>
 <20180519052631.730455475@debian.vm>
 <CAPcyv4jpY0x7kZtT+afAKnHKy8Uy1AC_N_QM7RrELSj_0iNrRw@mail.gmail.com>
 <20180524182013.GA59755@redhat.com>
 <20180618132306.GA25431@redhat.com>
 <20180621143140.GA14095@gmail.com>
 <alpine.LRH.2.02.1806211224470.19940@file01.intranet.prod.int.rdu2.redhat.com>
 <20180622013049.GA12505@gmail.com>
 <alpine.LRH.2.02.1808081720460.24747@file01.intranet.prod.int.rdu2.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <alpine.LRH.2.02.1808081720460.24747@file01.intranet.prod.int.rdu2.redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: Mike Snitzer <snitzer@redhat.com>, Thomas Gleixner <tglx@linutronix.de>, Dan Williams <dan.j.williams@intel.com>, device-mapper development <dm-devel@redhat.com>, X86 ML <x86@kernel.org>, linux-kernel@vger.kernel.org
List-Id: dm-devel.ids


* Mikulas Patocka <mpatocka@redhat.com> wrote:

> Here I resend it:
> 
> 
> From: Mikulas Patocka <mpatocka@redhat.com>
> Subject: [PATCH] x86: optimize memcpy_flushcache
> 
> I use memcpy_flushcache in my persistent memory driver for metadata
> updates, there are many 8-byte and 16-byte updates and it turns out that
> the overhead of memcpy_flushcache causes 2% performance degradation
> compared to "movnti" instruction explicitly coded using inline assembler.
> 
> The tests were done on a Skylake processor with persistent memory emulated
> using the "memmap" kernel parameter. dd was used to copy data to the
> dm-writecache target.
> 
> This patch recognizes memcpy_flushcache calls with constant short length
> and turns them into inline assembler - so that I don't have to use inline
> assembler in the driver.
> 
> Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
> 
> ---
>  arch/x86/include/asm/string_64.h |   20 +++++++++++++++++++-
>  arch/x86/lib/usercopy_64.c       |    4 ++--
>  2 files changed, 21 insertions(+), 3 deletions(-)

Applied to tip:x86/asm, thanks!

I'll push it out later today after some testing.

Thanks,

	Ingo

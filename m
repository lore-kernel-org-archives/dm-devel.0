From: Ingo Molnar <mingo@kernel.org>
Subject: Re: [PATCH v2 RESEND] x86: optimize memcpy_flushcache
Date: Thu, 21 Jun 2018 16:31:40 +0200
Message-ID: <20180621143140.GA14095@gmail.com>
References: <20180519052503.325953342@debian.vm>
 <20180519052631.730455475@debian.vm>
 <CAPcyv4jpY0x7kZtT+afAKnHKy8Uy1AC_N_QM7RrELSj_0iNrRw@mail.gmail.com>
 <20180524182013.GA59755@redhat.com>
 <20180618132306.GA25431@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180618132306.GA25431@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Mike Snitzer <snitzer@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Mikulas Patocka <mpatocka@redhat.com>, Dan Williams <dan.j.williams@intel.com>, device-mapper development <dm-devel@redhat.com>, X86 ML <x86@kernel.org>, linux-kernel@vger.kernel.org
List-Id: dm-devel.ids


* Mike Snitzer <snitzer@redhat.com> wrote:

> From: Mikulas Patocka <mpatocka@redhat.com>
> Subject: [PATCH v2] x86: optimize memcpy_flushcache
> 
> In the context of constant short length stores to persistent memory,
> memcpy_flushcache suffers from a 2% performance degradation compared to
> explicitly using the "movnti" instruction.
> 
> Optimize 4, 8, and 16 byte memcpy_flushcache calls to explicitly use the
> movnti instruction with inline assembler.

Linus requested asm optimizations to include actual benchmarks, so it would be 
nice to describe how this was tested, on what hardware, and what the before/after 
numbers are.

Thanks,

	Ingo

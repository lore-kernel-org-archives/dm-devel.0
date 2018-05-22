From: Jeff Moyer <jmoyer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [dm-devel] [patch 4/4] dm-writecache: use new API for flushing
Date: Tue, 22 May 2018 18:53:39 -0400
Message-ID: <x49r2m3nvyk.fsf@segfault.boston.devel.redhat.com>
References: <20180519052503.325953342@debian.vm>
 <20180519052635.567438191@debian.vm>
 <20180522063946.GB8054@infradead.org>
 <20180522184103.GA25826@redhat.com>
 <CAPcyv4g395RccdEPF=sCu5RdCH9zwD+GvOfSp7-F0Oh64CeDgA@mail.gmail.com>
 <20180522191942.GB25904@redhat.com>
 <CAPcyv4hWswV=VCfB7KatoW_zc-kUUju2jD45N-Gsg4sW-XFe-A@mail.gmail.com>
 <20180522205214.GA26259@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
In-Reply-To: <20180522205214.GA26259-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> (Mike Snitzer's message of
 "Tue, 22 May 2018 16:52:17 -0400")
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
List-Help: <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=subscribe>
Errors-To: linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
To: Mike Snitzer <snitzer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Mikulas Patocka <mpatocka-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, device-mapper development <dm-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-nvdimm <linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
List-Id: dm-devel.ids

Hi, Mike,

Mike Snitzer <snitzer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> writes:

> Looking at Mikulas' wrapper API that you and hch are calling into
> question:
>
> For ARM it is using arch/arm64/mm/flush.c:arch_wb_cache_pmem().
> (And ARM does seem to be providing CONFIG_ARCH_HAS_PMEM_API.)
>
> Whereas x86_64 is using memcpy_flushcache() as provided by
> CONFIG_ARCH_HAS_UACCESS_FLUSHCACHE.
> (Yet ARM does provide arch/arm64/lib/uaccess_flushcache.c:memcpy_flushcache)
>
> Just seems this isn't purely about ARM lacking on an API level (given on
> x86_64 Mikulas isn't only using CONFIG_ARCH_HAS_PMEM_API).
>
> Seems this is more to do with x86_64 having efficient Non-temporal
> stores?

Yeah, I think you've got that all right.

> Anyway, I'm still trying to appreciate the details here before I can
> make any forward progress.

Making data persistent on x64 requires 3 steps:
1) copy the data into pmem   (store instructions)
2) flush the cache lines associated with the data (clflush, clflush_opt, clwb)
3) wait on the flush to complete (sfence)

I'm not sure if other architectures require step 3.  Mikulas'
implementation seems to imply that arm64 doesn't require the fence.

The current pmem api provides:

memcpy*           -- step 1
memcpy_flushcache -- this combines steps 1 and 2
dax_flush         -- step 2
wmb*              -- step 3

* not strictly part of the pmem api

So, if you didn't care about performance, you could write generic code
that only used memcpy, dax_flush, and wmb (assuming other arches
actually need the wmb).  What Mikulas did was to abstract out an API
that could be called by generic code that would work optimally on all
architectures.

This looks like a worth-while addition to the PMEM API, to me.  Mikulas,
what do you think about refactoring the code as Christoph suggested?

Cheers,
Jeff

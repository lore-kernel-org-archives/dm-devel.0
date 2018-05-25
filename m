From: Mikulas Patocka <mpatocka@redhat.com>
Subject: Re: [patch 4/4] dm-writecache: use new API for flushing
Date: Fri, 25 May 2018 02:17:44 -0400 (EDT)
Message-ID: <alpine.LRH.2.02.1805250213270.13894@file01.intranet.prod.int.rdu2.redhat.com>
References: <20180519052503.325953342@debian.vm>
	<20180519052635.567438191@debian.vm>
	<CAPcyv4iEtfuVGPR0QMKcafv2XFwSj3nzxjX8cuXpXe00akAvYA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <CAPcyv4iEtfuVGPR0QMKcafv2XFwSj3nzxjX8cuXpXe00akAvYA@mail.gmail.com>
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
Cc: Mike Snitzer <msnitzer@redhat.com>, device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids



On Thu, 24 May 2018, Dan Williams wrote:

> On Fri, May 18, 2018 at 10:25 PM, Mikulas Patocka <mpatocka@redhat.com> wrote:
> > Use new API for flushing persistent memory.
> >
> > The problem is this:
> > * on X86-64, non-temporal stores have the best performance
> > * ARM64 doesn't have non-temporal stores, so we must flush cache. We
> >   should flush cache as late as possible, because it performs better this
> >   way.
> >
> > We introduce functions pmem_memcpy, pmem_flush and pmem_commit. To commit
> > data persistently, all three functions must be called.
> >
> > The macro pmem_assign may be used instead of pmem_memcpy. pmem_assign
> > (unlike pmem_memcpy) guarantees that 8-byte values are written atomically.
> >
> > On X86, pmem_memcpy is memcpy_flushcache, pmem_flush is empty and
> > pmem_commit is wmb.
> >
> > On ARM64, pmem_memcpy is memcpy, pmem_flush is arch_wb_cache_pmem and
> > pmem_commit is empty.
> 
> I don't want to grow driver-local wrappers for pmem. You should use
> memcpy_flushcache directly() and if an architecture does not define
> memcpy_flushcache() then don't allow building dm-writecache, i.e. this
> driver should 'depends on CONFIG_ARCH_HAS_UACCESS_FLUSHCACHE'. I don't
> see a need to add a standalone flush operation if all relevant archs
> provide memcpy_flushcache(). As for commit, I'd say just use wmb()
> directly since all archs define it. Alternatively we could introduce
> memcpy_flushcache_relaxed() to be the un-ordered version of the copy
> routine and memcpy_flushcache() would imply a wmb().

But memcpy_flushcache() on ARM64 is slow.

Mikulas

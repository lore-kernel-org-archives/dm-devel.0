From: Mike Snitzer <snitzer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [patch 4/4] dm-writecache: use new API for flushing
Date: Wed, 30 May 2018 09:16:23 -0400
Message-ID: <20180530131623.GB2106@redhat.com>
References: <20180519052635.567438191@debian.vm>
 <CAPcyv4iEtfuVGPR0QMKcafv2XFwSj3nzxjX8cuXpXe00akAvYA@mail.gmail.com>
 <alpine.LRH.2.02.1805250213270.13894@file01.intranet.prod.int.rdu2.redhat.com>
 <20180525125126.GA9275@redhat.com>
 <CAPcyv4j-v5HGBg9JMBXt7UUyw=K_bGC7t5tQGfXM9G4qjOpFjQ@mail.gmail.com>
 <alpine.LRH.2.02.1805260246250.15978@file01.intranet.prod.int.rdu2.redhat.com>
 <CAPcyv4jwLsCNvNhgvv2DDSZuQsQXYEpKUU_5w1pTnyKj-uDBbQ@mail.gmail.com>
 <alpine.LRH.2.02.1805280922190.13486@file01.intranet.prod.int.rdu2.redhat.com>
 <CAPcyv4jXV4aZ6wqqjVPL8J4LxwTtXnzQCLZ0Wk5oB4_0uxpg7g@mail.gmail.com>
 <alpine.LRH.2.02.1805300903220.1090@file01.intranet.prod.int.rdu2.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <alpine.LRH.2.02.1805300903220.1090-Hpncn10jQN4oNljnaZt3ZvA+iT7yCHsGwRM8/txMwJMAicBL8TP8PQ@public.gmane.org>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
List-Help: <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=subscribe>
Errors-To: linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
To: Mikulas Patocka <mpatocka-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: device-mapper development <dm-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-nvdimm <linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
List-Id: dm-devel.ids

On Wed, May 30 2018 at  9:07am -0400,
Mikulas Patocka <mpatocka-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:

> 
> 
> On Mon, 28 May 2018, Dan Williams wrote:
> 
> > On Mon, May 28, 2018 at 6:32 AM, Mikulas Patocka <mpatocka-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
> > >
> > > I measured it (with nvme backing store) and late cache flushing has 12%
> > > better performance than eager flushing with memcpy_flushcache().
> > 
> > I assume what you're seeing is ARM64 over-flushing the amount of dirty
> > data so it becomes more efficient to do an amortized flush at the end?
> > However, that effectively makes memcpy_flushcache() unusable in the
> > way it can be used on x86. You claimed that ARM does not support
> > non-temporal stores, but it does, see the STNP instruction. I do not
> > want to see arch specific optimizations in drivers, so either
> > write-through mappings is a potential answer to remove the need to
> > explicitly manage flushing, or just implement STNP hacks in
> > memcpy_flushcache() like you did with MOVNT on x86.
> > 
> > > 131836 4k iops - vs - 117016.
> > 
> > To be clear this is memcpy_flushcache() vs memcpy + flush?
> 
> I found out what caused the difference. I used dax_flush on the version of 
> dm-writecache that I had on the ARM machine (with the kernel 4.14, because 
> it is the last version where dax on ramdisk works) - and I thought that 
> dax_flush flushes the cache, but it doesn't.
> 
> When I replaced dax_flush with arch_wb_cache_pmem, the performance 
> difference between early flushing and late flushing disappeared.
> 
> So I think we can remove this per-architecture switch from dm-writecache.

That is really great news, can you submit an incremental patch that
layers ontop of the linux-dm.git 'dm-4.18' branch?

Thanks,
Mike

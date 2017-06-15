From: Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>
Subject: Re: [PATCH v3 08/14] x86, dax, libnvdimm: move wb_cache_pmem() to
 libnvdimm
Date: Thu, 15 Jun 2017 10:11:24 +0200
Message-ID: <20170615081124.GD1764@quack2.suse.cz>
References: <149703982465.20620.14881139332926778446.stgit@dwillia2-desk3.amr.corp.intel.com>
 <149703986971.20620.10303247412197996310.stgit@dwillia2-desk3.amr.corp.intel.com>
 <20170614105425.GD21506@quack2.suse.cz>
 <CAPcyv4hNLkX9ct=Z9YQ8zaqAYPa_ab_+W+Z8By6=btJEkbrZag@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CAPcyv4hNLkX9ct=Z9YQ8zaqAYPa_ab_+W+Z8By6=btJEkbrZag-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
List-Help: <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=subscribe>
Errors-To: linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
To: Dan Williams <dan.j.williams-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>, Matthew Wilcox <mawilcox-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>, X86 ML <x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org" <linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>, dm-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Al Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, linux-fsdevel <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
List-Id: dm-devel.ids

On Wed 14-06-17 09:49:29, Dan Williams wrote:
> On Wed, Jun 14, 2017 at 3:54 AM, Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org> wrote:
> >> -/**
> >> - * arch_wb_cache_pmem - write back a cache range with CLWB
> >> - * @vaddr:   virtual start address
> >> - * @size:    number of bytes to write back
> >> - *
> >> - * Write back a cache range using the CLWB (cache line write back)
> >> - * instruction. Note that @size is internally rounded up to be cache
> >> - * line size aligned.
> >> - */
> >>  static inline void arch_wb_cache_pmem(void *addr, size_t size)
> >>  {
> >> -     u16 x86_clflush_size = boot_cpu_data.x86_clflush_size;
> >> -     unsigned long clflush_mask = x86_clflush_size - 1;
> >> -     void *vend = addr + size;
> >> -     void *p;
> >> -
> >> -     for (p = (void *)((unsigned long)addr & ~clflush_mask);
> >> -          p < vend; p += x86_clflush_size)
> >> -             clwb(p);
> >> +     clean_cache_range(addr,size);
> >>  }
> >
> > So this will make compilation break on 32-bit x86 as it does not define
> > clean_cache_range(). Do we somewhere force we are on x86_64 when pmem is
> > enabled?
> 
> Yes, this is enforced by:
> 
>     select ARCH_HAS_PMEM_API if X86_64
> 
> ...in arch/x86/Kconfig. We fallback to a dummy arch_wb_cache_pmem()
> implementation and emit this warning for !ARCH_HAS_PMEM_API archs:
> 
>     "nd_pmem namespace0.0: unable to guarantee persistence of writes"

Aha, right. Feel free to add:

Reviewed-by: Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>

							Honza

-- 
Jan Kara <jack-IBi9RG/b67k@public.gmane.org>
SUSE Labs, CR

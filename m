From: Mikulas Patocka <mpatocka-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [dm-devel] [PATCH 2/2] dm-writecache
Date: Thu, 23 Nov 2017 16:22:30 -0500 (EST)
Message-ID: <alpine.LRH.2.02.1711231618550.2217@file01.intranet.prod.int.rdu2.redhat.com>
References: <alpine.LRH.2.02.1711222135371.2330@file01.intranet.prod.int.rdu2.redhat.com>
 <20171123082946.GB17859@infradead.org>
 <CAA9_cmcBk8AMU=dc3A2fv2oS7Drk_a1iBQAxJRDrqLV0k=rLWg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
In-Reply-To: <CAA9_cmcBk8AMU=dc3A2fv2oS7Drk_a1iBQAxJRDrqLV0k=rLWg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
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
Cc: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, device-mapper development <dm-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Mike Snitzer <msnitzer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org" <linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
List-Id: dm-devel.ids



On Thu, 23 Nov 2017, Dan Williams wrote:

> On Thu, Nov 23, 2017 at 12:29 AM, Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org> wrote:
> >> +/*
> >> + * The clflushopt instruction is very slow on Broadwell, so we use non-temporal
> >> + * stores instead.
> >> + */
> >> +#ifdef CONFIG_X86_64
> >> +#define NT_STORE(dest, src)  asm ("movnti %1, %0" : "=m"(dest) : "r"(src))
> >> +#define FLUSH_RANGE(dax, ptr, size)  do { } while (0)
> >> +#define COMMIT_FLUSHED()     wmb()
> >> +#else
> >> +#define NT_STORE(dest, src)  ACCESS_ONCE(dest) = (src)
> >> +#define FLUSH_RANGE          dax_flush
> >> +#define COMMIT_FLUSHED()     do { } while (0)
> >> +#endif
> >
> > Please go through the proper pmem APIs.
> 
> Yes, see _copy_from_iter_flushcache() and all its related apis.
> Drivers shouldn't be doing anything different than what fs/dax.c is
> using.

There is not any arch-independent API that abstracts over a single movnti 
instruction.

Do you want to add it?

memcpy_flushcache is overkill for one or two 8-byte stores. And - on 
non-x86 architectures memcpy_flushcache doesn't flush cache at all.

Mikulas

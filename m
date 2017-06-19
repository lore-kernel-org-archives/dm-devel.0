From: Dan Williams <dan.j.williams-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v3 01/14] x86, uaccess: introduce copy_from_iter_flushcache
 for pmem / cache-bypass operations
Date: Sun, 18 Jun 2017 19:02:54 -0700
Message-ID: <CAPcyv4iLtL5bJbxcLYwkJzTPk69Fam8xHdpdyGYPgNqNUC9qbQ@mail.gmail.com>
References: <149703982465.20620.14881139332926778446.stgit@dwillia2-desk3.amr.corp.intel.com>
 <149703983098.20620.14791162611225792317.stgit@dwillia2-desk3.amr.corp.intel.com>
 <20170618082841.GA26456@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
In-Reply-To: <20170618082841.GA26456-jcswGhMUV9g@public.gmane.org>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
List-Help: <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=subscribe>
Errors-To: linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
To: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Cc: Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>, Matthew Wilcox <mawilcox-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>, X86 ML <x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org" <linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>, dm-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Al Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, linux-fsdevel <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>
List-Id: dm-devel.ids

On Sun, Jun 18, 2017 at 1:28 AM, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org> wrote:
> On Fri, Jun 09, 2017 at 01:23:51PM -0700, Dan Williams wrote:
>> Implement a __copy_from_user_inatomic_flushcache, memcpy_page_flushcache, and
>> memcpy_flushcache, that guarantee that the destination buffer is not dirty in
>> the cpu cache on completion. The new copy_from_iter_flushcache and sub-routines
>
> Wouldn't writethrough be a better name?

I started with _writethrough, Ingo suggested _wt, and then Toshi
rightly pointed out that _wt might lead applications to assume that
the involved cache-lines are valid on return which may not be true. So
we settled on _flushcache in this thread [1].

[1]: https://lkml.org/lkml/2017/5/6/99

>> will be used to replace the "pmem api" (include/linux/pmem.h +
>> arch/x86/include/asm/pmem.h). The availability of copy_from_iter_flushcache()
>> and memcpy_flushcache() are gated by the CONFIG_ARCH_HAS_UACCESS_FLUSHCACHE
>> config symbol, and fallback to copy_from_iter_nocache() and plain memcpy()
>> otherwise.
>
> What is UACCESS about memcpy_flushcache?

The uaccess part comes from the fact that the conversion provides all
the _flushcache versions of the copy_from_iter() operations
(__copy_from_user_flushcache, memcpy_page_flushcache,
memcpy_flushcache). It also stems from Al asking that
__copy_user_flushcache() live in arch/x86/lib/usercopy_64.c. That
said, I wouldn't object to a different name for the config symbol.

From: Yigal Korman <yigal-/8YdC2HfS5554TAoqtyWWQ@public.gmane.org>
Subject: Re: [PATCH] x86: optimize memcpy_flushcache
Date: Wed, 27 Jun 2018 17:02:20 +0300
Message-ID: <CACTTzNZOK8cYZBcSjShFKYCoaW33cFtCZP7bN1CmQg9ZXsVf2w@mail.gmail.com>
References: <alpine.LRH.2.02.1806180846300.22626@file01.intranet.prod.int.rdu2.redhat.com>
 <CAPcyv4i_xqo1AgF7znUYi+Eo_obTBYA5vMv7=Q0VP755Kmm9bg@mail.gmail.com>
 <CACTTzNbu5FNXiyDeSBgTZCE7x=aNKQWvMLnhy5rkE51JJV9Rzg@mail.gmail.com>
 <CAPcyv4hzfy0pvniMz4-PcaAXo6kFC=n4hyPzd=0v-JxCsUhMhQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
In-Reply-To: <CAPcyv4hzfy0pvniMz4-PcaAXo6kFC=n4hyPzd=0v-JxCsUhMhQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
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
Cc: Mike Snitzer <msnitzer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-nvdimm <linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>, X86 ML <x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, device-mapper development <dm-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Mikulas Patocka <mpatocka-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, pmem <pmem-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Id: dm-devel.ids

On Wed, Jun 27, 2018 at 4:03 PM, Dan Williams <dan.j.williams-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org> wrote:
> On Wed, Jun 27, 2018 at 4:23 AM, Yigal Korman <yigal-/8YdC2HfS5554TAoqtyWWQ@public.gmane.org> wrote:
>> Hi,
>> I'm a bit late on this but I have a question about the original patch -
>> I thought that in order for movnt (movntil, movntiq) to push the data
>> into the persistency domain (ADR),
>> one must work with length that is multiple of cacheline size,
>> otherwise the write-combine buffers remain partially
>> filled and you need to commit them with a fence (sfence) - which ruins
>> the whole performance gain you got here.
>> Am I wrong, are the write-combine buffers are part of the ADR domain
>> or something?
>
> The intent is to allow a batch of memcpy_flushcache() calls followed
> by a single sfence. Specifying a multiple of a cacheline size does not
> necessarily help as sfence is still needed to make sure that the movnt
> result has reached the ADR-safe domain.

Oh, right, I see that dm-writecache calls writecache_commit_flushed
which in turn calls wmb().
I keep confusing *_nocache (i.e. copy_user_nocache) that includes
sfence and *_flushcache (i.e. memcpy_flushcache) that doesn't.
Thanks for the clear up.

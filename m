From: Dan Williams <dan.j.williams-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [patch 4/4] dm-writecache: use new API for flushing
Date: Thu, 31 May 2018 09:39:41 -0700
Message-ID: <CAPcyv4hr2cVhpLNu66vPgRTwtfxhwW4AdpJJUKBkBfPWKKGv+A@mail.gmail.com>
References: <20180519052503.325953342@debian.vm>
 <CAPcyv4iEtfuVGPR0QMKcafv2XFwSj3nzxjX8cuXpXe00akAvYA@mail.gmail.com>
 <alpine.LRH.2.02.1805250213270.13894@file01.intranet.prod.int.rdu2.redhat.com>
 <20180525125126.GA9275@redhat.com>
 <CAPcyv4j-v5HGBg9JMBXt7UUyw=K_bGC7t5tQGfXM9G4qjOpFjQ@mail.gmail.com>
 <alpine.LRH.2.02.1805260246250.15978@file01.intranet.prod.int.rdu2.redhat.com>
 <CAPcyv4jwLsCNvNhgvv2DDSZuQsQXYEpKUU_5w1pTnyKj-uDBbQ@mail.gmail.com>
 <alpine.LRH.2.02.1805280922190.13486@file01.intranet.prod.int.rdu2.redhat.com>
 <CAPcyv4jXV4aZ6wqqjVPL8J4LxwTtXnzQCLZ0Wk5oB4_0uxpg7g@mail.gmail.com>
 <alpine.LRH.2.02.1805300903220.1090@file01.intranet.prod.int.rdu2.redhat.com>
 <CAPcyv4j3pDQ3YMK5Eije0dgGw+1CQYazPJ-zvqfvGF-9O_gVJw@mail.gmail.com>
 <CAPcyv4gD-ZaXyV1SFAndobUYJOGLkx9rOyb5zNbzJXB_kVCzoA@mail.gmail.com>
 <alpine.LRH.2.02.1805310416540.30096@file01.intranet.prod.int.rdu2.redhat.com>
 <CAPcyv4gzFbdBbUhPJ6W4mTJWAkvqVw_4FVhVdePEJzc28Sg-Sg@mail.gmail.com>
 <alpine.LRH.2.02.1805311127001.31059@file01.intranet.prod.int.rdu2.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
In-Reply-To: <alpine.LRH.2.02.1805311127001.31059-Hpncn10jQN4oNljnaZt3ZvA+iT7yCHsGwRM8/txMwJMAicBL8TP8PQ@public.gmane.org>
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
Cc: device-mapper development <dm-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Mike Snitzer <snitzer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-nvdimm <linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
List-Id: dm-devel.ids

On Thu, May 31, 2018 at 8:31 AM, Mikulas Patocka <mpatocka-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
>
>
> On Thu, 31 May 2018, Dan Williams wrote:
>
>> On Thu, May 31, 2018 at 1:19 AM, Mikulas Patocka <mpatocka-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
>> >
>> >
>> > On Wed, 30 May 2018, Dan Williams wrote:
>> >
>> >> > Great find! Thanks for the due diligence. Feel free to add:
>> >> >
>> >> >     Acked-by: Dan Williams <dan.j.williams-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
>> >> >
>> >> > ...on the reworks to unify ARM and x86.
>> >>
>> >> One more note. The side effect of not using dax_flush() is that you
>> >> may end up flushing caches on systems where the platform has asserted
>> >> it will take responsibility for flushing caches at power loss. If /
>> >> when those systems become more prevalent we may want to think of a way
>> >> to combine the non-temporal optimization and the cache-flush-bypass
>> >> optimizations. However that is something that can wait for a later
>> >> change beyond 4.18.
>> >
>> > We could define memcpy_flushpmem, that falls back to memcpy or
>> > memcpy_flushcache, depending on whether the platform flushes the caches at
>> > power loss or not.
>>
>> The problem is that some platforms only power fail protect a subset of
>> the physical address range,
>
> How can this be? A psysical address may be cached on any CPU, so either
> there is enough power to flush all the CPUs' caches or there isn't.
>
> How does the CPU design that protects only a part of physical addresses
> look like?

It's not necessarily a CPU problem, it may be a problem of having
enough stored energy to potentially software loops to flush caches.
There's also the consideration that a general purpose platform may mix
persistent memory technologies from different vendors where some might
be flash-backed DRAM and some might be persistent media directly.

For now I don't think we need to worry about it, but I don't want to
make the assumption that this property is platform global given the
history of how persistent memory has been deployed to date.

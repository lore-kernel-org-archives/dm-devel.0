From: Dan Williams <dan.j.williams-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] dax: remove the pmem_dax_ops->flush abstraction
Date: Wed, 6 Sep 2017 08:46:55 -0700
Message-ID: <CAPcyv4h8i4_NoHw-5+-5Uz41Fo5sL-xWe=2TA0v0hK0aV=CZtg@mail.gmail.com>
References: <alpine.LRH.2.02.1708312138390.32309@file01.intranet.prod.int.rdu2.redhat.com>
 <CAPcyv4j9KcgWU+rDY_5zAQ4xg3cx4Z3UkjTieVNMkWLc7C0OLg@mail.gmail.com>
 <alpine.LRH.2.02.1708312257500.15601@file01.intranet.prod.int.rdu2.redhat.com>
 <CAPcyv4iSTmh4j_EfFsbqwrXRd134QMYr+CkV6JuSsw9TX5ihWg@mail.gmail.com>
 <alpine.LRH.2.02.1709060220520.12322@file01.intranet.prod.int.rdu2.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
In-Reply-To: <alpine.LRH.2.02.1709060220520.12322-Hpncn10jQN4oNljnaZt3ZvA+iT7yCHsGwRM8/txMwJMAicBL8TP8PQ@public.gmane.org>
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
Cc: dm-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, Mike Snitzer <snitzer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org" <linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
List-Id: dm-devel.ids

[ resend in plain text ]

On Tue, Sep 5, 2017 at 11:29 PM, Mikulas Patocka <mpatocka-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
>
>
> On Thu, 31 Aug 2017, Dan Williams wrote:
>
>> On Thu, Aug 31, 2017 at 8:04 PM, Mikulas Patocka <mpatocka-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
>> >
>> >
>> > On Thu, 31 Aug 2017, Dan Williams wrote:
>> >
>> >> On Thu, Aug 31, 2017 at 6:47 PM, Mikulas Patocka <mpatocka-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
>> >> > The patch abebfbe2f731 ("dm: add ->flush() dax operation support") is
>> >> > buggy. A dm device may be composed of multiple underlying devices and all
>> >> > of them need to be flushed. The patch just routes the flush request to the
>> >> > first device and ignores the other devices.
>> >> >
>> >> > It could be fixed by adding more complex logic to the device mapper. But
>> >> > there is only one implementation of the method pmem_dax_ops->flush - that
>> >> > is pmem_dax_flush() - and it calls arch_wb_cache_pmem(). Consequently, we
>> >> > don't need the pmem_dax_ops->flush abstraction at all, we can call
>> >> > arch_wb_cache_pmem() directly from dax_flush() because dax_dev->ops->flush
>> >> > couldn't ever reach anything different from arch_wb_cache_pmem().
>> >>
>> >> Unfortunately, this is not true, see usage of DAXDEV_WRITE_CACHE. This
>> >> is for platforms that arrange for cpu caches to be flushed on
>> >> power-fail, like standalone storage appliances, where it would be a
>> >
>> > BTW. if the system is capable of flushing caches on power failure, it is
>> > system-wide feature, it is not per-device feature. The CPU caches may
>> > store data for any persistent memory device.
>> >
>> > You either have enough remaining power to flush the CPU caches or not.
>>
>> Whether you need to flush caches or not can be a per-address range
>> attribute and can change over time.
>
> There is only one way to flush the cache (the clwb instruction), you don't
> need a method that abstracts over this instruction. A simple flag or
> static key that skips clwb() is sufficient.
>
> Linux kernel API is changeable, so you don't need to overdesign the API
> for future. If it ever happens that we have a system with two types of
> persistent memory that need different instructions to flush them, we can
> design a proper abstraction. But there is no reason to design the
> abstraction in advance for a situation that will perhaps never happen.

True, it is over designed and we can cross that complexity bridge in
the future when / if it arises.

Since dm is already checking dax_write_cache_enabled() to set its own
flush enabled bit I think your patch looks good. You can add:

Reviewed-by: Dan Williams <dan.j.williams-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

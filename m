From: Jim Ramsay <jim_ramsay@dell.com>
Subject: Re: [PATCH] reworked dm-switch target
Date: Tue, 21 Aug 2012 12:33:30 -0400
Message-ID: <20120821163329.GA21395@freewill.lab.equallogic.com>
References: <Pine.LNX.4.64.1208151832280.8587@file.rdu.redhat.com>
	<20120816070955.GA32526@agk-dp.fab.redhat.com>
	<C3B343EE19BD2940B6AEC40C9BE99426094C0C@AUSX10MPS302.AMER.DELL.COM>
	<Pine.LNX.4.64.1208201429110.18279@file.rdu.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.1208201429110.18279@file.rdu.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: dm-devel@redhat.com, Jason_Shamberger@dell.com, agk@redhat.com, Kevin_OKelley@dell.com
List-Id: dm-devel.ids

On Mon, Aug 20, 2012 at 03:20:42PM -0400, Mikulas Patocka wrote:
> On Fri, 17 Aug 2012, Jim_Ramsay@DELL.com wrote:
> > 1) Uploading large page tables
<snip>
> > Assuming a fairly well-distributed layout of 1572864 pages where 50% of 
> > the pages are different every other page, 20% are different every 2 pages, 
> > 10% every 5 pages, 10% every 10 pages, and 10% every 20 pages, this would 
> > leave us with a dmsetup message with argc=998768
> > 
> >   dmsetup message switch 0 set-table 0-0:1 1-1:0 2-2:2 3-3:1 4-4:0 5-5:2 6-6:0 7-8:1 9-15:2 16-16:1 ... (plus almost 1000000 more arguments...)
> 
> You don't have to use the dash, you can send:
> dmsetup message switch 0 set-table 0:1 1:0 2:2 3:1 4:0 ... etc.
> 
> You don't have to send the whole table at once in one message. Using 
> message with 998768 arguments is bad (it can trigger allocation failures 
> in the kernel).
> 
> But you can split the initial table load into several messages, each 
> having up to 4096 bytes, so that it fits into a single page.

Even removing the '-' for single-page sets, you're looking at having to
send 4 bytes minimum per page (and as the index of the page you're
indexing increases significantly, it takes many more bytes to represent
a page), which means that each 4096-byte run would have maybe 1000 page
table entries in it at most.

This would mean that to upload an entire page table for my example
volume, we would have to run 'dmsetup message ...' almost 1000 times.

I'm sure we can come up with other syntactical shortcuts like those
Alasdair came up with, but encoding into any ascii format will always be
less space-efficient than a pure binary transfer.

> > Perhaps we can work with you on designing alternate non-netlink mechanism 
> > to achieve the same goal... A sysfs file per DM device for userland 
> > processes to do direct I/O with?  Base64-encoding larger chunks of the 
> > binary page tables and passing those values through 'dmsetup message'?
> 
> As I said, you don't have to upload the whole table with one message ... 
> or if you really need to update the whole table at once, explain why.

At the very least, we would need to update the whole page table in the
following scenarios:

  1) When we first learn the geometry of the volume

  2) When the volume layout changes significantly (for example, if it was
     previously represented by 2 devices and is then later moved onto 3
     devices, or the underlying LUN is resized)

  3) When the protocol used to fetch the data can fetch segments of the
     page table in a dense binary formate, it is considerably more work
     for a userland processes to keep its own persistent copy of the
     page table, compare a new version with the old version, calculate
     the differences, and send only those differences.  It is much
     simpler to have a binary conduit to upload the entire table at
     once, provided it does not occur too frequently.

Furthermore, if a userland process already has an internal binary
representation of a page map, what is the value in converting this into
a complicated human-readable ascii representation then having the kernel
do the opposite de-conversion when it receives the data?

> > 2) vmalloc and TLB performance
<snip>

> The original code uses a simple kmalloc to allocate the whole table.
> 
> The maximum size allocatable with kmalloc is 4MB.
> 
> The minimum vmalloc arena is 128MB (on x86) - so the switch from kmalloc 
> to vmalloc makes it no worse.
> 
> > On SMP systems, the page table changes required by
> > vmalloc() allocations can require expensive cross-processor interrupts on
> > all CPUs.
> 
> vmalloc is used only once when the target is loaded, so performance is not 
> an issue here.

The table would also have to be reallocated on LUN resize or if the data
is moved to be across a different number of devices (provided the change
is such that it causes the number of bits-per-page to be changed), such
as if you had a 2-device setup represented by 1-bit-per-page change to a
3-device setup represented by 2-bit-per-page.

Granted these are not frequent operations, but we need to continue to
properly handle these cases.

We also need to keep the multiple device scenario in mind (perhaps 100s of
targets in use or being created simultaneously).

> > And, on all systems, use of space in the vmalloc() range
> > increases pressure on the translation lookaside buffer (TLB), reducing the
> > performance of the system."
> > 
> > The page table lookup is in the I/O path, so performance is an important 
> > consideration.  Do you have any performance comparisons between our 
> > existing 2-level lookup of kmalloc'd memory versus a single vmalloc'd 
> 
> There was just 1-level lookup in the original dm-switch patch. Did you add 
> 2-level lookup recently?

In October 2011 I posted a 'v3' version of our driver to the dm-devel
list that did this 2-stage lookup to the dm-devel list:

http://www.redhat.com/archives/dm-devel/2011-October/msg00109.html

The main consideration was to avoid single large kmalloc allocations,
but to also support sparse allocations in the future.

> > memory lookup?  Multiple devices of similarly large table size may be in 
> > use simultaneously, so this needs consideration as well.
> > 
> > Also, in the example above with 1572864 page table entries, assuming 2 
> > bits per entry requires a table of 384KB.  Would this be a problem for the 
> > vmalloc system, especially on 32-bit systems, if there are multiple 
> > devices of similarly large size in use at the same time?
> 
> 384KB is not a problem, the whole vmalloc space has 128MB.

This means we could allow ~375 similarly-sized devices in the system,
assuming no other kernel objects are consuming any vmalloc space.  This
could be okay, provided our performance considerations are also
addressed, but allowing sparse allocation may be a good enough reason
to use a 2-level allocation scheme.

> > It can also be desirable to allow sparsely-populated page tables, when it 
> > is known that large chunks are not needed or deemed (by external logic) 
> > not important enough to consume kernel memory.  A 2-level kmalloc'd memory 
> > scheme can save memory in sparsely-allocated situations.

This ability to do sparse allocations may be important depending on what
else is going on in the kernel and using vmalloc space.

Thanks for your comments, and I do hope to send our 'v4' driver code as
well as a demonstration application with the netlink socket interface to
this list in the very near future.

-- 
Jim Ramsay

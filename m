From: Jim Ramsay <jim_ramsay@dell.com>
Subject: Re: [PATCH] reworked dm-switch target
Date: Fri, 24 Aug 2012 14:14:44 -0400
Message-ID: <20120824181444.GC27819@freewill.lab.equallogic.com>
References: <Pine.LNX.4.64.1208151832280.8587@file.rdu.redhat.com>
	<20120816070955.GA32526@agk-dp.fab.redhat.com>
	<C3B343EE19BD2940B6AEC40C9BE99426094C0C@AUSX10MPS302.AMER.DELL.COM>
	<Pine.LNX.4.64.1208201429110.18279@file.rdu.redhat.com>
	<20120821163329.GA21395@freewill.lab.equallogic.com>
	<Pine.LNX.4.64.1208212026500.1653@file.rdu.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.1208212026500.1653@file.rdu.redhat.com>
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

On Tue, Aug 21, 2012 at 09:02:35PM -0400, Mikulas Patocka wrote:
> On Tue, 21 Aug 2012, Jim Ramsay wrote:
> > On Mon, Aug 20, 2012 at 03:20:42PM -0400, Mikulas Patocka wrote:
> > > On Fri, 17 Aug 2012, Jim_Ramsay@DELL.com wrote:
> > > > 1) Uploading large page tables
<snip>
> I converted the format to use hexadecimal numbers (they are faster to 
> produce and faster to parse) and made an option to omit the page number 
> (in this case, the previous page plus one is used) - and it takes 0.05s 
> to load a table with one million entries on 2.3GHz Opteron.
> 
> The table is loaded with 67 dm message calls, each having 45000 bytes 
> (the number 45000 was experimentally found to be near the optimum).
> 
> So I don't think there are performance problems with this.
> 
> I'll send you the program that updates the table with messages.

Thanks for this change, and for doing that performance test.

We are interested in the relative performance between using the dm
message interface and the netlink interface in uploading a million page
table entries.  If this dm message-based format is close enough, it
would certainly be an acceptable replacement of the netlink mechanism.

> > > > Perhaps we can work with you on designing alternate non-netlink mechanism 
> > > > to achieve the same goal... A sysfs file per DM device for userland 
> > > > processes to do direct I/O with?  Base64-encoding larger chunks of the 
> > > > binary page tables and passing those values through 'dmsetup message'?
> > > 
> > > As I said, you don't have to upload the whole table with one message ... 
> > > or if you really need to update the whole table at once, explain why.
> > 
> > At the very least, we would need to update the whole page table in the
> > following scenarios:
> > 
> >   1) When we first learn the geometry of the volume
> > 
> >   2) When the volume layout changes significantly (for example, if it was
> >      previously represented by 2 devices and is then later moved onto 3
> >      devices, or the underlying LUN is resized)
> > 
> >   3) When the protocol used to fetch the data can fetch segments of the
> >      page table in a dense binary formate, it is considerably more work
> >      for a userland processes to keep its own persistent copy of the
> >      page table, compare a new version with the old version, calculate
> >      the differences, and send only those differences.  It is much
> >      simpler to have a binary conduit to upload the entire table at
> >      once, provided it does not occur too frequently.
> 
> But you don't have to upload the table at once - you can upload the table 
> incrementally with several dm messages.

By "all at once" I was talking about the scenarios when you need to push
all 1000000 entries to the kernel driver.  The netlink implementation
also sends the data in chunks.

The question as to whether we should do this in one message or multiple
messages (and how many and how large they are) is better answered by
checking relative performance between this dm message code and our
existing netlink code.

> > Furthermore, if a userland process already has an internal binary
> > representation of a page map, what is the value in converting this into
> > a complicated human-readable ascii representation then having the kernel
> > do the opposite de-conversion when it receives the data?
> 
> The reason is simplicity - the dm message code is noticeably smaller than 
> the netlink code. It is also less bug-prone because no structures are 
> allocated or freed there.

I do like the simplicity of the dm message interface, but the cost of
that simplicity seems to be that it just doesn't seem to be well suited
for sending large amounts of packed binary data.  It's also great for
crafting test data by hand, but it's more complicated for userland
programs who now need to convert binary data into ascii before sending
it.

I think though that as long as the cost of uploading the whole page
table from start to finish isn't too great, a dm message based mechanism
would be acceptable.

> > > > 2) vmalloc and TLB performance
<snip>
> > The table would also have to be reallocated on LUN resize or if the data
> > is moved to be across a different number of devices (provided the change
> > is such that it causes the number of bits-per-page to be changed), such
> > as if you had a 2-device setup represented by 1-bit-per-page change to a
> > 3-device setup represented by 2-bit-per-page.
> > 
> > Granted these are not frequent operations, but we need to continue to
> > properly handle these cases.
> >
> > We also need to keep the multiple device scenario in mind (perhaps 100s of
> > targets in use or being created simultaneously).
> 
> For these operations (resizing the device or changing the number of 
> underlying devices), you can load a new table, suspend the device and 
> resume the device. It will switch to the new table and destroy the old 
> one.
> 
> You have to reload the table anyway if you change device size, so there is 
> no need to include code to change table size in the target driver.

Good points.

> > > > And, on all systems, use of space in the vmalloc() range
> > > > increases pressure on the translation lookaside buffer (TLB), reducing the
> > > > performance of the system."
> > > > 
> > > > The page table lookup is in the I/O path, so performance is an important 
> > > > consideration.  Do you have any performance comparisons between our 
> > > > existing 2-level lookup of kmalloc'd memory versus a single vmalloc'd 

Besides the performance consideration of uploading a large page table to
the device, the actual I/O performance is another important
consideration we have not yet addressed.

I think a side-by-side comparison of I/O performance would be useful to
see, comparing the vmalloc single table versus the kmalloc 2-step
lookup.  We are curious to see if there is any impact to doing lookups
all over a large vmalloc'd area in multiple disks simultaneously.

> > > > Also, in the example above with 1572864 page table entries, assuming 2 
> > > > bits per entry requires a table of 384KB.  Would this be a problem for the 
> > > > vmalloc system, especially on 32-bit systems, if there are multiple 
> > > > devices of similarly large size in use at the same time?
> > > 
> > > 384KB is not a problem, the whole vmalloc space has 128MB.
> > 
> > This means we could allow ~375 similarly-sized devices in the system,
> > assuming no other kernel objects are consuming any vmalloc space.  This
> > could be okay, provided our performance considerations are also
> > addressed, but allowing sparse allocation may be a good enough reason
> > to use a 2-level allocation scheme.
> > 
> > > > It can also be desirable to allow sparsely-populated page tables, when it 
> > > > is known that large chunks are not needed or deemed (by external logic) 
> > > > not important enough to consume kernel memory.  A 2-level kmalloc'd memory 
> > > > scheme can save memory in sparsely-allocated situations.
> > 
> > This ability to do sparse allocations may be important depending on what
> > else is going on in the kernel and using vmalloc space.
> 
> It may be possible to use radix tree and do sparse allocations, but given 
> the current usage (tables with million entries, each entry having a few 
> bits), it doesn't seem as a problem now.

I suppose it depends on how general we want this driver to be.  The
number of pages could be considerably larger if the underlying volumes
are larger or if the page sizes were considerably smaller.  For our
particular use of this device, and a reasonable look into the
not-too-distant future, I believe we would be happy if it works well
with the tens-millions-of-pages scope.  We are less concerned about the
case of hundreds-of-millions-of-pages or larger, at least for now.

I'm also not that familiar with what other devices use vmalloc space in
the kernel - With a limited resource like this we must make sure we can
properly contend with other consumers of the space.

So in conclusion, I think we're converging on something that we're all
going to be happy with - We just need to ensure that the performance of
the proposed changes are acceptable compared to our existing code.

To that end I will be devoting some time next week to getting your
driver working with our userland to test page table uploading and actual
IO performance.  Would you mind taking some time to give a try to the
latest 'v4' version of this driver, and doing an independent comparison?

v4 driver code is here:
  http://www.redhat.com/archives/dm-devel/2012-August/msg00299.html
v4 userland example code is here:
  http://www.redhat.com/archives/dm-devel/2012-August/msg00300.html

-- 
Jim Ramsay

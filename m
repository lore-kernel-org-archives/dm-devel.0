From: Mikulas Patocka <mpatocka@redhat.com>
Subject: Re: [PATCH] reworked dm-switch target
Date: Mon, 20 Aug 2012 15:20:42 -0400 (EDT)
Message-ID: <Pine.LNX.4.64.1208201429110.18279@file.rdu.redhat.com>
References: <Pine.LNX.4.64.1208151832280.8587@file.rdu.redhat.com>,
	<20120816070955.GA32526@agk-dp.fab.redhat.com>
	<C3B343EE19BD2940B6AEC40C9BE99426094C0C@AUSX10MPS302.AMER.DELL.COM>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <C3B343EE19BD2940B6AEC40C9BE99426094C0C@AUSX10MPS302.AMER.DELL.COM>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Jim_Ramsay@DELL.com
Cc: dm-devel@redhat.com, Jason_Shamberger@DELL.com, agk@redhat.com, Kevin_OKelley@DELL.com
List-Id: dm-devel.ids

Hi

On Fri, 17 Aug 2012, Jim_Ramsay@DELL.com wrote:

> Hi Alasdair and Mikulas.  It's great to hear this feedback, thanks!
> 
> We had a few comments about the latest changes:
> 
> 1) Uploading large page tables
> 
> As Alasdair mentioned, a more compact method of sending the page table 
> will be necessary.  Consider a volume with a page table that consists of 
> 1572864 entries in total.  On our storage solution, the pages are spread 
> out among different group members (i.e. underlying DM devices) and it is 
> uncommon to see long stretches mapping to the same device.  The reason for 
> this is similar to the principle of striping, attempting to maximize the 
> chance of simultaneous accesses on multiple group members.  This means 
> that there is little gain in having a message format that allows a 
> contiguous range of pages to be set to the same value.
> 
> Assuming a fairly well-distributed layout of 1572864 pages where 50% of 
> the pages are different every other page, 20% are different every 2 pages, 
> 10% every 5 pages, 10% every 10 pages, and 10% every 20 pages, this would 
> leave us with a dmsetup message with argc=998768
> 
>   dmsetup message switch 0 set-table 0-0:1 1-1:0 2-2:2 3-3:1 4-4:0 5-5:2 6-6:0 7-8:1 9-15:2 16-16:1 ... (plus almost 1000000 more arguments...)

You don't have to use the dash, you can send:
dmsetup message switch 0 set-table 0:1 1:0 2:2 3:1 4:0 ... etc.

You don't have to send the whole table at once in one message. Using 
message with 998768 arguments is bad (it can trigger allocation failures 
in the kernel).

But you can split the initial table load into several messages, each 
having up to 4096 bytes, so that it fits into a single page.

> We agree that using 'dmestup message' is a lot cleaner than using a 
> netlink socket in a number of ways, but the fact that it's argc/argv 
> space-delimited shell-parsed data makes it more difficult to send large 
> amounts of binary data like the bit-compressed page table.  We would be 
> fine leaving in the proposed syntax for setting specific pages, as it may 
> be useful to others and in small device testing scenarios, but an 
> additional mechanism to upload larger chunks of binary data all at once 
> would be important for our use of the device.
> 
> Perhaps we can work with you on designing alternate non-netlink mechanism 
> to achieve the same goal... A sysfs file per DM device for userland 
> processes to do direct I/O with?  Base64-encoding larger chunks of the 
> binary page tables and passing those values through 'dmsetup message'?

As I said, you don't have to upload the whole table with one message ... 
or if you really need to update the whole table at once, explain why.

> 2) vmalloc and TLB performance
> 
> Having a (virtually) contiguous memory range certainly simplifies the 
> allocation and lookup algorithms, but what about the concerns about 
> vmalloc() that are summarized nicely in Documentation/flexible-arrays.txt:
> 
> "Large contiguous memory allocations can be unreliable in the Linux kernel.
> Kernel programmers will sometimes respond to this problem by allocating
> pages with vmalloc().  This solution not ideal, though.  On 32-bit systems,
> memory from vmalloc() must be mapped into a relatively small address space;
> it's easy to run out.

The original code uses a simple kmalloc to allocate the whole table.

The maximum size allocatable with kmalloc is 4MB.

The minimum vmalloc arena is 128MB (on x86) - so the switch from kmalloc 
to vmalloc makes it no worse.

> On SMP systems, the page table changes required by
> vmalloc() allocations can require expensive cross-processor interrupts on
> all CPUs.

vmalloc is used only once when the target is loaded, so performance is not 
an issue here.

> And, on all systems, use of space in the vmalloc() range
> increases pressure on the translation lookaside buffer (TLB), reducing the
> performance of the system."
> 
> The page table lookup is in the I/O path, so performance is an important 
> consideration.  Do you have any performance comparisons between our 
> existing 2-level lookup of kmalloc'd memory versus a single vmalloc'd 

There was just 1-level lookup in the original dm-switch patch. Did you add 
2-level lookup recently?

> memory lookup?  Multiple devices of similarly large table size may be in 
> use simultaneously, so this needs consideration as well.
> 
> Also, in the example above with 1572864 page table entries, assuming 2 
> bits per entry requires a table of 384KB.  Would this be a problem for the 
> vmalloc system, especially on 32-bit systems, if there are multiple 
> devices of similarly large size in use at the same time?

384KB is not a problem, the whole vmalloc space has 128MB.

> It can also be desirable to allow sparsely-populated page tables, when it 
> is known that large chunks are not needed or deemed (by external logic) 
> not important enough to consume kernel memory.  A 2-level kmalloc'd memory 
> scheme can save memory in sparsely-allocated situations.

> 3) Userland values and counters
> 
> The "user saved" values are useful for debugging purposes.  For example, 
> we had been using the 0th field for a timestamp so it's easy to manually 
> validate when the last page table upload succeeded, and the other field 
> for a count of the number of page table entries uploaded so far, but these 
> could be used for other checkpointing or checksumming by userland 
> processes.
> 
> Also, while we had not yet implemented a mechanism to retrieve the 
> per-chunk hit counters, this would be valuable to have for a userland 
> process to decide which chunks of the page table are "hot" for a 
> sparsely-populated situation.
> 
> 4) num_discard_requests, num_flush_requests, and iterate_devices
> 
> I have a slightly updated version of driver that implements these DM 
> target features as well.  I was actually preparing to submit the changes 
> to this list when this conversation began, and will be doing so shortly.
> 
> --
> Jim Ramsay

Mikulas

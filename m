From: Mikulas Patocka <mpatocka@redhat.com>
Subject: Re: NetBSD libdevmapper port
Date: Sun, 15 Jun 2008 22:24:07 -0400 (EDT)
Message-ID: <Pine.LNX.4.64.0806152201230.14263@engineering.redhat.com>
References: <7F5B52C7-1511-49C8-B81A-D4D58E6B12F3@gmail.com>
	<200806131652.m5DGqD0s015068@sbuxscan.baea.com.au>
	<20080614095812.GA21126@baea.com.au>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20080614095812.GA21126@baea.com.au>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Brett Lymn <blymn@baesystems.com.au>
Cc: dm-devel@redhat.com, tech-kern@netbsd.org, Adam Hamsik <haaaad@gmail.com>
List-Id: dm-devel.ids

On Sat, 14 Jun 2008, Brett Lymn wrote:

> Hi - I am mentoring Adam in this project
>
> On Fri, Jun 13, 2008 at 12:51:48PM -0400, Mikulas Patocka wrote:
>>
>> If you are rewriting it --- have you somehow thought about avoiding
>> suspend?
>>
>
> I assume you are talking about handling a suspend of a device
> underlying the LVM.  At the moment, NetBSD does not have the facility
> to suspend a device in this manner so I dont think we will have this
> issue (yet).

It's good, so you can think twice and code once :)

>> A Linux LVM does something like: suspend old table, write to disk with
>> direct i/o, resume new table. I'd suggest that you invent some method how
>> to batch these operations into single syscall
>
> I think this should be doable with the API that Adam is using - in
> NetBSD there is a thing called proplib which is a method of passing a
> very limited form of XML into the kernel - Adam is using proplib to
> pass the lvm parameters into the kernel.
>
>>  --- the question --- how to do it portably on all
>> NetBSD architectures?),
>
> Actually, most of the operations you have listed are, from memory,
> machine independent code - there is very little of the kernel that
> actually is architecture specific we work hard to keep it that way.

See function in LVM2/lib/mm/memlock.c - _allocate_memory

It attempts to prepare memory for locking, so that there will be no more 
page faults while some device is suspended. It could fail if:

* if you have a different heap algorithm that allocates temp_malloc_mem 
block in a separate chunk
* if you have an architecture with separate stacks for stack data and for 
register windows (I don't know if such exists) - then alloca(_size_stack) 
will preallocate just one stack, not both
* if a running process can take some additional faults specific to a given 
architecture that allocate memory (for example fault on FPU instruction 
allocating FPU context --- I don't know how precisely you have it 
implemented).

- these are very brittle requirements and if someone forgets about them, 
then LVM will be deadlocky. And these requirements span a lot of 
LVM-independent code and it's hard to enforce all libc/kernel engineers to 
think about LVM-specific peculiarities.

>> --- if you port lvm2 as it is, you'll have to audit (and maybe rewrite)
>> many parts of NetBSD kernel for not waiting for I/O. If you do it badly,
>> you'll get deadlocks.
>>
>
> The head of the bleeding edge NetBSD code (netbsd-current) is having a
> lot of work done on it to make the kernel re-entrant and
> multi-threaded.  This may be a bit of a bonus in terms of what you are
> saying because there should be locks that need to be held to perform
> the i/o - it may be a case of just making the acquiring of these locks
> non-blocking (or it may not be an issue at all).  We shall need to
> wait and see on that one.

Any non-atomic memory allocation can wait for I/O. So if you allocate some 
kernel memory for example in that tiny XML parser, this could trigger 
dirty page writeout, the writeout may be directed to the suspended device 
and you are locked up. (atomic allocations may fail anytime --- for 
example if too many packets come from network and exhaust the atomic 
reserve --- so they are not perfect solution too)

If you solve this problem somehow generally (for example batching suspend 
and ioctls into one call), I'd support bacporting that solution to Linux.

Mikulas

> Thanks for the input.

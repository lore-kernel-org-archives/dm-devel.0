From: Mikulas Patocka <mpatocka@redhat.com>
Subject: Re: NetBSD libdevmapper port
Date: Fri, 13 Jun 2008 18:12:01 -0400 (EDT)
Message-ID: <Pine.LNX.4.64.0806131757160.1838@engineering.redhat.com>
References: <7F5B52C7-1511-49C8-B81A-D4D58E6B12F3@gmail.com>
	<Pine.LNX.4.64.0806131236500.32455@engineering.redhat.com>
	<20080613173413.GO20826@agk.fab.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20080613173413.GO20826@agk.fab.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Alasdair G Kergon <agk@redhat.com>
Cc: device-mapper development <dm-devel@redhat.com>, Adam Hamsik <haaaad@gmail.com>, tech-kern@netbsd.org
List-Id: dm-devel.ids

On Fri, 13 Jun 2008, Alasdair G Kergon wrote:

> On Fri, Jun 13, 2008 at 12:51:48PM -0400, Mikulas Patocka wrote:
>> This suspend thing was a big misdesign and if you are writing it from
>> scratch, try to avoid it.
>
> Despite how things might seem, we gained some substantial
> simplifications by doing things this way and I reject the term
> 'misdesign':-)  If writing this from scratch under similar time
> constraints, we would still handle this a similar way.

If you sum up the time that you spent looking for the deadlocks (for 
example that one when writing to raw device while suspended updated inode 
mtime field and the kernel tried to write that inode to the suspended root 
device), thinking how to do proper memory and stack preallocation and 
locking, how to allocate structure for ioctl arguments (that trick with 
PF_MEMALLOC, still not bug-free, but at least works in typical scenarios) 
+ plus the time still needed to fix things that are still broken (that 
GFP_KERNEL allocation in direct IO path, PF_MEMALLOC allocation in ioctl 
parameter copying) --- and compare this time to the hypothetical time how 
long it would take to write IOCTL call that performs few operations in a 
batch and never returns to userspace with suspended device --- which one 
do you think would win? I think the second solution would be written 
faster and with fewer bugs.

BTW. is there any need to update on-disk metadata while suspended? What 
would happen if we first updated metadata and then did suspend+resume in 
just one syscall? For linear or snapshots, there should be no problem, I'm 
interested if there's a dm target where this could produce a race 
condition.

Mikulas

> But this suspend/resume mechanism was never intended to last as long as
> it has - it was meant to be a stepping stone to a more-sophisticated
> transaction mechanism that we have still not found time to develop,
> mostly because this existing mechanism is "good enough" most of the
> time.
>
> Alasdair
> -- 
> agk@redhat.com
>
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel
>

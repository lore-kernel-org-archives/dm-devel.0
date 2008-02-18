From: Ric Wheeler <ric@emc.com>
Subject: Re: Re: [PATCH] Implement barrier support for single device
	DM devices
Date: Mon, 18 Feb 2008 08:52:10 -0500
Message-ID: <47B98D8A.7090506@emc.com>
References: <20080215120821.GA8267@basil.nowhere.org>
	<20080215122002.GM29914@agk.fab.redhat.com>
	<47B58EAA.8040405@msgid.tls.msk.ru>
	<20080215142010.GA29552@one.firstfloor.org>
	<20080215141229.GB1788@agk.fab.redhat.com>
	<47B97E87.6040209@emc.com> <47B9870B.8060005@msgid.tls.msk.ru>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <47B9870B.8060005@msgid.tls.msk.ru>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Michael Tokarev <mjt@tls.msk.ru>
Cc: device-mapper development <dm-devel@redhat.com>, Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org
List-Id: dm-devel.ids

Michael Tokarev wrote:
> Ric Wheeler wrote:
>> Alasdair G Kergon wrote:
>>> On Fri, Feb 15, 2008 at 03:20:10PM +0100, Andi Kleen wrote:
>>>> On Fri, Feb 15, 2008 at 04:07:54PM +0300, Michael Tokarev wrote:
>>>>> I wonder if it's worth the effort to try to implement this.
>>> My personal view (which seems to be in the minority) is that it's a
>>> waste of our development time *except* in the (rare?) cases similar to
>>> the ones Andi is talking about.
>> Using working barriers is important for normal users when you really
>> care about data loss and have normal drives in a box. We do power fail
>> testing on boxes (with reiserfs and ext3) and can definitely see a lot
>> of file system corruption eliminated over power failures when barriers
>> are enabled properly.
>>
>> It is not unreasonable for some machines to disable barriers to get a
>> performance boost, but I would not do that when you are storing things
>> you really need back.
> 
> The talk here is about something different - about supporting barriers
> on md/dm devices, i.e., on pseudo-devices which uses multiple real devices
> as components (software RAIDs etc).  In this "world" it's nearly impossible
> to support barriers if there are more than one underlying component device,
> barriers only works if there's only one component.  And the talk is about
> supporting barriers only in "minority" of cases - mostly for simplest
> device-mapper case only, NOT covering any raid1 or other "fancy" configurations.

I understand that. Most of the time, dm or md devices are composed of 
uniform components which will uniformly support (or not) the cache flush 
commands used by barriers.

> 
>> Of course, you don't need barriers when you either disable the write
>> cache on the drives or use a battery backed RAID array which gives you a
>> write cache that will survive power outages...
> 
> Two things here.
> 
> First, I still don't understand why in God's sake barriers are "working"
> while regular cache flushes are not.  Almost no consumer-grade hard drive
> supports write barriers, but they all support regular cache flushes, and
> the latter should be enough (while not the most speed-optimal) to ensure
> data safety.  Why to require write cache disable (like in XFS FAQ) instead
> of going the flush-cache-when-appropriate (as opposed to write-barrier-
> when-appropriate) way?

Barriers have different flavors, but can be composed of "cache" flushes 
which are supported on all drives that I have seen (S-ATA and ATA) for 
many years now. That is the flavor of barriers that we test with S-ATA & 
ATA drives.

The issue is that without flushing/invalidating (or other way of 
controlling the behavior of your storage), the file system has no way to 
make sure that all data is on persistent & non-volatile media.

> 
> And second, "surprisingly", battery-backed RAID write caches tends to fail
> too, sometimes... ;)  Usually, such a battery is enough to keep the data
> in memory for several hours only (sine many RAID controllers uses regular
> RAM for memory caches, which requires some power to keep its state), --
> I come across this issue the hard way, and realized that only very few
> persons around me who manages raid systems even knows about this problem -
> that the battery-backed cache is only for some time...  For example,
> power failed at evening, and by tomorrow morning, batteries are empty
> already.  Or, with better batteries, think about a weekend... ;)
> (I've seen some vendors now uses flash-based backing store for caches
> instead, which should ensure far better results here).
> 
> /mjt
> 

That is why you need to get a good array, not just a simple controller ;-)

Most arrays do not use batteries to hold up the write cache, they use 
the batteries to move any cached data to non-volatile media in the time 
that the batteries hold up.

You could certainly get this kind of behavior from the flash scheme you 
describe above as well...

ric

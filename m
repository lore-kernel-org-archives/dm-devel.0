From: Milan Broz <gmazyland@gmail.com>
Subject: Re: dm-crypt: remove per-cpu structure
Date: Sat, 22 Feb 2014 18:34:09 +0100
Message-ID: <5308DF91.6030003@gmail.com>
References: <alpine.LRH.2.02.1402201758190.28312@file01.intranet.prod.int.rdu2.redhat.com>
	<20140220235935.GA32743@redhat.com>
	<alpine.LRH.2.02.1402201907120.29698@file01.intranet.prod.int.rdu2.redhat.com>
	<20140221023240.GA338@redhat.com>
	<alpine.LRH.2.02.1402210238470.5846@file01.intranet.prod.int.rdu2.redhat.com>
	<53087BD3.1000900@gmail.com> <20140222142526.GA12207@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20140222142526.GA12207@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Mike Snitzer <snitzer@redhat.com>
Cc: Tejun Heo <tj@kernel.org>, Lisa Du <chunlingdu1@gmail.com>, device-mapper development <dm-devel@redhat.com>, Mikulas Patocka <mpatocka@redhat.com>, "Alasdair G. Kergon" <agk@redhat.com>
List-Id: dm-devel.ids

On 02/22/2014 03:25 PM, Mike Snitzer wrote:
> On Sat, Feb 22 2014 at  5:28am -0500,
> Milan Broz <gmazyland@gmail.com> wrote:
> 
>> On 02/21/2014 08:41 AM, Mikulas Patocka wrote:
>>>>>> Hi Mikulas,
>>>>>>
>>>>>> Obviously avoiding crashes is more important than performance.
>>
>> Yes, but please keep these changes in linux-next for a while
>> before submitting this for stable or you will fix one rare bug and
>> slow down all existing users (with possible another fix to fix later)...
>>
>> I know that taking cpu offline becomes more used these days
>> but still the performance is critical attribute for dmcrypt.
>>
>> (And IIRC this cpu work relocation problem is there for years.)
> 
> Unfortunately, we cannot leave the code in its current state.  Sure it
> has been this way for years but taking cpus offline is _much_ more
> common.
> 
> As I said here:
> https://git.kernel.org/cgit/linux/kernel/git/device-mapper/linux-dm.git/commit/?h=for-next&id=fba2d94c5e0f3d848792981977b1f62ce96377ac
> 
> This change may undermine performance improvements intended by commit
> c0297721 ("dm crypt: scale to multiple cpus").  But correctness is more
> important than performance.  The use of per-cpu structures may be
> revisited later (by using cpu hot-plug notifiers to make them safe).

Correctness? Yes. I think Tejun said how to fix it correctly.

I have nothing against removal of percpu structure - but please assess
what it breaks, how it will slow down dmcrypt and mention it in patch
header if you want quick fix.

I couldn't resist but "may undermine" in patch header sounds like
"we have no idea what it breaks but it no longer crashes".

Removal of headache by removing head is always 100% solution to
the particular problem but it has usually also some side effects :-)

...

> Mikulas does have an alternative approach that should be revisited ASAP
> given that it also fixes this cpu hotplug issue:
> http://people.redhat.com/mpatocka/patches/kernel/dm-crypt-paralelizace/current/series.html

Yes, and I spent many hours testing it and while it helped somewhere
it was not perfect solution in every situation. And I wish it works!
Unfortunately, the tests output was not convincing.
But it was described in thread you referenced.

And if he just repost the same patchset few month later without any
more data and no changes, why should I change my opinion?
I can just shut up of course and just maintain userspace and watch
people complaining.

> context/timeline:
> http://www.redhat.com/archives/dm-devel/2011-October/msg00127.html
> http://www.redhat.com/archives/dm-devel/2012-March/msg00181.html
> http://www.redhat.com/archives/dm-devel/2013-March/msg00103.html
> 
> Christoph pointed out there is precendence for sorting:
> http://www.redhat.com/archives/dm-devel/2013-March/msg00104.html

My opinion is that fixing io scheduler work (sorting) in dmcrypt is
just ugly hack and could lead to more problems in future because
it can increase latency and it anticipates some IO access patterns.
Dm-crypt should be (ideally) completely transparent and "invisible"
to IO processing...

I think there is a report of very slow operation of database (IIRC it was
MySQL) running over dmcrypt device. This would be probably nice test
case for these changes.

But I am not nacking it, if you want it, do it, you are maintainer.


> Even though you actively resisted it:
> http://www.redhat.com/archives/dm-devel/2013-March/msg00107.html

I am repeating still repeating the same: Do we have performance
numbers proving it is better in real world scenarios?
Nobody will use ramdisk for dmcrypt.

These are the most used scenarios for dmcrypt I know :

- Notebook with single SSD / rotational disk and multicore (2 or 4) CPU
with AES-NI acceleration, dmcrypt over plain partition or LVM
(typical encrypted distro installation)

- dmcrypt over MD RAID1/5/6 with several multicore CPUs
(think encrypted array for backups on server)
[There is also variant with several dmcrypt devices with MD RAID
over it - which is currently performance disaster - but I am
not sure this is good idea. It was suggested as workaround
before percpu changes were implemented.]

- several dmcrypt devices in system with many cores over LVM
(encrypted storage for VMs. It would be nice to have
fixed CPU limit per dmcrypt device - you do not want to one VM
eat all processing power. I think we discussed with Mikulas
that dmcrypt should have some tweaking parameters to limit used
CPUs per device. But it was long time ago...)

It would be also interesting how it behaves when stacking dmcrypt
devices on top of each other (this is used in TrueCrypt compatibility
mode in crypsetup, but also in TrueCrypt itself).

> Progress on improving dm-crypt is long overdue, I'd like to see Mikulas
> rebase/repost/retest his dm-crypt parallelization patchset for 3.15 or
> 3.16.

I agree and I would put accent on _improving_ in this sentence ;-)

Milan

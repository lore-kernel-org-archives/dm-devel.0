From: Zdenek Kabelac <zkabelac@redhat.com>
Subject: Re: Improve processing efficiency for addition and
 deletion of multipath devices
Date: Mon, 28 Nov 2016 13:55:27 +0100
Message-ID: <03b0e279-25f0-67cf-87e5-7ba0523a813c@redhat.com>
References: <OF6C4379F8.661B1ACE-ON48258079.000B15EB-48258079.000CBE4F@zte.com.cn>
	<597eba5c-3efa-8b05-3b7b-87792e3d896d@redhat.com>
	<708c4e21-559c-5d50-2525-e1e10a289711@suse.de>
	<61c3088c-062d-ad59-8138-bdd73784c7c0@redhat.com>
	<0d34fede-29b3-1d6f-3fd0-167e1bcf7019@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <0d34fede-29b3-1d6f-3fd0-167e1bcf7019@suse.de>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Hannes Reinecke <hare@suse.de>, tang.junhui@zte.com.cn, Christophe Varoqui <christophe.varoqui@opensvc.com>, bmarzins@redhat.com, Martin Wilck <mwilck@suse.com>, Bart Van Assche <bart.vanassche@sandisk.com>
Cc: zhang.kai16@zte.com.cn, dm-devel@redhat.com
List-Id: dm-devel.ids

Dne 28.11.2016 v 13:08 Hannes Reinecke napsal(a):
> On 11/28/2016 12:51 PM, Zdenek Kabelac wrote:
>> Dne 28.11.2016 v 11:42 Hannes Reinecke napsal(a):
>> With multipath device - you ONLY want to 'scan' device (with blkid)  when
>> only the initial first member device of multipath gets in.
>>
>> So you start multipath (resume -> CHANGE) - it should be the ONLY place
>> to run 'blkid' test (which really goes though over 3/4MB of disk read,
>> to check if there is not ZFS somewhere)
>>
>> Then any next disk being a member of multipath (recognized by 'multipath
>> -c',
>> should NOT scan)  - as far  as  I can tell current order is opposite,
>> fist there is  'blkid' (60) and then rule (62) recognizes a mpath_member.
>>
>> Thus every add disk fires very lengthy blkid scan.
>>
>> Of course I'm not here an expert on dm multipath rules so passing this
>> on to prajnoha@ -  but I'd guess this is primary source of slowdowns.
>>
>> There should be exactly ONE blkid for a single multipath device - as
>> long as 'RELOAD' only  add/remove  paths  (there is no reason to scan
>> component devices)
>>
> ATM 'multipath -c' is just a simple test if the device is supposed to be
> handled by multipath.

Yes - 'multipath -c'  is a way to recognize  'private/internal' device of 
multipath device (aka component).

This is very same issues with i.e. lvm2 raid1  leg devices - where you have a 
raid device and its individual _rimageXX legs.  In lvm2 we bypass/skip
scans of 'rimage' - only resulting 'raid' device is being checked.

There is no reason to scan 'hidden' subdevice.

Unfortunately udev doesn't support 'hidden' device - so it's upto 
'blockdevice' maintainer to implement this logic in udev rules.
So it needs a careful design to NOT miss scan for 'user accesssible' device 
while not doing unnecessary scans of device noone expect i.e. lvm2 should ever 
access  (there is absolutely NO reason to have full udev DB content for any 
lvm2 private device - there is always only a minimum info - same
should apply  to  dm multipaht - where components are 'private' to multipath).

> And the number of bytes read by blkid should be _that_ large; a simple
> 'blkid' on my device caused it to read 35k ...

Unless you've configured  (or is it default for Suse) to NOT scan for ZFS,
you would see this 3 times in strace:

read(3, 
"@\200\0\0@\200\1\0@\200\2\0@\200\3\0@\200\4\0@\200\f\0@\200\r\0@\200\30\0"..., 
262144) = 262144

So a default e.i. 'blkdid /dev/sda1' really does read a lot data from disk.


>
> Also udev will become very unhappy if we're not calling blkid for every
> device; you'd be having a hard time reconstructing the event for those
> devices.

It's not about making udev happy :)
Private device (or subsystem) is simply a missing piece in udev.
There is really no reason to fill udev DB with a device noone should be using.
And I hope we both agree  that mpath  'component' should never be used
by any user.
Of course noone object reading it via 'dd'  - but component should not
appear in udev DB device list as a regular device.



> While it's trivial to import variables from parent devices, it's
> impossible to do that from unrelated devices; you'd need a dedicated
> daemon for that.
> So we cannot skip blkid without additional tooling.

Trust me -  we can and we should improve it even more.


>
>>>
>>>> So while aggregation of 'uevents' in multipath would 'shorten' queue
>>>> processing of events - it would still not speedup scan alone.
>>>>
>>>> We need to drastically shorten unnecessary disk re-scanning.
>>>>
>>>> Also note - if you have a lot of disks -  it might be worth to checkout
>>>> whether udev picks  'right amount of udev workers'.
>>>> There is heuristic logic to avoid system overload - but might be worth
>>>> to check if in you system with your amount of CPU/RAM/DISKS  the
>>>> computed number is the best for scaling - i.e. if you double the amount
>>>> of workers - do you
>>>> get any better performance ?
>>>>
>>> That doesn't help, as we only have one queue (within multipath) to
>>> handle all uevents.
>>
>> This was meant for systems with many different multipath devices.
>> Obviously would not help with a single multipath device.
>>
> I'm talking about the multipath daemon.
> There will be exactly _one_ instance of the multipath daemon running for
> the entire system, which will be handling _all_ udev events with a
> single queue.
> Independent on the number of attached devices.


Ohh - I've thought there is some bigger parallelism in multipathd.
Ok - so then more workers would really not help.

That another reason why improving speed of rules should be prio task #1.

Regards

Zdenek

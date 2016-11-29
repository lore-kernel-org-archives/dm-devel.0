From: Zdenek Kabelac <zdenek.kabelac@gmail.com>
Subject: Re: Improve processing efficiency for addition and
 deletion of multipath devices
Date: Tue, 29 Nov 2016 10:34:04 +0100
Message-ID: <687462d0-9b6d-3263-b0c7-b7886a3cc4a0@gmail.com>
References: <OF6C4379F8.661B1ACE-ON48258079.000B15EB-48258079.000CBE4F@zte.com.cn>
	<597eba5c-3efa-8b05-3b7b-87792e3d896d@redhat.com>
	<708c4e21-559c-5d50-2525-e1e10a289711@suse.de>
	<61c3088c-062d-ad59-8138-bdd73784c7c0@redhat.com>
	<0d34fede-29b3-1d6f-3fd0-167e1bcf7019@suse.de>
	<20161128172226.GD1972@octiron.msp.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20161128172226.GD1972@octiron.msp.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Benjamin Marzinski <bmarzins@redhat.com>, Hannes Reinecke <hare@suse.de>
Cc: tang.junhui@zte.com.cn, zhang.kai16@zte.com.cn, dm-devel@redhat.com, Zdenek Kabelac <zkabelac@redhat.com>, Bart Van Assche <bart.vanassche@sandisk.com>, Martin Wilck <mwilck@suse.com>
List-Id: dm-devel.ids

Dne 28.11.2016 v 18:22 Benjamin Marzinski napsal(a):
> On Mon, Nov 28, 2016 at 01:08:51PM +0100, Hannes Reinecke wrote:
>> On 11/28/2016 12:51 PM, Zdenek Kabelac wrote:
>>> Dne 28.11.2016 v 11:42 Hannes Reinecke napsal(a):
>>>> On 11/28/2016 11:06 AM, Zdenek Kabelac wrote:
>>>
>>> With multipath device - you ONLY want to 'scan' device (with blkid)  when
>>> only the initial first member device of multipath gets in.
>>>
>>> So you start multipath (resume -> CHANGE) - it should be the ONLY place
>>> to run 'blkid' test (which really goes though over 3/4MB of disk read,
>>> to check if there is not ZFS somewhere)
>>>
>>> Then any next disk being a member of multipath (recognized by 'multipath
>>> -c',
>>> should NOT scan)  - as far  as  I can tell current order is opposite,
>>> fist there is  'blkid' (60) and then rule (62) recognizes a mpath_member.
>>>
>>> Thus every add disk fires very lengthy blkid scan.
>>>
>>> Of course I'm not here an expert on dm multipath rules so passing this
>>> on to prajnoha@ -  but I'd guess this is primary source of slowdowns.
>>>
>>> There should be exactly ONE blkid for a single multipath device - as
>>> long as 'RELOAD' only  add/remove  paths  (there is no reason to scan
>>> component devices)
>>>
>> ATM 'multipath -c' is just a simple test if the device is supposed to be
>> handled by multipath.
>
> Well, "simple" might be stretching the truth a little. I'd really like
> to not have to call multipath -c on every change event to a device since
> this isn't a particularly quick callout either. In fact we do this with
> the redhat code, but we use some horrible hacks, that could be solved if
> udev would just allow rules to compare the value of two environment
> variables. But this is impossible. I opened a bugzilla for allowing
> this, but it recently got closed WONTFIX. The idea is that multipathd

There are number of ways to solve this thing.

One could be  udev built-in command plugin to make parsing of WWID efficient.

multipath could also be able to generate udev rule dynamically
(i.e. --makeudevrule)  which would check if udev rule is older then config 
file and reload udev with new rule if necessary.
In such generated rules you then could use  WWID constant for compare operation.

But even plain 'multipath -c' is still better - since it's executed already 
anyway - my point here is - it should be executed before 'blkid' is attempted.

> would set a timestamp when it started, when a new wwid was added to the
> wwids file, and when it got reconfigured. These are the only times a
> configuration could change (well, users could change /etc/multipath.conf
> but not reload multipathd, but that will already cause problems). udev
> would read this timestamp and save it to the database.  When change
> events come along, as long as the timestamp hasn't changed, the old
> value of "multipath -c" is still correect.
>
>> And the number of bytes read by blkid should be _that_ large; a simple
>> 'blkid' on my device caused it to read 35k ...
>>
>> Also udev will become very unhappy if we're not calling blkid for every
>> device; you'd be having a hard time reconstructing the event for those
>> devices.
>> While it's trivial to import variables from parent devices, it's
>> impossible to do that from unrelated devices; you'd need a dedicated
>> daemon for that.
>> So we cannot skip blkid without additional tooling.
>
> We need to run blkid on the multipath device, but I'm not sure what it
> gets us on the paths, once we have determined that they belong to

There is NO reason to run blkid on a path (component device) -  since the 
discovered filesystem is later overwritten by mpath member info anyway.

Now lvm2 even tries to detect if the user has tried to use  'path' instead of 
real mpath device on misconfigured system - and already number of such 
misusage have been detected.

Regards

Zdenek

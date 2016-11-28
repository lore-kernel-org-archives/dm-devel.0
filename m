From: Peter Rajnoha <prajnoha@redhat.com>
Subject: Re: Improve processing efficiency for addition and
 deletion of multipath devices
Date: Mon, 28 Nov 2016 13:06:16 +0100
Message-ID: <1d2f312b-5b16-3dad-53c4-a0f19632faf6@redhat.com>
References: <OF6C4379F8.661B1ACE-ON48258079.000B15EB-48258079.000CBE4F@zte.com.cn>
	<597eba5c-3efa-8b05-3b7b-87792e3d896d@redhat.com>
	<708c4e21-559c-5d50-2525-e1e10a289711@suse.de>
	<61c3088c-062d-ad59-8138-bdd73784c7c0@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <61c3088c-062d-ad59-8138-bdd73784c7c0@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Zdenek Kabelac <zkabelac@redhat.com>, Hannes Reinecke <hare@suse.de>, tang.junhui@zte.com.cn, Christophe Varoqui <christophe.varoqui@opensvc.com>, bmarzins@redhat.com, Martin Wilck <mwilck@suse.com>, Bart Van Assche <bart.vanassche@sandisk.com>
Cc: zhang.kai16@zte.com.cn, dm-devel@redhat.com
List-Id: dm-devel.ids

On 11/28/2016 12:51 PM, Zdenek Kabelac wrote:
> Dne 28.11.2016 v 11:42 Hannes Reinecke napsal(a):
>> On 11/28/2016 11:06 AM, Zdenek Kabelac wrote:
>>> Dne 28.11.2016 v 03:19 tang.junhui@zte.com.cn napsal(a):
>>>> Hello Christophe, Ben, Hannes, Martin, Bart,
>>>> I am a member of host-side software development team of ZXUSP storage
>>>> project
>>>> in ZTE Corporation. Facing the market demand, our team decides to
>>>> write code to
>>>> promote multipath efficiency next month. The whole idea is in the mail
>>>> below.We
>>>> hope to participate in and make progress with the open source
>>>> community, so any
>>>> suggestion and comment would be welcome.
>>>>
>>>
>>>
>>> Hi
>>>
>>> First - we are aware of these issue.
>>>
>>> The solution proposed in this mail would surely help - but there is
>>> likely a bigger issue to be solved first.
>>>
>>> The core trouble is to avoid  'blkid' disk identification to be
>>> executed.
>>> Recent version of multipath is already marking plain 'RELOAD' operation
>>> of table (which should not be changing disk content) with extra DM bit,
>>> so udev rules ATM skips 'pvscan' - we also would like to extend the
>>> functionality to skip rules more and reimport existing 'symlinks' from
>>> udev database (so they would not get deleted).
>>>
>>> I believe the processing of udev rules is 'relatively' quick as long
>>> as it does not need to read/write ANYTHING from real disks.
>>>
>> Hmm. You sure this is an issue?
>> We definitely need to skip uevent handling when a path goes down (but I
>> think we do that already), but for 'add' events we absolutely need to
>> call blkid to figure out if the device has changed.
>> There are storage arrays out there who use a 'path down/path up' cycle
>> to inform initiators about any device layout change.
>> So we wouldn't be able to handle those properly if we don't call blkid
>> here.
> 
> The core trouble is -
> 
> 
> With multipath device - you ONLY want to 'scan' device (with blkid)  when
> only the initial first member device of multipath gets in.
> 
> So you start multipath (resume -> CHANGE) - it should be the ONLY place
> to run 'blkid' test (which really goes though over 3/4MB of disk read,
> to check if there is not ZFS somewhere)
> 
> Then any next disk being a member of multipath (recognized by 'multipath
> -c',
> should NOT scan)  - as far  as  I can tell current order is opposite,
> fist there is  'blkid' (60) and then rule (62) recognizes a mpath_member.
> 
> Thus every add disk fires very lengthy blkid scan.
> 
> Of course I'm not here an expert on dm multipath rules so passing this
> on to prajnoha@ -  but I'd guess this is primary source of slowdowns.
> 
> There should be exactly ONE blkid for a single multipath device - as
> long as 'RELOAD' only  add/remove  paths  (there is no reason to scan
> component devices)

That's true indeed - the blkid is executed in
60-persistent-storage.rules (for all disks in general). And multipath rules
are executed later - at the moment, if we detect that the disk is a
multipath component, we overwrite the ID_FS_TYPE to mpath_member. But
that means the blkid was executed uselessly before.

So if we wanted to save some cycles, this could be the place to also
look at optimization, as Zdenek already pointed out.

When it comes to the need to detect whether the component has changed or
not (as Hannes pointed out), that would be only for a change in
signatures (that blkid detects only). But is that enough? If we care
about the change in signatures that blkid detects, don't we care about
data/content that may have changed the same way as those signatures?

-- 
Peter

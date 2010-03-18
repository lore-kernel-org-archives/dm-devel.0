From: Milan Broz <mbroz@redhat.com>
Subject: Re: [PATCH 1/3] Send KOBJ_ADD event after dm
	resume	ioctl.
Date: Thu, 18 Mar 2010 22:35:32 +0100
Message-ID: <4BA29CA4.9070000@redhat.com>
References: <1268920694-10960-1-git-send-email-mbroz@redhat.com>
	<ac3eb2511003180913t5f69e0bs29ff3dcfd1209c60@mail.gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <ac3eb2511003180913t5f69e0bs29ff3dcfd1209c60@mail.gmail.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

On 03/18/2010 05:13 PM, Kay Sievers wrote:
> On Thu, Mar 18, 2010 at 14:58, Milan Broz <mbroz@redhat.com> wrote:
>> Block layer sends ADD uevent when new device is initialised.
>>
>> But the device-mapper block devices are more complex,
>> initialisation consists of allocating underlying device and
>> loading mapping table.
>>
>> Because from the userspace all block devices should behave
>> the same, patch defines new flag indicating that ADD event
>> should be suppressed in block layer.
>>
>> If the flag is set, caller then take full responsibility
>> for enabling and sending events later when device is ready
>> to use.

Hi Kay,

First - the patch is intentionally simple, because it is was the goal.

Call it hack if you want - the goal was fix events to fit
the udev rules specification of events, not rewrite block layer
initialisation.
("Why the dm devices need special handling of ADD event" problem.)

Now you are saying, that it is not enough.
Well I am not sure if I understand these objections:

> This will disconnect /sys, /dev and /proc from the flow of events. We
> rather like to keep them in sync. Device enumeration will find devices
> which have never been announced before. It will also find devices
> where "remove" was sent, but the device is still there. I don't think
> this disconnect is really acceptable from a driver core perspective
> and its consumers. On systems without devtmpfs, there will be no
> device node for the dm device while there is already the full sysfs
> entry and udev would be idle (settle returns), but the state in /sys
> not fully reflected in /dev, which is what we should avoid.

If it is problem it is already there for ages.
The device node appears immediately when device is usable.

Device without mapping table is not usable.

The information about device is not yet in /partitions, it is present
in /sysfs, but the device have zero size
(size is defined by table which is not yet loaded)
This is _current_ state and I think it was this way since 2.6.0 kernel.
No change with this patch.

What's the real problem there?

And why device-mapper need separate allocation of major:minor pair
and then load table in two separate steps:

device-mapper devices can be more complex that one simple device,
it constructs devices by referencing other devices in the table.

An example are snapshots - you have the origin device, (several) COW(s)
and these are linked together and must be activated
(read: resumed) as a tree - together.

I understand that you can invent another model which fit better udev
and I am sure that if device-mapper is designed now, udev integration
is one of the prerequisite. But it pre-dates udev.
Of course the final state is that some functions will be integrated into
block layer and the special "device-mapper" add-on disappears together
with this problem... :-)

> How about doing a two-stage instantiation instead of mangling events
> to work around this setup model? Instead of creating the mentioned
> event/sys inconsistencies, did you think about not registering the
> "dead" blockdev until it is ready to be used as a blockdev? Like you
> would allocate the dm instance in the kernel, but only register the
> blockdev with the block subsystem when the device is resumed/the table
> loaded. That way, only after the device is usable, it would get
> registered and appear in /dev, /sys and proc.

See above - if you mean registering device = allocating major:minor pair,
it is not possible to move it to resume.
Not because I am ignorant but because it is basic design principle
of the device-mapper.

Probably we can achieve it by duplicating/rewriting a lot of block layer
code - but I am sure you discussed this with Alasdair several times.

Mangling events... why you think it is mangling events? It just move ADD
event to proper place, when the device becomes ready.
Sysfs entry always appears before it - just the time interval
is slightly different here (but resume is called immediately after create).

I am trying to use udev view of problem - that's why I pushed to
add sysfs entries for dm for example. And it worked.

But if your statement is "it is your broken activation model" as you said
in some discussion, I can do nothing, just disagree - it is different model,
not broken.
And we have to find compromise how to work with it together.

Thanks,
Milan
--
mbroz@redhat.com

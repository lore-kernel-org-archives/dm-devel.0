From: Kay Sievers <kay.sievers@vrfy.org>
Subject: Re: [dm-devel] [PATCH] Reduce number of KOBJ_REMOVE events
Date: Mon, 25 Jul 2011 14:17:01 +0200
Message-ID: <CAPXgP101Jr3-k4p8ow-F3Phq+fNmC1eR8LD+j609xBvGfd1cUg@mail.gmail.com>
References: <4E2987AE.2070707@redhat.com> <1311553130.1671.21.camel@mop> <4E2D4177.9000402@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <4E2D4177.9000402@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Zdenek Kabelac <zkabelac@redhat.com>
Cc: device-mapper development <dm-devel@redhat.com>, Greg KH <greg@kroah.com>, LKML <linux-kernel@vger.kernel.org>
List-Id: dm-devel.ids

On Mon, Jul 25, 2011 at 12:12, Zdenek Kabelac <zkabelac@redhat.com> wro=
te:
> Dne 25.7.2011 02:18, Kay Sievers napsal(a):
>> On Fri, 2011-07-22 at 16:22 +0200, Zdenek Kabelac wrote:
>>
>>> For now udev recieves 3 event for removal of DM logical volumes. (1=
 for
>>> bdi and 2 for same block kobject). Reason is dm device generates it=
s
>>> own kobject event with approriate env parameter and block layer sen=
ds
>>> another KOBJ_REMOVE event on its own unconditionaly for the same
>>> kobject. As for now only the kobject cleanup checks that the REMOVE
>>> event has been already sent and avoids duplicate REMOVE event.
>>
>>> The patch for kobject_uevent_env() which has been testing for dupli=
cate
>>> REMOVE event did not passed into the mainline (yet?):
>>
>> No, it's wasn't merged. Subsystems should really not send their own
>> 'add' or 'remove' events. These are properties of the driver core.
>>
>>> I'm proposing alternative way around to always use kobject cleanup
>>> routine for sending REMOVE event if it was not send by the module -=
 so
>>> it makes the code few lines shorter.
>>
>> The events the core creates are only sent out at release() not at de=
l(),
>> so we would delay 'remove' events when we keep the device pinned but
>> it's not valid anymore. We can not do that today, we would need to m=
ove
>> the core-created 'remove' events to del().
>>
>> For device-mapper, I would prefer to add a '.dev_uevent' callback to=
 the
>> 'block' class let this callback check 'struct block_device_operation=
s'
>> for a possibly specified '.uevent' callback and call it.
>>
>> Then have 'dm_blk_dops' add '.uevent' and let the core call into the=
 dm
>> code to the needed properties to the 'remove' event, instead of send=
ing
>> its own, and see the duplication.
>
> Sounds like complex solution

I don't think so, It's clean, ~30 lines long, and technically correct, =
I expect.

> maybe it would be easier to just register some
> environment variable on dm code side - like kobject_add_env() - so it=
 would
> take envs from this internal kobject list and after sending uevent it=
 would
> implicitly clear this list.

So we would keep allocated per-event-type variables in the kobject, to
send when 'remove' is finally called? The callbacks are just much
simpler , I guess.

> So in dm case =C2=A0dm-uevent would just register =C2=A0env(cookie) f=
or KOBJ_REMOVE and
> would left kobject_uevent() on block layer ?
>
> Also I'm aware that remove event would be delayed by leaving it on
> kobject_cleanup(), but since you mentioned 'del()' as a better place =
- why not
> move this implicit uvent call there.

It's probably not wrong to do that, but I don't remember now why we
added it to release() that time.

> since most kernel driver writers
> probably do not want to be bothered with uvents?

I guess, most drivers use devices not raw kobjects, which send events
on their own, and don't need anything here.

Kay

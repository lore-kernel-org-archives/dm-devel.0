From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 1/3] Send KOBJ_ADD event after dm
	resume	ioctl.
Date: Fri, 19 Mar 2010 12:50:49 +0100
Message-ID: <4BA36519.9040507@suse.de>
References: <1268920694-10960-1-git-send-email-mbroz@redhat.com>	<ac3eb2511003180913t5f69e0bs29ff3dcfd1209c60@mail.gmail.com>	<4BA29CA4.9070000@redhat.com>	<ac3eb2511003190127n1aa2dda5pbd4e0841a46830bc@mail.gmail.com>	<20100319090656.GR6379@soda.linbit>	<ac3eb2511003190224u1eb19e4lfeda36bbab18939@mail.gmail.com>	<4BA348B7.5070604@redhat.com>	<ac3eb2511003190316s30c106fdkfd94861c99f9802d@mail.gmail.com>
	<4BA35C90.7000301@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <4BA35C90.7000301@redhat.com>
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

Milan Broz wrote:
> On 03/19/2010 11:16 AM, Kay Sievers wrote:
> =

>> There are several subsystems that depend on updating everything with
>> "change" events when device configurations change. There is nothing
>> inherently wrong with this approach, as long as subsystems send the
>> proper "change" events and don't try to hide anything they have
>> registered.
> =

> ok, this is perfectly fine with dm devices, CHANGE announces all
> changes. Just I am not sure if all consumers of events (and separate
> rules authors) know about that, I saw so many problems with
> failing something when wrongly reacting to ADD event...
> =

> Also it means that after ADD the by-uuid* and similar symlinks
> cannot be yet trusted - if the UUID is read from device and device
> is not yet ready.
> =

Correct. We try to take care of that one by
a) not running something like 'vol_id' for 'ADD' events on dm devices
and
b) really making sure the dm device can be read from when receiving
   CHANGE event.

> Well. And what should happen if anyone generate
> artificial CHANGE event before the real first CHANGE event comes from
> subsystem? (yes, I am looking at you, OPTIONS+=3D"watch" thing for exampl=
e)
> =

You have to check the device anyway. 'CHANGE' literally just means that,
ie something has changed with the device state.
We used to have 'ONLINE' and 'OFFLINE' events for block devices, but
that got modified to the more generic 'CHANGE' event.

There is _no_ indication what has changed with the device state; any
program etc must check for itself if the device is in a usable state.
(Normally there won't even be any additional environment variables with
a 'CHANGE' event, so one has to look in sysfs anyway to find out what
has changed).

> According to above, rules must be written such way that every ADD/CHANGE
> event must expect that device is not ready, so it can create only
> partial info in udev, is it correct?
Correct.

> (this is of course no problem if the rules are the same for both cases)
> =

Well, yes and no.
We (read: SUSE) are trying to make sure to _not_ run any programs likely
to read data from the disk when receiving 'ADD' events from these devices.

You might get lucky here when the 'ADD' event is in fact a fake as it
was triggered externally, but this is not something I'd bank on.
(And if someone is faking 'ADD' events he can as well do it properly
and fake the corresponding 'CHANGE' events, too)

HTH.

Cheers,

Hannes
-- =

Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: Markus Rex, HRB 16746 (AG N=FCrnberg)

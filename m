From: Milan Broz <mbroz@redhat.com>
Subject: Re: [PATCH 1/3] Send KOBJ_ADD event after dm
	resume	ioctl.
Date: Mon, 22 Mar 2010 11:11:09 +0100
Message-ID: <4BA7423D.6000305@redhat.com>
References: <ac3eb2511003180913t5f69e0bs29ff3dcfd1209c60@mail.gmail.com>	<ac3eb2511003190127n1aa2dda5pbd4e0841a46830bc@mail.gmail.com>	<20100319090656.GR6379@soda.linbit>	<ac3eb2511003190224u1eb19e4lfeda36bbab18939@mail.gmail.com>	<4BA37B06.1040107@redhat.com>	<ac3eb2511003190643u32a8e702l4e7774e7ec924a12@mail.gmail.com>	<7b13a0f81003190658i78664328ocb94aa0048054a17@mail.gmail.com>	<20100319143412.GE919@agk-dp.fab.redhat.com>	<7b13a0f81003190759w4de7be34pfa1a0454ac311ad8@mail.gmail.com>	<20100319152409.GG919@agk-dp.fab.redhat.com>
	<7b13a0f81003190901o225df427o4468700888501177@mail.gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <7b13a0f81003190901o225df427o4468700888501177@mail.gmail.com>
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
Cc: David Zeuthen <zeuthen@gmail.com>
List-Id: dm-devel.ids

On 03/19/2010 05:01 PM, David Zeuthen wrote:

Hi,

> If you wanted to solve the problem kernel-side I'd expect you to
> create a new subsytem for device-mapper (let's call it 'kdm') that
> libdevmapper would talk to. Then you'd only present block device
> objects exactly when the device-mapper side has been configured.
> 
> Then the flow of events could be something like this
> 
>  - add device kdm-0  (subsys 'kdm')
>  - libdevmapper configures kdm-0
>  - add device dm-0 (subsys 'block')
> 
> but I don't know if this is better.

Nope. device-mapper constructs block devices into other block devices,
it just use some more complex trees (in comparison with MD) and
so you just see these device trees from userspace.

Visibility of all these devices is surely useful when you want to construct
something special without high-level abstraction (like lvm2)
(e.g. liveCD uses snapshots this way).

I want to say, with all the rules Kay just written in some previous mail,
these newly allocated block devices should be present
in sysfs and /dev in kobject creation time.

And btw there is no problem on kernel side using this definition -
ADD/CHANGE event is generated properly, all scans on "unconfigured"
(= no table) device fails.

The problem is in userspace synchronisation.

And device-mapper is nothing special here - what happens if someone
trigger change event before mkfs open the plain disk?
mkfs can fail because device can be locked by asynchronous scan.
(and udev settle is not always option)
  
 
>     The 'private device
>     attribute' we suggested offers another - all would be expected
>     to respect a 'private' sysfs attribute.
> 
> 
> Sorry, but this is an even worse hack. Mandating that all of user
> space (that is: past, present and future) needs to read some
> random 'private' attribute in sysfs because of weird life-cycle
> issues in the device-mapper implementation... that's not really
> workable.

If all you have is a hammer, everything looks like a nail.

Sure, we can scan everything what is in system and expect that
it responds "Error 418 I'm a teapot!" and we can fail gracefully :-)

You simply have to distinguish some differences in device types,
and you are already doing that. (See above why special subsystem
is not good idea IMHO.)

What is interesting, that the private attribute comes from udev
world (when discussing cryptsetup problem. NO other application must
read keyslot device, because it contains key related material).
(It is done this way, because it can this way use kernel crypto
for key obfuscation - and it was 3rd party design.)

See https://bugzilla.redhat.com/show_bug.cgi?id=528909#c8
(yes, it is your comment)

It is generic concept. Now it is wrong. Why?

> Anyway, I really don't think you can expect user space to behave
> sanely so it's not really worth trying.
> 
> (I don't think you ever could expect user space to behave sanely,
> but I'll note that it's an even bigger problem now that we have
> powerful frameworks (such as udev) allowing people to run code
> at device discovery time.... I mean, device-mapper have probably
> been suffering from these issues from day 1 - it just wasn't visible
> earlier on because we didn't have uevents...)

Sounds more like anarchy:-) Device-mapper is also very powerful
system (btw lvm2 uses quite small part of its abilities).
So we have several "powerful" systems and we want to work them together
(and keep the plane flying and not crash).
That means that during the flight some rules must apply. That's all.

Milan
--
mbroz@redhat.com

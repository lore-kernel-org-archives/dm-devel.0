From: "Benjamin Marzinski" <bmarzins@redhat.com>
Subject: Re: [PATCH 17/33] multipathd: imply -n if
 find_multipaths is set
Date: Thu, 13 Apr 2017 16:54:32 -0500
Message-ID: <20170413215432.GR19236@octiron.msp.redhat.com>
References: <20170228162329.14517-1-mwilck@suse.com>
	<20170228162329.14517-18-mwilck@suse.com>
	<20170405230328.GJ19236@octiron.msp.redhat.com>
	<1492032986.4742.43.camel@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <1492032986.4742.43.camel@suse.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Martin Wilck <mwilck@suse.com>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

On Wed, Apr 12, 2017 at 11:36:26PM +0200, Martin Wilck wrote:
> On Wed, 2017-04-05 at 18:03 -0500, Benjamin Marzinski wrote:
> > On Tue, Feb 28, 2017 at 05:23:13PM +0100, Martin Wilck wrote:
> > > Automatic detection of new devices with find_multipaths
> > > doesn't work correctly currently. Therefore, for now,
> > > imply ignore_new_devs if find_multipaths is seen.
> > =

> > I would rather not do this (at least outside of the initramfs), since
> > it
> > keeps multipathd from automatically creating multipath devices as
> > expected when you enable find_multipaths. I admit that these path
> > devices won't be correctly claimed in udev when they appear for the
> > first time, but it's hard to believe that they are critical the very
> > first time they appear on the system. I have a patch that I can send
> > upstream that triggers a change uevent on path devices when they are
> > added to the wwids file.=A0=A0This means that these devices will be
> > correctly claimed by multipath as soon as it gets set up on top of
> > them.
> > =

> > Martin, what do you thing about reverting this change and triggering
> > a
> > uevent instead?
> =

> I haven't been able to obtain stable behavior in my experiments, that's
> why I made this patch. The problem is the correspondence between the
> multipath invocation in 56-multipath.rules and multipathd. I explained
> the problems I had in more detail in the commit message of patch 16 of
> the series. =

> =

> [Note: SUSE uses "-i" in multipath.rules, whereas Fedora/RH does not.
> However with patch 16/33 I changed the code such that "-i" is ignored
> when find_multipaths is used, so that the multipath call in 56-
> multipath.rules actually does the same in both distros in the
> find_multipaths case (only considers paths from the WWIDs file).]
> =

> For a path that's not in the WWIDs file yet, the udev rule will always
> return FALSE (better than with -i, where the result would be
> essentially random). That means that the path will be further processed
> by udev and systemd, and file systems will be mounted, LVM PVs scanned,
> etc.
> =

> When multipathd tries to grab this path later, it will most likely face
> an EBUSY error. Triggering another uevent won't change much if the
> devices are already in use. In the worst case, the multipath map will
> be non-functional but the paths will get SYSTEMD_READY=3D0 set in the new
> uevent, so that the device might become non-accessible by the system
> either through dm (map not set up successfully) or directly
> (SYSTEMD_READY=3D0).

Yep, but this will only happen the first time a device is seen. It's not
a problem on installation, since you are just setting everything up and
not running off your disks anyway.  After that, you are only going to
run into this issue when you first see new storage, which you can pretty
much guarantee isn't essential for the system to function (since your
system was already functioning without it). The only time it can prove
an issue is if you need to transfer an existing filesystem from one
device to another, since this new device will not be immediately
recognized.  In redhat's version, you are allowed to add
mpath.wwid=3D<wwid> to the kernel command line, and when multipathd starts
up, it will automatically add these to the wwids file.  I posted this
patch upstream, but Hannes NAK'ed it (IIRC because he didn't like how I
parsed the kernel commandline from /proc/cmdline). If people are
interested, I can repost it, and we can see if we can work out an
acceptable way to do this.
 =

> Doing this right is a hard problem IMO. Hannes and I thought about some
> new means of communication between multipath and multipathd that would
> guarantee that udev rules and multipathd were in agreement about every
> path, something fast and (almost) lock-less like shared memory. We have
> no code yet, though. (Note: implementing this would require reverting
> our patch "multipathd: start daemon after udev trigger").

Sounds intriguing

> One other idea I had was to have the udev rule treat every path as a
> multipath device path in the first place, then wait for a certain
> amount of time whether additional paths are detected. If yes, maps will
> be set up by multipathd and all is good. If no, we'd need to re-trigger =

> uevents for all "single-path" devices after the timeout, and now we'd
> distinguish between multipath and non-multipath as we are now doing it
> with=A0"multipath -i -u", thus the remaining single-path devices would be
> classified as non-multipath, and eventually be processed by systemd.
> Obvious drawback: single-path devices, more often than not the local
> SAS or SATA disks, would be processed very late in the boot process.
> This could be worked around by blacklisting, just like now.
> =

> I actually have an implementation of this already, but we decided
> against it for SUSE. If you're interested, I can post it here as PoC.

This was actually my first idea with dealing with this, but I gave up on
it also. =


I have repeatedly toyed with the idea of changing how multipath
discovers new devices to a method very similar to your patch, but for
all devices. The idea is to scrap /etc/multipath/wwids and
/etc/multipath/bindings, and use a completely new file, say
/etc/multipath/devices. For every multipath device, it would store the
wwid, possibly the device name (regardless of whether or not it's a
user_friendly_name or a multipath's section alias or just the wwid) and
the vendor, product, and revision data. It would definitively say which
devices were multipathed. If a device is in that file, you multipath it.
If not, you don't. This would make it much easier for udev to determine
if a device should be multipathed. It would simply search for the WWID
in that file. =


The flip side to this is that multipath would no longer automatically
discover devices. You would have to run

# multipath

to discover any new devices. Further, changing the blacklists in
/etc/multipath.conf wouldn't immediately blacklist existing devices. You
would have to run

# multipath (probably with some option)

to make it rescan the existing devices and remove the blacklisted ones
from /etc/multipath/devices. That's why you need to keep the
vendor/product information in that file, so you can blacklist devices
even if they aren't currently present on the system. This would make
multipath work much more like other virtual devices, which won't exist
until you specifically create them. The difference is that instead
having metadata on the device that says that it should be a built into a
virtual device, the metadata is in a seperate file.

The addition of the device name would also make is possible to associate
a path with a specific multipath device inside the udev database,
instead of simply knowing that it belongs to some multipath device. It
would also avoid all those issues where a device gets multipathed in the
initramfs, but doesn't have a user_friendly_names binding, but in the
regular filesystem it does have a binding, and so the name has to change
(although I believe that those have finally all been sorted in the
existing code). =


Redhat support would never let me remove find_multipaths as an option.
Customers hated manually setting up their blacklisting and multipathd
clearly knows enough to find their multipath devices for them. But it
does make claiming devices in udev a pain. However, even the regular
claiming code takes a long time in a udev task that can timeout, causing
all sorts of havoc. This is basically the same idea as your patch for
dealing with find_multipaths, but for all devices. Otherwise multipath
will automatically discover devices if find_multipaths is unset, but
won't if it's set, which seems really confusing.

Obviously, a quick version of this idea would be to simply set
ignore_new_devs all the time. But if we're doing that, I'd really like
to simplify the code that needs to be run for udev to claim the device
and right now blacklisting a device doesn't remove it from
/etc/multipath wwids.

Any thoughts?

> Martin
> =

> -- =

> Dr. Martin Wilck <mwilck@suse.com>, Tel.=A0+49 (0)911 74053 2107
> SUSE Linux GmbH, GF: Felix Imend=F6rffer, Jane Smithard, Graham Norton
> HRB 21284 (AG N=FCrnberg)

From: "Benjamin Marzinski" <bmarzins@redhat.com>
Subject: Re: Improve processing efficiency for addition and
 deletion of multipath devices
Date: Mon, 28 Nov 2016 11:22:26 -0600
Message-ID: <20161128172226.GD1972@octiron.msp.redhat.com>
References: <OF6C4379F8.661B1ACE-ON48258079.000B15EB-48258079.000CBE4F@zte.com.cn>
	<597eba5c-3efa-8b05-3b7b-87792e3d896d@redhat.com>
	<708c4e21-559c-5d50-2525-e1e10a289711@suse.de>
	<61c3088c-062d-ad59-8138-bdd73784c7c0@redhat.com>
	<0d34fede-29b3-1d6f-3fd0-167e1bcf7019@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
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
To: Hannes Reinecke <hare@suse.de>
Cc: tang.junhui@zte.com.cn, zhang.kai16@zte.com.cn, Zdenek Kabelac <zkabelac@redhat.com>, dm-devel@redhat.com, Bart Van Assche <bart.vanassche@sandisk.com>, Martin Wilck <mwilck@suse.com>
List-Id: dm-devel.ids

On Mon, Nov 28, 2016 at 01:08:51PM +0100, Hannes Reinecke wrote:
> On 11/28/2016 12:51 PM, Zdenek Kabelac wrote:
> > Dne 28.11.2016 v 11:42 Hannes Reinecke napsal(a):
> >> On 11/28/2016 11:06 AM, Zdenek Kabelac wrote:
> >>> Dne 28.11.2016 v 03:19 tang.junhui@zte.com.cn napsal(a):
> >>>> Hello Christophe, Ben, Hannes, Martin, Bart,
> >>>> I am a member of host-side software development team of ZXUSP storage
> >>>> project
> >>>> in ZTE Corporation. Facing the market demand, our team decides to
> >>>> write code to
> >>>> promote multipath efficiency next month. The whole idea is in the ma=
il
> >>>> below.We
> >>>> hope to participate in and make progress with the open source
> >>>> community, so any
> >>>> suggestion and comment would be welcome.
> >>>>
> >>>
> >>>
> >>> Hi
> >>>
> >>> First - we are aware of these issue.
> >>>
> >>> The solution proposed in this mail would surely help - but there is
> >>> likely a bigger issue to be solved first.
> >>>
> >>> The core trouble is to avoid  'blkid' disk identification to be
> >>> executed.
> >>> Recent version of multipath is already marking plain 'RELOAD' operati=
on
> >>> of table (which should not be changing disk content) with extra DM bi=
t,
> >>> so udev rules ATM skips 'pvscan' - we also would like to extend the
> >>> functionality to skip rules more and reimport existing 'symlinks' from
> >>> udev database (so they would not get deleted).
> >>>
> >>> I believe the processing of udev rules is 'relatively' quick as long
> >>> as it does not need to read/write ANYTHING from real disks.
> >>>
> >> Hmm. You sure this is an issue?
> >> We definitely need to skip uevent handling when a path goes down (but I
> >> think we do that already), but for 'add' events we absolutely need to
> >> call blkid to figure out if the device has changed.
> >> There are storage arrays out there who use a 'path down/path up' cycle
> >> to inform initiators about any device layout change.
> >> So we wouldn't be able to handle those properly if we don't call blkid
> >> here.
> > =

> > The core trouble is -
> > =

> > =

> > With multipath device - you ONLY want to 'scan' device (with blkid)  wh=
en
> > only the initial first member device of multipath gets in.
> > =

> > So you start multipath (resume -> CHANGE) - it should be the ONLY place
> > to run 'blkid' test (which really goes though over 3/4MB of disk read,
> > to check if there is not ZFS somewhere)
> > =

> > Then any next disk being a member of multipath (recognized by 'multipath
> > -c',
> > should NOT scan)  - as far  as  I can tell current order is opposite,
> > fist there is  'blkid' (60) and then rule (62) recognizes a mpath_membe=
r.
> > =

> > Thus every add disk fires very lengthy blkid scan.
> > =

> > Of course I'm not here an expert on dm multipath rules so passing this
> > on to prajnoha@ -  but I'd guess this is primary source of slowdowns.
> > =

> > There should be exactly ONE blkid for a single multipath device - as
> > long as 'RELOAD' only  add/remove  paths  (there is no reason to scan
> > component devices)
> > =

> ATM 'multipath -c' is just a simple test if the device is supposed to be
> handled by multipath.

Well, "simple" might be stretching the truth a little. I'd really like
to not have to call multipath -c on every change event to a device since
this isn't a particularly quick callout either. In fact we do this with
the redhat code, but we use some horrible hacks, that could be solved if
udev would just allow rules to compare the value of two environment
variables. But this is impossible. I opened a bugzilla for allowing
this, but it recently got closed WONTFIX. The idea is that multipathd
would set a timestamp when it started, when a new wwid was added to the
wwids file, and when it got reconfigured. These are the only times a
configuration could change (well, users could change /etc/multipath.conf
but not reload multipathd, but that will already cause problems). udev
would read this timestamp and save it to the database.  When change
events come along, as long as the timestamp hasn't changed, the old
value of "multipath -c" is still correect.
 =

> And the number of bytes read by blkid should be _that_ large; a simple
> 'blkid' on my device caused it to read 35k ...
> =

> Also udev will become very unhappy if we're not calling blkid for every
> device; you'd be having a hard time reconstructing the event for those
> devices.
> While it's trivial to import variables from parent devices, it's
> impossible to do that from unrelated devices; you'd need a dedicated
> daemon for that.
> So we cannot skip blkid without additional tooling.

We need to run blkid on the multipath device, but I'm not sure what it
gets us on the paths, once we have determined that they belong to
multipath.  multipathd doesn't use any of the values that blkid sets,
and really nothing else should be directly accessing this device.

-Ben

> >>
> >>> So while aggregation of 'uevents' in multipath would 'shorten' queue
> >>> processing of events - it would still not speedup scan alone.
> >>>
> >>> We need to drastically shorten unnecessary disk re-scanning.
> >>>
> >>> Also note - if you have a lot of disks -  it might be worth to checko=
ut
> >>> whether udev picks  'right amount of udev workers'.
> >>> There is heuristic logic to avoid system overload - but might be worth
> >>> to check if in you system with your amount of CPU/RAM/DISKS  the
> >>> computed number is the best for scaling - i.e. if you double the amou=
nt
> >>> of workers - do you
> >>> get any better performance ?
> >>>
> >> That doesn't help, as we only have one queue (within multipath) to
> >> handle all uevents.
> > =

> > This was meant for systems with many different multipath devices.
> > Obviously would not help with a single multipath device.
> > =

> I'm talking about the multipath daemon.
> There will be exactly _one_ instance of the multipath daemon running for
> the entire system, which will be handling _all_ udev events with a
> single queue.
> Independent on the number of attached devices.
> =

> Cheers,
> =

> Hannes
> -- =

> Dr. Hannes Reinecke		   Teamlead Storage & Networking
> hare@suse.de			               +49 911 74053 688
> SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
> GF: F. Imend=F6rffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
> HRB 21284 (AG N=FCrnberg)

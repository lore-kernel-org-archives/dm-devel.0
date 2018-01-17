From: "Benjamin Marzinski" <bmarzins@redhat.com>
Subject: Re: multipath-tools 0.7.4 failure to remove device
Date: Wed, 17 Jan 2018 12:38:59 -0600
Message-ID: <20180117183858.GR5638@octiron.msp.redhat.com>
References: <20180112083833.apsybil4ux4d2y32@jak-x230>
	<1515789339.3409.33.camel@suse.com>
	<20180112214700.ljxlypo5nar6oh3m@jak-x230>
	<1515795481.9139.8.camel@suse.com>
	<20180115154424.fcjuudt7phxrks6q@jak-x230>
	<1516032730.5699.38.camel@suse.com>
	<20180115162658.wlccxhlaq56byykg@jak-x230>
	<1516034784.5699.44.camel@suse.com>
	<20180116202946.GO5638@octiron.msp.redhat.com>
	<1516149827.23203.68.camel@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <1516149827.23203.68.camel@suse.com>
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
Cc: Julian Andres Klode <julian.klode@canonical.com>, Guan Junxiong <guanjunxiong@huawei.com>, development mailing list <dm-devel@redhat.com>
List-Id: dm-devel.ids

On Wed, Jan 17, 2018 at 01:43:47AM +0100, Martin Wilck wrote:
> On Tue, 2018-01-16 at 14:30 -0600, Benjamin Marzinski wrote:
> > On Mon, Jan 15, 2018 at 05:46:24PM +0100, Martin Wilck wrote:
> > > On Mon, 2018-01-15 at 17:26 +0100, Julian Andres Klode wrote:
> > > > On Mon, Jan 15, 2018 at 05:12:10PM +0100, Martin Wilck wrote:
> > > > > On Mon, 2018-01-15 at 16:44 +0100, Julian Andres Klode wrote:
> > So you only classify a device as a multipath device, if either:
> > =

> > 1. you find multiple devices with the same WWID. That's what the
> >    (VECTOR_SIZE(pathvec) > 1) check after the filter_pathvec() call
> >    does.
> > =

> > 2. You find that the device is already part of a multipath device.
> >    That's what the (VECTOR_SIZE(curmp) !=3D 0) after the get_dm_mpvec()
> >    call does.
> =

> My argument from ffbb886 still applies. You classify the first path as
> non-multipath, and subsequent paths as multipath. If systemd is in the
> game, it seems highly likely to me that this will cause havoc, because
> I'd expect it to grab the first path immediately after it's processed. =

> =

> In general, I strongly dislike the fact that subsequent events for the
> same device get opposite results. It just doesn't feel right.
> =

> On practical terms, for users who have root on non-multipath and don't
> care about blacklisting, this logic results in desired behavior. That's
> good.
> =

> But with root on multipath, I expect this to cause trouble. What are
> you doing to avoid the root FS being mounted before it can be
> multipathed? I guess you can get away with it with root on xfs or ext4,
> because the only problem you have is a non-multipathed root FS. With
> root on BTRFS and subvolumes for /usr, /var, etc (as is the default on
> SUSE), you'll run into emergency mode because the latter can't be
> mounted.
> =

> Note that since d7188fcd, multipathd is started after "udev settle"
> during boot. Thus it isn't available for picking up events while the
> first devices are processed. That makes it almost certain that systemd
> will grab the first path (without SYSTEMD_READY=3D0) for mounting root.

Ah, so it seems our disagreement here boils down to the fact that SUSE
adds -i to the mutipath -u call in the udev rules. Clearly, if we aren't
using "multipath -iu" to determine if a path should be claimed in udev,
none of the above applies.

> > This code is actually more stingy with allowing devices to be claimed
> > as
> > multipath devices than it could safely be.  Even though ignore_wwids
> > is
> > set, it should probably also allow devices that are in the wwids
> > file,
> > since they are multipath-able. The idea of ignore_wwids is to be more
> > generous in accepting devices, but by disallowing devices even if
> > they
> > are in the wwids file, it is being less generous in some cases. =

> =

> I didn't realize this so far. I agree that it might be better to allow
> devices from the wwids file, too.
> =

> > As for implying -n with find_multipaths, my personal opinion is that
> > it
> > breaks the main point of find_multipaths, which is to make stuff
> > "just
> > work". Since RedHat has been running with find_multipaths as the
> > default
> > for years now, I am well aware of the race-y issue. But in practice
> > it's not very bad.
> > =

> > Here is how I see it. The first time a multipathable device appears,
> > the
> > udev rules will not claim the first path of it. Multipathd will also
> > not
> > immediately create a multipath device on top of it.  This means that
> > something else could auto set-up on it.  The most likely way this can
> > happen is if you are adding new storage that already has LVM/MD
> > metadata
> > on it.  =

> > lvm will auto-activate on that new path, making multipath unable
> > to create the multipath device.
> > =

> > If you think that sounds like a big problem, you should consider that
> > if
> > you use the default multipath udev rules, the exact same problem
> > happens
> > if you don't use find_multipaths as well. That's because when we
> > check
> > if multipath can claim a device, we don't call multipath -u with -i.
> =

> At SUSE, we apply a patch that adds the "-i" flag to the "multipath -u
> call" in the udev rules. By default, we treat all non-blacklisted
> devices as multipath devices. That's why ffbb886 "ignore -i if
> find_multipaths is set" is handy for SUSE - it avoids the non-
> deterministic behavior with both "find_multpaths" and "ignore_wwids".
> =

> Unless I'm mistaken, the configuration with "find_multipaths=3Don" and
> "ignore_wwids=3Don" would only matter in practice if "-i" was added to
> the rules (as SUSE does) *and* ffbb886 is backed out (as Red Hat does,
> and apparently Ubuntu, too). No big distro seems to do it that way by
> default, apparently. But OTOH, no big distro is using the current
> upstream conventions, either.

Yeah. The reason I added the -i code in the first place was to allow
anaconda (the RHEL system installer) a way to determine what devices
should be multipathable. It is called by the program after the system
has booted and all devices are discovered. Anaconda doesn't actually use
it anymore, but I would still like there to be a command to let users
find out what devices should be multipath-able, recardless of whether
they have been multipathed before. That is what I see "-i" as being for.

> > This actually can save thoughtless users some headaches.  If they
> > aren't
> > using find_multipaths, and they don't setup their blacklisting
> > correctly, multipath still won't claim devices that are already in
> > use
> > when it starts up, because it will never create a multipath device on
> > them, so it will never add their wwid to the wwids file.
> =

> Am I mistaken, or did you just present an argument for not using (aka
> "ignoring") "-i" with find_multipath? :-)

Again, We don't use -i with udev. I want it solely to help users gather
information (what devices could be multipathed, not which are).

> > So in short, the problem (which currently effects multipath
> > regardless
> > of whether find_multipaths is set) is that when new storage is added,
> > if
> > that new storage already has metadata on it that the system will use
> > to
> > autoassemble something else on top of the device (in practice this
> > means
> > lvm/md metadata), you may autoassemble the wrong thing on the device.
> > It's a race, and yes, find-multipaths is more likely to lose the race
> > because it can't start assembling until the second path appears.
> > The solution is to simply remove the lvm/dm device, and run
> > multipath,
> > and from then on, you will never see the problem again.
> =

> If this was the only issue, I wouldn't see any reason to argue. I'm
> fairly sure that I made the two patches in question in order to
> fix some really nasty boot issues. That was almost a year ago, so I
> need to double-check. If neither Red Hat nor Ubuntu are seeing severe
> problems, maybe those hangs in the past were caused by something else.

If you use -i in your udev rules, then with find_multipaths enabled, you
will run into the issue where multipath will not claim the first path
(and this will happen every time, not just the first time mutipath sees
a device, because like I mentioned above, when -i is used, we don't
allow devices just beacuase the are in the wwids file). Then, when
multipathd does create the device (and it will try immediately if the
device is in the wwids file), it can race with whoever is using it. Once
a second path has appeared, the next time a change event happens on the
first path, it will get claimed by multipath, and set to not ready, and
udev will remove the path's partition devices. I can see how this would
cause a lot of boot issues.

> > The only bug I have ever received about this issue was because
> > anaconda
> > (the redhat system installer) knew that multipath was supposed to be
> > running on a device, but couldn't disassemble the lvm device that got
> > automatically created, because of the old meta-data. The solution is
> > to
> > make anaconda smarter.
> > =

> > As a side note, RedHat also adds code to automatically fire off a
> > change
> > uevent on all the path devices on the first time a multipath device
> > is
> > created, so that all the path devices get correctly claimed by
> > multipath
> > after the fact, on the first create. It's currently part of the same
> > patch that reverts the two commits listed above, but I have no
> > problem
> > with posting it as a seperate patch. =

> =

> That sounds interesting, although I don't see how it would help once
> systemd has grabbed the first path.

It can't stop something automated from using the path before multipathd
creates a device the first time it sees new storage. The race is still
there, and users still have to remove the lvm device or whatever it was
that got autoassembled (it's not usually a filesystem, since people
don't generally update their fstab to automount new storage before
connecting it for the first time) and then run mutipath. But the
majority of the time that people connect new storage, nothing will
autoassemble on top of it. And in this case, mutipath will update the
udev database so that all the new paths are claimed before any manual
setup is run on the new storage.  And like I said, I've only ever gotten
one bug for this.
 =

> > I obviously have no problem with
> > reverting those two commits upstream either. But I don't feel
> > horribly
> > burdened with carrying them as RedHat patches.
> =

> No problem for me to carry 64e27ec and ffbb886 as SUSE-patches, either.
> It's not optimal that the current upstream code represents a mixture of
> various distro patches that no distro is actually using. We should
> agree on one approach for upstream.
> =

> So either we should revert 64e27ec (and maybe ffbb886, too, but I'm not
> yet convinced), and add your "fire off change uevent" patch (take the
> "Red Hat / Ubuntu approach"), or we should add "-i" to the multipath
> call in the udev rules ("SUSE approach"). I'm fine with both.

Like I said, none of the RedHat multipath rules use -i, and neither does
anaconda anymore, so it's not essential. But I'd like it to be around to
help users gather information about their devices.

-Ben
 =

> Regards,
> Martin
> =

> -- =

> Dr. Martin Wilck <mwilck@suse.com>, Tel. +49 (0)911 74053 2107
> SUSE Linux GmbH, GF: Felix Imend=F6rffer, Jane Smithard, Graham Norton
> HRB 21284 (AG N=FCrnberg)

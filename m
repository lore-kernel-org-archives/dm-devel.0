From: "Benjamin Marzinski" <bmarzins@redhat.com>
Subject: Re: multipath-tools 0.7.4 failure to remove device
Date: Tue, 16 Jan 2018 14:30:46 -0600
Message-ID: <20180116202946.GO5638@octiron.msp.redhat.com>
References: <20180112083833.apsybil4ux4d2y32@jak-x230>
	<1515789339.3409.33.camel@suse.com>
	<20180112214700.ljxlypo5nar6oh3m@jak-x230>
	<1515795481.9139.8.camel@suse.com>
	<20180115154424.fcjuudt7phxrks6q@jak-x230>
	<1516032730.5699.38.camel@suse.com>
	<20180115162658.wlccxhlaq56byykg@jak-x230>
	<1516034784.5699.44.camel@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <1516034784.5699.44.camel@suse.com>
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

On Mon, Jan 15, 2018 at 05:46:24PM +0100, Martin Wilck wrote:
> On Mon, 2018-01-15 at 17:26 +0100, Julian Andres Klode wrote:
> > On Mon, Jan 15, 2018 at 05:12:10PM +0100, Martin Wilck wrote:
> > > On Mon, 2018-01-15 at 16:44 +0100, Julian Andres Klode wrote:
> > > > =

> > > > It was your commit that made it imply -n that caused the test
> > > > failure
> > > > :)
> > > > I understand your position on that, but reverted it for Ubuntu,
> > > > because,
> > > > while it might be somewhat broken, it's at least the same level
> > > > of
> > > > broken
> > > > as before.
> > > =

> > > I'd like to understand that better. Why would this break boot?
> > =

> > Ah sorry for the confusion. It did not break boot. Having finding
> > disabled would have "broken" boot. The problem I was talking about
> > was that with finding enabled, no dm devices were generated, which
> > it turned out, was not entirely true - you had to run multipath
> > manually (due to your find implies -n commit). =

> > =

> > It seems to me that this would cause more issues in practice than
> > just keeping the slightly race-y combination enabled. It's something
> > to revisit after the ubuntu lts when then people have some time to
> > adjust to that change.
> =

> I wouldn't call it "slightly race-y". With find_multipaths "on" and
> "ignore_wwids" "off", "multipath -u" classifies every device as a
> multipath device. So SYSTEMD_READY=3D0 will be set on each device. But
> multipathd, which is responsible for actually setting up the map, will
> honor "find_multipaths", and will not set up a map for a device it
> finds only a single path for. So the device never appears in a state in
> which systemd would be able to use it. Unless you've put in some other
> magic, this is almost guaranteed to make your system unbootable in the
> quite common case where people using multipath are running off a non-
> multipathed local root disk.

RedHat also removes your patches to force ignore_wwids off and imply -n

64e27ec066a001012f44550f095c93443e91d845
ffbb886a8a16cb063d669cd76a1e656fd3ec8c4b

I don't see any why that this could claim all the devices and render a
system unbootable. First off, I assume you mean that there is a problem
with find_multipaths "on" and ignore_wwids "on", since your patch forces
ignore_wwids "off", and with that setting, mutipath will obviously only
claim devices in the wwids file.

But with find_multipaths "on" and ignore_wwids "on", you don't classify
every device as a multipath device. Here's the code

        if (get_dm_mpvec(cmd, curmp, pathvec, refwwid))
                goto out;

        filter_pathvec(pathvec, refwwid);


        if (cmd =3D=3D CMD_VALID_PATH) {
                /* This only happens if find_multipaths and
                 * ignore_wwids is set.
                 * If there is currently a multipath device matching
                 * the refwwid, or there is more than one path matching
                 * the refwwid, then the path is valid */
                if (VECTOR_SIZE(curmp) !=3D 0 || VECTOR_SIZE(pathvec) > 1)
                        r =3D 0;
                printf("%s %s a valid multipath device path\n",
                       devpath, r =3D=3D 0 ? "is" : "is not");
                goto out;
        }

So you only classify a device as a multipath device, if either:

1. you find multiple devices with the same WWID. That's what the
   (VECTOR_SIZE(pathvec) > 1) check after the filter_pathvec() call
   does.

2. You find that the device is already part of a multipath device.
   That's what the (VECTOR_SIZE(curmp) !=3D 0) after the get_dm_mpvec()
   call does.

This code is actually more stingy with allowing devices to be claimed as
multipath devices than it could safely be.  Even though ignore_wwids is
set, it should probably also allow devices that are in the wwids file,
since they are multipath-able. The idea of ignore_wwids is to be more
generous in accepting devices, but by disallowing devices even if they
are in the wwids file, it is being less generous in some cases. =


As for implying -n with find_multipaths, my personal opinion is that it
breaks the main point of find_multipaths, which is to make stuff "just
work". Since RedHat has been running with find_multipaths as the default
for years now, I am well aware of the race-y issue. But in practice
it's not very bad.

Here is how I see it. The first time a multipathable device appears, the
udev rules will not claim the first path of it. Multipathd will also not
immediately create a multipath device on top of it.  This means that
something else could auto set-up on it.  The most likely way this can
happen is if you are adding new storage that already has LVM/MD metadata
on it.  lvm will auto-activate on that new path, making multipath unable
to create the multipath device.

If you think that sounds like a big problem, you should consider that if
you use the default multipath udev rules, the exact same problem happens
if you don't use find_multipaths as well. That's because when we check
if multipath can claim a device, we don't call multipath -u with -i.
This actually can save thoughtless users some headaches.  If they aren't
using find_multipaths, and they don't setup their blacklisting
correctly, multipath still won't claim devices that are already in use
when it starts up, because it will never create a multipath device on
them, so it will never add their wwid to the wwids file.

So in short, the problem (which currently effects multipath regardless
of whether find_multipaths is set) is that when new storage is added, if
that new storage already has metadata on it that the system will use to
autoassemble something else on top of the device (in practice this means
lvm/md metadata), you may autoassemble the wrong thing on the device.
It's a race, and yes, find-multipaths is more likely to lose the race
because it can't start assembling until the second path appears.
The solution is to simply remove the lvm/dm device, and run multipath,
and from then on, you will never see the problem again.

The only bug I have ever received about this issue was because anaconda
(the redhat system installer) knew that multipath was supposed to be
running on a device, but couldn't disassemble the lvm device that got
automatically created, because of the old meta-data. The solution is to
make anaconda smarter.

As a side note, RedHat also adds code to automatically fire off a change
uevent on all the path devices on the first time a multipath device is
created, so that all the path devices get correctly claimed by multipath
after the fact, on the first create. It's currently part of the same
patch that reverts the two commits listed above, but I have no problem
with posting it as a seperate patch. I obviously have no problem with
reverting those two commits upstream either. But I don't feel horribly
burdened with carrying them as RedHat patches.

-Ben

> Martin
> =

> -- =

> Dr. Martin Wilck <mwilck@suse.com>, Tel. +49 (0)911 74053 2107
> SUSE Linux GmbH, GF: Felix Imend=F6rffer, Jane Smithard, Graham Norton
> HRB 21284 (AG N=FCrnberg)
> =

> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel

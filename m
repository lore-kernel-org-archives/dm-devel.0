From: "Benjamin Marzinski" <bmarzins@redhat.com>
Subject: Re: [PATCH v3 17/20] multipath -u: test if path is busy
Date: Fri, 13 Apr 2018 10:53:35 -0500
Message-ID: <20180413155335.GC3103@octiron.msp.redhat.com>
References: <20180402195051.26854-1-mwilck@suse.com>
	<20180402195051.26854-18-mwilck@suse.com>
	<20180412184109.GS3103@octiron.msp.redhat.com>
	<1523571474.4346.107.camel@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <1523571474.4346.107.camel@suse.com>
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
Cc: dm-devel@redhat.com, Julian Andres Klode <julian.klode@canonical.com>
List-Id: dm-devel.ids

On Fri, Apr 13, 2018 at 12:17:54AM +0200, Martin Wilck wrote:
> On Thu, 2018-04-12 at 13:41 -0500, Benjamin Marzinski wrote:
> > On Mon, Apr 02, 2018 at 09:50:48PM +0200, Martin Wilck wrote:
> > > For "find_multipaths smart", check if a path is already in use
> > > before setting DM_MULTIPATH_DEVICE_PATH to 1 or 2 (and thus,
> > > SYSTEMD_READY=3D0). If we don't do this, a device which has already
> > > been
> > > mounted (e.g. during initrd processing) may be unmounted by
> > > systemd, causing
> > > havoc to the boot process.
> > =

> > I'm reviewing  v3 of this patch because I don't see patch 17/20 in
> > your
> > emails from v4. Am I missing an email, or did it not get sent?
> =

> It seems so, it didn't reach the dm-devel archive either. Strange.
> I got it on my suse.com address, so maybe something went wrong in our
> outgoing server. Anyway, v3/17 and v4/17 are identical.
> =

> > =

> > Signed-off-by: Martin Wilck <mwilck@suse.com>
> > > +
> > > +		/*
> > > +		 * If opening the path with O_EXCL fails, the path
> > > +		 * is in use (e.g. mounted during initramfs
> > > processing).
> > > +		 * We know that it's not used by dm-multipath.
> > > +		 * We may not set SYSTEMD_READY=3D0 on such devices,
> > > it
> > > +		 * might cause systemd to umount the device.
> > > +		 * Use O_RDONLY, because udevd would trigger
> > > another
> > > +		 * uevent for close-after-write.
> > > +		 *
> > > +		 * get_refwwid() above stores the path we examine
> > > in slot 0.
> > > +		 */
> > > +		pp =3D VECTOR_SLOT(pathvec, 0);
> > > +		fd =3D open(udev_device_get_devnode(pp->udev),
> > > +			  O_RDONLY|O_EXCL);
> > =

> > I'm worried about this.  Since we can't be sure that is_failed_wwid()
> > will really tell us that multipathd has tried to multipath the device
> > and failed, =

> =

> As I said already, I don't understand why you say that.
> =

> I can assert that if is_failed_wwid() returns true, multipathd has
> definitely tried and failed since the last reboot, and no (other
> instance of) multipathd or multipath has succeeded since then.
> =

> If is_failed_wwid() returns false, it's possible that the map already
> exists (see patch 18), or that previous/current instances of multipathd
> simply didn't try -  we have to check by other means.

I probably shouldn't have brought up is_failed_wwid() up here at all.
It has really nothing to do with my main point.

But just to rehash this again, you do agree that multipathd can get a
uevent for for a path device, recognize that it should create a
multipath device on it, and then fail somewhere in ev_add_path before it
get around to calling domap, right? If this happens, multipathd won't
automatically try to create that device again until either it gets
another add event for a path in that device, or it is reconfigured.  In
this case the is_failed_wwid() result would make it seem like multipathd
might still be waiting to create this device, when in truth, that won't
happen.

But I already agreed that that code is fine without giving you that kind
of guarantee, so there's no point in bring it up here. Lets just ignore
that.
 =

> > it is totally possible to get a maybe after multipath has
> > turned the path device over to the rest of the system.
> =

> A transition from "no" to "maybe" is only possible if a single path,
> which isn't in the WWIDs file and isn't part of a multipath map,
> transitions A) from "failed" to  "not failed" or B) from "blacklisted"
> to "not blacklisted". A) means that multipathd has successfully created
> a map, thus the path is now part of a map, and we will transition to
> "yes" and not to "maybe". B) is pathogical except for the coldplug
> case.

I agree that udev transitioning a device from "no" to "maybe" isn't
something that needs worrying about.  I do think it's valid to worry
about a device that previously was classified as "maybe", then timed out
to "no", and is now getting a new uevent, and having an exlusive open
run on it because at this point in configure(), it is classified as
"maybe". Obviously it has already timed out, so it will eventually be
classified as "no". But the exclusive open is still dangerous. Since you
agree that it is dangerous in the "no" to "yes" case, I assume you agree
it's dangerous here as well. This is why I said that the whole second
(cmd =3D=3D CMD_VALID_PATH) section, where we check for devices that aren't
obviously multipath paths and haven't been multipathed yet, shouldn't
happen after we have classified a device as "no". =


> However, transitioning from "no" to "yes" in multipath -u is just as
> bad as "no" to "maybe", unless the device has already been multipathed.
> This is a common case: a second path appears for a once-released
> device. I agree that we shouldn't try open(O_EXCL) in that situation.
> =

> > =

> > Of course, this means I would exlcude the whole second "if (cmd =3D=3D
> > CMD_VALID_PATH)" section in configure() unless we know that it is
> > safe
> > to grab the device.  Otherwise, there is nothing to stop us from
> > claiming a device that is in use. Clearly that exclusive grab check
> > is
> > racy at any time except on add events or when the device already is
> > set
> > to SYSTEMD_READY=3D0.  I'm pretty sure that the coldplug add event
> > after
> > the switchroot is safe, since nothing will be racing to grab the
> > device
> > then. =

> > =

> > You've already agreed that it should be fine to allow multipathd to
> > try
> > to create a multipath device on top of a non-claimed path, since we
> > can
> > just claim it later by issuing a uevent.  I feel like this is just
> > another instance of that.  If this isn't a new path, where we have
> > excluded everyone else from using it, we can't suddenly claim it just
> > because a second path appears. However, if multipathd manages to
> > create
> > a multipath device on top of it, then it will add the wwid to the
> > wwids
> > file, and be able to claim it.  But otherwise, I don't think that the
> > exclusive grab is safe or reliable enough to allow us to simply do
> > this
> > on any uevent.
> > =

> > I would add a new option to multipath, that works with -u, to tell it
> > that maybes are allowed. If find_multipaths =3D=3D FIND_MULTIPATHS_SMAR=
T,
> > then it should not claim the device if it doesn't get positively
> > claimed
> > in the first "if (cmd =3D=3D CMD_VALID_PATH)" section of configure().
> > That
> > will save us from claiming devices that are already in use, and speed
> > the multipath -u calls up.
> =

> I don't think we need another option. We can use the uevent environment
> in the -u case.

Sure.
 =

> Regards,
> Martin
> =

> -- =

> Dr. Martin Wilck <mwilck@suse.com>, Tel. +49 (0)911 74053 2107
> SUSE Linux GmbH, GF: Felix Imend=F6rffer, Jane Smithard, Graham Norton
> HRB 21284 (AG N=FCrnberg)

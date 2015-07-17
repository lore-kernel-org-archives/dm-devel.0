From: Pali =?utf-8?q?Roh=C3=A1r?= <pali.rohar@gmail.com>
Subject: Re: [PATCH v2 2/3] dm: Export function dm_suspend_md()
Date: Fri, 17 Jul 2015 19:13:56 +0200
Message-ID: <201507171913.57104@pali>
References: <1428254419-7334-1-git-send-email-pali.rohar@gmail.com> <20150717152253.GA1021@redhat.com> <20150717153045.GB1021@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1543878.sFMI0B1erI";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Return-path: <linux-pm-owner@vger.kernel.org>
In-Reply-To: <20150717153045.GB1021@redhat.com>
Sender: linux-pm-owner@vger.kernel.org
To: Mike Snitzer <snitzer@redhat.com>
Cc: Len Brown <len.brown@intel.com>, linux-pm@vger.kernel.org, "Rafael J. Wysocki" <rjw@rjwysocki.net>, linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, dm-devel@redhat.com, Pavel Machek <pavel@ucw.cz>, Alasdair Kergon <agk@redhat.com>
List-Id: dm-devel.ids

--nextPart1543878.sFMI0B1erI
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Friday 17 July 2015 17:30:45 Mike Snitzer wrote:
> On Fri, Jul 17 2015 at 11:22am -0400,
>=20
> Mike Snitzer <snitzer@redhat.com> wrote:
> > On Fri, Jul 17 2015 at 10:22am -0400,
> >=20
> > Pali Roh=C3=A1r <pali.rohar@gmail.com> wrote:
> > > On Friday 17 July 2015 10:04:39 Mike Snitzer wrote:
> > > > On Sun, Jun 21 2015 at  7:20am -0400,
> > > >=20
> > > > Pali Roh=C3=A1r <pali.rohar@gmail.com> wrote:
> > > > > This patch exports function dm_suspend_md() which suspend
> > > > > mapped device so other kernel drivers can use it and could
> > > > > suspend mapped device when needed.
> > > > >=20
> > > > > Signed-off-by: Pali Roh=C3=A1r <pali.rohar@gmail.com>
> > > > > ---
> > > > >=20
> > > > >  drivers/md/dm.c |    6 ++++++
> > > > >  drivers/md/dm.h |    5 +++++
> > > > >  2 files changed, 11 insertions(+)
> > > > >=20
> > > > > diff --git a/drivers/md/dm.c b/drivers/md/dm.c
> > > > > index 2caf492..03298ff 100644
> > > > > --- a/drivers/md/dm.c
> > > > > +++ b/drivers/md/dm.c
> > > > >=20
> > > > > @@ -3343,6 +3343,12 @@ out:
> > > > >  	return r;
> > > > > =20
> > > > >  }
> > > > >=20
> > > > > +int dm_suspend_md(struct mapped_device *md)
> > > > > +{
> > > > > +	return dm_suspend(md, DM_SUSPEND_LOCKFS_FLAG);
> > > > > +}
> > > > > +EXPORT_SYMBOL_GPL(dm_suspend_md);
> > > > > +
> > > > >=20
> > > > >  /*
> > > > > =20
> > > > >   * Internal suspend/resume works like userspace-driven
> > > > >   suspend. It waits * until all bios finish and prevents
> > > > >   issuing new bios to the target drivers.
> > > >=20
> > > > To do this properly you should be introducing a variant of
> > > > dm_internal_suspend.  We currently have two variants:
> > > > dm_internal_suspend_fast
> > > > dm_internal_suspend_noflush
> > > >=20
> > > > The reason to use a dm_internal_suspend variant is this suspend
> > > > was _not_ initiated by an upper level ioctl (from userspace).=20
> > > > It was done internally from within the target.
> > > >=20
> > > > You're explicitly using DM_SUSPEND_LOCKFS_FLAG above.. meaning
> > > > you're interested in flushing all pending IO (in the FS
> > > > layered on dm-crupt, if one exists).
> > > >=20
> > > > But see the comment in __dm_internal_suspend() about
> > > > TASK_UNINTERRUPTIBLE. If you're OK with the dm-crypt initiated
> > > > suspend being TASK_UNINTERRUPTIBLE then you could just
> > > > introduce:
> > > >=20
> > > > void dm_internal_suspend_uninterruptible_flush(struct
> > > > mapped_device *md) {
> > > >=20
> > > >         mutex_lock(&md->suspend_lock);
> > > >         __dm_internal_suspend(md, DM_SUSPEND_LOCKFS_FLAG);
> > > >         mutex_unlock(&md->suspend_lock);
> > > >=20
> > > > }
> > > > EXPORT_SYMBOL_GPL(dm_internal_suspend_uninterruptible_flush);
> > > >=20
> > > > Otherwise, there is much more extensive DM core changes needed
> > > > to __dm_internal_suspend() and .presuspend to properly support
> > > > TASK_INTERRUPTIBLE.
> > >=20
> > > Hi! I will look at dm_internal_suspend. Anyway use case for
> > > suspend is from dm-crypt to do both operations: suspend + key
> > > wipe. It means that without entering key again from userspace,
> > > resume is not possible. So my question is: It is possible to do
> > > internal suspend and then using resume from userspace via ioctl?
> >=20
> > Good question: no, userspace resume would block waiting for
> > internal resume.
> >=20
> > Soooo... I'll have to look at your patch 3 to understand why
> > dm-crypt is needing to initiate the suspend internally but then
> > userspace is initiating the resume... this imbalance is
> > concerning.
>=20
> Why not introduce a new message that allows you to wipe the key after
> suspend?  Both initiated from userspace.

There is already message for wiping key and it will success only if dm=20
is suspended.

But this patch series is fixing another problem: wipe key before=20
suspend/hibernation action happend and to have it race free it must be=20
done after userspace is freezed!

=2D-=20
Pali Roh=C3=A1r
pali.rohar@gmail.com

--nextPart1543878.sFMI0B1erI
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEABECAAYFAlWpN9UACgkQi/DJPQPkQ1IkIwCgp91zrE7aLxrj6ZccppG7mToQ
yOMAoK0b0ZcsmgmZJaiWSH8bG/4Va9XW
=vYGk
-----END PGP SIGNATURE-----

--nextPart1543878.sFMI0B1erI--

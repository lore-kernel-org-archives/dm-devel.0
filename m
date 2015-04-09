From: Pali =?utf-8?q?Roh=C3=A1r?= <pali.rohar@gmail.com>
Subject: Re: [PATCH 1/3] PM suspend/hibernate: Call notifier after freezing processes
Date: Thu, 9 Apr 2015 08:36:57 +0200
Message-ID: <201504090836.57365@pali>
References: <1428254419-7334-1-git-send-email-pali.rohar@gmail.com> <1428254419-7334-2-git-send-email-pali.rohar@gmail.com> <1530775.n2Kjx1bffW@vostro.rjw.lan>
Mime-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart2566388.gOmNIJrIqI";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1530775.n2Kjx1bffW@vostro.rjw.lan>
Sender: linux-raid-owner@vger.kernel.org
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@redhat.com>, Neil Brown <neilb@suse.de>, Len Brown <len.brown@intel.com>, Pavel Machek <pavel@ucw.cz>, dm-devel@redhat.com, linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org
List-Id: dm-devel.ids

--nextPart2566388.gOmNIJrIqI
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Thursday 09 April 2015 02:28:41 Rafael J. Wysocki wrote:
> On Sunday, April 05, 2015 07:20:17 PM Pali Roh=C3=A1r wrote:
> > To prevent race conditions on userspace processes with I/O
> > some taks must be called after processes are freezed. This
> > patch adds new events which are delivered by
> > pm_notifier_call_chain() after freezing processes when
> > doing suspend or hibernate action.
> >=20
> > Signed-off-by: Pali Roh=C3=A1r <pali.rohar@gmail.com>
>=20
> Please don't add more notifiers.  Just call whatever you need
> directly from where you need to call that.
>=20
> If that is device-related, try to use device PM
> suspend/hibernate callbacks instead.
>=20

Hi! It is not possible to use any exiting pm notifiers! This is=20
reason why I added new ones. As I wrote wiping dm crypt keys must=20
be done *after* userspace processes are freezed to prevent race=20
conditions...

> > ---
> >=20
> >  include/linux/suspend.h  |    2 ++
> >  kernel/power/hibernate.c |    2 ++
> >  kernel/power/suspend.c   |    4 +++-
> >  3 files changed, 7 insertions(+), 1 deletion(-)
> >=20
> > diff --git a/include/linux/suspend.h
> > b/include/linux/suspend.h index 5efe743..bc743c8 100644
> > --- a/include/linux/suspend.h
> > +++ b/include/linux/suspend.h
> > @@ -368,6 +368,8 @@ static inline bool
> > hibernation_available(void) { return false; }
> >=20
> >  #define PM_POST_SUSPEND		0x0004 /* Suspend finished */
> >  #define PM_RESTORE_PREPARE	0x0005 /* Going to restore a
> >  saved image */ #define PM_POST_RESTORE		0x0006 /*
> >  Restore
> >  failed */
> >=20
> > +#define PM_HIBERNATION_AFTER_FREEZE	0x0007 /* After
> > hibernation freeze */ +#define
> > PM_SUSPEND_AFTER_FREEZE		0x0008 /* After suspend freeze */
> >=20
> >  extern struct mutex pm_mutex;
> >=20
> > diff --git a/kernel/power/hibernate.c
> > b/kernel/power/hibernate.c index 2329daa..184f7ee 100644
> > --- a/kernel/power/hibernate.c
> > +++ b/kernel/power/hibernate.c
> > @@ -671,6 +671,8 @@ int hibernate(void)
> >=20
> >  	if (error)
> >  =09
> >  		goto Exit;
> >=20
> > +	pm_notifier_call_chain(PM_HIBERNATION_AFTER_FREEZE);
> > +
> >=20
> >  	lock_device_hotplug();
> >  	/* Allocate memory management structures */
> >  	error =3D create_basic_memory_bitmaps();
> >=20
> > diff --git a/kernel/power/suspend.c b/kernel/power/suspend.c
> > index b7d6b3a..1776938 100644
> > --- a/kernel/power/suspend.c
> > +++ b/kernel/power/suspend.c
> > @@ -268,8 +268,10 @@ static int
> > suspend_prepare(suspend_state_t state)
> >=20
> >  	trace_suspend_resume(TPS("freeze_processes"), 0, true);
> >  	error =3D suspend_freeze_processes();
> >  	trace_suspend_resume(TPS("freeze_processes"), 0, false);
> >=20
> > -	if (!error)
> > +	if (!error) {
> > +		pm_notifier_call_chain(PM_SUSPEND_AFTER_FREEZE);
> >=20
> >  		return 0;
> >=20
> > +	}
> >=20
> >  	suspend_stats.failed_freeze++;
> >  	dpm_save_failed_step(SUSPEND_FREEZE);

=2D-=20
Pali Roh=C3=A1r
pali.rohar@gmail.com

--nextPart2566388.gOmNIJrIqI
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEABECAAYFAlUmHgkACgkQi/DJPQPkQ1KqBQCgsCMPDSjapvieT2WGen4RFz1c
FZ0AoLar16geldAQXYKF7cbDoVv1l2bf
=QehT
-----END PGP SIGNATURE-----

--nextPart2566388.gOmNIJrIqI--

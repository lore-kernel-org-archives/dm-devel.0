From: Pali =?utf-8?B?Um9ow6Fy?= <pali.rohar@gmail.com>
Subject: Re: [PATCH v2 1/3] PM suspend/hibernate: Call notifier after
 freezing processes
Date: Thu, 16 Jul 2015 09:33:02 +0200
Message-ID: <20150716073302.GA10393@pali>
References: <1428254419-7334-1-git-send-email-pali.rohar@gmail.com>
 <1434885634-19895-1-git-send-email-pali.rohar@gmail.com>
 <1434885634-19895-2-git-send-email-pali.rohar@gmail.com>
 <3729395.1oJCgMXcLU@vostro.rjw.lan>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <3729395.1oJCgMXcLU@vostro.rjw.lan>
Sender: linux-kernel-owner@vger.kernel.org
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@redhat.com>, Neil Brown <neilb@suse.de>, Len Brown <len.brown@intel.com>, Pavel Machek <pavel@ucw.cz>, dm-devel@redhat.com, linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org
List-Id: dm-devel.ids

On Thursday 16 July 2015 03:02:03 Rafael J. Wysocki wrote:
> On Sunday, June 21, 2015 01:20:32 PM Pali Roh=C3=A1r wrote:
> > To prevent race conditions on userspace processes with I/O some tak=
s must be
> > called after processes are freezed. This patch adds new events whic=
h are
> > delivered by pm_notifier_call_chain() after freezing processes when=
 doing
> > suspend or hibernate action.
> >=20
> > Signed-off-by: Pali Roh=C3=A1r <pali.rohar@gmail.com>
> > ---
> >  include/linux/suspend.h  |    2 ++
> >  kernel/power/hibernate.c |    2 ++
> >  kernel/power/suspend.c   |    4 +++-
> >  3 files changed, 7 insertions(+), 1 deletion(-)
> >=20
> > diff --git a/include/linux/suspend.h b/include/linux/suspend.h
> > index 5efe743..bc743c8 100644
> > --- a/include/linux/suspend.h
> > +++ b/include/linux/suspend.h
> > @@ -368,6 +368,8 @@ static inline bool hibernation_available(void) =
{ return false; }
> >  #define PM_POST_SUSPEND		0x0004 /* Suspend finished */
> >  #define PM_RESTORE_PREPARE	0x0005 /* Going to restore a saved imag=
e */
> >  #define PM_POST_RESTORE		0x0006 /* Restore failed */
> > +#define PM_HIBERNATION_AFTER_FREEZE	0x0007 /* After hibernation fr=
eeze */
> > +#define PM_SUSPEND_AFTER_FREEZE		0x0008 /* After suspend freeze */
> > =20
> >  extern struct mutex pm_mutex;
> > =20
> > diff --git a/kernel/power/hibernate.c b/kernel/power/hibernate.c
> > index 2329daa..184f7ee 100644
> > --- a/kernel/power/hibernate.c
> > +++ b/kernel/power/hibernate.c
> > @@ -671,6 +671,8 @@ int hibernate(void)
> >  	if (error)
> >  		goto Exit;
> > =20
> > +	pm_notifier_call_chain(PM_HIBERNATION_AFTER_FREEZE);
>=20
> Don't we need to check errors from these?
>=20

If yes, what to do in this case? Fail hibernation and goto Exit?

> Also, if you're adding AFTER_FREEZE, it would be good to add BEFORE_T=
HAW too
> for symmetry.
>=20

But there is no use case for BEFORE_THAW. At least it is not needed for=
 now.

> > +
> >  	lock_device_hotplug();
> >  	/* Allocate memory management structures */
> >  	error =3D create_basic_memory_bitmaps();
> > diff --git a/kernel/power/suspend.c b/kernel/power/suspend.c
> > index 8d7a1ef..ba2a945 100644
> > --- a/kernel/power/suspend.c
> > +++ b/kernel/power/suspend.c
> > @@ -277,8 +277,10 @@ static int suspend_prepare(suspend_state_t sta=
te)
> >  	trace_suspend_resume(TPS("freeze_processes"), 0, true);
> >  	error =3D suspend_freeze_processes();
> >  	trace_suspend_resume(TPS("freeze_processes"), 0, false);
> > -	if (!error)
> > +	if (!error) {
> > +		pm_notifier_call_chain(PM_SUSPEND_AFTER_FREEZE);
> >  		return 0;
> > +	}
> > =20
> >  	suspend_stats.failed_freeze++;
> >  	dpm_save_failed_step(SUSPEND_FREEZE);
> >=20
>=20

--=20
Pali Roh=C3=A1r
pali.rohar@gmail.com

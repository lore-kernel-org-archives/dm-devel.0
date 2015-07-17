From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [PATCH v2 2/3] dm: Export function dm_suspend_md()
Date: Fri, 17 Jul 2015 13:31:47 -0400
Message-ID: <20150717173147.GA5060@redhat.com>
References: <1428254419-7334-1-git-send-email-pali.rohar@gmail.com>
 <20150717152253.GA1021@redhat.com>
 <20150717153045.GB1021@redhat.com>
 <201507171913.57104@pali>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <201507171913.57104@pali>
Sender: linux-kernel-owner@vger.kernel.org
To: Pali =?iso-8859-1?Q?Roh=E1r?= <pali.rohar@gmail.com>
Cc: Len Brown <len.brown@intel.com>, linux-pm@vger.kernel.org, "Rafael J. Wysocki" <rjw@rjwysocki.net>, linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, dm-devel@redhat.com, Pavel Machek <pavel@ucw.cz>, Alasdair Kergon <agk@redhat.com>
List-Id: dm-devel.ids

On Fri, Jul 17 2015 at  1:13pm -0400,
Pali Roh=E1r <pali.rohar@gmail.com> wrote:

> On Friday 17 July 2015 17:30:45 Mike Snitzer wrote:
> > On Fri, Jul 17 2015 at 11:22am -0400,
> >=20
> > Mike Snitzer <snitzer@redhat.com> wrote:
> > > On Fri, Jul 17 2015 at 10:22am -0400,
> > >=20
> > > Pali Roh=E1r <pali.rohar@gmail.com> wrote:
> > > > On Friday 17 July 2015 10:04:39 Mike Snitzer wrote:
> > > > > On Sun, Jun 21 2015 at  7:20am -0400,
> > > > >=20
> > > > > Pali Roh=E1r <pali.rohar@gmail.com> wrote:
> > > > > > This patch exports function dm_suspend_md() which suspend
> > > > > > mapped device so other kernel drivers can use it and could
> > > > > > suspend mapped device when needed.
> > > > > >=20
> > > > > > Signed-off-by: Pali Roh=E1r <pali.rohar@gmail.com>
> > > > > > ---
> > > > > >=20
> > > > > >  drivers/md/dm.c |    6 ++++++
> > > > > >  drivers/md/dm.h |    5 +++++
> > > > > >  2 files changed, 11 insertions(+)
> > > > > >=20
> > > > > > diff --git a/drivers/md/dm.c b/drivers/md/dm.c
> > > > > > index 2caf492..03298ff 100644
> > > > > > --- a/drivers/md/dm.c
> > > > > > +++ b/drivers/md/dm.c
> > > > > >=20
> > > > > > @@ -3343,6 +3343,12 @@ out:
> > > > > >  	return r;
> > > > > > =20
> > > > > >  }
> > > > > >=20
> > > > > > +int dm_suspend_md(struct mapped_device *md)
> > > > > > +{
> > > > > > +	return dm_suspend(md, DM_SUSPEND_LOCKFS_FLAG);
> > > > > > +}
> > > > > > +EXPORT_SYMBOL_GPL(dm_suspend_md);
> > > > > > +
> > > > > >=20
> > > > > >  /*
> > > > > > =20
> > > > > >   * Internal suspend/resume works like userspace-driven
> > > > > >   suspend. It waits * until all bios finish and prevents
> > > > > >   issuing new bios to the target drivers.
> > > > >=20
> > > > > To do this properly you should be introducing a variant of
> > > > > dm_internal_suspend.  We currently have two variants:
> > > > > dm_internal_suspend_fast
> > > > > dm_internal_suspend_noflush
> > > > >=20
> > > > > The reason to use a dm_internal_suspend variant is this suspe=
nd
> > > > > was _not_ initiated by an upper level ioctl (from userspace).=
=20
> > > > > It was done internally from within the target.
> > > > >=20
> > > > > You're explicitly using DM_SUSPEND_LOCKFS_FLAG above.. meanin=
g
> > > > > you're interested in flushing all pending IO (in the FS
> > > > > layered on dm-crupt, if one exists).
> > > > >=20
> > > > > But see the comment in __dm_internal_suspend() about
> > > > > TASK_UNINTERRUPTIBLE. If you're OK with the dm-crypt initiate=
d
> > > > > suspend being TASK_UNINTERRUPTIBLE then you could just
> > > > > introduce:
> > > > >=20
> > > > > void dm_internal_suspend_uninterruptible_flush(struct
> > > > > mapped_device *md) {
> > > > >=20
> > > > >         mutex_lock(&md->suspend_lock);
> > > > >         __dm_internal_suspend(md, DM_SUSPEND_LOCKFS_FLAG);
> > > > >         mutex_unlock(&md->suspend_lock);
> > > > >=20
> > > > > }
> > > > > EXPORT_SYMBOL_GPL(dm_internal_suspend_uninterruptible_flush);
> > > > >=20
> > > > > Otherwise, there is much more extensive DM core changes neede=
d
> > > > > to __dm_internal_suspend() and .presuspend to properly suppor=
t
> > > > > TASK_INTERRUPTIBLE.
> > > >=20
> > > > Hi! I will look at dm_internal_suspend. Anyway use case for
> > > > suspend is from dm-crypt to do both operations: suspend + key
> > > > wipe. It means that without entering key again from userspace,
> > > > resume is not possible. So my question is: It is possible to do
> > > > internal suspend and then using resume from userspace via ioctl=
?
> > >=20
> > > Good question: no, userspace resume would block waiting for
> > > internal resume.
> > >=20
> > > Soooo... I'll have to look at your patch 3 to understand why
> > > dm-crypt is needing to initiate the suspend internally but then
> > > userspace is initiating the resume... this imbalance is
> > > concerning.
> >=20
> > Why not introduce a new message that allows you to wipe the key aft=
er
> > suspend?  Both initiated from userspace.
>=20
> There is already message for wiping key and it will success only if d=
m=20
> is suspended.
>=20
> But this patch series is fixing another problem: wipe key before=20
> suspend/hibernation action happend and to have it race free it must b=
e=20
> done after userspace is freezed!

Yes, I remember now.  So it isn't even userspace initiating the
suspend_and_wipe, it is the PM chain notifier code you're adding.

I'll think more about your use of dm_suspend()

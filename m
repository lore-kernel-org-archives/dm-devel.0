From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [PATCH v2 2/3] dm: Export function dm_suspend_md()
Date: Fri, 17 Jul 2015 11:22:53 -0400
Message-ID: <20150717152253.GA1021@redhat.com>
References: <1428254419-7334-1-git-send-email-pali.rohar@gmail.com>
 <1434885634-19895-1-git-send-email-pali.rohar@gmail.com>
 <1434885634-19895-3-git-send-email-pali.rohar@gmail.com>
 <20150717140438.GA29704@redhat.com>
 <20150717142251.GA12011@pali>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-pm-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20150717142251.GA12011@pali>
Sender: linux-pm-owner@vger.kernel.org
To: Pali =?iso-8859-1?Q?Roh=E1r?= <pali.rohar@gmail.com>
Cc: Alasdair Kergon <agk@redhat.com>, Neil Brown <neilb@suse.de>, "Rafael J. Wysocki" <rjw@rjwysocki.net>, Len Brown <len.brown@intel.com>, Pavel Machek <pavel@ucw.cz>, linux-raid@vger.kernel.org, dm-devel@redhat.com, linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org
List-Id: dm-devel.ids

On Fri, Jul 17 2015 at 10:22am -0400,
Pali Roh=E1r <pali.rohar@gmail.com> wrote:

> On Friday 17 July 2015 10:04:39 Mike Snitzer wrote:
> > On Sun, Jun 21 2015 at  7:20am -0400,
> > Pali Roh=E1r <pali.rohar@gmail.com> wrote:
> >=20
> > > This patch exports function dm_suspend_md() which suspend mapped =
device so other
> > > kernel drivers can use it and could suspend mapped device when ne=
eded.
> > >=20
> > > Signed-off-by: Pali Roh=E1r <pali.rohar@gmail.com>
> > > ---
> > >  drivers/md/dm.c |    6 ++++++
> > >  drivers/md/dm.h |    5 +++++
> > >  2 files changed, 11 insertions(+)
> > >=20
> > > diff --git a/drivers/md/dm.c b/drivers/md/dm.c
> > > index 2caf492..03298ff 100644
> > > --- a/drivers/md/dm.c
> > > +++ b/drivers/md/dm.c
> > > @@ -3343,6 +3343,12 @@ out:
> > >  	return r;
> > >  }
> > > =20
> > > +int dm_suspend_md(struct mapped_device *md)
> > > +{
> > > +	return dm_suspend(md, DM_SUSPEND_LOCKFS_FLAG);
> > > +}
> > > +EXPORT_SYMBOL_GPL(dm_suspend_md);
> > > +
> > >  /*
> > >   * Internal suspend/resume works like userspace-driven suspend. =
It waits
> > >   * until all bios finish and prevents issuing new bios to the ta=
rget drivers.
> >=20
> > To do this properly you should be introducing a variant of
> > dm_internal_suspend.  We currently have two variants:
> > dm_internal_suspend_fast
> > dm_internal_suspend_noflush
> >=20
> > The reason to use a dm_internal_suspend variant is this suspend was
> > _not_ initiated by an upper level ioctl (from userspace).  It was
> > done internally from within the target.
> >=20
> > You're explicitly using DM_SUSPEND_LOCKFS_FLAG above.. meaning you'=
re
> > interested in flushing all pending IO (in the FS layered on dm-crup=
t, if
> > one exists).
> >=20
> > But see the comment in __dm_internal_suspend() about TASK_UNINTERRU=
PTIBLE.
> > If you're OK with the dm-crypt initiated suspend being
> > TASK_UNINTERRUPTIBLE then you could just introduce:
> >=20
> > void dm_internal_suspend_uninterruptible_flush(struct mapped_device=
 *md)
> > {
> >         mutex_lock(&md->suspend_lock);
> >         __dm_internal_suspend(md, DM_SUSPEND_LOCKFS_FLAG);
> >         mutex_unlock(&md->suspend_lock);
> > }
> > EXPORT_SYMBOL_GPL(dm_internal_suspend_uninterruptible_flush);
> >=20
> > Otherwise, there is much more extensive DM core changes needed to
> > __dm_internal_suspend() and .presuspend to properly support
> > TASK_INTERRUPTIBLE.
>=20
> Hi! I will look at dm_internal_suspend. Anyway use case for suspend i=
s
> from dm-crypt to do both operations: suspend + key wipe. It means tha=
t
> without entering key again from userspace, resume is not possible. So=
 my
> question is: It is possible to do internal suspend and then using res=
ume
> from userspace via ioctl?

Good question: no, userspace resume would block waiting for internal
resume.

Soooo... I'll have to look at your patch 3 to understand why dm-crypt i=
s
needing to initiate the suspend internally but then userspace is
initiating the resume... this imbalance is concerning.

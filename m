From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: Unnecessary snapshot validation
Date: Thu, 30 Jul 2015 13:17:49 -0400
Message-ID: <20150730171749.GA8751@redhat.com>
References: <20150130234959.GQ23957@agk-dp.fab.redhat.com>
	<alpine.LRH.2.02.1506211212010.9520@file01.intranet.prod.int.rdu2.redhat.com>
	<CAEcBt+Xw8Sh7=BYhZSfQUm+9xitsgPpJZppr=MY2JZ0gzkMQ8w@mail.gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <CAEcBt+Xw8Sh7=BYhZSfQUm+9xitsgPpJZppr=MY2JZ0gzkMQ8w@mail.gmail.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Frederick Grose <fgrose@gmail.com>
Cc: device-mapper development <dm-devel@redhat.com>, Mikulas Patocka <mpatocka@redhat.com>, livecd@lists.fedoraproject.org
List-Id: dm-devel.ids

On Thu, Jul 30 2015 at 12:01pm -0400,
Frederick Grose <fgrose@gmail.com> wrote:

> On Sun, Jun 21, 2015 at 4:31 PM, Mikulas Patocka <mpatocka@redhat.com> wrote:
> >
> >
> > On Fri, 30 Jan 2015, Alasdair G Kergon wrote:
> >
> >> I've had a complaint tonight at FOSDEM that we invalidate old-style
> >> snapshots in a particular case where there is no need to!
> >>
> >> If you take a snapshot of an origin, then keep writing to the *snapshot*
> >> and fill it up we should just return errors on any further such writes
> >> *without* invalidating the snapshot - so reads can still be performed
> >> successfully.
> >>
> >> (check for -ENOSPC from prepare_exception in __find_pending_exception?)
> >>
> >> Alasdair
> >
> > Hi
> >
> > Here I'm sending a patch that keeps data when the snapshot fills up.
> >
> > The user can extend the overflowed snapshot, deactivate and activate it
> > again, run fsck (if journaling filesystem is not used) mount it and
> > recover the data.
> >
> > Mikulas
> >
> >
> >
> > From: Mikulas Patocka <mpatocka@redhat.com>
> >
> > dm snapshot: don't invalidate on-disk image on snapshot write overflow
> >
> > When the snapshot overflows because of a write to the origin, the on-disk
> > image has to be invalidated. However, when the snapshot overflows because
> > of a write to the snapshot, the on-disk image doesn't have to be
> > invalidated. This patch changes the behavior, so that the on-disk image is
> > not invalidated in this case.
> >
> > When the snapshot overflows, the variable snapshot_overflowed is set. All
> > writes to the snapshot are disallowed to minimize filesystem corruption -
> > this condition is cleared when the snapshot is deactivated and activated.
> >
> > Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
> >
> > ---
> >  drivers/md/dm-snap.c |   18 ++++++++++++++----
> >  1 file changed, 14 insertions(+), 4 deletions(-)
> >
> > Index: linux-4.1-rc8/drivers/md/dm-snap.c
> > ===================================================================
> > --- linux-4.1-rc8.orig/drivers/md/dm-snap.c     2015-06-19 20:57:04.000000000 +0200
> > +++ linux-4.1-rc8/drivers/md/dm-snap.c  2015-06-21 17:11:10.000000000 +0200
> > @@ -63,6 +63,13 @@ struct dm_snapshot {
> >          */
> >         int valid;
> >
> > +       /*
> > +        * The snasphot overflowed because of write to the snapshot device.
> > +        * We don't have to invalidate the snapshot in this case, but we need
> > +        * to prevent further writes.
> > +        */
> > +       int snapshot_overflowed;
> > +
> >         /* Origin writes don't trigger exceptions until this is set */
> >         int active;
> >
> > @@ -1152,6 +1159,7 @@ static int snapshot_ctr(struct dm_target
> >
> >         s->ti = ti;
> >         s->valid = 1;
> > +       s->snapshot_overflowed = 0;
> >         s->active = 0;
> >         atomic_set(&s->pending_exceptions_count, 0);
> >         s->exception_start_sequence = 0;
> > @@ -1301,6 +1309,7 @@ static void __handover_exceptions(struct
> >
> >         snap_dest->ti->max_io_len = snap_dest->store->chunk_size;
> >         snap_dest->valid = snap_src->valid;
> > +       snap_dest->snapshot_overflowed = snap_src->snapshot_overflowed;
> >
> >         /*
> >          * Set source invalid to ensure it receives no further I/O.
> > @@ -1692,7 +1701,7 @@ static int snapshot_map(struct dm_target
> >          * to copy an exception */
> >         down_write(&s->lock);
> >
> > -       if (!s->valid) {
> > +       if (!s->valid || (unlikely(s->snapshot_overflowed) && bio_rw(bio) == WRITE)) {
> >                 r = -EIO;
> >                 goto out_unlock;
> >         }
> > @@ -1716,7 +1725,7 @@ static int snapshot_map(struct dm_target
> >                         pe = alloc_pending_exception(s);
> >                         down_write(&s->lock);
> >
> > -                       if (!s->valid) {
> > +                       if (!s->valid || s->snapshot_overflowed) {
> >                                 free_pending_exception(pe);
> >                                 r = -EIO;
> >                                 goto out_unlock;
> > @@ -1731,7 +1740,8 @@ static int snapshot_map(struct dm_target
> >
> >                         pe = __find_pending_exception(s, pe, chunk);
> >                         if (!pe) {
> > -                               __invalidate_snapshot(s, -ENOMEM);
> > +                               s->snapshot_overflowed = 1;
> > +                               DMERR("Invalidating snapshot: Unable to allocate exception.");
> >                                 r = -EIO;
> >                                 goto out_unlock;
> >                         }

This DMERR saying "Invalidating snapshot" isn't really accurate.

> > @@ -1987,7 +1997,7 @@ static void snapshot_status(struct dm_ta
> >
> >                 down_write(&snap->lock);
> >
> > -               if (!snap->valid)
> > +               if (!snap->valid || snap->snapshot_overflowed)
> >                         DMEMIT("Invalid");
> >                 else if (snap->merge_failed)
> >                         DMEMIT("Merge failed");
> >
> > --
> > dm-devel mailing list
> > dm-devel@redhat.com
> > https://www.redhat.com/mailman/listinfo/dm-devel
> 
> If I read this correctly, this change will allow Live USB devices
> (having read-only origins) to overflow their overlay file and not
> crash with I/O errors and fail to boot because of the invalid overlay.
> 
> Is this correct?

Any writes (to the snapshot) will still get an IO error.  Reads will not.

> If so, when would this released, and could it be back ported to F21 &
> F22 updates?

Needs further review.  This patch was sent right when the 4.2 merge
window opened so it was already too late for 4.2 consideration.
Earliest this will land is in Linux 4.3

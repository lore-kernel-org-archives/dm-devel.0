From: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: Re: device mapper not reporting no-barrier-support?
Date: Tue, 26 Feb 2008 23:25:56 +0100
Message-ID: <20080226222556.GU6704@kernel.dk>
References: <20080225132615.GA21990@1und1.de>
	<20080225152050.94788622.akpm@linux-foundation.org>
	<20080226013656.GE1788@agk.fab.redhat.com>
	<20080226161741.GN6704@kernel.dk> <20080226193349.GQ13026@1und1.de>
	<20080226194122.GQ6704@kernel.dk> <20080226202030.GR13026@1und1.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20080226202030.GR13026@1und1.de>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Anders Henke <anders.henke@1und1.de>, Andrew Morton <akpm@linux-foundation.org>, device-mapper development <dm-devel@redhat.com>, linux-kernel@vger.kernel.org
List-Id: dm-devel.ids

On Tue, Feb 26 2008, Anders Henke wrote:
> On Tue, Feb 26 2008 schrieb Jens Axboe:
> > On Tue, Feb 26 2008, Anders Henke wrote:
> > > On Tue, Feb 26 2008 Jens Axboe wrote:
> > > > On Tue, Feb 26 2008, Alasdair G Kergon wrote:
> > > > > On Mon, Feb 25, 2008 at 03:20:50PM -0800, Andrew Morton wrote:
> > > > > > On Mon, 25 Feb 2008 14:26:15 +0100 Anders Henke <anders.henke@1und1.de> wrote:
> > > > > > > I'm currently stuck between Kernel LVM and DRBD, as I'm using Kernel
> > > > > > > 2.6.24.2 with DRBD 8.2.5 on top of an LVM2 device (LV).
> > > > > > > -LVM2/device mapper doesn't support write barriers
> > > > > 
> > > > > That's right.
> > > > > 
> > > > > > > -DRBD uses blkdev_issue_flush() to flush its metadata to disk.
> > > > > 
> > > > > Which won't work if device-mapper is underneath.
> > > > > 
> > > > > > >  On a no-barrier-device, DRBD should receive EOPNOTSUPP, but
> > > > > > >  it really does receive an EIO. Promptly, DRBD gives the
> > > > > > >  error message "drbd0: local disk flush failed with status -5".
> > > > > > > I've posted a lengty summary of my findings to
> > > > > > > http://lists.linbit.com/pipermail/drbd-user/2008-February/008665.html
> > > > > > > ... that DRBD does catch the EOPNOTSUPP for blkdev_issue_flush and
> > > > > > > BIO_RW_BARRIER, but the lvm implementation of blkdev_issue_flush in
> > > > > > > 2.6.24.2 aparently does return EIO for blkdev_issue_flush.
> > > > > > I'd say it's a DM bug.
> > > > > 
> > > > > The dm code is unchanged, but look at the limited endio handling in
> > > > > ll_rw_blk.c:
> > > > > 
> > > > > static void bio_end_empty_barrier(struct bio *bio, int err)
> > > > > {
> > > > >         if (err)
> > > > >                 clear_bit(BIO_UPTODATE, &bio->bi_flags);
> > > > > 
> > > > >         complete(bio->bi_private);
> > > > > }
> > > > > 
> > > > > int blkdev_issue_flush(struct block_device *bdev, sector_t *error_sector)
> > > > > {
> > > > > ...
> > > > >         wait_for_completion(&wait);
> > > > >         if (error_sector)
> > > > >                 *error_sector = bio->bi_sector;
> > > > >         ret = 0;
> > > > >         if (!bio_flagged(bio, BIO_UPTODATE))
> > > > >                 ret = -EIO;
> > > > 
> > > > You are right, the return value got broken there. Does this make it
> > > > return -EOPNOTSUPP properly for you?
> > > 
> > > 
> > > No, it doesn't.
> > > 
> > > 
> > > 
> > > I've applied your patch manually, as 2.6.24.2. doesn't have a "blk-barrier.c":
> > > 
> > > ---cut
> > > --- linux-2.6.24.2/block/ll_rw_blk.c.prepatch   2008-02-11
> > > 06:51:11.000000000 +0100
> > > +++ linux-2.6.24.2/block/ll_rw_blk.c    2008-02-26 20:02:28.514641620
> > > +0100
> > > @@ -2667,8 +2667,11 @@
> > >  
> > >  static void bio_end_empty_barrier(struct bio *bio, int err)
> > >  {
> > > -       if (err)
> > > +       if (err) {
> > > +               if (err == -EOPNOTSUPP)
> > > +                       set_bit(BIO_EOPNOTSUPP, &bio->bi_flags);
> > >                 clear_bit(BIO_UPTODATE, &bio->bi_flags);
> > > +       }
> > >  
> > >         complete(bio->bi_private);
> > >  }
> > > ---cut
> > > 
> > > ... and the resulting kernel shows exactly the same behaviour than before:
> > 
> > Not surprising, as you missed half of the patch:
> 
> Ouch. Thank you for pointing this out.
> 
> I've been spending too much time of the day with things who have a negative 
> impact on my concentration and I shouldn't manually patch kernels at
> this time of the day.
> 
> Yes, it's useless to set a bit, but never check it (like in my version of
> your patch).
> 
> After adding the second part of your patch, the resulting kernel works as
> intended:
> 
> [  234.946192] drbd0: conn( WFSyncUUID -> SyncTarget ) 
> [  234.956176] drbd0: Began resync as SyncTarget (will sync 19542404 KB
> [4885601
>  bits set]).
> [  234.972567] drbd0: Writing meta data super block now.
> [  235.018203] drbd0: local disk flush failed with status -95
> 
> DRBD sees the EOPNOTSUPP, logs this message only once and doesn't try
> any further barrier requests (as intended).

OK good, that's what I expected :-)

I'll queue the patch for 2.6.25, the 2.6.24 should go to stable. Send me
a properly formatted patch and I'll make sure it goes that way.

Thanks for testing!

-- 
Jens Axboe

From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [PATCH 7/8] dm: improve noclone_endio() to support
 multipath target
Date: Wed, 20 Feb 2019 10:14:21 -0500
Message-ID: <20190220151421.GA24047@redhat.com>
References: <20190219221721.29830-1-snitzer@redhat.com>
	<20190219221721.29830-8-snitzer@redhat.com>
	<alpine.LRH.2.02.1902201007010.25108@file01.intranet.prod.int.rdu2.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <alpine.LRH.2.02.1902201007010.25108@file01.intranet.prod.int.rdu2.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

On Wed, Feb 20 2019 at 10:08am -0500,
Mikulas Patocka <mpatocka@redhat.com> wrote:

> 
> 
> On Tue, 19 Feb 2019, Mike Snitzer wrote:
> 
> > noclone_endio() must call the target's ->endio method if it exists.
> > Also must handle the various DM_ENDIO_* returns that are possible.
> > 
> > Factor out dm_bio_pushback_needed() for both dec_pending() and
> > noclone_endio() to use when handling BLK_STS_DM_REQUEUE.
> > 
> > Lastly, there is no need to conditionally set md->immutable_target in
> > __bind().  If the device only uses a single immutable target then it
> > should always be reflected in md->immutable_target.  This is important
> > because noclone_endio() benefits from this to get access to the
> > multipath dm_target without needing to add another member to the
> > 'dm_noclone' structure.
> > 
> > Signed-off-by: Mike Snitzer <snitzer@redhat.com>
> > ---
> >  drivers/md/dm.c | 77 ++++++++++++++++++++++++++++++++++++++++-----------------
> >  1 file changed, 55 insertions(+), 22 deletions(-)
> > 
> > diff --git a/drivers/md/dm.c b/drivers/md/dm.c
> > index 8ff0ced278d7..2299f946c175 100644
> > --- a/drivers/md/dm.c
> > +++ b/drivers/md/dm.c
> > @@ -897,6 +897,28 @@ static int __noflush_suspending(struct mapped_device *md)
> >  	return test_bit(DMF_NOFLUSH_SUSPENDING, &md->flags);
> >  }
> >  
> > +static bool dm_bio_pushback_needed(struct mapped_device *md,
> > +				   struct bio *bio, blk_status_t *error)
> > +{
> > +	unsigned long flags;
> > +
> > +	/*
> > +	 * Target requested pushing back the I/O.
> > +	 */
> > +	if (__noflush_suspending(md)) {
> > +		spin_lock_irqsave(&md->deferred_lock, flags);
> > +		// FIXME: using bio_list_add_head() creates LIFO
> > +		bio_list_add_head(&md->deferred, bio);
> > +		spin_unlock_irqrestore(&md->deferred_lock, flags);
> > +		return true;
> > +	} else {
> > +		/* noflush suspend was interrupted. */
> > +		*error = BLK_STS_IOERR;
> > +	}
> > +
> > +	return false;
> > +}
> > +
> >  /*
> >   * Decrements the number of outstanding ios that a bio has been
> >   * cloned into, completing the original io if necc.
> > @@ -917,19 +939,8 @@ static void dec_pending(struct dm_io *io, blk_status_t error)
> >  	}
> >  
> >  	if (atomic_dec_and_test(&io->io_count)) {
> > -		if (io->status == BLK_STS_DM_REQUEUE) {
> > -			/*
> > -			 * Target requested pushing back the I/O.
> > -			 */
> > -			spin_lock_irqsave(&md->deferred_lock, flags);
> > -			if (__noflush_suspending(md))
> > -				/* NOTE early return due to BLK_STS_DM_REQUEUE below */
> > -				bio_list_add_head(&md->deferred, io->orig_bio);
> > -			else
> > -				/* noflush suspend was interrupted. */
> > -				io->status = BLK_STS_IOERR;
> > -			spin_unlock_irqrestore(&md->deferred_lock, flags);
> > -		}
> > +		if (unlikely(io->status == BLK_STS_DM_REQUEUE))
> > +			(void) dm_bio_pushback_needed(md, bio, &io->status);
> 
> This triggers compiler warning because the variable bio is uninitialized 
> here.

Right, I fixed it up in latest git, please see latest 'dm-5.1' branch:
https://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm.git/log/?h=dm-5.1

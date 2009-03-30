From: Mikulas Patocka <mpatocka@redhat.com>
Subject: Re: [PATCH 14/14] barriers
Date: Mon, 30 Mar 2009 10:02:06 -0400 (EDT)
Message-ID: <Pine.LNX.4.64.0903301001220.1408@hs20-bc2-1.build.redhat.com>
References: <Pine.LNX.4.64.0902231422490.23293@hs20-bc2-1.build.redhat.com>
	<Pine.LNX.4.64.0903270209380.17063@hs20-bc2-1.build.redhat.com>
	<49D06851.9090904@ct.jp.nec.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <49D06851.9090904@ct.jp.nec.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Cc: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

Hi

You must apply the whole series of patches from patch 1 (that I sent long 
time before). This patch is an update to the series.

Mikulas

> Hi Mikulas,
> 
> This patch doesn't apply to 2.6.29.
> Probably you are using a pretty older kernel?
> 
> Thanks,
> Kiyoshi Ueda
> 
> 
> On 2009/03/27 15:11 +0900, Mikulas Patocka wrote:
> > Barrier support.
> > 
> > Barriers are submitted to a worker thread that issues them in-order.
> > 
> > __split_and_process_bio function is modified that when it sees a barrier
> > request, it waits for all pending IO before the request, then submits
> > the barrier and waits for it (we must wait, otherwise it could be
> > intermixed with following requests).
> > 
> > Errors from the barrier request are recorded in per-device barrier_error
> > variable. There may be only one barrier request in progress, so using
> > a per-device variable is correct.
> > 
> > The barrier request is converted to non-barrier request when sending it
> > to the underlying device.
> > 
> > This patch guarantees correct barrier behavior if the underlying device
> > doesn't perform write-back caching. The same requirement existed before
> > barriers were supported in dm.
> > 
> > Bottom layer barrier support (sending barriers by target drivers) and
> > handling devices with write-back caches will be done in further patches.
> > 
> > Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
> > 
> > ---
> >  drivers/md/dm.c |   79 +++++++++++++++++++++++++++++++++++++++++++-------------
> >  1 file changed, 61 insertions(+), 18 deletions(-)
> > 
> > Index: linux-2.6.29-rc8-devel/drivers/md/dm.c
> > ===================================================================
> > --- linux-2.6.29-rc8-devel.orig/drivers/md/dm.c	2009-03-27 06:51:29.000000000 +0100
> > +++ linux-2.6.29-rc8-devel/drivers/md/dm.c	2009-03-27 06:51:33.000000000 +0100
> > @@ -125,6 +125,11 @@ struct mapped_device {
> >  	spinlock_t deferred_lock;
> >  
> >  	/*
> > +	 * An error from the barrier request currently being processed.
> > +	 */
> > +	int barrier_error;
> > +
> > +	/*
> >  	 * Processing queue (flush/barriers)
> >  	 */
> >  	struct workqueue_struct *wq;
> > @@ -425,6 +430,10 @@ static void end_io_acct(struct dm_io *io
> >  	part_stat_add(cpu, &dm_disk(md)->part0, ticks[rw], duration);
> >  	part_stat_unlock();
> >  
> > +	/*
> > +	 * after this is decremented, the bio must not be touched if it is
> > +	 * barrier bio
> > +	 */
> >  	dm_disk(md)->part0.in_flight = pending =
> >  		atomic_dec_return(&md->pending);
> >  
> > @@ -525,19 +534,29 @@ static void dec_pending(struct dm_io *io
> >  			 */
> >  			spin_lock_irqsave(&io->md->deferred_lock, flags);
> >  			if (__noflush_suspending(io->md))
> > -				bio_list_add(&io->md->deferred, io->bio);
> > +				bio_list_add_head(&io->md->deferred, io->bio);
> >  			else
> >  				/* noflush suspend was interrupted. */
> >  				io->error = -EIO;
> >  			spin_unlock_irqrestore(&io->md->deferred_lock, flags);
> >  		}
> >  
> > -		end_io_acct(io);
> > +		if (bio_barrier(io->bio)) {
> > +			/*
> > +			 * There could be just one barrier request, so we use
> > +			 * per-device variable for error reporting is OK.
> > +			 * Note that you can't touch the bio after end_io_acct
> > +			 */
> > +			io->md->barrier_error = io->error;
> > +			end_io_acct(io);
> > +		} else {
> > +			end_io_acct(io);
> >  
> > -		if (io->error != DM_ENDIO_REQUEUE) {
> > -			trace_block_bio_complete(io->md->queue, io->bio);
> > +			if (io->error != DM_ENDIO_REQUEUE) {
> > +				trace_block_bio_complete(io->md->queue, io->bio);
> >  
> > -			bio_endio(io->bio, io->error);
> > +				bio_endio(io->bio, io->error);
> > +			}
> >  		}
> >  
> >  		free_io(io->md, io);
> > @@ -682,7 +701,7 @@ static struct bio *split_bvec(struct bio
> >  
> >  	clone->bi_sector = sector;
> >  	clone->bi_bdev = bio->bi_bdev;
> > -	clone->bi_rw = bio->bi_rw;
> > +	clone->bi_rw = bio->bi_rw & ~(1 << BIO_RW_BARRIER);
> >  	clone->bi_vcnt = 1;
> >  	clone->bi_size = to_bytes(len);
> >  	clone->bi_io_vec->bv_offset = offset;
> > @@ -703,6 +722,7 @@ static struct bio *clone_bio(struct bio 
> >  
> >  	clone = bio_alloc_bioset(GFP_NOIO, bio->bi_max_vecs, bs);
> >  	__bio_clone(clone, bio);
> > +	clone->bi_rw &= ~(1 << BIO_RW_BARRIER);
> >  	clone->bi_destructor = dm_bio_destructor;
> >  	clone->bi_sector = sector;
> >  	clone->bi_idx = idx;
> > @@ -823,7 +843,10 @@ static void __split_and_process_bio(stru
> >  
> >  	ci.map = dm_get_table(md);
> >  	if (unlikely(!ci.map)) {
> > -		bio_io_error(bio);
> > +		if (!bio_barrier(bio))
> > +			bio_io_error(bio);
> > +		else
> > +			md->barrier_error = -EIO;
> >  		return;
> >  	}
> >  
> > @@ -907,15 +930,6 @@ static int dm_request(struct request_que
> >  	struct mapped_device *md = q->queuedata;
> >  	int cpu;
> >  
> > -	/*
> > -	 * There is no use in forwarding any barrier request since we can't
> > -	 * guarantee it is (or can be) handled by the targets correctly.
> > -	 */
> > -	if (unlikely(bio_barrier(bio))) {
> > -		bio_endio(bio, -EOPNOTSUPP);
> > -		return 0;
> > -	}
> > -
> >  	down_read(&md->io_lock);
> >  
> >  	cpu = part_stat_lock();
> > @@ -927,7 +941,8 @@ static int dm_request(struct request_que
> >  	 * If we're suspended or the thread is processing barriers
> >  	 * we have to queue this io for later.
> >  	 */
> > -	if (unlikely(test_bit(DMF_QUEUE_IO_FOR_THREAD, &md->flags))) {
> > +	if (unlikely(test_bit(DMF_QUEUE_IO_FOR_THREAD, &md->flags)) ||
> > +	    unlikely(bio_barrier(bio))) {
> >  		up_read(&md->io_lock);
> >  
> >  		if (unlikely(test_bit(DMF_BLOCK_FOR_SUSPEND, &md->flags)) &&
> > @@ -1393,6 +1408,12 @@ static int dm_wait_for_completion(struct
> >  	return r;
> >  }
> >  
> > +static int dm_flush(struct mapped_device *md)
> > +{
> > +	dm_wait_for_completion(md, TASK_UNINTERRUPTIBLE);
> > +	return 0;
> > +}
> > +
> >  /*
> >   * Process the deferred bios
> >   */
> > @@ -1415,8 +1436,30 @@ static void dm_wq_work(struct work_struc
> >  			break;
> >  		}
> >  
> > -		__split_and_process_bio(md, c);
> > +		if (!bio_barrier(c))
> > +			__split_and_process_bio(md, c);
> > +		else {
> > +			int error = dm_flush(md);
> > +			if (unlikely(error)) {
> > +				bio_endio(c, error);
> > +				goto next_bio;
> > +			}
> > +			if (bio_empty_barrier(c)) {
> > +				bio_endio(c, 0);
> > +				goto next_bio;
> > +			}
> > +
> > +			__split_and_process_bio(md, c);
> > +
> > +			error = dm_flush(md);
> > +			if (!error && md->barrier_error)
> > +				error = md->barrier_error;
> > +
> > +			if (md->barrier_error != DM_ENDIO_REQUEUE)
> > +				bio_endio(c, error);
> > +		}
> >  
> > +next_bio:
> >  		down_write(&md->io_lock);
> >  	}
> >  }
> > 
> > --
> > dm-devel mailing list
> > dm-devel@redhat.com
> > https://www.redhat.com/mailman/listinfo/dm-devel
> 

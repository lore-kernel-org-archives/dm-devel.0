From: Ming Lei <tom.leiming@gmail.com>
Subject: Re: [PATCH v3] block: trace completion of all bios.
Date: Fri, 24 Mar 2017 14:47:41 +0800
Message-ID: <CACVXFVNC=-_f1jYo5bYw7X6TT8-g7UThw3zzzfrMaKVarnJvSQ@mail.gmail.com>
References: <877f3iave6.fsf@notabene.neil.brown.name> <20170322125149.GA29606@infradead.org>
 <87shm4a4lt.fsf@notabene.neil.brown.name> <20170323104331.GA16903@ming.t460p> <87fui3a65o.fsf@notabene.neil.brown.name>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <87fui3a65o.fsf@notabene.neil.brown.name>
Sender: linux-block-owner@vger.kernel.org
To: NeilBrown <neilb@suse.com>
Cc: Christoph Hellwig <hch@infradead.org>, Jens Axboe <axboe@kernel.dk>, linux-block <linux-block@vger.kernel.org>, "open list:SOFTWARE RAID (Multiple Disks) SUPPORT" <linux-raid@vger.kernel.org>, "open list:DEVICE-MAPPER (LVM)" <dm-devel@redhat.com>, Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@redhat.com>, Shaohua Li <shli@kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, "Martin K . Petersen" <martin.petersen@oracle.com>
List-Id: dm-devel.ids

On Fri, Mar 24, 2017 at 8:07 AM, NeilBrown <neilb@suse.com> wrote:
>
> Currently only dm and md/raid5 bios trigger
> trace_block_bio_complete().  Now that we have bio_chain() and
> bio_inc_remaining(), it is not possible, in general, for a driver to
> know when the bio is really complete.  Only bio_endio() knows that.
>
> So move the trace_block_bio_complete() call to bio_endio().
>
> Now trace_block_bio_complete() pairs with trace_block_bio_queue().
> Any bio for which a 'queue' event is traced, will subsequently
> generate a 'complete' event.
>
> There are a few cases where completion tracing is not wanted.
> 1/ If blk_update_request() has already generated a completion
>    trace event at the 'request' level, there is no point generating
>    one at the bio level too.  In this case the bi_sector and bi_size
>    will have changed, so the bio level event would be wrong
>
> 2/ If the bio hasn't actually been queued yet, but is being aborted
>    early, then a trace event could be confusing.  Some filesystems
>    call bio_endio() but do not want tracing.
>
> 3/ The bio_integrity code interposes itself by replacing bi_end_io,
>    then restoring it and calling bio_endio() again.  This would produce
>    two identical trace events if left like that.
>
> To handle these, we introduce a flag BIO_TRACE_COMPLETION and only
> produce the trace event when this is set.
> We address point 1 above by clearing the flag in blk_update_request().
> We address point 2 above by only setting the flag when
> generic_make_request() is called.
> We address point 3 above by clearing the flag after generating a
> completion event.
>
> When bio_split() is used on a bio, particularly in blk_queue_split(),
> there is an extra complication.  A new bio is split off the front, and
> may be handle directly without going through generic_make_request().
> The old bio, which has been advanced, is passed to
> generic_make_request(), so it will trigger a trace event a second
> time.
> Probably the best result when a split happens is to see a single
> 'queue' event for the whole bio, then multiple 'complete' events - one
> for each component.  To achieve this was can:
> - copy the BIO_TRACE_COMPLETION flag to the new bio in bio_split()
> - avoid generating a 'queue' event if BIO_TRACE_COMPLETION is already set.
> This way, the split-off bio won't create a queue event, the original
> won't either even if it re-submitted to generic_make_request(),
> but both will produce completion events, each for their own range.
>
> So if generic_make_request() is called (which generates a QUEUED
> event), then bi_endio() will create a single COMPLETE event for each
> range that the bio is split into, unless the driver has explicitly
> requested it not to.
>
> Signed-off-by: NeilBrown <neilb@suse.com>
> ---
>  block/bio.c               | 13 +++++++++++++
>  block/blk-core.c          | 10 +++++++++-
>  drivers/md/dm.c           |  1 -
>  drivers/md/raid5.c        |  8 --------
>  include/linux/blk_types.h |  4 +++-
>  5 files changed, 25 insertions(+), 11 deletions(-)
>
> diff --git a/block/bio.c b/block/bio.c
> index 5eec5e08417f..c1272986133e 100644
> --- a/block/bio.c
> +++ b/block/bio.c
> @@ -1818,6 +1818,11 @@ static inline bool bio_remaining_done(struct bio *bio)
>   *   bio_endio() will end I/O on the whole bio. bio_endio() is the preferred
>   *   way to end I/O on a bio. No one should call bi_end_io() directly on a
>   *   bio unless they own it and thus know that it has an end_io function.
> + *
> + *   bio_endio() can be called several times on a bio that has been chained
> + *   using bio_chain().  The ->bi_end_io() function will only be call the
> + *   last time.  At this point the BLK_TA_COMPLETE tracing event will be
> + *   generated if BIO_TRACE_COMPLETION is set.
>   **/
>  void bio_endio(struct bio *bio)
>  {
> @@ -1838,6 +1843,11 @@ void bio_endio(struct bio *bio)
>                 goto again;
>         }
>
> +       if (bio->bi_bdev && bio_flagged(bio, BIO_TRACE_COMPLETION)) {
> +               trace_block_bio_complete(bdev_get_queue(bio->bi_bdev),
> +                                        bio, bio->bi_error);
> +               bio_clear_flag(bio, BIO_TRACE_COMPLETION);
> +       }
>         if (bio->bi_end_io)
>                 bio->bi_end_io(bio);
>  }
> @@ -1876,6 +1886,9 @@ struct bio *bio_split(struct bio *bio, int sectors,
>
>         bio_advance(bio, split->bi_iter.bi_size);
>
> +       if (bio_flagged(bio, BIO_TRACE_COMPLETION))
> +               bio_set_flag(bio, BIO_TRACE_COMPLETION);
> +
>         return split;
>  }
>  EXPORT_SYMBOL(bio_split);
> diff --git a/block/blk-core.c b/block/blk-core.c
> index 0eeb99ef654f..b34b5b1b1bbf 100644
> --- a/block/blk-core.c
> +++ b/block/blk-core.c
> @@ -1936,7 +1936,13 @@ generic_make_request_checks(struct bio *bio)
>         if (!blkcg_bio_issue_check(q, bio))
>                 return false;
>
> -       trace_block_bio_queue(q, bio);
> +       if (!bio_flagged(bio, BIO_TRACE_COMPLETION)) {
> +               trace_block_bio_queue(q, bio);
> +               /* Now that enqueuing has been traced, we need to trace
> +                * completion as well.
> +                */
> +               bio_set_flag(bio, BIO_TRACE_COMPLETION);
> +       }
>         return true;
>
>  not_supported:
> @@ -2595,6 +2601,8 @@ bool blk_update_request(struct request *req, int error, unsigned int nr_bytes)
>                 if (bio_bytes == bio->bi_iter.bi_size)
>                         req->bio = bio->bi_next;
>
> +               /* Completion has already been traced */
> +               bio_clear_flag(bio, BIO_TRACE_COMPLETION);
>                 req_bio_endio(req, bio, bio_bytes, error);
>
>                 total_bytes += bio_bytes;
> diff --git a/drivers/md/dm.c b/drivers/md/dm.c
> index f4ffd1eb8f44..f5f09ace690a 100644
> --- a/drivers/md/dm.c
> +++ b/drivers/md/dm.c
> @@ -810,7 +810,6 @@ static void dec_pending(struct dm_io *io, int error)
>                         queue_io(md, bio);
>                 } else {
>                         /* done with normal IO or empty flush */
> -                       trace_block_bio_complete(md->queue, bio, io_error);
>                         bio->bi_error = io_error;
>                         bio_endio(bio);
>                 }
> diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
> index 9a3b7da34137..f684cb566721 100644
> --- a/drivers/md/raid5.c
> +++ b/drivers/md/raid5.c
> @@ -5141,8 +5141,6 @@ static void raid5_align_endio(struct bio *bi)
>         rdev_dec_pending(rdev, conf->mddev);
>
>         if (!error) {
> -               trace_block_bio_complete(bdev_get_queue(raid_bi->bi_bdev),
> -                                        raid_bi, 0);
>                 bio_endio(raid_bi);
>                 if (atomic_dec_and_test(&conf->active_aligned_reads))
>                         wake_up(&conf->wait_for_quiescent);
> @@ -5727,10 +5725,6 @@ static void raid5_make_request(struct mddev *mddev, struct bio * bi)
>                 md_write_end(mddev);
>         remaining = raid5_dec_bi_active_stripes(bi);
>         if (remaining == 0) {
> -
> -
> -               trace_block_bio_complete(bdev_get_queue(bi->bi_bdev),
> -                                        bi, 0);
>                 bio_endio(bi);
>         }
>  }
> @@ -6138,8 +6132,6 @@ static int  retry_aligned_read(struct r5conf *conf, struct bio *raid_bio)
>         }
>         remaining = raid5_dec_bi_active_stripes(raid_bio);
>         if (remaining == 0) {
> -               trace_block_bio_complete(bdev_get_queue(raid_bio->bi_bdev),
> -                                        raid_bio, 0);
>                 bio_endio(raid_bio);
>         }
>         if (atomic_dec_and_test(&conf->active_aligned_reads))
> diff --git a/include/linux/blk_types.h b/include/linux/blk_types.h
> index d703acb55d0f..db7a57ee0e58 100644
> --- a/include/linux/blk_types.h
> +++ b/include/linux/blk_types.h
> @@ -29,7 +29,7 @@ struct bio {
>                                                  * top bits REQ_OP. Use
>                                                  * accessors.
>                                                  */
> -       unsigned short          bi_flags;       /* status, command, etc */
> +       unsigned short          bi_flags;       /* status, etc */
>         unsigned short          bi_ioprio;
>
>         struct bvec_iter        bi_iter;
> @@ -102,6 +102,8 @@ struct bio {
>  #define BIO_REFFED     8       /* bio has elevated ->bi_cnt */
>  #define BIO_THROTTLED  9       /* This bio has already been subjected to
>                                  * throttling rules. Don't do it again. */
> +#define BIO_TRACE_COMPLETION 10        /* bio_endio() should trace the final completion
> +                                * of this bio. */

This may not be a good idea, since the flag space is quite small(12).

Thanks,
Ming

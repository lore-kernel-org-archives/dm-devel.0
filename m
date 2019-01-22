From: Ming Lei <ming.lei@redhat.com>
Subject: Re: [PATCH 3/4] dm: fix missing bio_split() pattern code
 in __split_and_process_bio()
Date: Tue, 22 Jan 2019 10:46:41 +0800
Message-ID: <20190122024640.GA4287@ming.t460p>
References: <20190119180506.1300-1-snitzer@redhat.com>
	<20190119180506.1300-4-snitzer@redhat.com>
	<20190121032153.GA24610@ming.t460p>
	<20190121160204.GA32117@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20190121160204.GA32117@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Mike Snitzer <snitzer@redhat.com>
Cc: axboe@kernel.dk, linux-block@vger.kernel.org, dm-devel@redhat.com, NeilBrown <neilb@suse.com>
List-Id: dm-devel.ids

On Mon, Jan 21, 2019 at 11:02:04AM -0500, Mike Snitzer wrote:
> On Sun, Jan 20 2019 at 10:21P -0500,
> Ming Lei <ming.lei@redhat.com> wrote:
> 
> > On Sat, Jan 19, 2019 at 01:05:05PM -0500, Mike Snitzer wrote:
> > > Use the same BIO_QUEUE_ENTERED pattern that was established by commit
> > > cd4a4ae4683dc ("block: don't use blocking queue entered for recursive
> > > bio submits") by setting BIO_QUEUE_ENTERED after bio_split() and before
> > > recursing via generic_make_request().
> > > 
> > > Also add trace_block_split() because it provides useful context about
> > > bio splits in blktrace.
> > > 
> > > Depends-on: cd4a4ae4683dc ("block: don't use blocking queue entered for recursive bio submits")
> > > Fixes: 18a25da84354 ("dm: ensure bio submission follows a depth-first tree walk")
> > > Cc: stable@vger.kernel.org # 4.16+
> > > Signed-off-by: Mike Snitzer <snitzer@redhat.com>
> > > ---
> > >  drivers/md/dm.c | 2 ++
> > >  1 file changed, 2 insertions(+)
> > > 
> > > diff --git a/drivers/md/dm.c b/drivers/md/dm.c
> > > index fbadda68e23b..6e29c2d99b99 100644
> > > --- a/drivers/md/dm.c
> > > +++ b/drivers/md/dm.c
> > > @@ -1654,7 +1654,9 @@ static blk_qc_t __split_and_process_bio(struct mapped_device *md,
> > >  						   sectors[op_stat_group(bio_op(bio))], ci.sector_count);
> > >  				part_stat_unlock();
> > >  
> > > +				bio_set_flag(bio, BIO_QUEUE_ENTERED);
> > >  				bio_chain(b, bio);
> > > +				trace_block_split(md->queue, b, bio->bi_iter.bi_sector);
> > >  				ret = generic_make_request(bio);
> > >  				break;
> > >  			}
> > 
> > In theory, BIO_QUEUE_ENTERED is only required when __split_and_process_bio() is
> > called from generic_make_request(). However, it may be called from dm_wq_work(),
> > this way might cause trouble on operation to q->q_usage_counter.
> 
> Good point, I've tweaked this patch to clear BIO_QUEUE_ENTERED in
> dm_make_request().
> 
> And to Neil's point: yes, these changes really do need to made
> common since it appears all bio_split() callers do go on to call
> generic_make_request().
> 
> Anyway, here is the updated patch that is now staged in linux-next:
> 
> From: Mike Snitzer <snitzer@redhat.com>
> Date: Fri, 18 Jan 2019 01:21:11 -0500
> Subject: [PATCH v2] dm: fix missing bio_split() pattern code in __split_and_process_bio()
> 
> Use the same BIO_QUEUE_ENTERED pattern that was established by commit
> cd4a4ae4683dc ("block: don't use blocking queue entered for recursive
> bio submits") by setting BIO_QUEUE_ENTERED after bio_split() and before
> recursing via generic_make_request().
> 
> Also add trace_block_split() because it provides useful context about
> bio splits in blktrace.
> 
> Depends-on: cd4a4ae4683dc ("block: don't use blocking queue entered for recursive bio submits")
> Fixes: 18a25da84354 ("dm: ensure bio submission follows a depth-first tree walk")
> Cc: stable@vger.kernel.org # 4.16+
> Signed-off-by: Mike Snitzer <snitzer@redhat.com>
> ---
>  drivers/md/dm.c | 9 +++++++++
>  1 file changed, 9 insertions(+)
> 
> diff --git a/drivers/md/dm.c b/drivers/md/dm.c
> index fbadda68e23b..25884f833a32 100644
> --- a/drivers/md/dm.c
> +++ b/drivers/md/dm.c
> @@ -1654,7 +1654,9 @@ static blk_qc_t __split_and_process_bio(struct mapped_device *md,
>  						   sectors[op_stat_group(bio_op(bio))], ci.sector_count);
>  				part_stat_unlock();
>  
> +				bio_set_flag(bio, BIO_QUEUE_ENTERED);
>  				bio_chain(b, bio);
> +				trace_block_split(md->queue, b, bio->bi_iter.bi_sector);
>  				ret = generic_make_request(bio);
>  				break;
>  			}
> @@ -1734,6 +1736,13 @@ static blk_qc_t dm_make_request(struct request_queue *q, struct bio *bio)
>  
>  	map = dm_get_live_table(md, &srcu_idx);
>  
> +	/*
> +	 * Clear the bio-reentered-generic_make_request() flag,
> +	 * will be set again as needed if bio needs to be split.
> +	 */
> +	if (bio_flagged(bio, BIO_QUEUE_ENTERED))
> +		bio_clear_flag(bio, BIO_QUEUE_ENTERED);
> +
>  	/* if we're suspended, we have to queue this io for later */
>  	if (unlikely(test_bit(DMF_BLOCK_IO_FOR_SUSPEND, &md->flags))) {
>  		dm_put_live_table(md, srcu_idx);
> -- 
> 2.15.0
> 

Hi Mike,

I'd suggest to fix this kind issue in the following way, then we
can avoid to touch this flag from drivers:

diff --git a/block/blk-core.c b/block/blk-core.c
index 3c5f61ceeb67..e70103560ac2 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -1024,6 +1024,8 @@ blk_qc_t generic_make_request(struct bio *bio)
 		else
 			bio_io_error(bio);
 		return ret;
+	} else {
+		bio_set_flag(bio, BIO_QUEUE_ENTERED);
 	}
 
 	if (!generic_make_request_checks(bio))
@@ -1074,6 +1076,8 @@ blk_qc_t generic_make_request(struct bio *bio)
 			if (blk_queue_enter(q, flags) < 0) {
 				enter_succeeded = false;
 				q = NULL;
+			} else {
+				bio_set_flag(bio, BIO_QUEUE_ENTERED);
 			}
 		}
 
diff --git a/block/blk-merge.c b/block/blk-merge.c
index b990853f6de7..8777e286bd3f 100644
--- a/block/blk-merge.c
+++ b/block/blk-merge.c
@@ -339,16 +339,6 @@ void blk_queue_split(struct request_queue *q, struct bio **bio)
 		/* there isn't chance to merge the splitted bio */
 		split->bi_opf |= REQ_NOMERGE;
 
-		/*
-		 * Since we're recursing into make_request here, ensure
-		 * that we mark this bio as already having entered the queue.
-		 * If not, and the queue is going away, we can get stuck
-		 * forever on waiting for the queue reference to drop. But
-		 * that will never happen, as we're already holding a
-		 * reference to it.
-		 */
-		bio_set_flag(*bio, BIO_QUEUE_ENTERED);
-
 		bio_chain(split, *bio);
 		trace_block_split(q, split, (*bio)->bi_iter.bi_sector);
 		generic_make_request(*bio);

Thanks,
Ming

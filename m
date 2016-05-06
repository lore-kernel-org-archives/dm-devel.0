From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 2/5] block: make bio_inc_remaining()
	interface	accessible again
Date: Fri, 6 May 2016 17:56:33 +0200
Message-ID: <20160506155633.GA7318@lst.de>
References: <1462463665-85312-1-git-send-email-snitzer@redhat.com>
	<1462463665-85312-3-git-send-email-snitzer@redhat.com>
	<20160506152535.GA6738@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20160506152535.GA6738@lst.de>
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
Cc: Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org, dm-devel@redhat.com, Christoph Hellwig <hch@lst.de>
List-Id: dm-devel.ids

On Fri, May 06, 2016 at 05:25:35PM +0200, Christoph Hellwig wrote:
> Can you explain that code flow to me?  I still fail to why exactly
> dm-thinp (and only dm-thinp) needs this.  Maybe start by pointing me
> to the additional bio_endio that pairs with the bio_inc_remaining
> call.
> 
> > All said, bio_inc_remaining() should really only be used in conjunction
> > with bio_chain().  It isn't intended for generic bio reference counting.
> 
> It's obviously used outside bio_chain in dm-thinp, so this sentence
> doesn't make too much sense to me.

FYI, this untested patch should fix the abuse in dm-think.  Not abusing
bio_inc_remaining actually makes the code a lot simpler and more obvious.
I'm not a 100% sure, but it seems the current pattern can also lead
to a leak of the bi_remaining references when set_pool_mode managed
to set a new process_prepared_discard function pointer after the
references have been grabbed already.

Jens, I noticed you've already applied this patch - I'd really prefer
to see it reverted as using bio_inc_remaining outside bio_chain leads
to this sort of convoluted code.

---
diff --git a/drivers/md/dm-thin.c b/drivers/md/dm-thin.c
index e4bb9da..5875749 100644
--- a/drivers/md/dm-thin.c
+++ b/drivers/md/dm-thin.c
@@ -382,7 +382,6 @@ static void end_discard(struct discard_op *op, int r)
 	 */
 	if (r && !op->parent_bio->bi_error)
 		op->parent_bio->bi_error = r;
-	bio_endio(op->parent_bio);
 }
 
 /*----------------------------------------------------------------*/
@@ -1056,11 +1055,9 @@ static void process_prepared_discard_passdown(struct dm_thin_new_mapping *m)
 	r = dm_thin_remove_range(tc->td, m->virt_begin, m->virt_end);
 	if (r) {
 		metadata_operation_failed(pool, "dm_thin_remove_range", r);
-		bio_io_error(m->bio);
-
+		m->bio->bi_error = -EIO;
 	} else if (m->maybe_shared) {
 		passdown_double_checking_shared_status(m);
-
 	} else {
 		struct discard_op op;
 		begin_discard(&op, tc, m->bio);
@@ -1069,6 +1066,7 @@ static void process_prepared_discard_passdown(struct dm_thin_new_mapping *m)
 		end_discard(&op, r);
 	}
 
+	bio_endio(m->bio);
 	cell_defer_no_holder(tc, m->cell);
 	mempool_free(m, pool->mapping_pool);
 }
@@ -1537,15 +1535,6 @@ static void break_up_discard_bio(struct thin_c *tc, dm_block_t begin, dm_block_t
 		m->cell = data_cell;
 		m->bio = bio;
 
-		/*
-		 * The parent bio must not complete before sub discard bios are
-		 * chained to it (see end_discard's bio_chain)!
-		 *
-		 * This per-mapping bi_remaining increment is paired with
-		 * the implicit decrement that occurs via bio_endio() in
-		 * end_discard().
-		 */
-		bio_inc_remaining(bio);
 		if (!dm_deferred_set_add_work(pool->all_io_ds, &m->list))
 			pool->process_prepared_discard(m);
 
@@ -1565,13 +1554,6 @@ static void process_discard_cell_passdown(struct thin_c *tc, struct dm_bio_priso
 	 */
 	h->cell = virt_cell;
 	break_up_discard_bio(tc, virt_cell->key.block_begin, virt_cell->key.block_end, bio);
-
-	/*
-	 * We complete the bio now, knowing that the bi_remaining field
-	 * will prevent completion until the sub range discards have
-	 * completed.
-	 */
-	bio_endio(bio);
 }
 
 static void process_discard_bio(struct thin_c *tc, struct bio *bio)

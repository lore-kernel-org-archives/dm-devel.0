From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 5/5] dm thin: unroll issue_discard() to
	create longer	discard bio chains
Date: Fri, 6 May 2016 18:12:16 +0200
Message-ID: <20160506161216.GC7397@lst.de>
References: <1462463665-85312-1-git-send-email-snitzer@redhat.com>
	<1462463665-85312-6-git-send-email-snitzer@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <1462463665-85312-6-git-send-email-snitzer@redhat.com>
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
Cc: Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org, dm-devel@redhat.com, Christoph Hellwig <hch@lst.de>, Joe Thornber <ejt@redhat.com>
List-Id: dm-devel.ids

On Thu, May 05, 2016 at 11:54:25AM -0400, Mike Snitzer wrote:
> From: Joe Thornber <ejt@redhat.com>
> 
> There is little benefit to doing this but it does structure DM thinp's
> code to more cleanly use the __blkdev_issue_discard() interface --
> particularly in passdown_double_checking_shared_status().

As-is I think it makes the code a whole lot more convoluted, and especially
the structure that's just used to communicated 4 parameters between
functions which don't even use all of them isn't very helpful.

If we can get rid of begin_discard/end_discard and struct discard_op I
think the rest of the changes would still be useful, though.

> +static int issue_discard(struct discard_op *op, dm_block_t data_b, dm_block_t data_e)
>  {
> +	struct thin_c *tc = op->tc;
>  	sector_t s = block_to_sectors(tc->pool, data_b);
>  	sector_t len = block_to_sectors(tc->pool, data_e - data_b);
> +	return __blkdev_issue_discard(tc->pool_dev->bdev, s, len,
> +				      GFP_NOWAIT, REQ_WRITE | REQ_DISCARD, &op->bio);
> +}

This is a useful helper I think, but passing tc and bio directly would
make it even more obvious.

> +static void end_discard(struct discard_op *op, int r)
> +{
> +	if (op->bio) {
> +		/*
> +		 * Even if one of the calls to issue_discard failed, we
> +		 * need to wait for the chain to complete.
> +		 */
> +		bio_chain(op->bio, op->parent_bio);
> +		submit_bio(REQ_WRITE | REQ_DISCARD, op->bio);

This comment is a bit confusing as there is nothing that appears to wait
on any of the bios involved.  Also if we ever were to get an error
return from issue_discard when op->bio is not set it would do the wrong
thing, although with the current interface that can't actually happen.

> +	blk_finish_plug(&op->plug);
> +
> +	/*
> +	 * Even if r is set, there could be sub discards in flight that we
> +	 * need to wait for.
> +	 */
> +	if (r && !op->parent_bio->bi_error)
> +		op->parent_bio->bi_error = r;

Both the plugging and the bi_error handling would benefit from being
moved into process_prepared_discard_passdown and handled in the common
path.

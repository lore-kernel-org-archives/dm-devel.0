From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: dm thin: do not queue freed thin mapping for next
 stage processing
Date: Mon, 26 Jun 2017 15:06:38 -0400
Message-ID: <20170626190638.GA375@redhat.com>
References: <1498243986-89156-1-git-send-email-vallish@amazon.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <1498243986-89156-1-git-send-email-vallish@amazon.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Vallish Vaidyeshwara <vallish@amazon.com>
Cc: eduval@amazon.com, ejt@redhat.com, gafton@amazon.com, dm-devel@redhat.com, anchalag@amazon.com, agk@redhat.com
List-Id: dm-devel.ids

On Fri, Jun 23 2017 at  2:53pm -0400,
Vallish Vaidyeshwara <vallish@amazon.com> wrote:

> process_prepared_discard_passdown_pt1() should cleanup
> dm_thin_new_mapping in cases of error.
> 
> dm_pool_inc_data_range() can fail trying to get a block reference:
> 
> metadata operation 'dm_pool_inc_data_range' failed: error = -61
> 
> When dm_pool_inc_data_range() fails, dm thin aborts current metadata
> transaction and marks pool as PM_READ_ONLY. Memory for thin mapping
> is released as well. However, current thin mapping will be queued
> onto next stage as part of queue_passdown_pt2() or passdown_endio().
> This dangling thin mapping memory when processed and accessed in
> next stage will lead to device mapper crashing.
> 
> Code flow without fix:
> -> process_prepared_discard_passdown_pt1(m)
>    -> dm_thin_remove_range()
>    -> discard passdown
>       --> passdown_endio(m) queues m onto next stage
>    -> dm_pool_inc_data_range() fails, frees memory m
>             but does not remove it from next stage queue
> 
> -> process_prepared_discard_passdown_pt2(m)
>    -> processes freed memory m and crashes
> 
> One such stack:
> 
> Call Trace:
> [<ffffffffa037a46f>] dm_cell_release_no_holder+0x2f/0x70 [dm_bio_prison]
> [<ffffffffa039b6dc>] cell_defer_no_holder+0x3c/0x80 [dm_thin_pool]
> [<ffffffffa039b88b>] process_prepared_discard_passdown_pt2+0x4b/0x90 [dm_thin_pool]
> [<ffffffffa0399611>] process_prepared+0x81/0xa0 [dm_thin_pool]
> [<ffffffffa039e735>] do_worker+0xc5/0x820 [dm_thin_pool]
> [<ffffffff8152bf54>] ? __schedule+0x244/0x680
> [<ffffffff81087e72>] ? pwq_activate_delayed_work+0x42/0xb0
> [<ffffffff81089f53>] process_one_work+0x153/0x3f0
> [<ffffffff8108a71b>] worker_thread+0x12b/0x4b0
> [<ffffffff8108a5f0>] ? rescuer_thread+0x350/0x350
> [<ffffffff8108fd6a>] kthread+0xca/0xe0
> [<ffffffff8108fca0>] ? kthread_park+0x60/0x60
> [<ffffffff81530b45>] ret_from_fork+0x25/0x30
> 
> The fix is to first take the block ref count for discarded block and
> then do a passdown discard of this block. If block ref count fails,
> then bail out aborting current metadata transaction, mark pool as
> PM_READ_ONLY and also free current thin mapping memory (existing error
> handling code) without queueing this thin mapping onto next stage of
> processing. If block ref count succeeds, then passdown discard of this
> block. Discard callback of passdown_endio() will queue this thin mapping
> onto next stage of processing.
> 
> Code flow with fix:
> -> process_prepared_discard_passdown_pt1(m)
>    -> dm_thin_remove_range()
>    -> dm_pool_inc_data_range()
>       --> if fails, free memory m and bail out
>    -> discard passdown
>       --> passdown_endio(m) queues m onto next stage
> 
> Cc: stable <stable@vger.kernel.org> # v4.9+
> Reviewed-by: Eduardo Valentin <eduval@amazon.com>
> Reviewed-by: Cristian Gafton <gafton@amazon.com>
> Reviewed-by: Anchal Agarwal <anchalag@amazon.com>
> Signed-off-by: Vallish Vaidyeshwara <vallish@amazon.com>
> ---
>  drivers/md/dm-thin.c | 26 +++++++++++++-------------
>  1 file changed, 13 insertions(+), 13 deletions(-)
> 
> diff --git a/drivers/md/dm-thin.c b/drivers/md/dm-thin.c
> index 17ad50d..28808e5 100644
> --- a/drivers/md/dm-thin.c
> +++ b/drivers/md/dm-thin.c
> @@ -1094,6 +1094,19 @@ static void process_prepared_discard_passdown_pt1(struct dm_thin_new_mapping *m)
>  		return;
>  	}
>  
> +	/*
> +	 * Increment the unmapped blocks.  This prevents a race between the
> +	 * passdown io and reallocation of freed blocks.
> +	 */
> +	r = dm_pool_inc_data_range(pool->pmd, m->data_block, data_end);
> +	if (r) {
> +		metadata_operation_failed(pool, "dm_pool_inc_data_range", r);
> +		bio_io_error(m->bio);
> +		cell_defer_no_holder(tc, m->cell);
> +		mempool_free(m, pool->mapping_pool);
> +		return;
> +	}
> +
>  	discard_parent = bio_alloc(GFP_NOIO, 1);
>  	if (!discard_parent) {
>  		DMWARN("%s: unable to allocate top level discard bio for passdown. Skipping passdown.",
> @@ -1114,19 +1127,6 @@ static void process_prepared_discard_passdown_pt1(struct dm_thin_new_mapping *m)
>  			end_discard(&op, r);
>  		}
>  	}
> -
> -	/*
> -	 * Increment the unmapped blocks.  This prevents a race between the
> -	 * passdown io and reallocation of freed blocks.
> -	 */
> -	r = dm_pool_inc_data_range(pool->pmd, m->data_block, data_end);
> -	if (r) {
> -		metadata_operation_failed(pool, "dm_pool_inc_data_range", r);
> -		bio_io_error(m->bio);
> -		cell_defer_no_holder(tc, m->cell);
> -		mempool_free(m, pool->mapping_pool);
> -		return;
> -	}
>  }
>  
>  static void process_prepared_discard_passdown_pt2(struct dm_thin_new_mapping *m)

This looks like a good fix.

But I'll wait for Joe's confirmation before staging for 4.12 final
inclusion later this week.

Thanks,
Mike

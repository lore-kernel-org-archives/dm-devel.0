From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [PATCH 1/3] block: Add blk_queue_copy_limits()
Date: Fri, 18 Sep 2009 15:07:20 -0400
Message-ID: <20090918190720.GA30063@redhat.com>
References: <4AB3B43D.9000802@ce.jp.nec.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <4AB3B43D.9000802@ce.jp.nec.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Jun'ichi Nomura <j-nomura@ce.jp.nec.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, linux-kernel@vger.kernel.org, device-mapper development <dm-devel@redhat.com>, Jens Axboe <jens.axboe@oracle.com>, Alasdair G Kergon <agk@redhat.com>
List-Id: dm-devel.ids

On Fri, Sep 18 2009 at 12:24pm -0400,
Jun'ichi Nomura <j-nomura@ce.jp.nec.com> wrote:

> This patch is a preparation for the last patch in this patchset
> which changes blk_set_default_limits() to set 0 to max_sectors.

should read: changes blk_set_default_limits() to set max_sectors to 0.

> dm uses blk_stack_limits() to merge limits of underlying devices
> and copy the end result to the queue.
> But if there's no underlying device (like 'zero' target),
> max_sectors/max_hw_sectors are left unchanged from the default 0
> and just copying it to the queue causes problems.
> 
> Provide blk_queue_copy_limits() to get a safe copy with
> invalid values fixed-up.
> 
> Signed-off-by: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
> Signed-off-by: Jun'ichi Nomura <j-nomura@ce.jp.nec.com>
> Cc: David Strand <dpstrand@gmail.com>
> Cc: Mike Snitzer <snitzer@redhat.com>
> Cc: Alasdair G Kergon <agk@redhat.com>
> Cc: Martin K. Petersen <martin.petersen@oracle.com>
> Cc: Jens Axboe <jens.axboe@oracle.com>
> ---
>  block/blk-settings.c   |   28 ++++++++++++++++++++++++++++
>  include/linux/blkdev.h |    1 +
>  2 files changed, 29 insertions(+)
> 
> Index: linux-2.6.31.work/block/blk-settings.c
> ===================================================================
> --- linux-2.6.31.work.orig/block/blk-settings.c
> +++ linux-2.6.31.work/block/blk-settings.c
> @@ -122,6 +122,34 @@ void blk_set_default_limits(struct queue
>  EXPORT_SYMBOL(blk_set_default_limits);
> 
>  /**
> + * blk_queue_copy_limits - copy limits to queue
> + * @q:  the request queue whose limits as a copy destination
> + * @lim:  the queue_limits structure as a copy source
> + *
> + * Description:
> + *   Copies a queue_limit struct contents to @q with fix-ups to
> + *   invalid values.
> + */
> +void blk_queue_copy_limits(struct request_queue *q, struct queue_limits
> *lim)
> +{
> +	q->limits = *lim;
> +
> +	/*
> +	 * blk_set_default_limits() sets 0 to max_sectors/max_hw_sectors
> +	 * so that blk_stack_limits() appropriately propagate the values
> +	 * of lower-stack by min_not_zero().
> +	 * However, if the default value 0 is unchanged (e.g. the stacking
> +	 * device is virtual and has no underlying device), it results
> +	 * in unusable device.

Likewise:
blk_set_default_limits() sets max_sectors/max_hw_sectors to 0?

> +	 * Check if max_sectors/max_hw_sectors have non-zero values,
> +	 * and set SAFE_MAX_SECTORS if they do.
> +	 */
> +	if (q->limits.max_sectors == 0 || q->limits.max_hw_sectors == 0)
> +		blk_queue_max_sectors(q, SAFE_MAX_SECTORS);

Shouldn't this check (and the entire comment above it) get added in the
3rd patch once max_sectors/max_hw_sectors sre actually set to 0?  I'm
being really pedantic here but...

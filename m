From: Ming Lei <ming.lei@redhat.com>
Subject: Re: [PATCH 2/3] block: use lcm_not_zero() when stacking
	chunk_sectors
Date: Sat, 12 Sep 2020 21:58:22 +0800
Message-ID: <20200912135822.GB210077@T590>
References: <20200911215338.44805-1-snitzer@redhat.com>
	<20200911215338.44805-3-snitzer@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20200911215338.44805-3-snitzer@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
Content-Disposition: inline
To: Mike Snitzer <snitzer@redhat.com>
Cc: linux-block@vger.kernel.org, dm-devel@redhat.com, Vijayendra Suman <vijayendra.suman@oracle.com>
List-Id: dm-devel.ids

On Fri, Sep 11, 2020 at 05:53:37PM -0400, Mike Snitzer wrote:
> Like 'io_opt', blk_stack_limits() should stack 'chunk_sectors' using
> lcm_not_zero() rather than min_not_zero() -- otherwise the final
> 'chunk_sectors' could result in sub-optimal alignment of IO to
> component devices in the IO stack.
> 
> Also, if 'chunk_sectors' isn't a multiple of 'physical_block_size'
> then it is a bug in the driver and the device should be flagged as
> 'misaligned'.
> 
> Signed-off-by: Mike Snitzer <snitzer@redhat.com>
> ---
>  block/blk-settings.c | 12 ++++++++----
>  1 file changed, 8 insertions(+), 4 deletions(-)
> 
> diff --git a/block/blk-settings.c b/block/blk-settings.c
> index 76a7e03bcd6c..b09642d5f15e 100644
> --- a/block/blk-settings.c
> +++ b/block/blk-settings.c
> @@ -534,6 +534,7 @@ int blk_stack_limits(struct queue_limits *t, struct queue_limits *b,
>  
>  	t->io_min = max(t->io_min, b->io_min);
>  	t->io_opt = lcm_not_zero(t->io_opt, b->io_opt);
> +	t->chunk_sectors = lcm_not_zero(t->chunk_sectors, b->chunk_sectors);
>  
>  	/* Physical block size a multiple of the logical block size? */
>  	if (t->physical_block_size & (t->logical_block_size - 1)) {
> @@ -556,6 +557,13 @@ int blk_stack_limits(struct queue_limits *t, struct queue_limits *b,
>  		ret = -1;
>  	}
>  
> +	/* chunk_sectors a multiple of the physical block size? */
> +	if (t->chunk_sectors & (t->physical_block_size - 1)) {
> +		t->chunk_sectors = 0;
> +		t->misaligned = 1;
> +		ret = -1;
> +	}
> +
>  	t->raid_partial_stripes_expensive =
>  		max(t->raid_partial_stripes_expensive,
>  		    b->raid_partial_stripes_expensive);
> @@ -594,10 +602,6 @@ int blk_stack_limits(struct queue_limits *t, struct queue_limits *b,
>  			t->discard_granularity;
>  	}
>  
> -	if (b->chunk_sectors)
> -		t->chunk_sectors = min_not_zero(t->chunk_sectors,
> -						b->chunk_sectors);
> -
>  	t->zoned = max(t->zoned, b->zoned);
>  	return ret;
>  }

Looks fine:

Reviewed-by: Ming Lei <ming.lei@redhat.com>


Thanks,
Ming

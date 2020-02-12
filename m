From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH v6 6/6] loop: Add support for REQ_ALLOCATE
Date: Wed, 12 Feb 2020 09:01:56 -0800
Message-ID: <20200212170156.GM6874@magnolia>
References: <158132703141.239613.3550455492676290009.stgit@localhost.localdomain>
 <158132724397.239613.16927024926439560344.stgit@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-block-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <158132724397.239613.16927024926439560344.stgit@localhost.localdomain>
Sender: linux-block-owner@vger.kernel.org
To: Kirill Tkhai <ktkhai@virtuozzo.com>
Cc: martin.petersen@oracle.com, bob.liu@oracle.com, axboe@kernel.dk, agk@redhat.com, snitzer@redhat.com, dm-devel@redhat.com, song@kernel.org, tytso@mit.edu, adilger.kernel@dilger.ca, Chaitanya.Kulkarni@wdc.com, ming.lei@redhat.com, osandov@fb.com, jthumshirn@suse.de, minwoo.im.dev@gmail.com, damien.lemoal@wdc.com, andrea.parri@amarulasolutions.com, hare@suse.com, tj@kernel.org, ajay.joshi@wdc.com, sagi@grimberg.me, dsterba@suse.com, bvanassche@acm.org, dhowells@redhat.com, asml.silence@gmail.com, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: dm-devel.ids

On Mon, Feb 10, 2020 at 12:34:04PM +0300, Kirill Tkhai wrote:
> Support for new modifier of REQ_OP_WRITE_ZEROES command.
> This results in allocation extents in backing file instead
> of actual blocks zeroing.
> 
> Signed-off-by: Kirill Tkhai <ktkhai@virtuozzo.com>
> Reviewed-by: Bob Liu <bob.liu@oracle.com>
> ---
>  drivers/block/loop.c |   15 ++++++++++++---
>  1 file changed, 12 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/block/loop.c b/drivers/block/loop.c
> index 739b372a5112..bfe76d9adf09 100644
> --- a/drivers/block/loop.c
> +++ b/drivers/block/loop.c
> @@ -581,6 +581,15 @@ static int lo_rw_aio(struct loop_device *lo, struct loop_cmd *cmd,
>  	return 0;
>  }
>  
> +static unsigned int write_zeroes_to_fallocate_mode(unsigned int flags)
> +{
> +	if (flags & REQ_ALLOCATE)
> +		return 0;
> +	if (flags & REQ_NOUNMAP)
> +		return FALLOC_FL_ZERO_RANGE;
> +	return FALLOC_FL_PUNCH_HOLE;
> +}
> +
>  static int do_req_filebacked(struct loop_device *lo, struct request *rq)
>  {
>  	struct loop_cmd *cmd = blk_mq_rq_to_pdu(rq);
> @@ -604,9 +613,7 @@ static int do_req_filebacked(struct loop_device *lo, struct request *rq)
>  		 * write zeroes the range.  Otherwise, punch them out.
>  		 */

Please update this comment to reflect the new REQ_ALLOCATE mode, and
move it to where you define write_zeroes_to_fallocate_mode().

With that fixed,

Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

>  		return lo_fallocate(lo, rq, pos,
> -			(rq->cmd_flags & REQ_NOUNMAP) ?
> -				FALLOC_FL_ZERO_RANGE :
> -				FALLOC_FL_PUNCH_HOLE);
> +			write_zeroes_to_fallocate_mode(rq->cmd_flags));
>  	case REQ_OP_DISCARD:
>  		return lo_fallocate(lo, rq, pos, FALLOC_FL_PUNCH_HOLE);
>  	case REQ_OP_WRITE:
> @@ -877,6 +884,7 @@ static void loop_config_discard(struct loop_device *lo)
>  		q->limits.discard_alignment = 0;
>  		blk_queue_max_discard_sectors(q, 0);
>  		blk_queue_max_write_zeroes_sectors(q, 0);
> +		blk_queue_max_allocate_sectors(q, 0);
>  		blk_queue_flag_clear(QUEUE_FLAG_DISCARD, q);
>  		return;
>  	}
> @@ -886,6 +894,7 @@ static void loop_config_discard(struct loop_device *lo)
>  
>  	blk_queue_max_discard_sectors(q, UINT_MAX >> 9);
>  	blk_queue_max_write_zeroes_sectors(q, UINT_MAX >> 9);
> +	blk_queue_max_allocate_sectors(q, UINT_MAX >> 9);
>  	blk_queue_flag_set(QUEUE_FLAG_DISCARD, q);
>  }
>  
> 
> 

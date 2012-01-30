From: Namhyung Kim <namhyung@gmail.com>
Subject: Re: [PATCH] block: add missing block_bio_complete() tracepoint
Date: Mon, 30 Jan 2012 15:38:57 +0900
Message-ID: <4F263B01.4050103@gmail.com>
References: <1327830093-12130-1-git-send-email-namhyung@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1327830093-12130-1-git-send-email-namhyung@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>, linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>, Steven Rostedt <rostedt@goodmis.org>, dm-devel@redhat.com
List-Id: dm-devel.ids

2012-01-29 6:41 PM, Namhyung Kim wrote:
> The block_bio_complete() TP has been missed so long, so that bio-based
> drivers haven't been able to trace its IO behavior. Add it.
>
> In some rare cases, such as loop_switch, @bio->bi_bdev can be NULL.
> Thus convert it to TRACE_EVENT_CONDITION() as Steven suggested.
>

Now I see that it seems TRACE_EVENT_CONDITION() can protect event 
tracing from such condition, but what about other users of the TP like 
blktrace? I think it'll still get NULL pointer dereference on 
bdev_get_queue() after the change, right? If so, convert to T_E_C() 
looks meaningless IMHO. Do I miss something?

Thanks,
Namhyung


>  From now on, request-based drivers will also get BLK_TA_COMPLETEs for
> all bio's in requests. This needs to be handled in userland properly.
>
> Also remove external use of the TP in DM and unexport it.
>
> Signed-off-by: Namhyung Kim <namhyung@gmail.com>
> Cc: Tejun Heo <tj@kernel.org>
> Cc: Steven Rostedt <rostedt@goodmis.org>
> Cc: dm-devel@redhat.com
> ---
> * v2:
>   - Merge previous patches into one as suggested by Tejun.
>   - Drop BIO_COMPLETE_MASK. Now I think it should be handled in userland
>     like other (maybe duplicated, in some sense) bio complete reports.
>
>   block/blk-core.c             |    1 -
>   drivers/md/dm.c              |    1 -
>   fs/bio.c                     |    2 ++
>   include/trace/events/block.h |    4 +++-
>   4 files changed, 5 insertions(+), 3 deletions(-)
>
> diff --git a/block/blk-core.c b/block/blk-core.c
> index 1b4fd93af2c0..399c128f516c 100644
> --- a/block/blk-core.c
> +++ b/block/blk-core.c
> @@ -37,7 +37,6 @@
>
>   EXPORT_TRACEPOINT_SYMBOL_GPL(block_bio_remap);
>   EXPORT_TRACEPOINT_SYMBOL_GPL(block_rq_remap);
> -EXPORT_TRACEPOINT_SYMBOL_GPL(block_bio_complete);
>
>   DEFINE_IDA(blk_queue_ida);
>
> diff --git a/drivers/md/dm.c b/drivers/md/dm.c
> index 4720f68f817e..01185fa0eb74 100644
> --- a/drivers/md/dm.c
> +++ b/drivers/md/dm.c
> @@ -648,7 +648,6 @@ static void dec_pending(struct dm_io *io, int error)
>   			queue_io(md, bio);
>   		} else {
>   			/* done with normal IO or empty flush */
> -			trace_block_bio_complete(md->queue, bio, io_error);
>   			bio_endio(bio, io_error);
>   		}
>   	}
> diff --git a/fs/bio.c b/fs/bio.c
> index b1fe82cf88cf..14c03eaf384e 100644
> --- a/fs/bio.c
> +++ b/fs/bio.c
> @@ -1447,6 +1447,8 @@ void bio_endio(struct bio *bio, int error)
>   	else if (!test_bit(BIO_UPTODATE,&bio->bi_flags))
>   		error = -EIO;
>
> +	trace_block_bio_complete(bdev_get_queue(bio->bi_bdev), bio, error);
> +
>   	if (bio->bi_end_io)
>   		bio->bi_end_io(bio, error);
>   }
> diff --git a/include/trace/events/block.h b/include/trace/events/block.h
> index 05c5e61f0a7c..96955f4828b3 100644
> --- a/include/trace/events/block.h
> +++ b/include/trace/events/block.h
> @@ -213,12 +213,14 @@ TRACE_EVENT(block_bio_bounce,
>    * This tracepoint indicates there is no further work to do on this
>    * block IO operation @bio.
>    */
> -TRACE_EVENT(block_bio_complete,
> +TRACE_EVENT_CONDITION(block_bio_complete,
>
>   	TP_PROTO(struct request_queue *q, struct bio *bio, int error),
>
>   	TP_ARGS(q, bio, error),
>
> +	TP_CONDITION(bio->bi_bdev != NULL),
> +
>   	TP_STRUCT__entry(
>   		__field( dev_t,		dev		)
>   		__field( sector_t,	sector		)

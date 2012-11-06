From: "Jun'ichi Nomura" <j-nomura@ce.jp.nec.com>
Subject: Re: [PATCH] Fix deadlock with request based dm and some
	drivers
Date: Tue, 06 Nov 2012 21:14:30 +0900
Message-ID: <5098FF26.4070907@ce.jp.nec.com>
References: <5098F47F.9030201@fusionio.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <5098F47F.9030201@fusionio.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Jens Axboe <jaxboe@fusionio.com>, Alasdair Kergon <agk@redhat.com>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

(Cc to dm-devel)

On 11/06/12 20:29, Jens Axboe wrote:
> I recently fixed a deadlock for a customer we have with
> the below patch. I have queued it up in my tree as not
> to lose it. Can I have an ack from you, or do you want
> to submit it yourself? I've marked it stable as well.

Could you tell details about how the deadlock happened?

dm's end_io always throws the completion handling to softirq:
  end_clone_request()
    dm_complete_request()
      blk_complete_request()

then it is processed in softirq context:
  dm_softirq_done()
    dm_done()
      dm_end_request()
        rq_completed(run_queue=true)
          blk_run_queue()

Since queue_lock is always held with interrupt disabled,
I couldn't see why it could deadlock.

Request-based dm followed the completion model of scsi
mid layer. So similar code path exists in scsi, too.
For example:
  scsi_request_fn()
    scsi_kill_request()
      blk_complete_request()
then:
  scsi_softirq_done()
    scsi_io_completion()
      scsi_next_command()
        scsi_run_queue()
          spin_lock queue_lock
          __blk_run_queue()

If calling run-queue from softirq_done_fn() can cause deadlock,
I'm afraid the problem is not limited to dm.

> From 8ca211056519ac06bc96fb134dca1f8eb2141407 Mon Sep 17 00:00:00 2001
> From: Jens Axboe <axboe@kernel.dk>
> Date: Tue, 6 Nov 2012 12:24:26 +0100
> Subject: [PATCH] dm: fix deadlock with request based dm and queue request_fn
>  recursion
> 
> Request based dm attempts to re-run the request queue off the
> request completion path. If used with a driver that potentially does
> end_io from its request_fn, we could deadlock trying to recurse
> back into request dispatch. Fix this by punting the request queue
> run to kblockd.
> 
> Tested to fix a quickly reproducible deadlock in such a scenario.
> 
> Cc: stable@kernel.org
> Signed-off-by: Jens Axboe <axboe@kernel.dk>
> ---
>  drivers/md/dm.c | 8 +++++++-
>  1 file changed, 7 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/md/dm.c b/drivers/md/dm.c
> index 02db918..77e6eff 100644
> --- a/drivers/md/dm.c
> +++ b/drivers/md/dm.c
> @@ -740,8 +740,14 @@ static void rq_completed(struct mapped_device *md, int rw, int run_queue)
>  	if (!md_in_flight(md))
>  		wake_up(&md->wait);
>  
> +	/*
> +	 * Run this off this callpath, as drivers could invoke end_io while
> +	 * inside their request_fn (and holding the queue lock). Calling
> +	 * back into ->request_fn() could deadlock attempting to grab the
> +	 * queue lock again.
> +	 */
>  	if (run_queue)
> -		blk_run_queue(md->queue);
> +		blk_run_queue_async(md->queue);
>  
>  	/*
>  	 * dm_put() must be at the end of this function. See the comment above


-- 
Jun'ichi Nomura, NEC Corporation

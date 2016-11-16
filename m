From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [PATCH 1/7] dm: Fix a (theoretical?) race condition
 in rq_completed()
Date: Tue, 15 Nov 2016 19:46:01 -0500
Message-ID: <20161116004601.GC19059@redhat.com>
References: <e83f8718-9e73-5544-3bcc-4d9851b90ba1@sandisk.com>
	<8357d3a6-f1bc-3631-6ca4-fc78253640f7@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <8357d3a6-f1bc-3631-6ca4-fc78253640f7@sandisk.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Bart Van Assche <bart.vanassche@sandisk.com>
Cc: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

On Tue, Nov 15 2016 at  6:32pm -0500,
Bart Van Assche <bart.vanassche@sandisk.com> wrote:

> It is required to hold the queue lock when calling blk_run_queue_async()
> to avoid that a race between blk_run_queue_async() and
> blk_cleanup_queue() is triggered.
> 
> Signed-off-by: Bart Van Assche <bart.vanassche@sandisk.com>

I picked this patch up earlier today, see:
https://git.kernel.org/cgit/linux/kernel/git/device-mapper/linux-dm.git/commit/?h=dm-4.10&id=d15bb3a6467e102e60d954aadda5fb19ce6fd8ec

But you your "(theoretical?)", I'd really expected you to have realized
an actual the need for this change...

Mike

> ---
>  drivers/md/dm-rq.c | 10 ++++++++--
>  1 file changed, 8 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/md/dm-rq.c b/drivers/md/dm-rq.c
> index f9f37ad..7df7948 100644
> --- a/drivers/md/dm-rq.c
> +++ b/drivers/md/dm-rq.c
> @@ -210,6 +210,9 @@ static void rq_end_stats(struct mapped_device *md, struct request *orig)
>   */
>  static void rq_completed(struct mapped_device *md, int rw, bool run_queue)
>  {
> +	struct request_queue *q = md->queue;
> +	unsigned long flags;
> +
>  	atomic_dec(&md->pending[rw]);
>  
>  	/* nudge anyone waiting on suspend queue */
> @@ -222,8 +225,11 @@ static void rq_completed(struct mapped_device *md, int rw, bool run_queue)
>  	 * back into ->request_fn() could deadlock attempting to grab the
>  	 * queue lock again.
>  	 */
> -	if (!md->queue->mq_ops && run_queue)
> -		blk_run_queue_async(md->queue);
> +	if (!q->mq_ops && run_queue) {
> +		spin_lock_irqsave(q->queue_lock, flags);
> +		blk_run_queue_async(q);
> +		spin_unlock_irqrestore(q->queue_lock, flags);
> +	}
>  
>  	/*
>  	 * dm_put() must be at the end of this function. See the comment above
> -- 
> 2.10.1
> 
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel

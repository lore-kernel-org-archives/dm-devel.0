From: Ming Lei <ming.lei@redhat.com>
Subject: Re: [PATCH] dm-mpath: Improve handling of busy paths
Date: Thu, 21 Sep 2017 06:36:06 +0800
Message-ID: <20170920223605.GC5105@ming.t460p>
References: <20170920181212.5532-1-bart.vanassche@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20170920181212.5532-1-bart.vanassche@wdc.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Bart Van Assche <bart.vanassche@wdc.com>
Cc: Jens Axboe <axboe@kernel.dk>, dm-devel@redhat.com, Christoph Hellwig <hch@lst.de>, Mike Snitzer <snitzer@redhat.com>, Hannes Reinecke <hare@suse.com>
List-Id: dm-devel.ids

On Wed, Sep 20, 2017 at 11:12:12AM -0700, Bart Van Assche wrote:
> Instead of retrying request allocation after a delay if a path is
> busy, wait until the underlying path has completed a request. This
> patch avoids that submission of requests to busy paths is delayed and
> hence creates more opportunities for merging sequential I/O requests.

Could you provide some test data with this change?

> 
> Reported-by: Ming Lei <ming.lei@redhat.com>
> Signed-off-by: Bart Van Assche <bart.vanassche@wdc.com>
> Cc: Christoph Hellwig <hch@lst.de>
> Cc: Hannes Reinecke <hare@suse.com>
> Cc: Jens Axboe <axboe@kernel.dk>
> Cc: Ming Lei <ming.lei@redhat.com>
> ---
>  drivers/md/dm-mpath.c | 10 +++++++++-
>  drivers/md/dm-rq.c    |  3 ++-
>  2 files changed, 11 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/md/dm-mpath.c b/drivers/md/dm-mpath.c
> index 11f273d2f018..b60ef655fa0c 100644
> --- a/drivers/md/dm-mpath.c
> +++ b/drivers/md/dm-mpath.c
> @@ -495,7 +495,13 @@ static int multipath_clone_and_map(struct dm_target *ti, struct request *rq,
>  
>  	bdev = pgpath->path.dev->bdev;
>  	q = bdev_get_queue(bdev);
> -	clone = blk_get_request(q, rq->cmd_flags | REQ_NOMERGE, GFP_ATOMIC);
> +	/*
> +	 * For blk-mq this code is called from inside dm_mq_queue_rq() and
> +	 * sleeping is allowed due to BLK_MQ_F_BLOCKING.  For the legacy block
> +	 * layer this code is called from workqueue context. Hence unlocking
> +	 * and reacquiring the queue lock is not necessary.
> +	 */
> +	clone = blk_get_request(q, rq->cmd_flags | REQ_NOMERGE, GFP_NOIO);

Actually with GFP_ATOMIC, dispatch in dm-rq can't move on and no request
will be dequeued from IO scheduler queue if this allocation fails, that
means IO merge is still working at that time if the patchset of
'blk-mq-sched: improve SCSI-MQ performance' is applied.

As my test done, the sequential I/O performance is still not good
even though the patchset is applied.

That isn't strange because queue depth of IO scheduler queue can be
much bigger than either q->queue_depth or .cmd_per_lun, that means
the underlying queue has been busy for a while before the allocation
fails.

So this approach may not work well in theory.


-- 
Ming
